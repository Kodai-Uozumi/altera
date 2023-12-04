library verilog;
use verilog.vl_types.all;
entity apexii_pll is
    generic(
        operation_mode  : string  := "normal";
        simulation_type : string  := "timing";
        clk0_multiply_by: integer := 1;
        clk0_divide_by  : integer := 1;
        clk1_multiply_by: integer := 1;
        clk1_divide_by  : integer := 1;
        clk2_multiply_by: integer := 1;
        clk2_divide_by  : integer := 1;
        input_frequency : integer := 1000;
        phase_shift     : integer := 0;
        lock_high       : integer := 1;
        lock_low        : integer := 1;
        valid_lock_multiplier: integer := 5;
        invalid_lock_multiplier: integer := 5;
        effective_phase_shift: integer := 0;
        effective_clk0_delay: integer := 0;
        effective_clk1_delay: integer := 0;
        effective_clk2_delay: integer := 0
    );
    port(
        clk             : in     vl_logic;
        fbin            : in     vl_logic;
        ena             : in     vl_logic;
        clk0            : out    vl_logic;
        clk1            : out    vl_logic;
        clk2            : out    vl_logic;
        locked          : out    vl_logic
    );
end apexii_pll;
