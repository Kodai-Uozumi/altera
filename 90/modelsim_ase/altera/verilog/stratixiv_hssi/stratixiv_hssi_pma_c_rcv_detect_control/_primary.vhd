library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_rcv_detect_control is
    port(
        \CLK\           : in     vl_logic;
        \RCV_DET_EN\    : in     vl_logic;
        \RCV_DET_PDB\   : in     vl_logic;
        \COM_PASS\      : in     vl_logic;
        \PROBE_PASS\    : in     vl_logic;
        \DET_ON\        : out    vl_logic;
        \DETECT_VALID\  : out    vl_logic;
        \RCV_FOUND\     : out    vl_logic;
        \RX_P\          : in     vl_logic;
        \RX_N\          : in     vl_logic
    );
end stratixiv_hssi_pma_c_rcv_detect_control;
