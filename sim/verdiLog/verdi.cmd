sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-2001" "-f" "/home/ICer/shaw/riscv_core/filelist/filelist.f" "-top" \
          "core_top"
schCreateWindow -delim "." -win $_nSchema1 -scope "core_top"
verdiWindowResize -win $_Verdi_1 -10 "20" "900" "700"
verdiWindowResize -win $_Verdi_1 -10 "20" "1184" "1067"
verdiWindowResize -win $_Verdi_1 -10 "20" "1500" "1322"
schSelect -win $_nSchema2 -signal "clk"
verdiShowWindow -win $_Verdi_1 -switchFS
schSelect -win $_nSchema2 -instport "rsu" "rst_n_syn"
schSelect -win $_nSchema2 -inst "rsu"
schSelect -win $_nSchema2 -inst "IFT"
schPushViewIn -win $_nSchema2
verdiWindowResize -win $_Verdi_1 "1330" "228" "1500" "1322"
verdiShowWindow -win $_Verdi_1 -switchFS
schSelect -win $_nSchema2 -inst "PC_CONTROL"
schSelect -win $_nSchema2 -inst "IFU"
schSelect -win $_nSchema2 -inst "itcm"
schPushViewIn -win $_nSchema2
srcShowCalling -win $_nTrace1
schPopViewUp -win $_nSchema2
schSelect -win $_nSchema2 -inst "IFU"
schPushViewIn -win $_nSchema2
schSelect -win $_nSchema2 -signal "1'b1"
schSelect -win $_nSchema2 -signal "1'b1"
schFocusConnection -win $_nSchema2
schDeselectAll -win $_nSchema2
schSelect -win $_nSchema2 -signal "1'b0"
schSelect -win $_nSchema2 -inst "IR_res_state_reg"
schZoom {24859} {6313} {38542} {25660} -win $_nSchema2
schSelect -win $_nSchema2 -signal "1'b1"
schFocusConnection -win $_nSchema2
verdiDockWidgetSetCurTab -dock widgetDock_<Decl._Tree>
verdiDockWidgetSetCurTab -dock widgetDock_<Inst._Tree>
verdiDockWidgetSetCurTab -dock widgetDock_<Decl._Tree>
verdiDockWidgetSetCurTab -dock widgetDock_<Inst._Tree>
schPopViewUp -win $_nSchema2
schSelect -win $_nSchema2 -inst "PC_CONTROL"
schPushViewIn -win $_nSchema2
schSelect -win $_nSchema2 -inst "PC:SigOp10:110:115:Combo"
schSelect -win $_nSchema2 -inst "PC:SigOp10:110:115:Combo"
schPushViewIn -win $_nSchema2
srcSetScope -win $_nTrace1 "core_top.IFT.PC_CONTROL" -delim "."
srcSelect -win $_nTrace1 -range {110 115 1 4 1 1}
schCreateWindow -delim "." -win $_nSchema1 -scope "core_top.IFT.PC_CONTROL"
schZoom {24468} {-900} {29675} {6760} -win $_nSchema3
schSelect -win $_nSchema3 -instport "int_flag" "lden"
schSelect -win $_nSchema3 -instport "int_flag" "lden"
schSelect -win $_nSchema3 -instport "int_flag" "lden"
schSelect -win $_nSchema3 -instport "int_flag" "lden"
schPushViewIn -win $_nSchema3
schPopViewUp -win $_nSchema3
schFit -win $_nSchema3
schPopViewUp -win $_nSchema3
srcHBSelect "core_top.IFT.IFU" -win $_nTrace1
verdiWindowResize -win $_Verdi_1 "1526" "68" "1500" "1322"
srcHBSelect "core_top.EXT.AU" -win $_nTrace1
srcHBSelect "core_top.EXT.AU" -win $_nTrace1
srcSetScope -win $_nTrace1 "core_top.EXT.AU" -delim "."
srcHBSelect "core_top.EXT.AU" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_bjp" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_bjp" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_agu" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_bjp" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_bjp" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_bjp" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_csrctrl" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_muldiv" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_ralu" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_agu" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_bjp" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_muldiv" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_ralu" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_muldiv.multi_cycle_divider" -win $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_muldiv.multi_cycle_multiplier" -win \
           $_nTrace1
srcHBSelect "core_top.EXT.AU.exu_alu_ralu.mau" -win $_nTrace1
srcHBSelect "core_top.EXT.CMT.u_exu_excp" -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "alu_i_pc_r" -line 32 -pos 1 -win $_nTrace1
srcHBSelect "core_top.EXT.CMT.u_exu_excp.exu_excp_cmt_csr_unit" -win $_nTrace1
verdiWindowResize -win $_Verdi_1 -10 "20" "1272" "834"
verdiWindowResize -win $_Verdi_1 "186" "189" "1500" "1322"
srcHBSelect "core_top.EXT.CSR" -win $_nTrace1
srcHBSelect "core_top.EXT.MC.WAIT" -win $_nTrace1
srcHBSelect "core_top.EXT.MC.RST4NXTIR" -win $_nTrace1
srcHBSelect "core_top.EXT.MC.COUNT_BUSY" -win $_nTrace1
srcHBSelect "core_top.EXT.MC.COUNT_BUSY" -win $_nTrace1
srcHBDrag -win $_nTrace1
srcHBSelect "core_top.EXT.MEMT.exu_ram_unit" -win $_nTrace1
srcSetScope -win $_nTrace1 "core_top.EXT.MEMT.exu_ram_unit" -delim "."
srcHBSelect "core_top.EXT.MEMT.exu_ram_unit" -win $_nTrace1
srcHBSelect "core_top.IFT.IFU" -win $_nTrace1
srcHBSelect "core_top.EXT.MEMT.exu_lsu" -win $_nTrace1
srcHBSelect "core_top.IFT.IFU" -win $_nTrace1
srcHBSelect "core_top.EXT.RF" -win $_nTrace1
debExit
