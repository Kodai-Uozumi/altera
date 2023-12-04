library verilog;
use verilog.vl_types.all;
entity altgxb_tx_core is
    generic(
        use_double_data_mode: string  := "OFF";
        use_fifo_mode   : string  := "ON";
        transmit_protocol: string  := "NONE";
        channel_width   : integer := 10;
        \KCHAR\         : integer := 0;
        \ECHAR\         : integer := 0
    );
    port(
        reset           : in     vl_logic;
        datain          : in     vl_logic_vector(19 downto 0);
        writeclk        : in     vl_logic;
        readclk         : in     vl_logic;
        ctrlena         : in     vl_logic_vector(1 downto 0);
        forcedisp       : in     vl_logic_vector(1 downto 0);
        dataout         : out    vl_logic_vector(9 downto 0);
        forcedispout    : out    vl_logic;
        ctrlenaout      : out    vl_logic;
        rdenasync       : out    vl_logic;
        xgmctrlena      : out    vl_logic;
        xgmdataout      : out    vl_logic_vector(7 downto 0);
        pre8b10bdataout : out    vl_logic_vector(9 downto 0)
    );
end altgxb_tx_core;
