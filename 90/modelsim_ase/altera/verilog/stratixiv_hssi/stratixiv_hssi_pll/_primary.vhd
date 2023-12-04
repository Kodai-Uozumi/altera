library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pll is
    generic(
        lpm_type        : string  := "stratixiv_hssi_pll";
        auto_settings   : string  := "true";
        bandwidth_type  : string  := "Auto";
        base_data_rate  : string  := "unused";
        channel_num     : integer := 0;
        charge_pump_current_bits: integer := 0;
        charge_pump_mode_bits: integer := 0;
        charge_pump_test_enable: string  := "false";
        dprio_config_mode: string  := "000000";
        effective_data_rate: string  := "unused";
        inclk0_input_period: integer := 0;
        inclk1_input_period: integer := 0;
        inclk2_input_period: integer := 0;
        inclk3_input_period: integer := 0;
        inclk4_input_period: integer := 0;
        inclk5_input_period: integer := 0;
        inclk6_input_period: integer := 0;
        inclk7_input_period: integer := 0;
        inclk8_input_period: integer := 0;
        inclk9_input_period: integer := 0;
        input_clock_frequency: string  := "unused";
        logical_channel_address: integer := 0;
        logical_tx_pll_number: integer := 0;
        loop_filter_c_bits: integer := 0;
        loop_filter_r_bits: integer := 0;
        m               : integer := 0;
        n               : integer := 0;
        pd_charge_pump_current_bits: integer := 0;
        pd_loop_filter_r_bits: integer := 0;
        pfd_clk_select  : integer := 0;
        pfd_fb_select   : string  := "internal";
        pll_type        : string  := "Auto";
        protocol_hint   : string  := "basic";
        refclk_divide_by: integer := 0;
        refclk_multiply_by: integer := 0;
        sim_is_negative_ppm_drift: string  := "false";
        sim_net_ppm_variation: integer := 0;
        test_charge_pump_current_down: string  := "false";
        test_charge_pump_current_up: string  := "false";
        use_refclk_pin  : string  := "false";
        vco_data_rate   : integer := 0;
        vco_divide_by   : integer := 0;
        vco_multiply_by : integer := 0;
        vco_post_scale  : integer := 0;
        vco_range       : string  := "low";
        vco_tuning_bits : integer := 0;
        volt_reg_control_bits: integer := 0;
        volt_reg_output_bits: integer := 0;
        sim_clkout_phase_shift: integer := 0;
        sim_clkout_latency: integer := 0;
        \PARAM_DELAY\   : integer := 0
    );
    port(
        areset          : in     vl_logic;
        datain          : in     vl_logic;
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic_vector(299 downto 0);
        earlyeios       : in     vl_logic;
        extra10gin      : in     vl_logic_vector(5 downto 0);
        inclk           : in     vl_logic_vector(9 downto 0);
        locktorefclk    : in     vl_logic;
        pfdfbclk        : in     vl_logic;
        powerdown       : in     vl_logic;
        rateswitch      : in     vl_logic;
        clk             : out    vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector(1 downto 0);
        dprioout        : out    vl_logic_vector(299 downto 0);
        freqlocked      : out    vl_logic;
        locked          : out    vl_logic;
        pfdfbclkout     : out    vl_logic;
        pfdrefclkout    : out    vl_logic;
        vcobypassout    : out    vl_logic
    );
end stratixiv_hssi_pll;
