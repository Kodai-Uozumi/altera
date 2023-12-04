library verilog;
use verilog.vl_types.all;
entity cycloneiiils_io_pad is
    generic(
        lpm_type        : string  := "cycloneiiils_io_pad"
    );
    port(
        padin           : in     vl_logic;
        padout          : out    vl_logic
    );
end cycloneiiils_io_pad;
