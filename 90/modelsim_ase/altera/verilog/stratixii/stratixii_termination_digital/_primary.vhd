library verilog;
use verilog.vl_types.all;
entity stratixii_termination_digital is
    generic(
        runtime_control : string  := "false";
        use_core_control: string  := "false";
        use_both_compares: string  := "false";
        pull_adder      : integer := 0;
        power_down      : string  := "true";
        left_shift      : string  := "false";
        test_mode       : string  := "false"
    );
    port(
        rin             : in     vl_logic;
        clk             : in     vl_logic;
        clr             : in     vl_logic;
        ena             : in     vl_logic;
        padder          : in     vl_logic_vector(6 downto 0);
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic;
        ctrlout         : out    vl_logic_vector(6 downto 0)
    );
end stratixii_termination_digital;
