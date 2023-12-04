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

entity maxii_lcell is
  port (clk     : in std_logic;
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        aclr    : in std_logic;
        aload    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        ena : in std_logic;
        cin   : in std_logic;
        cin0   : in std_logic;
        cin1   : in std_logic;
        inverta   : in std_logic;
        regcascin     : in std_logic;
        enable_asynch_arcs     : in std_logic;
        modesel   : in std_logic_vector(12 downto 0);
        pathsel   : in std_logic_vector(10 downto 0);
        combout   : out std_logic;
        regout    : out std_logic;
        cout    : out std_logic;
        cout0    : out std_logic;
        cout1  : out std_logic);
end maxii_lcell;
        
architecture vital_le_atom of maxii_lcell is

signal regin : std_logic;
signal dffin : std_logic;
signal qfbkin  : std_logic;

component maxii_asynch_lcell 
  port (
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        cin       : in std_logic;
        cin0       : in std_logic;
        cin1       : in std_logic;
        inverta       : in std_logic;
        qfbkin    : in std_logic;
        modesel   : in std_logic_vector(12 downto 0);
        pathsel   : in std_logic_vector(10 downto 0);
        regin   : out std_logic;
        combout   : out std_logic;
        cout      : out std_logic;
        cout0      : out std_logic;
        cout1      : out std_logic);
end component;

component maxii_lcell_register
  port (clk     : in std_logic;
        modesel   : in std_logic_vector(12 downto 0);
        aclr    : in std_logic;
        aload    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        ena : in std_logic;
        datain     : in std_logic;
        adata     : in std_logic;
        regcascin     : in std_logic;
        enable_asynch_arcs     : in std_logic;
        regout    : out std_logic;
        qfbkout     : out std_logic);
end component;

component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component; 


begin

lecomb: maxii_asynch_lcell
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cin0 => cin0, cin1 => cin1, inverta => inverta, qfbkin => qfbkin, modesel => modesel, pathsel => pathsel, regin => regin,
                  combout => combout, cout => cout, cout0 => cout0, cout1 => cout1);

regin_datac: AND2
   port map( Y =>  dffin, IN1 =>  regin, IN2 =>  datac);

lereg: maxii_lcell_register
  	port map (clk => clk, modesel => modesel, aclr => aclr, aload => aload, sclr => sclr, sload => sload, ena => ena, datain => dffin, adata => datac,
                  regcascin => regcascin, regout => regout,
                  qfbkout => qfbkin, enable_asynch_arcs => enable_asynch_arcs);


end vital_le_atom;


