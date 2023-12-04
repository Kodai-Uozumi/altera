library verilog;
use verilog.vl_types.all;
entity arriaii_crcblock is
    generic(
        oscillator_divider: integer := 1;
        lpm_type        : string  := "arriaii_crcblock";
        crc_deld_disable: string  := "off";
        error_delay     : integer := 0;
        error_dra_dl_bypass: string  := "off"
    );
    port(
        clk             : in     vl_logic;
        shiftnld        : in     vl_logic;
        crcerror        : out    vl_logic;
        regout          : out    vl_logic
    );
end arriaii_crcblock;
