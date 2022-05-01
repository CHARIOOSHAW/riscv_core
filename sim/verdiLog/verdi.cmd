sidCmdLineBehaviorAnalysisOpt -incr -clockSkew 0 -loopUnroll 0 -bboxEmptyModule 0  -cellModel 0 -bboxIgnoreProtected 0 
debImport "-2001" "-f" "/home/ICer/shaw/riscv_core/filelist/filelist.f" "-top" \
          "core_top"
wvCreateWindow
schCreateWindow -delim "." -win $_nSchema1 -scope "core_top"
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 {/home/ICer/shaw/riscv_core/sim/wave_core_top.fsdb}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/excp_dbg"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top"
wvGetSignalSetScope -win $_nWave2 "/sirv_gnrl_dffr"
wvSetPosition -win $_nWave2 {("G1" 5)}
wvSetPosition -win $_nWave2 {("G1" 5)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/sirv_gnrl_dffr/clk} \
{/sirv_gnrl_dffr/dnxt\[31:0\]} \
{/sirv_gnrl_dffr/qout\[31:0\]} \
{/sirv_gnrl_dffr/qout_r\[31:0\]} \
{/sirv_gnrl_dffr/rst_n} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 )} 
wvSetPosition -win $_nWave2 {("G1" 5)}
wvGetSignalClose -win $_nWave2
wvZoomAll -win $_nWave2
wvClearAll -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/excp_dbg"
wvGetSignalSetScope -win $_nWave2 "/sirv_gnrl_dffr"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top"
wvSetPosition -win $_nWave2 {("G1" 1759)}
wvSetPosition -win $_nWave2 {("G1" 1759)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/sim_core_top/sim_clk} \
{/sim_core_top/sim_clk_aon} \
{/sim_core_top/sim_core_unexcp_err} \
{/sim_core_top/sim_core_wfi} \
{/sim_core_top/sim_external_interrupt} \
{/sim_core_top/sim_pc_init_use} \
{/sim_core_top/sim_rst_n} \
{/sim_core_top/CT/PC_r\[31:0\]} \
{/sim_core_top/CT/clk} \
{/sim_core_top/CT/clk_aon} \
{/sim_core_top/CT/core_top_irq_req} \
{/sim_core_top/CT/core_unexcp_err} \
{/sim_core_top/CT/core_wfi} \
{/sim_core_top/CT/epc_r\[31:0\]} \
{/sim_core_top/CT/ext_int_ack} \
{/sim_core_top/CT/external_interrupt} \
{/sim_core_top/CT/exu_bjp_flush_req} \
{/sim_core_top/CT/exu_ifu_excp} \
{/sim_core_top/CT/exu_ifu_rv32} \
{/sim_core_top/CT/exu_ita_addr\[31:0\]} \
{/sim_core_top/CT/exu_ita_rd} \
{/sim_core_top/CT/exu_ita_valid} \
{/sim_core_top/CT/exu_ita_wdata\[31:0\]} \
{/sim_core_top/CT/exu_ita_wr} \
{/sim_core_top/CT/exu_ready} \
{/sim_core_top/CT/ifu_valid} \
{/sim_core_top/CT/ir_r\[31:0\]} \
{/sim_core_top/CT/ita_exu_ext_int} \
{/sim_core_top/CT/ita_exu_meip} \
{/sim_core_top/CT/ita_exu_msip} \
{/sim_core_top/CT/ita_exu_mtip} \
{/sim_core_top/CT/ita_exu_rdata\[31:0\]} \
{/sim_core_top/CT/ita_exu_ready} \
{/sim_core_top/CT/ita_exu_sft_int} \
{/sim_core_top/CT/ita_exu_tmr_int} \
{/sim_core_top/CT/ita_ifu_int_pending_flag} \
{/sim_core_top/CT/mtvec_r\[31:0\]} \
{/sim_core_top/CT/pipe_flush_pc\[31:0\]} \
{/sim_core_top/CT/pipe_flush_req} \
{/sim_core_top/CT/rst_n} \
{/sim_core_top/CT/rst_n_syn} \
{/sim_core_top/CT/EXT/clk} \
{/sim_core_top/CT/EXT/clk_aon} \
{/sim_core_top/CT/EXT/dbg_mode} \
{/sim_core_top/CT/EXT/exu_agu_cmd_addr\[31:0\]} \
{/sim_core_top/CT/EXT/exu_agu_cmd_enable} \
{/sim_core_top/CT/EXT/exu_agu_cmd_misalgn} \
{/sim_core_top/CT/EXT/exu_agu_cmd_read} \
{/sim_core_top/CT/EXT/exu_agu_cmd_size\[1:0\]} \
{/sim_core_top/CT/EXT/exu_agu_cmd_usign} \
{/sim_core_top/CT/EXT/exu_agu_cmd_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/exu_agu_cmd_wmask\[3:0\]} \
{/sim_core_top/CT/EXT/exu_agu_cmd_write} \
{/sim_core_top/CT/EXT/exu_agu_cmt_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/exu_alu_bjp_cmt_bjp} \
{/sim_core_top/CT/EXT/exu_alu_bjp_cmt_mret} \
{/sim_core_top/CT/EXT/exu_alu_bjp_cmt_needflush} \
{/sim_core_top/CT/EXT/exu_alu_bjp_req_flush_pc\[31:0\]} \
{/sim_core_top/CT/EXT/exu_alu_csr_cmd_idx\[11:0\]} \
{/sim_core_top/CT/EXT/exu_alu_csr_cmd_rd_en} \
{/sim_core_top/CT/EXT/exu_alu_csr_cmd_rdata\[31:0\]} \
{/sim_core_top/CT/EXT/exu_alu_csr_cmd_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/exu_alu_csr_cmd_wr_en} \
{/sim_core_top/CT/EXT/exu_alu_err} \
{/sim_core_top/CT/EXT/exu_cmt_commit_trap} \
{/sim_core_top/CT/EXT/exu_cmt_csr_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/exu_cmt_csr_badaddr_ena} \
{/sim_core_top/CT/EXT/exu_cmt_csr_cause\[31:0\]} \
{/sim_core_top/CT/EXT/exu_cmt_csr_cause_ena} \
{/sim_core_top/CT/EXT/exu_cmt_csr_epc\[31:0\]} \
{/sim_core_top/CT/EXT/exu_cmt_csr_epc_ena} \
{/sim_core_top/CT/EXT/exu_cmt_csr_instret_ena} \
{/sim_core_top/CT/EXT/exu_cmt_csr_mret_ena} \
{/sim_core_top/CT/EXT/exu_cmt_csr_status_ena} \
{/sim_core_top/CT/EXT/exu_csr_access_ilgl} \
{/sim_core_top/CT/EXT/exu_csr_ena} \
{/sim_core_top/CT/EXT/exu_csr_epc_r\[31:0\]} \
{/sim_core_top/CT/EXT/exu_csr_mtvec_r\[31:0\]} \
{/sim_core_top/CT/EXT/exu_dec_buserr} \
{/sim_core_top/CT/EXT/exu_dec_csrrw} \
{/sim_core_top/CT/EXT/exu_dec_ilegl} \
{/sim_core_top/CT/EXT/exu_dec_imm\[31:0\]} \
{/sim_core_top/CT/EXT/exu_dec_info\[25:0\]} \
{/sim_core_top/CT/EXT/exu_dec_ld} \
{/sim_core_top/CT/EXT/exu_dec_misalgn} \
{/sim_core_top/CT/EXT/exu_dec_pc_cycle\[5:0\]} \
{/sim_core_top/CT/EXT/exu_dec_rdidx\[4:0\]} \
{/sim_core_top/CT/EXT/exu_dec_rdwen} \
{/sim_core_top/CT/EXT/exu_dec_rs1en} \
{/sim_core_top/CT/EXT/exu_dec_rs1idx\[4:0\]} \
{/sim_core_top/CT/EXT/exu_dec_rs2en} \
{/sim_core_top/CT/EXT/exu_dec_rs2idx\[4:0\]} \
{/sim_core_top/CT/EXT/exu_dec_rv32} \
{/sim_core_top/CT/EXT/exu_dec_st} \
{/sim_core_top/CT/EXT/exu_i_ifu_buserr} \
{/sim_core_top/CT/EXT/exu_i_ifu_misalgn} \
{/sim_core_top/CT/EXT/exu_i_ifu_valid} \
{/sim_core_top/CT/EXT/exu_i_instr\[31:0\]} \
{/sim_core_top/CT/EXT/exu_i_ita_ext_irq} \
{/sim_core_top/CT/EXT/exu_i_ita_meip} \
{/sim_core_top/CT/EXT/exu_i_ita_msip} \
{/sim_core_top/CT/EXT/exu_i_ita_mtip} \
{/sim_core_top/CT/EXT/exu_i_ita_rdata\[31:0\]} \
{/sim_core_top/CT/EXT/exu_i_ita_ready} \
{/sim_core_top/CT/EXT/exu_i_ita_sft_irq} \
{/sim_core_top/CT/EXT/exu_i_ita_tmr_irq} \
{/sim_core_top/CT/EXT/exu_i_pc\[31:0\]} \
{/sim_core_top/CT/EXT/exu_mc_delay_err} \
{/sim_core_top/CT/EXT/exu_meie_r} \
{/sim_core_top/CT/EXT/exu_memt_agu_wbck_err} \
{/sim_core_top/CT/EXT/exu_memt_agu_wbck_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/exu_msie_r} \
{/sim_core_top/CT/EXT/exu_mtie_r} \
{/sim_core_top/CT/EXT/exu_o_bjp_flush_req} \
{/sim_core_top/CT/EXT/exu_o_core_wfi} \
{/sim_core_top/CT/EXT/exu_o_excp} \
{/sim_core_top/CT/EXT/exu_o_exu_ready} \
{/sim_core_top/CT/EXT/exu_o_ita_addr\[31:0\]} \
{/sim_core_top/CT/EXT/exu_o_ita_rd} \
{/sim_core_top/CT/EXT/exu_o_ita_valid} \
{/sim_core_top/CT/EXT/exu_o_ita_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/exu_o_ita_wr} \
{/sim_core_top/CT/EXT/exu_o_mtvec_r\[31:0\]} \
{/sim_core_top/CT/EXT/exu_o_pc_irq_req} \
{/sim_core_top/CT/EXT/exu_o_pipe_flush_pc\[31:0\]} \
{/sim_core_top/CT/EXT/exu_o_pipe_flush_req} \
{/sim_core_top/CT/EXT/exu_o_rv32} \
{/sim_core_top/CT/EXT/exu_o_unexpected_err} \
{/sim_core_top/CT/EXT/exu_pc_cycle_count\[5:0\]} \
{/sim_core_top/CT/EXT/exu_read_src1_data\[31:0\]} \
{/sim_core_top/CT/EXT/exu_read_src2_data\[31:0\]} \
{/sim_core_top/CT/EXT/exu_rf_op1\[31:0\]} \
{/sim_core_top/CT/EXT/exu_rf_op2\[31:0\]} \
{/sim_core_top/CT/EXT/exu_status_mie_r} \
{/sim_core_top/CT/EXT/exu_wbck_rdidx\[4:0\]} \
{/sim_core_top/CT/EXT/exu_wbck_rf_ena} \
{/sim_core_top/CT/EXT/exu_wbck_rf_rdidx\[4:0\]} \
{/sim_core_top/CT/EXT/exu_wbck_rf_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/exu_wbck_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/h_mode} \
{/sim_core_top/CT/EXT/m_mode} \
{/sim_core_top/CT/EXT/memtop_i_valid} \
{/sim_core_top/CT/EXT/memtop_o_ready} \
{/sim_core_top/CT/EXT/pc_et_i_epc_r\[31:0\]} \
{/sim_core_top/CT/EXT/rst_n} \
{/sim_core_top/CT/EXT/s_mode} \
{/sim_core_top/CT/EXT/u_mode} \
{/sim_core_top/CT/EXT/AU/agu_req_alu} \
{/sim_core_top/CT/EXT/AU/agu_req_alu_add} \
{/sim_core_top/CT/EXT/AU/agu_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/agu_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/agu_req_alu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_addr\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_enable} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_misalgn} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_read} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_size\[1:0\]} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_usign} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_wmask\[3:0\]} \
{/sim_core_top/CT/EXT/AU/alu_agu_cmd_write} \
{/sim_core_top/CT/EXT/AU/alu_bjp_cmt_bjp} \
{/sim_core_top/CT/EXT/AU/alu_bjp_cmt_dret} \
{/sim_core_top/CT/EXT/AU/alu_bjp_cmt_mret} \
{/sim_core_top/CT/EXT/AU/alu_bjp_cmt_needflush} \
{/sim_core_top/CT/EXT/AU/alu_bjp_req_flush_pc\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_csr_cmd_access_ilgl} \
{/sim_core_top/CT/EXT/AU/alu_csr_cmd_idx\[11:0\]} \
{/sim_core_top/CT/EXT/AU/alu_csr_cmd_rd_en} \
{/sim_core_top/CT/EXT/AU/alu_csr_cmd_rdata\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_csr_cmd_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_csr_cmd_wr_en} \
{/sim_core_top/CT/EXT/AU/alu_enable_agu} \
{/sim_core_top/CT/EXT/AU/alu_enable_bjp} \
{/sim_core_top/CT/EXT/AU/alu_enable_csr} \
{/sim_core_top/CT/EXT/AU/alu_enable_muldiv} \
{/sim_core_top/CT/EXT/AU/alu_enable_ralu} \
{/sim_core_top/CT/EXT/AU/alu_i_csrdpc\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_csrepc\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_imm\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_imm_agu\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_imm_bjp\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_imm_muldiv\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_imm_ralu\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_info\[25:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_info_agu\[10:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_info_bjp\[15:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_info_csr\[25:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_info_muldiv\[11:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_info_ralu\[20:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_pc_cycle\[5:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_pc_r\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs1_agu\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs1_bjp\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs1_csr\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs1_muldiv\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs1_ralu\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs2_agu\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs2_bjp\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs2_muldiv\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_i_rs2_ralu\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_memtop_wback_data\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_memtop_wback_err} \
{/sim_core_top/CT/EXT/AU/alu_ralu_cmt_ebreak} \
{/sim_core_top/CT/EXT/AU/alu_ralu_cmt_ecall} \
{/sim_core_top/CT/EXT/AU/alu_ralu_cmt_wfi} \
{/sim_core_top/CT/EXT/AU/alu_wbck_data\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_wbck_data_agu\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_wbck_data_bjp\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_wbck_data_csr\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_wbck_data_muldiv\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_wbck_data_ralu\[31:0\]} \
{/sim_core_top/CT/EXT/AU/alu_wbck_err} \
{/sim_core_top/CT/EXT/AU/alu_wbck_err_agu} \
{/sim_core_top/CT/EXT/AU/alu_wbck_err_bjp} \
{/sim_core_top/CT/EXT/AU/alu_wbck_err_csr} \
{/sim_core_top/CT/EXT/AU/alu_wbck_err_muldiv} \
{/sim_core_top/CT/EXT/AU/alu_wbck_err_ralu} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_cmp_eq} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_cmp_gt} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_cmp_gtu} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_cmp_lt} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_cmp_ltu} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_cmp_ne} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_cmp_res} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/bjp_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/clk} \
{/sim_core_top/CT/EXT/AU/muldiv_req_alu} \
{/sim_core_top/CT/EXT/AU/muldiv_req_alu_cmp_res} \
{/sim_core_top/CT/EXT/AU/muldiv_req_alu_ltu} \
{/sim_core_top/CT/EXT/AU/muldiv_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/muldiv_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/muldiv_req_alu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_addr_unalgn} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_addr\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_enable} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_misalgn} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_read} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_size\[1:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_usign} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_wmask\[3:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_cmd_write} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_enable} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_imm\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_info\[10:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_load} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_op2imm} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_rs1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_rs2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_size\[1:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_size_b} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_size_hw} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_size_w} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_store} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_i_usign} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_o_wback_data\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_o_wback_err} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_req_alu} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_req_alu_add} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/agu_req_alu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/algnst_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/algnst_wmask\[3:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/memtop_wback_data\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_agu/memtop_wback_err} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_i_csrdpc\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_i_csrepc\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_i_imm\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_i_info\[15:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_i_pc_r\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_i_rs1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_i_rs2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_o_cmt_bjp} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_o_cmt_dret} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_o_cmt_mret} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_o_cmt_needflush} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_o_wbck_err} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_o_wbck_wdat\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_cmp_eq} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_cmp_gt} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_cmp_gtu} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_cmp_lt} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_cmp_ltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_cmp_ne} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_cmp_res} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_flush} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bjp_req_flush_pc\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/bxx} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/dret} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/jal} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/jalr} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/jump} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/mret} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/rv16} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/rv32} \
{/sim_core_top/CT/EXT/AU/exu_alu_bjp/wbck_link} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_access_ilgl} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_cmd_rdata\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_cmd_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_i_info\[25:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_i_rs1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_idx\[11:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_rd_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csr_wr_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csridx\[11:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csrrc} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csrrs} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/csrrw} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/rs1imm} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/rs1is0} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/wbck_csr_dat\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/wbck_csr_ilgl} \
{/sim_core_top/CT/EXT/AU/exu_alu_csrctrl/zimm\[4:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/div_fix_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/div_sel_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/mul_sel_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_i_info\[11:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_i_rs1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_i_rs2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_illegal} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_mul_res\[65:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_mul_res_h\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_mul_res_l\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_op1_unsigned} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_op2_unsigned} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_quo_res\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_rem_res\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_req_alu} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_req_alu_cmp_res} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_req_alu_ltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_req_alu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_signed_op1\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_signed_op2\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_start_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/muldiv_wbck_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/pc_cycle\[5:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/rv32_div} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/rv32_divu} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/rv32_mul} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/rv32_mulh} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/rv32_mulhsu} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/rv32_mulhu} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/rv32_rem} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/rv32_remu} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_fix_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_op1\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_op1_unsigned\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_op2\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_op2_illegal} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_op2_unsigned\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_r\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_req_alu} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_req_alu_cmp_res} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_req_alu_ltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_req_alu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_sel_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_start_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/op1_signed} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/op1_unsigned_r\[30:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/op1_unsigned_r_nxt\[30:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/op2_signed} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_fixed\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_r\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_res\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_shift\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/rem_fixed\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/rem_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/rem_r\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/rem_res\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_register/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_register/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_register/lden} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/div_register/qout\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/op1_register/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/op1_register/dnxt\[30:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/op1_register/lden} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/op1_register/qout\[30:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_register/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_register/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_register/lden} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/quo_register/qout\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/rem_register/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/rem_register/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/rem_register/lden} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_divider/rem_register/qout\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/current_code\[2:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/current_op1\[65:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_op1\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_op2\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_op2_nxt\[34:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_op2_r\[34:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_res\[65:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_sel_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_start_en} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/neg} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/one} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/pc_cycle\[5:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/res_nxt\[65:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/res_r\[65:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/two} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/weighted_op1\[65:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/zero} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_opr/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_opr/dnxt\[34:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_opr/lden} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_opr/qout\[34:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_rer/clk} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_rer/dnxt\[65:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_rer/lden} \
{/sim_core_top/CT/EXT/AU/exu_alu_muldiv/multi_cycle_multiplier/mul_rer/qout\[65:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/adder_add} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/adder_op1\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/adder_op2\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/adder_res\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/adder_sub} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/agu_req_alu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/agu_req_alu_add} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/agu_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/agu_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/agu_req_alu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_dpath_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_i_imm\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_i_info\[20:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_i_pc\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_i_rs1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_i_rs2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_add} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_and} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_lui} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_or} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_sll} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_slt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_sltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_sra} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_srl} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_sub} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/alu_req_alu_xor} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/ander_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_cmp_eq} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_cmp_gt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_cmp_gtu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_cmp_lt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_cmp_ltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_cmp_ne} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_cmp_res} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/bjp_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/cmp_res} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/cmp_res_eq} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/cmp_res_gt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/cmp_res_gtu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/cmp_res_lt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/cmp_res_ltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/cmp_res_ne} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/ebreak} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/ecall} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/eff_mask\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/misc_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/misc_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/muldiv_req_alu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/muldiv_req_alu_cmp_res} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/muldiv_req_alu_ltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/muldiv_req_alu_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/muldiv_req_alu_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/muldiv_req_alu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mux_op1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mux_op2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mvop2_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/neq} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/nop} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op1_gt_op2} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op1pc} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op2imm} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_add} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_addsub} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_and} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_cmp_eq} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_cmp_gt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_cmp_gtu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_cmp_lt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_cmp_ltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_cmp_ne} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_mvop2} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_or} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_shift} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_sll} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_slt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_slttu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_sltu} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_sra} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_srl} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_sub} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_unsigned} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_xor} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/op_xorer} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/orer_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/ralu_o_cmt_ebreak} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/ralu_o_cmt_ecall} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/ralu_o_cmt_wfi} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/ralu_o_wbck_err} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/ralu_o_wbck_wdat\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/shifter_in1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/shifter_in2\[4:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/shifter_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/sll_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/slttu_cmp_lt} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/slttu_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/sra_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/srl_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/wfi} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/xorer_in1\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/xorer_in2\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/xorer_res\[31:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/adder_addsub} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/adder_cin} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/adder_in1\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/adder_in2\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/mau_adder_add} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/mau_adder_op1\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/mau_adder_op2\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/mau_adder_res\[32:0\]} \
{/sim_core_top/CT/EXT/AU/exu_alu_ralu/mau/mau_adder_sub} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_alu_err} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_buserr} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_ecall} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_ifu_buserr} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_ifu_ilegl} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_ifu_misalgn} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_ld} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_misalgn} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_stamo} \
{/sim_core_top/CT/EXT/CMT/alu_cmt_i_wfi} \
{/sim_core_top/CT/EXT/CMT/clk} \
{/sim_core_top/CT/EXT/CMT/cmt_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/cmt_badaddr_ena} \
{/sim_core_top/CT/EXT/CMT/cmt_bjp_flush_req} \
{/sim_core_top/CT/EXT/CMT/cmt_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/cmt_cause_ena} \
{/sim_core_top/CT/EXT/CMT/cmt_commit_trap} \
{/sim_core_top/CT/EXT/CMT/cmt_ena} \
{/sim_core_top/CT/EXT/CMT/cmt_epc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/cmt_epc_ena} \
{/sim_core_top/CT/EXT/CMT/cmt_i_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/cmt_i_bjp_flush_PC\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/cmt_i_bjp_mret} \
{/sim_core_top/CT/EXT/CMT/cmt_i_bjp_need_flush} \
{/sim_core_top/CT/EXT/CMT/cmt_i_exu_ready} \
{/sim_core_top/CT/EXT/CMT/cmt_i_ifu_valid} \
{/sim_core_top/CT/EXT/CMT/cmt_i_instr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/cmt_i_ita_ext_irq} \
{/sim_core_top/CT/EXT/CMT/cmt_i_ita_sft_irq} \
{/sim_core_top/CT/EXT/CMT/cmt_i_ita_tmr_irq} \
{/sim_core_top/CT/EXT/CMT/cmt_i_pc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/cmt_i_wfi_halt_ack} \
{/sim_core_top/CT/EXT/CMT/cmt_instret_ena} \
{/sim_core_top/CT/EXT/CMT/cmt_mret_ena} \
{/sim_core_top/CT/EXT/CMT/cmt_status_ena} \
{/sim_core_top/CT/EXT/CMT/commit_irq_req} \
{/sim_core_top/CT/EXT/CMT/core_wfi} \
{/sim_core_top/CT/EXT/CMT/csr_mtvec_r\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/dbg_mode} \
{/sim_core_top/CT/EXT/CMT/excpirq_flush_addr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/excpirq_flush_req} \
{/sim_core_top/CT/EXT/CMT/h_mode} \
{/sim_core_top/CT/EXT/CMT/m_mode} \
{/sim_core_top/CT/EXT/CMT/meie_r} \
{/sim_core_top/CT/EXT/CMT/msie_r} \
{/sim_core_top/CT/EXT/CMT/mtie_r} \
{/sim_core_top/CT/EXT/CMT/pc_cmt_i_epc_r\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/pipe_flush_pc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/pipe_flush_req} \
{/sim_core_top/CT/EXT/CMT/rst_n} \
{/sim_core_top/CT/EXT/CMT/s_mode} \
{/sim_core_top/CT/EXT/CMT/status_mie_r} \
{/sim_core_top/CT/EXT/CMT/u_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_alu_err} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_ecall} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_ifu_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_ifu_ilegl} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_ifu_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_ld} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_stamo} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/alu_excp_i_wfi} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/aluexcp_flush_req_ifu_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/aluexcp_flush_req_ifu_ilegl} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/aluexcp_flush_req_ifu_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/clk} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/cmt_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/cmt_badaddr_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/cmt_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/cmt_cause_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/cmt_epc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/cmt_epc_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/cmt_status_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/core_wfi} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/csr_mtvec_r\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/dbg_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_taken_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_alu_need_flush} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_excp_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_flush_by_alu_agu} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_i_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_i_epc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_i_instr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_i_pc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_irq_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_irq_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_o_commit_trap} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_wfi_flag_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excp_top_wfi_irq_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excpirq_flush_addr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/excpirq_flush_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_ext_irq} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_sft_irq} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_tmr_irq} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/h_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/irq_taken_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/m_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/meie_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/msie_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/mtie_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/rst_n} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/s_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/status_mie_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/u_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/wfi_halt_ack} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/alu_excp_flush_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_by_alu_agu} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_alu_err} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_ebreak} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_ecall} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_ifu_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_ifu_ilegl} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_ifu_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_ld} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_ld_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_ld_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_stamo} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_stamo_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_flush_req_stamo_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_alu_err} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_ebreak} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_ebreak4dbg} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_ebreak4excp} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_ecall} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_ifu_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_ifu_ilegl} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_ifu_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_ld} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_i_stamo} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_o_ebreakm_flush_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_o_excp_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_o_flush_by_alu_agu} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/aluexcp_o_need_flush4excp} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/dbg_ebreakm_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/dbg_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/excp_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/h_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/m_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/s_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_aluexcp_unit/u_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/cmt_badaddr_update} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/dbg_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_epc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_excp_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_excp_taken_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_flush_by_alu_agu} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_flush_req_ebreak} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_flush_req_ifu_buserr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_flush_req_ifu_ilegl} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_flush_req_ifu_misalgn} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_instr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_irq_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_irq_taken_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_i_pc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_o_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_o_badaddr_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_o_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_o_cause_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_o_epc\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_o_epc_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpcmt_o_status_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_cmt_csr_unit/excpirq_flush_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/clk} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/dbg_mode} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/ext_irq} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/irq_i_wfi_flag_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/irq_o_irq_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/irq_o_irq_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/irq_o_irq_req_active} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/irq_o_wfi_irq_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/irq_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/irq_req_raw} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/meie_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/msie_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/mtie_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/sft_irq} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/status_mie_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/tmr_irq} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_irq_unit/wfi_irq_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/clk} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/core_wfi} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/excp_i_alu_wfi} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/rst_n} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_clr} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_ena} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_nxt} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_set} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_i_irq_req} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_i_wfi_halt_ack} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_o_core_wfi} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_o_wfi_flag_r} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_dfflr/clk} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_dfflr/dnxt\[0:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_dfflr/lden} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_dfflr/qout\[0:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_dfflr/qout_r\[0:0\]} \
{/sim_core_top/CT/EXT/CMT/u_exu_excp/exu_excp_wfi_unit/wfi_flag_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/badaddr_ena} \
{/sim_core_top/CT/EXT/CSR/badaddr_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/badaddr_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/cause_ena} \
{/sim_core_top/CT/EXT/CSR/cause_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/cause_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/clk} \
{/sim_core_top/CT/EXT/CSR/clk_aon} \
{/sim_core_top/CT/EXT/CSR/cmt_badaddr\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/cmt_badaddr_ena} \
{/sim_core_top/CT/EXT/CSR/cmt_cause\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/cmt_cause_ena} \
{/sim_core_top/CT/EXT/CSR/cmt_epc\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/cmt_epc_ena} \
{/sim_core_top/CT/EXT/CSR/cmt_instret_ena} \
{/sim_core_top/CT/EXT/CSR/cmt_mret_ena} \
{/sim_core_top/CT/EXT/CSR/cmt_status_ena} \
{/sim_core_top/CT/EXT/CSR/cmt_trap_badaddr_ena} \
{/sim_core_top/CT/EXT/CSR/csr_cycle\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_cycleh\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_ena} \
{/sim_core_top/CT/EXT/CSR/csr_epc_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_i_ita_meip} \
{/sim_core_top/CT/EXT/CSR/csr_i_ita_msip} \
{/sim_core_top/CT/EXT/CSR/csr_i_ita_mtip} \
{/sim_core_top/CT/EXT/CSR/csr_idx\[11:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_marchid\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mbadaddr\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mcause\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mcycle\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mcycleh\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_meip_r} \
{/sim_core_top/CT/EXT/CSR/csr_mepc\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mhartid\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mie\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mimpid\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_minstret\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_minstreth\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mip\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_misa\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mscratch\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_msip_r} \
{/sim_core_top/CT/EXT/CSR/csr_mstatus\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mtip_r} \
{/sim_core_top/CT/EXT/CSR/csr_mtvec\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mtvec_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_mvendorid\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/csr_o_access_ilgl} \
{/sim_core_top/CT/EXT/CSR/csr_rd_en} \
{/sim_core_top/CT/EXT/CSR/csr_wr_en} \
{/sim_core_top/CT/EXT/CSR/epc_ena} \
{/sim_core_top/CT/EXT/CSR/epc_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/epc_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/h_mode} \
{/sim_core_top/CT/EXT/CSR/m_mode} \
{/sim_core_top/CT/EXT/CSR/mcycle_ena} \
{/sim_core_top/CT/EXT/CSR/mcycle_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycle_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycle_wr_ena} \
{/sim_core_top/CT/EXT/CSR/mcycleh_ena} \
{/sim_core_top/CT/EXT/CSR/mcycleh_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycleh_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycleh_wr_ena} \
{/sim_core_top/CT/EXT/CSR/meie_r} \
{/sim_core_top/CT/EXT/CSR/mie_ena} \
{/sim_core_top/CT/EXT/CSR/mie_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mie_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstret_ena} \
{/sim_core_top/CT/EXT/CSR/minstret_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstret_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstret_wr_ena} \
{/sim_core_top/CT/EXT/CSR/minstreth_ena} \
{/sim_core_top/CT/EXT/CSR/minstreth_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstreth_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstreth_wr_ena} \
{/sim_core_top/CT/EXT/CSR/mip_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mscratch_ena} \
{/sim_core_top/CT/EXT/CSR/mscratch_nxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mscratch_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/msie_r} \
{/sim_core_top/CT/EXT/CSR/mtie_r} \
{/sim_core_top/CT/EXT/CSR/priv_mode\[1:0\]} \
{/sim_core_top/CT/EXT/CSR/rd_marchid} \
{/sim_core_top/CT/EXT/CSR/rd_mbadaddr} \
{/sim_core_top/CT/EXT/CSR/rd_mcause} \
{/sim_core_top/CT/EXT/CSR/rd_mcycle} \
{/sim_core_top/CT/EXT/CSR/rd_mcycleh} \
{/sim_core_top/CT/EXT/CSR/rd_mepc} \
{/sim_core_top/CT/EXT/CSR/rd_mhartid} \
{/sim_core_top/CT/EXT/CSR/rd_mie} \
{/sim_core_top/CT/EXT/CSR/rd_mimpid} \
{/sim_core_top/CT/EXT/CSR/rd_minstret} \
{/sim_core_top/CT/EXT/CSR/rd_minstreth} \
{/sim_core_top/CT/EXT/CSR/rd_mip} \
{/sim_core_top/CT/EXT/CSR/rd_misa} \
{/sim_core_top/CT/EXT/CSR/rd_mscratch} \
{/sim_core_top/CT/EXT/CSR/rd_mstatus} \
{/sim_core_top/CT/EXT/CSR/rd_mtvec} \
{/sim_core_top/CT/EXT/CSR/rd_mvendorid} \
{/sim_core_top/CT/EXT/CSR/read_csr_dat\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/read_csr_ena} \
{/sim_core_top/CT/EXT/CSR/rst_n} \
{/sim_core_top/CT/EXT/CSR/s_mode} \
{/sim_core_top/CT/EXT/CSR/sel_indicator\[12:0\]} \
{/sim_core_top/CT/EXT/CSR/sel_mbadaddr} \
{/sim_core_top/CT/EXT/CSR/sel_mcause} \
{/sim_core_top/CT/EXT/CSR/sel_mcycle} \
{/sim_core_top/CT/EXT/CSR/sel_mcycleh} \
{/sim_core_top/CT/EXT/CSR/sel_mepc} \
{/sim_core_top/CT/EXT/CSR/sel_mie} \
{/sim_core_top/CT/EXT/CSR/sel_minstret} \
{/sim_core_top/CT/EXT/CSR/sel_minstreth} \
{/sim_core_top/CT/EXT/CSR/sel_mip} \
{/sim_core_top/CT/EXT/CSR/sel_misa} \
{/sim_core_top/CT/EXT/CSR/sel_mscratch} \
{/sim_core_top/CT/EXT/CSR/sel_mstatus} \
{/sim_core_top/CT/EXT/CSR/sel_mtvec} \
{/sim_core_top/CT/EXT/CSR/status_fs_r\[1:0\]} \
{/sim_core_top/CT/EXT/CSR/status_mie_ena} \
{/sim_core_top/CT/EXT/CSR/status_mie_nxt} \
{/sim_core_top/CT/EXT/CSR/status_mie_r} \
{/sim_core_top/CT/EXT/CSR/status_mpie_ena} \
{/sim_core_top/CT/EXT/CSR/status_mpie_nxt} \
{/sim_core_top/CT/EXT/CSR/status_mpie_r} \
{/sim_core_top/CT/EXT/CSR/status_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/status_sd_r} \
{/sim_core_top/CT/EXT/CSR/status_xs_r\[1:0\]} \
{/sim_core_top/CT/EXT/CSR/u_mode} \
{/sim_core_top/CT/EXT/CSR/wbck_csr_dat\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/wbck_csr_wen} \
{/sim_core_top/CT/EXT/CSR/wr_mbadaddr} \
{/sim_core_top/CT/EXT/CSR/wr_mcause} \
{/sim_core_top/CT/EXT/CSR/wr_mcycle} \
{/sim_core_top/CT/EXT/CSR/wr_mcycleh} \
{/sim_core_top/CT/EXT/CSR/wr_mepc} \
{/sim_core_top/CT/EXT/CSR/wr_mie} \
{/sim_core_top/CT/EXT/CSR/wr_minstret} \
{/sim_core_top/CT/EXT/CSR/wr_minstreth} \
{/sim_core_top/CT/EXT/CSR/wr_mscratch} \
{/sim_core_top/CT/EXT/CSR/wr_mstatus} \
{/sim_core_top/CT/EXT/CSR/badaddr_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/badaddr_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/badaddr_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/badaddr_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/badaddr_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/badaddr_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/cause_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/cause_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/cause_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/cause_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/cause_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/cause_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/epc_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/epc_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/epc_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/epc_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/epc_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/epc_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/mcycle_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/mcycle_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycle_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/mcycle_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycle_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycle_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/mcycleh_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/mcycleh_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycleh_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/mcycleh_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycleh_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mcycleh_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/meip_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/meip_dfflr/dnxt\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/meip_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/meip_dfflr/qout\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/meip_dfflr/qout_r\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/meip_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/mie_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/mie_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mie_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/mie_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mie_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mie_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/minstret_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/minstret_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstret_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/minstret_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstret_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstret_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/minstreth_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/minstreth_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstreth_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/minstreth_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstreth_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/minstreth_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/mscratch_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/mscratch_dfflr/dnxt\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mscratch_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/mscratch_dfflr/qout\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mscratch_dfflr/qout_r\[31:0\]} \
{/sim_core_top/CT/EXT/CSR/mscratch_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/msip_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/msip_dfflr/dnxt\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/msip_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/msip_dfflr/qout\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/msip_dfflr/qout_r\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/msip_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/mtip_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/mtip_dfflr/dnxt\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/mtip_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/mtip_dfflr/qout\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/mtip_dfflr/qout_r\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/mtip_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/status_mie_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/status_mie_dfflr/dnxt\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/status_mie_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/status_mie_dfflr/qout\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/status_mie_dfflr/qout_r\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/status_mie_dfflr/rst_n} \
{/sim_core_top/CT/EXT/CSR/status_mpie_dfflr/clk} \
{/sim_core_top/CT/EXT/CSR/status_mpie_dfflr/dnxt\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/status_mpie_dfflr/lden} \
{/sim_core_top/CT/EXT/CSR/status_mpie_dfflr/qout\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/status_mpie_dfflr/qout_r\[0:0\]} \
{/sim_core_top/CT/EXT/CSR/status_mpie_dfflr/rst_n} \
{/sim_core_top/CT/EXT/DC/agu_info_bus\[10:0\]} \
{/sim_core_top/CT/EXT/DC/alu_info_bus\[20:0\]} \
{/sim_core_top/CT/EXT/DC/alu_no_nop} \
{/sim_core_top/CT/EXT/DC/alu_op} \
{/sim_core_top/CT/EXT/DC/amoldst_op} \
{/sim_core_top/CT/EXT/DC/bjp_info_bus\[15:0\]} \
{/sim_core_top/CT/EXT/DC/bjp_op} \
{/sim_core_top/CT/EXT/DC/csr_info_bus\[25:0\]} \
{/sim_core_top/CT/EXT/DC/csr_op} \
{/sim_core_top/CT/EXT/DC/dbg_mode} \
{/sim_core_top/CT/EXT/DC/dec_bjp} \
{/sim_core_top/CT/EXT/DC/dec_buserr} \
{/sim_core_top/CT/EXT/DC/dec_bxx} \
{/sim_core_top/CT/EXT/DC/dec_csrrw} \
{/sim_core_top/CT/EXT/DC/dec_ilegl} \
{/sim_core_top/CT/EXT/DC/dec_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/dec_info\[25:0\]} \
{/sim_core_top/CT/EXT/DC/dec_jal} \
{/sim_core_top/CT/EXT/DC/dec_jalr} \
{/sim_core_top/CT/EXT/DC/dec_ld} \
{/sim_core_top/CT/EXT/DC/dec_misalgn} \
{/sim_core_top/CT/EXT/DC/dec_pc_cycle\[5:0\]} \
{/sim_core_top/CT/EXT/DC/dec_rdidx\[4:0\]} \
{/sim_core_top/CT/EXT/DC/dec_rdwen} \
{/sim_core_top/CT/EXT/DC/dec_rs1en} \
{/sim_core_top/CT/EXT/DC/dec_rs1idx\[4:0\]} \
{/sim_core_top/CT/EXT/DC/dec_rs2en} \
{/sim_core_top/CT/EXT/DC/dec_rs2idx\[4:0\]} \
{/sim_core_top/CT/EXT/DC/dec_rv32} \
{/sim_core_top/CT/EXT/DC/dec_store} \
{/sim_core_top/CT/EXT/DC/ecall_ebreak} \
{/sim_core_top/CT/EXT/DC/i_buserr} \
{/sim_core_top/CT/EXT/DC/i_instr\[31:0\]} \
{/sim_core_top/CT/EXT/DC/i_misalgn} \
{/sim_core_top/CT/EXT/DC/i_pc\[31:0\]} \
{/sim_core_top/CT/EXT/DC/legl_ops} \
{/sim_core_top/CT/EXT/DC/lsu_info_size\[1:0\]} \
{/sim_core_top/CT/EXT/DC/lsu_info_usign} \
{/sim_core_top/CT/EXT/DC/muldiv_info_bus\[11:0\]} \
{/sim_core_top/CT/EXT/DC/muldiv_op} \
{/sim_core_top/CT/EXT/DC/need_imm} \
{/sim_core_top/CT/EXT/DC/opcode\[6:0\]} \
{/sim_core_top/CT/EXT/DC/opcode_1_0_00} \
{/sim_core_top/CT/EXT/DC/opcode_1_0_01} \
{/sim_core_top/CT/EXT/DC/opcode_1_0_10} \
{/sim_core_top/CT/EXT/DC/opcode_1_0_11} \
{/sim_core_top/CT/EXT/DC/opcode_4_2_000} \
{/sim_core_top/CT/EXT/DC/opcode_4_2_001} \
{/sim_core_top/CT/EXT/DC/opcode_4_2_010} \
{/sim_core_top/CT/EXT/DC/opcode_4_2_011} \
{/sim_core_top/CT/EXT/DC/opcode_4_2_100} \
{/sim_core_top/CT/EXT/DC/opcode_4_2_101} \
{/sim_core_top/CT/EXT/DC/opcode_4_2_110} \
{/sim_core_top/CT/EXT/DC/opcode_4_2_111} \
{/sim_core_top/CT/EXT/DC/opcode_6_5_00} \
{/sim_core_top/CT/EXT/DC/opcode_6_5_01} \
{/sim_core_top/CT/EXT/DC/opcode_6_5_10} \
{/sim_core_top/CT/EXT/DC/opcode_6_5_11} \
{/sim_core_top/CT/EXT/DC/rv16} \
{/sim_core_top/CT/EXT/DC/rv16_add} \
{/sim_core_top/CT/EXT/DC/rv16_addi} \
{/sim_core_top/CT/EXT/DC/rv16_addi4spn} \
{/sim_core_top/CT/EXT/DC/rv16_addi4spn_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_addi16sp} \
{/sim_core_top/CT/EXT/DC/rv16_addi16sp_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_all0s_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_all1s_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_and} \
{/sim_core_top/CT/EXT/DC/rv16_andi} \
{/sim_core_top/CT/EXT/DC/rv16_beqz} \
{/sim_core_top/CT/EXT/DC/rv16_bnez} \
{/sim_core_top/CT/EXT/DC/rv16_bxx_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cb_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cb_rdd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cb_rss1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cb_rss2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ci16sp_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ci_rd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ci_rs1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ci_rs2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cili_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cilui_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cis_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ciw_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ciw_rdd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ciw_rss1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ciw_rss2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cj_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cj_rdd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cj_rss1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cj_rss2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cl_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cl_rdd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cl_rss1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cl_rss2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cr_rd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cr_rs1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cr_rs2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cs_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cs_rdd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cs_rss1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_cs_rss2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_css_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_css_rd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_css_rs1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_css_rs2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_ebreak} \
{/sim_core_top/CT/EXT/DC/rv16_fld} \
{/sim_core_top/CT/EXT/DC/rv16_fldsp} \
{/sim_core_top/CT/EXT/DC/rv16_flw} \
{/sim_core_top/CT/EXT/DC/rv16_flwsp} \
{/sim_core_top/CT/EXT/DC/rv16_format_cb} \
{/sim_core_top/CT/EXT/DC/rv16_format_ci} \
{/sim_core_top/CT/EXT/DC/rv16_format_ciw} \
{/sim_core_top/CT/EXT/DC/rv16_format_cj} \
{/sim_core_top/CT/EXT/DC/rv16_format_cl} \
{/sim_core_top/CT/EXT/DC/rv16_format_cr} \
{/sim_core_top/CT/EXT/DC/rv16_format_cs} \
{/sim_core_top/CT/EXT/DC/rv16_format_css} \
{/sim_core_top/CT/EXT/DC/rv16_fsd} \
{/sim_core_top/CT/EXT/DC/rv16_fsdsp} \
{/sim_core_top/CT/EXT/DC/rv16_fsw} \
{/sim_core_top/CT/EXT/DC/rv16_fswsp} \
{/sim_core_top/CT/EXT/DC/rv16_func3\[2:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_func3_000} \
{/sim_core_top/CT/EXT/DC/rv16_func3_001} \
{/sim_core_top/CT/EXT/DC/rv16_func3_010} \
{/sim_core_top/CT/EXT/DC/rv16_func3_011} \
{/sim_core_top/CT/EXT/DC/rv16_func3_100} \
{/sim_core_top/CT/EXT/DC/rv16_func3_101} \
{/sim_core_top/CT/EXT/DC/rv16_func3_110} \
{/sim_core_top/CT/EXT/DC/rv16_func3_111} \
{/sim_core_top/CT/EXT/DC/rv16_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_cb} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_ci16sp} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_cili} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_cilui} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_cis} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_ciw} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_cj} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_cl} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_cn} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_cs} \
{/sim_core_top/CT/EXT/DC/rv16_imm_sel_css} \
{/sim_core_top/CT/EXT/DC/rv16_instr\[15:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_instr_6_2_is0s} \
{/sim_core_top/CT/EXT/DC/rv16_instr_12_is0} \
{/sim_core_top/CT/EXT/DC/rv16_j} \
{/sim_core_top/CT/EXT/DC/rv16_jal} \
{/sim_core_top/CT/EXT/DC/rv16_jalr} \
{/sim_core_top/CT/EXT/DC/rv16_jalr_mv_add} \
{/sim_core_top/CT/EXT/DC/rv16_jjal_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_jr} \
{/sim_core_top/CT/EXT/DC/rv16_li} \
{/sim_core_top/CT/EXT/DC/rv16_li_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_li_lui_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_lui} \
{/sim_core_top/CT/EXT/DC/rv16_lui_addi16sp} \
{/sim_core_top/CT/EXT/DC/rv16_lui_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_lw} \
{/sim_core_top/CT/EXT/DC/rv16_lwsp} \
{/sim_core_top/CT/EXT/DC/rv16_lwsp_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_miscalu} \
{/sim_core_top/CT/EXT/DC/rv16_mv} \
{/sim_core_top/CT/EXT/DC/rv16_need_cb_rdd} \
{/sim_core_top/CT/EXT/DC/rv16_need_cb_rss1} \
{/sim_core_top/CT/EXT/DC/rv16_need_cb_rss2} \
{/sim_core_top/CT/EXT/DC/rv16_need_ci_rd} \
{/sim_core_top/CT/EXT/DC/rv16_need_ci_rs1} \
{/sim_core_top/CT/EXT/DC/rv16_need_ci_rs2} \
{/sim_core_top/CT/EXT/DC/rv16_need_ciw_rdd} \
{/sim_core_top/CT/EXT/DC/rv16_need_ciw_rss1} \
{/sim_core_top/CT/EXT/DC/rv16_need_ciw_rss2} \
{/sim_core_top/CT/EXT/DC/rv16_need_cj_rdd} \
{/sim_core_top/CT/EXT/DC/rv16_need_cj_rss1} \
{/sim_core_top/CT/EXT/DC/rv16_need_cj_rss2} \
{/sim_core_top/CT/EXT/DC/rv16_need_cl_rdd} \
{/sim_core_top/CT/EXT/DC/rv16_need_cl_rss1} \
{/sim_core_top/CT/EXT/DC/rv16_need_cl_rss2} \
{/sim_core_top/CT/EXT/DC/rv16_need_cr_rd} \
{/sim_core_top/CT/EXT/DC/rv16_need_cr_rs1} \
{/sim_core_top/CT/EXT/DC/rv16_need_cr_rs2} \
{/sim_core_top/CT/EXT/DC/rv16_need_cs_rdd} \
{/sim_core_top/CT/EXT/DC/rv16_need_cs_rss1} \
{/sim_core_top/CT/EXT/DC/rv16_need_cs_rss2} \
{/sim_core_top/CT/EXT/DC/rv16_need_css_rd} \
{/sim_core_top/CT/EXT/DC/rv16_need_css_rs1} \
{/sim_core_top/CT/EXT/DC/rv16_need_css_rs2} \
{/sim_core_top/CT/EXT/DC/rv16_need_imm} \
{/sim_core_top/CT/EXT/DC/rv16_need_rd} \
{/sim_core_top/CT/EXT/DC/rv16_need_rdd} \
{/sim_core_top/CT/EXT/DC/rv16_need_rs1} \
{/sim_core_top/CT/EXT/DC/rv16_need_rs2} \
{/sim_core_top/CT/EXT/DC/rv16_need_rss1} \
{/sim_core_top/CT/EXT/DC/rv16_need_rss2} \
{/sim_core_top/CT/EXT/DC/rv16_nop} \
{/sim_core_top/CT/EXT/DC/rv16_or} \
{/sim_core_top/CT/EXT/DC/rv16_rd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_rd_x0} \
{/sim_core_top/CT/EXT/DC/rv16_rd_x2} \
{/sim_core_top/CT/EXT/DC/rv16_rdd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_rden} \
{/sim_core_top/CT/EXT/DC/rv16_rdidx\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_rs1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_rs1_x0} \
{/sim_core_top/CT/EXT/DC/rv16_rs1en} \
{/sim_core_top/CT/EXT/DC/rv16_rs1idx\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_rs2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_rs2_x0} \
{/sim_core_top/CT/EXT/DC/rv16_rs2en} \
{/sim_core_top/CT/EXT/DC/rv16_rs2idx\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_rss1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_rss2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv16_slli} \
{/sim_core_top/CT/EXT/DC/rv16_srai} \
{/sim_core_top/CT/EXT/DC/rv16_srli} \
{/sim_core_top/CT/EXT/DC/rv16_sub} \
{/sim_core_top/CT/EXT/DC/rv16_subxororand} \
{/sim_core_top/CT/EXT/DC/rv16_sw} \
{/sim_core_top/CT/EXT/DC/rv16_swsp} \
{/sim_core_top/CT/EXT/DC/rv16_sxxi_shamt_ilgl} \
{/sim_core_top/CT/EXT/DC/rv16_sxxi_shamt_legl} \
{/sim_core_top/CT/EXT/DC/rv16_xor} \
{/sim_core_top/CT/EXT/DC/rv32} \
{/sim_core_top/CT/EXT/DC/rv32_add} \
{/sim_core_top/CT/EXT/DC/rv32_addi} \
{/sim_core_top/CT/EXT/DC/rv32_all0s_ilgl} \
{/sim_core_top/CT/EXT/DC/rv32_all1s_ilgl} \
{/sim_core_top/CT/EXT/DC/rv32_amo} \
{/sim_core_top/CT/EXT/DC/rv32_amoadd_w} \
{/sim_core_top/CT/EXT/DC/rv32_amoand_w} \
{/sim_core_top/CT/EXT/DC/rv32_amomax_w} \
{/sim_core_top/CT/EXT/DC/rv32_amomaxu_w} \
{/sim_core_top/CT/EXT/DC/rv32_amomin_w} \
{/sim_core_top/CT/EXT/DC/rv32_amominu_w} \
{/sim_core_top/CT/EXT/DC/rv32_amoor_w} \
{/sim_core_top/CT/EXT/DC/rv32_amoswap_w} \
{/sim_core_top/CT/EXT/DC/rv32_amoxor_w} \
{/sim_core_top/CT/EXT/DC/rv32_and} \
{/sim_core_top/CT/EXT/DC/rv32_andi} \
{/sim_core_top/CT/EXT/DC/rv32_auipc} \
{/sim_core_top/CT/EXT/DC/rv32_b_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_beq} \
{/sim_core_top/CT/EXT/DC/rv32_bgt} \
{/sim_core_top/CT/EXT/DC/rv32_bgtu} \
{/sim_core_top/CT/EXT/DC/rv32_blt} \
{/sim_core_top/CT/EXT/DC/rv32_bltu} \
{/sim_core_top/CT/EXT/DC/rv32_bne} \
{/sim_core_top/CT/EXT/DC/rv32_branch} \
{/sim_core_top/CT/EXT/DC/rv32_bxx_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_csr} \
{/sim_core_top/CT/EXT/DC/rv32_csrrc} \
{/sim_core_top/CT/EXT/DC/rv32_csrrci} \
{/sim_core_top/CT/EXT/DC/rv32_csrrs} \
{/sim_core_top/CT/EXT/DC/rv32_csrrsi} \
{/sim_core_top/CT/EXT/DC/rv32_csrrw} \
{/sim_core_top/CT/EXT/DC/rv32_csrrwi} \
{/sim_core_top/CT/EXT/DC/rv32_div} \
{/sim_core_top/CT/EXT/DC/rv32_divu} \
{/sim_core_top/CT/EXT/DC/rv32_dret} \
{/sim_core_top/CT/EXT/DC/rv32_dret_ilgl} \
{/sim_core_top/CT/EXT/DC/rv32_ebreak} \
{/sim_core_top/CT/EXT/DC/rv32_ecall} \
{/sim_core_top/CT/EXT/DC/rv32_ecall_ebreak_ret_wfi} \
{/sim_core_top/CT/EXT/DC/rv32_fence} \
{/sim_core_top/CT/EXT/DC/rv32_fence_fencei} \
{/sim_core_top/CT/EXT/DC/rv32_fence_i} \
{/sim_core_top/CT/EXT/DC/rv32_func3\[2:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_func3_000} \
{/sim_core_top/CT/EXT/DC/rv32_func3_001} \
{/sim_core_top/CT/EXT/DC/rv32_func3_010} \
{/sim_core_top/CT/EXT/DC/rv32_func3_011} \
{/sim_core_top/CT/EXT/DC/rv32_func3_100} \
{/sim_core_top/CT/EXT/DC/rv32_func3_101} \
{/sim_core_top/CT/EXT/DC/rv32_func3_110} \
{/sim_core_top/CT/EXT/DC/rv32_func3_111} \
{/sim_core_top/CT/EXT/DC/rv32_func7\[6:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0000000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0000001} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0000100} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0000101} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0001000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0001001} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0001100} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0001101} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0010000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0010001} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0010100} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0010101} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0100000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0100001} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0101100} \
{/sim_core_top/CT/EXT/DC/rv32_func7_0101101} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1010000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1010001} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1100000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1100001} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1101000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1101001} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1110000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1110001} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1111000} \
{/sim_core_top/CT/EXT/DC/rv32_func7_1111111} \
{/sim_core_top/CT/EXT/DC/rv32_i_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_imm_sel_b} \
{/sim_core_top/CT/EXT/DC/rv32_imm_sel_bxx} \
{/sim_core_top/CT/EXT/DC/rv32_imm_sel_i} \
{/sim_core_top/CT/EXT/DC/rv32_imm_sel_j} \
{/sim_core_top/CT/EXT/DC/rv32_imm_sel_jal} \
{/sim_core_top/CT/EXT/DC/rv32_imm_sel_jalr} \
{/sim_core_top/CT/EXT/DC/rv32_imm_sel_s} \
{/sim_core_top/CT/EXT/DC/rv32_imm_sel_u} \
{/sim_core_top/CT/EXT/DC/rv32_instr\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_j_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_jal} \
{/sim_core_top/CT/EXT/DC/rv32_jal_imm} \
{/sim_core_top/CT/EXT/DC/rv32_jalr} \
{/sim_core_top/CT/EXT/DC/rv32_jalr_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_lb} \
{/sim_core_top/CT/EXT/DC/rv32_lbu} \
{/sim_core_top/CT/EXT/DC/rv32_lh} \
{/sim_core_top/CT/EXT/DC/rv32_lhu} \
{/sim_core_top/CT/EXT/DC/rv32_load} \
{/sim_core_top/CT/EXT/DC/rv32_lr_w} \
{/sim_core_top/CT/EXT/DC/rv32_lui} \
{/sim_core_top/CT/EXT/DC/rv32_lw} \
{/sim_core_top/CT/EXT/DC/rv32_miscmem} \
{/sim_core_top/CT/EXT/DC/rv32_mret} \
{/sim_core_top/CT/EXT/DC/rv32_mul} \
{/sim_core_top/CT/EXT/DC/rv32_mulh} \
{/sim_core_top/CT/EXT/DC/rv32_mulhsu} \
{/sim_core_top/CT/EXT/DC/rv32_mulhu} \
{/sim_core_top/CT/EXT/DC/rv32_need_imm} \
{/sim_core_top/CT/EXT/DC/rv32_need_rd} \
{/sim_core_top/CT/EXT/DC/rv32_need_rs1} \
{/sim_core_top/CT/EXT/DC/rv32_need_rs2} \
{/sim_core_top/CT/EXT/DC/rv32_nop} \
{/sim_core_top/CT/EXT/DC/rv32_op} \
{/sim_core_top/CT/EXT/DC/rv32_op_imm} \
{/sim_core_top/CT/EXT/DC/rv32_or} \
{/sim_core_top/CT/EXT/DC/rv32_ori} \
{/sim_core_top/CT/EXT/DC/rv32_rd\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_rd_x0} \
{/sim_core_top/CT/EXT/DC/rv32_rd_x2} \
{/sim_core_top/CT/EXT/DC/rv32_rd_x31} \
{/sim_core_top/CT/EXT/DC/rv32_rem} \
{/sim_core_top/CT/EXT/DC/rv32_remu} \
{/sim_core_top/CT/EXT/DC/rv32_rs1\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_rs1_x0} \
{/sim_core_top/CT/EXT/DC/rv32_rs1_x31} \
{/sim_core_top/CT/EXT/DC/rv32_rs2\[4:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_rs2_x0} \
{/sim_core_top/CT/EXT/DC/rv32_rs2_x1} \
{/sim_core_top/CT/EXT/DC/rv32_rs2_x31} \
{/sim_core_top/CT/EXT/DC/rv32_s_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_sb} \
{/sim_core_top/CT/EXT/DC/rv32_sc_w} \
{/sim_core_top/CT/EXT/DC/rv32_sh} \
{/sim_core_top/CT/EXT/DC/rv32_sll} \
{/sim_core_top/CT/EXT/DC/rv32_slli} \
{/sim_core_top/CT/EXT/DC/rv32_slt} \
{/sim_core_top/CT/EXT/DC/rv32_slti} \
{/sim_core_top/CT/EXT/DC/rv32_sltiu} \
{/sim_core_top/CT/EXT/DC/rv32_sltu} \
{/sim_core_top/CT/EXT/DC/rv32_sra} \
{/sim_core_top/CT/EXT/DC/rv32_srai} \
{/sim_core_top/CT/EXT/DC/rv32_srl} \
{/sim_core_top/CT/EXT/DC/rv32_srli} \
{/sim_core_top/CT/EXT/DC/rv32_store} \
{/sim_core_top/CT/EXT/DC/rv32_sub} \
{/sim_core_top/CT/EXT/DC/rv32_sw} \
{/sim_core_top/CT/EXT/DC/rv32_sxxi_shamt_ilgl} \
{/sim_core_top/CT/EXT/DC/rv32_sxxi_shamt_legl} \
{/sim_core_top/CT/EXT/DC/rv32_system} \
{/sim_core_top/CT/EXT/DC/rv32_u_imm\[31:0\]} \
{/sim_core_top/CT/EXT/DC/rv32_wfi} \
{/sim_core_top/CT/EXT/DC/rv32_xor} \
{/sim_core_top/CT/EXT/DC/rv32_xori} \
{/sim_core_top/CT/EXT/DC/rv_all0s1s_ilgl} \
{/sim_core_top/CT/EXT/MC/clk} \
{/sim_core_top/CT/EXT/MC/count\[5:0\]} \
{/sim_core_top/CT/EXT/MC/count_t\[5:0\]} \
{/sim_core_top/CT/EXT/MC/curr_state\[1:0\]} \
{/sim_core_top/CT/EXT/MC/integrated_ready} \
{/sim_core_top/CT/EXT/MC/mc_i_ifu_valid} \
{/sim_core_top/CT/EXT/MC/mc_i_pc_cycle\[5:0\]} \
{/sim_core_top/CT/EXT/MC/mc_o_delay_err} \
{/sim_core_top/CT/EXT/MC/mc_o_exu_ready} \
{/sim_core_top/CT/EXT/MC/memtop_enable} \
{/sim_core_top/CT/EXT/MC/memtop_ready} \
{/sim_core_top/CT/EXT/MC/rst_n} \
{/sim_core_top/CT/EXT/MEMT/clk} \
{/sim_core_top/CT/EXT/MEMT/lsu_o_wbck_err} \
{/sim_core_top/CT/EXT/MEMT/lsu_o_wbck_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/lsu_ram_addr\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/lsu_ram_cs} \
{/sim_core_top/CT/EXT/MEMT/lsu_ram_rd} \
{/sim_core_top/CT/EXT/MEMT/lsu_ram_valid} \
{/sim_core_top/CT/EXT/MEMT/lsu_ram_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/lsu_ram_wr} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_addr\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_enable} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_misalgn} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_read} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_size\[1:0\]} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_usign} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_wmask\[3:0\]} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_cmd_write} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_commit_trap} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_ita_rdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_ita_ready} \
{/sim_core_top/CT/EXT/MEMT/memtop_i_valid} \
{/sim_core_top/CT/EXT/MEMT/memtop_o_ita_addr\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/memtop_o_ita_rd} \
{/sim_core_top/CT/EXT/MEMT/memtop_o_ita_valid} \
{/sim_core_top/CT/EXT/MEMT/memtop_o_ita_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/memtop_o_ita_wr} \
{/sim_core_top/CT/EXT/MEMT/memtop_o_ready} \
{/sim_core_top/CT/EXT/MEMT/ram_lsu_rdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/ram_lsu_ready} \
{/sim_core_top/CT/EXT/MEMT/rst_n} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_addr\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_enable} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_misalgn} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_read} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_size\[1:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_usign} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_wmask\[3:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/agu_i_cmd_write} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/clk} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/ita_lsu_rdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/ita_lsu_ready} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/ls_nxt_state\[1:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/ls_state\[1:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_expend_wmask\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_i_commit_trap} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_i_valid} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ita_addr\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ita_enable} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ita_rd} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ita_valid} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ita_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ita_wr} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_o_ready} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_o_wbck_err} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_o_wbck_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ram_addr\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ram_rd} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ram_valid} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ram_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_ram_wr} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_wbck_ita_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_wbck_ram_wdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/mem_ready} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/ram_lsu_rdata\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/ram_lsu_ready} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_higher_8} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_higher_16} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_highest_8} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_lower_8} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_lower_16} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_lowest_8} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_size_b} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_size_hw} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rdata_size_w} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/rst_n} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/shift_enable} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_dff/clk} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_dff/dnxt\[1:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_dff/lden} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_dff/qout\[1:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_dff/qout_r\[1:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_lsu/lsu_dff/rst_n} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/DB_r\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/DB_w\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/address\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/clk} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/cs} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/mem_count\[1:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/rd} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/rd_data_t0\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/rd_data_t1\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/rd_data_t2\[31:0\]} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/ready} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/valid} \
{/sim_core_top/CT/EXT/MEMT/exu_ram_unit/wr} \
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
{/sim_core_top/CT/EXT/WBCK/alu_wbck_i_ready} \
{/sim_core_top/CT/EXT/WBCK/alu_wbck_i_valid} \
{/sim_core_top/CT/EXT/WBCK/cmt_wbck_irqexcp} \
{/sim_core_top/CT/EXT/WBCK/wbck_i_rdidx\[4:0\]} \
{/sim_core_top/CT/EXT/WBCK/wbck_i_rdidx_req\[4:0\]} \
{/sim_core_top/CT/EXT/WBCK/wbck_i_wdat\[31:0\]} \
{/sim_core_top/CT/EXT/WBCK/wbck_i_wdat_req\[31:0\]} \
{/sim_core_top/CT/EXT/WBCK/wbck_o_rf_ena} \
{/sim_core_top/CT/EXT/WBCK/wbck_o_rf_rdidx\[4:0\]} \
{/sim_core_top/CT/EXT/WBCK/wbck_o_rf_wdat\[31:0\]} \
{/sim_core_top/CT/EXT/WBCK/wbck_ready4alu} \
{/sim_core_top/CT/IFT/clk} \
{/sim_core_top/CT/IFT/exu_ifu_i_pipe_flush_req} \
{/sim_core_top/CT/IFT/ifu_flash_enable} \
{/sim_core_top/CT/IFT/ifu_flash_pc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_bjp_flush_pc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_bjp_flush_req} \
{/sim_core_top/CT/IFT/ifu_i_excp} \
{/sim_core_top/CT/IFT/ifu_i_exu_ready} \
{/sim_core_top/CT/IFT/ifu_i_int_pending_flag} \
{/sim_core_top/CT/IFT/ifu_i_irq_req} \
{/sim_core_top/CT/IFT/ifu_i_mtvec\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_rv32} \
{/sim_core_top/CT/IFT/ifu_ir_r\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_o_ifu_valid} \
{/sim_core_top/CT/IFT/ifu_o_wbck_epc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_pc_first_instr} \
{/sim_core_top/CT/IFT/ifu_pc_init_use} \
{/sim_core_top/CT/IFT/ifu_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_pc_r\[31:0\]} \
{/sim_core_top/CT/IFT/itcm_ifu_ir\[31:0\]} \
{/sim_core_top/CT/IFT/pc_ifu_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/rst_n} \
{/sim_core_top/CT/IFT/IFU/ac_pipe_flush_req} \
{/sim_core_top/CT/IFT/IFU/ac_pipe_flush_req_nxt} \
{/sim_core_top/CT/IFT/IFU/ac_pipe_flush_req_raw} \
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
{/sim_core_top/CT/IFT/IFU/ifu_o_pc_first_instr} \
{/sim_core_top/CT/IFT/IFU/ifu_o_pc_init_use} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_first_instr_raw} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_flash\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_init_use_r} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_nxt_align} \
{/sim_core_top/CT/IFT/IFU/ifu_valid} \
{/sim_core_top/CT/IFT/IFU/itcm_ifu_i_ir\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/pc_ifu_i_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/rst_n} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_flush\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_r\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/clk} \
{/sim_core_top/CT/IFT/PC_CONTROL/need_flush} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_bjp_req_flush} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_bjp_req_fulsh_pc\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_excp} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_exu_ready} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_first_instr} \
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
{/sim_core_top/CT/IFT/itcm/clk} \
{/sim_core_top/CT/IFT/itcm/data_out\[31:0\]} \
{/sim_core_top/CT/IFT/itcm/flash_i_ifu_enable} \
{/sim_core_top/CT/IFT/itcm/pa\[31:0\]} \
{/sim_core_top/CT/IFT/itcm/pa_true\[31:0\]} \
{/sim_core_top/CT/IFT/itcm/pdataout\[31:0\]} \
{/sim_core_top/CT/ita/add_op1\[63:0\]} \
{/sim_core_top/CT/ita/add_op2\[63:0\]} \
{/sim_core_top/CT/ita/add_res\[64:0\]} \
{/sim_core_top/CT/ita/clk} \
{/sim_core_top/CT/ita/clk_mtime} \
{/sim_core_top/CT/ita/extirq_pending_flag} \
{/sim_core_top/CT/ita/ita_csr_meip} \
{/sim_core_top/CT/ita/ita_csr_msip} \
{/sim_core_top/CT/ita/ita_csr_mtip} \
{/sim_core_top/CT/ita/ita_ext_flag_set} \
{/sim_core_top/CT/ita/ita_ext_int} \
{/sim_core_top/CT/ita/ita_ext_int_raw} \
{/sim_core_top/CT/ita/ita_i_bjp_req_flush} \
{/sim_core_top/CT/ita/ita_i_external_int} \
{/sim_core_top/CT/ita/ita_i_exu_addr\[31:0\]} \
{/sim_core_top/CT/ita/ita_i_exu_rd} \
{/sim_core_top/CT/ita/ita_i_exu_valid} \
{/sim_core_top/CT/ita/ita_i_exu_wdata\[31:0\]} \
{/sim_core_top/CT/ita/ita_i_exu_wr} \
{/sim_core_top/CT/ita/ita_msip} \
{/sim_core_top/CT/ita/ita_o_exu_rdata\[31:0\]} \
{/sim_core_top/CT/ita/ita_o_exu_ready} \
{/sim_core_top/CT/ita/ita_o_int_pending_flag} \
{/sim_core_top/CT/ita/ita_sft_int} \
{/sim_core_top/CT/ita/ita_tmr_int} \
{/sim_core_top/CT/ita/ita_tmr_int_raw} \
{/sim_core_top/CT/ita/msip_ren} \
{/sim_core_top/CT/ita/msip_wen} \
{/sim_core_top/CT/ita/mtime\[31:0\]} \
{/sim_core_top/CT/ita/mtime_ren} \
{/sim_core_top/CT/ita/mtime_wen} \
{/sim_core_top/CT/ita/mtimecmp\[31:0\]} \
{/sim_core_top/CT/ita/mtimecmp_ren} \
{/sim_core_top/CT/ita/mtimecmp_wen} \
{/sim_core_top/CT/ita/mtimecmph\[31:0\]} \
{/sim_core_top/CT/ita/mtimecmph_ren} \
{/sim_core_top/CT/ita/mtimecmph_wen} \
{/sim_core_top/CT/ita/mtimeh\[31:0\]} \
{/sim_core_top/CT/ita/mtimeh_ren} \
{/sim_core_top/CT/ita/mtimeh_wen} \
{/sim_core_top/CT/ita/rcode\[4:0\]} \
{/sim_core_top/CT/ita/rdata\[31:0\]} \
{/sim_core_top/CT/ita/rst_n} \
{/sim_core_top/CT/ita/sel_msip} \
{/sim_core_top/CT/ita/sel_mtime} \
{/sim_core_top/CT/ita/sel_mtimecmp} \
{/sim_core_top/CT/ita/sel_mtimecmph} \
{/sim_core_top/CT/ita/sel_mtimeh} \
{/sim_core_top/CT/ita/tmr_int} \
{/sim_core_top/CT/ita/width_count} \
{/sim_core_top/CT/ita/chain2/clk} \
{/sim_core_top/CT/ita/chain2/rst_n} \
{/sim_core_top/CT/ita/chain2/sig_dff1} \
{/sim_core_top/CT/ita/chain2/sig_dff2} \
{/sim_core_top/CT/ita/chain2/sig_in} \
{/sim_core_top/CT/ita/chain2/sig_out} \
{/sim_core_top/CT/ita/chain3/clk_source} \
{/sim_core_top/CT/ita/chain3/clk_target} \
{/sim_core_top/CT/ita/chain3/rst_n} \
{/sim_core_top/CT/ita/chain3/sig_dff1} \
{/sim_core_top/CT/ita/chain3/sig_dff2} \
{/sim_core_top/CT/ita/chain3/sig_dff3} \
{/sim_core_top/CT/ita/chain3/sig_in} \
{/sim_core_top/CT/ita/chain3/sig_out} \
{/sim_core_top/CT/rsu/buff1} \
{/sim_core_top/CT/rsu/buff2} \
{/sim_core_top/CT/rsu/clk} \
{/sim_core_top/CT/rsu/rst_n} \
{/sim_core_top/CT/rsu/rst_n_syn} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 \
           18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 \
           40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 \
           62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 \
           84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 \
           105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 \
           122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 \
           139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 \
           156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 \
           173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 \
           190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 \
           207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 \
           224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 \
           241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 \
           258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 \
           275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 \
           292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 \
           309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 \
           326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 \
           343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 \
           360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 \
           377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 \
           394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 \
           411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 \
           428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 \
           445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 \
           462 463 464 465 466 467 468 469 470 471 472 473 474 475 476 477 478 \
           479 480 481 482 483 484 485 486 487 488 489 490 491 492 493 494 495 \
           496 497 498 499 500 501 502 503 504 505 506 507 508 509 510 511 512 \
           513 514 515 516 517 518 519 520 521 522 523 524 525 526 527 528 529 \
           530 531 532 533 534 535 536 537 538 539 540 541 542 543 544 545 546 \
           547 548 549 550 551 552 553 554 555 556 557 558 559 560 561 562 563 \
           564 565 566 567 568 569 570 571 572 573 574 575 576 577 578 579 580 \
           581 582 583 584 585 586 587 588 589 590 591 592 593 594 595 596 597 \
           598 599 600 601 602 603 604 605 606 607 608 609 610 611 612 613 614 \
           615 616 617 618 619 620 621 622 623 624 625 626 627 628 629 630 631 \
           632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 \
           649 650 651 652 653 654 655 656 657 658 659 660 661 662 663 664 665 \
           666 667 668 669 670 671 672 673 674 675 676 677 678 679 680 681 682 \
           683 684 685 686 687 688 689 690 691 692 693 694 695 696 697 698 699 \
           700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 \
           717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 \
           734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 \
           751 752 753 754 755 756 757 758 759 760 761 762 763 764 765 766 767 \
           768 769 770 771 772 773 774 775 776 777 778 779 780 781 782 783 784 \
           785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 800 801 \
           802 803 804 805 806 807 808 809 810 811 812 813 814 815 816 817 818 \
           819 820 821 822 823 824 825 826 827 828 829 830 831 832 833 834 835 \
           836 837 838 839 840 841 842 843 844 845 846 847 848 849 850 851 852 \
           853 854 855 856 857 858 859 860 861 862 863 864 865 866 867 868 869 \
           870 871 872 873 874 875 876 877 878 879 880 881 882 883 884 885 886 \
           887 888 889 890 891 892 893 894 895 896 897 898 899 900 901 902 903 \
           904 905 906 907 908 909 910 911 912 913 914 915 916 917 918 919 920 \
           921 922 923 924 925 926 927 928 929 930 931 932 933 934 935 936 937 \
           938 939 940 941 942 943 944 945 946 947 948 949 950 951 952 953 954 \
           955 956 957 958 959 960 961 962 963 964 965 966 967 968 969 970 971 \
           972 973 974 975 976 977 978 979 980 981 982 983 984 985 986 987 988 \
           989 990 991 992 993 994 995 996 997 998 999 1000 1001 1002 1003 1004 \
           1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1016 1017 1018 \
           1019 1020 1021 1022 1023 1024 1025 1026 1027 1028 1029 1030 1031 1032 \
           1033 1034 1035 1036 1037 1038 1039 1040 1041 1042 1043 1044 1045 1046 \
           1047 1048 1049 1050 1051 1052 1053 1054 1055 1056 1057 1058 1059 1060 \
           1061 1062 1063 1064 1065 1066 1067 1068 1069 1070 1071 1072 1073 1074 \
           1075 1076 1077 1078 1079 1080 1081 1082 1083 1084 1085 1086 1087 1088 \
           1089 1090 1091 1092 1093 1094 1095 1096 1097 1098 1099 1100 1101 1102 \
           1103 1104 1105 1106 1107 1108 1109 1110 1111 1112 1113 1114 1115 1116 \
           1117 1118 1119 1120 1121 1122 1123 1124 1125 1126 1127 1128 1129 1130 \
           1131 1132 1133 1134 1135 1136 1137 1138 1139 1140 1141 1142 1143 1144 \
           1145 1146 1147 1148 1149 1150 1151 1152 1153 1154 1155 1156 1157 1158 \
           1159 1160 1161 1162 1163 1164 1165 1166 1167 1168 1169 1170 1171 1172 \
           1173 1174 1175 1176 1177 1178 1179 1180 1181 1182 1183 1184 1185 1186 \
           1187 1188 1189 1190 1191 1192 1193 1194 1195 1196 1197 1198 1199 1200 \
           1201 1202 1203 1204 1205 1206 1207 1208 1209 1210 1211 1212 1213 1214 \
           1215 1216 1217 1218 1219 1220 1221 1222 1223 1224 1225 1226 1227 1228 \
           1229 1230 1231 1232 1233 1234 1235 1236 1237 1238 1239 1240 1241 1242 \
           1243 1244 1245 1246 1247 1248 1249 1250 1251 1252 1253 1254 1255 1256 \
           1257 1258 1259 1260 1261 1262 1263 1264 1265 1266 1267 1268 1269 1270 \
           1271 1272 1273 1274 1275 1276 1277 1278 1279 1280 1281 1282 1283 1284 \
           1285 1286 1287 1288 1289 1290 1291 1292 1293 1294 1295 1296 1297 1298 \
           1299 1300 1301 1302 1303 1304 1305 1306 1307 1308 1309 1310 1311 1312 \
           1313 1314 1315 1316 1317 1318 1319 1320 1321 1322 1323 1324 1325 1326 \
           1327 1328 1329 1330 1331 1332 1333 1334 1335 1336 1337 1338 1339 1340 \
           1341 1342 1343 1344 1345 1346 1347 1348 1349 1350 1351 1352 1353 1354 \
           1355 1356 1357 1358 1359 1360 1361 1362 1363 1364 1365 1366 1367 1368 \
           1369 1370 1371 1372 1373 1374 1375 1376 1377 1378 1379 1380 1381 1382 \
           1383 1384 1385 1386 1387 1388 1389 1390 1391 1392 1393 1394 1395 1396 \
           1397 1398 1399 1400 1401 1402 1403 1404 1405 1406 1407 1408 1409 1410 \
           1411 1412 1413 1414 1415 1416 1417 1418 1419 1420 1421 1422 1423 1424 \
           1425 1426 1427 1428 1429 1430 1431 1432 1433 1434 1435 1436 1437 1438 \
           1439 1440 1441 1442 1443 1444 1445 1446 1447 1448 1449 1450 1451 1452 \
           1453 1454 1455 1456 1457 1458 1459 1460 1461 1462 1463 1464 1465 1466 \
           1467 1468 1469 1470 1471 1472 1473 1474 1475 1476 1477 1478 1479 1480 \
           1481 1482 1483 1484 1485 1486 1487 1488 1489 1490 1491 1492 1493 1494 \
           1495 1496 1497 1498 1499 1500 1501 1502 1503 1504 1505 1506 1507 1508 \
           1509 1510 1511 1512 1513 1514 1515 1516 1517 1518 1519 1520 1521 1522 \
           1523 1524 1525 1526 1527 1528 1529 1530 1531 1532 1533 1534 1535 1536 \
           1537 1538 1539 1540 1541 1542 1543 1544 1545 1546 1547 1548 1549 1550 \
           1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 \
           1565 1566 1567 1568 1569 1570 1571 1572 1573 1574 1575 1576 1577 1578 \
           1579 1580 1581 1582 1583 1584 1585 1586 1587 1588 1589 1590 1591 1592 \
           1593 1594 1595 1596 1597 1598 1599 1600 1601 1602 1603 1604 1605 1606 \
           1607 1608 1609 1610 1611 1612 1613 1614 1615 1616 1617 1618 1619 1620 \
           1621 1622 1623 1624 1625 1626 1627 1628 1629 1630 1631 1632 1633 1634 \
           1635 1636 1637 1638 1639 1640 1641 1642 1643 1644 1645 1646 1647 1648 \
           1649 1650 1651 1652 1653 1654 1655 1656 1657 1658 1659 1660 1661 1662 \
           1663 1664 1665 1666 1667 1668 1669 1670 1671 1672 1673 1674 1675 1676 \
           1677 1678 1679 1680 1681 1682 1683 1684 1685 1686 1687 1688 1689 1690 \
           1691 1692 1693 1694 1695 1696 1697 1698 1699 1700 1701 1702 1703 1704 \
           1705 1706 1707 1708 1709 1710 1711 1712 1713 1714 1715 1716 1717 1718 \
           1719 1720 1721 1722 1723 1724 1725 1726 1727 1728 1729 1730 1731 1732 \
           1733 1734 1735 1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746 \
           1747 1748 1749 1750 1751 1752 1753 1754 1755 1756 1757 1758 1759 )} \
           
wvSetPosition -win $_nWave2 {("G1" 1759)}
wvGetSignalClose -win $_nWave2
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
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
wvSelectSignal -win $_nWave2 {( "G1" 1740 )} 
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
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
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
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
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
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 14
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 11
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 10
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 27
wvScrollUp -win $_nWave2 16
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 11
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 10
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 13
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 13
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 13
wvScrollUp -win $_nWave2 6
wvScrollUp -win $_nWave2 16
wvScrollUp -win $_nWave2 16
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 11
wvScrollUp -win $_nWave2 16
wvScrollUp -win $_nWave2 16
wvScrollUp -win $_nWave2 14
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 14
wvScrollUp -win $_nWave2 11
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 11
wvScrollUp -win $_nWave2 3
wvScrollUp -win $_nWave2 13
wvScrollUp -win $_nWave2 11
wvScrollUp -win $_nWave2 16
wvScrollUp -win $_nWave2 38
wvScrollUp -win $_nWave2 5
wvScrollUp -win $_nWave2 13
wvScrollUp -win $_nWave2 38
wvScrollUp -win $_nWave2 51
wvScrollUp -win $_nWave2 19
wvScrollUp -win $_nWave2 121
wvScrollUp -win $_nWave2 32
wvScrollUp -win $_nWave2 83
wvScrollUp -win $_nWave2 51
wvScrollUp -win $_nWave2 70
wvScrollUp -win $_nWave2 46
wvScrollUp -win $_nWave2 45
wvScrollUp -win $_nWave2 60
wvScrollUp -win $_nWave2 88
wvScrollUp -win $_nWave2 30
wvScrollUp -win $_nWave2 80
wvScrollUp -win $_nWave2 19
wvScrollUp -win $_nWave2 70
wvScrollUp -win $_nWave2 19
wvScrollUp -win $_nWave2 37
wvScrollUp -win $_nWave2 19
wvScrollUp -win $_nWave2 30
wvScrollUp -win $_nWave2 19
wvScrollUp -win $_nWave2 2
wvScrollUp -win $_nWave2 14
wvScrollUp -win $_nWave2 13
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 8
wvScrollUp -win $_nWave2 14
wvScrollUp -win $_nWave2 8
wvSelectSignal -win $_nWave2 {( "G1" 22 )} 
wvSelectSignal -win $_nWave2 {( "G1" 23 )} 
wvSelectSignal -win $_nWave2 {( "G1" 5 )} 
wvSelectSignal -win $_nWave2 {( "G1" 6 )} 
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
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvSelectSignal -win $_nWave2 {( "G1" 72 )} 
wvClearAll -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/excp_dbg"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top"
wvGetSignalSetScope -win $_nWave2 "/sim_core_top/CT/IFT"
wvSetPosition -win $_nWave2 {("G1" 85)}
wvSetPosition -win $_nWave2 {("G1" 85)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/sim_core_top/CT/IFT/clk} \
{/sim_core_top/CT/IFT/exu_ifu_i_pipe_flush_req} \
{/sim_core_top/CT/IFT/ifu_flash_enable} \
{/sim_core_top/CT/IFT/ifu_flash_pc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_bjp_flush_pc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_bjp_flush_req} \
{/sim_core_top/CT/IFT/ifu_i_excp} \
{/sim_core_top/CT/IFT/ifu_i_exu_ready} \
{/sim_core_top/CT/IFT/ifu_i_int_pending_flag} \
{/sim_core_top/CT/IFT/ifu_i_irq_req} \
{/sim_core_top/CT/IFT/ifu_i_mtvec\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_i_rv32} \
{/sim_core_top/CT/IFT/ifu_ir_r\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_o_ifu_valid} \
{/sim_core_top/CT/IFT/ifu_o_wbck_epc\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_pc_first_instr} \
{/sim_core_top/CT/IFT/ifu_pc_init_use} \
{/sim_core_top/CT/IFT/ifu_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/ifu_pc_r\[31:0\]} \
{/sim_core_top/CT/IFT/itcm_ifu_ir\[31:0\]} \
{/sim_core_top/CT/IFT/pc_ifu_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/rst_n} \
{/sim_core_top/CT/IFT/IFU/ac_pipe_flush_req} \
{/sim_core_top/CT/IFT/IFU/ac_pipe_flush_req_nxt} \
{/sim_core_top/CT/IFT/IFU/ac_pipe_flush_req_raw} \
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
{/sim_core_top/CT/IFT/IFU/ifu_o_pc_first_instr} \
{/sim_core_top/CT/IFT/IFU/ifu_o_pc_init_use} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_first_instr_raw} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_flash\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_init_use_r} \
{/sim_core_top/CT/IFT/IFU/ifu_pc_nxt_align} \
{/sim_core_top/CT/IFT/IFU/ifu_valid} \
{/sim_core_top/CT/IFT/IFU/itcm_ifu_i_ir\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/pc_ifu_i_pc_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/IFU/rst_n} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_flush\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_nxt\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/PC_r\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/clk} \
{/sim_core_top/CT/IFT/PC_CONTROL/need_flush} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_bjp_req_flush} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_bjp_req_fulsh_pc\[31:0\]} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_excp} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_exu_ready} \
{/sim_core_top/CT/IFT/PC_CONTROL/pc_i_first_instr} \
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
{/sim_core_top/CT/IFT/itcm/clk} \
{/sim_core_top/CT/IFT/itcm/data_out\[31:0\]} \
{/sim_core_top/CT/IFT/itcm/flash_i_ifu_enable} \
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
           84 85 )} 
wvSetPosition -win $_nWave2 {("G1" 85)}
wvGetSignalClose -win $_nWave2
wvZoomAll -win $_nWave2
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
verdiWindowResize -win $_Verdi_1 -1 "27" "853" "572"
verdiWindowResize -win $_Verdi_1 -605 "1058" "1919" "1678"
debExit
