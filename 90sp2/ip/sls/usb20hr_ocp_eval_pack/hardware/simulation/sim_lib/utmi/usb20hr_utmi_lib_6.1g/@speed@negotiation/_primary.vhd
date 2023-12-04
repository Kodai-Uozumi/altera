library verilog;
use verilog.vl_types.all;
entity SpeedNegotiation is
    port(
        CLKOUT          : in     vl_logic;
        rst             : in     vl_logic;
        StartSpeedNeg   : in     vl_logic;
        TXVALID         : in     vl_logic;
        LINESTATE       : out    vl_logic_vector(1 downto 0);
        SpeedNeg_Done   : out    vl_logic;
        usb_vbus_pad_o  : out    vl_logic
    );
end SpeedNegotiation;
