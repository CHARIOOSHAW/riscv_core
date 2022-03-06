
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
    input                             pc_i_irq_req           , // fenced irq req from exu_excp, exu_excp -> pc
    input                             pc_i_int_pending_flag  , // ita -> pc

    input                             pc_i_excp              , // err or illegal happened
    input  [`PC_SIZE-1:0]             pc_i_mtvec             ,
    input                             pc_i_init_use          ,

    input                             pc_i_bjp_req_flush     , // jump/bxx/ret instr
    input  [`PC_SIZE-1:0]             pc_i_bjp_req_fulsh_pc  , 
          
    input                             pc_i_rv32              , // get the length of instr from exu.

    input                             pc_i_ifu_valid         ,
    input                             pc_i_exu_ready         ,

    output [`PC_SIZE-1:0]             pc_o_pcnxt             , // Next PC. 
    output [`PC_SIZE-1:0]             pc_o_pcr               , // PC register, the current PC.
    output [`PC_SIZE-1:0]             pc_o_wbck_epc          , // The wbck interface for writing epc and dpc registers.
    
    input                             clk                    ,
    input                             rst_n
    );
 
    // wbck epc
    // excp and int which is piority?
    wire [`PC_SIZE-1:0] PC_r;
    assign pc_o_wbck_epc = (pc_i_irq_req &  pc_i_int_pending_flag             )? PC_r     :
                           (pc_i_irq_req & ~pc_i_int_pending_flag &  pc_i_rv32)? PC_r+'d4 :
                           (pc_i_irq_req & ~pc_i_int_pending_flag & ~pc_i_rv32)? PC_r+'d2 :
                            pc_i_excp                                          ? PC_r     :
                                                                                 'd0      ; // UNVALID


    /////////////////////////////////////////////////////////////////////////////////////////
    // Basic PC control and calculation.
    wire [`PC_SIZE-1:0] PC_nxt;

    // Flush and PC
    wire                need_flush =  pc_i_irq_req | pc_i_excp     | pc_i_bjp_req_flush    ;
    wire [`PC_SIZE-1:0] PC_flush   = (pc_i_irq_req | pc_i_excp)    ? pc_i_mtvec            : // Here need to be specific, dbg mode is not taken considered.
                                      pc_i_bjp_req_flush           ? pc_i_bjp_req_fulsh_pc :
                                                                     'd0                   ; // UNVALID 
                                     
    assign PC_nxt = need_flush                      ?    PC_flush   :
                    pc_i_init_use                   ?    `PC_SIZE'd0:
                    pc_i_rv32                       ?    PC_r+'d4   :
                    ~pc_i_rv32                      ?    PC_r+'d2   :
                                                         'd0;

    sirv_gnrl_dfflr #(.DW(`PC_SIZE)) pcr (
        .lden ( pc_i_ifu_valid & pc_i_exu_ready    ),
        .dnxt ( PC_nxt   ),
        .qout ( PC_r     ),
        .clk  ( clk      ),
        .rst_n( rst_n    )
    );  

    assign pc_o_pcr    = PC_r   ;
    assign pc_o_pcnxt  = PC_nxt ;
                                     
endmodule
