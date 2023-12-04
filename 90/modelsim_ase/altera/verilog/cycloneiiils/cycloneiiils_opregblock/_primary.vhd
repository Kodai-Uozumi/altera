library verilog;
use verilog.vl_types.all;
entity cycloneiiils_opregblock is
    generic(
        lpm_type        : string  := "cycloneiiils_opregblock"
    );
    port(
        clk             : in     vl_logic;
        shiftnld        : in     vl_logic;
        regout          : out    vl_logic
    );
end cycloneiiils_opregblock;
