library verilog;
use verilog.vl_types.all;
entity stratixgx_rx_core is
    generic(
        channel_width   : integer := 10;
        use_double_data_mode: string  := "false";
        use_channel_align: string  := "false";
        use_8b_10b_mode : string  := "true";
        synchronization_mode: string  := "none";
        align_pattern   : string  := "0000000101111100"
    );
    port(
        reset           : in     vl_logic;
        writeclk        : in     vl_logic;
        readclk         : in     vl_logic;
        errdetectin     : in     vl_logic;
        patterndetectin : in     vl_logic;
        decdatavalid    : in     vl_logic;
        xgmdatain       : in     vl_logic_vector(7 downto 0);
        post8b10b       : in     vl_logic_vector(9 downto 0);
        datain          : in     vl_logic_vector(9 downto 0);
        xgmctrlin       : in     vl_logic;
        ctrldetectin    : in     vl_logic;
        syncstatusin    : in     vl_logic;
        disparityerrin  : in     vl_logic;
        syncstatus      : out    vl_logic_vector(1 downto 0);
        errdetect       : out    vl_logic_vector(1 downto 0);
        ctrldetect      : out    vl_logic_vector(1 downto 0);
        disparityerr    : out    vl_logic_vector(1 downto 0);
        patterndetect   : out    vl_logic_vector(1 downto 0);
        dataout         : out    vl_logic_vector(19 downto 0);
        a1a2sizeout     : out    vl_logic_vector(1 downto 0);
        clkout          : out    vl_logic
    );
end stratixgx_rx_core;
