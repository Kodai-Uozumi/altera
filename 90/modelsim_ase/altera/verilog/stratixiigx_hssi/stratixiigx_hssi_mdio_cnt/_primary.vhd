library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_mdio_cnt is
    port(
        cnt_eq_0        : out    vl_logic;
        cnt_val         : in     vl_logic_vector(4 downto 0);
        ld_cnt          : in     vl_logic;
        mdc             : in     vl_logic;
        reset           : in     vl_logic
    );
end stratixiigx_hssi_mdio_cnt;
