library verilog;
use verilog.vl_types.all;
entity hardcopyiii_mac_register is
    generic(
        data_width      : integer := 18
    );
    port(
        datain          : in     vl_logic_vector;
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        sload           : in     vl_logic;
        bypass_register : in     vl_logic;
        dataout         : out    vl_logic_vector
    );
end hardcopyiii_mac_register;
