library verilog;
use verilog.vl_types.all;
entity stratixiigx_reorder_output is
    generic(
        operation_mode  : string  := "dynamic"
    );
    port(
        datain          : in     vl_logic_vector(143 downto 0);
        addnsub         : in     vl_logic;
        operation       : in     vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector(143 downto 0)
    );
end stratixiigx_reorder_output;
