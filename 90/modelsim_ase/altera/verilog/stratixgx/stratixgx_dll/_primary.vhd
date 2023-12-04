library verilog;
use verilog.vl_types.all;
entity stratixgx_dll is
    generic(
        input_frequency : string  := "10000 ps";
        phase_shift     : string  := "0";
        sim_valid_lock  : integer := 1;
        sim_invalid_lock: integer := 5;
        lpm_type        : string  := "stratixgx_dll"
    );
    port(
        clk             : in     vl_logic;
        delayctrlout    : out    vl_logic
    );
end stratixgx_dll;
