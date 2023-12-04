library verilog;
use verilog.vl_types.all;
entity stratixgx_comp_fifo_core is
    generic(
        use_rate_match_fifo: string  := "true";
        rate_matching_fifo_mode: string  := "xaui";
        use_channel_align: string  := "true";
        channel_num     : integer := 0;
        for_engineering_sample_device: string  := "true"
    );
    port(
        reset           : in     vl_logic;
        writeclk        : in     vl_logic;
        readclk         : in     vl_logic;
        underflow       : in     vl_logic;
        overflow        : in     vl_logic;
        errdetectin     : in     vl_logic;
        disperrin       : in     vl_logic;
        patterndetectin : in     vl_logic;
        disablefifowrin : in     vl_logic;
        disablefifordin : in     vl_logic;
        re              : in     vl_logic;
        we              : in     vl_logic;
        datain          : in     vl_logic_vector(9 downto 0);
        datainpre       : in     vl_logic_vector(9 downto 0);
        syncstatusin    : in     vl_logic;
        disperr         : out    vl_logic;
        alignstatus     : in     vl_logic;
        fifordin        : in     vl_logic;
        fifordout       : out    vl_logic;
        decsync         : out    vl_logic;
        fifocntlt5      : out    vl_logic;
        fifocntgt9      : out    vl_logic;
        done            : out    vl_logic;
        fifoalmostful   : out    vl_logic;
        fifofull        : out    vl_logic;
        fifoalmostempty : out    vl_logic;
        fifoempty       : out    vl_logic;
        alignsyncstatus : out    vl_logic;
        smenable        : out    vl_logic;
        disablefifordout: out    vl_logic;
        disablefifowrout: out    vl_logic;
        dataout         : out    vl_logic_vector(9 downto 0);
        codevalid       : out    vl_logic;
        errdetectout    : out    vl_logic;
        patterndetect   : out    vl_logic;
        syncstatus      : out    vl_logic
    );
end stratixgx_comp_fifo_core;
