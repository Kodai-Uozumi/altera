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
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;

package apex20ke_atom_pack is

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

end apex20ke_atom_pack;

LIBRARY IEEE;
use IEEE.std_logic_1164.all;

package body apex20ke_atom_pack is

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

end apex20ke_atom_pack;
--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for APEX20KE Atoms
--
--/////////////////////////////////////////////////////////////////////////////
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;

ENTITY dffe_io is
   GENERIC (
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

   PORT (
      Q                              :  out   STD_LOGIC;
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of dffe_io : ENTITY is TRUE;
end dffe_io;

-- ARCHITECTURE body --

ARCHITECTURE behave of dffe_io is
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

end behave;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_asynch_lcell
--
-- Description : Simulation model for asynchronous submodule of
--               APEX 20KE Lcell.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;

ENTITY apex20ke_asynch_lcell is
    GENERIC (
        operation_mode    : string := "normal";
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
        tpd_dataa_combout  : VitalDelayType01 := DefPropDelay01;
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
        tpd_dataa_cout     : VitalDelayType01 := DefPropDelay01;
        tpd_datab_cout     : VitalDelayType01 := DefPropDelay01;
        tpd_datac_cout     : VitalDelayType01 := DefPropDelay01;
        tpd_datad_cout     : VitalDelayType01 := DefPropDelay01;
        tpd_qfbkin_cout    : VitalDelayType01 := DefPropDelay01;
        tpd_cin_cout       : VitalDelayType01 := DefPropDelay01;
        tpd_cascin_cascout : VitalDelayType01 := DefPropDelay01;
        tpd_cin_cascout    : VitalDelayType01 := DefPropDelay01;
        tpd_dataa_cascout  : VitalDelayType01 := DefPropDelay01;
        tpd_datab_cascout  : VitalDelayType01 := DefPropDelay01;
        tpd_datac_cascout  : VitalDelayType01 := DefPropDelay01;
        tpd_datad_cascout  : VitalDelayType01 := DefPropDelay01;
        tpd_qfbkin_cascout : VitalDelayType01 := DefPropDelay01;
        tipd_dataa         : VitalDelayType01 := DefPropDelay01; 
        tipd_datab         : VitalDelayType01 := DefPropDelay01; 
        tipd_datac         : VitalDelayType01 := DefPropDelay01; 
        tipd_datad         : VitalDelayType01 := DefPropDelay01; 
        tipd_cin           : VitalDelayType01 := DefPropDelay01; 
        tipd_cascin        : VitalDelayType01 := DefPropDelay01
        );

    PORT (
        dataa   : in std_logic := '1';
        datab   : in std_logic := '1';
        datac   : in std_logic := '1';
        datad   : in std_logic := '1';
        cin     : in std_logic := '0';
        cascin  : in std_logic := '1';
        qfbkin  : in std_logic := '0';
        combout : out std_logic;
        cout    : out std_logic;
        cascout : out std_logic;
        regin   : out std_logic
        );
    attribute VITAL_LEVEL0 of apex20ke_asynch_lcell : ENTITY is TRUE;
end apex20ke_asynch_lcell;
        
ARCHITECTURE vital_le of apex20ke_asynch_lcell is
    attribute VITAL_LEVEL0 of vital_le : ARCHITECTURE is TRUE;
    signal dataa_ipd : std_logic;
    signal datab_ipd : std_logic;
    signal datac_ipd : std_logic;
    signal datad_ipd : std_logic;
    signal cin_ipd : std_logic;
    signal cascin_ipd : std_logic;
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

    VITALtiming : process(dataa_ipd, datab_ipd, datac_ipd, datad_ipd, 
                          cin_ipd, cascin_ipd, qfbkin)

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
                                   dselect => (datad_ipd, cin_ipd, 
                                               datab_ipd, dataa_ipd)
                                  ); -- Added By ModelTech
            else
                icomb1 := VitalMUX(data => lut_mask_std,
                                   dselect => (datad_ipd, datac_ipd, 
                                               datab_ipd, dataa_ipd)
                                  ); -- Added By ModelTech
            end if;
            icomb := icomb1 and cascin_ipd;
        end if;

        if operation_mode = "arithmetic" then
            icomb1 := VitalMUX(data => lut_mask_std,
                               dselect => ('1', cin_ipd, datab_ipd, 
                                           dataa_ipd)
                              ); -- Added By ModelTech

            icout := VitalMUX(data => lut_mask_std,
                              dselect => ('0', cin_ipd, datab_ipd, 
                                          dataa_ipd)
                             ); -- Added By ModelTech
            icomb := icomb1 and cascin_ipd;
	end if;

	if operation_mode = "counter" then
            icomb1 := VitalMUX(data => lut_mask_std,
                               dselect => ('1', cin_ipd, datab_ipd, 
                                           dataa_ipd)
                              ); -- Added By ModelTech
            icout := VitalMUX(data => lut_mask_std,
                              dselect => ('0', cin_ipd, datab_ipd, 
                                          dataa_ipd)
                             ); -- Added By ModelTech
            icomb := icomb1 and cascin_ipd;
        end if;

	if operation_mode = "qfbk_counter" then
            icomb1 := VitalMUX(data => lut_mask_std,
                               dselect => ('1', qfbkin, datab_ipd, 
                                           dataa_ipd)
                              ); -- Added By ModelTech
            icout := VitalMUX(data => lut_mask_std,
                              dselect => ('0', qfbkin, datab_ipd, 
                                          dataa_ipd)
                             ); -- Added By ModelTech
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
            MsgOn => MsgOn
            );
        
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
            MsgOn => MsgOn
            );
        
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
            MsgOn => MsgOn
            );
        
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
            MsgOn => MsgOn
            );

    end process;

end vital_le;	

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_lcell_register
--
-- Description : Simulation model for the register submodule of 
--               APEX 20KE Lcell.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;

ENTITY apex20ke_lcell_register is
    GENERIC (
        power_up : string := "low";
        packed_mode   : string := "false";
        x_on_violation : string := "on";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_datac_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tsetup_sclr_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
        tsetup_sload_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        thold_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        thold_datac_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
        thold_sclr_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        thold_sload_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
        tpd_clk_regout_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_aclr_regout_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_clk_qfbko_posedge   : VitalDelayType01 := DefPropDelay01;
        tpd_aclr_qfbko_posedge  : VitalDelayType01 := DefPropDelay01;
        tperiod_clk_posedge     : VitalDelayType := DefPulseWdthCnst;
        tipd_datac : VitalDelayType01 := DefPropDelay01; 
        tipd_ena   : VitalDelayType01 := DefPropDelay01; 
        tipd_aclr  : VitalDelayType01 := DefPropDelay01; 
        tipd_sclr  : VitalDelayType01 := DefPropDelay01; 
        tipd_sload : VitalDelayType01 := DefPropDelay01; 
        tipd_clk   : VitalDelayType01 := DefPropDelay01
        );

    PORT (
        clk     : in std_logic;
        datain  : in std_logic := '1';
        datac   : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr    : in std_logic := '0';
        sload   : in std_logic := '0';
        ena     : in std_logic := '1';
        devclrn : in std_logic := '1';
        devpor  : in std_logic := '1';
        regout  : out std_logic;
        qfbko   : out std_logic
        );
    attribute VITAL_LEVEL0 of apex20ke_lcell_register : ENTITY is TRUE;
end apex20ke_lcell_register;
        
ARCHITECTURE vital_le_reg of apex20ke_lcell_register is
    attribute VITAL_LEVEL0 of vital_le_reg : ARCHITECTURE is TRUE;
    signal ena_ipd, sload_ipd, datac_ipd : std_logic;
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
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming : process(clk_ipd, aclr_ipd, devclrn, devpor, sclr_ipd,
                          ena_ipd, datain, datac_ipd, sload_ipd)

    variable Tviol_datain_clk : std_ulogic := '0';
    variable Tviol_datac_clk : std_ulogic := '0';
    variable Tviol_sclr_clk : std_ulogic := '0';
    variable Tviol_sload_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable Tviol_clk : std_ulogic := '0';
    variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_datac_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sclr_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_sload_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    variable PeriodData_clk : VitalPeriodDataType := VitalPeriodDataInit;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    variable qfbko_VitalGlitchData : VitalGlitchDataType;
    
    variable iregout : std_logic;
    variable idata : std_logic := '0';
    variable setbit : std_logic := '0';
    variable tmp_regout : std_logic;
    variable tmp_qfbko : std_logic;
    
    -- variables for 'X' generation
    variable violation : std_logic := '0';

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
                CheckEnabled    => TO_X01((aclr_ipd) OR 
                                          (NOT devpor) OR 
                                          (NOT devclrn) OR 
                                          (sload_ipd) OR 
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks
                );
    
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
                CheckEnabled    => TO_X01((aclr_ipd) OR 
                                          (NOT devpor) OR 
                                          (NOT devclrn) OR 
                                          (NOT ena_ipd)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks
                );
    
    
            VitalSetupHoldCheck (
                Violation       => Tviol_ena_clk,
                TimingData      => TimingData_ena_clk,
                TestSignal      => ena_ipd,
                TestSignalName  => "ENA",
                RefSignal       => clk_ipd,
                RefSignalName   => "CLK",
                SetupHigh       => tsetup_ena_clk_noedge_posedge,
                SetupLow        => tsetup_ena_clk_noedge_posedge,
                HoldHigh        => thold_ena_clk_noedge_posedge,
                HoldLow         => thold_ena_clk_noedge_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR 
                                          (NOT devpor) OR 
                                          (NOT devclrn)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks
                );
    
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
                CheckEnabled    => TO_X01((aclr_ipd) OR 
                                          (NOT devpor) OR 
                                          (NOT devclrn)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks
                );
    
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
                CheckEnabled    => TO_X01((aclr_ipd) OR 
                                          (NOT devpor) OR 
                                          (NOT devclrn)) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks
                );
    
            VitalPeriodPulseCheck (
                Violation       => Tviol_clk,
                PeriodData      => PeriodData_clk,
                TestSignal      => clk_ipd,
                TestSignalName  => "CLK",
                Period          => tperiod_clk_posedge,
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
                HeaderMsg       => InstancePath & "/LCELL",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks
                );
 
        end if;

        violation := Tviol_datain_clk or Tviol_datac_clk or 
                     Tviol_ena_clk or Tviol_sclr_clk or 
                     Tviol_sload_clk or Tviol_clk;

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
        elsif (violation = 'X' and x_on_violation = "on") then
            iregout := 'X';
        elsif (clk_ipd'event and clk_ipd = '1' and 
               clk_ipd'last_value = '0') then
            if (ena_ipd = '1') then
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
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
        
        VitalPathDelay01 (
            OutSignal => qfbko,
            OutSignalName => "QFBKO",
            OutTemp => tmp_qfbko,
            Paths => (0 => (aclr_ipd'last_event, tpd_aclr_qfbko_posedge, TRUE),
                      1 => (clk_ipd'last_event, tpd_clk_qfbko_posedge, TRUE)),
            GlitchData => qfbko_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );

    end process;

end vital_le_reg;	

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_lcell
--
-- Description : Simulation model for APEX 20KE Lcell.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;
use work.apex20ke_asynch_lcell;
use work.apex20ke_lcell_register;

ENTITY apex20ke_lcell is
    GENERIC (
        operation_mode : string := "normal";
        output_mode    : string := "comb_and_reg";
        packed_mode    : string := "false";
        lut_mask       : string := "ffff";
        power_up       : string := "low";
        cin_used       : string := "false";
        lpm_type       : string := "apex20ke_lcell";
        x_on_violation : string := "on"
        );

    PORT (
        clk     : in std_logic;
        dataa   : in std_logic := '1';
        datab   : in std_logic := '1';
        datac   : in std_logic := '1';
        datad   : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr    : in std_logic := '0';
        sload   : in std_logic := '0';
        ena     : in std_logic := '1';
        cin     : in std_logic := '0';
        cascin  : in std_logic := '1';
        devclrn : in std_logic := '1';
        devpor  : in std_logic := '1';
        combout : out std_logic;
        regout  : out std_logic;
        cout    : out std_logic;
        cascout : out std_logic
        );
end apex20ke_lcell;
        
ARCHITECTURE vital_le_atom of apex20ke_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

COMPONENT apex20ke_asynch_lcell 
    GENERIC (
        operation_mode    : string := "normal";
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
        tpd_dataa_combout  : VitalDelayType01 := DefPropDelay01;
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
        tpd_dataa_cout     : VitalDelayType01 := DefPropDelay01;
        tpd_datab_cout     : VitalDelayType01 := DefPropDelay01;
        tpd_datac_cout     : VitalDelayType01 := DefPropDelay01;
        tpd_datad_cout     : VitalDelayType01 := DefPropDelay01;
        tpd_qfbkin_cout    : VitalDelayType01 := DefPropDelay01;
        tpd_cin_cout       : VitalDelayType01 := DefPropDelay01;
        tpd_cascin_cascout : VitalDelayType01 := DefPropDelay01;
        tpd_cin_cascout    : VitalDelayType01 := DefPropDelay01;
        tpd_dataa_cascout  : VitalDelayType01 := DefPropDelay01;
        tpd_datab_cascout  : VitalDelayType01 := DefPropDelay01;
        tpd_datac_cascout  : VitalDelayType01 := DefPropDelay01;
        tpd_datad_cascout  : VitalDelayType01 := DefPropDelay01;
        tpd_qfbkin_cascout : VitalDelayType01 := DefPropDelay01;
        tipd_dataa  : VitalDelayType01 := DefPropDelay01; 
        tipd_datab  : VitalDelayType01 := DefPropDelay01; 
        tipd_datac  : VitalDelayType01 := DefPropDelay01; 
        tipd_datad  : VitalDelayType01 := DefPropDelay01; 
        tipd_cin    : VitalDelayType01 := DefPropDelay01; 
        tipd_cascin : VitalDelayType01 := DefPropDelay01
        ); 

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
        regin     : out std_logic
        );

END COMPONENT;

COMPONENT apex20ke_lcell_register
    GENERIC (
        power_up : string := "low";
        packed_mode   : string := "false";
        x_on_violation : string := "on";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_datac_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tsetup_sclr_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
        tsetup_sload_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        thold_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        thold_datac_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
        thold_sclr_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        thold_sload_clk_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge     : VitalDelayType := DefSetupHoldCnst;
        tpd_clk_regout_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_aclr_regout_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_clk_qfbko_posedge   : VitalDelayType01 := DefPropDelay01;
        tpd_aclr_qfbko_posedge  : VitalDelayType01 := DefPropDelay01;
        tperiod_clk_posedge     : VitalDelayType := DefPulseWdthCnst;
        tipd_datac : VitalDelayType01 := DefPropDelay01; 
        tipd_ena   : VitalDelayType01 := DefPropDelay01; 
        tipd_aclr  : VitalDelayType01 := DefPropDelay01; 
        tipd_sclr  : VitalDelayType01 := DefPropDelay01; 
        tipd_sload : VitalDelayType01 := DefPropDelay01; 
        tipd_clk   : VitalDelayType01 := DefPropDelay01
        );

    PORT (
        clk     : in std_logic;
        datain  : in std_logic := '1';
        datac   : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr    : in std_logic := '0';
        sload   : in std_logic := '0';
        ena     : in std_logic := '1';
        devclrn : in std_logic := '1';
        devpor  : in std_logic := '1';
        regout  : out std_logic;
        qfbko   : out std_logic
        );

END COMPONENT;

begin

    lecomb: apex20ke_asynch_lcell
            generic map (operation_mode => operation_mode, 
                         output_mode => output_mode,
                         lut_mask => lut_mask,
                         cin_used => cin_used
                        )
            port map (dataa => dataa,
                      datab => datab,
                      datac => datac,
                      datad => datad,
                      cin => cin,
                      cascin => cascin, 
                      qfbkin => qfbk,
                      combout => combout,
                      cout => cout,
                      cascout => cascout,
                      regin => dffin
                     );

    lereg: apex20ke_lcell_register
           generic map (power_up => power_up,
                        packed_mode => packed_mode,
                        x_on_violation => x_on_violation
                       )
           port map (clk => clk,
                     datain => dffin,
                     datac => datac, 
                     aclr => aclr,
                     sclr => sclr,
                     sload => sload,
                     ena => ena,
                     devclrn => devclrn,
                     devpor => devpor,
                     regout => regout,
                     qfbko => qfbk
                    );


end vital_le_atom;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_asynch_io
--
-- Description : Simulation model for asynchronous submodule of
--               APEX 20KE IO.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;

ENTITY apex20ke_asynch_io is
    GENERIC (
        operation_mode : string := "input";
        reg_source_mode :  string := "none";
        feedback_mode : string := "from_pin";
        open_drain_output : string := "false";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tpd_datain_padio     : VitalDelayType01 := DefPropDelay01;
        tpd_padio_combout    : VitalDelayType01 := DefPropDelay01;
        tpd_oe_padio_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_oe_padio_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_dffeQ_padio      : VitalDelayType01 := DefPropDelay01;
        tpd_dffeQ_regout     : VitalDelayType01 := DefPropDelay01;
        tipd_datain          : VitalDelayType01 := DefPropDelay01;
        tipd_oe              : VitalDelayType01 := DefPropDelay01;
        tipd_padio           : VitalDelayType01 := DefPropDelay01
        );

    PORT (
        datain  : in std_logic;
        dffeQ   : in std_logic;
        oe      : in std_logic;
        padio   : inout std_logic;
        dffeD   : out std_logic;
        combout : out std_logic; 
        regout  : out std_logic
        );

    attribute VITAL_LEVEL0 of apex20ke_asynch_io : ENTITY is TRUE;
end apex20ke_asynch_io;

ARCHITECTURE vital_asynch_io of apex20ke_asynch_io is
    attribute VITAL_LEVEL0 of vital_asynch_io : ARCHITECTURE is TRUE;

    signal oe_ipd : std_logic;
    signal datain_ipd : std_logic;
    signal padio_ipd  : std_logic;

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
    variable regout_VitalGlitchData : VitalGlitchDataType;
    variable combout_VitalGlitchData : VitalGlitchDataType;
    variable padio_VitalGlitchData : VitalGlitchDataType;
    variable dffeD_VitalGlitchData : VitalGlitchDataType;
    
    variable tri_in : std_logic := '0';
    variable reg_indata : std_logic;
    variable tmp_combout : std_logic;
    variable tmp_padio : std_logic;
    variable oe_val : std_logic;
    variable temp : std_logic;

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
                tmp_combout := to_x01z(padio_ipd);
            elsif (operation_mode = "bidir") then
                tmp_combout := to_x01z(padio_ipd);
                tri_in := datain_ipd;
            end if;
        elsif ((reg_source_mode = "data_in") and
               (feedback_mode = "from_reg")) then
            if ((operation_mode = "output") or
                (operation_mode = "bidir")) then
                tri_in := datain_ipd;
                reg_indata := datain_ipd;
            end if;
        elsif ((reg_source_mode = "data_in") and
               (feedback_mode = "from_pin_and_reg")) then
            if (operation_mode = "input") then
                tmp_combout := to_x01z(padio_ipd);
                reg_indata := datain_ipd;
            elsif (operation_mode = "bidir") then
                tmp_combout := to_x01z(padio_ipd);
                tri_in := datain_ipd;
                reg_indata := datain_ipd;
            end  if;
        elsif ((reg_source_mode = "pin_only") and
               (feedback_mode = "from_pin_and_reg"))  then
            if (operation_mode = "input") then
                tmp_combout := to_x01z(padio_ipd);
                reg_indata := to_x01z(padio_ipd);
            elsif (operation_mode = "bidir") then
                tri_in := datain_ipd;
                tmp_combout := to_x01z(padio_ipd);
                reg_indata := to_x01z(padio_ipd);
            end if;
        elsif ((reg_source_mode = "pin_only") and
               (feedback_mode = "from_reg")) then
            if (operation_mode = "input") then
                reg_indata := to_x01z(padio_ipd);
            elsif (operation_mode = "bidir") then
                tri_in := datain_ipd;
                reg_indata := to_x01z(padio_ipd);
            end if;
        elsif ((reg_source_mode = "data_in_to_pin") and
               (feedback_mode = "from_pin")) then
            if (operation_mode = "bidir") then
                tri_in := dffeQ;
                reg_indata := datain_ipd;
                tmp_combout := to_x01z(padio_ipd);
            end if;
        elsif ((reg_source_mode = "data_in_to_pin") and
               (feedback_mode = "from_reg")) then
            if ((operation_mode = "output") or
                (operation_mode = "bidir")) then
                reg_indata := datain_ipd;
                tri_in := dffeQ;
            end if;
        elsif ((reg_source_mode = "data_in_to_pin") and
               (feedback_mode = "none")) then
            if ((operation_mode = "output") or
                (operation_mode = "bidir")) then
                tri_in := dffeQ;
                reg_indata := datain_ipd;
            end if;
        elsif ((reg_source_mode = "data_in_to_pin") and
               (feedback_mode = "from_pin_and_reg")) then
            if (operation_mode = "bidir") then
                reg_indata := datain_ipd;
                tri_in := dffeQ;
                tmp_combout := to_x01z(padio_ipd);
            end if;
        elsif ((reg_source_mode = "pin_loop") and
               (feedback_mode = "from_pin")) then
            if (operation_mode = "bidir") then
                tri_in := dffeQ;
                reg_indata := to_x01z(padio_ipd);
                tmp_combout := to_x01z(padio_ipd);
            end if;
        elsif ((reg_source_mode = "pin_loop") and
               (feedback_mode = "from_pin_and_reg")) then
            if (operation_mode = "bidir") then
                reg_indata := to_x01z(padio_ipd);
                tri_in := dffeQ;
                tmp_combout := to_x01z(padio_ipd);
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
                if (temp = '0') then
                    tmp_padio := '0';
                else
                    tmp_padio := 'Z';
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
        VitalPathDelay01 (
            OutSignal => regout,
            OutSignalName => "REGOUT",
            OutTemp => dffeQ,
            Paths => (0 => (dffeQ'last_event,
                            tpd_dffeQ_regout,
                            TRUE)),
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
             
        VitalPathDelay01 (
            OutSignal => combout,
            OutSignalName => "COMBOUT",
            OutTemp => tmp_combout,
            Paths => (0 => (padio_ipd'last_event,
                            tpd_padio_combout,
                            TRUE)),
            GlitchData => combout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn => MsgOn
            );
            
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
            MsgOn => MsgOn
            );

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
            MsgOn => MsgOn
            );

    end process;
end vital_asynch_io;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_io
--
-- Description : Simulation model for APEX 20KE IO.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;
use work.dffe_io;
use work.apex20ke_asynch_io;

ENTITY apex20ke_io is
    GENERIC (
        operation_mode : string := "input";
        reg_source_mode :  string := "none";
        feedback_mode : string := "from_pin";
        power_up : string := "low";
        open_drain_output : string := "false"
        );

    PORT (
        clk    : in std_logic;
        datain : in std_logic;
        aclr   : in std_logic;
        preset : in std_logic;
        ena    : in std_logic;
        oe     : in std_logic;
        devclrn   : in std_logic := '1';
        devpor : in std_logic := '1';
        devoe  : in std_logic := '0';
        padio  : inout std_logic;
        combout : out std_logic;
        regout  : out std_logic
        );

end apex20ke_io;

ARCHITECTURE arch of apex20ke_io is

    signal reg_clr, reg_pre : std_logic := '1';
    signal ioreg_clr, ioreg_pre : std_logic := '1';
    signal vcc : std_logic := '1';
    signal dffeD : std_logic;
    signal comb_out: std_logic;
    signal reg_out : std_logic;
    signal dffe_Q : std_logic;

COMPONENT dffe_io
    GENERIC (
        TimingChecksOn: Boolean := true;
        XGenerationOn: Boolean := false;
        InstancePath: STRING := "*";
        XOn: Boolean := DefGlitchXOn;
        MsgOn: Boolean := DefGlitchMsgOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        tpd_PRN_Q_negedge  : VitalDelayType01 := DefPropDelay01;
        tpd_CLRN_Q_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_CLK_Q_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_ENA_Q_posedge  :  VitalDelayType01 := DefPropDelay01;
        tsetup_D_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_D_CLK_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_ENA_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_D_CLK_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        thold_D_CLK_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
        thold_ENA_CLK_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        tipd_D    : VitalDelayType01 := DefPropDelay01;
        tipd_CLRN : VitalDelayType01 := DefPropDelay01;
        tipd_PRN  : VitalDelayType01 := DefPropDelay01;
        tipd_CLK  : VitalDelayType01 := DefPropDelay01;
        tipd_ENA  : VitalDelayType01 := DefPropDelay01
        );
        
    PORT (
        Q    : out STD_LOGIC := '0';
        D    : in STD_LOGIC := '1';
        CLRN : in STD_LOGIC := '1';
        PRN  : in STD_LOGIC := '1';
        CLK  : in STD_LOGIC := '0';
        ENA  : in STD_LOGIC := '1'
        );

END COMPONENT;

COMPONENT apex20ke_asynch_io
    GENERIC (
        operation_mode : string := "input";
        reg_source_mode :  string := "none";
        feedback_mode : string := "from_pin";
        open_drain_output : string := "false";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tpd_datain_padio     : VitalDelayType01 := DefPropDelay01;
        tpd_padio_combout    : VitalDelayType01 := DefPropDelay01;
        tpd_oe_padio_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_oe_padio_negedge : VitalDelayType01 := DefPropDelay01;
        tpd_dffeQ_padio      : VitalDelayType01 := DefPropDelay01;
        tpd_dffeQ_regout     : VitalDelayType01 := DefPropDelay01;
        tipd_datain          : VitalDelayType01 := DefPropDelay01;
        tipd_oe              : VitalDelayType01 := DefPropDelay01;
        tipd_padio           : VitalDelayType01 := DefPropDelay01
        );

    PORT (
        datain  : in std_logic;
        dffeQ   : in std_logic;
        oe      : in std_logic;
        padio   : inout std_logic;
        dffeD   : out std_logic;
        combout : out std_logic; 
        regout  : out std_logic
        );
END COMPONENT;

begin

    reg_clr <= devpor when power_up = "low" else vcc;
    reg_pre <= devpor when power_up = "high" else vcc;

    ioreg_clr <= devclrn and (not aclr) and reg_clr;
    ioreg_pre <= (not preset) and reg_pre;

    asynch_inst: apex20ke_asynch_io
                 generic map (operation_mode => operation_mode,
                              reg_source_mode => reg_source_mode,
                              feedback_mode => feedback_mode,
                              open_drain_output => open_drain_output
                             )

                 port map (datain => datain,
                           oe => oe,
                           padio => padio,
                           dffeD => dffeD,
                           dffeQ => dffe_Q,
                           combout => comb_out,
                           regout => reg_out
                          );

    io_reg: dffe_io
            port map (D => dffeD,
                      clk => clk,
                      ena => ena,
                      Q => dffe_Q,
                      CLRN => ioreg_clr,
                      PRN => ioreg_pre
                     );

    combout <= comb_out;
    regout <= reg_out;

end arch;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_asynch_pterm
--
-- Description : Simulation model for asynchronous submodule of
--               APEX 20KE PTERM.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;

ENTITY apex20ke_asynch_pterm is
    GENERIC (
        operation_mode     : string := "normal";
        invert_pterm1_mode : string := "false";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tpd_pterm0_combout : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pterm1_combout : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pexpin_combout : VitalDelayType01 := DefPropDelay01;
        tpd_fbkin_combout  : VitalDelayType01 := DefPropDelay01;
        tpd_pterm0_regin   : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pterm1_regin   : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pexpin_regin   : VitalDelayType01 := DefPropDelay01;
        tpd_fbkin_regin    : VitalDelayType01 := DefPropDelay01;
        tpd_pterm0_pexpout : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pterm1_pexpout : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pexpin_pexpout : VitalDelayType01 := DefPropDelay01;
        tpd_fbkin_pexpout  : VitalDelayType01 := DefPropDelay01;
        tipd_pterm0 : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tipd_pterm1 : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tipd_pexpin : VitalDelayType01 := DefPropDelay01
        );


    PORT (
        pterm0 : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pterm1 : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pexpin : in std_logic := '0';
        fbkin  : in std_logic;
        combout : out std_logic;
        regin   : out std_logic;
        pexpout : out std_logic
        );
   attribute VITAL_LEVEL0 of apex20ke_asynch_pterm : ENTITY is TRUE;
end apex20ke_asynch_pterm; 

ARCHITECTURE vital_pterm of apex20ke_asynch_pterm is
    attribute VITAL_LEVEL0 of vital_pterm : ARCHITECTURE is TRUE;

signal pterm0_ipd : std_logic_vector(31 downto 0) := (OTHERS => 'U');
signal pterm1_ipd : std_logic_vector(31 downto 0) := (OTHERS => 'U');
signal pexpin_ipd : std_ulogic := 'U';

begin

        ---------------------
        --  INPUT PATH DELAYs
        ---------------------
        WireDelay : block
        begin
            VitalWireDelay (pterm0_ipd(0), pterm0(0), tipd_pterm0(0));
            VitalWireDelay (pterm0_ipd(1), pterm0(1), tipd_pterm0(1));
            VitalWireDelay (pterm0_ipd(2), pterm0(2), tipd_pterm0(2));
            VitalWireDelay (pterm0_ipd(3), pterm0(3), tipd_pterm0(3));
            VitalWireDelay (pterm0_ipd(4), pterm0(4), tipd_pterm0(4));
            VitalWireDelay (pterm0_ipd(5), pterm0(5), tipd_pterm0(5));
            VitalWireDelay (pterm0_ipd(6), pterm0(6), tipd_pterm0(6));
            VitalWireDelay (pterm0_ipd(7), pterm0(7), tipd_pterm0(7));
            VitalWireDelay (pterm0_ipd(8), pterm0(8), tipd_pterm0(8));
            VitalWireDelay (pterm0_ipd(9), pterm0(9), tipd_pterm0(9));
            VitalWireDelay (pterm0_ipd(10), pterm0(10), tipd_pterm0(10));
            VitalWireDelay (pterm0_ipd(11), pterm0(11), tipd_pterm0(11));
            VitalWireDelay (pterm0_ipd(12), pterm0(12), tipd_pterm0(12));
            VitalWireDelay (pterm0_ipd(13), pterm0(13), tipd_pterm0(13));
            VitalWireDelay (pterm0_ipd(14), pterm0(14), tipd_pterm0(14));
            VitalWireDelay (pterm0_ipd(15), pterm0(15), tipd_pterm0(15));
            VitalWireDelay (pterm0_ipd(16), pterm0(16), tipd_pterm0(16));
            VitalWireDelay (pterm0_ipd(17), pterm0(17), tipd_pterm0(17));
            VitalWireDelay (pterm0_ipd(18), pterm0(18), tipd_pterm0(18));
            VitalWireDelay (pterm0_ipd(19), pterm0(19), tipd_pterm0(19));
            VitalWireDelay (pterm0_ipd(20), pterm0(20), tipd_pterm0(20));
            VitalWireDelay (pterm0_ipd(21), pterm0(21), tipd_pterm0(21));
            VitalWireDelay (pterm0_ipd(22), pterm0(22), tipd_pterm0(22));
            VitalWireDelay (pterm0_ipd(23), pterm0(23), tipd_pterm0(23));
            VitalWireDelay (pterm0_ipd(24), pterm0(24), tipd_pterm0(24));
            VitalWireDelay (pterm0_ipd(25), pterm0(25), tipd_pterm0(25));
            VitalWireDelay (pterm0_ipd(26), pterm0(26), tipd_pterm0(26));
            VitalWireDelay (pterm0_ipd(27), pterm0(27), tipd_pterm0(27));
            VitalWireDelay (pterm0_ipd(28), pterm0(28), tipd_pterm0(28));
            VitalWireDelay (pterm0_ipd(29), pterm0(29), tipd_pterm0(29));
            VitalWireDelay (pterm0_ipd(30), pterm0(30), tipd_pterm0(30));
            VitalWireDelay (pterm0_ipd(31), pterm0(31), tipd_pterm0(31));
            VitalWireDelay (pterm1_ipd(0), pterm1(0), tipd_pterm1(0));
            VitalWireDelay (pterm1_ipd(1), pterm1(1), tipd_pterm1(1));
            VitalWireDelay (pterm1_ipd(2), pterm1(2), tipd_pterm1(2));
            VitalWireDelay (pterm1_ipd(3), pterm1(3), tipd_pterm1(3));
            VitalWireDelay (pterm1_ipd(4), pterm1(4), tipd_pterm1(4));
            VitalWireDelay (pterm1_ipd(5), pterm1(5), tipd_pterm1(5));
            VitalWireDelay (pterm1_ipd(6), pterm1(6), tipd_pterm1(6));
            VitalWireDelay (pterm1_ipd(7), pterm1(7), tipd_pterm1(7));
            VitalWireDelay (pterm1_ipd(8), pterm1(8), tipd_pterm1(8));
            VitalWireDelay (pterm1_ipd(9), pterm1(9), tipd_pterm1(9));
            VitalWireDelay (pterm1_ipd(10), pterm1(10), tipd_pterm1(10));
            VitalWireDelay (pterm1_ipd(11), pterm1(11), tipd_pterm1(11));
            VitalWireDelay (pterm1_ipd(12), pterm1(12), tipd_pterm1(12));
            VitalWireDelay (pterm1_ipd(13), pterm1(13), tipd_pterm1(13));
            VitalWireDelay (pterm1_ipd(14), pterm1(14), tipd_pterm1(14));
            VitalWireDelay (pterm1_ipd(15), pterm1(15), tipd_pterm1(15));
            VitalWireDelay (pterm1_ipd(16), pterm1(16), tipd_pterm1(16));
            VitalWireDelay (pterm1_ipd(17), pterm1(17), tipd_pterm1(17));
            VitalWireDelay (pterm1_ipd(18), pterm1(18), tipd_pterm1(18));
            VitalWireDelay (pterm1_ipd(19), pterm1(19), tipd_pterm1(19));
            VitalWireDelay (pterm1_ipd(20), pterm1(20), tipd_pterm1(20));
            VitalWireDelay (pterm1_ipd(21), pterm1(21), tipd_pterm1(21));
            VitalWireDelay (pterm1_ipd(22), pterm1(22), tipd_pterm1(22));
            VitalWireDelay (pterm1_ipd(23), pterm1(23), tipd_pterm1(23));
            VitalWireDelay (pterm1_ipd(24), pterm1(24), tipd_pterm1(24));
            VitalWireDelay (pterm1_ipd(25), pterm1(25), tipd_pterm1(25));
            VitalWireDelay (pterm1_ipd(26), pterm1(26), tipd_pterm1(26));
            VitalWireDelay (pterm1_ipd(27), pterm1(27), tipd_pterm1(27));
            VitalWireDelay (pterm1_ipd(28), pterm1(28), tipd_pterm1(28));
            VitalWireDelay (pterm1_ipd(29), pterm1(29), tipd_pterm1(29));
            VitalWireDelay (pterm1_ipd(30), pterm1(30), tipd_pterm1(30));
            VitalWireDelay (pterm1_ipd(31), pterm1(31), tipd_pterm1(31));
            VitalWireDelay (pexpin_ipd, pexpin, tipd_pexpin);
        end block;

    VITALtiming : process(pterm0_ipd, pterm1_ipd, pexpin_ipd, fbkin)
    
    
    variable combout_VitalGlitchData : VitalGlitchDataType;
    variable regin_VitalGlitchData : VitalGlitchDataType;
    variable pexpout_VitalGlitchData : VitalGlitchDataType;
    
    variable tmp_comb : std_logic;
    variable tmp_pexpout : std_logic;
    variable ipterm1 : std_logic := '1';
    
    begin
        if (invert_pterm1_mode = "false") then
            ipterm1 := product(pterm1_ipd);
        else
            ipterm1 := not product(pterm1_ipd);
        end if;
  
        if (operation_mode = "normal") then
            tmp_comb := (product(pterm0_ipd) or ipterm1) or pexpin_ipd;
        elsif (operation_mode = "invert") then
            tmp_comb := (product(pterm0_ipd) or ipterm1 or pexpin_ipd) xor '1';
        elsif (operation_mode = "xor") then
            tmp_comb := (ipterm1 or pexpin_ipd) xor product(pterm0_ipd);
        elsif (operation_mode = "packed_pterm_exp") then
            tmp_comb := product(pterm0_ipd);
            tmp_pexpout := ipterm1 or pexpin_ipd;
        elsif (operation_mode = "pterm_exp") then
            tmp_pexpout := product(pterm0_ipd) or ipterm1 or pexpin_ipd;
        elsif (operation_mode = "tff") then
            tmp_comb := (product(pterm0_ipd) or ipterm1 or pexpin_ipd) xor fbkin;
        elsif (operation_mode = "tbarff") then
            tmp_comb := (product(pterm0_ipd) or ipterm1 or pexpin_ipd) xor  (not fbkin);
        elsif (operation_mode = "packed_tff") then
            tmp_pexpout := product(pterm0_ipd) or ipterm1 or pexpin_ipd;
            tmp_comb := fbkin xor '1'; -- feed this to regin. not combout
        else
            tmp_comb := 'Z';
            tmp_pexpout := 'Z';
        end if;
  
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => combout,
            OutSignalName => "COMBOUT",
            OutTemp => tmp_comb,
            Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_combout(0), TRUE),
                      2 => (pterm1_ipd'last_event, tpd_pterm1_combout(0), TRUE),
                      3 => (pexpin_ipd'last_event, tpd_pexpin_combout, TRUE),
                      4 => (fbkin'last_event, tpd_fbkin_combout, TRUE)),
            GlitchData => combout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn => MsgOn
            );
        
        VitalPathDelay01 ( 
            OutSignal => pexpout, 
            OutSignalName => "PEXPOUT", 
            OutTemp => tmp_pexpout,  
            Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_pexpout(0), TRUE),
                      2 => (pterm1_ipd'last_event, tpd_pterm1_pexpout(0), TRUE),
                      3 => (pexpin_ipd'last_event, tpd_pexpin_pexpout, TRUE),
                      4 => (fbkin'last_event, tpd_fbkin_pexpout, TRUE)),
            GlitchData => pexpout_VitalGlitchData, 
            Mode => DefGlitchMode, 
            XOn  => XOn, 
            MsgOn => MsgOn
            );
        
        VitalPathDelay01 (
            OutSignal => regin,
            OutSignalName => "REGIN",
            OutTemp => tmp_comb,
            Paths => (1 => (pterm0_ipd'last_event, tpd_pterm0_regin(0), TRUE),
                      2 => (pterm1_ipd'last_event, tpd_pterm1_regin(0), TRUE),
                      3 => (pexpin_ipd'last_event, tpd_pexpin_regin, TRUE),
                      4 => (fbkin'last_event, tpd_fbkin_regin, TRUE)),
            GlitchData => regin_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn => MsgOn
            );
       
    end process;

end vital_pterm;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_pterm_register
--
-- Description : Simulation model for the register submodule of 
--               APEX 20KE PTERM.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;

ENTITY apex20ke_pterm_register is
    GENERIC (
        power_up : string := "low";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tpd_aclr_regout_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_clk_regout_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_aclr_fbkout_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_clk_fbkout_posedge  : VitalDelayType01 := DefPropDelay01;
        tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        thold_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
        tipd_aclr : VitalDelayType01 := DefPropDelay01;
        tipd_ena  : VitalDelayType01 := DefPropDelay01;
        tipd_clk  : VitalDelayType01 := DefPropDelay01
        );

    PORT (
        datain	: in std_logic;
        clk	: in std_logic;
        ena 	: in std_logic := '1';
        aclr	: in std_logic := '0';
        devclrn : in std_logic := '1';
        devpor : in std_logic := '1';
        regout : out std_logic;
        fbkout : out std_logic
        );
   attribute VITAL_LEVEL0 of apex20ke_pterm_register : ENTITY is TRUE;
end apex20ke_pterm_register; 

ARCHITECTURE vital_pterm_reg of apex20ke_pterm_register is
    attribute VITAL_LEVEL0 of vital_pterm_reg : ARCHITECTURE is TRUE;

    signal clk_ipd : std_ulogic := 'U';
    signal aclr_ipd : std_ulogic := 'U';
    signal ena_ipd : std_ulogic := 'U';

begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (clk_ipd, clk, tipd_clk);
        VitalWireDelay (aclr_ipd, aclr, tipd_aclr);
        VitalWireDelay (ena_ipd, ena, tipd_ena);
    end block;

    VITALtiming : process(datain, clk_ipd, aclr_ipd, ena_ipd, 
                          devclrn, devpor)
    variable Tviol_datain_clk : std_ulogic := '0';
    variable Tviol_ena_clk : std_ulogic := '0';
    variable Tviol_clk : std_ulogic := '0';
    
    variable TimingData_datain_clk : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_ena_clk : VitalTimingDataType := VitalTimingDataInit;
    
    variable regout_VitalGlitchData : VitalGlitchDataType;
    variable fbkout_VitalGlitchData : VitalGlitchDataType;
    
    variable tmp_regout : std_logic;
    
    -- variables for 'X' generation
    variable violation : std_logic := '0';

    begin

        if (now = 0 ns) then
            if (power_up = "low") then
                tmp_regout := '0';
            elsif (power_up = "high") then
                tmp_regout := '1';
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
                HeaderMsg       => InstancePath & "/PTERM", 
                XOn             => XOnChecks, 
                MsgOn           => MsgOnChecks
                ); 
            
            VitalSetupHoldCheck ( 
                Violation       => Tviol_ena_clk, 
                TimingData      => TimingData_ena_clk, 
                TestSignal      => ena_ipd, 
                TestSignalName  => "ENA", 
                RefSignal       => clk_ipd, 
                RefSignalName   => "CLK", 
                SetupHigh       => tsetup_ena_clk_noedge_posedge, 
                SetupLow        => tsetup_ena_clk_noedge_posedge, 
                HoldHigh        => thold_ena_clk_noedge_posedge, 
                HoldLow         => thold_ena_clk_noedge_posedge, 
                CheckEnabled    => TO_X01(aclr_ipd) /= '1',
                RefTransition   => '/', 
                HeaderMsg       => InstancePath & "/PTERM", 
                XOn             => XOnChecks, 
                MsgOn           => MsgOnChecks
                ); 
        end if;
    
        violation := Tviol_datain_clk or Tviol_ena_clk;
    
        if (devpor = '0') then
            if (power_up = "low") then
                tmp_regout := '0';
            elsif (power_up = "high") then
                tmp_regout := '1';
            end if;
        elsif (aclr_ipd =  '1') then
            tmp_regout := '0';
        elsif (violation = 'X') then
            tmp_regout := 'X';
        elsif ((clk_ipd'event and clk_ipd = '1') and (ena_ipd = '1')) then
            tmp_regout := datain;
        end if;
    
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => regout,
            OutSignalName => "REGOUT",
            OutTemp => tmp_regout,
            Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                      1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn => MsgOn
            );
        
        VitalPathDelay01 ( 
            OutSignal => fbkout, 
            OutSignalName => "FBKOUT", 
            OutTemp => tmp_regout,  
            Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                      1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
            GlitchData => fbkout_VitalGlitchData, 
            Mode => DefGlitchMode, 
            XOn  => XOn, 
            MsgOn => MsgOn
            );

    end process;

end vital_pterm_reg;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_pterm
--
-- Description : Simulation model for APEX 20KE PTERM.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;
use work.apex20ke_asynch_pterm;
use work.apex20ke_pterm_register;

ENTITY apex20ke_pterm is
    GENERIC (
        operation_mode     : string := "normal";
        output_mode        : string := "comb";
        invert_pterm1_mode : string := "false";
        power_up           : string := "low"
        );

    PORT (
        pterm0  : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pterm1  : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pexpin  : in std_logic := '0';
        clk     : in std_logic := '0';
        ena     : in std_logic := '1';
        aclr    : in std_logic := '0';
        devclrn : in std_logic := '1';
        devpor  : in std_logic := '1';
        dataout : out std_logic;
        pexpout : out std_logic
        );

    attribute VITAL_LEVEL0 of apex20ke_pterm : ENTITY is TRUE;
end apex20ke_pterm; 

ARCHITECTURE vital_pterm_atom of apex20ke_pterm is
    attribute VITAL_LEVEL0 of vital_pterm_atom : ARCHITECTURE is TRUE;

COMPONENT apex20ke_asynch_pterm
    GENERIC (
        operation_mode     : string := "normal";
        invert_pterm1_mode : string := "false";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tpd_pterm0_combout : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pterm1_combout : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pexpin_combout : VitalDelayType01 := DefPropDelay01;
        tpd_fbkin_combout  : VitalDelayType01 := DefPropDelay01;
        tpd_pterm0_pexpout : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pterm1_pexpout : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tpd_pexpin_pexpout : VitalDelayType01 := DefPropDelay01;
        tpd_fbkin_pexpout  : VitalDelayType01 := DefPropDelay01;
        tipd_pterm0 : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tipd_pterm1 : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
        tipd_pexpin : VitalDelayType01 := DefPropDelay01
        );


    PORT (
        pterm0 : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pterm1 : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
        pexpin : in std_logic := '0';
        fbkin : in std_logic;
        combout : out std_logic;
        regin : out std_logic;
        pexpout : out std_logic
        );

END COMPONENT; 

COMPONENT apex20ke_pterm_register
    GENERIC (
        power_up : string := "low";
        TimingChecksOn: Boolean := True;
        MsgOn: Boolean := DefGlitchMsgOn;
        XOn: Boolean := DefGlitchXOn;
        MsgOnChecks: Boolean := DefMsgOnChecks;
        XOnChecks: Boolean := DefXOnChecks;
        InstancePath: STRING := "*";
        tpd_aclr_regout_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_clk_regout_posedge  : VitalDelayType01 := DefPropDelay01;
        tpd_aclr_fbkout_posedge : VitalDelayType01 := DefPropDelay01;
        tpd_clk_fbkout_posedge  : VitalDelayType01 := DefPropDelay01;
        tsetup_datain_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_ena_clk_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
        thold_datain_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
        thold_ena_clk_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
        tipd_aclr : VitalDelayType01 := DefPropDelay01;
        tipd_ena  : VitalDelayType01 := DefPropDelay01;
        tipd_clk  : VitalDelayType01 := DefPropDelay01
        );

    PORT (
        datain	: in std_logic;
        clk	: in std_logic;
        ena 	: in std_logic := '1';
        aclr	: in std_logic := '0';
        devclrn : in std_logic := '1';
        devpor : in std_logic := '1';
        regout : out std_logic;
        fbkout : out std_logic
        );

END COMPONENT; 

signal fbk : std_ulogic ;
signal dffin : std_ulogic ;
signal combo : std_ulogic ;
signal dffo : std_ulogic ;

begin

    pcom: apex20ke_asynch_pterm 
          generic map (operation_mode => operation_mode,
                       invert_pterm1_mode => invert_pterm1_mode
                      )
          port map (pterm0 => pterm0,
                    pterm1 => pterm1,
                    pexpin => pexpin,
                    fbkin => fbk,
                    regin => dffin,
                    combout => combo, 
                    pexpout => pexpout
                   );

    preg: apex20ke_pterm_register
          generic map (power_up => power_up)
          port map (datain => dffin,
                    clk => clk,
                    ena => ena,
                    aclr => aclr,
                    devclrn => devclrn,
                    devpor => devpor,
                    regout => dffo,
                    fbkout => fbk
                   );	

    dataout <= combo when output_mode = "comb" else dffo;

end vital_pterm_atom;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20K_ASYNCH_MEM
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
USE work.apex20ke_atom_pack.all;

 
ENTITY apex20ke_asynch_mem is
    GENERIC (
             logical_ram_depth                : integer := 2048;
             inifile                          : string := "none";
             address_width                    : integer := 1;
             deep_ram_mode                    : string := "off";
             first_address                    : integer := 0;
             last_address                     : integer := 2047;
             mem1                             : std_logic_vector(512 downto 1);
             mem2                             : std_logic_vector(512 downto 1);
             mem3                             : std_logic_vector(512 downto 1);
             mem4                             : std_logic_vector(512 downto 1);
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
             tsetup_waddr_we_noedge_posedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_waddr_we_noedge_negedge    : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_datain_we_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
             thold_datain_we_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             tsetup_raddr_re_noedge_negedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_raddr_re_noedge_negedge    : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tpd_raddr_dataout                : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_waddr_dataout                : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_re_dataout                   : VitalDelayType01 := DefPropDelay01;
             tpd_datain_dataout               : VitalDelayType01 := DefPropDelay01;
             tpd_we_dataout                   : VitalDelayType01 := DefPropDelay01;
             tipd_datain                      : VitalDelayType01 := DefPropDelay01;
             tipd_we                          : VitalDelayType01 := DefPropDelay01;
             tipd_re                          : VitalDelayType01 := DefPropDelay01;
             tipd_raddr                       : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tipd_waddr                       : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpw_we_posedge                   : VitalDelayType := 0 ns;
             tpw_re_posedge                   : VitalDelayType := 0 ns
            );
 
          PORT (datain  : in std_logic := '0';
                we      : in std_logic := '0';
                re      : in std_logic := '1';
                raddr   : in std_logic_vector(15 downto 0) := "0000000000000000";
                waddr   : in std_logic_vector(15 downto 0) := "0000000000000000";
                devclrn : in std_logic := '1';
                devpor  : in std_logic := '1';
                modesel : in std_logic_vector(17 downto 0) := "000000000000000000";
                dataout : out std_logic
               );

   attribute VITAL_LEVEL0 of apex20ke_asynch_mem : ENTITY is TRUE;

end apex20ke_asynch_mem;
 
ARCHITECTURE behave of apex20ke_asynch_mem is
signal datain_ipd     : std_logic;
signal we_ipd         : std_logic;
signal re_ipd         : std_logic;
signal waddr_ipd      : std_logic_vector(15 downto 0);
signal raddr_ipd      : std_logic_vector(15 downto 0);
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
      VitalWireDelay (raddr_ipd(11), raddr(11), tipd_raddr(11));
      VitalWireDelay (raddr_ipd(12), raddr(12), tipd_raddr(12));
      VitalWireDelay (raddr_ipd(13), raddr(13), tipd_raddr(13));
      VitalWireDelay (raddr_ipd(14), raddr(14), tipd_raddr(14));
      VitalWireDelay (raddr_ipd(15), raddr(15), tipd_raddr(15));
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
      VitalWireDelay (waddr_ipd(11), waddr(11), tipd_waddr(11));
      VitalWireDelay (waddr_ipd(12), waddr(12), tipd_waddr(12));
      VitalWireDelay (waddr_ipd(13), waddr(13), tipd_waddr(13));
      VitalWireDelay (waddr_ipd(14), waddr(14), tipd_waddr(14));
      VitalWireDelay (waddr_ipd(15), waddr(15), tipd_waddr(15));
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

   variable read_en : std_logic;
   variable write_en : std_logic;
   variable rword : integer;
   variable wword : integer;
   variable deep_ram_Read : integer;
   variable deep_Ram_write : integer;
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
                HeaderMsg       => InstancePath & "/APEX20KE_ASYNCH_MEM",
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
                HeaderMsg       => InstancePath & "/APEX20KE_ASYNCH_MEM",
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
                HeaderMsg       => InstancePath & "/APEX20KE_ASYNCH_MEM",
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
                HeaderMsg       => InstancePath & "/APEX20KE_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
      end if;

      rword := conv_integer(raddr_ipd(10 downto 0));
      wword := conv_integer(waddr_ipd(10 downto 0));
      deep_ram_read := conv_integer(raddr_ipd(15 downto 0));
      deep_ram_write := conv_integer(waddr_ipd(15 downto 0));

      if (now = 0 ns and do_init_mem) then
         do_init_mem := false;
         mem := (mem4 & mem3 & mem2 & mem1);

         -- memory contents depend on WE registered or not
         -- if WE is unregistered, initialize RAM to 'X'

         if (operation_mode /= "rom" and write_logic_clock = "none") then
            for i in 0 to 2047 loop
              mem(i) := 'X';
            end loop;
         end if;

         if (operation_mode = "rom" or operation_mode = "single_port") then
            -- re is always active
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

      if deep_ram_mode = "off" then
         read_en := re_ipd;
         write_en := we_ipd;
      else -- Deep RAM Mode
         if (deep_ram_read <= last_address) and (deep_ram_read >= first_address) then
            read_en := re_ipd;
         else
            read_en := '0';
         end if;
         if (deep_ram_write <= last_address) and (deep_ram_write >= first_address) then
            write_en := we_ipd; 
         else 
            write_en := '0'; 
         end if;
      end if;

      if modesel(17 downto 16) = 2 then -- ROM
         if read_en = '1' then
            tmp_dataout := mem(rword);
         end if;
      elsif modesel(17 downto 16) = 0 then -- Single Port RAM
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
      elsif modesel(17 downto 16) = 1 then -- Dual Port RAM 
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
   
end behave;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : DFFE
--
-- Description : Timing simulation model for a DFFE register
--
--////////////////////////////////////////////////////////////////////////////
 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.apex20ke_atom_pack.all;

ENTITY apex20ke_dffe is
   GENERIC (
            TimingChecksOn                : Boolean := True;
            XOn                           : Boolean := DefGlitchXOn;
            MsgOn                         : Boolean := DefGlitchMsgOn;
            MsgOnChecks                   : Boolean := DefMsgOnChecks;
            XOnChecks                     : Boolean := DefXOnChecks;
            InstancePath                  : STRING := "*";
            tpd_PRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
            tpd_CLRN_Q_negedge            :  VitalDelayType01 := DefPropDelay01;
            tpd_CLK_Q_posedge             :  VitalDelayType01 := DefPropDelay01;
            tpd_ENA_Q_posedge             :  VitalDelayType01 := DefPropDelay01;
            tsetup_D_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
            tsetup_D_CLK_noedge_negedge   :  VitalDelayType := DefSetupHoldCnst;
            tsetup_ENA_CLK_noedge_posedge :  VitalDelayType := DefSetupHoldCnst;
            thold_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
            thold_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
            thold_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
            tipd_D                        :  VitalDelayType01 := DefPropDelay01;
            tipd_CLRN                     :  VitalDelayType01 := DefPropDelay01;
            tipd_PRN                      :  VitalDelayType01 := DefPropDelay01;
            tipd_CLK                      :  VitalDelayType01 := DefPropDelay01;
            tipd_ENA                      :  VitalDelayType01 := DefPropDelay01
           );

   PORT    (
            Q                             :  out   STD_LOGIC;
            D                             :  in    STD_LOGIC;
            CLRN                          :  in    STD_LOGIC;
            PRN                           :  in    STD_LOGIC;
            CLK                           :  in    STD_LOGIC;
            ENA                           :  in    STD_LOGIC
           );

   attribute VITAL_LEVEL0 of apex20ke_dffe : ENTITY is TRUE;

end apex20ke_dffe;

-- ARCHITECTURE body --

ARCHITECTURE behave of apex20ke_dffe is
   attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;

   signal D_ipd          : STD_ULOGIC := 'U';
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

--USE apex20ke.SUPPORT.all;
USE work.apex20ke_atom_pack.all;

-- ENTITY declaration --
ENTITY and1 IS
   GENERIC (
            MsgOn                    : Boolean := DefGlitchMsgOn;
            XOn                      : Boolean := DefGlitchXOn;
            tpd_IN1_Y                :  VitalDelayType01 := DefPropDelay01;
            tipd_IN1                 :  VitalDelayType01 := DefPropDelay01);

   PORT    ( Y                       :  out  STD_LOGIC;
             IN1                     :  in   STD_LOGIC
           );
   attribute VITAL_LEVEL0 of and1 : ENTITY is TRUE;
END and1;

-- ARCHITECTURE body --

ARCHITECTURE AltVITAL of and1 is
   attribute VITAL_LEVEL0 of AltVITAL : ARCHITECTURE is TRUE;

   SIGNAL IN1_ipd	 : STD_ULOGIC := 'U';

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
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

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
END nmux21;

ARCHITECTURE structure of nmux21 is
begin

   MO <=  not B when (S = '1') else not A;

END structure;

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
     PORT ( 
                A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                S : in std_logic := '0'; 
                MO : out std_logic_vector(15 downto 0)); 
END bmux21; 
 
ARCHITECTURE structure of bmux21 is
BEGIN 
 
   MO <= B when (S = '1') else A; 
 
END structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20KE_RAM_SLICE
--
-- Description : Timing simulation model for a single RAM segment of the
--               APEX20KE family.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE work.apex20ke_atom_pack.all;
USE work.apex20ke_dffe;
USE work.and1;
USE work.mux21;
USE work.nmux21;
USE work.bmux21;
USE work.apex20ke_asynch_mem;

ENTITY  apex20ke_ram_slice is
    GENERIC (
             operation_mode             : string := "single_port";
             deep_ram_mode              : string := "off";
             logical_ram_name           : string := "ram_xxx";
             logical_ram_depth          : integer := 2048;
             logical_ram_width          : integer:= 1;
             address_width              : integer:= 16;
             data_in_clock              : string := "none";
             data_in_clear              : string := "none";
             write_logic_clock          : string := "none";
             write_logic_clear          : string := "none";
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
             power_up                   : string := "low";
             mem1                       : std_logic_vector(512 downto 1);
             mem2                       : std_logic_vector(512 downto 1);
             mem3                       : std_logic_vector(512 downto 1);
             mem4                       : std_logic_vector(512 downto 1)
            );

    PORT    (datain                     : in std_logic;
             clk0                       : in std_logic;
             clk1                       : in std_logic;
             clr0                       : in std_logic;
             clr1                       : in std_logic;
             ena0                       : in std_logic;
             ena1                       : in std_logic;
             we                         : in std_logic;
             re                         : in std_logic;
             waddr                      : in std_logic_vector(15 downto 0);
             raddr                      : in std_logic_vector(15 downto 0);
             devclrn                    : in std_logic := '1';
             devpor                     : in std_logic := '1';
             modesel                    : in std_logic_vector(17 downto 0) := (OTHERS => '0');
             dataout                    : out std_logic
            );
end apex20ke_ram_slice;

ARCHITECTURE structure of apex20ke_ram_slice is
   signal  datain_reg : std_logic;
   signal  we_reg : std_logic;
   signal  re_reg : std_logic;
   signal  dataout_reg : std_logic;
   signal  we_reg_mux : std_logic;
   signal  we_reg_mux_delayed : std_logic;
   signal  raddr_reg : std_logic_vector(15 downto 0);
   signal  waddr_reg : std_logic_vector(15 downto 0);
   signal  datain_int : std_logic;
   signal  we_int : std_logic;
   signal  re_int : std_logic;
   signal  dataout_int : std_logic;
   signal  raddr_int : std_logic_vector(15 downto 0);
   signal  waddr_int : std_logic_vector(15 downto 0);
   signal  reen : std_logic;
   signal  raddren : std_logic;
   signal  dataouten : std_logic;
   signal  datain_clr : std_logic;
   signal  re_clk : std_logic;
   signal  re_clr : std_logic;
   signal  raddr_clk : std_logic;
   signal  raddr_clr : std_logic;
   signal  dataout_clk : std_logic;
   signal  dataout_clr : std_logic;
   signal  datain_reg_sel : std_logic;
   signal  write_reg_sel : std_logic;
   signal  raddr_reg_sel : std_logic;
   -- initialize re_reg_sel right here to avoid glitch on re_int
--   signal  re_reg_sel, dataout_reg_sel, re_clk_sel, re_en_sel : std_logic;
   signal  dataout_reg_sel : std_logic;
   signal  re_clk_sel : std_logic;
   signal  re_en_sel : std_logic;
   signal  re_reg_sel : std_logic;
   signal  re_clr_sel : std_logic;
   signal  raddr_clk_sel : std_logic;
   signal  raddr_clr_sel : std_logic;
   signal  raddr_en_sel : std_logic;
   signal  dataout_clk_sel : std_logic; 
   signal  dataout_clr_sel : std_logic; 
   signal  dataout_en_sel : std_logic; 
   signal  datain_reg_clr : std_logic;
   signal  write_reg_clr : std_logic;
   signal  raddr_reg_clr : std_logic;
   signal  re_reg_clr : std_logic;
   signal  dataout_reg_clr : std_logic;
   signal  datain_reg_clr_sel: std_logic;
   signal  write_reg_clr_sel: std_logic;
   signal  raddr_reg_clr_sel: std_logic;
   signal  re_reg_clr_sel : std_logic;
   signal  dataout_reg_clr_sel : std_logic;
   signal  NC : std_logic := '0';

   signal  dinreg_clr : std_logic;
   signal  wereg_clr : std_logic;
   signal  rereg_clr : std_logic;
   signal  dataoutreg_clr : std_logic;
   signal  raddrreg_clr : std_logic;
   signal  we_pulse : std_logic;
   signal  dataout_tmp : std_logic;
   signal  valid_addr : std_logic;
   signal  raddr_num : integer;

   signal waddr_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal waddr_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal waddr_reg_delayed_3 : std_logic_vector(15 downto 0);
   signal datain_reg_delayed_1 : std_logic;
   signal datain_reg_delayed_2 : std_logic;
   signal datain_reg_delayed_3 : std_logic;

   signal clk0_delayed : std_logic;

COMPONENT apex20ke_dffe
    GENERIC (TimingChecksOn                : Boolean := true;
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

    PORT    (Q                             :  out   STD_LOGIC := '0';
             D                             :  in    STD_LOGIC := '1';
             CLRN                          :  in    STD_LOGIC := '1';
             PRN                           :  in    STD_LOGIC := '1';
             CLK                           :  in    STD_LOGIC := '0';
             ENA                           :  in    STD_LOGIC := '1'
            );
END COMPONENT;

COMPONENT and1
    GENERIC (XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y                     : VitalDelayType01 := DefPropDelay01;
             tipd_IN1                      : VitalDelayType01 := DefPropDelay01
            );
        
    PORT    (Y                             :  out   STD_LOGIC;
             IN1                           :  in    STD_LOGIC
            );
END COMPONENT;

COMPONENT mux21
    PORT    (A : in std_logic := '0';
             B : in std_logic := '0';
             S : in std_logic := '0';
             MO : out std_logic
            );
END COMPONENT;

COMPONENT nmux21
     PORT ( A : in std_logic := '0';
            B : in std_logic := '0';
            S : in std_logic := '0';
            MO : out std_logic
          );
END COMPONENT;

COMPONENT bmux21
     PORT ( A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
            B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
            S : in std_logic := '0';
            MO : out std_logic_vector(15 downto 0)
          );
END COMPONENT;

COMPONENT apex20ke_asynch_mem
     GENERIC (logical_ram_depth : integer := 2048;
              deep_ram_mode     : string := "OFF";
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
              raddr             : in std_logic_vector(15 downto 0) := (OTHERS => '0');
              waddr             : in std_logic_vector(15 downto 0) := (OTHERS => '0');
              devclrn           : in std_logic := '1';
              devpor            : in std_logic := '1';
              modesel           : in std_logic_vector(17 downto 0) := "000000000000000000";
              dataout           : out std_logic
             );
END COMPONENT;
 
begin     

   re_reg_sel <= modesel(6);

   datain_reg_sel         <= modesel(0);
   datain_reg_clr_sel     <= modesel(1);
   write_reg_sel          <= modesel(2);
   write_reg_clr_sel      <= modesel(3);
   raddr_reg_sel          <= modesel(4);
   raddr_reg_clr_sel      <= modesel(5);
   re_reg_sel             <= modesel(6);
   re_reg_clr_sel         <= modesel(7);
   dataout_reg_sel        <= modesel(8);
   dataout_reg_clr_sel    <= modesel(9);
   re_clk_sel             <= modesel(10);
   re_en_sel              <= modesel(10);
   re_clr_sel             <= modesel(11);
   raddr_clk_sel          <= modesel(12);
   raddr_en_sel           <= modesel(12);
   raddr_clr_sel          <= modesel(13);
   dataout_clk_sel        <= modesel(14);
   dataout_en_sel         <= modesel(14);
   dataout_clr_sel        <= modesel(15);

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
   writeregclr: nmux21
	   port map (A => NC, 
                     B => clr0, 
                     S => write_reg_clr_sel,
                     MO => write_reg_clr
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
                     B => raddr_clr, 
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
                     B => dataout_clr, 
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
   raddrclrsel: mux21
           port map (A => clr0, 
                     B => clr1, 
                     S => raddr_clr_sel,
                     MO => raddr_clr
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
   reclrsel: mux21
           port map (A => clr0, 
                     B => clr1, 
                     S => re_clr_sel,
                     MO => re_clr
                    ); 
   reregclr: nmux21
	   port map (A => NC, 
                     B => re_clr, 
                     S => re_reg_clr_sel,
                     MO => re_reg_clr
                    );
   dataoutclksel: mux21
           port map (A => clk0, 
                     B => clk1, 
                     S => dataout_clk_sel,
                     MO => dataout_clk
                    ); 
   dataoutensel: mux21
           port map (A => ena0, 
                     B => ena1, 
                     S => dataout_en_sel,
                     MO => dataouten
                    ); 
   dataoutclrsel: mux21
           port map (A => clr0, 
                     B => clr1, 
                     S => dataout_clr_sel,
                     MO => dataout_clr
                    ); 

   dinreg_clr <= datain_reg_clr and devclrn and devpor;
   dinreg: apex20ke_dffe
           port map (D => datain,
                     CLRN => dinreg_clr, 
                     CLK => clk0,
                       ENA => ena0, 
                     Q => datain_reg
                     );

   wereg_clr <= write_reg_clr and devclrn and devpor; 
   wereg: apex20ke_dffe 
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
   rereg: apex20ke_dffe 
           port map (D => re, 
                     CLRN => rereg_clr, 
                     CLK => re_clk,
                     ENA => reen, 
                     Q => re_reg
                    );

   dataoutreg_clr <= dataout_reg_clr and devclrn and devpor;
   dataoutreg: apex20ke_dffe 
           port map (D => dataout_int, 
                     CLRN => dataoutreg_clr, 
                     CLK => dataout_clk, 
                     ENA => dataouten, 
                     Q => dataout_reg
                    );
   waddrreg_0: apex20ke_dffe 
            port map (D => waddr(0), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(0)
                     );
   waddrreg_1: apex20ke_dffe 
            port map (D => waddr(1), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(1)
                     );
   waddrreg_2: apex20ke_dffe 
            port map (D => waddr(2), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(2)
                     );
   waddrreg_3: apex20ke_dffe 
            port map (D => waddr(3), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(3)
                     );
   waddrreg_4: apex20ke_dffe 
            port map (D => waddr(4), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(4)
                     );
   waddrreg_5: apex20ke_dffe 
            port map (D => waddr(5), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(5)
                     );
   waddrreg_6: apex20ke_dffe 
            port map (D => waddr(6), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(6)
                     );
   waddrreg_7: apex20ke_dffe 
            port map (D => waddr(7), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(7)
                     );
   waddrreg_8: apex20ke_dffe 
            port map (D => waddr(8), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(8)
                     );
   waddrreg_9: apex20ke_dffe 
            port map (D => waddr(9), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(9)
                     );
   waddrreg_10: apex20ke_dffe 
            port map (D => waddr(10), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(10)
                     );
   waddrreg_11: apex20ke_dffe 
            port map (D => waddr(11), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(11)
                     );
   waddrreg_12: apex20ke_dffe 
            port map (D => waddr(12), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(12)
                     );
   waddrreg_13: apex20ke_dffe 
            port map (D => waddr(13), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(13)
                     );
   waddrreg_14: apex20ke_dffe 
            port map (D => waddr(14), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(14)
                     );
   waddrreg_15: apex20ke_dffe 
            port map (D => waddr(15), 
                      CLRN => wereg_clr, 
                      CLK => clk0,
                      ENA => ena0, 
                      Q => waddr_reg(15)
                     );

   raddrreg_clr <= raddr_reg_clr and devclrn and devpor;

   raddrreg_0: apex20ke_dffe 
            port map (D => raddr(0), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(0)
                     );
   raddrreg_1: apex20ke_dffe 
            port map (D => raddr(1), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(1)
                     );
   raddrreg_2: apex20ke_dffe 
            port map (D => raddr(2), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(2)
                     );
   raddrreg_3: apex20ke_dffe 
            port map (D => raddr(3), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(3)
                     );
   raddrreg_4: apex20ke_dffe 
            port map (D => raddr(4), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(4)
                     );
   raddrreg_5: apex20ke_dffe 
            port map (D => raddr(5), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(5)
                     );
   raddrreg_6: apex20ke_dffe 
            port map (D => raddr(6), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(6)
                     );
   raddrreg_7: apex20ke_dffe 
            port map (D => raddr(7), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(7)
                     );
   raddrreg_8: apex20ke_dffe 
            port map (D => raddr(8), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(8)
                     );
   raddrreg_9: apex20ke_dffe 
            port map (D => raddr(9), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(9)
                     );
   raddrreg_10: apex20ke_dffe 
            port map (D => raddr(10), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(10)
                     );
   raddrreg_11: apex20ke_dffe 
            port map (D => raddr(11), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(11)
                     );
   raddrreg_12: apex20ke_dffe 
            port map (D => raddr(12), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(12)
                     );
   raddrreg_13: apex20ke_dffe 
            port map (D => raddr(13), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(13)
                     );
   raddrreg_14: apex20ke_dffe 
            port map (D => raddr(14), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(14)
                     );
   raddrreg_15: apex20ke_dffe 
            port map (D => raddr(15), 
                      CLRN => raddrreg_clr, 
                      CLK => raddr_clk,
                      ENA => raddren, 
                      Q => raddr_reg(15)
                     );

   apexmem: apex20ke_asynch_mem
         generic map (ADDRESS_WIDTH       => address_width,
                      BIT_NUMBER          => bit_number,
                      DEEP_RAM_MODE       => deep_ram_mode,
                      FIRST_ADDRESS       => first_address,
                      LAST_ADDRESS        => last_address,
                      MEM1                => mem1,
                      MEM2                => mem2,
                      MEM3                => mem3,
                      MEM4                => mem4,
                      INIFILE             => init_file,
                      WRITE_LOGIC_CLOCK   => write_logic_clock,
                      READ_ENABLE_CLOCK   => read_enable_clock,
                      DATA_OUT_CLOCK      => data_out_clock,
                      OPERATION_MODE      => operation_mode,
                      LOGICAL_RAM_DEPTH   => logical_ram_depth
                     )

	 port map    (DATAIN              => datain_int,
                      WE                  => we_int,
                      RE                  => re_int,
                      RADDR               => raddr_int,
                      WADDR               => waddr_int, 
                      MODESEL             => modesel,
                      DATAOUT             => dataout_int
                     );

   raddr_num <= conv_integer(raddr_int);

   valid_addr <= '1' when raddr_num <= last_address and raddr_num >= first_address else '0';

   dataout <= dataout_tmp when deep_ram_mode = "off" or (deep_ram_mode = "on" and valid_addr = '1') else 'Z';

end structure;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20KE_CAM
--
-- Description : Timing simulation model for the asynchronous CAM array.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE IEEE.VITAL_Primitives.all;
USE IEEE.VITAL_Timing.all;
USE work.apex20ke_atom_pack.all;

ENTITY  apex20ke_cam IS
    GENERIC (
             operation_mode                     : string := "encoded_address";
             logical_cam_depth                  : integer := 32;
             address_width                      : integer := 5;
             pattern_width                      : integer := 32;
             first_address                      : integer := 0;
             last_address                       : integer := 31;
             init_mem_true                      : apex20ke_mem_data := (OTHERS=> "11111111111111111111111111111111");
             init_mem_comp                      : apex20ke_mem_data := (OTHERS=> "11111111111111111111111111111111");
             first_pattern_bit                  : integer := 0;
             TimingChecksOn                     : Boolean := True;
             MsgOn                              : Boolean := DefGlitchMsgOn;
             XOn                                : Boolean := DefGlitchXOn;
             MsgOnChecks                        : Boolean := DefMsgOnChecks;
             XOnChecks                          : Boolean := DefXOnChecks;
             InstancePath                       : STRING := "*";
             tsetup_lit_we_noedge_posedge       : VitalDelayArrayType(31 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_lit_we_noedge_posedge        : VitalDelayArrayType(31 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_datain_we_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
             thold_datain_we_noedge_negedge     : VitalDelayType := DefSetupHoldCnst;
             tsetup_wrinvert_we_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
             thold_wrinvert_we_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
             tpd_lit_matchout                   : VitalDelayArrayType01(511 downto 0) := (OTHERS => DefPropDelay01);
             tpd_lit_matchfound                 : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
             tpd_we_matchout                    : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_we_matchfound                  : VitalDelayType01 := DefPropDelay01;
             tpd_outputselect_matchout          : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tipd_datain                        : VitalDelayType01 := DefPropDelay01;
             tipd_wrinvert                      : VitalDelayType01 := DefPropDelay01;
             tipd_we                            : VitalDelayType01 := DefPropDelay01;
             tipd_outputselect                  : VitalDelayType01 := DefPropDelay01;
             tipd_waddr                         : VitalDelayArrayType01(4 downto 0) := (OTHERS => DefPropDelay01);
             tipd_lit                           : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01)
            );
 
     PORT   (datain                : in std_logic := '0';
             wrinvert              : in std_logic := '0';
             outputselect          : in std_logic := '0';
             we                    : in std_logic := '0';
             lit                   : in std_logic_vector(31 downto 0);
             waddr                 : in std_logic_vector(4 downto 0) := "00000";
             modesel               : in std_logic_vector(1 downto 0) := "00";
             matchout              : out std_logic_vector(15 downto 0);
             matchfound            : out std_logic
            );

   attribute VITAL_LEVEL0 of apex20ke_cam : ENTITY is TRUE;
END apex20ke_cam;

ARCHITECTURE behave of apex20ke_cam IS
signal datain_ipd, we_ipd, wrinvert_ipd, outputselect_ipd : std_logic;
signal waddr_ipd : std_logic_vector(4 downto 0);
signal lit_ipd : std_logic_vector(31 downto 0);
begin

    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (waddr_ipd(0), waddr(0), tipd_waddr(0));
        VitalWireDelay (waddr_ipd(1), waddr(1), tipd_waddr(1));
        VitalWireDelay (waddr_ipd(2), waddr(2), tipd_waddr(2));
        VitalWireDelay (waddr_ipd(3), waddr(3), tipd_waddr(3));
        VitalWireDelay (waddr_ipd(4), waddr(4), tipd_waddr(4));

        VitalWireDelay (lit_ipd(0), lit(0), tipd_lit(0));
        VitalWireDelay (lit_ipd(1), lit(1), tipd_lit(1));
        VitalWireDelay (lit_ipd(2), lit(2), tipd_lit(2));
        VitalWireDelay (lit_ipd(3), lit(3), tipd_lit(3));
        VitalWireDelay (lit_ipd(4), lit(4), tipd_lit(4));
        VitalWireDelay (lit_ipd(5), lit(5), tipd_lit(5));
        VitalWireDelay (lit_ipd(6), lit(6), tipd_lit(6));
        VitalWireDelay (lit_ipd(7), lit(7), tipd_lit(7));
        VitalWireDelay (lit_ipd(8), lit(8), tipd_lit(8));
        VitalWireDelay (lit_ipd(9), lit(9), tipd_lit(9));
        VitalWireDelay (lit_ipd(10), lit(10), tipd_lit(10));
        VitalWireDelay (lit_ipd(11), lit(11), tipd_lit(11));
        VitalWireDelay (lit_ipd(12), lit(12), tipd_lit(12));
        VitalWireDelay (lit_ipd(13), lit(13), tipd_lit(13));
        VitalWireDelay (lit_ipd(14), lit(14), tipd_lit(14));
        VitalWireDelay (lit_ipd(15), lit(15), tipd_lit(15));
        VitalWireDelay (lit_ipd(16), lit(16), tipd_lit(16));
        VitalWireDelay (lit_ipd(17), lit(17), tipd_lit(17));
        VitalWireDelay (lit_ipd(18), lit(18), tipd_lit(18));
        VitalWireDelay (lit_ipd(19), lit(19), tipd_lit(19));
        VitalWireDelay (lit_ipd(20), lit(20), tipd_lit(20));
        VitalWireDelay (lit_ipd(21), lit(21), tipd_lit(21));
        VitalWireDelay (lit_ipd(22), lit(22), tipd_lit(22));
        VitalWireDelay (lit_ipd(23), lit(23), tipd_lit(23));
        VitalWireDelay (lit_ipd(24), lit(24), tipd_lit(24));
        VitalWireDelay (lit_ipd(25), lit(25), tipd_lit(25));
        VitalWireDelay (lit_ipd(26), lit(26), tipd_lit(26));
        VitalWireDelay (lit_ipd(27), lit(27), tipd_lit(27));
        VitalWireDelay (lit_ipd(28), lit(28), tipd_lit(28));
        VitalWireDelay (lit_ipd(29), lit(29), tipd_lit(29));
        VitalWireDelay (lit_ipd(30), lit(30), tipd_lit(30));
        VitalWireDelay (lit_ipd(31), lit(31), tipd_lit(31));
        VitalWireDelay (we_ipd, we, tipd_we);
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (wrinvert_ipd, wrinvert, tipd_wrinvert);
        VitalWireDelay (outputselect_ipd, outputselect, tipd_outputselect);
    end block;


    VITAL: process(we_ipd, lit_ipd, outputselect_ipd, wrinvert_ipd, datain_ipd)
    variable Tviol_wrinvert_we : std_ulogic := '0';
    variable Tviol_datain_we : std_ulogic := '0';
    variable Tviol_lit_we : std_ulogic := '0';
    variable TimingData_wrinvert_we : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_datain_we : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_lit_we : VitalTimingDataType := VitalTimingDataInit;
    variable matchfound_VitalGlitchData : VitalGlitchDataType;
    variable matchout_VitalGlitchDataArray : VitalGlitchDataArrayType(15 downto 0);

    variable wword : std_logic_vector(address_width-1 downto 0);
    variable pattern_tmp, read_pattern : std_logic_vector(pattern_width-1 downto 0);
    variable compare_data, temp : std_logic_vector(pattern_width-1 downto 0);
    variable wdatain_last_value, wrinvert_last_value : std_logic;
    variable m_found, continue : boolean;
    variable wword_int : integer;
    variable encoded_match_addr : std_logic_vector(4 downto 0);
    variable match_out : std_logic_vector(15 downto 0);
    variable match_found : std_logic;

    --  types for true and complement memory arrays
    TYPE mem_array is ARRAY(0 to 31) of std_logic_vector (31 downto 0);

    variable mem_true, mem_comp : mem_array;

    variable mult_match_array : std_logic_vector(31 downto 0) := (OTHERS => '0');
    variable mem_depth : integer := (last_address-first_address) + 1;
    variable i, j, k : integer := 0;

    variable init : boolean := true;

    begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then

         VitalSetupHoldCheck (
                Violation       => Tviol_wrinvert_we,
                TimingData      => TimingData_wrinvert_we,
                TestSignal      => wrinvert_ipd,
                TestSignalName  => "WRINVERT",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                SetupHigh       => tsetup_wrinvert_we_noedge_posedge,
                SetupLow        => tsetup_wrinvert_we_noedge_posedge,
                HoldHigh        => thold_wrinvert_we_noedge_posedge,
                HoldLow         => thold_wrinvert_we_noedge_posedge,
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/APEX20KE_CAM",
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
                HeaderMsg       => InstancePath & "/APEX20KE_CAM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_lit_we,
                TimingData      => TimingData_lit_we,
                TestSignal      => lit_ipd,
                TestSignalName  => "LIT",
                RefSignal       => we_ipd,
                RefSignalName   => "WE",
                SetupHigh       => tsetup_lit_we_noedge_posedge(0),
                SetupLow        => tsetup_lit_we_noedge_posedge(0),
                HoldHigh        => thold_lit_we_noedge_posedge(0),
                HoldLow         => thold_lit_we_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/APEX20KE_CAM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

        end if;

   if (we_ipd'event or lit_ipd'event or outputselect_ipd'event) then

   if init then
     -- initialize CAM from generics
      if (operation_mode = "encoded_address") or (operation_mode = "unencoded_32_address")
         or (operation_mode = "single_match") or (operation_mode = "multiple_match") then
         for i in 0 to 31 loop
            mem_true(i) := init_mem_true(i);
            mem_comp(i) := init_mem_comp(i);
         end loop;
      elsif (operation_mode = "unencoded_16_address") or (operation_mode = "fast_multiple_match") then
         for i in 0 to 15 loop
            mem_true(2*i) := init_mem_true(i);
            mem_comp(2*i) := init_mem_comp(i);
            mem_true(2*i+1) := (OTHERS => '1');
            mem_comp(2*i+1) := (OTHERS => '1');
         end loop;
         mem_depth := mem_depth * 2;
      end if;
      init := false;
   end if;
   if (we_ipd'event and we_ipd = '1') then
      if (datain_ipd = '0' and wrinvert_ipd = '0') then
        -- write 0's
         pattern_tmp := lit_ipd(pattern_width-1 downto 0);
         wword := waddr_ipd(address_width-1 downto 0);
         wword_int := alt_conv_integer(wword);
         if (modesel = "10") then   -- unencoded_16_address mode
            wword_int := wword_int * 2;
         end if;
         for i in 0 to (pattern_width-1) loop
            if (pattern_tmp(i) = '1') then
               mem_true(wword_int)(i) := '0';
            elsif (pattern_tmp(i) = '0') then
               mem_comp(wword_int)(i) := '0';
            end if;
         end loop;
      elsif (datain_ipd = '1' and wrinvert_ipd = '1') then
         if (wdatain_last_value = '1' and wrinvert_last_value = '0') then
         -- delete cycle continues
            if (pattern_tmp = lit_ipd(pattern_width-1 downto 0) and wword = waddr_ipd(address_width-1 downto 0)) then
                for i in 0 to (pattern_width-1) loop
                   if (pattern_tmp(i) = '0') then
                      mem_true(wword_int)(i) := '1';
                   elsif (pattern_tmp(i) = '1') then
                      mem_comp(wword_int)(i) := '1';
                   end if;
                end loop;
            else assert false report "Either address or pattern changed during delete cycle. Pattern will not be deleted." severity warning;
            end if;
         else
            if (wdatain_last_value = '0' and wrinvert_last_value = '0') then
            -- write cycle continues
               if (wword = waddr_ipd(address_width-1 downto 0)) then
                 -- last cycle was write 1's and now waddr is same
                  if (pattern_tmp /= lit_ipd(pattern_width-1 downto 0)) then
                   -- but pattern is not same, so error message
                    assert false report "Write pattern changed during write cycles. Write Data may not be valid." severity warning;
                  end if;
               end if;
            end if;
            -- write 1's
            pattern_tmp := lit_ipd(pattern_width-1 downto 0);
            wword := waddr_ipd(address_width-1 downto 0);
            wword_int := alt_conv_integer(wword);
            if (modesel = "10") then   -- unencoded_16_address mode
               wword_int := wword_int * 2;
            end if;
            for i in 0 to (pattern_width-1) loop
               if (pattern_tmp(i) = '0') then
                  mem_true(wword_int)(i) := '1';
               elsif (pattern_tmp(i) = '1') then
                  mem_comp(wword_int)(i) := '1';
               end if;
            end loop;
         end if;
      elsif (datain_ipd = '1' and wrinvert_ipd = '0') then
            pattern_tmp := lit_ipd(pattern_width-1 downto 0);
            wword := waddr_ipd(address_width-1 downto 0);
            wword_int := alt_conv_integer(wword);
            if (modesel = "10") then   -- unencoded_16_address mode
               wword_int := wword_int * 2;
            end if;
                for i in 0 to (pattern_width-1) loop
                   if (pattern_tmp(i) = '1') then
                      mem_true(wword_int)(i) := '1';
                   elsif (pattern_tmp(i) = '0') then
                      mem_comp(wword_int)(i) := '1';
                   end if;
                end loop;
      end if;
      wdatain_last_value := datain_ipd;
      wrinvert_last_value := wrinvert_ipd;
   end if;
--   elsif (we_pulse = '0') then
      m_found := false;
      read_pattern := lit_ipd(pattern_width-1 downto 0);
      i := 0;
      while (i < mem_depth and (not(m_found))) loop
        continue := true;
        j := 0;
        for k in 0 to pattern_width-1 loop
           if (mem_true(i)(k) = '1' and mem_comp(i)(k) = '1') then
              continue := false;
              exit;
           elsif (mem_true(i)(k) = '0' and mem_comp(i)(k) = '0') then
              temp(k) := 'X';
           else
              temp(k) := mem_comp(i)(k);
           end if;
        end loop;
        compare_data := read_pattern xor temp;
        while (j < pattern_width and continue) loop
           if (compare_data(j) = '1') then
             continue := false;
           end if;
           j := j + 1;
        end loop;
        if (continue and j = pattern_width) then
           if (modesel = "00" and not(m_found)) then
              m_found := true;
              encoded_match_addr := conv_std_logic_vector(i, 5);
           elsif (modesel /= "00") then
              mult_match_array(i) := '1';
              i := i + 1;
           end if;
        else
           mult_match_array(i) := '0';
           i := i + 1;
        end if;
      end loop;
      if (modesel = "00") then
         if (m_found) then
             match_out(4 downto 0) := encoded_match_addr;
             match_found := '1';
         else
             match_out(4 downto 0) := (OTHERS => '0');
             match_found := '0';
         end if;
         match_out(15 downto 5) := (OTHERS => '0');
      elsif (modesel = "01") then
         match_found := '0';
         if (outputselect_ipd = '0') then
            for i in 0 to 15 loop
              match_out(i) := mult_match_array(2*i);
            end loop;
         elsif (outputselect_ipd = '1') then
            for i in 0 to 15 loop
              match_out(i) := mult_match_array(2*i+1);
            end loop;
         end if;
      elsif (modesel = "10") then
        -- output only even addresses
         for i in 0 to 15 loop
            match_out(i) := mult_match_array(2*i);
         end loop;
      end if;

   if (outputselect_ipd'event and outputselect_ipd = '0') then
      for i in 0 to 15 loop
          match_out(i) := mult_match_array(2*i);
      end loop;
   elsif (outputselect_ipd'event and outputselect_ipd = '1') then
      for i in 0 to 15 loop
          match_out(i) := mult_match_array(2*i+1);
      end loop;
   end if;

--   end if;

   end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => matchfound,
       OutSignalName => "MATCHFOUND",
       OutTemp => match_found,
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchfound(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchfound, TRUE)),
       GlitchData => matchfound_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(0),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(0),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(0), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(0), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(0),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(1),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(1),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(1), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(1), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(1),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(2),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(2),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(2), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(2), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(2),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(3),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(3),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(3), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(3), TRUE)),

       GlitchData => matchout_VitalGlitchDataArray(3),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(4),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(4),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(4), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(4), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(4),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(5),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(5),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(5), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(5), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(5),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(6),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(6),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(6), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(6), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(6),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(7),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(7),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(7), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(7), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(7),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(8),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(8),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(8), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(8), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(8),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(9),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(9),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(9), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(9), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(9),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(10),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(10),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(10), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(10), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(10),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(11),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(11),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(11), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(11), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(11),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(12),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(12),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(12), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(12), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(12),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(13),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(13),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(13), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(13), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(13),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(14),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(14),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(14), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(14), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(14),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );

      VitalPathDelay01 (
       OutSignal => matchout(15),
       OutSignalName => "MATCHOUT",
       OutTemp => match_out(15),
       Paths => (1 => (lit_ipd'last_event, tpd_lit_matchout(0), TRUE),
                 2 => (we_ipd'last_event, tpd_we_matchout(15), TRUE),
                 3 => (outputselect_ipd'last_event, tpd_outputselect_matchout(15), TRUE)),
       GlitchData => matchout_VitalGlitchDataArray(15),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn  => MsgOn );
    end process;
end behave;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20KE_CAM_SLICE
--
-- Description : Structural model for a single CAM segment of the APEX20KE
--               device family
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE work.apex20ke_atom_pack.all;
USE work.apex20ke_dffe;
USE work.and1;
USE work.mux21;
USE work.nmux21;
USE work.bmux21;
USE work.apex20ke_cam;

ENTITY  apex20ke_cam_slice is
    GENERIC (
             operation_mode             : string := "encoded_address";
             logical_cam_name           : string := "cam_xxx";
             logical_cam_depth          : integer := 32;
             logical_cam_width          : integer:= 32;
             address_width              : integer:= 5;
             waddr_clear                : string := "none";
             write_enable_clear         : string := "none";
             write_logic_clock          : string := "none";
             write_logic_clear          : string := "none";
             output_clock               : string := "none";
             output_clear               : string := "none";
             init_file                  : string := "xxx";
             init_filex                 : string := "xxx";
             first_address              : integer:= 0;
             last_address               : integer:= 31;
             first_pattern_bit          : integer:= 0;
             pattern_width              : integer:= 32;
             power_up                   : string := "low";
             init_mem_true              : apex20ke_mem_data;
             init_mem_comp              : apex20ke_mem_data
            );

    PORT    (clk0             : in std_logic;
             clk1             : in std_logic; 
             clr0             : in std_logic; 
             clr1             : in std_logic;
             ena0             : in std_logic;
             ena1             : in std_logic;
             we               : in std_logic;
             datain           : in std_logic;
             wrinvert         : in std_logic;
             outputselect     : in std_logic;
             waddr            : in std_logic_vector(4 downto 0);
             lit              : in std_logic_vector(31 downto 0);
             devclrn          : in std_logic := '1';
             devpor           : in std_logic := '1';
             modesel          : in std_logic_vector(9 downto 0) := (OTHERS => '0');
             matchout         : out std_logic_vector(15 downto 0);
             matchfound       : out std_logic
            );

end apex20ke_cam_slice;

ARCHITECTURE structure of apex20ke_cam_slice is
signal waddr_clr_sel, write_logic_clr_sel, we_clr_sel : std_logic;
signal output_clr_sel, output_reg_clr_sel : std_logic;
signal write_logic_sel, output_reg_sel, output_clk_sel : std_logic;
signal output_clk, output_clk_en, output_clr : std_logic;
signal output_reg_clr, we_clr, waddr_clr, write_logic_clr : std_logic;
signal matchfound_int, matchfound_reg, matchfound_tmp : std_logic;
signal wdatain_reg, wdatain_int, wrinv_reg, wrinv_int : std_logic;
signal matchout_reg, matchout_int : std_logic_vector(15 downto 0);
signal waddr_reg : std_logic_vector(4 downto 0);
signal we_reg, we_reg_delayed : std_logic;
signal NC : std_logic := '0';

signal wereg_clr, writelogic_clr : std_logic;
signal waddrreg_clr, outputreg_clr : std_logic;
signal we_pulse : std_logic;

-- clk0 for we_pulse should have the same delay as
-- clk of wereg
signal clk0_delayed : std_logic;

COMPONENT apex20ke_dffe
    GENERIC (
             TimingChecksOn               : Boolean := true;
             InstancePath                 : STRING := "*";
             XOn                          : Boolean := DefGlitchXOn;
             MsgOn                        : Boolean := DefGlitchMsgOn;
             MsgOnChecks                  : Boolean := DefMsgOnChecks;
             XOnChecks                    : Boolean := DefXOnChecks;
             tpd_PRN_Q_negedge            : VitalDelayType01 := DefPropDelay01;
             tpd_CLRN_Q_negedge           : VitalDelayType01 := DefPropDelay01;
             tpd_CLK_Q_posedge            : VitalDelayType01 := DefPropDelay01;
             tpd_ENA_Q_posedge            : VitalDelayType01 := DefPropDelay01;
             tsetup_D_CLK_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
             tsetup_D_CLK_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
             tsetup_ENA_CLK_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
             thold_D_CLK_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
             thold_D_CLK_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             thold_ENA_CLK_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tipd_D                       : VitalDelayType01 := DefPropDelay01;
             tipd_CLRN                    : VitalDelayType01 := DefPropDelay01;
             tipd_PRN                     : VitalDelayType01 := DefPropDelay01;
             tipd_CLK                     : VitalDelayType01 := DefPropDelay01;
             tipd_ENA                     : VitalDelayType01 := DefPropDelay01
            );

    PORT    (
             Q                            :  out   STD_LOGIC := '0';
             D                            :  in    STD_LOGIC := '1';
             CLRN                         :  in    STD_LOGIC := '1';
             PRN                          :  in    STD_LOGIC := '1';
             CLK                          :  in    STD_LOGIC := '0';
             ENA                          :  in    STD_LOGIC := '1'
            );
END COMPONENT;

COMPONENT and1
    GENERIC (
             XOn            : Boolean := DefGlitchXOn;
             MsgOn          : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y      :  VitalDelayType01 := DefPropDelay01;
             tipd_IN1       :  VitalDelayType01 := DefPropDelay01
            );

    PORT    (Y              :  out   STD_LOGIC;
             IN1            :  in    STD_LOGIC
            );
END COMPONENT;

COMPONENT mux21
    PORT ( A : in std_logic := '0';
           B : in std_logic := '0';
           S : in std_logic := '0';
           MO : out std_logic
         );
END COMPONENT;

COMPONENT nmux21
    PORT ( A : in std_logic := '0';
           B : in std_logic := '0';
           S : in std_logic := '0';
           MO : out std_logic
         );
END COMPONENT;

COMPONENT bmux21
    PORT ( A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
           B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
           S : in std_logic := '0';
           MO : out std_logic_vector(15 downto 0)
         );
END COMPONENT;

COMPONENT apex20ke_cam
    GENERIC (operation_mode       : string := "encoded_address";
             logical_cam_depth    : integer := 32;
             first_pattern_bit    : integer := 0;
             first_address        : integer := 0;
             last_address         : integer := 31;
             init_mem_true        : apex20ke_mem_data := (OTHERS => "11111111111111111111111111111111");
             init_mem_comp        : apex20ke_mem_data := (OTHERS => "11111111111111111111111111111111");
             address_width        : integer := 1;
             pattern_width        : integer := 32
            );

     PORT    (datain              : in std_logic := '0';
              wrinvert            : in std_logic := '0';
              outputselect        : in std_logic := '0';
              we                  : in std_logic := '0';
              waddr               : in std_logic_vector(4 downto 0) := (OTHERS => '0');
              lit                 : in std_logic_vector(31 downto 0) := (OTHERS => '0');
              modesel             : in std_logic_vector(1 downto 0) := "00";
              matchfound          : out std_logic;
              matchout            : out std_logic_vector(15 downto 0)
             );
END COMPONENT;

begin
    -- READ THE MODESEL PORT BITS
  
    waddr_clr_sel             <= modesel(0);
    write_logic_sel           <= modesel(1);
    write_logic_clr_sel       <= modesel(2);
    we_clr_sel                <= modesel(3);
    output_reg_sel            <= modesel(4);
    output_clk_sel            <= modesel(5);
    output_clr_sel            <= modesel(6);
    output_reg_clr_sel        <= modesel(7);
    
    outputclksel: mux21 
            port map (A => clk0, 
                      B => clk1,
                      S => output_clk_sel, 
                      MO => output_clk
                     );
    outputclkensel: mux21 
            port map (A => ena0,
                      B => ena1,
                      S => output_clk_sel, 
                      MO => output_clk_en
                     );
    outputregclrsel: mux21 
            port map (A => clr0,
                      B => clr1,
                      S => output_reg_clr_sel, 
                      MO => output_reg_clr
                     );    
    outputclrsel: nmux21 
            port map (A => NC,
                      B => output_reg_clr,
                      S => output_clr_sel, 
                      MO => output_clr
                     );
    matchoutsel: bmux21
            port map (A => matchout_int,
                      B => matchout_reg,
                      S => output_reg_sel,
                      MO => matchout
                     );
    matchfoundsel: mux21
            port map (A => matchfound_int,
                      B => matchfound_reg,
                      S => output_reg_sel,
                      MO => matchfound
                     );
    wdatainsel: mux21
            port map (A => datain,
                      B => wdatain_reg,
                      S => write_logic_sel,
                      MO => wdatain_int
                     );
    wrinvsel: mux21
            port map (A => wrinvert,
                      B => wrinv_reg,
                      S => write_logic_sel,
                      MO => wrinv_int
                     );
    weclrsel: nmux21
            port map (A => clr0,
                      B => NC,
                      S => we_clr_sel,
                      MO => we_clr
                     );
    waddrclrsel: nmux21
            port map (A => clr0,
                      B => NC,
                      S => waddr_clr_sel,
                      MO => waddr_clr
                     );
    writelogicclrsel: nmux21
            port map (A => clr0,
                      B => NC,
                      S => write_logic_clr_sel,
                      MO => write_logic_clr
                     );
    wereg_clr <= we_clr and devclrn and devpor;
    wereg: apex20ke_dffe
            port map (D => we,
                      CLRN => wereg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => we_reg
                     );    
    -- clk0 for we_pulse should have the same delay as
    -- clk of wereg
    
    we_pulse <= we_reg_delayed and (not clk0_delayed);
    wedelay_buf: and1
            port map (IN1 => we_reg,
                      Y => we_reg_delayed
                     );    
    clk0weregdelaybuf: and1
            port map (IN1 => clk0,
                      Y => clk0_delayed
                     );
    writelogic_clr <= write_logic_clr and devclrn and devpor;
    wdatainreg: apex20ke_dffe
            port map (D => datain,
                      CLRN => writelogic_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => wdatain_reg
                     );
    wrinvreg: apex20ke_dffe
            port map (D => wrinvert,
                      CLRN => writelogic_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => wrinv_reg
                     );
    waddrreg_clr <= waddr_clr and devclrn and devpor;
    waddrreg_0: apex20ke_dffe 
            port map (D => waddr(0),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(0)
                     );
    waddrreg_1: apex20ke_dffe 
            port map (D => waddr(1),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(1)
                     );
    waddrreg_2: apex20ke_dffe 
            port map (D => waddr(2),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(2)
                     );
    waddrreg_3: apex20ke_dffe 
            port map (D => waddr(3),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(3)
                     );
    waddrreg_4: apex20ke_dffe 
            port map (D => waddr(4),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(4)
                     );
    outputreg_clr <= output_clr and devclrn and devpor;
    matchoutreg_0: apex20ke_dffe
            port map (D => matchout_int(0),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(0)
                     );
    matchoutreg_1: apex20ke_dffe
            port map (D => matchout_int(1),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(1)
                     );
    matchoutreg_2: apex20ke_dffe
            port map (D => matchout_int(2),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(2)
                     );
    matchoutreg_3: apex20ke_dffe
            port map (D => matchout_int(3),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(3)
                     );
    matchoutreg_4: apex20ke_dffe
            port map (D => matchout_int(4),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(4)
                     );
    matchoutreg_5: apex20ke_dffe
            port map (D => matchout_int(5),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(5)
                     );
    matchoutreg_6: apex20ke_dffe
            port map (D => matchout_int(6),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(6)
                     );
    matchoutreg_7: apex20ke_dffe
            port map (D => matchout_int(7),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(7)
                     );
    matchoutreg_8: apex20ke_dffe
            port map (D => matchout_int(8),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(8)
                     );
    matchoutreg_9: apex20ke_dffe
            port map (D => matchout_int(9),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(9)
                     );
    matchoutreg_10: apex20ke_dffe
            port map (D => matchout_int(10),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(10)
                     );
    matchoutreg_11: apex20ke_dffe
            port map (D => matchout_int(11),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(11)
                     );
    matchoutreg_12: apex20ke_dffe
            port map (D => matchout_int(12),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(12)
                     );
    matchoutreg_13: apex20ke_dffe
            port map (D => matchout_int(13),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(13)
                     );
    matchoutreg_14: apex20ke_dffe
            port map (D => matchout_int(14),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(14)
                     );
    matchoutreg_15: apex20ke_dffe
            port map (D => matchout_int(15),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(15)
                     );
    matchfoundreg: apex20ke_dffe
            port map (D => matchfound_int,
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchfound_reg
                     );
    
    cam1: apex20ke_cam
           generic map (operation_mode      => operation_mode,
                        address_width       => address_width,
                        pattern_width       => pattern_width,
                        first_pattern_bit   => first_pattern_bit,
                        first_address       => first_address,
                        last_address        => last_address,
                        init_MEM_TRUE       => init_mem_true,
                        init_MEM_COMP       => init_mem_comp,
                        LOGICAL_CAM_DEPTH   => logical_cam_depth
                       )

            port map   (datain              => wdatain_int,
                        wrinvert            => wrinv_int,
                        outputselect        => outputselect,
                        we                  => we_pulse,
                        waddr               => waddr_reg,
                        lit                 => lit,
                        modesel             => modesel(9 downto 8),
                        matchout            => matchout_int,
                        matchfound          => matchfound_int
                       );

end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_lvds_transmitter
--
-- Description : Simulation model for APEX 20KE LVDS_TX.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;

ENTITY apex20ke_lvds_transmitter is
    GENERIC (
        channel_width		: integer := 8;
        TimingChecksOn		: Boolean := True;
        MsgOn			: Boolean := DefGlitchMsgOn;
        MsgOnChecks             : Boolean := DefMsgOnChecks;
        XOnChecks               : Boolean := DefXOnChecks;
        XOn			: Boolean := DefGlitchXOn;
        InstancePath		: String := "*";
        tsetup_datain_clk1_noedge_negedge  : VitalDelayArrayType(7 downto 0) := (OTHERS => DefSetupHoldCnst);
        thold_datain_clk1_noedge_negedge   : VitalDelayArrayType(7 downto 0) := (OTHERS => DefSetupHoldCnst);
        tpd_clk0_dataout_negedge: VitalDelayType01 := DefPropDelay01;
        tipd_clk0		: VitalDelayType01 := DefpropDelay01;
        tipd_clk1		: VitalDelayType01 := DefpropDelay01;
        tipd_datain		: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefpropDelay01)
        );

    PORT (
        clk0		: in std_logic;
        clk1		: in std_logic;
        datain		: in std_logic_vector(7 downto 0);
        devclrn		: in std_logic := '1';
        devpor		: in std_logic := '1';
        dataout		: out std_logic
        );
    attribute VITAL_LEVEL0 of apex20ke_lvds_transmitter : ENTITY is TRUE;
end apex20ke_lvds_transmitter;

ARCHITECTURE vital_transmitter_atom of apex20ke_lvds_transmitter is
    attribute VITAL_LEVEL0 of vital_transmitter_atom : ARCHITECTURE is TRUE;
    signal clk0_ipd : std_logic;
    signal clk1_ipd : std_logic;
    signal datain_ipd : std_logic_vector(7 downto 0);

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk0_ipd, clk0, tipd_clk0);
        VitalWireDelay (clk1_ipd, clk1, tipd_clk1);
        VitalWireDelay (datain_ipd(0), datain(0), tipd_datain(0));
        VitalWireDelay (datain_ipd(1), datain(1), tipd_datain(1));
        VitalWireDelay (datain_ipd(2), datain(2), tipd_datain(2));
        VitalWireDelay (datain_ipd(3), datain(3), tipd_datain(3));
        VitalWireDelay (datain_ipd(4), datain(4), tipd_datain(4));
        VitalWireDelay (datain_ipd(5), datain(5), tipd_datain(5));
        VitalWireDelay (datain_ipd(6), datain(6), tipd_datain(6));
        VitalWireDelay (datain_ipd(7), datain(7), tipd_datain(7));
    end block;

    VITAL: process (clk0_ipd, clk1_ipd, devclrn, devpor)
    variable Tviol_datain_clk1 : std_ulogic := '0';
    variable TimingData_datain_clk1 : VitalTimingDataType := VitalTimingDataInit;
    variable dataout_VitalGlitchData : VitalGlitchDataType;
    variable i : integer := 0;
    variable dataout_tmp : std_logic;
    variable indata : std_logic_vector(channel_width-1 downto 0);
    variable regdata : std_logic_vector(channel_width-1 downto 0);
    variable fast_clk_count : integer := 4;
    begin

        if (now = 0 ns) then
            dataout_tmp := '0';
        end if;

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
        
            VitalSetupHoldCheck (
                Violation       => Tviol_datain_clk1,
                TimingData      => TimingData_datain_clk1,
                TestSignal      => datain_ipd,
                TestSignalName  => "DATAIN",
                RefSignal       => clk0_ipd,
                RefSignalName   => "CLK1",
                SetupHigh       => tsetup_datain_clk1_noedge_negedge(0),
                SetupLow        => tsetup_datain_clk1_noedge_negedge(0),
                HoldHigh        => thold_datain_clk1_noedge_negedge(0),
                HoldLow         => thold_datain_clk1_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEX20KE_LVDS_TX",
                XOn             => XOn,
                MsgOn           => MsgOn
                );

        end if;

        if ((devpor = '0') or (devclrn = '0')) then
            dataout_tmp := '0';
        else
            if (clk1_ipd'event and clk1_ipd = '1') then
                fast_clk_count := 0;
            end if;
            if (clk0_ipd'event and clk0_ipd = '1') then
                if (fast_clk_count = 2) then
                    for i in channel_width-1 downto 0 loop
                        regdata(i) := indata(i);
                    end loop;
                end if;
                dataout_tmp := regdata(channel_width-1);
                for i in channel_width-1 downto 1 loop
                    regdata(i) := regdata(i-1);
                end loop;
            end if;
            if (clk0_ipd'event and clk0_ipd = '0') then  -- falling edge
                fast_clk_count := fast_clk_count + 1; -- SPR 87691
                if (fast_clk_count = 3) then
                    indata := datain_ipd(channel_width-1 downto 0);
                end if;
            end if;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => dataout,
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp,
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge, TRUE)),
            GlitchData => dataout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );

    end process;

end vital_transmitter_atom;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_lvds_receiver
--
-- Description : Simulation model for APEX 20KE LVDS_RX.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;
use std.textio.all;


ENTITY apex20ke_lvds_receiver is
    GENERIC (
        channel_width		: integer := 8;
        TimingChecksOn		: Boolean := True;
        MsgOn			: Boolean := DefGlitchMsgOn;
        XOn			: Boolean := DefGlitchXOn;
        MsgOnChecks             : Boolean := DefMsgOnChecks;
        XOnChecks               : Boolean := DefXOnChecks;
        InstancePath		: String := "*";
        tpd_clk0_dataout_negedge: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
        tipd_clk0		: VitalDelayType01 := DefpropDelay01;
        tipd_clk1		: VitalDelayType01 := DefpropDelay01;
        tipd_deskewin		: VitalDelayType01 := DefpropDelay01;
        tipd_datain		: VitalDelayType01 := DefpropDelay01
        );

    PORT (
        clk0		: in std_logic;
        clk1		: in std_logic;
        datain		: in std_logic;
        deskewin	: in std_logic := '0';
        devclrn		: in std_logic := '1';
        devpor		: in std_logic := '1';
        dataout		: out std_logic_vector(7 downto 0)
        );
    attribute VITAL_LEVEL0 of apex20ke_lvds_receiver : ENTITY is TRUE;
end apex20ke_lvds_receiver;

ARCHITECTURE vital_receiver_atom of apex20ke_lvds_receiver is
    attribute VITAL_LEVEL0 of vital_receiver_atom : ARCHITECTURE is TRUE;
    signal clk0_tmp, clk0_ipd, clk1_ipd, deskewin_ipd : std_logic;
    signal clk0_tmp1, clk0_tmp2 : std_logic;
    signal datain_ipd : std_logic;

begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
        VitalWireDelay (clk0_tmp, clk0, tipd_clk0);
        VitalWireDelay (clk1_ipd, clk1, tipd_clk1);
        VitalWireDelay (deskewin_ipd, deskewin, tipd_deskewin);
        VitalWireDelay (datain_ipd, datain, tipd_datain);
    end block;

    clk0_tmp1 <= clk0_tmp after 0 ns;
    clk0_tmp2 <= clk0_tmp1 after 0 ns;
    clk0_ipd <= clk0_tmp2 after 0 ns;

    VITAL: process (deskewin_ipd, clk0_ipd, clk1_ipd, devpor, devclrn)
    variable Tviol_datain_clk0 : std_ulogic := '0';
    variable Tviol_deskewin_clk0 : std_ulogic := '0';
    variable TimingData_datain_clk0 : VitalTimingDataType := VitalTimingDataInit;
    variable TimingData_deskewin_clk0 : VitalTimingDataType := VitalTimingDataInit;
    variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(7 downto 0);
    variable clk0_count, cal_error : integer := 0;
    variable cal_cycle : integer := 1;
    variable deser_data_arr : std_logic_vector(channel_width-1 downto 0);
    variable dataout_tmp : std_logic_vector(7 downto 0);
    variable first_cycle : boolean := true;
    variable fast_clk_count : integer := 4;
    variable deskew_asserted : boolean := false;
    variable calibrated : boolean := false;
    variable check_calibration : boolean := false;
    variable screen_buffer : LINE;
    variable temp7vec : bit_vector(6 downto 0);
    variable temp8vec : bit_vector(7 downto 0);
    variable result : boolean := false;
    begin

        if (now = 0 ns) then
            dataout_tmp := (OTHERS => '0');
        end if;

        if ((devpor = '0') or (devclrn = '0')) then
            dataout_tmp := (OTHERS => '0');
        else
            if (deskewin_ipd'event and deskewin_ipd = '1') then
                deskew_asserted := true;
                calibrated := false;
                if (channel_width < 7) then
                    assert false report "Channel Width is less than 7. Calibration signal ignored." severity warning;
                else
                    assert false report "Calibrating receiver ...." severity note;
                end if;
            end if;

            if (deskewin_ipd'event and deskewin_ipd = '0') then
                deskew_asserted := false;
            end if;

            if (clk1_ipd'event and clk1_ipd = '1') then
                clk0_count := 0;
                if (check_calibration and not calibrated) then
                    -- old is_calibration_pattern function
                    if (channel_width = 7) then
                        if (deser_data_arr = "0000111") then
                            -- calibrate ok
                            write(screen_buffer, string'("Cycle : "));
                            write(screen_buffer, cal_cycle);
                            write(screen_buffer, string'(", Calibration pattern: 0000111."));
                            writeline (OUTPUT, screen_buffer);
                            result := true;
                        else
                            write(screen_buffer, string'("Calibration error in cycle "));
                            write(screen_buffer, cal_cycle);
                            writeline (OUTPUT, screen_buffer);
                            write(screen_buffer, string'("Expected pattern: 0000111, Actual pattern: "));
                            temp7vec := To_BitVector(deser_data_arr);
                            write(screen_buffer, temp7vec);
                            writeline (OUTPUT, screen_buffer);
                            result := false;
                        end if;
                    elsif (channel_width = 8) then
                        if (deser_data_arr = "00001111") then
                            -- calibrate ok
                            write(screen_buffer, string'("Cycle : "));
                            write(screen_buffer, cal_cycle);
                            write(screen_buffer, string'(", Calibration pattern: 00001111."));
                            writeline (OUTPUT, screen_buffer);
                            result := true;
                        else
                            write(screen_buffer, string'("Calibration error in cycle "));
                            write(screen_buffer, cal_cycle);
                            writeline (OUTPUT, screen_buffer);
                            write(screen_buffer, string'("Expected pattern: 00001111, Actual pattern: "));
                            temp8vec := To_BitVector(deser_data_arr);
                            write(screen_buffer, temp8vec);
                            writeline (OUTPUT, screen_buffer);
                            result := false;
                        end if;
                    end if;

                    if (result = true) then
                        cal_cycle := cal_cycle + 1;
                        if (cal_cycle >= 4) then
                            calibrated := true;
                            assert false report "Receiver Calibration successful" severity note;
                        end if;
                    else
                        if (not calibrated and not deskew_asserted) then
                            write(screen_buffer, string'("Receiver calibration requires at least 3 clock cycles.  Only "));
                            write(screen_buffer, cal_cycle);
                            write(screen_buffer, string'("cycles were completed when deskew was deasserted. Receiver may not be calibrated."));
                            writeline (OUTPUT, screen_buffer);
                        end if;
                        cal_cycle := 0;
                    end if;
                end if;

                if (deskew_asserted) then
                    check_calibration := true;
                else
                    check_calibration := false;
                end if;
            end if;

            if (clk0_ipd'event and clk0_ipd = '0') then
                clk0_count := clk0_count + 1;
                if (clk0_count = 3 and not deskew_asserted) then
                    dataout_tmp(channel_width-1 downto 0) := deser_data_arr;
                end if;
                for i in channel_width-1 downto 1 loop
                    deser_data_arr(i) := deser_data_arr(i-1);
                end loop;
                deser_data_arr(0) := datain_ipd;
            end if;
        end if;

        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => dataout(0),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(0),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(0), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(0),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
        
        VitalPathDelay01 (
            OutSignal => dataout(1),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(1),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(1), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(1),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
        
        VitalPathDelay01 (
            OutSignal => dataout(2),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(2),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(2), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(2),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
        
        VitalPathDelay01 (
            OutSignal => dataout(3),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(3),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(3), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(3),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );

        VitalPathDelay01 (
            OutSignal => dataout(4),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(4),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(4), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(4),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
        
        VitalPathDelay01 (
            OutSignal => dataout(5),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(5),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(5), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(5),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
        
        VitalPathDelay01 (
            OutSignal => dataout(6),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(6),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(6), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(6),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );

        VitalPathDelay01 (
            OutSignal => dataout(7),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(7),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(7), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(7),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
        );

    end process;

end vital_receiver_atom;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEX20KE_PLL
--
-- Description : Timing simulation model for APEX20KE device family PLL
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.apex20ke_atom_pack.all;

ENTITY  apex20ke_pll is
    GENERIC (
             input_frequency            : integer  := 1000;
             operation_mode             : string := "normal";
             simulation_type            : string := "timing";
             clk0_multiply_by           : integer := 1;
             clk0_divide_by             : integer := 1;
             clk1_multiply_by           : integer := 1;
             clk1_divide_by             : integer := 1;
             phase_shift                : integer := 0;
             effective_phase_shift      : integer := 0;
             effective_clk0_delay       : integer := 0;
             effective_clk1_delay       : integer := 0;
             lock_high                  : integer := 1;
             invalid_lock_multiplier    : integer := 5;
             valid_lock_multiplier      : integer := 5;
             lock_low                   : integer := 1;
             MsgOn                      : Boolean := DefGlitchMsgOn;
             XOn                        : Boolean := DefGlitchXOn;
             tpd_ena_clk0               : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk1               : VitalDelayType01 := DefPropDelay01;
             tpd_clk_locked             : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk0              : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk1              : VitalDelayType01 := DefPropDelay01;
             tipd_clk                   : VitalDelayType01 := DefpropDelay01;
             tipd_fbin                  : VitalDelayType01 := DefpropDelay01;
             tipd_ena                   : VitalDelayType01 := DefpropDelay01
            );

    PORT    (clk                        : in std_logic;
             ena                        : in std_logic;
             fbin                       : in std_logic;
             clk0                       : out std_logic;
             clk1                       : out std_logic;
             locked                     : out std_logic
            );
        attribute VITAL_LEVEL0 of apex20ke_pll : ENTITY is TRUE;
end apex20ke_pll;

ARCHITECTURE vital_pll_atom of apex20ke_pll is
attribute VITAL_LEVEL0 of vital_pll_atom : ARCHITECTURE is TRUE;
signal clk_ipd : std_logic;
signal ena_ipd : std_logic;
signal fbin_ipd : std_logic;

SIGNAL clk0_period, clk1_period, half_inclk : time;
SIGNAL pll_lock : std_logic := '0';
SIGNAL lock_on_rise, lock_on_fall : integer := 0;
SIGNAL clk_check : std_logic := '0';

SIGNAL clk0_tmp, clk1_tmp : std_logic := 'X';
begin

    ----------------------
    --  INPUT PATH DELAYs
    ----------------------
    WireDelay : block
    begin
       VitalWireDelay (clk_ipd, clk, tipd_clk);
       VitalWireDelay (ena_ipd, ena, tipd_ena);
       VitalWireDelay (fbin_ipd, fbin, tipd_fbin);
    end block;

    process (clk_ipd, ena_ipd, pll_lock, clk_check)
    variable expected_cycle, real_cycle : real := 0.0;
    variable inclk_ps : time := 0 ps;
    variable violation : boolean := false;
    variable pll_lock_tmp : std_logic := '0';
    variable start_lock_count, stop_lock_count : integer := 0;
    variable pll_last_rising_edge, pll_last_falling_edge : time := 0 ps;
    variable pll_rising_edge_count : integer := 0 ;
    variable pll_cycle, pll_duty_cycle : time := 0 ps;
    variable expected_next_clk_edge : time := 0 ps;
    variable clk_per_tolerance : time := 0 ps; 
    variable locked_VitalGlitchData : VitalGlitchDataType;

    variable last_synchronizing_rising_edge_for_clk0 : time := 0 ps;
    variable last_synchronizing_rising_edge_for_clk1 : time := 0 ps;
    variable input_cycles_per_clk0, input_cycles_per_clk1 : integer;
    variable input_cycle_count_to_sync0 : integer := 0;
    variable input_cycle_count_to_sync1 : integer := 0;
    variable init : boolean := true;
    variable output_value : std_logic := '0';
    variable vco_per : time;
    variable high_time : time;
    variable low_time : time;
    variable sched_time : time := 0 ps;
    variable tmp_per  : integer := 0;
    variable temp, tmp_rem, my_rem : integer;
    variable l : integer := 1;
    variable cycle_to_adjust : integer := 0;
    variable clk0_synchronizing_period, clk1_synchronizing_period : time;
    variable clk0_cycles_per_sync_period : integer := clk0_multiply_by;
    variable clk1_cycles_per_sync_period : integer := clk1_multiply_by;
    variable schedule_clk0, schedule_clk1 : boolean := false;
    variable clk0_phase_delay, clk1_phase_delay : time := 0 ps;
    begin
       if (init) then
          clk0_cycles_per_sync_period := clk0_multiply_by;
          clk1_cycles_per_sync_period := clk1_multiply_by;
          input_cycles_per_clk0 := clk0_divide_by;
          input_cycles_per_clk1 := clk1_divide_by;
          init := false;
       end if;

       if (ena_ipd = '0') then
          pll_lock_tmp := '0';
          pll_rising_edge_count := 0;
       elsif (clk_ipd'event and clk_ipd = '1') then
          if (pll_lock_tmp = '1') then
             clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
          end if;
          if pll_rising_edge_count = 0 then      -- at 1st rising edge
             inclk_ps := (input_frequency / 1 ) * 1 ps;
             half_inclk <= inclk_ps/2;
             clk_per_tolerance := 0.1 * inclk_ps;
             clk0_period <= (clk0_divide_by * inclk_ps) / clk0_multiply_by;
             clk1_period <= (clk1_divide_by * inclk_ps)/ clk1_multiply_by;
             pll_duty_cycle := inclk_ps/2;

             if (simulation_type = "functional") then
                clk0_phase_delay := phase_shift * 1 ps;
                clk1_phase_delay := phase_shift * 1 ps;
             else
                clk0_phase_delay := effective_clk0_delay * 1 ps;
                clk1_phase_delay := effective_clk1_delay * 1 ps;
             end if;
          elsif pll_rising_edge_count = 1 then      -- at 2nd rising edge
             pll_cycle := now - pll_last_rising_edge;    -- calculate period
             expected_cycle := real(input_frequency) / 1000.0;
             real_cycle := REAL( (NOW - pll_last_rising_edge) / 1 ns);
             if ( (NOW - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance)  or
                  (NOW - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance)) then
                assert false report " Inclock_Period Violation " severity warning;
                violation := true;
                if (pll_lock = '1') then
                   stop_lock_count := stop_lock_count + 1;
                   if (stop_lock_count = lock_low) then
                      pll_lock_tmp := '0';
                   end if;
                else
                   start_lock_count := 1;
                end if;
             else
                violation := false;
             end if;
             if ( (now - pll_last_falling_edge) < (pll_duty_cycle - clk_per_tolerance/2) or (now - pll_last_falling_edge) > (pll_duty_cycle + clk_per_tolerance/2) ) then
                ASSERT FALSE
                REPORT "Duty Cycle Violation"
                SEVERITY WARNING;
                violation := true;
             else
                violation := false;
             end if;
          else
             pll_cycle := now - pll_last_rising_edge;    -- calculate period
             if ((now - pll_last_rising_edge) < (inclk_ps - clk_per_tolerance) or
                 (now - pll_last_rising_edge) > (inclk_ps + clk_per_tolerance) ) then
                ASSERT FALSE
                REPORT "Cycle Violation"
                SEVERITY WARNING;
                violation := true;
                if (pll_lock = '1') then
                   stop_lock_count := stop_lock_count + 1;
                   if (stop_lock_count = lock_low) then
                      pll_lock_tmp := '0';
                   end if;
                else
                   start_lock_count := 1;
                end if;
             else
                violation := false;
             end if;
          end if;
          pll_last_rising_edge := now;
          pll_rising_edge_count := pll_rising_edge_count +1;
          if (not violation) then
             if (pll_lock_tmp = '1') then
                input_cycle_count_to_sync0 := input_cycle_count_to_sync0 + 1;
                if (input_cycle_count_to_sync0 = input_cycles_per_clk0) then
                   clk0_synchronizing_period := now - last_synchronizing_rising_edge_for_clk0;
                   last_synchronizing_rising_edge_for_clk0 := now;
                   schedule_clk0 := true;
                   input_cycle_count_to_sync0 := 0;
                end if;
                input_cycle_count_to_sync1 := input_cycle_count_to_sync1 + 1;
                if (input_cycle_count_to_sync1 = input_cycles_per_clk1) then
                   clk1_synchronizing_period := now - last_synchronizing_rising_edge_for_clk1;
                   last_synchronizing_rising_edge_for_clk1 := now;
                   schedule_clk1 := true;
                   input_cycle_count_to_sync1 := 0;
                end if;
             else
                start_lock_count := start_lock_count + 1;
                if (start_lock_count >= lock_high) then
                   pll_lock_tmp := '1';
                   lock_on_rise <= 1;
                   input_cycle_count_to_sync0 := 0;
                   input_cycle_count_to_sync1 := 0;
                   if (last_synchronizing_rising_edge_for_clk0 = 0 ps) then
                      clk0_synchronizing_period := ((pll_cycle/1 ps) * clk0_divide_by) * 1 ps;
                   else
                      clk0_synchronizing_period := now - last_synchronizing_rising_edge_for_clk0;
                   end if;
                   if (last_synchronizing_rising_edge_for_clk1 = 0 ps) then
                      clk1_synchronizing_period := ((pll_cycle/1 ps) * clk1_divide_by) * 1 ps;
                   else
                      clk1_synchronizing_period := now - last_synchronizing_rising_edge_for_clk1;
                   end if;
                   last_synchronizing_rising_edge_for_clk0 := now;
                   last_synchronizing_rising_edge_for_clk1 := now;
                   schedule_clk0 := true;
                   schedule_clk1 := true;
                end if;
             end if;
          else
             start_lock_count := 1;
          end if;

       elsif (clk_ipd'event and clk_ipd= '0') then
          if (pll_lock_tmp = '1') then
             clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
             if (now > 0 ns and ((now - pll_last_rising_edge) < (pll_duty_cycle - clk_per_tolerance/2) or (now - pll_last_rising_edge) > (pll_duty_cycle + clk_per_tolerance/2) ) ) then
                assert false report "Duty Cycle Violation" severity warning; 
                violation := true;
                if (pll_lock = '1') then
                   stop_lock_count := stop_lock_count + 1;
                   if (stop_lock_count = lock_low) then
                      pll_lock_tmp := '0';
                   end if;
                end if;
             else
                violation := false;
             end if;
          else
             start_lock_count := start_lock_count + 1;
          end if;
          pll_last_falling_edge := now;
       else
          if pll_lock_tmp = '1' then
             if (clk_ipd = '1') then
                 expected_next_clk_edge := pll_last_rising_edge + (inclk_ps+clk_per_tolerance)/2.0;
             else
                 expected_next_clk_edge := pll_last_falling_edge + (inclk_ps+clk_per_tolerance)/2.0;
             end if;
             violation := false;

             if (now < expected_next_clk_edge) then
                 clk_check <= not clk_check after (expected_next_clk_edge - now);
             elsif (now = expected_next_clk_edge) then
                 clk_check <= not clk_check after (inclk_ps+clk_per_tolerance)/2.0;
             else
                 ASSERT FALSE
                 REPORT "Inclock_Period Violation"
                 SEVERITY WARNING;
                 violation := true;
                 if (pll_lock = '1') then
                     stop_lock_count := stop_lock_count + 1;
                     if (stop_lock_count = lock_low) then
                         pll_lock_tmp := '0';
                     else
                         clk_check <= not clk_check after (inclk_ps/2.0);
                     end if;
                 end if;
             end if;
          end if;
       end if;
       pll_lock <= pll_lock_tmp;
       if (pll_lock'event and pll_lock = '0') then
          start_lock_count := 0;
          stop_lock_count := 0;
          lock_on_rise <= 0;
          lock_on_fall <= 0;
       end if;

       ----------------------
       --  Path Delay Section
       ----------------------
       VitalPathDelay01 (
         OutSignal => locked,
         OutSignalName => "LOCKED",
         OutTemp => pll_lock,
         Paths => (1 => (clk_ipd'last_event, tpd_clk_locked, TRUE)),
         GlitchData => locked_VitalGlitchData,
         Mode => DefGlitchMode,
         XOn  => XOn,
         MsgOn  => MsgOn );

       if (schedule_clk0) then
          sched_time := clk0_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := clk0_synchronizing_period/1 ps;
          my_rem := temp rem clk0_cycles_per_sync_period;
          for i in 1 to clk0_cycles_per_sync_period loop
              tmp_per := temp/clk0_cycles_per_sync_period;
              if (my_rem /= 0 and l <= my_rem) then
                 tmp_rem := (clk0_cycles_per_sync_period * l) rem my_rem;
                 cycle_to_adjust := (clk0_cycles_per_sync_period * l) / my_rem;
                 if (tmp_rem /= 0) then
                    cycle_to_adjust := cycle_to_adjust + 1;
                 end if;
              end if;
              if (cycle_to_adjust = i) then
                  tmp_per := tmp_per + 1;
                  l := l + 1;
              end if;
              vco_per := tmp_per * 1 ps;
              high_time := (tmp_per/2) * 1 ps;
              if (tmp_per rem 2 /= 0) then
                 high_time := high_time + 1 ps;
              end if;
              low_time := vco_per - high_time;
              for j in 1 to 2 loop
                 clk0_tmp <= transport output_value after sched_time;
                 output_value := not output_value;
                 if (output_value = '0') then
                    sched_time := sched_time + high_time;
                 elsif (output_value = '1') then
                    sched_time := sched_time + low_time;
                 end if;
              end loop;
          end loop;
          schedule_clk0 := false;
       end if;
 
       if (schedule_clk1) then
          sched_time := clk1_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := clk1_synchronizing_period/1 ps;
          my_rem := temp rem clk1_cycles_per_sync_period;
          for i in 1 to clk1_cycles_per_sync_period loop
              tmp_per := temp/clk1_cycles_per_sync_period;
              if (my_rem /= 0 and l <= my_rem) then
                 tmp_rem := (clk1_cycles_per_sync_period * l) rem my_rem;
                 cycle_to_adjust := (clk1_cycles_per_sync_period * l) / my_rem;
                 if (tmp_rem /= 0) then
                    cycle_to_adjust := cycle_to_adjust + 1;
                 end if;
              end if;
              if (cycle_to_adjust = i) then
                  tmp_per := tmp_per + 1;
                  l := l + 1;
              end if;
              vco_per := tmp_per * 1 ps;
              high_time := (tmp_per/2) * 1 ps;
              if (tmp_per rem 2 /= 0) then
                 high_time := high_time + 1 ps;
              end if;
              low_time := vco_per - high_time;
              for j in 1 to 2 loop
                 clk1_tmp <= transport output_value after sched_time;
                 output_value := not output_value;
                 if (output_value = '0') then
                    sched_time := sched_time + high_time;
                 elsif (output_value = '1') then
                    sched_time := sched_time + low_time;
                 end if;
              end loop;
          end loop;
          schedule_clk1 := false;
       end if;
    end process;

    clk0 <= clk0_tmp;
    clk1 <= clk1_tmp;

end vital_pll_atom;

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apex20ke_atom_pack.all;

ENTITY output_delay is
  
  GENERIC (
    tpd_clk_out_posedge : VitalDelayType01 := DefPropDelay01;  -- tco
    MsgOn: Boolean := DefGlitchMsgOn;
    XOn: Boolean := DefGlitchXOn);

  PORT (
    clk    : in  std_logic;
    input  : in  std_logic;
    output : out std_logic);

end output_delay;

ARCHITECTURE v1 of output_delay is

begin  -- v1

process (input, clk)
variable output_VitalGlitchData : VitalGlitchDataType;
begin  -- process
  VitalPathDelay01 (
    OutSignal => output,
    OutSignalName => "REGOUT",
    OutTemp => input,
    Paths => (0 => (clk'last_event, tpd_clk_out_posedge, TRUE)),
    GlitchData => output_VitalGlitchData,
    Mode => DefGlitchMode,
    XOn  => XOn,
    MsgOn  => MsgOn );
 
end process;
 

end v1;


--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : apex20ke_jtagb
--
-- Description : Simulation model for APEX 20KE JTAGB.
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.apex20ke_atom_pack.all;

ENTITY apex20ke_jtagb is
    PORT (
        tms : in std_logic; 
        tck : in std_logic; 
        tdi : in std_logic; 
        ntrst : in std_logic; 
        tdoutap : in std_logic; 
        tdouser : in std_logic; 
        tdo: out std_logic; 
        tmsutap: out std_logic; 
        tckutap: out std_logic; 
        tdiutap: out std_logic; 
        shiftuser: out std_logic; 
        clkdruser: out std_logic; 
        updateuser: out std_logic; 
        runidleuser: out std_logic; 
        usr1user: out std_logic
        );
end apex20ke_jtagb;

ARCHITECTURE architecture_jtagb of apex20ke_jtagb is
begin

    process(tms, tck, tdi, ntrst, tdoutap, tdouser)
    begin

    end process;

end architecture_jtagb;
