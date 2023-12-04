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
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////// LPM COMPONENT DECLNS for Verplex ////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--@///////////////////////////////////
--@ Author       : Arnab Guin    /////
--@ Date created : 9/29/03 ///////////
--@ Last revised : 9/29/03 ///////////
--@///////////////////////////////////
--@////////////////////////////////////////////////////////////////////////////////////////
--@ Main Design ::
--@
--@ Key components : 
--@ AND,OR,XOR,MUX
--@/////////////////////////////////////////////////////////////////////////////////////////
--@/////////////////////////////////////////////////////////////////////////////////////////
--@ Revision History                                  //////////////////////////////////////
--@ AGUIN : Create first revision : 9/29              //////////////////////////////////////
--@
--@/////////////////////////////////////////////////////////////////////////////////////////

library IEEE;
use IEEE.std_logic_1164.all;

PACKAGE lpm_components IS

constant L_CONSTANT : string := "LPM_CONSTANT";
constant L_INV      : string := "LPM_INV";
constant L_AND      : string := "LPM_AND";
constant L_OR       : string := "LPM_OR";
constant L_XOR      : string := "LPM_XOR";
constant L_BUSTRI   : string := "LPM_BUSTRI";
constant L_MUX      : string := "LPM_MUX";
constant L_DECODE   : string := "LPM_DECODE";
constant L_CLSHIFT  : string := "LPM_CLSHIFT";
constant L_ADD_SUB  : string := "LPM_ADD_SUB";
constant L_COMPARE  : string := "LPM_COMPARE";
constant L_MULT     : string := "LPM_MULT";
constant L_DIVIDE   : string := "LPM_DIVIDE";
constant L_ABS      : string := "LPM_ABS";
constant L_COUNTER  : string := "LPM_COUNTER";
constant L_LATCH    : string := "LPM_LATCH";
constant L_FF       : string := "LPM_FF";
constant L_SHIFTREG : string := "LPM_SHIFTREG";
constant L_RAM_DQ   : string := "LPM_RAM_DQ";
constant L_RAM_DP   : string := "LPM_RAM_DP";
constant L_RAM_IO   : string := "LPM_RAM_IO";
constant L_ROM      : string := "LPM_ROM";
constant L_FIFO     : string := "LPM_FIFO";
constant L_FIFO_DC  : string := "LPM_FIFO_DC";
constant L_TTABLE   : string := "LPM_TTABLE";
constant L_FSM      : string := "LPM_FSM";
constant L_INPAD    : string := "LPM_INPAD";
constant L_OUTPAD   : string := "LPM_OUTPAD";
constant L_BIPAD    : string := "LPM_BIPAD";
type STD_LOGIC_2D is array (NATURAL RANGE <>, NATURAL RANGE <>) of STD_LOGIC;
function str_to_int(S : string) return integer;
function to_int (arg : in std_logic_vector) return integer ;

------------------------------------------------------------------------
-- GATES ---------------------------------------------------------------
------------------------------------------------------------------------

component lpm_constant
        generic (lpm_width : natural;    -- MUST be greater than 0
				 lpm_cvalue : natural;
				 lpm_strength : string := "UNUSED";
				 lpm_type : string := L_CONSTANT;
				 lpm_hint : string := "UNUSED");
		port (result : out std_logic_vector(lpm_width-1 downto 0));
end component;

component lpm_inv
   generic (
      lpm_hint :  string := "UNUSED";
		lpm_type : string := L_INV;
      lpm_width   :  natural  );
   port(
      data  :  in std_logic_vector(LPM_WIDTH-1 downto 0);
      result   :  out std_logic_vector(LPM_WIDTH-1 downto 0)
   );
end component; 


component lpm_and
        generic (lpm_width : natural;    -- MUST be greater than 0
                 lpm_size : natural;    -- MUST be greater than 0
				 lpm_type : string := L_AND;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_2D(lpm_size-1 downto 0, lpm_width-1 downto 0); 
			  result : out std_logic_vector(lpm_width-1 downto 0)); 
end component; 
 
component lpm_or 
        generic (lpm_width : natural;    -- MUST be greater than 0 
                 lpm_size : natural;    -- MUST be greater than 0 
				 lpm_type : string := L_OR;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_2D(lpm_size-1 downto 0, lpm_width-1 downto 0); 
			  result : out std_logic_vector(lpm_width-1 downto 0)); 
end component; 

component lpm_xor 
        generic (lpm_width : natural;    -- MUST be greater than 0 
                 lpm_size : natural;    -- MUST be greater than 0 
				 lpm_type : string := L_XOR;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_2D(lpm_size-1 downto 0, lpm_width-1 downto 0); 
			  result : out std_logic_vector(lpm_width-1 downto 0)); 
end component; 
 
component lpm_bustri
   generic (
      lpm_hint :  string := "UNUSED";
		lpm_type : string := L_BUSTRI;
      lpm_width   :  natural  );
   port(
      data  :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '1');
      enabledt :  in std_logic := '1';
      enabletr :  in std_logic := '1';
      result   :  out std_logic_vector(LPM_WIDTH-1 downto 0);
      tridata  :  inout std_logic_vector(LPM_WIDTH-1 downto 0)
   ); 
end component; 


component lpm_mux 
        generic (lpm_width : natural;    -- MUST be greater than 0 
                 lpm_size : natural;    -- MUST be greater than 0 
                 lpm_widths : natural;    -- MUST be greater than 0 
                 lpm_pipeline : natural := 0;
				 lpm_type : string := L_MUX;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_2D(lpm_size-1 downto 0, lpm_width-1 downto 0);
			  aclr : in std_logic := '0';
			  clock : in std_logic := '0';
			  clken : in std_logic := '1';
			  sel : in std_logic_vector(lpm_widths-1 downto 0); 
			  result : out std_logic_vector(lpm_width-1 downto 0));
end component;

component lpm_decode
        generic (lpm_width : natural;    -- MUST be greater than 0
                 lpm_decodes : natural;    -- MUST be greater than 0
                 lpm_pipeline : natural := 0;
				 lpm_type : string := L_DECODE;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_vector(lpm_width-1 downto 0);
			  clock : in std_logic := '0';
			  clken : in std_logic := '1';
			  aclr : in std_logic := '0';
			  enable : in std_logic := '1';
			  eq : out std_logic_vector(lpm_decodes-1 downto 0));
end component;

component lpm_clshift
   generic (
      lpm_hint :  string := "UNUSED";
      lpm_shifttype  :  string := "LOGICAL";
		lpm_type : string := L_CLSHIFT;
      lpm_width   :  natural;
      lpm_widthdist  :  natural := 0   );
   port(
      data  :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      direction   :  in std_logic := '0';
      distance :  in std_logic_vector(LPM_WIDTHDIST-1 downto 0) := (others => '0');
      overflow :  out std_logic;
      result   :  out std_logic_vector(LPM_WIDTH-1 downto 0);
      underflow   :  out std_logic
   );
end component;

------------------------------------------------------------------------
-- ARITHMETIC COMPONENTS -----------------------------------------------
------------------------------------------------------------------------

component lpm_add_sub
   generic (
      lpm_direction  :  string := "DEFAULT";
      lpm_hint :  string := "UNUSED";
      lpm_pipeline   :  natural := 0;
      lpm_representation   :  string := "SIGNED";
      lpm_type :  string := L_ADD_SUB;
      lpm_width   :  natural  );
   port(
      aclr  :  in std_logic := '0';
      add_sub  :  in std_logic := '1';
      cin   :  in std_logic := 'Z';
      clken :  in std_logic := '1';
      clock :  in std_logic := '0';
      cout  :  out std_logic;
      dataa :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      datab :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      overflow :  out std_logic;
      result   :  out std_logic_vector(LPM_WIDTH-1 downto 0)
   );
end component;

component lpm_compare
   generic (
      lpm_hint :  string := "UNUSED";
      lpm_pipeline   :  natural := 0;
      lpm_representation   :  string := "UNSIGNED";
		lpm_type: string := L_COMPARE;
      lpm_width   :  natural  );
   port(
      aclr  :  in std_logic := '0';
      aeb   :  out std_logic;
      agb   :  out std_logic;
      ageb  :  out std_logic;
      alb   :  out std_logic;
      aleb  :  out std_logic;
      aneb  :  out std_logic;
      clken :  in std_logic := '1';
      clock :  in std_logic := '0';
      dataa :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      datab :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0')
   );
end component;

component lpm_mult
   generic (
      lpm_hint :  string := "UNUSED";
      lpm_pipeline   :  natural := 0;
      lpm_representation   :  string := "UNSIGNED";
		lpm_type: string := L_MULT;
      lpm_widtha  :  natural;
      lpm_widthb  :  natural;
      lpm_widthp  :  natural;
      lpm_widths  :  natural := 1   );
   port(
      aclr  :  in std_logic := '0';
      clken :  in std_logic := '1';
      clock :  in std_logic := '0';
      dataa :  in std_logic_vector(LPM_WIDTHA-1 downto 0);
      datab :  in std_logic_vector(LPM_WIDTHB-1 downto 0);
      result   :  out std_logic_vector(LPM_WIDTHP-1 downto 0);
      sum   :  in std_logic_vector(LPM_WIDTHS-1 downto 0) := (others => '0')
   );
end component;

	
component lpm_divide
   generic (
      lpm_drepresentation  :  string := "UNSIGNED";
      lpm_hint :  string := "UNUSED";
      lpm_nrepresentation  :  string := "UNSIGNED";
      lpm_pipeline   :  natural := 0;
      lpm_remainderpositive   :  string := "TRUE";
		lpm_type : string := L_DIVIDE;
      lpm_widthd  :  natural;
      lpm_widthn  :  natural  );
   port(
      aclr  :  in std_logic := '0';
      clken :  in std_logic := '1';
      clock :  in std_logic := '0';
      denom :  in std_logic_vector(LPM_WIDTHD-1 downto 0);
      numer :  in std_logic_vector(LPM_WIDTHN-1 downto 0);
      quotient :  out std_logic_vector(LPM_WIDTHN-1 downto 0);
      remain   :  out std_logic_vector(LPM_WIDTHD-1 downto 0)
   );
end component;
				
component lpm_abs
   generic (
      lpm_hint :  string := "UNUSED";
      lpm_type :  string := L_ABS;
      lpm_width   :  natural  );
   port(
      data  :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      overflow :  out std_logic;
      result   :  out std_logic_vector(LPM_WIDTH-1 downto 0)
   );
end component;


component lpm_counter
   generic (
      lpm_avalue  :  natural := 0;
      lpm_direction  :  string := "DEFAULT";
      lpm_hint :  string := "UNUSED";
      lpm_modulus :  natural := 0;
      lpm_port_updown   :  string := "PORT_CONNECTIVITY";
      lpm_svalue  :  natural := 0;
      lpm_type :  string := L_COUNTER;
      lpm_width   :  natural  );
   port(
      aclr  :  in std_logic := '0';
      aload :  in std_logic := '0';
      aset  :  in std_logic := '0';
      cin   :  in std_logic := '1';
      clk_en   :  in std_logic := '1';
      clock :  in std_logic;
      cnt_en   :  in std_logic := '1';
      cout  :  out std_logic;
      data  :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      eq :  out std_logic_vector(15 downto 0);
      q  :  out std_logic_vector(LPM_WIDTH-1 downto 0);
      sclr  :  in std_logic := '0';
      sload :  in std_logic := '0';
      sset  :  in std_logic := '0';
      updown   :  in std_logic := '1'
   );
end component;



------------------------------------------------------------------------
-- STORAGE COMPONENTS --------------------------------------------------
------------------------------------------------------------------------

component lpm_latch
   generic (
      lpm_avalue  :  string := "UNUSED";
      lpm_hint :  string := "UNUSED";
		lpm_type: string := L_LATCH;
      lpm_width   :  natural  );
   port(
      aclr  :  in std_logic := '0';
      aconst   :  in std_logic := '0';
      aset  :  in std_logic := '0';
      data  :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      gate  :  in std_logic;
      q  :  out std_logic_vector(LPM_WIDTH-1 downto 0)
   );
end component;

component lpm_ff
   generic (
      lpm_avalue  :  natural := 0;
      lpm_fftype  :  string := "DFF";
      lpm_hint :  string := "UNUSED";
      lpm_svalue  :  natural := 0; 
		lpm_type: string := L_FF;
      lpm_width   :  natural  );
   port(
      aclr  :  in std_logic := '0';
      aload :  in std_logic := '0';
      aset  :  in std_logic := '0';
      clock :  in std_logic;
      data  :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      enable   :  in std_logic := '1';
      q  :  out std_logic_vector(LPM_WIDTH-1 downto 0);
      sclr  :  in std_logic := '0';
      sload :  in std_logic := '0';
      sset  :  in std_logic := '0'
   );
end component;

component lpm_shiftreg
   generic (
      lpm_avalue  :  string := "UNUSED";
      lpm_direction  :  string := "LEFT";
      lpm_hint :  string := "UNUSED";
      lpm_svalue  :  string := "UNUSED";
		lpm_type: string := L_SHIFTREG;
      lpm_width   :  natural  );
   port(
      aclr  :  in std_logic := '0'; 
      aset  :  in std_logic := '0';
      clock :  in std_logic;
      data  :  in std_logic_vector(LPM_WIDTH-1 downto 0) := (others => '0');
      enable   :  in std_logic := '1';
      load  :  in std_logic := '0';
      q  :  out std_logic_vector(LPM_WIDTH-1 downto 0);
      sclr  :  in std_logic := '0';
      shiftin  :  in std_logic := '1';
      shiftout :  out std_logic;
      sset  :  in std_logic := '0'
   );
end component;


component lpm_ram_dq
        generic (lpm_width : natural;    -- MUST be greater than 0
                 lpm_widthad : natural;    -- MUST be greater than 0
				 lpm_numwords : natural := 0;
				 lpm_indata : string := "REGISTERED";
				 lpm_address_control: string := "REGISTERED";
				 lpm_outdata : string := "REGISTERED";
				 lpm_file : string := "UNUSED";
				 lpm_type : string := L_RAM_DQ;
			     use_eab  : string := "ON";
				 intended_device_family  : string := "UNUSED";
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_vector(lpm_width-1 downto 0);
			  address : in std_logic_vector(lpm_widthad-1 downto 0);
			  inclock : in std_logic := '0';
			  outclock : in std_logic := '0';
			  we : in std_logic;
			  q : out std_logic_vector(lpm_width-1 downto 0));
end component;

component lpm_ram_dp
        generic (lpm_width : natural;    -- MUST be greater than 0
                 lpm_widthad : natural;    -- MUST be greater than 0
				 lpm_numwords : natural := 0;
				 lpm_indata : string := "REGISTERED";
				 lpm_outdata : string := "REGISTERED";
				 lpm_rdaddress_control : string := "REGISTERED";
				 lpm_wraddress_control : string := "REGISTERED";
				 lpm_file : string := "UNUSED";
				 lpm_type : string := L_RAM_DP;
				 use_eab  : string := "ON";
				 intended_device_family  : string := "UNUSED";
				 rden_used  : string := "TRUE";
				 lpm_hint : string := "UNUSED");
		port (rdclock : in std_logic := '0';
			  rdclken : in std_logic := '1';
			  rdaddress : in std_logic_vector(lpm_widthad-1 downto 0);
			  rden : in std_logic := '1';
			  data : in std_logic_vector(lpm_width-1 downto 0);
			  wraddress : in std_logic_vector(lpm_widthad-1 downto 0);
			  wren : in std_logic;
			  wrclock : in std_logic := '0';
			  wrclken : in std_logic := '1';
			  q : out std_logic_vector(lpm_width-1 downto 0));
end component;

component lpm_ram_io
        generic (lpm_width : natural;    -- MUST be greater than 0
                 lpm_widthad : natural;    -- MUST be greater than 0
				 lpm_numwords : natural := 0;
				 lpm_indata : string := "REGISTERED";
				 lpm_address_control : string := "REGISTERED";
				 lpm_outdata : string := "REGISTERED";
				 lpm_file : string := "UNUSED";
				 lpm_type : string := L_RAM_IO;
				 intended_device_family  : string := "UNUSED";
				 use_eab  : string := "ON";
				 lpm_hint : string := "UNUSED");
		port (address : in STD_LOGIC_VECTOR(lpm_widthad-1 downto 0);
			  inclock : in STD_LOGIC := '0';
			  outclock : in STD_LOGIC := '0';
			  memenab : in STD_LOGIC := '1';
			  outenab : in STD_LOGIC := 'Z';
			  we : in STD_LOGIC := 'Z';
			  dio : inout STD_LOGIC_VECTOR(lpm_width-1 downto 0));
end component;

component lpm_rom
        generic (lpm_width : natural;    -- MUST be greater than 0
                 lpm_widthad : natural;    -- MUST be greater than 0
				 lpm_numwords : natural := 0;
				 lpm_address_control : string := "REGISTERED";
				 lpm_outdata : string := "REGISTERED";
				 lpm_file : string;
				 lpm_type : string := L_ROM;
				 intended_device_family  : string := "UNUSED";
				 lpm_hint : string := "UNUSED");
		port (address : in STD_LOGIC_VECTOR(lpm_widthad-1 downto 0);
			  inclock : in STD_LOGIC := '0';
			  outclock : in STD_LOGIC := '0';
			  memenab : in STD_LOGIC := '1';
			  q : out STD_LOGIC_VECTOR(lpm_width-1 downto 0));
end component;

component lpm_fifo
        generic (lpm_width : natural;    -- MUST be greater than 0
                 lpm_widthu : natural := 1;    -- MUST be greater than 0
                 lpm_numwords : natural;    -- MUST be greater than 0
				 lpm_showahead : string := "OFF";
				 lpm_type : string := L_FIFO;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_vector(lpm_width-1 downto 0);
			  clock : in std_logic;
			  wrreq : in std_logic;
			  rdreq : in std_logic;
			  aclr : in std_logic := '0';
			  sclr : in std_logic := '0';
			  q : out std_logic_vector(lpm_width-1 downto 0);
			  usedw : out std_logic_vector(lpm_widthU-1 downto 0);
			  full : out std_logic;
			  empty : out std_logic);
end component;

component lpm_fifo_dc
        generic (lpm_width : natural;    -- MUST be greater than 0
                 lpm_widthu : natural := 1;    -- MUST be greater than 0
                 lpm_numwords : natural;    -- MUST be greater than 0
		 lpm_showahead : string := "OFF";
		 lpm_type : string := L_FIFO_DC;
	         underflow_checking : string := "ON"; 
	         overflow_checking : string := "ON"; 
		 lpm_hint : string := "UNUSED");
		port (data : in std_logic_vector(lpm_width-1 downto 0);
			  wrclock : in std_logic;
			  rdclock : in std_logic;
			  wrreq : in std_logic;
			  rdreq : in std_logic;
			  aclr : in std_logic := '0';
			  q : out std_logic_vector(lpm_width-1 downto 0);
			  wrusedw : out std_logic_vector(lpm_widthU-1 downto 0);
			  rdusedw : out std_logic_vector(lpm_widthU-1 downto 0);
			  wrfull : out std_logic;
			  rdfull : out std_logic;
			  wrempty : out std_logic;
			  rdempty : out std_logic);
end component;


------------------------------------------------------------------------
-- TABLE PRIMITIVES ----------------------------------------------------
------------------------------------------------------------------------

component lpm_ttable
        generic (lpm_widthin : natural;    -- MUST be greater than 0
                 lpm_widthout : natural;    -- MUST be greater than 0
				 lpm_file : string;
				 lpm_truthtype : string := "FD";                 
				 lpm_type : string := L_TTABLE;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_vector(lpm_widthin-1 downto 0);
			  result : out std_logic_vector(lpm_widthout-1 downto 0));
end component;

component lpm_fsm
        generic (lpm_widthin : natural;    -- MUST be greater than 0 
                 lpm_widthout : natural;    -- MUST be greater than 0 
                 lpm_widths : natural := 1;    -- MUST be greater than 0
				 lpm_file : string ; 
				 lpm_pvalue : string := "UNUSED";
				 lpm_avalue : string := "UNUSED";
				 lpm_truthtype : string := "FD";
				 lpm_type : string := L_FSM;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_vector(lpm_widthin-1 downto 0);
			  clock : in std_logic;
			  aset : in std_logic := '0';
			  testenab : in std_logic := '0';
			  testin : in std_logic := '0';
			  testout : out std_logic;
			  state : out std_logic_vector(lpm_widths-1 downto 0);
			  result : out std_logic_vector(lpm_widthout-1 downto 0));
end component;


------------------------------------------------------------------------
-- PAD PRIMITIVES ------------------------------------------------------
------------------------------------------------------------------------

component lpm_inpad
        generic (lpm_width : natural;    -- MUST be greater than 0
				 lpm_type : string := L_INPAD;
				 lpm_hint : string := "UNUSED");
		port (pad : in std_logic_vector(lpm_width-1 downto 0);
			  result : out std_logic_vector(lpm_width-1 downto 0));
end component;

component lpm_outpad
        generic (lpm_width : natural;    -- MUST be greater than 0
				 lpm_type : string := L_OUTPAD;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_vector(lpm_width-1 downto 0);
			  pad : out std_logic_vector(lpm_width-1 downto 0));
end component;

component lpm_bipad
        generic (lpm_width : natural;    -- MUST be greater than 0
				 lpm_type : string := L_BIPAD;
				 lpm_hint : string := "UNUSED");
		port (data : in std_logic_vector(lpm_width-1 downto 0);
			  enable : in std_logic;
			  result : out std_logic_vector(lpm_width-1 downto 0);
			  pad : inout std_logic_vector(lpm_width-1 downto 0));
end component;

COMPONENT pipeline_internal_fv
	generic (
		data_width : natural := 1;
		latency : natural := 2
	);
	port (
		clk : in std_logic;
		ena : in std_logic;
		clr : in std_logic;
		d   : in  std_logic_vector(data_width-1 DOWNTO 0);
		piped : out std_logic_vector(data_width-1 DOWNTO 0)
	);
END COMPONENT;

end;


PACKAGE BODY lpm_components IS
    function str_to_int( s : string ) return integer is
	variable len : integer := s'length;
	variable ivalue : integer := 0;
	variable digit : integer;
	begin
        for i in 1 to len loop
			case s(i) is
				when '0' =>
					digit := 0;
				when '1' =>
					digit := 1;
				when '2' =>
					digit := 2;
				when '3' =>
					digit := 3;
				when '4' =>
					digit := 4;
				when '5' =>
					digit := 5;
				when '6' =>
					digit := 6;
				when '7' =>
					digit := 7;
				when '8' =>
					digit := 8;
				when '9' =>
					digit := 9;
				when others =>
					ASSERT FALSE
					REPORT "Illegal Character "&  s(i) & "in string parameter! "
					SEVERITY ERROR;
			end case;
			ivalue := ivalue * 10 + digit;
		end loop;
		return ivalue;
	end;

	function to_int (arg : in std_logic_vector) return integer is
	variable result : integer := 0;
	begin
		result := 0;
		for i in arg'range loop
			if arg(i) = '1' then
				result := result + 2**i;
			end if;
		end loop;
		return result;
	end to_int;
end;
