library verilog;
use verilog.vl_types.all;
entity max_mcell_register is
    generic(
        operation_mode  : string  := "normal";
        power_up        : string  := "low";
        register_mode   : string  := "dff"
    );
    port(
        datain          : in     vl_logic;
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        pclk            : in     vl_logic_vector(51 downto 0);
        pena            : in     vl_logic_vector(51 downto 0);
        paclr           : in     vl_logic_vector(51 downto 0);
        papre           : in     vl_logic_vector(51 downto 0);
        regout          : out    vl_logic;
        fbkout          : out    vl_logic
    );
end max_mcell_register;
