library verilog;
use verilog.vl_types.all;
entity hardcopyiii_hram is
    generic(
        logical_ram_name: string  := "hram";
        logical_ram_depth: integer := 0;
        logical_ram_width: integer := 0;
        first_address   : integer := 0;
        last_address    : integer := 0;
        first_bit_number: integer := 0;
        init_file       : string  := "UNUSED";
        data_width      : integer := 20;
        address_width   : integer := 6;
        byte_enable_mask_width: integer := 2;
        byte_size       : integer := 1;
        port_b_address_clock: string  := "none";
        port_b_address_clear: string  := "none";
        port_b_data_out_clock: string  := "none";
        port_b_data_out_clear: string  := "none";
        lpm_type        : string  := "hardcopyiii_hram";
        lpm_hint        : string  := "true";
        mixed_port_feed_through_mode: string  := "dont_care";
        num_cols        : integer := 1
    );
    port(
        portadatain     : in     vl_logic_vector;
        portaaddr       : in     vl_logic_vector;
        portabyteenamasks: in     vl_logic_vector;
        portbaddr       : in     vl_logic_vector;
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        ena0            : in     vl_logic;
        ena1            : in     vl_logic;
        ena2            : in     vl_logic;
        ena3            : in     vl_logic;
        clr0            : in     vl_logic;
        clr1            : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        portbdataout    : out    vl_logic_vector
    );
end hardcopyiii_hram;
