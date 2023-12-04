library verilog;
use verilog.vl_types.all;
entity stratixgx_hssi_rx_serdes is
    generic(
        channel_width   : integer := 10;
        run_length      : integer := 4;
        run_length_enable: string  := "false";
        cruclk_period   : integer := 5000;
        cruclk_multiplier: integer := 4;
        use_cruclk_divider: string  := "false";
        use_double_data_mode: string  := "false";
        channel_width_max: integer := 10;
        init_lock_latency: integer := 9
    );
    port(
        cruclk          : in     vl_logic;
        datain          : in     vl_logic;
        areset          : in     vl_logic;
        feedback        : in     vl_logic;
        fbkcntl         : in     vl_logic;
        ltr             : in     vl_logic;
        ltd             : in     vl_logic;
        clkout          : out    vl_logic;
        dataout         : out    vl_logic_vector(9 downto 0);
        rlv             : out    vl_logic;
        lock            : out    vl_logic;
        freqlock        : out    vl_logic;
        signaldetect    : out    vl_logic
    );
end stratixgx_hssi_rx_serdes;
