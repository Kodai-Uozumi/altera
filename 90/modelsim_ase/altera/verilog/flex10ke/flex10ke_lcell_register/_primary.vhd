library verilog;
use verilog.vl_types.all;
entity flex10ke_lcell_register is
    generic(
        operation_mode  : string  := "normal";
        packed_mode     : string  := "false";
        clock_enable_mode: string  := "false";
        x_on_violation  : string  := "on"
    );
    port(
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        aload           : in     vl_logic;
        datain          : in     vl_logic;
        dataa           : in     vl_logic;
        datab           : in     vl_logic;
        datac           : in     vl_logic;
        datad           : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        regout          : out    vl_logic;
        qfbko           : out    vl_logic
    );
end flex10ke_lcell_register;
