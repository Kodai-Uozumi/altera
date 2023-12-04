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



library IEEE;
use IEEE.std_logic_1164.all;

-- 4-to-1 mux: 
entity mux41 is
	port (
		I0 : in std_logic;
		I1 : in std_logic;
		I2 : in std_logic;
		I3: in std_logic;
		S0: in std_logic;
		S1: in std_logic;
		MO: out std_logic );
end mux41;

architecture structure of mux41 is

component mux21
	port (
		A : in std_logic;
        B : in std_logic;
        S : in std_logic;
        MO : out std_logic);
end component;

signal int_01, int_23 : std_logic;
begin
	inst1: mux21 port map  (MO =>  int_01, A =>  I0, B =>  I1, S =>  S0);
	inst2: mux21 port map  (MO =>  int_23, A =>  I2, B =>  I3, S =>  S0);
	inst3: mux21 port map  (MO => MO, A =>  int_01, B =>  int_23, S =>  S1);

end structure;

library IEEE;
use IEEE.std_logic_1164.all;

entity cycloneiii_clkctrl is 
	port (
		ena : in std_logic;
		inclk : in std_logic_vector(3 downto 0);
		clkselect : in std_logic_vector(1 downto 0);
		modesel : in std_logic_vector(3 downto 0);
		outclk: out std_logic );
end cycloneiii_clkctrl;

architecture structure of cycloneiii_clkctrl is
  component dffe
   port(
      Q                              :  out   std_logic;
      D                              :  in    std_logic;
      CLRN                           :  in    std_logic;
      PRN                            :  in    std_logic;
      CLK                            :  in    std_logic;
      ENA                            :  in    std_logic);
end component;
	component mux41
	port (
			I0 : in std_logic;
			I1 : in std_logic;
			I2 : in std_logic;
			I3 : in std_logic;
			S0 : in std_logic;
			S1 : in std_logic;
			MO : out std_logic);
	end component;

	component bb2
	port (
			in1 : in std_logic;
			in2 : in std_logic;
			y : out std_logic);
	end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
	end component;

  component OR2
   port(
      IN2   : in STD_LOGIC;
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
	end component;

  component AND2
   port(
      IN2   : in STD_LOGIC;
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
	end component;

	signal    clkmux_out, clkmux_out_inv, cereg_out : std_logic;
	signal vcc : std_logic;
	signal ena_is_gnd, ena_is_used, ena_is_not_used, ce_out : std_logic;
	signal ena_is_not_gnd, clk_out : std_logic;
begin
	vcc <= '1';

	-- modelsel(0) : ena is gnd
	-- modelsel(1) : ena is used(i.e not vcc, and not connected)

	ena_is_gnd <=  modesel(0);
	ena_is_used <= modesel(1);


	mux_inst: mux41 port map  ( MO =>  clkmux_out, I0 =>  inclk(0), I1 => inclk(1), I2 =>  inclk(2), I3 =>  inclk(3) , S0 =>  clkselect(0), S1 =>  clkselect(1) );

	inv_1: INV port map  (Y =>  clkmux_out_inv, IN1 =>  clkmux_out);

	extena0_reg : dffe port map 	(Q =>  cereg_out, CLK =>  clkmux_out_inv, ENA =>  vcc, D =>  ena, CLRN =>  vcc, PRN =>  vcc);

	inv_2: INV port map  (Y =>  ena_is_not_used, IN1 =>  ena_is_used );
	or2_inst: OR2   port map  (Y =>  ce_out, IN1 =>  ena_is_not_used, IN2 =>  cereg_out);

	inv_3: INV port map  (Y =>  ena_is_not_gnd, IN1 =>  ena_is_gnd );
	and2_inst: AND2    port map  (Y =>  clk_out, IN1 =>  ena_is_not_gnd, IN2 =>  clkmux_out);
	bb_1: bb2 port map  (y =>  outclk, in1 =>  ce_out, in2 =>  clk_out );		
        
end structure;

