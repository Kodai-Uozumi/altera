library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_tx_clkmux_cmu is
    generic(
        \DELAY\         : integer := 1
    );
    port(
        cpulse          : out    vl_logic;
        cpulse_ht       : in     vl_logic;
        cpulse_x1       : in     vl_logic;
        cpulse_x4       : in     vl_logic;
        cpulse_xn_b     : in     vl_logic;
        cpulse_xn_t     : in     vl_logic;
        delay_sel       : in     vl_logic;
        hfclk_n         : out    vl_logic;
        hfclk_p         : out    vl_logic;
        hfclkn_ht       : in     vl_logic;
        hfclkn_x1       : in     vl_logic;
        hfclkn_x4       : in     vl_logic;
        hfclkn_xn_b     : in     vl_logic;
        hfclkn_xn_t     : in     vl_logic;
        hfclkp_ht       : in     vl_logic;
        hfclkp_x1       : in     vl_logic;
        hfclkp_x4       : in     vl_logic;
        hfclkp_xn_b     : in     vl_logic;
        hfclkp_xn_t     : in     vl_logic;
        ht_sel          : in     vl_logic;
        lfclk_n         : out    vl_logic;
        lfclk_p         : out    vl_logic;
        lfclkn_ht       : in     vl_logic;
        lfclkn_x1       : in     vl_logic;
        lfclkn_x4       : in     vl_logic;
        lfclkn_xn_b     : in     vl_logic;
        lfclkn_xn_t     : in     vl_logic;
        lfclkp_ht       : in     vl_logic;
        lfclkp_x1       : in     vl_logic;
        lfclkp_x4       : in     vl_logic;
        lfclkp_xn_b     : in     vl_logic;
        lfclkp_xn_t     : in     vl_logic;
        pdb             : in     vl_logic;
        sel             : in     vl_logic_vector(1 downto 0);
        vccelxqyx       : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end stratixiv_hssi_pma_c_tx_clkmux_cmu;
