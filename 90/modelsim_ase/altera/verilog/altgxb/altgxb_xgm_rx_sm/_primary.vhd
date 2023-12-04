library verilog;
use verilog.vl_types.all;
entity altgxb_xgm_rx_sm is
    port(
        resetall        : in     vl_logic;
        rxclk           : in     vl_logic;
        rxctrl          : in     vl_logic_vector(3 downto 0);
        rxctrlout       : out    vl_logic_vector(3 downto 0);
        rxdatain        : in     vl_logic_vector(31 downto 0);
        rxdataout       : out    vl_logic_vector(31 downto 0);
        rxdatavalid     : in     vl_logic_vector(3 downto 0);
        rxrunningdisp   : in     vl_logic_vector(3 downto 0)
    );
end altgxb_xgm_rx_sm;
