library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_tx is
    port(
        atb0            : inout  vl_logic;
        atb1            : inout  vl_logic;
        bsmode          : in     vl_logic;
        bsoeb           : in     vl_logic;
        bstxn_in        : in     vl_logic;
        bstxp_in        : in     vl_logic;
        cgb_vccelxqyx   : in     vl_logic;
        cgb_vssexqyx    : in     vl_logic;
        com_pass        : out    vl_logic;
        detect_on       : out    vl_logic;
        fixed_clk_out   : out    vl_logic;
        ib50uc_rcvdt    : inout  vl_logic;
        ib50uc_vcm      : inout  vl_logic;
        ib50ut_vcm      : inout  vl_logic;
        ib100uc         : inout  vl_logic;
        lst             : in     vl_logic_vector(3 downto 0);
        pdb             : in     vl_logic;
        probe_pass      : out    vl_logic;
        r_dft_sel       : in     vl_logic_vector(2 downto 0);
        r_dis_idlegate  : in     vl_logic;
        r_highv         : in     vl_logic;
        r_lowv          : in     vl_logic;
        r_rx_det        : in     vl_logic_vector(1 downto 0);
        r_slew          : in     vl_logic_vector(1 downto 0);
        rlpbkn          : in     vl_logic;
        rlpbkn_em       : in     vl_logic;
        rlpbkp          : in     vl_logic;
        rlpbkp_em       : in     vl_logic;
        rpre_em_1t      : in     vl_logic_vector(4 downto 0);
        rpre_em_2t      : in     vl_logic_vector(3 downto 0);
        rpre_em_pt      : in     vl_logic_vector(3 downto 0);
        rsig_inv_2t     : in     vl_logic;
        rsig_inv_ptap   : in     vl_logic;
        rterm_sel       : in     vl_logic_vector(2 downto 0);
        rtx_rlpbk       : in     vl_logic;
        rtx_vtt         : in     vl_logic_vector(1 downto 0);
        rvod_sel        : in     vl_logic_vector(2 downto 0);
        rx_det_clk      : in     vl_logic;
        rx_det_pdb      : in     vl_logic;
        rx_detect_valid : out    vl_logic;
        rx_found        : out    vl_logic;
        sel_150r        : out    vl_logic;
        tx50            : in     vl_logic_vector(3 downto 0);
        tx_det_rx       : in     vl_logic;
        tx_dftout       : out    vl_logic_vector(6 downto 1);
        tx_elec_idl     : in     vl_logic;
        vccehtxqyx      : in     vl_logic;
        vccehxqyx       : in     vl_logic;
        vccesdh_la      : in     vl_logic;
        vccesdp_la      : in     vl_logic;
        vccetxqyx       : in     vl_logic;
        vin             : in     vl_logic;
        vin_po1         : in     vl_logic;
        vin_po2         : in     vl_logic;
        vin_pre         : in     vl_logic;
        vip             : in     vl_logic;
        vip_po1         : in     vl_logic;
        vip_po2         : in     vl_logic;
        vip_pre         : in     vl_logic;
        von             : out    vl_logic;
        vop             : out    vl_logic;
        vssexqyx        : in     vl_logic;
        rx_p            : in     vl_logic;
        rx_n            : in     vl_logic
    );
end arriaii_hssi_pma_c_tx;
