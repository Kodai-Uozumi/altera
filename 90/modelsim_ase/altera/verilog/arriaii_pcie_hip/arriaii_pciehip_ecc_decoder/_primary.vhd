library verilog;
use verilog.vl_types.all;
entity arriaii_pciehip_ecc_decoder is
    port(
        flag            : in     vl_logic_vector(2 downto 0);
        derr            : out    vl_logic;
        derr_cor        : out    vl_logic
    );
end arriaii_pciehip_ecc_decoder;
