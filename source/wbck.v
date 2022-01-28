
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/09/08 15:39:00
// Design Name: 
// Module Name: wbck
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Wbck is the final module. Wbck is used write back data to regfile.
//                      Wbck always happened at the last cycle of excute and there is no irq and excp.
//                      last cycle: determined by multi_counter;
//                      no irq and excp: determined by commit.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module wbck(
    input                       alu_wbck_i_ready   , // ready signal. The instr has been fully excuted.
    input                       alu_wbck_i_valid   , // valid signal. The instr commit at the end 
    input                       cmt_wbck_irqexcp   , // make sure there is no int and excp.

    input  [`XLEN-1:0         ] wbck_i_wdat        , // from alu
    input  [`RFIDX_WIDTH-1:0  ] wbck_i_rdidx       , // from decoder

    output                      wbck_o_rf_ena      , // to RF
    output [`XLEN-1:0         ] wbck_o_rf_wdat     ,
    output [`RFIDX_WIDTH-1:0  ] wbck_o_rf_rdidx    

    );

    //////////////////////////////////////////////////////////////
    // The Final arbitrated Write-Back Interface
    wire   wbck_ready4alu      = alu_wbck_i_ready & alu_wbck_i_valid & (~cmt_wbck_irqexcp) ;// There is no other behavior for our core.
  
    wire [`XLEN-1:0       ]  wbck_i_wdat_req     = {32{wbck_ready4alu}} & wbck_i_wdat  ;
    wire [`RFIDX_WIDTH-1:0]  wbck_i_rdidx_req    = {32{wbck_ready4alu}} & wbck_i_rdidx ;
  
    //output 
    assign wbck_o_rf_ena   = wbck_ready4alu            ;
    assign wbck_o_rf_wdat  = wbck_i_wdat_req[`XLEN-1:0];
    assign wbck_o_rf_rdidx = wbck_i_rdidx_req          ;

    
endmodule
