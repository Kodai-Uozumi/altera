library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

package FIFOSM_CONST is
	type FIFOSM_STATE is
	(
		STATE_START,
		STATE_EXIT,
		STATE_INTEL_UNLOCK,
		STATE_SPANSION_UNLOCK_1,
		STATE_SPANSION_UNLOCK_2,
		STATE_CUSTOM_WRITE,
		STATE_INST_1,
		STATE_INST_2,
		STATE_INTEL_WRITE_BUFFER_CNFM,
		STATE_SPANSION_WRITE_BUFFER_CNFM,
		STATE_SYNC,
		STATE_SET_ADDR,
		STATE_SET_INST,
		STATE_SET_PARAM,
		STATE_SPANSION_UNLOCK_BYPASS
	);
	constant PFL_INFO							: STD_LOGIC_VECTOR(4 downto 0) := "10001"; --0x11
	constant PFL_READ							: STD_LOGIC_VECTOR(4 downto 0) := "10010"; --0x12
	constant PFL_ADDR							: STD_LOGIC_VECTOR(4 downto 0) := "10100"; --0x14
	constant PFL_WRITE							: STD_LOGIC_VECTOR(4 downto 0) := "11000"; --0x18
	constant PFL_ENA_CFG						: STD_LOGIC_VECTOR(4 downto 0) := "00000"; --0x00
	constant PFL_STATE_MACHINE					: STD_LOGIC_VECTOR(4 downto 0) := "01111"; --0x0f
	constant FIFOSM_START						: STD_LOGIC_VECTOR(4 downto 0) := "00001"; --0x01
	constant FIFOSM_EXIT						: STD_LOGIC_VECTOR(4 downto 0) := "11111"; --0x1f
	constant FIFOSM_INTEL_UNLOCK				: STD_LOGIC_VECTOR(4 downto 0) := "00010"; --0x02
	constant FIFOSM_SPANSION_UNLOCK_1			: STD_LOGIC_VECTOR(4 downto 0) := "00011"; --0x03
	constant FIFOSM_SPANSION_UNLOCK_2			: STD_LOGIC_VECTOR(4 downto 0) := "00100"; --0x04
	constant FIFOSM_CUSTOM_WRITE				: STD_LOGIC_VECTOR(4 downto 0) := "00101"; --0x05
	constant FIFOSM_INST_1						: STD_LOGIC_VECTOR(4 downto 0) := "00110"; --0x06
	constant FIFOSM_INST_2						: STD_LOGIC_VECTOR(4 downto 0) := "00111"; --0x07
	constant FIFOSM_INTEL_WRITE_BUFFER_CNFM		: STD_LOGIC_VECTOR(4 downto 0) := "01000"; --0x08
	constant FIFOSM_SPANSION_WRITE_BUFFER_CNFM	: STD_LOGIC_VECTOR(4 downto 0) := "01001"; --0x09
	constant FIFOSM_SYNC						: STD_LOGIC_VECTOR(4 downto 0) := "01010"; --0x0a
	constant FIFOSM_SET_ADDR					: STD_LOGIC_VECTOR(4 downto 0) := "01011"; --0x0b
	constant FIFOSM_SET_INST 					: STD_LOGIC_VECTOR(4 downto 0) := "01100"; --0x0c
	constant FIFOSM_SET_PARAM					: STD_LOGIC_VECTOR(4 downto 0) := "01101"; --0x0d
	constant FIFOSM_SPANSION_UNLOCK_BYPASS		: STD_LOGIC_VECTOR(4 downto 0) := "01110"; --0x0e
end package FIFOSM_CONST;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use WORK.FIFOSM_CONST.all;

entity alt_pfl_pgm_fifo_sm is
	generic
	(
		DATA_WIDTH			: natural	:= 16;
		ADDR_WIDTH			: natural	:= 20;
		PFL_IR_BITS			: natural	:= 5;
		DATA_REG_WIDTH		: natural := 16 + 1;
		ADDR_REG_WIDTH		: natural := 20;
		INST_REG_WIDTH		: natural := 2 * 8;
		PARAM_REG_WIDTH		: natural := 13;
		SYNC_REG_WIDTH		: natural := 1;
		STATUS_REG_WIDTH	: natural := 3;
		BYPASS_REG_WIDTH	: natural := 1;
		FIFO_SIZE		 	: natural := 16
	);
	port
	(
		-- Input ports
		inst_out			: in  STD_LOGIC_VECTOR(INST_REG_WIDTH-1 downto 0);
		data_out			: in  STD_LOGIC_VECTOR(DATA_REG_WIDTH-1 downto 0);
		vjtag_ir_in			: in  STD_LOGIC_VECTOR(PFL_IR_BITS-1 downto 0);
		vjtag_tck			: in  STD_LOGIC;
		vjtag_tdi			: in  STD_LOGIC;
		vjtag_virtual_state_cdr		: in  STD_LOGIC;
		vjtag_virtual_state_e1dr	: in  STD_LOGIC;
		vjtag_virtual_state_e2dr	: in  STD_LOGIC;
		vjtag_virtual_state_pdr		: in  STD_LOGIC;
		vjtag_virtual_state_sdr		: in  STD_LOGIC;
		vjtag_virtual_state_udr		: in  STD_LOGIC;
		vjtag_virtual_state_cir		: in  STD_LOGIC;
		vjtag_virtual_state_uir		: in  STD_LOGIC;
		scfifo_full			: in  STD_LOGIC;
		param_tdo			: in  STD_LOGIC;
		status_tdo			: in  STD_LOGIC;
		inst_tdo			: in  STD_LOGIC;
		bypass_tdo			: in  STD_LOGIC;
		addr_tdo			: in  STD_LOGIC;
		data_tdo			: in  STD_LOGIC;

		-- Output ports
		vjtag_tdo			: out STD_LOGIC;
		is_state_machine_mode	: out STD_LOGIC;
		scfifo_wrreq		: out STD_LOGIC;
		scfifo_aclr			: out STD_LOGIC;
		scfifo_data			: out STD_LOGIC_VECTOR(DATA_REG_WIDTH-1 downto 0);
		param_reg_enable	: out STD_LOGIC;
		status_reg_enable	: out STD_LOGIC;
		inst_reg_enable		: out STD_LOGIC;
		bypass_reg_enable	: out STD_LOGIC;
		addr_counter_enable	: out STD_LOGIC;
		data_reg_enable		: out STD_LOGIC;
		sync_reg_aclr		: out STD_LOGIC;
		sync_reg_aset		: out STD_LOGIC;
		status_reg_update	: out STD_LOGIC;
		status_reg_aclr		: out STD_LOGIC;
		status_reg_set_full	: out STD_LOGIC;
		flashsm_reset		: out STD_LOGIC
	);
end entity alt_pfl_pgm_fifo_sm;

architecture controller of alt_pfl_pgm_fifo_sm is

	signal present_state					: FIFOSM_STATE;
	signal control_signals					: STD_LOGIC_VECTOR(8 downto 0);
	signal scfifo_aclr_signal				: STD_LOGIC;
	signal scfifo_wrreq_signal				: STD_LOGIC;
	signal scfifo_data_signal				: STD_LOGIC_VECTOR(DATA_REG_WIDTH-1 downto 0);
	signal inst_out_signal					: STD_LOGIC_VECTOR(INST_REG_WIDTH-1 downto 0);
	signal sm_active						: STD_LOGIC_VECTOR(0 downto 0);

	constant INTEL_FL_UNLOCK				: STD_LOGIC_VECTOR(31 downto 0) := x"00000060";
	constant SPANSION_FL_UNLOCK_1			: STD_LOGIC_VECTOR(31 downto 0) := x"000000aa";
	constant SPANSION_FL_UNLOCK_2			: STD_LOGIC_VECTOR(31 downto 0) := x"00000055";
	constant INTEL_FL_WRITE_BUFFER_CNFM		: STD_LOGIC_VECTOR(31 downto 0) := x"000000d0";
	constant SPANSION_FL_WRITE_BUFFER_CNFM	: STD_LOGIC_VECTOR(31 downto 0) := x"00000029";
	constant SPANSION_FL_UNLOCK_BYPASS		: STD_LOGIC_VECTOR(31 downto 0) := x"00000020";

begin

	activate_state_machine : process (vjtag_tck)
	begin
		-- Negative edge-triggered so that the signal is available before going into STATE_START at the next positive edge
		if (vjtag_tck'event and vjtag_tck='0') then
			if ( vjtag_ir_in(4)='0' ) then
				if ( vjtag_ir_in = PFL_ENA_CFG ) then
					sm_active(0) <= '0';
				else
					sm_active(0) <= '1';
				end if;
			else
				sm_active(0) <= '0';
			end if;
		end if;
	end process activate_state_machine;

	is_state_machine_mode <= sm_active(0);


	run_state_machine : process (vjtag_tck)
	begin
		if (vjtag_tck'event and vjtag_tck='1') then
			-- Only run the state machine if it is activated
			if (sm_active(0) = '1') then
				if (vjtag_ir_in = FIFOSM_START) then present_state <= STATE_START;
				elsif (vjtag_ir_in = FIFOSM_SET_PARAM) then present_state <= STATE_SET_PARAM;
				elsif (vjtag_ir_in = FIFOSM_SET_INST) then present_state <= STATE_SET_INST;
				elsif (vjtag_ir_in = FIFOSM_SET_ADDR) then present_state <= STATE_SET_ADDR;
				elsif (vjtag_ir_in = FIFOSM_CUSTOM_WRITE) then present_state <= STATE_CUSTOM_WRITE;
				elsif (vjtag_ir_in = FIFOSM_INST_1) then present_state <= STATE_INST_1;
				elsif (vjtag_ir_in = FIFOSM_INST_2) then present_state <= STATE_INST_2;
				elsif (vjtag_ir_in = FIFOSM_INTEL_UNLOCK) then present_state <= STATE_INTEL_UNLOCK;
				elsif (vjtag_ir_in = FIFOSM_SPANSION_UNLOCK_1) then present_state <= STATE_SPANSION_UNLOCK_1;
				elsif (vjtag_ir_in = FIFOSM_SPANSION_UNLOCK_2) then present_state <= STATE_SPANSION_UNLOCK_2;
				elsif (vjtag_ir_in = FIFOSM_SYNC) then present_state <= STATE_SYNC;
				elsif (vjtag_ir_in = PFL_STATE_MACHINE) then present_state <= STATE_START;
				elsif (vjtag_ir_in = FIFOSM_EXIT) then present_state <= STATE_EXIT;
				elsif (vjtag_ir_in = FIFOSM_INTEL_WRITE_BUFFER_CNFM) then present_state <= STATE_INTEL_WRITE_BUFFER_CNFM;
				elsif (vjtag_ir_in = FIFOSM_SPANSION_WRITE_BUFFER_CNFM) then present_state <= STATE_SPANSION_WRITE_BUFFER_CNFM;
				elsif (vjtag_ir_in = FIFOSM_SPANSION_UNLOCK_BYPASS) then present_state <= STATE_SPANSION_UNLOCK_BYPASS;
				else present_state <= STATE_EXIT;
				end if;
			else
				present_state <= STATE_EXIT;
			end if;
		end if;
	end process run_state_machine;

	-- Output signals
--	fifosm_output : process (present_state, data_out, inst_out, bypass_tdo, param_tdo, inst_tdo, status_tdo, addr_tdo, data_tdo)
	fifosm_output : process (vjtag_tck)
	begin
		if (vjtag_tck'event and vjtag_tck='1') then
			case (present_state) is
				when STATE_START =>
					scfifo_aclr_signal <= '1';
					scfifo_wrreq_signal <= '0';
					scfifo_data_signal <= (others => '1');
					vjtag_tdo <= bypass_tdo; 
				when STATE_EXIT =>
					scfifo_aclr_signal <= '1';
					scfifo_wrreq_signal <= '0';
					scfifo_data_signal <= (others => '1');
					vjtag_tdo <= bypass_tdo; 
				when STATE_SET_PARAM =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '0';
					scfifo_data_signal <= (others => '1');
					vjtag_tdo <= param_tdo; 
				when STATE_SET_INST =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '0';
					scfifo_data_signal <= (others => '1');
					vjtag_tdo <= inst_tdo; 
				when STATE_SET_ADDR =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '0';
					scfifo_data_signal <= (others => '1');
					vjtag_tdo <= addr_tdo; 
				when STATE_SYNC =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '0';
					scfifo_data_signal <= (others => '1');
					vjtag_tdo <= status_tdo; 
				when STATE_CUSTOM_WRITE =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= data_out;
					vjtag_tdo <= data_tdo; 
				when STATE_INST_1 =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= inst_out_signal(DATA_WIDTH-1 downto 0) & '1';
					vjtag_tdo <= bypass_tdo; 
				when STATE_INST_2 =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= inst_out_signal(DATA_WIDTH-1 downto 0) & '1';
					vjtag_tdo <= bypass_tdo; 
				when STATE_INTEL_UNLOCK =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= INTEL_FL_UNLOCK(DATA_WIDTH-1  downto 0) & '1';
					vjtag_tdo <= bypass_tdo; 
				when STATE_SPANSION_UNLOCK_1 =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= SPANSION_FL_UNLOCK_1(DATA_WIDTH-1  downto 0) & '1';
					vjtag_tdo <= bypass_tdo; 
				when STATE_SPANSION_UNLOCK_2 =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= SPANSION_FL_UNLOCK_2(DATA_WIDTH-1  downto 0) & '1';
					vjtag_tdo <= bypass_tdo; 
				when STATE_SPANSION_UNLOCK_BYPASS =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= SPANSION_FL_UNLOCK_BYPASS(DATA_WIDTH-1  downto 0) & '1';
					vjtag_tdo <= bypass_tdo; 
				when STATE_INTEL_WRITE_BUFFER_CNFM =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= INTEL_FL_WRITE_BUFFER_CNFM(DATA_WIDTH-1  downto 0) & '0';
					vjtag_tdo <= bypass_tdo; 
				when STATE_SPANSION_WRITE_BUFFER_CNFM =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '1';
					scfifo_data_signal <= SPANSION_FL_WRITE_BUFFER_CNFM(DATA_WIDTH-1  downto 0) & '0';
					vjtag_tdo <= bypass_tdo; 
				when others =>
					scfifo_aclr_signal <= '0';
					scfifo_wrreq_signal <= '0';
					scfifo_data_signal <= (others => '1');
					vjtag_tdo <= bypass_tdo; 
			end case;
		end if;
	end process fifosm_output;

	with present_state select
		inst_out_signal <=	x"000000" & inst_out((INST_REG_WIDTH/4)-1 downto 0) when STATE_INST_1,
							x"000000" & inst_out((INST_REG_WIDTH/2)-1 downto INST_REG_WIDTH/4) when STATE_INST_2,
							(others => '1') when others;

	with present_state select
		control_signals <=	"000001011" when STATE_START,
							"000000001" when STATE_EXIT,
							"010000001" when STATE_SET_ADDR,
							"001000001" when STATE_SET_INST,
							"000100001" when STATE_SET_PARAM,
							"000000100" when STATE_SYNC,
							"100010000" when STATE_CUSTOM_WRITE,
							"000010000" when STATE_INST_1,
							"000010000" when STATE_INST_2,
							"000010000" when STATE_INTEL_UNLOCK,
							"000010000" when STATE_SPANSION_UNLOCK_1,
							"000010000" when STATE_SPANSION_UNLOCK_2,
							"000010000" when STATE_INTEL_WRITE_BUFFER_CNFM,
							"000010000" when STATE_SPANSION_WRITE_BUFFER_CNFM,
							"000010000" when STATE_SPANSION_UNLOCK_BYPASS,
							"000000001" when others;

	-- Output signals to registers
	data_reg_enable <= control_signals(8) and vjtag_virtual_state_sdr;
	addr_counter_enable <= control_signals(7) and vjtag_virtual_state_sdr;
	inst_reg_enable <= control_signals(6) and vjtag_virtual_state_sdr;
	param_reg_enable <= control_signals(5) and vjtag_virtual_state_sdr ;
	bypass_reg_enable <= control_signals(4) and vjtag_virtual_state_sdr;
	sync_reg_aclr <= control_signals(3);
	sync_reg_aset <= control_signals(2);
	status_reg_aclr <= control_signals(1);
	flashsm_reset <= control_signals(0);

	status_reg_set_full <= scfifo_full and scfifo_wrreq_signal;

	status_reg_control: process (present_state, vjtag_virtual_state_cdr, vjtag_virtual_state_sdr)
	begin
		if (present_state = STATE_SYNC) then
			if (vjtag_virtual_state_cdr = '1') then
				status_reg_enable <= '1';
				status_reg_update <= '1'; --update status_reg internal reg in virtual_cdr state
			elsif (vjtag_virtual_state_sdr = '1') then
				status_reg_enable <= '1';
				status_reg_update <= '0';
			else 
				status_reg_enable <= '0';
				status_reg_update <= '0';
			end if;
		else
			status_reg_enable <= '0';
			status_reg_update <= '0';
		end if;
	end process;

	scfifo_aclr <= scfifo_aclr_signal;
	scfifo_data <= scfifo_data_signal;

	scfifo_wrreq_control: process (scfifo_wrreq_signal, vjtag_virtual_state_udr, vjtag_virtual_state_uir, present_state)
	begin
		if ( scfifo_wrreq_signal = '1' and (vjtag_virtual_state_udr = '1' or vjtag_virtual_state_uir = '1') ) then
			if (present_state=STATE_CUSTOM_WRITE or present_state=STATE_INTEL_WRITE_BUFFER_CNFM or present_state=STATE_SPANSION_WRITE_BUFFER_CNFM) then
				if (vjtag_virtual_state_uir = '1') then
					scfifo_wrreq <= '0';
				else
					scfifo_wrreq <= '1';
				end if;
			else 
				scfifo_wrreq <= '1';
			end if;
		else
			scfifo_wrreq <= '0';
		end if;
	end process scfifo_wrreq_control;

end architecture controller;
