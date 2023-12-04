library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_rx_pcs_channel_testbus is
    port(
        chnl_test_bus_out: out    vl_logic_vector(9 downto 0);
        rtest_bus_sel   : in     vl_logic_vector(2 downto 0);
        test_bus_in0    : in     vl_logic_vector(9 downto 0);
        test_bus_in1    : in     vl_logic_vector(9 downto 0);
        test_bus_in2    : in     vl_logic_vector(9 downto 0);
        test_bus_in3    : in     vl_logic_vector(9 downto 0);
        test_bus_in4    : in     vl_logic_vector(9 downto 0);
        test_bus_in5    : in     vl_logic_vector(9 downto 0);
        test_bus_in6    : in     vl_logic_vector(9 downto 0);
        test_bus_in7    : in     vl_logic_vector(9 downto 0)
    );
end stratixiigx_hssi_rx_pcs_channel_testbus;
