library verilog;
use verilog.vl_types.all;
entity apex20ke_lcell_register is
    generic(
        operation_mode  : string  := "normal";
        packed_mode     : string  := "false";
        power_up        : string  := "low";
        x_on_violation  : string  := "on"
    );
    port(
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        sclr            : in     vl_logic;
        sload           : in     vl_logic;
        ena             : in     vl_logic;
        datain          : in     vl_logic;
        datac           : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        regout          : out    vl_logic;
        qfbko           : out    vl_logic
    );
end apex20ke_lcell_register;
