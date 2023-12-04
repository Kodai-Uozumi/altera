library verilog;
use verilog.vl_types.all;
entity flex6k_io is
    generic(
        operation_mode  : string  := "input";
        feedback_mode   : string  := "from_pin";
        power_up        : string  := "low";
        output_enable   : string  := "false"
    );
    port(
        datain          : in     vl_logic;
        oe              : in     vl_logic;
        devclrn         : in     vl_logic;
        devoe           : in     vl_logic;
        devpor          : in     vl_logic;
        padio           : inout  vl_logic;
        combout         : out    vl_logic
    );
end flex6k_io;
