library verilog;
use verilog.vl_types.all;
entity stratixiii_routing_wire is
    port(
        datain          : in     vl_logic;
        dataout         : out    vl_logic
    );
end stratixiii_routing_wire;
