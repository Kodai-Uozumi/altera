-- Copyright (C) 1991-2009 Altera Corporation
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
-- Quartus II 9.0 Build 132 02/25/2009

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.flex6k_atom_pack.all;

package FLEX6000_COMPONENTS is

component flex6k_lcell
  generic (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      packed_mode   : string := "false";
      lut_mask       : string := "ffff";
      power_up : string := "low";
	  cin_used       : string := "false");

  port (clk     : in std_logic := '0';
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        cin   : in std_logic := '0';
        cascin     : in std_logic := '1';
        devclrn : in std_logic := '1';
        devpor  : in std_logic := '1';
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end component;

component flex6k_io 
   generic (operation_mode : string := "input";
           	feedback_mode : string := "from_pin";
      	power_up : string := "low";
	output_enable : string := "false");

    port (datain : in std_logic := '1';
          oe     : in std_logic := '1';
          devclrn : in std_logic := '1';
          devpor  : in std_logic := '1';
          devoe   : in std_logic := '0';
          padio  : inout std_logic;
          combout : out std_logic);
end component;

end flex6000_components;

