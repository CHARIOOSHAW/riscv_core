
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: chario shaw
// 
// Create Date: 2021/08/20 17:31:09
// Design Name: 
// Module Name: excp_aluexcp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: excp_aluexcp is a unit of excp and is designed for detect
//                      alu related excptions.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

// alu_excp have been changed to aluexcp.
module excp_aluexcp(
    
    // dbg control signals
    input                dbg_ebreakm_r                    ,
    input                dbg_mode                         ,
      
    // exception type from exu and ifu      
    input                alu_excp_flush_req               ,
    input                aluexcp_i_alu_err                ,
    input                aluexcp_i_ebreak                 ,
    input                aluexcp_i_misalgn                ,
    input                aluexcp_i_buserr                 ,
    input                aluexcp_i_ecall                  ,
    input                aluexcp_i_ifu_misalgn            ,
    input                aluexcp_i_ifu_buserr             ,
    input                aluexcp_i_ifu_ilegl              ,
    input                aluexcp_i_ld                     ,      
    input                aluexcp_i_stamo                  ,    

    // current pri mode
    input                u_mode                           ,
    input                s_mode                           ,
    input                h_mode                           ,
    input                m_mode                           ,
    
    // output 
    output               aluexcp_o_ebreakm_flush_req      , // enter dbg mode
    output               aluexcp_o_need_flush4excp        , // need flush because of exception, to pc mtvec or dbg entry. Something has to be changed in PC.

    output               aluexcp_o_flush_by_alu_agu       ,
    output [`XLEN-1:0]   aluexcp_o_excp_cause             ,

    output               aluexcp_flush_req_ifu_misalgn    ,
    output               aluexcp_flush_req_ifu_buserr     ,
    output               aluexcp_flush_req_ifu_ilegl      ,
    output               aluexcp_flush_req_ebreak        

    );
    
    ////////////////////////////////////////////////////////////////////////////
    // The ALU triggered Exception 
    // there are two methods to handle ebreak: 1. handled as a regular exception. 2. entry the dbg mode.
  
    // The ebreak instruction will generated regular exception when the ebreakm bit 
    // of DCSR reg is not set or core is in dbg mode.
    wire aluexcp_i_ebreak4excp  = (aluexcp_i_ebreak & ((~dbg_ebreakm_r) | dbg_mode));

    // The ebreak instruction will enter into the debug-mode when the ebreakm
    // bit of DCSR reg is set and core is not in dbg mode.
    wire aluexcp_i_ebreak4dbg   =  aluexcp_i_ebreak 
                                 & (~aluexcp_o_need_flush4excp)   // override by other alu exceptions
                                 & dbg_ebreakm_r 
                                 & (~dbg_mode);                   // Not in debug mode

    // By observing alu_ebreakm_flush_req , we can figure out if there is an ebreak wait for flush.
    assign aluexcp_o_ebreakm_flush_req  =  aluexcp_i_ebreak4dbg ; // jump to dbg entry address
  
    assign aluexcp_o_need_flush4excp = aluexcp_i_misalgn     |    // jump to excp entry address
                                       aluexcp_i_buserr      |
                                       aluexcp_i_ebreak4excp |
                                       aluexcp_i_ecall       |
                                       aluexcp_i_ifu_misalgn | 
                                       aluexcp_i_ifu_buserr  | 
                                       aluexcp_i_ifu_ilegl   |
                                       aluexcp_i_alu_err     ;

    // excp cause
    wire   aluexcp_flush_req_ld            = alu_excp_flush_req       & aluexcp_i_ld           ;
    wire   aluexcp_flush_req_stamo         = alu_excp_flush_req       & aluexcp_i_stamo        ;
    assign aluexcp_flush_req_ebreak        = alu_excp_flush_req       & aluexcp_i_ebreak4excp  ;
    wire   aluexcp_flush_req_ecall         = alu_excp_flush_req       & aluexcp_i_ecall        ;
    assign aluexcp_flush_req_ifu_misalgn   = alu_excp_flush_req       & aluexcp_i_ifu_misalgn  ;
    assign aluexcp_flush_req_ifu_buserr    = alu_excp_flush_req       & aluexcp_i_ifu_buserr   ;
    assign aluexcp_flush_req_ifu_ilegl     = alu_excp_flush_req       & aluexcp_i_ifu_ilegl    ;
    assign aluexcp_flush_req_alu_err       = alu_excp_flush_req       & aluexcp_i_alu_err      ;
    wire   aluexcp_flush_req_ld_misalgn    = aluexcp_flush_req_ld     & aluexcp_i_misalgn      ; // ALU load misalign
    wire   aluexcp_flush_req_ld_buserr     = aluexcp_flush_req_ld     & aluexcp_i_buserr       ; // ALU load bus error
    wire   aluexcp_flush_req_stamo_misalgn = aluexcp_flush_req_stamo  & aluexcp_i_misalgn      ; // ALU store/AMO misalign
    wire   aluexcp_flush_req_stamo_buserr  = aluexcp_flush_req_stamo  & aluexcp_i_buserr       ; // ALU store/AMO bus error

    // The excp was put forward by agu and lsu.
    wire aluexcp_flush_by_alu_agu        = aluexcp_flush_req_ld_misalgn    |
                                           aluexcp_flush_req_ld_buserr     |
                                           aluexcp_flush_req_stamo_misalgn |
                                           aluexcp_flush_req_stamo_buserr  ;

    wire [`XLEN-1:0] excp_cause;
    assign excp_cause[31:5] = 27'b0;
    assign excp_cause[4:0]  = aluexcp_flush_req_ifu_misalgn    ? 5'd0 : //Instruction address misaligned
                              aluexcp_flush_req_ifu_buserr     ? 5'd1 : //Instruction access fault
                              aluexcp_flush_req_ifu_ilegl      ? 5'd2 : //Illegal instruction
                              aluexcp_flush_req_ebreak         ? 5'd3 : //Breakpoint, only under dbg mode
                              aluexcp_flush_req_ld_misalgn     ? 5'd4 : //load address misalign
                              aluexcp_flush_req_ld_buserr      ? 5'd5 : //load access fault
                              aluexcp_flush_req_stamo_misalgn  ? 5'd6 : //Store/AMO address misalign
                              aluexcp_flush_req_stamo_buserr   ? 5'd7 : //Store/AMO access fault
                              aluexcp_flush_req_alu_err        ? 5'd8 : //ALU err (except err from agu)
                              aluexcp_flush_req_ecall & u_mode ? 5'd9 : //Environment call from U-mode
                              aluexcp_flush_req_ecall & s_mode ? 5'd10: //Environment call from S-mode
                              aluexcp_flush_req_ecall & h_mode ? 5'd11: //Environment call from H-mode
                              aluexcp_flush_req_ecall & m_mode ? 5'd12: //Environment call from M-mode
                                                                 5'h1F; //Otherwise a reserved value

    // organize output 
    assign aluexcp_o_flush_by_alu_agu = aluexcp_flush_by_alu_agu;
    assign aluexcp_o_excp_cause       = excp_cause;

endmodule
