library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_rx_digi_rx_ctrl is
    generic(
        delay           : integer := 0
    );
    port(
        soft_reset      : in     vl_logic;
        clk_2           : in     vl_logic;
        rx_wr_clk       : in     vl_logic;
        rx_rd_clk       : in     vl_logic;
        scan_mode       : in     vl_logic;
        rrxfifo_dis     : in     vl_logic;
        rindv_rx        : in     vl_logic;
        rendec_data_sel_rx: in     vl_logic;
        rwa_6g_en       : in     vl_logic;
        rrxfifo_lowlatency_en: in     vl_logic;
        endec_rx        : in     vl_logic;
        rinvalid_code_err_only: in     vl_logic;
        rrx_pipe_enable : in     vl_logic;
        rpmadatawidth   : in     vl_logic;
        rdwidth         : in     vl_logic;
        rautoinsdis     : in     vl_logic;
        rbytorden       : in     vl_logic_vector(1 downto 0);
        rbytord_2sym_en : in     vl_logic;
        rbytordpat      : in     vl_logic_vector(19 downto 0);
        rbytordpadval   : in     vl_logic_vector(9 downto 0);
        rbytordplden    : in     vl_logic;
        bytordplden     : in     vl_logic;
        rsync_comp_size : in     vl_logic_vector(2 downto 0);
        rsync_comp_pat  : in     vl_logic_vector(39 downto 0);
        rsync_comp_porn : in     vl_logic;
        rsync_sm_dis    : in     vl_logic;
        rclkcmpinsertpad: in     vl_logic;
        rbytord_6g_mask_en: in     vl_logic;
        rbytord_s2gx    : in     vl_logic;
        invalid_code_delay: in     vl_logic_vector(1 downto 0);
        sigdetni        : in     vl_logic;
        dec_data_valid_pre: in     vl_logic_vector(1 downto 0);
        dec_data_valid  : in     vl_logic_vector(1 downto 0);
        rx_data_rs      : in     vl_logic_vector(7 downto 0);
        rx_control_rs   : in     vl_logic;
        rx_data_dt      : in     vl_logic_vector(15 downto 0);
        rx_control_dt   : in     vl_logic_vector(1 downto 0);
        tenb_data       : in     vl_logic_vector(19 downto 0);
        sync_resync_pre : in     vl_logic_vector(1 downto 0);
        sync_resync_delay: in     vl_logic_vector(1 downto 0);
        disp_err_delay  : in     vl_logic_vector(1 downto 0);
        disp_val_delay  : in     vl_logic_vector(1 downto 0);
        ovr_undflow     : in     vl_logic_vector(3 downto 0);
        rrxfifo_urst_en : in     vl_logic;
        rxfifo_urst     : in     vl_logic;
        rrxphfifopldctl_en: in     vl_logic;
        pld_wr_dis      : in     vl_logic;
        pld_re          : in     vl_logic;
        rrxpcsbypass_en : in     vl_logic;
        phystatus_int   : in     vl_logic;
        rxvalid_int     : in     vl_logic;
        rxstatus_int    : in     vl_logic_vector(2 downto 0);
        powerdown       : in     vl_logic_vector(1 downto 0);
        reset_pc_ptrs   : in     vl_logic;
        reset_pc_ptrs_centrl: in     vl_logic;
        reset_pc_ptrs_quad_up: in     vl_logic;
        reset_pc_ptrs_quad_down: in     vl_logic;
        gen2ngen1       : in     vl_logic;
        gen2ngen1_bundle: in     vl_logic;
        dis_pc_byte     : in     vl_logic;
        wr_enable_centrl: in     vl_logic;
        wr_enable_quad_up: in     vl_logic;
        wr_enable_quad_down: in     vl_logic;
        rd_enable_centrl: in     vl_logic;
        rd_enable_quad_up: in     vl_logic;
        rd_enable_quad_down: in     vl_logic;
        rx_we_in_centrl : in     vl_logic;
        rx_we_in_quad_up: in     vl_logic;
        rx_we_in_quad_down: in     vl_logic;
        rauto_speed_ena : in     vl_logic;
        rfreq_sel       : in     vl_logic;
        rphfifo_regmode_rx: in     vl_logic;
        rmaster_rx      : in     vl_logic;
        rmaster_up_rx   : in     vl_logic;
        rxd             : out    vl_logic_vector(63 downto 0);
        rxd_9           : out    vl_logic_vector(1 downto 0);
        rxd_19          : out    vl_logic_vector(1 downto 0);
        rxc             : out    vl_logic_vector(3 downto 0);
        running_disp    : out    vl_logic_vector(1 downto 0);
        signal_detect_out: out    vl_logic;
        rxd_lpbk        : out    vl_logic_vector(39 downto 0);
        rx_we_out       : out    vl_logic;
        ph_fifo_empty   : out    vl_logic;
        ph_fifo_full    : out    vl_logic;
        wr_enable_out   : out    vl_logic;
        rd_enable_out   : out    vl_logic;
        bytord_valid_out: out    vl_logic;
        soft_reset_rclk1: out    vl_logic;
        soft_reset_wclk1: out    vl_logic;
        phystatus       : out    vl_logic;
        rxvalid         : out    vl_logic;
        rxstatus        : out    vl_logic_vector(2 downto 0);
        pipe_data       : out    vl_logic_vector(63 downto 0);
        wr_enable2      : out    vl_logic;
        wptr_bin        : out    vl_logic_vector(2 downto 0);
        rd_enable2      : out    vl_logic;
        rptr_bin        : out    vl_logic_vector(2 downto 0);
        pcs_wrapback_in : in     vl_logic_vector(69 downto 0);
        rpcs_wrapback_en: in     vl_logic
    );
end arriaii_hssi_rx_digi_rx_ctrl;
