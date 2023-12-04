library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_cmu_pll is
    generic(
        inclk0_period   : integer := 0;
        inclk1_period   : integer := 0;
        inclk2_period   : integer := 0;
        inclk3_period   : integer := 0;
        inclk4_period   : integer := 0;
        inclk5_period   : integer := 0;
        inclk6_period   : integer := 0;
        inclk7_period   : integer := 0;
        pfd_clk_select  : integer := 0;
        multiply_by     : integer := 1;
        divide_by       : integer := 1;
        low_speed_test_sel: integer := 0;
        pll_type        : string  := "normal";
        charge_pump_current_test_enable: integer := 0;
        vco_range       : string  := "low";
        loop_filter_resistor_control: integer := 0;
        loop_filter_ripple_capacitor_control: integer := 0;
        use_default_charge_pump_current_selection: string  := "false";
        use_default_charge_pump_supply_vccm_vod_control: string  := "false";
        pll_number      : integer := 0;
        charge_pump_current_control: integer := 0;
        up_down_control_percent: integer := 0;
        charge_pump_tristate_enable: string  := "false";
        enable_pll_cascade: string  := "false";
        dprio_config_mode: integer := 0;
        protocol_hint   : string  := "basic";
        remapped_to_new_loop_filter_charge_pump_settings: string  := "false";
        sim_clkout_phase_shift: integer := 0;
        sim_clkout_latency: integer := 0
    );
    port(
        clk             : in     vl_logic_vector(7 downto 0);
        dprioin         : in     vl_logic_vector(39 downto 0);
        dpriodisable    : in     vl_logic;
        pllreset        : in     vl_logic;
        pllpowerdn      : in     vl_logic;
        clkout          : out    vl_logic;
        locked          : out    vl_logic;
        dprioout        : out    vl_logic_vector(39 downto 0);
        fbclkout        : out    vl_logic;
        vcobypassout    : out    vl_logic
    );
end arriagx_hssi_cmu_pll;
