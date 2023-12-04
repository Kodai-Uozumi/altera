library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_aux_clock_phaseshift is
    generic(
        clk_phase_shift_by: integer := 0
    );
    port(
        clk             : in     vl_logic;
        clkout          : out    vl_logic
    );
end stratixiigx_hssi_aux_clock_phaseshift;
