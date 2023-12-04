library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_div4or5_mcnt is
    port(
        clk             : in     vl_logic;
        clkb            : in     vl_logic;
        d5              : in     vl_logic;
        fout            : out    vl_logic;
        foutn           : out    vl_logic;
        rst_n           : in     vl_logic;
        vccerx          : in     vl_logic;
        vssex           : in     vl_logic
    );
end stratixiv_hssi_pma_c_div4or5_mcnt;
