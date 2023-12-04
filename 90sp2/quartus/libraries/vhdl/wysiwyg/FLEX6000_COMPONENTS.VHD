--
-- Copyright (C) 1988-2000 Altera Corporation
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
--
-- FILENAME     :    flex6000_components.vhd
-- FILE CONTENTS:    FLEX6000 VITAL Component Package 
-- DATE CREATED :    Mon Act 23 17:43:50 PST 2000
--
-- LIBRARY      :    work
-- REVISION     :    1.0
-- LOGIC SYSTEM :    IEEE-1164
-- NOTES        :
-- HISTORY      :
--
----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package FLEX6000_COMPONENTS is

component flex6k_lcell
  generic (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      packed_mode   : string := "false";
      lut_mask       : string := "ffff";
      power_up : string := "low";
		lpm_type : string := "flex6k_lcell";
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
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end component;

component flex6k_io 
   generic (operation_mode : string := "input";
           	feedback_mode : string := "from_pin";
      	power_up : string := "low";
		lpm_type : string := "flex6k_io";
	output_enable : string := "false");

    port (datain : in std_logic := '1';
          oe     : in std_logic := '1';
          padio  : inout std_logic;
          combout : out std_logic);
end component;

end flex6000_components;

