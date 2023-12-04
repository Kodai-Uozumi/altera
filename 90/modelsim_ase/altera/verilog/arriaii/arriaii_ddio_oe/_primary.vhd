library verilog;
use verilog.vl_types.all;
entity arriaii_ddio_oe is
    generic(
        power_up        : string  := "low";
        async_mode      : string  := "none";
        sync_mode       : string  := "none";
        lpm_type        : string  := "arriaii_ddio_oe"
    );
    port(
        oe              : in     vl_logic;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        areset          : in     vl_logic;
        sreset          : in     vl_logic;
        dataout         : out    vl_logic;
        dfflo           : out    vl_logic;
        dffhi           : out    vl_logic;
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic
    );
end arriaii_ddio_oe;
