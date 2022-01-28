
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/08/21 22:13:47
// Design Name: 
// Module Name: excp_cmt_csr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: excp_cmt is used to organize the cmt interface to csr register.
//                      It will change the status of csr register when excp and int happened.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module excp_cmt_csr(

    // excp_cmt input 
    input                   dbg_mode                         , // from dbg unit  
    input                   excp_top_vld_4irqexcp            ,

    input                   excpirq_flush_req                , // from excp top 
    input                   excpcmt_i_excp_taken_ena         ,
    input                   excpcmt_i_irq_taken_ena          ,

    input                   excpcmt_i_flush_by_alu_agu       , // excp type from excp_top input
    input                   excpcmt_i_flush_req_ebreak       ,   
    input                   excpcmt_i_flush_req_ifu_misalgn  , 
    input                   excpcmt_i_flush_req_ifu_buserr   , 
    input                   excpcmt_i_flush_req_ifu_ilegl    ,   
    
    input [`PC_SIZE-1:0   ] excpcmt_i_epc                    , // from PC
 
    input [`XLEN-1:0      ] excpcmt_i_excp_cause             , // from excp_aluexcp
    input [`XLEN-1:0      ] excpcmt_i_irq_cause              , // from excp_irq
 
    input [`ADDR_SIZE-1:0 ] excpcmt_i_badaddr                , // from excp_top input, means illegal address for mem.
    input [`PC_SIZE-1:0   ] excpcmt_i_pc                     , // from excp_top input
    input [`XLEN-1:0      ] excpcmt_i_instr                  , // from excp_top input
    
    // excp_cmt output  
    output                  excpcmt_o_cause_ena              ,
    output [`XLEN-1:0     ] excpcmt_o_cause                  ,
          
    output                  excpcmt_o_badaddr_ena            ,
    output [`ADDR_SIZE-1:0] excpcmt_o_badaddr                ,
          
    output                  excpcmt_o_epc_ena                ,
    output [`PC_SIZE-1:0  ] excpcmt_o_epc                    ,
          
    output                  excpcmt_o_status_ena             
    );

    ////////////////////////////////////////////////////////////////////////////
    // Update the CSRs (Mcause, .etc)
    // cmt data for mcause register
    assign excpcmt_o_cause_ena    = excpcmt_o_epc_ena;                                                              
    assign excpcmt_o_cause        = excpcmt_i_excp_taken_ena ? excpcmt_i_excp_cause : excpcmt_i_irq_cause; // irq cause is offered by irq unit


    // cmt data for mtval
    // Per Priv Spec v1.10, all trap need to update this register
    // When a trap is taken into M-mode, mtval is written with exception-specific
    // information to assist software in handling the trap. But not all excp will write 
    // valid information (non-zero) to mtval.
    wire   cmt_badaddr_update       =  excpirq_flush_req;                                                 // generate by excp top
    assign excpcmt_o_badaddr_ena    =  excpcmt_o_epc_ena & cmt_badaddr_update;
    assign excpcmt_o_badaddr        =  excpcmt_i_flush_by_alu_agu        ? excpcmt_i_badaddr :
                                       (excpcmt_i_flush_req_ebreak      |
                                        excpcmt_i_flush_req_ifu_misalgn |
                                        excpcmt_i_flush_req_ifu_buserr)  ? excpcmt_i_pc      :
                                        excpcmt_i_flush_req_ifu_ilegl    ? excpcmt_i_instr   :
                                       `ADDR_SIZE'd0;


    // PC data for mepc and mdpc
    assign excpcmt_o_epc_ena        = (~dbg_mode) 
                                    & (excpcmt_i_excp_taken_ena | excpcmt_i_irq_taken_ena) 
                                    & excp_top_vld_4irqexcp;                                             // irq should wait for valid, ready and jump. excp only wait for ready.
    assign excpcmt_o_epc            = excpcmt_i_epc ;                                                    // alu_excp_i_epc is offered by PC unit


    // In the debug mode, epc/cause/status/badaddr will not update badaddr
    // Any trap include exception and irq (exclude dbg_irq) will update mstatus register
    assign excpcmt_o_status_ena  = excpcmt_o_epc_ena;



endmodule
