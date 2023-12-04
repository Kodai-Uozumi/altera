library verilog;
use verilog.vl_types.all;
entity apexii_io is
    generic(
        operation_mode  : string  := "input";
        ddio_mode       : string  := "none";
        open_drain_output: string  := "false";
        bus_hold        : string  := "false";
        output_register_mode: string  := "none";
        output_reset    : string  := "none";
        output_power_up : string  := "low";
        oe_register_mode: string  := "none";
        oe_reset        : string  := "none";
        oe_power_up     : string  := "low";
        input_register_mode: string  := "none";
        input_reset     : string  := "none";
        input_power_up  : string  := "low";
        tie_off_output_clock_enable: string  := "false";
        tie_off_oe_clock_enable: string  := "false";
        extend_oe_disable: string  := "false"
    );
    port(
        datain          : in     vl_logic;
        ddiodatain      : in     vl_logic;
        oe              : in     vl_logic;
        outclk          : in     vl_logic;
        outclkena       : in     vl_logic;
        inclk           : in     vl_logic;
        inclkena        : in     vl_logic;
        areset          : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        devoe           : in     vl_logic;
        padio           : inout  vl_logic;
        combout         : out    vl_logic;
        regout          : out    vl_logic;
        ddioregout      : out    vl_logic
    );
end apexii_io;
