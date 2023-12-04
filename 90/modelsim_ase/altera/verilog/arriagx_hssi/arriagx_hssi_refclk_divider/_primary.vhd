library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_refclk_divider is
    generic(
        enable_divider  : string  := "true";
        divider_number  : integer := 0;
        refclk_coupling_termination: string  := "dc_coupling_external_termination";
        dprio_config_mode: integer := 0
    );
    port(
        inclk           : in     vl_logic;
        dprioin         : in     vl_logic;
        dpriodisable    : in     vl_logic;
        clkout          : out    vl_logic;
        dprioout        : out    vl_logic
    );
end arriagx_hssi_refclk_divider;
