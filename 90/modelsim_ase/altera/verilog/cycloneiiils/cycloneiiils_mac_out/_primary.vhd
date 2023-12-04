library verilog;
use verilog.vl_types.all;
entity cycloneiiils_mac_out is
    generic(
        dataa_width     : integer := 1;
        output_clock    : string  := "none";
        lpm_hint        : string  := "true";
        lpm_type        : string  := "cycloneiiils_mac_out"
    );
    port(
        dataa           : in     vl_logic_vector;
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        ena             : in     vl_logic;
        dataout         : out    vl_logic_vector;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end cycloneiiils_mac_out;
