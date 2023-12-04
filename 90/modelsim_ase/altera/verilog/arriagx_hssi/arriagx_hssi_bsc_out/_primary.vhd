library verilog;
use verilog.vl_types.all;
entity arriagx_hssi_bsc_out is
    port(
        clk             : in     vl_logic;
        jtag_mode       : in     vl_logic;
        reset           : in     vl_logic;
        shift_load      : in     vl_logic;
        si              : in     vl_logic;
        sig_in          : in     vl_logic;
        sig_out         : out    vl_logic;
        so              : out    vl_logic
    );
end arriagx_hssi_bsc_out;
