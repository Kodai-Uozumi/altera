library verilog;
use verilog.vl_types.all;
entity arriagx_mac_out_internal is
    generic(
        operation_mode  : string  := "output_only";
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        datac_width     : integer := 36;
        datad_width     : integer := 36
    );
    port(
        dataa           : in     vl_logic_vector(35 downto 0);
        datab           : in     vl_logic_vector(35 downto 0);
        datac           : in     vl_logic_vector(35 downto 0);
        datad           : in     vl_logic_vector(35 downto 0);
        mode0           : in     vl_logic;
        mode1           : in     vl_logic;
        roundab         : in     vl_logic;
        saturateab      : in     vl_logic;
        roundcd         : in     vl_logic;
        saturatecd      : in     vl_logic;
        multabsaturate  : in     vl_logic;
        multcdsaturate  : in     vl_logic;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        addnsub0        : in     vl_logic;
        addnsub1        : in     vl_logic;
        zeroacc         : in     vl_logic;
        zeroacc1        : in     vl_logic;
        feedback        : in     vl_logic_vector(143 downto 0);
        dataout         : out    vl_logic_vector(143 downto 0);
        accoverflow     : out    vl_logic
    );
end arriagx_mac_out_internal;
