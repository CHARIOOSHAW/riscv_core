//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/07/10 15:16:06
// Design Name: 
// Module Name: agu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Agu is used to calculate the address of mem access. 
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module agu(

    //////////////////////////////////////////////////////////////
    // The General signal for AGU unit.
    //
    input [`XLEN-1:0              ]  agu_i_rs1        ,
    input [`XLEN-1:0              ]  agu_i_rs2        ,
    input [`XLEN-1:0              ]  agu_i_imm        ,
    input [`DECINFO_AGU_WIDTH-1:0 ]  agu_i_info       ,
    input                            agu_i_enable     ,
    input                            memtop_wback_err ,
    input [`XLEN-1:0              ]  memtop_wback_data,
    output                           agu_o_wback_err  ,
    output [`XLEN-1:0             ]  agu_o_wback_data ,

    //////////////////////////////////////////////////////////////
    // To share the ALU datapath, generate interface to ALU
    output                           agu_req_alu      ,
    output [`XLEN-1:0             ]  agu_req_alu_op1  ,
    output [`XLEN-1:0             ]  agu_req_alu_op2  ,
    output                           agu_req_alu_add  ,
    input  [`XLEN-1:0             ]  agu_req_alu_res  ,

    //////////////////////////////////////////////////////////////
    // To LSU
    output                           agu_cmd_enable   ,
    output                           agu_cmd_read     , 
    output                           agu_cmd_write    ,
    output                           agu_cmd_usign    ,
    output [1:0                   ]  agu_cmd_size     , 
    output [`XLEN-1:0             ]  agu_cmd_addr     ,
    output [`XLEN-1:0             ]  agu_cmd_wdata    , 
    output [`XLEN/8-1:0           ]  agu_cmd_wmask    ,
    output                           agu_cmd_misalgn  
    
    );


    // dec agu info bus
    wire       agu_i_load       =  agu_i_info [`DECINFO_AGU_LOAD   ];
    wire       agu_i_store      =  agu_i_info [`DECINFO_AGU_STORE  ];
    wire [1:0] agu_i_size       =  agu_i_info [`DECINFO_AGU_SIZE   ];
    wire       agu_i_usign      =  agu_i_info [`DECINFO_AGU_USIGN  ];
    wire       agu_i_op2imm     =  agu_i_info [`DECINFO_AGU_OP2IMM ];
   
    wire       agu_i_size_b     =  (agu_i_size == 2'b00);
    wire       agu_i_size_hw    =  (agu_i_size == 2'b01);
    wire       agu_i_size_w     =  (agu_i_size == 2'b10);
    
    // load or store align 
    wire       agu_addr_unalgn  =  (agu_i_size_hw &  agu_req_alu_res[0]) | (agu_i_size_w  &  (|agu_req_alu_res[1:0]));

    // alu req
    assign     agu_req_alu_add  =  1'b1; // each load or store instr need add.
    assign     agu_req_alu_op1  =  agu_i_rs1;
    assign     agu_req_alu_op2  =  agu_i_imm;
    assign     agu_req_alu      =  (agu_i_info[2:0] == 3'b001);
 
    // agu to lsu 
    assign     agu_cmd_enable   =  agu_i_enable;
    assign     agu_cmd_read     =  agu_i_load;
    assign     agu_cmd_write    =  agu_i_store;
    assign     agu_cmd_usign    =  agu_i_usign; // usign and size is used for read instrs.
    assign     agu_cmd_size     =  agu_i_size;  // store instrs don't need them.
    assign     agu_cmd_addr     =  agu_req_alu_res;
    assign     agu_cmd_misalgn  =  agu_addr_unalgn;

    // wdata and wmask for store instrs.
    wire [`XLEN-1:0]   algnst_wdata = ({`XLEN{agu_i_size_b }} & {4{agu_i_rs2[ 7:0]}}) |
                                      ({`XLEN{agu_i_size_hw}} & {2{agu_i_rs2[15:0]}}) |
                                      ({`XLEN{agu_i_size_w }} & {1{agu_i_rs2[31:0]}});

    // wask is a 4-bits signal (for 32-bit system), the 1 inside the signal means a 8-bits data is avaliable when cpu store.
    // For example, 4'b0001 mean the lower 8 bits are avaliable for store. And, 4'b0011 mean the lower 16 bits are useful.   
    // shifter is the only one operater which can change the format of data with two signal operands.                               
    wire [`XLEN/8-1:0] algnst_wmask = ({`XLEN/8{agu_i_size_b }} & (4'b0001 << agu_req_alu_res[1:0])) |
                                      ({`XLEN/8{agu_i_size_hw}} & (4'b0011 << {agu_req_alu_res[1],1'b0})) |
                                      ({`XLEN/8{agu_i_size_w }} & (4'b1111));
        
    assign     agu_cmd_wdata    =  algnst_wdata;
    assign     agu_cmd_wmask    =  algnst_wmask;
    
    //////////////////////////////////////////////////////////////////
    // data path
    assign agu_o_wback_data = memtop_wback_data;
    assign agu_o_wback_err  = memtop_wback_err ;
    
endmodule
