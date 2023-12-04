library verilog;
use verilog.vl_types.all;
entity stratixiv_round_saturate_block is
    generic(
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        saturate_width  : integer := 15;
        round_width     : integer := 15;
        saturate_mode   : string  := " asymmetric";
        round_mode      : string  := "nearest_integer";
        operation_mode  : string  := "output_only"
    );
    port(
        datain          : in     vl_logic_vector(71 downto 0);
        round           : in     vl_logic;
        saturate        : in     vl_logic;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        datain_width    : in     vl_logic_vector(7 downto 0);
        dataout         : out    vl_logic_vector(71 downto 0);
        saturationoverflow: out    vl_logic
    );
end stratixiv_round_saturate_block;
