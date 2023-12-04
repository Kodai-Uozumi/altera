library verilog;
use verilog.vl_types.all;
entity altgxb_8b10b_encoder is
    generic(
        transmit_protocol: string  := "NONE";
        use_8b_10b_mode : string  := "ON";
        force_disparity_mode: string  := "OFF"
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        xgmctrl         : in     vl_logic;
        kin             : in     vl_logic;
        xgmdatain       : in     vl_logic_vector(7 downto 0);
        datain          : in     vl_logic_vector(7 downto 0);
        forcedisparity  : in     vl_logic;
        dataout         : out    vl_logic_vector(9 downto 0);
        parafbkdataout  : out    vl_logic_vector(9 downto 0)
    );
end altgxb_8b10b_encoder;
