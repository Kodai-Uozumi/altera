library verilog;
use verilog.vl_types.all;
entity apex20ke_cam_slice is
    generic(
        operation_mode  : string  := "encoded_address";
        logical_cam_name: string  := "cam_xxx";
        logical_cam_depth: string  := "32";
        logical_cam_width: string  := "32";
        address_width   : integer := 5;
        waddr_clear     : string  := "none";
        write_enable_clear: string  := "none";
        write_logic_clock: string  := "none";
        write_logic_clear: string  := "none";
        output_clock    : string  := "none";
        output_clear    : string  := "none";
        init_file       : string  := "none";
        init_filex      : string  := "none";
        first_address   : integer := 0;
        last_address    : integer := 31;
        first_pattern_bit: string  := "1";
        pattern_width   : integer := 32;
        power_up        : string  := "low"
      --init_mem_true1  : integer type with unrepresentable value!
      --init_mem_true2  : integer type with unrepresentable value!
      --init_mem_comp1  : integer type with unrepresentable value!
      --init_mem_comp2  : integer type with unrepresentable value!
    );
    port(
        lit             : in     vl_logic_vector(31 downto 0);
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        clr0            : in     vl_logic;
        clr1            : in     vl_logic;
        ena0            : in     vl_logic;
        ena1            : in     vl_logic;
        outputselect    : in     vl_logic;
        we              : in     vl_logic;
        wrinvert        : in     vl_logic;
        datain          : in     vl_logic;
        waddr           : in     vl_logic_vector(4 downto 0);
        matchout        : out    vl_logic_vector(15 downto 0);
        matchfound      : out    vl_logic;
        modesel         : in     vl_logic_vector(9 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end apex20ke_cam_slice;
