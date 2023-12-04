library verilog;
use verilog.vl_types.all;
entity arriaii_hssi_cmu_dprio_status is
    generic(
        \XGXS_STATUS1\  : integer := 24580;
        \XGXS_STATUS2\  : integer := 24581;
        \XGXS_LANE_STATUS\: integer := 24582
    );
    port(
        mdio_rst        : in     vl_logic;
        mdio_rd         : in     vl_logic;
        reg_addr        : in     vl_logic_vector(15 downto 0);
        dev_addr_0      : in     vl_logic;
        mdc             : in     vl_logic;
        serial_mode     : in     vl_logic;
        ser_shift_load  : in     vl_logic;
        si              : in     vl_logic;
        mbus_out_ch0    : in     vl_logic_vector(15 downto 0);
        mbus_out_ch1    : in     vl_logic_vector(15 downto 0);
        mbus_out_ch2    : in     vl_logic_vector(15 downto 0);
        mbus_out_ch3    : in     vl_logic_vector(15 downto 0);
        mbus_out_centrl : in     vl_logic_vector(15 downto 0);
        align_status    : in     vl_logic;
        sync_status     : in     vl_logic_vector(3 downto 0);
        xs_link_status  : in     vl_logic;
        rx_local_fault  : in     vl_logic;
        tx_local_fault  : in     vl_logic;
        rxs_link_status_set: out    vl_logic;
        rtx_rx_local_fault_clr: out    vl_logic;
        mbus_out        : out    vl_logic_vector(15 downto 0);
        so              : out    vl_logic
    );
end arriaii_hssi_cmu_dprio_status;
