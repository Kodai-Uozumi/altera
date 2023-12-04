library verilog;
use verilog.vl_types.all;
entity cycloneiiils_controller is
    generic(
        lpm_type        : string  := "cycloneiiils_controller"
    );
    port(
        nceout          : out    vl_logic
    );
end cycloneiiils_controller;
