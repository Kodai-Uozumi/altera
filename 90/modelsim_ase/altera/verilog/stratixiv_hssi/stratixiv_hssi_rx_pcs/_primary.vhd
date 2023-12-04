library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_rx_pcs is
    generic(
        lpm_type        : string  := "stratixiv_hssi_rx_pcs";
        align_ordered_set_based: string  := "false";
        align_pattern   : string  := "0101111100";
        align_pattern_length: integer := 10;
        align_to_deskew_pattern_pos_disp_only: string  := "false";
        allow_align_polarity_inversion: string  := "false";
        allow_pipe_polarity_inversion: string  := "false";
        auto_spd_deassert_ph_fifo_rst_count: integer := 0;
        auto_spd_phystatus_notify_count: integer := 0;
        auto_spd_self_switch_enable: string  := "false";
        bit_slip_enable : string  := "false";
        byte_order_back_compat_enable: string  := "false";
        byte_order_double_data_mode_mask_enable: string  := "false";
        byte_order_invalid_code_or_run_disp_error: string  := "false";
        byte_order_mode : string  := "none";
        byte_order_pad_pattern: string  := "0101111100";
        byte_order_pattern: string  := "0101111100";
        byte_order_pld_ctrl_enable: string  := "false";
        cdrctrl_bypass_ppm_detector_cycle: integer := 0;
        cdrctrl_cid_mode_enable: string  := "false";
        cdrctrl_enable  : string  := "false";
        cdrctrl_mask_cycle: integer := 0;
        cdrctrl_min_lock_to_ref_cycle: integer := 0;
        cdrctrl_rxvalid_mask: string  := "false";
        channel_bonding : string  := "none";
        channel_number  : integer := 0;
        channel_width   : integer := 10;
        clk1_mux_select : string  := "recvd_clk";
        clk2_mux_select : string  := "recvd_clk";
        clk_pd_enable   : string  := "false";
        core_clock_0ppm : string  := "false";
        datapath_low_latency_mode: string  := "false";
        datapath_protocol: string  := "basic";
        dec_8b_10b_compatibility_mode: string  := "true";
        dec_8b_10b_mode : string  := "none";
        dec_8b_10b_polarity_inv_enable: string  := "false";
        deskew_pattern  : string  := "1100111100";
        disable_auto_idle_insertion: string  := "false";
        disable_running_disp_in_word_align: string  := "false";
        disallow_kchar_after_pattern_ordered_set: string  := "false";
        dprio_config_mode: integer := 0;
        elec_idle_eios_detect_priority_over_eidle_disable: string  := "false";
        elec_idle_gen1_sigdet_enable: string  := "false";
        elec_idle_infer_enable: string  := "false";
        elec_idle_k_detect: string  := "false";
        elec_idle_num_com_detect: integer := 0;
        enable_bit_reversal: string  := "false";
        enable_deep_align: string  := "false";
        enable_deep_align_byte_swap: string  := "false";
        enable_self_test_mode: string  := "false";
        enable_true_complement_match_in_word_align: string  := "true";
        error_from_wa_or_8b_10b_select: string  := "false";
        force_signal_detect_dig: string  := "false";
        hip_enable      : string  := "false";
        infiniband_invalid_code: integer := 0;
        insert_pad_on_underflow: string  := "false";
        iqp_bypass      : string  := "false";
        iqp_ph_fifo_xn_select: integer := 9999;
        logical_channel_address: integer := 0;
        migrated_from_prev_family: string  := "false";
        num_align_code_groups_in_ordered_set: integer := 1;
        num_align_cons_good_data: integer := 3;
        num_align_cons_pat: integer := 4;
        num_align_loss_sync_error: integer := 1;
        ph_fifo_disable : string  := "false";
        ph_fifo_low_latency_enable: string  := "false";
        ph_fifo_reg_mode: string  := "false";
        ph_fifo_reset_enable: string  := "false";
        ph_fifo_user_ctrl_enable: string  := "false";
        ph_fifo_xn_mapping0: string  := "none";
        ph_fifo_xn_mapping1: string  := "none";
        ph_fifo_xn_mapping2: string  := "none";
        ph_fifo_xn_select: integer := 9999;
        phystatus_delay : integer := 0;
        phystatus_reset_toggle: string  := "false";
        pipe_auto_speed_nego_enable: string  := "false";
        pipe_freq_scale_mode: string  := "Data width";
        pipe_hip_enable : string  := "false";
        pma_done_count  : integer := 53392;
        prbs_all_one_detect: string  := "false";
        prbs_cid_pattern: string  := "false";
        prbs_cid_pattern_length: integer := 0;
        protocol_hint   : string  := "basic";
        rate_match_almost_empty_threshold: integer := 11;
        rate_match_almost_full_threshold: integer := 13;
        rate_match_back_to_back: string  := "false";
        rate_match_delete_threshold: integer := 0;
        rate_match_empty_threshold: integer := 0;
        rate_match_fifo_mode: string  := "false";
        rate_match_full_threshold: integer := 0;
        rate_match_insert_threshold: integer := 0;
        rate_match_ordered_set_based: string  := "false";
        rate_match_pattern1: string  := "00000000000010111100";
        rate_match_pattern2: string  := "00000000000010111100";
        rate_match_pattern_size: integer := 10;
        rate_match_pipe_enable: string  := "false";
        rate_match_reset_enable: string  := "true";
        rate_match_skip_set_based: string  := "false";
        rate_match_start_threshold: integer := 0;
        rd_clk_mux_select: string  := "int_clk";
        recovered_clk_mux_select: string  := "recvd_clk";
        reset_clock_output_during_digital_reset: string  := "false";
        run_length      : integer := 200;
        run_length_enable: string  := "false";
        rx_detect_bypass: string  := "false";
        rx_phfifo_wait_cnt: integer := 0;
        rxstatus_error_report_mode: integer := 0;
        self_test_mode  : string  := "incremental";
        test_bus_sel    : integer := 0;
        use_alignment_state_machine: string  := "false";
        use_deserializer_double_data_mode: string  := "false";
        use_deskew_fifo : string  := "false";
        use_double_data_mode: string  := "false";
        use_parallel_loopback: string  := "false";
        use_rising_edge_triggered_pattern_align: string  := "false";
        enable_phfifo_bypass: string  := "false"
    );
    port(
        a1a2size        : in     vl_logic;
        alignstatus     : in     vl_logic;
        alignstatussync : in     vl_logic;
        autospdxnconfigsel: in     vl_logic_vector(2 downto 0);
        autospdxnspdchg : in     vl_logic_vector(2 downto 0);
        bitslip         : in     vl_logic;
        cdrctrllocktorefcl: in     vl_logic;
        coreclk         : in     vl_logic;
        datain          : in     vl_logic_vector(19 downto 0);
        digitalreset    : in     vl_logic;
        disablefifordin : in     vl_logic;
        disablefifowrin : in     vl_logic;
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic_vector(399 downto 0);
        elecidleinfersel: in     vl_logic_vector(2 downto 0);
        enabledeskew    : in     vl_logic;
        enabyteord      : in     vl_logic;
        enapatternalign : in     vl_logic;
        fifordin        : in     vl_logic;
        fiforesetrd     : in     vl_logic;
        grayelecidleinferselfromtx: in     vl_logic_vector(2 downto 0);
        hip8b10binvpolarity: in     vl_logic;
        hipelecidleinfersel: in     vl_logic_vector(2 downto 0);
        hippowerdown    : in     vl_logic_vector(1 downto 0);
        hiprateswitch   : in     vl_logic;
        invpol          : in     vl_logic;
        iqpautospdxnspgchg: in     vl_logic_vector(1 downto 0);
        iqpphfifoxnbytesel: in     vl_logic_vector(1 downto 0);
        iqpphfifoxnptrsreset: in     vl_logic_vector(1 downto 0);
        iqpphfifoxnrdenable: in     vl_logic_vector(1 downto 0);
        iqpphfifoxnwrclk: in     vl_logic_vector(1 downto 0);
        iqpphfifoxnwrenable: in     vl_logic_vector(1 downto 0);
        localrefclk     : in     vl_logic;
        masterclk       : in     vl_logic;
        parallelfdbk    : in     vl_logic_vector(19 downto 0);
        phfifordenable  : in     vl_logic;
        phfiforeset     : in     vl_logic;
        phfifowrdisable : in     vl_logic;
        phfifox4bytesel : in     vl_logic;
        phfifox4rdenable: in     vl_logic;
        phfifox4wrclk   : in     vl_logic;
        phfifox4wrenable: in     vl_logic;
        phfifox8bytesel : in     vl_logic;
        phfifox8rdenable: in     vl_logic;
        phfifox8wrclk   : in     vl_logic;
        phfifox8wrenable: in     vl_logic;
        phfifoxnbytesel : in     vl_logic_vector(2 downto 0);
        phfifoxnptrsreset: in     vl_logic_vector(2 downto 0);
        phfifoxnrdenable: in     vl_logic_vector(2 downto 0);
        phfifoxnwrclk   : in     vl_logic_vector(2 downto 0);
        phfifoxnwrenable: in     vl_logic_vector(2 downto 0);
        pipe8b10binvpolarity: in     vl_logic;
        pipeenrevparallellpbkfromtx: in     vl_logic;
        pipepowerdown   : in     vl_logic_vector(1 downto 0);
        pipepowerstate  : in     vl_logic_vector(3 downto 0);
        pmatestbusin    : in     vl_logic_vector(7 downto 0);
        powerdn         : in     vl_logic_vector(1 downto 0);
        ppmdetectdividedclk: in     vl_logic;
        ppmdetectrefclk : in     vl_logic;
        prbscidenable   : in     vl_logic;
        quadreset       : in     vl_logic;
        rateswitch      : in     vl_logic;
        rateswitchisdone: in     vl_logic;
        rateswitchxndone: in     vl_logic;
        recoveredclk    : in     vl_logic;
        refclk          : in     vl_logic;
        revbitorderwa   : in     vl_logic;
        revbyteorderwa  : in     vl_logic;
        rmfifordena     : in     vl_logic;
        rmfiforeset     : in     vl_logic;
        rmfifowrena     : in     vl_logic;
        rxdetectvalid   : in     vl_logic;
        rxelecidlerateswitch: in     vl_logic;
        rxfound         : in     vl_logic_vector(1 downto 0);
        signaldetected  : in     vl_logic;
        xauidelcondmet  : in     vl_logic;
        xauififoovr     : in     vl_logic;
        xauiinsertincomplete: in     vl_logic;
        xauilatencycomp : in     vl_logic;
        xgmctrlin       : in     vl_logic;
        xgmdatain       : in     vl_logic_vector(7 downto 0);
        a1a2sizeout     : out    vl_logic_vector(3 downto 0);
        a1detect        : out    vl_logic_vector(1 downto 0);
        a2detect        : out    vl_logic_vector(1 downto 0);
        adetectdeskew   : out    vl_logic;
        alignstatussyncout: out    vl_logic;
        autospdrateswitchout: out    vl_logic;
        autospdspdchgout: out    vl_logic;
        bistdone        : out    vl_logic;
        bisterr         : out    vl_logic;
        bitslipboundaryselectout: out    vl_logic_vector(4 downto 0);
        byteorderalignstatus: out    vl_logic;
        cdrctrlearlyeios: out    vl_logic;
        cdrctrllocktorefclkout: out    vl_logic;
        clkout          : out    vl_logic;
        coreclkout      : out    vl_logic;
        ctrldetect      : out    vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector(39 downto 0);
        dataoutfull     : out    vl_logic_vector(63 downto 0);
        digitaltestout  : out    vl_logic_vector(9 downto 0);
        disablefifordout: out    vl_logic;
        disablefifowrout: out    vl_logic;
        disperr         : out    vl_logic_vector(3 downto 0);
        dprioout        : out    vl_logic_vector(399 downto 0);
        errdetect       : out    vl_logic_vector(3 downto 0);
        fifordout       : out    vl_logic;
        hipdataout      : out    vl_logic_vector(8 downto 0);
        hipdatavalid    : out    vl_logic;
        hipelecidle     : out    vl_logic;
        hipphydonestatus: out    vl_logic;
        hipstatus       : out    vl_logic_vector(2 downto 0);
        iqpphfifobyteselout: out    vl_logic;
        iqpphfifoptrsresetout: out    vl_logic;
        iqpphfifordenableout: out    vl_logic;
        iqpphfifowrclkout: out    vl_logic;
        iqpphfifowrenableout: out    vl_logic;
        k1detect        : out    vl_logic_vector(1 downto 0);
        k2detect        : out    vl_logic_vector(1 downto 0);
        patterndetect   : out    vl_logic_vector(3 downto 0);
        phfifobyteselout: out    vl_logic;
        phfifobyteserdisableout: out    vl_logic;
        phfifooverflow  : out    vl_logic;
        phfifoptrsresetout: out    vl_logic;
        phfifordenableout: out    vl_logic;
        phfiforesetout  : out    vl_logic;
        phfifounderflow : out    vl_logic;
        phfifowrclkout  : out    vl_logic;
        phfifowrdisableout: out    vl_logic;
        phfifowrenableout: out    vl_logic;
        pipebufferstat  : out    vl_logic_vector(3 downto 0);
        pipedatavalid   : out    vl_logic;
        pipeelecidle    : out    vl_logic;
        pipephydonestatus: out    vl_logic;
        pipestatus      : out    vl_logic_vector(2 downto 0);
        pipestatetransdoneout: out    vl_logic;
        rateswitchout   : out    vl_logic;
        rdalign         : out    vl_logic;
        revparallelfdbkdata: out    vl_logic_vector(19 downto 0);
        rlv             : out    vl_logic;
        rmfifoalmostempty: out    vl_logic;
        rmfifoalmostfull: out    vl_logic;
        rmfifodatadeleted: out    vl_logic_vector(3 downto 0);
        rmfifodatainserted: out    vl_logic_vector(3 downto 0);
        rmfifoempty     : out    vl_logic;
        rmfifofull      : out    vl_logic;
        runningdisp     : out    vl_logic_vector(3 downto 0);
        signaldetect    : out    vl_logic;
        syncstatus      : out    vl_logic_vector(3 downto 0);
        syncstatusdeskew: out    vl_logic;
        xauidelcondmetout: out    vl_logic;
        xauififoovrout  : out    vl_logic;
        xauiinsertincompleteout: out    vl_logic;
        xauilatencycompout: out    vl_logic;
        xgmctrldet      : out    vl_logic;
        xgmdataout      : out    vl_logic_vector(7 downto 0);
        xgmdatavalid    : out    vl_logic;
        xgmrunningdisp  : out    vl_logic
    );
end stratixiv_hssi_rx_pcs;