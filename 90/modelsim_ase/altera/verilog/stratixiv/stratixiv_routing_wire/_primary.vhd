library verilog;
use verilog.vl_types.all;
entity stratixiv_routing_wire is
    port(
        datain          : in     vl_logic;
        dataout         : out    vl_logic
    );
end stratixiv_routing_wire;
