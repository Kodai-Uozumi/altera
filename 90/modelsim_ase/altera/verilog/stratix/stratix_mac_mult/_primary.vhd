library verilog;
use verilog.vl_types.all;
entity stratix_mac_mult is
    generic(
        dataa_width     : integer := 18;
        datab_width     : integer := 18;
        dataa_clock     : string  := "none";
        datab_clock     : string  := "none";
        signa_clock     : string  := "none";
        signb_clock     : string  := "none";
        output_clock    : string  := "none";
        dataa_clear     : string  := "none";
        datab_clear     : string  := "none";
        signa_clear     : string  := "none";
        signb_clear     : string  := "none";
        output_clear    : string  := "none";
        signa_internally_grounded: string  := "false";
        signb_internally_grounded: string  := "false";
        lpm_hint        : string  := "true";
        lpm_type        : string  := "stratix_mac_mult"
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        clk             : in     vl_logic_vector(3 downto 0);
        aclr            : in     vl_logic_vector(3 downto 0);
        ena             : in     vl_logic_vector(3 downto 0);
        dataout         : out    vl_logic_vector;
        scanouta        : out    vl_logic_vector;
        scanoutb        : out    vl_logic_vector;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end stratix_mac_mult;
