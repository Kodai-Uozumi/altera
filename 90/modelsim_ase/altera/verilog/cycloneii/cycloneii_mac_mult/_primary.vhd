library verilog;
use verilog.vl_types.all;
entity cycloneii_mac_mult is
    generic(
        dataa_width     : integer := 18;
        datab_width     : integer := 18;
        dataa_clock     : string  := "none";
        datab_clock     : string  := "none";
        signa_clock     : string  := "none";
        signb_clock     : string  := "none";
        lpm_hint        : string  := "true";
        lpm_type        : string  := "cycloneii_mac_mult"
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        clk             : in     vl_logic;
        aclr            : in     vl_logic;
        ena             : in     vl_logic;
        dataout         : out    vl_logic_vector;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end cycloneii_mac_mult;
