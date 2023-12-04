library verilog;
use verilog.vl_types.all;
entity arriaii_pciehip_ecc_gen is
    port(
        datain          : in     vl_logic_vector(63 downto 0);
        syndrome        : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector(7 downto 0)
    );
end arriaii_pciehip_ecc_gen;
