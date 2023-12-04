library verilog;
use verilog.vl_types.all;
entity \stratixiigx_hssi_tx_rx_det_CLK_GEN\ is
    port(
        \CLK\           : in     vl_logic;
        \RESET_N\       : in     vl_logic;
        \CLKOUT\        : out    vl_logic
    );
end \stratixiigx_hssi_tx_rx_det_CLK_GEN\;
