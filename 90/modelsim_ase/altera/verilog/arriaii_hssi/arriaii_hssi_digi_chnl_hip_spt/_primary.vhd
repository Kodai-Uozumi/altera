library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_digi_chnl_hip_spt is
    port(
        rhip_ena        : in     vl_logic;
        pcs_rxd_ch      : in     vl_logic_vector(8 downto 0);
        pcs_rxvalid     : in     vl_logic;
        pcs_rxelecidle  : in     vl_logic;
        pcs_rxstatus_ch : in     vl_logic_vector(2 downto 0);
        pcs_phystatus   : in     vl_logic;
        txpma_local_clk : in     vl_logic;
        txd_ch          : in     vl_logic_vector(10 downto 0);
        hip_txd_ch      : in     vl_logic_vector(9 downto 0);
        txdetectrxloopback: in     vl_logic;
        hip_txdetectrxloopback: in     vl_logic;
        rxpolarity      : in     vl_logic;
        hip_rxpolarity  : in     vl_logic;
        powerdown_ch    : in     vl_logic_vector(1 downto 0);
        hip_powerdown_ch: in     vl_logic_vector(1 downto 0);
        txdeemph        : in     vl_logic;
        hip_txdeemph    : in     vl_logic;
        txmargin_ch     : in     vl_logic_vector(2 downto 0);
        hip_txmargin_ch : in     vl_logic_vector(2 downto 0);
        eidleinfersel_ch: in     vl_logic_vector(2 downto 0);
        hip_eidleinfersel_ch: in     vl_logic_vector(2 downto 0);
        rate            : in     vl_logic;
        hip_rate        : in     vl_logic;
        hip_txelecidle  : in     vl_logic;
        rxd_ch          : out    vl_logic_vector(8 downto 0);
        hip_rxd_ch      : out    vl_logic_vector(8 downto 0);
        rxvalid         : out    vl_logic;
        hip_rxvalid     : out    vl_logic;
        rxelecidle      : out    vl_logic;
        hip_rxelecidle  : out    vl_logic;
        rxstatus_ch     : out    vl_logic_vector(2 downto 0);
        hip_rxstatus_ch : out    vl_logic_vector(2 downto 0);
        phystatus       : out    vl_logic;
        hip_phystatus   : out    vl_logic;
        hip_tx_clk      : out    vl_logic;
        pcs_txd_ch      : out    vl_logic_vector(10 downto 0);
        pcs_txdetectrxloopback: out    vl_logic;
        pcs_rxpolarity  : out    vl_logic;
        pcs_powerdown_ch: out    vl_logic_vector(1 downto 0);
        pcs_txdeemph    : out    vl_logic;
        pcs_txmargin_ch : out    vl_logic_vector(2 downto 0);
        pcs_eidleinfersel_ch: out    vl_logic_vector(2 downto 0);
        pcs_rate        : out    vl_logic
    );
end arriaii_hssi_digi_chnl_hip_spt;
