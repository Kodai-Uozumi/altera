library verilog;
use verilog.vl_types.all;
entity stratixiii_dqs_enable is
    generic(
        lpm_type        : string  := "stratixiii_dqs_enable"
    );
    port(
        dqsin           : in     vl_logic;
        dqsenable       : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dqsbusout       : out    vl_logic
    );
end stratixiii_dqs_enable;
