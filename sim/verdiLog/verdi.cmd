sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-2001" "-f" "/home/ICer/shaw/riscv_core/filelist/filelist.f" "-top" \
          "core_top"
wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 {/home/ICer/shaw/riscv_core/sim/wave_core_top.fsdb}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/excp_dbg"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top/CT/IFT"
wvSetPosition -win $_nWave2 {("G1" 99)}
wvSetPosition -win $_nWave2 {("G1" 99)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/sim_core_top/CT/IFT/clk} \
{/sim_core_top/CT/IFT/exu_ifu_i_pipe_flush_req} \
{/sim_core_top/CT/IFT/ifu_flash_pc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_bjp_flush_pc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_bjp_flush_req} \
{/sim_core_top/CT/IFT/ifu_i_excp} \
{/sim_core_top/CT/IFT/ifu_i_exu_ready} \
{/sim_core_top/CT/IFT/ifu_i_int_pending_flag} \
{/sim_core_top/CT/IFT/ifu_i_irq_req} \
{/sim_core_top/CT/IFT/ifu_i_mtvec\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_pc_init_use} \
{/sim_core_top/CT/IFT/ifu_i_rv32} \
{/sim_core_top/CT/IFT/ifu_ir_r\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_o_ifu_valid} \
{/sim_core_top/CT/IFT/ifu_o_wbck_epc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_pc_r\[31:0\]} \
{/sim_core_top/CT/IFT/itcm_ifu_ir\[31:0\]} \
{/sim_core_top/CT/IFT/pc_ifu_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/rst_n} \
{/sim_core_top/CT/IFT/IFU/IR_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_r\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res_nxt\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res_state} \
{/sim_core_top/CT/IFT/IFU/IR_res_state_nxt} \
{/sim_core_top/CT/IFT/IFU/clk} \
{/sim_core_top/CT/IFT/IFU/current_ir\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/exu_ifu_pipe_flush_req} \
{/sim_core_top/CT/IFT/IFU/ifu_flash_o_pc\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_i_exu_ready} \
{/sim_core_top/CT/IFT/IFU/ifu_o_ifu_valid} \
{/sim_core_top/CT/IFT/IFU/ifu_o_ir_r\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ir_length_16} \
{/sim_core_top/CT/IFT/IFU/ir_length_32} \
{/sim_core_top/CT/IFT/IFU/ir_length_a16} \
{/sim_core_top/CT/IFT/IFU/ir_length_a32} \
{/sim_core_top/CT/IFT/IFU/ir_length_encode\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/ir_length_m16} \
{/sim_core_top/CT/IFT/IFU/ir_length_m32} \
{/sim_core_top/CT/IFT/IFU/ir_state\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/ir_state_nxt\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/itcm_ifu_i_ir\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/pc_align} \
{/sim_core_top/CT/IFT/IFU/pc_ifu_i_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/rst_n} \
{/sim_core_top/CT/IFT/IFU/IR_register/clk} \
{/sim_core_top/CT/IFT/IFU/IR_register/dnxt\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_register/lden} \
{/sim_core_top/CT/IFT/IFU/IR_register/qout\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_register/qout_r\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_register/rst_n} \
{/sim_core_top/CT/IFT/IFU/IR_res_register/clk} \
{/sim_core_top/CT/IFT/IFU/IR_res_register/dnxt\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res_register/lden} \
{/sim_core_top/CT/IFT/IFU/IR_res_register/qout\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res_register/qout_r\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res_register/rst_n} \
{/sim_core_top/CT/IFT/IFU/IR_res_status_register/clk} \
{/sim_core_top/CT/IFT/IFU/IR_res_status_register/dnxt\[0:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res_status_register/lden} \
{/sim_core_top/CT/IFT/IFU/IR_res_status_register/qout\[0:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res_status_register/qout_r\[0:0\]} \
{/sim_core_top/CT/IFT/IFU/IR_res_status_register/rst_n} \
{/sim_core_top/CT/IFT/IFU/ir_state_register/clk} \
{/sim_core_top/CT/IFT/IFU/ir_state_register/dnxt\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/ir_state_register/lden} \
{/sim_core_top/CT/IFT/IFU/ir_state_register/qout\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/ir_state_register/qout_r\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/ir_state_register/rst_n} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_flush\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_r\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/clk} \
{/sim_core_top/CT/IFT/PC_CONTROL/need_flush} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_bjp_req_flush} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_bjp_req_fulsh_pc\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_excp} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_exu_ready} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_ifu_valid} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_init_use} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_int_pending_flag} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_irq_req} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_mtvec\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_rv32} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_o_pcnxt\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_o_pcr\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_o_wbck_epc\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/rst_n} \
{/sim_core_top/CT/IFT/PC_CONTROL/pcr/clk} \
{/sim_core_top/CT/IFT/PC_CONTROL/pcr/dnxt\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pcr/lden} \
{/sim_core_top/CT/IFT/PC_CONTROL/pcr/qout\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pcr/qout_r\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pcr/rst_n} \
{/sim_core_top/CT/IFT/itcm/mem_t\[31:0\]} \
{/sim_core_top/CT/IFT/itcm/pa\[31:0\]} \
{/sim_core_top/CT/IFT/itcm/pa_true\[31:0\]} \
{/sim_core_top/CT/IFT/itcm/pdataout\[31:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 \
           40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 \
           62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 \
           84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 )} 
wvSetPosition -win $_nWave2 {("G1" 99)}
wvGetSignalClose -win $_nWave2
wvZoomAll -win $_nWave2
srcDeselectAll -win $_nTrace1
wvSetCursor -win $_nWave2 214.351522 -snap {("G1" 52)}
wvSetCursor -win $_nWave2 271.124212 -snap {("G1" 59)}
wvSetCursor -win $_nWave2 156.748012 -snap {("G1" 50)}
wvSetCursor -win $_nWave2 232.075679 -snap {("G1" 49)}
wvSetCursor -win $_nWave2 244.261036 -snap {("G1" 49)}
wvSetCursor -win $_nWave2 254.230875 -snap {("G1" 50)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
debExit
