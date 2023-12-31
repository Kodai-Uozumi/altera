library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_mdio_pcs_bus_out_mux is
    port(
        pcs_ctrl_in1    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in2    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in3    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in4    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in5    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in6    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in7    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in8    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in9    : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in10   : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in11   : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in12   : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in13   : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in14   : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in15   : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_in16   : in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in1: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in2: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in3: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in4: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in5: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in6: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in7: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in8: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in9: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in10: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in11: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in12: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in13: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in14: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in15: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in16: in     vl_logic_vector(15 downto 0);
        reg_addr        : in     vl_logic_vector(15 downto 0);
        pcs_ctrl_out    : out    vl_logic_vector(15 downto 0)
    );
end stratixiigx_hssi_mdio_pcs_bus_out_mux;
