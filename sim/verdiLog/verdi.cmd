sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-2001" "-f" "/home/ICer/shaw/riscv_core/filelist/filelist.f" "-top" \
          "core_top"
wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 {/home/ICer/shaw/riscv_core/sim/wave_core_top.fsdb}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/excp_dbg"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top/CT/EXT"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top/CT/rsu"
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/sim_core_top/CT/rsu/buff1} \
{/sim_core_top/CT/rsu/buff2} \
{/sim_core_top/CT/rsu/clk} \
{/sim_core_top/CT/rsu/rst_n} \
{/sim_core_top/CT/rsu/rst_n_syn} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/sim_core_top/CT/rsu/buff1} \
{/sim_core_top/CT/rsu/buff2} \
{/sim_core_top/CT/rsu/clk} \
{/sim_core_top/CT/rsu/rst_n} \
{/sim_core_top/CT/rsu/rst_n_syn} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvGetSignalClose -win $_nWave2
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 90.559364 -snap {("G2" 0)}
debExit
