library verilog;
use verilog.vl_types.all;
entity cycloneiiils_mac_mult_internal is
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
end cycloneiiils_mac_mult_internal;
