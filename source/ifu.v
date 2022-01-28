
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
    // output                                ifu_o_itcm_ren         , 
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
    wire ir_length_m32 = ~pc_align & ir_length_32;        // This is an misalign 32-bit instr.
    wire ir_length_m16 = ~pc_align & ir_length_16;        // This is an misalign 16-bit instr.

    // The first bit is used to show the status of align;  1:align 0:misalign
    // The second bit is used to show the length of instr. 1:16 bit 0:32 bit
    wire [1:0] ir_length_encode = ({2{ir_length_a32 &  pc_align}} & 2'b10 )|
                                  ({2{ir_length_m32 & ~pc_align}} & 2'b00 )|
                                  ({2{ir_length_a16 &  pc_align}} & 2'b11 )|
                                  ({2{ir_length_m16 & ~pc_align}} & 2'b01 );



    // main state controller
    // make an extra cycle when meet jump instrs.
    // make two extra cycles when meet misalign jump to 32-bits instr.
    reg  [1:0             ] ir_state_nxt;  
    wire [1:0             ] ir_state;

    // Here is the most difficult logic:
    // 1. pc_nxt is uploaded by pc controller and it will be remained unchange during the jump instr excuting procedure.
    // 2. ifu give internal address to itcm to take instr out with 1-2 cycles which is decided by pc_nxt and ir_state.
    // 3. ir should be ready at the end of 01 or 11 state when meet jump and other flush.
    // 4. When jumping, only the ir obtained from 01 state can tell the length of instr. So the 00 and 11 state is automaticly changed.
    always @(*) begin:main_s

        case({exu_ifu_pipe_flush_req, ir_state, ir_length_encode})

        // If there is no flush req, state is always 2'b00.
        // If there is no flush req, state can not be other situation except for 2'b00.
        5'b0_00_00 : ir_state_nxt = 2'b00;
        5'b0_00_01 : ir_state_nxt = 2'b00;
        5'b0_00_10 : ir_state_nxt = 2'b00;
        5'b0_00_11 : ir_state_nxt = 2'b00;

        // If there is flush req:
        // First, the state 2'b00 should always jump to 2'b01 and tell ram read the PC[31:2].
        5'b1_00_00 : ir_state_nxt = 2'b01;
        5'b1_00_01 : ir_state_nxt = 2'b01;
        5'b1_00_10 : ir_state_nxt = 2'b01;
        5'b1_00_11 : ir_state_nxt = 2'b01;

        // Second, the state 2'b01 should jump to 2'b01 or 2'b11 according to ir_length_encode.
        5'b1_01_00 : ir_state_nxt = 2'b11;
        5'b1_01_01 : ir_state_nxt = 2'b00;
        5'b1_01_10 : ir_state_nxt = 2'b00;
        5'b1_01_11 : ir_state_nxt = 2'b00;

        // Third, the state 2'b11 should always jump to 2'b00 and tell ram read the PC[31:2] + 32'd4.
        5'b1_11_00 : ir_state_nxt = 2'b00;

        // Other conditions are all illegal.        
        default : ir_state_nxt = 2'b11;

        endcase

    end

    // The state only changed when ready and valid are both set.
    sirv_gnrl_dfflr #(.DW(2)) ir_state_register (
        .lden ( ~ifu_o_ifu_valid | ifu_i_exu_ready ),
        .dnxt (ir_state_nxt ),
        .qout (ir_state     ),
        .clk  (clk          ),
        .rst_n(rst_n        )
    );

    // PC controller is used to control the pc in a two-step instr-reading procedure.
    wire IR_res_state    ;
    always @(*) begin: pc_o_controller
        case(IR_res_state)
        // If there is no flush req, the state is always 2'b00.
        1'b1   : ifu_flash_o_pc = {pc_ifu_i_pc_nxt[`PC_SIZE-1:2], 2'b00} + `PC_SIZE'd4;    // Normally, read next 32 bits when ir_res is avaliable.
        1'b0   : ifu_flash_o_pc = {pc_ifu_i_pc_nxt[`PC_SIZE-1:2], 2'b00};                  // read the current 32 bits when ir_res is unavaliable.

        default    : ifu_flash_o_pc = `PC_SIZE'd0;    
        endcase
    end


    // One thing that ir register and ir_res register have to concern is ensuring at any state the ir length should be correct.
    // 01 state is always correct;
    // 00 state will fail when misalign-reading 16bits instr.
    // 11 state will fail when reading any instr(32).
    // So, we make an indicator to show the valid of ir_res register. 
    // Generate IR register
    wire [`IR_RES_LEN-1:0 ] IR_res;
    wire [`XLEN-1:0       ] IR_r  ;
    reg  [`XLEN-1:0       ] IR_nxt;
    reg  [`IR_RES_LEN-1:0 ] IR_res_nxt;

    always @(*) begin: ir_res_reg
    
        case({exu_ifu_pipe_flush_req, ir_state, ir_length_encode})

        // If there is no flush req, the state is always 2'b00.
        5'b0_00_00 : IR_res_nxt =  itcm_ifu_i_ir[31:16];          // 32m, save the unused 16 bits, 00 always intends to read the upper 16 bits.    // ok
        5'b0_00_01 : IR_res_nxt =  `IR_RES_LEN'd0      ;          // 16m, empty the res register.                                                  // ok no jump m16
        5'b0_00_10 : IR_res_nxt =  `IR_RES_LEN'd0      ;          // 32a, the res register is still empty, the instrs all used.                    // ok no jump a32
        5'b0_00_11 : IR_res_nxt =  itcm_ifu_i_ir[31:16];          // 16a, save the unused 16 bits.                                                 // ok

        // If there is flush req:
        // First, the state 2'b00 should always jump to 2'b01 and tell ram read the PC[31:2].
        5'b1_00_00 : IR_res_nxt =  `IR_RES_LEN'd0      ;          // If there is flush, the data in res register is wasted.                        // ok
        5'b1_00_01 : IR_res_nxt =  `IR_RES_LEN'd0      ;                                                                                           // ok
        5'b1_00_10 : IR_res_nxt =  `IR_RES_LEN'd0      ;                                                                                           // ok
        5'b1_00_11 : IR_res_nxt =  `IR_RES_LEN'd0      ;                                                                                           // ok

        // Second, the state 2'b01 should jump to 2'b01 or 2'b11 according to ir_length_encode.
        5'b1_01_00 : IR_res_nxt =  itcm_ifu_i_ir[31:16];          // save the lower part of 32bits instr. // This condition is very special.       // ok
        5'b1_01_01 : IR_res_nxt =  `IR_RES_LEN'd0      ;          // empty                                                                         // ok
        5'b1_01_10 : IR_res_nxt =  `IR_RES_LEN'd0      ;          // empty                                                                         // ok 
        5'b1_01_11 : IR_res_nxt =  itcm_ifu_i_ir[31:16];          // Save the unused part.                                                         // ok

        // Third, the state 2'b11 should always jump to 2'b00 and tell ram read the PC[31:2] + 32'd4.
        5'b1_11_00 : IR_res_nxt =  itcm_ifu_i_ir[31:16];          // Save the unused part.                                                         // ok

        // Other conditions are all illegal.        
        default    : IR_res_nxt =  `IR_RES_LEN'hdead   ;

        endcase
    end

    // res register is not controlled by ready and valid.
    sirv_gnrl_dfflr #(.DW(16)) IR_res_register (
        .lden ( ~ifu_o_ifu_valid | ifu_i_exu_ready   ),
        .dnxt (IR_res_nxt   ),
        .qout (IR_res       ),
        .clk  (clk          ),
        .rst_n(rst_n        )
    );


    // build another dff for ir_res register to show its status.
    reg  IR_res_state_nxt;

    always@(*) begin: IR_res_state_reg

        case({exu_ifu_pipe_flush_req, ir_state, ir_length_encode})

        // If there is no flush req, the state is always 2'b00.
        5'b0_00_00 : IR_res_state_nxt =  1'b1      ;          // 32m, save the unused 16 bits, 00 always intends to read the upper 16 bits.
        5'b0_00_01 : IR_res_state_nxt =  1'b0      ;          // 16m, empty the res register.
        5'b0_00_10 : IR_res_state_nxt =  1'b0      ;          // 32a, the res register is still empty, the instrs all used.
        5'b0_00_11 : IR_res_state_nxt =  1'b1      ;          // 16a, save the unused 16 bits.

        // If there is flush req:
        // First, the state 2'b00 should always jump to 2'b01 and tell ram read the PC[31:2].
        5'b1_00_00 : IR_res_state_nxt =  1'b0      ;          // If there is flush, the data in res register is wasted.
        5'b1_00_01 : IR_res_state_nxt =  1'b0      ;
        5'b1_00_10 : IR_res_state_nxt =  1'b0      ;
        5'b1_00_11 : IR_res_state_nxt =  1'b0      ;

        // Second, the state 2'b01 should jump to 2'b01 or 2'b11 according to ir_length_encode.
        5'b1_01_00 : IR_res_state_nxt =  1'b1      ;          // save the lower part of 32bits instr. // This condition is very special.
        5'b1_01_01 : IR_res_state_nxt =  1'b0      ;          // empty
        5'b1_01_10 : IR_res_state_nxt =  1'b0      ;          // empty
        5'b1_01_11 : IR_res_state_nxt =  1'b1      ;          // Save the unused part.

        // Third, the state 2'b11 should always jump to 2'b00 and tell ram read the PC[31:2] + 32'd4.
        5'b1_11_00 : IR_res_state_nxt =  1'b1      ;          // Save the unused part.

        // Other conditions are all illegal.        
        default    : IR_res_state_nxt =  1'b0      ;

        endcase

    end

    // res_status register is not controlled by ready and valid.
    sirv_gnrl_dfflr #(.DW(1)) IR_res_status_register (
        .lden ( ~ifu_o_ifu_valid | ifu_i_exu_ready      ),
        .dnxt (IR_res_state_nxt   ),
        .qout (IR_res_state       ),
        .clk  (clk                ),
        .rst_n(rst_n              )
    );



    // Generate correct IR
    always@(*) begin:IR_controller

        case({exu_ifu_pipe_flush_req, ir_state, ir_length_encode})  // ir_length_encode: MSB, 0: misalign 1: align; LSB, 0: 32bit 1:16bit.

        // If there is no flush req, the state is always 2'b00.
        5'b0_00_00 : IR_nxt  =  {itcm_ifu_i_ir[15:0], IR_res             }      ;          // 32m, combine the ir_res register and the itcm_ir.
        5'b0_00_01 : IR_nxt  =  {16'd0              , IR_res             }      ;          // 16m, take out the res register.
        5'b0_00_10 : IR_nxt  =  itcm_ifu_i_ir                                   ;          // 32a, the instrs all used.
        5'b0_00_11 : IR_nxt  =  {16'd0              , itcm_ifu_i_ir[15:0]}      ;          // 16a, save the unused 16 bits.
        
        // If there is flush req:
        // First, the state 2'b00 should always jump to 2'b01 and tell ram read the PC[31:2].
        5'b1_00_00 : IR_nxt  =  32'h0000_0000                                   ;          // instr will not changed at this state.
        5'b1_00_01 : IR_nxt  =  32'h0000_0000                                   ;
        5'b1_00_10 : IR_nxt  =  32'h0000_0000                                   ;
        5'b1_00_11 : IR_nxt  =  32'h0000_0000                                   ;

        // Second, the state 2'b01 should jump to 2'b01 or 2'b11 according to ir_length_encode.
        5'b1_01_00 : IR_nxt  =  32'h0000_0000                                   ;          // save the lower part of 32bits instr. // This condition is very special. // instr will not changed at this state.
        5'b1_01_01 : IR_nxt  =  {16'd0              , itcm_ifu_i_ir[31:16]}     ;          // empty
        5'b1_01_10 : IR_nxt  =  itcm_ifu_i_ir                                   ;          // empty
        5'b1_01_11 : IR_nxt  =  {16'd0              , itcm_ifu_i_ir[15: 0]}     ;          // Save the unused part.

        // Third, the state 2'b11 should always jump to 2'b00 and tell ram read the PC[31:2] + 32'd4.
        5'b1_11_00 : IR_nxt  =  {itcm_ifu_i_ir[15:0], IR_res             }      ;          // Save the unused part.

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


    // output valid
    always @(*) begin: ifu_valid
        if (~rst_n)
            ifu_o_ifu_valid = 1'b0;
        else if (~exu_ifu_pipe_flush_req & ~(|ir_state))
            ifu_o_ifu_valid = 1'b1;                                                                 // If there is no flush, ir will be ready at state 00;
        else if (exu_ifu_pipe_flush_req & ir_state[0] & (~(ir_state[1])) & (|ir_length_encode))
            ifu_o_ifu_valid = 1'b1;                                                                 // If there is flush, ir will be ready at state 01 if ir_length_encode is not 00. 
        else if (exu_ifu_pipe_flush_req & ir_state[1] & ir_state[0] & (~(|ir_length_encode)))
            ifu_o_ifu_valid = 1'b1;                                                                 // If there is flush, ir will be ready at state 11 if ir_length_encode is 00. 
        else
            ifu_o_ifu_valid = 1'b0;                                                                 // ifu is not valid under other conditions.
    end

endmodule
