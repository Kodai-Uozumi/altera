library verilog;
use verilog.vl_types.all;
entity arriaii_dqs_enable_ctrl is
    generic(
        lpm_type        : string  := "arriaii_dqs_enable_ctrl";
        delay_dqs_enable_by_half_cycle: string  := "false"
    );
    port(
        clk             : in     vl_logic;
        dqsenablein     : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dqsenableout    : out    vl_logic
    );
end arriaii_dqs_enable_ctrl;
