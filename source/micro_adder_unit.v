
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/09 11:47:48
// Design Name: 
// Module Name: micro_adder_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: adder_unit is used to handle adder operations.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module micro_adder_unit(
    
    // operand number 
    input [`ALU_ADDER_WIDTH-1:0]    mau_adder_op1,
    input [`ALU_ADDER_WIDTH-1:0]    mau_adder_op2,
       
    // indicate signals   
    input                           mau_adder_add,
    input                           mau_adder_sub,
  
    // output result  
    output [`ALU_ADDER_WIDTH-1:0]   mau_adder_res
    );

    wire [`ALU_ADDER_WIDTH-1:0]     adder_in1;
    wire [`ALU_ADDER_WIDTH-1:0]     adder_in2;
    wire                            adder_cin;
    wire                            adder_addsub  =  mau_adder_add | mau_adder_sub; 

    // Make sure to use logic-gating to gateoff the signal
    assign adder_in1        = {`ALU_ADDER_WIDTH{adder_addsub}} & (mau_adder_op1);
    assign adder_in2        = {`ALU_ADDER_WIDTH{adder_addsub}} & (mau_adder_sub ? (~mau_adder_op2) : mau_adder_op2);
    assign adder_cin        = adder_addsub & mau_adder_sub;
    assign mau_adder_res    = adder_in1 + adder_in2 + adder_cin; // if add a+b+0, if sub a+(~b+1).

endmodule
