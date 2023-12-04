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

entity apexii_lcell is
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
        modesel   : in std_logic_vector(8 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end apexii_lcell;
        
architecture vital_le_atom of apexii_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

component apexii_asynch_lcell 
  port (
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        cin       : in std_logic;
        cascin    : in std_logic;
        qfbkin    : in std_logic;
        modesel   : in std_logic_vector(8 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        combout   : out std_logic;
        cout      : out std_logic;
        cascout   : out std_logic;
        regin     : out std_logic);
end component;

component apexii_lcell_register
  port (clk     : in std_logic;
        datain     : in std_logic;
        datac     : in std_logic;
        aclr    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        ena : in std_logic;
        modesel   : in std_logic_vector(8 downto 0);
        regout    : out std_logic;
        qfbko     : out std_logic);
end component;

begin

lecomb: apexii_asynch_lcell
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cascin => cascin, qfbkin => qfbk, modesel => modesel, pathsel => pathsel,
                  combout => combout, cout => cout, cascout => cascout, regin => dffin);

lereg: apexii_lcell_register
  	port map (clk => clk, datain => dffin, datac => datac, modesel => modesel,
                  aclr => aclr, sclr => sclr, sload => sload, ena => ena,
                  regout => regout,
                  qfbko => qfbk);


end vital_le_atom;


--
-- APEXII_IO
--
library IEEE;
use IEEE.std_logic_1164.all;

entity  apexii_io is
    port (
			datain                       : in std_logic := '0';
			ddiodatain                       : in std_logic := '0';
			oe                       : in std_logic := '0';
			outclk                       : in std_logic := '0';
			outclkena                       : in std_logic := '1';
			inclk                       : in std_logic := '0';
			inclkena                       : in std_logic := '1';
			areset                       : in std_logic := '0';
			modesel                       : in std_logic_vector(36 DOWNTO 0);
			combout                       : out std_logic;
			regout                       : out std_logic;
			ddioregout					 : out std_logic;
			padio                       : inout std_logic );
end apexii_io;

architecture structure of apexii_io is
component apexii_asynch_io 
	port(
         datain : in  STD_LOGIC;
         oe     : in  STD_LOGIC;
         regin  : in std_logic;
         ddioregin  : in std_logic;
         modesel : in std_logic_vector(36 downto 0);
         padio  : inout STD_LOGIC;
         combout: out STD_LOGIC;
         regout : out STD_LOGIC;
         ddioregout : out STD_LOGIC);
end component;
  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;
  component AND1
  port(
       IN1 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;
  component OR2
   port( IN1 : in STD_LOGIC;
      IN2 : in STD_LOGIC;
      Y   : out STD_LOGIC);
end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
   component TRIBUF
    port(
     IN1   : in STD_LOGIC;
     Y    : out STD_LOGIC;
     OE     : in STD_LOGIC);
end component;

  component dffe
   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end component;

component mux21
	port (
		A : in std_logic := '0';
        B : in std_logic := '0';
        S : in std_logic := '0';
        MO : out std_logic);
end component;
	signal	tmp_oe_reg_out, tmp_input_reg_out, tmp_output_reg_out: std_logic; 
	
	signal 	tmp_padio, tmp_combout : std_logic;
	
	signal	tri_in,  tri_in_new : std_logic;  -- temp result before outputing to padio
	
	signal	oe_out, od_output : std_logic;  -- open_drain_output mode
	
   signal  in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out: std_logic;

   signal  oe_reg_out, oe_pulse_reg_out : std_logic;

   signal  out_reg_out, out_ddio_reg_out: std_logic;

	signal	in_reg_clr, in_reg_preset, in_reg_sel : std_logic;
	
	signal	oe_reg_clr, oe_reg_preset, oe_reg_sel : std_logic;
	
	signal	out_reg_clr, out_reg_preset, out_reg_sel : std_logic;
	
	signal	input_or_bidir, output_or_bidir, ddio_output_or_bidir : std_logic;
	
	signal	input_reg_pu_low, output_reg_pu_low, oe_reg_pu_low : std_logic;
	signal	input_reg_pu_low_inv, output_reg_pu_low_inv, oe_reg_pu_low_inv : std_logic;
	
	signal	pmuxout, poutmux3 : std_logic;
	signal	in_reg_clr_and_pu_low, out_reg_clr_and_pu_low, in_reg_preset_and_pu_low_inv : std_logic;
	signal	out_reg_preset_and_pu_low_inv, oe_reg_clr_and_pu_low, oe_reg_preset_and_pu_low_inv : std_logic;

   -- spr 81268
   signal outclk_delayed : std_logic;
   signal  out_clk_ena, oe_clk_ena, ddio_data : std_logic;

	signal	oe_w_wo_pulse_and_reg_out, tmp_datain, inclk_inv, outclk_inv, pmux2out : std_logic;
	signal	iareset : std_logic ;
	signal one,zero : std_logic;
begin    
one <= '1';
zero <= '0'; 

od_ora : OR2
  port map ( Y => output_or_bidir, IN1 => modesel(1), IN2 => modesel(2));
-- output_or_bidir <= '1' WHEN operation_mode = "output" OR operation_mode = "bidir" ELSE '0';

dod_ora : OR2
  port map ( Y => ddio_output_or_bidir, IN1 => modesel(4), IN2 => modesel(5));
-- ddio output_or_bidir <= '1' WHEN ddio_mode = "output" OR operation_mode = "bidir" ELSE '0';

irpl_not : INV
    port map ( Y => input_reg_pu_low, IN1 => modesel(30));
--input_reg_pu_low <=  '0' WHEN input_power_up = "low" ELSE '1';
irpl_not_i : INV
    port map ( Y => input_reg_pu_low_inv, IN1 => input_reg_pu_low);
and2_2_31 : AND2
    port map ( Y => in_reg_clr_and_pu_low, IN1 => in_reg_clr, IN2 => input_reg_pu_low);
and2_2_32 : AND2
    port map ( Y => out_reg_clr_and_pu_low, IN1 => out_reg_clr, IN2 => output_reg_pu_low);

orpl_not : INV
    port map ( Y => output_reg_pu_low, IN1 => modesel(16));
--output_reg_pu_low <= '0' WHEN output_power_up = "low" ELSE '1';
orpl_not_i : INV
    port map ( Y => output_reg_pu_low_inv, IN1 => output_reg_pu_low);
and2_2_33 : AND2
    port map ( Y => in_reg_preset_and_pu_low_inv, IN1 => in_reg_preset, IN2 => input_reg_pu_low_inv);
and2_2_34 : AND2
    port map ( Y => out_reg_preset_and_pu_low_inv, IN1 => out_reg_preset, IN2 => output_reg_pu_low_inv);

oerpl_not : INV
    port map ( Y => oe_reg_pu_low, IN1 => modesel(23));
--oe_reg_pu_low <= '0' WHEN oe_power_up = "low" ELSE '1';
oerpl_not1 : INV
    port map ( Y => oe_reg_pu_low_inv, IN1 => oe_reg_pu_low_inv);
and2_2_35 : AND2
    port map ( Y => oe_reg_clr_and_pu_low, IN1 => oe_reg_clr, IN2 => oe_reg_pu_low);
and2_2_36 : AND2
    port map ( Y => oe_reg_preset_and_pu_low_inv, IN1 => oe_reg_preset, IN2 => oe_reg_pu_low_inv);

out_reg_sel  <= modesel(10);
--out_reg_sel <= '1' WHEN output_register_mode = "register" ELSE '0';
oe_reg_sel  <= modesel(17);
--oe_reg_sel <= '1' WHEN oe_register_mode = "register" 0ELSE '0';
in_reg_sel   <= modesel(24);
--in_reg_sel <= '1' WHEN input_register_mode = "register" ELSE '0';

iareset_inv : INV
    port map ( Y => iareset, IN1 => areset);
--iareset <= (NOT areset) WHEN ( areset = '1' OR areset = '0') ELSE '1';
-- oe_w_wo_pulse_and_reg_out, 

-- output registered
outregc:  mux21
    port map (MO => out_reg_clr, B => iareset, A => one, S => modesel(12));
--out_reg_clr <= iareset WHEN output_reset = "clear" ELSE '1';
outregp:  mux21
   port map (MO => out_reg_preset, B => iareset, A => one, S => modesel(13));
--out_reg_preset <= iareset WHEN output_reset = "preset" ELSE '1';

oeregc_1:  mux21
    port map (MO => out_clk_ena, B => outclkena, A => one, S => modesel(31));
--out_clk_ena <= '1' WHEN tie_off_output_clock_enable = "true" ELSE outclkena;

-- oe register
oeregc:  mux21
    port map (MO => oe_reg_clr, B => iareset, A => one, S => modesel(19));
--oe_reg_clr <= iareset WHEN oe_reset = "clear" ELSE '1';
oeregp:  mux21
    port map (MO => oe_reg_preset, B => iareset, A => one, S => modesel(20));
--oe_reg_preset <= iareset WHEN oe_reset = "preset" ELSE '1';

oeregc_2:  mux21
    port map (MO => oe_clk_ena, B => outclkena, A => one, S => modesel(33));
--oe_clk_ena <= '1' WHEN tie_off_oe_clock_enable = "true" ELSE outclkena;

-- input register
inregc:  mux21
    port map (MO => in_reg_clr, B => iareset, A => one, S => modesel(26));
--in_reg_clr <= iareset WHEN input_reset = "clear" ELSE '1';
inregp:  mux21
    port map (MO => in_reg_preset, B => iareset, A => one, S => modesel(27));
--in_reg_preset <= iareset WHEN input_reset = "preset" ELSE '1';

in_reg : dffe
	port map (D => padio, CLRN => in_reg_clr, PRN => in_reg_preset, CLK => inclk, ENA => inclkena, Q => in_reg_out);

inv_11: INV
			port map (Y => inclk_inv, IN1 => inclk);

inv_111: INV
			port map (Y => outclk_inv, IN1 => outclk);

in_ddio0_reg : dffe
	port map (D => padio, CLRN => in_reg_clr, PRN => in_reg_preset, CLK => inclk_inv, ENA => inclkena, Q => in_ddio0_reg_out);

in_ddio1_reg : dffe
	port map (D => in_ddio0_reg_out, CLRN => in_reg_clr, PRN => in_reg_preset, CLK => inclk, ENA => inclkena, Q => in_ddio1_reg_out);

out_reg : dffe
	port map (D => datain, CLRN => out_reg_clr, PRN => out_reg_preset, CLK => outclk, ENA => out_clk_ena, Q => out_reg_out);

out_ddio_reg : dffe
	port map (D => ddiodatain, CLRN => out_reg_clr, PRN => out_reg_preset, CLK => outclk, ENA => out_clk_ena, Q => out_ddio_reg_out);

oe_reg : dffe
	port map (D => oe, CLRN => oe_reg_clr, PRN => oe_reg_preset, CLK => outclk, ENA => oe_clk_ena, Q => oe_reg_out);

oe_pulse_reg : dffe
	port map (D => oe_reg_out, CLRN => oe_reg_clr, PRN => oe_reg_preset, CLK => outclk_inv, ENA => oe_clk_ena, Q => oe_pulse_reg_out);


oe_mux : mux21	
		port map (MO => oe_out, A => oe, B => pmux2out, S => modesel(17));
oe_mux2 : mux21 
		port map (MO => pmux2out, A => oe_reg_out, B => oe_w_wo_pulse_and_reg_out, S => modesel(36));
and2_oe_p_r_out : and2
		port map (Y => oe_w_wo_pulse_and_reg_out, IN1 => oe_pulse_reg_out, IN2 => oe_reg_out);
--oe_out <= (oe_pulse_reg_out and oe_reg_out) WHEN (extend_oe_disable = "true")
--  ELSE oe_reg_out WHEN (oe_register_mode = "register") ELSE oe;

sel_delaybuf: AND1
        port map (IN1 => outclk, Y => outclk_delayed);

ddio_data_mux : mux21
           port map (MO => ddio_data,
                     A => out_ddio_reg_out,
                     B => out_reg_out,
                     S => outclk_delayed);


out_mux1 : mux21 
	port map (MO => tmp_datain, B => ddio_data, A => poutmux3, S => ddio_output_or_bidir);
out_mux3	: mux21
	port map  (MO => poutmux3, B => out_reg_out, A => datain, S => out_reg_sel);
--tmp_datain <= ddio_data WHEN (ddio_mode = "output" or ddio_mode = "bidir") ELSE
--              out_reg_out WHEN (out_reg_sel = '1') ELSE
--              datain;


-- timing info in case output and/or input are not registered.
apexii_pin : apexii_asynch_io
	port map( datain => tmp_datain,
             oe => oe_out,
             regin => in_reg_out,
             ddioregin => in_ddio1_reg_out,
             modesel=>modesel,
             padio => padio,
             combout => combout,
             regout => regout,
             ddioregout => ddioregout);


end structure;



--
-- APEXII_RAM_BLOCK
--
library ieee;
use ieee.std_logic_1164.all;


entity  apexii_ram_block is
    port (
		portadatain		: in std_logic_vector(15 downto 0);
		portaclk0		: in std_logic;
		portaclk1		: in std_logic;
		portaclr0		: in std_logic;
		portaclr1		: in std_logic;
		portaena0		: in std_logic;
		portaena1		: in std_logic;
		portawe			: in std_logic;
		portare			: in std_logic;
		portaraddr		: in std_logic_vector(16 downto 0);
		portawaddr		: in std_logic_vector(16 downto 0);
		portbdatain		: in std_logic_vector(15 downto 0);
		portbclk0		: in std_logic;
		portbclk1		: in std_logic;
		portbclr0		: in std_logic;
		portbclr1		: in std_logic;
		portbena0		: in std_logic;
		portbena1		: in std_logic;
		portbwe			: in std_logic;
		portbre			: in std_logic;
		portbraddr		: in std_logic_vector(16 downto 0);
		portbwaddr		: in std_logic_vector(16 downto 0);
		portadataout		: out std_logic_vector(15 downto 0);
		portbdataout		: out std_logic_vector(15 downto 0);
		portamodesel		: in std_logic_vector(20 downto 0);
		portbmodesel		: in std_logic_vector(20 downto 0));
end apexii_ram_block;

architecture structure of apexii_ram_block is

component dffe
   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end component;
component AND1
           port(
              Y                   :  out   STD_LOGIC;
              IN1                 :  in    STD_LOGIC);
end component;
component INV
           port(
              Y                   :  out   STD_LOGIC;
              IN1                 :  in    STD_LOGIC);
end component;
component AND2
           port(
              Y                   :  out   STD_LOGIC;
              IN2                   :  in   STD_LOGIC;
              IN1                 :  in    STD_LOGIC);
end component;
component mux21
          port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end component;
component nmux21
          port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end component;
component bmux21
          port (
                A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                S : in std_logic := '0';
                MO : out std_logic_vector(15 downto 0));
end component;
component bmux21_17
          port (
                A : in std_logic_vector(16 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(16 downto 0) := (OTHERS => '0');
                S : in std_logic := '0';
                MO : out std_logic_vector(16 downto 0));
end component;
component apexii_asynch_mem

    port (
	portadatain : in std_logic_vector(15 downto 0) := (OTHERS => '0');
	portawe : in std_logic := '0';
	portare : in std_logic := '0';
	portaraddr : in std_logic_vector(16 downto 0) := (OTHERS => '0');
	portawaddr : in std_logic_vector(16 downto 0) := (OTHERS => '0');
	portbdatain : in std_logic_vector(15 downto 0) := (OTHERS => '0');
	portbwe : in std_logic := '0';
	portbre : in std_logic := '0';
	portbraddr : in std_logic_vector(16 downto 0) := (OTHERS => '0');
	portbwaddr : in std_logic_vector(16 downto 0) := (OTHERS => '0');
	portadataout : out std_logic_vector(15 downto 0);
	portbdataout : out std_logic_vector(15 downto 0);
	portamodesel : in std_logic_vector(20 downto 0) := (OTHERS => '0');
	portbmodesel : in std_logic_vector(20 downto 0) := (OTHERS => '0'));

end component;

-- 'sel' signals for porta

   signal  portadatain_reg_sel, portadatain_reg_clr_sel : std_logic;
   signal  portawrite_reg_sel, portawe_clr_sel : std_logic;
   signal  portawaddr_clr_sel: std_logic;
   signal  portaraddr_clr_sel, portare_clr_sel : std_logic_vector(1 downto 0);
   signal  portaraddr_clk_sel, portare_clk_sel : std_logic_vector(1 downto 0);
   signal  portadataout_clk_sel : std_logic_vector(1 downto 0); 
   signal  portadataout_clr_sel : std_logic_vector(1 downto 0); 
   signal  portaraddr_en_sel, portare_en_sel : std_logic;
   signal  portadataout_en_sel : std_logic; 

-- registered signals for porta
 
   signal  portadatain_reg, portadataout_reg : std_logic_vector(15 downto 0);
   signal  portawe_reg, portare_reg : std_logic;
   signal  portaraddr_reg, portawaddr_reg : std_logic_vector(16 downto 0);

   signal  portadatain_int, portadataout_int : std_logic_vector(15 downto 0);
   signal  portaraddr_int, portawaddr_int : std_logic_vector(16 downto 0);
   signal  portawe_int, portare_int : std_logic;

-- 'clr' signals for porta

   signal  portadatain_reg_clr, portadinreg_clr : std_logic;
   signal  portawe_reg_clr, portawereg_clr : std_logic;
   signal  portawaddr_reg_clr, portawaddrreg_clr : std_logic;
   signal  portare_reg_clr, portarereg_clr : std_logic;
   signal  portaraddr_reg_clr, portaraddrreg_clr : std_logic;
   signal  portadataout_reg_clr, portadataoutreg_clr : std_logic;

-- 'ena' signals for porta

   signal  portareen, portaraddren, portadataouten : std_logic;

-- 'clk' signals for porta

   signal  portare_clk, portare_clr : std_logic;
   signal  portaraddr_clk, portaraddr_clr : std_logic;
   signal  portadataout_clk, portadataout_clr : std_logic;

-- other signals

   signal  portawe_reg_mux, portawe_reg_mux_delayed : std_logic;
   signal  portawe_pulse : std_logic;
   signal  portadataout_tmp : std_logic_vector(15 downto 0);
   signal  portavalid_addr : std_logic;
   signal  portaraddr_num : integer;

-- 'sel' signals for portb

   signal  portbdatain_reg_sel, portbdatain_reg_clr_sel : std_logic;
   signal  portbwrite_reg_sel, portbwe_clr_sel : std_logic;
   signal  portbwaddr_clr_sel: std_logic;
   signal  portbraddr_clr_sel, portbre_clr_sel : std_logic_vector(1 downto 0);
   signal  portbraddr_clk_sel, portbre_clk_sel : std_logic_vector(1 downto 0);
   signal  portbdataout_clk_sel : std_logic_vector(1 downto 0); 
   signal  portbdataout_clr_sel : std_logic_vector(1 downto 0); 
   signal  portbraddr_en_sel, portbre_en_sel : std_logic;
   signal  portbdataout_en_sel : std_logic; 

-- registered signals for portb

   signal  portbdatain_reg, portbdataout_reg : std_logic_vector(15 downto 0);
   signal  portbwe_reg, portbre_reg : std_logic;
   signal  portbraddr_reg, portbwaddr_reg : std_logic_vector(16 downto 0);

   signal  portbdatain_int, portbdataout_int : std_logic_vector(15 downto 0);
   signal  portbraddr_int, portbwaddr_int : std_logic_vector(16 downto 0);
   signal  portbwe_int, portbre_int : std_logic;

-- 'clr' signals for portb

   signal  portbdatain_reg_clr, portbdinreg_clr : std_logic;
   signal  portbwe_reg_clr, portbwereg_clr : std_logic;
   signal  portbwaddr_reg_clr, portbwaddrreg_clr : std_logic;
   signal  portbre_reg_clr, portbrereg_clr : std_logic;
   signal  portbraddr_reg_clr, portbraddrreg_clr : std_logic;
   signal  portbdataout_reg_clr, portbdataoutreg_clr : std_logic;

-- 'ena' signals for portb

   signal  portbreen, portbraddren, portbdataouten : std_logic;

-- 'clk' signals for portb

   signal  portbre_clk, portbre_clr : std_logic;
   signal  portbraddr_clk, portbraddr_clr : std_logic;
   signal  portbdataout_clk, portbdataout_clr : std_logic;

-- other signals

   signal  portbwe_reg_mux, portbwe_reg_mux_delayed : std_logic;
   signal  portbwe_pulse : std_logic;
   signal  portbdataout_tmp : std_logic_vector(15 downto 0);
   signal  portbvalid_addr : std_logic;
   signal  portbraddr_num : integer;

   signal  NC : std_logic;
   signal  vcc : std_logic;
   signal  portaclk0_inv1, portbclk0_inv1 : std_logic;
   signal  portaclk0_delayed, portbclk0_delayed : std_logic;

begin     

vcc <= '1';
portadatain_reg_sel 	 	<= portamodesel(0);
portadatain_reg_clr_sel   	<= portamodesel(1);

portawrite_reg_sel 	 	<= portamodesel(2);
portawe_clr_sel			<= portamodesel(3);
portawaddr_clr_sel		<= portamodesel(4);

portaraddr_clk_sel(0)   	<= portamodesel(5);
portaraddr_clr_sel(0)		<= portamodesel(6);

portare_clk_sel(0) 	 	<= portamodesel(7);
portare_clr_sel(0)	 	<= portamodesel(8);

portadataout_clk_sel(0)  	<= portamodesel(9);
portadataout_clr_sel(0)  	<= portamodesel(10);

portare_clk_sel(1) 	 	<= portamodesel(11);
portare_en_sel 	 		<= portamodesel(11);
portare_clr_sel(1) 	 	<= portamodesel(12);

portaraddr_clk_sel(1) 	 	<= portamodesel(13);
portaraddr_en_sel 	 	<= portamodesel(13);
portaraddr_clr_sel(1) 	 	<= portamodesel(14);

portadataout_clk_sel(1)		<= portamodesel(15);
portadataout_en_sel		<= portamodesel(15);
portadataout_clr_sel(1)		<= portamodesel(16);

portbdatain_reg_sel 	 	<= portbmodesel(0);
portbdatain_reg_clr_sel   	<= portbmodesel(1);

portbwrite_reg_sel 	 	<= portbmodesel(2);
portbwe_clr_sel			<= portbmodesel(3);
portbwaddr_clr_sel		<= portbmodesel(4);

portbraddr_clk_sel(0)   	<= portbmodesel(5);
portbraddr_clr_sel(0)		<= portbmodesel(6);

portbre_clk_sel(0) 	 	<= portbmodesel(7);
portbre_clr_sel(0)	 	<= portbmodesel(8);

portbdataout_clk_sel(0)  	<= portbmodesel(9);
portbdataout_clr_sel(0)  	<= portbmodesel(10);

portbre_clk_sel(1) 	 	<= portbmodesel(11);
portbre_en_sel 	 		<= portbmodesel(11);
portbre_clr_sel(1) 	 	<= portbmodesel(12);

portbraddr_clk_sel(1) 	 	<= portbmodesel(13);
portbraddr_en_sel 	 	<= portbmodesel(13);
portbraddr_clr_sel(1) 	 	<= portbmodesel(14);

portbdataout_clk_sel(1)		<= portbmodesel(15);
portbdataout_en_sel		<= portbmodesel(15);
portbdataout_clr_sel(1)		<= portbmodesel(16);

-- PORT A registers

portadatainregclr: nmux21
           port map (A => NC, B => portaclr0, S => portadatain_reg_clr_sel,
                     MO => portadatain_reg_clr);
portadinreg_clr <= portadatain_reg_clr;
portadinreg_0 : dffe
      port map (D => portadatain(0), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(0));
portadinreg_1 : dffe
      port map (D => portadatain(1), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(1));
portadinreg_2 : dffe
      port map (D => portadatain(2), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(2));
portadinreg_3 : dffe
      port map (D => portadatain(3), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(3));
portadinreg_4 : dffe
      port map (D => portadatain(4), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(4));
portadinreg_5 : dffe
      port map (D => portadatain(5), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(5));
portadinreg_6 : dffe
      port map (D => portadatain(6), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(6));
portadinreg_7 : dffe
      port map (D => portadatain(7), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(7));
portadinreg_8 : dffe
      port map (D => portadatain(8), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(8));
portadinreg_9 : dffe
      port map (D => portadatain(9), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(9));
portadinreg_10 : dffe
      port map (D => portadatain(10), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(10));
portadinreg_11 : dffe
      port map (D => portadatain(11), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(11));
portadinreg_12 : dffe
      port map (D => portadatain(12), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(12));
portadinreg_13 : dffe
      port map (D => portadatain(13), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(13));
portadinreg_14 : dffe
      port map (D => portadatain(14), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(14));
portadinreg_15 : dffe
      port map (D => portadatain(15), CLRN => portadinreg_clr, CLK => portaclk0,
                   PRN => vcc, ENA => portaena0, Q => portadatain_reg(15));
portadatainsel: bmux21 
    port map (A => portadatain, B => portadatain_reg, S => portadatain_reg_sel, 
              MO => portadatain_int);


portaweregclr: nmux21
	port map (A => NC, B => portaclr0, S => portawe_clr_sel,
                     MO => portawe_reg_clr);
portawereg_clr <= portawe_reg_clr;
portawereg: dffe 
        port map (D => portawe, CLRN => portawereg_clr, CLK => portaclk0,
                       PRN => vcc, ENA => portaena0, Q => portawe_reg);
portawesel1: mux21
        port map (A => portawe, B => portawe_reg, S => portawrite_reg_sel,
                     MO => portawe_reg_mux);
portawedelaybuf: AND1
        port map (IN1 => portawe_reg_mux, Y => portawe_reg_mux_delayed);

inv_1: INV
			port map (Y => portaclk0_inv1, IN1 => portaclk0_delayed);

portaclk0weregdelaybuf: AND1
        port map (Y => portaclk0_delayed, IN1 => portaclk0);

and2_1: AND2
			port map (Y => portawe_pulse, IN1 => portaclk0_inv1, IN2 => portawe_reg_mux_delayed);

--portawe_pulse <= portawe_reg_mux_delayed and (not portaclk0);

portawesel2: mux21
        port map (A => portawe_reg_mux_delayed, B => portawe_pulse,
                     S => portawrite_reg_sel, MO => portawe_int);


portawaddrregclr: nmux21
        port map (A => NC, B => portaclr0, S => portawaddr_clr_sel,
                     MO => portawaddr_reg_clr);
portawaddrreg_clr <= portawaddr_reg_clr;
portawaddrreg_0: dffe 
        port map (D => portawaddr(0), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(0));
portawaddrreg_1: dffe 
        port map (D => portawaddr(1), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(1));
portawaddrreg_2: dffe 
        port map (D => portawaddr(2), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(2));
portawaddrreg_3: dffe 
        port map (D => portawaddr(3), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(3));
portawaddrreg_4: dffe 
        port map (D => portawaddr(4), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(4));
portawaddrreg_5: dffe 
        port map (D => portawaddr(5), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(5));
portawaddrreg_6: dffe 
        port map (D => portawaddr(6), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(6));
portawaddrreg_7: dffe 
        port map (D => portawaddr(7), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(7));
portawaddrreg_8: dffe 
        port map (D => portawaddr(8), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(8));
portawaddrreg_9: dffe 
        port map (D => portawaddr(9), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(9));
portawaddrreg_10: dffe 
        port map (D => portawaddr(10), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(10));
portawaddrreg_11: dffe 
        port map (D => portawaddr(11), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(11));
portawaddrreg_12: dffe 
        port map (D => portawaddr(12), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(12));
portawaddrreg_13: dffe 
        port map (D => portawaddr(13), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(13));
portawaddrreg_14: dffe 
        port map (D => portawaddr(14), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(14));
portawaddrreg_15: dffe 
        port map (D => portawaddr(15), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(15));
portawaddrreg_16: dffe 
        port map (D => portawaddr(16), CLRN => portawaddrreg_clr,
                  CLK => portaclk0, PRN => vcc, ENA => portaena0,
                  Q => portawaddr_reg(16));
portawaddrsel: bmux21_17 
        port map (A => portawaddr, B => portawaddr_reg, S => portawrite_reg_sel,
                     MO => portawaddr_int);


portaraddrclksel: mux21
        port map (A => portaclk0, B => portaclk1, S => portaraddr_clk_sel(1),
                     MO => portaraddr_clk); 
portaraddrensel: mux21
        port map (A => portaena0, B => portaena1, S => portaraddr_en_sel,
                     MO => portaraddren); 
portaraddrclrsel: mux21
        port map (A => portaclr0, B => portaclr1, S => portaraddr_clr_sel(1),
                     MO => portaraddr_clr); 
portaraddrregclr: nmux21
        port map (A => NC, B => portaraddr_clr, S => portaraddr_clr_sel(0),
                     MO => portaraddr_reg_clr);
portaraddrreg_clr <= portaraddr_reg_clr;
portaraddrreg_0: dffe 
        port map (D => portaraddr(0), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(0));
portaraddrreg_1: dffe 
        port map (D => portaraddr(1), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(1));
portaraddrreg_2: dffe 
        port map (D => portaraddr(2), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(2));
portaraddrreg_3: dffe 
        port map (D => portaraddr(3), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(3));
portaraddrreg_4: dffe 
        port map (D => portaraddr(4), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(4));
portaraddrreg_5: dffe 
        port map (D => portaraddr(5), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(5));
portaraddrreg_6: dffe 
        port map (D => portaraddr(6), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(6));
portaraddrreg_7: dffe 
        port map (D => portaraddr(7), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(7));
portaraddrreg_8: dffe 
        port map (D => portaraddr(8), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(8));
portaraddrreg_9: dffe 
        port map (D => portaraddr(9), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(9));
portaraddrreg_10: dffe 
        port map (D => portaraddr(10), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(10));
portaraddrreg_11: dffe 
        port map (D => portaraddr(11), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(11));
portaraddrreg_12: dffe 
        port map (D => portaraddr(12), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(12));
portaraddrreg_13: dffe 
        port map (D => portaraddr(13), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(13));
portaraddrreg_14: dffe 
        port map (D => portaraddr(14), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(14));
portaraddrreg_15: dffe 
        port map (D => portaraddr(15), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(15));
portaraddrreg_16: dffe 
        port map (D => portaraddr(16), CLRN => portaraddrreg_clr,
                  CLK => portaraddr_clk, PRN => vcc, ENA => portaraddren,
                  Q => portaraddr_reg(16));
portaraddrsel: bmux21_17
	port map (A => portaraddr, B => portaraddr_reg,
                  S => portaraddr_clk_sel(0), MO => portaraddr_int);
portareclksel: mux21
           port map (A => portaclk0, B => portaclk1, S => portare_clk_sel(1),
                     MO => portare_clk); 
portareensel: mux21
           port map (A => portaena0, B => portaena1, S => portare_en_sel,
                     MO => portareen); 
portareclrsel: mux21
           port map (A => portaclr0, B => portaclr1, S => portare_clr_sel(1),
                     MO => portare_clr); 
portareregclr: nmux21
	   port map (A => NC, B => portare_clr, S => portare_clr_sel(0),
                     MO => portare_reg_clr);
portarereg_clr <= portare_reg_clr;
portarereg: dffe 
         port map (D => portare, CLRN => portarereg_clr, CLK => portare_clk,
                       PRN => vcc, ENA => portareen, Q => portare_reg);
portaresel: mux21
           port map (A => portare, B => portare_reg, S => portare_clk_sel(0),
                     MO => portare_int); 


portadataoutclksel: mux21
      port map (A => portaclk0, B => portaclk1, S => portadataout_clk_sel(1),
                     MO => portadataout_clk); 
portadataoutensel: mux21
      port map (A => portaena0, B => portaena1, S => portadataout_en_sel,
                     MO => portadataouten); 
portadataoutclrsel: mux21
      port map (A => portaclr0, B => portaclr1, S => portadataout_clr_sel(1),
                     MO => portadataout_clr); 
portadataoutregclr: nmux21
      port map (A => NC, B => portadataout_clr, S => portadataout_clr_sel(0),
                     MO => portadataout_reg_clr);
portadataoutreg_clr <= portadataout_reg_clr;
portadataoutreg_0 : dffe 
        port map (D => portadataout_int(0), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(0));
portadataoutreg_1 : dffe 
        port map (D => portadataout_int(1), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(1));
portadataoutreg_2 : dffe 
        port map (D => portadataout_int(2), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(2));
portadataoutreg_3 : dffe 
        port map (D => portadataout_int(3), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(3));
portadataoutreg_4 : dffe 
        port map (D => portadataout_int(4), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(4));
portadataoutreg_5 : dffe 
        port map (D => portadataout_int(5), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(5));
portadataoutreg_6 : dffe 
        port map (D => portadataout_int(6), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(6));
portadataoutreg_7 : dffe 
        port map (D => portadataout_int(7), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(7));
portadataoutreg_8 : dffe 
        port map (D => portadataout_int(8), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(8));
portadataoutreg_9 : dffe 
        port map (D => portadataout_int(9), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(9));
portadataoutreg_10 : dffe 
        port map (D => portadataout_int(10), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(10));
portadataoutreg_11 : dffe 
        port map (D => portadataout_int(11), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(11));
portadataoutreg_12 : dffe 
        port map (D => portadataout_int(12), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(12));
portadataoutreg_13 : dffe 
        port map (D => portadataout_int(13), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(13));
portadataoutreg_14 : dffe 
        port map (D => portadataout_int(14), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(14));
portadataoutreg_15 : dffe 
        port map (D => portadataout_int(15), CLRN => portadataoutreg_clr, 
                  CLK => portadataout_clk, PRN => vcc, ENA => portadataouten,
                  Q => portadataout_reg(15));
portadataoutsel: bmux21
      port map (A => portadataout_int, B => portadataout_reg,
                S => portadataout_clk_sel(0), MO => portadataout_tmp); 

-- PORT B registers

portbdatainregclr: nmux21
           port map (A => NC, B => portbclr0, S => portbdatain_reg_clr_sel,
                     MO => portbdatain_reg_clr);
portbdinreg_clr <= portbdatain_reg_clr;
portbdinreg_0 : dffe
      port map (D => portbdatain(0), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(0));
portbdinreg_1 : dffe
      port map (D => portbdatain(1), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(1));
portbdinreg_2 : dffe
      port map (D => portbdatain(2), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(2));
portbdinreg_3 : dffe
      port map (D => portbdatain(3), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(3));
portbdinreg_4 : dffe
      port map (D => portbdatain(4), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(4));
portbdinreg_5 : dffe
      port map (D => portbdatain(5), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(5));
portbdinreg_6 : dffe
      port map (D => portbdatain(6), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(6));
portbdinreg_7 : dffe
      port map (D => portbdatain(7), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(7));
portbdinreg_8 : dffe
      port map (D => portbdatain(8), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(8));
portbdinreg_9 : dffe
      port map (D => portbdatain(9), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(9));
portbdinreg_10 : dffe
      port map (D => portbdatain(10), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(10));
portbdinreg_11 : dffe
      port map (D => portbdatain(11), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(11));
portbdinreg_12 : dffe
      port map (D => portbdatain(12), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(12));
portbdinreg_13 : dffe
      port map (D => portbdatain(13), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(13));
portbdinreg_14 : dffe
      port map (D => portbdatain(14), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(14));
portbdinreg_15 : dffe
      port map (D => portbdatain(15), CLRN => portbdinreg_clr, CLK => portbclk0,
                   PRN => vcc, ENA => portbena0, Q => portbdatain_reg(15));
portbdatainsel: bmux21 
    port map (A => portbdatain, B => portbdatain_reg, S => portbdatain_reg_sel, 
              MO => portbdatain_int);


portbweregclr: nmux21
	port map (A => NC, B => portbclr0, S => portbwe_clr_sel,
                     MO => portbwe_reg_clr);
portbwereg_clr <= portbwe_reg_clr;
portbwereg: dffe 
        port map (D => portbwe, CLRN => portbwereg_clr, CLK => portbclk0,
                       PRN => vcc, ENA => portbena0, Q => portbwe_reg);
portbwesel1: mux21
        port map (A => portbwe, B => portbwe_reg, S => portbwrite_reg_sel,
                     MO => portbwe_reg_mux);
portbwedelaybuf: AND1
        port map (IN1 => portbwe_reg_mux, Y => portbwe_reg_mux_delayed);

inv_2_1: INV
			port map (Y => portbclk0_inv1, IN1 => portbclk0_delayed);

portbclk0weregdelaybuf: AND1
        port map (Y => portbclk0_delayed, IN1 => portbclk0);

and2_2_1: AND2
			port map (Y => portbwe_pulse, IN1 => portbclk0_inv1, IN2 => portbwe_reg_mux_delayed);

--portbwe_pulse <= portbwe_reg_mux_delayed and (not portbclk0);

portbwesel2: mux21
        port map (A => portbwe_reg_mux_delayed, B => portbwe_pulse,
                     S => portbwrite_reg_sel, MO => portbwe_int);


portbwaddrregclr: nmux21
        port map (A => NC, B => portbclr0, S => portbwaddr_clr_sel,
                     MO => portbwaddr_reg_clr);
portbwaddrreg_clr <= portbwaddr_reg_clr;
portbwaddrreg_0: dffe 
        port map (D => portbwaddr(0), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(0));
portbwaddrreg_1: dffe 
        port map (D => portbwaddr(1), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(1));
portbwaddrreg_2: dffe 
        port map (D => portbwaddr(2), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(2));
portbwaddrreg_3: dffe 
        port map (D => portbwaddr(3), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(3));
portbwaddrreg_4: dffe 
        port map (D => portbwaddr(4), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(4));
portbwaddrreg_5: dffe 
        port map (D => portbwaddr(5), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(5));
portbwaddrreg_6: dffe 
        port map (D => portbwaddr(6), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(6));
portbwaddrreg_7: dffe 
        port map (D => portbwaddr(7), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(7));
portbwaddrreg_8: dffe 
        port map (D => portbwaddr(8), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(8));
portbwaddrreg_9: dffe 
        port map (D => portbwaddr(9), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(9));
portbwaddrreg_10: dffe 
        port map (D => portbwaddr(10), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(10));
portbwaddrreg_11: dffe 
        port map (D => portbwaddr(11), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(11));
portbwaddrreg_12: dffe 
        port map (D => portbwaddr(12), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(12));
portbwaddrreg_13: dffe 
        port map (D => portbwaddr(13), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(13));
portbwaddrreg_14: dffe 
        port map (D => portbwaddr(14), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(14));
portbwaddrreg_15: dffe 
        port map (D => portbwaddr(15), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(15));
portbwaddrreg_16: dffe 
        port map (D => portbwaddr(16), CLRN => portbwaddrreg_clr,
                  CLK => portbclk0, PRN => vcc, ENA => portbena0,
                  Q => portbwaddr_reg(16));
portbwaddrsel: bmux21_17 
        port map (A => portbwaddr, B => portbwaddr_reg, S => portbwrite_reg_sel,
                     MO => portbwaddr_int);


portbraddrclksel: mux21
        port map (A => portbclk0, B => portbclk1, S => portbraddr_clk_sel(1),
                     MO => portbraddr_clk); 
portbraddrensel: mux21
        port map (A => portbena0, B => portbena1, S => portbraddr_en_sel,
                     MO => portbraddren); 
portbraddrclrsel: mux21
        port map (A => portbclr0, B => portbclr1, S => portbraddr_clr_sel(1),
                     MO => portbraddr_clr); 
portbraddrregclr: nmux21
        port map (A => NC, B => portbraddr_clr, S => portbraddr_clr_sel(0),
                     MO => portbraddr_reg_clr);
portbraddrreg_clr <= portbraddr_reg_clr;
portbraddrreg_0: dffe 
        port map (D => portbraddr(0), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(0));
portbraddrreg_1: dffe 
        port map (D => portbraddr(1), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(1));
portbraddrreg_2: dffe 
        port map (D => portbraddr(2), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(2));
portbraddrreg_3: dffe 
        port map (D => portbraddr(3), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(3));
portbraddrreg_4: dffe 
        port map (D => portbraddr(4), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(4));
portbraddrreg_5: dffe 
        port map (D => portbraddr(5), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(5));
portbraddrreg_6: dffe 
        port map (D => portbraddr(6), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(6));
portbraddrreg_7: dffe 
        port map (D => portbraddr(7), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(7));
portbraddrreg_8: dffe 
        port map (D => portbraddr(8), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(8));
portbraddrreg_9: dffe 
        port map (D => portbraddr(9), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(9));
portbraddrreg_10: dffe 
        port map (D => portbraddr(10), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(10));
portbraddrreg_11: dffe 
        port map (D => portbraddr(11), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(11));
portbraddrreg_12: dffe 
        port map (D => portbraddr(12), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(12));
portbraddrreg_13: dffe 
        port map (D => portbraddr(13), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(13));
portbraddrreg_14: dffe 
        port map (D => portbraddr(14), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(14));
portbraddrreg_15: dffe 
        port map (D => portbraddr(15), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(15));
portbraddrreg_16: dffe 
        port map (D => portbraddr(16), CLRN => portbraddrreg_clr,
                  CLK => portbraddr_clk, PRN => vcc, ENA => portbraddren,
                  Q => portbraddr_reg(16));

portbraddrsel: bmux21_17
	port map (A => portbraddr, B => portbraddr_reg,
                  S => portbraddr_clk_sel(0), MO => portbraddr_int);

portbreclksel: mux21
           port map (A => portbclk0, B => portbclk1, S => portbre_clk_sel(1),
                     MO => portbre_clk); 
portbreensel: mux21
           port map (A => portbena0, B => portbena1, S => portbre_en_sel,
                     MO => portbreen); 
portbreclrsel: mux21
           port map (A => portbclr0, B => portbclr1, S => portbre_clr_sel(1),
                     MO => portbre_clr); 
portbreregclr: nmux21
	   port map (A => NC, B => portbre_clr, S => portbre_clr_sel(0),
                     MO => portbre_reg_clr);
portbrereg_clr <= portbre_reg_clr;
portbrereg: dffe 
         port map (D => portbre, CLRN => portbrereg_clr, CLK => portbre_clk,
                       PRN => vcc, ENA => portbreen, Q => portbre_reg);
portbresel: mux21
           port map (A => portbre, B => portbre_reg, S => portbre_clk_sel(0),
                     MO => portbre_int); 


portbdataoutclksel: mux21
      port map (A => portbclk0, B => portbclk1, S => portbdataout_clk_sel(1),
                     MO => portbdataout_clk); 
portbdataoutensel: mux21
      port map (A => portbena0, B => portbena1, S => portbdataout_en_sel,
                     MO => portbdataouten); 
portbdataoutclrsel: mux21
      port map (A => portbclr0, B => portbclr1, S => portbdataout_clr_sel(1),
                     MO => portbdataout_clr); 
portbdataoutregclr: nmux21
      port map (A => NC, B => portbdataout_clr, S => portbdataout_clr_sel(0),
                     MO => portbdataout_reg_clr);
portbdataoutreg_clr <= portbdataout_reg_clr;
portbdataoutreg_0 : dffe 
        port map (D => portbdataout_int(0), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(0));
portbdataoutreg_1 : dffe 
        port map (D => portbdataout_int(1), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(1));
portbdataoutreg_2 : dffe 
        port map (D => portbdataout_int(2), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(2));
portbdataoutreg_3 : dffe 
        port map (D => portbdataout_int(3), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(3));
portbdataoutreg_4 : dffe 
        port map (D => portbdataout_int(4), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(4));
portbdataoutreg_5 : dffe 
        port map (D => portbdataout_int(5), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(5));
portbdataoutreg_6 : dffe 
        port map (D => portbdataout_int(6), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(6));
portbdataoutreg_7 : dffe 
        port map (D => portbdataout_int(7), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(7));
portbdataoutreg_8 : dffe 
        port map (D => portbdataout_int(8), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(8));
portbdataoutreg_9 : dffe 
        port map (D => portbdataout_int(9), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(9));
portbdataoutreg_10 : dffe 
        port map (D => portbdataout_int(10), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(10));
portbdataoutreg_11 : dffe 
        port map (D => portbdataout_int(11), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(11));
portbdataoutreg_12 : dffe 
        port map (D => portbdataout_int(12), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(12));
portbdataoutreg_13 : dffe 
        port map (D => portbdataout_int(13), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(13));
portbdataoutreg_14 : dffe 
        port map (D => portbdataout_int(14), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(14));
portbdataoutreg_15 : dffe 
        port map (D => portbdataout_int(15), CLRN => portbdataoutreg_clr, 
                  CLK => portbdataout_clk, PRN => vcc, ENA => portbdataouten,
                  Q => portbdataout_reg(15));
portbdataoutsel: bmux21
      port map (A => portbdataout_int, B => portbdataout_reg,
                S => portbdataout_clk_sel(0), MO => portbdataout_tmp); 


apexiimem: apexii_asynch_mem
	  port map (
		portadatain => portadatain_int,
		portawe => portawe_int,
		portare => portare_int,
		portaraddr => portaraddr_int,
		portawaddr => portawaddr_int,
		portbdatain => portbdatain_int,
		portbwe => portbwe_int,
		portbre => portbre_int,
		portbraddr => portbraddr_int,
		portbwaddr => portbwaddr_int,
		portadataout => portadataout_int,
		portbdataout => portbdataout_int,
		portamodesel => portamodesel,
		portbmodesel => portbmodesel
              );

--portaraddr_num <= conv_integer(portaraddr_int);

--portavalid_addr <= '1' when portaraddr_num <= last_address and portaraddr_num >= first_address else '0';

--portadataout <= portadataout_tmp when deep_ram_mode = "off" or (deep_ram_mode = "on" and valid_addr = '1') else 'Z';

portadataout <= portadataout_tmp;
portbdataout <= portbdataout_tmp;

end structure;

library IEEE;
use IEEE.std_logic_1164.all;

entity  apexii_cam_slice is
    port (clk0, clk1, clr0, clr1, ena0, ena1, 
          we, datain, wrinvert, outputselect : in std_logic;
          waddr : in std_logic_vector(4 downto 0);
	  lit : in std_logic_vector(31 downto 0);
          modesel : in std_logic_vector(9 downto 0) := (OTHERS => '0');
          matchout : out std_logic_vector(15 downto 0);
	  matchfound : out std_logic);

end apexii_cam_slice;

architecture structure of apexii_cam_slice is
   signal waddr_clr_sel, write_logic_clr_sel, we_clr_sel : std_logic;
   signal output_clr_sel, output_reg_clr_sel : std_logic;
   signal write_logic_sel, output_reg_sel, output_clk_sel : std_logic;
   signal output_clk, output_clk_en, output_clr : std_logic;
   signal output_reg_clr, we_clr, waddr_clr, write_logic_clr : std_logic;
   signal matchfound_int, matchfound_reg: std_logic;
   signal wdatain_reg, wdatain_int, wrinv_reg, wrinv_int : std_logic;
   signal matchout_reg, matchout_int : std_logic_vector(15 downto 0);
   signal waddr_reg : std_logic_vector(4 downto 0);
   signal we_reg, we_pulse, clk0_inv1, we_reg_delayed : std_logic;
   signal clk0_delayed, clk0_delayed_inv : std_logic;
   signal NC : std_logic := '0';

   signal wereg_clr : std_logic;
   signal outputreg_clr : std_logic;
   signal  vcc : std_logic;
   signal  gnd : std_logic;

component dffe
   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end component;

component mux21
          port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end component;

component nmux21
          port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end component;

component bmux21
          port (
                A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                S : in std_logic := '0';
                MO : out std_logic_vector(15 downto 0));
end component;

component INV
          port (
                IN1 : in std_logic;
                Y : out std_logic);
end component;

component AND1
          port (
                IN1 : in std_logic;
                Y : out std_logic);
end component;

component AND2
          port (
                IN1 : in std_logic;
                IN2 : in std_logic;
                Y : out std_logic);
end component;

component apexii_cam
          port (datain, wrinvert, outputselect : in std_logic := '0';
                we : in std_logic := '0';
		inclk : in std_logic;
                waddr : in std_logic_vector(4 downto 0) := (OTHERS => '0');
                lit : in std_logic_vector(31 downto 0) := (OTHERS => '0');
                modesel : in std_logic_vector(1 downto 0) := "00";
                matchfound : out std_logic;
		matchout : out std_logic_vector(15 downto 0));
end component;

begin

vcc <= '1';
gnd <= '0';

waddr_clr_sel		<= modesel(0);
write_logic_sel		<= modesel(1);
write_logic_clr_sel	<= modesel(2);
we_clr_sel		<= modesel(3);
output_reg_sel		<= modesel(4);
output_clk_sel		<= modesel(5);
output_clr_sel		<= modesel(6);
output_reg_clr_sel	<= modesel(7);

outputclksel: mux21 
           port map (A => clk0, B => clk1, S => output_clk_sel, 
                     MO => output_clk);

outputclkensel: mux21 
           port map (A => ena0, B => ena1, S => output_clk_sel, 
                     MO => output_clk_en);

outputregclrsel: mux21 
           port map (A => clr0, B => clr1, S => output_reg_clr_sel, 
                     MO => output_reg_clr);

outputclrsel: nmux21 
           port map (A => NC, B => output_reg_clr, S => output_clr_sel, 
                     MO => output_clr);

matchoutsel: bmux21
           port map (A => matchout_int, B => matchout_reg, S => output_reg_sel,
                     MO => matchout);

matchfoundsel: mux21
           port map (A => matchfound_int, B => matchfound_reg, S => output_reg_sel,
                     MO => matchfound);

wdatainsel: mux21
           port map (A => datain, B => wdatain_reg, S => write_logic_sel,
                     MO => wdatain_int);

wrinvsel: mux21
           port map (A => wrinvert, B => wrinv_reg, S => write_logic_sel,
                     MO => wrinv_int);

weclrsel: nmux21
           port map (A => clr0, B => NC, S => we_clr_sel,
                     MO => we_clr);

waddrclrsel: nmux21
           port map (A => clr0, B => NC, S => waddr_clr_sel,
                     MO => waddr_clr);

writelogicclrsel: nmux21
           port map (A => clr0, B => NC, S => write_logic_clr_sel,
                     MO => write_logic_clr);

wereg: dffe
          port map (D => we, CLRN => we_clr, PRN => vcc, CLK => clk0,
                    ENA => ena0, Q => we_reg);

clk0weregdelaybuf: AND1
			port map (Y => clk0_delayed, IN1 => clk0);

pt_inv_1: INV
			port map (Y => clk0_delayed_inv, IN1 => clk0_delayed);

pt_and2_1: AND2
			port map (Y => we_pulse, IN1 => clk0_delayed_inv, IN2 => we_reg_delayed);

wedelay_buf: AND1
			port map (Y => we_reg_delayed, IN1 => we_reg);

wdatainreg: dffe
          port map (D => datain, CLRN => write_logic_clr, PRN => vcc, CLK => clk0,
                    ENA => ena0, Q => wdatain_reg);

wrinvreg: dffe
          port map (D => wrinvert, CLRN => write_logic_clr, PRN => vcc, CLK => clk0,
                    ENA => ena0, Q => wrinv_reg);

waddrreg_0: dffe 
          port map (D => waddr(0), CLRN => waddr_clr, PRN => vcc, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(0));

waddrreg_1: dffe 
          port map (D => waddr(1), CLRN => waddr_clr, PRN => vcc, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(1));

waddrreg_2: dffe 
          port map (D => waddr(2), CLRN => waddr_clr, PRN => vcc, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(2));

waddrreg_3: dffe 
          port map (D => waddr(3), CLRN => waddr_clr, PRN => vcc, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(3));

waddrreg_4: dffe 
          port map (D => waddr(4), CLRN => waddr_clr, PRN => vcc, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(4));

matchoutreg_0: dffe
     port map (D => matchout_int(0), CLRN => output_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(0));
matchoutreg_1: dffe
     port map (D => matchout_int(1), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(1));
matchoutreg_2: dffe
     port map (D => matchout_int(2), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(2));
matchoutreg_3: dffe
     port map (D => matchout_int(3), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(3));
matchoutreg_4: dffe
     port map (D => matchout_int(4), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(4));
matchoutreg_5: dffe
     port map (D => matchout_int(5), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(5));
matchoutreg_6: dffe
     port map (D => matchout_int(6), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(6));
matchoutreg_7: dffe
     port map (D => matchout_int(7), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(7));
matchoutreg_8: dffe
     port map (D => matchout_int(8), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(8));
matchoutreg_9: dffe
     port map (D => matchout_int(9), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(9));
matchoutreg_10: dffe
     port map (D => matchout_int(10), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(10));
matchoutreg_11: dffe
     port map (D => matchout_int(11), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(11));
matchoutreg_12: dffe
     port map (D => matchout_int(12), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(12));
matchoutreg_13: dffe
     port map (D => matchout_int(14), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(13));
matchoutreg_14: dffe
     port map (D => matchout_int(14), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(14));
matchoutreg_15: dffe
     port map (D => matchout_int(15), CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchout_reg(15));

matchfoundreg: dffe
     port map (D => matchfound_int, CLRN => outputreg_clr, PRN => vcc, CLK => output_clk,
		       ENA => output_clk_en, Q => matchfound_reg);

cam1: apexii_cam

	  port map (datain => wdatain_int, wrinvert => wrinv_int,
		    outputselect => outputselect, inclk => clk0,
                    we => we_pulse, waddr => waddr_reg, lit => lit,
                    modesel => modesel(9 downto 8), matchout => matchout_int,
		    matchfound => matchfound_int);

end structure;


library IEEE;
use IEEE.std_logic_1164.all;

entity apexii_pterm is

  port (pterm0	: in std_logic_vector(31 downto 0);
        pterm1  : in std_logic_vector(31 downto 0);
        pexpin	: in std_logic;
        clk	: in std_logic;
        ena 	: in std_logic;
	aclr	: in std_logic;
        modesel : in std_logic_vector(9 downto 0);
	dataout : out std_logic;
        pexpout : out std_logic );
end apexii_pterm; 

architecture vital_pterm_atom of apexii_pterm is

component apexii_asynch_pterm
  port (pterm0	: in std_logic_vector(31 downto 0) := 
			"11111111111111111111111111111111";
        pterm1  : in std_logic_vector(31 downto 0) := 
			"11111111111111111111111111111111";
        pexpin	: in std_logic := '0';
        fbkin : in std_logic;
	combout : out std_logic;
        regin : out std_logic;
        modesel : in std_logic_vector(9 downto 0);
        pexpout : out std_logic );
end component; 

component apexii_pterm_register
  port (
        datain	: in std_logic;
        clk	: in std_logic;
        ena 	: in std_logic;
	aclr	: in std_logic;
	regout : out std_logic;
	modesel : in std_logic_vector(9 downto 0);
        fbkout : out std_logic);
end component; 

component mux21
  port (
        A	: in std_logic;
        B	: in std_logic;
        S 	: in std_logic;
        MO : out std_logic);
end component; 

signal fbk, dffin, combo, dffo	:std_ulogic ;
signal modesel_tmp : std_logic;

begin

pcom: apexii_asynch_pterm 
	port map ( pterm0 => pterm0, pterm1 => pterm1, pexpin => pexpin,
                   fbkin => fbk, regin => dffin, combout => combo, 
                   pexpout => pexpout, modesel => modesel);

preg: apexii_pterm_register
	port map ( datain => dffin, clk => clk, ena => ena, aclr => aclr,
                   regout => dffo,
                   fbkout => fbk, modesel => modesel);	

--dataout <= combo when output_mode = "comb" else dffo;

modesel_tmp <= modesel(8);

mux21_inst1: mux21 
	port map ( MO => dataout, S => modesel_tmp, A => combo, B => dffo);


end vital_pterm_atom;

