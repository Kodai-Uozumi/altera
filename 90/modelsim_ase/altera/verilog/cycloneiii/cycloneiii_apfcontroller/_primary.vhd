library verilog;
use verilog.vl_types.all;
entity cycloneiii_apfcontroller is
    generic(
        lpm_type        : string  := "cycloneiii_apfcontroller"
    );
    port(
        usermode        : out    vl_logic;
        nceout          : out    vl_logic
    );
end cycloneiii_apfcontroller;
