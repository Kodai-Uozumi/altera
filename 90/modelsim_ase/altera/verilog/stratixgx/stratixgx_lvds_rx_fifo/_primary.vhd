library verilog;
use verilog.vl_types.all;
entity stratixgx_lvds_rx_fifo is
    generic(
        channel_width   : integer := 10
    );
    port(
        wclk            : in     vl_logic;
        rclk            : in     vl_logic;
        reset           : in     vl_logic;
        datain          : in     vl_logic_vector;
        dataout         : out    vl_logic_vector
    );
end stratixgx_lvds_rx_fifo;
