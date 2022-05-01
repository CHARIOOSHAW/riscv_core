
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/08/06 15:14:40
// Design Name: 
// Module Name: mem_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: mem_top is the memory unit of core, it includes a lsu_ctrl unit and 
//                      a memory(ram) itself.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"
`include "config.v"

module mem_top(

    // signals from agu
    input                           memtop_i_cmd_enable   ,
    input                           memtop_i_cmd_read     ,
    input                           memtop_i_cmd_write    ,
    input                           memtop_i_cmd_usign    ,
    input  [1:0                   ] memtop_i_cmd_size     ,
    input  [`PC_SIZE-1:0          ] memtop_i_cmd_addr     ,
    input  [`XLEN-1:0             ] memtop_i_cmd_wdata    ,
    input  [`XLEN/8-1:0           ] memtop_i_cmd_wmask    ,
    input                           memtop_i_cmd_misalgn  ,

    // cmt -> lsu
    input                           memtop_i_commit_trap  ,
  
    // send to agu interface  
    output [`XLEN-1:0             ] lsu_o_wbck_wdata      ,
    output                          lsu_o_wbck_err        ,

    // send to ita
    output                          memtop_o_ita_wr       ,    
    output                          memtop_o_ita_rd       , 
    output [`XLEN-1:0             ] memtop_o_ita_wdata    , 
    output [`PC_SIZE-1:0          ] memtop_o_ita_addr     ,
    output                          memtop_o_ita_valid    ,
    input  [`XLEN-1:0             ] memtop_i_ita_rdata    , 
    input                           memtop_i_ita_ready    ,

    // valid & ready
    output                          memtop_o_ready        ,
    input                           memtop_i_valid        , // from agu

    // clk and rst_n  
    input                           clk                   ,
    input                           rst_n                 
                        
    );

    /////////////////////////////////////////////////////////////////////////////
    // internal signal between lsu and ram
    
    wire                            lsu_ram_wr            ;
    wire                            lsu_ram_rd            ;
    wire [`XLEN-1:0               ] lsu_ram_wdata         ;
    wire [`XLEN-1:0               ] lsu_ram_addr          ;
    wire [`XLEN-1:0               ] ram_lsu_rdata         ;
    wire                            lsu_ram_valid         ;
    wire                            ram_lsu_ready         ;


    /////////////////////////////////////////////////////////////////////////////
    // lsu unit
    lsu_ctrl exu_lsu (
        
        .agu_i_cmd_enable    (      memtop_i_cmd_enable     ),
        .agu_i_cmd_read      (      memtop_i_cmd_read       ),
        .agu_i_cmd_write     (      memtop_i_cmd_write      ),
        .agu_i_cmd_usign     (      memtop_i_cmd_usign      ),
        .agu_i_cmd_size      (      memtop_i_cmd_size       ),
        .agu_i_cmd_addr      (      memtop_i_cmd_addr       ),
        .agu_i_cmd_wdata     (      memtop_i_cmd_wdata      ),
        .agu_i_cmd_wmask     (      memtop_i_cmd_wmask      ),
        .agu_i_cmd_misalgn   (      memtop_i_cmd_misalgn    ),

        .lsu_i_commit_trap   (      memtop_i_commit_trap    ),
 
        .lsu_ram_wr          (      lsu_ram_wr              ),
        .lsu_ram_rd          (      lsu_ram_rd              ),
        .lsu_ram_wdata       (      lsu_ram_wdata           ),
        .lsu_ram_addr        (      lsu_ram_addr            ),
        .ram_lsu_rdata       (      ram_lsu_rdata           ),
        .lsu_ram_valid       (      lsu_ram_valid           ),
        .ram_lsu_ready       (      ram_lsu_ready           ),

        .lsu_ita_wr          (      memtop_o_ita_wr         ),
        .lsu_ita_rd          (      memtop_o_ita_rd         ), 
        .lsu_ita_wdata       (      memtop_o_ita_wdata      ), 
        .lsu_ita_addr        (      memtop_o_ita_addr       ), 
        .lsu_ita_valid       (      memtop_o_ita_valid      ), 
        .ita_lsu_rdata       (      memtop_i_ita_rdata      ), 
        .ita_lsu_ready       (      memtop_i_ita_ready      ),
 
        .lsu_o_wbck_wdata    (      lsu_o_wbck_wdata        ),
        .lsu_o_wbck_err      (      lsu_o_wbck_err          ),
 
        .lsu_o_ready         (      memtop_o_ready          ),
        .lsu_i_valid         (      memtop_i_valid          ),
 
        .clk                 (      clk                     ),
        .rst_n               (      rst_n                   )
    ); 
    
    ////////////////////////////////////////////////////////////////////////////////
    // ram unit
    wire lsu_ram_cs = lsu_ram_valid & (~lsu_o_wbck_err); // only read or write when the instr is legal.

    ram_module exu_ram_unit (
        .DB_r                (      ram_lsu_rdata           ),
        .DB_w                (      lsu_ram_wdata           ),
        .address             (      lsu_ram_addr            ),
         
        .wr                  (      lsu_ram_wr              ),
        .rd                  (      lsu_ram_rd              ),
        .cs                  (      lsu_ram_cs              ),
        
        .valid               (      lsu_ram_valid           ),
        .ready               (      ram_lsu_ready           ),
        .clk                 (      clk                     )
    );

   
endmodule
