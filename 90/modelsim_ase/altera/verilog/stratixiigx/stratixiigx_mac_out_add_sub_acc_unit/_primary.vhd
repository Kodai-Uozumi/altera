library verilog;
use verilog.vl_types.all;
entity stratixiigx_mac_out_add_sub_acc_unit is
    generic(
        dataa_width     : integer := 36;
        datab_width     : integer := 36;
        datac_width     : integer := 36;
        datad_width     : integer := 36;
        block_type      : string  := "R"
    );
    port(
        dataa           : in     vl_logic_vector(71 downto 0);
        datab           : in     vl_logic_vector(71 downto 0);
        datac           : in     vl_logic_vector(71 downto 0);
        datad           : in     vl_logic_vector(71 downto 0);
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        operation       : in     vl_logic_vector(3 downto 0);
        addnsub         : in     vl_logic;
        dataout         : out    vl_logic_vector(71 downto 0);
        overflow        : out    vl_logic
    );
end stratixiigx_mac_out_add_sub_acc_unit;
