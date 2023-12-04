library verilog;
use verilog.vl_types.all;
entity hardcopyiii_lvds_rx_fifo is
    generic(
        channel_width   : integer := 10
    );
    port(
        wclk            : in     vl_logic;
        rclk            : in     vl_logic;
        dparst          : in     vl_logic;
        fiforst         : in     vl_logic;
        datain          : in     vl_logic;
        dataout         : out    vl_logic
    );
end hardcopyiii_lvds_rx_fifo;
