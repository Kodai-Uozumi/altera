library verilog;
use verilog.vl_types.all;
entity stratixiii_bias_block is
    generic(
        lpm_type        : string  := "stratixiii_bias_block"
    );
    port(
        clk             : in     vl_logic;
        shiftnld        : in     vl_logic;
        captnupdt       : in     vl_logic;
        din             : in     vl_logic;
        dout            : out    vl_logic
    );
end stratixiii_bias_block;
