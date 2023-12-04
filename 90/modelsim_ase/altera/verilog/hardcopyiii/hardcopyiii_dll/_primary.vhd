library verilog;
use verilog.vl_types.all;
entity hardcopyiii_dll is
    generic(
        input_frequency : string  := "0 ps";
        delay_buffer_mode: string  := "low";
        delay_chain_length: integer := 12;
        delayctrlout_mode: string  := "normal";
        jitter_reduction: string  := "false";
        use_upndnin     : string  := "false";
        use_upndninclkena: string  := "false";
        sim_valid_lock  : integer := 16;
        sim_valid_lockcount: integer := 0;
        sim_low_buffer_intrinsic_delay: integer := 350;
        sim_high_buffer_intrinsic_delay: integer := 175;
        sim_buffer_delay_increment: integer := 10;
        static_delay_ctrl: integer := 0;
        dual_phase_comparators: string  := "true";
        lpm_type        : string  := "hardcopyiii_dll"
    );
    port(
        clk             : in     vl_logic;
        aload           : in     vl_logic;
        upndnin         : in     vl_logic;
        upndninclkena   : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        offsetdelayctrlout: out    vl_logic_vector(5 downto 0);
        offsetdelayctrlclkout: out    vl_logic;
        delayctrlout    : out    vl_logic_vector(5 downto 0);
        dqsupdate       : out    vl_logic;
        upndnout        : out    vl_logic
    );
end hardcopyiii_dll;
