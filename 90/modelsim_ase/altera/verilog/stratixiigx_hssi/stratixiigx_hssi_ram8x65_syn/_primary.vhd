library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_ram8x65_syn is
    generic(
        read_access_time: integer := 0;
        write_access_time: integer := 0;
        ram_width       : integer := 65
    );
    port(
        rst_l           : in     vl_logic;
        clk             : in     vl_logic;
        fifo_wr         : in     vl_logic_vector(7 downto 0);
        data_in         : in     vl_logic_vector(64 downto 0);
        fifo_re         : in     vl_logic_vector(7 downto 0);
        data_out        : out    vl_logic_vector(64 downto 0)
    );
end stratixiigx_hssi_ram8x65_syn;
