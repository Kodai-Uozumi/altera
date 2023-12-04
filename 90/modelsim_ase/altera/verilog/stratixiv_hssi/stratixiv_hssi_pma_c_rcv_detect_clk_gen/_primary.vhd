library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_rcv_detect_clk_gen is
    port(
        \CLK\           : in     vl_logic;
        \RESET_N\       : in     vl_logic;
        \CLKOUT\        : out    vl_logic
    );
end stratixiv_hssi_pma_c_rcv_detect_clk_gen;
