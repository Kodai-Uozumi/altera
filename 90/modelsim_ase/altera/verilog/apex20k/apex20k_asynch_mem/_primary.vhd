library verilog;
use verilog.vl_types.all;
entity apex20k_asynch_mem is
    generic(
        logical_ram_depth: integer := 2048;
        infile          : string  := "none";
        address_width   : integer := 16;
        deep_ram_mode   : string  := "off";
        first_address   : integer := 0;
        last_address    : integer := 2047;
        mem1            : integer := 0;
        mem2            : integer := 0;
        mem3            : integer := 0;
        mem4            : integer := 0;
        bit_number      : integer := 0;
        write_logic_clock: string  := "none";
        operation_mode  : string  := "single_port";
        read_enable_clock: string  := "none";
        data_out_clock  : string  := "none"
    );
    port(
        datain          : in     vl_logic;
        we              : in     vl_logic;
        re              : in     vl_logic;
        raddr           : in     vl_logic_vector(15 downto 0);
        waddr           : in     vl_logic_vector(15 downto 0);
        modesel         : in     vl_logic_vector(17 downto 0);
        dataout         : out    vl_logic
    );
end apex20k_asynch_mem;
