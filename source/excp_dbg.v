
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/08/23 13:31:53
// Design Name: 
// Module Name: excp_dbg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: excp_dbg is used to control the state of dbg_irqexcp related signals.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module excp_dbg(

    input                     alu_ebreakm_flush_req   , // from excp_aluexcp
                       
    input                     dbg_irq_r               , // from dbg unit
    input                     dbg_halt_r              ,
    input                     dbg_step_r              ,
    input                     dbg_mode                ,
   
    input                     cmt_ena                 , // from cmt top
    input                     dbg_entry_taken_ena     , // from excp top 
   
    output                    dbg_step_req            ,
    output                    dbg_trig_req            ,
    output                    dbg_ebrk_req            ,
    output                    dbg_irq_req             ,
    output                    nonalu_dbg_irq_req      ,
    output                    dbg_halt_req            ,
    output                    nonalu_dbg_halt_req     ,

    output                    nonalu_dbg_entry_req    ,
    output                    nonalu_dbg_entry_req_raw,
    output                    dbg_entry_req           ,

    input                     clk                     ,
    input                     rst_n
    );

    `ifndef E203_SUPPORT_TRIGM//{
        // We dont support the HW Trigger Module yet
        wire alu_dbgtrig_flush_req_novld = 1'b0;
        wire alu_dbgtrig_flush_req       = 1'b0;
    `endif

    // The DebugMode-entry triggered Exception 
    // The priority from top to down
    // dbg_trig_req ? 3'd2 : 
    // dbg_ebrk_req ? 3'd1 : 
    // dbg_irq_req  ? 3'd3 : 
    // dbg_step_req ? 3'd4 :
    // dbg_halt_req ? 3'd5 : 

    // Since the step_req_r is last cycle generated indicated, means last instruction is single-step
    //   and it have been commited in non debug-mode, and then this cyclc step_req_r is the of the highest priority
    wire step_req_r;
    assign dbg_step_req        = step_req_r;
    assign dbg_trig_req        = alu_dbgtrig_flush_req & (~step_req_r);
    assign dbg_ebrk_req        = alu_ebreakm_flush_req & (~alu_dbgtrig_flush_req) & (~step_req_r);
    assign dbg_irq_req         = dbg_irq_r  & (~alu_ebreakm_flush_req) & (~alu_dbgtrig_flush_req) & (~step_req_r);
    assign nonalu_dbg_irq_req  = dbg_irq_r & (~step_req_r);

    // The step have higher priority, and will preempt the halt
    assign dbg_halt_req        = dbg_halt_r & (~dbg_irq_r) & (~alu_ebreakm_flush_req) & (~alu_dbgtrig_flush_req) & (~step_req_r) & (~dbg_step_r);
    assign nonalu_dbg_halt_req = dbg_halt_r & (~dbg_irq_r) & (~step_req_r) & (~dbg_step_r);
    
    // The debug-step request will be set when currently the step_r is high, and one 
    //   instruction (in non debug_mode) have been executed
    // The step request will be clear when 
    //   core enter into the debug-mode 
    wire step_req_set = (~dbg_mode) & dbg_step_r & cmt_ena & (~dbg_entry_taken_ena);
    wire step_req_clr = dbg_entry_taken_ena;
    wire step_req_ena = step_req_set | step_req_clr;
    wire step_req_nxt = step_req_set | (~step_req_clr);
    sirv_gnrl_dfflr #(1) step_req_dfflr (step_req_ena, step_req_nxt, step_req_r, clk, rst_n);

    // The debug-mode will mask off the debug-mode-entry
    wire   dbg_entry_mask           = dbg_mode;
    assign dbg_entry_req            = (~dbg_entry_mask) & (dbg_irq_req  |
                                                           dbg_halt_req |
                                                           dbg_step_req |
                                                           dbg_trig_req |
                                                           dbg_ebrk_req );
    
    assign nonalu_dbg_entry_req     = (~dbg_entry_mask) & (nonalu_dbg_irq_req | nonalu_dbg_halt_req | dbg_step_req);

    assign nonalu_dbg_entry_req_raw = (~dbg_entry_mask) & (dbg_irq_r | dbg_halt_r | step_req_r);

endmodule
