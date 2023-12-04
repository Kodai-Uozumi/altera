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

-- NCO  Frequency Hopping Example Design - Testbench
-- Description: This is the VHDL testbench for the Frequency Hopping Example Design.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

use std.textio.all;

-----------------------------------------------------------
-- Declare entity for module testbench (Configure Generics)
-----------------------------------------------------------
entity freq_hopping_example_tb is   
  generic(
		PHASE_INC_WIDTH		:	INTEGER:=32; --Phase increment input width 
		WAVE_OUTPUT_WIDTH	:	INTEGER:=18  --Waveform output width
        );
end freq_hopping_example_tb;        

architecture tb of freq_hopping_example_tb is

---------------------------------------------------------------------------
-- Convert integer to unsigned std_logic_vector
-- Input: 	Integer
-- Output:	std_logic_vector 
-- This function is required because the frequency values are generated
-- as integers , but the core requires a std_logic_vector  
---------------------------------------------------------------------------
function int2ustd(value : integer; width : integer) return std_logic_vector is 

variable temp :   std_logic_vector(width-1 downto 0);
begin
	if (width>0) then
		temp:=conv_std_logic_vector(conv_unsigned(value, width ), width);
	end if ;
	return temp;
end int2ustd;


----------------------------------------------------------------------------------------
-- Convert hopping frequency values (in Hz) into Phase Increment values for the NCO core
-- Input: 	Hopping frequency
-- Output:	Phase Increment value
----------------------------------------------------------------------------------------
function freq2phi(value: integer)  return integer is

variable results : integer ;
variable temp : real;
begin
   -- phi = [fo/fclk*2^(PHASE_INC_WIDTH)]*n
   -- where:
		-- fo = hopping frequency (input)
		-- fclk = clock frequency (for this design = 200e6 (200 MHz)
		-- PHASE_INC_WIDTH = 32   (for this design)
		-- n = number of channels (n=1 for this design)
   
   -- Note that in this function we decompose the multiplication by
   -- 2^(PHASE_INC_WIDTH) to avoid high precision fixed/floating point
   -- arithmetic errors
   
	temp:=(real(2**16)*1.0*real(value));	-- multiplying by 2^16 is the first half of the multiplication decomposition (PHASE_INC_WIDTH = 32)  
	temp:= temp/200000000.0; 				-- divide by 200 MHz (fclk)                 
	temp:= temp*real(2**16); 				-- Perform second half of multiplication decomposition
	results:=integer(temp);	
	return results;
end freq2phi;

---------------------------------------------------------
-- Declare component for frequency hopping example design
---------------------------------------------------------
component freq_hopping_example
  generic(
		PHASE_INC_WIDTH		:	INTEGER:=32; --Phase increment input width 
		WAVE_OUTPUT_WIDTH	:	INTEGER:=18  --Sine and cosine output width
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
end component;

------------------
-- Declare signals
------------------
signal clk				: std_logic;
signal clken			: std_logic;
signal reset_n			: std_logic;

-- Avalon-MM interface
signal write			: std_logic;
signal write_data		: std_logic_vector (PHASE_INC_WIDTH-1 downto 0);
signal address			: std_logic_vector (3 downto 0);

-- Select which frequency is output value
signal freq_sel			: std_logic_vector (3 downto 0);

-- Sine and cosine output port
signal fsin_o			: std_logic_vector (WAVE_OUTPUT_WIDTH-1 downto 0);
signal fcos_o			: std_logic_vector (WAVE_OUTPUT_WIDTH-1 downto 0);
signal out_valid		: std_logic;

-- Clock cycle
constant clk_half_cycle	: time := 2500 ps;
constant clk_cycle		: time := 5000 ps;

----------------------------------+------+------+------+------+------+------+-----+------+-------+------+------+------+------+------+------+-------+
--|hopping freq  (KHz)            |  1   |  2   |  5   |  8   |  10  |  20  |  50 |  80  |  100  | 200  | 500  |  800 | 1000 | 2000 | 5000 | 10000 |
--+-------------------------------+------+------+------+------+------+------+-----+------+-------+------+------+------+------+------+------+-------+
--|holding time(no. of clk cycles)| 1500 | 1000 | 800  | 2000 | 1000 | 1500 | 500 | 1000 |  800  | 1500 | 1000 | 2000 |  800 | 1500 | 2000 |  1000 |
--+-------------------------------+------+------+------+------+------+------+-----+------+-------+------+------+------+------+------+------+-------*/

-- hopping frequencies (Hz)
constant FREQ_01 :  INTEGER:= 1_000     ; -- 1    KHz
constant FREQ_02 :  INTEGER:= 2_000     ; -- 2    KHz
constant FREQ_03 :  INTEGER:= 5_000     ; -- 5    KHz
constant FREQ_04 :  INTEGER:= 8_000     ; -- 8    KHz
constant FREQ_05 :  INTEGER:= 10_000    ; -- 10   KHz
constant FREQ_06 :  INTEGER:= 20_000    ; -- 20   KHz
constant FREQ_07 :  INTEGER:= 50_000    ; -- 50   KHz
constant FREQ_08 :  INTEGER:= 80_000    ; -- 80   KHz
constant FREQ_09 :  INTEGER:= 100_000   ; -- 100  KHz
constant FREQ_10 :  INTEGER:= 200_000   ; -- 200  KHz
constant FREQ_11 :  INTEGER:= 500_000   ; -- 500  KHz
constant FREQ_12 :  INTEGER:= 800_000   ; -- 800  KHz
constant FREQ_13 :  INTEGER:= 1_000_000 ; -- 1    MHz
constant FREQ_14 :  INTEGER:= 2_000_000 ; -- 2    MHz
constant FREQ_15 :  INTEGER:= 5_000_000 ; -- 5    MHz
constant FREQ_16 :  INTEGER:= 10_000_000; -- 10   MHz

-- holding time at hopping frequencies (number of clock cycle)
constant TIME_01 :  INTEGER:= 15000;
constant TIME_02 :  INTEGER:= 10000;
constant TIME_03 :  INTEGER:= 8000 ;
constant TIME_04 :  INTEGER:= 20000;
constant TIME_05 :  INTEGER:= 10000;
constant TIME_06 :  INTEGER:= 15000;
constant TIME_07 :  INTEGER:= 5000 ;
constant TIME_08 :  INTEGER:= 10000;
constant TIME_09 :  INTEGER:= 8000 ;
constant TIME_10 :  INTEGER:= 15000;
constant TIME_11 :  INTEGER:= 10000;
constant TIME_12 :  INTEGER:= 20000;
constant TIME_13 :  INTEGER:= 15000;
constant TIME_14 :  INTEGER:= 15000;
constant TIME_15 :  INTEGER:= 15000;
constant TIME_16 :  INTEGER:= 10000;

begin
---------------------------------------
-- Instantiate freq_hopping_example.vhd
---------------------------------------
freq_hopping_example_inst: freq_hopping_example
generic map(
		PHASE_INC_WIDTH		=> PHASE_INC_WIDTH,
		WAVE_OUTPUT_WIDTH	=> WAVE_OUTPUT_WIDTH
	)

port map( 	clk				=> clk,
			clken			=> clken,
			reset_n			=> reset_n,
			
			write			=> write,
			write_data		=> write_data,
			address			=> address,
			
			freq_sel		=> freq_sel,
			

			fsin_o			=> fsin_o,
			fcos_o			=> fcos_o,
			out_valid		=> out_valid  
	);
	
------------------------
-- Generate Clock signal
------------------------
clk_gen : process
begin
	loop
		clk<='0' , '1'  after clk_half_cycle;
     		wait for clk_cycle;
        end loop;
end process clk_gen;

-------------------------------------
-- Generate reset_n and clken signals
-------------------------------------
reset_n <= '0',
           '1' after 10*clk_cycle ;
		   
clken   <= '0',
           '1' after 5*clk_cycle ;

-------------------------------------------------------------------------------------------------
-- Write values of hopping frequencies to the Phase Incremental Registers via Avalon-MM interface
-------------------------------------------------------------------------------------------------
-- Generate write signal
control_write_signal : process
  begin
	write	<= '0';
	wait for 20*clk_cycle;
	write	<= '1';
	
	wait until address = "1111";
	wait for 2*clk_cycle;
	write	<= '0';
	wait;
  end process control_write_signal;

-- Generate address bus
control_address_bus : process
  begin
	address <= 	"0000";
	wait until write = '1';
	
	for i in 0 to 15 loop
		wait for 2*clk_cycle;
		address <= (address + 1);
	end loop;
	
	wait until address = "1111";
	address <= "0000";
  end process control_address_bus;

-- Generate write_data bus
control_write_data_bus : process
  begin
	write_data  <= 	(others => '0') ;
	wait until address = "0000" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_01),32);
	wait until address = "0001" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_02),32);
	wait until address = "0010" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_03),32);
	wait until address = "0011" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_04),32);
	wait until address = "0100" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_05),32);
	wait until address = "0101" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_06),32);
	wait until address = "0110" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_07),32);
	wait until address = "0111" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_08),32);
	wait until address = "1000" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_09),32);
	wait until address = "1001" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_10),32);
	wait until address = "1010" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_11),32);
	wait until address = "1011" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_12),32);
	wait until address = "1100" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_13),32);
	wait until address = "1101" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_14),32);
	wait until address = "1110" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_15),32);
	wait until address = "1111" and write = '1';
	
	write_data  <= 	int2ustd(freq2phi(FREQ_16),32);
	
  end process control_write_data_bus;
  
-----------------------------------------------------------------------------------------------------------------------------
-- Generate freq_sel signal, which will be used to select the hopping frequency of the signal that the NCO core will generate 
-----------------------------------------------------------------------------------------------------------------------------
control_freq_sel_bus : process
  begin
	freq_sel <= "0000";
	wait for (TIME_01*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_02*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_03*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_04*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_05*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_06*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_07*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_08*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_09*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_10*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_11*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_12*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_13*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_14*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	wait for (TIME_15*clk_cycle);
	
	freq_sel <= (freq_sel + 1);
	
  end process control_freq_sel_bus;

end tb;
	
