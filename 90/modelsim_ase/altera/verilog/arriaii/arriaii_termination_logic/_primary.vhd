library verilog;
use verilog.vl_types.all;
entity arriaii_termination_logic is
    generic(
        lpm_type        : string  := "arriaii_termination_logic"
    );
    port(
        terminationclock: in     vl_logic;
        terminationdata : in     vl_logic;
        terminationselect: in     vl_logic;
        terminationcontrol: out    vl_logic_vector(15 downto 0)
    );
end arriaii_termination_logic;
