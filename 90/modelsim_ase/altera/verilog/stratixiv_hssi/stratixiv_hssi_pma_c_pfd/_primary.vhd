library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_pfd is
    port(
        dn              : out    vl_logic;
        dnb             : out    vl_logic;
        fbclk           : in     vl_logic;
        refclk          : in     vl_logic;
        up              : out    vl_logic;
        upb             : out    vl_logic;
        vccerx          : in     vl_logic;
        vssex           : in     vl_logic
    );
end stratixiv_hssi_pma_c_pfd;
