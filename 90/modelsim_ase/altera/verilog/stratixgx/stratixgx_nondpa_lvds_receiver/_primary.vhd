library verilog;
use verilog.vl_types.all;
entity stratixgx_nondpa_lvds_receiver is
    generic(
        channel_width   : integer := 4;
        use_enable1     : string  := "false"
    );
    port(
        clk0            : in     vl_logic;
        enable0         : in     vl_logic;
        enable1         : in     vl_logic;
        datain          : in     vl_logic;
        dataout         : out    vl_logic_vector;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end stratixgx_nondpa_lvds_receiver;
