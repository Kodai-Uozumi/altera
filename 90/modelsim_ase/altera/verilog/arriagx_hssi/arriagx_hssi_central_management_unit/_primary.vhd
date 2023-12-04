library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_central_management_unit is
    generic(
        rx_dprio_width  : integer := 800;
        tx_dprio_width  : integer := 400;
        in_xaui_mode    : string  := "false";
        portaddr        : integer := 1;
        devaddr         : integer := 1;
        bonded_quad_mode: string  := "none";
        use_deskew_fifo : string  := "false";
        num_con_errors_for_align_loss: integer := 2;
        num_con_good_data_for_align_approach: integer := 3;
        num_con_align_chars_for_align: integer := 4;
        offset_all_errors_align: string  := "false";
        lpm_type        : string  := "arriagx_hssi_central_management_unit";
        dprio_config_mode: integer := 0;
        rx0_cru_clock0_physical_mapping: string  := "refclk0";
        rx0_cru_clock1_physical_mapping: string  := "refclk1";
        rx0_cru_clock2_physical_mapping: string  := "iq0";
        rx0_cru_clock3_physical_mapping: string  := "iq1";
        rx0_cru_clock4_physical_mapping: string  := "iq2";
        rx0_cru_clock5_physical_mapping: string  := "iq3";
        rx0_cru_clock6_physical_mapping: string  := "iq4";
        rx0_cru_clock7_physical_mapping: string  := "pld_cru_clk";
        rx0_cru_clock8_physical_mapping: string  := "cmu_div_clk";
        rx1_cru_clock0_physical_mapping: string  := "refclk0";
        rx1_cru_clock1_physical_mapping: string  := "refclk1";
        rx1_cru_clock2_physical_mapping: string  := "iq0";
        rx1_cru_clock3_physical_mapping: string  := "iq1";
        rx1_cru_clock4_physical_mapping: string  := "iq2";
        rx1_cru_clock5_physical_mapping: string  := "iq3";
        rx1_cru_clock6_physical_mapping: string  := "iq4";
        rx1_cru_clock7_physical_mapping: string  := "pld_cru_clk";
        rx1_cru_clock8_physical_mapping: string  := "cmu_div_clk";
        rx2_cru_clock0_physical_mapping: string  := "refclk0";
        rx2_cru_clock1_physical_mapping: string  := "refclk1";
        rx2_cru_clock2_physical_mapping: string  := "iq0";
        rx2_cru_clock3_physical_mapping: string  := "iq1";
        rx2_cru_clock4_physical_mapping: string  := "iq2";
        rx2_cru_clock5_physical_mapping: string  := "iq3";
        rx2_cru_clock6_physical_mapping: string  := "iq4";
        rx2_cru_clock7_physical_mapping: string  := "pld_cru_clk";
        rx2_cru_clock8_physical_mapping: string  := "cmu_div_clk";
        rx3_cru_clock0_physical_mapping: string  := "refclk0";
        rx3_cru_clock1_physical_mapping: string  := "refclk1";
        rx3_cru_clock2_physical_mapping: string  := "iq0";
        rx3_cru_clock3_physical_mapping: string  := "iq1";
        rx3_cru_clock4_physical_mapping: string  := "iq2";
        rx3_cru_clock5_physical_mapping: string  := "iq3";
        rx3_cru_clock6_physical_mapping: string  := "iq4";
        rx3_cru_clock7_physical_mapping: string  := "pld_cru_clk";
        rx3_cru_clock8_physical_mapping: string  := "cmu_div_clk";
        tx0_pll_fast_clk0_physical_mapping: string  := "pll0";
        tx0_pll_fast_clk1_physical_mapping: string  := "pll1";
        tx1_pll_fast_clk0_physical_mapping: string  := "pll0";
        tx1_pll_fast_clk1_physical_mapping: string  := "pll1";
        tx2_pll_fast_clk0_physical_mapping: string  := "pll0";
        tx2_pll_fast_clk1_physical_mapping: string  := "pll1";
        tx3_pll_fast_clk0_physical_mapping: string  := "pll0";
        tx3_pll_fast_clk1_physical_mapping: string  := "pll1";
        pll0_inclk0_logical_to_physical_mapping: string  := "iq0";
        pll0_inclk1_logical_to_physical_mapping: string  := "iq1";
        pll0_inclk2_logical_to_physical_mapping: string  := "iq2";
        pll0_inclk3_logical_to_physical_mapping: string  := "iq3";
        pll0_inclk4_logical_to_physical_mapping: string  := "iq4";
        pll0_inclk5_logical_to_physical_mapping: string  := "pld_clk";
        pll0_inclk6_logical_to_physical_mapping: string  := "clkrefclk0";
        pll0_inclk7_logical_to_physical_mapping: string  := "clkrefclk1";
        pll1_inclk0_logical_to_physical_mapping: string  := "iq0";
        pll1_inclk1_logical_to_physical_mapping: string  := "iq1";
        pll1_inclk2_logical_to_physical_mapping: string  := "iq2";
        pll1_inclk3_logical_to_physical_mapping: string  := "iq3";
        pll1_inclk4_logical_to_physical_mapping: string  := "iq4";
        pll1_inclk5_logical_to_physical_mapping: string  := "pld_clk";
        pll1_inclk6_logical_to_physical_mapping: string  := "clkrefclk0";
        pll1_inclk7_logical_to_physical_mapping: string  := "clkrefclk1";
        pll2_inclk0_logical_to_physical_mapping: string  := "iq0";
        pll2_inclk1_logical_to_physical_mapping: string  := "iq1";
        pll2_inclk2_logical_to_physical_mapping: string  := "iq2";
        pll2_inclk3_logical_to_physical_mapping: string  := "iq3";
        pll2_inclk4_logical_to_physical_mapping: string  := "iq4";
        pll2_inclk5_logical_to_physical_mapping: string  := "pld_clk";
        pll2_inclk6_logical_to_physical_mapping: string  := "clkrefclk0";
        pll2_inclk7_logical_to_physical_mapping: string  := "clkrefclk1";
        cmu_divider_inclk0_physical_mapping: string  := "pll0";
        cmu_divider_inclk1_physical_mapping: string  := "pll1";
        cmu_divider_inclk2_physical_mapping: string  := "pll2";
        rx0_logical_to_physical_mapping: integer := 0;
        rx1_logical_to_physical_mapping: integer := 1;
        rx2_logical_to_physical_mapping: integer := 2;
        rx3_logical_to_physical_mapping: integer := 3;
        tx0_logical_to_physical_mapping: integer := 0;
        tx1_logical_to_physical_mapping: integer := 1;
        tx2_logical_to_physical_mapping: integer := 2;
        tx3_logical_to_physical_mapping: integer := 3;
        pll0_logical_to_physical_mapping: integer := 0;
        pll1_logical_to_physical_mapping: integer := 1;
        pll2_logical_to_physical_mapping: integer := 2;
        refclk_divider0_logical_to_physical_mapping: integer := 0;
        refclk_divider1_logical_to_physical_mapping: integer := 1;
        analog_test_bus_enable: string  := "false";
        bypass_bandgap  : string  := "true";
        central_test_bus_select: integer := 5;
        sim_dump_dprio_internal_reg_at_time: integer := 0;
        sim_dump_filename: string  := "sim_dprio_dump.txt"
    );
    port(
        adet            : in     vl_logic_vector(3 downto 0);
        cmudividerdprioin: in     vl_logic_vector(29 downto 0);
        cmuplldprioin   : in     vl_logic_vector(119 downto 0);
        dpclk           : in     vl_logic;
        dpriodisable    : in     vl_logic;
        dprioin         : in     vl_logic;
        dprioload       : in     vl_logic;
        fixedclk        : in     vl_logic_vector(3 downto 0);
        quadenable      : in     vl_logic;
        quadreset       : in     vl_logic;
        rdalign         : in     vl_logic_vector(3 downto 0);
        rdenablesync    : in     vl_logic;
        recovclk        : in     vl_logic;
        refclkdividerdprioin: in     vl_logic_vector(1 downto 0);
        rxanalogreset   : in     vl_logic_vector(3 downto 0);
        rxclk           : in     vl_logic;
        rxctrl          : in     vl_logic_vector(3 downto 0);
        rxdatain        : in     vl_logic_vector(31 downto 0);
        rxdatavalid     : in     vl_logic_vector(3 downto 0);
        rxdigitalreset  : in     vl_logic_vector(3 downto 0);
        rxdprioin       : in     vl_logic_vector;
        rxpowerdown     : in     vl_logic_vector(3 downto 0);
        rxrunningdisp   : in     vl_logic_vector(3 downto 0);
        syncstatus      : in     vl_logic_vector(3 downto 0);
        txclk           : in     vl_logic;
        txctrl          : in     vl_logic_vector(3 downto 0);
        txdatain        : in     vl_logic_vector(31 downto 0);
        txdigitalreset  : in     vl_logic_vector(3 downto 0);
        txdprioin       : in     vl_logic_vector;
        alignstatus     : out    vl_logic;
        clkdivpowerdn   : out    vl_logic;
        cmudividerdprioout: out    vl_logic_vector(29 downto 0);
        cmuplldprioout  : out    vl_logic_vector(119 downto 0);
        dpriodisableout : out    vl_logic;
        dpriooe         : out    vl_logic;
        dprioout        : out    vl_logic;
        enabledeskew    : out    vl_logic;
        fiforesetrd     : out    vl_logic;
        pllresetout     : out    vl_logic_vector(2 downto 0);
        pllpowerdn      : out    vl_logic_vector(2 downto 0);
        quadresetout    : out    vl_logic;
        refclkdividerdprioout: out    vl_logic_vector(1 downto 0);
        rxadcepowerdn   : out    vl_logic_vector(3 downto 0);
        rxadceresetout  : out    vl_logic_vector(3 downto 0);
        rxanalogresetout: out    vl_logic_vector(3 downto 0);
        rxcruresetout   : out    vl_logic_vector(3 downto 0);
        rxcrupowerdn    : out    vl_logic_vector(3 downto 0);
        rxctrlout       : out    vl_logic_vector(3 downto 0);
        rxdataout       : out    vl_logic_vector(31 downto 0);
        rxdigitalresetout: out    vl_logic_vector(3 downto 0);
        rxdprioout      : out    vl_logic_vector;
        rxibpowerdn     : out    vl_logic_vector(3 downto 0);
        txctrlout       : out    vl_logic_vector(3 downto 0);
        txdataout       : out    vl_logic_vector(31 downto 0);
        txdigitalresetout: out    vl_logic_vector(3 downto 0);
        txanalogresetout: out    vl_logic_vector(3 downto 0);
        txdetectrxpowerdn: out    vl_logic_vector(3 downto 0);
        txdividerpowerdn: out    vl_logic_vector(3 downto 0);
        txobpowerdn     : out    vl_logic_vector(3 downto 0);
        txdprioout      : out    vl_logic_vector;
        digitaltestout  : out    vl_logic_vector(9 downto 0)
    );
end arriagx_hssi_central_management_unit;
