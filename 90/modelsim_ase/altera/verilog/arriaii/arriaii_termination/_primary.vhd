library verilog;
use verilog.vl_types.all;
entity arriaii_termination is
    generic(
        lpm_type        : string  := "arriaii_termination";
        runtime_control : string  := "false"
    );
    port(
        rdn             : in     vl_logic;
        rup             : in     vl_logic;
        scanclock       : in     vl_logic;
        scanin          : in     vl_logic;
        scaninmux       : in     vl_logic;
        scanshiftmux    : in     vl_logic;
        terminationuserclear: in     vl_logic;
        terminationuserclock: in     vl_logic;
        comparatorprobe : out    vl_logic;
        scanout         : out    vl_logic;
        terminationclockout: out    vl_logic;
        terminationcontrolprobe: out    vl_logic;
        terminationdataout: out    vl_logic;
        terminationdone : out    vl_logic;
        terminationselectout: out    vl_logic
    );
end arriaii_termination;
