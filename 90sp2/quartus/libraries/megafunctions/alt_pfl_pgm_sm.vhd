library IEEE;
use IEEE.STD_LOGIC_1164.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity alt_pfl_pgm_sm is
	generic
	(
		DATA_WIDTH	: natural	:= 16;
		ADDR_WIDTH	: natural	:= 20;
		PFL_IR_BITS	: natural	:= 5;
		FIFO_SIZE	: natural	:= 16
	);
	port
	(
		-- Input ports
		addr_out					: in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		data_out					: in  STD_LOGIC_VECTOR(DATA_WIDTH downto 0);
		addr_tdo					: in  STD_LOGIC;
		data_tdo					: in  STD_LOGIC;
		flash_data_in				: in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
		vjtag_ir_in					: in  STD_LOGIC_VECTOR(PFL_IR_BITS-1 downto 0);
		vjtag_tck					: in  STD_LOGIC;
		vjtag_tdi					: in  STD_LOGIC;
		vjtag_virtual_state_cdr		: in  STD_LOGIC;
		vjtag_virtual_state_e1dr	: in  STD_LOGIC;
		vjtag_virtual_state_e2dr	: in  STD_LOGIC;
		vjtag_virtual_state_pdr		: in  STD_LOGIC;
		vjtag_virtual_state_sdr		: in  STD_LOGIC;
		vjtag_virtual_state_udr		: in  STD_LOGIC;
		vjtag_virtual_state_cir		: in  STD_LOGIC;
		vjtag_virtual_state_uir		: in  STD_LOGIC;

		-- Output ports
		vjtag_tdo					: out STD_LOGIC;
		is_state_machine_mode		: out STD_LOGIC;
		flash_select				: out STD_LOGIC;
		flash_read					: out STD_LOGIC;
		flash_write					: out STD_LOGIC;
		flash_addr					: out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
		flash_data_out				: out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
		flash_data_highz			: out STD_LOGIC;
		addr_count					: out STD_LOGIC;
		addr_counter_enable			: out STD_LOGIC;
		data_reg_enable				: out STD_LOGIC
	);
end entity alt_pfl_pgm_sm;

architecture structure of alt_pfl_pgm_sm is

	function log2(A: integer) return integer is
	begin
	  for I in 1 to 30 loop  -- Works for up to 32 bit integers
	    if(2**I > A) then return(I-1);  end if;
	  end loop;
	  return(30);
	end;

	constant DATA_REG_WIDTH		: natural := DATA_WIDTH + 1;
	constant ADDR_REG_WIDTH		: natural := ADDR_WIDTH;
	constant INST_REG_WIDTH		: natural := 4 * 8;
	constant PARAM_REG_WIDTH	: natural := 13;
	constant SYNC_REG_WIDTH		: natural := 1;
	constant STATUS_REG_WIDTH	: natural := 3;
	constant BYPASS_REG_WIDTH	: natural := 1;

	signal param_tdo			: STD_LOGIC;
	signal status_tdo			: STD_LOGIC;
	signal inst_tdo				: STD_LOGIC;
	signal bypass_tdo			: STD_LOGIC;
--	signal sync_tdo				: STD_LOGIC;
	signal param_reg_enable		: STD_LOGIC;
	signal status_reg_enable	: STD_LOGIC;
	signal inst_reg_enable		: STD_LOGIC;
	signal bypass_reg_enable	: STD_LOGIC;
--	signal sync_reg_enable		: STD_LOGIC;
--	signal addr_counter_enable	: STD_LOGIC;
--	signal data_reg_enable		: STD_LOGIC;
	signal sync_reg_aclr		: STD_LOGIC;
	signal sync_reg_aset		: STD_LOGIC;
	signal status_reg_update	: STD_LOGIC;
	signal status_reg_aclr		: STD_LOGIC;
	signal status_reg_set_full	: STD_LOGIC;
	signal status_reg_set_done	: STD_LOGIC;
	signal status_reg_set_error	: STD_LOGIC;
	signal status_reg_full_bit	: STD_LOGIC;
	signal scfifo_aclr			: STD_LOGIC;
	signal scfifo_empty			: STD_LOGIC;
	signal scfifo_full			: STD_LOGIC;
	signal scfifo_rdreq			: STD_LOGIC;
	signal scfifo_wrreq			: STD_LOGIC;

	signal param_out			: STD_LOGIC_VECTOR(PARAM_REG_WIDTH-1 downto 0);
	signal inst_out				: STD_LOGIC_VECTOR(INST_REG_WIDTH-1 downto 0);
	signal is_sync				: STD_LOGIC_VECTOR(SYNC_REG_WIDTH-1 downto 0);
	signal scfifo_data			: STD_LOGIC_VECTOR(DATA_REG_WIDTH-1 downto 0);
	signal scfifo_q				: STD_LOGIC_VECTOR(DATA_REG_WIDTH-1 downto 0);
--	signal scfifo_usedw			: STD_LOGIC_VECTOR(log2(FIFO_SIZE)-1 downto 0);

	signal flashsm_reset		: STD_LOGIC;

	signal debug_signal			: STD_LOGIC_VECTOR(23 downto 15);

	COMPONENT lpm_ff
		GENERIC
		(
			lpm_fftype		: STRING;
			lpm_type		: STRING;
			lpm_width		: NATURAL
		);
		PORT
		(
			aclr	: IN STD_LOGIC ;
			clock	: IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
			data	: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
			aset	: IN STD_LOGIC 
		);
	END COMPONENT;

	COMPONENT lpm_shiftreg
		GENERIC
		(
			lpm_direction	: STRING;
			lpm_type		: STRING;
			lpm_width		: NATURAL
		);
		PORT
		(
				enable	: IN STD_LOGIC ;
				clock	: IN STD_LOGIC ;
				q	: OUT STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
				shiftout	: OUT STD_LOGIC ;
				shiftin	: IN STD_LOGIC
		);
	END COMPONENT;

	component alt_pfl_pgm_status_register
		PORT
		(
			enable			: IN STD_LOGIC ;
			clk				: in STD_LOGIC;
			shiftin			: in STD_LOGIC;
			load			: in STD_LOGIC;
			aclr 			: in STD_LOGIC;
			set_full			: in STD_LOGIC;
			set_done			: in STD_LOGIC;
			set_error 			: in STD_LOGIC;
			shiftout		: out STD_LOGIC;
			full_bit		: out STD_LOGIC;
			pout			: out STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	end component;

	COMPONENT scfifo
		GENERIC
		(
			add_ram_output_register		: STRING;
			intended_device_family		: STRING;
			lpm_numwords		: NATURAL;
			lpm_showahead		: STRING;
			lpm_type		: STRING;
			lpm_width		: NATURAL;
			lpm_widthu		: NATURAL;
			overflow_checking		: STRING;
			underflow_checking		: STRING;
			use_eab		: STRING
		);
		PORT
		(
--			usedw	: OUT STD_LOGIC_VECTOR (lpm_widthu-1 DOWNTO 0);
			rdreq	: IN STD_LOGIC ;
			empty	: OUT STD_LOGIC ;
			aclr	: IN STD_LOGIC ;
			clock	: IN STD_LOGIC ;
			q	: OUT STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			wrreq	: IN STD_LOGIC ;
			data	: IN STD_LOGIC_VECTOR (lpm_width-1 DOWNTO 0);
			full	: OUT STD_LOGIC 
		);
	END COMPONENT;

	component alt_pfl_pgm_fifo_sm
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
			BYPASS_REG_WIDTH	: natural := 1
		);
		port
		(
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
	
			vjtag_tdo			: out STD_LOGIC;
			is_state_machine_mode	: out STD_LOGIC;
			scfifo_wrreq		: out STD_LOGIC;
			scfifo_aclr			: out STD_LOGIC;
			scfifo_data			: out STD_LOGIC_VECTOR(DATA_WIDTH downto 0);
			param_reg_enable	: out STD_LOGIC;
			status_reg_enable	: out STD_LOGIC;
			inst_reg_enable		: out STD_LOGIC;
			bypass_reg_enable	: out STD_LOGIC;
			addr_counter_enable	: out STD_LOGIC;
			data_reg_enable		: out STD_LOGIC;
			sync_reg_aclr		: out STD_LOGIC;
			sync_reg_aset		: out STD_LOGIC;
			status_reg_update		: out STD_LOGIC;
			status_reg_aclr		: out STD_LOGIC;
			status_reg_set_full	: out STD_LOGIC;
			flashsm_reset		: out STD_LOGIC
		);
	end component;

	component alt_pfl_pgm_flash_sm
		generic 
		(
			ADDR_WIDTH		: natural := 20;-- from 19 for 8Mbits, up to 25 for 512Mbits
			DATA_WIDTH		: natural := 8 -- valid values are 8 and 16
		);
		port
		(
			clk				: in STD_LOGIC;
			reset			: in STD_LOGIC;
			
			--scfifo
			scfifo_data_in	: in STD_LOGIC_VECTOR (DATA_WIDTH DOWNTO 0);
			scfifo_empty	: in STD_LOGIC;
			scfifo_rdreq	: out STD_LOGIC := '0';
			
			--sync_reg
			is_sync			: in STD_LOGIC;
			
			--param_reg
			param_in		: in STD_LOGIC_VECTOR (12 DOWNTO 0);
			
			--flash
			flash_select	: out STD_LOGIC;
			flash_write		: out STD_LOGIC := '0';
			flash_read		: out STD_LOGIC := '0';
			flash_data_highz: out STD_LOGIC;
			flash_data_in	: in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			flash_data_out	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
			flash_addr_out	: out STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
			
			--addr_counter
			addr_in			: in STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
			addr_count		: out STD_LOGIC;
					
			--status_reg
			status_full		: in STD_LOGIC;
			status_done		: out STD_LOGIC;
			status_error	: out STD_LOGIC
		);
	end component;

begin

	status_reg : alt_pfl_pgm_status_register
		PORT MAP (
			enable		=> status_reg_enable,
			clk			=> vjtag_tck,
			shiftin		=> vjtag_tdi,
			load		=> status_reg_update,
			aclr		=> status_reg_aclr,
			set_full	=> status_reg_set_full,
			set_done	=> status_reg_set_done,
			set_error	=> status_reg_set_error,
			full_bit	=> status_reg_full_bit,
			shiftout	=> status_tdo
		);

	bypass_reg : lpm_shiftreg
		GENERIC MAP
		(
			lpm_direction => "RIGHT",
			lpm_type => "LPM_SHIFTREG",
			lpm_width => BYPASS_REG_WIDTH
		)
		PORT MAP
		(
			enable => bypass_reg_enable,
			clock => vjtag_tck,
			shiftin => vjtag_tdi,
			shiftout => bypass_tdo
		);

	param_reg : lpm_shiftreg
		GENERIC MAP
		(
			lpm_direction => "RIGHT",
			lpm_type => "LPM_SHIFTREG",
			lpm_width => PARAM_REG_WIDTH
		)
		PORT MAP
		(
			enable => param_reg_enable,
			clock => vjtag_tck,
			shiftin => vjtag_tdi,
			q => param_out,
			shiftout => param_tdo
		);

	inst_reg : lpm_shiftreg
		GENERIC MAP
		(
			lpm_direction => "RIGHT",
			lpm_type => "LPM_SHIFTREG",
			lpm_width => INST_REG_WIDTH
		)
		PORT MAP
		(
			enable => inst_reg_enable,
			clock => vjtag_tck,
			shiftin => vjtag_tdi,
			q => inst_out,
			shiftout => inst_tdo
		);

	sync_reg : lpm_ff
		GENERIC MAP
		(
			lpm_fftype => "DFF",
			lpm_type => "LPM_FF",
			lpm_width => 1
		)
		PORT MAP
		(
			aclr => sync_reg_aclr,
			clock => vjtag_tck,
			data => is_sync,
			aset => sync_reg_aset,
			q => is_sync
		);

	scfifo_buffer : scfifo
		GENERIC MAP
		(
			add_ram_output_register => "ON",
			intended_device_family => "Cyclone II",
			lpm_numwords => FIFO_SIZE,
			lpm_showahead => "OFF",
			lpm_type => "scfifo",
			lpm_width => DATA_REG_WIDTH,
			lpm_widthu => log2(FIFO_SIZE),
			overflow_checking => "ON",
			underflow_checking => "ON",
			use_eab => "ON"
		)
		PORT MAP
		(
--			usedw		=> scfifo_usedw,
			aclr		=> scfifo_aclr,
			clock		=> vjtag_tck,
			data		=> scfifo_data,
			rdreq		=> scfifo_rdreq,
			wrreq		=> scfifo_wrreq,
			empty		=> scfifo_empty,
			full		=> scfifo_full,
			q			=> scfifo_q
		);

	fifo_sm : alt_pfl_pgm_fifo_sm
		generic map
		(
			DATA_WIDTH		=> DATA_WIDTH,
			ADDR_WIDTH		=> ADDR_WIDTH,
			PFL_IR_BITS		=> PFL_IR_BITS,
			DATA_REG_WIDTH	=> DATA_REG_WIDTH,
			ADDR_REG_WIDTH	=> ADDR_REG_WIDTH,
			INST_REG_WIDTH	=> INST_REG_WIDTH,
			PARAM_REG_WIDTH	=> PARAM_REG_WIDTH,
			SYNC_REG_WIDTH	=> SYNC_REG_WIDTH,
			STATUS_REG_WIDTH=> STATUS_REG_WIDTH,
			BYPASS_REG_WIDTH=> BYPASS_REG_WIDTH
		)
		port map
		(
			inst_out => inst_out,
			data_out => data_out,
			vjtag_ir_in => vjtag_ir_in,
			vjtag_tck => vjtag_tck ,
			vjtag_tdi => vjtag_tdi,
			vjtag_virtual_state_cdr => vjtag_virtual_state_cdr,
			vjtag_virtual_state_e1dr => vjtag_virtual_state_e1dr,
			vjtag_virtual_state_e2dr => vjtag_virtual_state_e2dr,
			vjtag_virtual_state_pdr => vjtag_virtual_state_pdr,
			vjtag_virtual_state_sdr => vjtag_virtual_state_sdr,
			vjtag_virtual_state_udr => vjtag_virtual_state_udr,
			vjtag_virtual_state_cir => vjtag_virtual_state_cir,
			vjtag_virtual_state_uir => vjtag_virtual_state_uir,
			scfifo_full => scfifo_full,
			param_tdo => param_tdo,
			status_tdo => status_tdo,
			inst_tdo => inst_tdo,
			bypass_tdo => bypass_tdo,
			addr_tdo => addr_tdo,
			data_tdo => data_tdo,
			vjtag_tdo => vjtag_tdo,
			is_state_machine_mode => is_state_machine_mode,
			scfifo_wrreq => scfifo_wrreq,
			scfifo_aclr => scfifo_aclr,
			scfifo_data => scfifo_data,
			param_reg_enable => param_reg_enable,
			status_reg_enable => status_reg_enable,
			inst_reg_enable => inst_reg_enable,
			bypass_reg_enable => bypass_reg_enable,
			addr_counter_enable => addr_counter_enable,
			data_reg_enable => data_reg_enable,
			sync_reg_aclr => sync_reg_aclr,
			sync_reg_aset => sync_reg_aset,
			status_reg_update => status_reg_update,
			status_reg_aclr => status_reg_aclr,
			status_reg_set_full => status_reg_set_full,
			flashsm_reset => flashsm_reset
		);

	flash_sm : alt_pfl_pgm_flash_sm
		generic map
		(
			ADDR_WIDTH		=> ADDR_WIDTH,
			DATA_WIDTH		=> DATA_WIDTH
		)
		port map
		(
			clk				=> vjtag_tck,
			reset			=> flashsm_reset,
			scfifo_data_in	=> scfifo_q,
			scfifo_empty	=> scfifo_empty,
			scfifo_rdreq	=> scfifo_rdreq,
			is_sync			=> is_sync(0),
			param_in		=> param_out,
			flash_select	=> flash_select,
			flash_write		=> flash_write,
			flash_read		=> flash_read,
			flash_data_highz=> flash_data_highz,
			flash_data_in	=> flash_data_in,
			flash_data_out	=> flash_data_out,
			flash_addr_out	=> flash_addr,
			addr_in			=> addr_out,
			addr_count		=> addr_count,
			status_full		=> status_reg_full_bit,
			status_done		=> status_reg_set_done,
			status_error	=> status_reg_set_error
		);

end architecture structure;
