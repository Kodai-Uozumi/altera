library verilog;
use verilog.vl_types.all;
entity max_asynch_mcell is
    generic(
        operation_mode  : string  := "normal";
        pexp_mode       : string  := "off";
        register_mode   : string  := "dff"
    );
    port(
        pterm0          : in     vl_logic_vector(51 downto 0);
        pterm1          : in     vl_logic_vector(51 downto 0);
        pterm2          : in     vl_logic_vector(51 downto 0);
        pterm3          : in     vl_logic_vector(51 downto 0);
        pterm4          : in     vl_logic_vector(51 downto 0);
        pterm5          : in     vl_logic_vector(51 downto 0);
        fpin            : in     vl_logic;
        pxor            : in     vl_logic_vector(51 downto 0);
        pexpin          : in     vl_logic;
        fbkin           : in     vl_logic;
        combout         : out    vl_logic;
        pexpout         : out    vl_logic;
        regin           : out    vl_logic
    );
end max_asynch_mcell;
