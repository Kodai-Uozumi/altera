library verilog;
use verilog.vl_types.all;
entity arriaii_pciehip_dprio_bus_out_mux is
    port(
        hip_ctrl_in1    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in2    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in3    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in4    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in5    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in6    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in7    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in8    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in9    : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in10   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in11   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in12   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in13   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in14   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in15   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in16   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in17   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in18   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in19   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in20   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in21   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in22   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in23   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in24   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in25   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in26   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in27   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in28   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in29   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in30   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in31   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in32   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in33   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in34   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in35   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in36   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in37   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in38   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in39   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in40   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in41   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in42   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in43   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in44   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in45   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in46   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in47   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in48   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in49   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in50   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in51   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in52   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in53   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in54   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in55   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in56   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in57   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in58   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in59   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in60   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in61   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in62   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in63   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in64   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in65   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in66   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in67   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in68   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in69   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in70   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in71   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in72   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in73   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in74   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in75   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in76   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in77   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in78   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in79   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in80   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in81   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in82   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in83   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in84   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in85   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in86   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in87   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in88   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in89   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in90   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in91   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in92   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in93   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in94   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in95   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in96   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in97   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in98   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in99   : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in100  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in101  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in102  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in103  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in104  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in105  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in106  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in107  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in108  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in109  : in     vl_logic_vector(15 downto 0);
        hip_ctrl_in110  : in     vl_logic_vector(15 downto 0);
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
        hw_address_ctrl_in17: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in18: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in19: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in20: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in21: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in22: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in23: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in24: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in25: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in26: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in27: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in28: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in29: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in30: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in31: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in32: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in33: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in34: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in35: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in36: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in37: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in38: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in39: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in40: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in41: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in42: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in43: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in44: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in45: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in46: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in47: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in48: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in49: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in50: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in51: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in52: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in53: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in54: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in55: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in56: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in57: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in58: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in59: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in60: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in61: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in62: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in63: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in64: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in65: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in66: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in67: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in68: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in69: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in70: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in71: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in72: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in73: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in74: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in75: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in76: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in77: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in78: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in79: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in80: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in81: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in82: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in83: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in84: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in85: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in86: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in87: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in88: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in89: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in90: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in91: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in92: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in93: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in94: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in95: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in96: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in97: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in98: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in99: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in100: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in101: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in102: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in103: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in104: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in105: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in106: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in107: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in108: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in109: in     vl_logic_vector(15 downto 0);
        hw_address_ctrl_in110: in     vl_logic_vector(15 downto 0);
        reg_addr        : in     vl_logic_vector(15 downto 0);
        hip_ctrl_out    : out    vl_logic_vector(15 downto 0)
    );
end arriaii_pciehip_dprio_bus_out_mux;
