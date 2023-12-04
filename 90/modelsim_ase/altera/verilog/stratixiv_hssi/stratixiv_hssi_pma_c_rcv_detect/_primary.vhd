library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_rcv_detect is
    port(
        com_pass        : out    vl_logic;
        detect_on       : out    vl_logic;
        fixed_clk_out   : out    vl_logic;
        probe_pass      : out    vl_logic;
        rcv_det_pdb     : in     vl_logic;
        rdet            : in     vl_logic_vector(1 downto 0);
        rx_det_clk      : in     vl_logic;
        rx_det_valid    : out    vl_logic;
        rx_found        : out    vl_logic;
        sel_150r        : out    vl_logic;
        tx_det_rx       : in     vl_logic;
        rx_n            : in     vl_logic;
        rx_p            : in     vl_logic
    );
end stratixiv_hssi_pma_c_rcv_detect;
