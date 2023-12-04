library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_rx_ctrl is
    port(
        bytord_valid_out: out    vl_logic;
        bytordplden     : in     vl_logic;
        clk_2           : in     vl_logic;
        dec_data_valid  : in     vl_logic_vector(1 downto 0);
        dec_data_valid_pre: in     vl_logic_vector(1 downto 0);
        disp_err_delay  : in     vl_logic_vector(1 downto 0);
        disp_val_delay  : in     vl_logic_vector(1 downto 0);
        endec_rx        : in     vl_logic;
        indv_rx         : in     vl_logic;
        invalid_code_delay: in     vl_logic_vector(1 downto 0);
        ovr_undflow     : in     vl_logic_vector(3 downto 0);
        ph_fifo_empty   : out    vl_logic;
        ph_fifo_full    : out    vl_logic;
        pld_re          : in     vl_logic;
        pld_wr_dis      : in     vl_logic;
        rautoinsdis     : in     vl_logic;
        rbytord_2sym_en : in     vl_logic;
        rbytorden       : in     vl_logic_vector(1 downto 0);
        rbytordpadval   : in     vl_logic_vector(9 downto 0);
        rbytordpat      : in     vl_logic_vector(9 downto 0);
        rbytordplden    : in     vl_logic;
        rclkcmpinsertpad: in     vl_logic;
        rd_enable2      : out    vl_logic;
        rd_enable_ch0   : in     vl_logic;
        rd_enable_out   : out    vl_logic;
        rd_enable_q0_ch0: in     vl_logic;
        rdwidth         : in     vl_logic;
        rendec_data_sel_rx: in     vl_logic;
        rinvalid_code_err_only: in     vl_logic;
        rphfifo_master_sel_rx: in     vl_logic;
        rpmadatawidth   : in     vl_logic;
        rptr_bin        : out    vl_logic_vector(2 downto 0);
        rrxfifo_dis     : in     vl_logic;
        rrxfifo_lowlatency_en: in     vl_logic;
        rrxfifo_urst_en : in     vl_logic;
        rrxphfifopldctl_en: in     vl_logic;
        rsync_comp_pat  : in     vl_logic_vector(39 downto 0);
        rsync_comp_porn : in     vl_logic;
        rsync_comp_size : in     vl_logic_vector(2 downto 0);
        rsync_sm_dis    : in     vl_logic;
        running_disp    : out    vl_logic_vector(1 downto 0);
        rwa_6g_en       : in     vl_logic;
        rx_control_dt   : in     vl_logic_vector(1 downto 0);
        rx_control_rs   : in     vl_logic;
        rx_data_dt      : in     vl_logic_vector(15 downto 0);
        rx_data_rs      : in     vl_logic_vector(7 downto 0);
        rx_rd_clk       : in     vl_logic;
        rx_we_in_ch0    : in     vl_logic;
        rx_we_in_q0_ch0 : in     vl_logic;
        rx_we_out       : out    vl_logic;
        rx_wr_clk       : in     vl_logic;
        rxc             : out    vl_logic_vector(3 downto 0);
        rxd             : out    vl_logic_vector(63 downto 0);
        rxd_19          : out    vl_logic_vector(1 downto 0);
        rxd_9           : out    vl_logic_vector(1 downto 0);
        rxd_lpbk        : out    vl_logic_vector(39 downto 0);
        rxfifo_urst     : in     vl_logic;
        scan_mode       : in     vl_logic;
        signal_detect_out: out    vl_logic;
        signal_detect_sync_st: in     vl_logic;
        soft_reset      : in     vl_logic;
        soft_reset_rclk1: out    vl_logic;
        sync_resync_delay: in     vl_logic_vector(1 downto 0);
        sync_resync_pre : in     vl_logic_vector(1 downto 0);
        tenb_data       : in     vl_logic_vector(19 downto 0);
        wptr_bin        : out    vl_logic_vector(2 downto 0);
        wr_enable2      : out    vl_logic;
        wr_enable_ch0   : in     vl_logic;
        wr_enable_out   : out    vl_logic;
        wr_enable_q0_ch0: in     vl_logic
    );
end stratixiigx_hssi_rx_ctrl;
