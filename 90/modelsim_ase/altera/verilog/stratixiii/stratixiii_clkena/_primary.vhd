library verilog;
use verilog.vl_types.all;
entity stratixiii_clkena is
    generic(
        clock_type      : string  := "Auto";
        ena_register_mode: string  := "falling edge";
        lpm_type        : string  := "stratixiii_clkena"
    );
    port(
        inclk           : in     vl_logic;
        ena             : in     vl_logic;
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic;
        enaout          : out    vl_logic;
        outclk          : out    vl_logic
    );
end stratixiii_clkena;
