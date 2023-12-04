library verilog;
use verilog.vl_types.all;
entity maxii_ufm is
    generic(
        address_width   : integer := 9;
        init_file       : string  := "none";
        lpm_type        : string  := "maxii_ufm";
        osc_sim_setting : integer := 180000;
        program_time    : integer := 1600000;
        erase_time      : integer := 500000000;
        widthdata       : integer := 16;
        widthadd        : integer := 9
    );
    port(
        program         : in     vl_logic;
        erase           : in     vl_logic;
        oscena          : in     vl_logic;
        arclk           : in     vl_logic;
        arshft          : in     vl_logic;
        ardin           : in     vl_logic;
        drclk           : in     vl_logic;
        drshft          : in     vl_logic;
        drdin           : in     vl_logic;
        sbdin           : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        ctrl_bgpbusy    : in     vl_logic;
        busy            : out    vl_logic;
        osc             : out    vl_logic;
        drdout          : out    vl_logic;
        sbdout          : out    vl_logic;
        bgpbusy         : out    vl_logic
    );
end maxii_ufm;
