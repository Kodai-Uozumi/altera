library verilog;
use verilog.vl_types.all;
entity hardcopyiii_ddr_io_reg is
    generic(
        power_up        : string  := "DONT_CARE";
        is_wysiwyg      : string  := "false";
        x_on_violation  : string  := "on"
    );
    port(
        d               : in     vl_logic;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        clrn            : in     vl_logic;
        prn             : in     vl_logic;
        aload           : in     vl_logic;
        asdata          : in     vl_logic;
        sclr            : in     vl_logic;
        sload           : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        rpt_violation   : in     vl_logic;
        q               : out    vl_logic
    );
end hardcopyiii_ddr_io_reg;
