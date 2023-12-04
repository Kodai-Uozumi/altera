library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_divby2q is
    port(
        clk             : in     vl_logic;
        clk0            : out    vl_logic;
        clk90           : out    vl_logic;
        clk180          : out    vl_logic;
        clk270          : out    vl_logic;
        clkb            : in     vl_logic;
        rst_n           : in     vl_logic;
        vcce_la         : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end stratixiv_hssi_pma_c_divby2q;
