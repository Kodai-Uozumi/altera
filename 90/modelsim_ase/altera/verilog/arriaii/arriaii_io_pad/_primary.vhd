library verilog;
use verilog.vl_types.all;
entity arriaii_io_pad is
    generic(
        lpm_type        : string  := "arriaii_io_pad"
    );
    port(
        padin           : in     vl_logic;
        padout          : out    vl_logic
    );
end arriaii_io_pad;
