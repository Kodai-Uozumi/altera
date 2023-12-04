library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_deser is
    generic(
        \PARAM_DELAY\   : integer := 0
    );
    port(
        clk90b          : in     vl_logic;
        clk_divrx       : out    vl_logic;
        deser_div2      : in     vl_logic;
        deser_div5      : in     vl_logic;
        deser_pdb       : in     vl_logic;
        deven           : in     vl_logic;
        devenb          : in     vl_logic;
        dodd            : in     vl_logic;
        doddb           : in     vl_logic;
        dout            : out    vl_logic_vector(19 downto 0);
        fsd             : out    vl_logic;
        pcie_sw         : in     vl_logic;
        pcieo           : out    vl_logic;
        rdynamic_sw     : in     vl_logic;
        rfast_sd        : in     vl_logic_vector(3 downto 0);
        rst_n           : in     vl_logic;
        rtest_fastsd    : in     vl_logic;
        rxinn           : in     vl_logic;
        rxinp           : in     vl_logic;
        vcce_la         : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end stratixiv_hssi_pma_c_deser;
