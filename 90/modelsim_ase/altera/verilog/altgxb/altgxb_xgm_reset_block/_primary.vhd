library verilog;
use verilog.vl_types.all;
entity altgxb_xgm_reset_block is
    port(
        txdigitalreset  : in     vl_logic_vector(3 downto 0);
        rxdigitalreset  : in     vl_logic_vector(3 downto 0);
        rxanalogreset   : in     vl_logic_vector(3 downto 0);
        pllreset        : in     vl_logic;
        pllenable       : in     vl_logic;
        txdigitalresetout: out    vl_logic_vector(3 downto 0);
        rxdigitalresetout: out    vl_logic_vector(3 downto 0);
        txanalogresetout: out    vl_logic_vector(3 downto 0);
        rxanalogresetout: out    vl_logic_vector(3 downto 0);
        pllresetout     : out    vl_logic
    );
end altgxb_xgm_reset_block;
