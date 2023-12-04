library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_rlpbk_ctrl is
    port(
        cru_rlbk        : in     vl_logic;
        rrevlb_sw       : in     vl_logic;
        rrx_s_rdlpbk    : in     vl_logic;
        tx_rlpbk        : out    vl_logic;
        vccerx          : in     vl_logic;
        vssex           : in     vl_logic
    );
end stratixiv_hssi_pma_c_rlpbk_ctrl;
