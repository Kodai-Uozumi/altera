-- Copyright (C) 1988-2009 Altera Corporation

-- Any megafunction design, and related net list (encrypted or decrypted),
-- support information, device programming or simulation file, and any other
-- associated documentation or information provided by Altera or a partner
-- under Altera's Megafunction Partnership Program may be used only to
-- program PLD devices (but not masked PLD devices) from Altera.  Any other
-- use of such megafunction design, net list, support information, device
-- programming or simulation file, or any other related documentation or
-- information is prohibited for any other purpose, including, but not
-- limited to modification, reverse engineering, de-compiling, or use with
-- any other silicon devices, unless such use is explicitly licensed under
-- a separate agreement with Altera or a megafunction partner.  Title to
-- the intellectual property, including patents, copyrights, trademarks,
-- trade secrets, or maskworks, embodied in any such megafunction design,
-- net list, support information, device programming or simulation file, or
-- any other related documentation or information provided by Altera or a
-- megafunction partner, remains with Altera, the megafunction partner, or
-- their respective licensors.  No other licenses, including any licenses
-- needed under any third party's intellectual property, are provided herein.

-- NCO Frequency Hopping Example Design 
-- Description: This is the toplevel of the NCO Frequency Hopping Example Design (VHDL version)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use std.textio.all;

----------------------
-- Declare main entity
----------------------
entity freq_hopping_example is   
  generic(
		PHASE_INC_WIDTH	:	INTEGER:=32;  --Phase increment input width 
		WAVE_OUTPUT_WIDTH	:	INTEGER:=18  --Waveform output width
        );

  port(
		clk			: IN std_logic;
		clken		: IN std_logic;
		reset_n		: IN std_logic;
		
		-- Avalon-MM interface
		write		: IN std_logic;
		write_data	: IN std_logic_vector (PHASE_INC_WIDTH-1 downto 0);
		address		: IN std_logic_vector (3 downto 0);
		
		
		-- Select which frequency is output value
		freq_sel	: IN std_logic_vector (3 downto 0);
		
		--  Sine and cosine output port
		fsin_o		: OUT std_logic_vector (WAVE_OUTPUT_WIDTH-1 downto 0);
		fcos_o		: OUT std_logic_vector (WAVE_OUTPUT_WIDTH-1 downto 0);
		out_valid	: OUT std_logic
	);
end freq_hopping_example;
 
architecture nco_inst of freq_hopping_example is

	----------------------------------------
	-- Component declaration for NCO IP Core
	----------------------------------------
	component nco

	port(
			clk					: IN STD_LOGIC ;
			clken				: IN STD_LOGIC ;
			reset_n				: IN STD_LOGIC ;
			
			phi_inc_i			: IN STD_LOGIC_VECTOR (PHASE_INC_WIDTH-1 DOWNTO 0);
			
			fsin_o				: OUT STD_LOGIC_VECTOR (WAVE_OUTPUT_WIDTH-1 DOWNTO 0);
			fcos_o				: OUT STD_LOGIC_VECTOR (WAVE_OUTPUT_WIDTH-1 DOWNTO 0);
			out_valid			: OUT STD_LOGIC
			);
	end component;

	------------------
	-- Declare Signals
	------------------
	
	-- Phase increment.  This value controls the output frequency of the NCO
	signal phi_inc_i			: std_logic_vector (PHASE_INC_WIDTH-1 downto 0);	
	
	-- This signal stores initial values of phase increment
	type STD_LOGIC_2D is array (15 downto 0) of STD_LOGIC_VECTOR (PHASE_INC_WIDTH-1 downto 0);
	signal phase_inc_reg		: STD_LOGIC_2D ;
	
	begin
	-----------------------
	-- Instantiate NCO core
	-----------------------
	nco_inst: nco
	
	port map(  clk			=>clk,
			   reset_n		=>reset_n,
			   clken		=>clken,
			   phi_inc_i	=>phi_inc_i,
			   fsin_o		=>fsin_o,
			   fcos_o		=>fcos_o,
			   out_valid	=>out_valid
		);

	-------------------------------------------------------------
	-- Write value to phase increment registers through Avalon-MM
	-- Each register has an unique address.
	-------------------------------------------------------------
	avalon_mm : process(clk,reset_n) is
	  begin
	    -- Reset whenever the reset signal goes low, regardless of the clock
		if(reset_n='0') then
			for i in 0 to 15 loop
					phase_inc_reg (i) <= (others =>'0');
			end loop;
		-- If not resetting, and the clock signal is enabled on this register,
		-- update the register output on the clock's rising edge
		elsif rising_edge(clk)then               
			if(write='1') then
				case address is 
					when "0000" =>
						phase_inc_reg (0) <= write_data;
					when "0001" =>
						phase_inc_reg (1) <= write_data;
					when "0010" =>
						phase_inc_reg (2) <= write_data;
					when "0011" =>
						phase_inc_reg (3) <= write_data;
					when "0100" =>
						phase_inc_reg (4) <= write_data;
					when "0101" =>
						phase_inc_reg (5) <= write_data;
					when "0110" =>
						phase_inc_reg (6) <= write_data;
					when "0111" =>
						phase_inc_reg (7) <= write_data;
					when "1000" =>
						phase_inc_reg (8) <= write_data;
					when "1001" =>
						phase_inc_reg (9) <= write_data;
					when "1010" =>
						phase_inc_reg (10) <= write_data;
					when "1011" =>
						phase_inc_reg (11) <= write_data;
					when "1100" =>
						phase_inc_reg (12) <= write_data;
					when "1101" =>
						phase_inc_reg (13) <= write_data;
					when "1110" =>
						phase_inc_reg (14) <= write_data;
					when others =>
						phase_inc_reg (15) <= write_data;
				end case;
			end if;
		end if;
	end process avalon_mm;
	
	-----------------------------------------------------------------------------
	-- Select the hopping frequency for the signal that the NCO core will generate  
	-----------------------------------------------------------------------------
	phase_inc_select: process(freq_sel,phase_inc_reg) is 
        begin
     		case freq_sel is
				when "0000" =>
					phi_inc_i	<=	phase_inc_reg (0);
				when "0001" =>
					phi_inc_i	<=	phase_inc_reg (1);
				when "0010" =>
					phi_inc_i	<=	phase_inc_reg (2);
				when "0011" =>
					phi_inc_i	<=	phase_inc_reg (3);
				when "0100" =>
					phi_inc_i	<=	phase_inc_reg (4);
				when "0101" =>
					phi_inc_i	<=	phase_inc_reg (5);
				when "0110" =>
					phi_inc_i	<=	phase_inc_reg (6);
				when "0111" =>
					phi_inc_i	<=	phase_inc_reg (7);
				when "1000" =>
					phi_inc_i	<=	phase_inc_reg (8);
				when "1001" =>
					phi_inc_i	<=	phase_inc_reg (9);
				when "1010" =>
					phi_inc_i	<=	phase_inc_reg (10);
				when "1011" =>
					phi_inc_i	<=	phase_inc_reg (11);
				when "1100" =>
					phi_inc_i	<=	phase_inc_reg (12);
				when "1101" =>
					phi_inc_i	<=	phase_inc_reg (13);
				when "1110" =>
					phi_inc_i	<=	phase_inc_reg (14);
				when others =>
					phi_inc_i	<=	phase_inc_reg (15);                    
			end case;
	end process phase_inc_select;

end nco_inst;

