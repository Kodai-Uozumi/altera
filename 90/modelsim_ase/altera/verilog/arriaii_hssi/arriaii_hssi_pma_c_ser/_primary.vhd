library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_ser is
    generic(
        \PARAM_DELAY\   : integer := 0
    );
    port(
        clk_divtx       : out    vl_logic;
        cpulse          : in     vl_logic;
        data            : in     vl_logic_vector(19 downto 0);
        div2            : in     vl_logic;
        div5            : in     vl_logic;
        hfclkn          : in     vl_logic;
        hfclkp          : in     vl_logic;
        lbvon           : out    vl_logic;
        lbvop           : out    vl_logic;
        lfclkn          : in     vl_logic;
        lfclkp          : in     vl_logic;
        pclk_in         : in     vl_logic;
        pclksel         : in     vl_logic;
        pdb             : in     vl_logic;
        pre_em          : in     vl_logic_vector(4 downto 0);
        pre_em_2t       : in     vl_logic_vector(3 downto 0);
        pre_em_pretap   : in     vl_logic_vector(3 downto 0);
        pre_en_out      : out    vl_logic;
        rst_n           : in     vl_logic;
        s_lpbk          : in     vl_logic;
        vccelxqyx       : in     vl_logic;
        vccetxqyx       : in     vl_logic;
        von             : out    vl_logic;
        von_op1         : out    vl_logic;
        von_op2         : out    vl_logic;
        von_pre         : out    vl_logic;
        vop             : out    vl_logic;
        vop_op1         : out    vl_logic;
        vop_op2         : out    vl_logic;
        vop_pre         : out    vl_logic;
        vssexqyx        : in     vl_logic
    );
end arriaii_hssi_pma_c_ser;
