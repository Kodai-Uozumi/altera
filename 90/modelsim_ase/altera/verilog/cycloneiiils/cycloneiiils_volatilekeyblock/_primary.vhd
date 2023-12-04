library verilog;
use verilog.vl_types.all;
entity cycloneiiils_volatilekeyblock is
    generic(
        lpm_type        : string  := "cycloneiiils_volatilekeyblock"
    );
    port(
        vkeypgmd        : out    vl_logic
    );
end cycloneiiils_volatilekeyblock;
