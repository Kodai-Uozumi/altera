library verilog;
use verilog.vl_types.all;
entity stratixii_io is
    generic(
        operation_mode  : string  := "input";
        ddio_mode       : string  := "none";
        open_drain_output: string  := "false";
        bus_hold        : string  := "false";
        output_register_mode: string  := "none";
        output_async_reset: string  := "none";
        output_power_up : string  := "low";
        output_sync_reset: string  := "none";
        tie_off_output_clock_enable: string  := "false";
        oe_register_mode: string  := "none";
        oe_async_reset  : string  := "none";
        oe_power_up     : string  := "low";
        oe_sync_reset   : string  := "none";
        tie_off_oe_clock_enable: string  := "false";
        input_register_mode: string  := "none";
        input_async_reset: string  := "none";
        input_power_up  : string  := "low";
        input_sync_reset: string  := "none";
        extend_oe_disable: string  := "false";
        dqs_input_frequency: string  := "10000 ps";
        dqs_out_mode    : string  := "none";
        dqs_delay_buffer_mode: string  := "low";
        dqs_phase_shift : integer := 0;
        inclk_input     : string  := "normal";
        ddioinclk_input : string  := "negated_inclk";
        dqs_offsetctrl_enable: string  := "false";
        dqs_ctrl_latches_enable: string  := "false";
        dqs_edge_detect_enable: string  := "false";
        gated_dqs       : string  := "false";
        sim_dqs_intrinsic_delay: integer := 0;
        sim_dqs_delay_increment: integer := 0;
        sim_dqs_offset_increment: integer := 0;
        lpm_type        : string  := "stratixii_io"
    );
    port(
        datain          : in     vl_logic;
        ddiodatain      : in     vl_logic;
        oe              : in     vl_logic;
        outclk          : in     vl_logic;
        outclkena       : in     vl_logic;
        inclk           : in     vl_logic;
        inclkena        : in     vl_logic;
        areset          : in     vl_logic;
        sreset          : in     vl_logic;
        ddioinclk       : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        offsetctrlin    : in     vl_logic_vector(5 downto 0);
        dqsupdateen     : in     vl_logic;
        linkin          : in     vl_logic;
        terminationcontrol: in     vl_logic_vector(13 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        devoe           : in     vl_logic;
        padio           : inout  vl_logic;
        combout         : out    vl_logic;
        regout          : out    vl_logic;
        ddioregout      : out    vl_logic;
        dqsbusout       : out    vl_logic;
        linkout         : out    vl_logic
    );
end stratixii_io;
