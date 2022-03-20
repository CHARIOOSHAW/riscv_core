
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/09/21 22:27:15
// Design Name: 
// Module Name: ifu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: ifu_top includes ifu, pc_control and itcm which can operate 
//                      independently.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module ifu_top(

    // instr length
    input                           ifu_i_rv32               ,
   
    // handshake interface   
    output                          ifu_o_ifu_valid          ,
    input                           ifu_i_exu_ready          ,

    // flush req from exu
    input                           exu_ifu_i_pipe_flush_req ,
    input                           ifu_i_bjp_flush_req      ,
    input  [`PC_SIZE-1:0          ] ifu_i_bjp_flush_pc       ,

    // pc output from ifu
    output [`PC_SIZE-1:0          ] ifu_pc_nxt               ,
    output [`PC_SIZE-1:0          ] ifu_pc_r                 ,
             
    // IR output from ifu             
    output [`XLEN-1:0             ] ifu_ir_r                 ,
   
    // int and trap related vld and epc
    input  [`PC_SIZE-1:0          ] ifu_i_mtvec              , 
    input                           ifu_i_irq_req            , // exu_excp -> pc
    input                           ifu_i_int_pending_flag   , // ita -> pc
    input                           ifu_i_excp               ,
    output [`PC_SIZE-1:0          ] ifu_o_wbck_epc           ,
                 
    input                           clk                      ,
    input                           rst_n

    );

    //////////////////////////////////////////////////////////////////////////////
    // U1: ifu
    // Description: ifu controls the inter-connection between itcm and pc. It also 
    //              outputs the valid signal which is important for the whole system.
    //////////////////////////////////////////////////////////////////////////////
    wire [`XLEN-1:0               ] itcm_ifu_ir    ;
    wire [`PC_SIZE-1:0            ] pc_ifu_pc_nxt  ; 
    wire [`PC_SIZE-1:0            ] ifu_flash_pc   ;
    wire                            ifu_flash_enable;

    assign ifu_pc_nxt = pc_ifu_pc_nxt;

    ifu IFU (

        // IR related signals for ifu.
        .itcm_ifu_i_ir          ( itcm_ifu_ir               ),
        .ifu_o_ir_r             ( ifu_ir_r                  ),
                           
        // IFU raw PC.                           
        .pc_ifu_i_pc_nxt        ( pc_ifu_pc_nxt             ),
        .ifu_o_pc_init_use      ( ifu_pc_init_use           ),
        .ifu_flash_o_pc         ( ifu_flash_pc              ),
        .ifu_flash_o_enable     ( ifu_flash_enable          ),
                           
        // EXU req pipe-flush.                           
        .exu_ifu_pipe_flush_req ( exu_ifu_i_pipe_flush_req  ),
        
        // handshake interface with exu
        .ifu_o_ifu_valid        ( ifu_o_ifu_valid           ),
        .ifu_i_exu_ready        ( ifu_i_exu_ready           ),
                           
        .clk                    ( clk                       ),
        .rst_n                  ( rst_n                     )
    );

    ///////////////////////////////////////////////////////////////////////////////
    // U2: PC
    // Description: PC is used to control the reading of instr from tcm.
    //////////////////////////////////////////////////////////////////////////////
    PC PC_CONTROL (
        .pc_i_irq_req           ( ifu_i_irq_req             ),  // exu -> pc
        .pc_i_int_pending_flag  ( ifu_i_int_pending_flag    ),  // ita -> pc

        .pc_i_excp              ( ifu_i_excp                ),
        .pc_i_mtvec             ( ifu_i_mtvec               ),
        .pc_i_init_use          ( ifu_pc_init_use           ),
                    
        .pc_i_bjp_req_flush     ( ifu_i_bjp_flush_req       ),
        .pc_i_bjp_req_fulsh_pc  ( ifu_i_bjp_flush_pc        ),
            
        .pc_i_rv32              ( ifu_i_rv32                ),
                    
        .pc_i_ifu_valid         ( ifu_o_ifu_valid           ),
        .pc_i_exu_ready         ( ifu_i_exu_ready           ),
                    
        .pc_o_pcnxt             ( pc_ifu_pc_nxt             ),
        .pc_o_pcr               ( ifu_pc_r                  ),                          
        .pc_o_wbck_epc          ( ifu_o_wbck_epc            ),
                            
        .clk                    ( clk                       ),
        .rst_n                  ( rst_n                     )
    );

    //////////////////////////////////////////////////////////////////////////////
    // U3: itcm
    // Description: itcm
    //////////////////////////////////////////////////////////////////////////////

    otp4k8 itcm(
        .pdataout               ( itcm_ifu_ir               ),
        .pa                     ( ifu_flash_pc              ),

        .flash_i_ifu_enable     ( ifu_flash_enable          ),

        .clk                    ( clk                       )
    );

endmodule
