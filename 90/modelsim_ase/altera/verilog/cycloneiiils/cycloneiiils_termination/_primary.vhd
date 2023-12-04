library verilog;
use verilog.vl_types.all;
entity cycloneiiils_termination is
    generic(
        pullup_control_to_core: string  := "false";
        power_down      : string  := "true";
        test_mode       : string  := "false";
        left_shift_termination_code: string  := "false";
        pullup_adder    : integer := 0;
        pulldown_adder  : integer := 0;
        clock_divide_by : integer := 32;
        runtime_control : string  := "false";
        shift_vref_rup  : string  := "true";
        shift_vref_rdn  : string  := "true";
        shifted_vref_control: string  := "true";
        lpm_type        : string  := "cycloneiiils_termination"
    );
    port(
        rup             : in     vl_logic;
        rdn             : in     vl_logic;
        terminationclock: in     vl_logic;
        terminationclear: in     vl_logic;
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic;
        comparatorprobe : out    vl_logic;
        terminationcontrolprobe: out    vl_logic;
        calibrationdone : out    vl_logic;
        terminationcontrol: out    vl_logic_vector(15 downto 0)
    );
end cycloneiiils_termination;
