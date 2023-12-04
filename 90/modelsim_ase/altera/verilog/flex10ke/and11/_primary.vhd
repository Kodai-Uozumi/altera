library verilog;
use verilog.vl_types.all;
entity and11 is
    port(
        \Y\             : out    vl_logic_vector(10 downto 0);
        \IN1\           : in     vl_logic_vector(10 downto 0)
    );
end and11;
