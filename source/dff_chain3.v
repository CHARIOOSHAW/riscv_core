
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2022/02/20 16:00:59
// Design Name: 
// Module Name: dff_chain
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Three_level dff chain for signal synchronization.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module dff_chain3 (
    output               sig_out    ,

    input                clk_source ,
    input                clk_target ,
    input                rst_n      ,
    input                sig_in     
);
    reg                  sig_dff1;
    reg                  sig_dff2;
    reg                  sig_dff3;

    // level 1
    always@(posedge clk_source or negedge rst_n) begin
        if (~rst_n)
            sig_dff1 <= 1'b0;
        else
            sig_dff1 <= sig_in;
    end

    // level 2
    always@(posedge clk_target or negedge rst_n) begin
        if (~rst_n)
            sig_dff2 <= 1'b0;
        else
            sig_dff2 <= sig_dff1;
    end

    // level 3
    always@(posedge clk_target or negedge rst_n) begin
        if (~rst_n)
            sig_dff3 <= 1'b0;
        else
            sig_dff3 <= sig_dff2;
    end

    assign sig_out = sig_dff3;

endmodule

