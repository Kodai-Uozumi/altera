library verilog;
use verilog.vl_types.all;
entity stratixiv_rt_sm is
    generic(
        \STRATIXIV_RTOCT_WAIT\: integer := 0;
        \RUP_VREF_M_RDN_VER_M\: integer := 1;
        \RUP_VREF_L_RDN_VER_L\: integer := 2;
        \RUP_VREF_H_RDN_VER_H\: integer := 3;
        \RUP_VREF_L_RDN_VER_H\: integer := 4;
        \RUP_VREF_H_RDN_VER_L\: integer := 5;
        \STRATIXIV_RTOCT_INC_PN\: integer := 8;
        \STRATIXIV_RTOCT_DEC_PN\: integer := 9;
        \STRATIXIV_RTOCT_INC_P\: integer := 10;
        \STRATIXIV_RTOCT_DEC_P\: integer := 11;
        \STRATIXIV_RTOCT_INC_N\: integer := 12;
        \STRATIXIV_RTOCT_DEC_N\: integer := 13;
        \STRATIXIV_RTOCT_SWITCH_REG\: integer := 17;
        \STRATIXIV_RTOCT_DONE\: integer := 31
    );
    port(
        rup             : in     vl_logic;
        rdn             : in     vl_logic;
        clk             : in     vl_logic;
        clken           : in     vl_logic;
        clr             : in     vl_logic;
        rtena           : in     vl_logic;
        rscaldone       : in     vl_logic;
        rtoffsetp       : out    vl_logic_vector(3 downto 0);
        rtoffsetn       : out    vl_logic_vector(3 downto 0);
        caldone         : out    vl_logic;
        sel_rup_vref    : out    vl_logic_vector(2 downto 0);
        sel_rdn_vref    : out    vl_logic_vector(2 downto 0)
    );
end stratixiv_rt_sm;
