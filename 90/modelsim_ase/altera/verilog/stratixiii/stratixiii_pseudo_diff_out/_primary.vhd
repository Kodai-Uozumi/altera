library verilog;
use verilog.vl_types.all;
entity stratixiii_pseudo_diff_out is
    generic(
        lpm_type        : string  := "stratixiii_pseudo_diff_out"
    );
    port(
        i               : in     vl_logic;
        o               : out    vl_logic;
        obar            : out    vl_logic
    );
end stratixiii_pseudo_diff_out;
