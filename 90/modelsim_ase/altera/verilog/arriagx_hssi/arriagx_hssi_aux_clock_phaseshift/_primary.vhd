library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_aux_clock_phaseshift is
    generic(
        clk_phase_shift_by: integer := 0
    );
    port(
        clk             : in     vl_logic;
        clkout          : out    vl_logic
    );
end arriagx_hssi_aux_clock_phaseshift;
