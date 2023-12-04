library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_pma_c_ser_20to10 is
    generic(
        \PARAM_DELAY\   : integer := 0;
        \PARAM_DELAY_1\ : integer := 1
    );
    port(
        clk_divtx       : out    vl_logic;
        data            : out    vl_logic_vector(9 downto 0);
        data_a          : in     vl_logic_vector(9 downto 0);
        data_b          : in     vl_logic_vector(9 downto 0);
        div2            : in     vl_logic;
        lfclk_n         : in     vl_logic;
        lfclk_p         : in     vl_logic;
        pclk_in         : in     vl_logic;
        pclksel         : in     vl_logic;
        rst_n           : in     vl_logic;
        vccetxqyx       : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end arriaii_hssi_pma_c_ser_20to10;
