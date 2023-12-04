library verilog;
use verilog.vl_types.all;
entity hardcopyii_mac_out_internal is
    generic(
        operation_mode  : string  := "output_only";
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        datac_width     : integer := 36;
        datad_width     : integer := 36;
        mode0           : integer := 0;
        mode1           : integer := 0;
        zeroacc1        : integer := 0;
        saturatecd      : integer := 0
    );
    port(
        dataa           : in     vl_logic_vector(35 downto 0);
        datab           : in     vl_logic_vector(35 downto 0);
        datac           : in     vl_logic_vector(35 downto 0);
        datad           : in     vl_logic_vector(35 downto 0);
        roundab         : in     vl_logic;
        saturateab      : in     vl_logic;
        roundcd         : in     vl_logic;
        multabsaturate  : in     vl_logic;
        multcdsaturate  : in     vl_logic;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        addnsub0        : in     vl_logic;
        addnsub1        : in     vl_logic;
        zeroacc         : in     vl_logic;
        feedback        : in     vl_logic_vector(143 downto 0);
        dataout         : out    vl_logic_vector(143 downto 0);
        accoverflow     : out    vl_logic
    );
end hardcopyii_mac_out_internal;
