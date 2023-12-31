library verilog;
use verilog.vl_types.all;
entity stratixii_rublock is
    generic(
        operation_mode  : string  := "remote";
        sim_init_config : string  := "factory";
        sim_init_watchdog_value: integer := 0;
        sim_init_page_select: integer := 0;
        sim_init_status : integer := 0;
        lpm_type        : string  := "stratixii_rublock"
    );
    port(
        clk             : in     vl_logic;
        shiftnld        : in     vl_logic;
        captnupdt       : in     vl_logic;
        regin           : in     vl_logic;
        rsttimer        : in     vl_logic;
        rconfig         : in     vl_logic;
        regout          : out    vl_logic;
        pgmout          : out    vl_logic_vector(2 downto 0)
    );
end stratixii_rublock;
