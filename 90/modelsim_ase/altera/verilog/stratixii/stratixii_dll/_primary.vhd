library verilog;
use verilog.vl_types.all;
entity stratixii_dll is
    generic(
        input_frequency : string  := "10000 ps";
        delay_chain_length: integer := 16;
        delay_buffer_mode: string  := "low";
        delayctrlout_mode: string  := "normal";
        static_delay_ctrl: integer := 0;
        offsetctrlout_mode: string  := "static";
        static_offset   : string  := "0";
        jitter_reduction: string  := "false";
        use_upndnin     : string  := "false";
        use_upndninclkena: string  := "false";
        sim_valid_lock  : integer := 1;
        sim_loop_intrinsic_delay: integer := 1000;
        sim_loop_delay_increment: integer := 100;
        sim_valid_lockcount: integer := 90;
        lpm_type        : string  := "stratixii_dll"
    );
    port(
        clk             : in     vl_logic;
        aload           : in     vl_logic;
        offset          : in     vl_logic_vector(5 downto 0);
        upndnin         : in     vl_logic;
        upndninclkena   : in     vl_logic;
        addnsub         : in     vl_logic;
        delayctrlout    : out    vl_logic_vector(5 downto 0);
        offsetctrlout   : out    vl_logic_vector(5 downto 0);
        dqsupdate       : out    vl_logic;
        upndnout        : out    vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end stratixii_dll;
