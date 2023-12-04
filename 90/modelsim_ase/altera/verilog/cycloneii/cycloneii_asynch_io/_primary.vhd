library verilog;
use verilog.vl_types.all;
entity cycloneii_asynch_io is
    generic(
        operation_mode  : string  := "input";
        bus_hold        : string  := "false";
        open_drain_output: string  := "false";
        use_differential_input: string  := "false"
    );
    port(
        datain          : in     vl_logic;
        oe              : in     vl_logic;
        regin           : in     vl_logic;
        differentialin  : in     vl_logic;
        differentialout : out    vl_logic;
        padio           : inout  vl_logic;
        combout         : out    vl_logic;
        regout          : out    vl_logic
    );
end cycloneii_asynch_io;
