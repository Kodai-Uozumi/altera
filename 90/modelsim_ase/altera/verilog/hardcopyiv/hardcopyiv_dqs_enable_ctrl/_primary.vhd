library verilog;
use verilog.vl_types.all;
entity hardcopyiv_dqs_enable_ctrl is
    generic(
        use_phasectrlin : string  := "true";
        phase_setting   : integer := 0;
        delay_buffer_mode: string  := "high";
        level_dqs_enable: string  := "false";
        delay_dqs_enable_by_half_cycle: string  := "false";
        add_phase_transfer_reg: string  := "false";
        invert_phase    : string  := "false";
        sim_low_buffer_intrinsic_delay: integer := 350;
        sim_high_buffer_intrinsic_delay: integer := 175;
        sim_buffer_delay_increment: integer := 10;
        lpm_type        : string  := "hardcopyiv_dqs_enable_ctrl"
    );
    port(
        dqsenablein     : in     vl_logic;
        clk             : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        phasectrlin     : in     vl_logic_vector(3 downto 0);
        enaphasetransferreg: in     vl_logic;
        phaseinvertctrl : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dffin           : out    vl_logic;
        dffextenddqsenable: out    vl_logic;
        dqsenableout    : out    vl_logic
    );
end hardcopyiv_dqs_enable_ctrl;
