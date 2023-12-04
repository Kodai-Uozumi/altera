library verilog;
use verilog.vl_types.all;
entity cycloneiiils_pseudo_diff_out is
    generic(
        lpm_type        : string  := "cycloneiiils_pseudo_diff_out"
    );
    port(
        i               : in     vl_logic;
        o               : out    vl_logic;
        obar            : out    vl_logic
    );
end cycloneiiils_pseudo_diff_out;
