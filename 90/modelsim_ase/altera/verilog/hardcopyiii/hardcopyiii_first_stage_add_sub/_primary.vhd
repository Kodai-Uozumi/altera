library verilog;
use verilog.vl_types.all;
entity hardcopyiii_first_stage_add_sub is
    generic(
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        fsa_mode        : string  := "add"
    );
    port(
        dataa           : in     vl_logic_vector(71 downto 0);
        datab           : in     vl_logic_vector(71 downto 0);
        sign            : in     vl_logic;
        operation       : in     vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector(71 downto 0)
    );
end hardcopyiii_first_stage_add_sub;
