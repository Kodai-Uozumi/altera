library verilog;
use verilog.vl_types.all;
entity arriaii_carry_chain_adder is
    port(
        dataa           : in     vl_logic_vector(71 downto 0);
        datab           : in     vl_logic_vector(71 downto 0);
        dataout         : out    vl_logic_vector(71 downto 0)
    );
end arriaii_carry_chain_adder;
