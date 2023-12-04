library verilog;
use verilog.vl_types.all;
entity stratixgx_lvds_rx_deserializer is
    generic(
        channel_width   : integer := 10
    );
    port(
        clk0            : in     vl_logic;
        coreclk         : in     vl_logic;
        datain          : in     vl_logic;
        reset           : in     vl_logic;
        dataout         : out    vl_logic_vector;
        pclk            : out    vl_logic
    );
end stratixgx_lvds_rx_deserializer;
