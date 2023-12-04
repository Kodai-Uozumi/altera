library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_clkgenbuf is
    generic(
        \PARAM_DELAY\   : integer := 0
    );
    port(
        cgb_x_en        : in     vl_logic_vector(1 downto 0);
        clk0_0          : in     vl_logic;
        clk0_1          : in     vl_logic;
        clk0_out        : out    vl_logic;
        clk90_0         : in     vl_logic;
        clk90_1         : in     vl_logic;
        clk90_out       : out    vl_logic;
        clk180_0        : in     vl_logic;
        clk180_1        : in     vl_logic;
        clk180_out      : out    vl_logic;
        clk270_0        : in     vl_logic;
        clk270_1        : in     vl_logic;
        clk270_out      : out    vl_logic;
        cmu_sel         : in     vl_logic;
        cpulse          : out    vl_logic;
        div5            : in     vl_logic;
        dynamic_sw      : in     vl_logic;
        gen2ngen1       : out    vl_logic;
        hclk            : out    vl_logic;
        hfclk_n         : out    vl_logic;
        hfclk_p         : out    vl_logic;
        lfclk_n         : out    vl_logic;
        lfclk_p         : out    vl_logic;
        m_sel           : in     vl_logic_vector(1 downto 0);
        pcie_sw         : in     vl_logic;
        pcie_sw_cdr     : out    vl_logic;
        pclk            : out    vl_logic;
        pdb             : in     vl_logic;
        rst_n           : in     vl_logic;
        rst_n1          : out    vl_logic;
        vccelxqyx       : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end arriaii_hssi_pma_c_clkgenbuf;
