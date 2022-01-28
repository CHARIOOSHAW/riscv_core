
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/07/29 17:52:14
// Design Name: 
// Module Name: div
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: div unit is use to handle signed and unsigned div operation.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module div(

    // DIVOP_LEN    = 33
    // 1bit for sign bit extend.
    input  [`DIVOP_LEN-1:0       ] div_op1         ,  // Original Dividend 
    input  [`DIVOP_LEN-1:0       ] div_op2         ,  // Divisor
   
    // control signals   
    input                          div_sel_en      ,
    input                          div_start_en    ,  // load data, 1 cycle
    input                          div_fix_en      ,  // fix result, 1 cycle
    // input  [`MAX_DELAY_WIDTH-1:0 ] pc_cycle     ,  // 1+1+32 = 34 cycle
           
    // output signals   
    output [`DIVOP_LEN-1:0       ] quo_res         ,  // Quotient
    output [`DIVOP_LEN-1:0       ] rem_res         ,  // Remainder
   
    // div req alu to share the resource.
    output                         div_req_alu     ,
    output                         div_req_alu_ltu ,
    output [`DIVOP_LEN-2:0       ] div_req_alu_op1 ,
    output [`DIVOP_LEN-2:0       ] div_req_alu_op2 ,
    input                          div_req_alu_cmp_res ,
    input  [`DIVOP_LEN-2:0       ] div_req_alu_res ,

    // div error
    output                         div_op2_illegal ,  // op2 = 0 is not allowed.

    // clk
    input                          clk     
    );

    // unsign the ops.
    wire op1_signed = div_op1[`DIVOP_LEN-1];
    wire op2_signed = div_op2[`DIVOP_LEN-1];

    wire [`DIVOP_LEN-1:0] div_op2_unsigned = op2_signed? ~div_op2 + 1'd1: div_op2;
    wire [`DIVOP_LEN-1:0] div_op1_unsigned = op1_signed? ~div_op1 + 1'd1: div_op1;

    wire [`DIVOP_LEN-3:0] op1_unsigned_r;   // The bits remained unhandled.
    wire [`DIVOP_LEN-3:0] op1_unsigned_r_nxt = (div_start_en & (~div_fix_en))? div_op1_unsigned[`DIVOP_LEN-3:0]:
                                                op1_unsigned_r << 1;
    sirv_gnrl_dffl #(.DW(`DIVOP_LEN-2)) op1_register (
        .lden(div_sel_en),
        .dnxt(op1_unsigned_r_nxt),
        .qout(op1_unsigned_r),
        .clk(clk)
    );

    // div
    wire [`DIVOP_LEN-2:0] div_r;
    wire [`DIVOP_LEN-2:0] div_nxt =   div_start_en                        ?  {{`DIVOP_LEN-2{1'b0}},div_op1_unsigned[`DIVOP_LEN-2]}                           :  // To the begining, div = op1.
                                    (~div_req_alu_cmp_res & (~div_fix_en))?  (div_req_alu_res << 1) | {{`DIVOP_LEN-2{1'd0}},op1_unsigned_r[`DIVOP_LEN-3]}    :  // If div >= op2, sub then left shift.
                                    ( div_req_alu_cmp_res & (~div_fix_en))?  (div_r << 1) | {{`DIVOP_LEN-2{1'd0}},op1_unsigned_r[`DIVOP_LEN-3]}              :  // If div < op2, left shift.
                                    div_r;                                                                                                                      // or in the fix cycle, div remained unchange.

    sirv_gnrl_dffl #(.DW(`DIVOP_LEN-1)) div_register (
        .lden(div_sel_en),
        .dnxt(div_nxt),
        .qout(div_r),
        .clk(clk)
    );

    // quo
    wire [`DIVOP_LEN-2:0] quo_r;
    wire [`DIVOP_LEN-2:0] quo_shift = quo_r << 1;
    wire [`DIVOP_LEN-2:0] quo_fixed = (op1_signed ^ op2_signed)? ~quo_r+1'd1: quo_r;

    wire [`DIVOP_LEN-2:0] quo_nxt =   div_start_en                        ?  'd0                              :  // To the begining, quo = 0.
                                    (~div_req_alu_cmp_res & (~div_fix_en))?  {quo_shift[`DIVOP_LEN-2:1],1'b1} :  // If div >= op2, left shift then rem[0] = 1. 
                                    ( div_req_alu_cmp_res & (~div_fix_en))?  {quo_shift[`DIVOP_LEN-2:1],1'b0} :  // If div < op2, left shift then rem[0] = 0.
                                    quo_r;                                                                       // in the fix cycle, quo fixed.

    sirv_gnrl_dffl #(.DW(`DIVOP_LEN-1)) quo_register (
        .lden(div_sel_en),
        .dnxt(quo_nxt),
        .qout(quo_r),
        .clk(clk)
    );

    // rem
    // If div >= op2, save the alu_res. If div < op2, save dividend.
    wire [`DIVOP_LEN-2:0] rem_r;
    reg  [`DIVOP_LEN-2:0] rem_nxt;
    always@(*) begin
        if (div_fix_en) begin: fix_now
            rem_nxt = rem_r;
        end
        else if (~div_req_alu_cmp_res) begin:sub_now
            rem_nxt = div_req_alu_res;
        end
        else begin:nonsub_now
            rem_nxt = div_r;
        end
    end        

    sirv_gnrl_dffl #(.DW(`DIVOP_LEN-1)) rem_register (
        .lden(div_sel_en),
        .dnxt(rem_nxt),
        .qout(rem_r),
        .clk(clk)
    );
    wire [`DIVOP_LEN-2:0] rem_fixed = op1_signed? ~rem_r+1'd1 : rem_r           ;

    // req data path
    assign div_req_alu     = div_req_alu_ltu              ;
    assign div_req_alu_ltu = div_sel_en & ~(div_start_en) ;
    assign div_req_alu_op1 = div_r                        ;
    assign div_req_alu_op2 = div_op2_unsigned             ;

    // div illegal
    assign div_op2_illegal = div_sel_en & (&(~div_op2));

    //output 
    assign quo_res         = {quo_fixed[`DIVOP_LEN-2] , quo_fixed};                                              // recover the sign bit.
    assign rem_res         = {rem_fixed[`DIVOP_LEN-2] , rem_fixed};


endmodule
