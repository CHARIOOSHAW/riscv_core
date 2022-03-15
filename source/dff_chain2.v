

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2022/02/20 16:00:59
// Design Name: 
// Module Name: dff_chain2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Two_level dff chain for signal synchronization.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module dff_chain2 (
    output               sig_out    ,
    input                sig_in     ,

    input                clk        ,
    input                rst_n      

);
    reg                  sig_dff1;
    reg                  sig_dff2;

    // level 1
    always@(posedge clk or negedge rst_n) begin
        if (~rst_n)
            sig_dff1 <= 1'b0;
        else
            sig_dff1 <= sig_in;
    end

    // level 2
    always@(posedge clk or negedge rst_n) begin
        if (~rst_n)
            sig_dff2 <= 1'b0;
        else
            sig_dff2 <= sig_dff1;
    end

    assign sig_out = sig_dff2;

endmodule

