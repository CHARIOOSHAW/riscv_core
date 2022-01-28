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
    input  [31:0]      pa          //otp address bus

);

    reg  [31:0] mem [50:0];
    wire [31:0] pa_true = {2'b00,pa[31:2]};

    initial begin
        $readmemb("../instr/instr_new.txt",mem);
        $display("read finished!!!");
    end 

    //----------------------------------usre program	   
    //usr nomal mode read
    assign pdataout = mem[pa_true];



endmodule          
 
