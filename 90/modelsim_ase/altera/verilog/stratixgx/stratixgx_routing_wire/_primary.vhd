library verilog;
use verilog.vl_types.all;
entity stratixgx_routing_wire is
    port(
        datain          : in     vl_logic;
        dataout         : out    vl_logic
    );
end stratixgx_routing_wire;
