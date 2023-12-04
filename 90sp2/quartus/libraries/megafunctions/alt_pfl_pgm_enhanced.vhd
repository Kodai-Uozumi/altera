library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity custom_jtag_counter is
	generic 
		(
			WIDTH		: natural := 22
		);
	port
		(
			clk		: in STD_LOGIC;
			s_load		: in STD_LOGIC;
			s_in		: in STD_LOGIC;
			count		: in STD_LOGIC;
			
			s_out		: out STD_LOGIC;
			p_out		: out STD_LOGIC_VECTOR (WIDTH-1 DOWNTO 0)
		);
end entity custom_jtag_counter;

architecture rtl of custom_jtag_counter is	
	signal data_reg		: STD_LOGIC_VECTOR (WIDTH-1 DOWNTO 0);
begin
	process(clk, s_load,  s_in, count)
	begin
		if ( rising_edge(clk) ) then
			if ( s_load = '1')  then
				data_reg <= s_in & data_reg(WIDTH - 1 DOWNTO 1);
			elsif (count = '1') then
				data_reg <= data_reg + conv_std_logic_vector(1, WIDTH);
			end if;
		end if;
	end process;
	p_out <= data_reg;
	s_out <= data_reg(0);
end architecture rtl;

package CONSTANTS is
 	constant ALTERA_MFG_ID        : natural := 110;
 	constant PFL_NODE_ID          : natural := 5;
 	constant PFL_VERSION          : natural := 7;
 	constant PFL_INSTANCE         : natural := 0;
 	constant N_NODE_VERSION_BITS  : natural := 5;
 	constant N_NODE_ID_BITS       : natural := 8;
 	constant N_MFG_ID_BITS        : natural := 11;
 	constant N_INSTANCE_BITS      : natural := 8;
 	constant N_SLD_NODE_INFO_BITS : natural := N_NODE_VERSION_BITS + N_NODE_ID_BITS + N_MFG_ID_BITS + N_INSTANCE_BITS;
 	constant N_INFO_BITS          : natural := 8;
 	constant INFO_SHIFT_INST      : natural := 0;
 	constant READ_INST            : natural := 1;
 	constant ADDR_SHIFT_INST      : natural := 2;
 	constant WRITE_INST           : natural := 3;
 	constant EN_CONFIG_INST       : natural := 4;
end package CONSTANTS;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use WORK.CONSTANTS.all;

package FUNCTIONS is
	function make_node_info
	(
		NODE_VERSION : natural ;
		NODE_ID      : natural ;
		MFG_ID       : natural ;
		INSTANCE     : natural
	)
	return natural;
end package FUNCTIONS;

package body FUNCTIONS is
	function make_node_info
	(
		NODE_VERSION : natural ;
		NODE_ID      : natural ;
		MFG_ID       : natural ;
		INSTANCE     : natural
	)
	return natural is
		variable info_val : natural;
	begin
		info_val := NODE_VERSION;
		info_val := (info_val * (2 ** N_NODE_ID_BITS)) + NODE_ID;
		info_val := (info_val * (2 ** N_MFG_ID_BITS)) + MFG_ID;
		info_val := (info_val * (2 ** N_INSTANCE_BITS)) + INSTANCE;
		return info_val;
	end make_node_info;
end package body FUNCTIONS;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use WORK.CONSTANTS.all;
use WORK.FUNCTIONS.all;

library altera_mf;
use altera_mf.altera_mf_components.all;

entity alt_pfl_pgm_enhanced is
	generic 
	(
		PFL_IR_BITS			: natural := 5;
		ADDR_WIDTH			: natural;	-- from 19 for 8Mbits, up to 25 for 512Mbits
		OPTION_START_ADDR	: natural;
		FLASH_DATA_WIDTH	: natural := 16;	-- valid values are 8 and 16
		FIFO_SIZE		 	: natural := 16;
		N_FLASH				: natural := 1;
		N_FLASH_BITS		: natural := 4
	);
	port
	(
		pfl_nreset		: in STD_LOGIC;
		pfl_flash_access_granted: in STD_LOGIC;
		pfl_flash_access_request: out STD_LOGIC;

--      to CFG
        enable_configuration : out STD_LOGIC;
        enable_nconfig : out STD_LOGIC;
        
-- 		flash output
		flash_addr		: out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
		flash_data_in	: in STD_LOGIC_VECTOR (FLASH_DATA_WIDTH-1 downto 0);
		flash_data_out	: out STD_LOGIC_VECTOR (FLASH_DATA_WIDTH-1 downto 0);
		flash_read		: out STD_LOGIC;
		flash_write		: out STD_LOGIC;
		flash_select	: out STD_LOGIC;
		flash_data_highz: out STD_LOGIC;
        flash_nreset    : out STD_LOGIC;
        
        --pfl multiple flash
        active_flash_index : out STD_LOGIC_VECTOR(N_FLASH_BITS-1 downto 0)
	    );
end entity alt_pfl_pgm_enhanced;

architecture rtl of alt_pfl_pgm_enhanced is
	function log2(A: integer) return integer is
	begin
	  for I in 1 to 30 loop  -- Works for up to 32 bit integers
	    if(2**I > A) then return(I-1);  end if;
	  end loop;
	  return(30);
	end;


    constant info_shiftreg_width : NATURAL := 31;
	--param reg
	signal info_shiftreg_out	: STD_LOGIC;
	signal info_data_in         : STD_LOGIC_VECTOR(info_shiftreg_width-1 DOWNTO 0);
    signal info_data_out        : STD_LOGIC_VECTOR(info_shiftreg_width-1 downto 0);

	-- jtag flash data reg
	signal pgm_jtag_flash_data_in	: STD_LOGIC_VECTOR(FLASH_DATA_WIDTH DOWNTO 0);
	signal pgm_jtag_flash_data_out	: STD_LOGIC_VECTOR(FLASH_DATA_WIDTH DOWNTO 0);
	signal pgm_jtag_load_flash_data	: STD_LOGIC;
	signal pgm_jtag_flash_serial_out: STD_LOGIC;

	--jtag addr_counter
	signal jtag_addr_serial_out	: STD_LOGIC;
	
	-- HUB / instruction
	signal data_inst_jtag_udr	: STD_LOGIC;
	signal jtag_data_inst		: STD_LOGIC;
	signal jtag_addr_inst		: STD_LOGIC;
	signal jtag_info_inst		: STD_LOGIC;

	signal jtag_flash_write		: STD_LOGIC;
	signal jtag_flash_read		: STD_LOGIC;
    
	signal enable_configuration_sig : STD_LOGIC;

	signal jtag_addr_s_load : STD_LOGIC;
	signal jtag_addr_count : STD_LOGIC;

	signal info_shiftreg_load : STD_LOGIC;
	signal info_shiftreg_enable : STD_LOGIC;

	signal jtag_flash_datareg_enable : STD_LOGIC;

	-- from HUB	
	signal ir_in				: STD_LOGIC_VECTOR (PFL_IR_BITS-1 downto 0);
	signal ir_out				: STD_LOGIC_VECTOR (PFL_IR_BITS-1 downto 0);
	signal tdi					: STD_LOGIC;
	signal raw_tck				: STD_LOGIC;
	signal tdo					: STD_LOGIC;
	signal virtual_state_cdr	: STD_LOGIC;
	signal virtual_state_sdr	: STD_LOGIC;
	signal virtual_state_pdr	: STD_LOGIC;
	signal virtual_state_udr	: STD_LOGIC;
	signal virtual_state_e1dr	: STD_LOGIC;
	signal virtual_state_e2dr	: STD_LOGIC;
	signal virtual_state_cir	: STD_LOGIC;
	signal virtual_state_uir	: STD_LOGIC;
	signal jtag_state_rti		: STD_LOGIC;

	-- from pgm_sm
	signal pgmsm_addr_out			: STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
	signal pgmsm_data_out			: STD_LOGIC_VECTOR(FLASH_DATA_WIDTH downto 0); --extra bit for address control
	signal pgmsm_addr_tdo			: STD_LOGIC;
	signal pgmsm_data_tdo			: STD_LOGIC;
	signal pgmsm_flash_data_in		: STD_LOGIC_VECTOR(FLASH_DATA_WIDTH-1 downto 0);
	signal pgmsm_tdo				: STD_LOGIC;
	signal is_state_machine_mode	: STD_LOGIC;
	signal pgmsm_flash_select		: STD_LOGIC;
	signal pgmsm_flash_read			: STD_LOGIC;
	signal pgmsm_flash_write		: STD_LOGIC;
	signal pgmsm_flash_addr			: STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
	signal pgmsm_flash_data_out		: STD_LOGIC_VECTOR(FLASH_DATA_WIDTH-1 downto 0);
	signal pgmsm_flash_data_highz	: STD_LOGIC;
	signal pgmsm_addr_count			: STD_LOGIC;
	signal pgmsm_addr_enable		: STD_LOGIC;
	signal pgmsm_data_enable		: STD_LOGIC;

	signal pgmcrc_tdo				: STD_LOGIC;			
	signal pgmcrc_enable			: STD_LOGIC;
	signal pgmcrc_addr_count		: STD_LOGIC;

	signal pgm_jtag_flash_datareg_enable	: STD_LOGIC;
	signal pgm_flash_addr					: STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
	signal pgm_jtag_addr_s_load 			: STD_LOGIC;
	signal pgm_jtag_addr_count 				: STD_LOGIC;
	signal pgm_jtag_addr_serial_out			: STD_LOGIC;
	signal pgm_flash_data_out				: STD_LOGIC_VECTOR(FLASH_DATA_WIDTH-1 downto 0);
	signal pgm_flash_data_highz 			: STD_LOGIC;
	signal pgm_flash_write					: STD_LOGIC;
	signal pgm_flash_read					: STD_LOGIC;
	signal pgm_flash_select					: STD_LOGIC;

	--pfl multiple flash
	signal active_flash_index_sig : STD_LOGIC_VECTOR(N_FLASH_BITS-1 DOWNTO 0);

	COMPONENT alt_pfl_pgm_sm is
		generic
		(
			DATA_WIDTH	: natural;
			ADDR_WIDTH	: natural;
			PFL_IR_BITS	: natural;
			FIFO_SIZE	: natural
		);
		port
		(
			addr_out					: in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
			data_out					: in  STD_LOGIC_VECTOR(FLASH_DATA_WIDTH downto 0); --extra bit for address control
			addr_tdo					: in  STD_LOGIC;
			data_tdo					: in  STD_LOGIC;
			flash_data_in				: in  STD_LOGIC_VECTOR(FLASH_DATA_WIDTH-1 downto 0);
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

			vjtag_tdo					: out STD_LOGIC;
			is_state_machine_mode		: out STD_LOGIC;
			flash_select				: out STD_LOGIC;
			flash_read					: out STD_LOGIC;
			flash_write					: out STD_LOGIC;
			flash_addr					: out STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);
			flash_data_out				: out STD_LOGIC_VECTOR(FLASH_DATA_WIDTH-1 downto 0);
			flash_data_highz			: out STD_LOGIC;
			addr_count					: out STD_LOGIC;
			addr_counter_enable					: out STD_LOGIC;
			data_reg_enable					: out STD_LOGIC
		);
	END COMPONENT alt_pfl_pgm_sm;

    COMPONENT custom_jtag_counter
		generic 
			(
				WIDTH		: natural
			);
		port
			(
				clk			: in STD_LOGIC;
				s_load		: in STD_LOGIC;
				s_in		: in STD_LOGIC;
				count		: in STD_LOGIC;
	
				s_out		: out STD_LOGIC;
				p_out		: out STD_LOGIC_VECTOR (WIDTH-1 DOWNTO 0)
			);
	END COMPONENT custom_jtag_counter;	
	COMPONENT lpm_shiftreg
		GENERIC 
		(
			LPM_WIDTH		: POSITIVE;
			LPM_AVALUE		: STRING := "UNUSED";
--			LPM_SVALUE		: NATURAL := 0;
			LPM_PVALUE		: STRING := "UNUSED";
			LPM_DIRECTION	: STRING := "UNUSED";
			LPM_TYPE		: STRING := "LPM_SHIFTREG";
			LPM_HINT		: STRING := "UNUSED"
		);
		PORT 
		(
			data			: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
			clock			: IN STD_LOGIC;
			enable, shiftin	: IN STD_LOGIC := '1';
			load, sclr, sset, aclr, aset: IN STD_LOGIC := '0';
			q				: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
			shiftout		: OUT STD_LOGIC
		);
	END COMPONENT lpm_shiftreg;

	COMPONENT sld_virtual_jtag_basic
		GENERIC
		(
			sld_ir_width		: natural;
			sld_version		: natural;
			sld_type_id		: natural;
			sld_mfg_id		: natural;
			sld_instance_index	: natural
		);
		PORT
		(
			ir_in			: out STD_LOGIC_VECTOR(sld_ir_width-1 DOWNTO 0);
			ir_out			: in STD_LOGIC_VECTOR(sld_ir_width-1 DOWNTO 0);
			tdi			: out STD_LOGIC;
			tck			: out STD_LOGIC;
			tdo			: in STD_LOGIC;
			virtual_state_cdr	: out STD_LOGIC;
			virtual_state_sdr	: out STD_LOGIC;
			virtual_state_pdr	: out STD_LOGIC;
			virtual_state_udr	: out STD_LOGIC;
			virtual_state_e1dr	: out STD_LOGIC;
			virtual_state_e2dr	: out STD_LOGIC;
			virtual_state_cir	: out STD_LOGIC;
			virtual_state_uir	: out STD_LOGIC;
			jtag_state_rti 		: out STD_LOGIC
		);
	END COMPONENT sld_virtual_jtag_basic;

	COMPONENT alt_pfl_pgm_verify
		generic
		(
			DATA_WIDTH	: natural;
			PFL_IR_BITS	: natural
		);
		port
		(
			vjtag_tck				: in  STD_LOGIC;
			vjtag_tdi				: in  STD_LOGIC;
			vjtag_virtual_state_sdr	: in  STD_LOGIC;
			reset_crc_register	: in  STD_LOGIC;
			vjtag_ir_in				: in  STD_LOGIC_VECTOR(PFL_IR_BITS-1 downto 0);
			flash_data_in			: in  STD_LOGIC_VECTOR(FLASH_DATA_WIDTH-1 downto 0);
			
			vjtag_tdo				: out STD_LOGIC;
			crc_verify_enable		: out STD_LOGIC;
			addr_count				: out STD_LOGIC
		);
	END COMPONENT alt_pfl_pgm_verify;

begin
	jtag_data_inst	   <= jtag_flash_read or jtag_flash_write;
	data_inst_jtag_udr <= virtual_state_udr and jtag_data_inst;

	enable_configuration_sig <= not ir_in(EN_CONFIG_INST) and not ir_in(WRITE_INST) and not ir_in(ADDR_SHIFT_INST) and not ir_in(READ_INST) and not ir_in(INFO_SHIFT_INST);
	enable_configuration <= enable_configuration_sig;
	jtag_flash_write<= ir_in(EN_CONFIG_INST) and ir_in(WRITE_INST) and (not ir_in(ADDR_SHIFT_INST)) and (not ir_in(READ_INST)) and (not ir_in(INFO_SHIFT_INST));
	jtag_addr_inst	<= ir_in(EN_CONFIG_INST) and (not ir_in(WRITE_INST)) and ir_in(ADDR_SHIFT_INST) and (not ir_in(READ_INST)) and (not ir_in(INFO_SHIFT_INST));
	jtag_flash_read	<= ir_in(EN_CONFIG_INST) and (not ir_in(WRITE_INST)) and (not ir_in(ADDR_SHIFT_INST)) and ir_in(READ_INST) and (not ir_in(INFO_SHIFT_INST));
	jtag_info_inst 	<= ir_in(EN_CONFIG_INST) and (not ir_in(WRITE_INST)) and (not ir_in(ADDR_SHIFT_INST)) and (not ir_in(READ_INST)) and ir_in(INFO_SHIFT_INST);

	-- addr_counter, data_reg and flash mux between normal mode and state machine mode
	mode_mux : process(is_state_machine_mode, pgmsm_addr_enable, pgmsm_addr_count, pgmsm_flash_addr, pgmsm_data_enable,
		pgmsm_flash_data_out, pgmsm_flash_data_highz, pgmsm_flash_write, pgmsm_flash_read, pgmsm_flash_select,
		pgm_jtag_addr_s_load, pgm_jtag_addr_count, pgm_flash_addr, pgm_jtag_flash_datareg_enable, pgm_flash_data_out, pgm_flash_data_highz,
		pgm_flash_write, pgm_flash_read, pgm_flash_select, pgmcrc_enable, pgmcrc_addr_count
		)
	begin
		if (is_state_machine_mode = '1') then
			jtag_addr_s_load <= pgmsm_addr_enable;
			jtag_addr_count <= pgmsm_addr_count;
			flash_addr <= pgmsm_flash_addr;
			--jtag_load_flash_data <= pgmsm_jtag_load_flash_data;
			--jtag_flash_data_in <= pgmsm_jtag_flash_data_in;
			jtag_flash_datareg_enable <= pgmsm_data_enable;
			flash_data_out <= pgmsm_flash_data_out;
			flash_data_highz <= pgmsm_flash_data_highz;
			flash_write <= pgmsm_flash_write;
			flash_read <= pgmsm_flash_read;
			flash_select <= pgmsm_flash_select;
		elsif (pgmcrc_enable = '1') then
			jtag_addr_s_load <= '0';
			jtag_addr_count <= pgmcrc_addr_count;
			flash_addr <= pgm_flash_addr;
			jtag_flash_datareg_enable <= pgm_jtag_flash_datareg_enable;
			flash_data_out <= pgm_flash_data_out;
			flash_data_highz <= '1';
			flash_write <= '0';
			flash_read <= '1';
			flash_select <= '1';
		else
			jtag_addr_s_load <= pgm_jtag_addr_s_load;
			jtag_addr_count <= pgm_jtag_addr_count;
			flash_addr <= pgm_flash_addr;
			--jtag_load_flash_data <= pgm_jtag_load_flash_data;
			--jtag_flash_data_in <= pgm_jtag_flash_data_in;
			jtag_flash_datareg_enable <= pgm_jtag_flash_datareg_enable;
			flash_data_out <= pgm_flash_data_out;
			flash_data_highz <= pgm_flash_data_highz;
			flash_write <= pgm_flash_write;
			flash_read <= pgm_flash_read;
			flash_select <= pgm_flash_select;
		end if;
	end process mode_mux;

	pgmsm_addr_out <= pgm_flash_addr;
	pgmsm_data_out <= pgm_jtag_flash_data_out;
	pgmsm_addr_tdo <= pgm_jtag_addr_serial_out;
	pgmsm_data_tdo <= pgm_jtag_flash_serial_out;
	pgmsm_flash_data_in <= flash_data_in;

	jtag_addr: custom_jtag_counter
		generic map
		(
			WIDTH 	=> ADDR_WIDTH
		)
		port map
		(
			clk		=> raw_tck,
			s_load	=> jtag_addr_s_load,
			s_in	=> tdi,
			count	=> jtag_addr_count,

			p_out	=> pgm_flash_addr,
			s_out	=> pgm_jtag_addr_serial_out
		);

	pgm_jtag_addr_s_load <= jtag_addr_inst and virtual_state_sdr;
	pgm_jtag_addr_count <= data_inst_jtag_udr and not pgm_jtag_flash_data_out(0);

	--3 bits for size 1 bit for access granted
	-- parallel load the data when jtag_info_inst is shifted and JSM is not
	-- in SDR..but enabled only in SDR or RTI ..so no risk to assign 
	info_shiftreg: lpm_shiftreg
		generic map
		(
			LPM_WIDTH 		=> info_shiftreg_width,
			LPM_DIRECTION	=> "RIGHT"
		)
		port map
		(
			data			=> info_data_in,
			clock			=> raw_tck,
			enable			=> info_shiftreg_enable,
			shiftin			=> tdi,
			shiftout		=> info_shiftreg_out,
			q			=> info_data_out,
			load			=> info_shiftreg_load
		);
    info_shiftreg_load <= jtag_info_inst and virtual_state_cdr;
    info_shiftreg_enable <= jtag_info_inst and (virtual_state_sdr or virtual_state_cdr);
    info_data_in(2) <= pfl_flash_access_granted;
	info_data_in(5 downto 3) <= CONV_STD_LOGIC_VECTOR(ADDR_WIDTH+log2(FLASH_DATA_WIDTH)-23, 3);	-- CFI size (0 for CFI_008, 6 for CFI_512)
	info_data_in(21 downto 6) <= CONV_STD_LOGIC_VECTOR(OPTION_START_ADDR/8192, 16);
    info_data_in(0) <= '0';
    info_data_in(1) <= '0';
    info_data_in(22) <= '0';

	--pfl multiple flash
	info_data_in(26 downto 23) <= CONV_STD_LOGIC_VECTOR(N_FLASH, 4);
    info_data_in(30 downto 27) <= "0000"; -- keep info from programmer on index of active flash
	
	active_flash_index <= active_flash_index_sig;
	set_active_flash_index: process (virtual_state_udr, jtag_info_inst, info_data_out, raw_tck, active_flash_index_sig)
	begin
		if (raw_tck'event and raw_tck='1') then
			if (virtual_state_udr = '1' and jtag_info_inst = '1') then
				active_flash_index_sig <= info_data_out(30 downto 27);
			else
				active_flash_index_sig <= active_flash_index_sig;
			end if;
		else
				active_flash_index_sig <= active_flash_index_sig;
		end if;
	end process;
	
	--set pfl_flash_access_request output
	pfl_flash_access_request <= not enable_configuration_sig;

	jtag_flash_datareg: lpm_shiftreg
		generic map
		(
			LPM_WIDTH 		=> FLASH_DATA_WIDTH + 1,
			LPM_DIRECTION	=> "RIGHT"
		)
		port map
		(
			data			=> pgm_jtag_flash_data_in,
			shiftin			=> tdi,
			clock			=> raw_tck,
			enable			=> jtag_flash_datareg_enable,
			shiftout		=> pgm_jtag_flash_serial_out,
			load			=> pgm_jtag_load_flash_data,
			q				=> pgm_jtag_flash_data_out
		);

	-- in SDR this should be in serial mode, rest of the time in parallel mode
	-- or config controller shifting the data to FPGA
	pgm_jtag_load_flash_data <=	(jtag_flash_read and jtag_state_rti);
	pgm_jtag_flash_data_in(FLASH_DATA_WIDTH downto 1) <= flash_data_in(FLASH_DATA_WIDTH-1 downto 0);
	pgm_jtag_flash_data_in(0) <= '0';
	pgm_jtag_flash_datareg_enable <= pgm_jtag_load_flash_data or virtual_state_sdr;
	-- drive out only during flash programing
	pgm_flash_data_out <= pgm_jtag_flash_data_out(FLASH_DATA_WIDTH downto 1);
	pgm_flash_data_highz <= not (jtag_flash_write and 
		(virtual_state_cdr or 
		 virtual_state_e1dr or 
		 virtual_state_e2dr or 
		 virtual_state_pdr or 
		 virtual_state_sdr or 
		 virtual_state_udr));
	pgm_flash_write <= virtual_state_udr and jtag_flash_write;
	pgm_flash_read <= jtag_flash_read and jtag_state_rti;
	pgm_flash_select <= (virtual_state_udr and jtag_flash_write) or (jtag_flash_read and jtag_state_rti);
    flash_nreset <= not (virtual_state_udr and jtag_info_inst and info_data_out(22));

	-- tdo mux between the shift register or param register or pgm_sm
	tdo_mux :process (is_state_machine_mode, pgmsm_tdo, info_shiftreg_out, pgm_jtag_flash_serial_out,
	jtag_addr_inst, pgm_jtag_addr_serial_out, jtag_info_inst, pgmcrc_enable, pgmcrc_tdo)
	begin
		if (is_state_machine_mode = '1') then
			tdo <= pgmsm_tdo;
		elsif (pgmcrc_enable = '1') then
			tdo <= pgmcrc_tdo;
		else
			if (jtag_info_inst = '1') then
				tdo <= info_shiftreg_out;
			elsif (jtag_addr_inst = '1') then
				tdo <= pgm_jtag_addr_serial_out;
			else
				tdo <= pgm_jtag_flash_serial_out;
			end if;
		end if;
	end process tdo_mux;

	--set fpga_nconfig output
	--keep it high unless JSM is in UDR and jtag_info_inst is in IR
	-- now we don't need to send DEASSERT od nInitCONF..since it
	-- is low only during UDR state
    enable_nconfig <= virtual_state_udr and jtag_info_inst and info_data_out(1);
    vjtag: sld_virtual_jtag_basic
		generic map
		(
			sld_ir_width => PFL_IR_BITS,
			sld_version => PFL_VERSION,
			sld_type_id => PFL_NODE_ID,
			sld_mfg_id => ALTERA_MFG_ID,
			sld_instance_index => PFL_INSTANCE
			--lpm_hint => ""
		)
		port map
		(
			ir_in           => ir_in,
			ir_out			=> ir_out,
			tdi				=> tdi,
			tck				=> raw_tck,
			tdo				=> tdo,
			virtual_state_cdr	=> virtual_state_cdr,
			virtual_state_sdr	=> virtual_state_sdr,
			virtual_state_pdr	=> virtual_state_pdr,
			virtual_state_udr	=> virtual_state_udr,
			virtual_state_e1dr	=> virtual_state_e1dr,
			virtual_state_e2dr	=> virtual_state_e2dr,
			virtual_state_cir	=> virtual_state_cir,
			virtual_state_uir	=> virtual_state_uir,
			jtag_state_rti 	=> jtag_state_rti
		);
	ir_out <= ir_in;

	pgm_sm: alt_pfl_pgm_sm
		generic map
		(
			DATA_WIDTH	=> FLASH_DATA_WIDTH,
			ADDR_WIDTH	=> ADDR_WIDTH,
			PFL_IR_BITS	=> PFL_IR_BITS,
			FIFO_SIZE => FIFO_SIZE
		)
		port map
		(
			addr_out					=> pgmsm_addr_out,
			data_out					=> pgmsm_data_out,
			addr_tdo					=> pgmsm_addr_tdo,
			data_tdo					=> pgmsm_data_tdo,
			flash_data_in				=> pgmsm_flash_data_in,
			vjtag_ir_in					=> ir_in,
			vjtag_tck					=> raw_tck,
			vjtag_tdi					=> tdi,
			vjtag_virtual_state_cdr		=> virtual_state_cdr,
			vjtag_virtual_state_e1dr	=> virtual_state_e1dr,
			vjtag_virtual_state_e2dr	=> virtual_state_e2dr,
			vjtag_virtual_state_pdr		=> virtual_state_pdr,
			vjtag_virtual_state_sdr		=> virtual_state_sdr,
			vjtag_virtual_state_udr		=> virtual_state_udr,
			vjtag_virtual_state_cir		=> virtual_state_cir,
			vjtag_virtual_state_uir		=> virtual_state_uir,

			vjtag_tdo					=> pgmsm_tdo,
			is_state_machine_mode		=> is_state_machine_mode,
			flash_select				=> pgmsm_flash_select,
			flash_read					=> pgmsm_flash_read,
			flash_write					=> pgmsm_flash_write,
			flash_addr					=> pgmsm_flash_addr,
			flash_data_out				=> pgmsm_flash_data_out,
			flash_data_highz			=> pgmsm_flash_data_highz,
			addr_count					=> pgmsm_addr_count,
			addr_counter_enable			=> pgmsm_addr_enable,
			data_reg_enable				=> pgmsm_data_enable
		);

	pgm_crc : alt_pfl_pgm_verify
		generic map
		(
			DATA_WIDTH	=> FLASH_DATA_WIDTH,
			PFL_IR_BITS	=> PFL_IR_BITS
		)
		port map
		(
			vjtag_tck				=> raw_tck,
			vjtag_tdi				=> tdi,
			vjtag_virtual_state_sdr	=> virtual_state_sdr,
			reset_crc_register => jtag_flash_read,
			vjtag_ir_in				=> ir_in,
			flash_data_in			=> flash_data_in,
			vjtag_tdo				=> pgmcrc_tdo,
			crc_verify_enable		=> pgmcrc_enable,
			addr_count				=> pgmcrc_addr_count
		);

end architecture rtl;
