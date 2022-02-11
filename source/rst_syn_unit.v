
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date:
// Design Name: 
// Module Name: rst_syn_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Synchronous unit for rst signals,
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module rst_syn_unit (
    input          rst_n     ,
    input          clk       ,

    output         rst_n_syn
);

    // The rst_n_syn signal will be unset asynchronously and set synchronously. 
    reg buff1;
    reg buff2;

    always@(posedge clk or negedge rst_n) begin:b1
        if (~rst_n)
            buff1 <= 1'b0;
        else
            buff1 <= 1'b1;
    end 

    always@(posedge clk or negedge rst_n) begin:b2
        if (~rst_n)
            buff2 <= 1'b0;
        else
            buff2 <= buff1;
    end

    assign rst_n_syn = buff2;
  
endmodule
