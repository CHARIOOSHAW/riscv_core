
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/07/31 21:27:23
// Design Name: 
// Module Name: muldiv_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: muldiv_top is used to control the mul&div unit according to cycle and decoded instr.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module muldiv_top(

    //////////////////////////////////////////////////////////////
    // The General signal for MULDIV unit.
    //
    input  [`XLEN-1:0                 ]  muldiv_i_rs1           ,
    input  [`XLEN-1:0                 ]  muldiv_i_rs2           ,
    input  [`DECINFO_MULDIV_WIDTH-1:0 ]  muldiv_i_info          ,

    // pc control
    input  [`MAX_DELAY_WIDTH-1:0      ]  pc_cycle               ,

    //////////////////////////////////////////////////////////////
    // To share the ALU datapath, generate interface to ALU
    output                               muldiv_req_alu         ,
    output [`XLEN-1:0                 ]  muldiv_req_alu_op1     ,
    output [`XLEN-1:0                 ]  muldiv_req_alu_op2     ,
    output                               muldiv_req_alu_ltu     ,
    input  [`XLEN-1:0                 ]  muldiv_req_alu_res     ,
    input                                muldiv_req_alu_cmp_res ,

    //////////////////////////////////////////////////////////////
    // output 
    output                               muldiv_illegal         ,
    output [`XLEN-1:0                 ]  muldiv_wbck_res        ,

    `ifdef TEST_MODE
      /////////////////////////////////////////////////////////////
      // test port
      output                             div_sel_en_t           ,
      output                             mul_sel_en_t           ,
      output                             muldiv_start_en_t      ,
    `endif 

    input                                clk                    
    );

    // info bus
    wire rv32_mul            =   muldiv_i_info[`DECINFO_MULDIV_MUL   ];   
    wire rv32_mulh           =   muldiv_i_info[`DECINFO_MULDIV_MULH  ];
    wire rv32_mulhsu         =   muldiv_i_info[`DECINFO_MULDIV_MULHSU];
    wire rv32_mulhu          =   muldiv_i_info[`DECINFO_MULDIV_MULHU ];
    wire rv32_div            =   muldiv_i_info[`DECINFO_MULDIV_DIV   ];
    wire rv32_divu           =   muldiv_i_info[`DECINFO_MULDIV_DIVU  ];
    wire rv32_rem            =   muldiv_i_info[`DECINFO_MULDIV_REM   ];
    wire rv32_remu           =   muldiv_i_info[`DECINFO_MULDIV_REMU  ];
        
    // sel enable    
    wire div_sel_en          =   |({rv32_div, rv32_divu, rv32_rem, rv32_remu})       ;
    wire mul_sel_en          =   |({rv32_mul, rv32_mulh, rv32_mulhsu,rv32_mulhu})    ;
    wire muldiv_start_en     =   (pc_cycle == 6'b000001) & (div_sel_en | mul_sel_en) ;  // Both mul and div instrs need "start" cycle.
    wire div_fix_en          =   (pc_cycle == 6'b100010) &  div_sel_en               ;  // Only div instr need "fix" cycle.

    `ifdef TEST_MODE
      assign div_sel_en_t      =   div_sel_en      ;
      assign mul_sel_en_t      =   mul_sel_en      ;
      assign muldiv_start_en_t =   muldiv_start_en ;
      assign div_fix_en_t      =   div_fix_en      ;
    `endif

    // operand 
    wire                     muldiv_op1_unsigned = |({rv32_mulhu, rv32_divu, rv32_remu});
    wire                     muldiv_op2_unsigned = |({rv32_mulhsu, rv32_mulhu, rv32_divu, rv32_remu});

    wire [`MULOP_LEN-1:0 ]   muldiv_signed_op1 = muldiv_op1_unsigned? {1'b0, muldiv_i_rs1}: {muldiv_i_rs1[`MULOP_LEN-2], muldiv_i_rs1}; // Extend 1 bit to sign the operands.
    wire [`MULOP_LEN-1:0 ]   muldiv_signed_op2 = muldiv_op2_unsigned? {1'b0, muldiv_i_rs2}: {muldiv_i_rs2[`MULOP_LEN-2], muldiv_i_rs2};

    // res
    wire [2*`MULOP_LEN-1:0 ] muldiv_mul_res;
    wire [`DIVOP_LEN-1:0   ] muldiv_rem_res;
    wire [`DIVOP_LEN-1:0   ] muldiv_quo_res;

    // There are still some modules or registers can be reused betweem mul&div&dpath.
    // However, the length of signals is not strictly idential which limit the implement of reusing.
    // Still, it is a possible direction for further optimization.
    div multi_cycle_divider (

        // decoded operation signals 
        .div_op1             ( muldiv_signed_op1       ),  
        .div_op2             ( muldiv_signed_op2       ),  

        // control signals
        .div_sel_en          ( div_sel_en              ),
        .div_start_en        ( muldiv_start_en         ),  
        .div_fix_en          ( div_fix_en              ),  
                         
        // result outputs                         
        .quo_res             ( muldiv_quo_res          ),
        .rem_res             ( muldiv_rem_res          ),
                         
        // div2alu req                          
        .div_req_alu         ( muldiv_req_alu          ),
        .div_req_alu_ltu     ( muldiv_req_alu_ltu      ),
        .div_req_alu_op1     ( muldiv_req_alu_op1      ),
        .div_req_alu_op2     ( muldiv_req_alu_op2      ),
        .div_req_alu_cmp_res ( muldiv_req_alu_cmp_res  ),
        .div_req_alu_res     ( muldiv_req_alu_res      ),
                         
        // illegal signal                         
        .div_op2_illegal     ( muldiv_illegal          ),  // illegal indicator
                                 
        // clk                         
        .clk                 ( clk                     )
    );

    mul multi_cycle_multiplier(

        // decoded operation signals
        .mul_op1             ( muldiv_signed_op1       ),
        .mul_op2             ( muldiv_signed_op2       ),

        // control signals
        .mul_sel_en          ( mul_sel_en              ),
        .mul_start_en        ( muldiv_start_en         ),
        .pc_cycle            ( pc_cycle                ),

        // result output 
        .mul_res             ( muldiv_mul_res          ),

        // clk
        .clk                 ( clk                     )
    );

    // result output 
    wire [`XLEN-1:0   ] muldiv_mul_res_h = muldiv_mul_res[`XLEN+`MULOP_LEN-2:`MULOP_LEN-1];
    wire [`XLEN-1:0   ] muldiv_mul_res_l = muldiv_mul_res[`MULOP_LEN-2      :0           ];  // MULOP_LEN = 33
 

    assign muldiv_wbck_res = ({`XLEN{rv32_mul    }} & muldiv_mul_res_l[`XLEN-1:0])|
                             ({`XLEN{rv32_mulh   }} & muldiv_mul_res_h[`XLEN-1:0])|
                             ({`XLEN{rv32_mulhsu }} & muldiv_mul_res_h[`XLEN-1:0])|
                             ({`XLEN{rv32_mulhu  }} & muldiv_mul_res_h[`XLEN-1:0])|
                             ({`XLEN{rv32_div    }} & muldiv_quo_res  [`XLEN-1:0])|
                             ({`XLEN{rv32_divu   }} & muldiv_quo_res  [`XLEN-1:0])|
                             ({`XLEN{rv32_rem    }} & muldiv_rem_res  [`XLEN-1:0])|
                             ({`XLEN{rv32_remu   }} & muldiv_rem_res  [`XLEN-1:0]);

endmodule
