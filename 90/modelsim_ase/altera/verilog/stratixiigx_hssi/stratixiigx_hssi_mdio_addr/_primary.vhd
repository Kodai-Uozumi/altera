library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_mdio_addr is
    port(
        incr_addr       : in     vl_logic;
        mdc             : in     vl_logic;
        mdio_in         : in     vl_logic;
        reg_addr        : out    vl_logic_vector(15 downto 0);
        reset           : in     vl_logic;
        shift_addr      : in     vl_logic
    );
end stratixiigx_hssi_mdio_addr;
