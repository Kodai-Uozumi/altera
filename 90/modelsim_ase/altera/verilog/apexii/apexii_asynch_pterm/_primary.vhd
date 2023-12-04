library verilog;
use verilog.vl_types.all;
entity apexii_asynch_pterm is
    generic(
        operation_mode  : string  := "normal";
        invert_pterm1_mode: string  := "false"
    );
    port(
        pterm0          : in     vl_logic_vector(31 downto 0);
        pterm1          : in     vl_logic_vector(31 downto 0);
        pexpin          : in     vl_logic;
        fbkin           : in     vl_logic;
        combout         : out    vl_logic;
        pexpout         : out    vl_logic;
        regin           : out    vl_logic
    );
end apexii_asynch_pterm;
