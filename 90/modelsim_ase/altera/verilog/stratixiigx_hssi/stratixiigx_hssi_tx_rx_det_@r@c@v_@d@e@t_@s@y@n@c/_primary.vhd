library verilog;
use verilog.vl_types.all;
entity \stratixiigx_hssi_tx_rx_det_RCV_DET_SYNC\ is
    port(
        \CLK\           : in     vl_logic;
        \RESET_N\       : in     vl_logic;
        \RCV_DET\       : in     vl_logic;
        \RCV_DET_OUT\   : out    vl_logic
    );
end \stratixiigx_hssi_tx_rx_det_RCV_DET_SYNC\;
