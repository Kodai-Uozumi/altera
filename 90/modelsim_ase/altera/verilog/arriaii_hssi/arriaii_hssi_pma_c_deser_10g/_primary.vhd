library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_deser_10g is
    generic(
        \PARAM_DELAY\   : integer := 0
    );
    port(
        clk90b          : in     vl_logic;
        clk_divrx       : out    vl_logic;
        deser_pdb       : in     vl_logic;
        deven           : in     vl_logic;
        devenb          : in     vl_logic;
        dodd            : in     vl_logic;
        doddb           : in     vl_logic;
        dout            : out    vl_logic_vector(63 downto 0);
        rst_n           : in     vl_logic;
        vcce_la         : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end arriaii_hssi_pma_c_deser_10g;
