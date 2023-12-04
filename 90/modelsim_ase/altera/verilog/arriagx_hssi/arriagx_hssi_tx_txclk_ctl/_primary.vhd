library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_tx_txclk_ctl is
    port(
        txrst           : in     vl_logic;
        pld_tx_clk      : in     vl_logic;
        refclk_pma      : in     vl_logic;
        txpma_local_clk : in     vl_logic;
        tx_div2_sync_in_ch0: in     vl_logic;
        tx_div2_sync_in_q0_ch0: in     vl_logic;
        rindv_tx        : in     vl_logic;
        rtxwrclksel     : in     vl_logic;
        rtxrdclksel     : in     vl_logic;
        rdwidth_tx      : in     vl_logic;
        rfreerun_tx     : in     vl_logic;
        rphfifo_master_sel_tx: in     vl_logic;
        scan_mode       : in     vl_logic;
        tx_clk_out      : out    vl_logic;
        tx_div2_sync_out: out    vl_logic;
        wr_clk_pos      : out    vl_logic;
        fifo_rd_clk     : out    vl_logic;
        refclk_b        : out    vl_logic
    );
end arriagx_hssi_tx_txclk_ctl;
