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
    input      [`XLEN-1:0                  ] itcm_ifu_i_ir          , // The extracted data from itcm, 32-bits always. flash -> ifu
    output     [`XLEN-1:0                  ] ifu_o_ir_r             , // ifu -> exu

    // PC control for flash    
    input      [`PC_SIZE-1:0               ] pc_ifu_i_pc_nxt        , // The PC_nxt from pc_controller. pc -> ifu
    output                                   ifu_o_pc_init_use      , // ifu -> pc
    output                                   ifu_o_pc_first_instr   ,
    output     [`PC_SIZE-1:0               ] ifu_flash_o_pc         , // PC sent to flash. ifu -> flash
    output                                   ifu_flash_o_enable     ,
 
    // jump and excpirq
    input                                    exu_ifu_pipe_flush_req , // exu -> ifu

    // handshake signals
    output                                   ifu_o_ifu_valid        ,
    input                                    ifu_i_exu_ready        ,

    input                                    clk                    ,
    input                                    rst_n 

    );

    // global signals
    wire [1 :0         ] ifu_ir_info         ; // ir_info[1]: 32-bit instr if set(get from ir_curr); ir_info[0]: pc align if set(get from pc to flash).   
    reg  [(`XLEN/2)-1:0] ifu_ir_curr         ; // To get the necessary info, the lower 16 bits of instr is enough.
    wire                 ac_pipe_flush_req   ;

    //////////////////////////////////////////////////////////////////////////////////////
    // P1: main_state
    // Describe: main state control the current state of ifu.
    //           2'b00: INIT, the first cycle get of reset state.
    //           2'b01: NORMAL, no flush req is put forward.
    //           2'b10: FLUSH1, flush req happened, new instr is taken out at this state if instr is not 32m.
    //           2'b11: FLUSH2, new instr is ready at this state if instr is 32m.
    //////////////////////////////////////////////////////////////////////////////////////
    reg  [1:0] ifu_ir_state    ;
    reg  [1:0] ifu_ir_state_nxt;

    always@(posedge clk or negedge rst_n) begin: main_state
        if (~rst_n) begin:state_reset 
            ifu_ir_state <= 2'b00;
        end
        else begin:state_shift
            ifu_ir_state <= ifu_ir_state_nxt;
        end
    end

    always@(*) begin:ir_state_nxt
        case({ac_pipe_flush_req, ifu_ir_state, ifu_ir_info})
            5'b0_00_01: ifu_ir_state_nxt = 2'b01;             // INIT always goes to NORMAL. The very first instr is set to 16'h0000.

            5'b0_01_00: ifu_ir_state_nxt = 2'b01;             // If there is no flush req, NORMAL goes to NORMAL.
            5'b0_01_01: ifu_ir_state_nxt = 2'b01;
            5'b0_01_10: ifu_ir_state_nxt = 2'b01;
            5'b0_01_11: ifu_ir_state_nxt = 2'b01;

            5'b1_01_00: ifu_ir_state_nxt = 2'b10;             // If there is flush req, always goes to FLUSH1.
            5'b1_01_01: ifu_ir_state_nxt = 2'b10;
            5'b1_01_10: ifu_ir_state_nxt = 2'b10; 
            5'b1_01_11: ifu_ir_state_nxt = 2'b10; 

            5'b1_10_00: ifu_ir_state_nxt = 2'b01;
            5'b1_10_01: ifu_ir_state_nxt = 2'b01;
            5'b1_10_10: ifu_ir_state_nxt = 2'b11;             // If 32m flush req, goes to FLUSH2.
            5'b1_10_11: ifu_ir_state_nxt = 2'b01;             

            5'b1_11_10: ifu_ir_state_nxt = 2'b01;             // FLUSH2 goes to NORMAL.

            default   : ifu_ir_state_nxt = 2'b01;             // OTHER CONDITIONS ARE ILLEGAL!!
        endcase
    end


    /////////////////////////////////////////////////////////////////////////////////////
    // P2: ir_res_state
    // Describe: ir_res_state indicates the status of the register which is used to 
    //           store the unused part flash_o_instr.
    //
    ////////////////////////////////////////////////////////////////////////////////////
    reg        ifu_ir_res_state;
    reg        ifu_ir_res_state_nxt;

    always@(posedge clk or negedge rst_n) begin: res_state
        if (~rst_n) begin:res_state_reset
            ifu_ir_res_state <= 1'b0;
        end
        else begin:res_state_shift
            ifu_ir_res_state <= ifu_ir_res_state_nxt;
        end
    end

    always@(*) begin:ir_res_state_nxt
        case({ac_pipe_flush_req, ifu_ir_state, ifu_ir_info})
            5'b0_00_01: ifu_ir_res_state_nxt = 1'b0;            // The very first instr is set to 16'h0000. ir_res clear.

            5'b0_01_00: ifu_ir_res_state_nxt = 1'b0;            // 16m, res clear.
            5'b0_01_01: ifu_ir_res_state_nxt = 1'b1;            // 16a, res full.
            5'b0_01_10: ifu_ir_res_state_nxt = 1'b1;            // 32m, res full.
            5'b0_01_11: ifu_ir_res_state_nxt = 1'b0;            // 32a, res clear.

            5'b1_01_00: ifu_ir_res_state_nxt = 1'b0;            // If there is flush req, res clear at the first state.
            5'b1_01_01: ifu_ir_res_state_nxt = 1'b0;
            5'b1_01_10: ifu_ir_res_state_nxt = 1'b0; 
            5'b1_01_11: ifu_ir_res_state_nxt = 1'b0; 

            5'b1_10_00: ifu_ir_res_state_nxt = 1'b0;            // instr out, res clear.
            5'b1_10_01: ifu_ir_res_state_nxt = 1'b1;            // instr out, res full.
            5'b1_10_10: ifu_ir_res_state_nxt = 1'b1;            // no instr output, save to 16 bits to res first.
            5'b1_10_11: ifu_ir_res_state_nxt = 1'b0;            // instr out, res clear.

            5'b1_11_10: ifu_ir_res_state_nxt = 1'b1;            // instr out, res full.

            default   : ifu_ir_res_state_nxt = 1'b0;            // OTHER CONDITIONS ARE ILLEGAL!!
        endcase
    end


    ////////////////////////////////////////////////////////////////////////////////////
    // P3: ir_res_reg
    // Describe: ir_res_reg is used to store the unused part of instr.
    ////////////////////////////////////////////////////////////////////////////////////
    reg [(`XLEN/2)-1:0 ] ifu_ir_res    ;
    reg [(`XLEN/2)-1:0 ] ifu_ir_res_nxt;

    always@(posedge clk or negedge rst_n) begin:res_reg
        if(~rst_n) begin:res_reset
            ifu_ir_res <= 16'h0000;
        end
        else begin:res_update
            ifu_ir_res <= ifu_ir_res_nxt;
        end
    end

    always@(*) begin: ir_res_nxt
        case(ifu_ir_res_state_nxt)
            // ir_res always take the higher 16 bits of itcm input.
            1'b1: ifu_ir_res_nxt = itcm_ifu_i_ir[`XLEN-1:`XLEN/2];

            // ir_res keeps unchanged if ir_res is not avaliable.
            1'b0: ifu_ir_res_nxt = ifu_ir_res                    ;
        endcase
    end
    

    ///////////////////////////////////////////////////////////////////////////////////
    // P5: ir_curr and ir_info
    // Describe: significant part of ifu.
    //           ir_curr is the instr wait for launch which is related to pc_nxt and pc_flash.
    //           ----------------------\  /--------------\  /------------------------
    //                                  \/                \/
    //                ir in exu         /\  ir in ifu     /\  ir from itcm next cycle
    //           ----------------------/  \--------------/  \------------------------
    //                pc_r                   pc_nxt            pc_flash
    ///////////////////////////////////////////////////////////////////////////////////
    wire   ifu_pc_nxt_align;                       // pc_nxt_align tells the begining of instr.
    assign ifu_pc_nxt_align = ~pc_ifu_i_pc_nxt[1]; // pc_nxt[1:0] should be 10 or 00. 00 means align.

    always@(*) begin:ir_curr
        if (ifu_ir_res_state) begin: ir_curr_from_res
            ifu_ir_curr = ifu_ir_res;
        end
        else if (ifu_pc_nxt_align) begin: ir_curr_from_low16
            ifu_ir_curr = itcm_ifu_i_ir[(`XLEN/2)-1:0];
        end
        else begin:ir_curr_from_high16
            ifu_ir_curr = itcm_ifu_i_ir[`XLEN-1:(`XLEN/2)];
        end
    end
    
    wire ifu_ir_nxt_rv32 = (~(ifu_ir_curr[4:2] == 3'b111)) & (ifu_ir_curr[1:0] == 2'b11); // decode the length of ir_nxt from ir_curr. only 16-bit and 32-bit instr is supported.

    assign ifu_ir_info[1] = ifu_ir_nxt_rv32;
    assign ifu_ir_info[0] = ifu_pc_nxt_align;


    //////////////////////////////////////////////////////////////////////////////////
    // P6: pc_flash
    // Describe: pc_flash is the pc for itcm access which is predicted from pc_nxt and ir_nxt.
    //////////////////////////////////////////////////////////////////////////////////
    reg [`PC_SIZE-1:0] ifu_pc_flash;
    always@(*) begin:pc_flash
        if (ifu_ir_state == 2'b00) begin:init_pc
            ifu_pc_flash = `PC_SIZE'h0000_0000;
        end
        else if (ac_pipe_flush_req & (ifu_ir_state == 2'b01)) begin:norm2flush
            ifu_pc_flash = pc_ifu_i_pc_nxt;
        end
        else if (ifu_ir_state == 2'b10) begin:flush1
            ifu_pc_flash = pc_ifu_i_pc_nxt + `PC_SIZE'h0000_0004;                   // always try to take the next instr in itcm
        end
        else if (ifu_ir_state == 2'b11) begin:flush2
            ifu_pc_flash = pc_ifu_i_pc_nxt + `PC_SIZE'h0000_0008;
        end
        else begin:norm
            case(ifu_ir_info)
                2'b00: ifu_pc_flash = pc_ifu_i_pc_nxt + `PC_SIZE'h0000_0004;        // 16m
                2'b01: ifu_pc_flash = pc_ifu_i_pc_nxt + `PC_SIZE'h0000_0004;        // 16a
                2'b10: ifu_pc_flash = pc_ifu_i_pc_nxt + `PC_SIZE'h0000_0008;        // 32m
                2'b11: ifu_pc_flash = pc_ifu_i_pc_nxt + `PC_SIZE'h0000_0004;        // 32a
            endcase
        end
    end

    assign ifu_flash_o_enable = ac_pipe_flush_req | (ifu_i_exu_ready & ifu_o_ifu_valid);
    assign ifu_flash_o_pc     = ifu_pc_flash;


    /////////////////////////////////////////////////////////////////////////////////
    // P7: ir_reg
    // Describe: ir_reg is used to store ir_r. ir_r is related to pc_r.
    /////////////////////////////////////////////////////////////////////////////////
    reg [`XLEN-1:0] ifu_ir_nxt;
    reg [`XLEN-1:0] ifu_ir_reg;

    always@(posedge clk or negedge rst_n) begin:ir_reg
        if (~rst_n) begin:ir_reset
            ifu_ir_reg <= `XLEN'h0000_0000;
        end
        else if (ifu_i_exu_ready & ifu_o_ifu_valid) begin:ir_update
            ifu_ir_reg <= ifu_ir_nxt;  // ir update when exu and ifu are both ready.       
        end
    end

    always@(*) begin:ir_reg_nxt
        case({ac_pipe_flush_req, ifu_ir_state, ifu_ir_info})
            5'b0_00_01: ifu_ir_nxt = `XLEN'h0000_0000;        // First cycle, both itcm_i_ir and ir_res are unavaliable.

            5'b0_01_00: ifu_ir_nxt = {16'h0000           , ifu_ir_res         };   // 16m, take the data inside ir_res.
            5'b0_01_01: ifu_ir_nxt = {16'h0000           , itcm_ifu_i_ir[15:0]};   // 16a, take the lower 16 bits of itcm_i_ir.
            5'b0_01_10: ifu_ir_nxt = {itcm_ifu_i_ir[15:0], ifu_ir_res         };   // 32m, combine the data inside ir_res and lower 16 bits of itcm_i_ir.
            5'b0_01_11: ifu_ir_nxt = itcm_ifu_i_ir                             ;   // 32a, just take itcm_i_ir.

            5'b1_01_00: ifu_ir_nxt = 32'h0000_0000                             ;   // at this state, ir is useless.
            5'b1_01_01: ifu_ir_nxt = 32'h0000_0000                             ;   // at this state, ir is useless.
            5'b1_01_10: ifu_ir_nxt = 32'h0000_0000                             ;   // at this state, ir is useless.
            5'b1_01_11: ifu_ir_nxt = 32'h0000_0000                             ;   // at this state, ir is useless.

            5'b1_10_00: ifu_ir_nxt = {16'h0000           , itcm_ifu_i_ir[31:16]};  // 16m
            5'b1_10_01: ifu_ir_nxt = {16'h0000           , itcm_ifu_i_ir[15:0 ]};  // 16a
            5'b1_10_10: ifu_ir_nxt = 32'h0000_0000                              ;  // 32m, instr not ready yet.
            5'b1_10_11: ifu_ir_nxt = itcm_ifu_i_ir                              ;  // 32a

            5'b1_11_10: ifu_ir_nxt = {itcm_ifu_i_ir[15:0], ifu_ir_res          };  // 32m, instr ready.

            default:    ifu_ir_nxt = 32'h0000_0000                             ;   // OTHER CONDITIONS ARE ILLEGAL.
        endcase
    end

    assign ifu_o_ir_r = ifu_ir_reg;
    
    
    /////////////////////////////////////////////////////////////////////////////////
    // P8: valid
    // Describe: ifu_valid indicate ifu have organized the correct instr.
    ////////////////////////////////////////////////////////////////////////////////
    reg ifu_valid;

    always@(*) begin:ifu_ir_valid
        if (ifu_ir_state == 2'b00) begin:state_init
            ifu_valid = 1'b1;
        end
        else begin: other_state
            case({ac_pipe_flush_req, ifu_ir_state, ifu_ir_info})
                
                // If no flush req, ifu always valid.
                5'b0_01_00: ifu_valid = 1'b1;
                5'b0_01_01: ifu_valid = 1'b1;
                5'b0_01_10: ifu_valid = 1'b1;
                5'b0_01_11: ifu_valid = 1'b1;

                // If flush req, ifu always unvalid at 01.
                5'b1_01_00: ifu_valid = 1'b0;
                5'b1_01_01: ifu_valid = 1'b0;
                5'b1_01_10: ifu_valid = 1'b0;
                5'b1_01_11: ifu_valid = 1'b0;

                // If flush req, ifu valid at 10 except 32m.
                5'b1_10_00: ifu_valid = 1'b1;
                5'b1_10_01: ifu_valid = 1'b1;
                5'b1_10_10: ifu_valid = 1'b0;
                5'b1_10_11: ifu_valid = 1'b1;

                // ifu always valid at 11.
                5'b1_11_10: ifu_valid = 1'b1;
                
                // Other conditions are illegal.
                default: ifu_valid = 1'b1; 
            endcase
        end
    end

    assign ifu_o_ifu_valid = ifu_valid; 


    /////////////////////////////////////////////////////////////////////////////////////
    // P9: INIT_USE
    // Describe: the first cycle after the rst_n was pull up.
    ////////////////////////////////////////////////////////////////////////////////////
    reg ifu_pc_init_use_r;
    reg ifu_pc_first_instr_raw;

    always@(posedge clk or negedge rst_n) begin
        if(~rst_n)
            ifu_pc_init_use_r <= 1'b1;
        else
            ifu_pc_init_use_r <= 1'b0;
    end

    assign ifu_o_pc_init_use = ifu_pc_init_use_r;

    always@(posedge clk or negedge rst_n) begin
        if(~rst_n)
            ifu_pc_first_instr_raw <= 1'b1;
        else
            ifu_pc_first_instr_raw <= ifu_pc_init_use_r;
    end

    assign ifu_o_pc_first_instr = ifu_pc_first_instr_raw & (~ifu_pc_init_use_r);


    ////////////////////////////////////////////////////////////////////////////////////
    // P10: auto_correlation-pipe_flush_req
    // Describe: ensure the length of flush req meet the need of pipe flush.
    ////////////////////////////////////////////////////////////////////////////////////
    reg ac_pipe_flush_req_raw;
    reg ac_pipe_flush_req_nxt;

    always@(posedge clk or negedge rst_n) begin
        if (~rst_n)
            ac_pipe_flush_req_raw <= 1'b0;
        else
            ac_pipe_flush_req_raw <= ac_pipe_flush_req_nxt;
    end

    always@(*) begin
        case({ac_pipe_flush_req_raw|exu_ifu_pipe_flush_req, ifu_ir_state, ifu_ir_info})
            5'b0_00_01: ac_pipe_flush_req_nxt = 1'b0;

            // If no flush req, ac_pipe_flush_req always unvalid.
            5'b0_01_00: ac_pipe_flush_req_nxt = 1'b0;
            5'b0_01_01: ac_pipe_flush_req_nxt = 1'b0;
            5'b0_01_10: ac_pipe_flush_req_nxt = 1'b0;
            5'b0_01_11: ac_pipe_flush_req_nxt = 1'b0;

            // If flush req, ac_pipe_flush_req always valid at 01.
            5'b1_01_00: ac_pipe_flush_req_nxt = 1'b1;
            5'b1_01_01: ac_pipe_flush_req_nxt = 1'b1;
            5'b1_01_10: ac_pipe_flush_req_nxt = 1'b1;
            5'b1_01_11: ac_pipe_flush_req_nxt = 1'b1;

            // if flush req, ac_pipe_flush_req release at 10 except 32m.
            5'b1_10_00: ac_pipe_flush_req_nxt = 1'b0;
            5'b1_10_01: ac_pipe_flush_req_nxt = 1'b0;
            5'b1_10_10: ac_pipe_flush_req_nxt = 1'b1;
            5'b1_10_11: ac_pipe_flush_req_nxt = 1'b0;

            // if no flush req, ac_pipe_flush_req will release at 11.
            5'b1_11_10: ac_pipe_flush_req_nxt = 1'b0;
                
            // other conditions are illegal.
            default: ac_pipe_flush_req_nxt = 1'b0; 
        endcase
    end

    assign ac_pipe_flush_req = ac_pipe_flush_req_raw | exu_ifu_pipe_flush_req;
    

    
endmodule
