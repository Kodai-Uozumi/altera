library verilog;
use verilog.vl_types.all;
entity max_mcell is
    generic(
        operation_mode  : string  := "normal";
        output_mode     : string  := "comb";
        register_mode   : string  := "dff";
        pexp_mode       : string  := "off";
        power_up        : string  := "low"
    );
    port(
        pterm0          : in     vl_logic_vector(51 downto 0);
        pterm1          : in     vl_logic_vector(51 downto 0);
        pterm2          : in     vl_logic_vector(51 downto 0);
        pterm3          : in     vl_logic_vector(51 downto 0);
        pterm4          : in     vl_logic_vector(51 downto 0);
        pterm5          : in     vl_logic_vector(51 downto 0);
        pxor            : in     vl_logic_vector(51 downto 0);
        pexpin          : in     vl_logic;
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        fpin            : in     vl_logic;
        pclk            : in     vl_logic_vector(51 downto 0);
        pena            : in     vl_logic_vector(51 downto 0);
        paclr           : in     vl_logic_vector(51 downto 0);
        papre           : in     vl_logic_vector(51 downto 0);
        dataout         : out    vl_logic;
        pexpout         : out    vl_logic
    );
end max_mcell;
