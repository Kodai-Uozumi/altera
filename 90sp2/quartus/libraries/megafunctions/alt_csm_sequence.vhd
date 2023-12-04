--------------------------------------------------------------------------------
--
--                 Altera Clock Shared Memory Sequencer Source File
--                           Copyright DDC, 2002
--                           All Rights Reserved
--                     DDC Confidential and Proprietary
--
--------------------------------------------------------------------------------
--  Copyright 1991-2009 Corporation  
--  Your use of Altera Corporation's design tools, logic functions  
--  and other software and tools, and its AMPP partner logic  
--  functions, and any output files from any of the foregoing  
--  (including device programming or simulation files), and any  
--  associated documentation or information are expressly subject  
--  to the terms and conditions of the Altera Program License  
--  Subscription Agreement, Altera MegaCore Function License  
--  Agreement, or other applicable license agreement, including,  
--  without limitation, that your use is for the sole purpose of  
--  programming logic devices manufactured by Altera and sold by  
--  Altera or its authorized distributors.  Please refer to the  
--  applicable agreement for further details. 
--  
--  9.0 Build 235  03/01/2009   
--------------------------------------------------------------------------------
--
--      File Name:          alt_csm_sequence.vhd
--      Entity Name:        alt_csm_sequence
--
--      Description:
--
--          This submodule of altcsmem implements the tdm sequencer.
--
--------------------------------------------------------------------------------
--
--      Revision History
--      ----------------
--          03/14/02    first release.
--
--      I/O
--      ----------------
--      Inputs:
--          tdm_clk		clock
--          reset		asynchronous reset signal
--
--      Outputs:
--          active_port_stb	current active port as one-hot bit field
--          active_port_num	current active port as encoded bit field
--          
--      Other
--      ----------------
--
--      Instantiated Functions: None
--
--      Instantiated Procedures: None
--
--      Instantiated Components: None
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.alt_csm_const_pkg.all;
use work.alt_csm_func_pkg.all;


entity alt_csm_sequence is
	generic
	(
		num_states			: natural := 2;
		num_states_width	: natural := 1;
		num_ports			: natural := 2;
		num_ports_width		: natural := 1;
		seq_rom_mif			: string := ""
	);
	port
	(
		clk					: in  std_logic;
		reset				: in  std_logic;
		active_port_stb		: out std_logic_vector(num_ports -1 downto 0);
		active_port_num		: out std_logic_vector(num_ports_width -1 downto 0)
	);
end alt_csm_sequence;



--------------------------------------------------------------------------------
--
-- preferred sequencer architecture using a software defined rom to hold
-- the port_sequence, allows "random" port service rates and sequence
--
--------------------------------------------------------------------------------
architecture encoded_rom of alt_csm_sequence is

signal active_high_reset	: std_logic;

signal state_cnt		: std_logic_vector(num_states_width -1 downto 0);

signal state_reg		: std_logic_vector(num_ports_width -1 downto 0);
signal state			: std_logic_vector(num_ports_width -1 downto 0);

signal decode_reg		: std_logic_vector(num_ports -1 downto 0);

component alt_csm_rom_wrapper is
	generic
	(
		g_addr_width	: natural;
		g_data_width	: natural;
		g_numwords		: natural;
		g_init_file		: string
	);
	port
	(
		clock		: in  std_logic;
		aclr		: in  std_logic;
		addr		: in  std_logic_vector(g_addr_width -1 downto 0);
		data		: out std_logic_vector(g_data_width -1 downto 0)
	);
end component;

begin

	active_high_reset <= not (reset);

	inst_rom : alt_csm_rom_wrapper
	generic map
	(
		g_addr_width	=> num_states_width,
		g_data_width	=> num_ports_width,
		g_numwords		=> num_states,
		g_init_file		=> seq_rom_mif
	)
	port map
	(
		clock	=> clk,
		aclr	=> active_high_reset,
		addr	=> state_cnt,
		data	=> state
	);
	

	gen_state_cnt : process(clk, reset)
	begin
		if reset = c_async_reset_val then
			state_cnt <= (others => '0');
		elsif clk'event and clk = '1' then
			if (state_cnt = conv_std_logic_vector(num_states -1, num_states_width)) then
				state_cnt <= (others => '0');
			else
				state_cnt <= state_cnt +1;
			end if;
		end if;
	end process gen_state_cnt;


	active_port_num <= state_reg;

	process(clk, reset)
	begin
		if reset = c_async_reset_val then
			state_reg <= (others => '0');
		elsif clk'event and clk = '1' then
			state_reg <= state;
		end if;
	end process;


	active_port_stb <= decode_reg;

	gen_decode_reg : for i in 0 to num_ports -1 generate
	begin

		process(clk, reset)
		begin
			if reset = c_async_reset_val then
				decode_reg(i) <= '0';
			elsif clk'event and clk = '1' then
				if (state = conv_std_logic_vector(i, num_ports)) then
					decode_reg(i) <= '1';
				else
					decode_reg(i) <= '0';
				end if;
			end if;
		end process;

	end generate gen_decode_reg;

end architecture encoded_rom;


