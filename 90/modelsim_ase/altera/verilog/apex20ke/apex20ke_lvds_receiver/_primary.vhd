library verilog;
use verilog.vl_types.all;
entity apex20ke_lvds_receiver is
    generic(
        channel_width   : integer := 8
    );
    port(
        deskewin        : in     vl_logic;
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        datain          : in     vl_logic;
        dataout         : out    vl_logic_vector(7 downto 0);
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end apex20ke_lvds_receiver;
