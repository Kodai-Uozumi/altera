library verilog;
use verilog.vl_types.all;
entity stratixiigx_mac_mult_block is
    generic(
        dataa_width     : integer := 18;
        datab_width     : integer := 18;
        dynamic_mode    : string  := "no"
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        bypass_multiplier: in     vl_logic;
        scanouta        : out    vl_logic_vector;
        scanoutb        : out    vl_logic_vector;
        dataout         : out    vl_logic_vector
    );
end stratixiigx_mac_mult_block;
