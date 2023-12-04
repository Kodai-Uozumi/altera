library verilog;
use verilog.vl_types.all;
entity stratixiv_io_pad is
    generic(
        lpm_type        : string  := "stratixiv_io_pad"
    );
    port(
        padin           : in     vl_logic;
        padout          : out    vl_logic
    );
end stratixiv_io_pad;
