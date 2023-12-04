library verilog;
use verilog.vl_types.all;
entity stratixiigx_lcell_ff is
    generic(
        x_on_violation  : string  := "on";
        lpm_type        : string  := "stratixiigx_lcell_ff"
    );
    port(
        datain          : in     vl_logic;
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        aload           : in     vl_logic;
        sclr            : in     vl_logic;
        sload           : in     vl_logic;
        adatasdata      : in     vl_logic;
        ena             : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        regout          : out    vl_logic
    );
end stratixiigx_lcell_ff;
