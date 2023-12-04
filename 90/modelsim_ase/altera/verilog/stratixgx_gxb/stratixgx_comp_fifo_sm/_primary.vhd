library verilog;
use verilog.vl_types.all;
entity stratixgx_comp_fifo_sm is
    port(
        alignsyncstatus : in     vl_logic;
        decsync         : in     vl_logic;
        done            : in     vl_logic;
        fifocntgt9      : in     vl_logic;
        fifocntlt5      : in     vl_logic;
        overflow        : out    vl_logic;
        reset           : in     vl_logic;
        smenable        : in     vl_logic;
        underflow       : out    vl_logic;
        writeclk        : in     vl_logic
    );
end stratixgx_comp_fifo_sm;
