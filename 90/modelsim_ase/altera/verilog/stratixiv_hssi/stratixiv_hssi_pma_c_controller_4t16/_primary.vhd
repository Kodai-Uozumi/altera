library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_controller_4t16 is
    port(
        atben           : out    vl_logic;
        ct0             : in     vl_logic;
        ct1             : in     vl_logic;
        ct2             : in     vl_logic;
        ct3             : in     vl_logic;
        tmsb1           : out    vl_logic;
        tmsb2           : out    vl_logic;
        tmsb3           : out    vl_logic;
        tmsb4           : out    vl_logic;
        tmsb5           : out    vl_logic;
        tmsb6           : out    vl_logic;
        tmsb7           : out    vl_logic;
        tmsb8           : out    vl_logic;
        tmsb9           : out    vl_logic;
        tmsb10          : out    vl_logic;
        tmsb11          : out    vl_logic;
        tmsb12          : out    vl_logic;
        tmsb13          : out    vl_logic;
        tmsb14          : out    vl_logic;
        tmsb15          : out    vl_logic;
        vcce_la         : in     vl_logic;
        vssex           : in     vl_logic
    );
end stratixiv_hssi_pma_c_controller_4t16;
