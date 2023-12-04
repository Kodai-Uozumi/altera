--------------------------------------------------------------------------------
--
--                  Altera Clock Shared Memory Source File
--                    Sequencer ROM Wrapper Source File
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
--      File Name:          alt_csm_rom_wrapper.vhd
--      Entity Name:        alt_csm_rom_wrapper
--
--      Description:
--
--          This submodule of altcsmem provides a parameterized wrapper 
--          for a rom component used by the tdm sequencer.
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
--          clock           clock
--          aclr            active high asynchronous clear
--          addr            input address bus
--
--      Outputs:
--          data            output data bus
--
--      Generics:
--          g_addr_width    width of the address bus port
--          g_data_width    width of the data bus port
--          g_init_file     path to the ROM init file (intel hex format)
--
--      Other
--      ----------------
--
--      Instantiated Functions: None
--
--      Instantiated Procedures: None
--
--      Instantiated Components:
--          altsyncram      from altera_mf library
--
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-- pragma translate_off
library altera_mf;
use altera_mf.altera_mf_components.all;
-- pragma translate_on

entity alt_csm_rom_wrapper is
	generic
	(
		g_addr_width	: natural := 1;
		g_data_width	: natural := 1;
		g_numwords		: natural := 1;
		g_init_file		: string := ""
	);
	port
	(
		clock		: in  std_logic;
		aclr		: in  std_logic := '0';
		addr		: in  std_logic_vector(g_addr_width -1 downto 0);
		data		: out std_logic_vector(g_data_width -1 downto 0)
	);
end alt_csm_rom_wrapper;


architecture rtl of alt_csm_rom_wrapper is

	signal data_out	: std_logic_vector (g_data_width -1 downto 0);


	COMPONENT altsyncram
	GENERIC (
		operation_mode		: STRING;
--x		maximum_depth		: NATURAL;
		width_a				: NATURAL;
		widthad_a			: NATURAL;
		numwords_a			: NATURAL;
		width_byteena_a		: NATURAL;
		outdata_reg_a		: STRING;
		outdata_aclr_a		: STRING;
		address_aclr_a		: STRING;
		read_during_write_mode_mixed_ports		: STRING;
		ram_block_type		: STRING;
		lpm_type            : STRING := "altsyncram";
		init_file			: STRING;
		intended_device_family		: STRING
	);
	PORT (
			aclr0		: IN STD_LOGIC ;
			clock0		: IN STD_LOGIC ;
			address_a	: IN STD_LOGIC_VECTOR (g_addr_width -1 downto 0);
			q_a			: OUT STD_LOGIC_VECTOR (g_data_width -1 downto 0)
	);
	END COMPONENT;

begin

	data <= data_out(g_data_width -1 downto 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		operation_mode => "ROM",
--x		maximum_depth => (g_data_width * (2 ** g_addr_width)),
		width_a => g_data_width,
		widthad_a => g_addr_width,
--x		numwords_a => (2 ** g_addr_width),
		numwords_a => g_numwords,
		width_byteena_a => 1,
		outdata_reg_a => "CLOCK0",
		outdata_aclr_a => "CLEAR0",
		address_aclr_a => "CLEAR0",
		read_during_write_mode_mixed_ports => "DONT_CARE",
		ram_block_type => "AUTO",
		init_file => g_init_file,
		intended_device_family => "Stratix"
	)
	PORT MAP (
		aclr0 => aclr,
		clock0 => clock,
		address_a => addr,
		q_a => data_out
	);


end rtl;

