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

entity flex6k_lcell is
  port (clk     : in std_logic;
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        aclr    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        ena : in std_logic;
        cin   : in std_logic;
        cascin     : in std_logic;
        modesel   : in std_logic_vector(6 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end flex6k_lcell;
        
architecture vital_le_atom of flex6k_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

component flex6k_asynch_lcell 
  port (
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        cin       : in std_logic;
        cascin    : in std_logic;
        qfbkin    : in std_logic;
        modesel   : in std_logic_vector(6 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        combout   : out std_logic;
        cout      : out std_logic;
        cascout   : out std_logic;
        regin     : out std_logic);
end component;

component flex6k_lcell_register
  port (clk     : in std_logic;
        datain     : in std_logic;
        datac     : in std_logic;
        aclr    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        modesel   : in std_logic_vector(6 downto 0);
        regout    : out std_logic;
        qfbko     : out std_logic);
end component;

begin

lecomb: flex6k_asynch_lcell
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cascin => cascin, qfbkin => qfbk, modesel => modesel, pathsel => pathsel,
                  combout => combout, cout => cout, cascout => cascout, regin => dffin);

lereg: flex6k_lcell_register
  	port map (clk => clk, datain => dffin, datac => datac, 
                  aclr => aclr, sclr => sclr, sload => sload, modesel => modesel,
                  regout => regout,
                  qfbko => qfbk);


end vital_le_atom;


library IEEE;
use IEEE.std_logic_1164.all;

entity  flex6k_io is
    port ( datain : in std_logic;
          oe     : in std_logic;
          modesel : in std_logic_vector(4 downto 0);
          padio  : inout std_logic;
          combout  : out std_logic);

end flex6k_io;

architecture arch of flex6k_io is

   signal comb_out : std_logic;
	signal vcc : std_logic;

component flex6k_asynch_io
    port (datain : in std_logic;
          oe   : in std_logic;
          modesel : in std_logic_vector(4 downto 0);
          padio  : inout std_logic;
          combout  : out std_logic);
end component;

begin

vcc <= '1';

asynch_inst: flex6k_asynch_io
     port map (datain => datain, oe => oe, padio => padio, 
                           combout => combout, modesel => modesel);

end arch;

