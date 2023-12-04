library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_lockdet_tx18 is
    port(
        disableb        : in     vl_logic;
        dn              : in     vl_logic;
        dnb             : in     vl_logic;
        ib50            : inout  vl_logic;
        lock            : out    vl_logic;
        lockb           : out    vl_logic;
        pd              : in     vl_logic;
        up              : in     vl_logic;
        upb             : in     vl_logic;
        vccerx          : in     vl_logic;
        vssex           : in     vl_logic
    );
end stratixiv_hssi_pma_c_lockdet_tx18;
