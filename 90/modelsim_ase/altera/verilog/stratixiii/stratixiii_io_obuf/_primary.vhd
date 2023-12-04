library verilog;
use verilog.vl_types.all;
entity stratixiii_io_obuf is
    generic(
        open_drain_output: string  := "false";
        bus_hold        : string  := "false";
        shift_series_termination_control: string  := "false";
        sim_dynamic_termination_control_is_connected: string  := "false";
        lpm_type        : string  := "stratixiii_io_obuf"
    );
    port(
        i               : in     vl_logic;
        oe              : in     vl_logic;
        dynamicterminationcontrol: in     vl_logic;
        seriesterminationcontrol: in     vl_logic_vector(13 downto 0);
        parallelterminationcontrol: in     vl_logic_vector(13 downto 0);
        devoe           : in     vl_logic;
        o               : out    vl_logic;
        obar            : out    vl_logic
    );
end stratixiii_io_obuf;
