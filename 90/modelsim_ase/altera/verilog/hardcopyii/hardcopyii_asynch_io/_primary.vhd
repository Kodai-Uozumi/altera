library verilog;
use verilog.vl_types.all;
entity hardcopyii_asynch_io is
    generic(
        operation_mode  : string  := "input";
        bus_hold        : string  := "false";
        open_drain_output: string  := "false";
        dqs_input_frequency: string  := "10000 ps";
        dqs_out_mode    : string  := "none";
        dqs_delay_buffer_mode: string  := "low";
        dqs_phase_shift : integer := 0;
        dqs_offsetctrl_enable: string  := "false";
        dqs_ctrl_latches_enable: string  := "false";
        dqs_edge_detect_enable: string  := "false";
        sim_dqs_intrinsic_delay: integer := 0;
        sim_dqs_delay_increment: integer := 0;
        sim_dqs_offset_increment: integer := 0;
        gated_dqs       : string  := "false"
    );
    port(
        datain          : in     vl_logic;
        oe              : in     vl_logic;
        regin           : in     vl_logic;
        ddioregin       : in     vl_logic;
        padio           : inout  vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        offsetctrlin    : in     vl_logic_vector(5 downto 0);
        dqsupdateen     : in     vl_logic;
        dqsbusout       : out    vl_logic;
        combout         : out    vl_logic;
        regout          : out    vl_logic;
        ddioregout      : out    vl_logic
    );
end hardcopyii_asynch_io;
