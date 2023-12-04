library verilog;
use verilog.vl_types.all;
entity arriaii_lvds_tx_parallel_register is
    generic(
        channel_width   : integer := 4
    );
    port(
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        datain          : in     vl_logic_vector;
        dataout         : out    vl_logic_vector;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end arriaii_lvds_tx_parallel_register;
