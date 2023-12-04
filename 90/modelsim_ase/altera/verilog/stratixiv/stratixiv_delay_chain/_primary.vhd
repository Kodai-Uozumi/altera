library verilog;
use verilog.vl_types.all;
entity stratixiv_delay_chain is
    generic(
        sim_delayctrlin_rising_delay_0: integer := 0;
        sim_delayctrlin_rising_delay_1: integer := 50;
        sim_delayctrlin_rising_delay_2: integer := 100;
        sim_delayctrlin_rising_delay_3: integer := 150;
        sim_delayctrlin_rising_delay_4: integer := 200;
        sim_delayctrlin_rising_delay_5: integer := 250;
        sim_delayctrlin_rising_delay_6: integer := 300;
        sim_delayctrlin_rising_delay_7: integer := 350;
        sim_delayctrlin_rising_delay_8: integer := 400;
        sim_delayctrlin_rising_delay_9: integer := 450;
        sim_delayctrlin_rising_delay_10: integer := 500;
        sim_delayctrlin_rising_delay_11: integer := 550;
        sim_delayctrlin_rising_delay_12: integer := 600;
        sim_delayctrlin_rising_delay_13: integer := 650;
        sim_delayctrlin_rising_delay_14: integer := 700;
        sim_delayctrlin_rising_delay_15: integer := 750;
        sim_delayctrlin_falling_delay_0: integer := 0;
        sim_delayctrlin_falling_delay_1: integer := 50;
        sim_delayctrlin_falling_delay_2: integer := 100;
        sim_delayctrlin_falling_delay_3: integer := 150;
        sim_delayctrlin_falling_delay_4: integer := 200;
        sim_delayctrlin_falling_delay_5: integer := 250;
        sim_delayctrlin_falling_delay_6: integer := 300;
        sim_delayctrlin_falling_delay_7: integer := 350;
        sim_delayctrlin_falling_delay_8: integer := 400;
        sim_delayctrlin_falling_delay_9: integer := 450;
        sim_delayctrlin_falling_delay_10: integer := 500;
        sim_delayctrlin_falling_delay_11: integer := 550;
        sim_delayctrlin_falling_delay_12: integer := 600;
        sim_delayctrlin_falling_delay_13: integer := 650;
        sim_delayctrlin_falling_delay_14: integer := 700;
        sim_delayctrlin_falling_delay_15: integer := 750;
        sim_finedelayctrlin_falling_delay_0: integer := 0;
        sim_finedelayctrlin_falling_delay_1: integer := 25;
        sim_finedelayctrlin_rising_delay_0: integer := 0;
        sim_finedelayctrlin_rising_delay_1: integer := 25;
        use_finedelayctrlin: string  := "false";
        lpm_type        : string  := "stratixiv_delay_chain";
        use_delayctrlin : string  := "true";
        delay_setting   : integer := 0
    );
    port(
        datain          : in     vl_logic;
        delayctrlin     : in     vl_logic_vector(3 downto 0);
        finedelayctrlin : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dataout         : out    vl_logic
    );
end stratixiv_delay_chain;
