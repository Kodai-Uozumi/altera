library verilog;
use verilog.vl_types.all;
entity hardcopyiv_dll_offset_ctrl is
    generic(
        use_offset      : string  := "false";
        static_offset   : string  := "0";
        delay_buffer_mode: string  := "low";
        lpm_type        : string  := "hardcopyiv_dll_offset_ctrl"
    );
    port(
        clk             : in     vl_logic;
        aload           : in     vl_logic;
        offsetdelayctrlin: in     vl_logic_vector(5 downto 0);
        offset          : in     vl_logic_vector(5 downto 0);
        addnsub         : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        offsettestout   : out    vl_logic_vector(5 downto 0);
        offsetctrlout   : out    vl_logic_vector(5 downto 0)
    );
end hardcopyiv_dll_offset_ctrl;
