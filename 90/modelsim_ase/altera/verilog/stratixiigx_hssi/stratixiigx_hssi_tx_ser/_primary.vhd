library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_tx_ser is
    port(
        serialclk       : in     vl_logic;
        parallelclk     : in     vl_logic;
        datain          : in     vl_logic_vector(19 downto 0);
        reset           : in     vl_logic;
        elecreset       : in     vl_logic;
        rseriallpbkdatain: in     vl_logic;
        rseriallpbkctrl : in     vl_logic;
        rdwidth         : in     vl_logic;
        rdoublewidth    : in     vl_logic;
        serialdataout   : out    vl_logic;
        seriallpbkdataout: out    vl_logic;
        clkout          : out    vl_logic
    );
end stratixiigx_hssi_tx_ser;
