library verilog;
use verilog.vl_types.all;
entity maxii_io is
    generic(
        operation_mode  : string  := "input";
        bus_hold        : string  := "false";
        open_drain_output: string  := "false";
        lpm_type        : string  := "maxii_io"
    );
    port(
        datain          : in     vl_logic;
        oe              : in     vl_logic;
        padio           : inout  vl_logic;
        combout         : out    vl_logic
    );
end maxii_io;
