library verilog;
use verilog.vl_types.all;
entity stratixiigx_mac_rs_block is
    generic(
        block_type      : string  := "mac_mult";
        dataa_width     : integer := 18;
        datab_width     : integer := 18
    );
    port(
        operation       : in     vl_logic_vector(3 downto 0);
        round           : in     vl_logic;
        saturate        : in     vl_logic;
        addnsub         : in     vl_logic;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        signsize        : in     vl_logic_vector(5 downto 0);
        roundsize       : in     vl_logic_vector(7 downto 0);
        dataoutsize     : in     vl_logic_vector(7 downto 0);
        dataa           : in     vl_logic_vector(71 downto 0);
        datab           : in     vl_logic_vector(71 downto 0);
        datain          : in     vl_logic_vector(71 downto 0);
        dataout         : out    vl_logic_vector(71 downto 0)
    );
end stratixiigx_mac_rs_block;
