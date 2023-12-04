library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_rcv_detect_fsm is
    generic(
        \RESET\         : integer := 0;
        \WAKE\          : integer := 1;
        \STATE_1\       : integer := 3;
        \STATE_2\       : integer := 5;
        \HOLD\          : integer := 4
    );
    port(
        \CLK\           : in     vl_logic;
        \RESET_N\       : in     vl_logic;
        \COM_PASS\      : in     vl_logic;
        \PROBE_PASS\    : in     vl_logic;
        \DET_ON\        : out    vl_logic;
        \DETECT_VALID\  : out    vl_logic;
        \RCV_FOUND\     : out    vl_logic;
        \TX_DET_RX\     : in     vl_logic;
        \RX_P\          : in     vl_logic;
        \RX_N\          : in     vl_logic
    );
end arriaii_hssi_pma_c_rcv_detect_fsm;
