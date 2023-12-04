library verilog;
use verilog.vl_types.all;
entity apex20ke_lvds_transmitter is
    generic(
        channel_width   : integer := 8
    );
    port(
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        datain          : in     vl_logic_vector(7 downto 0);
        dataout         : out    vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end apex20ke_lvds_transmitter;
