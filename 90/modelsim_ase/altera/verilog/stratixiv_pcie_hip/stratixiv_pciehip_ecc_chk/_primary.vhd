library verilog;
use verilog.vl_types.all;
entity stratixiv_pciehip_ecc_chk is
    port(
        enable_ecc      : in     vl_logic;
        datain          : in     vl_logic_vector(63 downto 0);
        syndrome        : in     vl_logic_vector(7 downto 0);
        dataout         : out    vl_logic_vector(63 downto 0);
        single_err      : out    vl_logic;
        multi_err       : out    vl_logic
    );
end stratixiv_pciehip_ecc_chk;
