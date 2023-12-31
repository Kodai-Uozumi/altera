library verilog;
use verilog.vl_types.all;
entity apexii_ram_block is
    generic(
        operation_mode  : string  := "single_port";
        port_a_operation_mode: string  := "single_port";
        port_b_operation_mode: string  := "single_port";
        logical_ram_name: string  := "ram_xxx";
        port_a_logical_ram_name: string  := "ram_xxx";
        port_b_logical_ram_name: string  := "ram_xxx";
        init_file       : string  := "none";
        port_a_init_file: string  := "none";
        port_b_init_file: string  := "none";
        data_interleave_width_in_bits: integer := 1;
        data_interleave_offset_in_bits: integer := 1;
        port_a_data_interleave_width_in_bits: integer := 1;
        port_a_data_interleave_offset_in_bits: integer := 1;
        port_b_data_interleave_width_in_bits: integer := 1;
        port_b_data_interleave_offset_in_bits: integer := 1;
        port_a_write_deep_ram_mode: string  := "off";
        port_a_write_logical_ram_depth: integer := 4096;
        port_a_write_logical_ram_width: integer := 16;
        port_a_write_address_width: integer := 16;
        port_a_read_deep_ram_mode: string  := "off";
        port_a_read_logical_ram_depth: integer := 4096;
        port_a_read_logical_ram_width: integer := 16;
        port_a_read_address_width: integer := 16;
        port_a_data_in_clock: string  := "none";
        port_a_data_in_clear: string  := "none";
        port_a_write_logic_clock: string  := "none";
        port_a_write_address_clear: string  := "none";
        port_a_write_enable_clear: string  := "none";
        port_a_read_enable_clock: string  := "none";
        port_a_read_enable_clear: string  := "none";
        port_a_read_address_clock: string  := "none";
        port_a_read_address_clear: string  := "none";
        port_a_data_out_clock: string  := "none";
        port_a_data_out_clear: string  := "none";
        port_a_write_first_address: integer := 0;
        port_a_write_last_address: integer := 4095;
        port_a_write_first_bit_number: integer := 1;
        port_a_write_data_width: integer := 1;
        port_a_read_first_address: integer := 0;
        port_a_read_last_address: integer := 4095;
        port_a_read_first_bit_number: integer := 1;
        port_a_read_data_width: integer := 1;
        port_b_write_deep_ram_mode: string  := "off";
        port_b_write_logical_ram_depth: integer := 4096;
        port_b_write_logical_ram_width: integer := 16;
        port_b_write_address_width: integer := 16;
        port_b_read_deep_ram_mode: string  := "off";
        port_b_read_logical_ram_depth: integer := 4096;
        port_b_read_logical_ram_width: integer := 16;
        port_b_read_address_width: integer := 16;
        port_b_data_in_clock: string  := "none";
        port_b_data_in_clear: string  := "none";
        port_b_write_logic_clock: string  := "none";
        port_b_write_address_clear: string  := "none";
        port_b_write_enable_clear: string  := "none";
        port_b_read_enable_clock: string  := "none";
        port_b_read_enable_clear: string  := "none";
        port_b_read_address_clock: string  := "none";
        port_b_read_address_clear: string  := "none";
        port_b_data_out_clock: string  := "none";
        port_b_data_out_clear: string  := "none";
        port_b_write_first_address: integer := 0;
        port_b_write_last_address: integer := 4095;
        port_b_write_first_bit_number: integer := 1;
        port_b_write_data_width: integer := 1;
        port_b_read_first_address: integer := 0;
        port_b_read_last_address: integer := 4095;
        port_b_read_first_bit_number: integer := 1;
        port_b_read_data_width: integer := 1;
        power_up        : string  := "low";
        mem1            : integer := 0;
        mem2            : integer := 0;
        mem3            : integer := 0;
        mem4            : integer := 0;
        mem5            : integer := 0;
        mem6            : integer := 0;
        mem7            : integer := 0;
        mem8            : integer := 0
    );
    port(
        portadatain     : in     vl_logic_vector(15 downto 0);
        portaclk0       : in     vl_logic;
        portaclk1       : in     vl_logic;
        portaclr0       : in     vl_logic;
        portaclr1       : in     vl_logic;
        portaena0       : in     vl_logic;
        portaena1       : in     vl_logic;
        portawe         : in     vl_logic;
        portare         : in     vl_logic;
        portaraddr      : in     vl_logic_vector(16 downto 0);
        portawaddr      : in     vl_logic_vector(16 downto 0);
        portadataout    : out    vl_logic_vector(15 downto 0);
        portbdatain     : in     vl_logic_vector(15 downto 0);
        portbclk0       : in     vl_logic;
        portbclk1       : in     vl_logic;
        portbclr0       : in     vl_logic;
        portbclr1       : in     vl_logic;
        portbena0       : in     vl_logic;
        portbena1       : in     vl_logic;
        portbwe         : in     vl_logic;
        portbre         : in     vl_logic;
        portbraddr      : in     vl_logic_vector(16 downto 0);
        portbwaddr      : in     vl_logic_vector(16 downto 0);
        portbdataout    : out    vl_logic_vector(15 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        portamodesel    : in     vl_logic_vector(20 downto 0);
        portbmodesel    : in     vl_logic_vector(20 downto 0)
    );
end apexii_ram_block;
