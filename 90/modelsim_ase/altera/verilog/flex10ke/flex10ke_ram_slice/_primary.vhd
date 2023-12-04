library verilog;
use verilog.vl_types.all;
entity flex10ke_ram_slice is
    generic(
        operation_mode  : string  := "single_port";
        logical_ram_name: string  := "ram_xxx";
        logical_ram_depth: string  := "2k";
        logical_ram_width: string  := "1";
        address_width   : integer := 11;
        data_in_clock   : string  := "none";
        data_in_clear   : string  := "none";
        write_logic_clock: string  := "none";
        write_address_clear: string  := "none";
        write_enable_clear: string  := "none";
        read_enable_clock: string  := "none";
        read_enable_clear: string  := "none";
        read_address_clock: string  := "none";
        read_address_clear: string  := "none";
        data_out_clock  : string  := "none";
        data_out_clear  : string  := "none";
        init_file       : string  := "none";
        first_address   : integer := 0;
        last_address    : integer := 2047;
        bit_number      : string  := "1";
        mem1            : integer := 0;
        mem2            : integer := 0;
        mem3            : integer := 0;
        mem4            : integer := 0
    );
    port(
        datain          : in     vl_logic;
        clr0            : in     vl_logic;
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        ena0            : in     vl_logic;
        ena1            : in     vl_logic;
        we              : in     vl_logic;
        re              : in     vl_logic;
        waddr           : in     vl_logic_vector(10 downto 0);
        raddr           : in     vl_logic_vector(10 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        modesel         : in     vl_logic_vector(15 downto 0);
        dataout         : out    vl_logic
    );
end flex10ke_ram_slice;
