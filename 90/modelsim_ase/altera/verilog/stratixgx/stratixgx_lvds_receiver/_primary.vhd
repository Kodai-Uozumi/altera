library verilog;
use verilog.vl_types.all;
entity stratixgx_lvds_receiver is
    generic(
        channel_width   : integer := 10;
        use_enable1     : string  := "false";
        enable_dpa      : string  := "off";
        dpll_rawperror  : string  := "off";
        dpll_lockwin    : integer := 100;
        dpll_lockcnt    : integer := 1;
        enable_fifo     : string  := "on"
    );
    port(
        clk0            : in     vl_logic;
        coreclk         : in     vl_logic;
        datain          : in     vl_logic;
        enable0         : in     vl_logic;
        enable1         : in     vl_logic;
        dpareset        : in     vl_logic;
        dpllreset       : in     vl_logic;
        bitslip         : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dataout         : out    vl_logic_vector;
        dpalock         : out    vl_logic
    );
end stratixgx_lvds_receiver;
