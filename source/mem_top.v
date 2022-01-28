
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
  
    // send to agu interface  
    output [`XLEN-1:0             ] lsu_o_wbck_wdata      ,
    output                          lsu_o_wbck_err        ,
    
    // ready
    output                          memtop_o_ready        ,

    `ifdef TEST_MODE
      // test ports        
      output [`XLEN-1:0           ] mem_data_t            ,
      output                        lsu_ram_wr_t          ,
      output                        lsu_ram_rd_t          ,
      output [`XLEN-1:0           ] lsu_ram_wdata_t       ,
      output [`XLEN-1:0           ] lsu_ram_addr_t        ,
      output [`XLEN-1:0           ] ram_lsu_rdata_t       , 
      output [1:0                 ] ls_nxt_state_t        ,    
      output [1:0                 ] ls_state_t            ,        
      output [`XLEN-1:0           ] lsu_expend_wmask_t    ,
    `endif 

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
 
        .lsu_o_wr            (      lsu_ram_wr              ),
        .lsu_o_rd            (      lsu_ram_rd              ),
        .lsu_o_wdata         (      lsu_ram_wdata           ),
        .lsu_o_addr          (      lsu_ram_addr            ),
        .ram_i_rdata         (      ram_lsu_rdata           ),
 
        .lsu_o_wbck_wdata    (      lsu_o_wbck_wdata        ),
        .lsu_o_wbck_err      (      lsu_o_wbck_err          ),
 
        .lsu_o_ready         (      memtop_o_ready          ),
        .lsu_i_valid         (      1'b1                    ),
 
        `ifdef TEST_MODE 
         .ls_nxt_state_t     (      ls_nxt_state_t          ),
         .ls_state_t         (      ls_state_t              ),
         .lsu_expend_wmask_t (      lsu_expend_wmask_t      ),
        `endif  
 
        .clk                 (      clk                     ),
        .rst_n               (      rst_n                   )
    ); 
    
    ////////////////////////////////////////////////////////////////////////////////
    // ram unit
    wire lsu_ram_cs = memtop_i_cmd_enable & (~lsu_o_wbck_err); // only read or write when the instr is legal.

    ram_db exu_ram_unit (
        .DB_r                (      ram_lsu_rdata           ),
        .DB_w                (      lsu_ram_wdata           ),
        .address             (      lsu_ram_addr            ),
         
        .wr                  (      lsu_ram_wr              ),
        .rd                  (      lsu_ram_rd              ),
        .cs                  (      lsu_ram_cs              ),
 
        `ifdef TEST_MODE 
         .rd_data_t          (      mem_data_t              ),
        `endif  
 
        .clk                 (      clk                     )
    );

    `ifdef TEST_MODE
        // test port
        assign lsu_ram_wr_t    = lsu_ram_wr    ;
        assign lsu_ram_rd_t    = lsu_ram_rd    ;
        assign lsu_ram_wdata_t = lsu_ram_wdata ;
        assign lsu_ram_addr_t  = lsu_ram_addr  ;
        assign ram_lsu_rdata_t = ram_lsu_rdata ;
    `endif 

endmodule
