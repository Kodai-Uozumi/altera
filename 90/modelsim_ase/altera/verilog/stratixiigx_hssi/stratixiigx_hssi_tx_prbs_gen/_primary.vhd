library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_tx_prbs_gen is
    port(
        prbs_out        : out    vl_logic_vector(19 downto 0);
        rpma_doublewidth_tx: in     vl_logic;
        rpmadwidth_tx   : in     vl_logic;
        rprbs_en_tx     : in     vl_logic;
        rprbs_sel       : in     vl_logic_vector(2 downto 0);
        soft_reset      : in     vl_logic;
        tx_clk          : in     vl_logic
    );
end stratixiigx_hssi_tx_prbs_gen;
