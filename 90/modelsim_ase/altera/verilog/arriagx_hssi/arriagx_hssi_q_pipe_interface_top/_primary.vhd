library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_q_pipe_interface_top is
    port(
        pipe_tx_clk     : in     vl_logic;
        pipe_rx_clk     : in     vl_logic;
        refclk_b        : in     vl_logic;
        tx_pipe_reset   : in     vl_logic;
        rx_pipe_reset   : in     vl_logic;
        refclk_b_reset  : in     vl_logic;
        rtx_pipe_enable : in     vl_logic;
        rrx_pipe_enable : in     vl_logic;
        rrdwidth_rx     : in     vl_logic;
        rtx_elec_idle_delay: in     vl_logic_vector(1 downto 0);
        rrx_detect_bypass: in     vl_logic;
        rclkcmpinsertpad: in     vl_logic;
        rphystatus_rst_toggle: in     vl_logic;
        txdetectrxloopback: in     vl_logic;
        txelecidle      : in     vl_logic;
        txcompliance    : in     vl_logic;
        powerdown       : in     vl_logic_vector(1 downto 0);
        txd_ch          : in     vl_logic_vector(43 downto 0);
        rxpolarity      : in     vl_logic;
        rxvalid         : out    vl_logic;
        rxelecidle      : out    vl_logic;
        rxstatus        : out    vl_logic_vector(2 downto 0);
        rxd_ch          : out    vl_logic_vector(63 downto 0);
        phystatus       : out    vl_logic;
        revloopback     : in     vl_logic;
        polinv_rx       : in     vl_logic;
        txd             : out    vl_logic_vector(43 downto 0);
        rev_loopbk      : out    vl_logic;
        tx_elec_idle_comp: in     vl_logic;
        rxd             : in     vl_logic_vector(63 downto 0);
        polinv_rx_int   : out    vl_logic;
        tx_elec_idle    : out    vl_logic;
        txdetectrx      : out    vl_logic;
        powerstate      : out    vl_logic_vector(3 downto 0);
        txbeacon        : out    vl_logic;
        rx_found        : in     vl_logic;
        rx_detect_valid : in     vl_logic;
        rxelectricalidle: in     vl_logic;
        rxbeacon        : in     vl_logic;
        txdetectrxin    : in     vl_logic;
        powerstatein    : in     vl_logic_vector(3 downto 0);
        use_powerstatein: in     vl_logic;
        power_state_transition_done: in     vl_logic;
        power_state_transition_done_ena: in     vl_logic
    );
end arriagx_hssi_q_pipe_interface_top;
