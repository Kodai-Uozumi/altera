library verilog;
use verilog.vl_types.all;
entity rom_segment is
    generic(
        \Tout\          : integer := 0;
        \Taa\           : integer := 0;
        \Trc\           : integer := 0
    );
    port(
        \A\             : in     vl_logic_vector(10 downto 0);
        \D\             : in     vl_logic;
        \WE\            : in     vl_logic;
        \Q\             : out    vl_logic;
        \INIT_DATA\     : in     vl_logic_vector(2047 downto 0)
    );
end rom_segment;
