
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/18 16:00:59
// Design Name: 
// Module Name: sirv_gnrl_dfflr
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
//  Verilog module sirv_gnrl DFF with Load-enable and Reset
//  Default reset value is 0
//
// ===========================================================================

module sirv_gnrl_dfflr # (
  parameter DW = 32
) (

  input               lden, 
  input      [DW-1:0] dnxt,
  output     [DW-1:0] qout,

  input               clk,
  input               rst_n
);

reg [DW-1:0] qout_r;

always @(posedge clk or negedge rst_n)
begin : DFFLR_PROC
  if (rst_n == 1'b0)
    qout_r <= {DW{1'b0}};
  else if (lden)
    qout_r <= dnxt;
end

assign qout = qout_r;    

endmodule
