
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/09/08 15:49:28
// Design Name: 
// Module Name: exu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: The top of whole exu, including:
//                      1. RF    
//                      2. DC
//                      3. MC
//                      4. ALU                         
//                      5. MEMT
//                      6. CMT
//                      7. WBCK
//                      8. CSR
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module exu_top(

    // pc and instr related
    input [`XLEN-1:0             ] exu_i_instr          ,  
    input [`PC_SIZE-1:0          ] exu_i_pc             , 
    input                          exu_i_pc_vld_4irqexcp,
    input [`XLEN-1:0             ] pc_et_i_epc_r        ,
    
    // ifu related
    input                          exu_i_ifu_valid      ,
    input                          exu_i_ifu_misalgn    ,
    input                          exu_i_ifu_buserr     , 
    
    // cmt related
    input                          dbg_mode             ,
    input                          dbg_ebreakm_r        ,

    input                          u_mode               , 
    input                          s_mode               , 
    input                          h_mode               , 
    input                          m_mode               ,

    input                          ext_irq_r            ,
    input                          sft_irq_r            ,
    input                          tmr_irq_r            ,

    // wfi
    output                         exu_o_core_wfi       ,

    // ready
    output                         exu_o_exu_ready      ,

    // exu -> ifu, flush req
    output                         exu_o_pipe_flush_req ,
    output [`PC_SIZE-1:0         ] exu_o_pipe_flush_pc  ,
    output [`PC_SIZE-1:0         ] exu_o_mtvec_r        ,
    output                         exu_o_excp           ,

    // err
    output                         exu_o_unexpected_err ,

    // ins length
    output                         exu_o_rv32           ,

    input                          clk                  ,
    input                          clk_aon              ,
    input                          rst_n
    );

    ////////////////////////////////////////////////////////////////////////////
    // U1: RF
    // Describe: The direct store unit of exu. 
    // Connect : RF -> DECODER WBCK -> RF
    ////////////////////////////////////////////////////////////////////////////
    wire [`XLEN-1:0           ] exu_read_src1_data ;
    wire [`XLEN-1:0           ] exu_read_src2_data ;
    wire [`RFIDX_WIDTH-1:0    ] exu_dec_rs1idx     ;
    wire [`RFIDX_WIDTH-1:0    ] exu_dec_rs2idx     ;

    wire                        exu_wbck_rf_ena    ;
    wire [`XLEN-1:0           ] exu_wbck_rf_wdata  ;
    wire [`RFIDX_WIDTH-1:0    ] exu_wbck_rf_rdidx  ;

    regfile RF (
        .read_src1_idx  ( exu_dec_rs1idx             ),
        .read_src2_idx  ( exu_dec_rs2idx             ),

        .read_src1_data ( exu_read_src1_data         ),
        .read_src2_data ( exu_read_src2_data         ),

        .wbck_dest_wen  ( exu_wbck_rf_ena            ),
        .wbck_dest_idx  ( exu_wbck_rf_rdidx          ),
        .wbck_dest_data ( exu_wbck_rf_wdata          ),

        .clk            ( clk                        )
        );

    // op for alu
    wire                        exu_dec_rs1en      ;
    wire                        exu_dec_rs2en      ;
    wire [`XLEN-1:0           ] exu_rf_op1 = exu_dec_rs1en? exu_read_src1_data: `XLEN'd0;
    wire [`XLEN-1:0           ] exu_rf_op2 = exu_dec_rs2en? exu_read_src2_data: `XLEN'd0;

    ///////////////////////////////////////////////////////////////////////////
    // U2: DECODER
    // Describe: The decoder of exu. 
    // Connect : DC -> ALU 
    ////////////////////////////////////////////////////////////////////////////
    // RF inter-connect signals
    wire                        exu_dec_rdwen      ;
    wire [`RFIDX_WIDTH-1:0    ] exu_dec_rdidx      ;
     
    // decoder info signals     
    wire                        exu_dec_rv32       ;
    wire [`DECINFO_WIDTH-1:0  ] exu_dec_info       ;
    wire [`XLEN-1:0           ] exu_dec_imm        ;
     
    // dec error signals     
    wire                        exu_dec_misalgn    ;
    wire                        exu_dec_buserr     ;
    wire                        exu_dec_ilegl      ;

    // dec ldst instrs
    wire                        exu_dec_ld         ;
    wire                        exu_dec_st         ;

    // dec csrrw
    wire                        exu_dec_csrrw      ;

    // dec pc cycle
    wire [`MAX_DELAY_WIDTH-1:0] exu_dec_pc_cycle   ;

    assign exu_o_rv32         = exu_dec_rv32       ;

    decoder DC (
        .i_instr         ( exu_i_instr                ), 
        .i_pc            ( exu_i_pc                   ), 

        .i_misalgn       ( exu_i_ifu_misalgn          ), 
        .i_buserr        ( exu_i_ifu_buserr           ), 
        .dbg_mode        ( dbg_mode                   ),

        .dec_rs1en       ( exu_dec_rs1en              ),
        .dec_rs2en       ( exu_dec_rs2en              ),
        .dec_rdwen       ( exu_dec_rdwen              ),
        .dec_rs1idx      ( exu_dec_rs1idx             ),
        .dec_rs2idx      ( exu_dec_rs2idx             ),
        .dec_rdidx       ( exu_dec_rdidx              ),

        .dec_rv32        ( exu_dec_rv32               ),
        .dec_info        ( exu_dec_info               ), 
        .dec_imm         ( exu_dec_imm                ),

        // ifu errors
        .dec_misalgn     ( exu_dec_misalgn            ),
        .dec_buserr      ( exu_dec_buserr             ),
        .dec_ilegl       ( exu_dec_ilegl              ),

        .dec_ld          ( exu_dec_ld                 ),
        .dec_store       ( exu_dec_st                 ),
        .dec_csrrw       ( exu_dec_csrrw              ),

        .dec_pc_cycle    ( exu_dec_pc_cycle           )
    );

    ///////////////////////////////////////////////////////////////////////////
    // U3: multi_counter
    // Describe: The exu ready controller.
    // Connect : DC -> MC, MC -> TOP
    ////////////////////////////////////////////////////////////////////////////
    // wire                        exu_o_exu_ready    ; // exu ready
    wire [`MAX_DELAY_WIDTH-1:0  ] exu_pc_cycle_count ;
    wire                          exu_mc_delay_err   ;
    assign exu_o_unexpected_err = exu_mc_delay_err   ;

    wire                          memtop_o_ready     ;
    wire                          memtop_i_valid     ;


    multi_counter MC (
        .mc_i_pc_cycle   ( exu_dec_pc_cycle           ),
        .mc_i_ifu_valid  ( exu_i_ifu_valid            ),
                                    
        .mc_o_delay_err  ( exu_mc_delay_err           ),
        .mc_o_exu_ready  ( exu_o_exu_ready            ),
        .count_t         ( exu_pc_cycle_count         ),

        .memtop_enable   ( memtop_i_valid             ),
        .memtop_ready    ( memtop_o_ready             ),
                            
        .clk             ( clk                        ),
        .rst_n           ( rst_n                      )
    );



    ///////////////////////////////////////////////////////////////////////////
    // U4: ALU
    // Describe: The direct handle unit. 
    // Connect : AU -> MEMT
    //           AU -> CMT
    //           AU -> CSR 
    ////////////////////////////////////////////////////////////////////////////

    // alu - memtop signals
    wire                          exu_agu_cmd_read         ;  
    wire                          exu_agu_cmd_write        ;  
    wire                          exu_agu_cmd_usign        ;  
    wire [1:0                   ] exu_agu_cmd_size         ;     
    wire [`PC_SIZE-1:0          ] exu_agu_cmd_addr         ;  
    wire [`XLEN-1:0             ] exu_agu_cmd_wdata        ;  
    wire [`XLEN/8-1:0           ] exu_agu_cmd_wmask        ;  
    wire                          exu_agu_cmd_misalgn      ;  
  
    wire [`XLEN-1:0             ] exu_memt_agu_wbck_wdata  ;
    wire                          exu_memt_agu_wbck_err    ;
  
    wire                          exu_ralu_cmt_ecall       ;
    wire                          exu_ralu_cmt_ebreak      ;
    wire                          exu_ralu_cmt_wfi         ;

    wire                          exu_alu_bjp_cmt_bjp      ;
    wire                          exu_alu_bjp_cmt_mret     ;
    wire                          exu_alu_bjp_cmt_needflush;
    wire [`PC_SIZE-1:0          ] exu_alu_bjp_req_flush_pc ;

    wire                          exu_alu_csr_cmd_wr_en    ;
    wire                          exu_alu_csr_cmd_rd_en    ;
    wire [`CSR_IDX_WIDTH-1:0    ] exu_alu_csr_cmd_idx      ;
    wire [`XLEN-1:0             ] exu_alu_csr_cmd_wdata    ;
    wire [`XLEN-1:0             ] exu_alu_csr_cmd_rdata    ;
    wire [`PC_SIZE-1:0          ] exu_csr_epc_r            ;
    wire                          exu_csr_access_ilgl      ;

    wire                          exu_alu_err              ;
    wire [`XLEN-1:0             ] exu_wbck_wdata           ;


    alu_top AU (

        .alu_i_rs1              ( exu_rf_op1                      ),
        .alu_i_rs2              ( exu_rf_op2                      ),
        .alu_i_imm              ( exu_dec_imm                     ),
        .alu_i_info             ( exu_dec_info                    ),
        .alu_i_pc_cycle         ( exu_pc_cycle_count              ), // this pc_cycle is means cycle count rather than dec_pc_cycle
        .alu_i_pc_r             ( exu_i_pc                        ),

        // agu                                
        .alu_agu_cmd_enable     ( exu_agu_cmd_enable              ),
        .alu_agu_cmd_read       ( exu_agu_cmd_read                ),
        .alu_agu_cmd_write      ( exu_agu_cmd_write               ),
        .alu_agu_cmd_usign      ( exu_agu_cmd_usign               ),
        .alu_agu_cmd_size       ( exu_agu_cmd_size                ),
        .alu_agu_cmd_addr       ( exu_agu_cmd_addr                ),
        .alu_agu_cmd_wdata      ( exu_agu_cmd_wdata               ),
        .alu_agu_cmd_wmask      ( exu_agu_cmd_wmask               ),
        .alu_agu_cmd_misalgn    ( exu_agu_cmd_misalgn             ),
        .alu_memtop_wback_err   ( exu_memt_agu_wbck_err           ), // memtop to agu
        .alu_memtop_wback_data  ( exu_memt_agu_wbck_wdata         ), // memtop to agu
                                        
        // ralu - cmt                               
        .alu_ralu_cmt_ecall     ( exu_ralu_cmt_ecall              ),
        .alu_ralu_cmt_ebreak    ( exu_ralu_cmt_ebreak             ),
        .alu_ralu_cmt_wfi       ( exu_ralu_cmt_wfi                ),                               
        .alu_i_csrepc           ( exu_csr_epc_r                   ),
        .alu_i_csrdpc           ( 32'hFFFF_FFFF                   ),

        // bjp
        .alu_bjp_cmt_bjp        ( exu_alu_bjp_cmt_bjp             ),
        .alu_bjp_cmt_mret       ( exu_alu_bjp_cmt_mret            ),
        .alu_bjp_cmt_needflush  ( exu_alu_bjp_cmt_needflush       ),
        .alu_bjp_req_flush_pc   ( exu_alu_bjp_req_flush_pc        ),

        // csr                                
        .alu_csr_cmd_wr_en      ( exu_alu_csr_cmd_wr_en           ),
        .alu_csr_cmd_rd_en      ( exu_alu_csr_cmd_rd_en           ),
        .alu_csr_cmd_idx        ( exu_alu_csr_cmd_idx             ),
        .alu_csr_cmd_wdata      ( exu_alu_csr_cmd_wdata           ),
        .alu_csr_cmd_rdata      ( exu_alu_csr_cmd_rdata           ),
        .alu_csr_cmd_access_ilgl( exu_csr_access_ilgl             ),

        // result output                                 
        .alu_wbck_err           ( exu_alu_err                     ),
        .alu_wbck_data          ( exu_wbck_wdata                  ),

        .clk                    ( clk                             )
    );

    ///////////////////////////////////////////////////////////////////////////
    // U5: MEMT
    // Describe: LSU and mem 
    // Connect : AU -> MEMT
    //           MEMT -> CMT
    ////////////////////////////////////////////////////////////////////////////
    assign memtop_i_valid = exu_agu_cmd_enable; // valid is set when the instr is ld or st. 

    mem_top MEMT (

        .memtop_i_cmd_enable    ( exu_agu_cmd_enable              ),
        .memtop_i_cmd_read      ( exu_agu_cmd_read                ),
        .memtop_i_cmd_write     ( exu_agu_cmd_write               ),
        .memtop_i_cmd_usign     ( exu_agu_cmd_usign               ),
        .memtop_i_cmd_size      ( exu_agu_cmd_size                ),
        .memtop_i_cmd_addr      ( exu_agu_cmd_addr                ),
        .memtop_i_cmd_wdata     ( exu_agu_cmd_wdata               ),
        .memtop_i_cmd_wmask     ( exu_agu_cmd_wmask               ),
        .memtop_i_cmd_misalgn   ( exu_agu_cmd_misalgn             ),

        .memtop_o_ready         ( memtop_o_ready                  ),
        .memtop_i_valid         ( memtop_i_valid                  ),

        .lsu_o_wbck_wdata       ( exu_memt_agu_wbck_wdata         ),
        .lsu_o_wbck_err         ( exu_memt_agu_wbck_err           ),
                                 
        .clk                    ( clk                             ),
        .rst_n                  ( rst_n                           )
    );

    ///////////////////////////////////////////////////////////////////////////
    // U6: CMT
    // Describe: commit unit controls the excp and irq handle process. 
    // Connect : AU  -> CMT
    //           CMT -> WBCK
    ////////////////////////////////////////////////////////////////////////////
    wire                        exu_cmt_commit_trap    ;
    
    // csr to cmt
    wire                        exu_status_mie_r       ;
    wire                        exu_mtie_r             ;
    wire                        exu_msie_r             ;
    wire                        exu_meie_r             ;
    wire [`PC_SIZE-1:0        ] exu_csr_mtvec_r        ;

    assign exu_o_mtvec_r = exu_csr_mtvec_r;

    // cmt to scr
    wire [`ADDR_SIZE-1:0      ] exu_cmt_agu_badaddr = exu_rf_op1 + exu_dec_imm; // try to gate it
    wire [`ADDR_SIZE-1:0      ] exu_cmt_csr_badaddr    ;     
    wire                        exu_cmt_csr_badaddr_ena;
    wire [`PC_SIZE-1:0        ] exu_cmt_csr_epc        ;
    wire                        exu_cmt_csr_epc_ena    ;
    wire [`XLEN-1:0           ] exu_cmt_csr_cause      ;
    wire                        exu_cmt_csr_cause_ena  ;
    wire                        exu_cmt_csr_status_ena ;
    wire                        exu_cmt_csr_instret_ena;
    wire                        exu_cmt_csr_mret_ena   ;
    wire                        exu_nonalu_flush_req   ;

    assign exu_o_excp = exu_cmt_commit_trap & (~exu_nonalu_flush_req); 

    commit CMT (
        .cmt_i_ifu_valid        ( exu_i_ifu_valid                 ),
        .cmt_i_exu_ready        ( exu_o_exu_ready                 ),

        .cmt_i_pc               ( exu_i_pc                        ),
        .cmt_i_instr            ( exu_i_instr                     ),
        .cmt_i_pc_vld_4irqexcp  ( exu_i_pc_vld_4irqexcp           ),
        .cmt_i_wfi_halt_ack     ( 1'b1                            ),

        .cmt_i_bjp_need_flush   ( exu_alu_bjp_cmt_needflush       ),
        .cmt_i_bjp_flush_PC     ( exu_alu_bjp_req_flush_pc        ),
        .cmt_i_bjp_mret         ( exu_alu_bjp_cmt_mret            ),

        .pc_cmt_i_epc_r         ( pc_et_i_epc_r                   ), // pc to excp top
        .csr_mtvec_r            ( exu_csr_mtvec_r                 ),
        .status_mie_r           ( exu_status_mie_r                ),
        .mtie_r                 ( exu_mtie_r                      ),
        .msie_r                 ( exu_msie_r                      ),
        .meie_r                 ( exu_meie_r                      ),
                 
        .u_mode                 ( u_mode                          ),
        .s_mode                 ( s_mode                          ),
        .h_mode                 ( h_mode                          ),
        .m_mode                 ( m_mode                          ),

        .dbg_mode               ( dbg_mode                        ),
        .dbg_ebreakm_r          ( dbg_ebreakm_r                   ),

        .ext_irq_r              ( ext_irq_r                       ),
        .sft_irq_r              ( sft_irq_r                       ),
        .tmr_irq_r              ( tmr_irq_r                       ),

        .alu_cmt_i_wfi          ( exu_ralu_cmt_ecall              ),
        .alu_cmt_i_ecall        ( exu_ralu_cmt_ebreak             ),
        .alu_cmt_i_ebreak       ( exu_ralu_cmt_wfi                ),
        .alu_cmt_i_ifu_misalgn  ( exu_dec_misalgn                 ),
        .alu_cmt_i_ifu_buserr   ( exu_dec_buserr                  ),
        .alu_cmt_i_ifu_ilegl    ( exu_dec_ilegl                   ),
        .alu_cmt_i_misalgn      ( exu_agu_cmd_misalgn             ), // misalgn from agu
        .alu_cmt_i_ld           ( exu_dec_ld                      ),
        .alu_cmt_i_stamo        ( exu_dec_st                      ),
        .alu_cmt_i_buserr       ( 1'b0                            ),
        .alu_cmt_i_alu_err      ( exu_alu_err                     ),

        .cmt_i_badaddr          ( exu_cmt_agu_badaddr             ),
        .cmt_badaddr            ( exu_cmt_csr_badaddr             ),
        .cmt_badaddr_ena        ( exu_cmt_csr_badaddr_ena         ),
        .cmt_epc                ( exu_cmt_csr_epc                 ),
        .cmt_epc_ena            ( exu_cmt_csr_epc_ena             ),
        .cmt_cause              ( exu_cmt_csr_cause               ),
        .cmt_cause_ena          ( exu_cmt_csr_cause_ena           ),
        .cmt_instret_ena        ( exu_cmt_csr_instret_ena         ),
        .cmt_status_ena         ( exu_cmt_csr_status_ena          ),
        .cmt_mret_ena           ( exu_cmt_csr_mret_ena            ),

        .commit_trap            ( exu_cmt_commit_trap             ),
        .nonalu_flush_req       ( exu_nonalu_flush_req            ),
        .pipe_flush_req         ( exu_o_pipe_flush_req            ),
        .pipe_flush_pc          ( exu_o_pipe_flush_pc             ),
        .core_wfi               ( exu_o_core_wfi                  ),
                
        .clk                    ( clk                             ),
        .rst_n                  ( rst_n                           )
    );

    ///////////////////////////////////////////////////////////////////////////
    // U7: WBCK
    // Describe: WBCK unit is designed for write-back procedure to RF. 
    // Connect : CMT -> WBCK
    ////////////////////////////////////////////////////////////////////////////
    wire [`RFIDX_WIDTH-1:0] exu_wbck_rdidx = exu_dec_rdwen? exu_dec_rdidx: `PC_SIZE'd0;

    wbck WBCK (
        .alu_wbck_i_ready       ( exu_o_exu_ready                 ),
        .alu_wbck_i_valid       ( exu_i_ifu_valid                 ),
        .cmt_wbck_irqexcp       ( exu_cmt_commit_trap             ),

        .wbck_i_wdat            ( exu_wbck_wdata                  ),
        .wbck_i_rdidx           ( exu_wbck_rdidx                  ),

        .wbck_o_rf_ena          ( exu_wbck_rf_ena                 ),
        .wbck_o_rf_wdat         ( exu_wbck_rf_wdata               ),
        .wbck_o_rf_rdidx        ( exu_wbck_rf_rdidx               )
    );

    ///////////////////////////////////////////////////////////////////////////
    // U7: WBCK
    // Describe: WBCK unit is designed for write-back procedure to RF. 
    // Connect : CMT -> WBCK
    ////////////////////////////////////////////////////////////////////////////
    wire exu_csr_ena  = exu_dec_csrrw & exu_i_ifu_valid & exu_o_exu_ready;

    csr CSR (
        .csr_ena                ( exu_csr_ena                     ),
        .csr_wr_en              ( exu_alu_csr_cmd_wr_en           ),
        .csr_rd_en              ( exu_alu_csr_cmd_rd_en           ),
        .csr_idx                ( exu_alu_csr_cmd_idx             ),
        .read_csr_dat           ( exu_alu_csr_cmd_rdata           ),
        .wbck_csr_dat           ( exu_alu_csr_cmd_wdata           ),
                                                    
        .ext_irq_r              ( ext_irq_r                       ),
        .sft_irq_r              ( sft_irq_r                       ),
        .tmr_irq_r              ( tmr_irq_r                       ),

        .u_mode                 ( u_mode                          ),
        .s_mode                 ( s_mode                          ),
        .h_mode                 ( h_mode                          ),
        .m_mode                 ( m_mode                          ),
                                                
        .status_mie_r           ( exu_status_mie_r                ),
        .mtie_r                 ( exu_mtie_r                      ),
        .msie_r                 ( exu_msie_r                      ),
        .meie_r                 ( exu_meie_r                      ),
        .csr_epc_r              ( exu_csr_epc_r                   ),
        .csr_mtvec_r            ( exu_csr_mtvec_r                 ),
                                               
        .cmt_badaddr            ( exu_cmt_csr_badaddr             ),
        .cmt_badaddr_ena        ( exu_cmt_csr_badaddr_ena         ),
        .cmt_epc                ( exu_cmt_csr_epc                 ),
        .cmt_epc_ena            ( exu_cmt_csr_epc_ena             ),
        .cmt_cause              ( exu_cmt_csr_cause               ),
        .cmt_cause_ena          ( exu_cmt_csr_cause_ena           ),
        .cmt_status_ena         ( exu_cmt_csr_status_ena          ),
        .cmt_instret_ena        ( exu_cmt_csr_instret_ena         ),                         
        .cmt_mret_ena           ( exu_cmt_csr_mret_ena            ),

        .csr_o_access_ilgl      ( exu_csr_access_ilgl             ),

        .clk_aon                ( clk_aon                         ),
        .clk                    ( clk                             ),
        .rst_n                  ( rst_n                           )
    );
endmodule
