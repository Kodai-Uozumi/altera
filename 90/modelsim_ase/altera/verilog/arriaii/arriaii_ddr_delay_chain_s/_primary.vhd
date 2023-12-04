library verilog;
use verilog.vl_types.all;
entity arriaii_ddr_delay_chain_s is
    generic(
        use_phasectrlin : string  := "true";
        phase_setting   : integer := 0;
        sim_buffer_intrinsic_delay: integer := 350;
        sim_buffer_delay_increment: integer := 10;
        phasectrlin_limit: integer := 7
    );
    port(
        clk             : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(5 downto 0);
        phasectrlin     : in     vl_logic_vector(3 downto 0);
        delayed_clkout  : out    vl_logic
    );
end arriaii_ddr_delay_chain_s;
