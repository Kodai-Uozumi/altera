library verilog;
use verilog.vl_types.all;
entity stratixiii_rublock is
    generic(
        sim_init_config : string  := "factory";
        sim_init_watchdog_value: integer := 0;
        sim_init_status : integer := 0;
        lpm_type        : string  := "stratixiii_rublock"
    );
    port(
        clk             : in     vl_logic;
        shiftnld        : in     vl_logic;
        captnupdt       : in     vl_logic;
        regin           : in     vl_logic;
        rsttimer        : in     vl_logic;
        rconfig         : in     vl_logic;
        regout          : out    vl_logic
    );
end stratixiii_rublock;
