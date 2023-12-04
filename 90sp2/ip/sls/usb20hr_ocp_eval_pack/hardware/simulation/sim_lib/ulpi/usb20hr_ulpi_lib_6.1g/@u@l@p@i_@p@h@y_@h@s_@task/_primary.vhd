library verilog;
use verilog.vl_types.all;
entity ULPI_PHY_HS_Task is
    generic(
        Tp              : integer := 1;
        IDEAL           : integer := 0;
        REG_WR          : integer := 1;
        DECODE_COM      : integer := 2;
        TRANSMIT        : integer := 3;
        REGWRITE        : integer := 4;
        TXDATA          : integer := 5;
        SD_RX_CMD       : integer := 6;
        NOPID           : integer := 7;
        SEND_CMD        : integer := 8;
        UPDATE_END      : integer := 9;
        SEND_DATA       : integer := 10;
        UPDATE_CMD      : integer := 11;
        DATA_STAGE      : integer := 12;
        DATA_END        : integer := 13;
        UPDATE_CMD1     : integer := 14
    );
    port(
        Reset_n         : in     vl_logic;
        Clk             : in     vl_logic;
        tb_txdata       : in     vl_logic_vector(7 downto 0);
        tb_tx_valid     : in     vl_logic;
        tb_tx_ready     : out    vl_logic;
        tb_rxdata       : out    vl_logic_vector(7 downto 0);
        tb_rx_valid     : out    vl_logic;
        tb_rx_active    : out    vl_logic;
        DataOut         : out    vl_logic_vector(7 downto 0);
        DataIn          : in     vl_logic_vector(7 downto 0);
        Dir             : out    vl_logic;
        Nxt             : out    vl_logic;
        Stp             : in     vl_logic;
        Xcvselect_0     : out    vl_logic;
        Termselect      : out    vl_logic;
        StartSpeedNeg   : in     vl_logic;
        SpeedNeg_Done   : out    vl_logic
    );
end ULPI_PHY_HS_Task;
