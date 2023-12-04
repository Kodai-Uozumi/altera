library verilog;
use verilog.vl_types.all;
entity hardcopyiv_io_pad is
    generic(
        lpm_type        : string  := "hardcopyiv_io_pad"
    );
    port(
        padin           : in     vl_logic;
        padout          : out    vl_logic
    );
end hardcopyiv_io_pad;
