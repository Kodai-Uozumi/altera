library verilog;
use verilog.vl_types.all;
entity arriaii_pciehip_pulse_ext is
    port(
        core_clk        : in     vl_logic;
        rstn            : in     vl_logic;
        srst            : in     vl_logic;
        derr_cor        : in     vl_logic;
        derr_cor_ext    : out    vl_logic
    );
end arriaii_pciehip_pulse_ext;
