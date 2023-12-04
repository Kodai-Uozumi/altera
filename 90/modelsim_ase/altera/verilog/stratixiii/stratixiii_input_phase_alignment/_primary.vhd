library verilog;
use verilog.vl_types.all;
entity stratixiii_input_phase_alignment is
    generic(
        use_phasectrlin : string  := "true";
        phase_setting   : integer := 0;
        delay_buffer_mode: string  := "high";
        power_up        : string  := "low";
        async_mode      : string  := "none";
        add_input_cycle_delay: string  := "false";
        bypass_output_register: string  := "false";
        add_phase_transfer_reg: string  := "false";
        invert_phase    : string  := "false";
        sim_low_buffer_intrinsic_delay: integer := 350;
        sim_high_buffer_intrinsic_delay: integer := 175;
        sim_buffer_delay_increment: integer := 10;
        lpm_type        : string  := "stratixiii_input_phase_alignment"
    );
    port(
        datain          : in     vl_logic;
        clk             : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        phasectrlin     : in     vl_logic_vector(3 downto 0);
        areset          : in     vl_logic;
        enainputcycledelay: in     vl_logic;
        enaphasetransferreg: in     vl_logic;
        phaseinvertctrl : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dffin           : out    vl_logic;
        dff1t           : out    vl_logic;
        dataout         : out    vl_logic
    );
end stratixiii_input_phase_alignment;
