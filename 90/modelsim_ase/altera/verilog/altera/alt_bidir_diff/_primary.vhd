library verilog;
use verilog.vl_types.all;
entity alt_bidir_diff is
    generic(
        io_standard     : string  := "NONE";
        current_strength: string  := "NONE";
        current_strength_new: string  := "NONE";
        slew_rate       : integer := -1;
        location        : string  := "NONE";
        enable_bus_hold : string  := "NONE";
        weak_pull_up_resistor: string  := "NONE";
        termination     : string  := "NONE";
        input_termination: string  := "NONE";
        output_termination: string  := "NONE";
        lpm_type        : string  := "alt_bidir_diff"
    );
    port(
        oe              : in     vl_logic;
        bidirin         : inout  vl_logic;
        io              : inout  vl_logic;
        iobar           : inout  vl_logic
    );
end alt_bidir_diff;
