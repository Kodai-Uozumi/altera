library verilog;
use verilog.vl_types.all;
entity altgxb_deskew_fifo_rtl is
    port(
        adetectdeskew   : out    vl_logic;
        datain          : in     vl_logic_vector(9 downto 0);
        dataout         : out    vl_logic_vector(9 downto 0);
        dataoutpre      : out    vl_logic_vector(9 downto 0);
        disperr         : out    vl_logic;
        disperrin       : in     vl_logic;
        disperrpre      : out    vl_logic;
        enabledeskew    : in     vl_logic;
        errdetect       : out    vl_logic;
        errdetectin     : in     vl_logic;
        errdetectpre    : out    vl_logic;
        fiforesetrd     : in     vl_logic;
        patterndetect   : out    vl_logic;
        patterndetectin : in     vl_logic;
        patterndetectpre: out    vl_logic;
        readclock       : in     vl_logic;
        reset           : in     vl_logic;
        syncstatus      : out    vl_logic;
        syncstatusin    : in     vl_logic;
        syncstatuspre   : out    vl_logic;
        wr_align        : in     vl_logic;
        writeclock      : in     vl_logic
    );
end altgxb_deskew_fifo_rtl;
