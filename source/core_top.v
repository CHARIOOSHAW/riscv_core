
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
    input                                 extenal_interrupt ,
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
    wire                pc_vld_4irqexcp  ;
    wire [`PC_SIZE-1:0] mtvec_r          ;
    wire                exu_ifu_excp     ;  
    wire                rst_n_syn        ;

    ifu_top IFT (

        .ifu_i_pc_init_use        ( pc_init_use                 ), 
        .ifu_i_rv32               ( exu_ifu_rv32                ),
                             
        .ifu_o_ifu_valid          ( ifu_valid                   ),
        .ifu_i_exu_ready          ( exu_ready                   ),
                             
        .exu_ifu_i_pipe_flush_req ( pipe_flush_req              ),
        .exu_ifu_i_flush_pc       ( pipe_flush_pc               ),
                             
        .ifu_pc_nxt               (                             ),
        .ifu_pc_r                 ( PC_r                        ),
                             
        .ifu_ir_r                 ( ir_r                        ),
                                     
        .ifu_i_mtvec              ( mtvec_r                     ), 
        .ifu_i_interrupt          ( extenal_interrupt           ),
        .ifu_i_excp               ( exu_ifu_excp                ),
        .ifu_o_interrupt_ack      ( ext_int_ack                 ),
        .ifu_o_vld_4irqexcp       ( pc_vld_4irqexcp             ),
        .ifu_o_wbck_epc           ( epc_r                       ),
                             
        .clk                      ( clk                         ),
        .rst_n                    ( rst_n_syn                   )
    );


    //////////////////////////////////////////////////////////////////////////////
    // U2: exu
    // Description: exu controls the read procedure of instr and generate ifu_valid.
    //////////////////////////////////////////////////////////////////////////////

    exu_top EXT (
        .exu_i_instr               ( ir_r                       ),  
        .exu_i_pc                  ( PC_r                       ), 
        .exu_i_pc_vld_4irqexcp     ( pc_vld_4irqexcp            ),
        .pc_et_i_epc_r             ( epc_r                      ),

        .exu_i_ifu_valid           ( ifu_valid                  ),
        .exu_i_ifu_misalgn         ( 1'b0                       ),
        .exu_i_ifu_buserr          ( 1'b0                       ), 

        .dbg_mode                  ( 1'b0                       ),
        .dbg_ebreakm_r             ( 1'b1                       ),

        .u_mode                    ( 1'b0                       ), 
        .s_mode                    ( 1'b0                       ), 
        .h_mode                    ( 1'b0                       ), 
        .m_mode                    ( 1'b1                       ),

        .ext_irq_r                 ( ext_int_ack                ),
        .sft_irq_r                 ( 1'b0                       ),
        .tmr_irq_r                 ( 1'b0                       ),

        .exu_o_core_wfi            ( core_wfi                   ),
        .exu_o_exu_ready           ( exu_ready                  ),

        .exu_o_pipe_flush_req      ( pipe_flush_req             ),
        .exu_o_pipe_flush_pc       ( pipe_flush_pc              ), 
        .exu_o_unexpected_err      ( core_unexcp_err            ),
        .exu_o_mtvec_r             ( mtvec_r                    ),
        .exu_o_excp                ( exu_ifu_excp               ),

        .exu_o_rv32                ( exu_ifu_rv32               ),
        
        .clk                       ( clk                        ),
        .clk_aon                   ( clk_aon                    ),
        .rst_n                     ( rst_n_syn                  )
    );

    //////////////////////////////////////////////////////////////////////////////
    // U3: rst_syn
    // Description: external rst_n converter
    //////////////////////////////////////////////////////////////////////////////
    rst_syn_unit rsu(
      .clk                         ( clk                        ),
      .rst_n                       ( rst_n                      ),
    
      .rst_n_syn                   ( rst_n_syn                  )
    );




endmodule
