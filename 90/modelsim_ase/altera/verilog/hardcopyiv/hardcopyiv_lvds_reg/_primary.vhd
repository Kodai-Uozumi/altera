library verilog;
use verilog.vl_types.all;
entity hardcopyiv_lvds_reg is
    port(
        q               : out    vl_logic;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        d               : in     vl_logic;
        clrn            : in     vl_logic;
        prn             : in     vl_logic
    );
end hardcopyiv_lvds_reg;
