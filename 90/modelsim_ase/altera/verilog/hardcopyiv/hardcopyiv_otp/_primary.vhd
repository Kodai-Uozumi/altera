library verilog;
use verilog.vl_types.all;
entity hardcopyiv_otp is
    generic(
        data_width      : integer := 128;
        lpm_file        : string  := "init_file.hex";
        lpm_type        : string  := "hardcopyiv_otp";
        lpm_hint        : string  := "true";
        init_data       : integer := 0
    );
    port(
        otpclken        : in     vl_logic;
        otpclk          : in     vl_logic;
        otpshiftnld     : in     vl_logic;
        otpdout         : out    vl_logic
    );
end hardcopyiv_otp;
