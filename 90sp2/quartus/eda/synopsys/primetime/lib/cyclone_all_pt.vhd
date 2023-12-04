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

entity cyclone_lcell is
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
end cyclone_lcell;
        
architecture vital_le_atom of cyclone_lcell is

signal regin : std_logic;
signal dffin : std_logic;
signal qfbkin  : std_logic;

component cyclone_asynch_lcell 
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

component cyclone_lcell_register
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

lecomb: cyclone_asynch_lcell
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cin0 => cin0, cin1 => cin1, inverta => inverta, qfbkin => qfbkin, modesel => modesel, pathsel => pathsel, regin => regin,
                  combout => combout, cout => cout, cout0 => cout0, cout1 => cout1);

regin_datac: AND2
   port map( Y =>  dffin, IN1 =>  regin, IN2 =>  datac);

lereg: cyclone_lcell_register
  	port map (clk => clk, modesel => modesel, aclr => aclr, aload => aload, sclr => sclr, sload => sload, ena => ena, datain => dffin, adata => datac,
                  regcascin => regcascin, regout => regout,
                  qfbkout => qfbkin, enable_asynch_arcs => enable_asynch_arcs);


end vital_le_atom;


--
-- CYCLONE_IO
--
library IEEE;
use IEEE.std_logic_1164.all;

entity  cyclone_io is
    port (
		datain          : in std_logic := '0';
		oe              : in std_logic := '1';
		outclk          : in std_logic := '0';
		outclkena       : in std_logic := '1';
		inclk           : in std_logic := '0';
		inclkena        : in std_logic := '1';
		areset          : in std_logic := '0';
		sreset          : in std_logic := '0';
		modesel         : in std_logic_vector(26 DOWNTO 0);
		combout         : out std_logic;
		regout          : out std_logic;
		padio           : inout std_logic );
end cyclone_io;

architecture structure of cyclone_io is
component cyclone_asynch_io 
	port(
         datain : in  STD_LOGIC;
         oe     : in  STD_LOGIC;
         regin  : in std_logic;
         modesel : in std_logic_vector(26 downto 0);
         padio  : inout STD_LOGIC;
         combout: out STD_LOGIC;
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
	signal one,zero : std_logic;
begin    
one <= '1';
zero <= '0'; 

inv_1 : INV
    port map ( Y => areset_inv, IN1 => areset);

	-- output register signals
	--assign out_reg_aclr = (output_async_reset == "clear") ? iareset : 'b1;
	-- output registered
	mux21_1 : mux21 port map ( MO => out_reg_aclr , B => areset_inv, A => one, S =>  modesel(9));

	--assign out_reg_apreset = ( output_async_reset == "preset") ? iareset : 'b1;
	mux21_2 : mux21 port map( MO =>  out_reg_apreset, B =>  areset_inv, A =>  one, S =>  modesel(10));
    --assign outreg_sreset_is_used = ( output_sync_reset == clear || preset);
	or2_1 : OR2 port map(Y =>  outreg_sreset_is_used, IN1 =>  modesel(11), IN2 =>  modesel(12));

	-- This is the FF value that is clocked in when sreset is active
	--assign outreg_sreset_value = (output_sync_reset == "preset");
	outreg_sreset_value <= modesel(12);

	-- oe register signals
	--assign oe_reg_aclr = ( oe_async_reset == "clear") ? iareset : 'b1;
	mux21_3 : mux21 port map( MO =>  oe_reg_aclr, B =>  areset_inv, A =>  one, S =>  modesel(15));

	--assign oe_reg_apreset = ( oe_async_reset == "preset") ? iareset : 'b1;
	mux21_4 : mux21 port map( MO =>  oe_reg_apreset, B =>  areset_inv, A =>  one, S =>  modesel(16));

    --assign oereg_sreset_is_used = ( oe_sync_reset == clear || preset);
	or2_2 : OR2 port map(Y =>  oereg_sreset_is_used, IN1 =>  modesel(17), IN2 =>  modesel(18));

	-- This is the FF value that is clocked in when sreset is active
	--assign oereg_sreset_value = (oe_sync_reset == "preset");
	oereg_sreset_value <= modesel(18);

	-- input register signals
	--assign in_reg_aclr = ( input_async_reset == "clear") ? iareset : 'b1;
	mux21_5 : mux21 port map( MO =>  in_reg_aclr, B =>  areset_inv, A =>  one, S =>  modesel(20));

	--assign in_reg_apreset = ( input_async_reset == "preset") ? iareset : 'b1;
	mux21_6 : mux21 port map( MO =>  in_reg_apreset, B =>  areset_inv, A =>  one, S =>  modesel(21));

	--assign inreg_sreset_is_used = ( input_sync_reset == "clear" || "preset");
	or2_3 : OR2 port map(Y =>  inreg_sreset_is_used, IN1 =>  modesel(22), IN2 =>  modesel(23));

	-- This is the FF value that is clocked in when sreset is active
	--assign inreg_sreset_value = (input_sync_reset == "preset");
	inreg_sreset_value <= modesel(23);

	-- oe and output register clock enable signals
	--assign out_reg_clk_ena = ( tie_off_output_clock_enable == "true") ? 'b1 : outclkena;
	mux21_7 : mux21 port map( MO =>  out_reg_clk_ena, B =>  one, A =>  outclkena, S =>  modesel(25));

	--assign oe_reg_clk_ena = ( tie_off_oe_clock_enable == "true") ? 'b1 : outclkena;
	mux21_8 : mux21 port map( MO =>  oe_reg_clk_ena, B =>  one, A =>  outclkena, S =>  modesel(26));

	-- input reg
	and2_1 : AND2 port map( Y =>  select_inreg_sreset_value, IN1 =>  sreset, IN2 =>  inreg_sreset_is_used);
	inreg_D_mux : mux21 port map(MO  =>  inreg_D,
			           A  =>  padio,
			           B  =>  inreg_sreset_value,
			           S  =>  select_inreg_sreset_value);
   
	input_reg : dffe port map(Q  =>  tmp_input_reg_out,
                       CLK  =>  inclk,
                       ENA  =>  inclkena,
                       D  =>  inreg_D,
                       CLRN  =>  in_reg_aclr ,
                       PRN  =>  in_reg_apreset );
	--output reg
	and2_2 : AND2 port map( Y =>  select_outreg_sreset_value, IN1 =>  sreset, IN2 =>  outreg_sreset_is_used);
	outreg_D_mux : mux21 port map(MO  =>  outreg_D,
			           A  =>  datain,
			           B  =>  outreg_sreset_value,
			           S  =>  select_outreg_sreset_value);

	output_reg : dffe port map(Q  =>  tmp_output_reg_out,
                     CLK  =>  outclk,
                     ENA  =>  out_reg_clk_ena,
                     D  =>  outreg_D,
                     CLRN  =>  out_reg_aclr ,
                     PRN  =>  out_reg_apreset );
	--oe reg
	and2_3 : AND2 port map( Y =>  select_outreg_sreset_value, IN1 =>  sreset, IN2 =>  outreg_sreset_is_used);
	oereg_D_mux : mux21 port map(MO  =>  oereg_D,
			           A  =>  oe,
			           B  =>  oereg_sreset_value,
			           S  =>  select_outreg_sreset_value);

	oe_reg : dffe port map(Q  =>  tmp_oe_reg_out,
                 CLK  =>  outclk,
                 ENA  =>  oe_reg_clk_ena,
                 D  =>  oereg_D,
                 CLRN  =>  oe_reg_aclr ,
				 PRN  =>  oe_reg_apreset );

	-- asynchronous block
	--assign tmp_oe = (oe_reg_sel == 'b1) ? tmp_oe_reg_out : oe;
	mux21_9 : mux21 port map( MO =>  tmp_oe, B =>  tmp_oe_reg_out, A =>  oe, S =>  modesel(14));
	--assign tmp_datain = ((operation_mode == "output" || operation_mode == "bidir") && out_reg_sel == 'b1 ) ? tmp_output_reg_out : datain;
	or2_4 : OR2 port map(Y =>  output_or_bidir_pad, IN1 =>  modesel(1), IN2 =>  modesel(2));
	and2_4 : AND2 port map( Y =>  has_output_register, IN1 =>  output_or_bidir_pad, IN2 =>  modesel(8));
	mux21_10 : mux21 port map( MO =>  tmp_datain, B =>  tmp_output_reg_out, A =>  datain, S =>  has_output_register);

	asynch_inst: cyclone_asynch_io	port map(datain =>  tmp_datain,
                                    oe =>  tmp_oe,
                                    regin =>  tmp_input_reg_out,
                                    padio =>  padio,
                                    combout =>  combout,
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



--
-- cyclone_RAM_BLOCK
--
library ieee;
use ieee.std_logic_1164.all;


entity  cyclone_ram_block is
    port (
		portadatain		: in std_logic_vector(143 downto 0);
		portaaddr		: in std_logic_vector(15 downto 0);
		portawe		: in std_logic;
		modesel		: in std_logic_vector(40 downto 0);
		portbdatain		: in std_logic_vector(71 downto 0);
		portbaddr		: in std_logic_vector(15 downto 0);
		portbrewe		: in std_logic;
		clk0, clk1		: in std_logic;
		ena0, ena1		: in std_logic;
		clr0, clr1		: in std_logic;
		portabyteenamasks		: in std_logic_vector(15 downto 0);
		portbbyteenamasks		: in std_logic_vector(15 downto 0);
		portadataout		: out std_logic_vector(143 downto 0);
		portbdataout		: out std_logic_vector(143 downto 0));
end cyclone_ram_block;

architecture structure of cyclone_ram_block is

component mux21_spc
          port (
                IN0 : in std_logic;
                IN1 : in std_logic;
                S : in std_logic;
                PASS : in std_logic;
                MO : out std_logic);
end component;
component cyclone_core_mem
    port (
		portadatain		: in std_logic_vector(143 downto 0);
		portaaddr		: in std_logic_vector(15 downto 0);
		portawe		: in std_logic;
		portaclk		: in std_logic;
		portaclr		: in std_logic;
		portaena		: in std_logic;
		modesel		: in std_logic_vector(40 downto 0);
		portbdatain		: in std_logic_vector(71 downto 0);
		portabyteenamasks		: in std_logic_vector(15 downto 0);
		portbbyteenamasks		: in std_logic_vector(15 downto 0);
		portbaddr		: in std_logic_vector(15 downto 0);
		portbrewe		: in std_logic;
		portb_datain_clk		: in std_logic;
		portb_addr_clk		: in std_logic;
		portb_rewe_clk		: in std_logic;
		portb_byte_enable_clk		: in std_logic;
		portb_datain_ena		: in std_logic;
		portb_addr_ena		: in std_logic;
		portb_rewe_ena		: in std_logic;
		portb_byte_enable_ena		: in std_logic;
		portb_datain_clr		: in std_logic;
		portb_addr_clr		: in std_logic;
		portb_rewe_clr		: in std_logic;
		portb_byte_enable_clr		: in std_logic;
		portadataout		: out std_logic_vector(143 downto 0);
		portbdataout		: out std_logic_vector(143 downto 0));
end component;

component cyclone_memory_register
    port (
		data		: in std_logic_vector(143 downto 0);
		clk, aclr, ena, async		: in std_logic;
		dataout		: out std_logic_vector(143 downto 0));
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

	signal porta_clk, porta_clr, porta_ena : std_logic;
	signal porta_dataout : std_logic_vector(143 downto 0);
	signal porta_falling_edge_feedthru : std_logic_vector(143 downto 0); 
	signal portb_datain_clk, portb_addr_clk, portb_rewe_clk : std_logic; 
	signal portb_datain_ena, portb_addr_ena, portb_rewe_ena : std_logic; 
	signal portb_datain_clr, portb_addr_clr, portb_rewe_clr : std_logic; 
	signal portb_dataout : std_logic_vector(143 downto 0);
	signal portb_falling_edge_feedthru : std_logic_vector(143 downto 0);
	signal portb_byte_enable_clk, portb_byte_enable_clr, porta_out_clk_none : std_logic;
	signal select_porta_out_clk01, porta_out_clk_exists : std_logic;
	signal select_porta_out_clr01, porta_out_clr_exists : std_logic;
	signal select_portb_out_clk01, portb_out_clk_exists, portb_out_clk_none : std_logic;
	signal select_portb_out_clr01, portb_out_clr_exists : std_logic;

	signal select_portb_datain_clr01 : std_logic;
	signal select_portb_addr_clr01 : std_logic;
	signal select_portb_rewe_clk01, select_portb_rewe_clr01 : std_logic;
	signal select_portb_byte_enable_clr01 : std_logic;
	signal portb_byte_enable_clr_exists : std_logic;
	signal portb_rewe_clr_exists : std_logic;

	signal outb_clr, outb_clk, outa_clr, outa_clk : std_logic;
	signal outa_ena, outb_ena : std_logic;
	signal outclk_inv : std_logic;
	signal portb_datain_clr_exists, portb_addr_clr_exists: std_logic;
	
	signal vcc : std_logic;
begin

	vcc <= '1';
	-- porta control signals are fixed
	porta_clk <= clk0;
	porta_clr <= clr0;
	porta_ena <= ena0;

	-- this clock select also selects all other register clocks
	--  since same clock has to be used on all registers on port b
	select_portb_rewe_clk01 <= modesel(21);


	-- select_* signals choose one of two clears
	select_portb_datain_clr01 <= modesel(17);
	select_portb_addr_clr01 <= modesel(20);
	select_portb_byte_enable_clr01 <= modesel(26);
	select_portb_rewe_clr01 <= modesel(23);

	-- *_exists signals determine whether to pass above selected clear signal through
	-- portb_datain_clr_exists = datain_clr = clr0 || clr1
	modesel_or_5: OR2    port map(Y =>  portb_datain_clr_exists, IN1 =>  modesel(16), IN2 =>  modesel(17));
	
	-- portb_addr_clr_exists = addr_in_clr = clr0 || clr1
	modesel_or_6: OR2    port map(Y =>  portb_addr_clr_exists, IN1 =>  modesel(19), IN2 =>  modesel(20));


	-- portb_rewe_clr_exists = re/we_in_clr = clr0 || clr1
	modesel_or_7: OR2    port map(Y =>  portb_rewe_clr_exists, IN1 =>  modesel(22), IN2 =>  modesel(23));


	-- portb_byte_enable_clr_exists = addr_in_clr = clr0 || clr1
	modesel_or_8: OR2    port map(Y =>  portb_byte_enable_clr_exists, IN1 =>  modesel(25), IN2 =>  modesel(26));


	-- PORT B DATAIN CLR 
	select_portb_datain_clr: mux21_spc  port map( MO =>  portb_datain_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_datain_clr01, 
	                     PASS =>  portb_datain_clr_exists);

	-- PORT B ADDR CLR 
	select_portb_addr_clr: mux21_spc port map( MO =>  portb_addr_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_addr_clr01, 
	                     PASS =>  portb_addr_clr_exists);

	-- PORT B BYTEENABLE CLR 
	select_portb_byte_enable_clr: mux21_spc  port map( MO =>  portb_byte_enable_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_byte_enable_clr01, 
	                     PASS =>  portb_byte_enable_clr_exists);

	-- PORT B READ/WRITE ENABLE REGISTER selection
	-- Note: CLK & ENA selections here apply to all registers, since
	-- all of them can have same clock and enable.
	select_portb_rewe_clk: mux21_spc port map( MO =>  portb_rewe_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_portb_rewe_clk01, 
	                     PASS =>  vcc);
	-- ena selection follows clk selection
	select_portb_rewe_ena: mux21_spc  port map( MO =>  portb_rewe_ena, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_portb_rewe_clk01, 
	                     PASS =>  vcc);
	select_portb_rewe_clr: mux21_spc  port map( MO =>  portb_rewe_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_rewe_clr01, 
	                     PASS =>  portb_rewe_clr_exists);


	-- internal synchronous memory: includes all input registers, but not 
	-- 											the output registers
  cyclonemem  : cyclone_core_mem	 
       port map(portadatain =>  portadatain, 
       portaaddr =>  portaaddr, 
       portawe =>  portawe, 
       portaclk =>  porta_clk, 
       portaclr =>  porta_clr, 
       portaena =>  porta_ena, 
       portadataout =>  porta_dataout,
       portabyteenamasks =>  portabyteenamasks,
       modesel =>  modesel,
       portbdatain =>  portbdatain, 
       portbaddr =>  portbaddr, 
       portbrewe =>  portbrewe, 
       portb_datain_clk =>  portb_rewe_clk, 
       portb_addr_clk =>  portb_rewe_clk, 
       portb_rewe_clk =>  portb_rewe_clk, 
       portb_datain_ena =>  portb_rewe_ena, 
       portb_addr_ena =>  portb_rewe_ena, 
       portb_rewe_ena =>  portb_rewe_ena, 
       portb_datain_clr =>  portb_datain_clr, 
       portb_addr_clr =>  portb_addr_clr, 
       portb_rewe_clr =>  portb_rewe_clr, 
       portbdataout =>  portb_dataout,
       portbbyteenamasks =>  portbbyteenamasks,
       portb_byte_enable_clk =>  portb_rewe_clk, 
       portb_byte_enable_ena =>  portb_rewe_ena, 
      portb_byte_enable_clr =>  portb_byte_enable_clr
       );


	select_porta_out_clk01 <= modesel(12); 
	-- { this is modesel for porta outclock = clk1 }

	-- porta_out_clk_exists = porta outclock= clk0 or clk1
	modesel_or_1: OR2    port map(Y =>  porta_out_clk_exists, IN1 =>  modesel(11), IN2 =>  modesel(12));
	modesel_or_1_inv: INV  port map(Y =>  porta_out_clk_none, IN1 =>  porta_out_clk_exists);
	
	-- porta_out_clr_exists = porta outclr= clr0 or clr1
	modesel_or_2: OR2    port map(Y =>  porta_out_clr_exists, IN1 =>  modesel(13), IN2 =>  modesel(14));



	select_portb_out_clk01 <= modesel(28); 
	-- { this is modesel for portb outclock = clk1 }

	-- portb_out_clk_exists = portb outclock= clk0 or clk1
	modesel_or_3: OR2    port map(Y =>  portb_out_clk_exists, IN1 =>  modesel(27), IN2 =>  modesel(28));
	modesel_or_3_inv: INV  port map(Y =>  portb_out_clk_none, IN1 =>  portb_out_clk_exists);
	
	-- portb_out_clr_exists = portb outclr= clr0 or clr1
	modesel_or_4: OR2    port map(Y =>  portb_out_clr_exists, IN1 =>  modesel(29), IN2 =>  modesel(30));


	-- PORT A OUTPUT REGISTER selection


	select_porta_out_clk: mux21_spc  port map( MO =>  outa_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_porta_out_clk01, 
	                     PASS =>  porta_out_clk_exists);
	-- ena selection follows clk selection
	select_porta_out_ena: mux21_spc  port map( MO =>  outa_ena, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_porta_out_clk01, 
	                     PASS =>  porta_out_clk_exists);
	select_porta_out_clr: mux21_spc  port map( MO =>  outa_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_porta_out_clr01, 
	                     PASS =>  porta_out_clr_exists);


	-- PORT B OUTPUT REGISTER selection
	select_portb_out_clk: mux21_spc  port map( MO =>  outb_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_portb_out_clk01, 
	                     PASS =>  portb_out_clk_exists);
	-- ena selection follows clk selection
	select_portb_out_ena: mux21_spc  port map( MO =>  outb_ena, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_portb_out_clk01, 
	                     PASS =>  portb_out_clk_exists);
	select_portb_out_clr: mux21_spc  port map( MO =>  outb_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_out_clr01, 
	                     PASS =>  portb_out_clr_exists);


porta_ram_output_reg: cyclone_memory_register 	
		 port map(data =>  porta_dataout,
		 clk =>  outa_clk, 
		 aclr =>  outa_clr, 
		 ena =>  outa_ena, 
		 async =>  porta_out_clk_none, 
		 dataout =>  portadataout 
		);

portb_ram_output_reg: cyclone_memory_register 	
		 port map(data =>  portb_dataout,
		 clk =>  outb_clk, 
		 aclr =>  outb_clr, 
		 ena =>  outb_ena, 
		 async =>  portb_out_clk_none, 
		 dataout =>  portbdataout 
		);


end structure;


