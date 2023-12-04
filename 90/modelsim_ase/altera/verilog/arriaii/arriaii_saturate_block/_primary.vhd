library verilog;
use verilog.vl_types.all;
entity arriaii_saturate_block is
    generic(
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        round_width     : integer := 15;
        saturate_width  : integer := 1;
        saturate_mode   : string  := " asymmetric";
        operation_mode  : string  := "output_only"
    );
    port(
        datain          : in     vl_logic_vector(71 downto 0);
        saturate        : in     vl_logic;
        round           : in     vl_logic;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        datain_width    : in     vl_logic_vector(7 downto 0);
        dataout         : out    vl_logic_vector(71 downto 0);
        saturation_overflow: out    vl_logic
    );
end arriaii_saturate_block;
