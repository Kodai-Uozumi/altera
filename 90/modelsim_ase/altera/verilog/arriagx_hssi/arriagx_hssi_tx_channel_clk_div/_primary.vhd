library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_tx_channel_clk_div is
    generic(
        clkin0_select   : string  := "true";
        clk_divide_by_n : integer := 1;
        clk_divide_by_m : integer := 4;
        clk_divide_by_2_select: string  := "true";
        allow_vco_bypass: string  := "false";
        lclkout_latency : integer := 0;
        fclkout_latency : integer := 0;
        lclkout_phase_shift: integer := 0;
        fclkout_phase_shift: integer := 0
    );
    port(
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic_vector(9 downto 0);
        clkin0          : in     vl_logic;
        clkin1          : in     vl_logic;
        reset           : in     vl_logic;
        vcobypassin     : in     vl_logic;
        lclkout         : out    vl_logic;
        fclkout         : out    vl_logic
    );
end arriagx_hssi_tx_channel_clk_div;
