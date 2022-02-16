sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-2001" "-f" "/home/ICer/shaw/riscv_core/filelist/filelist.f" "-top" \
          "core_top"
wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 {/home/ICer/shaw/riscv_core/sim/wave_core_top.fsdb}
srcHBSelect "core_top.EXT.WBCK" -win $_nTrace1
srcHBSelect "core_top.EXT.RF" -win $_nTrace1
srcHBSelect "core_top.EXT.RF" -win $_nTrace1
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/excp_dbg"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top/CT/EXT/RF"
wvSetPosition -win $_nWave2 {("G1" 133)}
wvSetPosition -win $_nWave2 {("G1" 133)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/sim_core_top/CT/EXT/RF/clk} \
{/sim_core_top/CT/EXT/RF/read_src1_data\[31:0\]} \
{/sim_core_top/CT/EXT/RF/read_src1_idx\[4:0\]} \
{/sim_core_top/CT/EXT/RF/read_src2_data\[31:0\]} \
{/sim_core_top/CT/EXT/RF/read_src2_idx\[4:0\]} \
{/sim_core_top/CT/EXT/RF/rf_wen\[31:0\]} \
{/sim_core_top/CT/EXT/RF/wbck_dest_data\[31:0\]} \
{/sim_core_top/CT/EXT/RF/wbck_dest_idx\[4:0\]} \
{/sim_core_top/CT/EXT/RF/wbck_dest_wen} \
{/sim_core_top/CT/EXT/RF/rf_main\[1\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[1\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[1\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[1\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[2\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[2\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[2\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[2\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[3\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[3\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[3\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[3\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[4\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[4\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[4\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[4\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[5\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[5\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[5\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[5\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[6\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[6\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[6\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[6\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[7\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[7\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[7\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[7\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[8\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[8\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[8\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[8\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[9\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[9\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[9\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[9\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[10\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[10\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[10\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[10\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[11\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[11\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[11\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[11\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[12\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[12\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[12\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[12\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[13\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[13\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[13\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[13\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[14\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[14\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[14\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[14\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[15\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[15\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[15\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[15\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[16\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[16\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[16\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[16\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[17\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[17\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[17\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[17\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[18\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[18\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[18\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[18\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[19\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[19\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[19\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[19\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[20\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[20\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[20\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[20\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[21\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[21\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[21\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[21\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[22\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[22\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[22\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[22\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[23\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[23\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[23\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[23\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[24\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[24\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[24\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[24\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[25\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[25\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[25\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[25\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[26\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[26\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[26\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[26\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[27\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[27\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[27\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[27\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[28\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[28\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[28\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[28\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[29\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[29\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[29\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[29\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[30\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[30\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[30\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[30\]/rfno0/rf_dffl/qout\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[31\]/rfno0/rf_dffl/clk} \
{/sim_core_top/CT/EXT/RF/rf_main\[31\]/rfno0/rf_dffl/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/RF/rf_main\[31\]/rfno0/rf_dffl/lden} \
{/sim_core_top/CT/EXT/RF/rf_main\[31\]/rfno0/rf_dffl/qout\[31:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 \
           40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 \
           62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 \
           84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 \
           105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 \
           122 123 124 125 126 127 128 129 130 131 132 133 )} 
wvSetPosition -win $_nWave2 {("G1" 133)}
wvGetSignalClose -win $_nWave2
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 1164.809432 -snap {("G1" 116)}
srcDeselectAll -win $_nTrace1
wvSetCursor -win $_nWave2 709.520154 -snap {("G1" 110)}
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
wvSelectSignal -win $_nWave2 {( "G1" 90 )} 
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
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 875.873447 -snap {("G1" 32)}
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
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 917.423421 -snap {("G1" 40)}
wvSetCursor -win $_nWave2 954.818397 -snap {("G1" 32)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollUp -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoom -win $_nWave2 828.727327 1500.353886
wvSetCursor -win $_nWave2 915.237081 -snap {("G1" 34)}
wvSetCursor -win $_nWave2 955.321980 -snap {("G1" 33)}
wvSetCursor -win $_nWave2 954.094891 -snap {("G1" 33)}
wvSetCursor -win $_nWave2 953.481346 -snap {("G1" 32)}
wvCenterCursor -win $_nWave2
wvSelectStuckSignals -win $_nWave2
wvSetCursor -win $_nWave2 954.386456 -snap {("G1" 32)}
wvSelectSignal -win $_nWave2 {( "G1" 47 )} 
wvSetCursor -win $_nWave2 955.613544 -snap {("G1" 32)}
wvSetCursor -win $_nWave2 955.000000 -snap {("G1" 33)}
wvSelectSignal -win $_nWave2 {( "G1" 33 )} 
wvSetCursor -win $_nWave2 954.795485 -snap {("G1" 32)}
wvSelectSignal -win $_nWave2 {( "G1" 32 )} 
wvSetMarker -win $_nWave2 -keepViewRange -name "M1" 955.409030
wvSetMarker -win $_nWave2 -keepViewRange -name "M1" 955.000000
wvSetCursor -win $_nWave2 977.496627 -snap {("G1" 37)}
wvSetCursor -win $_nWave2 916.142191 -snap {("G1" 41)}
wvSetCursor -win $_nWave2 953.977426 -snap {("G1" 35)}
wvSetCursor -win $_nWave2 965.634769 -snap {("G1" 34)}
wvSetCursor -win $_nWave2 1014.513803 -snap {("G1" 37)}
wvSetCursor -win $_nWave2 1064.824440 -snap {("G1" 41)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 1094.683599 -snap {("G1" 54)}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSetCursor -win $_nWave2 1144.994237 -snap {("G1" 45)}
wvSetCursor -win $_nWave2 1195.713904 -snap {("G1" 49)}
wvTpfCloseForm -win $_nWave2
wvGetSignalClose -win $_nWave2
wvCloseWindow -win $_nWave2
debExit
