library verilog;
use verilog.vl_types.all;
entity altgxb_xgm_interface is
    generic(
        use_continuous_calibration_mode: string  := "OFF";
        mode_is_xaui    : string  := "OFF";
        digital_test_output_select: integer := 0;
        analog_test_output_signal_select: integer := 0;
        analog_test_output_channel_select: integer := 0;
        rx_ppm_setting_0: integer := 0;
        rx_ppm_setting_1: integer := 0;
        use_rx_calibration_status: string  := "OFF";
        use_global_serial_loopback: string  := "OFF";
        rx_calibration_test_write_value: integer := 0;
        enable_rx_calibration_test_write: string  := "OFF";
        tx_calibration_test_write_value: integer := 0;
        enable_tx_calibration_test_write: string  := "OFF"
    );
    port(
        txdatain        : in     vl_logic_vector(31 downto 0);
        txctrl          : in     vl_logic_vector(3 downto 0);
        rdenablesync    : in     vl_logic;
        txclk           : in     vl_logic;
        rxdatain        : in     vl_logic_vector(31 downto 0);
        rxctrl          : in     vl_logic_vector(3 downto 0);
        rxrunningdisp   : in     vl_logic_vector(3 downto 0);
        rxdatavalid     : in     vl_logic_vector(3 downto 0);
        rxclk           : in     vl_logic;
        resetall        : in     vl_logic;
        adet            : in     vl_logic_vector(3 downto 0);
        syncstatus      : in     vl_logic_vector(3 downto 0);
        rdalign         : in     vl_logic_vector(3 downto 0);
        recovclk        : in     vl_logic;
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic;
        txdataout       : out    vl_logic_vector(31 downto 0);
        txctrlout       : out    vl_logic_vector(3 downto 0);
        rxdataout       : out    vl_logic_vector(31 downto 0);
        rxctrlout       : out    vl_logic_vector(3 downto 0);
        resetout        : out    vl_logic;
        alignstatus     : out    vl_logic;
        enabledeskew    : out    vl_logic;
        fiforesetrd     : out    vl_logic;
        scanclk         : in     vl_logic;
        scanin          : in     vl_logic;
        scanshift       : in     vl_logic;
        scanmode        : in     vl_logic;
        scanout         : out    vl_logic;
        test            : out    vl_logic;
        digitalsmtest   : out    vl_logic_vector(3 downto 0);
        calibrationstatus: out    vl_logic_vector(4 downto 0);
        mdiodisable     : in     vl_logic;
        mdioclk         : in     vl_logic;
        mdioin          : in     vl_logic;
        rxppmselect     : in     vl_logic;
        mdioout         : out    vl_logic;
        mdiooe          : out    vl_logic;
        txdigitalreset  : in     vl_logic_vector(3 downto 0);
        rxdigitalreset  : in     vl_logic_vector(3 downto 0);
        rxanalogreset   : in     vl_logic_vector(3 downto 0);
        pllreset        : in     vl_logic;
        pllenable       : in     vl_logic;
        txdigitalresetout: out    vl_logic_vector(3 downto 0);
        rxdigitalresetout: out    vl_logic_vector(3 downto 0);
        txanalogresetout: out    vl_logic_vector(3 downto 0);
        rxanalogresetout: out    vl_logic_vector(3 downto 0);
        pllresetout     : out    vl_logic
    );
end altgxb_xgm_interface;
