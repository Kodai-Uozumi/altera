library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_rx_pma is
    generic(
        lpm_type        : string  := "arriaii_hssi_rx_pma";
        adaptive_equalization_mode: string  := "none";
        allow_serial_loopback: string  := "false";
        allow_vco_bypass: integer := 0;
        analog_power    : string  := "1.4V";
        channel_number  : integer := 0;
        channel_type    : string  := "auto";
        common_mode     : string  := "0.82V";
        deserialization_factor: integer := 8;
        dprio_config_mode: string  := "000000";
        enable_ltd      : string  := "false";
        enable_ltr      : string  := "false";
        eq_adapt_seq_control: integer := 0;
        eq_dc_gain      : integer := 0;
        eq_max_gradient_control: integer := 0;
        eqa_ctrl        : integer := 0;
        eqb_ctrl        : integer := 0;
        eqc_ctrl        : integer := 0;
        eqd_ctrl        : integer := 0;
        eqv_ctrl        : integer := 0;
        eyemon_bandwidth: integer := 0;
        force_signal_detect: string  := "false";
        ignore_lock_detect: string  := "false";
        logical_channel_address: integer := 0;
        low_speed_test_select: integer := 0;
        offset_cancellation: integer := 0;
        ppm_gen1_2_xcnt_en: integer := 1;
        ppm_post_eidle  : integer := 0;
        ppmselect       : integer := 0;
        protocol_hint   : string  := "basic";
        send_direct_reverse_serial_loopback: string  := "None";
        signal_detect_hysteresis: integer := 0;
        signal_detect_hysteresis_valid_threshold: integer := 0;
        signal_detect_loss_threshold: integer := 0;
        termination     : string  := "OCT 100 Ohms";
        use_deser_double_data_width: string  := "false";
        use_pma_direct  : string  := "false";
        \PARAM_DELAY\   : integer := 0
    );
    port(
        adaptcapture    : in     vl_logic;
        adcepowerdn     : in     vl_logic;
        adcereset       : in     vl_logic;
        adcestandby     : in     vl_logic;
        datain          : in     vl_logic;
        deserclock      : in     vl_logic_vector(3 downto 0);
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic_vector(299 downto 0);
        extra10gin      : in     vl_logic_vector(37 downto 0);
        freqlock        : in     vl_logic;
        ignorephslck    : in     vl_logic;
        locktodata      : in     vl_logic;
        locktoref       : in     vl_logic;
        offsetcancellationen: in     vl_logic;
        plllocked       : in     vl_logic;
        powerdn         : in     vl_logic;
        ppmdetectdividedclk: in     vl_logic;
        ppmdetectrefclk : in     vl_logic;
        recoverdatain   : in     vl_logic_vector(1 downto 0);
        rxpmareset      : in     vl_logic;
        seriallpbken    : in     vl_logic;
        seriallpbkin    : in     vl_logic;
        testbussel      : in     vl_logic_vector(3 downto 0);
        adaptdone       : out    vl_logic;
        analogtestbus   : out    vl_logic_vector(7 downto 0);
        clockout        : out    vl_logic;
        dataout         : out    vl_logic;
        dataoutfull     : out    vl_logic_vector(19 downto 0);
        dprioout        : out    vl_logic_vector(299 downto 0);
        locktorefout    : out    vl_logic;
        ppmdetectclkrel : out    vl_logic;
        recoverdataout  : out    vl_logic_vector(63 downto 0);
        reverselpbkout  : out    vl_logic;
        revserialfdbkout: out    vl_logic;
        signaldetect    : out    vl_logic
    );
end arriaii_hssi_rx_pma;
