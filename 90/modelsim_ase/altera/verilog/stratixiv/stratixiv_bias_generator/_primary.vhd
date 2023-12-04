library verilog;
use verilog.vl_types.all;
entity stratixiv_bias_generator is
    generic(
        \TOTAL_REG\     : integer := 202
    );
    port(
        din             : in     vl_logic;
        mainclk         : in     vl_logic;
        updateclk       : in     vl_logic;
        capture         : in     vl_logic;
        update          : in     vl_logic;
        dout            : out    vl_logic
    );
end stratixiv_bias_generator;
