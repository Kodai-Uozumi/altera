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
--
-- FILENAME     :    apex20k_components.vhd
-- FILE CONTENTS:    APEX20K VITAL Component Package (3.0)
-- DATE CREATED :    Tue Nov 17 17:43:50 PST 1998
--
-- LIBRARY      :    work
-- REVISION     :    QII 1.0
-- LOGIC SYSTEM :    IEEE-1164
-- NOTES        :
-- HISTORY      :
--
----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package APEX20K_COMPONENTS is

component apex20k_lcell
  generic (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      packed_mode   : string := "false";
      lut_mask       : string := "ffff";
      power_up : string := "low";
		lpm_type : string := "apex20k_lcell";
	  cin_used       : string := "false");

  port (clk     : in std_logic := '0';
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        cin   : in std_logic := '0';
        cascin     : in std_logic := '1';
        modesel : in std_logic_vector(7 downto 0) := "00000000";
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end component;

component apex20k_io 
   generic (operation_mode : string := "input";
      reg_source_mode :  string := "none";
      feedback_mode : string := "from_pin";
		lpm_type : string := "apex20k_io";
      power_up : string := "low");

    port (clk    : in std_logic := '0';
          datain : in std_logic := '1';
          aclr   : in std_logic := '0';
          ena    : in std_logic := '1';
          oe     : in std_logic := '1';
          modesel : in std_logic_vector(11 downto 0) := "000000000000";
          padio  : inout std_logic;
          combout : out std_logic;
          regout  : out std_logic);

end component;

component apex20k_pterm 
  generic (operation_mode     : string := "normal";
      output_mode        : string := "comb";
      invert_pterm1_mode : string := "false";
      power_up : string := "low";
      TimingChecksOn: Boolean := True;
		lpm_type : string := "apex20k_pterm";
      InstancePath: STRING := "*" );


  port (pterm0  : in std_logic_vector(31 downto 0) := (OTHERS => '1');
        pterm1  : in std_logic_vector(31 downto 0) := (OTHERS => '1');
        pexpin  : in std_logic := '0';
        clk     : in std_logic := '0';
        ena     : in std_logic := '1';
        aclr    : in std_logic := '0';
        modesel : in std_logic_vector(9 downto 0) := "0000000000";
        dataout : out std_logic;
        pexpout : out std_logic );
end component;

component  apex20k_ram_slice
    generic (operation_mode     : string := "single_port";
     deep_ram_mode       : string := "off";
     logical_ram_name    : string := "ram_xxx";
     logical_ram_depth   : integer := 2048;
     logical_ram_width   : integer:= 1;
     address_width       : integer:= 16;
     data_in_clock       : string := "none";
     data_in_clear       : string := "none";
     write_logic_clock   : string := "none";
     write_logic_clear   : string := "none";
     read_enable_clock   : string := "none";
     read_enable_clear   : string := "none";
     read_address_clock  : string := "none";
     read_address_clear  : string := "none";
     data_out_clock      : string := "none";
     data_out_clear      : string := "none";
     init_file           : string := "xxx";
     first_address       : integer:= 0;
     last_address        : integer:= 2047;
     bit_number          : integer:= 0;
     power_up      : string := "low";
		lpm_type : string := "apex20k_ram_slice";
     mem1                : std_logic_vector(512 downto 1) := (OTHERS => '0');
     mem2                : std_logic_vector(512 downto 1) := (OTHERS => '0');
     mem3                : std_logic_vector(512 downto 1) := (OTHERS => '0');
     mem4                : std_logic_vector(512 downto 1) := (OTHERS => '0'));
    port (datain         : in std_logic := '0';
         clk0            : in std_logic := '0';
         clk1            : in std_logic := '0';
         clr0            : in std_logic := '0';
         clr1            : in std_logic := '0'; 
         ena0            : in std_logic := '1';
         ena1            : in std_logic := '1';
         we              : in std_logic := '0';
         re              : in std_logic := '1';
         raddr           : in std_logic_vector(15 downto 0) := (OTHERS => '0');
         waddr           : in std_logic_vector(15 downto 0) := (OTHERS => '0');
         modesel         : in std_logic_vector(17 downto 0) := (OTHERS => '0');
         dataout         : out std_logic);
end component;

component apex20k_pll
    generic (
		input_frequency		: integer := 1000;
		clk0_multiply_by	: integer := 1;
		lpm_type : string := "apex20k_pll";
		clk1_multiply_by	: integer := 1 );

    port (
		clk : in std_logic;
		clk0 : out std_logic;
		clk1 : out std_logic;
		locked : out std_logic);
end component;

end apex20k_components;
