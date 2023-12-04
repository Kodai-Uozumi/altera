library verilog;
use verilog.vl_types.all;
entity arriagx_mac_out_input_interface is
    generic(
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        datac_width     : integer := 36;
        datad_width     : integer := 36
    );
    port(
        accuma          : in     vl_logic_vector(51 downto 0);
        accumc          : in     vl_logic_vector(51 downto 0);
        dataa           : in     vl_logic_vector(71 downto 0);
        datab           : in     vl_logic_vector(71 downto 0);
        datac           : in     vl_logic_vector(71 downto 0);
        datad           : in     vl_logic_vector(71 downto 0);
        sign            : in     vl_logic;
        multabsaturate  : in     vl_logic;
        multcdsaturate  : in     vl_logic;
        zeroacc         : in     vl_logic;
        zeroacc1        : in     vl_logic;
        operation       : in     vl_logic_vector(3 downto 0);
        outa            : out    vl_logic_vector(71 downto 0);
        outb            : out    vl_logic_vector(71 downto 0);
        outc            : out    vl_logic_vector(71 downto 0);
        outd            : out    vl_logic_vector(71 downto 0);
        sata            : out    vl_logic;
        satb            : out    vl_logic;
        satc            : out    vl_logic;
        satd            : out    vl_logic;
        satab           : out    vl_logic;
        satcd           : out    vl_logic
    );
end arriagx_mac_out_input_interface;
