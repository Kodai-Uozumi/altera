library verilog;
use verilog.vl_types.all;
entity stratixiii_second_stage_add_accum is
    generic(
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        ssa_mode        : string  := "add"
    );
    port(
        dataa           : in     vl_logic_vector(71 downto 0);
        datab           : in     vl_logic_vector(71 downto 0);
        accumin         : in     vl_logic_vector(71 downto 0);
        sign            : in     vl_logic;
        operation       : in     vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector(71 downto 0);
        overflow        : out    vl_logic
    );
end stratixiii_second_stage_add_accum;
