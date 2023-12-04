library verilog;
use verilog.vl_types.all;
entity dpram_segment is
    generic(
        \Tout\          : integer := 0;
        \Taa\           : integer := 0;
        \Tdd\           : integer := 0;
        \Trc\           : integer := 0;
        \Tra\           : integer := 0
    );
    port(
        \WADDR\         : in     vl_logic_vector(10 downto 0);
        \RADDR\         : in     vl_logic_vector(10 downto 0);
        \D\             : in     vl_logic;
        \WE\            : in     vl_logic;
        \RE\            : in     vl_logic;
        \Q\             : out    vl_logic;
        \INIT_DATA\     : in     vl_logic_vector(2047 downto 0)
    );
end dpram_segment;
