library verilog;
use verilog.vl_types.all;
entity arriaii_controller is
    generic(
        lpm_type        : string  := "arriaii_controller"
    );
    port(
        nceout          : out    vl_logic
    );
end arriaii_controller;
