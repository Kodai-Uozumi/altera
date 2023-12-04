library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_rx_digi is
    port(
        hard_reset      : in     vl_logic;
        rxpcs_rst       : in     vl_logic;
        rxpma_rst       : in     vl_logic;
        cmpfifourst     : in     vl_logic;
        phfifourst_rx   : in     vl_logic;
        scan_mode       : in     vl_logic;
        encdt           : in     vl_logic;
        a1a2_size       : in     vl_logic;
        bitslip         : in     vl_logic;
        rdenable_rmf    : in     vl_logic;
        wrenable_rmf    : in     vl_logic;
        pld_rx_clk      : in     vl_logic;
        soft_reset_rclk1: out    vl_logic;
        polinv_rx       : in     vl_logic;
        bitloc_rev_en   : in     vl_logic;
        byte_rev_en     : in     vl_logic;
        rcvd_clk_pma    : in     vl_logic;
        pudi            : in     vl_logic_vector(19 downto 0);
        sigdetni        : in     vl_logic;
        fifo_rst_rd_qd  : in     vl_logic;
        fifo_rst_rd_gp  : in     vl_logic;
        en_dskw_qd      : in     vl_logic;
        en_dskw_gp      : in     vl_logic;
        is_lane0        : in     vl_logic;
        align_status    : in     vl_logic;
        align_status_sync_0: in     vl_logic;
        align_status_sync_2: in     vl_logic;
        rx_data_rs      : in     vl_logic_vector(7 downto 0);
        rx_control_rs   : in     vl_logic;
        rcvd_clk0_pma   : in     vl_logic;
        fifo_rd_in_comp_0: in     vl_logic;
        fifo_rd_in_comp_2: in     vl_logic;
        txlp20b         : in     vl_logic_vector(19 downto 0);
        refclk_pma      : in     vl_logic;
        tx_pma_clk      : in     vl_logic;
        fref            : in     vl_logic;
        clklow          : in     vl_logic;
        bytordpld       : in     vl_logic;
        wrdisable_rx    : in     vl_logic;
        rdenable_rx     : in     vl_logic;
        pma_testbus     : in     vl_logic_vector(7 downto 0);
        encoder_testbus : in     vl_logic_vector(9 downto 0);
        tx_ctrl_testbus : in     vl_logic_vector(9 downto 0);
        phystatus_int   : in     vl_logic;
        rxvalid_int     : in     vl_logic;
        rxstatus_int    : in     vl_logic_vector(2 downto 0);
        powerdown       : in     vl_logic_vector(1 downto 0);
        fifo_rd_out_comp: out    vl_logic;
        rxd             : out    vl_logic_vector(63 downto 0);
        rev_loop_data   : out    vl_logic_vector(19 downto 0);
        rx_clk          : out    vl_logic;
        bisterr         : out    vl_logic;
        cg_comma        : out    vl_logic_vector(1 downto 0);
        clk_2_b         : out    vl_logic;
        rcvd_clk_pma_b  : out    vl_logic;
        sync_status     : out    vl_logic;
        align_status_sync: out    vl_logic;
        dec_data_valid  : out    vl_logic;
        dec_data        : out    vl_logic_vector(7 downto 0);
        dec_ctl         : out    vl_logic;
        running_disp    : out    vl_logic_vector(1 downto 0);
        selftest_done   : out    vl_logic;
        selftest_err    : out    vl_logic;
        err_data        : out    vl_logic_vector(15 downto 0);
        err_ctl         : out    vl_logic_vector(1 downto 0);
        prbs_done       : out    vl_logic;
        prbs_err_lt     : out    vl_logic;
        signal_detect_out: out    vl_logic;
        align_det_sync  : out    vl_logic;
        rd_align        : out    vl_logic;
        bistdone        : out    vl_logic;
        rlv             : out    vl_logic;
        rlv_lt          : out    vl_logic;
        almost_fl_rmf   : out    vl_logic;
        full_rmf        : out    vl_logic;
        almost_mt_rmf   : out    vl_logic;
        empty_rmf       : out    vl_logic;
        freq_lock       : out    vl_logic;
        full_rx         : out    vl_logic;
        empty_rx        : out    vl_logic;
        a1a2_k1k2_flag  : out    vl_logic_vector(3 downto 0);
        byteord_flag    : out    vl_logic;
        rx_pipe_clk     : out    vl_logic;
        chnl_test_bus_out: out    vl_logic_vector(9 downto 0);
        rx_pipe_soft_reset: out    vl_logic;
        phystatus       : out    vl_logic;
        rxvalid         : out    vl_logic;
        rxstatus        : out    vl_logic_vector(2 downto 0);
        pipe_data       : out    vl_logic_vector(63 downto 0);
        rskpsetbased    : in     vl_logic;
        rtruebac2bac    : in     vl_logic;
        rcmpfifourst    : in     vl_logic;
        rphfifourstrx   : in     vl_logic;
        rcomp_size      : in     vl_logic_vector(2 downto 0);
        rcomp_pat       : in     vl_logic_vector(39 downto 0);
        rrundisp        : in     vl_logic_vector(5 downto 0);
        rib_inv_cd      : in     vl_logic_vector(1 downto 0);
        rrlv_en         : in     vl_logic;
        rsync_sm_dis    : in     vl_logic;
        rautobtalg_dis  : in     vl_logic;
        rdis_rx_disp    : in     vl_logic;
        rmatchen        : in     vl_logic;
        rgenericfifo    : in     vl_logic;
        rendec_rx       : in     vl_logic;
        rdwidth_rx      : in     vl_logic;
        rlp20ben        : in     vl_logic;
        rrxfifo_dis     : in     vl_logic;
        rpmadwidth_rx   : in     vl_logic;
        rpma_doublewidth_rx: in     vl_logic;
        renumber        : in     vl_logic_vector(5 downto 0);
        rknumber        : in     vl_logic_vector(7 downto 0);
        renpolinv_rx    : in     vl_logic;
        rgnumber        : in     vl_logic_vector(7 downto 0);
        rclkcmpsqmd     : in     vl_logic;
        rclkcmpsq1p     : in     vl_logic_vector(19 downto 0);
        rclkcmpsq1n     : in     vl_logic_vector(19 downto 0);
        rclkcmp_pipe_en : in     vl_logic;
        rosnumber       : in     vl_logic_vector(1 downto 0);
        rosbased        : in     vl_logic;
        rkchar          : in     vl_logic;
        rcascaded_8b10b_en_rx: in     vl_logic;
        resync_badcg_en : in     vl_logic_vector(1 downto 0);
        rencdt_rising   : in     vl_logic;
        rcomp_pat_porn  : in     vl_logic;
        rprbsen_rx      : in     vl_logic;
        rprbs_clr_rslt_rx: in     vl_logic;
        rbisten_rx      : in     vl_logic;
        rbist_clr_rx    : in     vl_logic;
        rwa_6g_en       : in     vl_logic;
        rbytord_2sym_en : in     vl_logic;
        rbysync_polinv_en: in     vl_logic;
        rbytord_6g_mask_en: in     vl_logic;
        rbytord_s2gx    : in     vl_logic;
        rbitloc_rev_en  : in     vl_logic;
        rbyte_rev_en    : in     vl_logic;
        rbyteorden      : in     vl_logic_vector(1 downto 0);
        rbytordplden    : in     vl_logic;
        rphfifopldenrx  : in     vl_logic;
        rautoinsdis     : in     vl_logic;
        rppmsel         : in     vl_logic_vector(5 downto 0);
        rforce0_freqdet : in     vl_logic;
        rforce1_freqdet : in     vl_logic;
        rbytordpat      : in     vl_logic_vector(19 downto 0);
        rbytordpad      : in     vl_logic_vector(9 downto 0);
        rforce_sig_det_pcs: in     vl_logic;
        rfreerun_rx     : in     vl_logic;
        rrcvd_clk_sel   : in     vl_logic_vector(1 downto 0);
        rclk_1_sel      : in     vl_logic_vector(1 downto 0);
        rclk_2_sel      : in     vl_logic_vector(1 downto 0);
        rrx_rd_clk_sel  : in     vl_logic;
        rall_one_dect_only: in     vl_logic;
        rtest_bus_sel   : in     vl_logic_vector(3 downto 0);
        r8b10b_dec_ibm_en: in     vl_logic_vector(1 downto 0);
        rrxfifo_lowlatency_en: in     vl_logic;
        rppm_cnt_reset  : in     vl_logic;
        sel_gp_md       : in     vl_logic;
        rclkcmpinsertpad: in     vl_logic;
        rindv_rx        : in     vl_logic;
        dskwclksel      : in     vl_logic_vector(1 downto 0);
        rdskposdisp     : in     vl_logic;
        rdskchrp        : in     vl_logic_vector(9 downto 0);
        rendec_data_sel_rx: in     vl_logic;
        rprbs_sel       : in     vl_logic_vector(2 downto 0);
        rbist_sel       : in     vl_logic_vector(1 downto 0);
        rcxpat_chnl_en  : in     vl_logic_vector(1 downto 0);
        rstart_threshold: in     vl_logic_vector(2 downto 0);
        rins_threshold  : in     vl_logic_vector(4 downto 0);
        rdel_threshold  : in     vl_logic_vector(4 downto 0);
        rfull_threshold : in     vl_logic_vector(4 downto 0);
        rempty_threshold: in     vl_logic_vector(2 downto 0);
        rinvalid_code_err_only: in     vl_logic;
        rrx_pipe_enable : in     vl_logic;
        rrxpcsbypass_en : in     vl_logic;
        rfts_count      : in     vl_logic_vector(9 downto 0);
        rpcs_wrapback_en: in     vl_logic;
        rcid_pattern_rx : in     vl_logic;
        rcid_len_rx     : in     vl_logic_vector(7 downto 0);
        rauto_speed_ena : in     vl_logic;
        rphfifo_regmode_rx: in     vl_logic;
        rfreq_sel       : in     vl_logic;
        rate            : in     vl_logic;
        gen2ngen1       : in     vl_logic;
        gen2ngen1_bundle: in     vl_logic;
        speed_change    : out    vl_logic;
        rx_div2_sync_in_centrl: in     vl_logic;
        rx_div2_sync_in_quad_up: in     vl_logic;
        rx_div2_sync_in_quad_down: in     vl_logic;
        reset_pc_ptrs_in_centrl: in     vl_logic;
        reset_pc_ptrs_in_quad_up: in     vl_logic;
        reset_pc_ptrs_in_quad_down: in     vl_logic;
        wr_enable_in_centrl: in     vl_logic;
        wr_enable_in_quad_up: in     vl_logic;
        wr_enable_in_quad_down: in     vl_logic;
        rd_enable_in_centrl: in     vl_logic;
        rd_enable_in_quad_up: in     vl_logic;
        rd_enable_in_quad_down: in     vl_logic;
        rx_we_in_centrl : in     vl_logic;
        rx_we_in_quad_up: in     vl_logic;
        rx_we_in_quad_down: in     vl_logic;
        speed_change_in_centrl: in     vl_logic;
        rx_div2_sync_in_pipe_quad_up: in     vl_logic;
        rx_div2_sync_in_pipe_quad_down: in     vl_logic;
        reset_pc_ptrs_in_pipe_quad_up: in     vl_logic;
        reset_pc_ptrs_in_pipe_quad_down: in     vl_logic;
        wr_enable_in_pipe_quad_up: in     vl_logic;
        wr_enable_in_pipe_quad_down: in     vl_logic;
        rd_enable_in_pipe_quad_up: in     vl_logic;
        rd_enable_in_pipe_quad_down: in     vl_logic;
        rx_we_in_pipe_quad_up: in     vl_logic;
        rx_we_in_pipe_quad_down: in     vl_logic;
        speed_change_in_pipe_quad_up: in     vl_logic;
        speed_change_in_pipe_quad_down: in     vl_logic;
        config_sel_centrl: in     vl_logic;
        config_sel_quad_up: in     vl_logic;
        config_sel_quad_down: in     vl_logic;
        rmaster_rx      : in     vl_logic;
        rmaster_up_rx   : in     vl_logic;
        rpipeline_bypass_rx: in     vl_logic;
        rauto_deassert_pc_rst_cnt: in     vl_logic_vector(3 downto 0);
        rauto_pc_en_cnt : in     vl_logic_vector(4 downto 0);
        rself_sw_en_rx  : in     vl_logic;
        rx_div2_sync_out_pipe_up: out    vl_logic;
        rx_we_out_pipe_up: out    vl_logic;
        wr_enable_out_pipe_up: out    vl_logic;
        rd_enable_out_pipe_up: out    vl_logic;
        reset_pc_ptrs_out_pipe_up: out    vl_logic;
        speed_change_out_pipe_up: out    vl_logic;
        rx_div2_sync_out_pipe_down: out    vl_logic;
        rx_we_out_pipe_down: out    vl_logic;
        wr_enable_out_pipe_down: out    vl_logic;
        rd_enable_out_pipe_down: out    vl_logic;
        reset_pc_ptrs_out_pipe_down: out    vl_logic;
        speed_change_out_pipe_down: out    vl_logic;
        dis_pc_byte     : out    vl_logic;
        reset_pc_ptrs   : out    vl_logic;
        pcie_switch     : out    vl_logic;
        reidleinferenable: in     vl_logic;
        reidle_com_detect: in     vl_logic_vector(1 downto 0);
        eidleinfersel   : in     vl_logic_vector(2 downto 0);
        pipe_loopbk     : in     vl_logic;
        rxelecidle_int  : out    vl_logic;
        rpma_done_count : in     vl_logic_vector(17 downto 0);
        riei_eios_priority_dis: in     vl_logic;
        rgen1_sigdet_ena: in     vl_logic;
        rerr_flags_sel  : in     vl_logic;
        rrxpcsclkpwdn   : in     vl_logic;
        rcdr_ctrl_en    : in     vl_logic;
        rcid_en         : in     vl_logic;
        rrxvalid_mask   : in     vl_logic;
        rwait_count     : in     vl_logic_vector(7 downto 0);
        rmask_count     : in     vl_logic_vector(9 downto 0);
        pld_ltr         : in     vl_logic;
        early_eios      : out    vl_logic;
        ltr             : out    vl_logic;
        prbs_cid_en     : in     vl_logic;
        wa_boundary     : out    vl_logic_vector(4 downto 0);
        tx_div2_sync_out_pipe_up: in     vl_logic;
        fifo_select_out_pipe_up: in     vl_logic;
        tx_wr_enable_out_pipe_up: in     vl_logic;
        tx_rd_enable_out_pipe_up: in     vl_logic;
        tx_div2_sync_out_pipe_down: in     vl_logic;
        fifo_select_out_pipe_down: in     vl_logic;
        tx_wr_enable_out_pipe_down: in     vl_logic;
        tx_rd_enable_out_pipe_down: in     vl_logic;
        rwait_for_phfifo_cnt: in     vl_logic_vector(5 downto 0);
        rppm_post_eidle_del: in     vl_logic;
        rppm_gen1_2xcnt_en: in     vl_logic;
        cg_comp_rd_d_ch0: in     vl_logic;
        cg_comp_rd_d_ch1: in     vl_logic;
        cg_comp_rd_d_ch2: in     vl_logic;
        cg_comp_rd_d_ch3: in     vl_logic;
        cg_comp_wr_ch0  : in     vl_logic;
        cg_comp_wr_ch1  : in     vl_logic;
        cg_comp_wr_ch2  : in     vl_logic;
        cg_comp_wr_ch3  : in     vl_logic;
        cg_comp_rd_d_out: out    vl_logic;
        cg_comp_wr_out  : out    vl_logic;
        del_cond_met_0  : in     vl_logic;
        fifo_ovr_0      : in     vl_logic;
        latency_comp_0  : in     vl_logic;
        insert_incomplete_0: in     vl_logic;
        del_cond_met_out: out    vl_logic;
        fifo_ovr_out    : out    vl_logic;
        latency_comp_out: out    vl_logic;
        insert_incomplete_out: out    vl_logic;
        pcs_wrapback_in : in     vl_logic_vector(69 downto 0)
    );
end arriaii_hssi_rx_digi;
