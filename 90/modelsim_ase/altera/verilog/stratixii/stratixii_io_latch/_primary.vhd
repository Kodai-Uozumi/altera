library verilog;
use verilog.vl_types.all;
entity stratixii_io_latch is
    generic(
      --async_reset     : integer type with unrepresentable value!
        sync_reset      : string  := "none";
        power_up        : string  := "low"
    );
    port(
        clk             : in     vl_logic;
        datain          : in     vl_logic;
        ena             : in     vl_logic;
        sreset          : in     vl_logic;
        areset          : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        regout          : out    vl_logic
    );
end stratixii_io_latch;
