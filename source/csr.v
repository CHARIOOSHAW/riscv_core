
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/07/15 11:11:45
// Design Name: 
// Module Name: csr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: CSR is used to implement the csr registers.
// 
//////////////////////////////////////////////////////////////////////////////////

`include "mcu_defines.v"

module csr(

    // General datapath.
    input                      csr_ena         ,
    input                      csr_wr_en       ,
    input                      csr_rd_en       ,
    input [`CSR_IDX_WIDTH-1:0] csr_idx         ,

    output [`XLEN-1:0        ] read_csr_dat    , // read data bus
    input  [`XLEN-1:0        ] wbck_csr_dat    , // write data bus
    
    // interrupt request       
    input                      ext_irq_r       ,
    input                      sft_irq_r       ,
    input                      tmr_irq_r       ,

    // private mode
    input                      u_mode          ,
    input                      s_mode          ,
    input                      h_mode          ,
    input                      m_mode          ,

    // interrupt shield output 
    output                     status_mie_r    ,
    output                     mtie_r          ,
    output                     msie_r          ,
    output                     meie_r          ,

    // address output 
    output [`PC_SIZE-1:0     ] csr_epc_r       ,
    output [`PC_SIZE-1:0     ] csr_mtvec_r     ,

    // enabled when enter the exception program
    input [`ADDR_SIZE-1:0    ] cmt_badaddr     ,
    input                      cmt_badaddr_ena ,
    input [`PC_SIZE-1:0      ] cmt_epc         ,
    input                      cmt_epc_ena     ,
    input [`XLEN-1:0         ] cmt_cause       ,
    input                      cmt_cause_ena   ,
    input                      cmt_status_ena  ,
    input                      cmt_instret_ena ,

    // enabled when exit the exception program
    input                      cmt_mret_ena    ,

    // addr illegal
    output                     csr_o_access_ilgl,
    
    // clk&rst    
    input                      clk_aon         ,
    input                      clk             ,
    input                      rst_n

  );

    // Only toggle when need to read or write to save power
    wire wbck_csr_wen = csr_wr_en & csr_ena;
    wire read_csr_ena = csr_rd_en & csr_ena;

    wire [1:0] priv_mode = u_mode ? 2'b00 : 
                           s_mode ? 2'b01 :
                           h_mode ? 2'b10 : 
                           m_mode ? 2'b11 : 
                                    2'b11;

    // Note: 1. The input wbck_csr_data is in the length of 32-bit. However, to reduce the area,
    // only a small number of field will be recorded.
    // 2. All the writing back operations will be handled here. CSR is separated from WBCK module from EXU.


    // 1 MSTATUS
    // 0x300 MRW mstatus Machine status register.
    wire sel_mstatus = (csr_idx == 12'h300);

    wire rd_mstatus  = sel_mstatus & csr_rd_en;
    wire wr_mstatus  = sel_mstatus & csr_wr_en;

    /////////////////////////////////////////////////////////////////////
    // Note: the below implementation only apply to Machine-mode config,
    //       if other mode is also supported, these logics need to be updated

    //////////////////////////
    // Implement MPIE field

    wire status_mpie_r;
    // The MPIE Feilds will be updates when: 
    wire status_mpie_ena = 
            // The CSR is written by CSR instructions, write csr
            (wr_mstatus & wbck_csr_wen) | 
            // The MRET instruction commited, mret
            cmt_mret_ena | 
            // The Trap is taken, fall into the trap
            cmt_status_ena; 

    wire status_mpie_nxt = 
        // See Priv SPEC:
        //       When a trap is taken from privilege mode y into privilege
        //       mode x, xPIE is set to the value of xIE;
        // So, When the Trap is taken, the MPIE is updated with the current MIE value
        cmt_status_ena? status_mie_r:

        // See Priv SPEC:
        //       When executing an xRET instruction, supposing xPP holds the value y, xIE
        //       is set to xPIE; the privilege mode is changed to y; 
        //       xPIE is set to 1;
        // So, When the MRET instruction commited, the MPIE is updated with 1
        cmt_mret_ena? 1'b1:

        // When the CSR is written by CSR instructions
        (wr_mstatus & wbck_csr_wen)? wbck_csr_dat[7]: // MPIE is in field 7 of mstatus

        status_mpie_r; // Unchanged 

    sirv_gnrl_dfflr #(1) status_mpie_dfflr (status_mpie_ena, status_mpie_nxt, status_mpie_r, clk, rst_n);

    //////////////////////////
    // Implement MIE field

    // The MIE Feilds will be updates same as MPIE
    wire status_mie_ena  = status_mpie_ena; 
    wire status_mie_nxt  = 
        //   See Priv SPEC:
        //       When a trap is taken from privilege mode y into privilege
        //       mode x, xPIE is set to the value of xIE,
        //       xIE is set to 0;
        // So, When the Trap is taken, the MIE is updated with 0
        cmt_status_ena? 1'b0:
        //   See Priv SPEC:
        //       When executing an xRET instruction, supposing xPP holds the value y, xIE
        //       is set to xPIE; the privilege mode is changed to y, xPIE is set to 1;
        // So, When the MRET instruction commited, the MIE is updated with MPIE
        cmt_mret_ena? status_mpie_r:
        // When the CSR is written by CSR instructions
        (wr_mstatus & wbck_csr_wen)? wbck_csr_dat[3] : // MIE is in field 3 of mstatus
        status_mie_r; // Unchanged 

    sirv_gnrl_dfflr #(1) status_mie_dfflr (status_mie_ena, status_mie_nxt, status_mie_r, clk, rst_n);

    //////////////////////////
    // Implement SD field
    //
    //  See Priv SPEC:
    //    The SD bit is read-only 
    //    And is set when either the FS or XS bits encode a Dirty
    //      state (i.e., SD=((FS==11) OR (XS==11))).
    wire [1:0] status_fs_r;
    wire [1:0] status_xs_r;
    wire status_sd_r = 1'b0; // EAI & FPU is not avaliable.

    //////////////////////////
    // Implement XS field
    //
    //  See Priv SPEC:
    //    XS field is read-only
    //    The XS field represents a summary of all extensions' status
    // But in E200 we implement XS exactly same as FS to make it usable by software to 
    //   disable extended accelerators
    `ifndef HAS_EAI
       // If no EAI coprocessor interface configured, the XS is just hardwired to 0
       assign status_xs_r = 2'b00;
    `endif

    //////////////////////////
    // Implement FS field
    //
    `ifndef HAS_FPU
       // If no FPU configured, the FS is just hardwired to 0
       assign status_fs_r = 2'b00; 
    `endif

    //////////////////////////
    // Pack to the full mstatus register
    //
    wire [`XLEN-1:0] status_r;
    assign status_r[31]    = status_sd_r;                        //SD
    assign status_r[30:23] = 8'b0; // Reserved
    assign status_r[22:17] = 6'b0;               // TSR--MPRV
    assign status_r[16:15] = status_xs_r;                        // XS
    assign status_r[14:13] = status_fs_r;                        // FS
    assign status_r[12:11] = 2'b11;              // MPP 
    assign status_r[10:9]  = 2'b0; // Reserved
    assign status_r[8]     = 1'b0;               // SPP
    assign status_r[7]     = status_mpie_r;                      // MPIE
    assign status_r[6]     = 1'b0; // Reserved
    assign status_r[5]     = 1'b0;               // SPIE 
    assign status_r[4]     = 1'b0;               // UPIE 
    assign status_r[3]     = status_mie_r;                       // MIE
    assign status_r[2]     = 1'b0; // Reserved
    assign status_r[1]     = 1'b0;               // SIE 
    assign status_r[0]     = 1'b0;               // UIE 

    wire [`XLEN-1:0] csr_mstatus = status_r;


    // 2 MIE  
    //0x304 MRW mie Machine interrupt-enable register.
    wire sel_mie = (csr_idx == 12'h304);
    wire rd_mie  = sel_mie & csr_rd_en;
    wire wr_mie  = sel_mie & csr_wr_en;
    wire mie_ena = wr_mie  & wbck_csr_wen;

    wire [`XLEN-1:0] mie_r;
    wire [`XLEN-1:0] mie_nxt;
    assign mie_nxt[31:12] = 20'b0;
    assign mie_nxt[11]    = wbck_csr_dat[11];//MEIE
    assign mie_nxt[10:8]  = 3'b0;
    assign mie_nxt[7]     = wbck_csr_dat[ 7];//MTIE
    assign mie_nxt[6:4]   = 3'b0;
    assign mie_nxt[3]     = wbck_csr_dat[ 3];//MSIE
    assign mie_nxt[2:0]   = 3'b0;

    sirv_gnrl_dfflr #(`XLEN) mie_dfflr (mie_ena, mie_nxt, mie_r, clk, rst_n);
    wire [`XLEN-1:0] csr_mie = mie_r;

    assign meie_r = csr_mie[11];
    assign mtie_r = csr_mie[ 7];
    assign msie_r = csr_mie[ 3];


    // 3 MIP
    // 0x344 MRW mip Machine interrupt pending
    wire sel_mip = (csr_idx == 12'h344);
    wire rd_mip  = sel_mip & csr_rd_en; // The MxIP is read-only

    wire meip_r;
    wire msip_r;
    wire mtip_r;
    sirv_gnrl_dffr #(1) meip_dffr (ext_irq_r, meip_r, clk, rst_n); // CG is cancelled. mip is workinng all the time.
    sirv_gnrl_dffr #(1) msip_dffr (sft_irq_r, msip_r, clk, rst_n); // irq_r is sent from the csr_ctrl.
    sirv_gnrl_dffr #(1) mtip_dffr (tmr_irq_r, mtip_r, clk, rst_n);

    wire [`XLEN-1:0]  mip_r  ;
    assign mip_r[31:12] =  20'b0  ;
    assign mip_r[11]    =  meip_r ;
    assign mip_r[10:8]  =  3'b0   ;
    assign mip_r[7]     =  mtip_r ;
    assign mip_r[6:4]   =  3'b0   ;
    assign mip_r[3]     =  msip_r ;
    assign mip_r[2:0]   =  3'b0   ;

    wire [`XLEN-1:0] csr_mip = mip_r;


    // 4 MTVEC
    // 0x305 MRW mtvec Machine trap-handler base address.
    // If different exceptions should be direct to different entrances, csr_ctrl should handle the csr_mtvec.
    wire sel_mtvec = (csr_idx == 12'h305);
    wire rd_mtvec  = csr_rd_en & sel_mtvec;
    `ifdef SUPPORT_MTVEC //{
        wire wr_mtvec  = sel_mtvec & csr_wr_en;
        wire mtvec_ena = (wr_mtvec & wbck_csr_wen);
        wire [`XLEN-1:0] mtvec_r;
        wire [`XLEN-1:0] mtvec_nxt = wbck_csr_dat;
        sirv_gnrl_dfflr #(`XLEN) mtvec_dfflr (mtvec_ena, mtvec_nxt, mtvec_r, clk, rst_n);
        wire [`XLEN-1:0] csr_mtvec = mtvec_r;
    `else//}{
        // THe vector table base is a configurable parameter, so we dont support writeable to it
        wire [`XLEN-1:0] csr_mtvec = 32'h0000_0000;
    `endif//}
    assign csr_mtvec_r = csr_mtvec;


    // 5 MSCRATCH
    //0x340 MRW mscratch 
    wire sel_mscratch = (csr_idx == 12'h340);
    wire rd_mscratch  = sel_mscratch & csr_rd_en;
    `ifdef SUPPORT_MSCRATCH //{
        wire wr_mscratch  = sel_mscratch & csr_wr_en;
        wire mscratch_ena = (wr_mscratch & wbck_csr_wen);
        wire [`XLEN-1:0] mscratch_r;
        wire [`XLEN-1:0] mscratch_nxt = wbck_csr_dat;
        sirv_gnrl_dfflr #(`XLEN) mscratch_dfflr (mscratch_ena, mscratch_nxt, mscratch_r, clk, rst_n);
        wire [`XLEN-1:0] csr_mscratch = mscratch_r;
    `else//}{
        wire [`XLEN-1:0] csr_mscratch = `XLEN'b0;
    `endif//}


    // 6 COUNTING CSRs
    // 0xB00 MRW mcycle 
    // 0xB02 MRW minstret 
    // 0xB80 MRW mcycleh
    // 0xB82 MRW minstreth 
    // Read only registers.
    wire sel_mcycle      = (csr_idx == 12'hB00);
    wire sel_mcycleh     = (csr_idx == 12'hB80);
    wire sel_minstret    = (csr_idx == 12'hB02);
    wire sel_minstreth   = (csr_idx == 12'hB82);

    wire rd_mcycle       = csr_rd_en & sel_mcycle   ;
    wire rd_mcycleh      = csr_rd_en & sel_mcycleh  ;
    wire rd_minstret     = csr_rd_en & sel_minstret ;
    wire rd_minstreth    = csr_rd_en & sel_minstreth;

    // 7 self-def CSRs
    `ifdef SUPPORT_MCYCLE_MINSTRET //{
        wire wr_mcycle        = csr_wr_en & sel_mcycle    ;
        wire wr_mcycleh       = csr_wr_en & sel_mcycleh   ;
        wire wr_minstret      = csr_wr_en & sel_minstret  ;
        wire wr_minstreth     = csr_wr_en & sel_minstreth ;

        wire mcycle_wr_ena    = (wr_mcycle    & wbck_csr_wen) ;
        wire mcycleh_wr_ena   = (wr_mcycleh   & wbck_csr_wen) ;
        wire minstret_wr_ena  = (wr_minstret  & wbck_csr_wen) ;
        wire minstreth_wr_ena = (wr_minstreth & wbck_csr_wen) ;

        wire [`XLEN-1:0] mcycle_r    ;
        wire [`XLEN-1:0] mcycleh_r   ;
        wire [`XLEN-1:0] minstret_r  ;
        wire [`XLEN-1:0] minstreth_r ;


        wire mcycle_ena        = mcycle_wr_ena    |  (1'b1); // mcycle_ena is set whenever mcycle is written or there is no mcycle_stop.
        wire mcycleh_ena       = mcycleh_wr_ena   |  ((mcycle_r == (~(`XLEN'd0)))); // carry
        wire minstret_ena      = minstret_wr_ena  |  (cmt_instret_ena);
        wire minstreth_ena     = minstreth_wr_ena |  ((cmt_instret_ena & (minstret_r == (~(`XLEN'b0)))));

        wire [`XLEN-1:0] mcycle_nxt    = mcycle_wr_ena    ? wbck_csr_dat : (mcycle_r    + 1'b1); // write then use wbck_dat elsewise +1. 
        wire [`XLEN-1:0] mcycleh_nxt   = mcycleh_wr_ena   ? wbck_csr_dat : (mcycleh_r   + 1'b1);
        wire [`XLEN-1:0] minstret_nxt  = minstret_wr_ena  ? wbck_csr_dat : (minstret_r  + 1'b1);
        wire [`XLEN-1:0] minstreth_nxt = minstreth_wr_ena ? wbck_csr_dat : (minstreth_r + 1'b1);

        //We need to use the always-on clock for cycle counter
        sirv_gnrl_dfflr #(`XLEN) mcycle_dfflr    (mcycle_ena, mcycle_nxt, mcycle_r   , clk_aon, rst_n);
        sirv_gnrl_dfflr #(`XLEN) mcycleh_dfflr   (mcycleh_ena, mcycleh_nxt, mcycleh_r  , clk_aon, rst_n);
        sirv_gnrl_dfflr #(`XLEN) minstret_dfflr  (minstret_ena, minstret_nxt, minstret_r , clk, rst_n);
        sirv_gnrl_dfflr #(`XLEN) minstreth_dfflr (minstreth_ena, minstreth_nxt, minstreth_r, clk, rst_n);

        wire [`XLEN-1:0] csr_mcycle      = mcycle_r;
        wire [`XLEN-1:0] csr_mcycleh     = mcycleh_r;
        wire [`XLEN-1:0] csr_minstret    = minstret_r;
        wire [`XLEN-1:0] csr_minstreth   = minstreth_r;
    `else//}{

        wire [`XLEN-1:0] csr_mcycle      = `XLEN'b0;  // Zero is returned to indicate the csr is not supported.
        wire [`XLEN-1:0] csr_mcycleh     = `XLEN'b0;
        wire [`XLEN-1:0] csr_minstret    = `XLEN'b0;
        wire [`XLEN-1:0] csr_minstreth   = `XLEN'b0;
        wire [`XLEN-1:0] csr_counterstop = `XLEN'b0;
    `endif//}


    wire [`XLEN-1:0] csr_cycle  = `XLEN'b0;
    wire [`XLEN-1:0] csr_cycleh = `XLEN'b0;

    // 8 MEPC
    //0x341 MRW mepc Machine exception program counter.
    wire sel_mepc = (csr_idx == 12'h341);
    wire rd_mepc  = sel_mepc & csr_rd_en;
    wire wr_mepc  = sel_mepc & csr_wr_en;
    wire epc_ena  = (wr_mepc & wbck_csr_wen) | cmt_epc_ena;
    wire [`PC_SIZE-1:0] epc_r;
    wire [`PC_SIZE-1:0] epc_nxt;
    assign epc_nxt[`PC_SIZE-1:1] = cmt_epc_ena ? cmt_epc[`PC_SIZE-1:1] : wbck_csr_dat[`PC_SIZE-1:1]; // cmt_ena indicate program is falling into the trap.
    assign epc_nxt[0] = 1'b0;// Must not hold PC which will generate the misalign exception according to ISA
    sirv_gnrl_dfflr #(`PC_SIZE) epc_dfflr (epc_ena, epc_nxt, epc_r, clk, rst_n);
    wire [`XLEN-1:0] csr_mepc;
    assign csr_mepc  = epc_r;
    assign csr_epc_r = csr_mepc;


    // 9 MCAUSE
    //0x342 MRW mcause Machine trap cause.
    wire sel_mcause = (csr_idx == 12'h342);
    wire rd_mcause  = sel_mcause & csr_rd_en;
    wire wr_mcause  = sel_mcause & csr_wr_en;
    wire cause_ena  = (wr_mcause & wbck_csr_wen) | cmt_cause_ena;
    wire [`XLEN-1:0] cause_r;
    wire [`XLEN-1:0] cause_nxt;
    assign cause_nxt[31]  = cmt_cause_ena ? cmt_cause[31] : wbck_csr_dat[31]; // interrupt field.
    assign cause_nxt[30:4] = 27'b0;
    assign cause_nxt[3:0] = cmt_cause_ena ? cmt_cause[3:0] : wbck_csr_dat[3:0];  // maxium 16 different avaliable exceptions.
    sirv_gnrl_dfflr #(`XLEN) cause_dfflr (cause_ena, cause_nxt, cause_r, clk, rst_n);
    wire [`XLEN-1:0] csr_mcause = cause_r;


    // 10 MBADADDR
    // 0x343 MRW mbadaddr Machine bad address.
    wire sel_mbadaddr = (csr_idx == 12'h343);
    wire rd_mbadaddr = sel_mbadaddr & csr_rd_en;
    wire wr_mbadaddr = sel_mbadaddr & csr_wr_en;
    wire cmt_trap_badaddr_ena = cmt_badaddr_ena;
    wire badaddr_ena = (wr_mbadaddr & wbck_csr_wen) | cmt_trap_badaddr_ena;
    wire [`ADDR_SIZE-1:0] badaddr_r;
    wire [`ADDR_SIZE-1:0] badaddr_nxt;
    assign badaddr_nxt = cmt_trap_badaddr_ena ? cmt_badaddr : wbck_csr_dat[`ADDR_SIZE-1:0];
    sirv_gnrl_dfflr #(`ADDR_SIZE) badaddr_dfflr (badaddr_ena, badaddr_nxt, badaddr_r, clk, rst_n);
    wire [`XLEN-1:0] csr_mbadaddr;
    assign csr_mbadaddr = badaddr_r;


    // 11 MISA
    //0x301 MRW misa ISA and extensions
    wire sel_misa = (csr_idx == 12'h301);
    wire rd_misa = sel_misa & csr_rd_en;
    // Only implemented the M mode, IMC or EMC
    wire [`XLEN-1:0] csr_misa = {
        2'b01
       ,4'b0 //WIRI
       ,1'b0 //              25 Z Reserved
       ,1'b0 //              24 Y Reserved
       ,1'b0 //              23 X Non-standard extensions present
       ,1'b0 //              22 W Reserved
       ,1'b0 //              21 V Tentatively reserved for Vector extension 20 U User mode implemented
       ,1'b0 //              20 U User mode implemented
       ,1'b0 //              19 T Tentatively reserved for Transactional Memory extension
       ,1'b0 //              18 S Supervisor mode implemented
       ,1'b0 //              17 R Reserved
       ,1'b0 //              16 Q Quad-precision floating-point extension
       ,1'b0 //              15 P Tentatively reserved for Packed-SIMD extension
       ,1'b0 //              14 O Reserved
       ,1'b0 //              13 N User-level interrupts supported
       ,1'b1 // 12 M Integer Multiply/Divide extension
       ,1'b0 //              11 L Tentatively reserved for Decimal Floating-Point extension
       ,1'b0 //              10 K Reserved
       ,1'b0 //              9 J Reserved
       ,1'b1 // 8 I RV32I/64I/128I base ISA
       ,1'b0 //              7 H Hypervisor mode implemented
       ,1'b0 //              6 G Additional standard extensions present
       ,1'b0 //              5 F Single-precision floating-point extension
       ,1'b0 //              4 E RV32E base ISA              
       ,1'b0 //              3 D Double-precision floating-point extension
       ,1'b1 // 2 C Compressed extension
       ,1'b0 //              1 B Tentatively reserved for Bit operations extension
       ,1'b0 //              0 A Atomic extension
        };


    // 12 MIR
    // read only
    //Machine Information Registers
    //0xF11 MRO mvendorid Vendor ID.
    //0xF12 MRO marchid Architecture ID.
    //0xF13 MRO mimpid Implementation ID.
    //0xF14 MRO mhartid Hardware thread ID.
    wire [`XLEN-1:0] csr_mvendorid = `XLEN'd0;
    wire [`XLEN-1:0] csr_marchid   = `XLEN'd0;
    wire [`XLEN-1:0] csr_mimpid    = `XLEN'd0;
    wire [`XLEN-1:0] csr_mhartid   = `XLEN'd0;
    wire rd_mvendorid = csr_rd_en & (csr_idx == 12'hF11);
    wire rd_marchid   = csr_rd_en & (csr_idx == 12'hF12);
    wire rd_mimpid    = csr_rd_en & (csr_idx == 12'hF13);
    wire rd_mhartid   = csr_rd_en & (csr_idx == 12'hF14);


    // 13 DEBUG REGISTERS
    //0x7b0 Debug Control and Status
    //0x7b1 Debug PC
    //0x7b2 Debug Scratch Register
    //0x7a0 Trigger selection register
    // wire sel_dcsr     = (csr_idx == 12'h7b0);
    // wire sel_dpc      = (csr_idx == 12'h7b1);
    // wire sel_dscratch = (csr_idx == 12'h7b2);

    // wire rd_dcsr      = dbg_mode & csr_rd_en & sel_dcsr    ;
    // wire rd_dpc       = dbg_mode & csr_rd_en & sel_dpc     ;
    // wire rd_dscratch  = dbg_mode & csr_rd_en & sel_dscratch;

    // assign wr_dcsr_ena     = dbg_mode & csr_wr_en & sel_dcsr    ;
    // assign wr_dpc_ena      = dbg_mode & csr_wr_en & sel_dpc     ;
    // assign wr_dscratch_ena = dbg_mode & csr_wr_en & sel_dscratch;

    // wire [`XLEN-1:0] csr_dcsr     = dcsr_r    ;
    // wire [`XLEN-1:0] csr_dpc      = dpc_r     ;
    // wire [`XLEN-1:0] csr_dscratch = dscratch_r;

    // assign csr_dpc_r = dpc_r;


    /////////////////////////////////////////////////////////////////////
    //  Generate the Read path
    //Currently we only support the M mode to simplify the implementation and 
    //      reduce the gatecount because we are a privite core
    assign read_csr_dat = `XLEN'b0 
                   | ({`XLEN{rd_mstatus    }} & csr_mstatus    )
                   | ({`XLEN{rd_mie        }} & csr_mie        )
                   | ({`XLEN{rd_mtvec      }} & csr_mtvec      )
                   | ({`XLEN{rd_mepc       }} & csr_mepc       )
                   | ({`XLEN{rd_mscratch   }} & csr_mscratch   )
                   | ({`XLEN{rd_mcause     }} & csr_mcause     )
                   | ({`XLEN{rd_mbadaddr   }} & csr_mbadaddr   )
                   | ({`XLEN{rd_mip        }} & csr_mip        )
                   | ({`XLEN{rd_misa       }} & csr_misa       )
                   | ({`XLEN{rd_mvendorid  }} & csr_mvendorid  )
                   | ({`XLEN{rd_marchid    }} & csr_marchid    )
                   | ({`XLEN{rd_mimpid     }} & csr_mimpid     )
                   | ({`XLEN{rd_mhartid    }} & csr_mhartid    )
                   | ({`XLEN{rd_mcycle     }} & csr_mcycle     )
                   | ({`XLEN{rd_mcycleh    }} & csr_mcycleh    )
                   | ({`XLEN{rd_minstret   }} & csr_minstret   )
                   | ({`XLEN{rd_minstreth  }} & csr_minstreth  )
                   ;

    wire [12:0] sel_indicator = {sel_mstatus, sel_mie, sel_mip, sel_mtvec, sel_mscratch, sel_mcycle, sel_mcycleh, sel_minstret, sel_minstreth, sel_mepc, sel_mcause, sel_mbadaddr, sel_misa};
    assign csr_o_access_ilgl  = 1'b0; // csr_ena & (~(|sel_indicator)); it always failed here and report ilgl, why? loop here?
                                        
endmodule


