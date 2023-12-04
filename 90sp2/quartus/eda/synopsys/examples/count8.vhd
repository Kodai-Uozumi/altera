-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY altera;
USE altera.maxplus2.all;       --  Include Altera component declarations.

ENTITY count8 IS
	PORT (a    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	      ldn  : IN STD_LOGIC;
	      gn   : IN STD_LOGIC;
	      dnup : IN STD_LOGIC;
	      setn : IN STD_LOGIC;
	      clrn : IN STD_LOGIC;
	      clk  : IN STD_LOGIC;
	      co   : OUT STD_LOGIC;
	      Q    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END count8;

ARCHITECTURE structure OF count8 IS
	signal clk2x : STD_LOGIC;


COMPONENT clklock_2_40
     PORT (
             INCLK : IN STD_LOGIC;
             OUTCLK : OUT STD_LOGIC
     );
END COMPONENT;

BEGIN
	u1: clklock_2_40 
	PORT MAP ( inclk=>clk, outclk=>clk2x);

	u2: a_8count 
	PORT MAP ( a=>a(0), b=>a(1), c=>a(2), d=>a(3),
		   e=>a(4), f=>a(5), g=>a(6), h=>a(7),
		   clk=>clk2x,
		   ldn=>ldn,
		   gn=>gn,
		   dnup=>dnup,
		   setn=>setn,
		   clrn=>clrn,
	           qa=>q(0), qb=>q(1), qc=>q(2), qd=>q(3),
		   qe=>q(4), qf=>q(5), qg=>q(6), qh=>q(7),
		   cout=>co);

END structure;
