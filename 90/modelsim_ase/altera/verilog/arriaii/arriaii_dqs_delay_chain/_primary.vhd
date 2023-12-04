library verilog;
use verilog.vl_types.all;
entity arriaii_dqs_delay_chain is
    generic(
        lpm_type        : string  := "arriaii_dqs_delay_chain";
        delay_buffer_mode: string  := "low";
        dqs_ctrl_latches_enable: string  := "false";
        dqs_input_frequency: string  := "unused";
        dqs_offsetctrl_enable: string  := "false";
        dqs_phase_shift : integer := 0;
        phase_setting   : integer := 0;
        sim_buffer_delay_increment: integer := 10;
        sim_high_buffer_intrinsic_delay: integer := 175;
        sim_low_buffer_intrinsic_delay: integer := 350;
        test_enable     : string  := "false";
        test_select     : integer := 0
    );
    port(
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        dqsin           : in     vl_logic;
        dqsupdateen     : in     vl_logic;
        offsetctrlin    : in     vl_logic_vector(5 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dqsbusout       : out    vl_logic
    );
end arriaii_dqs_delay_chain;
