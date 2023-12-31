library verilog;
use verilog.vl_types.all;
entity stratixiv_output_phase_alignment is
    generic(
        operation_mode  : string  := "ddio_out";
        use_phasectrlin : string  := "true";
        phase_setting   : integer := 0;
        delay_buffer_mode: string  := "high";
        power_up        : string  := "low";
        async_mode      : string  := "none";
        sync_mode       : string  := "none";
        add_output_cycle_delay: string  := "false";
        use_delayed_clock: string  := "false";
        add_phase_transfer_reg: string  := "false";
        use_phasectrl_clock: string  := "true";
        use_primary_clock: string  := "true";
        invert_phase    : string  := "false";
        phase_setting_for_delayed_clock: integer := 2;
        bypass_input_register: string  := "false";
        sim_low_buffer_intrinsic_delay: integer := 350;
        sim_high_buffer_intrinsic_delay: integer := 175;
        sim_buffer_delay_increment: integer := 10;
        duty_cycle_delay_mode: string  := "none";
        sim_dutycycledelayctrlin_falling_delay_0: integer := 0;
        sim_dutycycledelayctrlin_falling_delay_1: integer := 25;
        sim_dutycycledelayctrlin_falling_delay_10: integer := 250;
        sim_dutycycledelayctrlin_falling_delay_11: integer := 275;
        sim_dutycycledelayctrlin_falling_delay_12: integer := 300;
        sim_dutycycledelayctrlin_falling_delay_13: integer := 325;
        sim_dutycycledelayctrlin_falling_delay_14: integer := 350;
        sim_dutycycledelayctrlin_falling_delay_15: integer := 375;
        sim_dutycycledelayctrlin_falling_delay_2: integer := 50;
        sim_dutycycledelayctrlin_falling_delay_3: integer := 75;
        sim_dutycycledelayctrlin_falling_delay_4: integer := 100;
        sim_dutycycledelayctrlin_falling_delay_5: integer := 125;
        sim_dutycycledelayctrlin_falling_delay_6: integer := 150;
        sim_dutycycledelayctrlin_falling_delay_7: integer := 175;
        sim_dutycycledelayctrlin_falling_delay_8: integer := 200;
        sim_dutycycledelayctrlin_falling_delay_9: integer := 225;
        sim_dutycycledelayctrlin_rising_delay_0: integer := 0;
        sim_dutycycledelayctrlin_rising_delay_1: integer := 25;
        sim_dutycycledelayctrlin_rising_delay_10: integer := 250;
        sim_dutycycledelayctrlin_rising_delay_11: integer := 275;
        sim_dutycycledelayctrlin_rising_delay_12: integer := 300;
        sim_dutycycledelayctrlin_rising_delay_13: integer := 325;
        sim_dutycycledelayctrlin_rising_delay_14: integer := 350;
        sim_dutycycledelayctrlin_rising_delay_15: integer := 375;
        sim_dutycycledelayctrlin_rising_delay_2: integer := 50;
        sim_dutycycledelayctrlin_rising_delay_3: integer := 75;
        sim_dutycycledelayctrlin_rising_delay_4: integer := 100;
        sim_dutycycledelayctrlin_rising_delay_5: integer := 125;
        sim_dutycycledelayctrlin_rising_delay_6: integer := 150;
        sim_dutycycledelayctrlin_rising_delay_7: integer := 175;
        sim_dutycycledelayctrlin_rising_delay_8: integer := 200;
        sim_dutycycledelayctrlin_rising_delay_9: integer := 225;
        lpm_type        : string  := "stratixiv_output_phase_alignment"
    );
    port(
        datain          : in     vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        phasectrlin     : in     vl_logic_vector(3 downto 0);
        areset          : in     vl_logic;
        sreset          : in     vl_logic;
        clkena          : in     vl_logic;
        enaoutputcycledelay: in     vl_logic;
        enaphasetransferreg: in     vl_logic;
        phaseinvertctrl : in     vl_logic;
        delaymode       : in     vl_logic;
        dutycycledelayctrlin: in     vl_logic_vector(3 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dffin           : out    vl_logic_vector(1 downto 0);
        dff1t           : out    vl_logic_vector(1 downto 0);
        dffddiodataout  : out    vl_logic;
        dataout         : out    vl_logic
    );
end stratixiv_output_phase_alignment;
