library verilog;
use verilog.vl_types.all;
entity apex20k_io is
    generic(
        operation_mode  : string  := "input";
        reg_source_mode : string  := "none";
        feedback_mode   : string  := "from_pin";
        power_up        : string  := "low"
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic;
        aclr            : in     vl_logic;
        ena             : in     vl_logic;
        oe              : in     vl_logic;
        devclrn         : in     vl_logic;
        devoe           : in     vl_logic;
        devpor          : in     vl_logic;
        padio           : inout  vl_logic;
        combout         : out    vl_logic;
        regout          : out    vl_logic
    );
end apex20k_io;
