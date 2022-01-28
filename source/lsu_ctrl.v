
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/14 09:54:47
// Design Name: 
// Module Name: lsu_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module lsu_ctrl(

    // address from AGU
    input                           agu_i_cmd_enable   ,
    input                           agu_i_cmd_read     ,
    input                           agu_i_cmd_write    ,
    input                           agu_i_cmd_usign    ,
    input  [1:0                   ] agu_i_cmd_size     ,
    input  [`XLEN-1:0             ] agu_i_cmd_addr     ,
    input  [`XLEN-1:0             ] agu_i_cmd_wdata    ,
    input  [`XLEN/8-1:0           ] agu_i_cmd_wmask    ,
    input                           agu_i_cmd_misalgn  ,

    // data path for ram
    output                          lsu_o_wr           ,
    output                          lsu_o_rd           ,
    output [`XLEN-1:0             ] lsu_o_wdata        , // lsu -> ram, store instrs.
    output [`PC_SIZE-1:0          ] lsu_o_addr         ,
    input  [`XLEN-1:0             ] ram_i_rdata        , // ram -> lsu, the 1st step for write.

    // Commit data path
    output [`XLEN-1:0             ] lsu_o_wbck_wdata   , // ram -> lsu -> commit -> rd, load instrs.
    output                          lsu_o_wbck_err     ,

    // handshake interface
    output                          lsu_o_ready        ,
    input                           lsu_i_valid        ,
    
    `ifdef TEST_MODE
      // test ports
      output [1:0                 ] ls_nxt_state_t     ,
      output [1:0                 ] ls_state_t         ,
      output [`XLEN-1:0           ] lsu_expend_wmask_t ,
    `endif 

    input                           clk                ,
    input                           rst_n              


    );

    wire [`XLEN-1:0 ] lsu_expend_wmask;

    // FSM for read&write enable control.
    wire [1:0]                     ls_state     ; // 0 read; 1 write;   
    wire [1:0]                     ls_nxt_state ;

    sirv_gnrl_dfflr #(.DW(2)) lsu_dff (
        .lden(1'b1)         ,
        .dnxt(ls_nxt_state) ,
        .qout(ls_state)     ,
        .clk(clk)           ,
        .rst_n(rst_n)
    );

    assign ls_nxt_state  =  (agu_i_cmd_enable & ~lsu_o_wbck_err & agu_i_cmd_write & (ls_state == 2'b00))? 2'b10:
                            (agu_i_cmd_enable & ~lsu_o_wbck_err & agu_i_cmd_read  & (ls_state == 2'b00))? 2'b01:
                            2'b00;

    assign lsu_o_wr      =  (ls_state == 2'b10)? 1'b1: 1'b0;
    assign lsu_o_rd      =  (ls_state == 2'b00)? 1'b1: 1'b0; // ram excute reading when the state is IDLE and stay silence when state is READ.
 
    // To Ram
    assign lsu_o_addr    =  {2'b00, agu_i_cmd_addr[`XLEN-1:2]};

    // To RAM
    genvar j;
    generate 
        for (j = 0; j<`XLEN/8; j=j+1) begin:wmask
            assign lsu_expend_wmask[j*8+7:j*8] = {8{agu_i_cmd_wmask[j]}};
        end
    endgenerate

    assign lsu_o_wdata =  (agu_i_cmd_size == 2'b10)? agu_i_cmd_wdata:
                          // we should remain the data unchanged if the instr don't intend to write it. 
                          (agu_i_cmd_wdata & lsu_expend_wmask ) | (ram_i_rdata & ~lsu_expend_wmask);

    // To rd
    // For read operation the rdata have to be reorganized.
    // length
    wire rdata_size_b     = (agu_i_cmd_size == 2'b00)? 1'b1: 1'b0;
    wire rdata_size_hw    = (agu_i_cmd_size == 2'b01)? 1'b1: 1'b0;
    wire rdata_size_w     = (agu_i_cmd_size == 2'b10)? 1'b1: 1'b0;

    // pos
    wire rdata_lowest_8 ;
    wire rdata_lower_8  ;
    wire rdata_higher_8 ;
    wire rdata_highest_8;

    // pos for lw
    wire rdata_lower_16   = rdata_lowest_8;
    wire rdata_higher_16  = rdata_higher_8;

    // pos for lb
    assign rdata_lowest_8   = (agu_i_cmd_addr[1:0] == 2'b00)? 1'b1: 1'b0;
    assign rdata_lower_8    = (agu_i_cmd_addr[1:0] == 2'b01)? 1'b1: 1'b0;
    assign rdata_higher_8   = (agu_i_cmd_addr[1:0] == 2'b10)? 1'b1: 1'b0;
    assign rdata_highest_8  = (agu_i_cmd_addr[1:0] == 2'b11)? 1'b1: 1'b0;

    // Here the wbck_data is decided by:
    // 1. The instr refers to a signed or unsigned instr;
    // 2. The length of data that need to be read;
    // 3. The start point that reading procedure begins.
    // For b  | highest_8 | higher_8 | lower_8 | lowest_8 |
    // For hw | higher 16 | lower 16 |
    //                                1.                2.              3.
    assign lsu_o_wbck_wdata =  (({32{~agu_i_cmd_usign & rdata_size_w                    }}) & ram_i_rdata                                        )| // lw

                               (({32{agu_i_cmd_usign  & rdata_size_hw & rdata_lower_16  }}) & {{(`XLEN-16){1'b0}},ram_i_rdata[15:0 ]}            )| // lhu lower   16
                               (({32{agu_i_cmd_usign  & rdata_size_hw & rdata_higher_16 }}) & {{(`XLEN-16){1'b0}},ram_i_rdata[31:16]}            )| // lhu higher  16
                               (({32{~agu_i_cmd_usign & rdata_size_hw & rdata_lower_16  }}) & {{(`XLEN-16){ram_i_rdata[15]}},ram_i_rdata[15:0]}  )| // lh  lower   16
                               (({32{~agu_i_cmd_usign & rdata_size_hw & rdata_higher_16 }}) & {{(`XLEN-16){ram_i_rdata[31]}},ram_i_rdata[31:16]} )| // lh  higher  16
    
                               (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_lowest_8  }}) & {{(`XLEN-8){1'b0}},ram_i_rdata[7:0   ]}            )| // lbu lowest  8
                               (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_lower_8   }}) & {{(`XLEN-8){1'b0}},ram_i_rdata[15:8  ]}            )| // lbu lower   8
                               (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_higher_8  }}) & {{(`XLEN-8){1'b0}},ram_i_rdata[23:16 ]}            )| // lbu higher  8
                               (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_highest_8 }}) & {{(`XLEN-8){1'b0}},ram_i_rdata[31:24 ]}            )| // lbu higher  8

                               (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_lowest_8  }}) & {{(`XLEN-8){ram_i_rdata[7]}} ,ram_i_rdata[7:0  ]}  )| // lb  lowest  8
                               (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_lower_8   }}) & {{(`XLEN-8){ram_i_rdata[15]}},ram_i_rdata[15:8 ]}  )| // lb  lower   8
                               (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_higher_8  }}) & {{(`XLEN-8){ram_i_rdata[23]}},ram_i_rdata[23:16]}  )| // lb  higher  8
                               (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_highest_8 }}) & {{(`XLEN-8){ram_i_rdata[31]}},ram_i_rdata[31:24]}  )  // lb  highest 8
                                ;


    // err indicator 
    assign lsu_o_wbck_err   =  agu_i_cmd_misalgn;

    // handshake interface
    assign lsu_o_ready      =  ~(ls_state == 2'b00) & lsu_i_valid;

    `ifdef TEST_MODE
        // test ports
        assign ls_nxt_state_t      = ls_nxt_state      ;
        assign ls_state_t          = ls_state          ;
        assign lsu_expend_wmask_t  = lsu_expend_wmask  ;
    `endif

endmodule
