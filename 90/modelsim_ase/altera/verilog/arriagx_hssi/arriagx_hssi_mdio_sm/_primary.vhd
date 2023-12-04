library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_mdio_sm is
    generic(
        \IDLE\          : integer := 0;
        \PREAMBLE\      : integer := 1;
        \CONTROL\       : integer := 2;
        \TURN_ARND_0\   : integer := 3;
        \TURN_ARND_1\   : integer := 4;
        \ADDR_DATA\     : integer := 5;
        \ADDR_OP\       : integer := 0;
        \WR_OP\         : integer := 1;
        \RD_INC_OP\     : integer := 2;
        \RD_OP\         : integer := 3
    );
    port(
        mdc             : in     vl_logic;
        mdio_in         : in     vl_logic;
        reset           : in     vl_logic;
        opcode          : in     vl_logic_vector(1 downto 0);
        valid_addr      : in     vl_logic;
        cnt_eq_0        : in     vl_logic;
        shift_in        : out    vl_logic;
        shift_out       : out    vl_logic;
        latch_ctl       : out    vl_logic;
        incr_addr       : out    vl_logic;
        mdio_wr         : out    vl_logic;
        mdio_rd         : out    vl_logic;
        shift_addr      : out    vl_logic;
        ld_data         : out    vl_logic;
        ld_cnt          : out    vl_logic;
        cnt_val         : out    vl_logic_vector(4 downto 0);
        valid_addr_lt   : out    vl_logic;
        curr_state      : out    vl_logic_vector(2 downto 0)
    );
end arriagx_hssi_mdio_sm;
