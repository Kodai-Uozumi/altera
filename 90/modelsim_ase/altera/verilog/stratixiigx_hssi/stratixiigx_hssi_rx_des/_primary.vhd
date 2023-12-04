library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_rx_des is
    port(
        datain          : in     vl_logic;
        rdoublewidth    : in     vl_logic;
        rdwidth         : in     vl_logic;
        reset           : in     vl_logic;
        serialclk       : in     vl_logic;
        serialfdbken    : in     vl_logic;
        serialfdbkin    : in     vl_logic;
        paralleldataout : out    vl_logic_vector(19 downto 0);
        recvclkout      : out    vl_logic
    );
end stratixiigx_hssi_rx_des;
