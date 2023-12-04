library verilog;
use verilog.vl_types.all;
entity cycloneii_clk_delay_ctrl is
    generic(
        behavioral_sim_delay: integer := 0;
        delay_chain     : string  := "54";
        delay_chain_mode: string  := "static";
        uses_calibration: string  := "false";
        use_new_style_dq_detection: string  := "false";
        tan_delay_under_delay_ctrl_signal: string  := "unused";
        delay_ctrl_sim_delay_15_0: integer := 0;
        delay_ctrl_sim_delay_31_16: integer := 0;
        delay_ctrl_sim_delay_47_32: integer := 0;
        delay_ctrl_sim_delay_63_48: integer := 0;
        lpm_type        : string  := "cycloneii_clk_delay_ctrl"
    );
    port(
        clk             : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        disablecalibration: in     vl_logic;
        pllcalibrateclkdelayedin: in     vl_logic;
        devpor          : in     vl_logic;
        devclrn         : in     vl_logic;
        clkout          : out    vl_logic
    );
end cycloneii_clk_delay_ctrl;
