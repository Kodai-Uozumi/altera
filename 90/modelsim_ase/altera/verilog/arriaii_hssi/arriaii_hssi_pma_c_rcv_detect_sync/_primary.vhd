library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_rcv_detect_sync is
    port(
        \CLK\           : in     vl_logic;
        \RESET_N\       : in     vl_logic;
        \RCV_DET\       : in     vl_logic;
        \RCV_DET_OUT\   : out    vl_logic
    );
end arriaii_hssi_pma_c_rcv_detect_sync;
