library verilog;
use verilog.vl_types.all;
entity hardcopyiii_lvds_rx_bitslip is
    generic(
        channel_width   : integer := 10;
        bitslip_rollover: integer := 12;
        x_on_bitslip    : string  := "on"
    );
    port(
        clk0            : in     vl_logic;
        bslipcntl       : in     vl_logic;
        bsliprst        : in     vl_logic;
        datain          : in     vl_logic;
        bslipmax        : out    vl_logic;
        dataout         : out    vl_logic
    );
end hardcopyiii_lvds_rx_bitslip;
