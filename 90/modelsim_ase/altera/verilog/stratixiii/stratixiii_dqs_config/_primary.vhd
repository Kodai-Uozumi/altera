library verilog;
use verilog.vl_types.all;
entity stratixiii_dqs_config is
    generic(
        enhanced_mode   : string  := "false";
        lpm_type        : string  := "stratixiii_dqs_config"
    );
    port(
        datain          : in     vl_logic;
        clk             : in     vl_logic;
        ena             : in     vl_logic;
        update          : in     vl_logic;
        devclrn         : in     vl_logic;
        devpor          : in     vl_logic;
        dqsbusoutdelaysetting: out    vl_logic_vector(3 downto 0);
        dqsinputphasesetting: out    vl_logic_vector(2 downto 0);
        dqsenablectrlphasesetting: out    vl_logic_vector(3 downto 0);
        dqsoutputphasesetting: out    vl_logic_vector(3 downto 0);
        dqoutputphasesetting: out    vl_logic_vector(3 downto 0);
        resyncinputphasesetting: out    vl_logic_vector(3 downto 0);
        dividerphasesetting: out    vl_logic;
        enaoctcycledelaysetting: out    vl_logic;
        enainputcycledelaysetting: out    vl_logic;
        enaoutputcycledelaysetting: out    vl_logic;
        dqsenabledelaysetting: out    vl_logic_vector(2 downto 0);
        octdelaysetting1: out    vl_logic_vector(3 downto 0);
        octdelaysetting2: out    vl_logic_vector(2 downto 0);
        enadataoutbypass: out    vl_logic;
        enadqsenablephasetransferreg: out    vl_logic;
        enaoctphasetransferreg: out    vl_logic;
        enaoutputphasetransferreg: out    vl_logic;
        enainputphasetransferreg: out    vl_logic;
        resyncinputphaseinvert: out    vl_logic;
        dqsenablectrlphaseinvert: out    vl_logic;
        dqoutputphaseinvert: out    vl_logic;
        dqsoutputphaseinvert: out    vl_logic;
        dqsbusoutfinedelaysetting: out    vl_logic;
        dqsenablefinedelaysetting: out    vl_logic;
        dataout         : out    vl_logic
    );
end stratixiii_dqs_config;
