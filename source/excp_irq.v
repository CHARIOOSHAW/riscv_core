
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

    // dbg mode
    input                       dbg_mode            ,
      
    // int signals     
    // The int here is arbitraged by PC unit, which would delay if jump instr is excuting or not-vld.
    input                       ext_irq_r           ,
    input                       sft_irq_r           ,
    input                       tmr_irq_r           ,
           
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
    wire irq_mask                = dbg_mode | (~status_mie_r);                // Regular interrupt will be masked off because dbg mode or global irq shield.
    wire wfi_irq_mask            = dbg_mode ;                                 // WFI interrupt is used to stop the sleep stage of core. 
               
    wire irq_req_raw             = (ext_irq_r & meie_r) |     
                                   (sft_irq_r & msie_r) |     
                                   (tmr_irq_r & mtie_r) ;     
         
    wire irq_req                 = (~irq_mask    ) & irq_req_raw ;            
    wire wfi_irq_req             = (~wfi_irq_mask) & irq_req_raw ;            // INT can always end wfi if core is not in the dbg mode. 
 
 
    assign irq_o_irq_req_active  = irq_i_wfi_flag_r ? wfi_irq_req : irq_req;  // This signal is used to quit wfi if core is sleeping. 
    assign irq_o_irq_req         = irq_req;                                   // This signal is used to control the irq handle process. to PC i_interrupt.
    assign irq_o_wfi_irq_req     = wfi_irq_req;
    
    assign irq_o_irq_cause[31]   =  1'b1;
    assign irq_o_irq_cause[30:4] =  27'b0;
    assign irq_o_irq_cause[3:0]  =  (sft_irq_r & msie_r) ? 4'd3  :      // 3  Machine software interrupt
                                    (tmr_irq_r & mtie_r) ? 4'd7  :      // 7  Machine timer interrupt
                                    (ext_irq_r & meie_r) ? 4'd11 :      // 11 Machine external interrupt
                                                           4'd0  ;      // INT UNVALID

endmodule
