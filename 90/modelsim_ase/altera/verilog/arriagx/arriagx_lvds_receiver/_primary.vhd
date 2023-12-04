library verilog;
use verilog.vl_types.all;
entity arriagx_lvds_receiver is
    generic(
        channel_width   : integer := 10;
        data_align_rollover: integer := 2;
        enable_dpa      : string  := "off";
        lose_lock_on_one_change: string  := "off";
        reset_fifo_at_first_lock: string  := "on";
        align_to_rising_edge_only: string  := "on";
        use_serial_feedback_input: string  := "off";
        dpa_debug       : string  := "off";
        x_on_bitslip    : string  := "on";
        lpm_type        : string  := "arriagx_lvds_receiver";
        \DPA_CYCLES_TO_LOCK\: integer := 2
    );
    port(
        clk0            : in     vl_logic;
        datain          : in     vl_logic;
        enable0         : in     vl_logic;
        dpareset        : in     vl_logic;
        dpahold         : in     vl_logic;
        dpaswitch       : in     vl_logic;
        fiforeset       : in     vl_logic;
        bitslip         : in     vl_logic;
        bitslipreset    : in     vl_logic;
        serialfbk       : in     vl_logic;
        dataout         : out    vl_logic_vector;
        dpalock         : out    vl_logic;
        bitslipmax      : out    vl_logic;
        serialdataout   : out    vl_logic;
        postdpaserialdataout: out    vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end arriagx_lvds_receiver;
