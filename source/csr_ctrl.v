
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/07/23 10:21:03
// Design Name: 
// Module Name: csr_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: csr_ctrl is used to control the read and write of csr. The wbck data will
//                      be sent to commit interface.
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module csr_ctrl(

  input  [`XLEN-1:0              ] csr_i_rs1          ,
  input  [`DECINFO_CSR_WIDTH-1:0 ] csr_i_info         ,
  
  output                           csr_wr_en          ,
  output                           csr_rd_en          ,
  output [`CSR_IDX_WIDTH-1:0     ] csr_idx            ,
  output [`XLEN-1:0              ] csr_cmd_wdata      , // csrctrl2csr
  input  [`XLEN-1:0              ] csr_cmd_rdata      , // csr2csrctrl
  input                            csr_access_ilgl    ,

  output                           wbck_csr_ilgl      ,
  output [`XLEN-1:0              ] wbck_csr_dat         // csr2rf

  );
 
 
  wire                      csrrw  =  csr_i_info[`DECINFO_CSR_CSRRW ];
  wire                      csrrs  =  csr_i_info[`DECINFO_CSR_CSRRS ];
  wire                      csrrc  =  csr_i_info[`DECINFO_CSR_CSRRC ];
  wire                      rs1imm =  csr_i_info[`DECINFO_CSR_RS1IMM];
  wire                      rs1is0 =  csr_i_info[`DECINFO_CSR_RS1IS0];
  wire [4:0]                zimm   =  csr_i_info[`DECINFO_CSR_ZIMMM ];
  wire [`CSR_IDX_WIDTH-1:0] csridx =  csr_i_info[`DECINFO_CSR_CSRIDX];


  wire [`XLEN-1:0] csr_op1 = rs1imm ? {27'b0,zimm} : csr_i_rs1;

  assign csr_rd_en = csrrw | csrrs | csrrc  ;                   // rw, set and clear operation always need to read CSR not matter where the rd points.
                     
  assign csr_wr_en = csrrw                                      // CSRRW always write the original RS1 value into the CSR
                     | ((csrrs | csrrc) & (~rs1is0)) ;          // for CSRRS/RC, if the RS is x0, then should not really write                                        
                                                                                                                                                                                     
  assign csr_idx   = csridx;
  
  // rf2csr data path 
  // Data for csrrs and csrrc is connected with the orignal data in csr registers.
  assign csr_cmd_wdata =   ({`XLEN{csrrw}} &    csr_op1                 )
                         | ({`XLEN{csrrs}} & (  csr_op1  | csr_cmd_rdata))
                         | ({`XLEN{csrrc}} & ((~csr_op1) & csr_cmd_rdata));
  
  // csr2rf
  assign wbck_csr_dat  = csr_cmd_rdata;
  assign wbck_csr_ilgl = csr_access_ilgl;

endmodule

