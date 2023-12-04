library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_tx_rx_det is
    generic(
        \RX_EXIST\      : integer := 1
    );
    port(
        \RX_DET_PDB\    : in     vl_logic;
        \CLK15M\        : in     vl_logic;
        \TX_DET_RX\     : in     vl_logic;
        \RX_FOUND\      : out    vl_logic;
        \RX_DET_VALID\  : out    vl_logic
    );
end stratixiigx_hssi_tx_rx_det;
