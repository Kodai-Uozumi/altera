library verilog;
use verilog.vl_types.all;
entity stratixiii_rt_sm is
    generic(
        \STRATIXIII_RTOCT_WAIT\: integer := 0;
        \RUP_VREF_M_RDN_VER_M\: integer := 1;
        \RUP_VREF_L_RDN_VER_L\: integer := 2;
        \RUP_VREF_H_RDN_VER_H\: integer := 3;
        \RUP_VREF_L_RDN_VER_H\: integer := 4;
        \RUP_VREF_H_RDN_VER_L\: integer := 5;
        \STRATIXIII_RTOCT_INC_PN\: integer := 8;
        \STRATIXIII_RTOCT_DEC_PN\: integer := 9;
        \STRATIXIII_RTOCT_INC_P\: integer := 10;
        \STRATIXIII_RTOCT_DEC_P\: integer := 11;
        \STRATIXIII_RTOCT_INC_N\: integer := 12;
        \STRATIXIII_RTOCT_DEC_N\: integer := 13;
        \STRATIXIII_RTOCT_SWITCH_REG\: integer := 17;
        \STRATIXIII_RTOCT_DONE\: integer := 31
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
end stratixiii_rt_sm;
