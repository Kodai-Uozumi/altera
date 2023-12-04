library verilog;
use verilog.vl_types.all;
entity hardcopyiii_ram_block is
    generic(
        operation_mode  : string  := "single_port";
        mixed_port_feed_through_mode: string  := "dont_care";
        ram_block_type  : string  := "auto";
        logical_ram_name: string  := "ram_name";
        init_file       : string  := "init_file.hex";
        init_file_layout: string  := "none";
        enable_ecc      : string  := "false";
        data_interleave_width_in_bits: integer := 1;
        data_interleave_offset_in_bits: integer := 1;
        port_a_logical_ram_depth: integer := 0;
        port_a_logical_ram_width: integer := 0;
        port_a_first_address: integer := 0;
        port_a_last_address: integer := 0;
        port_a_first_bit_number: integer := 0;
        port_a_address_clear: string  := "none";
        port_a_data_out_clear: string  := "none";
        port_a_data_in_clock: string  := "clock0";
        port_a_address_clock: string  := "clock0";
        port_a_write_enable_clock: string  := "clock0";
        port_a_byte_enable_clock: string  := "clock0";
        port_a_read_enable_clock: string  := "clock0";
        port_a_data_out_clock: string  := "none";
        port_a_data_width: integer := 1;
        port_a_address_width: integer := 1;
        port_a_byte_enable_mask_width: integer := 1;
        port_b_logical_ram_depth: integer := 0;
        port_b_logical_ram_width: integer := 0;
        port_b_first_address: integer := 0;
        port_b_last_address: integer := 0;
        port_b_first_bit_number: integer := 0;
        port_b_address_clear: string  := "none";
        port_b_data_out_clear: string  := "none";
        port_b_data_in_clock: string  := "clock1";
        port_b_address_clock: string  := "clock1";
        port_b_write_enable_clock: string  := "clock1";
        port_b_read_enable_clock: string  := "clock1";
        port_b_byte_enable_clock: string  := "clock1";
        port_b_data_out_clock: string  := "none";
        port_b_data_width: integer := 1;
        port_b_address_width: integer := 1;
        port_b_byte_enable_mask_width: integer := 1;
        port_a_read_during_write_mode: string  := "new_data_no_nbe_read";
        port_b_read_during_write_mode: string  := "new_data_no_nbe_read";
        power_up_uninitialized: string  := "false";
        lpm_type        : string  := "hardcopyiii_ram_block";
        lpm_hint        : string  := "true";
        connectivity_checking: string  := "off";
        mem_init0       : integer := 0;
        mem_init1       : integer := 0;
        mem_init2       : integer := 0;
        mem_init3       : integer := 0;
        mem_init4       : integer := 0;
        mem_init5       : integer := 0;
        mem_init6       : integer := 0;
        mem_init7       : integer := 0;
        mem_init8       : integer := 0;
        mem_init9       : integer := 0;
        mem_init10      : integer := 0;
        mem_init11      : integer := 0;
        mem_init12      : integer := 0;
        mem_init13      : integer := 0;
        mem_init14      : integer := 0;
        mem_init15      : integer := 0;
        mem_init16      : integer := 0;
        mem_init17      : integer := 0;
        mem_init18      : integer := 0;
        mem_init19      : integer := 0;
        mem_init20      : integer := 0;
        mem_init21      : integer := 0;
        mem_init22      : integer := 0;
        mem_init23      : integer := 0;
        mem_init24      : integer := 0;
        mem_init25      : integer := 0;
        mem_init26      : integer := 0;
        mem_init27      : integer := 0;
        mem_init28      : integer := 0;
        mem_init29      : integer := 0;
        mem_init30      : integer := 0;
        mem_init31      : integer := 0;
        mem_init32      : integer := 0;
        mem_init33      : integer := 0;
        mem_init34      : integer := 0;
        mem_init35      : integer := 0;
        mem_init36      : integer := 0;
        mem_init37      : integer := 0;
        mem_init38      : integer := 0;
        mem_init39      : integer := 0;
        mem_init40      : integer := 0;
        mem_init41      : integer := 0;
        mem_init42      : integer := 0;
        mem_init43      : integer := 0;
        mem_init44      : integer := 0;
        mem_init45      : integer := 0;
        mem_init46      : integer := 0;
        mem_init47      : integer := 0;
        mem_init48      : integer := 0;
        mem_init49      : integer := 0;
        mem_init50      : integer := 0;
        mem_init51      : integer := 0;
        mem_init52      : integer := 0;
        mem_init53      : integer := 0;
        mem_init54      : integer := 0;
        mem_init55      : integer := 0;
        mem_init56      : integer := 0;
        mem_init57      : integer := 0;
        mem_init58      : integer := 0;
        mem_init59      : integer := 0;
        mem_init60      : integer := 0;
        mem_init61      : integer := 0;
        mem_init62      : integer := 0;
        mem_init63      : integer := 0;
        mem_init64      : integer := 0;
        mem_init65      : integer := 0;
        mem_init66      : integer := 0;
        mem_init67      : integer := 0;
        mem_init68      : integer := 0;
        mem_init69      : integer := 0;
        mem_init70      : integer := 0;
        mem_init71      : integer := 0;
        port_a_byte_size: integer := 0;
        port_b_byte_size: integer := 0;
        clk0_input_clock_enable: string  := "none";
        clk0_core_clock_enable: string  := "none";
        clk0_output_clock_enable: string  := "none";
        clk1_input_clock_enable: string  := "none";
        clk1_core_clock_enable: string  := "none";
        clk1_output_clock_enable: string  := "none"
    );
    port(
        portadatain     : in     vl_logic_vector;
        portaaddr       : in     vl_logic_vector;
        portawe         : in     vl_logic;
        portare         : in     vl_logic;
        portbdatain     : in     vl_logic_vector;
        portbaddr       : in     vl_logic_vector;
        portbwe         : in     vl_logic;
        portbre         : in     vl_logic;
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        ena0            : in     vl_logic;
        ena1            : in     vl_logic;
        ena2            : in     vl_logic;
        ena3            : in     vl_logic;
        clr0            : in     vl_logic;
        clr1            : in     vl_logic;
        portabyteenamasks: in     vl_logic_vector;
        portbbyteenamasks: in     vl_logic_vector;
        portaaddrstall  : in     vl_logic;
        portbaddrstall  : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        eccstatus       : out    vl_logic_vector(2 downto 0);
        portadataout    : out    vl_logic_vector;
        portbdataout    : out    vl_logic_vector;
        dftout          : out    vl_logic_vector(8 downto 0)
    );
end hardcopyiii_ram_block;
