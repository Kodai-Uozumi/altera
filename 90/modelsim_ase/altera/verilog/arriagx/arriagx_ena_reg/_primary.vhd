library verilog;
use verilog.vl_types.all;
entity arriagx_ena_reg is
    port(
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        d               : in     vl_logic;
        clrn            : in     vl_logic;
        prn             : in     vl_logic;
        q               : out    vl_logic
    );
end arriagx_ena_reg;
