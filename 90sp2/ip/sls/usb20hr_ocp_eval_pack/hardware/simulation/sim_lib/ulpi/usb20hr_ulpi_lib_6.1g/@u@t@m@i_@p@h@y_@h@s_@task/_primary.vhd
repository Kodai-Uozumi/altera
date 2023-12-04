library verilog;
use verilog.vl_types.all;
entity UTMI_PHY_HS_Task is
    generic(
        IDLE            : integer := 1;
        RXACTIVE1       : integer := 2;
        RXACTIVE2       : integer := 3;
        RXACTIVE3       : integer := 4;
        RXACTIVE4       : integer := 5;
        RXACTIVE5       : integer := 6;
        RX_VALID        : integer := 7
    );
    port(
        RESETN          : in     vl_logic;
        XCVRSELECT      : in     vl_logic;
        TERMSEL         : in     vl_logic;
        SUSPENDN        : in     vl_logic;
        OPMODE          : in     vl_logic_vector(1 downto 0);
        TXVALID         : in     vl_logic;
        tb_txdata       : in     vl_logic_vector(7 downto 0);
        tb_tx_valid     : in     vl_logic;
        pl_size         : in     vl_logic_vector(7 downto 0);
        CLKOUT          : in     vl_logic;
        LINESTATE       : out    vl_logic_vector(1 downto 0);
        TXREADY         : out    vl_logic;
        Rxvalid_flop1   : out    vl_logic;
        Rxactive_flop1  : out    vl_logic;
        RXERROR         : out    vl_logic;
        tb_tx_ready     : out    vl_logic;
        tb_rxdata       : out    vl_logic_vector(7 downto 0);
        tb_rx_valid     : out    vl_logic;
        tb_rx_active    : out    vl_logic;
        tb_rx_error     : out    vl_logic;
        Data_out        : out    vl_logic_vector(7 downto 0);
        Data_in         : in     vl_logic_vector(7 downto 0)
    );
end UTMI_PHY_HS_Task;
