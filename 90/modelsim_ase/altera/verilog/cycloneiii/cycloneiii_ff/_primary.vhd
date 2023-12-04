library verilog;
use verilog.vl_types.all;
entity cycloneiii_ff is
    generic(
        power_up        : string  := "low";
        x_on_violation  : string  := "on";
        lpm_type        : string  := "cycloneiii_ff"
    );
    port(
        d               : in     vl_logic;
        clk             : in     vl_logic;
        clrn            : in     vl_logic;
        aload           : in     vl_logic;
        sclr            : in     vl_logic;
        sload           : in     vl_logic;
        asdata          : in     vl_logic;
        ena             : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        q               : out    vl_logic
    );
end cycloneiii_ff;
