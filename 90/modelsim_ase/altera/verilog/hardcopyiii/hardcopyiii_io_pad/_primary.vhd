library verilog;
use verilog.vl_types.all;
entity hardcopyiii_io_pad is
    generic(
        lpm_type        : string  := "hardcopyiii_io_pad"
    );
    port(
        padin           : in     vl_logic;
        padout          : out    vl_logic
    );
end hardcopyiii_io_pad;
