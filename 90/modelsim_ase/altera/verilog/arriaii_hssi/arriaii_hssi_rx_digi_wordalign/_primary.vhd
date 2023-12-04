library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_rx_digi_wordalign is
    port(
        a1a2_k1k2_flag  : out    vl_logic_vector(3 downto 0);
        a1a2_size       : in     vl_logic;
        adata           : out    vl_logic_vector(9 downto 0);
        adata_valid     : out    vl_logic;
        autobytealign_dis: in     vl_logic;
        bitloc_rev_en   : in     vl_logic;
        bitslip         : in     vl_logic;
        byte_rev_en     : in     vl_logic;
        cg_syncpat      : out    vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        comp_pat        : in     vl_logic_vector(39 downto 0);
        comp_pat_porn   : in     vl_logic;
        comp_pat_size   : in     vl_logic_vector(2 downto 0);
        disable_rx_disp : in     vl_logic;
        dwidth          : in     vl_logic;
        encdet_prbs     : in     vl_logic;
        encdt           : in     vl_logic;
        enumber         : in     vl_logic_vector(9 downto 0);
        gen2ngen1       : in     vl_logic;
        gen2ngen1_bundle: in     vl_logic;
        gnumber         : in     vl_logic_vector(9 downto 0);
        ib_invalid_code : in     vl_logic_vector(1 downto 0);
        kchar           : out    vl_logic;
        kcount          : out    vl_logic_vector(9 downto 0);
        knumber         : in     vl_logic_vector(9 downto 0);
        lpbk_en         : in     vl_logic;
        max_rlv_sel     : in     vl_logic_vector(5 downto 0);
        pipe_loose_sync : in     vl_logic;
        pmadwidth       : in     vl_logic_vector(1 downto 0);
        polinv_en       : in     vl_logic;
        prbs_en         : in     vl_logic;
        pudi            : in     vl_logic_vector(19 downto 0);
        pudr            : in     vl_logic_vector(19 downto 0);
        r8b10b_dec_ibm_en: in     vl_logic_vector(1 downto 0);
        rauto_speed_ena : in     vl_logic;
        rbitloc_rev_en  : in     vl_logic;
        rbyte_rev_en    : in     vl_logic;
        rencdt_rising   : in     vl_logic;
        resync_badcg_en : in     vl_logic_vector(1 downto 0);
        rforce_sig_det_pcs: in     vl_logic;
        rfreq_sel       : in     vl_logic;
        rindv_rx        : in     vl_logic;
        rkchar          : in     vl_logic;
        rlv             : out    vl_logic;
        rlv_en          : in     vl_logic;
        rlv_lt          : out    vl_logic;
        rosbased        : in     vl_logic;
        rosnumber       : in     vl_logic_vector(3 downto 0);
        rpolinv_en      : in     vl_logic;
        rrxpcsbypass_en : in     vl_logic;
        rst             : in     vl_logic;
        rst1            : out    vl_logic;
        scan_mode       : in     vl_logic;
        signal_detect   : in     vl_logic;
        signal_detect_rcvdclk: out    vl_logic;
        sudi            : out    vl_logic_vector(31 downto 0);
        sudi_pre        : out    vl_logic_vector(13 downto 0);
        sync_sm_dis     : in     vl_logic;
        sync_status     : out    vl_logic;
        testbus         : out    vl_logic_vector(9 downto 0);
        wa_6g_en        : in     vl_logic;
        wa_boundary     : out    vl_logic_vector(4 downto 0)
    );
end arriaii_hssi_rx_digi_wordalign;
