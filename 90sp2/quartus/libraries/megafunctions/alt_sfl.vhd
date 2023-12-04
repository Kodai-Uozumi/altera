---------------- ALT_SFL -----------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

package INSTR_CONST is
	constant IDLE_INSTR         : natural := 0;
	constant START_INDEX_INSTR  : natural := 1;
	constant STOP_INDEX_INSTR   : natural := 2;
	constant DATA_SHIFT_INSTR   : natural := 3;
	constant SFL_VERSION        : natural := 1;
	constant SFL_N_VERSION_BITS : natural := 3;
	constant SFL_N_IR_BITS      : natural := 4;
	constant SFL_N_ADDRESS_BITS : natural := 27;
end package INSTR_CONST;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_ARITH.all;
use IEEE.std_logic_SIGNED.all;
use WORK.INSTR_CONST.all;

entity alt_sfl is
	generic
	(
		ADDRESS_WIDTH : natural := SFL_N_ADDRESS_BITS;
		SLD_NODE_INFO : natural := 2125312
	);
	port
	(
		-- HUB IOs
		ir_in          : in std_logic_vector(SFL_N_IR_BITS - 1 downto 0);
		ir_out         : out std_logic_vector(SFL_N_IR_BITS - 1 downto 0);
		tdi            : in std_logic;
		raw_tck        : in std_logic;
		usr1           : in std_logic;
		jtag_state_sdr : in std_logic;
		jtag_state_rti : in std_logic;
		tdo            : out std_logic;

		-- ASMI IOs
		dclkin              : OUT std_logic;
		scein               : OUT std_logic;
		sdoin               : OUT std_logic;
		asmi_access_request : OUT std_logic;
		data0out            : IN std_logic;
		asmi_access_granted : IN std_logic := '1'
	);
end entity alt_sfl;

architecture rtl of alt_sfl is
	component lpm_shiftreg
	generic
	(
		LPM_WIDTH     : positive;
		LPM_AVALUE    : string := "UNUSED";
		LPM_SVALUE    : string := "UNUSED";
		LPM_PVALUE    : string := "UNUSED";
		LPM_DIRECTION : string := "UNUSED";
		LPM_TYPE      : string := "LPM_SHIFTREG";
		LPM_HINT      : string := "UNUSED"
	);
	port
	(
		data             : IN std_logic_vector(LPM_WIDTH-1 downto 0) := (OTHERS => '0');
		clock            : IN std_logic;
		enable, shiftin  : IN std_logic := '1';
		load, sclr, sset : IN std_logic := '0';
		aclr, aset       : IN std_logic := '0';
		q                : OUT std_logic_vector(LPM_WIDTH-1 downto 0);
		shiftout         : OUT std_logic
	);
	end component lpm_shiftreg;

	component lpm_counter
	generic
	(
		LPM_WIDTH     : positive;
		LPM_MODULUS   : natural := 0;
		LPM_DIRECTION : string := "UNUSED";
		LPM_AVALUE    : string := "UNUSED";
		LPM_SVALUE    : string := "UNUSED";
		LPM_PVALUE    : string := "UNUSED";
		LPM_TYPE      : string := "LPM_COUNTER";
		LPM_HINT      : string := "UNUSED"
	);
	port
	(
		data   : IN std_logic_vector(LPM_WIDTH-1 downto 0) := (OTHERS => '0');
		clock  : IN std_logic;
		clk_en : IN std_logic := '1';
		cnt_en : IN std_logic := '1';
		updown : IN std_logic := '1';
		sload  : IN std_logic := '0';
		sset   : IN std_logic := '0';
		sclr   : IN std_logic := '0';
		aload  : IN std_logic := '0';
		aset   : IN std_logic := '0';
		aclr   : IN std_logic := '0';
		cin    : IN std_logic := '0';
		cout   : OUT std_logic;
		q      : OUT std_logic_vector(LPM_WIDTH-1 downto 0)
	);
	end component;

	signal jtag_sdr          : std_logic;
	signal tck               : std_logic;
	signal start_index_inst  : std_logic;
	signal stop_index_inst   : std_logic;
	signal data_shift_inst   : std_logic;
	signal idle_inst         : std_logic;
	signal sdr               : std_logic;
	signal drscan            : std_logic;
	signal master_dclk_en    : std_logic;
	signal device_dclk_en    : std_logic;
	signal bit_counter_clr   : std_logic;
	signal total_bit_count   : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
	signal start_index_sout  : std_logic;
	signal start_index_value : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
	signal stop_index_sout   : std_logic;
	signal stop_index_value  : std_logic_vector(ADDRESS_WIDTH - 1 downto 0);
	signal tdo_reg_in        : std_logic;
	signal bypass_out        : std_logic;
	signal ir_out_int        : std_logic_vector(SFL_N_IR_BITS - 1 downto 0);

begin
	bit_counter: lpm_counter
	generic map
	(
		LPM_WIDTH => ADDRESS_WIDTH
	)
	port map
	(
		clock  => tck,
		clk_en => master_dclk_en,
		aclr   => bit_counter_clr,
		q      => total_bit_count
	);

	start_index: lpm_shiftreg
	generic map
	(
		LPM_WIDTH     => ADDRESS_WIDTH,
		LPM_DIRECTION => "RIGHT"
	)
	port map
	(
		clock    => tck,
		enable   => start_index_inst and sdr,
		shiftin  => tdi,
		shiftout => start_index_sout,
		q        => start_index_value
	);

	stop_index: lpm_shiftreg
	generic map
	(
		LPM_WIDTH     => ADDRESS_WIDTH,
		LPM_DIRECTION => "RIGHT"
	)
	port map
	(
		clock    => tck,
		enable   => stop_index_inst and sdr,
		shiftin  => tdi,
		shiftout => stop_index_sout,
		q        => stop_index_value
	);

	-- set the instructions signals
	start_index_inst    <= ir_in(START_INDEX_INSTR);
	stop_index_inst     <= ir_in(STOP_INDEX_INSTR);
	data_shift_inst     <= ir_in(DATA_SHIFT_INSTR);
	idle_inst           <= ir_in(IDLE_INSTR);
	drscan              <= not usr1;
	sdr                 <= drscan and jtag_sdr;
	tck                 <= raw_tck;
	jtag_sdr            <= jtag_state_sdr;
	master_dclk_en      <= sdr and data_shift_inst;
	sdoin               <= tdi;
	dclkin              <= tck;
	bit_counter_clr     <= stop_index_inst or jtag_state_rti;
	asmi_access_request <= start_index_inst or stop_index_inst or data_shift_inst;

	-- generate enable signal
	process(master_dclk_en, stop_index_value, start_index_value, total_bit_count)
	begin
		if((master_dclk_en) = '1') then
			if ((total_bit_count >= start_index_value) and (total_bit_count < stop_index_value)) then
				device_dclk_en <= '1';
			else
				device_dclk_en <= '0';
			end if;
		else
			device_dclk_en <= '0';
		end if;
	end process;

	process(data0out, device_dclk_en, tdi, tck)
	begin
		if rising_edge(tck) then
			if(device_dclk_en = '1') then
				tdo_reg_in <= data0out;
			else
				tdo_reg_in <= tdi;
			end if;
		end if;
	end process;

	-- bypass
	process(tck, idle_inst, tdi)
	begin
		if rising_edge(tck) then
			if (idle_inst = '1') then
				bypass_out <= tdi;
			else
				bypass_out <= '0';
			end if;
		end if;
	end process;

	-- set TDO
	process(start_index_inst, stop_index_inst, data_shift_inst, stop_index_sout, start_index_sout, tdo_reg_in, bypass_out)
	begin
		if(start_index_inst = '1') then
			tdo <= start_index_sout;
		elsif(stop_index_inst = '1') then
			tdo <= stop_index_sout;
		elsif(data_shift_inst = '1') then
			tdo <= tdo_reg_in;
		else
			tdo <= bypass_out;
		end if;
	end process;

	-- change sce on falling edge
	process(tck, device_dclk_en)
	begin
		if falling_edge(tck) then
			scein <= not device_dclk_en;
		end if;
	end process;

	ir_out_int <= asmi_access_granted &
		CONV_STD_LOGIC_VECTOR(CONV_UNSIGNED(SFL_VERSION, SFL_N_VERSION_BITS), SFL_N_VERSION_BITS);
	ir_out <= ir_out_int;
end architecture rtl;
