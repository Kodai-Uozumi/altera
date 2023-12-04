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
-- Quartus II 9.0 Build 235 03/01/2009

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

package flex6k_atom_pack is

function str_to_bin (lut_mask : string ) return std_logic_vector;

function product(list : std_logic_vector) return std_logic ;

function alt_conv_integer(arg : in std_logic_vector) return integer;

-- default generic values
   CONSTANT DefWireDelay        : VitalDelayType01      := (0 ns, 0 ns);
   CONSTANT DefPropDelay01      : VitalDelayType01      := (0 ns, 0 ns);
   CONSTANT DefPropDelay01Z     : VitalDelayType01Z     := (OTHERS => 0 ns);
   CONSTANT DefSetupHoldCnst    : TIME := 0 ns;
   CONSTANT DefPulseWdthCnst    : TIME := 0 ns;

-- default control options
-- CONSTANT DefGlitchMode       : VitalGlitchKindType   := OnEvent;
-- change default delay type to Transport : for spr 68748
   CONSTANT DefGlitchMode       : VitalGlitchKindType   := VitalTransport;
   CONSTANT DefGlitchMsgOn      : BOOLEAN       := FALSE;
   CONSTANT DefGlitchXOn        : BOOLEAN       := FALSE;
   CONSTANT DefMsgOnChecks      : BOOLEAN       := TRUE;
   CONSTANT DefXOnChecks        : BOOLEAN       := TRUE;

-- output strength mapping
--  UX01ZWHL-
   CONSTANT PullUp      : VitalOutputMapType    := "UX01HX01X";
   CONSTANT NoPullUpZ   : VitalOutputMapType    := "UX01ZX01X";
   CONSTANT PullDown    : VitalOutputMapType    := "UX01LX01X";

-- primitive result strength mapping
   CONSTANT wiredOR     : VitalResultMapType    := ( 'U', 'X', 'L', '1' );
   CONSTANT wiredAND    : VitalResultMapType    := ( 'U', 'X', '0', 'H' );
   CONSTANT L : VitalTableSymbolType := '0';
   CONSTANT H : VitalTableSymbolType := '1';
   CONSTANT x : VitalTableSymbolType := '-';
   CONSTANT S : VitalTableSymbolType := 'S';
   CONSTANT R : VitalTableSymbolType := '/';
   CONSTANT U : VitalTableSymbolType := 'X';
   CONSTANT V : VitalTableSymbolType := 'B'; -- valid clock signal (non-rising)

-- Declare array types for CAM_SLICE
   TYPE apex20ke_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
   TYPE mercury_mem_data IS ARRAY (0 to 63) of STD_LOGIC_VECTOR (31 downto 0);

end flex6k_atom_pack;

library IEEE;
use IEEE.std_logic_1164.all;

package body flex6k_atom_pack is

type masklength is array (4 downto 1) of std_logic_vector(3 downto 0);

function str_to_bin (lut_mask : string) return std_logic_vector is
	variable slice : masklength := (OTHERS => "0000");
	variable mask : std_logic_vector(15 downto 0);

	begin
     	for i in 1 to lut_mask'length loop
        case lut_mask(i) is
          when '0' => slice(i) := "0000";
          when '1' => slice(i) := "0001";
          when '2' => slice(i) := "0010";
          when '3' => slice(i) := "0011";
          when '4' => slice(i) := "0100";
          when '5' => slice(i) := "0101";
          when '6' => slice(i) := "0110";
          when '7' => slice(i) := "0111";
          when '8' => slice(i) := "1000";
          when '9' => slice(i) := "1001";
          when 'a' => slice(i) := "1010";
          when 'A' => slice(i) := "1010";
          when 'b' => slice(i) := "1011";
          when 'B' => slice(i) := "1011";
          when 'c' => slice(i) := "1100";
          when 'C' => slice(i) := "1100";
          when 'd' => slice(i) := "1101";
          when 'D' => slice(i) := "1101";
          when 'e' => slice(i) := "1110";
          when 'E' => slice(i) := "1110";
          when others => slice(i) := "1111";
        end case;
     end loop;
     mask := (slice(1) & slice(2) & slice(3) & slice(4));
     return (mask);
end str_to_bin;
 
function product (list: std_logic_vector) return std_logic is
	begin
      for i in 0 to 31 loop
           if list(i) = '0' then
             return ('0');
           end if;
      end loop;
      return ('1');
end product;

function alt_conv_integer(arg : in std_logic_vector) return integer is
	variable result : integer;
	begin
  		result := 0;
  		for i in arg'range loop
     			if arg(i) = '1' then
				result := result + 2**i;
     			end if;
  		end loop;
  	return result;
end alt_conv_integer;

end flex6k_atom_pack;

--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for FLEX6K Atoms
--
--/////////////////////////////////////////////////////////////////////////////

--
-- ENTITY mux21
--
library ieee;
use ieee.std_logic_1164.all;

entity mux21 is
     port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end mux21;

architecture structure of mux21 is
begin
   MO <= B when (S = '1') else A;
end structure;

--
-- ENTITY dff_io
--
LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.flex6k_atom_pack.all;

entity dffe_io is
   generic(
      TimingChecksOn: Boolean := True;
      XGenerationOn: Boolean := False;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOnChecks: Boolean := DefXOnChecks;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      InstancePath: STRING := "*";
      tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge     :   VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge     :   VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge   :   VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of dffe_io : entity is TRUE;
end dffe_io;

-- architecture body --

architecture behave of dffe_io is
   attribute VITAL_LEVEL0 of behave : architecture is TRUE;

   signal D_ipd  : STD_ULOGIC := 'U';
   signal CLRN_ipd       : STD_ULOGIC := 'U';
   signal PRN_ipd        : STD_ULOGIC := 'U';
   signal CLK_ipd        : STD_ULOGIC := 'U';
   signal ENA_ipd        : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (D_ipd, D, tipd_D);
   VitalWireDelay (CLRN_ipd, CLRN, tipd_CLRN);
   VitalWireDelay (PRN_ipd, PRN, tipd_PRN);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (D_ipd, CLRN_ipd, PRN_ipd, CLK_ipd, ENA_ipd)

   -- timing check results
   VARIABLE Tviol_D_CLK : STD_ULOGIC := '0';
   VARIABLE Tviol_ENA_CLK       : STD_ULOGIC := '0';
   VARIABLE TimingData_D_CLK : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE TimingData_ENA_CLK : VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(0 to 7);
   VARIABLE D_delayed : STD_ULOGIC := 'U';
   VARIABLE CLK_delayed : STD_ULOGIC := 'U';
   VARIABLE ENA_delayed : STD_ULOGIC := 'U';
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');

   -- output glitch detection variables
   VARIABLE Q_VitalGlitchData   : VitalGlitchDataType;


   CONSTANT dffe_Q_tab : VitalStateTableType := (
    ( L,  L,  x,  x,  x,  x,  x,  x,  x,  L ),
    ( L,  H,  L,  H,  H,  x,  x,  H,  x,  H ),
    ( L,  H,  L,  H,  x,  L,  x,  H,  x,  H ),
    ( L,  H,  L,  x,  H,  H,  x,  H,  x,  H ),
    ( L,  H,  H,  x,  x,  x,  H,  x,  x,  S ),
    ( L,  H,  x,  x,  x,  x,  L,  x,  x,  H ),
    ( L,  H,  x,  x,  x,  x,  H,  L,  x,  S ),
    ( L,  x,  L,  L,  L,  x,  H,  H,  x,  L ),
    ( L,  x,  L,  L,  x,  L,  H,  H,  x,  L ),
    ( L,  x,  L,  x,  L,  H,  H,  H,  x,  L ));
   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
                Violation       => Tviol_D_CLK,
                TimingData      => TimingData_D_CLK,
                TestSignal      => D_ipd,
                TestSignalName  => "D",
                RefSignal       => CLK_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_D_CLK_noedge_posedge,
                SetupLow        => tsetup_D_CLK_noedge_posedge,
                HoldHigh        => thold_D_CLK_noedge_posedge,
                HoldLow         => thold_D_CLK_noedge_posedge,
                CheckEnabled    => TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) OR ( (NOT ENA_ipd) )) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/DFFE",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_ENA_CLK,
                TimingData      => TimingData_ENA_CLK,
                TestSignal      => ENA_ipd,
                TestSignalName  => "ENA",
                RefSignal       => CLK_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ENA_CLK_noedge_posedge,
                SetupLow        => tsetup_ENA_CLK_noedge_posedge,
                HoldHigh        => thold_ENA_CLK_noedge_posedge,
                HoldLow         => thold_ENA_CLK_noedge_posedge,
                CheckEnabled    => TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/DFFE",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_D_CLK or Tviol_ENA_CLK;
      VitalStateTable(
        StateTable => dffe_Q_tab,
        DataIn => (
                Violation, CLRN_ipd, CLK_delayed, Results(1), D_delayed, ENA_delayed, PRN_ipd, CLK_ipd),
        Result => Results,
        NumStates => 1,
        PreviousDataIn => PrevData_Q);
      D_delayed := D_ipd;
      CLK_delayed := CLK_ipd;
      ENA_delayed := ENA_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       OutSignalName => "Q",
       OutTemp => Results(1),
       Paths => (0 => (PRN_ipd'last_event, tpd_PRN_Q_negedge, TRUE),
                 1 => (CLRN_ipd'last_event, tpd_CLRN_Q_negedge, TRUE),
                 2 => (CLK_ipd'last_event, tpd_CLK_Q_posedge, TRUE)),
       GlitchData => Q_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;

end behave;

--
-- ENTITY flex6k_asynch_lcell
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.flex6k_atom_pack.all;

entity flex6k_asynch_lcell is
  	generic (operation_mode    : string := "normal";
      	output_mode   : string := "comb_and_reg";
      	lut_mask       : string := "ffff";
      	power_up : string := "low";
      	cin_used       : string := "false";
      	TimingChecksOn: Boolean := True;
	      MsgOn: Boolean := DefGlitchMsgOn;
      	XOn: Boolean := DefGlitchXOn;
	      MsgOnChecks: Boolean := DefMsgOnChecks;
      	XOnChecks: Boolean := DefXOnChecks;
      	InstancePath: STRING := "*";

      	tpd_dataa_combout	 : VitalDelayType01 := DefPropDelay01;
	      tpd_datab_combout  : VitalDelayType01 := DefPropDelay01;
      	tpd_datac_combout  : VitalDelayType01 := DefPropDelay01;
	      tpd_datad_combout  : VitalDelayType01 := DefPropDelay01;
      	tpd_qfbkin_combout : VitalDelayType01 := DefPropDelay01;
      	tpd_cin_combout    : VitalDelayType01 := DefPropDelay01;
      	tpd_cascin_combout : VitalDelayType01 := DefPropDelay01;
      	
		tpd_dataa_regin    : VitalDelayType01 := DefPropDelay01;
      	tpd_datab_regin    : VitalDelayType01 := DefPropDelay01;
      	tpd_datac_regin    : VitalDelayType01 := DefPropDelay01;
      	tpd_datad_regin    : VitalDelayType01 := DefPropDelay01;
	      tpd_qfbkin_regin   : VitalDelayType01 := DefPropDelay01;
      	tpd_cin_regin      : VitalDelayType01 := DefPropDelay01;
	      tpd_cascin_regin   : VitalDelayType01 := DefPropDelay01;
      
		tpd_dataa_cout	 : VitalDelayType01 := DefPropDelay01;
      	tpd_datab_cout	 : VitalDelayType01 := DefPropDelay01;
	      tpd_datac_cout     : VitalDelayType01 := DefPropDelay01;
      	tpd_datad_cout     : VitalDelayType01 := DefPropDelay01;
	      tpd_qfbkin_cout    : VitalDelayType01 := DefPropDelay01;
     		tpd_cin_cout	 : VitalDelayType01 := DefPropDelay01;
      
		tpd_cascin_cascout : VitalDelayType01 := DefPropDelay01;
      	tpd_cin_cascout    : VitalDelayType01 := DefPropDelay01;
      	tpd_dataa_cascout	 : VitalDelayType01 := DefPropDelay01;
     		tpd_datab_cascout	 : VitalDelayType01 := DefPropDelay01;
      	tpd_datac_cascout  : VitalDelayType01 := DefPropDelay01;
      	tpd_datad_cascout  : VitalDelayType01 := DefPropDelay01;
      	tpd_qfbkin_cascout : VitalDelayType01 := DefPropDelay01;
      
		tipd_dataa		 : VitalDelayType01 := DefPropDelay01; 
      	tipd_datab		 : VitalDelayType01 := DefPropDelay01; 
      	tipd_datac		 : VitalDelayType01 := DefPropDelay01; 
      	tipd_datad		 : VitalDelayType01 := DefPropDelay01; 
      	tipd_cin  		 : VitalDelayType01 := DefPropDelay01; 
      	tipd_cascin		 : VitalDelayType01 := DefPropDelay01 );

  port (
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        cin       : in std_logic := '0';
        cascin    : in std_logic := '1';
        qfbkin    : in std_logic := '0';
        combout   : out std_logic;
        cout      : out std_logic;
        cascout   : out std_logic;
        regin     : out std_logic);

   attribute VITAL_LEVEL0 of flex6k_asynch_lcell : entity is TRUE;
end flex6k_asynch_lcell;
        
architecture vital_le of flex6k_asynch_lcell is
	attribute VITAL_LEVEL0 of vital_le : architecture is TRUE;
   	signal dataa_ipd, datab_ipd : std_logic;
	signal datac_ipd, datad_ipd, cin_ipd : std_logic;
	signal cascin_ipd : std_logic := '1';
	begin
		---------------------
	   	--  INPUT PATH DELAYs
   		---------------------
	   	WireDelay : block
   		begin
   			VitalWireDelay (dataa_ipd, dataa, tipd_dataa);
   			VitalWireDelay (datab_ipd, datab, tipd_datab);
			VitalWireDelay (datac_ipd, datac, tipd_datac);
			VitalWireDelay (datad_ipd, datad, tipd_datad);
   			VitalWireDelay (cin_ipd, cin, tipd_cin);
   			VitalWireDelay (cascin_ipd, cascin, tipd_cascin);
   		end block;

VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd, cin_ipd, cascin_ipd, qfbkin)
	variable combout_VitalGlitchData	: VitalGlitchDataType;
	variable cout_VitalGlitchData		: VitalGlitchDataType;
	variable cascout_VitalGlitchData 	: VitalGlitchDataType;
	variable regin_VitalGlitchData 	: VitalGlitchDataType;

	variable icomb, icomb1, icout : std_logic;
	variable idata, setbit : std_logic := '0';
	variable tmp_combout, tmp_cout, tmp_regin : std_logic;
	variable tmp_cascout : std_logic := '1';
	variable lut_mask_std : std_logic_vector (15 downto 0) :=  str_to_bin(lut_mask); -- Added By ModelTech

	begin
		if operation_mode = "normal" then
			if cin_used = "true" then
				icomb1 := VitalMUX(data => lut_mask_std,
                		dselect => (datad_ipd, cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
			else
				icomb1 := VitalMUX(data => lut_mask_std,
                		dselect => (datad_ipd, datac_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
			end if;
			icomb := icomb1 and cascin_ipd;
		end if;

		if operation_mode = "arithmetic" then
			icomb1 := VitalMUX(data => lut_mask_std,
                  dselect => ('1', cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
			icout := VitalMUX(data => lut_mask_std,
                  dselect => ('0', cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
			icomb := icomb1 and cascin_ipd;
		end if;

		if operation_mode = "counter" then
			icomb1 := VitalMUX(data => lut_mask_std,
                  dselect => ('1', cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
			icout := VitalMUX(data => lut_mask_std,
                  dselect => ('0', cin_ipd, datab_ipd, dataa_ipd)); -- Added By ModelTech
			icomb := icomb1 and cascin_ipd;
		end if;

		if operation_mode = "qfbk_counter" then
			icomb1 := VitalMUX(data => lut_mask_std,
                  dselect => ('1', qfbkin, datab_ipd, dataa_ipd)); -- Added By ModelTech
			icout := VitalMUX(data => lut_mask_std,
                  dselect => ('0', qfbkin, datab_ipd, dataa_ipd)); -- Added By ModelTech
			icomb := icomb1 and cascin_ipd;
		end if;

		tmp_combout := icomb;
		tmp_cascout := icomb;
		tmp_cout := icout;
        	tmp_regin := icomb;

      	----------------------
      	--  Path Delay Section
      	----------------------
      	VitalPathDelay01 (
			OutSignal => combout,
		      OutSignalName => "COMBOUT",
       		OutTemp => tmp_combout,
       		Paths => (
			0 => (dataa_ipd'last_event, tpd_dataa_combout, TRUE),
                 	1 => (datab_ipd'last_event, tpd_datab_combout, TRUE),
                 	2 => (datac_ipd'last_event, tpd_datac_combout, TRUE),
                 	3 => (datad_ipd'last_event, tpd_datad_combout, TRUE),
                 	4 => (cin_ipd'last_event, tpd_cin_combout, TRUE),
                 	5 => (cascin_ipd'last_event, tpd_cascin_combout, TRUE),
                 	6 => (qfbkin'last_event, tpd_qfbkin_combout, TRUE)
			),
		      GlitchData => combout_VitalGlitchData,
       		Mode => DefGlitchMode,
       		XOn  => XOn,
       		MsgOn => MsgOn );

      	VitalPathDelay01 (
       		OutSignal => regin,
       		OutSignalName => "REGIN",
       		OutTemp => tmp_regin,
       		Paths => (
			0 => (dataa_ipd'last_event, tpd_dataa_regin, TRUE),
                 	1 => (datab_ipd'last_event, tpd_datab_regin, TRUE),
                 	2 => (datac_ipd'last_event, tpd_datac_regin, TRUE),
                 	3 => (datad_ipd'last_event, tpd_datad_regin, TRUE),
                 	4 => (cin_ipd'last_event, tpd_cin_regin, TRUE),
                 	5 => (cascin_ipd'last_event, tpd_cascin_regin, TRUE),
                 	6 => (qfbkin'last_event, tpd_qfbkin_regin, TRUE)
			),
       		GlitchData => regin_VitalGlitchData,
       		Mode => DefGlitchMode,
       		XOn  => XOn,
       		MsgOn => MsgOn );

      	VitalPathDelay01 ( 
       		OutSignal => cascout, 
       		OutSignalName => "CASCOUT",
       		OutTemp => tmp_cascout,
       		Paths => (
			0 => (dataa_ipd'last_event, tpd_dataa_cascout, TRUE),
                 	1 => (datab_ipd'last_event, tpd_datab_cascout, TRUE),
                 	2 => (datac_ipd'last_event, tpd_datac_cascout, TRUE),
                 	3 => (datad_ipd'last_event, tpd_datad_cascout, TRUE),
                 	4 => (cin_ipd'last_event, tpd_cin_cascout, TRUE),
                 	5 => (cascin_ipd'last_event, tpd_cascin_cascout, TRUE),
                 	6 => (qfbkin'last_event, tpd_qfbkin_cascout, TRUE)
			),
       		GlitchData => cascout_VitalGlitchData,    
       		Mode => DefGlitchMode, 
       		XOn  => XOn, 
       		MsgOn => MsgOn );

      	VitalPathDelay01 ( 
       		OutSignal => cout, 
       		OutSignalName => "COUT",
       		OutTemp => tmp_cout,
       		Paths => (
			0 => (dataa_ipd'last_event, tpd_dataa_cout, TRUE),
                 	1 => (datab_ipd'last_event, tpd_datab_cout, TRUE),
                 	2 => (datac_ipd'last_event, tpd_datac_cout, TRUE),
                 	3 => (datad_ipd'last_event, tpd_datad_cout, TRUE),
                 	4 => (cin_ipd'last_event, tpd_cin_cout, TRUE),
                 	5 => (qfbkin'last_event, tpd_qfbkin_cout, TRUE)
			),
       		GlitchData => cout_VitalGlitchData,    
       		Mode => DefGlitchMode, 
       		XOn  => XOn, 
       		MsgOn => MsgOn );

end process;

end vital_le;	

--
-- ENTITY flex6k_lcell_register
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.flex6k_atom_pack.all;

entity flex6k_lcell_register is
  generic (
      power_up : string := "low";
      packed_mode   : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";

      tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;

      thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      thold_sclr_clk_noedge_posedge		: VitalDelayType := DefSetupHoldCnst;
      thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;

      tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
     
	tpd_clk_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
      tpd_aclr_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
      
	tperiod_clk_posedge           : VitalDelayType := DefPulseWdthCnst;
      
	tipd_datac  			: VitalDelayType01 := DefPropDelay01; 
      tipd_aclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sclr 			: VitalDelayType01 := DefPropDelay01; 
      tipd_sload 			: VitalDelayType01 := DefPropDelay01; 
      tipd_clk  			: VitalDelayType01 := DefPropDelay01);

  port (clk 	:in std_logic;
        datain  	: in std_logic := '1';
        datac     : in std_logic := '1';
        aclr    	: in std_logic := '0';
        sclr 	: in std_logic := '0';
        sload 	: in std_logic := '0';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic;
        qfbko     : out std_logic);

 attribute VITAL_LEVEL0 of flex6k_lcell_register : entity is TRUE;
end flex6k_lcell_register;
        
architecture vital_le_reg of flex6k_lcell_register is
	attribute VITAL_LEVEL0 of vital_le_reg : architecture is TRUE;
   	signal sload_ipd, datac_ipd : std_logic;
   	signal clk_ipd, aclr_ipd, sclr_ipd : std_logic;
	begin
		---------------------
   		--  INPUT PATH DELAYs
   		---------------------
   		WireDelay : block
   		begin
   			VitalWireDelay (datac_ipd, datac, tipd_datac);
		   	VitalWireDelay (clk_ipd, clk, tipd_clk);
   			VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
   			VitalWireDelay (sclr_ipd, sclr, tipd_sclr);
   			VitalWireDelay (sload_ipd, sload, tipd_sload);
		end block;

	VITALtiming : process(clk_ipd, aclr_ipd, devclrn, devpor, datain)
		variable Tviol_datain_clk : std_ulogic := '0';
		variable Tviol_datac_clk : std_ulogic := '0';
		variable Tviol_sclr_clk : std_ulogic := '0';
		variable Tviol_sload_clk : std_ulogic := '0';
		variable Tviol_clk : std_ulogic := '0';
		
		variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
		variable TimingData_datac_clk : VitalTimingDataType := VitalTimingDataInit;
		variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
		variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
		variable PeriodData_clk : VitalPeriodDataType := VitalPeriodDataInit;
		variable regout_VitalGlitchData : VitalGlitchDataType;
		variable qfbko_VitalGlitchData : VitalGlitchDataType;

		variable iregout : std_logic;
		variable idata, setbit : std_logic := '0';
		variable tmp_regout : std_logic;
		variable tmp_qfbko : std_logic;

		begin
	      if (now = 0 ns) then
      		if (power_up = "low") then
            		iregout := '0';
         		elsif (power_up = "high") then
            		iregout := '1';
         		end if;
      	end if;

	      ------------------------
      	--  Timing Check Section
      	------------------------
      	if (TimingChecksOn) then
	      	VitalSetupHoldCheck (
                		Violation       => Tviol_datain_clk,
                		TimingData      => TimingData_datain_clk,
                		TestSignal      => datain,
                		TestSignalName  => "DATAIN",
                		RefSignal       => clk_ipd,
                		RefSignalName   => "CLK",
                		SetupHigh       => tsetup_datain_clk_noedge_posedge,
                		SetupLow        => tsetup_datain_clk_noedge_posedge,
                		HoldHigh        => thold_datain_clk_noedge_posedge,
                		HoldLow         => thold_datain_clk_noedge_posedge,
                		CheckEnabled    => TO_X01(aclr_ipd) /= '1',
                		RefTransition   => '/',
                		HeaderMsg       => InstancePath & "/LCELL",
                		XOn             => XOnChecks,
                		MsgOn           => MsgOnChecks );

         		VitalSetupHoldCheck (
                		Violation       => Tviol_datac_clk,
                		TimingData      => TimingData_datac_clk,
                		TestSignal      => datac_ipd,
                		TestSignalName  => "DATAC",
                		RefSignal       => clk_ipd,
                		RefSignalName   => "CLK",
                		SetupHigh       => tsetup_datac_clk_noedge_posedge,
                		SetupLow        => tsetup_datac_clk_noedge_posedge,
                		HoldHigh        => thold_datac_clk_noedge_posedge,
                		HoldLow         => thold_datac_clk_noedge_posedge,
                		CheckEnabled    => TO_X01(aclr_ipd) /= '1',
                		RefTransition   => '/',
                		HeaderMsg       => InstancePath & "/LCELL",
                		XOn             => XOnChecks,
               	 	MsgOn           => MsgOnChecks );


         		VitalSetupHoldCheck (
                		Violation       => Tviol_sclr_clk,
                		TimingData      => TimingData_sclr_clk,
                		TestSignal      => sclr_ipd,
                		TestSignalName  => "SCLR",
                		RefSignal       => clk_ipd,
                		RefSignalName   => "CLK",
                		SetupHigh       => tsetup_sclr_clk_noedge_posedge,
                		SetupLow        => tsetup_sclr_clk_noedge_posedge,
                		HoldHigh        => thold_sclr_clk_noedge_posedge,
                		HoldLow         => thold_sclr_clk_noedge_posedge,
                		CheckEnabled    => TO_X01(aclr_ipd) /= '1',
                		RefTransition   => '/',
                		HeaderMsg       => InstancePath & "/LCELL",
                		XOn             => XOnChecks,
                		MsgOn           => MsgOnChecks );

         		VitalSetupHoldCheck (
                		Violation       => Tviol_sload_clk,
                		TimingData      => TimingData_sload_clk,
                		TestSignal      => sload_ipd,
                		TestSignalName  => "SLOAD",
                		RefSignal       => clk_ipd,
                		RefSignalName   => "CLK",
                		SetupHigh       => tsetup_sload_clk_noedge_posedge,
                		SetupLow        => tsetup_sload_clk_noedge_posedge,
                		HoldHigh        => thold_sload_clk_noedge_posedge,
                		HoldLow         => thold_sload_clk_noedge_posedge,
                		CheckEnabled    => TO_X01(aclr_ipd) /= '1',
                		RefTransition   => '/',
                		HeaderMsg       => InstancePath & "/LCELL",
                		XOn             => XOnChecks,
                		MsgOn           => MsgOnChecks );

			VitalPeriodPulseCheck (
                 		Violation       => Tviol_clk,
                 		PeriodData      => PeriodData_clk,
                 		TestSignal      => clk_ipd,
                 		TestSignalName  => "CLK",
                 		Period          => tperiod_clk_posedge,
                 		CheckEnabled    => TO_X01(aclr_ipd) /= '1',
                 		HeaderMsg       => InstancePath & "/PTERM",
                 		XOn             => XOnChecks,
                 		MsgOn           => MsgOnChecks );
 	      end if;

	if (devpor = '0') then
      	if (power_up = "low") then
            	iregout := '0';
         	elsif (power_up = "high") then
            	iregout := '1';
         	end if;
      elsif (devclrn = '0') then
         	iregout := '0';
     	elsif (aclr_ipd = '1') then
		iregout := '0';
      elsif clk_ipd'event and clk_ipd = '1' then
		if (sclr_ipd = '1') then
			iregout := '0';
		elsif (sload_ipd = '1') then
			iregout := datac_ipd;
		else
			if packed_mode = "true" then
				iregout := datac_ipd;
			else
				iregout := datain;
			end if;
		end if;
	end if;
     --end if;

     tmp_regout := iregout;
     tmp_qfbko := iregout;
     ----------------------
     --  Path Delay Section
     ----------------------
     	VitalPathDelay01 (
     		OutSignal => regout,
       	OutSignalName => "REGOUT",
       	OutTemp => tmp_regout,
       	Paths => (
				0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
	                  1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
       	GlitchData => qfbko_VitalGlitchData,
       	Mode => DefGlitchMode,
       	XOn  => XOn,
       	MsgOn  => MsgOn );

      VitalPathDelay01 (
       	OutSignal => qfbko,
       	OutSignalName => "QFBKO",
       	OutTemp => tmp_qfbko,
       	Paths => (
				0 => (aclr_ipd'last_event, tpd_aclr_qfbko_posedge, TRUE),
                 		1 => (clk_ipd'last_event, tpd_clk_qfbko_posedge, TRUE)),
       	GlitchData => regout_VitalGlitchData,
       	Mode => DefGlitchMode,
       	XOn  => XOn,
       	MsgOn  => MsgOn );
end process;
end vital_le_reg;	

--
-- ENTITY flex6k_lcell
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.flex6k_atom_pack.all;
use work.flex6k_asynch_lcell;
use work.flex6k_lcell_register;

entity flex6k_lcell is
	generic (operation_mode    : string := "normal";
      	output_mode   : string := "comb_and_reg";
      	packed_mode   : string := "false";
      	lut_mask      : string := "ffff";
      	power_up 	  : string := "low";
      	cin_used      : string := "false");

	port (clk	: in std_logic;
      dataa     	: in std_logic := '1';
      datab       : in std_logic := '1';
      datac       : in std_logic := '1';
      datad       : in std_logic := '1';
      aclr        : in std_logic := '0';
      sclr 		: in std_logic := '0';
      sload 	: in std_logic := '0';
      cin         : in std_logic := '0';
      cascin      : in std_logic := '1';
      devclrn     : in std_logic := '1';
      devpor      : in std_logic := '1';
      combout     : out std_logic;
      regout      : out std_logic;
      cout		: out std_logic;
      cascout     : out std_logic);
end flex6k_lcell;
        
architecture vital_le_atom of flex6k_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

component flex6k_asynch_lcell 
  	generic (operation_mode    : string := "normal";
      	output_mode   : string := "comb_and_reg";
      	lut_mask       : string := "ffff";
      	power_up : string := "low";
      	cin_used       : string := "false";
      	TimingChecksOn: Boolean := True;
      	MsgOn: Boolean := DefGlitchMsgOn;
      	XOn: Boolean := DefGlitchXOn;
      	MsgOnChecks: Boolean := DefMsgOnChecks;
      	XOnChecks: Boolean := DefXOnChecks;
      	InstancePath: STRING := "*";
      
		tpd_dataa_combout		: VitalDelayType01 := DefPropDelay01;
      	tpd_datab_combout       : VitalDelayType01 := DefPropDelay01;
      	tpd_datac_combout       : VitalDelayType01 := DefPropDelay01;
      	tpd_datad_combout       : VitalDelayType01 := DefPropDelay01;
      	tpd_qfbkin_combout      : VitalDelayType01 := DefPropDelay01;
      	tpd_cin_combout 		: VitalDelayType01 := DefPropDelay01;
      	tpd_cascin_combout      : VitalDelayType01 := DefPropDelay01;
      
		tpd_dataa_regin         : VitalDelayType01 := DefPropDelay01;
      	tpd_datab_regin         : VitalDelayType01 := DefPropDelay01;
      	tpd_datac_regin         : VitalDelayType01 := DefPropDelay01;
      	tpd_datad_regin         : VitalDelayType01 := DefPropDelay01;
      	tpd_qfbkin_regin        : VitalDelayType01 := DefPropDelay01;
      	tpd_cin_regin           : VitalDelayType01 := DefPropDelay01;
     	 	tpd_cascin_regin  	: VitalDelayType01 := DefPropDelay01;
      
		tpd_dataa_cout	      : VitalDelayType01 := DefPropDelay01;
      	tpd_datab_cout	      : VitalDelayType01 := DefPropDelay01;
      	tpd_datac_cout    	: VitalDelayType01 := DefPropDelay01;
      	tpd_datad_cout    	: VitalDelayType01 := DefPropDelay01;
     		tpd_qfbkin_cout         : VitalDelayType01 := DefPropDelay01;
      	tpd_cin_cout		: VitalDelayType01 := DefPropDelay01;
      	
		tpd_cascin_cascout	: VitalDelayType01 := DefPropDelay01;
	      tpd_cin_cascout    	: VitalDelayType01 := DefPropDelay01;
      	tpd_dataa_cascout	      : VitalDelayType01 := DefPropDelay01;
     	 	tpd_datab_cascout	      : VitalDelayType01 := DefPropDelay01;
      	tpd_datac_cascout    	: VitalDelayType01 := DefPropDelay01;
      	tpd_datad_cascout    	: VitalDelayType01 := DefPropDelay01;
      	tpd_qfbkin_cascout      : VitalDelayType01 := DefPropDelay01;
     
		tipd_dataa			: VitalDelayType01 := DefPropDelay01; 
      	tipd_datab			: VitalDelayType01 := DefPropDelay01; 
      	tipd_datac			: VitalDelayType01 := DefPropDelay01; 
      	tipd_datad			: VitalDelayType01 := DefPropDelay01; 
     		tipd_cin  			: VitalDelayType01 := DefPropDelay01; 
      	tipd_cascin			: VitalDelayType01 := DefPropDelay01); 

	port (
      	dataa     : in std_logic := '1';
        	datab     : in std_logic := '1';
        	datac     : in std_logic := '1';
        	datad     : in std_logic := '1';
        	cin       : in std_logic := '0';
        	cascin    : in std_logic := '1';
        	qfbkin    : in std_logic := '0';
        	combout   : out std_logic;
        	cout      : out std_logic;
        	cascout   : out std_logic;
        	regin     : out std_logic);
end component;

component flex6k_lcell_register
	generic (
      	power_up : string := "low";
      	packed_mode   : string := "false";
      	TimingChecksOn: Boolean := True;
      	MsgOn: Boolean := DefGlitchMsgOn;
      	XOn: Boolean := DefGlitchXOn;
      	MsgOnChecks: Boolean := DefMsgOnChecks;
      	XOnChecks: Boolean := DefXOnChecks;
      	InstancePath: STRING := "*";
      	
		tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      	tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      	tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      	tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      
	      thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      	thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      	thold_sclr_clk_noedge_posedge		: VitalDelayType := DefSetupHoldCnst;
      	thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
      
	      tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      	tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
      	tpd_clk_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
      	tpd_aclr_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
      	tperiod_clk_posedge           : VitalDelayType := DefPulseWdthCnst;
      
		tipd_datac  			: VitalDelayType01 := DefPropDelay01; 
            tipd_aclr 			: VitalDelayType01 := DefPropDelay01; 
      	tipd_sclr 			: VitalDelayType01 := DefPropDelay01; 
      	tipd_sload 			: VitalDelayType01 := DefPropDelay01; 
      	tipd_clk  			: VitalDelayType01 := DefPropDelay01);

  port (clk     : in std_logic;
        datain     : in std_logic := '1';
        datac     : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic;
        qfbko     : out std_logic);
end component;

begin
lecomb: flex6k_asynch_lcell
	generic map (
		operation_mode => operation_mode, 
		output_mode => output_mode,
            lut_mask => lut_mask, 
		cin_used => cin_used)
      
	port map (
		dataa => dataa, 
		datab => datab, 
		datac => datac, 
		datad => datad,
            cin => cin, 
		cascin => cascin, 
		qfbkin => qfbk, 
            combout => combout, 
		cout => cout, 
		cascout => cascout, 
		regin => dffin);

lereg: flex6k_lcell_register
	generic map (
		power_up => power_up, 
		packed_mode => packed_mode)
  	
	port map (
		clk => clk, 
		datain => dffin, 
		datac => datac, 
            aclr => aclr, 
		sclr => sclr, 
		sload => sload, 
		devclrn => devclrn, 
		devpor => devpor, 
		regout => regout,
            qfbko => qfbk);

end vital_le_atom;

--
--
--  FLEX6K_IO Model
--
--
-- ENTITY flex6k_asynch_io
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.flex6k_atom_pack.all;

entity flex6k_asynch_io is
	generic (
		operation_mode : string := "input";
            	feedback_mode : string := "from_pin";
	    output_enable : string := "false";
            TimingChecksOn: Boolean := True;
      	MsgOn: Boolean := DefGlitchMsgOn;
      	XOn: Boolean := DefGlitchXOn;
      	MsgOnChecks: Boolean := DefMsgOnChecks;
      	XOnChecks: Boolean := DefXOnChecks;
      	InstancePath: STRING := "*";
      
		tpd_datain_padio			     : VitalDelayType01 := DefPropDelay01;
      	tpd_padio_combout                  : VitalDelayType01 := DefPropDelay01;
      	
		tpd_oe_padio_posedge               : VitalDelayType01 := DefPropDelay01;
      	tpd_oe_padio_negedge               : VitalDelayType01 := DefPropDelay01;
      	
		tipd_datain                        : VitalDelayType01 := DefPropDelay01;
      	tipd_oe                            : VitalDelayType01 := DefPropDelay01;
      	tipd_padio                         : VitalDelayType01 := DefPropDelay01);

    port (
		datain : in std_logic;
            oe   : in std_logic;
          	padio  : inout std_logic;
            combout : out std_logic);

attribute VITAL_LEVEL0 of flex6k_asynch_io : entity is TRUE;
end flex6k_asynch_io;

architecture vital_asynch_io of flex6k_asynch_io is
	attribute VITAL_LEVEL0 of vital_asynch_io : architecture is TRUE;
	signal oe_ipd : std_logic;
   	signal datain_ipd, padio_ipd : std_logic;
	begin
   	---------------------
   	--  INPUT PATH DELAYs
   	---------------------
   	WireDelay : block
   	begin
      	VitalWireDelay (datain_ipd, datain, tipd_datain);
      	VitalWireDelay (padio_ipd, padio, tipd_padio);
      	VitalWireDelay (oe_ipd, oe, tipd_oe);
   	end block;

VITALtiming : process(datain_ipd, oe_ipd, padio_ipd)
	variable Tviol_datain_clk : std_ulogic := '0';
	variable Tviol_padio_clk : std_ulogic := '0';
	variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
	variable TimingData_padio_clk : VitalTimingDataType := VitalTimingDataInit;
	variable combout_VitalGlitchData : VitalGlitchDataType;
	variable padio_VitalGlitchData : VitalGlitchDataType;
	
	variable tri_in : std_logic := '0';
	variable tmp_combout, tmp_padio, oe_val, temp : std_logic;
	
	begin
	if ((feedback_mode = "none")) then
		if ((operation_mode = "output") or
		    (operation_mode = "bidir")) then
			tri_in := datain_ipd;
		end if;
	elsif ((feedback_mode = "from_pin")) then
		if (operation_mode = "input") then
			tmp_combout := to_x01z(padio_ipd);
		elsif (operation_mode = "bidir") then
			tmp_combout := to_x01z(padio_ipd);
		      tri_in := datain_ipd;
		end if;
	end if;

	if (operation_mode = "output") then
	   oe_val := to_x01z(oe_ipd);

	   if (oe_val = '0') then
	       temp := 'Z';
	   else
	       temp := tri_in;
	   end if;

	   if (oe_ipd = '1') then
	      tmp_padio := temp;
	   elsif (oe_ipd = '0') then
	      tmp_padio := 'Z';
	   end if;

	elsif ((operation_mode = "bidir")or (operation_mode = "output")) then
	   if ((oe_ipd = '1')) then
	      tmp_padio := tri_in;
	   elsif ((oe_ipd = '0')) then
	      tmp_padio := 'Z';
	   end if;
	   
	else
	   tmp_padio := 'Z';
	end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
      	OutSignal => combout,
       	OutSignalName => "COMBOUT",
       	OutTemp => tmp_combout,
       	Paths => (
			0 => (padio_ipd'last_event, tpd_padio_combout, TRUE)),
       	GlitchData => combout_VitalGlitchData,
       	Mode => DefGlitchMode,
       	XOn  => XOn,
       	MsgOn => MsgOn );

      VitalPathDelay01 ( 
       	OutSignal => padio, 
       	OutSignalName => "PADIO", 
       	OutTemp => tmp_padio,   
       	Paths => (
			1 => (oe_ipd'last_event, tpd_oe_padio_posedge, oe_ipd = '1'), 
	            2 => (oe_ipd'last_event, tpd_oe_padio_negedge, oe_ipd = '0'), 
                  3 => (datain_ipd'last_event, tpd_datain_padio, TRUE)),
       	GlitchData => padio_VitalGlitchData,  
       	Mode => DefGlitchMode, 
       	XOn  => XOn,   
       	MsgOn => MsgOn );
end process;
end vital_asynch_io;

--
--  ENTITY flex6k_io
--
LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.flex6k_atom_pack.all;
use work.flex6k_asynch_io;

entity  flex6k_io is
	generic (
		operation_mode : string := "input";
            feedback_mode : string := "from_pin";
	   power_up : string := "low";
	    output_enable : string := "false");
	
	port (
		datain : in std_logic;
            oe     : in std_logic;
            devclrn   : in std_logic := '1';
          	devpor : in std_logic := '1';
          	devoe  : in std_logic := '0';
          	padio  : inout std_logic;
          	combout : out std_logic);
end flex6k_io;

architecture arch of flex6k_io is
	signal vcc : std_logic := '1';
   	signal comb_out, reg_out : std_logic;

component flex6k_asynch_io
   generic (
	operation_mode : string := "input";
      feedback_mode : string := "from_pin";
      output_enable : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      
	tpd_datain_padio			     : VitalDelayType01 := DefPropDelay01;
      tpd_padio_combout                  : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_posedge               : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_negedge               : VitalDelayType01 := DefPropDelay01;
      tipd_datain                        : VitalDelayType01 := DefPropDelay01;
      tipd_oe                            : VitalDelayType01 := DefPropDelay01;
      tipd_padio                         : VitalDelayType01 := DefPropDelay01);

    port (datain 	: in std_logic;
          oe     	: in std_logic;
          padio  	: inout std_logic;
          combout : out std_logic);
end component;

begin

asynch_inst: flex6k_asynch_io
     generic map (
		operation_mode => operation_mode,
            feedback_mode => feedback_mode, 
	    output_enable => output_enable)
     port map (	
		datain => datain, 
		oe => oe, 
		padio => padio,
            combout => comb_out);

combout <= comb_out;
end arch;

--
-- END of FLEX6K IO
--


