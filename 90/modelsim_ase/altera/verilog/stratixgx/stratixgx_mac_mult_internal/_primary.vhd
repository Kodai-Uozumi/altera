library verilog;
use verilog.vl_types.all;
entity stratixgx_mac_mult_internal is
    generic(
        dataa_width     : integer := 18;
        datab_width     : integer := 18;
        dataout_width   : integer := 36
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        scanouta        : out    vl_logic_vector;
        scanoutb        : out    vl_logic_vector;
        dataout         : out    vl_logic_vector(35 downto 0)
    );
end stratixgx_mac_mult_internal;
