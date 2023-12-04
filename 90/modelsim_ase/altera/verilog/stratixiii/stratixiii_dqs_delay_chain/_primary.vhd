library verilog;
use verilog.vl_types.all;
entity stratixiii_dqs_delay_chain is
    generic(
        dqs_input_frequency: string  := "unused";
        use_phasectrlin : string  := "false";
        phase_setting   : integer := 0;
        delay_buffer_mode: string  := "low";
        dqs_phase_shift : integer := 0;
        dqs_offsetctrl_enable: string  := "false";
        dqs_ctrl_latches_enable: string  := "false";
        test_enable     : string  := "false";
        test_select     : integer := 0;
        sim_low_buffer_intrinsic_delay: integer := 350;
        sim_high_buffer_intrinsic_delay: integer := 175;
        sim_buffer_delay_increment: integer := 10;
        lpm_type        : string  := "stratixiii_dqs_delay_chain"
    );
    port(
        dqsin           : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        offsetctrlin    : in     vl_logic_vector(5 downto 0);
        dqsupdateen     : in     vl_logic;
        phasectrlin     : in     vl_logic_vector(2 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dffin           : out    vl_logic;
        dqsbusout       : out    vl_logic
    );
end stratixiii_dqs_delay_chain;
