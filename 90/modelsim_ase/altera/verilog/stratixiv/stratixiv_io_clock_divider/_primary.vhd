library verilog;
use verilog.vl_types.all;
entity stratixiv_io_clock_divider is
    generic(
        use_phasectrlin : string  := "true";
        phase_setting   : integer := 0;
        delay_buffer_mode: string  := "high";
        use_masterin    : string  := "false";
        invert_phase    : string  := "false";
        sim_low_buffer_intrinsic_delay: integer := 350;
        sim_high_buffer_intrinsic_delay: integer := 175;
        sim_buffer_delay_increment: integer := 10;
        lpm_type        : string  := "stratixiv_io_clock_divider"
    );
    port(
        clk             : in     vl_logic;
        phaseselect     : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        phasectrlin     : in     vl_logic_vector(3 downto 0);
        masterin        : in     vl_logic;
        phaseinvertctrl : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        clkout          : out    vl_logic;
        slaveout        : out    vl_logic
    );
end stratixiv_io_clock_divider;
