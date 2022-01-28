
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/09/23 16:28:28
// Design Name: 
// Module Name: sim_core_top
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


module sim_core_top;
    reg  sim_pc_init_use      ;
    reg  sim_extenal_interrupt;
    reg  sim_rst_n            ;

    wire sim_core_wfi         ;     
    wire sim_core_unexcp_err  ;

    reg  sim_clk              ;
    wire sim_clk_aon          ;
     
    core_top CT(
        .pc_init_use       ( sim_pc_init_use       ),
        .extenal_interrupt ( sim_extenal_interrupt ),
        .core_wfi          ( sim_core_wfi          ),  
        .core_unexcp_err   ( sim_core_unexcp_err   ), 
        .clk               ( sim_clk               ),
        .clk_aon           ( sim_clk_aon           ),
        .rst_n             ( sim_rst_n             )
        );


    always #5 sim_clk     = ~sim_clk;
    assign    sim_clk_aon = sim_clk ;

    initial begin
        $display("Let's go!");
        sim_clk = 1'b0;
        #0 sim_rst_n = 1'b0;
        #80 sim_rst_n = 1'b1;
           sim_pc_init_use = 1'b0;      
           sim_extenal_interrupt = 1'b0;
        $display("so we finished.");
    end

    initial begin
	  #200 $finish();
    end 


    `ifdef FSDB
        initial begin
            $fsdbDumpfile("wave_core_top.fsdb");
            $fsdbDumpvars;
            $display("Dump finished.");
        end
    `endif

endmodule