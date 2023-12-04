library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_rx_rxclk_ctl is
    port(
        pld_rx_clk      : in     vl_logic;
        rcvd_clk_pma    : in     vl_logic;
        rcvd_clk0_pma   : in     vl_logic;
        tx_pma_clk      : in     vl_logic;
        refclk_pma      : in     vl_logic;
        rxrst           : in     vl_logic;
        rindv_rx        : in     vl_logic;
        rx_div2_sync_in_ch0: in     vl_logic;
        rx_div2_sync_in_q0_ch0: in     vl_logic;
        rdwidth_rx      : in     vl_logic;
        rfreerun_rx     : in     vl_logic;
        scan_mode       : in     vl_logic;
        rphfifo_master_sel_rx: in     vl_logic;
        rrcvd_clk_sel   : in     vl_logic_vector(1 downto 0);
        rclk_1_sel      : in     vl_logic_vector(1 downto 0);
        rclk_2_sel      : in     vl_logic_vector(1 downto 0);
        rrx_rd_clk_sel  : in     vl_logic;
        clk_1_b         : out    vl_logic;
        clk_2_b         : out    vl_logic;
        rx_rd_clk       : out    vl_logic;
        rx_wr_clk       : out    vl_logic;
        rx_clk          : out    vl_logic;
        rcvd_clk        : out    vl_logic;
        rcvd_clk_pma_b  : out    vl_logic;
        rx_div2_sync_out: out    vl_logic
    );
end stratixiigx_hssi_rx_rxclk_ctl;
