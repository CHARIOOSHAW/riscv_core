
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw 
// 
// Create Date: 2021/07/28 10:14:53
// Design Name: 
// Module Name: mul
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: mul is the multi-cycle multiple unit for ALU. 
//                      A single multiple operation costs 15-16 cycle for 32-bit system. 
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module mul(

    // MULOP_LEN    = 33
    // MULOP_LEN_E2 = 35
    // 1bit for lowest bit extend; 1bit for sign bit extend; 1bit for align.
    input  [`MULOP_LEN-1:0       ] mul_op1      ,   // op1 will be remained uncahnged.
    input  [`MULOP_LEN-1:0       ] mul_op2      ,   // op2 will be encodeed with radix-4.

    // control signals
    input                          mul_sel_en   ,
    input                          mul_start_en ,
    input  [`MAX_DELAY_WIDTH-1:0 ] pc_cycle     ,
    
    // output signals
    output [(2*`MULOP_LEN)-1:0   ] mul_res      ,
    
    // clk
    input                          clk     
    );

    // Before enter the process, the lowest bit should be expanded with 1'b0.
    // Store the unhandlled part of op2.
    // For each cycle, mul will handle two bits of op2, until op2 has been fully considered.
    wire   [`MULOP_LEN_E2-1:0       ] mul_op2_r;
    wire   [`MULOP_LEN_E2-1:0       ] mul_op2_nxt = mul_start_en? {{1{mul_op2[`MULOP_LEN-1]}},mul_op2,1'b0}:
                                                    {{2{mul_op2_r[`MULOP_LEN_E2-1]}}, mul_op2_r[`MULOP_LEN_E2-1:2]};

    sirv_gnrl_dffl #(.DW(`MULOP_LEN_E2)) mul_opr (
        .lden(mul_sel_en),
        .dnxt(mul_op2_nxt),
        .qout(mul_op2_r),
        .clk(clk)
    );

    wire   [2:0] current_code = mul_op2_r[2:0];

    // For a three-bits code split, there are five types of weight (-2/-1/0/1/2). 
    wire   neg  =  current_code[2];
    wire   zero = (current_code == 3'b000 | current_code == 3'b111)? 1'b1: 1'b0;
    wire   two  = (current_code == 3'b100 | current_code == 3'b011)? 1'b1: 1'b0;
    wire   one  = (~zero) & (~two);

    // Weight the op1.
    wire [(2*`MULOP_LEN)-1:0] weighted_op1  = zero? 'd0:
                                              // A*1
                                              one?  {{`MULOP_LEN{mul_op1[`MULOP_LEN-1]}}, mul_op1}: // expand with signal bit
                                              // A*2
                                              {{`MULOP_LEN{mul_op1[`MULOP_LEN-1]}}, mul_op1[`MULOP_LEN-2:0], 1'b0};

    // current_op1: the partial product of this cycle.
    // reverse if neg.
    // Here, it should be reminded that the partial product should be left shifted according to the cycle number.
    // R = sum(weight*op1*(4^n)). n represents the cycle number. 
    wire [(2*`MULOP_LEN)-1:0] current_op1   = (neg? (~weighted_op1 + 1'b1): weighted_op1) << {(pc_cycle[`MAX_DELAY_WIDTH-1:0]-'d2), 1'b0};

    // add
    wire [(2*`MULOP_LEN)-1:0] res_r;
    wire [(2*`MULOP_LEN)-1:0] res_nxt;
    assign res_nxt = mul_start_en? 'd0: res_r + current_op1;

    sirv_gnrl_dffl #(.DW(2*`MULOP_LEN)) mul_rer (
        .lden(mul_sel_en),
        .dnxt(res_nxt),
        .qout(res_r),
        .clk(clk)
    );

    // output 
    assign mul_res = res_r;

endmodule
