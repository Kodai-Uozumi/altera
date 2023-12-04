library verilog;
use verilog.vl_types.all;
entity stratix_routing_wire is
    port(
        datain          : in     vl_logic;
        dataout         : out    vl_logic
    );
end stratix_routing_wire;
