/******************************************************************************
*
*    File Name:  otp4k8.v
*      Version:  0
*         Date:  june 1, 2021
*        Model:  otp4k8 
* Dependencies:  
*
*      Company:  mixchips
*
******************************************************************************/


`include "mcu_defines.v"
`include "config.v"

module otp4k8(

    output [31:0]      pdataout ,  //data read from otp
    input  [31:0]      pa       ,  //otp address bus

    input              flash_i_ifu_enable,

    input              clk

);
    
    reg  [31:0] mem [50:0];
    wire [31:0] pa_true = {2'b00,pa[31:2]};

    initial begin
        $readmemb("../instr/instr.txt",mem);
        $display("read finished!!!");
    end 

    //----------------------------------usre program	   
    //usr nomal mode read
    reg [31:0] data_out;
    always@(posedge clk) begin
        if (flash_i_ifu_enable)
            data_out <= mem[pa_true];
        else
            data_out <= data_out;
    end

    assign pdataout = data_out;


endmodule          
 
