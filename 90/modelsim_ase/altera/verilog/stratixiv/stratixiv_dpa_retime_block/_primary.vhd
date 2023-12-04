library verilog;
use verilog.vl_types.all;
entity stratixiv_dpa_retime_block is
    port(
        clkin           : in     vl_logic;
        datain          : in     vl_logic;
        reset           : in     vl_logic;
        clk0            : out    vl_logic;
        clk1            : out    vl_logic;
        clk2            : out    vl_logic;
        clk3            : out    vl_logic;
        clk4            : out    vl_logic;
        clk5            : out    vl_logic;
        clk6            : out    vl_logic;
        clk7            : out    vl_logic;
        data0           : out    vl_logic;
        data1           : out    vl_logic;
        data2           : out    vl_logic;
        data3           : out    vl_logic;
        data4           : out    vl_logic;
        data5           : out    vl_logic;
        data6           : out    vl_logic;
        data7           : out    vl_logic;
        lock            : out    vl_logic
    );
end stratixiv_dpa_retime_block;
