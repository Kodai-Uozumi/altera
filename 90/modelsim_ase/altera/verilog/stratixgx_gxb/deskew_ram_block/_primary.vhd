library verilog;
use verilog.vl_types.all;
entity deskew_ram_block is
    generic(
        read_access_time: integer := 0;
        write_access_time: integer := 0;
        ram_width       : integer := 14
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        addrwr          : in     vl_logic_vector(15 downto 0);
        addrrd1         : in     vl_logic_vector(15 downto 0);
        addrrd2         : in     vl_logic_vector(15 downto 0);
        datain          : in     vl_logic_vector(13 downto 0);
        we              : in     vl_logic;
        re              : in     vl_logic;
        dataout1        : out    vl_logic_vector(13 downto 0);
        dataout2        : out    vl_logic_vector(13 downto 0)
    );
end deskew_ram_block;
