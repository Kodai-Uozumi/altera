library verilog;
use verilog.vl_types.all;
entity stratixiv_mlab_cell is
    generic(
        logical_ram_name: string  := "lutram";
        logical_ram_depth: integer := 0;
        logical_ram_width: integer := 0;
        first_address   : integer := 0;
        last_address    : integer := 0;
        first_bit_number: integer := 0;
        init_file       : string  := "init_file.hex";
        data_width      : integer := 1;
        address_width   : integer := 1;
        byte_enable_mask_width: integer := 1;
        byte_size       : integer := 1;
        lpm_type        : string  := "stratixiv_mlab_cell";
        lpm_hint        : string  := "true";
        mem_init0       : integer := 0;
        mixed_port_feed_through_mode: string  := "dont_care";
        num_cols        : integer := 1
    );
    port(
        portadatain     : in     vl_logic_vector;
        portaaddr       : in     vl_logic_vector;
        portabyteenamasks: in     vl_logic_vector;
        portbaddr       : in     vl_logic_vector;
        clk0            : in     vl_logic;
        ena0            : in     vl_logic;
        portbdataout    : out    vl_logic_vector
    );
end stratixiv_mlab_cell;
