library verilog;
use verilog.vl_types.all;
entity stratixiii_io_pad is
    generic(
        lpm_type        : string  := "stratixiii_io_pad"
    );
    port(
        padin           : in     vl_logic;
        padout          : out    vl_logic
    );
end stratixiii_io_pad;
