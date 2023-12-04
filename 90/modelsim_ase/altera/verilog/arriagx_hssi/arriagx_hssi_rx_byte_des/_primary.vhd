library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_rx_byte_des is
    port(
        soft_reset      : in     vl_logic;
        clk_2           : in     vl_logic;
        rx_we_out       : in     vl_logic;
        rdwidth         : in     vl_logic;
        rx_wr_clk       : in     vl_logic;
        soft_reset_wclk1: in     vl_logic;
        bo_en           : in     vl_logic;
        bo_3g_en        : in     vl_logic;
        rx_data_int     : in     vl_logic_vector(19 downto 0);
        sync_resync_d   : in     vl_logic_vector(1 downto 0);
        disp_err_d      : in     vl_logic_vector(1 downto 0);
        pattern_det_d   : in     vl_logic_vector(1 downto 0);
        ovr_undflow_d   : in     vl_logic_vector(3 downto 0);
        disp_val_d      : in     vl_logic_vector(1 downto 0);
        byte_des_fifo_data_in: out    vl_logic_vector(63 downto 0);
        byte_des_bo_3g_start: out    vl_logic_vector(1 downto 0)
    );
end arriagx_hssi_rx_byte_des;
