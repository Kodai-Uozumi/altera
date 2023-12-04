library verilog;
use verilog.vl_types.all;
entity stratixgx_xgm_dskw_sm is
    port(
        adet            : in     vl_logic_vector(3 downto 0);
        alignstatus     : out    vl_logic;
        enabledeskew    : out    vl_logic;
        fiforesetrd     : out    vl_logic;
        rdalign         : in     vl_logic_vector(3 downto 0);
        recovclk        : in     vl_logic;
        resetall        : in     vl_logic;
        syncstatus      : in     vl_logic_vector(3 downto 0)
    );
end stratixgx_xgm_dskw_sm;
