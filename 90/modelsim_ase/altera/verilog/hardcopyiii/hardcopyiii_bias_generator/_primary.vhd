library verilog;
use verilog.vl_types.all;
entity hardcopyiii_bias_generator is
    generic(
        \TOTAL_REG\     : integer := 252
    );
    port(
        din             : in     vl_logic;
        mainclk         : in     vl_logic;
        updateclk       : in     vl_logic;
        capture         : in     vl_logic;
        update          : in     vl_logic;
        dout            : out    vl_logic
    );
end hardcopyiii_bias_generator;
