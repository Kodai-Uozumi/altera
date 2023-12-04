library verilog;
use verilog.vl_types.all;
entity apexii_hsdi_receiver is
    generic(
        channel_width   : integer := 10;
        cds_mode        : string  := "single_bit"
    );
    port(
        deskewin        : in     vl_logic;
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        datain          : in     vl_logic;
        dataout         : out    vl_logic_vector(9 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end apexii_hsdi_receiver;
