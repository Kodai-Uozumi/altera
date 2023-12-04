library verilog;
use verilog.vl_types.all;
entity hardcopyiv_round_block is
    generic(
        round_mode      : string  := "nearest_integer";
        operation_mode  : string  := "output_only";
        round_width     : integer := 15
    );
    port(
        datain          : in     vl_logic_vector(71 downto 0);
        round           : in     vl_logic;
        datain_width    : in     vl_logic_vector(7 downto 0);
        dataout         : out    vl_logic_vector(71 downto 0)
    );
end hardcopyiv_round_block;
