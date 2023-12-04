library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_cmu_dprio_reg_centrl is
    port(
        mdio_rst        : in     vl_logic;
        mdio_wr         : in     vl_logic;
        reg_addr        : in     vl_logic_vector(15 downto 0);
        mdc             : in     vl_logic;
        mbus_in         : in     vl_logic_vector(15 downto 0);
        serial_mode     : in     vl_logic;
        mdio_dis        : in     vl_logic;
        pma_cram_test   : in     vl_logic;
        ser_shift_load  : in     vl_logic;
        si              : in     vl_logic;
        ext_centrl_ctrl_1: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_2: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_3: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_4: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_5: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_6: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_7: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_8: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_9: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_10: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_11: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_12: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_13: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_14: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_15: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_16: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_17: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_18: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_19: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_20: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_21: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_22: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_23: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_24: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_25: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_26: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_27: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_28: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_29: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_30: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_31: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_32: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_33: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_34: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_35: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_36: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_37: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_38: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_39: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_40: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_41: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_42: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_43: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_44: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_45: in     vl_logic_vector(15 downto 0);
        ext_centrl_ctrl_46: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_1: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_2: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_3: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_4: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_5: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_6: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_7: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_8: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_9: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_10: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_11: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_12: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_13: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_14: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_15: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_16: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_17: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_18: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_19: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_20: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_21: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_22: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_23: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_24: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_25: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_26: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_27: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_28: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_29: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_30: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_31: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_32: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_33: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_34: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_35: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_36: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_37: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_38: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_39: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_40: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_41: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_42: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_43: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_44: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_45: in     vl_logic_vector(15 downto 0);
        targ_addr_ctrl_46: in     vl_logic_vector(15 downto 0);
        out_centrl_ctrl_1: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_2: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_3: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_4: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_5: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_6: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_7: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_8: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_9: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_10: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_11: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_12: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_13: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_14: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_15: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_16: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_17: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_18: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_19: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_20: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_21: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_22: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_23: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_24: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_25: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_26: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_27: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_28: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_29: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_30: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_31: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_32: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_33: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_34: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_35: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_36: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_37: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_38: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_39: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_40: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_41: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_42: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_43: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_44: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_45: out    vl_logic_vector(15 downto 0);
        out_centrl_ctrl_46: out    vl_logic_vector(15 downto 0);
        so              : out    vl_logic
    );
end arriaii_hssi_cmu_dprio_reg_centrl;
