
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/08/20 16:11:36
// Design Name: 
// Module Name: excp_irq
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: IRQ is a part of excp unit which is used to handle interrupt for wfi
//                      and other types of interrupts.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module excp_irq(
    //clk
    input                       clk                 ,

    // dbg mode
    input                       dbg_mode            ,
      
    // int signals     
    // The int here is arbitraged by ita unit, which would delay if jump instr is excuting or not-vld.
    input                       ext_irq             ,
    input                       sft_irq             ,
    input                       tmr_irq             ,
           
    // irq shield signals from csr           
    input                       status_mie_r        ,
    input                       meie_r              ,
    input                       msie_r              ,
    input                       mtie_r              ,
    
    // wfi indicator from excp top 
    input                       irq_i_wfi_flag_r    ,

    // output
    output                      irq_o_irq_req_active, // INT VALID indicator
    output                      irq_o_wfi_irq_req   , // WFI INT
    output                      irq_o_irq_req       , // INT needs to be processed
    output [`XLEN-1:0         ] irq_o_irq_cause       // the type of INT

    );

    ////////////////////////////////////////////////////////////////////////////
    // The IRQ triggered Exception 
    // The debug mode will mask off the interrupts   
    // mie is the global fence of irq.
    wire irq_req_raw             = (ext_irq   & meie_r) |     
                                   (sft_irq   & msie_r) |     
                                   (tmr_irq   & mtie_r) ;     
    
    // mie_r expand 1 clk for pipe_flush
    reg status_mie_re;
    always@(posedge clk) begin
        status_mie_re <= status_mie_r;
    end
    wire status_mie_w2_r = status_mie_re | status_mie_r;

    wire irq_req         = (~dbg_mode & status_mie_w2_r) & irq_req_raw ;


    /////////////////////////////////////////////////////////////////////////////
    // WFI 
    wire wfi_irq_req             = (~dbg_mode) & irq_req_raw ;                // INT can always end wfi if core is not in the dbg mode. 
  
    assign irq_o_irq_req_active  = irq_i_wfi_flag_r ? wfi_irq_req : irq_req;  // This signal is used to quit wfi if core is sleeping. 
    assign irq_o_irq_req         = irq_req;                                   // This signal is used to control the irq handle process. to PC i_interrupt.
    assign irq_o_wfi_irq_req     = wfi_irq_req;
    
    ////////////////////////////////////////////////////////////////////////////
    // IRQ CAUSE
    assign irq_o_irq_cause[31]   =  1'b1;
    assign irq_o_irq_cause[30:4] =  27'b0;
    assign irq_o_irq_cause[3:0]  =  (sft_irq & msie_r) ? 4'd3  :            // 3  Machine software interrupt
                                    (tmr_irq & mtie_r) ? 4'd7  :            // 7  Machine timer interrupt
                                    (ext_irq & meie_r) ? 4'd11 :            // 11 Machine external interrupt
                                                         4'd0  ;            // INT UNVALID

endmodule
