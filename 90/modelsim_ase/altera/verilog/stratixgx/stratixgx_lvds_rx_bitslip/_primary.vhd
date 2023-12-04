library verilog;
use verilog.vl_types.all;
entity stratixgx_lvds_rx_bitslip is
    generic(
        channel_width   : integer := 10
    );
    port(
        coreclk         : in     vl_logic;
        bitslip         : in     vl_logic;
        rxpdat2         : in     vl_logic_vector;
        rxpdat3         : in     vl_logic_vector;
        reset           : in     vl_logic;
        dataout         : out    vl_logic_vector
    );
end stratixgx_lvds_rx_bitslip;
