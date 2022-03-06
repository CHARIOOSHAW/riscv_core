
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/08/05 12:00:41
// Design Name: 
// Module Name: commit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Commit unit is used to control the excp unit and directly 
//                      order the wbck unit.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module commit(

    // cmt input
    input                            cmt_i_ifu_valid       , // valid is from ifu
    input                            cmt_i_exu_ready       , // ready is used to control wbck. outside ready is not controlled by this. outside ready is used to control PC and IR.

    input  [`PC_SIZE-1:0           ] cmt_i_pc              ,  
    input  [`INSTR_SIZE-1:0        ] cmt_i_instr           ,  
    input                            cmt_i_wfi_halt_ack    , // from GC

    // bjp inputs
    input                            cmt_i_bjp_need_flush  ,
    input  [`PC_SIZE-1:0           ] cmt_i_bjp_flush_PC    ,
    input                            cmt_i_bjp_mret        ,

    // address csr input 
    input  [`PC_SIZE-1:0           ] pc_cmt_i_epc_r        ,
    input  [`XLEN-1:0              ] csr_mtvec_r           ,
            
    // mode input - m mode only now            
    input                            u_mode                ,
    input                            s_mode                ,
    input                            h_mode                ,
    input                            m_mode                ,
  
    // dbg status input  
    input                            dbg_mode              ,

    // int fence status  
    input                            status_mie_r          ,
    output                           commit_irq_req        ,
    input                            mtie_r                ,
    input                            msie_r                ,
    input                            meie_r                ,
  

    // int input signals
    input                            cmt_i_ita_ext_irq     ,
    input                            cmt_i_ita_sft_irq     ,
    input                            cmt_i_ita_tmr_irq     ,

    // ALU exception
    input                            alu_cmt_i_wfi         ,
    input                            alu_cmt_i_ecall       ,
    input                            alu_cmt_i_ifu_misalgn ,
    input                            alu_cmt_i_ifu_buserr  ,
    input                            alu_cmt_i_ifu_ilegl   ,
    input                            alu_cmt_i_alu_err     ,

    // The AGU Exception 
    input                            alu_cmt_i_misalgn     , // The misalign exception generated
    input                            alu_cmt_i_ld          ,
    input                            alu_cmt_i_stamo       ,
    input                            alu_cmt_i_buserr      , // The bus-error exception generated
    input   [`ADDR_SIZE-1:0        ] cmt_i_badaddr         ,
 
 
    // cmt interface for csr
    output  [`ADDR_SIZE-1:0        ] cmt_badaddr           ,
    output                           cmt_badaddr_ena       ,
    output  [`PC_SIZE-1:0          ] cmt_epc               ,
    output                           cmt_epc_ena           ,
    output  [`XLEN-1:0             ] cmt_cause             ,
    output                           cmt_cause_ena         ,
    output                           cmt_instret_ena       , // generate by cmt top
    output                           cmt_status_ena        ,

    // cmt output 
    output                           cmt_commit_trap       ,
    output                           pipe_flush_req        ,
    output  [`PC_SIZE-1:0          ] pipe_flush_pc         ,  
    output                           core_wfi              ,
    output                           cmt_mret_ena          ,
    output                           cmt_bjp_flush_req     ,

    input                            clk                   ,
    input                            rst_n
    );

    wire                 excpirq_flush_req           ;
    wire [`PC_SIZE-1:0 ] excpirq_flush_addr          ;

    // cmt related enable
    wire   cmt_ena               = cmt_i_ifu_valid & cmt_i_exu_ready;        // when both valid and ready are set, core have to decide whether commit or not.

    // commit signals
    assign pipe_flush_req        = excpirq_flush_req | cmt_i_bjp_need_flush; // pipeline need to be flushed because of irq/excp/jump-instrs.
    assign pipe_flush_pc         = excpirq_flush_req ? excpirq_flush_addr : cmt_i_bjp_flush_PC;  

    assign cmt_instret_ena       = cmt_ena & (~excpirq_flush_req);           // stop counting when meet excp and irq flush.

    assign cmt_mret_ena          = cmt_ena & cmt_i_bjp_mret;                 // mret, ready to entry machine mode.

    assign cmt_bjp_flush_req     = cmt_i_bjp_need_flush;


    // excp unit
    exu_excp_top u_exu_excp(

        .excp_top_i_epc               ( pc_cmt_i_epc_r                  ),
          
        .excp_top_i_badaddr           ( cmt_i_badaddr                   ), // illegal ld or store address
        .excp_top_i_pc                ( cmt_i_pc                        ),
        .excp_top_i_instr             ( cmt_i_instr                     ),
                    
        .excpirq_flush_req            ( excpirq_flush_req               ),
        .excpirq_flush_addr           ( excpirq_flush_addr              ),
        .excp_top_o_commit_trap       ( cmt_commit_trap                 ),

        // wfi output 
        .core_wfi                     ( core_wfi                        ),     
        .wfi_halt_ack                 ( cmt_i_wfi_halt_ack              ),      
        
        // exception type
        .alu_excp_i_wfi               ( alu_cmt_i_wfi                   ),
        .alu_excp_i_ld                ( alu_cmt_i_ld                    ),
        .alu_excp_i_stamo             ( alu_cmt_i_stamo                 ),
        .alu_excp_i_misalgn           ( alu_cmt_i_misalgn               ),
        .alu_excp_i_buserr            ( alu_cmt_i_buserr                ),
        .alu_excp_i_ecall             ( alu_cmt_i_ecall                 ),
        .alu_excp_i_ifu_misalgn       ( alu_cmt_i_ifu_misalgn           ),
        .alu_excp_i_ifu_buserr        ( alu_cmt_i_ifu_buserr            ),
        .alu_excp_i_ifu_ilegl         ( alu_cmt_i_ifu_ilegl             ),
        .alu_excp_i_alu_err           ( alu_cmt_i_alu_err               ),
              
        // int input signals
        .exu_excp_ext_irq             ( cmt_i_ita_ext_irq               ),
        .exu_excp_sft_irq             ( cmt_i_ita_sft_irq               ),
        .exu_excp_tmr_irq             ( cmt_i_ita_tmr_irq               ),
        .excp_top_irq_req             ( commit_irq_req                  ), // to pc

        // int fence status
        .status_mie_r                 ( status_mie_r                    ),
        .mtie_r                       ( mtie_r                          ),
        .msie_r                       ( msie_r                          ),
        .meie_r                       ( meie_r                          ),
              
        // private mode 
        .u_mode                       ( u_mode                          ),
        .s_mode                       ( s_mode                          ),
        .h_mode                       ( h_mode                          ),
        .m_mode                       ( m_mode                          ),
              
        // csr cmt interface
        .csr_mtvec_r                  ( csr_mtvec_r                     ),
        .cmt_badaddr                  ( cmt_badaddr                     ),
        .cmt_badaddr_ena              ( cmt_badaddr_ena                 ),
        .cmt_epc                      ( cmt_epc                         ),
        .cmt_epc_ena                  ( cmt_epc_ena                     ),
        .cmt_cause                    ( cmt_cause                       ),
        .cmt_cause_ena                ( cmt_cause_ena                   ),
        .cmt_status_ena               ( cmt_status_ena                  ),
              
        // dbg status
        .dbg_mode                     ( dbg_mode                        ),

        .clk                          ( clk                             ),
        .rst_n                        ( rst_n                           )
    );

endmodule
