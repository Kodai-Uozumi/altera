library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_refclk_divider is
    generic(
        lpm_type        : string  := "arriaii_hssi_refclk_divider";
        divider_number  : integer := 0;
        enable_divider  : string  := "false";
        refclk_coupling_termination: string  := "normal_100_ohm_termination";
        protocol_hint   : string  := "basic"
    );
    port(
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic;
        inclk           : in     vl_logic;
        clkout          : out    vl_logic;
        dprioout        : out    vl_logic
    );
end arriaii_hssi_refclk_divider;
