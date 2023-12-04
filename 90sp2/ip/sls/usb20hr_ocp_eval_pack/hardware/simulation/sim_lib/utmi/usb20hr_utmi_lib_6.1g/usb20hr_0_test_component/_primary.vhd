library verilog;
use verilog.vl_types.all;
entity usb20hr_0_test_component is
    generic(
        Interface_sel   : integer := 1;
        GET_STATUS      : integer := 0;
        CLEAR_FEATURE   : integer := 1;
        SET_FEATURE     : integer := 3;
        SET_ADDRESS     : integer := 5;
        GET_DESCRIPTOR  : integer := 6;
        SET_DESCRIPTOR  : integer := 7;
        GET_CONFIG      : integer := 8;
        SET_CONFIG      : integer := 9;
        GET_INTERFACE   : integer := 10;
        SET_INTERFACE   : integer := 11;
        SYNCH_FRAME     : integer := 12
    );
    port(
        clk             : in     vl_logic;
        TxValid         : in     vl_logic;
        XcvSelect       : in     vl_logic;
        TermSel         : in     vl_logic;
        SuspendM        : in     vl_logic;
        OpMode          : in     vl_logic_vector(1 downto 0);
        TxReady         : out    vl_logic;
        RxActive        : out    vl_logic;
        RxValid         : out    vl_logic;
        RxError         : out    vl_logic;
        LineState       : out    vl_logic_vector(1 downto 0);
        usb_vbus        : out    vl_logic;
        Data            : inout  vl_logic_vector(7 downto 0);
        Dir             : out    vl_logic;
        Nxt             : out    vl_logic;
        Stp             : in     vl_logic
    );
end usb20hr_0_test_component;
