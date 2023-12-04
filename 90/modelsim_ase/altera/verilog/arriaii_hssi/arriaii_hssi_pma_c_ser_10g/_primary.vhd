library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_ser_10g is
    generic(
        \PARAM_DELAY\   : integer := 0
    );
    port(
        clk_divtx       : out    vl_logic;
        clk_skew        : in     vl_logic_vector(2 downto 0);
        cpulse          : in     vl_logic;
        cpulseb         : in     vl_logic;
        data_in         : in     vl_logic_vector(63 downto 0);
        hfclkn          : in     vl_logic;
        hfclkp          : in     vl_logic;
        lbvon           : out    vl_logic;
        lbvop           : out    vl_logic;
        lfclkn          : in     vl_logic;
        lfclkp          : in     vl_logic;
        pdb             : in     vl_logic;
        pre_em          : in     vl_logic_vector(4 downto 0);
        rst_n           : in     vl_logic;
        s_lpbk          : in     vl_logic;
        vccelxqyx       : in     vl_logic;
        vccetxqyx       : in     vl_logic;
        von             : out    vl_logic;
        von_op1         : out    vl_logic;
        vop             : out    vl_logic;
        vop_op1         : out    vl_logic;
        vssexqyx        : in     vl_logic
    );
end arriaii_hssi_pma_c_ser_10g;
