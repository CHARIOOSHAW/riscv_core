
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/07/08 10:59:51
// Design Name: 
// Module Name: ralu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: ralu is used to handle the calculating instructions.
// 
//////////////////////////////////////////////////////////////////////////////////
`include "mcu_defines.v"

module ralu(

    // RALU signals 
    input  [`XLEN-1:0]              alu_i_rs1            ,
    input  [`XLEN-1:0]              alu_i_rs2            ,
    input  [`XLEN-1:0]              alu_i_imm            ,
    input  [`PC_SIZE-1:0]           alu_i_pc             ,
    input  [`DECINFO_ALU_WIDTH-1:0] alu_i_info           ,

    //////////////////////////////////////////////////////
    // BJP request the datapath
    input                           bjp_req_alu          ,
    input  [`XLEN-1:0]              bjp_req_alu_op1      ,
    input  [`XLEN-1:0]              bjp_req_alu_op2      ,
    input                           bjp_req_alu_cmp_eq   ,
    input                           bjp_req_alu_cmp_ne   ,
    input                           bjp_req_alu_cmp_lt   ,
    input                           bjp_req_alu_cmp_gt   ,
    input                           bjp_req_alu_cmp_ltu  ,
    input                           bjp_req_alu_cmp_gtu  ,
    output                          bjp_req_alu_cmp_res  ,
  
    //////////////////////////////////////////////////////
    // AGU request the datapath
    input                           agu_req_alu          ,
    input  [`XLEN-1:0]              agu_req_alu_op1      ,
    input  [`XLEN-1:0]              agu_req_alu_op2      ,
    input                           agu_req_alu_add      ,
    output [`XLEN-1:0]              agu_req_alu_res      ,

    /////////////////////////////////////////////////////
    // DIV request the datapath 
    input                           muldiv_req_alu       ,
    input  [`XLEN-1:0]              muldiv_req_alu_op1   ,
    input  [`XLEN-1:0]              muldiv_req_alu_op2   ,
    input                           muldiv_req_alu_ltu   ,
    output [`XLEN-1:0]              muldiv_req_alu_res   ,
    output                          muldiv_req_alu_cmp_res,

    ////////////////////////////////////////////////////
    // The RALU Write-back/Commit Interface
    output [`XLEN-1:0]              ralu_o_wbck_wdat     ,
    output                          ralu_o_wbck_err       ,   
    output                          ralu_o_cmt_ecall      ,   
    output                          ralu_o_cmt_ebreak     ,   
    output                          ralu_o_cmt_wfi   

    );
    
    // RALU will include two main parts:
    // 1. ralu: it is used to take dec info and handle regular alu operations.
    // 2. dpath is used to calcualte the result and sent result back.

    //////////////////////////////////////////////////////
    // RALU: ALU request the datapath
    wire                    alu_req_alu          ; 
    wire  [`XLEN-1:0]       alu_req_alu_op1      ;
    wire  [`XLEN-1:0]       alu_req_alu_op2      ;
    wire                    alu_req_alu_add      ;
    wire                    alu_req_alu_sub      ;
    wire                    alu_req_alu_xor      ;
    wire                    alu_req_alu_sll      ;
    wire                    alu_req_alu_srl      ;
    wire                    alu_req_alu_sra      ;
    wire                    alu_req_alu_or       ;
    wire                    alu_req_alu_and      ;
    wire                    alu_req_alu_slt      ;
    wire                    alu_req_alu_sltu     ;
    wire                    alu_req_alu_lui      ;

    // ALU request result
    wire  [`XLEN-1:0]       alu_req_alu_res      ;

    wire op2imm    =  alu_i_info [`DECINFO_ALU_OP2IMM ]; // instr need imm for op2.
    wire op1pc     =  alu_i_info [`DECINFO_ALU_OP1PC  ]; // instr need pc for op1.

    assign alu_req_alu_op1 = op1pc?  alu_i_pc:  alu_i_rs1;
    assign alu_req_alu_op2 = op2imm? alu_i_imm: alu_i_rs2;
    assign alu_req_alu = |{alu_req_alu_add , 
                           alu_req_alu_sub , 
                           alu_req_alu_xor , 
                           alu_req_alu_sll ,  
                           alu_req_alu_srl , 
                           alu_req_alu_sra , 
                           alu_req_alu_or  ,  
                           alu_req_alu_and , 
                           alu_req_alu_slt ,
                           alu_req_alu_sltu,
                           alu_req_alu_lui  };
    
    wire nop       =  alu_i_info [`DECINFO_ALU_NOP    ];
    wire ecall     =  alu_i_info [`DECINFO_ALU_ECAL   ];
    wire ebreak    =  alu_i_info [`DECINFO_ALU_EBRK   ];
    wire wfi       =  alu_i_info [`DECINFO_ALU_WFI    ];
    
    // The NOP is encoded as ADDI, so need to uncheck it
    assign alu_req_alu_add  = alu_i_info [`DECINFO_ALU_ADD ] & (~nop);
    assign alu_req_alu_sub  = alu_i_info [`DECINFO_ALU_SUB ];
    assign alu_req_alu_xor  = alu_i_info [`DECINFO_ALU_XOR ];
    assign alu_req_alu_sll  = alu_i_info [`DECINFO_ALU_SLL ];
    assign alu_req_alu_srl  = alu_i_info [`DECINFO_ALU_SRL ];
    assign alu_req_alu_sra  = alu_i_info [`DECINFO_ALU_SRA ];
    assign alu_req_alu_or   = alu_i_info [`DECINFO_ALU_OR  ];
    assign alu_req_alu_and  = alu_i_info [`DECINFO_ALU_AND ];
    assign alu_req_alu_slt  = alu_i_info [`DECINFO_ALU_SLT ];
    assign alu_req_alu_sltu = alu_i_info [`DECINFO_ALU_SLTU];
    assign alu_req_alu_lui  = alu_i_info [`DECINFO_ALU_LUI ];
    
    assign ralu_o_wbck_wdat  = alu_req_alu_res;
    
    assign ralu_o_cmt_ecall  = ecall;   
    assign ralu_o_cmt_ebreak = ebreak;   
    assign ralu_o_cmt_wfi    = wfi;   
    
    // The exception or error result cannot write-back
    assign ralu_o_wbck_err = ralu_o_cmt_ecall | ralu_o_cmt_ebreak | ralu_o_cmt_wfi;
    

    ///////////////////////////////////////////////////////////////////////////
    //-------------------------------DPATH-----------------------------------//
    //-----------------------shifter/adder/xorer/cmp-------------------------//
    ///////////////////////////////////////////////////////////////////////////

    // openand part
    // misc_op is original signal which will be further gated by sel signal.
    wire [`XLEN-1:0]  mux_op1;
    wire [`XLEN-1:0]  mux_op2;
    assign mux_op1 =  alu_req_alu?    alu_req_alu_op1   :
                      bjp_req_alu?    bjp_req_alu_op1   :
                      agu_req_alu?    agu_req_alu_op1   :
                      muldiv_req_alu? muldiv_req_alu_op1:
                      `XLEN'd0;
    assign mux_op2 =  alu_req_alu?    alu_req_alu_op2   :
                      bjp_req_alu?    bjp_req_alu_op2   :
                      agu_req_alu?    agu_req_alu_op2   :
                      muldiv_req_alu? muldiv_req_alu_op2:
                      `XLEN'd0;
    wire [`XLEN-1:0]  misc_op1 = mux_op1[`XLEN-1:0];
    wire [`XLEN-1:0]  misc_op2 = mux_op2[`XLEN-1:0];

    // indicate signals
    wire op_add     = alu_req_alu?  alu_req_alu_add:
                      agu_req_alu?  agu_req_alu_add:
                                    1'b0;
    wire op_sub     = alu_req_alu?  alu_req_alu_sub: muldiv_req_alu? muldiv_req_alu_ltu: 1'b0;  // There is only one sub instr, however sub is needed in other alu instrs. 
    wire op_or      = alu_req_alu?  alu_req_alu_or:      1'b0;
    wire op_xor     = alu_req_alu?  alu_req_alu_xor:     1'b0;
    wire op_and     = alu_req_alu?  alu_req_alu_and:     1'b0;
    wire op_sll     = alu_req_alu?  alu_req_alu_sll:     1'b0;
    wire op_srl     = alu_req_alu?  alu_req_alu_srl:     1'b0;
    wire op_sra     = alu_req_alu?  alu_req_alu_sra:     1'b0;
    wire op_slt     = alu_req_alu?  alu_req_alu_slt:     1'b0;
    wire op_sltu    = alu_req_alu?  alu_req_alu_sltu:    1'b0;
    wire op_mvop2   = alu_req_alu?  alu_req_alu_lui:     1'b0;
    wire op_cmp_eq  = bjp_req_alu?  bjp_req_alu_cmp_eq:  1'b0;
    wire op_cmp_ne  = bjp_req_alu?  bjp_req_alu_cmp_ne:  1'b0;
    wire op_cmp_lt  = bjp_req_alu?  bjp_req_alu_cmp_lt:  1'b0;
    wire op_cmp_gt  = bjp_req_alu?  bjp_req_alu_cmp_gt:  1'b0;
    wire op_cmp_ltu = bjp_req_alu?  bjp_req_alu_cmp_ltu: muldiv_req_alu? muldiv_req_alu_ltu: 1'b0;
    wire op_cmp_gtu = bjp_req_alu?  bjp_req_alu_cmp_gtu: 1'b0;


    //////////////////////////////////////////////////////////////
    // DPATH: Left-Shifter unit, U1
    // shifter handle the following three kinds of operation with shift unit.
    wire op_shift = op_sra | op_sll | op_srl; 

    // The Left-Shifter will be used to handle the shift op
    wire [`XLEN-1:0]   shifter_in1;
    wire [5-1:0]       shifter_in2; // 5-bit shamt or imm.
    wire [`XLEN-1:0]   shifter_res;
    
    
    // Make sure to use logic-gating to gateoff the shift_in1 
    // in order to save area and just use one left-shifter, we
    // convert the right-shift op into left-shift operation by inverse the index of op1.
    assign shifter_in1 = {`XLEN{op_shift}} &                                                       // clock gate      
    ((op_sra | op_srl)? {alu_req_alu_op1[00],alu_req_alu_op1[01],alu_req_alu_op1[02],alu_req_alu_op1[03],    ///////////////
                         alu_req_alu_op1[04],alu_req_alu_op1[05],alu_req_alu_op1[06],alu_req_alu_op1[07],    // right
                         alu_req_alu_op1[08],alu_req_alu_op1[09],alu_req_alu_op1[10],alu_req_alu_op1[11],    //   -
                         alu_req_alu_op1[12],alu_req_alu_op1[13],alu_req_alu_op1[14],alu_req_alu_op1[15],    // shift
                         alu_req_alu_op1[16],alu_req_alu_op1[17],alu_req_alu_op1[18],alu_req_alu_op1[19],    // should
                         alu_req_alu_op1[20],alu_req_alu_op1[21],alu_req_alu_op1[22],alu_req_alu_op1[23],    // be 
                         alu_req_alu_op1[24],alu_req_alu_op1[25],alu_req_alu_op1[26],alu_req_alu_op1[27],    // convert
                         alu_req_alu_op1[28],alu_req_alu_op1[29],alu_req_alu_op1[30],alu_req_alu_op1[31]}:   ///////////////

                         alu_req_alu_op1);                                                         // left-shift op1
    assign shifter_in2            = {5{op_shift}} & alu_req_alu_op2[4:0];                          // op2 should be a 5-bit imm.
    assign shifter_res            = (shifter_in1 << shifter_in2);                                  // The orignal shift result which have to be further handled.
  
    wire [`XLEN-1:0] sll_res = shifter_res;
    wire [`XLEN-1:0] srl_res = {
                          shifter_res[00],shifter_res[01],shifter_res[02],shifter_res[03],
                          shifter_res[04],shifter_res[05],shifter_res[06],shifter_res[07],
                          shifter_res[08],shifter_res[09],shifter_res[10],shifter_res[11],
                          shifter_res[12],shifter_res[13],shifter_res[14],shifter_res[15],
                          shifter_res[16],shifter_res[17],shifter_res[18],shifter_res[19],
                          shifter_res[20],shifter_res[21],shifter_res[22],shifter_res[23],
                          shifter_res[24],shifter_res[25],shifter_res[26],shifter_res[27],
                          shifter_res[28],shifter_res[29],shifter_res[30],shifter_res[31]};        // For right-shift operations, the result have to be inverse again.
    
    wire [`XLEN-1:0] eff_mask = (~(`XLEN'b0)) >> shifter_in2;                                      // Make a mask like 0000001111111111111. 
    wire [`XLEN-1:0] sra_res  = (srl_res & eff_mask) | ({32{alu_req_alu_op1[31]}} & (~eff_mask));  // The former part in order to keep the lower bits and the latter part creat the flag bit sequence.


    //////////////////////////////////////////////////////////////
    // DPATH: adder unit, U2
    // The Adder will be reused to handle the add/sub/compare op
    // All unit request ALU-adder with 32bits opereand without sign extended.

    // unsign & op
    wire op_unsigned = op_sltu | op_cmp_ltu | op_cmp_gtu;
    wire [`ALU_ADDER_WIDTH-1:0] adder_op1   =   {{(~op_unsigned) & misc_op1[`XLEN-1]},misc_op1};
    wire [`ALU_ADDER_WIDTH-1:0] adder_op2   =   {{(~op_unsigned) & misc_op2[`XLEN-1]},misc_op2};

    // data path for adder
    wire [`ALU_ADDER_WIDTH-1:0] adder_res;
    wire adder_add; // adder need add.
    wire adder_sub; // adder need sub.
    wire op_addsub   = op_add | op_sub;

    assign adder_add = op_add; 
    assign adder_sub = ((op_sub) // The original sub instruction
                       |(op_cmp_lt | op_cmp_gt | op_cmp_ltu | op_cmp_gtu | op_slt | op_sltu) // The compare lt or gt instruction
                       );

    micro_adder_unit mau (.mau_adder_op1     (  adder_op1    ),
                          .mau_adder_op2     (  adder_op2    ),
                          .mau_adder_add     (  adder_add    ),
                          .mau_adder_sub     (  adder_sub    ),
                          .mau_adder_res     (  adder_res    )
                          );
    

    //////////////////////////////////////////////////////////////
    // DPATH: XOR-er, U3
    // xorer is used for xor instr or compare eq/ne instruction
    wire op_xorer = op_xor | (op_cmp_eq | op_cmp_ne); 

    // The XOR-er will be reused to handle the XOR and compare op
    wire [`XLEN-1:0] xorer_in1;
    wire [`XLEN-1:0] xorer_in2;

    assign xorer_in1 = {`XLEN{op_xorer}} & misc_op1;
    assign xorer_in2 = {`XLEN{op_xorer}} & misc_op2;

    wire [`XLEN-1:0] xorer_res = xorer_in1 ^ xorer_in2;

    // The OR and AND is light-weight.
    wire [`XLEN-1:0] orer_res  = misc_op1 | misc_op2; 
    wire [`XLEN-1:0] ander_res = misc_op1 & misc_op2; 
    

    //////////////////////////////////////////////////////////////
    // DPATH: CMP unit, U4
    // CMP will call other unit at the same time and resolve the result. 
    // It is Non-Equal if the XOR result have any bit non-zero.
    wire neq         = (|xorer_res); 
    wire cmp_res_ne  = op_cmp_ne & neq;

    // It is Equal if it is not Non-Equal.
    wire cmp_res_eq  = op_cmp_eq & (~neq);

    // It is Less-Than if the adder result is negative.
    // Judge the MSB of adder_res.
    wire cmp_res_lt  = op_cmp_lt  & adder_res[`XLEN];
    wire cmp_res_ltu = op_cmp_ltu & adder_res[`XLEN];

    // It is Greater-Than if the adder result is postive
    wire op1_gt_op2  = (~adder_res[`XLEN]);
    wire cmp_res_gt  = op_cmp_gt  & op1_gt_op2;
    wire cmp_res_gtu = op_cmp_gtu & op1_gt_op2;

    // Just or them all. The result signals have been gated by op signal.
    wire cmp_res     = cmp_res_eq 
                     | cmp_res_ne 
                     | cmp_res_lt 
                     | cmp_res_gt  
                     | cmp_res_ltu 
                     | cmp_res_gtu; 


    //////////////////////////////////////////////////////////////
    // DPATH: MV unit, U5
    // Just directly use op2 since the op2 will be the immediate
    wire [`XLEN-1:0] mvop2_res = misc_op2;


    //////////////////////////////////////////////////////////////
    // DPATH: SLT unit, U6
    // Generate the SLT and SLTU result
    // Just directly use op2 since the op2 will be the immediate
    wire op_slttu      = (op_slt | op_sltu);
    // The SLT and SLTU is reusing the adder to do the comparasion
    // It is Less-Than if the adder result is negative.
    wire slttu_cmp_lt  = op_slttu & adder_res[`XLEN];
    wire [`XLEN-1:0] slttu_res = slttu_cmp_lt? `XLEN'd1: `XLEN'd0; // if less-than then set, otherwise release.


    //////////////////////////////////////////////////////////////
    // DPATH: result output for DPATH, U7
    // Generate the final result
    wire [`XLEN-1:0] alu_dpath_res = 
        ({`XLEN{op_or       }} & orer_res )
      | ({`XLEN{op_and      }} & ander_res)
      | ({`XLEN{op_xor      }} & xorer_res)
      | ({`XLEN{op_addsub   }} & adder_res[`XLEN-1:0]) // The MSB of adder_res should be aborted.
      | ({`XLEN{op_srl      }} & srl_res  )
      | ({`XLEN{op_sll      }} & sll_res  )
      | ({`XLEN{op_sra      }} & sra_res  )
      | ({`XLEN{op_mvop2    }} & mvop2_res)
      | ({`XLEN{op_slttu    }} & slttu_res);

    assign alu_req_alu_res        = alu_dpath_res[`XLEN-1:0];
    assign agu_req_alu_res        = alu_dpath_res[`XLEN-1:0];
    assign muldiv_req_alu_res     = alu_dpath_res[`XLEN-1:0];
    assign bjp_req_alu_cmp_res    = bjp_req_alu & cmp_res   ;
    assign muldiv_req_alu_cmp_res = muldiv_req_alu & cmp_res;

endmodule
