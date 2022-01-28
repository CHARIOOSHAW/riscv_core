`include "config.v"

`ifdef ISA32
    `define RFIDX_WIDTH     5   // Regfile index range: 0-31.
    `define XLEN            32  // Regfile data length.
    `define RFREG_NUM       32  // The amount of rf registers.
    `define PC_SIZE         32  // The length of program counter.
    `define INSTR_SIZE      32  // The length of instruction.

    // Decode relevant macro
    // INFO HEAD
    `define DECINFO_GRP_WIDTH            3
    `define DECINFO_GRP_ALU              `DECINFO_GRP_WIDTH'd0
    `define DECINFO_GRP_AGU              `DECINFO_GRP_WIDTH'd1
    `define DECINFO_GRP_BJP              `DECINFO_GRP_WIDTH'd2
    `define DECINFO_GRP_CSR              `DECINFO_GRP_WIDTH'd3
    `define DECINFO_GRP_MULDIV           `DECINFO_GRP_WIDTH'd4
          
    `define DECINFO_GRP_LSB              0                                       // The begining of info bus.
    `define DECINFO_GRP_MSB              (`DECINFO_GRP_WIDTH+`DECINFO_GRP_LSB-1)
    `define DECINFO_GRP                  `DECINFO_GRP_MSB:`DECINFO_GRP_LSB       // Group info.
      
    `define DECINFO_RV32                 `DECINFO_GRP_MSB+1                      // One bit for instruction length. 
      
    `define DECINFO_SUBDECINFO_LSB       `DECINFO_RV32+1                         // The begining of extra information.
   
    // ALU GROUP   
    `define DECINFO_ALU_ADD              `DECINFO_SUBDECINFO_LSB
    `define DECINFO_ALU_SUB              `DECINFO_ALU_ADD+1
    `define DECINFO_ALU_XOR              `DECINFO_ALU_SUB+1
    `define DECINFO_ALU_SLL              `DECINFO_ALU_XOR+1
    `define DECINFO_ALU_SRL              `DECINFO_ALU_SLL+1
    `define DECINFO_ALU_SRA              `DECINFO_ALU_SRL+1
    `define DECINFO_ALU_OR               `DECINFO_ALU_SRA+1
    `define DECINFO_ALU_AND              `DECINFO_ALU_OR+1
    `define DECINFO_ALU_SLT              `DECINFO_ALU_AND+1
    `define DECINFO_ALU_SLTU             `DECINFO_ALU_SLT+1
    `define DECINFO_ALU_LUI              `DECINFO_ALU_SLTU+1
    `define DECINFO_ALU_OP2IMM           `DECINFO_ALU_LUI+1
    `define DECINFO_ALU_OP1PC            `DECINFO_ALU_OP2IMM+1
    `define DECINFO_ALU_NOP              `DECINFO_ALU_OP1PC+1
    `define DECINFO_ALU_ECAL             `DECINFO_ALU_NOP+1
    `define DECINFO_ALU_EBRK             `DECINFO_ALU_ECAL+1
    `define DECINFO_ALU_WFI              `DECINFO_ALU_EBRK+1
   
    `define DECINFO_ALU_WIDTH            `DECINFO_ALU_WFI+1
   
    // Bxx GROUP   
    // Fence instructions are removed.   
    `define DECINFO_BJP_JUMP             `DECINFO_SUBDECINFO_LSB
    `define DECINFO_BJP_JAL              `DECINFO_BJP_JUMP+1
    `define DECINFO_BJP_JALR             `DECINFO_BJP_JAL+1
    `define DECINFO_BJP_BEQ              `DECINFO_BJP_JALR+1
    `define DECINFO_BJP_BNE              `DECINFO_BJP_BEQ+1
    `define DECINFO_BJP_BLT              `DECINFO_BJP_BNE+1
    `define DECINFO_BJP_BGT              `DECINFO_BJP_BLT+1
    `define DECINFO_BJP_BLTU             `DECINFO_BJP_BGT+1
    `define DECINFO_BJP_BGTU             `DECINFO_BJP_BLTU+1
    `define DECINFO_BJP_BXX              `DECINFO_BJP_BGTU+1
    `define DECINFO_BJP_MRET             `DECINFO_BJP_BXX+1
    `define DECINFO_BJP_DRET             `DECINFO_BJP_MRET+1
   
    `define DECINFO_BJP_WIDTH            `DECINFO_BJP_DRET+1
   
    // CSR GROUP   
    `define DECINFO_CSR_CSRRW            `DECINFO_SUBDECINFO_LSB
    `define DECINFO_CSR_CSRRS            `DECINFO_CSR_CSRRW+1
    `define DECINFO_CSR_CSRRC            `DECINFO_CSR_CSRRS+1
    `define DECINFO_CSR_RS1IMM           `DECINFO_CSR_CSRRC+1
        `define DECINFO_CSR_ZIMMM_LSB    `DECINFO_CSR_RS1IMM+1
        `define DECINFO_CSR_ZIMMM_MSB    `DECINFO_CSR_RS1IMM+5
    `define DECINFO_CSR_ZIMMM            `DECINFO_CSR_ZIMMM_MSB:`DECINFO_CSR_ZIMMM_LSB // [4:0]
    `define DECINFO_CSR_RS1IS0           `DECINFO_CSR_ZIMMM_MSB+1
        `define DECINFO_CSR_CSRIDX_LSB   `DECINFO_CSR_RS1IS0+1
        `define DECINFO_CSR_CSRIDX_MSB   `DECINFO_CSR_RS1IS0+12
    `define DECINFO_CSR_CSRIDX           `DECINFO_CSR_CSRIDX_MSB:`DECINFO_CSR_CSRIDX_LSB // [11:0]

    `define DECINFO_CSR_WIDTH            `DECINFO_CSR_CSRIDX_MSB+1

    // MULDIV GROUP
    `define DECINFO_MULDIV_MUL           `DECINFO_SUBDECINFO_LSB
    `define DECINFO_MULDIV_MULH          `DECINFO_MULDIV_MUL+1
    `define DECINFO_MULDIV_MULHSU        `DECINFO_MULDIV_MULH+1
    `define DECINFO_MULDIV_MULHU         `DECINFO_MULDIV_MULHSU+1
    `define DECINFO_MULDIV_DIV           `DECINFO_MULDIV_MULHU+1
    `define DECINFO_MULDIV_DIVU          `DECINFO_MULDIV_DIV+1
    `define DECINFO_MULDIV_REM           `DECINFO_MULDIV_DIVU+1
    `define DECINFO_MULDIV_REMU          `DECINFO_MULDIV_REM+1

    `define DECINFO_MULDIV_WIDTH         `DECINFO_MULDIV_REMU+1

    // AGU GROUP
    `define DECINFO_AGU_LOAD             `DECINFO_SUBDECINFO_LSB
    `define DECINFO_AGU_STORE            `DECINFO_AGU_LOAD+1
        `define DECINFO_AGU_SIZE_LSB     `DECINFO_AGU_STORE+1
        `define DECINFO_AGU_SIZE_MSB     `DECINFO_AGU_STORE+2
    `define DECINFO_AGU_SIZE             `DECINFO_AGU_SIZE_MSB:`DECINFO_AGU_SIZE_LSB
    `define DECINFO_AGU_USIGN            `DECINFO_AGU_SIZE_MSB+1
    `define DECINFO_AGU_AMO              `DECINFO_AGU_USIGN+1
    `define DECINFO_AGU_OP2IMM           `DECINFO_AGU_AMO+1

    `define DECINFO_AGU_WIDTH            `DECINFO_AGU_OP2IMM+1

    // The longest info bus.
    `define DECINFO_WIDTH                `DECINFO_CSR_WIDTH

    // For all instructions, the maxium delay should be 64 cycle.
    `define MAX_DELAY_WIDTH              6
    
    // ALU defines
    `define MULDIV_ADDER_WIDTH           35

    `ifdef CFG_SUPPORT_SHARE_MULDIV
        `define ALU_ADDER_WIDTH `MULDIV_ADDER_WIDTH // Sharing dpath with mul need 35-bits data path.
    `endif
    `ifndef CFG_SUPPORT_SHARE_MULDIV
        `define ALU_ADDER_WIDTH (`XLEN+1)           // Without sharing dpath with mul need 33-bits data path.
    `endif

    `define MULOP_LEN                    33          // 7+2
    `define MULOP_LEN_E2                 35

    `ifdef FAKE_DIV_TOP
        `define DIVOP_LEN                8          // A fake top for test. 
    `endif
    `ifndef FAKE_DIV_TOP
        `define DIVOP_LEN                33
    `endif 

    // LSU defines
    `define LSU_IDLE                     0
    `define LSU_READ2RD                  1
    `define LSU_WRITE                    2

    // CSR defines
    `define SUPPORT_MCYCLE_MINSTRET      
    `define SUPPORT_MSCRATCH  
    `define ADDR_SIZE                    32    
    `define CSR_IDX_WIDTH                12
 
    `define IDX_MSTATUS                  12'h300       
    `define IDX_MIE                      12'h304
    `define IDX_MIP                      12'h344
    `define IDX_MTVEC                    12'h305
    `define IDX_MSCRATCH                 12'h340
    `define IDX_MCYCLE                   12'hB00
    `define IDX_MCYCLEH                  12'hB80
    `define IDX_MINSTRET                 12'hB02
    `define IDX_MINSTRETH                12'hB82
    `define IDX_COUNTSTOP                12'hBFF
    `define IDX_MCGSTOP                  12'hBFE
    `define IDX_MEPC                     12'h341
    `define IDX_MCAUSE                   12'h342
    `define IDX_MTVAL                    12'h343
    `define IDX_MISA                     12'h301
    `define IDX_MVENDORID                12'hF11
    `define IDX_MARCHID                  12'hF12
    `define IDX_MIMPID                   12'hF13
    `define IDX_MHARTID                  12'hF14
    `define IDX_DCSR                     12'h7b0
    `define IDX_DPC                      12'h7b1
    `define IDX_DSCRATCH                 12'h7b2
    `define MTVEC_TRAP_BASE              32'h0000_0000

    `define MVENDORID                    0
    `define MARCHID                      0
    `define MIMPID                       0
    `define MHARTID                      0          // For single core system, hartid should be 0.

    // IFU defines
    `define IR_RES_LEN                   16         





`endif