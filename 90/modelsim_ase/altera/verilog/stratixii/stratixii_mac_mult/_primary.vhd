library verilog;
use verilog.vl_types.all;
entity stratixii_mac_mult is
    generic(
        dataa_width     : integer := 18;
        datab_width     : integer := 18;
        dataa_clock     : string  := "none";
        datab_clock     : string  := "none";
        signa_clock     : string  := "none";
        signb_clock     : string  := "none";
        round_clock     : string  := "none";
        saturate_clock  : string  := "none";
        output_clock    : string  := "none";
        dataa_clear     : string  := "none";
        datab_clear     : string  := "none";
        signa_clear     : string  := "none";
        signb_clear     : string  := "none";
        round_clear     : string  := "none";
        saturate_clear  : string  := "none";
        output_clear    : string  := "none";
        bypass_multiplier: string  := "no";
        mode_clock      : string  := "none";
        zeroacc_clock   : string  := "none";
        mode_clear      : string  := "none";
        zeroacc_clear   : string  := "none";
        signa_internally_grounded: string  := "false";
        signb_internally_grounded: string  := "false";
        lpm_hint        : string  := "true";
        lpm_type        : string  := "stratixii_mac_mult";
        dynamic_mode    : string  := "no"
    );
    port(
        dataa           : in     vl_logic_vector;
        datab           : in     vl_logic_vector;
        scanina         : in     vl_logic_vector;
        scaninb         : in     vl_logic_vector;
        sourcea         : in     vl_logic;
        sourceb         : in     vl_logic;
        signa           : in     vl_logic;
        signb           : in     vl_logic;
        round           : in     vl_logic;
        saturate        : in     vl_logic;
        clk             : in     vl_logic_vector(3 downto 0);
        aclr            : in     vl_logic_vector(3 downto 0);
        ena             : in     vl_logic_vector(3 downto 0);
        mode            : in     vl_logic;
        zeroacc         : in     vl_logic;
        dataout         : out    vl_logic_vector;
        scanouta        : out    vl_logic_vector;
        scanoutb        : out    vl_logic_vector;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic
    );
end stratixii_mac_mult;
