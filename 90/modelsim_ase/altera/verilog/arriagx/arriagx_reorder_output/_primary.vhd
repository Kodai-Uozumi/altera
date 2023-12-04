library verilog;
use verilog.vl_types.all;
entity arriagx_reorder_output is
    generic(
        operation_mode  : string  := "dynamic"
    );
    port(
        datain          : in     vl_logic_vector(143 downto 0);
        addnsub         : in     vl_logic;
        operation       : in     vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector(143 downto 0)
    );
end arriagx_reorder_output;
