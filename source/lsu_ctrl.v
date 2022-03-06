
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
    input  [`PC_SIZE-1:0          ] agu_i_cmd_addr     ,
    input  [`XLEN-1:0             ] agu_i_cmd_wdata    ,
    input  [`XLEN/8-1:0           ] agu_i_cmd_wmask    ,
    input                           agu_i_cmd_misalgn  ,

    // data path for ram
    output                          lsu_ram_wr         ,
    output                          lsu_ram_rd         ,
    output [`XLEN-1:0             ] lsu_ram_wdata      , // lsu -> ram, store instrs.
    output [`PC_SIZE-1:0          ] lsu_ram_addr       ,
    output                          lsu_ram_valid      , // ram enable
 
    input  [`XLEN-1:0             ] ram_lsu_rdata      , // ram -> lsu, the 1st step for write or read.
    input                           ram_lsu_ready      , // ram -> lsu, data read ready.

    //data path for ita
    output                          lsu_ita_wr         ,
    output                          lsu_ita_rd         ,
    output [`XLEN-1:0             ] lsu_ita_wdata      ,
    output [`PC_SIZE-1:0          ] lsu_ita_addr       ,
    output                          lsu_ita_valid      ,

    input  [`XLEN-1:0             ] ita_lsu_rdata      ,
    input                           ita_lsu_ready      ,

    // Commit data path
    output [`XLEN-1:0             ] lsu_o_wbck_wdata   , // ram -> lsu -> commit -> rd, load instrs.
    output                          lsu_o_wbck_err     ,

    // handshake interface
    output                          lsu_o_ready        ,
    input                           lsu_i_valid        ,
    

    input                           clk                ,
    input                           rst_n              


    );

    wire [`XLEN-1:0 ] lsu_expend_wmask;
    wire              lsu_ita_enable;             // read or write to registers inside ita rather than ram.
    assign lsu_ita_enable = (agu_i_cmd_addr == 32'h1000_0000)|
                            (agu_i_cmd_addr == 32'h1000_0004)|
                            (agu_i_cmd_addr == 32'h1000_0008)|
                            (agu_i_cmd_addr == 32'h1000_000c)|
                            (agu_i_cmd_addr == 32'h1000_0010);   // The address of 32'h1xxx_xxxx is related to ita regs.

    wire              mem_ready;
    assign mem_ready = ( lsu_ita_enable & ita_lsu_ready)|
                       (~lsu_ita_enable & ram_lsu_ready);

    // FSM for read&write enable control.
    wire [1:0]                     ls_state     ; // 00/01 read; 10 write;   
    wire [1:0]                     ls_nxt_state ;
    wire                           shift_enable ; // FSM state shift enable
    
    assign shift_enable = ((lsu_i_valid&mem_ready) & (ls_state == 2'b00)) | // ls_state = read ram 1 st, wait for ready.
                          ((lsu_i_valid&mem_ready) & (ls_state == 2'b10)) | // ls_state = write ram 2 nd, wait for ready.
                          ((ls_state == 2'b01));                            // ls_state = write rf 2 nd, no wait.

    sirv_gnrl_dfflr #(.DW(2)) lsu_dff (
        .lden(shift_enable             ) ,
        .dnxt(ls_nxt_state             ) ,
        .qout(ls_state                 ) ,
        .clk (clk                      ) ,
        .rst_n(rst_n                   )
    );

    assign ls_nxt_state  =  (agu_i_cmd_enable & ~lsu_o_wbck_err & agu_i_cmd_write & (ls_state == 2'b00))? 2'b10:
                            (agu_i_cmd_enable & ~lsu_o_wbck_err & agu_i_cmd_read  & (ls_state == 2'b00))? 2'b01:
                            2'b00;

    assign lsu_ram_wr      =  ((ls_state == 2'b10)&(~lsu_ita_enable))? 1'b1: 1'b0;
    assign lsu_ram_rd      =  ((ls_state == 2'b00)&(~lsu_ita_enable))? 1'b1: 1'b0; // ram excute reading when the state is IDLE and stay silence when state is READ.
    assign lsu_ita_wr      =  ((ls_state == 2'b10)&(lsu_ita_enable))? 1'b1: 1'b0;
    assign lsu_ita_rd      =  ((ls_state == 2'b00)&(lsu_ita_enable))? 1'b1: 1'b0;
 
    // address to Ram or ita
    assign lsu_ram_addr    =  {2'b00, agu_i_cmd_addr[`PC_SIZE-1:2]};
    assign lsu_ita_addr    =  agu_i_cmd_addr;

    // To RAM
    genvar j;
    generate 
        for (j = 0; j<`XLEN/8; j=j+1) begin:wmask
            assign lsu_expend_wmask[j*8+7:j*8] = {8{agu_i_cmd_wmask[j]}};
        end
    endgenerate

    assign lsu_ram_wdata =  (agu_i_cmd_size == 2'b10)? agu_i_cmd_wdata:
                            // we should remain the data unchanged if the instr don't intend to write it. 
                            (agu_i_cmd_wdata & lsu_expend_wmask ) | // new data offered by agu
                            ({32{~lsu_ita_enable}} & ram_lsu_rdata & ~lsu_expend_wmask)|
                            ({32{ lsu_ita_enable}} & ita_lsu_rdata & ~lsu_expend_wmask);
    assign lsu_ita_wdata =   lsu_ram_wdata;

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
    wire [`XLEN-1:0] lsu_wbck_ram_wdata;
    assign lsu_wbck_ram_wdata =  (({32{~agu_i_cmd_usign & rdata_size_w                    }}) & ram_lsu_rdata                                          )| // lw

                                 (({32{agu_i_cmd_usign  & rdata_size_hw & rdata_lower_16  }}) & {{(`XLEN-16){1'b0}},ram_lsu_rdata[15:0 ]}              )| // lhu lower   16
                                 (({32{agu_i_cmd_usign  & rdata_size_hw & rdata_higher_16 }}) & {{(`XLEN-16){1'b0}},ram_lsu_rdata[31:16]}              )| // lhu higher  16
                                 (({32{~agu_i_cmd_usign & rdata_size_hw & rdata_lower_16  }}) & {{(`XLEN-16){ram_lsu_rdata[15]}},ram_lsu_rdata[15:0]}  )| // lh  lower   16
                                 (({32{~agu_i_cmd_usign & rdata_size_hw & rdata_higher_16 }}) & {{(`XLEN-16){ram_lsu_rdata[31]}},ram_lsu_rdata[31:16]} )| // lh  higher  16
    
                                 (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_lowest_8  }}) & {{(`XLEN-8){1'b0}},ram_lsu_rdata[7:0   ]}              )| // lbu lowest  8
                                 (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_lower_8   }}) & {{(`XLEN-8){1'b0}},ram_lsu_rdata[15:8  ]}              )| // lbu lower   8
                                 (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_higher_8  }}) & {{(`XLEN-8){1'b0}},ram_lsu_rdata[23:16 ]}              )| // lbu higher  8
                                 (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_highest_8 }}) & {{(`XLEN-8){1'b0}},ram_lsu_rdata[31:24 ]}              )| // lbu higher  8

                                 (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_lowest_8  }}) & {{(`XLEN-8){ram_lsu_rdata[7]}} ,ram_lsu_rdata[7:0  ]}  )| // lb  lowest  8
                                 (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_lower_8   }}) & {{(`XLEN-8){ram_lsu_rdata[15]}},ram_lsu_rdata[15:8 ]}  )| // lb  lower   8
                                 (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_higher_8  }}) & {{(`XLEN-8){ram_lsu_rdata[23]}},ram_lsu_rdata[23:16]}  )| // lb  higher  8
                                 (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_highest_8 }}) & {{(`XLEN-8){ram_lsu_rdata[31]}},ram_lsu_rdata[31:24]}  ); // lb  highest 8
                                 

    wire [`XLEN-1:0] lsu_wbck_ita_wdata;
    assign lsu_wbck_ita_wdata =  (({32{~agu_i_cmd_usign & rdata_size_w                    }}) & ita_lsu_rdata                                          )| // lw

                                 (({32{agu_i_cmd_usign  & rdata_size_hw & rdata_lower_16  }}) & {{(`XLEN-16){1'b0}},ita_lsu_rdata[15:0 ]}              )| // lhu lower   16
                                 (({32{agu_i_cmd_usign  & rdata_size_hw & rdata_higher_16 }}) & {{(`XLEN-16){1'b0}},ita_lsu_rdata[31:16]}              )| // lhu higher  16
                                 (({32{~agu_i_cmd_usign & rdata_size_hw & rdata_lower_16  }}) & {{(`XLEN-16){ita_lsu_rdata[15]}},ita_lsu_rdata[15:0]}  )| // lh  lower   16
                                 (({32{~agu_i_cmd_usign & rdata_size_hw & rdata_higher_16 }}) & {{(`XLEN-16){ita_lsu_rdata[31]}},ita_lsu_rdata[31:16]} )| // lh  higher  16
    
                                 (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_lowest_8  }}) & {{(`XLEN-8){1'b0}},ita_lsu_rdata[7:0   ]}              )| // lbu lowest  8
                                 (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_lower_8   }}) & {{(`XLEN-8){1'b0}},ita_lsu_rdata[15:8  ]}              )| // lbu lower   8
                                 (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_higher_8  }}) & {{(`XLEN-8){1'b0}},ita_lsu_rdata[23:16 ]}              )| // lbu higher  8
                                 (({32{agu_i_cmd_usign  & rdata_size_b  & rdata_highest_8 }}) & {{(`XLEN-8){1'b0}},ita_lsu_rdata[31:24 ]}              )| // lbu higher  8

                                 (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_lowest_8  }}) & {{(`XLEN-8){ita_lsu_rdata[7]}} ,ita_lsu_rdata[7:0  ]}  )| // lb  lowest  8
                                 (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_lower_8   }}) & {{(`XLEN-8){ita_lsu_rdata[15]}},ita_lsu_rdata[15:8 ]}  )| // lb  lower   8
                                 (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_higher_8  }}) & {{(`XLEN-8){ita_lsu_rdata[23]}},ita_lsu_rdata[23:16]}  )| // lb  higher  8
                                 (({32{~agu_i_cmd_usign & rdata_size_b  & rdata_highest_8 }}) & {{(`XLEN-8){ita_lsu_rdata[31]}},ita_lsu_rdata[31:24]}  ); // lb  highest 8

    assign lsu_o_wbck_wdata = (~lsu_ita_enable)? lsu_wbck_ram_wdata: lsu_wbck_ita_wdata;

    // err indicator 
    assign lsu_o_wbck_err   =  agu_i_cmd_misalgn;


    // handshake interface
    // to exu
    // For mem_top, 
    // Write : the ready signal is set when the data have been taken out at 2nd state (ready set twice).
    // Read  : the ready signal is set when enter the 2nd state(ready set once).
    assign lsu_o_ready      =  (ls_state == 2'b01) |
                               (ls_state == 2'b10) &
                               ((lsu_i_valid & ram_lsu_ready & ~lsu_ita_enable) |
                                (lsu_i_valid & ita_lsu_ready &  lsu_ita_enable));


    // to ram
    assign lsu_ram_valid    =  lsu_i_valid & (~ls_state[0])&(~lsu_ita_enable);                // For ram, the valid signal is set when the instr is ld or st, and ram need to paticipate in.
    assign lsu_ita_valid    =  lsu_i_valid & (~ls_state[0])&( lsu_ita_enable); 
 
endmodule
