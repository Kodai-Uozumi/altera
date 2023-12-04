library verilog;
use verilog.vl_types.all;
entity stratixiv_tsdblock is
    generic(
        poi_cal_temperature: integer := 85;
        clock_divider_enable: string  := "on";
        clock_divider_value: integer := 40;
        sim_tsdcalo     : integer := 0;
        user_offset_enable: string  := "off";
        lpm_type        : string  := "stratixiv_tsdblock"
    );
    port(
        offset          : in     vl_logic_vector(5 downto 0);
        clk             : in     vl_logic;
        ce              : in     vl_logic;
        clr             : in     vl_logic;
        testin          : in     vl_logic_vector(7 downto 0);
        tsdcalo         : out    vl_logic_vector(7 downto 0);
        tsdcaldone      : out    vl_logic;
        fdbkctrlfromcore: in     vl_logic;
        compouttest     : in     vl_logic;
        tsdcompout      : out    vl_logic;
        offsetout       : out    vl_logic_vector(5 downto 0)
    );
end stratixiv_tsdblock;
