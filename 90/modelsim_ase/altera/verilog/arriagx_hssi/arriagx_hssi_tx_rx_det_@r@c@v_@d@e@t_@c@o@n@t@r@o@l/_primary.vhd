library verilog;
use verilog.vl_types.all;
entity \arriagx_hssi_tx_rx_det_RCV_DET_CONTROL\ is
    port(
        \CLK\           : in     vl_logic;
        \RCV_DET_EN\    : in     vl_logic;
        \RCV_DET_PDB\   : in     vl_logic;
        \COM_PASS\      : in     vl_logic;
        \PROBE_PASS\    : in     vl_logic;
        \DET_ON\        : out    vl_logic;
        \DETECT_VALID\  : out    vl_logic;
        \RCV_FOUND\     : out    vl_logic
    );
end \arriagx_hssi_tx_rx_det_RCV_DET_CONTROL\;
