library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_d2a_mbpass is
    port(
        bypass          : in     vl_logic_vector(7 downto 5);
        d2a_in          : in     vl_logic;
        d2a_out         : out    vl_logic;
        radce_adapt     : in     vl_logic;
        radce_pdb       : in     vl_logic;
        vccehx          : in     vl_logic;
        vssex           : in     vl_logic
    );
end stratixiv_hssi_pma_c_d2a_mbpass;
