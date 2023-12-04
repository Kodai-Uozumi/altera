library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_rx_cdr is
    generic(
        cru_clock_select: integer := 0;
        cru_divide_by   : integer := 1;
        cru_multiply_by : integer := 10;
        cru_pre_divide_by: integer := 1;
        cruclk0_period  : integer := 10000;
        cruclk1_period  : integer := 10000;
        cruclk2_period  : integer := 10000;
        cruclk3_period  : integer := 10000;
        cruclk4_period  : integer := 10000;
        cruclk5_period  : integer := 10000;
        cruclk6_period  : integer := 10000;
        cruclk7_period  : integer := 10000;
        force_signal_detect: string  := "false";
        ignore_lock_detect: string  := "false";
        signal_detect_threshhold: integer := 0;
        send_direct_reverse_serial_loopback: string  := "false";
        force_freq_det_high: string  := "false";
        force_freq_det_low: string  := "false";
        sim_rxpll_clkout_phase_shift: integer := 0;
        sim_rxpll_clkout_latency: integer := 0;
        dprio_config_mode: integer := 0
    );
    port(
        cruclk          : in     vl_logic_vector(8 downto 0);
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic_vector(19 downto 0);
        freqlock        : in     vl_logic;
        ltd             : in     vl_logic;
        ltr             : in     vl_logic;
        pdb             : in     vl_logic;
        reset           : in     vl_logic;
        rxin            : in     vl_logic;
        clklow          : out    vl_logic;
        dprioout        : out    vl_logic_vector(19 downto 0);
        fref            : out    vl_logic;
        freqlocked      : out    vl_logic;
        phaselockloss   : out    vl_logic;
        revserialfdbk   : out    vl_logic;
        serialclkout    : out    vl_logic;
        signaldetect    : out    vl_logic
    );
end arriagx_hssi_rx_cdr;
