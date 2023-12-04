library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_deser_10to20 is
    generic(
        \PARAM_DELAY\   : integer := 0
    );
    port(
        ck_div          : in     vl_logic;
        ckb_2div        : out    vl_logic;
        clk_div         : out    vl_logic;
        div2            : in     vl_logic;
        douta           : out    vl_logic_vector(9 downto 0);
        doutb           : out    vl_logic_vector(9 downto 0);
        doutn           : in     vl_logic_vector(9 downto 0);
        doutp           : in     vl_logic_vector(9 downto 0);
        en              : in     vl_logic;
        nck_div         : in     vl_logic;
        nclk_div        : out    vl_logic;
        rst_n           : in     vl_logic;
        vcce_la         : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end arriaii_hssi_pma_c_deser_10to20;
