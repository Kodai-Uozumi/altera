library verilog;
use verilog.vl_types.all;
entity hardcopyii_lvds_rx_fifo_sync_ram is
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic;
        write_reset     : in     vl_logic;
        waddr           : in     vl_logic_vector(2 downto 0);
        raddr           : in     vl_logic_vector(2 downto 0);
        we              : in     vl_logic;
        dataout         : out    vl_logic
    );
end hardcopyii_lvds_rx_fifo_sync_ram;