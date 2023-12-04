library verilog;
use verilog.vl_types.all;
entity alt_iobuf is
    generic(
        io_standard     : string  := "NONE";
        current_strength: string  := "NONE";
        current_strength_new: string  := "NONE";
        slew_rate       : integer := -1;
        slow_slew_rate  : string  := "NONE";
        location        : string  := "NONE";
        enable_bus_hold : string  := "NONE";
        weak_pull_up_resistor: string  := "NONE";
        termination     : string  := "NONE";
        input_termination: string  := "NONE";
        output_termination: string  := "NONE";
        lpm_type        : string  := "alt_iobuf"
    );
    port(
        i               : in     vl_logic;
        oe              : in     vl_logic;
        io              : inout  vl_logic;
        o               : out    vl_logic
    );
end alt_iobuf;
