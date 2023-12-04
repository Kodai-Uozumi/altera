library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_pcie_sw is
    generic(
        \PARAM_DELAY\   : integer := 0
    );
    port(
        cpulse          : in     vl_logic;
        cpulse_out      : out    vl_logic;
        cpulseb         : in     vl_logic;
        cpulsei         : in     vl_logic;
        dynamic_sw      : in     vl_logic;
        gen2ngen1       : out    vl_logic;
        hclk            : out    vl_logic;
        hfclkn          : in     vl_logic;
        hfclkn_out      : out    vl_logic;
        hfclkp          : in     vl_logic;
        hfclkp_out      : out    vl_logic;
        lfclkn          : in     vl_logic;
        lfclkn_out      : out    vl_logic;
        lfclkp          : in     vl_logic;
        lfclkp_out      : out    vl_logic;
        pcie_sw         : in     vl_logic;
        pcie_sw_cdr     : out    vl_logic;
        pclk            : out    vl_logic;
        pdb             : in     vl_logic;
        rst_n           : in     vl_logic;
        vccelxqyx       : in     vl_logic;
        vssexqyx        : in     vl_logic;
        div5            : in     vl_logic
    );
end arriaii_hssi_pma_c_pcie_sw;
