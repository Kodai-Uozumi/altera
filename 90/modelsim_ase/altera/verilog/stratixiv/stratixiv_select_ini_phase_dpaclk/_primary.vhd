library verilog;
use verilog.vl_types.all;
entity stratixiv_select_ini_phase_dpaclk is
    generic(
        initial_phase_select: integer := 0
    );
    port(
        clkin           : in     vl_logic;
        loaden          : in     vl_logic;
        enable          : in     vl_logic;
        clkout          : out    vl_logic;
        loadenout       : out    vl_logic
    );
end stratixiv_select_ini_phase_dpaclk;
