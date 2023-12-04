library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_ppmdetect is
    port(
        scan_mode       : in     vl_logic;
        ppmsel          : in     vl_logic_vector(5 downto 0);
        fref            : in     vl_logic;
        fvcobyn         : in     vl_logic;
        pd              : in     vl_logic;
        hard_reset      : in     vl_logic;
        rforcehigh      : in     vl_logic;
        rforcelow       : in     vl_logic;
        freq_lock       : out    vl_logic;
        ppm_cnt_latch   : out    vl_logic_vector(6 downto 0);
        ppm_cnt_reset   : in     vl_logic
    );
end stratixiv_hssi_pma_ppmdetect;
