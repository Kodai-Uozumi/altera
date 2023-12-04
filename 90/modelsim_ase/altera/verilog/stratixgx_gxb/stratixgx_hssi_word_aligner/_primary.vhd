library verilog;
use verilog.vl_types.all;
entity stratixgx_hssi_word_aligner is
    generic(
        channel_width   : integer := 10;
        align_pattern_length: integer := 10;
        infiniband_invalid_code: integer := 0;
        align_pattern   : string  := "0000000101111100";
        synchronization_mode: string  := "XAUI";
        use_8b_10b_mode : string  := "true";
        use_auto_bit_slip: string  := "true"
    );
    port(
        datain          : in     vl_logic_vector(9 downto 0);
        clk             : in     vl_logic;
        softreset       : in     vl_logic;
        enacdet         : in     vl_logic;
        bitslip         : in     vl_logic;
        a1a2size        : in     vl_logic;
        aligneddata     : out    vl_logic_vector(9 downto 0);
        aligneddatapre  : out    vl_logic_vector(9 downto 0);
        invalidcode     : out    vl_logic;
        invalidcodepre  : out    vl_logic;
        syncstatus      : out    vl_logic;
        syncstatusdeskew: out    vl_logic;
        disperr         : out    vl_logic;
        disperrpre      : out    vl_logic;
        patterndetectpre: out    vl_logic;
        patterndetect   : out    vl_logic
    );
end stratixgx_hssi_word_aligner;
