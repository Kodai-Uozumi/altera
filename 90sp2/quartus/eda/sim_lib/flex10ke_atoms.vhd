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

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;

package flex10ke_atom_pack is

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
--   CONSTANT DefGlitchMode       : VitalGlitchKindType   := OnEvent;
-- change default delay type to Transport
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

end flex10ke_atom_pack;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

package body flex10ke_atom_pack is

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

end flex10ke_atom_pack;
--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for FLEX10KE Atoms
--
--/////////////////////////////////////////////////////////////////////////////

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : mux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux21 is
     PORT (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end mux21;

ARCHITECTURE structure of mux21 is
begin
   MO <= B when (S = '1') else A;
end structure;


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;

ENTITY dffe_io is
   GENERIC(
      TimingChecksOn: Boolean := True;
      XGenerationOn: Boolean := False;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOnChecks: Boolean := DefXOnChecks;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      InstancePath: STRING := "*";
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
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   PORT(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of dffe_io : ENTITY is TRUE;
end dffe_io;

-- ARCHITECTURE body --

ARCHITECTURE behave of dffe_io is
   attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;

   signal D_ipd  : STD_ULOGIC := 'U';
   signal CLRN_ipd       : STD_ULOGIC := 'U';
   signal PRN_ipd        : STD_ULOGIC := '1';
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
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (D_ipd, CLRN_ipd, CLK_ipd, ENA_ipd)

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
                CheckEnabled    => TO_X01(( (NOT CLRN_ipd) ) OR ( (NOT ENA_ipd) )) /= '1',
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
                CheckEnabled    => TO_X01(( (NOT CLRN_ipd) ) ) /= '1',
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
       Paths => (0 => (CLRN_ipd'last_event, tpd_CLRN_Q_negedge, TRUE),
                 1 => (CLK_ipd'last_event, tpd_CLK_Q_posedge, TRUE)),
       GlitchData => Q_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;

end behave;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;

ENTITY flex10ke_asynch_lcell is
  GENERIC (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      lut_mask       : string := "ffff";
      cin_used       : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_dataa_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datab_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datac_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datad_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_combout                : VitalDelayType01 := DefPropDelay01;
      tpd_cin_combout                   : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_combout                : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datab_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datac_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datad_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_regin                  : VitalDelayType01 := DefPropDelay01;
      tpd_cin_regin                     : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_regin                  : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout                        : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout                        : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cout                    : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cout                    : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_cout                   : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cout                        : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_cascout                : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cascout                    : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cascout                        : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cascout                        : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cascout                    : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cascout                    : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_cascout                : VitalDelayType01 := DefPropDelay01;
      tipd_dataa                        : VitalDelayType01 := DefPropDelay01; 
      tipd_datab                        : VitalDelayType01 := DefPropDelay01; 
      tipd_datac                        : VitalDelayType01 := DefPropDelay01; 
      tipd_datad                        : VitalDelayType01 := DefPropDelay01; 
      tipd_cin                          : VitalDelayType01 := DefPropDelay01; 
      tipd_cascin                        : VitalDelayType01 := DefPropDelay01 );

  PORT (
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
   attribute VITAL_LEVEL0 of flex10ke_asynch_lcell : ENTITY is TRUE;
end flex10ke_asynch_lcell;
        
ARCHITECTURE vital_le of flex10ke_asynch_lcell is
   attribute VITAL_LEVEL0 of vital_le : ARCHITECTURE is TRUE;
   signal dataa_ipd, datab_ipd : std_logic;
   signal datac_ipd, datad_ipd, cin_ipd, cascin_ipd : std_logic;
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

variable combout_VitalGlitchData : VitalGlitchDataType;
variable cout_VitalGlitchData : VitalGlitchDataType;
variable cascout_VitalGlitchData : VitalGlitchDataType;
variable regin_VitalGlitchData : VitalGlitchDataType;

variable icomb, icomb1, icout : std_logic;
variable idata, setbit : std_logic := '0';
variable tmp_combout, tmp_cascout, tmp_cout, tmp_regin : std_logic;
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

        if operation_mode = "up_dn_cntr" then
                icomb1 := VitalMUX(data => lut_mask_std,
                         dselect => ('1', cin_ipd, qfbkin, dataa_ipd)); -- Added By ModelTech
                icout := VitalMUX(data => lut_mask_std,
                         dselect => ('0', cin_ipd, datab_ipd, qfbkin)); -- Added By ModelTech
                if (datad_ipd = '0') then
                        icomb := datac_ipd and cascin_ipd;
                else
                        icomb := icomb1 and cascin_ipd;
                end if;
        end if;

        if operation_mode = "clrb_cntr" then
                icomb1 := VitalMUX(data => lut_mask_std,
                         dselect => ('1', cin_ipd, qfbkin, dataa_ipd)); -- Added By ModelTech
                icout := VitalMUX(data => lut_mask_std,
                         dselect => ('0', cin_ipd, datab_ipd, qfbkin)); -- Added By ModelTech
                if (datad_ipd = '0') then
                        icomb := datac_ipd and datab_ipd;
                else
                        icomb := icomb1 and datab_ipd;
                end if;
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
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_combout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_combout, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_combout, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_combout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_combout, TRUE),
                 5 => (cascin_ipd'last_event, tpd_cascin_combout, TRUE),
                 6 => (qfbkin'last_event, tpd_qfbkin_combout, TRUE)),
       GlitchData => combout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 (
       OutSignal => regin,
       OutSignalName => "REGIN",
       OutTemp => tmp_regin,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_regin, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_regin, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_regin, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_regin, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_regin, TRUE),
                 5 => (cascin_ipd'last_event, tpd_cascin_regin, TRUE),
                 6 => (qfbkin'last_event, tpd_qfbkin_regin, TRUE)),
       GlitchData => regin_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cascout, 
       OutSignalName => "CASCOUT",
       OutTemp => tmp_cascout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cascout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cascout, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_cascout, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_cascout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_cascout, TRUE),
                 5 => (cascin_ipd'last_event, tpd_cascin_cascout, TRUE),
                 6 => (qfbkin'last_event, tpd_qfbkin_cascout, TRUE)),
       GlitchData => cascout_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => cout, 
       OutSignalName => "COUT",
       OutTemp => tmp_cout,
       Paths => (0 => (dataa_ipd'last_event, tpd_dataa_cout, TRUE),
                 1 => (datab_ipd'last_event, tpd_datab_cout, TRUE),
                 2 => (datac_ipd'last_event, tpd_datac_cout, TRUE),
                 3 => (datad_ipd'last_event, tpd_datad_cout, TRUE),
                 4 => (cin_ipd'last_event, tpd_cin_cout, TRUE),
                 5 => (qfbkin'last_event, tpd_qfbkin_cout, TRUE)),
       GlitchData => cout_VitalGlitchData,    
       Mode => DefGlitchMode, 
       XOn  => XOn, 
       MsgOn => MsgOn );

end process;

end vital_le;        

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;

ENTITY flex10ke_lcell_register is
  GENERIC (operation_mode : string := "normal";
      clock_enable_mode : string := "false";
      packed_mode   : string := "false";
      x_on_violation : string := "on";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";

      tsetup_datain_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tsetup_dataa_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;  
      tsetup_datab_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;  
      tsetup_datac_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tsetup_datad_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tsetup_aload_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;

      thold_datain_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_dataa_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_datab_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_datac_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_datad_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_aload_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;

      tpd_clk_regout_posedge                : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_regout_posedge                : VitalDelayType01 := DefPropDelay01;
      tpd_clk_qfbko_posedge                : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_qfbko_posedge                : VitalDelayType01 := DefPropDelay01;

      tperiod_clk_posedge               : VitalDelayType := DefPulseWdthCnst;

      tipd_dataa                          : VitalDelayType01 := DefPropDelay01;         
      tipd_datab                          : VitalDelayType01 := DefPropDelay01;         
      tipd_datac                          : VitalDelayType01 := DefPropDelay01;         
      tipd_datad                          : VitalDelayType01 := DefPropDelay01; 
      tipd_aclr                         : VitalDelayType01 := DefPropDelay01; 
      tipd_aload                         : VitalDelayType01 := DefPropDelay01;        
      tipd_clk                          : VitalDelayType01 := DefPropDelay01);

  PORT (clk :in std_logic;
        datain  : in std_logic := '1';
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        aclr    : in std_logic := '0';
        aload : in std_logic := '0';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic;
        qfbko     : out std_logic);
   attribute VITAL_LEVEL0 of flex10ke_lcell_register : ENTITY is TRUE;
end flex10ke_lcell_register;
        
ARCHITECTURE vital_le_reg of flex10ke_lcell_register is
   attribute VITAL_LEVEL0 of vital_le_reg : ARCHITECTURE is TRUE;
   signal aload_ipd, dataa_ipd, datab_ipd, datac_ipd, datad_ipd : std_logic;
   signal ena_ipd : std_logic := '1';
   signal clk_ipd, aclr_ipd: std_logic;
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
   VitalWireDelay (clk_ipd, clk, tipd_clk);
   VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
   VitalWireDelay (aload_ipd, aload, tipd_aload);
   end block;

VITALtiming : process(clk_ipd, aclr_ipd, devclrn, devpor, ena_ipd, datain, dataa_ipd, datab_ipd, datac_ipd, datad_ipd, aload_ipd)
variable Tviol_datain_clk : std_ulogic := '0';
variable Tviol_dataa_clk : std_ulogic := '0';
variable Tviol_datab_clk : std_ulogic := '0';
variable Tviol_datac_clk : std_ulogic := '0';
variable Tviol_datad_clk : std_ulogic := '0';
variable Tviol_aload_clk : std_ulogic := '0';
variable Tviol_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_dataa_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_datab_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_datac_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_datad_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_aload_clk : VitalTimingDataType := VitalTimingDataInit;
variable PeriodData_clk : VitalPeriodDataType := VitalPeriodDataInit;
variable regout_VitalGlitchData : VitalGlitchDataType;
variable qfbko_VitalGlitchData : VitalGlitchDataType;

variable iregout : std_logic := '0';
variable inreg, temp: std_logic;
variable idata, setbit : std_logic := '0';
variable tmp_regout : std_logic;
variable tmp_qfbko : std_logic;

-- variables for 'X' generation
variable violation : std_logic := '0';

begin
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (NOT dataa_ipd)) /= '1',
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (NOT dataa_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_dataa_clk,
                TimingData      => TimingData_dataa_clk,
                TestSignal      => dataa_ipd,
                TestSignalName  => "DATAA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_dataa_clk_noedge_posedge,
                SetupLow        => tsetup_dataa_clk_noedge_posedge,
                HoldHigh        => thold_dataa_clk_noedge_posedge,
                HoldLow         => thold_dataa_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_datab_clk,
                TimingData      => TimingData_datab_clk,
                TestSignal      => datab_ipd,
                TestSignalName  => "DATAB",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datab_clk_noedge_posedge,
                SetupLow        => tsetup_datab_clk_noedge_posedge,
                HoldHigh        => thold_datab_clk_noedge_posedge,
                HoldLow         => thold_datab_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_datad_clk,
                TimingData      => TimingData_datad_clk,
                TestSignal      => datad_ipd,
                TestSignalName  => "DATAD",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_datad_clk_noedge_posedge,
                SetupLow        => tsetup_datad_clk_noedge_posedge,
                HoldHigh        => thold_datad_clk_noedge_posedge,
                HoldLow         => thold_datad_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (NOT dataa_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );


         VitalSetupHoldCheck (
                Violation       => Tviol_aload_clk,
                TimingData      => TimingData_aload_clk,
                TestSignal      => aload_ipd,
                TestSignalName  => "ALOAD",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_aload_clk_noedge_posedge,
                SetupLow        => tsetup_aload_clk_noedge_posedge,
                HoldHigh        => thold_aload_clk_noedge_posedge,
                HoldLow         => thold_aload_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
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
                 CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
                 HeaderMsg       => InstancePath & "/LCELL",
                 XOn             => XOnChecks,
                 MsgOn           => MsgOnChecks );
 
      end if;

      violation := Tviol_datain_clk or Tviol_dataa_clk or Tviol_datab_clk or Tviol_datac_clk or Tviol_datad_clk or
                   Tviol_aload_clk or Tviol_clk;

      if clock_enable_mode = "true" then
        ena_ipd <= dataa_ipd;
      end if;        

      if (devclrn = '0') then
         iregout := '0';
      elsif (aclr_ipd = '1') then
                iregout := '0';
      elsif (violation = 'X' and x_on_violation = "on") then
            iregout := 'X';
      elsif (aload = '1') then
            iregout := datac_ipd;        
      elsif clk_ipd'event and clk_ipd = '1' then
                if (ena_ipd = '1') then
                        if (operation_mode = "clrb_cntr") then
                                if (datab_ipd = '0') then
                                        iregout := '0';
                                elsif (datad_ipd = '0') then
                                        iregout := datac_ipd;
                                else
                                        iregout := datain;
                                end if;
                        elsif (operation_mode = "up_dn_cntr") then        
                                if (datad_ipd = '0') then
                                        iregout := datac_ipd;
                                else
                                        iregout := datain;
                                end if;
                        else
                                if (packed_mode = "true") then
                                        iregout := datad_ipd;
                                else
                                        iregout := datain;
                                end if;
                        end if;
                end if;
      end if;

      tmp_regout := iregout;
      tmp_qfbko := iregout;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => regout,
       OutSignalName => "REGOUT",
       OutTemp => tmp_regout,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
       GlitchData => qfbko_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => qfbko,
       OutSignalName => "QFBKO",
       OutTemp => tmp_qfbko,
       Paths => (0 => (aclr_ipd'last_event, tpd_aclr_qfbko_posedge, TRUE),
                 1 => (clk_ipd'last_event, tpd_clk_qfbko_posedge, TRUE)),
       GlitchData => regout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );
end process;
end vital_le_reg;        


LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;
USE work.flex10ke_asynch_lcell;
USE work.flex10ke_lcell_register;

ENTITY flex10ke_lcell is
  GENERIC (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      clock_enable_mode : string := "false";
      packed_mode   : string := "false";
      lut_mask       : string := "ffff";
      cin_used       : string := "false";
      x_on_violation : string := "on"
     );

  PORT (clk     : in std_logic := '0';
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        aclr    : in std_logic := '0';
        aload : in std_logic := '0';
        cin   : in std_logic := '0';
        cascin     : in std_logic := '1';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end flex10ke_lcell;
        
ARCHITECTURE vital_le_atom of flex10ke_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

COMPONENT flex10ke_asynch_lcell 
  GENERIC (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      lut_mask       : string := "ffff";
      cin_used       : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_dataa_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datab_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datac_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_datad_combout                 : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_combout                : VitalDelayType01 := DefPropDelay01;
      tpd_cin_combout                   : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_combout                : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datab_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datac_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_datad_regin                   : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_regin                  : VitalDelayType01 := DefPropDelay01;
      tpd_cin_regin                     : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_regin                  : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cout                        : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cout                        : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cout                    : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cout                    : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_cout                   : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cout                        : VitalDelayType01 := DefPropDelay01;
      tpd_cascin_cascout                : VitalDelayType01 := DefPropDelay01;
      tpd_cin_cascout                    : VitalDelayType01 := DefPropDelay01;
      tpd_dataa_cascout                        : VitalDelayType01 := DefPropDelay01;
      tpd_datab_cascout                        : VitalDelayType01 := DefPropDelay01;
      tpd_datac_cascout                    : VitalDelayType01 := DefPropDelay01;
      tpd_datad_cascout                    : VitalDelayType01 := DefPropDelay01;
      tpd_qfbkin_cascout                : VitalDelayType01 := DefPropDelay01;
      tipd_dataa                        : VitalDelayType01 := DefPropDelay01; 
      tipd_datab                        : VitalDelayType01 := DefPropDelay01; 
      tipd_datac                        : VitalDelayType01 := DefPropDelay01; 
      tipd_datad                        : VitalDelayType01 := DefPropDelay01; 
      tipd_cin                          : VitalDelayType01 := DefPropDelay01; 
      tipd_cascin                        : VitalDelayType01 := DefPropDelay01); 

  PORT (
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
end COMPONENT;

COMPONENT flex10ke_lcell_register
  GENERIC (operation_mode : string := "normal";
      clock_enable_mode : string := "false";
      x_on_violation : string := "on";
      packed_mode   : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tsetup_datain_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tsetup_dataa_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tsetup_datab_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tsetup_datac_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tsetup_datad_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tsetup_aload_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_datain_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_dataa_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_datab_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_datac_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_datad_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      thold_aload_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
      tpd_clk_regout_posedge                : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_regout_posedge                : VitalDelayType01 := DefPropDelay01;
      tpd_clk_qfbko_posedge                : VitalDelayType01 := DefPropDelay01;
      tpd_aclr_qfbko_posedge                : VitalDelayType01 := DefPropDelay01;
      tperiod_clk_posedge               : VitalDelayType := DefPulseWdthCnst;
      tipd_dataa                          : VitalDelayType01 := DefPropDelay01; 
      tipd_datab                          : VitalDelayType01 := DefPropDelay01; 
      tipd_datac                          : VitalDelayType01 := DefPropDelay01; 
      tipd_datad                          : VitalDelayType01 := DefPropDelay01; 
      tipd_aclr                         : VitalDelayType01 := DefPropDelay01; 
      tipd_clk                          : VitalDelayType01 := DefPropDelay01;
      tipd_aload                         : VitalDelayType01 := DefPropDelay01); 
  PORT (clk     : in std_logic;
        datain     : in std_logic := '1';
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        aclr    : in std_logic := '0';
        aload : in std_logic := '0';
        devclrn   : in std_logic := '1';
        devpor    : in std_logic := '1';
        regout    : out std_logic;
        qfbko     : out std_logic);
end COMPONENT;

begin

lecomb: flex10ke_asynch_lcell
        generic map (operation_mode => operation_mode, output_mode => output_mode,
                     lut_mask => lut_mask, cin_used => cin_used)
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cascin => cascin, qfbkin => qfbk,
                  combout => combout, cout => cout, cascout => cascout, regin => dffin);

lereg: flex10ke_lcell_register
        generic map (operation_mode => operation_mode, clock_enable_mode => clock_enable_mode, packed_mode => packed_mode, x_on_violation => x_on_violation)
          port map (clk => clk, datain => dffin, dataa => dataa, datab => datab, datac => datac, datad => datad, 
                aclr => aclr, aload => aload, devclrn => devclrn, devpor => devpor, regout => regout, qfbko => qfbk);


end vital_le_atom;

--
--
--  FLEX10KE_IO Model
--
--
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;

ENTITY flex10ke_asynch_io is
   GENERIC (operation_mode : string := "input";
      reg_source_mode :  string := "none";
      feedback_mode : string := "from_pin";
      open_drain_output : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";

      tpd_datain_padio                         : VitalDelayType01 := DefPropDelay01;
      tpd_padio_dataout                  : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_posedge               : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_negedge               : VitalDelayType01 := DefPropDelay01;
      tpd_dffeQ_padio                         : VitalDelayType01 := DefPropDelay01;
      tpd_dffeQ_dataout                         : VitalDelayType01 := DefPropDelay01;

      tipd_datain                        : VitalDelayType01 := DefPropDelay01;
      tipd_oe                            : VitalDelayType01 := DefPropDelay01;
      tipd_padio                         : VitalDelayType01 := DefPropDelay01);

    PORT (datain: in std_logic;
          dffeQ : in std_logic;
          oe           : in std_logic;
          padio : inout std_logic;
          dffeD : out std_logic;
          dataout : out std_logic);

    attribute VITAL_LEVEL0 of flex10ke_asynch_io : ENTITY is TRUE;
end flex10ke_asynch_io;

ARCHITECTURE vital_asynch_io of flex10ke_asynch_io is
   attribute VITAL_LEVEL0 of vital_asynch_io : ARCHITECTURE is TRUE;

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

VITALtiming : process(datain_ipd, oe_ipd, padio_ipd, dffeQ)
variable Tviol_datain_clk : std_ulogic := '0';
variable Tviol_padio_clk : std_ulogic := '0';
variable Tviol_ena_clk : std_ulogic := '0';
variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_padio_clk : VitalTimingDataType := VitalTimingDataInit;
variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
variable dataout_VitalGlitchData : VitalGlitchDataType;
variable padio_VitalGlitchData : VitalGlitchDataType;
variable dffeD_VitalGlitchData : VitalGlitchDataType;

variable tri_in : std_logic := '0';
variable tmp_dataout, tmp_padio, oe_val, temp : std_logic;
variable reg_indata : std_logic := '0';
begin

        if ((reg_source_mode = "none") and
                     (feedback_mode = "none")) then
                if ((operation_mode = "output") or
                          (operation_mode = "bidir")) then
                     tri_in := datain_ipd;
                end if;
        elsif ((reg_source_mode = "none") and
                     (feedback_mode = "from_pin")) then
                if (operation_mode = "input") then
                        tmp_dataout := to_x01z(padio_ipd);
                elsif (operation_mode = "bidir") then
                        tmp_dataout := to_x01z(padio_ipd);
                        tri_in := datain_ipd;
                end if;
        elsif ((reg_source_mode = "data_in") and
                        (feedback_mode = "from_reg")) then
                if ((operation_mode = "output") or
                          (operation_mode = "bidir")) then
                     tri_in := datain_ipd;        
                     reg_indata := datain_ipd;
                end if;
        elsif ((reg_source_mode = "pin_only") and
                        (feedback_mode = "from_reg"))   then
                if (operation_mode = "input") then
                        reg_indata := to_x01z(padio_ipd);
                elsif (operation_mode = "bidir")  then
                        tri_in := datain_ipd;
                        reg_indata := to_x01z(padio_ipd);
                end if;
        elsif ((reg_source_mode = "data_in_to_pin") and
                        (feedback_mode = "from_pin")) then
                if (operation_mode = "bidir") then
                        reg_indata := datain_ipd;
                        tri_in := dffeQ;
                        tmp_dataout := to_x01z(padio_ipd);
                end if;
        elsif ((reg_source_mode = "data_in_to_pin") and
                        (feedback_mode = "from_reg"))     then
                if ((operation_mode = "output") or
                          (operation_mode = "bidir")) then
                        reg_indata := datain_ipd;
                        tri_in := dffeQ;
                end  if;
        elsif ((reg_source_mode = "data_in_to_pin") and
                        (feedback_mode = "none"))       then
                if ((operation_mode = "output") or
                          (operation_mode = "bidir")) then
                        tri_in := dffeQ;
                        reg_indata := datain_ipd;
                end   if;
        elsif ((reg_source_mode = "pin_loop") and
                        (feedback_mode = "from_pin")) then
                if (operation_mode = "bidir") then
                        tri_in := dffeQ;
                        reg_indata := to_x01z(padio_ipd);
                        tmp_dataout := to_x01z(padio_ipd);
                end if;
        elsif ((reg_source_mode = "pin_loop") and
                        (feedback_mode = "from_reg")) then
                if (operation_mode = "bidir") then
                        reg_indata := to_x01z(padio_ipd);
                        tri_in := dffeQ;
                end if;
        end if;

        if (operation_mode = "output") then
           oe_val := to_x01z(oe_ipd);
           if (oe_val = '0') then
               temp := 'Z';
           else
               temp := tri_in;
           end if;
           if (open_drain_output = "false") then
              tmp_padio := temp;
           elsif (open_drain_output = "true") then
                   if ((reg_source_mode = "data_in_to_pin") and (feedback_mode /= "from_pin")) then   
                        if (temp = '0') then
                                 tmp_padio := '0';
                      else
                                 tmp_padio := 'Z';
                      end if;
                else
                            if (datain_ipd = '1') then
                                tmp_padio := 'Z';
                            else
                                tmp_padio := '0';
                            end if;
                end if;
           end if;
        elsif ((operation_mode = "bidir") and (oe_ipd = '1')) then
           if (open_drain_output = "false") then
              tmp_padio := tri_in;
           elsif (open_drain_output = "true") then
              if (tri_in = '0') then
                 tmp_padio := '0';
              else
                 tmp_padio := 'Z';
              end if;
           end if;
        else
           tmp_padio := 'Z';
        end if;

      ----------------------
      --  Path Delay Section
      ----------------------

     if (feedback_mode ="from_pin") then
      VitalPathDelay01 (
       OutSignal => dataout,
       OutSignalName => "DATAOUT",
       OutTemp => tmp_dataout,
       Paths => ( 0 => (padio_ipd'last_event,
                       tpd_padio_dataout,
                       TRUE)),
       GlitchData => dataout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );
        
     else
      VitalPathDelay01 (
       OutSignal => dataout,
       OutSignalName => "DATAOUT",
       OutTemp => dffeQ,
       Paths => ( 0 => (dffeQ'last_event,
                       tpd_dffeQ_dataout,
                       TRUE)),
       GlitchData => dataout_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn => MsgOn );
     end if;

      VitalPathDelay01 ( 
       OutSignal => padio, 
       OutSignalName => "PADIO", 
       OutTemp => tmp_padio,   
       Paths => (0 => (dffeQ'last_event,
                       tpd_dffeQ_padio,
                       TRUE),
                        1 => (oe_ipd'last_event,
                       tpd_oe_padio_posedge,
                       oe_ipd = '1'), 
                 2 => (oe_ipd'last_event,
                       tpd_oe_padio_negedge,
                       oe_ipd = '0'), 
                 3 => (datain_ipd'last_event,
                       tpd_datain_padio,
                       (reg_source_mode = "none" or reg_source_mode = "data_in"
                        or reg_source_mode = "pin_only"))),
       GlitchData => padio_VitalGlitchData,  
       Mode => DefGlitchMode, 
       XOn  => XOn,   
       MsgOn => MsgOn );

      VitalPathDelay01 ( 
       OutSignal => dffeD, 
       OutSignalName => "DFFED", 
       OutTemp => reg_indata,   
       Paths => (0 => (datain_ipd'last_event, (0 ns, 0 ns),
                       reg_source_mode = "data_in" or
                       reg_source_mode = "data_in_to_pin"),
                 1 => (padio_ipd'last_event, (0 ns, 0 ns),
                       reg_source_mode = "pin_only" or
                       reg_source_mode = "pin_loop")),
       GlitchData => dffeD_VitalGlitchData,  
       Mode => DefGlitchMode, 
       XOn  => XOn,   
       MsgOn => MsgOn );
end process;
end vital_asynch_io;

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;
USE work.dffe_io;
USE work.flex10ke_asynch_io;

ENTITY  flex10ke_io is
   GENERIC (operation_mode : string := "input";
      reg_source_mode :  string := "none";
      feedback_mode : string := "from_pin";
      power_up : string := "low";
      open_drain_output : string := "false");

    PORT (clk    : in std_logic := '0';
          datain : in std_logic := '1';
          aclr   : in std_logic := '0';
          ena    : in std_logic := '1';
          oe     : in std_logic := '1';
          devclrn   : in std_logic := '1';
          devpor : in std_logic := '1';
          devoe  : in std_logic := '0';
          padio  : inout std_logic;
          dataout : out std_logic);

end flex10ke_io;

ARCHITECTURE arch of flex10ke_io is

   signal reg_clr, reg_pre : std_logic := '1';
   signal ioreg_clr : std_logic := '1';
   signal vcc : std_logic := '1';
   signal dffeD : std_logic;
   signal data_out : std_logic;
   signal dffe_Q : std_logic;
         
COMPONENT dffe_io
   GENERIC(
      TimingChecksOn: Boolean := true;
      XGenerationOn: Boolean := false;
      InstancePath: STRING := "*";
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
      tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
      tsetup_ENA_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_posedge    :   VitalDelayType := DefSetupHoldCnst;
      thold_D_CLK_noedge_negedge    :   VitalDelayType := DefSetupHoldCnst;
      thold_ENA_CLK_noedge_posedge    :   VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
      tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   PORT(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end COMPONENT;

COMPONENT flex10ke_asynch_io
   GENERIC (operation_mode : string := "input";
      reg_source_mode :  string := "none";
      feedback_mode : string := "from_pin";
      open_drain_output : string := "false";
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_datain_padio                         : VitalDelayType01 := DefPropDelay01;
      tpd_padio_dataout                  : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_posedge               : VitalDelayType01 := DefPropDelay01;
      tpd_oe_padio_negedge               : VitalDelayType01 := DefPropDelay01;
      tpd_dffeQ_padio                         : VitalDelayType01 := DefPropDelay01;
      tpd_dffeQ_dataout                         : VitalDelayType01 := DefPropDelay01;
      tipd_datain                        : VitalDelayType01 := DefPropDelay01;
      tipd_oe                            : VitalDelayType01 := DefPropDelay01;
      tipd_padio                         : VitalDelayType01 := DefPropDelay01);

    PORT (datain : in std_logic;
          dffeQ : in std_logic;
          oe   : in std_logic;
          padio  : inout std_logic;
          dffeD : out std_logic;
          dataout : out std_logic);
end COMPONENT;

begin

reg_clr <= devpor when power_up = "low" else vcc;

ioreg_clr <= devclrn and (not aclr) and reg_clr;

inst1: flex10ke_asynch_io
     generic map (operation_mode => operation_mode,
                  reg_source_mode => reg_source_mode,
                  feedback_mode => feedback_mode,
                  open_drain_output => open_drain_output)

     port map (datain => datain, oe => oe, padio => padio,
                           dffeD => dffeD, dffeQ => dffe_Q,
                           dataout => data_out);

io_reg: dffe_io
      port map (D => dffeD, clk => clk, ena => ena, Q => dffe_Q,
                CLRN => ioreg_clr);

dataout <= data_out;

end arch;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : FLEX10KE_ASYNCH_MEM
--
-- Description : Timing simulation model for the asynchronous RAM array.
--               Size of array : 2048x1
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;

 
ENTITY flex10ke_asynch_mem IS
    GENERIC (
             logical_ram_depth                : integer := 2048;
             inifile                          : string := "none";
             address_width                    : integer := 1;
             first_address                    : integer := 0;
             last_address                     : integer := 2047;
             mem1                             : std_logic_vector(512 downto 1) ;
             mem2                             : std_logic_vector(512 downto 1) ;
             mem3                             : std_logic_vector(512 downto 1) ;
             mem4                             : std_logic_vector(512 downto 1) ;
             bit_number                       : integer := 0;
             write_logic_clock                : string := "none";
             read_enable_clock                : string := "none";
             data_out_clock                   : string := "none";
             operation_mode                   : string := "single_port";
             TimingChecksOn                   : Boolean := True;
             MsgOn                            : Boolean := DefGlitchMsgOn;
             XOn                              : Boolean := DefGlitchXOn;
             MsgOnChecks                      : Boolean := DefMsgOnChecks;
             XOnChecks                        : Boolean := DefXOnChecks;
             InstancePath                     : STRING := "*";
             tsetup_waddr_we_noedge_posedge   : VitalDelayArrayType(10 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_waddr_we_noedge_negedge    : VitalDelayArrayType(10 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_datain_we_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
             thold_datain_we_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             tsetup_raddr_re_noedge_negedge   : VitalDelayArrayType(10 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_raddr_re_noedge_negedge    : VitalDelayArrayType(10 downto 0) := (OTHERS => DefSetupHoldCnst);
             tpd_raddr_dataout                : VitalDelayArrayType01(10 downto 0) := (OTHERS => DefPropDelay01);
             tpd_waddr_dataout                : VitalDelayArrayType01(10 downto 0) := (OTHERS => DefPropDelay01);
             tpd_re_dataout                   : VitalDelayType01 := DefPropDelay01;
             tpd_datain_dataout               : VitalDelayType01 := DefPropDelay01;
             tpd_we_dataout                   : VitalDelayType01 := DefPropDelay01;
             tipd_datain                      : VitalDelayType01 := DefPropDelay01;
             tipd_we                          : VitalDelayType01 := DefPropDelay01;
             tipd_re                          : VitalDelayType01 := DefPropDelay01;
             tipd_raddr                       : VitalDelayArrayType01(10 downto 0) := (OTHERS => DefPropDelay01);
             tipd_waddr                       : VitalDelayArrayType01(10 downto 0) := (OTHERS => DefPropDelay01);
             tpw_we_posedge                   : VitalDelayType := 0 ns;
             tpw_re_posedge                   : VitalDelayType := 0 ns
            );
 
          PORT (datain  : in std_logic := '0';
                we      : in std_logic := '0';
                re      : in std_logic := '1';
                raddr   : in std_logic_vector(10 downto 0) := "00000000000";
                waddr   : in std_logic_vector(10 downto 0) := "00000000000";
                devclrn : in std_logic := '1';
                devpor  : in std_logic := '1';
                modesel : in std_logic_vector(15 downto 0) := "0000000000000000";
                dataout : out std_logic
                );
    
    attribute VITAL_LEVEL0 of flex10ke_asynch_mem : ENTITY is TRUE;
end flex10ke_asynch_mem;
 
ARCHITECTURE behave of flex10ke_asynch_mem is
signal datain_ipd, we_ipd, re_ipd : std_logic;
signal waddr_ipd, raddr_ipd : std_logic_vector(10 downto 0);
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (raddr_ipd(0), raddr(0), tipd_raddr(0));
        VitalWireDelay (raddr_ipd(1), raddr(1), tipd_raddr(1));
        VitalWireDelay (raddr_ipd(2), raddr(2), tipd_raddr(2));
        VitalWireDelay (raddr_ipd(3), raddr(3), tipd_raddr(3));
        VitalWireDelay (raddr_ipd(4), raddr(4), tipd_raddr(4));
        VitalWireDelay (raddr_ipd(5), raddr(5), tipd_raddr(5));
        VitalWireDelay (raddr_ipd(6), raddr(6), tipd_raddr(6));
        VitalWireDelay (raddr_ipd(7), raddr(7), tipd_raddr(7));
        VitalWireDelay (raddr_ipd(8), raddr(8), tipd_raddr(8));
        VitalWireDelay (raddr_ipd(9), raddr(9), tipd_raddr(9));
        VitalWireDelay (raddr_ipd(10), raddr(10), tipd_raddr(10));
        VitalWireDelay (waddr_ipd(0), waddr(0), tipd_waddr(0));
        VitalWireDelay (waddr_ipd(1), waddr(1), tipd_waddr(1));
        VitalWireDelay (waddr_ipd(2), waddr(2), tipd_waddr(2));
        VitalWireDelay (waddr_ipd(3), waddr(3), tipd_waddr(3));
        VitalWireDelay (waddr_ipd(4), waddr(4), tipd_waddr(4));
        VitalWireDelay (waddr_ipd(5), waddr(5), tipd_waddr(5));
        VitalWireDelay (waddr_ipd(6), waddr(6), tipd_waddr(6));
        VitalWireDelay (waddr_ipd(7), waddr(7), tipd_waddr(7));
        VitalWireDelay (waddr_ipd(8), waddr(8), tipd_waddr(8));
        VitalWireDelay (waddr_ipd(9), waddr(9), tipd_waddr(9));
        VitalWireDelay (waddr_ipd(10), waddr(10), tipd_waddr(10));
        VitalWireDelay (we_ipd, we, tipd_we);
        VitalWireDelay (re_ipd, re, tipd_re);
        VitalWireDelay (datain_ipd, datain, tipd_datain);
    end block;
    
    VITAL: process(datain_ipd, we_ipd, re_ipd, raddr_ipd, waddr_ipd)
    variable Tviol_waddr_we : std_ulogic := '0';
    variable Tviol_raddr_re : std_ulogic := '0';
    variable Tviol_datain_we : std_ulogic := '0';
    variable TimingData_waddr_we : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_raddr_re : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_datain_we : VitalTimingDataType := VitalTimingDataInit;
    variable dataout_VitalGlitchData : VitalGlitchDataType;
    variable read_en, write_en : std_logic;
    variable rword, wword : integer;
    
    variable mem : std_logic_vector(2047 downto 0);
    variable tmp_dataout : std_logic;
    variable write_en_last_value : std_logic := '0';
    
    variable do_init_mem : boolean := true;
    variable i : integer := 0;
    begin

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then

           VitalSetupHoldCheck (
                Violation       => Tviol_waddr_we,
                TimingData      => TimingData_waddr_we,
                TestSignal      => waddr_ipd,
                TestSignalName  => "WADDR",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                SetupHigh       => tsetup_waddr_we_noedge_posedge(0),
                SetupLow        => tsetup_waddr_we_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/FLEX10KE_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

           VitalSetupHoldCheck (
                Violation       => Tviol_waddr_we,
                TimingData      => TimingData_waddr_we,
                TestSignal      => waddr_ipd,
                TestSignalName  => "WADDR",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                HoldHigh        => thold_waddr_we_noedge_negedge(0),
                HoldLow         => thold_waddr_we_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/FLEX10KE_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

           VitalSetupHoldCheck (
                Violation       => Tviol_raddr_re,
                TimingData      => TimingData_raddr_re,
                TestSignal      => raddr_ipd,
                TestSignalName  => "RADDR",
                RefSignal       => re_ipd,
                RefSignalName   => "RE",
                SetupHigh       => tsetup_raddr_re_noedge_negedge(0),
                SetupLow        => tsetup_raddr_re_noedge_negedge(0),
                HoldHigh        => thold_raddr_re_noedge_negedge(0),
                HoldLow         => thold_raddr_re_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/FLEX10KE_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

           VitalSetupHoldCheck (
                Violation       => Tviol_datain_we,
                TimingData      => TimingData_datain_we,
                TestSignal      => datain_ipd,
                TestSignalName  => "DATAIN",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                SetupHigh       => tsetup_datain_we_noedge_negedge,
                SetupLow        => tsetup_datain_we_noedge_negedge,
                HoldHigh        => thold_datain_we_noedge_negedge,
                HoldLow         => thold_datain_we_noedge_negedge,
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/FLEX10KE_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
        end if;

        rword := conv_integer(raddr_ipd(10 downto 0));
        wword := conv_integer(waddr_ipd(10 downto 0));

        if (now = 0 ns and do_init_mem) then
            do_init_mem := false;
            mem := (mem4 & mem3 & mem2 & mem1);

            -- if WE is not registered, initial RAM content is X
            -- note that if WE is not registered, the MIF file cannot be used
            if (operation_mode /= "rom" and write_logic_clock = "none") then
               for i in 0 to 2047 loop
                   mem(i) := 'X';
               end loop;
            end if;

            if (operation_mode = "rom" or operation_mode = "single_port") then
                -- implies re is active
                tmp_dataout := mem(0);
            else   -- re is inactive
                tmp_dataout := '0';
            end if;
            if (read_enable_clock /= "none") then
               if (operation_mode = "rom" or operation_mode = "single_port") then
                  -- implies re is active
                  tmp_dataout := mem(0);
               else
                   -- eab cell output powers up to VCC
                   tmp_dataout := '1';
               end if;
            end if;
        end if;

        read_en := re_ipd;
        write_en := we_ipd;

        if modesel(14 downto 13) = 2 then -- ROM
           if read_en = '1' then
               tmp_dataout := mem(rword);
           end if;
        elsif modesel(14 downto 13) = 0 then -- Single Port RAM
           if (write_en = '0') and (write_en_last_value = '1') then
                mem(wword) := datain_ipd;
           end if;
           if write_en = '0' then
               tmp_dataout := mem(wword);
           elsif write_en = '1' then
               tmp_dataout := datain_ipd;
           else
               tmp_dataout := 'X';
           end if;
        elsif modesel(14 downto 13) = 1 then -- Dual Port RAM 
           if (write_en = '0') and (write_en_last_value = '1') then
               mem(wword) := datain_ipd;
           end if;
           if (read_en = '1') and (wword = rword) and (write_en = '1') then    
               tmp_dataout := datain_ipd;
           elsif (read_en = '1') then  
               tmp_dataout := mem(rword);
           end if;
        end if;

        write_en_last_value := write_en;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
           OutSignal => dataout,
           OutSignalName => "DATAOUT",
           OutTemp => tmp_dataout,
           Paths => (1 => (raddr_ipd'last_event, tpd_raddr_dataout(0), TRUE),
                     2 => (waddr_ipd'last_event, tpd_waddr_dataout(0), TRUE),
                     3 => (we_ipd'last_event, tpd_we_dataout, TRUE),
                     4 => (re_ipd'last_event, tpd_re_dataout, TRUE),
                     5 => (datain_ipd'last_event, tpd_datain_dataout, TRUE)),
           GlitchData => dataout_VitalGlitchData,
           Mode => DefGlitchMode,
           XOn  => XOn,
           MsgOn        => MsgOn );

    end process;
   
end behave;                             -- flex10ke_asynch_mem

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : FLEX10KE_DFFE
--
-- Description : Timing simulation model for a DFFE register
--
--////////////////////////////////////////////////////////////////////////////
 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;

ENTITY flex10ke_dffe is
   GENERIC(
           TimingChecksOn                 : Boolean := True;
           XOn                            : Boolean := DefGlitchXOn;
           MsgOn                          : Boolean := DefGlitchMsgOn;
           MsgOnChecks                    : Boolean := DefMsgOnChecks;
           XOnChecks                      : Boolean := DefXOnChecks;
           InstancePath                   : STRING := "*";
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
           tipd_ENA                       :  VitalDelayType01 := DefPropDelay01
           );

   PORT(
        Q                                 :  out   STD_LOGIC := '0';
        D                                 :  in    STD_LOGIC;
        CLRN                              :  in    STD_LOGIC;
        PRN                               :  in    STD_LOGIC;
        CLK                               :  in    STD_LOGIC;
        ENA                               :  in    STD_LOGIC
        );
   
   attribute VITAL_LEVEL0 of flex10ke_dffe : ENTITY is TRUE;
   
end flex10ke_dffe;

-- ARCHITECTURE body --

ARCHITECTURE behave of flex10ke_dffe is
   attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;

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

end behave;                             -- flex10ke_dffe

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : and1
--
-- Description : Simulation model for a 1-input AND gate
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;

--USE flex10ke.SUPPORT.all;
USE work.flex10ke_atom_pack.all;

-- ENTITY declaration --
ENTITY and1 is
    GENERIC(
            MsgOn                     : Boolean := DefGlitchMsgOn;
            XOn                       : Boolean := DefGlitchXOn;
            tpd_IN1_Y                 : VitalDelayType01 := DefPropDelay01;
            tipd_IN1                  : VitalDelayType01 := DefPropDelay01);

    PORT   ( Y                        : out STD_LOGIC;
             IN1                      : in  STD_LOGIC
           );
    attribute VITAL_LEVEL0 of and1 : ENTITY is TRUE;
END and1;

-- ARCHITECTURE body --

ARCHITECTURE AltVITAL of and1 is
    attribute VITAL_LEVEL0 of AltVITAL : ARCHITECTURE is TRUE;

    SIGNAL IN1_ipd         : STD_ULOGIC := 'U';

begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
       VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
    end block;
    --------------------
    --  BEHAVIOR SECTION
    --------------------
    VITALBehavior : process (IN1_ipd)


    -- functionality results
    VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
    ALIAS Y_zd : STD_ULOGIC is Results(1);

    -- output glitch detection variables
    VARIABLE Y_GlitchData        : VitalGlitchDataType;

    begin

       -------------------------
       --  Functionality Section
       -------------------------
       Y_zd := TO_X01(IN1_ipd);

       ----------------------
       --  Path Delay Section
       ----------------------
       VitalPathDelay01 (
           OutSignal => Y,
           OutSignalName => "Y",
           OutTemp => Y_zd,
           Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
           GlitchData => Y_GlitchData,
           Mode => DefGlitchMode,
           XOn  => XOn,
           MsgOn        => MsgOn );
    end process;
end AltVITAL;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : nmux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
--               The output is an inversion of the selected input.
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY nmux21 is
     PORT ( A : in std_logic := '0';
            B : in std_logic := '0';
            S : in std_logic := '0';
            MO : out std_logic
          );
end nmux21;

ARCHITECTURE structure of nmux21 is
begin

    MO <=  not B when (S = '1') else not A;

end structure;
--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : bmux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_SLICE
--               Each input is a 16-bit bus.
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bmux21 is 
     PORT ( A : in std_logic_vector(10 downto 0) := (OTHERS => '0');
            B : in std_logic_vector(10 downto 0) := (OTHERS => '0');
            S : in std_logic := '0'; 
            MO : out std_logic_vector(10 downto 0)
          ); 
end bmux21; 
 
ARCHITECTURE structure of bmux21 is
begin 
 
    MO <= B when (S = '1') else A; 
 
end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : FLEX10KE_RAM_SLICE
--
-- Description : Timing simulation model for a single RAM segment of the
--               FLEX10KE family.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE work.flex10ke_atom_pack.all;
USE work.flex10ke_dffe;
USE work.and1;
USE work.mux21;
USE work.nmux21;
USE work.bmux21;
USE work.flex10ke_asynch_mem;

ENTITY  flex10ke_ram_slice is
    GENERIC (
             operation_mode             : string := "single_port";
             logical_ram_name           : string := "ram_xxx";
             logical_ram_depth          : integer := 2048;
             logical_ram_width          : integer:= 1;
             address_width              : integer:= 11;
             data_in_clock              : string := "none";
             data_in_clear              : string := "none";
             write_logic_clock          : string := "none";
             write_address_clear        : string := "none";
             write_enable_clear         : string := "none";
             read_enable_clock          : string := "none";
             read_enable_clear          : string := "none";
             read_address_clock         : string := "none";
             read_address_clear         : string := "none";
             data_out_clock             : string := "none";
             data_out_clear             : string := "none";
             init_file                  : string := "none";
             first_address              : integer:= 1;
             last_address               : integer:= 100;
             bit_number                 : integer:= 1;
             mem1                       : std_logic_vector(512 downto 1);
             mem2                       : std_logic_vector(512 downto 1);
             mem3                       : std_logic_vector(512 downto 1);
             mem4                       : std_logic_vector(512 downto 1)
            );
    
     PORT   (datain                     : in std_logic;
             clr0                       : in std_logic;
             clk0                       : in std_logic;
             clk1                       : in std_logic;
             ena0                       : in std_logic;
             ena1                       : in std_logic;
             we                         : in std_logic;
             re                         : in std_logic;
             waddr                      : in std_logic_vector(10 downto 0);
             raddr                      : in std_logic_vector(10 downto 0);
             devclrn                    : in std_logic := '1';
             devpor                     : in std_logic := '1';
             modesel                    : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             dataout                    : out std_logic
            );
end flex10ke_ram_slice;

ARCHITECTURE structure of flex10ke_ram_slice is
   signal  datain_reg, we_reg, re_reg, dataout_reg : std_logic;
   signal  we_reg_mux, we_reg_mux_delayed : std_logic;
   signal  raddr_reg, waddr_reg : std_logic_vector(10 downto 0);
   signal  datain_int, we_int, re_int, dataout_int : std_logic;
   signal  raddr_int, waddr_int : std_logic_vector(10 downto 0);
   signal  reen, raddren, dataouten : std_logic;
   signal  datain_clr : std_logic;
   signal  re_clk, raddr_clk : std_logic;
   signal  datain_reg_sel, write_reg_sel, raddr_reg_sel : std_logic;
   -- initialize re_reg_sel right here to avoid glitch on re_int
   -- signal  re_reg_sel, dataout_reg_sel, re_clk_sel, re_en_sel : std_logic;
   signal  dataout_reg_sel, re_clk_sel, re_en_sel : std_logic;
   signal  re_reg_sel : std_logic;
   signal  raddr_clk_sel, raddr_en_sel : std_logic;
   signal  dataout_en_sel : std_logic; 
   signal  datain_reg_clr, waddr_reg_clr, raddr_reg_clr : std_logic;
   signal  re_reg_clr, dataout_reg_clr, we_reg_clr : std_logic;
   signal  datain_reg_clr_sel : std_logic;
   signal  waddr_reg_clr_sel : std_logic;
   signal  we_reg_clr_sel : std_logic;
   signal  raddr_reg_clr_sel: std_logic;
   signal  re_reg_clr_sel, dataout_reg_clr_sel : std_logic;
   signal  NC : std_logic := '0';

   signal dinreg_clr, wereg_clr, rereg_clr, dataoutreg_clr : std_logic;
   signal raddrreg_clr, waddrreg_clr : std_logic;
   signal we_pulse : std_logic;
   signal dataout_tmp, valid_addr : std_logic;
   signal  raddr_num : integer;

   signal waddr_reg_delayed_1, waddr_reg_delayed_2 : std_logic_vector(10 downto 0);
   signal waddr_reg_delayed_3 : std_logic_vector(10 downto 0);
   signal datain_reg_delayed_1 : std_logic;
   signal datain_reg_delayed_2 : std_logic;
   signal datain_reg_delayed_3 : std_logic;

   signal clk0_delayed : std_logic;

COMPONENT flex10ke_dffe
    GENERIC(
            TimingChecksOn                : Boolean := true;
            InstancePath                  : STRING := "*";
            XOn                           : Boolean := DefGlitchXOn;
            MsgOn                         : Boolean := DefGlitchMsgOn;
            MsgOnChecks                   : Boolean := DefMsgOnChecks;
            XOnChecks                     : Boolean := DefXOnChecks;
            tpd_PRN_Q_negedge             : VitalDelayType01 := DefPropDelay01;
            tpd_CLRN_Q_negedge            : VitalDelayType01 := DefPropDelay01;
            tpd_CLK_Q_posedge             : VitalDelayType01 := DefPropDelay01;
            tpd_ENA_Q_posedge             : VitalDelayType01 := DefPropDelay01;
            tsetup_D_CLK_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
            tsetup_D_CLK_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
            tsetup_ENA_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
            thold_D_CLK_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
            thold_D_CLK_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
            thold_ENA_CLK_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
            tipd_D                        : VitalDelayType01 := DefPropDelay01;
            tipd_CLRN                     : VitalDelayType01 := DefPropDelay01;
            tipd_PRN                      : VitalDelayType01 := DefPropDelay01;
            tipd_CLK                      : VitalDelayType01 := DefPropDelay01;
            tipd_ENA                      : VitalDelayType01 := DefPropDelay01
           );

    PORT  (
           Q                              :  out   STD_LOGIC := '0';
           D                              :  in    STD_LOGIC := '1';
           CLRN                           :  in    STD_LOGIC := '1';
           PRN                            :  in    STD_LOGIC := '1';
           CLK                            :  in    STD_LOGIC := '0';
           ENA                            :  in    STD_LOGIC := '1'
          );
END COMPONENT;

COMPONENT and1
    GENERIC(
            XOn                           : Boolean := DefGlitchXOn;
            MsgOn                         : Boolean := DefGlitchMsgOn;
            tpd_IN1_Y                     :  VitalDelayType01 := DefPropDelay01;
            tipd_IN1                      :  VitalDelayType01 := DefPropDelay01
           );
        
    PORT   ( Y                            :  out   STD_LOGIC;
             IN1                          :  in    STD_LOGIC
           );
END COMPONENT;

COMPONENT mux21
    PORT   ( A : in std_logic := '0';
             B : in std_logic := '0';
             S : in std_logic := '0';
             MO : out std_logic
            );
END COMPONENT;

COMPONENT nmux21
    PORT   ( A : in std_logic := '0';
             B : in std_logic := '0';
             S : in std_logic := '0';
             MO : out std_logic
            );
END COMPONENT;

COMPONENT bmux21
    PORT ( A : in std_logic_vector(10 downto 0) := (OTHERS => '0');
           B : in std_logic_vector(10 downto 0) := (OTHERS => '0');
           S : in std_logic := '0';
           MO : out std_logic_vector(10 downto 0)
         );
END COMPONENT;

COMPONENT flex10ke_asynch_mem
    GENERIC (logical_ram_depth : integer := 2048;
             bit_number        : integer := 0;
             first_address     : integer := 0;
             last_address      : integer := 2047;
             inifile           : string := "none";
             write_logic_clock : string := "none";
             read_enable_clock : string := "none";
             data_out_clock    : string := "none";
             operation_mode    : string := "single_port";
             mem1              : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem2              : std_logic_vector(512 downto 1) := (OTHERS=>'X');
             mem3              : std_logic_vector(512 downto 1) := (OTHERS=>'X');
             mem4              : std_logic_vector(512 downto 1) := (OTHERS=>'X');
             address_width     : integer := 1
            );

    PORT    (datain            : in std_logic := '0';
             we                : in std_logic := '0';
             re                : in std_logic := '0';
             raddr             : in std_logic_vector(10 downto 0) := (OTHERS => '0');
             waddr             : in std_logic_vector(10 downto 0) := (OTHERS => '0');
             devclrn           : in std_logic := '1';
             devpor            : in std_logic := '1';
             modesel           : in std_logic_vector(15 downto 0) := "0000000000000000";
             dataout           : out std_logic
            );
END COMPONENT;
 
begin     


    re_reg_sel             <= modesel(6);
    
    datain_reg_sel         <= modesel(0);
    datain_reg_clr_sel     <= modesel(1);
    write_reg_sel          <= modesel(2);
    waddr_reg_clr_sel      <= modesel(15);
    we_reg_clr_sel         <= modesel(3);
    raddr_reg_sel          <= modesel(4);
    raddr_reg_clr_sel      <= modesel(5);
    re_reg_sel             <= modesel(6);
    re_reg_clr_sel         <= modesel(7);
    dataout_reg_sel        <= modesel(8);
    dataout_reg_clr_sel    <= modesel(9);
    re_clk_sel             <= modesel(10);
    re_en_sel              <= modesel(10);
    raddr_clk_sel          <= modesel(11);
    raddr_en_sel           <= modesel(11);
    dataout_en_sel         <= modesel(12);
    
    -- the following assignments insert delta delays for functional
    -- simulation
    datain_reg_delayed_1 <= datain_reg;
    datain_reg_delayed_2 <= datain_reg_delayed_1;
    datain_reg_delayed_3 <= datain_reg_delayed_2;
    
    datainsel: mux21 
            port map (A => datain,
                      B => datain_reg_delayed_3,
                      S => datain_reg_sel, 
                      MO => datain_int
                     );
    
    datainregclr: nmux21
            port map (A => NC,
                      B => clr0,
                      S => datain_reg_clr_sel,
                      MO => datain_reg_clr
                     );
    
    -- the following assignments insert delta delays for functional
    -- simulation
    waddr_reg_delayed_1 <= waddr_reg;
    waddr_reg_delayed_2 <= waddr_reg_delayed_1;
    waddr_reg_delayed_3 <= waddr_reg_delayed_2;
    
    waddrsel: bmux21 
            port map (A => waddr,
                      B => waddr_reg_delayed_3,
                      S => write_reg_sel, 
                      MO => waddr_int
                     );
    
    waddrregclr: nmux21
            port map (A => NC,
                      B => clr0,
                      S => waddr_reg_clr_sel,
                      MO => waddr_reg_clr
                     );
    weregclr: nmux21
            port map (A => NC,
                      B => clr0,
                      S => we_reg_clr_sel,
                      MO => we_reg_clr
                     );
    
    wesel2: mux21
            port map (A => we_reg_mux_delayed,
                      B => we_pulse,
                      S => write_reg_sel,
                      MO => we_int
                     );
    
    wesel1: mux21
            port map (A => we,
                      B => we_reg,
                      S => write_reg_sel,
                      MO => we_reg_mux
                     );
    
    raddrsel: bmux21
            port map (A => raddr,
                      B => raddr_reg,
                      S => raddr_reg_sel,
                      MO => raddr_int
                     );
    
    raddrregclr: nmux21
            port map (A => NC,
                      B => clr0,
                      S => raddr_reg_clr_sel,
                      MO => raddr_reg_clr
                     );
    
    resel: mux21
            port map (A => re,
                      B => re_reg,
                      S => re_reg_sel,
                      MO => re_int
                     ); 
     
    dataoutsel: mux21
            port map (A => dataout_int,
                      B => dataout_reg,
                      S => dataout_reg_sel,
                      MO => dataout_tmp
                     ); 
     
    dataoutregclr: nmux21
            port map (A => NC,
                      B => clr0,
                      S => dataout_reg_clr_sel,
                      MO => dataout_reg_clr
                     );
    raddrclksel: mux21
            port map (A => clk0,
                      B => clk1,
                      S => raddr_clk_sel,
                      MO => raddr_clk
                     );
    raddrensel: mux21
            port map (A => ena0,
                      B => ena1,
                      S => raddr_en_sel,
                      MO => raddren
                     );       
    reclksel: mux21
            port map (A => clk0,
                      B => clk1,
                      S => re_clk_sel,
                      MO => re_clk
                     );
    reensel: mux21
            port map (A => ena0,
                      B => ena1,
                      S => re_en_sel,
                      MO => reen
                     );
    reregclr: nmux21
            port map (A => NC,
                      B => clr0,
                      S => re_reg_clr_sel,
                      MO => re_reg_clr
                     );

    dataoutensel: mux21
            port map (A => NC,
                      B => ena1,
                      S => dataout_en_sel,
                      MO => dataouten
                     );
    
    dinreg_clr <= datain_reg_clr and devclrn and devpor;
    dinreg: flex10ke_dffe
            port map (D => datain,
                      CLRN => dinreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => datain_reg
                     );
    
    wereg_clr <= we_reg_clr and devclrn and devpor; 
    waddrreg_clr <= waddr_reg_clr and devclrn and devpor; 
    
    wereg: flex10ke_dffe 
            port map (D => we,
                      CLRN => wereg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => we_reg
                     );
    
    -- clk0 for we_pulse should have the same delay as
    -- clk of wereg
    we_pulse <= we_reg_mux_delayed and (not clk0_delayed);
    
    wedelaybuf: and1
            port map (IN1 => we_reg_mux,
                      Y => we_reg_mux_delayed
                     );
    
    clk0weregdelaybuf: and1
            port map (IN1 => clk0,
                      Y => clk0_delayed
                     );
    
    rereg_clr <= re_reg_clr and devclrn and devpor; 
    rereg: flex10ke_dffe 
            port map (D => re,
                      CLRN => rereg_clr,
                      CLK => re_clk,
                      ENA => reen,
                      Q => re_reg
                     );
    
    dataoutreg_clr <= dataout_reg_clr and devclrn and devpor;
    dataoutreg: flex10ke_dffe 
            port map (D => dataout_int,
                      CLRN => dataoutreg_clr, 
                      CLK => clk1,
                      ENA => dataouten,
                      Q => dataout_reg
                     );
    
    waddrreg_0: flex10ke_dffe 
            port map (D => waddr(0),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(0)
                     );
    waddrreg_1: flex10ke_dffe 
            port map (D => waddr(1),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(1)
                     );
    waddrreg_2: flex10ke_dffe 
            port map (D => waddr(2),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(2)
                     );
    waddrreg_3: flex10ke_dffe 
            port map (D => waddr(3),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(3)
                     );
    waddrreg_4: flex10ke_dffe 
            port map (D => waddr(4),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(4)
                     );
    waddrreg_5: flex10ke_dffe 
            port map (D => waddr(5),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(5)
                     );
    waddrreg_6: flex10ke_dffe 
            port map (D => waddr(6),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(6)
                     );
    waddrreg_7: flex10ke_dffe 
            port map (D => waddr(7),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(7)
                     );
    waddrreg_8: flex10ke_dffe 
            port map (D => waddr(8),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(8)
                     );
    waddrreg_9: flex10ke_dffe 
            port map (D => waddr(9),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(9)
                     );
    waddrreg_10: flex10ke_dffe 
            port map (D => waddr(10),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(10)
                     );

    raddrreg_clr <= raddr_reg_clr and devclrn and devpor;
    raddrreg_0: flex10ke_dffe 
            port map (D => raddr(0),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(0)
                     );
    raddrreg_1: flex10ke_dffe 
            port map (D => raddr(1),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(1)
                     );
    raddrreg_2: flex10ke_dffe 
            port map (D => raddr(2),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(2)
                     );
    raddrreg_3: flex10ke_dffe 
            port map (D => raddr(3),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(3)
                     );
    raddrreg_4: flex10ke_dffe 
            port map (D => raddr(4),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(4)
                     );
    raddrreg_5: flex10ke_dffe 
            port map (D => raddr(5),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(5)
                     );
    raddrreg_6: flex10ke_dffe 
            port map (D => raddr(6),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(6)
                     );
    raddrreg_7: flex10ke_dffe 
            port map (D => raddr(7),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(7)
                     );
    raddrreg_8: flex10ke_dffe 
            port map (D => raddr(8),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(8)
                     );
    raddrreg_9: flex10ke_dffe 
            port map (D => raddr(9),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(9)
                     );
    raddrreg_10: flex10ke_dffe 
            port map (D => raddr(10),
                      CLRN => raddrreg_clr,
                      CLK => raddr_clk,
                      ENA => raddren,
                      Q => raddr_reg(10)
                     );

    flexmem: flex10ke_asynch_mem
          generic map (ADDRESS_WIDTH => address_width,
                       BIT_NUMBER => bit_number,
                       FIRST_ADDRESS => first_address,
                       LAST_ADDRESS => last_address,
                       MEM1 => mem1,
                       MEM2 => mem2,
                       MEM3 => mem3,
                       MEM4 => mem4,
                       INIFILE      => init_file,
                       WRITE_LOGIC_CLOCK => write_logic_clock,
                       READ_ENABLE_CLOCK => read_enable_clock,
                       DATA_OUT_CLOCK => data_out_clock,
                       OPERATION_MODE => operation_mode,
                       LOGICAL_RAM_DEPTH => logical_ram_depth
                      )

          port map    (DATAIN => datain_int,
                       WE => we_int,
                       RE => re_int,
                       RADDR => raddr_int,
                       WADDR => waddr_int, 
                       MODESEL => modesel,
                       DATAOUT => dataout_int
                      );

    raddr_num <= conv_integer(raddr_int);

    valid_addr <= '1' when raddr_num <= last_address and raddr_num >= first_address else '0';

    dataout <= dataout_tmp;

end structure;

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : FLEX10KE_PLL
--
-- Description : Timing Simulation model for the FLEX10KE device family PLL
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.flex10ke_atom_pack.all;

ENTITY  flex10ke_pll is
    GENERIC (
             input_frequency         : integer := 1000;
             clk1_multiply_by        : integer := 1;
             tipd_clk                : VitalDelayType01 := DefpropDelay01
            );

    PORT    (clk                     : in std_logic;
             clk0                    : out std_logic;
             clk1                    : out std_logic;
             locked                  : out std_logic
            );
        attribute VITAL_LEVEL0 of flex10ke_pll : ENTITY is TRUE;
end flex10ke_pll;

ARCHITECTURE vital_pll_atom of flex10ke_pll is
attribute VITAL_LEVEL0 of vital_pll_atom : ARCHITECTURE is TRUE;

signal clk_ipd                   : std_logic;
signal clklock1_half_period      : TIME;
signal clklock2_half_period      : TIME;
signal new_inclk1                : STD_LOGIC;
signal new_inclk2                : STD_LOGIC;
signal start_inclk               : STD_LOGIC;
signal clklock_rising_edge_count : INTEGER := 0 ;
signal clklock_cycle             : TIME ;
signal clklock_duty_cycle        : TIME ;
signal clklock_last_rising_edge  : TIME ;
signal clklock_last_falling_edge : TIME ;
signal clock1_count              : INTEGER := -1 ;
signal clock2_count              : INTEGER := -1 ;
signal clklock_lock              : BOOLEAN := TRUE;
signal locked_tmp0               : STD_LOGIC := '0';
signal locked_tmp1               : STD_LOGIC := '0';
signal clk0_multiply_by          : INTEGER := 1;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
    end block;

    VITALtiming : process (clk_ipd)
    begin

    end process;

    edge_count: PROCESS
    VARIABLE expected_cycle : REAL;
    VARIABLE real_cycle : REAL;
    BEGIN

        WAIT UNTIL (clk_ipd'EVENT AND clk_ipd = '1');       -- Detect First Edge
        clklock_rising_edge_count <= clklock_rising_edge_count +1;
        clklock_last_rising_edge <= NOW;
   
        IF ((clk1_multiply_by < 1) OR (clk1_multiply_by > 2)) THEN
            ASSERT ((clk1_multiply_by >= 1) AND (clk1_multiply_by <= 2))
            REPORT "Invalid Clock1 Multiplication Factor"
            SEVERITY WARNING;
            clklock_lock <= FALSE;
        END IF;        

        IF clklock_rising_edge_count = 0 THEN      -- at 1st rising edge
           start_inclk <= clk_ipd;
        ELSE
            IF clklock_rising_edge_count = 1 THEN      -- at 2nd rising edge
                clklock_cycle <= NOW - clklock_last_rising_edge;    -- calculate period
                expected_cycle := real(input_frequency) / 1000.0;
                real_cycle := REAL( (NOW - clklock_last_rising_edge) / 1 ns);
                IF ( real_cycle < (expected_cycle - 1.0)  OR
                    real_cycle > (expected_cycle + 1.0) ) THEN
                    ASSERT ( (expected_cycle - 1.0) <= real_cycle AND
                           real_cycle <= (expected_cycle + 1.0) )
                    REPORT " Input_Frequency Violation "
                    SEVERITY WARNING;
                    clklock_lock <= FALSE;
                END IF;
               IF ( (NOW - clklock_last_falling_edge) /= clklock_duty_cycle ) THEN
                   ASSERT (NOW - clklock_last_falling_edge) = clklock_duty_cycle
                   REPORT " Duty Cycle Violation "
                   SEVERITY WARNING;
                   clklock_lock <= FALSE;
               END IF;
            ELSE
                IF ( (NOW - clklock_last_rising_edge) /= clklock_cycle ) THEN
                    ASSERT (NOW - clklock_last_rising_edge) = clklock_cycle
                    REPORT " Cycle Violation "
                    SEVERITY WARNING;
                    clklock_lock <= FALSE;
                END IF;
            END IF;
        END IF;


        WAIT UNTIL (clk_ipd'EVENT AND clk_ipd = '0');       -- Detect Secound Edge
        IF clklock_rising_edge_count = 1 THEN      -- at 1st falling edge
            -- Calculate new 1/2 Cycle
            clklock1_half_period <= (NOW - clklock_last_rising_edge)/clk0_multiply_by;
            clklock2_half_period <= (NOW - clklock_last_rising_edge)/clk1_multiply_by;
            clklock_duty_cycle <= NOW - clklock_last_rising_edge;   -- calculate duty cycle
            clklock_last_falling_edge <= NOW;
        ELSE
            IF ( (NOW - clklock_last_rising_edge) /= clklock_duty_cycle ) THEN
                ASSERT (NOW - clklock_last_rising_edge) = clklock_duty_cycle
                REPORT " Duty Cycle Violation "
                SEVERITY WARNING;
                clklock_lock <= FALSE;
            END IF;
        END IF;

    END PROCESS edge_count;

    toggle1: PROCESS
    BEGIN
        WAIT ON clklock_rising_edge_count;
        IF clklock_rising_edge_count > 2 THEN
            FOR i IN 1 TO 2*clk0_multiply_by LOOP   -- Count the new clock edges
                clock1_count <= clock1_count + 1;
                WAIT FOR clklock1_half_period;
            END LOOP;
        ELSE
            clock1_count <= 0;
        END IF;
    END PROCESS toggle1;

    toggle2 : process
    begin
        WAIT ON clklock_rising_edge_count;
        IF clklock_rising_edge_count > 2 then
            for i in 1 to 2*clk1_multiply_by loop
                clock2_count <= clock2_count + 1;
                wait for clklock2_half_period;
            end loop;
        else
            clock2_count <= 0;
        end if;
    end process toggle2;


    gen_clkout1: PROCESS                     -- Generate new clock
    VARIABLE clkout1_zd : STD_LOGIC;
    BEGIN
        IF ( clock1_count <= 0 OR clklock_lock = FALSE ) THEN
            -- handle falling edge first case
            clk0 <= '0';                  -- avoid 'U'
            clkout1_zd := '0' ;
        END IF;
        WAIT ON clock1_count, clklock_lock;
        IF ( clock1_count = 0 OR clklock_lock = FALSE ) THEN
            clkout1_zd := '0' ;
        ELSE
            IF clock1_count = 1 THEN
                new_inclk1 <= NOT start_inclk;
                clkout1_zd := start_inclk ;
                locked_tmp0 <= '1';
            ELSE
                new_inclk1 <= NOT new_inclk1;
                clkout1_zd := new_inclk1 ;
            END IF;
        END IF;

    clk0 <= clkout1_zd;
    end process gen_clkout1;

    gen_clkout2 : process
    variable clkout2_zd : std_logic;
    begin
        if (clock2_count <= 0 or clklock_lock = false) then
            -- handle falling edge first case
            clk1 <= '0';
            clkout2_zd := '0';
        end if;
        wait on clock2_count, clklock_lock;
        if (clock2_count = 0 or clklock_lock = false) then
            clkout2_zd := '0';
        else
            if clock2_count = 1 then
                new_inclk2 <= not start_inclk;
                clkout2_zd := start_inclk;
                locked_tmp1 <= '1';
            else
                new_inclk2 <= not new_inclk2;
                clkout2_zd := new_inclk2;
            end if;
        end if;
        clk1 <= clkout2_zd;
    end process gen_clkout2;

    locked <= '0' when clklock_lock = false else (locked_tmp0 or locked_tmp1);

end vital_pll_atom;
