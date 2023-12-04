library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pcie_hip is
    generic(
        lpm_type        : string  := "arriaii_hssi_pcie_hip";
        advanced_errors : string  := "false";
        allow_rx_valid_empty: string  := "false";
        bar0_64bit_mem_space: string  := "true";
        bar0_io_space   : string  := "false";
        bar0_prefetchable: string  := "true";
        bar0_size_mask  : integer := 32;
        bar1_64bit_mem_space: string  := "false";
        bar1_io_space   : string  := "false";
        bar1_prefetchable: string  := "false";
        bar1_size_mask  : integer := 4;
        bar2_64bit_mem_space: string  := "false";
        bar2_io_space   : string  := "false";
        bar2_prefetchable: string  := "false";
        bar2_size_mask  : integer := 4;
        bar3_64bit_mem_space: string  := "false";
        bar3_io_space   : string  := "false";
        bar3_prefetchable: string  := "false";
        bar3_size_mask  : integer := 4;
        bar4_64bit_mem_space: string  := "false";
        bar4_io_space   : string  := "false";
        bar4_prefetchable: string  := "false";
        bar4_size_mask  : integer := 4;
        bar5_64bit_mem_space: string  := "false";
        bar5_io_space   : string  := "false";
        bar5_prefetchable: string  := "false";
        bar5_size_mask  : integer := 4;
        bar_io_window_size: string  := "NONE";
        bar_prefetchable: integer := 0;
        base_address    : integer := 0;
        bridge_port_ssid_support: string  := "false";
        bridge_port_vga_enable: string  := "false";
        bypass_cdc      : string  := "false";
        bypass_tl       : string  := "false";
        class_code      : integer := 16711680;
        completion_timeout: string  := "ABCD";
        core_clk_divider: integer := 1;
        core_clk_source : string  := "PLL_FIXED_CLK";
        credit_buffer_allocation_aux: string  := "BALANCED";
        deemphasis_enable: string  := "false";
        device_address  : integer := 0;
        device_id       : integer := 1;
        device_number   : integer := 0;
        diffclock_nfts_count: integer := 128;
        disable_async_l2_logic: string  := "false";
        disable_cdc_clk_ppm: string  := "true";
        disable_link_x2_support: string  := "false";
        disable_snoop_packet: integer := 0;
        dll_active_report_support: string  := "false";
        ei_delay_powerdown_count: integer := 10;
        eie_before_nfts_count: integer := 4;
        enable_adapter_half_rate_mode: string  := "false";
        enable_ch0_pclk_out: string  := "false";
        enable_completion_timeout_disable: string  := "true";
        enable_coreclk_out_half_rate: string  := "false";
        enable_ecrc_check: string  := "false";
        enable_ecrc_gen : string  := "false";
        enable_function_msi_support: string  := "true";
        enable_function_msix_support: string  := "false";
        enable_gen2_core: string  := "true";
        enable_hip_x1_loopback: string  := "false";
        enable_l1_aspm  : string  := "false";
        enable_msi_64bit_addressing: string  := "true";
        enable_msi_masking: string  := "false";
        enable_rcv0buf_a_we: string  := "true";
        enable_rcv0buf_b_re: string  := "true";
        enable_rcv0buf_output_regs: string  := "false";
        enable_rcv1buf_a_we: string  := "true";
        enable_rcv1buf_b_re: string  := "true";
        enable_rcv1buf_output_regs: string  := "false";
        enable_retrybuf_a_we: string  := "true";
        enable_retrybuf_b_re: string  := "true";
        enable_retrybuf_ecc: string  := "false";
        enable_retrybuf_output_regs: string  := "false";
        enable_retrybuf_x8_clk_stealing: integer := 0;
        enable_rx0buf_ecc: string  := "false";
        enable_rx0buf_x8_clk_stealing: integer := 0;
        enable_rx1buf_ecc: string  := "false";
        enable_rx1buf_x8_clk_stealing: integer := 0;
        enable_rx_buffer_checking: string  := "false";
        enable_rx_ei_l0s_exit_refined: string  := "false";
        enable_rx_reordering: string  := "true";
        enable_slot_register: string  := "false";
        endpoint_l0_latency: integer := 0;
        endpoint_l1_latency: integer := 0;
        expansion_base_address_register: integer := 0;
        extend_tag_field: string  := "false";
        fc_init_timer   : integer := 1024;
        flow_control_timeout_count: integer := 200;
        flow_control_update_count: integer := 30;
        gen2_diffclock_nfts_count: integer := 255;
        gen2_lane_rate_mode: string  := "false";
        gen2_sameclock_nfts_count: integer := 255;
        hot_plug_support: integer := 0;
        iei_logic       : string  := "IEI_IIIS";
        indicator       : integer := 7;
        l01_entry_latency: integer := 31;
        l0_exit_latency_diffclock: integer := 6;
        l0_exit_latency_sameclock: integer := 6;
        l1_exit_latency_diffclock: integer := 0;
        l1_exit_latency_sameclock: integer := 0;
        lane_mask       : integer := 240;
        low_priority_vc : integer := 0;
        max_link_width  : integer := 4;
        max_payload_size: integer := 2;
        maximum_current : integer := 0;
        migrated_from_prev_family: string  := "false";
        millisecond_cycle_count: integer := 0;
        mram_bist_settings: string  := "";
        msi_function_count: integer := 2;
        msix_pba_bir    : integer := 0;
        msix_pba_offset : integer := 0;
        msix_table_bir  : integer := 0;
        msix_table_offset: integer := 0;
        msix_table_size : integer := 0;
        no_command_completed: string  := "true";
        no_soft_reset   : string  := "false";
        pcie_mode       : string  := "SHARED_MODE";
        pme_state_enable: integer := 0;
        port_address    : integer := 0;
        port_link_number: integer := 1;
        register_pipe_signals: string  := "false";
        retry_buffer_last_active_address: integer := 2047;
        retry_buffer_memory_settings: integer := 0;
        revision_id     : integer := 1;
        rx0_adap_fifo_full_value: integer := 9;
        rx1_adap_fifo_full_value: integer := 9;
        rx_cdc_full_value: integer := 12;
        rx_idl_os_count : integer := 0;
        rx_ptr0_nonposted_dpram_max: integer := 0;
        rx_ptr0_nonposted_dpram_min: integer := 0;
        rx_ptr0_posted_dpram_max: integer := 0;
        rx_ptr0_posted_dpram_min: integer := 0;
        rx_ptr1_nonposted_dpram_max: integer := 0;
        rx_ptr1_nonposted_dpram_min: integer := 0;
        rx_ptr1_posted_dpram_max: integer := 0;
        rx_ptr1_posted_dpram_min: integer := 0;
        sameclock_nfts_count: integer := 128;
        single_rx_detect: integer := 0;
        skp_os_schedule_count: integer := 0;
        slot_number     : integer := 0;
        slot_power_limit: integer := 0;
        slot_power_scale: integer := 0;
        ssid            : integer := 0;
        ssvid           : integer := 0;
        subsystem_device_id: integer := 1;
        subsystem_vendor_id: integer := 4466;
        surprise_down_error_support: string  := "false";
        tx0_adap_fifo_full_value: integer := 11;
        tx1_adap_fifo_full_value: integer := 11;
        tx_cdc_full_value: integer := 12;
        tx_cdc_stop_dummy_full_value: integer := 11;
        use_crc_forwarding: string  := "false";
        vc0_clk_enable  : string  := "true";
        vc0_rx_buffer_memory_settings: integer := 0;
        vc0_rx_flow_ctrl_compl_data: integer := 448;
        vc0_rx_flow_ctrl_compl_header: integer := 112;
        vc0_rx_flow_ctrl_nonposted_data: integer := 0;
        vc0_rx_flow_ctrl_nonposted_header: integer := 54;
        vc0_rx_flow_ctrl_posted_data: integer := 360;
        vc0_rx_flow_ctrl_posted_header: integer := 50;
        vc1_clk_enable  : string  := "false";
        vc1_rx_buffer_memory_settings: integer := 0;
        vc1_rx_flow_ctrl_compl_data: integer := 448;
        vc1_rx_flow_ctrl_compl_header: integer := 112;
        vc1_rx_flow_ctrl_nonposted_data: integer := 0;
        vc1_rx_flow_ctrl_nonposted_header: integer := 54;
        vc1_rx_flow_ctrl_posted_data: integer := 360;
        vc1_rx_flow_ctrl_posted_header: integer := 50;
        vc_arbitration  : integer := 1;
        vc_enable       : integer := 0;
        vendor_id       : integer := 4466
    );
    port(
        bistenrcv0      : in     vl_logic;
        bistenrcv1      : in     vl_logic;
        bistenrpl       : in     vl_logic;
        bistscanen      : in     vl_logic;
        bistscanin      : in     vl_logic;
        bisttesten      : in     vl_logic;
        coreclkin       : in     vl_logic;
        corecrst        : in     vl_logic;
        corepor         : in     vl_logic;
        corerst         : in     vl_logic;
        coresrst        : in     vl_logic;
        cplerr          : in     vl_logic_vector(6 downto 0);
        cplpending      : in     vl_logic;
        dbgpipex1rx     : in     vl_logic_vector(14 downto 0);
        dlaspmcr0       : in     vl_logic;
        dlcomclkreg     : in     vl_logic;
        dlctrllink2     : in     vl_logic_vector(12 downto 0);
        dldataupfc      : in     vl_logic_vector(11 downto 0);
        dlhdrupfc       : in     vl_logic_vector(7 downto 0);
        dlinhdllp       : in     vl_logic;
        dlmaxploaddcr   : in     vl_logic_vector(2 downto 0);
        dlreqphycfg     : in     vl_logic_vector(3 downto 0);
        dlreqphypm      : in     vl_logic_vector(3 downto 0);
        dlrequpfc       : in     vl_logic;
        dlreqwake       : in     vl_logic;
        dlrxecrcchk     : in     vl_logic;
        dlsndupfc       : in     vl_logic;
        dltxcfgextsy    : in     vl_logic;
        dltxreqpm       : in     vl_logic;
        dltxtyppm       : in     vl_logic_vector(2 downto 0);
        dltypupfc       : in     vl_logic_vector(1 downto 0);
        dlvcctrl        : in     vl_logic_vector(7 downto 0);
        dlvcidmap       : in     vl_logic_vector(23 downto 0);
        dlvcidupfc      : in     vl_logic_vector(2 downto 0);
        dpclk           : in     vl_logic;
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic;
        dprioload       : in     vl_logic;
        lmiaddr         : in     vl_logic_vector(11 downto 0);
        lmidin          : in     vl_logic_vector(31 downto 0);
        lmirden         : in     vl_logic;
        lmiwren         : in     vl_logic;
        mode            : in     vl_logic_vector(1 downto 0);
        mramhiptestenable: in     vl_logic;
        mramregscanen   : in     vl_logic;
        mramregscanin   : in     vl_logic;
        pclkcentral     : in     vl_logic;
        pclkch0         : in     vl_logic;
        phyrst          : in     vl_logic;
        physrst         : in     vl_logic;
        phystatus       : in     vl_logic_vector(7 downto 0);
        pldclk          : in     vl_logic;
        pldrst          : in     vl_logic;
        pldsrst         : in     vl_logic;
        pllfixedclk     : in     vl_logic;
        rxdata          : in     vl_logic_vector(63 downto 0);
        rxdatak         : in     vl_logic_vector(7 downto 0);
        rxelecidle      : in     vl_logic_vector(7 downto 0);
        rxmaskvc0       : in     vl_logic;
        rxmaskvc1       : in     vl_logic;
        rxreadyvc0      : in     vl_logic;
        rxreadyvc1      : in     vl_logic;
        rxstatus        : in     vl_logic_vector(23 downto 0);
        rxvalid         : in     vl_logic_vector(7 downto 0);
        scanen          : in     vl_logic;
        scanmoden       : in     vl_logic;
        swdnin          : in     vl_logic_vector(2 downto 0);
        swupin          : in     vl_logic_vector(6 downto 0);
        testin          : in     vl_logic_vector(39 downto 0);
        tlaermsinum     : in     vl_logic_vector(4 downto 0);
        tlappintasts    : in     vl_logic;
        tlappmsinum     : in     vl_logic_vector(4 downto 0);
        tlappmsireq     : in     vl_logic;
        tlappmsitc      : in     vl_logic_vector(2 downto 0);
        tlhpgctrler     : in     vl_logic_vector(4 downto 0);
        tlpexmsinum     : in     vl_logic_vector(4 downto 0);
        tlpmauxpwr      : in     vl_logic;
        tlpmdata        : in     vl_logic_vector(9 downto 0);
        tlpmetocr       : in     vl_logic;
        tlpmevent       : in     vl_logic;
        tlslotclkcfg    : in     vl_logic;
        txdatavc00      : in     vl_logic_vector(63 downto 0);
        txdatavc01      : in     vl_logic_vector(63 downto 0);
        txdatavc10      : in     vl_logic_vector(63 downto 0);
        txdatavc11      : in     vl_logic_vector(63 downto 0);
        txeopvc00       : in     vl_logic;
        txeopvc01       : in     vl_logic;
        txeopvc10       : in     vl_logic;
        txeopvc11       : in     vl_logic;
        txerrvc0        : in     vl_logic;
        txerrvc1        : in     vl_logic;
        txsopvc00       : in     vl_logic;
        txsopvc01       : in     vl_logic;
        txsopvc10       : in     vl_logic;
        txsopvc11       : in     vl_logic;
        txvalidvc0      : in     vl_logic;
        txvalidvc1      : in     vl_logic;
        bistdonearcv0   : out    vl_logic;
        bistdonearcv1   : out    vl_logic;
        bistdonearpl    : out    vl_logic;
        bistdonebrcv0   : out    vl_logic;
        bistdonebrcv1   : out    vl_logic;
        bistdonebrpl    : out    vl_logic;
        bistpassrcv0    : out    vl_logic;
        bistpassrcv1    : out    vl_logic;
        bistpassrpl     : out    vl_logic;
        bistscanoutrcv0 : out    vl_logic;
        bistscanoutrcv1 : out    vl_logic;
        bistscanoutrpl  : out    vl_logic;
        clrrxpath       : out    vl_logic;
        coreclkout      : out    vl_logic;
        dataenablen     : out    vl_logic;
        derrcorextrcv0  : out    vl_logic;
        derrcorextrcv1  : out    vl_logic;
        derrcorextrpl   : out    vl_logic;
        derrrpl         : out    vl_logic;
        dlackphypm      : out    vl_logic_vector(1 downto 0);
        dlackrequpfc    : out    vl_logic;
        dlacksndupfc    : out    vl_logic;
        dlcurrentdeemp  : out    vl_logic;
        dlcurrentspeed  : out    vl_logic_vector(1 downto 0);
        dldllreq        : out    vl_logic;
        dlerrdll        : out    vl_logic_vector(4 downto 0);
        dlerrphy        : out    vl_logic;
        dllinkautobdwstatus: out    vl_logic;
        dllinkbdwmngstatus: out    vl_logic;
        dlltssm         : out    vl_logic_vector(4 downto 0);
        dlrpbufemp      : out    vl_logic;
        dlrstentercompbit: out    vl_logic;
        dlrsttxmarginfield: out    vl_logic;
        dlrxtyppm       : out    vl_logic_vector(2 downto 0);
        dlrxvalpm       : out    vl_logic;
        dltxackpm       : out    vl_logic;
        dlup            : out    vl_logic;
        dlupexit        : out    vl_logic;
        dlvcstatus      : out    vl_logic_vector(7 downto 0);
        dprioout        : out    vl_logic;
        dpriostate      : out    vl_logic_vector(2 downto 0);
        eidleinfersel   : out    vl_logic_vector(23 downto 0);
        ev128ns         : out    vl_logic;
        ev1us           : out    vl_logic;
        gen2rate        : out    vl_logic;
        gen2rategnd     : out    vl_logic;
        hotrstexit      : out    vl_logic;
        intstatus       : out    vl_logic_vector(3 downto 0);
        l2exit          : out    vl_logic;
        laneact         : out    vl_logic_vector(3 downto 0);
        linkup          : out    vl_logic;
        lmiack          : out    vl_logic;
        lmidout         : out    vl_logic_vector(31 downto 0);
        ltssml0state    : out    vl_logic;
        mramregscanout  : out    vl_logic;
        powerdown       : out    vl_logic_vector(15 downto 0);
        resetstatus     : out    vl_logic;
        rxbardecvc0     : out    vl_logic_vector(7 downto 0);
        rxbardecvc1     : out    vl_logic_vector(7 downto 0);
        rxbevc00        : out    vl_logic_vector(7 downto 0);
        rxbevc01        : out    vl_logic_vector(7 downto 0);
        rxbevc10        : out    vl_logic_vector(7 downto 0);
        rxbevc11        : out    vl_logic_vector(7 downto 0);
        rxdatavc00      : out    vl_logic_vector(63 downto 0);
        rxdatavc01      : out    vl_logic_vector(63 downto 0);
        rxdatavc10      : out    vl_logic_vector(63 downto 0);
        rxdatavc11      : out    vl_logic_vector(63 downto 0);
        rxeopvc00       : out    vl_logic;
        rxeopvc01       : out    vl_logic;
        rxeopvc10       : out    vl_logic;
        rxeopvc11       : out    vl_logic;
        rxerrvc0        : out    vl_logic;
        rxerrvc1        : out    vl_logic;
        rxfifoemptyvc0  : out    vl_logic;
        rxfifoemptyvc1  : out    vl_logic;
        rxfifofullvc0   : out    vl_logic;
        rxfifofullvc1   : out    vl_logic;
        rxfifordpvc0    : out    vl_logic_vector(3 downto 0);
        rxfifordpvc1    : out    vl_logic_vector(3 downto 0);
        rxfifowrpvc0    : out    vl_logic_vector(3 downto 0);
        rxfifowrpvc1    : out    vl_logic_vector(3 downto 0);
        rxpolarity      : out    vl_logic_vector(7 downto 0);
        rxsopvc00       : out    vl_logic;
        rxsopvc01       : out    vl_logic;
        rxsopvc10       : out    vl_logic;
        rxsopvc11       : out    vl_logic;
        rxvalidvc0      : out    vl_logic;
        rxvalidvc1      : out    vl_logic;
        serrout         : out    vl_logic;
        swdnwake        : out    vl_logic;
        swuphotrst      : out    vl_logic;
        testout         : out    vl_logic_vector(63 downto 0);
        tlappintaack    : out    vl_logic;
        tlappmsiack     : out    vl_logic;
        tlcfgadd        : out    vl_logic_vector(3 downto 0);
        tlcfgctl        : out    vl_logic_vector(31 downto 0);
        tlcfgctlwr      : out    vl_logic;
        tlcfgsts        : out    vl_logic_vector(52 downto 0);
        tlcfgstswr      : out    vl_logic;
        tlpmetosr       : out    vl_logic;
        txcompl         : out    vl_logic_vector(7 downto 0);
        txcredvc0       : out    vl_logic_vector(35 downto 0);
        txcredvc1       : out    vl_logic_vector(35 downto 0);
        txdata          : out    vl_logic_vector(63 downto 0);
        txdatak         : out    vl_logic_vector(7 downto 0);
        txdeemph        : out    vl_logic_vector(7 downto 0);
        txdetectrx      : out    vl_logic_vector(7 downto 0);
        txelecidle      : out    vl_logic_vector(7 downto 0);
        txfifoemptyvc0  : out    vl_logic;
        txfifoemptyvc1  : out    vl_logic;
        txfifofullvc0   : out    vl_logic;
        txfifofullvc1   : out    vl_logic;
        txfifordpvc0    : out    vl_logic_vector(3 downto 0);
        txfifordpvc1    : out    vl_logic_vector(3 downto 0);
        txfifowrpvc0    : out    vl_logic_vector(3 downto 0);
        txfifowrpvc1    : out    vl_logic_vector(3 downto 0);
        txmargin        : out    vl_logic_vector(23 downto 0);
        txreadyvc0      : out    vl_logic;
        txreadyvc1      : out    vl_logic;
        wakeoen         : out    vl_logic
    );
end arriaii_hssi_pcie_hip;