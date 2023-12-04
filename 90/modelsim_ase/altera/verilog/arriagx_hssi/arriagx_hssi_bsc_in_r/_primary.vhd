library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_bsc_in_r is
    port(
        reset           : in     vl_logic;
        clk             : in     vl_logic;
        sig_in          : in     vl_logic;
        ext_in          : in     vl_logic;
        jtag_mode       : in     vl_logic;
        si              : in     vl_logic;
        shift           : in     vl_logic;
        mdio_dis        : in     vl_logic;
        sig_out         : out    vl_logic;
        so              : out    vl_logic
    );
end arriagx_hssi_bsc_in_r;
