library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_rlpbk_mux is
    port(
        doddn           : in     vl_logic;
        doddp           : in     vl_logic;
        dodn            : in     vl_logic;
        dodp            : in     vl_logic;
        don             : in     vl_logic;
        don_pre         : in     vl_logic;
        dop             : in     vl_logic;
        dop_pre         : in     vl_logic;
        drxn            : in     vl_logic;
        drxp            : in     vl_logic;
        sel             : in     vl_logic;
        vcce_la         : in     vl_logic;
        voddn           : out    vl_logic;
        voddp           : out    vl_logic;
        vodn            : out    vl_logic;
        vodp            : out    vl_logic;
        von             : out    vl_logic;
        von_pre         : out    vl_logic;
        vop             : out    vl_logic;
        vop_pre         : out    vl_logic;
        vssex           : in     vl_logic
    );
end stratixiv_hssi_pma_c_rlpbk_mux;
