
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chario Shaw
// 
// Create Date: 2021/06/20 20:50:17
// Design Name: 
// Module Name: decoder
// Project Name: riscv_mcu
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Decoder is used to decode the instruction and build the info bus.
// 
//////////////////////////////////////////////////////////////////////////////////

`include "mcu_defines.v"

module decoder(

    //////////////////////////////////////////////////////////////
    // The IR to Decoder
    input  [`INSTR_SIZE-1:0]      i_instr         ,     // instruction input
    input  [`PC_SIZE-1:0]         i_pc            ,     // PC input

    // The error signals. Directly output.
    input                         i_misalgn       ,     // The fetch misalign
    input                         i_buserr        ,     // The fetch bus error
    input                         dbg_mode        ,
   
    // Output                  
    output                        dec_rs1en       ,
    output                        dec_rs2en       ,
    output                        dec_rdwen       ,
    output [`RFIDX_WIDTH-1:0]     dec_rs1idx      ,
    output [`RFIDX_WIDTH-1:0]     dec_rs2idx      ,
    output [`RFIDX_WIDTH-1:0]     dec_rdidx       ,
    
    output [`DECINFO_WIDTH-1:0]   dec_info        ,     // one-dimension vector
    output [`XLEN-1:0]            dec_imm         ,

    output                        dec_misalgn     ,
    output                        dec_buserr      ,
    output                        dec_ilegl       ,
    output                        dec_rv32        ,

    output                        dec_ld          ,
    output                        dec_store       ,

    output                        dec_csrrw       ,

    output [`MAX_DELAY_WIDTH-1:0] dec_pc_cycle

    );

    // P1: Basic signals
    wire [32-1:0] rv32_instr = i_instr;         
    wire [16-1:0] rv16_instr = i_instr[15:0];  // For 16-bit instruction, only the lower 16 bits are necessary.

    wire [6:0] opcode = i_instr[6:0];

    wire [4:0]  rv32_rd     = rv32_instr[11:7];  // The information parts of 32-bit instr.
    wire [2:0]  rv32_func3  = rv32_instr[14:12];
    wire [4:0]  rv32_rs1    = rv32_instr[19:15];
    wire [4:0]  rv32_rs2    = rv32_instr[24:20];
    wire [6:0]  rv32_func7  = rv32_instr[31:25];

    wire [4:0]  rv16_rd     = rv32_rd;   // The information part of 16-bit instr.
    wire [4:0]  rv16_rs1    = rv16_rd; 
    wire [4:0]  rv16_rs2    = rv32_instr[6:2];
    wire [4:0]  rv16_rss1   = {2'b01,rv32_instr[9:7]}; // rss1 = rs1'
    wire [4:0]  rv16_rss2   = {2'b01,rv32_instr[4:2]};
    wire [4:0]  rv16_rdd    = rv16_rss2;
    wire [2:0]  rv16_func3  = rv32_instr[15:13];

    //============================================================================================
    // P2: Matching signals
    // We generate the signals and reused them as much as possible to save gatecounts
    wire opcode_1_0_00  = (opcode[1:0] == 2'b00); // i_instr[1:0]
    wire opcode_1_0_01  = (opcode[1:0] == 2'b01);
    wire opcode_1_0_10  = (opcode[1:0] == 2'b10);
    wire opcode_1_0_11  = (opcode[1:0] == 2'b11);

    wire opcode_4_2_000 = (opcode[4:2] == 3'b000); // i_instr[4:2]
    wire opcode_4_2_001 = (opcode[4:2] == 3'b001);
    wire opcode_4_2_010 = (opcode[4:2] == 3'b010);
    wire opcode_4_2_011 = (opcode[4:2] == 3'b011);
    wire opcode_4_2_100 = (opcode[4:2] == 3'b100);
    wire opcode_4_2_101 = (opcode[4:2] == 3'b101);
    wire opcode_4_2_110 = (opcode[4:2] == 3'b110);
    wire opcode_4_2_111 = (opcode[4:2] == 3'b111);

    wire opcode_6_5_00  = (opcode[6:5] == 2'b00); // i_instr[6:5]
    wire opcode_6_5_01  = (opcode[6:5] == 2'b01);
    wire opcode_6_5_10  = (opcode[6:5] == 2'b10);
    wire opcode_6_5_11  = (opcode[6:5] == 2'b11);

    wire rv32_func3_000 = (rv32_func3 == 3'b000);
    wire rv32_func3_001 = (rv32_func3 == 3'b001);
    wire rv32_func3_010 = (rv32_func3 == 3'b010);
    wire rv32_func3_011 = (rv32_func3 == 3'b011);
    wire rv32_func3_100 = (rv32_func3 == 3'b100);
    wire rv32_func3_101 = (rv32_func3 == 3'b101);
    wire rv32_func3_110 = (rv32_func3 == 3'b110);
    wire rv32_func3_111 = (rv32_func3 == 3'b111);

    wire rv16_func3_000 = (rv16_func3 == 3'b000);
    wire rv16_func3_001 = (rv16_func3 == 3'b001);
    wire rv16_func3_010 = (rv16_func3 == 3'b010);
    wire rv16_func3_011 = (rv16_func3 == 3'b011);
    wire rv16_func3_100 = (rv16_func3 == 3'b100);
    wire rv16_func3_101 = (rv16_func3 == 3'b101);
    wire rv16_func3_110 = (rv16_func3 == 3'b110);
    wire rv16_func3_111 = (rv16_func3 == 3'b111);

    wire rv32_func7_0000000 = (rv32_func7 == 7'b0000000);
    wire rv32_func7_0100000 = (rv32_func7 == 7'b0100000);
    wire rv32_func7_0000001 = (rv32_func7 == 7'b0000001);
    wire rv32_func7_0000101 = (rv32_func7 == 7'b0000101);
    wire rv32_func7_0001001 = (rv32_func7 == 7'b0001001);
    wire rv32_func7_0001101 = (rv32_func7 == 7'b0001101);
    wire rv32_func7_0010101 = (rv32_func7 == 7'b0010101);
    wire rv32_func7_0100001 = (rv32_func7 == 7'b0100001);
    wire rv32_func7_0010001 = (rv32_func7 == 7'b0010001);
    wire rv32_func7_0101101 = (rv32_func7 == 7'b0101101);
    wire rv32_func7_1111111 = (rv32_func7 == 7'b1111111);
    wire rv32_func7_0000100 = (rv32_func7 == 7'b0000100);
    wire rv32_func7_0001000 = (rv32_func7 == 7'b0001000);
    wire rv32_func7_0001100 = (rv32_func7 == 7'b0001100);
    wire rv32_func7_0101100 = (rv32_func7 == 7'b0101100);
    wire rv32_func7_0010000 = (rv32_func7 == 7'b0010000);
    wire rv32_func7_0010100 = (rv32_func7 == 7'b0010100);
    wire rv32_func7_1100000 = (rv32_func7 == 7'b1100000);
    wire rv32_func7_1110000 = (rv32_func7 == 7'b1110000);
    wire rv32_func7_1010000 = (rv32_func7 == 7'b1010000);
    wire rv32_func7_1101000 = (rv32_func7 == 7'b1101000);
    wire rv32_func7_1111000 = (rv32_func7 == 7'b1111000);
    wire rv32_func7_1010001 = (rv32_func7 == 7'b1010001);
    wire rv32_func7_1110001 = (rv32_func7 == 7'b1110001);
    wire rv32_func7_1100001 = (rv32_func7 == 7'b1100001);
    wire rv32_func7_1101001 = (rv32_func7 == 7'b1101001);

    wire rv32_rs1_x0 = (rv32_rs1 == 5'b00000);
    wire rv32_rs2_x0 = (rv32_rs2 == 5'b00000);
    wire rv32_rs2_x1 = (rv32_rs2 == 5'b00001);
    wire rv32_rd_x0  = (rv32_rd  == 5'b00000);
    wire rv32_rd_x2  = (rv32_rd  == 5'b00010); // x2 is the stack register which is frequently used in load&save instrs.

    wire rv16_rs1_x0 = (rv16_rs1 == 5'b00000);
    wire rv16_rs2_x0 = (rv16_rs2 == 5'b00000);
    wire rv16_rd_x0  = (rv16_rd  == 5'b00000);
    wire rv16_rd_x2  = (rv16_rd  == 5'b00010);

    wire rv32_rs1_x31 = (rv32_rs1 == 5'b11111);
    wire rv32_rs2_x31 = (rv32_rs2 == 5'b11111);
    wire rv32_rd_x31  = (rv32_rd  == 5'b11111);

    wire rv16_instr_12_is0   = (rv16_instr[12] == 1'b0);
    wire rv16_instr_6_2_is0s = (rv16_instr[6:2] == 5'b00000);

    wire rv32 = (~(i_instr[4:2] == 3'b111)) & opcode_1_0_11;  
    wire rv16 = (~(i_instr[1:0] == 2'b11));

    //===============================================================================
    // P3: 32-bit instruction operation signals : general
    wire rv32_lui     = opcode_6_5_01 & opcode_4_2_101 & opcode_1_0_11;
    wire rv32_auipc   = opcode_6_5_00 & opcode_4_2_101 & opcode_1_0_11;
    wire rv32_jal     = opcode_6_5_11 & opcode_4_2_011 & opcode_1_0_11;
    wire rv32_jalr    = opcode_6_5_11 & opcode_4_2_001 & opcode_1_0_11;
    wire rv32_branch  = opcode_6_5_11 & opcode_4_2_000 & opcode_1_0_11; // Rv32_branch includes 6 bxx instructions.
    wire rv32_load    = opcode_6_5_00 & opcode_4_2_000 & opcode_1_0_11; // Rv32_load includes 5 load instructions.
    wire rv32_store   = opcode_6_5_01 & opcode_4_2_000 & opcode_1_0_11; // Rv32_store includes 3 store instrcutions.
    wire rv32_op_imm  = opcode_6_5_00 & opcode_4_2_100 & opcode_1_0_11;
    wire rv32_op      = opcode_6_5_01 & opcode_4_2_100 & opcode_1_0_11;
    wire rv32_system  = opcode_6_5_11 & opcode_4_2_100 & opcode_1_0_11; // Dbg & csr instructions.

    wire rv32_miscmem = 1'b0; // Fence
    
    `ifndef E203_SUPPORT_AMO//{
    wire rv32_amo      = 1'b0;
    `endif//}
     
    //==============================================================================
    // P4: 16-bit instruction operation signals
    // 00 part
    wire rv16_addi4spn_ilgl;
    wire rv16_addi16sp_ilgl;
    wire rv16_addi4spn     = rv16_func3_000 & opcode_1_0_00 & (~rv16_addi4spn_ilgl);
    wire rv16_lw           = rv16_func3_010 & opcode_1_0_00;
    wire rv16_sw           = rv16_func3_110 & opcode_1_0_00;
 
    // 01 part 
    wire rv16_addi         = rv16_func3_000 & opcode_1_0_01;
    wire rv16_jal          = rv16_func3_001 & opcode_1_0_01;
    wire rv16_li           = rv16_func3_010 & opcode_1_0_01;
    wire rv16_lui_addi16sp = rv16_func3_011 & opcode_1_0_01; // includes 2 instructions.
    wire rv16_miscalu      = rv16_func3_100 & opcode_1_0_01; // includes 7 instructions.
    wire rv16_j            = rv16_func3_101 & opcode_1_0_01;
    wire rv16_beqz         = rv16_func3_110 & opcode_1_0_01;
    wire rv16_bnez         = rv16_func3_111 & opcode_1_0_01;

    // 10 part
    wire rv16_slli         = rv16_func3_000 & opcode_1_0_10;
    wire rv16_lwsp         = rv16_func3_010 & opcode_1_0_10;
    wire rv16_jalr_mv_add  = rv16_func3_100 & opcode_1_0_10; // includes 5 instructions.
    wire rv16_swsp         = rv16_func3_110 & opcode_1_0_10;

    // FPU necessary instructions
    `ifndef HAS_FPU
    wire rv16_fld   = 1'b0;
    wire rv16_flw   = 1'b0;
    wire rv16_fsd   = 1'b0;
    wire rv16_fsw   = 1'b0;
    wire rv16_fldsp = 1'b0;
    wire rv16_flwsp = 1'b0;
    wire rv16_fsdsp = 1'b0;
    wire rv16_fswsp = 1'b0;
    `endif

    wire legl_ops;

    wire rv16_nop          = (rv16_addi4spn & rv16_rs1_x0 & rv16_rs2_x0 & (~rv16_instr[12])) | (rv16 & (~legl_ops)); // c.nop is considered as an add instr to x0. From the aspect of result, there is no need to consider c.nop here.
    wire rv16_srli         = rv16_miscalu & (rv16_instr[11:10] == 2'b00);
    wire rv16_srai         = rv16_miscalu  & (rv16_instr[11:10] == 2'b01);
    wire rv16_andi         = rv16_miscalu  & (rv16_instr[11:10] == 2'b10);  
    wire rv16_addi16sp     = rv16_lui_addi16sp & (rv16_rd_x2) & (~rv16_addi16sp_ilgl); // In 32(16)-bit instructions, rd locates at the same part.
    wire rv16_lui          = rv16_lui_addi16sp & (~rv16_rd_x2);

    wire rv16_subxororand  = rv16_miscalu & (rv16_instr[12:10] == 3'b011);
    wire rv16_sub          = rv16_subxororand & (rv16_instr[6:5] == 2'b00);
    wire rv16_xor          = rv16_subxororand & (rv16_instr[6:5] == 2'b01);
    wire rv16_or           = rv16_subxororand & (rv16_instr[6:5] == 2'b10);
    wire rv16_and          = rv16_subxororand & (rv16_instr[6:5] == 2'b11);

    wire rv16_jr           = rv16_jalr_mv_add & (~rv16_instr[12]) & (~rv16_rd_x0) & (rv16_rs2_x0);
    wire rv16_mv           = rv16_jalr_mv_add & (~rv16_instr[12]) & (~rv16_rd_x0) & (~rv16_rs2_x0);
    wire rv16_ebreak       = rv16_jalr_mv_add & (rv16_instr[12]) & (rv16_rd_x0) & (rv16_rs2_x0);
    wire rv16_jalr         = rv16_jalr_mv_add & (rv16_instr[12]) & (~rv16_rd_x0) & (rv16_rs2_x0);
    wire rv16_add          = rv16_jalr_mv_add & (rv16_instr[12]) & (~rv16_rd_x0) & (~rv16_rs2_x0);

    //=================================================================================
    // P5: 32-bit instruction operation signals : specific
    // Branch Instructions
    wire rv32_beq          = rv32_branch & rv32_func3_000;
    wire rv32_bne          = rv32_branch & rv32_func3_001;
    wire rv32_blt          = rv32_branch & rv32_func3_100;
    wire rv32_bgt          = rv32_branch & rv32_func3_101;
    wire rv32_bltu         = rv32_branch & rv32_func3_110;
    wire rv32_bgtu         = rv32_branch & rv32_func3_111;

    // System Instructions
    wire rv32_ecall        = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0000_0000_0000);
    wire rv32_ebreak       = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0000_0000_0001);
    wire rv32_mret         = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0011_0000_0010);
    wire rv32_dret         = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0111_1011_0010);
    wire rv32_wfi          = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0001_0000_0101);

    wire rv32_csrrw        = rv32_system & rv32_func3_001;
    wire rv32_csrrs        = rv32_system & rv32_func3_010;
    wire rv32_csrrc        = rv32_system & rv32_func3_011;
    wire rv32_csrrwi       = rv32_system & rv32_func3_101;
    wire rv32_csrrsi       = rv32_system & rv32_func3_110;
    wire rv32_csrrci       = rv32_system & rv32_func3_111;

    wire rv32_ecall_ebreak_ret_wfi = rv32_system & rv32_func3_000;
    wire rv32_csr                  = rv32_system & (~rv32_func3_000);

    // ===========================================================================
    // P7: BJP info bus. The Branch and system ret instructions will be handled by BJP unit from EXU.
    wire dec_jal           = rv32_jal | rv16_jal | rv16_j;
    wire dec_jalr          = rv32_jalr | rv16_jalr | rv16_jr;
    wire dec_bxx           = rv32_branch | rv16_beqz | rv16_bnez;
    wire dec_bjp           = dec_jal | dec_jalr | dec_bxx; // The main signal for bxx and jal(r) operation.
    
    wire rv32_fence        = 1'b0;
    wire rv32_fence_i      = 1'b0;
    wire rv32_fence_fencei = 1'b0; // Fence operation is forbidden.

    // The main operation signal for jump instructions which will be sent to EXU.
    wire rv32_dret_ilgl;
    wire bjp_op = dec_bjp | rv32_mret | (rv32_dret & (~rv32_dret_ilgl)) | rv32_fence_fencei;

    // BJP info Bus.
    wire [`DECINFO_BJP_WIDTH-1:0] bjp_info_bus;

    assign bjp_info_bus[`DECINFO_GRP           ]     =  `DECINFO_GRP_BJP;
    assign bjp_info_bus[`DECINFO_RV32          ]     =  rv32;
    assign bjp_info_bus[`DECINFO_BJP_JUMP      ]     =  dec_jal | dec_jalr;
    assign bjp_info_bus[`DECINFO_BJP_JAL       ]     =  dec_jal;
    assign bjp_info_bus[`DECINFO_BJP_JALR      ]     =  dec_jalr;
    assign bjp_info_bus[`DECINFO_BJP_BEQ       ]     =  rv32_beq | rv16_beqz;
    assign bjp_info_bus[`DECINFO_BJP_BNE       ]     =  rv32_bne | rv16_bnez;
    assign bjp_info_bus[`DECINFO_BJP_BLT       ]     =  rv32_blt;
    assign bjp_info_bus[`DECINFO_BJP_BGT       ]     =  rv32_bgt; 
    assign bjp_info_bus[`DECINFO_BJP_BLTU      ]     =  rv32_bltu; 
    assign bjp_info_bus[`DECINFO_BJP_BGTU      ]     =  rv32_bgtu; 
    assign bjp_info_bus[`DECINFO_BJP_BXX       ]     =  dec_bxx; 
    assign bjp_info_bus[`DECINFO_BJP_MRET      ]     =  rv32_mret;
    assign bjp_info_bus[`DECINFO_BJP_DRET      ]     =  rv32_dret; 

    //==============================================================================
    // P8: ALU info bus. The alu instructions will be handled by RALU unit from EXU.
    wire rv32_addi         = rv32_op_imm & rv32_func3_000;
    wire rv32_slti         = rv32_op_imm & rv32_func3_010;
    wire rv32_sltiu        = rv32_op_imm & rv32_func3_011;
    wire rv32_xori         = rv32_op_imm & rv32_func3_100;
    wire rv32_ori          = rv32_op_imm & rv32_func3_110;
    wire rv32_andi         = rv32_op_imm & rv32_func3_111;
    wire rv32_slli         = rv32_op_imm & rv32_func3_001 & rv32_func7_0000000;
    wire rv32_srli         = rv32_op_imm & rv32_func3_101 & rv32_func7_0000000;
    wire rv32_srai         = rv32_op_imm & rv32_func3_101 & rv32_func7_0100000;

    // non-imm alu instructions
    wire rv32_add          = rv32_op & rv32_func3_000 & rv32_func7_0000000;
    wire rv32_sub          = rv32_op & rv32_func3_000 & rv32_func7_0100000;
    wire rv32_sll          = rv32_op & rv32_func3_001 & rv32_func7_0000000;
    wire rv32_slt          = rv32_op & rv32_func3_010 & rv32_func7_0000000;
    wire rv32_sltu         = rv32_op & rv32_func3_011 & rv32_func7_0000000;
    wire rv32_xor          = rv32_op & rv32_func3_100 & rv32_func7_0000000;
    wire rv32_srl          = rv32_op & rv32_func3_101 & rv32_func7_0000000;
    wire rv32_sra          = rv32_op & rv32_func3_101 & rv32_func7_0100000;
    wire rv32_or           = rv32_op & rv32_func3_110 & rv32_func7_0000000;
    wire rv32_and          = rv32_op & rv32_func3_111 & rv32_func7_0000000;

    // There is no nop instruction in rv32I. We defined a nop to handle WFI or passing.
    // The source and dest of nop is set to x0, no data will be written back.
    // 32-bit 0 series is not a legal instruction. So the imm shouldn't be 0.
    wire rv32_nop          = rv32 & (~legl_ops);

    wire ecall_ebreak      = rv32_ecall | rv32_ebreak | rv16_ebreak;

    // The main operation signal for ralu instructions which will be sent to EXU.
    wire rv32_sxxi_shamt_ilgl;
    wire rv16_sxxi_shamt_ilgl;
    wire rv16_li_ilgl;
    wire alu_op  = (~rv32_sxxi_shamt_ilgl)  // Firstly, the instruction should be legal. 
                 & (~rv16_sxxi_shamt_ilgl)
                 & (~rv16_li_ilgl)
                 & (~rv16_addi4spn_ilgl)
                 & (~rv16_addi16sp_ilgl)
                 & (  rv32_op_imm          // Second, it should be one of the ralu operations.
                    | rv32_op & (~rv32_func7_0000001) // Exclude the MULDIV
                    | rv32_auipc
                    | rv32_lui
                    | rv16_addi4spn
                    | rv16_addi         
                    | rv16_lui_addi16sp 
                    | rv16_li | rv16_mv
                    | rv16_slli         
                    | rv16_miscalu  
                    | rv16_add
                    | rv16_nop 
                    | rv32_nop
                    | rv32_wfi // We just put WFI into ALU and do nothing in ALU
                    | ecall_ebreak);
    
    wire alu_no_nop  = (~rv32_sxxi_shamt_ilgl)  // Firstly, the instruction should be legal. 
             & (~rv16_sxxi_shamt_ilgl)
             & (~rv16_li_ilgl)
             & (~rv16_addi4spn_ilgl)
             & (~rv16_addi16sp_ilgl)
             & (  rv32_op_imm          // Second, it should be one of the ralu operations.
                | rv32_op & (~rv32_func7_0000001) // Exclude the MULDIV
                | rv32_auipc
                | rv32_lui
                | rv16_addi4spn
                | rv16_addi         
                | rv16_lui_addi16sp 
                | rv16_li | rv16_mv
                | rv16_slli         
                | rv16_miscalu  
                | rv16_add 
                | rv32_wfi // We just put WFI into ALU and do nothing in ALU
                | ecall_ebreak);
    
    // imm necessary signal. important.
    wire need_imm;

    wire [`DECINFO_ALU_WIDTH-1:0] alu_info_bus;
    assign alu_info_bus[`DECINFO_GRP           ]     =  `DECINFO_GRP_ALU;
    assign alu_info_bus[`DECINFO_RV32          ]     =  rv32;
    assign alu_info_bus[`DECINFO_ALU_ADD       ]     =  rv32_add  | rv32_addi | rv32_auipc | rv16_addi | rv16_addi4spn | rv16_addi16sp | rv16_add 
                                                        //  We also decode LI and MV as the add instruction, becuase
                                                        //    they all add x0 with a RS2 or Immeidate, and then write into RD
                                                        | rv16_li | rv16_mv;
    assign alu_info_bus[`DECINFO_ALU_SUB       ]     =  rv32_sub  | rv16_sub;
    assign alu_info_bus[`DECINFO_ALU_SLT       ]     =  rv32_slt  | rv32_slti;
    assign alu_info_bus[`DECINFO_ALU_SLTU      ]     =  rv32_sltu | rv32_sltiu;
    assign alu_info_bus[`DECINFO_ALU_XOR       ]     =  rv32_xor  | rv32_xori | rv16_xor;
    assign alu_info_bus[`DECINFO_ALU_SLL       ]     =  rv32_sll  | rv32_slli | rv16_slli;
    assign alu_info_bus[`DECINFO_ALU_SRL       ]     =  rv32_srl  | rv32_srli | rv16_srli;
    assign alu_info_bus[`DECINFO_ALU_SRA       ]     =  rv32_sra  | rv32_srai | rv16_srai;
    assign alu_info_bus[`DECINFO_ALU_OR        ]     =  rv32_or   | rv32_ori  | rv16_or;
    assign alu_info_bus[`DECINFO_ALU_AND       ]     =  rv32_and  | rv32_andi | rv16_and | rv16_andi;
    assign alu_info_bus[`DECINFO_ALU_LUI       ]     =  rv32_lui  | rv16_lui;
    assign alu_info_bus[`DECINFO_ALU_OP2IMM    ]     =  need_imm; // Indicator signal.
    assign alu_info_bus[`DECINFO_ALU_OP1PC     ]     =  rv32_auipc;
    assign alu_info_bus[`DECINFO_ALU_NOP       ]     =  rv16_nop | rv32_nop;
    assign alu_info_bus[`DECINFO_ALU_ECAL      ]     =  rv32_ecall;
    assign alu_info_bus[`DECINFO_ALU_EBRK      ]     =  rv32_ebreak;
    assign alu_info_bus[`DECINFO_ALU_WFI       ]     =  rv32_wfi;
 
    //==============================================================================
    // P9: CSR info bus. The csr instructions will be handled by CSR unit from EXU.
    wire csr_op = rv32_csr;
    wire [`DECINFO_CSR_WIDTH-1:0] csr_info_bus;
    assign csr_info_bus[`DECINFO_GRP           ]     =  `DECINFO_GRP_CSR;
    assign csr_info_bus[`DECINFO_RV32          ]     =  rv32;
    assign csr_info_bus[`DECINFO_CSR_CSRRW     ]     =  rv32_csrrw | rv32_csrrwi;
    assign csr_info_bus[`DECINFO_CSR_CSRRS     ]     =  rv32_csrrs | rv32_csrrsi;
    assign csr_info_bus[`DECINFO_CSR_CSRRC     ]     =  rv32_csrrc | rv32_csrrci;
    assign csr_info_bus[`DECINFO_CSR_RS1IMM    ]     =  rv32_csrrwi| rv32_csrrsi | rv32_csrrci;
    assign csr_info_bus[`DECINFO_CSR_ZIMMM     ]     =  rv32_rs1;
    assign csr_info_bus[`DECINFO_CSR_RS1IS0    ]     =  rv32_rs1_x0;
    assign csr_info_bus[`DECINFO_CSR_CSRIDX    ]     =  rv32_instr[31:20];

    //==============================================================================
    // P10: MUL&DIV info bus. The mul&div instructions will be handled by muldiv-dpath unit from EXU.
    wire rv32_mul      = rv32_op     & rv32_func3_000 & rv32_func7_0000001;
    wire rv32_mulh     = rv32_op     & rv32_func3_001 & rv32_func7_0000001;
    wire rv32_mulhsu   = rv32_op     & rv32_func3_010 & rv32_func7_0000001;
    wire rv32_mulhu    = rv32_op     & rv32_func3_011 & rv32_func7_0000001;
    wire rv32_div      = rv32_op     & rv32_func3_100 & rv32_func7_0000001;
    wire rv32_divu     = rv32_op     & rv32_func3_101 & rv32_func7_0000001;
    wire rv32_rem      = rv32_op     & rv32_func3_110 & rv32_func7_0000001;
    wire rv32_remu     = rv32_op     & rv32_func3_111 & rv32_func7_0000001;

    wire muldiv_op = rv32_op & rv32_func7_0000001; // mul&div instructions belong to type R.

    wire [`DECINFO_MULDIV_WIDTH-1:0] muldiv_info_bus;
    assign muldiv_info_bus[`DECINFO_GRP          ]   =  `DECINFO_GRP_MULDIV;
    assign muldiv_info_bus[`DECINFO_RV32         ]   =  rv32        ;
    assign muldiv_info_bus[`DECINFO_MULDIV_MUL   ]   =  rv32_mul    ;   
    assign muldiv_info_bus[`DECINFO_MULDIV_MULH  ]   =  rv32_mulh   ;
    assign muldiv_info_bus[`DECINFO_MULDIV_MULHSU]   =  rv32_mulhsu ;
    assign muldiv_info_bus[`DECINFO_MULDIV_MULHU ]   =  rv32_mulhu  ;
    assign muldiv_info_bus[`DECINFO_MULDIV_DIV   ]   =  rv32_div    ;
    assign muldiv_info_bus[`DECINFO_MULDIV_DIVU  ]   =  rv32_divu   ;
    assign muldiv_info_bus[`DECINFO_MULDIV_REM   ]   =  rv32_rem    ;
    assign muldiv_info_bus[`DECINFO_MULDIV_REMU  ]   =  rv32_remu   ;

    // assign dec_mulhsu = rv32_mulh | rv32_mulhu | rv32_mulhsu;
    // assign dec_mul    = rv32_mul;
    // assign dec_div    = rv32_div;
    // assign dec_rem    = rv32_rem;
    // assign dec_divu   = rv32_divu;
    // assign dec_remu   = rv32_remu;

    //==============================================================================
    // P11: LS info bus. The load&save instructions will be handled by AGU unit from EXU.
    wire rv32_lb      = rv32_load & rv32_func3_000;
    wire rv32_lh      = rv32_load & rv32_func3_001;
    wire rv32_lw      = rv32_load & rv32_func3_010;
    wire rv32_lbu     = rv32_load & rv32_func3_100;
    wire rv32_lhu     = rv32_load & rv32_func3_101;

    wire rv32_sb      = rv32_store & rv32_func3_000;
    wire rv32_sh      = rv32_store & rv32_func3_001;
    wire rv32_sw      = rv32_store & rv32_func3_010;

    `ifndef E203_SUPPORT_AMO//{
    wire rv32_lr_w      = 1'b0;
    wire rv32_sc_w      = 1'b0;
    wire rv32_amoswap_w = 1'b0;
    wire rv32_amoadd_w  = 1'b0;
    wire rv32_amoxor_w  = 1'b0;
    wire rv32_amoand_w  = 1'b0;
    wire rv32_amoor_w   = 1'b0;
    wire rv32_amomin_w  = 1'b0;
    wire rv32_amomax_w  = 1'b0;
    wire rv32_amominu_w = 1'b0;
    wire rv32_amomaxu_w = 1'b0;
    `endif//}

    // The following operations will be sent to AGU and LSU.
    wire rv16_lwsp_ilgl;
    wire amoldst_op = rv32_amo | rv32_load | rv32_store | rv16_lw | rv16_sw | (rv16_lwsp & (~rv16_lwsp_ilgl)) | rv16_swsp;

    // ls ins tructions need more inforamtion about size and sign.
    // The RV16 always is word and signed.
    wire [1:0] lsu_info_size    = rv32? rv32_func3[1:0]: 2'b10;
    wire       lsu_info_usign   = rv32? rv32_func3[2]: 1'b0;

    assign dec_ld    = rv32_load  | rv16_lw | rv16_lwsp;
    assign dec_store = rv32_store | rv16_sw | rv16_swsp;

    wire [`DECINFO_AGU_WIDTH-1:0] agu_info_bus;
    assign agu_info_bus[`DECINFO_GRP             ]   =  `DECINFO_GRP_AGU;
    assign agu_info_bus[`DECINFO_RV32            ]   =  rv32;
    assign agu_info_bus[`DECINFO_AGU_LOAD        ]   =  rv32_load | rv16_lw | rv16_lwsp;     
    assign agu_info_bus[`DECINFO_AGU_STORE       ]   =  rv32_store | rv16_sw | rv16_swsp;
    assign agu_info_bus[`DECINFO_AGU_SIZE        ]   =  lsu_info_size;
    assign agu_info_bus[`DECINFO_AGU_USIGN       ]   =  lsu_info_usign;
    assign agu_info_bus[`DECINFO_AGU_AMO         ]   =  rv32_amo;
    assign agu_info_bus[`DECINFO_AGU_OP2IMM      ]   =  need_imm;

    //================================================================================================================
    // P12: immediate number.
    // There are five types of imm for rv32 instrcutions.
    // All types of imm are set to 32 bit after decoding.
    // If imm need to be appended, it should be regarded as a signed number.
    // R type has no imm.
    wire [`XLEN-1:0] rv32_u_imm = {rv32_instr[31:12], 12'd0}; 
    wire [`XLEN-1:0] rv32_j_imm = {{11{rv32_instr[31]}}, rv32_instr[31], rv32_instr[19:12], rv32_instr[20], rv32_instr[30:21], 1'b0};
    wire [`XLEN-1:0] rv32_i_imm = {{20{rv32_instr[31]}}, rv32_instr[31:20]};
    wire [`XLEN-1:0] rv32_b_imm = {{20{rv32_instr[31]}}, rv32_instr[31], rv32_instr[7], rv32_instr[30:24], rv32_instr[11:8]};
    wire [`XLEN-1:0] rv32_s_imm = {{20{rv32_instr[31]}}, rv32_instr[31:25], rv32_instr[11:7]};
    
    // It will select i-type immediate when
    //    * rv32_op_imm
    //    * rv32_jalr
    //    * rv32_load
    wire        rv32_imm_sel_i      =  rv32_op_imm | rv32_jalr | rv32_load;
    wire        rv32_imm_sel_jalr   =  rv32_jalr;
    wire [31:0] rv32_jalr_imm       =  rv32_i_imm;

    // It will select u-type immediate when
    //    * rv32_lui, rv32_auipc 
    wire        rv32_imm_sel_u      =  rv32_lui | rv32_auipc;

    // It will select j-type immediate when
    //    * rv32_jal
    wire        rv32_imm_sel_j      =  rv32_jal;
    wire        rv32_imm_sel_jal    =  rv32_jal;
    wire        rv32_jal_imm        =  rv32_j_imm;

    // It will select b-type immediate when
    //    * rv32_branch
    wire        rv32_imm_sel_b      =  rv32_branch;
    wire        rv32_imm_sel_bxx    =  rv32_branch;
    wire [31:0] rv32_bxx_imm        =  rv32_b_imm;

    // It will select s-type immediate when
    //    * rv32_store
    wire        rv32_imm_sel_s      =  rv32_store;

    // The imm of 16-bit instruction.
    // * Note: this CIS/CILI/CILUI/CI16SP-type is named by myself, because in 
    //         ISA doc, the CI format for LWSP is different
    //         with other CI formats in terms of immediate
 
    // It will select CIS-type immediate when
    //    * rv16_lwsp
    wire        rv16_imm_sel_cis    =  rv16_lwsp;
    wire [31:0] rv16_cis_imm        =  {24'd0, rv16_instr[3:2], rv16_instr[12], rv16_instr[6:4], 2'd0}; // zero-expand

    // It will select CILI-type immediate when
    //    * rv16_li
    //    * rv16_addi
    //    * rv16_slli
    //    * rv16_srai
    //    * rv16_srli
    //    * rv16_andi
    wire        rv16_imm_sel_cili   =  rv16_li | rv16_addi | rv16_slli | rv16_srai | rv16_srli | rv16_andi;
    wire [31:0] rv16_cili_imm       =  {{26{rv16_instr[12]}}, rv16_instr[12], rv16_instr[6:2]}; 

    // It will select CILUI-type immediate when
    //    * rv16_lui
    wire        rv16_imm_sel_cilui  =  rv16_lui;
    wire [31:0] rv16_cilui_imm      =  {{14{rv16_instr[12]}}, rv16_instr[12], rv16_instr[6:2], 12'd0};

    // It will select CI16SP-type immediate when
    //    * rv16_addi16sp
    wire        rv16_imm_sel_ci16sp =  rv16_addi16sp;
    wire [31:0] rv16_ci16sp_imm     =  {{22{rv16_instr[12]}} , rv16_instr[12], rv16_instr[4:3], rv16_instr[5], rv16_instr[2], rv16_instr[6], 4'd0};
 
    // It will select CSS-type immediate when
    //    * rv16_swsp
    wire        rv16_imm_sel_css    =  rv16_swsp;
    wire [31:0] rv16_css_imm        =  {24'd0, rv16_instr[8:7], rv16_instr[12:9], 2'd0}; //zero-expand

    // It will select CIW-type immediate when
    //    * rv16_addi4spn
    wire        rv16_imm_sel_ciw    =  rv16_addi4spn;
    wire [31:0] rv16_ciw_imm        =  {22'd0, rv16_instr[10:7], rv16_instr[12:11], rv16_instr[5], rv16_instr[6], 2'd0}; // zero-expand

    // It will select CL-type immediate when
    //    * rv16_lw
    wire        rv16_imm_sel_cl     =  rv16_lw;
    wire [31:0] rv16_cl_imm         =  {25'd0, rv16_instr[5], rv16_instr[12:10], rv16_instr[6], 2'd0}; // zero-expand

    // It will select CS-type immediate when
    //    * rv16_sw
    wire        rv16_imm_sel_cs     =  rv16_sw;
    wire [31:0] rv16_cs_imm         =  {25'd0, rv16_instr[5], rv16_instr[12:10], rv16_instr[6], 2'd0};

    // It will select CB-type immediate when
    //    * rv16_beqz
    //    * rv16_bnez
    wire        rv16_imm_sel_cb     =  rv16_beqz | rv16_bnez;
    wire [31:0] rv16_cb_imm         =  {{24{rv16_instr[12]}}, rv16_instr[12], rv16_instr[6:5], rv16_instr[2], rv16_instr[11:10], rv16_instr[4:3]};
    wire [31:0] rv16_bxx_imm        =  rv16_cb_imm;

    // It will select CN-type immediate when
    // * rv16_nop
    wire        rv16_imm_sel_cn     =  rv16_nop;


    // It will select CJ-type immediate when
    //    * rv16_j
    //    * rv16_jal
    wire        rv16_imm_sel_cj     =  rv16_jal | rv16_j;
    wire [31:0] rv16_cj_imm         =  {{20{rv16_instr[12]}},
                                        rv16_instr[12],
                                        rv16_instr[8],
                                        rv16_instr[10:9],
                                        rv16_instr[6],
                                        rv16_instr[7],
                                        rv16_instr[2],
                                        rv16_instr[11],
                                        rv16_instr[5:3],
                                        1'b0};
    wire [31:0] rv16_jjal_imm       =  rv16_cj_imm;


    // It will select CSR-type register (no-imm) when
    //    * rv16_subxororand
    // R type has no imm.

    // rv32_imm is the selected imm when rv32 instr is decoded.
    wire [31:0] rv32_imm  =  ({32{rv32_imm_sel_b      }} & rv32_b_imm) |
                             ({32{rv32_imm_sel_i      }} & rv32_i_imm) |
                             ({32{rv32_imm_sel_j      }} & rv32_j_imm) |
                             ({32{rv32_imm_sel_s      }} & rv32_s_imm) |
                             ({32{rv32_imm_sel_u      }} & rv32_u_imm);
                    
    wire rv32_need_imm    =  rv32_imm_sel_b |
                             rv32_imm_sel_i |
                             rv32_imm_sel_j |
                             rv32_imm_sel_u |
                             rv32_imm_sel_s;
    
    // rv16_imm is the selected imm when rv16 instr is decoded.
    wire [31:0] rv16_imm  =  ({32{rv16_imm_sel_cis    }} & rv16_cis_imm) |
                             ({32{rv16_imm_sel_cili   }} & rv16_cili_imm) |
                             ({32{rv16_imm_sel_cilui  }} & rv16_cilui_imm) |
                             ({32{rv16_imm_sel_ci16sp }} & rv16_ci16sp_imm) |
                             ({32{rv16_imm_sel_css    }} & rv16_css_imm) |
                             ({32{rv16_imm_sel_ciw    }} & rv16_ciw_imm) |
                             ({32{rv16_imm_sel_cl     }} & rv16_cl_imm) |
                             ({32{rv16_imm_sel_cs     }} & rv16_cs_imm) |
                             ({32{rv16_imm_sel_cb     }} & rv16_cb_imm) |
                             ({32{rv16_imm_sel_cj     }} & rv16_cj_imm);

    wire rv16_need_imm    =  rv16_imm_sel_cis |   
                             rv16_imm_sel_cili | 
                             rv16_imm_sel_cilui |
                             rv16_imm_sel_ci16sp |
                             rv16_imm_sel_css |   
                             rv16_imm_sel_ciw |   
                             rv16_imm_sel_cl |    
                             rv16_imm_sel_cs |    
                             rv16_imm_sel_cb |  
                             rv16_imm_sel_cj;  

    // dec signals about imm
    assign need_imm = rv32? rv32_need_imm: rv16_need_imm;

    assign dec_imm  = rv32? rv32_imm: rv16_imm;

    //==============================================================================
    // P13: register index.
    // For RV32 instructions, rd/rs1/rs2 always stay at the same place.
    // For Rv16 instructions, the indexes of registers should be reconstructed.
    // All the RV32IMA need RD register except the
    //   * Branch, Store,
    //   * fence, fence_i 
    //   * ecall, ebreak  
    wire rv32_need_rd     =  (~rv32_rd_x0) & (
                             (~rv32_branch) 
                           & (~rv32_store)
                           & (~rv32_fence_fencei)
                           & (~rv32_ecall_ebreak_ret_wfi) 
                           );

    // All the RV32IMA need RS1 register except the
    //   * lui
    //   * auipc
    //   * jal
    //   * fence, fence_i 
    //   * ecall, ebreak  
    //   * csrrwi
    //   * csrrsi
    //   * csrrci
    wire rv32_need_rs1    =  (~rv32_rs1_x0) & (
                             (~rv32_lui)
                           & (~rv32_auipc)
                           & (~rv32_jal)
                           & (~rv32_fence_fencei)
                           & (~rv32_ecall_ebreak_ret_wfi)
                           & (~rv32_csrrwi)
                           & (~rv32_csrrsi)
                           & (~rv32_csrrci)
                           );

    // Following RV32IMA instructions need RS2 register
    //   * branch
    //   * store
    //   * rv32_op
    //   * rv32_amo except the rv32_lr_w
    wire rv32_need_rs2    =  (~rv32_rs2_x0) & (
                             (rv32_branch)
                           | (rv32_store)
                           | (rv32_op)
                           | (rv32_amo & (~rv32_lr_w))
                           );

    // To decode the registers for Rv16, divided into 8 groups
    // Rd/Rs1/Rs2 should be determined by the appended rv32 instruction according to rv16 instr.
    wire rv16_format_cr  = rv16_jalr_mv_add;
    wire rv16_format_ci  = rv16_lwsp | rv16_li | rv16_lui_addi16sp | rv16_addi | rv16_slli; 
    wire rv16_format_css = rv16_swsp;
    wire rv16_format_ciw = rv16_addi4spn; 
    wire rv16_format_cl  = rv16_lw;
    wire rv16_format_cs  = rv16_sw | rv16_subxororand; 
    wire rv16_format_cb  = rv16_beqz | rv16_bnez | rv16_srli | rv16_srai | rv16_andi; 
    wire rv16_format_cj  = rv16_j | rv16_jal; 

    // In CR Cases:
    //   * JR:     rs1= rs1(coded),     rs2= x0 (coded),   rd = x0 (implicit)
    //   * JALR:   rs1= rs1(coded),     rs2= x0 (coded),   rd = x1 (implicit)
    //   * MV:     rs1= x0 (implicit),  rs2= rs2(coded),   rd = rd (coded)
    //   * ADD:    rs1= rs1(coded),     rs2= rs2(coded),   rd = rd (coded)
    //   * eBreak: rs1= rs1(coded),     rs2= x0 (coded),   rd = x0 (coded)
    // All of the CR cases need rd/rs1 and rs2.
    wire rv16_need_cr_rs1                  =  rv16_format_cr;
    wire rv16_need_cr_rs2                  =  rv16_format_cr;
    wire rv16_need_cr_rd                   =  rv16_format_cr;
    wire [`RFIDX_WIDTH-1:0] rv16_cr_rs1    =  rv16_mv? `RFIDX_WIDTH'd0 : rv16_rs1;
    wire [`RFIDX_WIDTH-1:0] rv16_cr_rs2    =  rv16_rs2;
    wire [`RFIDX_WIDTH-1:0] rv16_cr_rd     =  (rv16_jalr | rv16_jr)? {{`RFIDX_WIDTH-1{1'b0}}, rv16_instr[12]}: rv16_rd;
  
    //// In CI Cases:  
    //   * LWSP:     rs1= x2 (implicit),    rd = rd 
    //   * LI/LUI:   rs1= x0 (implicit),    rd = rd
    //   * ADDI:     rs1= rs1(implicit),    rd = rd
    //   * ADDI16SP: rs1= rs1(implicit),    rd = rd
    //   * SLLI:     rs1= rs1(implicit),    rd = rd
    // CI instructions have no rs2.  
    wire rv16_need_ci_rs1                  =  rv16_format_ci;
    wire rv16_need_ci_rs2                  =  1'b0;
    wire rv16_need_ci_rd                   =  rv16_format_ci;
    wire [`RFIDX_WIDTH-1:0] rv16_ci_rs1    =  rv16_lwsp? `RFIDX_WIDTH'd2: (rv16_lui | rv16_li)? `RFIDX_WIDTH'd0: rv16_rs1;
    wire [`RFIDX_WIDTH-1:0] rv16_ci_rs2    =  `RFIDX_WIDTH'd0;
    wire [`RFIDX_WIDTH-1:0] rv16_ci_rd     =  rv16_rd;
  
    // In CSS Cases:  
    //   * SWSP:     rs1 = x2 (implicit), rs2= rs2 
    wire rv16_need_css_rs1                 =  rv16_format_css;
    wire rv16_need_css_rs2                 =  rv16_format_css;
    wire rv16_need_css_rd                  =  1'b0;
    wire [`RFIDX_WIDTH-1:0] rv16_css_rs1   =  `RFIDX_WIDTH'd2;
    wire [`RFIDX_WIDTH-1:0] rv16_css_rs2   =  rv16_rs2;
    wire [`RFIDX_WIDTH-1:0] rv16_css_rd    =  `RFIDX_WIDTH'd0;
 
    // In CIW cases: 
    //   * ADDI4SPN:   rdd = rdd, rss1= x2 (implicit)
    wire rv16_need_ciw_rss1                =  rv16_format_ciw;
    wire rv16_need_ciw_rss2                =  1'b0;
    wire rv16_need_ciw_rdd                 =  rv16_format_ciw;
    wire [`RFIDX_WIDTH-1:0] rv16_ciw_rss1  =  `RFIDX_WIDTH'd2;
    wire [`RFIDX_WIDTH-1:0] rv16_ciw_rss2  =  `RFIDX_WIDTH'd0;
    wire [`RFIDX_WIDTH-1:0] rv16_ciw_rdd   =  rv16_rdd;

    // In CL cases:
    //   * LW:   rss1 = rss1, rdd= rdd
    wire rv16_need_cl_rss1                 =  rv16_format_cl;
    wire rv16_need_cl_rss2                 =  1'b0;
    wire rv16_need_cl_rdd                  =  rv16_format_cl;
    wire [`RFIDX_WIDTH-1:0] rv16_cl_rss1   =  rv16_rss1;
    wire [`RFIDX_WIDTH-1:0] rv16_cl_rss2   =  `RFIDX_WIDTH'd0;
    wire [`RFIDX_WIDTH-1:0] rv16_cl_rdd    =  rv16_rdd;

    // In CS cases:
    //   * SW:            rdd = none(implicit), rss1= rss1       , rss2=rss2
    //   * SUBXORORAND:   rdd = rss1,           rss1= rss1(coded), rss2=rss2
    wire rv16_need_cs_rss1                 =  rv16_format_cs;
    wire rv16_need_cs_rss2                 =  rv16_format_cs;
    wire rv16_need_cs_rdd                  =  rv16_format_cs & rv16_subxororand;
    wire [`RFIDX_WIDTH-1:0] rv16_cs_rss1   =  rv16_rss1;
    wire [`RFIDX_WIDTH-1:0] rv16_cs_rss2   =  rv16_rss2;
    wire [`RFIDX_WIDTH-1:0] rv16_cs_rdd    =  rv16_rss1;

    // In CB cases:
    //   * BEQ/BNE:            rdd = none(implicit), rss1= rss1, rss2=x0(implicit)
    //   * SRLI/SRAI/ANDI:     rdd = rss1          , rss1= rss1, rss2=none(implicit)
    wire rv16_need_cb_rss1                 =  rv16_format_cb;
    wire rv16_need_cb_rss2                 =  rv16_format_cb & (rv16_beqz | rv16_bnez);
    wire rv16_need_cb_rdd                  =  rv16_format_cb & (~(rv16_beqz | rv16_bnez));
    wire [`RFIDX_WIDTH-1:0] rv16_cb_rss1   =  rv16_rss1;
    wire [`RFIDX_WIDTH-1:0] rv16_cb_rss2   =  `RFIDX_WIDTH'd0;
    wire [`RFIDX_WIDTH-1:0] rv16_cb_rdd    =  rv16_rss1;

    // In CJ cases:
    //   * J:            rdd = x0(implicit)
    //   * JAL:          rdd = x1(implicit)
    wire rv16_need_cj_rss1                 =  1'b0;
    wire rv16_need_cj_rss2                 =  1'b0;
    wire rv16_need_cj_rdd                  =  rv16_format_cj;
    wire [`RFIDX_WIDTH-1:0] rv16_cj_rss1   =  `RFIDX_WIDTH'd0;
    wire [`RFIDX_WIDTH-1:0] rv16_cj_rss2   =  `RFIDX_WIDTH'd0;
    wire [`RFIDX_WIDTH-1:0] rv16_cj_rdd    =  (rv16_j)? `RFIDX_WIDTH'd0: `RFIDX_WIDTH'd1;

    // rv16 rs/rd enable
    // CR/CI/CSS belongs to rs type.
    // CIW/CL/CS/CB/CJ belongs to rss type.
    wire rv16_need_rs1 = rv16_need_cr_rs1 | rv16_need_ci_rs1 | rv16_need_css_rs1;
    wire rv16_need_rs2 = rv16_need_cr_rs2 | rv16_need_ci_rs2 | rv16_need_css_rs2;
    wire rv16_need_rd  = rv16_need_cr_rd  | rv16_need_ci_rd  | rv16_need_css_rd;
  
    wire rv16_need_rss1 = rv16_need_ciw_rss1|rv16_need_cl_rss1|rv16_need_cs_rss1|rv16_need_cb_rss1|rv16_need_cj_rss1;
    wire rv16_need_rss2 = rv16_need_ciw_rss2|rv16_need_cl_rss2|rv16_need_cs_rss2|rv16_need_cb_rss2|rv16_need_cj_rss2;
    wire rv16_need_rdd  = rv16_need_ciw_rdd |rv16_need_cl_rdd |rv16_need_cs_rdd |rv16_need_cb_rdd |rv16_need_cj_rdd ;
  
    wire rv16_rs1en = (rv16_need_rs1 | rv16_need_rss1);
    wire rv16_rs2en = (rv16_need_rs2 | rv16_need_rss2);
    wire rv16_rden  = (rv16_need_rd  | rv16_need_rdd );

    // rv16 rs index bus. 
    wire [`RFIDX_WIDTH-1:0] rv16_rs1idx;
    wire [`RFIDX_WIDTH-1:0] rv16_rs2idx;
    wire [`RFIDX_WIDTH-1:0] rv16_rdidx ;

    assign rv16_rs1idx = 
           ({`RFIDX_WIDTH{rv16_need_cr_rs1   }}  & rv16_cr_rs1   )
         | ({`RFIDX_WIDTH{rv16_need_ci_rs1   }}  & rv16_ci_rs1   )
         | ({`RFIDX_WIDTH{rv16_need_css_rs1  }}  & rv16_css_rs1  )
         | ({`RFIDX_WIDTH{rv16_need_ciw_rss1 }}  & rv16_ciw_rss1 )
         | ({`RFIDX_WIDTH{rv16_need_cl_rss1  }}  & rv16_cl_rss1  )
         | ({`RFIDX_WIDTH{rv16_need_cs_rss1  }}  & rv16_cs_rss1  )
         | ({`RFIDX_WIDTH{rv16_need_cb_rss1  }}  & rv16_cb_rss1  )
         | ({`RFIDX_WIDTH{rv16_need_cj_rss1  }}  & rv16_cj_rss1  )
         | ({`RFIDX_WIDTH{rv16_nop | rv32_nop}}  & `RFIDX_WIDTH'd0)
         ;

    assign rv16_rs2idx = 
           ({`RFIDX_WIDTH{rv16_need_cr_rs2   }}  & rv16_cr_rs2   )
         | ({`RFIDX_WIDTH{rv16_need_ci_rs2   }}  & rv16_ci_rs2   )
         | ({`RFIDX_WIDTH{rv16_need_css_rs2  }}  & rv16_css_rs2  )
         | ({`RFIDX_WIDTH{rv16_need_ciw_rss2 }}  & rv16_ciw_rss2 )
         | ({`RFIDX_WIDTH{rv16_need_cl_rss2  }}  & rv16_cl_rss2  )
         | ({`RFIDX_WIDTH{rv16_need_cs_rss2  }}  & rv16_cs_rss2  )
         | ({`RFIDX_WIDTH{rv16_need_cb_rss2  }}  & rv16_cb_rss2  )
         | ({`RFIDX_WIDTH{rv16_need_cj_rss2  }}  & rv16_cj_rss2  )
         | ({`RFIDX_WIDTH{rv16_nop | rv32_nop}}  & `RFIDX_WIDTH'd0)
         ;

    assign rv16_rdidx = 
           ({`RFIDX_WIDTH{rv16_need_cr_rd    }}  &  rv16_cr_rd   )
         | ({`RFIDX_WIDTH{rv16_need_ci_rd    }}  &  rv16_ci_rd   )
         | ({`RFIDX_WIDTH{rv16_need_css_rd   }}  &  rv16_css_rd  )
         | ({`RFIDX_WIDTH{rv16_need_ciw_rdd  }}  &  rv16_ciw_rdd )
         | ({`RFIDX_WIDTH{rv16_need_cl_rdd   }}  &  rv16_cl_rdd  )
         | ({`RFIDX_WIDTH{rv16_need_cs_rdd   }}  &  rv16_cs_rdd  )
         | ({`RFIDX_WIDTH{rv16_need_cb_rdd   }}  &  rv16_cb_rdd  )
         | ({`RFIDX_WIDTH{rv16_need_cj_rdd   }}  &  rv16_cj_rdd  )
         | ({`RFIDX_WIDTH{rv16_nop | rv32_nop}}  & `RFIDX_WIDTH'd0)
         ;

    //==============================================================================
    // P6: Illegal instructions.
    assign rv16_lwsp_ilgl       =  rv16_lwsp & rv16_rd_x0;

    // alu related illegal
    wire rv16_sxxi_shamt_legl = 
               rv16_instr_12_is0 // shamt[5] must be zero for RV32C
             & (~(rv16_instr_6_2_is0s)); // shamt[4:0] must be non-zero for RV32C
    assign rv16_sxxi_shamt_ilgl =  (rv16_srli | rv16_slli | rv16_srai) & (~rv16_sxxi_shamt_legl); // sxxi includes srai/slli/srli.

    assign rv16_li_ilgl         =  rv16_li & (rv16_rd_x0); // C.LI is only valid when rd!=x0.
    wire   rv16_lui_ilgl        =  rv16_lui & (rv16_rd_x0 | rv16_rd_x2 | (rv16_instr_6_2_is0s & rv16_instr_12_is0)); //C.LUI is only valid when rd!=x0 or x2, and when the immediate is not equal to zero.
    wire   rv16_li_lui_ilgl     =  rv16_li_ilgl | rv16_lui_ilgl;
  
    assign rv16_addi4spn_ilgl   =    rv16_instr_12_is0 // [12]
                                   & rv16_rd_x0     // [11:7]
                                   & opcode_6_5_00;// [6:5] (RES, nzimm=0, bits[12:5])
    assign rv16_addi16sp_ilgl   =    rv16_instr_12_is0 & rv16_instr_6_2_is0s; //(RES, nzimm=0, bits 12,6:2)
      
    assign rv32_dret_ilgl     =  rv32_dret & (~dbg_mode);

    // shift illegal
    wire rv32_sxxi_shamt_legl =  (rv32_instr[25] == 1'b0); // shamt[5] must be zero for RV32I, shamt[5] == func7[LSB]. //?
    assign rv32_sxxi_shamt_ilgl =  (rv32_slli | rv32_srli | rv32_srai) & (~rv32_sxxi_shamt_legl);

    // Whole-zero/one sequence is illegal instruction.
    wire rv32_all0s_ilgl  = rv32_func7_0000000 
                          & rv32_rs2_x0 
                          & rv32_rs1_x0 
                          & rv32_func3_000 
                          & rv32_rd_x0 
                          & opcode_6_5_00 
                          & opcode_4_2_000 
                          & (opcode[1:0] == 2'b00); 
    wire rv32_all1s_ilgl  = rv32_func7_1111111 
                          & rv32_rs2_x31 
                          & rv32_rs1_x31 
                          & rv32_func3_111 
                          & rv32_rd_x31 
                          & opcode_6_5_11 
                          & opcode_4_2_111 
                          & (opcode[1:0] == 2'b11); 
    wire rv16_all0s_ilgl  = rv16_func3_000 //rv16_func3  = rv32_instr[15:13];
                          & rv32_func3_000 //rv32_func3  = rv32_instr[14:12];
                          & rv32_rd_x0     //rv32_rd     = rv32_instr[11:7];
                          & opcode_6_5_00 
                          & opcode_4_2_000 
                          & (opcode[1:0] == 2'b00); 
    wire rv16_all1s_ilgl  = rv16_func3_111
                          & rv32_func3_111 
                          & rv32_rd_x31 
                          & opcode_6_5_11 
                          & opcode_4_2_111 
                          & (opcode[1:0] == 2'b11);

    wire rv_all0s1s_ilgl = rv32 ?  (rv32_all0s_ilgl | rv32_all1s_ilgl)
                                :  (rv16_all0s_ilgl | rv16_all1s_ilgl);
    
    // A legal operation should belong to one of these categories.
    assign legl_ops = 
            alu_no_nop
          | amoldst_op
          | bjp_op
          | csr_op
          | muldiv_op
          ;

    //=============================================================================
    // P14: Other dec signals
    // decoder info bus*
    // The length of dec_info is decided by the longest info bus.
    assign dec_info = 
              ({`DECINFO_WIDTH{alu_op}}     & {{`DECINFO_WIDTH-`DECINFO_ALU_WIDTH{1'b0}},alu_info_bus})
            | ({`DECINFO_WIDTH{amoldst_op}} & {{`DECINFO_WIDTH-`DECINFO_AGU_WIDTH{1'b0}},agu_info_bus})
            | ({`DECINFO_WIDTH{bjp_op}}     & {{`DECINFO_WIDTH-`DECINFO_BJP_WIDTH{1'b0}},bjp_info_bus})
            | ({`DECINFO_WIDTH{csr_op}}     & {{`DECINFO_WIDTH-`DECINFO_CSR_WIDTH{1'b0}},csr_info_bus})
            | ({`DECINFO_WIDTH{muldiv_op}}  & {{`DECINFO_WIDTH-`DECINFO_MULDIV_WIDTH{1'b0}},muldiv_info_bus})
              ;

    // decoder register index bus*
    assign dec_rs1idx = rv32? rv32_rs1: rv16_rs1idx;
    assign dec_rs2idx = rv32? rv32_rs2: rv16_rs2idx;
    assign dec_rdidx  = rv32? rv32_rd : rv16_rdidx ;

    // decoder register enable signal*
    assign dec_rs1en = rv32 ? rv32_need_rs1 : rv16_rs1en; 
    assign dec_rs2en = rv32 ? rv32_need_rs2 : rv16_rs2en;
    assign dec_rdwen = rv32 ? rv32_need_rd  : rv16_rden ;

    // decoder Error signal* 
    assign dec_misalgn = i_misalgn;
    assign dec_buserr  = i_buserr; 
    
    assign dec_ilegl = 1'b0; // illegal was not considered now.
    //                    (rv_all0s1s_ilgl) 
    //                 | (rv16_addi16sp_ilgl)
    //                 | (rv16_addi4spn_ilgl)
    //                 | (rv16_li_lui_ilgl)
    //                 | (rv16_sxxi_shamt_ilgl)
    //                 | (rv32_sxxi_shamt_ilgl)
    //                 | (rv32_dret_ilgl)
    //                 | (rv16_lwsp_ilgl); 


    // decoder instr length signal*
    assign dec_rv32    = rv32;

    assign dec_csrrw   = rv32_csr;

    // bjp imm&rs signals
    // assign dec_bjp_imm = 
    //                ({32{rv16_jal | rv16_j     }} & rv16_jjal_imm   )
    //              | ({32{rv16_jalr_mv_add      }} & rv16_jrjalr_imm )
    //              | ({32{rv16_beqz | rv16_bnez }} & rv16_bxx_imm    )
    //              | ({32{rv32_jal              }} & rv32_jal_imm    )
    //              | ({32{rv32_jalr             }} & rv32_jalr_imm   )
    //              | ({32{rv32_branch           }} & rv32_bxx_imm    )
    //              ;
    // 
    // assign dec_jalr_rs1idx = rv32 ? rv32_rs1[`RFIDX_WIDTH-1:0] : rv16_rs1[`RFIDX_WIDTH-1:0]; 

    ///////////////////////////////////////////////////////////////////////////////////////////
    // U14: PC_CYCLE
    assign dec_pc_cycle = amoldst_op?                                                    6'd2 : // ld and st cost 2 cycle for excute 
                          muldiv_op & (rv32_mul | rv32_mulh | rv32_mulhsu | rv32_mulhu)? 6'd19: // mul cost 18+1 cycle to excute
                          muldiv_op & (rv32_div | rv32_divu | rv32_rem    | rv32_remu )? 6'd35: // div cost 34+1 cycle to excute
                                                                                         6'd1 ; // other instr cost 1 cycle  

    //=============================================================================
    // P00: test port
    // assign alu_info_bus_test = alu_info_bus;  
    // assign bjp_info_bus_test = bjp_info_bus;
    // assign agu_info_bus_test = agu_info_bus;
    // assign csr_info_bus_test = csr_info_bus;
    // assign muldiv_info_bus_test = muldiv_info_bus;



endmodule
