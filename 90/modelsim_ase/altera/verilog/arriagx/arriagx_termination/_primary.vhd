library verilog;
use verilog.vl_types.all;
entity arriagx_termination is
    generic(
        runtime_control : string  := "false";
        use_core_control: string  := "false";
        pullup_control_to_core: string  := "true";
        use_high_voltage_compare: string  := "true";
        use_both_compares: string  := "false";
        pullup_adder    : integer := 0;
        pulldown_adder  : integer := 0;
        half_rate_clock : string  := "false";
        power_down      : string  := "true";
        left_shift      : string  := "false";
        test_mode       : string  := "false";
        lpm_type        : string  := "arriagx_termination"
    );
    port(
        rup             : in     vl_logic;
        rdn             : in     vl_logic;
        terminationclock: in     vl_logic;
        terminationclear: in     vl_logic;
        terminationenable: in     vl_logic;
        terminationpullup: in     vl_logic_vector(6 downto 0);
        terminationpulldown: in     vl_logic_vector(6 downto 0);
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic;
        incrup          : out    vl_logic;
        incrdn          : out    vl_logic;
        terminationcontrol: out    vl_logic_vector(13 downto 0);
        terminationcontrolprobe: out    vl_logic_vector(6 downto 0)
    );
end arriagx_termination;
