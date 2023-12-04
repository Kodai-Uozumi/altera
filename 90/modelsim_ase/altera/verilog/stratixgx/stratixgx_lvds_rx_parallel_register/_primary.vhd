library verilog;
use verilog.vl_types.all;
entity stratixgx_lvds_rx_parallel_register is
    generic(
        channel_width   : integer := 4
    );
    port(
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        datain          : in     vl_logic_vector;
        dataout         : out    vl_logic_vector;
        reset           : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end stratixgx_lvds_rx_parallel_register;
