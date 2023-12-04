library verilog;
use verilog.vl_types.all;
entity stratixiigx_lvds_rx_deser is
    generic(
        channel_width   : integer := 10
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dataout         : out    vl_logic_vector
    );
end stratixiigx_lvds_rx_deser;
