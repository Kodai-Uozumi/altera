library verilog;
use verilog.vl_types.all;
entity apex20ke_cam is
    generic(
        operation_mode  : string  := "encoded_address";
        address_width   : integer := 5;
        pattern_width   : integer := 32;
        first_address   : integer := 0;
        last_address    : integer := 31;
        init_file       : string  := "none";
        init_filex      : string  := "none";
        init_mem_true1  : integer := 1;
        init_mem_true2  : integer := 1;
        init_mem_comp1  : integer := 1;
        init_mem_comp2  : integer := 1
    );
    port(
        waddr           : in     vl_logic_vector(4 downto 0);
        we              : in     vl_logic;
        datain          : in     vl_logic;
        wrinvert        : in     vl_logic;
        lit             : in     vl_logic_vector(31 downto 0);
        outputselect    : in     vl_logic;
        matchout        : out    vl_logic_vector(15 downto 0);
        matchfound      : out    vl_logic;
        modesel         : in     vl_logic_vector(1 downto 0)
    );
end apex20ke_cam;
