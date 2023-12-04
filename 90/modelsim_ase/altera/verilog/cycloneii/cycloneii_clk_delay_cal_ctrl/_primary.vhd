library verilog;
use verilog.vl_types.all;
entity cycloneii_clk_delay_cal_ctrl is
    generic(
        delay_ctrl_sim_delay_15_0: integer := 0;
        delay_ctrl_sim_delay_31_16: integer := 0;
        delay_ctrl_sim_delay_47_32: integer := 0;
        delay_ctrl_sim_delay_63_48: integer := 0;
        lpm_type        : string  := "cycloneii_clk_delay_cal_ctrl"
    );
    port(
        pllcalibrateclk : in     vl_logic;
        plldataclk      : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        disablecalibration: in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        calibratedata   : out    vl_logic;
        pllcalibrateclkdelayedout: out    vl_logic
    );
end cycloneii_clk_delay_cal_ctrl;
