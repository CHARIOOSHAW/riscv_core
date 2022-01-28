
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw 
// 
// Create Date: 2021/06/18 13:44:53
// Design Name: 
// Module Name: PC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: PC.v is used to generate the PC of next instructiuon which belongs to ifu. 
//                      And send valid PC to epc and dpc. 
// 
//////////////////////////////////////////////////////////////////////////////////

`include "mcu_defines.v"

module PC(

    // PC related signals
    input                             pc_i_interrupt         , // interrupt happened
    input                             pc_i_excp              , // err or illegal happened
    input  [`PC_SIZE-1:0]             pc_i_mtvec             ,
    input                             pc_i_init_use          ,

    input                             pc_i_alu_req_flush     , // jump/bxx/ret instr
    input  [`PC_SIZE-1:0]             pc_i_alu_req_fulsh_pc  , 
          
    input                             pc_i_rv32              , // get the length of instr from exu.

    input                             pc_i_ifu_valid         ,
    input                             pc_i_exu_ready         ,

    output [`PC_SIZE-1:0]             pc_o_pcnxt             , // Next PC. 
    output [`PC_SIZE-1:0]             pc_o_pcr               , // PC register, the current PC.

    output                            pc_o_interrupt_ack     ,
    output                            pc_o_vld_4irqexcp      ,
    output [`PC_SIZE-1:0]             pc_o_wbck_epc          , // The wbck interface for writing epc and dpc registers.
    
    input                             clk                    ,
    input                             rst_n
    );

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // One more thing, PC has to arbitrage whether the interrupt signal is valid or not.
    // The interrupt signal will be masked and recorded when it meet alu_req_flush.
    // It will wait for the excution of jump instr and return pc_r to epc or dpc registers rather than pc_r+2 or pc_r+4.
    // Here, we arbitrage the interrupt signal.
    // For detail:
    // 1. Int comes and no alu request flush. Interrupt_ack set and return pc_r+2 or pc_r+4 to epc(dpc).
    // 2. Int comes and alu request flush at the same time. Interrupt_ack clr and int_flag_r set. 
    //    Wait for the excution finished, clear int_flag_r, set Interrupt_ack and return pc_r.

    // int ack
    wire   int_flag_r;
    wire   interrupt_ack      =  (pc_i_interrupt & ~pc_i_alu_req_flush                                  ) |
                                 (int_flag_r     & ~pc_i_alu_req_flush & pc_i_ifu_valid & pc_i_exu_ready) ;
    assign pc_o_interrupt_ack =  interrupt_ack                                      ;
    
    // pc_valid    
    wire   pc_vld_4irqexcp    =   interrupt_ack | pc_i_excp                         ;
    assign pc_o_vld_4irqexcp  =   pc_vld_4irqexcp                                   ;

    // int flag
    wire int_flag_set;
    wire int_flag_clr;
    wire int_flag_nxt;

    assign int_flag_set = (pc_i_interrupt & pc_i_alu_req_flush) | (pc_i_interrupt & ~(pc_i_exu_ready & pc_i_ifu_valid));
    assign int_flag_clr = interrupt_ack;
    assign int_flag_nxt = int_flag_clr? 1'b0: int_flag_set? 1'b1: int_flag_r;

    sirv_gnrl_dfflr #(.DW(1)) int_flag (
        .lden (1'b1         ),
        .dnxt (int_flag_nxt ),
        .qout (int_flag_r   ),
        .clk  (clk          ),
        .rst_n(rst_n        )
    );

    // wbck epc
    // excp and int which is piority?
    wire [`PC_SIZE-1:0] PC_r;
    assign pc_o_wbck_epc = (interrupt_ack & int_flag_r              )? PC_r     :
                           (interrupt_ack & ~int_flag_r &  pc_i_rv32)? PC_r+'d4 :
                           (interrupt_ack & ~int_flag_r & ~pc_i_rv32)? PC_r+'d2 :
                            pc_i_excp                                ? PC_r     :
                                                                       'd0      ; // UNVALID


    /////////////////////////////////////////////////////////////////////////////////////////
    // Basic PC control and calculation.
    wire [`PC_SIZE-1:0] PC_nxt;

    // Flush and PC
    wire                need_flush =  interrupt_ack | pc_i_excp     | pc_i_alu_req_flush    ;
    wire [`PC_SIZE-1:0] PC_flush   = (interrupt_ack | pc_i_excp)    ? pc_i_mtvec            : // Here need to be specific, dbg mode is not taken considered.
                                      pc_i_alu_req_flush            ? pc_i_alu_req_fulsh_pc :
                                                                      'd0                   ; // UNVALID
    // wire                PC_stop    =  ~(pc_i_ifu_valid & pc_i_exu_ready); // PC will stop and wait for excution when meet multi-cycle instrs.
                                     
    assign PC_nxt = need_flush      ?    PC_flush   :
                    pc_i_init_use   ?    `PC_SIZE'd0:
                    // PC_stop      ?    PC_r       :
                    pc_i_rv32       ?    PC_r+'d4   :
                    ~pc_i_rv32      ?    PC_r+'d2   :
                    'd0;

    sirv_gnrl_dfflr #(.DW(`PC_SIZE)) pcr (
        .lden ( pc_i_ifu_valid & pc_i_exu_ready ),
        .dnxt (PC_nxt   ),
        .qout (PC_r     ),
        .clk  (clk      ),
        .rst_n(rst_n    )
    );  

    assign pc_o_pcr    = PC_r   ;
    assign pc_o_pcnxt  = PC_nxt ;
                                     
endmodule
