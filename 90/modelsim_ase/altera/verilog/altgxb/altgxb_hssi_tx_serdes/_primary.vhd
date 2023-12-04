library verilog;
use verilog.vl_types.all;
entity altgxb_hssi_tx_serdes is
    generic(
        channel_width   : integer := 10
    );
    port(
        clk             : in     vl_logic;
        clk1            : in     vl_logic;
        datain          : in     vl_logic_vector(9 downto 0);
        serialdatain    : in     vl_logic;
        srlpbk          : in     vl_logic;
        areset          : in     vl_logic;
        dataout         : out    vl_logic
    );
end altgxb_hssi_tx_serdes;
