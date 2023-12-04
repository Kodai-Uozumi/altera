library verilog;
use verilog.vl_types.all;
entity cycloneiiils_testaccessblock is
    generic(
        lpm_type        : string  := "cycloneiiils_testaccessblock"
    );
    port(
        secure1         : out    vl_logic;
        secure2         : out    vl_logic
    );
end cycloneiiils_testaccessblock;
