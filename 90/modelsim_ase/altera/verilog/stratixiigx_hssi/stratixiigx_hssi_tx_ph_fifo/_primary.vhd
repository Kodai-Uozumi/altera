library verilog;
use verilog.vl_types.all;
entity stratixiigx_hssi_tx_ph_fifo is
    port(
        rst_wclk        : in     vl_logic;
        rst_rclk        : in     vl_logic;
        wr_clk          : in     vl_logic;
        rd_clk          : in     vl_logic;
        bypass_en       : in     vl_logic;
        lowlatency_en   : in     vl_logic;
        we              : in     vl_logic;
        re              : in     vl_logic;
        din             : in     vl_logic_vector(43 downto 0);
        data_out        : out    vl_logic_vector(43 downto 0);
        ph_fifo_full    : out    vl_logic;
        ph_fifo_empty   : out    vl_logic;
        wptr_bin        : out    vl_logic_vector(2 downto 0);
        rptr_bin        : out    vl_logic_vector(2 downto 0)
    );
end stratixiigx_hssi_tx_ph_fifo;
