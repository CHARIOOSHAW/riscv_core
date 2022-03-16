
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/09/17 11:09:20
// Design Name: 
// Module Name: ifu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: ifu is used to extract instrs from instr-mem.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module ifu(

    // ir related interface
    input      [`XLEN-1:0                  ] itcm_ifu_i_ir          , // The extracted data from itcm, 32-bits always. 
    output     [`XLEN-1:0                  ] ifu_o_ir_r             ,

    // PC control for flash    
    input      [`PC_SIZE-1:0               ] pc_ifu_i_pc_nxt        , // The PC from pc controller which has to be handled when misalign.
    output reg [`PC_SIZE-1:0               ] ifu_flash_o_pc         , // PC sent to flash 
 
    // jump and excpirq
    input                                    exu_ifu_pipe_flush_req ,

    // handshake signals
    output reg                               ifu_o_ifu_valid        ,
    input                                    ifu_i_exu_ready        ,

    input                                    clk                    ,
    input                                    rst_n 

    );

    wire [15:0    ] current_ir;
    wire pc_align      = ~(|pc_ifu_i_pc_nxt[1:0])? 1'b1: 1'b0; // The PC stay at the boundry of 32-bit. Align.
    wire ir_length_32  = (~(current_ir[4:2]   == 3'b111)) & (current_ir[1:0] == 2'b11); 
    wire ir_length_16  = (~(current_ir[1:0]   == 2'b11)); 
         
    wire ir_length_a32 = pc_align  & ir_length_32;         // This is an align 32-bit instr.
    wire ir_length_a16 = pc_align  & ir_length_16;         // This is an align 16-bit instr.
    wire ir_length_m32 = ~pc_align & ir_length_32;         // This is an misalign 32-bit instr.
    wire ir_length_m16 = ~pc_align & ir_length_16;         // This is an misalign 16-bit instr.

    // The first bit is used to show the status of align;  1:align 0:misalign
    // The second bit is used to show the length of instr. 1:16 bit 0:32 bit
    wire [1:0] ir_length_encode = ({2{ir_length_a32 &  pc_align}} & 2'b10 )|
                                  ({2{ir_length_m32 & ~pc_align}} & 2'b00 )|
                                  ({2{ir_length_a16 &  pc_align}} & 2'b11 )|
                                  ({2{ir_length_m16 & ~pc_align}} & 2'b01 );


    // -------------------------------------------------------------------------------------------------------------
    // 1. main state controller
    // make an extra cycle when meet jump instrs.
    // make two extra cycles when meet misalign jump to 32-bits instr.
    reg   ir_state_nxt;  
    wire  ir_state;

    // Here is the most difficult logic:
    // 1. pc_nxt is uploaded by pc controller and it will be remained unchange during the jump instr excuting procedure.
    // 2. ifu give internal address to itcm to take instr out with 1-2 cycles which is decided by pc_nxt and ir_state.
    // 3. ir should be ready at the end of 0 or 1 state when meet jump and other flush. 1'b1 indicates 1 extra cycle for 32m instrs.
    always @(*) begin:main_s
        case({exu_ifu_pipe_flush_req, ir_state, ir_length_encode})

            // If there is no flush req, state is always 1'b0.
            // If there is no flush req, state can not be other situation except for 1'b0.
            4'b0_0_00 : ir_state_nxt = 1'b0;
            4'b0_0_01 : ir_state_nxt = 1'b0;
            4'b0_0_10 : ir_state_nxt = 1'b0;
            4'b0_0_11 : ir_state_nxt = 1'b0;

            // If there is flush req:
            4'b1_0_00 : ir_state_nxt = 1'b1;
            4'b1_0_01 : ir_state_nxt = 1'b0;
            4'b1_0_10 : ir_state_nxt = 1'b0;
            4'b1_0_11 : ir_state_nxt = 1'b0;

            // The state 1'b1 should always jump to 1'b0 and tell ram read the PC[31:2] + 32'd4.
            4'b1_1_00 : ir_state_nxt = 1'b0;

            // Other conditions are all illegal.        
            default : ir_state_nxt   = 1'b0;
        endcase
    end

    // The state only changed when ready and valid are both set.
    sirv_gnrl_dfflr #(.DW(1)) ir_state_register (
        .lden ( 1'b1        ),
        .dnxt (ir_state_nxt ),
        .qout (ir_state     ),
        .clk  (clk          ),
        .rst_n(rst_n        )
    );

    
    //------------------------------------------------------------------------------------------------------------------------
    // 2. generate flash addr
    // PC controller is used to control the pc in a two-step instr-reading procedure.
    wire IR_res_state    ;
    always @(*) begin: pc_o_controller
        case({exu_ifu_pipe_flush_req, ir_state, IR_res_state})
            3'b001   : ifu_flash_o_pc = {pc_ifu_i_pc_nxt[`PC_SIZE-1:2], 2'b00} + `PC_SIZE'd4;    // Normally, read next 32 bits when ir_res is avaliable.
            3'b000   : ifu_flash_o_pc = {pc_ifu_i_pc_nxt[`PC_SIZE-1:2], 2'b00};                  // read the current 32 bits when ir_res is unavaliable.

            3'b100   : ifu_flash_o_pc = {pc_ifu_i_pc_nxt[`PC_SIZE-1:2], 2'b00};                  // read the current 32 bits when flush and state is 0.
            3'b101   : ifu_flash_o_pc = {pc_ifu_i_pc_nxt[`PC_SIZE-1:2], 2'b00};                  

            3'b111   : ifu_flash_o_pc = {pc_ifu_i_pc_nxt[`PC_SIZE-1:2], 2'b00} + `PC_SIZE'd4;    // read the next 32 bits when flush and state is 1. Under this situation, ir_res_state can't be 0.
            default    : ifu_flash_o_pc = `PC_SIZE'd0;    
        endcase
    end


    //------------------------------------------------------------------------------------------------------------------------
    // 3. ir_res
    // res will fail when misalign-reading 16bits instr.
    // res will fail when reading any instr(32).
    // Generate IR register
    wire [`IR_RES_LEN-1:0 ] IR_res;
    wire [`XLEN-1:0       ] IR_r  ;
    reg  [`XLEN-1:0       ] IR_nxt;
    reg  [`IR_RES_LEN-1:0 ] IR_res_nxt;

    always @(*) begin: ir_res_reg
        case(ir_length_encode)
            2'b00 : IR_res_nxt =  itcm_ifu_i_ir[31:16];           // 32m, save the unused 16 bits, 00 always intends to read the upper 16 bits.    // ok
            2'b01 : IR_res_nxt =  `IR_RES_LEN'd0      ;           // 16m, empty the res register.                                                  // ok no jump m16
            2'b10 : IR_res_nxt =  `IR_RES_LEN'd0      ;           // 32a, the res register is still empty, the instrs all used.                    // ok no jump a32
            2'b11 : IR_res_nxt =  itcm_ifu_i_ir[31:16];           // 16a, save the unused 16 bits.                                                 // ok
        endcase
    end

    // res register is not controlled by ready and valid.
    sirv_gnrl_dfflr #(.DW(16)) IR_res_register (
        .lden ( 1'b1        ),
        .dnxt (IR_res_nxt   ),
        .qout (IR_res       ),
        .clk  (clk          ),
        .rst_n(rst_n        )
    );

    
    //-----------------------------------------------------------------------------------------------------------------------------------
    // 4. ir_res_state
    // build another dff for ir_res_state register to show its status.
    reg  IR_res_state_nxt;

    always@(*) begin: IR_res_state_reg
        case(ir_length_encode)
            2'b00   : IR_res_state_nxt =  1'b1      ;          // 32m, save the unused 16 bits, 00 always intends to read the upper 16 bits.
            2'b01   : IR_res_state_nxt =  1'b0      ;          // 16m, empty the res register.
            2'b10   : IR_res_state_nxt =  1'b0      ;          // 32a, the res register is still empty, the instrs all used.
            2'b11   : IR_res_state_nxt =  1'b1      ;          // 16a, save the unused 16 bits.
        endcase
    end

    // res_status register is not controlled by ready and valid.
    sirv_gnrl_dfflr #(.DW(1)) IR_res_status_register (
        .lden ( 1'b1              ),
        .dnxt (IR_res_state_nxt   ),
        .qout (IR_res_state       ),
        .clk  (clk                ),
        .rst_n(rst_n              )
    );


    //-----------------------------------------------------------------------------------------------------------
    // 5. ir_reg
    // Generate correct IR
    always@(*) begin:IR_controller

        case({exu_ifu_pipe_flush_req, ir_state, ir_length_encode})                            // ir_length_encode: MSB, 0: misalign 1: align; LSB, 0: 32bit 1:16bit.

            4'b0_0_00 : IR_nxt  =  {itcm_ifu_i_ir[15:0], IR_res             }      ;          // 32m, combine the ir_res register and the itcm_ir.
            4'b0_0_01 : IR_nxt  =  {16'd0              , IR_res             }      ;          // 16m, take out the res register.
            4'b0_0_10 : IR_nxt  =  itcm_ifu_i_ir                                   ;          // 32a, the instrs all used.
            4'b0_0_11 : IR_nxt  =  {16'd0              , itcm_ifu_i_ir[15:0]}      ;          // 16a, save the unused 16 bits.
            
            4'b1_0_00 : IR_nxt  =  32'h0000_0000                                   ;          // This condition is very special. // instr will not changed at this state.
            4'b1_0_01 : IR_nxt  =  {16'd0              , itcm_ifu_i_ir[31:16]}     ;          // take higher 16 bits.
            4'b1_0_10 : IR_nxt  =  itcm_ifu_i_ir                                   ;          // take 32 bits.
            4'b1_0_11 : IR_nxt  =  {16'd0              , itcm_ifu_i_ir[15: 0]}     ;          // take lower 16 bits and save the reserve part.

            // Third, tell ram read the PC[31:2] + 32'd4.
            4'b1_1_00 : IR_nxt  =  {itcm_ifu_i_ir[15:0], IR_res             }      ;          // Save the unused part.

            // Other conditions are all illegal.        
            default    : IR_nxt  =  32'hdead_ffff                                   ;

        endcase
    end

    sirv_gnrl_dfflr #(.DW(32)) IR_register (
        .lden ( ifu_o_ifu_valid & ifu_i_exu_ready ), // IR can change when both valid and ready are set.
        .dnxt (IR_nxt       ),
        .qout (IR_r         ),
        .clk  (clk          ),
        .rst_n(rst_n        )
    );

    assign ifu_o_ir_r = IR_r;


    // make an auxiliary signal to measure the length of instr
    // If the ir_res is valid, use it first.
    // Then, use itcm_ir according to pc.
    assign current_ir = ({16{IR_res_state }} &  IR_res)                            |               
                        ({16{(~IR_res_state  &  pc_align)}} & itcm_ifu_i_ir[15:0 ])|
                        ({16{(~IR_res_state  & ~pc_align)}} & itcm_ifu_i_ir[31:16]) ;

    // --------------------------------------------------------------------------------------------------
    // 6. ifu_valid
    // output valid
    always @(*) begin: ifu_valid
        if (~rst_n)
            ifu_o_ifu_valid = 1'b0;
        else if (~exu_ifu_pipe_flush_req & ~ir_state)
            ifu_o_ifu_valid = 1'b1;                                                                 // If there is no flush, ir will be ready at state 0;
        else if (exu_ifu_pipe_flush_req & ~ir_state & (|ir_length_encode))
            ifu_o_ifu_valid = 1'b1;                                                                 // If there is flush, ir will be ready at state 0 if ir_length_encode is not 00. 
        else if (exu_ifu_pipe_flush_req & ir_state  & (~(|ir_length_encode)))
            ifu_o_ifu_valid = 1'b1;                                                                 // If there is flush, ir will be ready at state 1 if ir_length_encode is 00. 
        else
            ifu_o_ifu_valid = 1'b0;                                                                 // ifu is not valid under other conditions.
    end

endmodule
