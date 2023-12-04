library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_phystatus_generator is
    port(
        clk             : in     vl_logic;
        latched_p0      : in     vl_logic;
        latched_p0s     : in     vl_logic;
        latched_p1      : in     vl_logic;
        latched_p2      : in     vl_logic;
        phystat_ena     : in     vl_logic;
        phystatus       : out    vl_logic;
        power_state_transition_done: in     vl_logic;
        power_state_transition_done_ena: in     vl_logic;
        powerdown       : in     vl_logic_vector(1 downto 0);
        reset_n         : in     vl_logic;
        rphystatus_rst_toggle: in     vl_logic;
        rx_detect_valid : in     vl_logic
    );
end arriagx_hssi_phystatus_generator;
