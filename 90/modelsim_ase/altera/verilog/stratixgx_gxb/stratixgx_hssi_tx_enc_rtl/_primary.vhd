library verilog;
use verilog.vl_types.all;
entity stratixgx_hssi_tx_enc_rtl is
    port(
        \ENDEC\         : in     vl_logic;
        \GE_XAUI_SEL\   : in     vl_logic;
        \IB_FORCE_DISPARITY\: in     vl_logic;
        \INDV\          : in     vl_logic;
        prbs_en         : in     vl_logic;
        \PUDR\          : out    vl_logic_vector(9 downto 0);
        soft_reset      : in     vl_logic;
        tx_clk          : in     vl_logic;
        tx_ctl_tc       : in     vl_logic;
        tx_ctl_ts       : in     vl_logic;
        tx_data_9_tc    : in     vl_logic;
        tx_data_pg      : in     vl_logic_vector(9 downto 0);
        tx_data_tc      : in     vl_logic_vector(7 downto 0);
        tx_data_ts      : in     vl_logic_vector(7 downto 0);
        \TXLP10B\       : out    vl_logic_vector(9 downto 0)
    );
end stratixgx_hssi_tx_enc_rtl;
