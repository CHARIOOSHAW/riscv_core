
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2021/06/17 21:21:20
// Design Name:
// Module Name: sirv_gnrl_dffl
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


// ===========================================================================
//
// Description:
//  Verilog module sirv_gnrl DFF with Load-enable, no reset
//
// ===========================================================================

module sirv_gnrl_dffl # (
    parameter DW = 32
  ) (

    input               lden,
    input      [DW-1:0] dnxt,
    output reg [DW-1:0] qout,

    input               clk
  );

  always @(posedge clk)
  begin : DFFL_PROC
    if (lden == 1'b1)
      qout <= dnxt;
  end

  // `ifndef FPGA_SOURCE//{
  // `ifndef DISABLE_SV_ASSERTION//{
  // //synopsys translate_off
  // sirv_gnrl_xchecker # (
  //   .DW(1)
  // ) sirv_gnrl_xchecker(
  //   .i_dat(lden),
  //   .clk  (clk)
  // );
  // //synopsys translate_on
  // `endif//}
  // `endif//}

endmodule


