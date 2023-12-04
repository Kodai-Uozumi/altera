library verilog;
use verilog.vl_types.all;
entity stratixii_mac_out_output_interface is
    port(
        dataa           : in     vl_logic_vector(35 downto 0);
        datab           : in     vl_logic_vector(35 downto 0);
        datac           : in     vl_logic_vector(35 downto 0);
        datad           : in     vl_logic_vector(35 downto 0);
        datar           : in     vl_logic_vector(71 downto 0);
        datas           : in     vl_logic_vector(71 downto 0);
        datat           : in     vl_logic_vector(71 downto 0);
        data_36_mult    : in     vl_logic_vector(71 downto 0);
        sata            : in     vl_logic;
        satb            : in     vl_logic;
        satc            : in     vl_logic;
        satd            : in     vl_logic;
        satab           : in     vl_logic;
        satcd           : in     vl_logic;
        satr            : in     vl_logic;
        sats            : in     vl_logic;
        multabsaturate  : in     vl_logic;
        multcdsaturate  : in     vl_logic;
        saturate0       : in     vl_logic;
        saturate1       : in     vl_logic;
        overflowr       : in     vl_logic;
        overflows       : in     vl_logic;
        operation       : in     vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector(143 downto 0);
        accoverflow     : out    vl_logic
    );
end stratixii_mac_out_output_interface;
