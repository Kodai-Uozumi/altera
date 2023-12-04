library verilog;
use verilog.vl_types.all;
entity hardcopyiii_ddio_in is
    generic(
        power_up        : string  := "low";
        async_mode      : string  := "none";
        sync_mode       : string  := "none";
        use_clkn        : string  := "false";
        lpm_type        : string  := "hardcopyiii_ddio_in"
    );
    port(
        datain          : in     vl_logic;
        clk             : in     vl_logic;
        clkn            : in     vl_logic;
        ena             : in     vl_logic;
        areset          : in     vl_logic;
        sreset          : in     vl_logic;
        regoutlo        : out    vl_logic;
        regouthi        : out    vl_logic;
        dfflo           : out    vl_logic;
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic
    );
end hardcopyiii_ddio_in;
