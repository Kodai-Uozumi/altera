library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_sdl_en_2x is
    port(
        clk             : in     vl_logic;
        d               : in     vl_logic;
        db              : in     vl_logic;
        en              : in     vl_logic;
        \out\           : out    vl_logic;
        outb            : out    vl_logic;
        vcce_la         : in     vl_logic;
        vssex           : in     vl_logic
    );
end stratixiv_hssi_pma_c_sdl_en_2x;
