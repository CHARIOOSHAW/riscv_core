
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/08/05 15:09:31
// Design Name: 
// Module Name: alu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Alu_top is the combination of alu child modules, including 
//                      ralu/csr/muldiv/agu/dpath/bjp(inside PC).
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module alu_top(

    // general ports
    input  [`XLEN-1:0             ] alu_i_rs1             ,
    input  [`XLEN-1:0             ] alu_i_rs2             ,
    input  [`XLEN-1:0             ] alu_i_imm             ,
    input  [`DECINFO_CSR_WIDTH-1:0] alu_i_info            , // info is a control signal for every unit. It will not be demuxed.
    input  [`MAX_DELAY_WIDTH-1:0  ] alu_i_pc_cycle        ,
    input  [`PC_SIZE-1 : 0        ] alu_i_pc_r            ,
    

    /////////////////////////////////////////////////////////////////
    // agu - memtop
    output                          alu_agu_cmd_enable    ,   
    output                          alu_agu_cmd_read      ,  
    output                          alu_agu_cmd_write     ,  
    output                          alu_agu_cmd_usign     ,  
    output [1:0]                    alu_agu_cmd_size      ,     
    output [`XLEN-1:0             ] alu_agu_cmd_addr      ,  
    output [`XLEN-1:0             ] alu_agu_cmd_wdata     ,  
    output [`XLEN/8-1:0           ] alu_agu_cmd_wmask     ,  
    output                          alu_agu_cmd_misalgn   ,

    input                           alu_memtop_wback_err  ,
    input  [`XLEN-1:0             ] alu_memtop_wback_data ,

    ////////////////////////////////////////////////////////////////
    // ralu - special instr indicate
    output                          alu_ralu_cmt_ecall    ,
    output                          alu_ralu_cmt_ebreak   ,
    output                          alu_ralu_cmt_wfi      ,

    ////////////////////////////////////////////////////////////////
    // bjp - csr/excp/cmt 
    input  [`PC_SIZE-1:0          ] alu_i_csrepc          ,
    input  [`PC_SIZE-1:0          ] alu_i_csrdpc          ,

    // bjp - special instr indicate
    output                          alu_bjp_cmt_bjp       ,
    output                          alu_bjp_cmt_mret      ,
    output                          alu_bjp_cmt_dret      ,
    output                          alu_bjp_cmt_needflush ,
    output [`PC_SIZE-1:0          ] alu_bjp_req_flush_pc  ,

    ///////////////////////////////////////////////////////////////
    // csr_ctrl - csr
    output                          alu_csr_cmd_wr_en     , 
    output                          alu_csr_cmd_rd_en     , 
    output [`CSR_IDX_WIDTH-1:0    ] alu_csr_cmd_idx       ,        
    output [`XLEN-1:0             ] alu_csr_cmd_wdata     ,      
    input  [`XLEN-1:0             ] alu_csr_cmd_rdata     ,  
    input                           alu_csr_cmd_access_ilgl,

    //////////////////////////////////////////////////////////////
    // alu-commit
    output                          alu_wbck_err          ,
    output [`XLEN-1:0             ] alu_wbck_data         ,

    input                           clk                   
);

    //-----------------------------------------------------------------//
    // enable signal generate
    wire alu_enable_ralu   = (alu_i_info[2:0] == 3'b000);
    wire alu_enable_agu    = (alu_i_info[2:0] == 3'b001);
    wire alu_enable_bjp    = (alu_i_info[2:0] == 3'b010);
    wire alu_enable_csr    = (alu_i_info[2:0] == 3'b011);
    wire alu_enable_muldiv = (alu_i_info[2:0] == 3'b100);

    //--------------------------------------------------------------//
    // internal signal declearation
    // operand mux
    wire [`XLEN-1:0             ]  alu_i_rs1_ralu     = ({`XLEN{alu_enable_ralu  }} & alu_i_rs1);
    wire [`XLEN-1:0             ]  alu_i_rs2_ralu     = ({`XLEN{alu_enable_ralu  }} & alu_i_rs2);
    wire [`XLEN-1:0             ]  alu_i_imm_ralu     = ({`XLEN{alu_enable_ralu  }} & alu_i_imm);
    wire [`DECINFO_ALU_WIDTH-1:0]  alu_i_info_ralu    = ({`DECINFO_ALU_WIDTH{alu_enable_ralu  }} & alu_i_info[`DECINFO_ALU_WIDTH-1:0]);
     
    wire [`XLEN-1:0             ]  alu_i_rs1_agu      = ({`XLEN{alu_enable_agu   }} & alu_i_rs1);
    wire [`XLEN-1:0             ]  alu_i_rs2_agu      = ({`XLEN{alu_enable_agu   }} & alu_i_rs2);
    wire [`XLEN-1:0             ]  alu_i_imm_agu      = ({`XLEN{alu_enable_agu   }} & alu_i_imm);
    wire [`DECINFO_AGU_WIDTH-1:0]  alu_i_info_agu     = ({`DECINFO_AGU_WIDTH{alu_enable_agu   }} & alu_i_info[`DECINFO_AGU_WIDTH-1:0]);
   
    wire [`XLEN-1:0             ]  alu_i_rs1_muldiv   = ({`XLEN{alu_enable_muldiv}} & alu_i_rs1);
    wire [`XLEN-1:0             ]  alu_i_rs2_muldiv   = ({`XLEN{alu_enable_muldiv}} & alu_i_rs2);
    wire [`XLEN-1:0             ]  alu_i_imm_muldiv   = ({`XLEN{alu_enable_muldiv}} & alu_i_imm);
    wire [`DECINFO_MULDIV_WIDTH-1:0]  alu_i_info_muldiv  = ({`DECINFO_MULDIV_WIDTH{alu_enable_muldiv}} & alu_i_info[`DECINFO_MULDIV_WIDTH-1:0]);

    wire [`XLEN-1:0             ]  alu_i_rs1_bjp      = ({`XLEN{alu_enable_bjp   }} & alu_i_rs1);
    wire [`XLEN-1:0             ]  alu_i_rs2_bjp      = ({`XLEN{alu_enable_bjp   }} & alu_i_rs2);
    wire [`XLEN-1:0             ]  alu_i_imm_bjp      = ({`XLEN{alu_enable_bjp   }} & alu_i_imm);
    wire [`DECINFO_BJP_WIDTH-1:0]  alu_i_info_bjp     = ({`DECINFO_BJP_WIDTH{alu_enable_bjp   }} & alu_i_info[`DECINFO_BJP_WIDTH-1:0]);

    wire [`XLEN-1:0             ]  alu_i_rs1_csr      = ({`XLEN{alu_enable_csr   }} & alu_i_rs1);
    wire [`DECINFO_CSR_WIDTH-1:0]  alu_i_info_csr     = ({`DECINFO_CSR_WIDTH{alu_enable_csr   }} & alu_i_info[`DECINFO_CSR_WIDTH-1:0]);

    //--------------------------------------------------------------//
    // request signals
    // alu request signals  
    // csr doesn't need to req. ralu reqs inside its module. 
    wire                           agu_req_alu           ;
    wire [`XLEN-1:0             ]  agu_req_alu_op1       ;
    wire [`XLEN-1:0             ]  agu_req_alu_op2       ;
    wire                           agu_req_alu_add       ;
    wire [`XLEN-1:0             ]  agu_req_alu_res       ;
    
    wire                           muldiv_req_alu        ;        
    wire [`XLEN-1:0             ]  muldiv_req_alu_op1    ;   
    wire [`XLEN-1:0             ]  muldiv_req_alu_op2    ;   
    wire                           muldiv_req_alu_ltu    ;   
    wire [`XLEN-1:0             ]  muldiv_req_alu_res    ;   
    wire                           muldiv_req_alu_cmp_res;

    wire                           bjp_req_alu           ;
    wire [`XLEN-1:0             ]  bjp_req_alu_op1       ;
    wire [`XLEN-1:0             ]  bjp_req_alu_op2       ;
    wire                           bjp_req_alu_cmp_eq    ;
    wire                           bjp_req_alu_cmp_ne    ;
    wire                           bjp_req_alu_cmp_lt    ;
    wire                           bjp_req_alu_cmp_gt    ;
    wire                           bjp_req_alu_cmp_ltu   ;
    wire                           bjp_req_alu_cmp_gtu   ;
    wire                           bjp_req_alu_cmp_res   ;

    //------------------------------------------------------------------//
    // data and err demux   
    wire                           alu_wbck_err_ralu     ; 
    wire [`XLEN-1:0             ]  alu_wbck_data_ralu    ;
   
    wire                           alu_wbck_err_agu      ; 
    wire [`XLEN-1:0             ]  alu_wbck_data_agu     ;

    wire                           alu_wbck_err_muldiv   ; 
    wire [`XLEN-1:0             ]  alu_wbck_data_muldiv  ;

    wire                           alu_wbck_err_bjp      ; 
    wire [`XLEN-1:0             ]  alu_wbck_data_bjp     ;

    wire                           alu_wbck_err_csr      ; 
    wire [`XLEN-1:0             ]  alu_wbck_data_csr     ;

    assign alu_wbck_err = (alu_enable_ralu   & alu_wbck_err_ralu   )|
                          // (alu_enable_agu    & alu_wbck_err_agu )| // The err from agu will be handled directly.
                          (alu_enable_muldiv & alu_wbck_err_muldiv )|
                          (alu_enable_bjp    & alu_wbck_err_bjp    )|
                          (alu_enable_csr    & alu_wbck_err_csr    );

    assign alu_wbck_data = ({`XLEN{alu_enable_ralu   }} & alu_wbck_data_ralu   )|
                           ({`XLEN{alu_enable_agu    }} & alu_wbck_data_agu    )|
                           ({`XLEN{alu_enable_muldiv }} & alu_wbck_data_muldiv )|
                           ({`XLEN{alu_enable_bjp    }} & alu_wbck_data_bjp    )|
                           ({`XLEN{alu_enable_csr    }} & alu_wbck_data_csr    );


    //--------------------------------------------------------------//
    // Unit Instantiation
    //--------------------------------------------------------------//
    // U1: RALU
    // RALU = ALU + DPATH
    // RALU is the calculation unit for core. Other units will request
    // RALU for regular calculation by sending operands and instr type.
    // And RALU will send results back to them. 
    // ecall/ebreak/wfi are special, they are excuted by other units actually.
    //--------------------------------------------------------------//
    ralu exu_alu_ralu (

        // RALU input signals which belongs to ralu itself.
        .alu_i_rs1               (  alu_i_rs1_ralu                  ),
        .alu_i_rs2               (  alu_i_rs2_ralu                  ),
        .alu_i_imm               (  alu_i_imm_ralu                  ),
        .alu_i_pc                (  alu_i_pc_r                      ), // ralu need pc for calculate for some instrs. Pc_r will offered by pc unit.
        .alu_i_info              (  alu_i_info_ralu                 ),

        // bjp unit request signal path.
        .bjp_req_alu             (  bjp_req_alu                     ),
        .bjp_req_alu_op1         (  bjp_req_alu_op1                 ),
        .bjp_req_alu_op2         (  bjp_req_alu_op2                 ),
        .bjp_req_alu_cmp_eq      (  bjp_req_alu_cmp_eq              ),
        .bjp_req_alu_cmp_ne      (  bjp_req_alu_cmp_ne              ),
        .bjp_req_alu_cmp_lt      (  bjp_req_alu_cmp_lt              ),
        .bjp_req_alu_cmp_gt      (  bjp_req_alu_cmp_gt              ),
        .bjp_req_alu_cmp_ltu     (  bjp_req_alu_cmp_ltu             ),
        .bjp_req_alu_cmp_gtu     (  bjp_req_alu_cmp_gtu             ),
        .bjp_req_alu_cmp_res     (  bjp_req_alu_cmp_res             ),

        // agu unit request signal path.
        .agu_req_alu             (  agu_req_alu                     ),
        .agu_req_alu_op1         (  agu_req_alu_op1                 ),
        .agu_req_alu_op2         (  agu_req_alu_op2                 ),
        .agu_req_alu_add         (  agu_req_alu_add                 ),
        .agu_req_alu_res         (  agu_req_alu_res                 ),

        // muldiv unit request signal path
        .muldiv_req_alu          (  muldiv_req_alu                  ),
        .muldiv_req_alu_op1      (  muldiv_req_alu_op1              ),
        .muldiv_req_alu_op2      (  muldiv_req_alu_op2              ),
        .muldiv_req_alu_ltu      (  muldiv_req_alu_ltu              ),
        .muldiv_req_alu_res      (  muldiv_req_alu_res              ),
        .muldiv_req_alu_cmp_res  (  muldiv_req_alu_cmp_res          ),

        // ralu output      
        .ralu_o_wbck_wdat        (  alu_wbck_data_ralu              ), // wdata is for wbck unit.
        .ralu_o_wbck_err         (  alu_wbck_err_ralu               ),
        .ralu_o_cmt_ecall        (  alu_ralu_cmt_ecall              ),
        .ralu_o_cmt_ebreak       (  alu_ralu_cmt_ebreak             ),
        .ralu_o_cmt_wfi          (  alu_ralu_cmt_wfi                )
    );


    //-------------------------------------------------------------//
    // U2: AGU
    // AGU is the control unit for load & store instr. It calculates
    // the address of storage accessing and control the whole process.
    // It has to be pointed out that the ld&st instrs need 2 cycles to 
    // excute, so handshake is needed for them. And the info should remain
    // unchanged during the process.
    //-------------------------------------------------------------//
    agu exu_alu_agu (

        // agu input signals
        .agu_i_rs1               (  alu_i_rs1_agu                   ),
        .agu_i_rs2               (  alu_i_rs2_agu                   ),
        .agu_i_imm               (  alu_i_imm_agu                   ),
        .agu_i_info              (  alu_i_info_agu                  ),
        // The most important point of enable signal is IFU have to keep
        // the instr, before the instr has been fully excuted.
        .agu_i_enable            (  alu_enable_agu                  ), 

        // the wbck data and err from agu to alu_top
        .agu_o_wback_err         (  alu_wbck_err_agu                ),
        .agu_o_wback_data        (  alu_wbck_data_agu               ),
        
        // agu request signals
        .agu_req_alu             (  agu_req_alu                     ),
        .agu_req_alu_op1         (  agu_req_alu_op1                 ),
        .agu_req_alu_op2         (  agu_req_alu_op2                 ),
        .agu_req_alu_add         (  agu_req_alu_add                 ),
        .agu_req_alu_res         (  agu_req_alu_res                 ),

        // The connection between agu and memtop
        .agu_cmd_enable          (  alu_agu_cmd_enable              ),
        .agu_cmd_read            (  alu_agu_cmd_read                ),
        .agu_cmd_write           (  alu_agu_cmd_write               ),
        .agu_cmd_usign           (  alu_agu_cmd_usign               ),
        .agu_cmd_size            (  alu_agu_cmd_size                ),
        .agu_cmd_addr            (  alu_agu_cmd_addr                ),
        .agu_cmd_wdata           (  alu_agu_cmd_wdata               ),
        .agu_cmd_wmask           (  alu_agu_cmd_wmask               ),
        .agu_cmd_misalgn         (  alu_agu_cmd_misalgn             ),

        .memtop_wback_err        (  alu_memtop_wback_err            ),
        .memtop_wback_data       (  alu_memtop_wback_data           )

    );

    //-------------------------------------------------------------//
    // U3: MULDIV
    // MULDIV is a multi-cycle calculation unit for mul & div operation.
    // It has been optimized with algorithm and shared some part of sources.
    // It still have space to further improved.
    //-------------------------------------------------------------//
    muldiv_top exu_alu_muldiv(

        // muldiv input signals
        .muldiv_i_rs1            (  alu_i_rs1_muldiv                 ),
        .muldiv_i_rs2            (  alu_i_rs2_muldiv                 ),
        .muldiv_i_info           (  alu_i_info_muldiv                ),
        // pc_cycle is an important control signal for muldiv, it indicate 
        // how many cycles a instr have cost since it has been successfully decoded.
        .pc_cycle                (  alu_i_pc_cycle                   ),  
     
        // muldiv request signals
        .muldiv_req_alu          (  muldiv_req_alu                   ),
        .muldiv_req_alu_op1      (  muldiv_req_alu_op1               ),
        .muldiv_req_alu_op2      (  muldiv_req_alu_op2               ),
        .muldiv_req_alu_ltu      (  muldiv_req_alu_ltu               ),
        .muldiv_req_alu_res      (  muldiv_req_alu_res               ),
        .muldiv_req_alu_cmp_res  (  muldiv_req_alu_cmp_res           ),
         
        // muldiv write back data
        .muldiv_illegal          (  alu_wbck_err_muldiv              ),
        .muldiv_wbck_res         (  alu_wbck_data_muldiv             ),
         
        .clk                     (  clk                              )               
    );

    //-------------------------------------------------------------//
    // U4: BJP
    // BJP controls the jump instrs. BJP includes a pc manager which 
    // offers pc_r and pc_nxt to ralu and IFU.
    //-------------------------------------------------------------//
    bjp exu_alu_bjp (

        // bjp input signals
        .bjp_i_rs1               (  alu_i_rs1_bjp                   ),
        .bjp_i_rs2               (  alu_i_rs2_bjp                   ),
        .bjp_i_imm               (  alu_i_imm_bjp                   ),
        .bjp_i_info              (  alu_i_info_bjp                  ),
        .bjp_i_csrepc            (  alu_i_csrepc                    ),
        .bjp_i_csrdpc            (  alu_i_csrdpc                    ),

        .bjp_i_pc_r              (  alu_i_pc_r                      ), // The PC of current instr.

        // bjp request interface
        .bjp_req_alu             (  bjp_req_alu                     ),
        .bjp_req_alu_op1         (  bjp_req_alu_op1                 ),
        .bjp_req_alu_op2         (  bjp_req_alu_op2                 ),
        .bjp_req_alu_cmp_eq      (  bjp_req_alu_cmp_eq              ),
        .bjp_req_alu_cmp_ne      (  bjp_req_alu_cmp_ne              ),
        .bjp_req_alu_cmp_lt      (  bjp_req_alu_cmp_lt              ),
        .bjp_req_alu_cmp_gt      (  bjp_req_alu_cmp_gt              ),
        .bjp_req_alu_cmp_ltu     (  bjp_req_alu_cmp_ltu             ),
        .bjp_req_alu_cmp_gtu     (  bjp_req_alu_cmp_gtu             ),
        .bjp_req_alu_cmp_res     (  bjp_req_alu_cmp_res             ),

        // bjp output signals
        .bjp_o_wbck_wdat         (  alu_wbck_data_bjp               ), // bjp need write back when excute jal or jalr.  
        .bjp_o_wbck_err          (  alu_wbck_err_bjp                ),
        .bjp_o_cmt_bjp           (  alu_bjp_cmt_bjp                 ),
        .bjp_o_cmt_mret          (  alu_bjp_cmt_mret                ),
        .bjp_o_cmt_dret          (  alu_bjp_cmt_dret                ),
        .bjp_o_cmt_needflush     (  alu_bjp_cmt_needflush           ),
        .bjp_req_flush_pc        (  alu_bjp_req_flush_pc            )  // bjp request pc flush.


    );


    //-------------------------------------------------------------//
    // U5: CSR_CTRL
    // CSR_CTRL controls the read and write instrs of CSRs. 
    // CSR_CTRL can access and change the status of CSR. But it doesn't 
    // control the interrupt reactions.
    //-------------------------------------------------------------//
    csr_ctrl exu_alu_csrctrl (

        // csr_ctrl input signals
        .csr_i_rs1               (  alu_i_rs1_csr                  ),
        .csr_i_info              (  alu_i_info_csr                 ),

        // csr_ctrl to csr control signals
        .csr_wr_en               (  alu_csr_cmd_wr_en              ),
        .csr_rd_en               (  alu_csr_cmd_rd_en              ),
        .csr_idx                 (  alu_csr_cmd_idx                ),
        .csr_cmd_wdata           (  alu_csr_cmd_wdata              ),
        .csr_cmd_rdata           (  alu_csr_cmd_rdata              ),
        .csr_access_ilgl         (  alu_csr_cmd_access_ilgl        ),

        // csr_ctrl to commit write back signals
        .wbck_csr_ilgl           (  alu_wbck_err_csr               ),
        .wbck_csr_dat            (  alu_wbck_data_csr              )
    );



endmodule
