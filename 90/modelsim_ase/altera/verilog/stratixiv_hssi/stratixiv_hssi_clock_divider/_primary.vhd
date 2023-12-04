library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_clock_divider is
    generic(
        lpm_type        : string  := "stratixiv_hssi_clock_divider";
        channel_num     : integer := 0;
        coreclk_out_gated_by_quad_reset: string  := "false";
        data_rate       : integer := 0;
        divide_by       : integer := 4;
        divider_type    : string  := "CHANNEL_REGULAR";
        dprio_config_mode: integer := 0;
        effective_data_rate: string  := "unused";
        enable_dynamic_divider: string  := "false";
        enable_refclk_out: string  := "false";
        inclk_select    : integer := 0;
        logical_channel_address: integer := 0;
        pre_divide_by   : integer := 1;
        rate_switch_base_clk_in_select: integer := 0;
        rate_switch_done_in_select: integer := 0;
        refclk_divide_by: integer := 0;
        refclk_multiply_by: integer := 0;
        refclkin_select : integer := 0;
        select_local_rate_switch_base_clock: string  := "false";
        select_local_rate_switch_done: string  := "true";
        select_local_refclk: string  := "false";
        select_refclk_dig: string  := "false";
        sim_analogfastrefclkout_phase_shift: integer := 0;
        sim_analogrefclkout_phase_shift: integer := 0;
        sim_coreclkout_phase_shift: integer := 0;
        sim_refclkout_phase_shift: integer := 0;
        use_coreclk_out_post_divider: string  := "false";
        use_refclk_post_divider: string  := "false";
        use_vco_bypass  : string  := "false"
    );
    port(
        clk0in          : in     vl_logic_vector(3 downto 0);
        clk1in          : in     vl_logic_vector(3 downto 0);
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic_vector(99 downto 0);
        powerdn         : in     vl_logic;
        quadreset       : in     vl_logic;
        rateswitch      : in     vl_logic;
        rateswitchbaseclkin: in     vl_logic_vector(1 downto 0);
        rateswitchdonein: in     vl_logic_vector(1 downto 0);
        refclkdig       : in     vl_logic;
        refclkin        : in     vl_logic_vector(1 downto 0);
        vcobypassin     : in     vl_logic;
        analogfastrefclkout: out    vl_logic_vector(1 downto 0);
        analogfastrefclkoutshifted: out    vl_logic_vector(1 downto 0);
        analogrefclkout : out    vl_logic_vector(1 downto 0);
        analogrefclkoutshifted: out    vl_logic_vector(1 downto 0);
        analogrefclkpulse: out    vl_logic;
        analogrefclkpulseshifted: out    vl_logic;
        coreclkout      : out    vl_logic;
        dprioout        : out    vl_logic_vector(99 downto 0);
        rateswitchbaseclock: out    vl_logic;
        rateswitchdone  : out    vl_logic;
        rateswitchout   : out    vl_logic;
        refclkout       : out    vl_logic
    );
end stratixiv_hssi_clock_divider;
