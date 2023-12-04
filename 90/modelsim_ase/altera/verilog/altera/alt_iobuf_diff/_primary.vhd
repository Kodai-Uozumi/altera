library verilog;
use verilog.vl_types.all;
entity alt_iobuf_diff is
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
        lpm_type        : string  := "alt_iobuf_diff"
    );
    port(
        i               : in     vl_logic;
        oe              : in     vl_logic;
        io              : inout  vl_logic;
        iobar           : inout  vl_logic;
        o               : out    vl_logic
    );
end alt_iobuf_diff;
