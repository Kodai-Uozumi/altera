library verilog;
use verilog.vl_types.all;
entity altgxb_comp_fifo is
    generic(
        use_rate_match_fifo: string  := "ON";
        rate_matching_fifo_mode: string  := "XAUI";
        use_channel_align: string  := "ON";
        channel_num     : integer := 0;
        for_engineering_sample_device: string  := "ON"
    );
    port(
        datain          : in     vl_logic_vector(9 downto 0);
        datainpre       : in     vl_logic_vector(9 downto 0);
        reset           : in     vl_logic;
        errdetectin     : in     vl_logic;
        syncstatusin    : in     vl_logic;
        disperrin       : in     vl_logic;
        patterndetectin : in     vl_logic;
        errdetectinpre  : in     vl_logic;
        syncstatusinpre : in     vl_logic;
        disperrinpre    : in     vl_logic;
        patterndetectinpre: in     vl_logic;
        writeclk        : in     vl_logic;
        readclk         : in     vl_logic;
        re              : in     vl_logic;
        we              : in     vl_logic;
        fifordin        : in     vl_logic;
        disablefifordin : in     vl_logic;
        disablefifowrin : in     vl_logic;
        alignstatus     : in     vl_logic;
        dataout         : out    vl_logic_vector(9 downto 0);
        errdetectout    : out    vl_logic;
        syncstatus      : out    vl_logic;
        disperr         : out    vl_logic;
        patterndetect   : out    vl_logic;
        codevalid       : out    vl_logic;
        fifofull        : out    vl_logic;
        fifoalmostful   : out    vl_logic;
        fifoempty       : out    vl_logic;
        fifoalmostempty : out    vl_logic;
        disablefifordout: out    vl_logic;
        disablefifowrout: out    vl_logic;
        fifordout       : out    vl_logic
    );
end altgxb_comp_fifo;
