library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_deser_ff_chain is
    generic(
        \PARAM_DELAY\   : integer := 0
    );
    port(
        clka            : in     vl_logic;
        clkb            : in     vl_logic;
        dout            : out    vl_logic;
        rsd             : in     vl_logic_vector(2 downto 0);
        rst_n           : in     vl_logic;
        rtest_fsd       : in     vl_logic;
        rxinn           : in     vl_logic;
        rxinp           : in     vl_logic;
        vcce_la         : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end arriaii_hssi_pma_c_deser_ff_chain;
