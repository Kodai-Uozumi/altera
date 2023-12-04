library verilog;
use verilog.vl_types.all;
entity altgxb_hssi_rx_wal_rtl is
    port(
        \A1A2_SIZE\     : in     vl_logic;
        \AUTOBYTEALIGN_DIS\: in     vl_logic;
        \BITSLIP\       : in     vl_logic;
        cg_comma        : out    vl_logic;
        \DISABLE_RX_DISP\: in     vl_logic;
        \DWIDTH\        : in     vl_logic;
        encdet_prbs     : in     vl_logic;
        \ENCDT\         : in     vl_logic;
        \GE_XAUI_SEL\   : in     vl_logic;
        \IB_INVALID_CODE\: in     vl_logic_vector(1 downto 0);
        \LP10BEN\       : in     vl_logic;
        \PMADATAWIDTH\  : in     vl_logic;
        prbs_en         : in     vl_logic;
        \PUDI\          : in     vl_logic_vector(9 downto 0);
        \PUDR\          : in     vl_logic_vector(9 downto 0);
        rcvd_clk        : in     vl_logic;
        \RLV\           : out    vl_logic;
        \RLV_EN\        : in     vl_logic;
        \RLV_lt\        : out    vl_logic;
        \RUNDISP_SEL\   : in     vl_logic_vector(4 downto 0);
        signal_detect   : in     vl_logic;
        signal_detect_sync: out    vl_logic;
        soft_reset      : in     vl_logic;
        \SUDI\          : out    vl_logic_vector(12 downto 0);
        \SUDI_pre\      : out    vl_logic_vector(9 downto 0);
        \SYNC_COMP_PAT\ : in     vl_logic_vector(15 downto 0);
        \SYNC_COMP_SIZE\: in     vl_logic_vector(1 downto 0);
        sync_curr_st    : out    vl_logic_vector(3 downto 0);
        \SYNC_SM_DIS\   : in     vl_logic;
        sync_status     : out    vl_logic
    );
end altgxb_hssi_rx_wal_rtl;
