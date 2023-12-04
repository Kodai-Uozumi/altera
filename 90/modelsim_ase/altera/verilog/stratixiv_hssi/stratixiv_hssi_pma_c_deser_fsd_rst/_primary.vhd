library verilog;
use verilog.vl_types.all;
entity stratixiv_hssi_pma_c_deser_fsd_rst is
    generic(
        \RST_SD_PULSE_WIDTH\: integer := 1
    );
    port(
        \in\            : in     vl_logic;
        rst             : out    vl_logic;
        vcce_la         : in     vl_logic;
        vssexqyx        : in     vl_logic
    );
end stratixiv_hssi_pma_c_deser_fsd_rst;
