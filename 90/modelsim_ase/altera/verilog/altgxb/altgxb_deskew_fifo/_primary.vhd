library verilog;
use verilog.vl_types.all;
entity altgxb_deskew_fifo is
    generic(
        a               : integer := 195
    );
    port(
        datain          : in     vl_logic_vector(9 downto 0);
        errdetectin     : in     vl_logic;
        syncstatusin    : in     vl_logic;
        disperrin       : in     vl_logic;
        patterndetectin : in     vl_logic;
        writeclock      : in     vl_logic;
        readclock       : in     vl_logic;
        adetectdeskew   : out    vl_logic;
        fiforesetrd     : in     vl_logic;
        enabledeskew    : in     vl_logic;
        reset           : in     vl_logic;
        dataout         : out    vl_logic_vector(9 downto 0);
        dataoutpre      : out    vl_logic_vector(9 downto 0);
        errdetect       : out    vl_logic;
        syncstatus      : out    vl_logic;
        disperr         : out    vl_logic;
        patterndetect   : out    vl_logic;
        errdetectpre    : out    vl_logic;
        syncstatuspre   : out    vl_logic;
        disperrpre      : out    vl_logic;
        patterndetectpre: out    vl_logic;
        rdalign         : out    vl_logic
    );
end altgxb_deskew_fifo;
