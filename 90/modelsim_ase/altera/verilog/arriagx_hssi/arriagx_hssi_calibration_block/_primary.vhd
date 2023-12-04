library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_calibration_block is
    generic(
        use_continuous_calibration_mode: string  := "false";
        rx_calibration_write_test_value: integer := 0;
        tx_calibration_write_test_value: integer := 0;
        enable_rx_calibration_test_write: string  := "false";
        enable_tx_calibration_test_write: string  := "false";
        send_rx_calibration_status: string  := "true"
    );
    port(
        clk             : in     vl_logic;
        powerdn         : in     vl_logic;
        enabletestbus   : in     vl_logic;
        calibrationstatus: out    vl_logic_vector(4 downto 0)
    );
end arriagx_hssi_calibration_block;
