//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2022/02/14
// Design Name: 
// Module Name: intagent
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:  Tmr_irq will generate the interrupt signal with time registers.
//                       Tmr_irq is independent of other signals outside of excp units.
//                       Sft_irq and Tmr_irq will be cleared if rst_n is avaliable.
//                       ext_irq should be longer than 2 cycles in this implementation.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module intagent(

    //////////////////////////////////////////////////////////////
    // ita -> csr, change the mip field
    output                           ita_csr_mtip           ,
    output                           ita_csr_msip           ,
    output                           ita_csr_meip           ,

    // ita -> excp_irq, irq indicators
    output                           ita_tmr_int            ,
    output                           ita_sft_int            ,
    output                           ita_ext_int            ,
    
    // ld or st data path
    input                            ita_i_exu_wr           ,
    input                            ita_i_exu_rd           ,
    input  [`XLEN-1:0              ] ita_i_exu_wdata        ,
    input  [`PC_SIZE-1:0           ] ita_i_exu_addr         ,
    input                            ita_i_exu_valid        ,

    output [`XLEN-1:0              ] ita_o_exu_rdata        ,
    output                           ita_o_exu_ready        ,
    
    // int arbitration
    input                            ita_i_bjp_req_flush    ,
    output                           ita_o_int_pending_flag ,

    // external int
    input                            ita_i_external_int     ,

    // valid and ready signals
    // int is avaliable when ready and valid is set.(An instr finished.)
    // input                            ita_i_exu_ir_ready     ,
    // input                            ita_i_ifu_ir_valid     ,

    input                            clk_mtime              ,  // A stable clk for time counting.
    input                            clk                    ,  // CPU internal clk
    input                            rst_n                     // reset signal
);
    
    // Memory defines
    reg [`XLEN-1:0                ]  mtimeh           ;  // Int register : the higher 32 bits of mtime
    reg [`XLEN-1:0                ]  mtimecmph        ;  // Int register : the higher 32 bits of mtimecmp
    reg [`XLEN-1:0                ]  mtime            ;  // Int register : the lower 32 bits of mtime
    reg [`XLEN-1:0                ]  mtimecmp         ;  // Int register : the lower 32 bits of mtimecmp
    reg                              ita_msip         ;  // Msip is considered as a memory. Use LDST instrs to access it.

    //-------------------------------------------------------------------------------
    // LDST DATA PATH
    // connect to lsu_ctrl
    // mtimecmp : RW; mtime : R;
    // msip: RW
    wire sel_msip      = (ita_i_exu_addr == 32'h1000_0000)? 1'b1: 1'b0;
    wire sel_mtime     = (ita_i_exu_addr == 32'h1000_0004)? 1'b1: 1'b0;
    wire sel_mtimeh    = (ita_i_exu_addr == 32'h1000_0008)? 1'b1: 1'b0;
    wire sel_mtimecmp  = (ita_i_exu_addr == 32'h1000_000c)? 1'b1: 1'b0;
    wire sel_mtimecmph = (ita_i_exu_addr == 32'h1000_0010)? 1'b1: 1'b0;

    wire mtimecmp_wen  = sel_mtimecmp  & ita_i_exu_wr;
    wire mtimecmp_ren  = sel_mtimecmp  & ita_i_exu_rd;
    wire mtimecmph_wen = sel_mtimecmph & ita_i_exu_wr;
    wire mtimecmph_ren = sel_mtimecmph & ita_i_exu_rd;
    wire mtime_wen     = sel_mtime     & ita_i_exu_wr;
    wire mtime_ren     = sel_mtime     & ita_i_exu_rd;
    wire mtimeh_wen    = sel_mtimeh    & ita_i_exu_wr;
    wire mtimeh_ren    = sel_mtimeh    & ita_i_exu_rd;
    wire msip_wen      = sel_msip      & ita_i_exu_wr;
    wire msip_ren      = sel_msip      & ita_i_exu_rd;

    reg  [`XLEN-1:0 ] rdata;
    wire [4:0       ] rcode = {mtimecmp_ren, mtimecmph_ren, mtime_ren, mtimeh_ren, msip_ren};

    always@(*) begin:READ_MREG
        case(rcode)
            // read mtime and mtimecmp
            5'b10000     : rdata = mtimecmp     ;
            5'b01000     : rdata = mtimecmph    ;
            5'b00100     : rdata = mtime        ;
            5'b00010     : rdata = mtimeh       ;

            // read msip
            5'b00001     : rdata = {31'd0, ita_msip};
            default      : rdata = 32'hdead_ffff;
        endcase
    end

    assign ita_o_exu_rdata = rdata;
    
    // READY 
    assign ita_o_exu_ready = ita_i_exu_valid;


    //---------------------------------------------------------------------------------------------
    // TMR INT
    // SIGNIFICANT INFORMATION
    // 1. Mtime and mtimecmp is not defined as CSR registers.
    // 2. Mtime increase with low-speed clock (clk_mtime).
    // 3. The implementation of TMR is risky when the st instr of tmr is very near the tmr_int.
    //    Due to CDC, ita_tmr_req will delay certain cycles after the tmr_int is set.
    //    If st clear the mtimecmp. we might lost the int signal. And the length might lower than 
    //    2 cycles after the arbitration.
    
    // mtime
    always@(posedge clk_mtime or negedge rst_n) begin
        if (~rst_n) begin:RESET
            mtimeh <= 32'h0000_0000;
            mtime  <= 32'h0000_0000;
        end
        else begin:COUNTING
            if (&mtime) begin
                mtime  <= 32'h0000_0000;
                mtimeh <= mtimeh + 32'h0000_0001;
            end
            else begin
                mtime  <= mtime + 32'h0000_0001;
                mtimeh <= mtimeh;
            end
        end
    end
  
    // mtimecmp
    always@(posedge clk or negedge rst_n) begin
        if (~rst_n) begin:RESET_CMP
            mtimecmph <= 32'h0000_0000;
            mtimecmp  <= 32'h1000_0000;
        end
        else if(mtimecmp_wen) begin:WRITE_LOW32
            mtimecmp  <= ita_i_exu_wdata;
            mtimecmph <= mtimecmph ;
        end
        else if(mtimecmph_wen) begin:WRITE_HIGH32
            mtimecmph <= ita_i_exu_wdata;
            mtimecmp  <= mtimecmp  ;
        end
        else begin:KEEP
            mtimecmph <= mtimecmph ;
            mtimecmp  <= mtimecmp  ;
        end
    end

    // make an adder
    // add_op1 - add_op2 >= 0, then mtime >= mtimecmp, set tmr_int;
    // add_op1 - add_op2 < 0, then mtime < mtimecmp, clear tmr_int.
    wire [2*`XLEN-1:0             ]  add_op1 =   {mtimeh,    mtime   };
    wire [2*`XLEN-1:0             ]  add_op2 = ~({mtimecmph, mtimecmp}) + 64'd1;
    wire [2*`XLEN:0               ]  add_res     = {1'b0, add_op1} + {1'b1, add_op2};
  
    // generate tmr_int
    reg  tmr_int;
    wire ita_tmr_int_raw;

    always@(*) begin
        if (add_res[2*`XLEN])
            tmr_int = 1'b0;
        else
            tmr_int = 1'b1;
    end

    // tmr_int signal CDC
    // register chain
    dff_chain3 chain3(
        .sig_out   ( ita_tmr_int_raw  ),
        .clk_source( clk_mtime        ),
        .clk_target( clk              ),
        .rst_n     ( rst_n            ),
        .sig_in    ( tmr_int          )
    ); 
    
    assign ita_csr_mtip = ita_tmr_int_raw;
    assign ita_tmr_int  = ita_tmr_int_raw & ~(ita_i_bjp_req_flush);
    
    //-------------------------------------------------------------------------------
    // SFT INT
    always@(posedge clk or negedge rst_n) begin
        if (~rst_n)
            ita_msip <= 1'b0;
        else if (msip_wen)
            ita_msip <= ita_i_exu_wdata[0];
        else 
            ita_msip <= ita_msip;
    end

    assign ita_csr_msip     = ita_msip;
    assign ita_sft_int      = ita_msip & ~(ita_i_bjp_req_flush);

    //-------------------------------------------------------------------------------
    // NOTE: The length of ext_irq should be longer than 2 cycles.
    // EXT INT
    wire ita_ext_int_raw;
    dff_chain2 chain2(
        .sig_in    ( ita_i_external_int ),
        .sig_out   ( ita_ext_int_raw    ), // syn int signal
        .clk       ( clk                ),
        .rst_n     ( rst_n              )
    );

    assign ita_csr_meip = ita_ext_int_raw;

    //-------------------------------------------------------------------------------
    // arbitration between bjp and int
    // One more thing, intagent has to arbitrage whether the interrupt signal is valid or not.
    // The interrupt signal will be masked and recorded when it meet bjp_req_flush.
    // It will wait for the excution of jump instr and return pc_r to epc or dpc registers rather than pc_r+2 or pc_r+4.
    // Here, we arbitrage the interrupt signal.
    // For detail:
    // 1. Int comes and no bjp request flush. Interrupt_ack set and return pc_r+2 or pc_r+4 to epc(dpc).
    // 2. Int comes and bjp request flush at the same time. Interrupt_ack clr and int_flag_r set. 
    //    Wait for the excution finished, clear int_flag_r, set Interrupt_ack and return pc_r.
    // 3. The set signal of int is independent from ready and valid signal.
    
    // external int
    reg      extirq_pending_flag;
    reg      width_count;
    assign   ita_ext_int         =  ~ita_i_bjp_req_flush & (ita_ext_int_raw | extirq_pending_flag);
    wire     ita_ext_flag_set    =  ita_ext_int_raw & (ita_i_bjp_req_flush);

    always@(posedge clk or negedge rst_n) begin:ext_int_flag
        if (~rst_n)
            extirq_pending_flag <= 1'b0;
        else if (extirq_pending_flag & width_count & ~ita_i_bjp_req_flush)           // add a counter
            extirq_pending_flag <= 1'b0;
        else if (ita_ext_flag_set)
            extirq_pending_flag <= 1'b1;
        else
            extirq_pending_flag <= extirq_pending_flag;
    end
    
    // expand external int signal use count
    always@(posedge clk or negedge rst_n) begin
        if (~rst_n)
            width_count <= 1'b0;
        else if (extirq_pending_flag & ~ita_i_bjp_req_flush)
            width_count <= 1'b1;
        else
            width_count <= 1'b0;
    end

    // output pending flag
    assign ita_o_int_pending_flag = extirq_pending_flag;

endmodule



