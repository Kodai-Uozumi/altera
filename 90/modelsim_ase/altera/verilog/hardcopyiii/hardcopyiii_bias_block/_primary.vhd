library verilog;
use verilog.vl_types.all;
entity hardcopyiii_bias_block is
    generic(
        lpm_type        : string  := "hardcopyiii_bias_block"
    );
    port(
        clk             : in     vl_logic;
        shiftnld        : in     vl_logic;
        captnupdt       : in     vl_logic;
        din             : in     vl_logic;
        dout            : out    vl_logic
    );
end hardcopyiii_bias_block;
