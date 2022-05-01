//for simulation
//ram.v
`include "mcu_defines.v"

module ram_module (

    input      [31:0]  DB_w    , // ram data bus
    output reg [31:0]  DB_r    ,
    input      [31:0]  address , // address bus
    input              wr      , // write signal
    input              clk     , // clk
    input              cs      , // ram select signal
    input              rd      ,
    
    input              valid   ,
    output             ready

);

    reg [31:0]  mem [50:0];

    always @(posedge clk)
        if(cs & wr & ~rd)
            mem[address] <= DB_w;

    always @(posedge clk)
       if(cs & ~wr & rd)
            DB_r <= mem[address];

    wire [`XLEN-1:0 ] rd_data_t0 = mem[0];
    wire [`XLEN-1:0 ] rd_data_t1 = mem[1];
    wire [`XLEN-1:0 ] rd_data_t2 = mem[2];

    reg  [1:0       ] mem_count;

    always@(posedge clk or negedge cs) begin
        if (~cs) 
            mem_count <= 2'b00;
        else begin:count
            mem_count <= mem_count + 2'b01;
        end
    end
    
    assign ready = (mem_count == 2'b11) & valid;
    
endmodule
