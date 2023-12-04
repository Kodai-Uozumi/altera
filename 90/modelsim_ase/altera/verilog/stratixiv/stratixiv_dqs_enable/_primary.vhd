library verilog;
use verilog.vl_types.all;
entity stratixiv_dqs_enable is
    generic(
        lpm_type        : string  := "stratixiv_dqs_enable"
    );
    port(
        dqsin           : in     vl_logic;
        dqsenable       : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dqsbusout       : out    vl_logic
    );
end stratixiv_dqs_enable;
