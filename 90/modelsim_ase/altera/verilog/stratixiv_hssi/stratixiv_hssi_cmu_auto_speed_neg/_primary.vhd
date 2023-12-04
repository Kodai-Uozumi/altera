library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_cmu_auto_speed_neg is
    generic(
        \WAIT_RATE_CHANGE\: integer := 0;
        \WAIT_FOR_PHFIFO\: integer := 1;
        \DISABLE_PC_BYTE\: integer := 2;
        \SET_CONFIG_SEL\: integer := 3;
        \WAIT_GEN2NGEN1_CHANGE\: integer := 4;
        \WAIT_PMA_DONE_CNTR\: integer := 5;
        \DEASSERT_PC_PTR_RESET\: integer := 6;
        \WAIT_DEASSERT_RST_CNTR\: integer := 7;
        \ENABLE_PC_BYTE\: integer := 8;
        \WAIT_ENABLE_CNTR\: integer := 9;
        \SPEED_CHANGE_DONE\: integer := 10
    );
    port(
        refclk          : in     vl_logic;
        rxpcs_rst_int   : in     vl_logic;
        rate            : in     vl_logic;
        gen2ngen1       : in     vl_logic;
        config_sel_centrl: in     vl_logic;
        config_sel_quad_up: in     vl_logic;
        config_sel_quad_down: in     vl_logic;
        rindv_rx        : in     vl_logic;
        rmaster_rx      : in     vl_logic;
        rmaster_up_rx   : in     vl_logic;
        rauto_speed_ena : in     vl_logic;
        singleorbundle  : in     vl_logic;
        rphfifo_regmode_rx: in     vl_logic;
        rpma_done_count : in     vl_logic_vector(17 downto 0);
        rauto_deassert_pc_rst_cnt: in     vl_logic_vector(3 downto 0);
        rauto_pc_en_cnt : in     vl_logic_vector(4 downto 0);
        rwait_for_phfifo_cnt: in     vl_logic_vector(5 downto 0);
        config_sel      : out    vl_logic;
        pcie_switch     : out    vl_logic;
        speed_change    : out    vl_logic;
        dis_pc_byte     : out    vl_logic;
        reset_pc_ptrs   : out    vl_logic;
        cs              : out    vl_logic_vector(3 downto 0)
    );
end stratixiv_hssi_cmu_auto_speed_neg;
