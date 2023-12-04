library verilog;
use verilog.vl_types.all;
entity stratixiv_pciehip_pciexp_dcfiforam is
    generic(
        addr_width      : integer := 4;
        data_width      : integer := 32
    );
    port(
        data            : in     vl_logic_vector;
        wren            : in     vl_logic;
        wraddress       : in     vl_logic_vector;
        rdaddress       : in     vl_logic_vector;
        wrclock         : in     vl_logic;
        rdclock         : in     vl_logic;
        q               : out    vl_logic_vector
    );
end stratixiv_pciehip_pciexp_dcfiforam;
