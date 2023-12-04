library verilog;
use verilog.vl_types.all;
entity max_io is
    generic(
        operation_mode  : string  := "input";
        bus_hold        : string  := "false";
        open_drain_output: string  := "false";
        weak_pull_up    : string  := "false"
    );
    port(
        datain          : in     vl_logic;
        oe              : in     vl_logic;
        padio           : inout  vl_logic;
        dataout         : out    vl_logic
    );
end max_io;
