
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/08/20 17:34:57
// Design Name: 
// Module Name: excp_wfi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: excp_wfi is used to handle wfi instr and generate wfi_flag_r which means
//                      core is sleeping now.
// 
//////////////////////////////////////////////////////////////////////////////////


module excp_wfi(

    // irq indicators for irq and top
    input                wfi_i_irq_req                  , // interrupt request. for flag_r.

    // instr indicator from decoder
    input                excp_i_alu_wfi                 , // a wfi instr arrived.

    // halt signal from GC
    input                wfi_i_wfi_halt_ack             ,

    // output 
    output               wfi_o_wfi_flag_r               , // core is sleeping 
    output               wfi_o_core_wfi                 , // core is sleeping but clr can be felt. When core_wfi is released, the core will awake at the next posedge of clk.

    input                clk                            ,
    input                rst_n                

    );
    ///////////////////////////////////////////////////////////////////////////
    // The expc unit is writen according to the E203 core.
    // I have made some comments for each signal. 
    // However some sturctures still need to be fixed in the further validation.
    //////////////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////////
    // WFI CONTROL UNIT
    // WFI flag generation
    // WFI instr is achieved with GC. GC will lock the flip of clock after it is request for wfi and no task is remained unfinished.
    // So the ack signals are generated by GC inside IFU and EXU.
    // But, in our design, all instrs will be handled sequentially. So only one GC is enough for both IFU and EXU.
    // The halt_ack is set to 1 constantly.
    // The wfi_flag will be set if there is a WFI instruction halt req
    wire wfi_flag_clr;
    wire wfi_flag_set = excp_i_alu_wfi       & 
                        (~wfi_flag_clr)      &
                        wfi_i_wfi_halt_ack   ;

    // The wfi_flag will be cleared if there is interrupt pending, or debug entry request
    // WFI begins with instr and ended by interrupt or dbg.
    assign wfi_flag_clr = wfi_i_irq_req        ;

    // If meanwhile set and clear, then clear preempt.
    // The state of flag_r is permit to change when flag_r need to be set or clear.
    wire wfi_flag_ena = wfi_flag_set | wfi_flag_clr;

    // the nxt state of wfi_flag
    // clr is more significant than set.
    wire wfi_flag_r    ; // WFI indicator 
    wire wfi_flag_nxt = (wfi_flag_set | wfi_flag_r) & (~wfi_flag_clr);
    sirv_gnrl_dfflr #(1) wfi_flag_dfflr (wfi_flag_ena, wfi_flag_nxt, wfi_flag_r, clk, rst_n);

    // core_wfi represents the cpu core is under the wfi state.
    assign core_wfi = wfi_flag_r & (~wfi_flag_clr);

    //output 
    assign wfi_o_wfi_flag_r  = wfi_flag_r ;
    assign wfi_o_core_wfi    = core_wfi   ;
    
endmodule