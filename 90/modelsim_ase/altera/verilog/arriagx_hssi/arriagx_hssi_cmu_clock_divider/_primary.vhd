library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_cmu_clock_divider is
    generic(
        inclk_select    : integer := 0;
        use_vco_bypass  : string  := "false";
        use_digital_refclk_post_divider: string  := "false";
        use_coreclk_out_post_divider: string  := "false";
        divide_by       : integer := 4;
        enable_refclk_out: string  := "true";
        enable_pclk_x8_out: string  := "false";
        select_neighbor_pclk: string  := "false";
        coreclk_out_gated_by_quad_reset: string  := "false";
        select_refclk_dig: string  := "false";
        dprio_config_mode: integer := 0;
        sim_analogrefclkout_phase_shift: integer := 0;
        sim_analogfastrefclkout_phase_shift: integer := 0;
        sim_digitalrefclkout_phase_shift: integer := 0;
        sim_pclkx8out_phase_shift: integer := 0;
        sim_coreclkout_phase_shift: integer := 0
    );
    port(
        clk             : in     vl_logic_vector(2 downto 0);
        pclkin          : in     vl_logic;
        dprioin         : in     vl_logic_vector(29 downto 0);
        dpriodisable    : in     vl_logic;
        powerdn         : in     vl_logic;
        quadreset       : in     vl_logic;
        refclkdig       : in     vl_logic;
        scanclk         : in     vl_logic;
        scanin          : in     vl_logic_vector(22 downto 0);
        vcobypassin     : in     vl_logic;
        scanshift       : in     vl_logic;
        scanmode        : in     vl_logic;
        analogrefclkout : out    vl_logic;
        analogfastrefclkout: out    vl_logic;
        digitalrefclkout: out    vl_logic;
        pclkx8out       : out    vl_logic;
        coreclkout      : out    vl_logic;
        dprioout        : out    vl_logic_vector(29 downto 0);
        scanout         : out    vl_logic_vector(22 downto 0)
    );
end arriagx_hssi_cmu_clock_divider;
