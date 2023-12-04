library verilog;
use verilog.vl_types.all;
entity apexii_pterm_register is
    generic(
        power_up        : string  := "low"
    );
    port(
        datain          : in     vl_logic;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        aclr            : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        regout          : out    vl_logic;
        fbkout          : out    vl_logic
    );
end apexii_pterm_register;
