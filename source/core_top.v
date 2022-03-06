
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/09/23 11:22:26
// Design Name: 
// Module Name: core_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: core top is the top module of the whole design. It contains 
//                      ifu and exu.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"


module core_top(

    // pc initial
    input                                 pc_init_use       ,

    // external irq and core state
    input                                 external_interrupt ,
    output                                core_wfi          , 
    output                                core_unexcp_err   , 
    
    // clk and rst_n
    input                                 clk               ,
    input                                 clk_aon           ,
    input                                 rst_n  
    );


    //////////////////////////////////////////////////////////////////////////////
    // U1: ifu
    // Description: ifu controls the read procedure of instr and generate ifu_valid.
    //////////////////////////////////////////////////////////////////////////////
    wire                exu_ifu_rv32     ;
    wire                ifu_valid        ;
    wire                exu_ready        ;
  
    wire                pipe_flush_req   ;
    wire [`PC_SIZE-1:0] pipe_flush_pc    ;
  
    wire [`XLEN-1:0   ] ir_r             ;
    wire [`PC_SIZE-1:0] PC_r             ;
  
    wire                ext_int_ack      ;
    wire [`PC_SIZE-1:0] epc_r            ;
    wire [`PC_SIZE-1:0] mtvec_r          ;
    wire                exu_ifu_excp     ;  
    wire                rst_n_syn        ;
    wire                exu_bjp_flush_req;
    wire                core_top_irq_req ;
    wire                ita_ifu_int_pending_flag;

    ifu_top IFT (

        .ifu_i_pc_init_use        ( pc_init_use                 ), 
        .ifu_i_rv32               ( exu_ifu_rv32                ),
                             
        .ifu_o_ifu_valid          ( ifu_valid                   ),
        .ifu_i_exu_ready          ( exu_ready                   ),
                             
        .exu_ifu_i_pipe_flush_req ( pipe_flush_req              ),
        .ifu_i_bjp_flush_req      ( exu_bjp_flush_req           ),
        .ifu_i_bjp_flush_pc       ( pipe_flush_pc               ),
                             
        .ifu_pc_nxt               (                             ),
        .ifu_pc_r                 ( PC_r                        ),
                             
        .ifu_ir_r                 ( ir_r                        ),
                                     
        .ifu_i_mtvec              ( mtvec_r                     ), 
        .ifu_i_irq_req            ( core_top_irq_req            ),
        .ifu_i_int_pending_flag   ( ita_ifu_int_pending_flag    ),
        .ifu_i_excp               ( exu_ifu_excp                ),
        .ifu_o_wbck_epc           ( epc_r                       ),
                             
        .clk                      ( clk                         ),
        .rst_n                    ( rst_n_syn                   )
    );


    //////////////////////////////////////////////////////////////////////////////
    // U2: exu
    // Description: exu controls the read procedure of instr and generate ifu_valid.
    //////////////////////////////////////////////////////////////////////////////
    wire                  ita_exu_ready    ;
    wire [`XLEN-1:0     ] ita_exu_rdata    ;
    wire                  exu_ita_valid    ;
    wire [`PC_SIZE-1:0  ] exu_ita_addr     ;
    wire                  exu_ita_wr       ;
    wire                  exu_ita_rd       ;
    wire [`XLEN-1:0     ] exu_ita_wdata    ;

    wire                  ita_exu_tmr_int  ;   
    wire                  ita_exu_sft_int  ;
    wire                  ita_exu_ext_int  ;

    wire                  ita_exu_mtip     ;
    wire                  ita_exu_msip     ;
    wire                  ita_exu_meip     ;

    exu_top EXT (
        .exu_i_instr               ( ir_r                       ),  
        .exu_i_pc                  ( PC_r                       ), 
        .pc_et_i_epc_r             ( epc_r                      ),

        .exu_i_ifu_valid           ( ifu_valid                  ),
        .exu_i_ifu_misalgn         ( 1'b0                       ),
        .exu_i_ifu_buserr          ( 1'b0                       ), 

        .dbg_mode                  ( 1'b0                       ),

        .u_mode                    ( 1'b0                       ), 
        .s_mode                    ( 1'b0                       ), 
        .h_mode                    ( 1'b0                       ), 
        .m_mode                    ( 1'b1                       ),
       
        ///////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////
        .exu_i_ita_meip            ( ita_exu_meip               ),
        .exu_i_ita_msip            ( ita_exu_msip               ),
        .exu_i_ita_mtip            ( ita_exu_mtip               ),

        .exu_i_ita_ext_irq         ( ita_exu_ext_int            ),
        .exu_i_ita_sft_irq         ( ita_exu_sft_int            ),
        .exu_i_ita_tmr_irq         ( ita_exu_tmr_int            ),

        .exu_o_ita_wr              ( exu_ita_wr                 ),
        .exu_o_ita_rd              ( exu_ita_rd                 ), 
        .exu_o_ita_wdata           ( exu_ita_wdata              ), 
        .exu_o_ita_addr            ( exu_ita_addr               ), 
        .exu_o_ita_valid           ( exu_ita_valid              ), 
        .exu_i_ita_rdata           ( ita_exu_rdata              ), 
        .exu_i_ita_ready           ( ita_exu_ready              ), 

        /////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////

        .exu_o_core_wfi            ( core_wfi                    ),
        .exu_o_exu_ready           ( exu_ready                   ),

        .exu_o_pipe_flush_req      ( pipe_flush_req              ),
        .exu_o_pipe_flush_pc       ( pipe_flush_pc               ), 
        .exu_o_bjp_flush_req       ( exu_bjp_flush_req           ),

        .exu_o_unexpected_err      ( core_unexcp_err             ),
        .exu_o_mtvec_r             ( mtvec_r                     ),
        .exu_o_excp                ( exu_ifu_excp                ),
        .exu_o_pc_irq_req          ( core_top_irq_req            ),
        
        .exu_o_rv32                ( exu_ifu_rv32                ),
        
        .clk                       ( clk                         ),
        .clk_aon                   ( clk_aon                     ),
        .rst_n                     ( rst_n_syn                   )
    );

    
    /////////////////////////////////////////////////////////////////
    // U3: rst_syn
    // Description: external rst_n converter
    /////////////////////////////////////////////////////////////////
    rst_syn_unit rsu(
        .clk                         ( clk                        ),
        .rst_n                       ( rst_n                      ),
    
        .rst_n_syn                   ( rst_n_syn                  )
    );


    /////////////////////////////////////////////////////////////////
    // U4: intagent
    // Description: generate irq signals
    /////////////////////////////////////////////////////////////////
    intagent ita(

        .ita_csr_mtip                ( ita_exu_mtip               ),
        .ita_csr_msip                ( ita_exu_msip               ),
        .ita_csr_meip                ( ita_exu_meip               ),
        
        .ita_tmr_int                 ( ita_exu_tmr_int            ),
        .ita_sft_int                 ( ita_exu_sft_int            ),
        .ita_ext_int                 ( ita_exu_ext_int            ),
                                                                   
        .ita_i_exu_wr                ( exu_ita_wr                 ),
        .ita_i_exu_rd                ( exu_ita_rd                 ),
        .ita_i_exu_wdata             ( exu_ita_wdata              ),
        .ita_i_exu_addr              ( exu_ita_addr               ),
        .ita_i_exu_valid             ( exu_ita_valid              ),
                                                                   
        .ita_o_exu_rdata             ( ita_exu_rdata              ),
        .ita_o_exu_ready             ( ita_exu_ready              ),        
                                                                   
        .ita_i_bjp_req_flush         ( exu_bjp_flush_req          ),
        .ita_o_int_pending_flag      ( ita_ifu_int_pending_flag   ),
                                                                                                                
        .ita_i_external_int          ( external_interrupt         ),
                                                                   
        .clk_mtime                   ( clk_aon                    ),
        .clk                         ( clk                        ),
        .rst_n                       ( rst_n_syn                  )
    );

    
endmodule
