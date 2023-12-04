library verilog;
use verilog.vl_types.all;
entity apex20ke_asynch_io is
    generic(
        operation_mode  : string  := "input";
        reg_source_mode : string  := "none";
        feedback_mode   : string  := "from_pin";
        open_drain_output: string  := "false"
    );
    port(
        datain          : in     vl_logic;
        oe              : in     vl_logic;
        padio           : inout  vl_logic;
        \dffeD\         : out    vl_logic;
        \dffeQ\         : in     vl_logic;
        combout         : out    vl_logic;
        regout          : out    vl_logic
    );
end apex20ke_asynch_io;
