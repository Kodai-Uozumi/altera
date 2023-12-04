library verilog;
use verilog.vl_types.all;
entity stratixgx_lvds_rx_fifo_sync_ram is
    generic(
        ram_width       : integer := 10
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic_vector;
        reset           : in     vl_logic;
        waddr           : in     vl_logic_vector(1 downto 0);
        raddr           : in     vl_logic_vector(1 downto 0);
        we              : in     vl_logic;
        dataout         : out    vl_logic_vector
    );
end stratixgx_lvds_rx_fifo_sync_ram;
