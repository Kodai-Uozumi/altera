library verilog;
use verilog.vl_types.all;
entity stratixiv_pciehip_compute_bit is
    port(
        datain          : in     vl_logic_vector(63 downto 0);
        s               : in     vl_logic;
        r               : out    vl_logic
    );
end stratixiv_pciehip_compute_bit;
