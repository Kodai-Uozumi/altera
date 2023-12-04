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

entity  max_io is
  port (	datain          : in std_logic := '0';
              	oe              : in std_logic := '1';
              	modesel         : in std_logic_vector(8 downto 0);
              	dataout         : out std_logic;
              	padio           : inout std_logic);
end max_io;
        
architecture structure of max_io is
	signal data_out : std_logic;
	
component max_asynch_io
  port (	datain : in  STD_LOGIC := '0';
                oe         : in  STD_LOGIC := '0';
                modesel : in std_logic_vector(8 downto 0);
                padio  : inout STD_LOGIC;
                dataout: out STD_LOGIC);
end component;

begin

asynch_inst: max_asynch_io
  port map (	datain => datain, 
		oe => oe, 
		padio => padio,
		dataout => data_out,
        	modesel => modesel);

dataout <= data_out;

end structure;

library IEEE;
use IEEE.std_logic_1164.all;

entity max_mcell is

  port (	pterm0	: in std_logic_vector(51 downto 0);
        	pterm1  : in std_logic_vector(51 downto 0);
        	pterm2  : in std_logic_vector(51 downto 0);
        	pterm3  : in std_logic_vector(51 downto 0);
        	pterm4  : in std_logic_vector(51 downto 0);
        	pterm5  : in std_logic_vector(51 downto 0);
        	pclk    : in std_logic_vector(51 downto 0);
        	pena    : in std_logic_vector(51 downto 0);
        	paclr   : in std_logic_vector(51 downto 0);
        	papre   : in std_logic_vector(51 downto 0);
        	pxor    : in std_logic_vector(51 downto 0);
        	pexpin	: in std_logic := '0';
        	clk	: in std_logic := '0';
			aclr	: in std_logic := '0';
			fpin	: in std_logic := '1';
        	modesel : in std_logic_vector(12 downto 0);
			dataout : out std_logic;
        	pexpout : out std_logic );

end max_mcell; 

architecture vital_mcell_atom of max_mcell is

component max_asynch_mcell
  port (	pterm0	: in std_logic_vector(51 downto 0);
        	pterm1  : in std_logic_vector(51 downto 0);
        	pterm2  : in std_logic_vector(51 downto 0);
        	pterm3  : in std_logic_vector(51 downto 0);
        	pterm4  : in std_logic_vector(51 downto 0);
        	pterm5  : in std_logic_vector(51 downto 0);
        	fpin 	: in std_logic := '1';
        	pxor    : in std_logic_vector(51 downto 0);
        	pexpin	: in std_logic := '0';
        	fbkin : in std_logic;
			modesel : in std_logic_vector(12 downto 0);
			combout : out std_logic;
        	regin : out std_logic;
        	pexpout : out std_logic );
end component; 

component max_mcell_register
  port ( datain	: in std_logic;
        	clk	: in std_logic;
			aclr	: in std_logic;
        	pclk    : in std_logic_vector(51 downto 0);
        	pena    : in std_logic_vector(51 downto 0);
        	paclr   : in std_logic_vector(51 downto 0);
        	papre   : in std_logic_vector(51 downto 0);
			modesel : in std_logic_vector(12 downto 0);
			regout : out std_logic;
        	fbkout : out std_logic);
end component; 

component mux21
          port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end component;

signal fbk, dffin, combo, dffo	:std_ulogic ;

begin

pcom: max_asynch_mcell 
  port map ( 	pterm0 => pterm0, pterm1 => pterm1, pterm2 => pterm2, pterm3 => pterm3,
		pterm4 => pterm4, pterm5 => pterm5, fpin => fpin, pxor => pxor, pexpin => pexpin, fbkin => fbk, 
		modesel=>modesel, regin => dffin, combout => combo, pexpout => pexpout);

preg: max_mcell_register
  port map ( 	datain => dffin, clk => clk, aclr => aclr,
				pclk => pclk, pena => pena, paclr => paclr, papre => papre, modesel => modesel,
                regout => dffo, fbkout => fbk);	

--dataout <= combo when output_mode = "comb" else dffo;
sel: mux21 
     port map (A => dffo, B => combo, S => modesel(6), 
               MO => dataout);


end vital_mcell_atom;


library IEEE;
use IEEE.std_logic_1164.all;

entity  max_sexp is
  port (	datain          : in std_logic_vector(51 downto 0);
              	dataout         : out std_logic);
end max_sexp;

architecture structure of max_sexp is
	signal data_out : std_logic;
	
component max_asynch_sexp
  port (	datain : in std_logic_vector(51 downto 0);
                dataout: out STD_LOGIC);
end component;
begin
pcom: max_asynch_sexp
  port map (	datain => datain, 
				dataout => data_out);

dataout <= data_out;

end structure;
