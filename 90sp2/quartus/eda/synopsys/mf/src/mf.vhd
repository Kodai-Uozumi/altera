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



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity A_81MUX is
	port (A, B, C, GN : in std_logic;
	      D0, D1, D2, D3, D4, D5, D6, D7 : in std_logic;
	      Y, WN : out std_logic);
end A_81MUX;

architecture BEHAVIOR of A_81MUX is
begin
	process(A, B, C, GN, D0, D1, D2, D3, D4, D5, D6, D7)
	variable sel : integer range 0 to 7;
	begin
		if GN = '1' then
			Y <= '0';
			WN <= '1';
		else 

		sel := 0;
		if (A = '1') then sel := sel + 1; end if;		
		if (B = '1') then sel := sel + 2; end if;		
		if (C = '1') then sel := sel + 4; end if;		

		case sel is
		 when 0 =>
			Y <= D0;
			WN <= not D0;
		 when 1 =>
			Y <= D1;
			WN <= not D1;
		 when 2 =>
			Y <= D2;
			WN <= not D2;
		 when 3 =>
			Y <= D3;
			WN <= not D3;
		 when 4 =>
			Y <= D4;
			WN <= not D4;
		 when 5 =>
			Y <= D5;
			WN <= not D5;
		 when 6 =>
			Y <= D6;
			WN <= not D6;
		 when 7 =>
			Y <= D7;
			WN <= not D7;
		end case;
		end if;
	end process;
end BEHAVIOR;

---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity A_8COUNT is
	port (A, B, C, D, E, F, G, H : in std_logic;
	      LDN, GN, DNUP, SETN, CLRN, CLK: in std_logic;
	      QA, QB, QC, QD, QE, QF, QG, QH, COUT : out std_logic);
end A_8COUNT;

architecture BEHAVIOR of A_8COUNT is
        constant SIZE : integer := 7;
	signal tmp : std_logic_vector(SIZE downto 0);
begin
	process(CLK,CLRN,SETN,LDN,DNUP,GN,A,B,C,D,E,F,G,H)
	begin

		if CLRN = '0' and SETN = '1' then
		   tmp <= "00000000";
		elsif CLRN = '1' and SETN = '0' then
	           tmp <= (H&G&F&E&D&C&B&A);
		elsif (CLK'event and CLK = '1') then
		   if CLRN = '1' and SETN = '1' then
		   	if LDN = '0' then
				tmp <= (H&G&F&E&D&C&B&A);
		   	elsif DNUP = '1' and GN = '0' then
		   		tmp <= tmp - 1;
		   	elsif DNUP = '0' and GN = '0' then
		   		tmp <= tmp + 1;
		   	end if;
		   end if;

		end if;
	end process;
		COUT <= ((not DNUP) and (not GN) and LDN and tmp(0) and tmp(1)
			 and tmp(2) and tmp(3) and tmp(4) and tmp(5) and tmp(6)
			 and tmp(7))    or
		       	(DNUP and (not GN) and LDN and ((not tmp(0)) and 
			 (not tmp(1)) and (not tmp(2)) and (not tmp(3)) and
			 (not tmp(4)) and (not tmp(5)) and (not tmp(6)) and
			 (not tmp(7))));

        QA <= tmp(0); 
        QB <= tmp(1);
        QC <= tmp(2);
        QD <= tmp(3);
        QE <= tmp(4);
        QF <= tmp(5);
        QG <= tmp(6);
        QH <= tmp(7);
end BEHAVIOR;
---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity A_8FADD is
	port (A8, A7, A6, A5, A4, A3, A2, A1 : in std_logic;
	      B8, B7, B6, B5, B4, B3, B2, B1 : in std_logic;
	      CIN : in std_logic;
	      SUM8, SUM7, SUM6, SUM5, SUM4, SUM3, SUM2, SUM1, COUT : out std_logic);
end A_8FADD;

architecture BEHAVIOR of A_8FADD is
        constant SIZE : integer := 7;
        signal ABUS: std_logic_vector(SIZE downto 0);
        signal BBUS: std_logic_vector(SIZE downto 0);
        signal SUMBUS : std_logic_vector(SIZE+1 downto 0);
begin
		
        ABUS <= (A8&A7&A6&A5&A4&A3&A2&A1);
        BBUS <= (B8&B7&B6&B5&B4&B3&B2&B1);
		SUMBUS <= ('0'&ABUS) + BBUS+ CIN;
		COUT <= SUMBUS(8);

        SUM1 <= SUMBUS(0);
        SUM2 <= SUMBUS(1);
        SUM3 <= SUMBUS(2);
        SUM4 <= SUMBUS(3);
        SUM5 <= SUMBUS(4);
        SUM6 <= SUMBUS(5);
        SUM7 <= SUMBUS(6);
        SUM8 <= SUMBUS(7);

end BEHAVIOR;

---------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity A_8MCOMP is
	port (A7, A6, A5, A4, A3, A2, A1, A0 : in std_logic;
	      B7, B6, B5, B4, B3, B2, B1, B0 : in std_logic;
	      ALTB, AEQB, AGTB : out std_logic;
	      AEB7, AEB6, AEB5, AEB4, AEB3, AEB2, AEB1, AEB0 : out std_logic);
end A_8MCOMP;


architecture BEHAVIOR of A_8MCOMP is
        constant SIZE : integer := 7;
        signal ABUS : std_logic_vector(SIZE downto 0);
        signal BBUS : std_logic_vector(SIZE downto 0);
        signal AEBBUS: std_logic_vector(SIZE downto 0);
begin
        ABUS <= (A7&A6&A5&A4&A3&A2&A1&A0);
        BBUS <= (B7&B6&B5&B4&B3&B2&B1&B0);
	process(ABUS , BBUS)
	begin
		if ABUS > BBUS then
			AGTB <= '1';
			ALTB <= '0';
			AEQB <= '0';
		elsif ABUS = BBUS then
			AEQB <= '1';
			AGTB <= '0';
			ALTB <= '0';
		elsif ABUS < BBUS then
			ALTB <= '1';
			AEQB <= '0';
			AGTB <= '0';
		end if;
	end process;

	process(ABUS ,BBUS)
	begin
		for i in 7 downto 0 loop
			if ABUS(i) = BBUS (i) then
				AEBBUS(i) <= '1';
			else AEBBUS(i) <= '0';
			end if;
		end loop;
	end process;

        AEB0 <= AEBBUS(0);
        AEB1 <= AEBBUS(1);
        AEB2 <= AEBBUS(2);
        AEB3 <= AEBBUS(3);
        AEB4 <= AEBBUS(4);
        AEB5 <= AEBBUS(5);
        AEB6 <= AEBBUS(6);
        AEB7 <= AEBBUS(7);

end BEHAVIOR;

