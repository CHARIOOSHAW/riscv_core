
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/06/17 16:21:17
// Design Name: 
// Module Name: regfile
// Project Name: riscv_mcu
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: The instance for rf0-rf31.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module regfile(
    // Two read ports should be supported.
    input  [`RFIDX_WIDTH-1:0] read_src1_idx,
    input  [`RFIDX_WIDTH-1:0] read_src2_idx,
    output [`XLEN-1:0       ] read_src1_data,
    output [`XLEN-1:0       ] read_src2_data,


    // One write port.
    input                    wbck_dest_wen,
    input [`RFIDX_WIDTH-1:0] wbck_dest_idx,
    input [`XLEN-1:0]        wbck_dest_data,

    input clk

    );

    // Assign the write enable signal for each rf register. 
    wire [`RFREG_NUM-1:0] rf_wen;

    // The logical part of regfile.
    wire [`XLEN-1:0] rf_r [`RFREG_NUM-1:0];

    genvar i;
    generate
        for (i=0; i<`RFREG_NUM; i=i+1) begin: rf_main
            // x0 can't be wrote and should be constant-zeros.
            if (i==0) begin: rf0
                assign rf_r[i]   = 'd0;
                assign rf_wen[i] = 'b0;
            end

            // xno0 write when the idx and wen is avaliable at the same time.
            else begin: rfno0
                assign rf_wen[i] = (wbck_dest_idx==i)&(wbck_dest_wen);
                sirv_gnrl_dffl #(.DW(`XLEN)) rf_dffl (
                    .lden(  rf_wen[i]        ),
                    .dnxt(  wbck_dest_data   ),
                    .qout(  rf_r[i]          ),
                    .clk(   clk              )
                    );
            end
        end
    endgenerate

    // Asynchronous read.
    assign read_src1_data = rf_r[read_src1_idx];
    assign read_src2_data = rf_r[read_src2_idx];   

    // Mapping table
    // wire  [`E203_XLEN-1:0] x0  = rf_r[0];
    // wire  [`E203_XLEN-1:0] x1  = rf_r[1];
    // wire  [`E203_XLEN-1:0] x2  = rf_r[2];
    // wire  [`E203_XLEN-1:0] x3  = rf_r[3];
    // wire  [`E203_XLEN-1:0] x4  = rf_r[4];
    // wire  [`E203_XLEN-1:0] x5  = rf_r[5];
    // wire  [`E203_XLEN-1:0] x6  = rf_r[6];
    // wire  [`E203_XLEN-1:0] x7  = rf_r[7];
    // wire  [`E203_XLEN-1:0] x8  = rf_r[8];
    // wire  [`E203_XLEN-1:0] x9  = rf_r[9];
    // wire  [`E203_XLEN-1:0] x10 = rf_r[10];
    // wire  [`E203_XLEN-1:0] x11 = rf_r[11];
    // wire  [`E203_XLEN-1:0] x12 = rf_r[12];
    // wire  [`E203_XLEN-1:0] x13 = rf_r[13];
    // wire  [`E203_XLEN-1:0] x14 = rf_r[14];
    // wire  [`E203_XLEN-1:0] x15 = rf_r[15];
    // wire  [`E203_XLEN-1:0] x16 = rf_r[16];
    // wire  [`E203_XLEN-1:0] x17 = rf_r[17];
    // wire  [`E203_XLEN-1:0] x18 = rf_r[18];
    // wire  [`E203_XLEN-1:0] x19 = rf_r[19];
    // wire  [`E203_XLEN-1:0] x20 = rf_r[20];
    // wire  [`E203_XLEN-1:0] x21 = rf_r[21];
    // wire  [`E203_XLEN-1:0] x22 = rf_r[22];
    // wire  [`E203_XLEN-1:0] x23 = rf_r[23];
    // wire  [`E203_XLEN-1:0] x24 = rf_r[24];
    // wire  [`E203_XLEN-1:0] x25 = rf_r[25];
    // wire  [`E203_XLEN-1:0] x26 = rf_r[26];
    // wire  [`E203_XLEN-1:0] x27 = rf_r[27];
    // wire  [`E203_XLEN-1:0] x28 = rf_r[28];
    // wire  [`E203_XLEN-1:0] x29 = rf_r[29];
    // wire  [`E203_XLEN-1:0] x30 = rf_r[30];
    // wire  [`E203_XLEN-1:0] x31 = rf_r[31];

endmodule
