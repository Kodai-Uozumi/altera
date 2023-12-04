library verilog;
use verilog.vl_types.all;
entity hardcopyiii_dqs_enable is
    generic(
        lpm_type        : string  := "hardcopyiii_dqs_enable"
    );
    port(
        dqsin           : in     vl_logic;
        dqsenable       : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dqsbusout       : out    vl_logic
    );
end hardcopyiii_dqs_enable;
