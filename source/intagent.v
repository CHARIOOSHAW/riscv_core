//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2022/02/14
// Design Name: 
// Module Name: excp_tmr_irq
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
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module excp_tmr_irq(

    //////////////////////////////////////////////////////////////
    // 
    output                           tmr_int_syn      ,
    
    // ld or st data path
    // connect to lsu_ctrl
    // mtimecmp : RW; mtime : R;
    // 
    output [`XLEN-1:0              ] mreg_rdata       ,
    output                           mreg_ready       ,
    input                            mtimecmp_wen     ,
    input                            mtimecmp_ren     ,
    input                            mtime_ren        ,
    input                            mreg_hl          , // 1, read(write) higher 32 bits; 0, read(write) lower 32 bits.
    input  [`XLEN-1:0              ] mreg_wdata       ,


    input                            clk_mtime        ,  // A stable clk for time counting.
    input                            clk              ,  // CPU internal clk
    input                            rst_n               // reset signal
);
    
    // TMR INT
    // SIGNIFICANT INFORMATION
    // 1. Mtime and mtimecmp is not defined as CSR registers.
    // 2. Mtime increase with low-speed clock (clk_mtime).
    reg [`XLEN-1:0                ]  mtimeh           ;  // Int register : the higher 32 bits of mtime
    reg [`XLEN-1:0                ]  mtimecmph        ;  // Int register : the higher 32 bits of mtimecmp
    reg [`XLEN-1:0                ]  mtime            ;  // Int register : the lower 32 bits of mtime
    reg [`XLEN-1:0                ]  mtimecmp         ;  // Int register : the lower 32 bits of mtimecmp
    
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
        if (rst_n) begin:RESET_CMP
            mtimecmph <= 32'h0000_0000;
            mtimecmp  <= 32'h1000_0000;
        end
        else if(mtimecmp_wen&(~mreg_hl)) begin:WRITE_LOW32
            mtimecmp  <= mreg_wdata;
            mtimecmph <= mtimecmph ;
        end
        else if(mtimecmp_wen&mreg_hl) begin:WRITE_HIGH32
            mtimecmph <= mreg_wdata;
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
    wire [2*`XLEN:0               ]  add_op1 = {1'b0, mtimeh,    mtime   };
    wire [2*`XLEN:0               ]  add_op2 = {1'b1, mtimecmph, mtimecmp};

    wire [2*`XLEN:0               ]  add_op2_rev = ~add_op2 + 65'd1;
    wire [2*`XLEN:0               ]  add_res     = add_op1 + add_op2_rev;
  
    reg tmr_int;
    always@(*) begin
        if (add_res[2*`XLEN])
            tmr_int = 1'b0;
        else
            tmr_int = 1'b1;
    end

    // register chain
    dff_chain c1(
        .sig_out   ( tmr_int_syn  ),
        .clk_source( clk_mtime    ),
        .clk_target( clk          ),
        .rst_n     ( rst_n        ),
        .sig_in    ( tmr_int      )
    ); 




    

    // SFT INT


    // LDST DATA PATH
    reg  [`XLEN-1:0 ] rdata;
    wire [2:0       ] rcode = {mtimecmp_ren, mtime_ren, mreg_hl};

    always@(*) begin:READ_MREG
        case(rcode)
            100     : rdata = mtimecmp     ;
            101     : rdata = mtimecmph    ;
            010     : rdata = mtime        ;
            011     : rdata = mtimeh       ;
            default : rdata = 32'h0000_0000;
        endcase
    end

    assign mreg_rdata = rdata;


    // READY 
    assign mreg_ready = 1'b1;

endmodule



