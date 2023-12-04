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

entity  cycloneii_io is
    port (
		datain          : in std_logic := '0';
		oe              : in std_logic := '1';
		outclk          : in std_logic := '0';
		outclkena       : in std_logic := '1';
		inclk           : in std_logic := '0';
		inclkena        : in std_logic := '1';
		areset          : in std_logic := '0';
		sreset          : in std_logic := '0';
		differentialin      : in std_logic := '0';
		linkin          : in std_logic := '0';
		modesel         : in std_logic_vector(25 DOWNTO 0);
		combout         : out std_logic;
		regout          : out std_logic;
		differentialout     : out std_logic;
		linkout         : out std_logic;
		padio           : inout std_logic );
end cycloneii_io;

architecture structure of cycloneii_io is
component cycloneii_asynch_io 
	port(
         differentialin : in  STD_LOGIC;
         datain : in  STD_LOGIC;
         oe     : in  STD_LOGIC;
         regin  : in std_logic;
         modesel : in std_logic_vector(25 downto 0);
         padio  : inout STD_LOGIC;
         combout: out STD_LOGIC;
         differentialout: out STD_LOGIC;
         regout : out STD_LOGIC);
end component;

component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
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

	
	signal	out_reg_clk_ena, oe_reg_clk_ena : std_logic;

	signal	tmp_oe_reg_out, tmp_input_reg_out, tmp_output_reg_out : std_logic;
	
	signal	inreg_sreset_is_used, outreg_sreset_is_used, oereg_sreset_is_used : std_logic;

	signal	inreg_sreset_value, outreg_sreset_value, oereg_sreset_value : std_logic;
	signal	select_inreg_sreset_value, select_outreg_sreset_value, select_oereg_sreset_value : std_logic;

	signal	in_reg_aclr, in_reg_apreset : std_logic;
	
	signal	oe_reg_aclr, oe_reg_apreset, oe_reg_sel : std_logic;
	
	signal	out_reg_aclr, out_reg_apreset, out_reg_sel : std_logic;
	
	signal	inreg_D, outreg_D, oereg_D : std_logic;

	signal	tmp_datain, tmp_oe : std_logic;
	signal 	areset_inv: std_logic;
	signal	output_or_bidir_pad, has_output_register : std_logic;
	signal	select_differential_path_in, select_differential_path_out : std_logic;
	signal	padio_in : std_logic;
	signal one,zero : std_logic;
begin    
one <= '1';
zero <= '0'; 

	select_differential_path_in <= modesel(25);

	-- areset is active high & mapped to CLRN/PRN on dffe which are active low
	inv_1 : INV port map  ( Y =>  areset_inv, IN1 =>  areset);

	
	-- output register signals
	--assign out_reg_aclr = (output_async_reset == "clear") ? iareset : 'b1;
	-- output registered
	mux21_1 : mux21 port map  ( MO =>  out_reg_aclr, B =>  areset_inv, A =>  one, S =>  modesel(6));

	--assign out_reg_apreset = ( output_async_reset == "preset") ? iareset : 'b1;
	mux21_2 : mux21 port map  ( MO =>  out_reg_apreset, B =>  areset_inv, A =>  one, S =>  modesel(7));
    --assign outreg_sreset_is_used = ( output_sync_reset == clear || preset);
	or2_1 : OR2 port map  (Y =>  outreg_sreset_is_used, IN1 =>  modesel(8), IN2 =>  modesel(9));

	-- This is the FF value that is clocked in when sreset is active
	--assign outreg_sreset_value = (output_sync_reset == "preset");
	outreg_sreset_value <= modesel(9);

	-- oe register signals
	--assign oe_reg_aclr = ( oe_async_reset == "clear") ? iareset : 'b1;
	mux21_3 : mux21 port map  ( MO =>  oe_reg_aclr, B =>  areset_inv, A =>  one, S =>  modesel(12));

	--assign oe_reg_apreset = ( oe_async_reset == "preset") ? iareset : 'b1;
	mux21_4 : mux21 port map  ( MO =>  oe_reg_apreset, B =>  areset_inv, A =>  one, S =>  modesel(13));

    --assign oereg_sreset_is_used = ( oe_sync_reset == clear || preset);
	or2_2 : OR2 port map  (Y =>  oereg_sreset_is_used, IN1 =>  modesel(14), IN2 =>  modesel(15));

	-- This is the FF value that is clocked in when sreset is active
	--assign oereg_sreset_value = (oe_sync_reset == "preset");
	oereg_sreset_value <= modesel(15);

	-- input register signals
	--assign in_reg_aclr = ( input_async_reset == "clear") ? iareset : 'b1;
	mux21_5 : mux21 port map  ( MO =>  in_reg_aclr, B =>  areset_inv, A =>  one, S =>  modesel(17));

	--assign in_reg_apreset = ( input_async_reset == "preset") ? iareset : 'b1;
	mux21_6 : mux21 port map  ( MO =>  in_reg_apreset, B =>  areset_inv, A =>  one, S =>  modesel(18));

	--assign inreg_sreset_is_used = ( input_sync_reset == "clear" || "preset");
	or2_3 : OR2 port map  (Y =>  inreg_sreset_is_used, IN1 =>  modesel(19), IN2 =>  modesel(20));

	-- This is the FF value that is clocked in when sreset is active
	--assign inreg_sreset_value = (input_sync_reset == "preset");
	inreg_sreset_value <= modesel(20);

	-- oe and output register clock enable signals
	--assign out_reg_clk_ena = ( tie_off_output_clock_enable == "true") ? 'b1 : outclkena;
	mux21_7 : mux21 port map  ( MO =>  out_reg_clk_ena, B =>  one, A =>  outclkena, S =>  modesel(22));

	--assign oe_reg_clk_ena = ( tie_off_oe_clock_enable == "true") ? 'b1 : outclkena;
	mux21_8 : mux21 port map  ( MO =>  oe_reg_clk_ena, B =>  one, A =>  outclkena, S =>  modesel(23));

	-- input reg
	and2_1 : AND2 port map  ( Y =>  select_inreg_sreset_value, IN1 =>  sreset, IN2 =>  inreg_sreset_is_used);

	differential_path_mux_in : mux21 port map  (MO  =>  padio_in,
			           A  =>  padio,
			           B  =>  differentialin,
			           S  =>  select_differential_path_in);
   
	inreg_D_mux : mux21 port map  (MO  =>  inreg_D,
			           A  =>  padio_in,
			           B  =>  inreg_sreset_value,
			           S  =>  select_inreg_sreset_value);
   
	input_reg : dffe port map  (Q  =>  tmp_input_reg_out,
                       CLK  =>  inclk,
                       ENA  =>  inclkena,
                       D  =>  inreg_D,
                       CLRN  =>  in_reg_aclr ,
                       PRN  =>  in_reg_apreset );
	--output reg
	and2_2 : AND2 port map  ( Y =>  select_outreg_sreset_value, IN1 =>  sreset, IN2 =>  outreg_sreset_is_used);
	outreg_D_mux : mux21 port map  (MO  =>  outreg_D,
			           A  =>  datain,
			           B  =>  outreg_sreset_value,
			           S  =>  select_outreg_sreset_value);

	output_reg : dffe port map  (Q  =>  tmp_output_reg_out,
                     CLK  =>  outclk,
                     ENA  =>  out_reg_clk_ena,
                     D  =>  outreg_D,
                     CLRN  =>  out_reg_aclr ,
                     PRN  =>  out_reg_apreset );
	--oe reg
	and2_3 : AND2 port map  ( Y =>  select_outreg_sreset_value, IN1 =>  sreset, IN2 =>  outreg_sreset_is_used);
	oereg_D_mux : mux21 port map  (MO  =>  oereg_D,
			           A  =>  oe,
			           B  =>  oereg_sreset_value,
			           S  =>  select_outreg_sreset_value);

	oe_reg : dffe port map  (Q  =>  tmp_oe_reg_out,
                 CLK  =>  outclk,
                 ENA  =>  oe_reg_clk_ena,
                 D  =>  oereg_D,
                 CLRN  =>  oe_reg_aclr ,
				 PRN  =>  oe_reg_apreset );

	-- asynchronous block
	--assign tmp_oe = (oe_reg_sel == 'b1) ? tmp_oe_reg_out : oe;
	mux21_9 : mux21 port map  ( MO =>  tmp_oe, B =>  tmp_oe_reg_out, A =>  oe, S =>  modesel(11));
	--assign tmp_datain = ((operation_mode == "output" || operation_mode == "bidir") && out_reg_sel == 'b1 ) ? tmp_output_reg_out : datain;
	or2_4 : OR2 port map  (Y =>  output_or_bidir_pad, IN1 =>  modesel(1), IN2 =>  modesel(2));
	and2_4 : AND2 port map  ( Y =>  has_output_register, IN1 =>  output_or_bidir_pad, IN2 =>  modesel(5));
	mux21_10 : mux21 port map  ( MO =>  tmp_datain, B =>  tmp_output_reg_out, A =>  datain, S =>  has_output_register);

	asynch_inst: cycloneii_asynch_io port map 	(
                                    differentialin =>  differentialin,
                                    datain =>  tmp_datain,
                                    oe =>  tmp_oe,
                                    regin =>  tmp_input_reg_out,
                                    padio =>  padio,
                                    combout =>  combout,
                                    differentialout =>  differentialout,
                                    regout =>  regout,
                                    modesel =>  modesel);

end structure;

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

entity  cycloneii_mac_mult is
    port (
      dataa           : in std_logic_vector(17 downto 0);
      datab           : in std_logic_vector(17 downto 0);
      signa           : in std_logic;
      signb           : in std_logic;
      clk             : in std_logic;
      aclr            : in std_logic;
      ena             : in std_logic;
      modesel             : in std_logic_vector(3 downto 0);
      
      dataout         : out std_logic_vector(35 downto 0)
		);
end cycloneii_mac_mult;

architecture structure of cycloneii_mac_mult is
  component cycloneii_mac_register
   port(
      data   : in std_logic_vector(17 downto 0);
      clk, aclr, ena, async   : in std_logic;
      dataout    : out std_logic_vector(17 downto 0));
	end component;
  component cycloneii_mac_mult_internal
   port(
      dataa   : in std_logic_vector(17 downto 0);
      datab   : in std_logic_vector(17 downto 0);
      signa, signb   : in std_logic;
      dataout    : out std_logic_vector(35 downto 0));
	end component;

  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
	end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
	end component;


   signal 				  signa_out: std_logic; 
   signal 				  signb_out: std_logic;
   
   signal dataa_out : std_logic_vector(17 downto 0);
   signal datab_out : std_logic_vector(17 downto 0);

	signal datab_int, datab_out_int : std_logic_vector(71 downto 0);
	signal signa_int, signa_out_int : std_logic_vector(17 downto 0);
	signal signb_int, signb_out_int : std_logic_vector(17 downto 0);
	signal dataa_int, dataa_out_int2 : std_logic_vector(71 downto 0);
	signal clka, aclra, enaa, clkb, aclrb, enab, clksa, enasa, aclrsa, clksb, enasb, aclrsb : std_logic;
	signal clkout, aclrout, enaout : std_logic;
	signal no_dataa_reg, no_datab_reg, no_signa_reg, no_signb_reg : std_logic;
begin    

	-- select clk,aclr,ena for dataa: Either used or None
	dataa_clk_inst1 : AND2    port map  ( Y =>  clka, IN1 =>  clk, IN2 =>  modesel(0));
	dataa_aclr_inst1 : AND2    port map  ( Y =>  aclra, IN1 =>  aclr, IN2 =>  modesel(0));
	dataa_ena_inst1 : AND2    port map  ( Y =>  enaa, IN1 =>  ena, IN2 =>  modesel(0));

	-- select clk,aclr,ena for datab: Either used or None
	datab_clk_inst1 : AND2    port map  ( Y =>  clkb, IN1 =>  clk, IN2 =>  modesel(1));
	datab_aclr_inst1 : AND2    port map  ( Y =>  aclrb, IN1 =>  aclr, IN2 =>  modesel(1));
	datab_ena_inst1 : AND2    port map  ( Y =>  enab, IN1 =>  ena, IN2 =>  modesel(1));

	-- select clk,aclr,ena for signa: Either used or None
	signa_clk_inst1 : AND2    port map  ( Y =>  clksa, IN1 =>  clk, IN2 =>  modesel(2));
	signa_aclr_inst1 : AND2    port map  ( Y =>  aclrsa, IN1 =>  aclr, IN2 =>  modesel(2));
	signa_ena_inst1 : AND2    port map  ( Y =>  enasa, IN1 =>  ena, IN2 =>  modesel(2));

	-- select clk,aclr,ena for signb: Either used or None
	signb_clk_inst1 : AND2    port map  ( Y =>  clksb, IN1 =>  clk, IN2 =>  modesel(3));
	signb_aclr_inst1 : AND2    port map  ( Y =>  aclrsb, IN1 =>  aclr, IN2 =>  modesel(3));
	signb_ena_inst1 : AND2    port map  ( Y =>  enasb, IN1 =>  ena, IN2 =>  modesel(3));


	inv_1 : INV port map  ( Y =>  no_dataa_reg, IN1 =>  modesel(0));
   dataa_mac_reg : cycloneii_mac_register port map 	(
	data  =>  dataa,
	clk  =>  clka,
	aclr  =>  aclra,
	ena  =>  enaa,
	dataout  =>  dataa_out,
	async  =>   no_dataa_reg 
	);

	inv_2 : INV port map  ( Y =>  no_datab_reg, IN1 =>  modesel(1));
   datab_mac_reg : cycloneii_mac_register port map 	(
	data  =>  datab,
	clk  =>  clkb,
	aclr  =>  aclrb,
	ena  =>  enab,
	dataout  =>  datab_out,
	async  =>   no_datab_reg
	);

	inv_3 : INV port map  ( Y =>  no_signa_reg, IN1 =>  modesel(2));
	signa_int(0) <= signa; 
   signa_mac_reg : cycloneii_mac_register port map 	(
	data  =>  signa_int,
	clk  =>  clksa,
	aclr  =>  aclrsa,
	ena  =>  enasa,
	dataout  =>  signa_out_int,
	async  =>  no_signa_reg
	);
	signa_out <= signa_out_int(0); 

	inv_4 : INV port map  ( Y =>  no_signb_reg, IN1 =>  modesel(3));
	signb_int(0) <= signb; 
   signb_mac_reg : cycloneii_mac_register port map 	(
	data  =>  signb_int,
	clk  =>  clksb,
	aclr  =>  aclrsb,
	ena  =>  enasb,
	dataout  =>  signb_out_int,
	async  =>   no_signb_reg
	);
	signb_out <= signb_out_int(0); 

   mac_multiply : cycloneii_mac_mult_internal port map  (
	dataa  =>  dataa_out,
	datab  =>  datab_out,
	signa  =>  signa_out,
	signb  =>  signb_out,
	dataout =>  dataout
	);

end structure;

--
-- CYCLONEII_RAM_BLOCK
--
library ieee;
use ieee.std_logic_1164.all;


entity cycloneii_ram_block is
	port (
		portadatain : in std_logic_vector(143 downto 0);
		portaaddr : in std_logic_vector(15 downto 0);
		portawe  : in std_logic;
		modesel : in std_logic_vector(48 downto 0);
		portbdatain : in std_logic_vector(71 downto 0);
		portbaddr : in std_logic_vector(15 downto 0);
		portbrewe  : in std_logic;
		clk0  : in std_logic;
		clk1  : in std_logic;
	   ena0  : in std_logic;
		ena1  : in std_logic;
	   clr0  : in std_logic;
		clr1  : in std_logic;
	   portabyteenamasks : in std_logic_vector(15 downto 0);
	   portbbyteenamasks : in std_logic_vector(15 downto 0);
	   portaaddrstall : in std_logic;
		portbaddrstall : in std_logic;
	   portadataout : out std_logic_vector(143 downto 0);
	   portbdataout : out std_logic_vector(143 downto 0));
end cycloneii_ram_block;
 
architecture structure of cycloneii_ram_block is

component mux21
          port (
                A : in std_logic;
                B : in std_logic;
                S : in std_logic;
                MO : out std_logic);
end component;

component mux21_spc
          port (
                IN0 : in std_logic;
                IN1 : in std_logic;
                S : in std_logic;
                PASS : in std_logic;
                MO : out std_logic);
end component;
component cycloneii_ram_internal
    port (
		portadatain		: in std_logic_vector(143 downto 0);
		portaaddress		: in std_logic_vector(15 downto 0);
		portawriteenable		: in std_logic;
		modesel		: in std_logic_vector(48 downto 0);
		portbdatain		: in std_logic_vector(71 downto 0);
		portabyteenamasks		: in std_logic_vector(15 downto 0);
		portbbyteenamasks		: in std_logic_vector(15 downto 0);
		portbaddress		: in std_logic_vector(15 downto 0);
		portbrewe		: in std_logic;
		portadataout		: out std_logic_vector(143 downto 0);
		portbdataout		: out std_logic_vector(143 downto 0));
end component;

component cycloneii_memory_register
    port (
		data		: in std_logic_vector(143 downto 0);
		clk, aclr, ena, async		: in std_logic;
		dataout		: out std_logic_vector(143 downto 0));
end component;

component cycloneii_memory_addr_register
    port (
		address		: in std_logic_vector(15 downto 0);
		clk, ena, addrstall		: in std_logic;
		dataout		: out std_logic_vector(15 downto 0));
end component;

  component OR2
   port( IN1 : in STD_LOGIC;
      IN2 : in STD_LOGIC;
      Y   : out STD_LOGIC);
end component;
  component AND2
   port( IN1 : in STD_LOGIC;
      IN2 : in STD_LOGIC;
      Y   : out STD_LOGIC);
end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
component dffe

   port(
      Q                              :  out   STD_LOGIC;
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
end component;


	signal porta_clk, porta_ena : std_logic; 
	signal porta_dataout : std_logic_vector(143 downto 0);
	signal porta_falling_edge_feedthru : std_logic_vector(143 downto 0); 
	signal portb_datain_clk, portb_addr_clk, portb_clk : std_logic; 
	signal portb_datain_ena, portb_addr_ena, portb_ena, portb_ena_in : std_logic; 
	signal portb_dataout : std_logic_vector(143 downto 0);
	signal portb_falling_edge_feedthru : std_logic_vector(143 downto 0);
	signal portb_byte_enable_clk : std_logic;
	signal select_porta_out_clk01, porta_out_clk_exists, porta_out_clk_none : std_logic;
	signal select_porta_out_clr01, porta_out_clr_exists : std_logic;
	signal select_portb_out_clk01, portb_out_clk_exists, portb_out_clk_none : std_logic;
	signal select_portb_out_clr01, portb_out_clr_exists : std_logic;

	signal select_portb_byte_enable_clr01 : std_logic;
	signal select_portb_rewe_clk01 : std_logic;

	signal porta_datain_reg : std_logic_vector(143 downto 0);
	signal  porta_addr_reg : std_logic_vector(15 downto 0);
	signal porta_we_reg : std_logic;
	signal portabyteenamasks_in, porta_byteenamasks_reg_out : std_logic_vector(143 downto 0);
   signal  porta_byteenamasks_reg : std_logic_vector(15 downto 0);
	signal portb_datain_reg : std_logic_vector(71 downto 0);
	signal  portb_addr_reg : std_logic_vector(15 downto 0);
	signal portb_rewe_reg : std_logic;
	signal portbbyteenamasks_in, portb_byteenamasks_reg_out : std_logic_vector(143 downto 0);
   signal  portb_byteenamasks_reg : std_logic_vector(15 downto 0);

	signal outa_ena, outa_ena_in, outb_ena, outb_ena_in : std_logic;
	signal disable_porta_ce_input_reg : std_logic;
	signal disable_porta_ce_output_reg : std_logic;
	signal disable_portb_ce_input_reg : std_logic;
	signal disable_portb_ce_output_reg : std_logic;
	signal porta_we_ce_used  : std_logic;
	signal porta_datain_ce_used  : std_logic;
	signal porta_addr_ce_used  : std_logic;
	signal porta_byte_enable_ce_used  : std_logic;
	signal porta_dataout_ce_used  : std_logic;
	signal portb_we_ce_used  : std_logic;
	signal portb_datain_ce_used  : std_logic;
	signal portb_addr_ce_used  : std_logic;
	signal portb_byte_enable_ce_used  : std_logic;
	signal portb_dataout_ce_used  : std_logic;
	signal vcc, gnd: std_logic;
	signal gnd_vec: std_logic_vector(143 downto 0);

	signal clr0_e, clr1_e, porta_datain_ena, porta_addr_ena, porta_we_ce_used_inv : std_logic;
	signal porta_we_ena, portb_we_ena, portb_we_ce_used_inv, portb_byte_enable_ena : std_logic;
	signal outb_clr, outa_clk, outa_clr, outa_dataout_ena, outb_dataout_ena : std_logic;
	signal porta_byte_enable_ena, outb_clk : std_logic;
	signal tmp_portbdatain, tmp_portb_datain_reg : std_logic_vector(143 downto 0);

begin

	vcc <= '1';
	gnd <= '0';
	gnd_vec <= (others => '0');	

	-- porta clk is fixed
	porta_clk <= clk0;

	clr0_e <= clr0;
	clr1_e <= clr1;

	-- this clock select also selects all other register clocks
	--  since same clock has to be used on all registers on port b
	select_portb_rewe_clk01 <= modesel(21);

	disable_porta_ce_input_reg <= modesel(31); 
	disable_porta_ce_output_reg <= modesel(32); 
	disable_portb_ce_input_reg <= modesel(33); 
	disable_portb_ce_output_reg <= modesel(34); 

	porta_we_ce_used <= modesel(39); 
	porta_datain_ce_used <= modesel(40); 
	porta_addr_ce_used <= modesel(41); 
	porta_byte_enable_ce_used <= modesel(42); 
	porta_dataout_ce_used <= modesel(43); 
	portb_we_ce_used <= modesel(44); 
	portb_datain_ce_used <= modesel(45); 
	portb_addr_ce_used <= modesel(46); 
	portb_byte_enable_ce_used <= modesel(47); 
	portb_dataout_ce_used <= modesel(48); 

	-- porta has no ena0/ena1 selection(its always ena0). However
 	-- this ena can be optionally disabled
	select_porta_input_ena: mux21 port map ( MO =>  porta_ena, A =>  ena0, B =>  gnd, 
	                     S =>  disable_porta_ce_input_reg );
	
	-- PORT B READ/WRITE ENABLE REGISTER selection
	-- Note: CLK & ENA selections here apply to all registers, since
	-- all of them can have same clock and enable.
			  select_portb_rewe_clk: mux21_spc port map ( MO =>  portb_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_portb_rewe_clk01, 
	                     PASS =>  vcc);
	-- ena selection follows clk selection.
	select_portb_rewe_ena: mux21_spc port map ( MO =>  portb_ena_in, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_portb_rewe_clk01, 
	                     PASS =>  vcc);

	-- ena selected from above can be optionally disabled
	select_portb_input_ena: mux21 port map ( MO =>  portb_ena, A =>  portb_ena_in, B =>  gnd, 
	                     S =>  disable_portb_ce_input_reg );
	


	porta_datain_ena_inst : AND2    port map (Y =>  porta_datain_ena, IN1 =>  porta_ena, IN2 =>  porta_datain_ce_used);
ram_portadatain_reg: cycloneii_memory_register 	
		port map (data =>  portadatain,
		 clk =>  porta_clk, 
		 aclr =>  gnd, 
		 ena =>  porta_datain_ena, 
		 async =>  gnd, 
		 dataout =>  porta_datain_reg 
		);

	porta_addr_ena_inst : AND2    port map (Y =>  porta_addr_ena, IN1 =>  porta_ena, IN2 =>  porta_addr_ce_used);
ram_portaaddr_reg: cycloneii_memory_addr_register 	
		port map (address =>  portaaddr,
		 clk =>  porta_clk, 
		 ena =>  porta_addr_ena, 
		 addrstall =>  portaaddrstall, 
		 dataout =>  porta_addr_reg 
		);

	porta_we_ena_used_inv: INV   port map (Y =>  porta_we_ce_used_inv, IN1 =>  porta_we_ce_used);
	porta_we_ena_inst : OR2    port map (Y =>  porta_we_ena, IN1 =>  porta_ena, IN2 =>  porta_we_ce_used_inv);
	ram_portawe_reg : dffe	port map (Q =>  porta_we_reg, CLK =>  porta_clk, ENA =>  porta_we_ena, D =>  portawe, CLRN =>  vcc, PRN =>  vcc);

	portabyteenamasks_in(15 downto 0) <= portabyteenamasks;
	portabyteenamasks_in(143 downto 16) <= gnd_vec(143 downto 16);
	porta_byte_enable_ena_inst : AND2    port map (Y =>  porta_byte_enable_ena, IN1 =>  porta_ena, IN2 =>  porta_byte_enable_ce_used);
ram_portabyteenamasks_reg: cycloneii_memory_register 	
		port map (data =>  portabyteenamasks_in,
		 clk =>  porta_clk, 
		 aclr =>  gnd, 
		 ena =>  porta_byte_enable_ena, 
		 async =>  gnd, 
		 dataout =>  porta_byteenamasks_reg_out 
		);
	porta_byteenamasks_reg <= porta_byteenamasks_reg_out(15 downto 0);

	portb_datain_ena_inst : AND2    port map (Y =>  portb_datain_ena, IN1 =>  portb_ena, IN2 =>  portb_datain_ce_used);
	tmp_portbdatain(71 downto 0) <= portbdatain;
ram_portbdatain_reg: cycloneii_memory_register 	
		port map (data =>  tmp_portbdatain,
		 clk =>  portb_clk, 
		 aclr =>  gnd, 
		 ena =>  portb_datain_ena, 
		 async =>  gnd, 
		 dataout =>  tmp_portb_datain_reg 
		);

	portb_datain_reg <= tmp_portb_datain_reg(71 downto 0);

	portb_addr_ena_inst : AND2    port map (Y =>  portb_addr_ena, IN1 =>  portb_ena, IN2 =>  portb_addr_ce_used);
ram_portbaddr_reg: cycloneii_memory_addr_register 	
		port map (address =>  portbaddr,
		 clk =>  portb_clk, 
		 ena =>  portb_addr_ena, 
		 addrstall =>  portbaddrstall, 
		 dataout =>  portb_addr_reg 
		);

	portb_we_ena_used_inv: INV   port map (Y =>  portb_we_ce_used_inv, IN1 =>  portb_we_ce_used);
	portb_we_ena_inst : OR2    port map (Y =>  portb_we_ena, IN1 =>  portb_ena, IN2 =>  portb_we_ce_used_inv);
	ram_portbrewe_reg : dffe	port map (Q =>  portb_rewe_reg, CLK =>  portb_clk, ENA =>  portb_we_ena, D =>  portbrewe, CLRN =>  vcc, PRN =>  vcc);

	portbbyteenamasks_in(15 downto 0) <= portbbyteenamasks;
	portbbyteenamasks_in(143 downto 16) <= gnd_vec(143 downto 16);
	portb_byte_enable_ena_inst : AND2    port map (Y =>  portb_byte_enable_ena, IN1 =>  portb_ena, IN2 =>  portb_byte_enable_ce_used);
ram_portbbyteenamasks_reg: cycloneii_memory_register 	
		port map (data =>  portbbyteenamasks_in,
		 clk =>  portb_clk, 
		 aclr =>  gnd, 
		 ena =>  portb_byte_enable_ena, 
		 async =>  gnd, 
		 dataout =>  portb_byteenamasks_reg_out 
		);
	portb_byteenamasks_reg <= portb_byteenamasks_reg_out(15 downto 0);

	-- internal asynchronous memory: doesn't include input and output registers
  internal_ram: cycloneii_ram_internal  
      port map (portadatain =>  porta_datain_reg, 
       portaaddress =>  porta_addr_reg, 
       portawriteenable =>  porta_we_reg, 
       portabyteenamasks =>  porta_byteenamasks_reg,
       modesel =>  modesel,
       portbdatain =>  portb_datain_reg, 
       portbaddress =>  portb_addr_reg, 
       portbrewe =>  portb_rewe_reg, 
       portbbyteenamasks =>  portb_byteenamasks_reg,
       portadataout =>  porta_dataout,
      portbdataout =>  portb_dataout);


	select_porta_out_clk01 <= modesel(12); 
	-- { this is modesel for porta outclock = clk1 }
	select_porta_out_clr01 <= modesel(14); 
	-- { this is modesel for porta outclr = clr1 }

	-- porta_out_clk_exists = porta outclock= clk0 or clk1
	modesel_or_1: OR2   port map (Y =>  porta_out_clk_exists, IN1 =>  modesel(11), IN2 =>  modesel(12));
	modesel_or_1_inv: INV   port map (Y =>  porta_out_clk_none, IN1 =>  porta_out_clk_exists);
	
	-- porta_out_clr_exists = porta outclr= clr0 or clr1
	modesel_or_2: OR2   port map (Y =>  porta_out_clr_exists, IN1 =>  modesel(13), IN2 =>  modesel(14));



	select_portb_out_clk01 <= modesel(28); 
	-- { this is modesel for portb outclock = clk1 }
	select_portb_out_clr01 <= modesel(30); 
	-- { this is modesel for portb outclr = clr1 }

	-- portb_out_clk_exists = portb outclock= clk0 or clk1
	modesel_or_3: OR2   port map (Y =>  portb_out_clk_exists, IN1 =>  modesel(27), IN2 =>  modesel(28));
	modesel_or_3_inv: INV port map (Y =>  portb_out_clk_none, IN1 =>  portb_out_clk_exists);
	
	-- portb_out_clr_exists = portb outclr= clr0 or clr1
	modesel_or_4: OR2   port map (Y =>  portb_out_clr_exists, IN1 =>  modesel(29), IN2 =>  modesel(30));


	-- PORT A OUTPUT REGISTER selection


	select_porta_out_clk: mux21_spc port map ( MO =>  outa_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_porta_out_clk01, 
	                     PASS =>  porta_out_clk_exists);
	-- ena selection follows clk selection
	select_porta_out_ena: mux21_spc port map ( MO =>  outa_ena_in, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_porta_out_clk01, 
	                     PASS =>  porta_out_clk_exists);
	-- ena selected from above can be optionally disabled
	select_porta_output_ena: mux21 port map ( MO =>  outa_ena, A =>  outa_ena_in, B =>  gnd, 
	                     S =>  disable_porta_ce_output_reg );
	
	select_porta_out_clr: mux21_spc port map ( MO =>  outa_clr, IN0 =>  clr0_e, IN1 =>  clr1_e, 
	                     S =>  select_porta_out_clr01, 
	                     PASS =>  porta_out_clr_exists);


	-- PORT B OUTPUT REGISTER selection
	select_portb_out_clk: mux21_spc port map ( MO =>  outb_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_portb_out_clk01, 
	                     PASS =>  portb_out_clk_exists);
	-- ena selection follows clk selection
	select_portb_out_ena: mux21_spc port map ( MO =>  outb_ena_in, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_portb_out_clk01, 
	                     PASS =>  portb_out_clk_exists);
	-- ena selected from above can be optionally disabled
	select_portb_output_ena: mux21 port map ( MO =>  outb_ena, A =>  outb_ena_in, B =>  gnd, 
	                     S =>  disable_portb_ce_output_reg );
	
	select_portb_out_clr: mux21_spc port map ( MO =>  outb_clr, IN0 =>  clr0_e, IN1 =>  clr1_e, 
	                     S =>  select_portb_out_clr01, 
	                     PASS =>  portb_out_clr_exists);


	porta_dataout_ena_inst : AND2    port map (Y =>  outa_dataout_ena, IN1 =>  outa_ena, IN2 =>  porta_dataout_ce_used);

porta_ram_output_reg: cycloneii_memory_register 	
		port map (data =>  porta_dataout,
		 clk =>  outa_clk, 
		 aclr =>  outa_clr, 
		 ena =>  outa_dataout_ena, 
		 async =>  porta_out_clk_none, 
		 dataout =>  portadataout 
		);

	portb_dataout_ena_inst : AND2    port map (Y =>  outb_dataout_ena, IN1 =>  outb_ena, IN2 =>  portb_dataout_ce_used);
portb_ram_output_reg: cycloneii_memory_register 	
		port map (data =>  portb_dataout,
		 clk =>  outb_clk, 
		 aclr =>  outb_clr, 
		 ena =>  outb_dataout_ena, 
		 async =>  portb_out_clk_none, 
		 dataout =>  portbdataout 
		);


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

entity cycloneii_clkctrl is 
	port (
		ena : in std_logic;
		inclk : in std_logic_vector(3 downto 0);
		clkselect : in std_logic_vector(1 downto 0);
		modesel : in std_logic;
		outclk: out std_logic );
end cycloneii_clkctrl;

architecture structure of cycloneii_clkctrl is
  component dffe
   port(
      Q                              :  out   std_logic;
      D                              :  in    std_logic;
      CLRN                           :  in    std_logic;
      PRN                            :  in    std_logic;
      CLK                            :  in    std_logic;
      ENA                            :  in    std_logic);
end component;
	component mux21
	port (
			A : in std_logic;
			B : in std_logic;
			S : in std_logic;
			MO : out std_logic);
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

	signal vcc : std_logic;
	signal ce_out, cereg_out, clkmux_out, clkmux_out_inv : std_logic;
begin
	vcc <= '1';


	mux_inst: mux41 port map  ( MO =>  clkmux_out, I0 =>  inclk(0), I1 =>  inclk(1), I2 =>  inclk(2), I3 =>  inclk(3), S0 =>  clkselect(0), S1 =>  clkselect(1) );

	inv_1: INV port map  (Y =>  clkmux_out_inv, IN1 =>  clkmux_out);

	extena0_reg : dffe port map 	(Q =>  cereg_out, CLK =>  clkmux_out_inv, ENA =>  vcc, D =>  ena, CLRN =>  vcc, PRN =>  vcc);

	inst1: mux21 port map  (MO =>  ce_out, A =>  cereg_out, B =>  ena, S =>  modesel);
	bb_2: bb2 port map  (y =>  outclk, in1 =>  ce_out, in2 =>  clkmux_out );		
        
end structure;
