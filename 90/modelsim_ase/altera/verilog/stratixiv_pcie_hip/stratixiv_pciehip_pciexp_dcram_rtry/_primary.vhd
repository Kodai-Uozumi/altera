library verilog;
use verilog.vl_types.all;
entity stratixiv_pciehip_pciexp_dcram_rtry is
    generic(
        addr_width      : integer := 4;
        data_width      : integer := 32
    );
    port(
        wrclock         : in     vl_logic;
        wren            : in     vl_logic;
        wraddress       : in     vl_logic_vector;
        data            : in     vl_logic_vector;
        rdclock         : in     vl_logic;
        rdaddress       : in     vl_logic_vector;
        q               : out    vl_logic_vector
    );
end stratixiv_pciehip_pciexp_dcram_rtry;
