library verilog;
use verilog.vl_types.all;
entity hardcopyiv_mac_multiplier is
    generic(
        dataa_width     : integer := 18;
        datab_width     : integer := 18
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        dataout         : out    vl_logic_vector
    );
end hardcopyiv_mac_multiplier;
