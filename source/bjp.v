
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw 
// 
// Create Date: 2021/06/18 13:44:53
// Design Name: 
// Module Name: bjp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: bjp is used to handle the jump instructions. 
// 
//////////////////////////////////////////////////////////////////////////////////

`include "mcu_defines.v"

module bjp(
    // PC related signals
    input  [`PC_SIZE-1:0]             bjp_i_pc_r          ,

    /////////////////////////////////////////////////////////
    // BJP get data from alu top, regfile and csr.
    input  [`XLEN-1:0]                bjp_i_rs1           ,
    input  [`XLEN-1:0]                bjp_i_rs2           ,
    input  [`XLEN-1:0]                bjp_i_imm           ,
    input  [`DECINFO_BJP_WIDTH-1:0]   bjp_i_info          ,
    input  [`XLEN-1:0]                bjp_i_csrepc        ,
    input  [`XLEN-1:0]                bjp_i_csrdpc        ,

    /////////////////////////////////////////////////////////
    // To share the ALU datapath
    // The operands and info to alu_dpath
    output                            bjp_req_alu         ,
    output [`XLEN-1:0]                bjp_req_alu_op1     ,
    output [`XLEN-1:0]                bjp_req_alu_op2     ,
    output                            bjp_req_alu_cmp_eq  ,
    output                            bjp_req_alu_cmp_ne  ,
    output                            bjp_req_alu_cmp_lt  ,
    output                            bjp_req_alu_cmp_gt  ,
    output                            bjp_req_alu_cmp_ltu ,
    output                            bjp_req_alu_cmp_gtu ,
    input                             bjp_req_alu_cmp_res ,

    //   The Write-Back Result for JAL and JALR
    output [`XLEN-1:0]                bjp_o_wbck_wdat     ,
    output                            bjp_o_wbck_err      ,
 
    //   The Commit Result for BJP 
    output                            bjp_o_cmt_bjp       ,
    output                            bjp_o_cmt_mret      ,
    output                            bjp_o_cmt_dret      ,
    output                            bjp_o_cmt_needflush ,
    output [`PC_SIZE-1:0]             bjp_req_flush_pc    
    
    );
   
    // Resolve info bus and get the main group of instr.
    wire   mret                     =     bjp_i_info[`DECINFO_BJP_MRET  ];
    wire   dret                     =     bjp_i_info[`DECINFO_BJP_DRET  ]; 
    wire   bxx                      =     bjp_i_info[`DECINFO_BJP_BXX   ];
    wire   jump                     =     bjp_i_info[`DECINFO_BJP_JUMP  ];
    wire   rv32                     =     bjp_i_info[`DECINFO_RV32      ];
    wire   jal                      =     bjp_i_info[`DECINFO_BJP_JAL   ];
    wire   jalr                     =     bjp_i_info[`DECINFO_BJP_JALR  ];
    wire   rv16                     =     ~rv32;

    // Alu_bjp need to write back when the instr is jal or jalr.
    // The operands will be sent to dpath in order to add the operands.
    // The rs1 should be current pc and the rs2 should be 2(16-bit) or 4(32-bit).
    wire   wbck_link                =     jump;
    assign bjp_o_wbck_wdat          =     rv32? bjp_i_pc_r+(32'd4): bjp_i_pc_r+32'd2;
    assign bjp_o_wbck_err           =     1'b0;

    // Tell dpath what kind of operation you want to do.
    assign bjp_req_alu              =     bxx;
    assign bjp_req_alu_cmp_eq       =     bjp_i_info [`DECINFO_BJP_BEQ  ]; 
    assign bjp_req_alu_cmp_ne       =     bjp_i_info [`DECINFO_BJP_BNE  ]; 
    assign bjp_req_alu_cmp_lt       =     bjp_i_info [`DECINFO_BJP_BLT  ]; 
    assign bjp_req_alu_cmp_gt       =     bjp_i_info [`DECINFO_BJP_BGT  ]; 
    assign bjp_req_alu_cmp_ltu      =     bjp_i_info [`DECINFO_BJP_BLTU ]; 
    assign bjp_req_alu_cmp_gtu      =     bjp_i_info [`DECINFO_BJP_BGTU ]; 
    assign bjp_req_alu_op1          =     bjp_i_rs1                      ;
    assign bjp_req_alu_op2          =     bjp_i_rs2                      ;

    // Need flush signal.
    // PC needs flush when meets jal/jalr/Bxx(avaliable), interrupt and return.
    // For cmp result, 0 represents reject, 1 represents approve.
    wire             bjp_req_flush  =     jal | jalr | (bxx & bjp_req_alu_cmp_res)| mret | dret ; // here a loop occur. go and excute it.

    assign bjp_req_flush_pc    =    jal?       bjp_i_pc_r + bjp_i_imm:                            // For jal, the imm has been reorganized in dc. 
                                    jalr?      bjp_i_rs1  + bjp_i_imm:                            // For jalr, the imm has been reorganized in dc.
                                    bxx?       bjp_i_pc_r + {bjp_i_imm[30:0],1'b0}:               // For bxx, the imm has been reorganized in dc. The last bit of bimm is always 0.
                                    mret?      bjp_i_csrepc:                                      // mret
                                    dret?      bjp_i_csrdpc:                                      // dret
                                    'd0;                                                          // UNVALID

    // Commit signals
    assign bjp_o_cmt_needflush      =     bjp_req_flush;
    assign bjp_o_cmt_bjp            =     bxx | jump;
    assign bjp_o_cmt_mret           =     mret;
    assign bjp_o_cmt_dret           =     dret;


endmodule
