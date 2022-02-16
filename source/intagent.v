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
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module excp_tmr_irq(

    //////////////////////////////////////////////////////////////
    // The General signal for AGU unit.
    

    input                            clk_mtime        ,  // A stable clk for time counting.
    input                            clk              ,  // CPU internal clk
    input                            rst_n               // reset signal
);
  
    // SIGNIFICANT INFORMATION
    // 1. Mtime and mtimecmp is not defined as CSR registers.
    // 2.

    reg [2*`XLEN-1:0              ]  mtime            ;  // CSR register : mtime
    reg [2*`XLEN-1:0              ]  mtimecmp         ;  // CSR register : mtimecmp




