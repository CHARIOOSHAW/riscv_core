
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/07/23 14:15:08
// Design Name: 
// Module Name: exu_excp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: expc is used to detect the interrupt and aberrant. exu_excp is the top 
//                      module of excp unit.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module exu_excp_top(
    /////////////////////////////////////////////////////////////////////////////
    // input from PC unit which generate epc and pc_vld.
    input [`PC_SIZE-1:0           ] excp_top_i_epc         , // from PC
    input                           excp_i_pc_vld_4irqexcp ,

    ////////////////////////////////////////////////////////////////////////////
    // input from exu_top and output to exu_top
    output                          excpirq_flush_req      ,
    output [`PC_SIZE-1:0          ] excpirq_flush_addr     ,  
    output                          commit_trap            ,
  
    /////////////////////////////////////////////////////////////////////////////
    // illegal related information for ifu or decoder
    input [`ADDR_SIZE-1:0         ] excp_top_i_badaddr     ,
    input [`PC_SIZE-1:0           ] excp_top_i_pc          ,
    input [`INSTR_SIZE-1:0        ] excp_top_i_instr       ,

    //////////////////////////////////////////////////////////////////////////////
    // core wfi stage
    output                          core_wfi               ,

    //////////////////////////////////////////////////////////////////////////////
    // halt signal ack from exu.
    input                           wfi_halt_ack           , // from GC

    //////////////////////////////////////////////////////////////////////////////
    // input from alu and decoder
    input                           alu_excp_i_wfi         , // This is a wfi instr.
    input                           alu_excp_i_ld          ,
    input                           alu_excp_i_stamo       ,
    input                           alu_excp_i_misalgn     ,
    input                           alu_excp_i_buserr      ,
    input                           alu_excp_i_ecall       ,
    input                           alu_excp_i_ebreak      ,
    input                           alu_excp_i_ifu_misalgn ,
    input                           alu_excp_i_ifu_buserr  ,
    input                           alu_excp_i_ifu_ilegl   ,
    input                           alu_excp_i_alu_err     ,

    //////////////////////////////////////////////////////////////////////////////
    // irq unit related input 
    input                           ext_irq_r              ,
    input                           sft_irq_r              ,
    input                           tmr_irq_r              , 

    input                           status_mie_r           ,
    input                           mtie_r                 ,
    input                           msie_r                 ,
    input                           meie_r                 ,
    output                          excp_top_irq_req       , // to PC.v, fenced irq.

    ///////////////////////////////////////////////////////////////////////////////
    // core mode
    input                           u_mode                 ,
    input                           s_mode                 ,
    input                           h_mode                 ,
    input                           m_mode                 ,
                 
    //////////////////////////////////////////////////////////////////////////////
    // cmt output interface
    input   [`XLEN-1:0            ] csr_mtvec_r            ,
    output  [`ADDR_SIZE-1:0       ] cmt_badaddr            ,
    output                          cmt_badaddr_ena        ,
    output  [`PC_SIZE-1:0         ] cmt_epc                , 
    output                          cmt_epc_ena            ,
    output  [`XLEN-1:0            ] cmt_cause              ,
    output                          cmt_cause_ena          ,
    output                          cmt_status_ena         ,

    ///////////////////////////////////////////////////////////////////////////////
    // dbg state signal
    input                           dbg_mode               ,
    input                           dbg_ebreakm_r          ,
    

    input                           clk                    ,
    input                           rst_n

    );

    // Additional Comments:
    // Generally, the excp can be further improved. One direction is the excution of excp should wait for 
    // the finish of multi-cycle instrs. To improve the excution speed, we can kill the multi-cycle instrs
    // as long as we detect excp and set ready.

    //////////////////////////////////////////////////////////////////////////////////////////////////////
    // excp top signals 
    //////////////////////////////////////////////////////////////////////////////////////////////////////

    // dbg entry flush req and dbg ready signals
    wire   excp_top_alu_excp_i_ready4dbg  = excp_i_pc_vld_4irqexcp;

    // irq and excp flush req    
    // irq gain the periority.
    // excp or irq is put forward, but valid remains to be examed. 
    wire   excp_top_alu_need_flush     ;
    wire   excp_top_ebreakm_flush_req  ;
                    
    wire   excp_top_alu_excp_flush_req    =  excp_top_alu_need_flush & (~excp_top_irq_req);
    assign excpirq_flush_req              =  excp_top_irq_req  | excp_top_alu_excp_flush_req;
 
    wire   excpirq_taken_ena              =  excpirq_flush_req & excp_i_pc_vld_4irqexcp;             // exam the valid.
    assign commit_trap                    =  excpirq_taken_ena;                                      // when excp and irq happened, the cmt will be blocked and the result will be wasted.
  
    wire   excp_taken_ena                 =  excp_top_alu_excp_flush_req  & excpirq_taken_ena; 
    wire   irq_taken_ena                  =  excp_top_irq_req  & excpirq_taken_ena;
    wire   breakm_taken_ena               =  excp_top_ebreakm_flush_req   & excp_i_pc_vld_4irqexcp;

    // 800 dbg entry address; 808 dbg trap address; mtvec non-dbg trap address.
    assign excpirq_flush_addr             =  breakm_taken_ena? `PC_SIZE'h800: (excp_top_alu_excp_flush_req & dbg_mode)? `PC_SIZE'h808 : csr_mtvec_r;
    

    ///////////////////////////////////////////////////////////////////////////////////////
    // U1 : excp_irq
    // Describe : irq enable control unit
    ///////////////////////////////////////////////////////////////////////////////////////
    wire             excp_top_wfi_irq_req   ;
    wire [`XLEN-1:0] excp_top_irq_cause     ;
    wire             excp_top_wfi_flag_r    ;

    excp_irq exu_excp_irq_unit (
        .clk                              ( clk                                    ),
        .dbg_mode                         ( dbg_mode                               ),
                        
        .ext_irq_r                        ( ext_irq_r                              ),
        .sft_irq_r                        ( sft_irq_r                              ),
        .tmr_irq_r                        ( tmr_irq_r                              ),
                        
        .status_mie_r                     ( status_mie_r                           ),
        .meie_r                           ( mtie_r                                 ),
        .msie_r                           ( msie_r                                 ),
        .mtie_r                           ( meie_r                                 ),
                        
        .irq_i_wfi_flag_r                 ( excp_top_wfi_flag_r                    ), // wfi flag from excp_wfi
                        
        .irq_o_irq_req_active             (                                        ), // active signal for excp_wfi
        .irq_o_irq_req                    ( excp_top_irq_req                       ), // irq_req for excp_top
        .irq_o_wfi_irq_req                ( excp_top_wfi_irq_req                   ), // wfi irq for excp_wfi
        .irq_o_irq_cause                  ( excp_top_irq_cause                     )  // excp_cause for excp_cmt_csr
    );

    ////////////////////////////////////////////////////////////////////////////////////////
    // U2 : excp_wfi
    // Descibe: wfi unit will control the state of CPU core.
    ///////////////////////////////////////////////////////////////////////////////////////
    excp_wfi exu_excp_wfi_unit (
        .wfi_i_irq_req                    ( excp_top_wfi_irq_req                   ), // int for wfi exit 
        
        .excp_i_alu_wfi                   ( alu_excp_i_wfi                         ), // wfi indicator from input
        .wfi_i_wfi_halt_ack               ( wfi_halt_ack                           ), // wfi halt ack from GC
        
        .wfi_o_wfi_flag_r                 ( excp_top_wfi_flag_r                    ), // core wfi flag 
        .wfi_o_core_wfi                   ( core_wfi                               ), // core is in wfi state now and nxt cycle
        
        .clk                              ( clk                                    ),
        .rst_n                            ( rst_n                                  )
    );

    ////////////////////////////////////////////////////////////////////////////////////////
    // U3 : excp_aluexcp
    // Descibe: aluexcp will help handle the excp and organize data for csr commit. 
    ///////////////////////////////////////////////////////////////////////////////////////
    wire             excp_top_flush_by_alu_agu              ;
    wire [`XLEN-1:0] excp_top_excp_cause                    ;

    wire             aluexcp_flush_req_ifu_misalgn          ;
    wire             aluexcp_flush_req_ifu_buserr           ;
    wire             aluexcp_flush_req_ifu_ilegl            ;
    wire             aluexcp_flush_req_ebreak               ;

    excp_aluexcp exu_excp_aluexcp_unit (
        .dbg_ebreakm_r                    ( dbg_ebreakm_r                          ), // get from dbg unit through input 
        .dbg_mode                         ( dbg_mode                               ),
                                    
        .alu_excp_flush_req               ( excp_top_alu_excp_flush_req            ), // flush req from exu_excp top
        .aluexcp_i_alu_err                ( alu_excp_i_alu_err                     ),
        .aluexcp_i_ebreak                 ( alu_excp_i_ebreak                      ),
        .aluexcp_i_misalgn                ( alu_excp_i_misalgn                     ),
        .aluexcp_i_buserr                 ( alu_excp_i_buserr                      ),
        .aluexcp_i_ecall                  ( alu_excp_i_ecall                       ),
        .aluexcp_i_ifu_misalgn            ( alu_excp_i_ifu_misalgn                 ),
        .aluexcp_i_ifu_buserr             ( alu_excp_i_ifu_buserr                  ),
        .aluexcp_i_ifu_ilegl              ( alu_excp_i_ifu_ilegl                   ),
        .aluexcp_i_ld                     ( alu_excp_i_ld                          ), 
        .aluexcp_i_stamo                  ( alu_excp_i_stamo                       ), 
                                    
        .u_mode                           ( u_mode                                 ),
        .s_mode                           ( s_mode                                 ),
        .h_mode                           ( h_mode                                 ),
        .m_mode                           ( m_mode                                 ),

        .aluexcp_o_ebreakm_flush_req      ( excp_top_ebreakm_flush_req             ), // ebreakm will be handled with dbg
        .aluexcp_o_need_flush4excp        ( excp_top_alu_need_flush                ), // flush indicator to exu_excp top

        .aluexcp_o_flush_by_alu_agu       ( excp_top_flush_by_alu_agu              ), 
        .aluexcp_o_excp_cause             ( excp_top_excp_cause                    ),  // excp cause to cmt_csr unit

        .aluexcp_flush_req_ifu_misalgn    ( aluexcp_flush_req_ifu_misalgn          ),
        .aluexcp_flush_req_ifu_buserr     ( aluexcp_flush_req_ifu_buserr           ),
        .aluexcp_flush_req_ifu_ilegl      ( aluexcp_flush_req_ifu_ilegl            ),
        .aluexcp_flush_req_ebreak         ( aluexcp_flush_req_ebreak               )
    );

    ////////////////////////////////////////////////////////////////////////////////////////
    // U4 : excp_cmt_csr
    // Descibe: cmt_csr is used to organize the data for csr upgrade. 
    ///////////////////////////////////////////////////////////////////////////////////////
    excp_cmt_csr exu_excp_cmt_csr_unit (
        .dbg_mode                        ( dbg_mode                                ),
        .excp_top_vld_4irqexcp           ( excp_i_pc_vld_4irqexcp                  ),
                                         
        .excpirq_flush_req               ( excpirq_flush_req                       ), // get from exu_excp top
        .excpcmt_i_excp_taken_ena        ( excp_taken_ena                          ),
        .excpcmt_i_irq_taken_ena         ( irq_taken_ena                           ),
                                         
        .excpcmt_i_flush_by_alu_agu      ( excp_top_flush_by_alu_agu               ),
        .excpcmt_i_flush_req_ebreak      ( aluexcp_flush_req_ebreak                ), // from aluexcp
        .excpcmt_i_flush_req_ifu_misalgn ( aluexcp_flush_req_ifu_misalgn           ),
        .excpcmt_i_flush_req_ifu_buserr  ( aluexcp_flush_req_ifu_buserr            ),
        .excpcmt_i_flush_req_ifu_ilegl   ( aluexcp_flush_req_ifu_ilegl             ),
                             
        .excpcmt_i_epc                   ( excp_top_i_epc                          ),
                                        
        .excpcmt_i_excp_cause            ( excp_top_excp_cause                     ),
        .excpcmt_i_irq_cause             ( excp_top_irq_cause                      ),

        .excpcmt_i_badaddr               ( excp_top_i_badaddr                      ), // badaddr: illegal mem access addr 
        .excpcmt_i_pc                    ( excp_top_i_pc                           ), // pc: return pc when excp 
        .excpcmt_i_instr                 ( excp_top_i_instr                        ), // instr: return instr when illegal instrs
                                        
        .excpcmt_o_cause_ena             ( cmt_cause_ena                           ),
        .excpcmt_o_cause                 ( cmt_cause                               ),
                                        
        .excpcmt_o_badaddr_ena           ( cmt_badaddr_ena                         ),
        .excpcmt_o_badaddr               ( cmt_badaddr                             ),
                                        
        .excpcmt_o_epc_ena               ( cmt_epc_ena                             ),
        .excpcmt_o_epc                   ( cmt_epc                                 ),
                                        
        .excpcmt_o_status_ena            ( cmt_status_ena                          )
    );


endmodule









