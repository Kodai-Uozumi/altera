library verilog;
use verilog.vl_types.all;
entity altgxb_hssi_transmitter is
    generic(
        channel_num     : integer := 1;
        channel_width   : integer := 8;
        serialization_factor: integer := 8;
        use_double_data_mode: string  := "OFF";
        use_8b_10b_mode : string  := "OFF";
        use_fifo_mode   : string  := "OFF";
        use_reverse_parallel_feedback: string  := "OFF";
        force_disparity_mode: string  := "OFF";
        transmit_protocol: string  := "NONE";
        use_vod_ctrl_signal: string  := "OFF";
        use_preemphasis_ctrl_signal: string  := "OFF";
        use_self_test_mode: string  := "OFF";
        self_test_mode  : integer := 0;
        vod_ctrl_setting: integer := 4;
        preemphasis_ctrl_setting: integer := 5;
        termination     : integer := 0
    );
    port(
        pllclk          : in     vl_logic;
        fastpllclk      : in     vl_logic;
        coreclk         : in     vl_logic;
        softreset       : in     vl_logic;
        serialdatain    : in     vl_logic;
        xgmctrl         : in     vl_logic;
        srlpbk          : in     vl_logic;
        analogreset     : in     vl_logic;
        datain          : in     vl_logic_vector(19 downto 0);
        ctrlenable      : in     vl_logic_vector(1 downto 0);
        forcedisparity  : in     vl_logic_vector(1 downto 0);
        xgmdatain       : in     vl_logic_vector(7 downto 0);
        vodctrl         : in     vl_logic_vector(2 downto 0);
        preemphasisctrl : in     vl_logic_vector(2 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dataout         : out    vl_logic;
        xgmctrlenable   : out    vl_logic;
        rdenablesync    : out    vl_logic;
        xgmdataout      : out    vl_logic_vector(7 downto 0);
        parallelfdbkdata: out    vl_logic_vector(9 downto 0);
        pre8b10bdata    : out    vl_logic_vector(9 downto 0)
    );
end altgxb_hssi_transmitter;
