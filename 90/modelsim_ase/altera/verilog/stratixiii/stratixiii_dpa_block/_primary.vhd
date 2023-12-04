library verilog;
use verilog.vl_types.all;
entity stratixiii_dpa_block is
    generic(
        net_ppm_variation: integer := 0;
        is_negative_ppm_drift: string  := "off";
        enable_soft_cdr_mode: string  := "on"
    );
    port(
        clkin           : in     vl_logic;
        dpareset        : in     vl_logic;
        dpahold         : in     vl_logic;
        datain          : in     vl_logic;
        clkout          : out    vl_logic;
        dataout         : out    vl_logic;
        dpalock         : out    vl_logic
    );
end stratixiii_dpa_block;
