library verilog;
use verilog.vl_types.all;
entity hardcopyiii_ddr_gray_decoder is
    generic(
        width           : integer := 6
    );
    port(
        gin             : in     vl_logic_vector;
        bout            : out    vl_logic_vector
    );
end hardcopyiii_ddr_gray_decoder;
