library verilog;
use verilog.vl_types.all;
entity apexii_pterm is
    generic(
        operation_mode  : string  := "normal";
        output_mode     : string  := "comb";
        invert_pterm1_mode: string  := "false";
        power_up        : string  := "low"
    );
    port(
        pterm0          : in     vl_logic_vector(31 downto 0);
        pterm1          : in     vl_logic_vector(31 downto 0);
        pexpin          : in     vl_logic;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        aclr            : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dataout         : out    vl_logic;
        pexpout         : out    vl_logic
    );
end apexii_pterm;
