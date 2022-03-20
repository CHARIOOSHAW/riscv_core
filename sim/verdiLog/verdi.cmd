sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-2001" "-f" "/home/ICer/shaw/riscv_core/filelist/filelist.f" "-top" \
          "core_top"
wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 {/home/ICer/shaw/riscv_core/sim/wave_core_top.fsdb}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/excp_dbg"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top/CT/IFT"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top/CT/IFT/IFU"
wvSetPosition -win $_nWave2 {("G1" 26)}
wvSetPosition -win $_nWave2 {("G1" 26)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/sim_core_top/CT/IFT/IFU/clk} \
{/sim_core_top/CT/IFT/IFU/exu_ifu_pipe_flush_req} \
{/sim_core_top/CT/IFT/IFU/ifu_flash_o_enable} \
{/sim_core_top/CT/IFT/IFU/ifu_flash_o_pc\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_i_exu_ready} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_curr\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_info\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_nxt_rv32} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_reg\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_res\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_res_nxt\[15:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_res_state} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_res_state_nxt} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_state\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_ir_state_nxt\[1:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_o_ifu_valid} \
{/sim_core_top/CT/IFT/IFU/ifu_o_ir_r\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_o_pc_init_use} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_flash\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_init_use_r} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_nxt_align} \
{/sim_core_top/CT/IFT/IFU/ifu_valid} \
{/sim_core_top/CT/IFT/IFU/itcm_ifu_i_ir\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/pc_ifu_i_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/rst_n} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 )} 
wvSetPosition -win $_nWave2 {("G1" 26)}
wvGetSignalClose -win $_nWave2
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 328.450781 -snap {("G1" 10)}
wvSetCursor -win $_nWave2 250.907595 -snap {("G1" 10)}
wvSelectSignal -win $_nWave2 {( "G1" 17 )} 
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvSelectSignal -win $_nWave2 {( "G1" 12 )} 
wvSelectSignal -win $_nWave2 {( "G1" 20 )} 
wvSelectSignal -win $_nWave2 {( "G1" 17 )} 
wvSelectSignal -win $_nWave2 {( "G1" 19 )} 
wvSelectSignal -win $_nWave2 {( "G1" 22 )} 
wvSetCursor -win $_nWave2 385.002754 -snap {("G1" 17)}
wvSetCursor -win $_nWave2 253.437065 -snap {("G1" 26)}
wvSetCursor -win $_nWave2 258.699693 -snap {("G1" 24)}
debExit
