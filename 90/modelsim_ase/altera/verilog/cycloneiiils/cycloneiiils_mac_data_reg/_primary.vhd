library verilog;
use verilog.vl_types.all;
entity cycloneiiils_mac_data_reg is
    generic(
        data_width      : integer := 18
    );
    port(
        clk             : in     vl_logic;
        data            : in     vl_logic_vector(17 downto 0);
        ena             : in     vl_logic;
        aclr            : in     vl_logic;
        dataout         : out    vl_logic_vector(17 downto 0)
    );
end cycloneiiils_mac_data_reg;
