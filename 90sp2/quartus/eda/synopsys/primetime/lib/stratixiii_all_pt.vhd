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


library IEEE;
use IEEE.std_logic_1164.all;

-- special 4-to-1 mux: 
-- output of 4-1 mux is gated with ACTIVE LOW PASSN input
-- i.e if pass = 0, output = one of clocks
--     if pass = 1, output = 0
entity  mux41_spc is
    port (
			INP                       : in std_logic_vector(3 downto 0);
			S0                       : in std_logic;
			S1                       : in std_logic;
			PASSN                       : in std_logic;
			MO                       : out std_logic);
end mux41_spc;

architecture structure of mux41_spc is
component mux21
	port (
		A : in std_logic;
        B : in std_logic;
        S : in std_logic;
        MO : out std_logic);
end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;
signal int_01, int_23, int_0123, PASSN_INV : std_logic;

begin    

	inst1: mux21  port map(MO =>  int_01, A =>  INP(0), B =>  INP(1), S =>  S0);
	inst2: mux21  port map(MO =>  int_23, A =>  INP(2), B =>  INP(3), S =>  S0);
	inst3: mux21  port map(MO =>  int_0123, A =>  int_01, B =>  int_23, S =>  S1);
	inst4: INV  port map(Y =>  PASSN_INV, IN1 =>  PASSN);
	inst5: AND2  port map(Y =>  MO, IN1 =>  int_0123, IN2 =>  PASSN_INV);

end structure;



library IEEE;
use IEEE.std_logic_1164.all;

-- special 2-to-1 mux: 
-- output of 2-1 mux is gated with PASS input
-- output = 0 if pass = 0
-- output = one of inputs if pass = 1
entity  mux21_spc is
    port (
			IN0                       : in std_logic;
			IN1                       : in std_logic;
			S                       : in std_logic;
			PASS                       : in std_logic;
			MO                       : out std_logic);
end mux21_spc;

architecture structure of mux21_spc is
component mux21
	port (
		A : in std_logic := '0';
        B : in std_logic := '0';
        S : in std_logic := '0';
        MO : out std_logic);
end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;
signal int_01 : std_logic;
begin    

	inst1: mux21  port map(MO =>  int_01, A =>  IN0, B =>  IN1, S =>  S);
	inst3: AND2  port map(Y =>  MO, IN1 =>  int_01, IN2 =>  PASS);

end structure;


