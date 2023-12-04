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

ENTITY tstrom IS
        PORT (
          addr :IN STD_LOGIC_VECTOR (7 DOWNTO 0);
          memenab :IN STD_LOGIC;
          q: OUT STD_LOGIC_VECTOR (14 DOWNTO 0));
END tstrom;

ARCHITECTURE behavior OF tstrom IS

COMPONENT asyn_rom_256x15
-- pragma translate_off
     GENERIC( LPM_FILE : string );
-- pragma translate_on
     PORT ( Address : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            MemEnab : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(14 DOWNTO 0)
     );
END COMPONENT;

BEGIN

	u1: asyn_rom_256x15
-- pragma translate_off
        GENERIC MAP ( LPM_FILE => "u1.hex")
-- pragma translate_on
	PORT MAP ( Address => addr, MemEnab => memenab, Q =>q);
END behavior;

