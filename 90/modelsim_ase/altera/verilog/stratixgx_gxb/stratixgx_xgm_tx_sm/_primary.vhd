library verilog;
use verilog.vl_types.all;
entity stratixgx_xgm_tx_sm is
    port(
        rdenablesync    : in     vl_logic;
        resetall        : in     vl_logic;
        txclk           : in     vl_logic;
        txctrl          : in     vl_logic_vector(3 downto 0);
        txctrlout       : out    vl_logic_vector(3 downto 0);
        txdatain        : in     vl_logic_vector(31 downto 0);
        txdataout       : out    vl_logic_vector(31 downto 0)
    );
end stratixgx_xgm_tx_sm;
