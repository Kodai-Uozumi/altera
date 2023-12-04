library verilog;
use verilog.vl_types.all;
entity stratixgx_8b10b_decoder is
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic_vector(9 downto 0);
        datainvalid     : in     vl_logic;
        dataout         : out    vl_logic_vector(7 downto 0);
        decdatavalid    : out    vl_logic;
        disperr         : out    vl_logic;
        disperrin       : in     vl_logic;
        errdetect       : out    vl_logic;
        errdetectin     : in     vl_logic;
        kout            : out    vl_logic;
        patterndetect   : out    vl_logic;
        patterndetectin : in     vl_logic;
        rderr           : out    vl_logic;
        reset           : in     vl_logic;
        syncstatus      : out    vl_logic;
        syncstatusin    : in     vl_logic;
        \tenBdata\      : out    vl_logic_vector(9 downto 0);
        valid           : out    vl_logic;
        xgmctrldet      : out    vl_logic;
        xgmdataout      : out    vl_logic_vector(7 downto 0);
        xgmdatavalid    : out    vl_logic;
        xgmrunningdisp  : out    vl_logic
    );
end stratixgx_8b10b_decoder;
