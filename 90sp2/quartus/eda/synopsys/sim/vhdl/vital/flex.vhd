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


----------------------------------------------------------------
-- 
-- Created by the Synopsys Library Compiler v3.4b
-- FILENAME     :    flex_VITAL.vhd
-- FILE CONTENTS:    Entity, Structural Architecture(VITAL),
--                   and Configuration
-- DATE CREATED :    Mon Nov  4 15:07:22 1996
-- 
-- LIBRARY      :    flex
-- DATE ENTERED :    Sat Oct 19 16:48:53 1996
-- REVISION     :    0.100000
-- TECHNOLOGY   :    fpga
-- TIME SCALE   :    1 ns
-- LOGIC SYSTEM :    IEEE-1164
-- NOTES        :    VITAL, TimingChecksOn(TRUE), XGenerationOn(FALSE), TimingMessage(TRUE), OnDetect 
-- HISTORY      :
library IEEE;
use IEEE.STD_LOGIC_1164.all;

use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
package SUPPORT is
-- default generic values
    CONSTANT DefWireDelay        : VitalDelayType01      := (0 ns, 0 ns);
    CONSTANT DefPropDelay01      : VitalDelayType01      := (0 ns, 0 ns);
    CONSTANT DefPropDelay01Z     : VitalDelayType01Z     := (OTHERS => 0 ns);
    CONSTANT DefSetupHoldCnst    : TIME := 0 ns;
    CONSTANT DefPulseWdthCnst    : TIME := 0 ns;
-- default control options
    CONSTANT DefGlitchMode       : VitalGlitchKindType   := OnEvent;
    CONSTANT DefGlitchMsgOn      : BOOLEAN       := FALSE;
    CONSTANT DefGlitchXOn        : BOOLEAN       := FALSE;
    CONSTANT DefTimingMsgOn      : BOOLEAN       := FALSE;
    CONSTANT DefTimingXOn        : BOOLEAN       := FALSE;
-- output strength mapping
                                     --  UX01ZWHL-
    CONSTANT PullUp      : VitalOutputMapType    := "UX01HX01X";
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
end SUPPORT;
-- 
----------------------------------------------------------------

----- CELL ACARRY -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ACARRY is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ACARRY : entity is TRUE;
end ACARRY;

-- architecture body --
architecture VITAL of ACARRY is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

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
   ALIAS Y_zd : STD_LOGIC is Results(1);

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
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ACARRY_VITAL of ACARRY is
   for VITAL
   end for;
end CFG_ACARRY_VITAL;


----- CELL ACASCADE -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ACASCADE is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (0.600 ns, 0.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ACASCADE : entity is TRUE;
end ACASCADE;

-- architecture body --
architecture VITAL of ACASCADE is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

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
   ALIAS Y_zd : STD_LOGIC is Results(1);

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
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ACASCADE_VITAL of ACASCADE is
   for VITAL
   end for;
end CFG_ACASCADE_VITAL;


----- CELL AFLEX_CARRY_COUNT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity AFLEX_CARRY_COUNT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tpd_COUNT_CO                   :	VitalDelayType01 := (0.699 ns, 0.699 ns);
      tpd_UPDN_CO                    :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_COUNT                     :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_UPDN                      :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      CI                             :	in    STD_ULOGIC;
      COUNT                          :	in    STD_ULOGIC;
      UPDN                           :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of AFLEX_CARRY_COUNT : entity is TRUE;
end AFLEX_CARRY_COUNT;

-- architecture body --
architecture VITAL of AFLEX_CARRY_COUNT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL CI_ipd    : STD_ULOGIC := 'U';
   SIGNAL COUNT_ipd    : STD_ULOGIC := 'U';
   SIGNAL UPDN_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   VitalWireDelay (COUNT_ipd, COUNT, tipd_COUNT);
   VitalWireDelay (UPDN_ipd, UPDN, tipd_UPDN);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (CI_ipd, COUNT_ipd, UPDN_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd := ((NOT ((UPDN_ipd) XOR (COUNT_ipd)))) AND (CI_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (CI_ipd'last_event, tpd_CI_CO, TRUE),
                 1 => (COUNT_ipd'last_event, tpd_COUNT_CO, TRUE),
                 2 => (UPDN_ipd'last_event, tpd_UPDN_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_AFLEX_CARRY_COUNT_VITAL of AFLEX_CARRY_COUNT is
   for VITAL
   end for;
end CFG_AFLEX_CARRY_COUNT_VITAL;



----- CELL FLEX_CARRYSC_COUNT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRYSC_COUNT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_CI_CO                      :	VitalDelayType01 := (0.200 ns, 0.200 ns);
      tpd_COUNT_CO                   :	VitalDelayType01 := (0.500 ns, 0.500 ns);
      tpd_UPDN_CO                    :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_COUNT_CNTO                 :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_COUNT                     :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_UPDN                      :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      CNTO                           :	out   STD_ULOGIC;
      CI                             :	in    STD_ULOGIC;
      COUNT                          :	in    STD_ULOGIC;
      UPDN                           :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRYSC_COUNT : entity is TRUE;
end FLEX_CARRYSC_COUNT;

-- architecture body --
architecture VITAL of FLEX_CARRYSC_COUNT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL CI_ipd	 : STD_ULOGIC := 'U';
   SIGNAL COUNT_ipd	 : STD_ULOGIC := 'U';
   SIGNAL UPDN_ipd	 : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   VitalWireDelay (COUNT_ipd, COUNT, tipd_COUNT);
   VitalWireDelay (UPDN_ipd, UPDN, tipd_UPDN);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (CI_ipd, COUNT_ipd, UPDN_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 2) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);
   ALIAS CNTO_zd : STD_LOGIC is Results(2);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;
   VARIABLE CNTO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd := ((NOT ((UPDN_ipd) XOR (COUNT_ipd)))) AND (CI_ipd);
      CNTO_zd := TO_X01(COUNT_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (CI_ipd'last_event, tpd_CI_CO, TRUE),
                 1 => (COUNT_ipd'last_event, tpd_COUNT_CO, TRUE),
                 2 => (UPDN_ipd'last_event, tpd_UPDN_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);
      VitalPathDelay01 (
       OutSignal => CNTO,
       GlitchData => CNTO_GlitchData,
       OutSignalName => "CNTO",
       OutTemp => CNTO_zd,
       Paths => (0 => (COUNT_ipd'last_event, tpd_COUNT_CNTO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRYSC_COUNT_VITAL of FLEX_CARRYSC_COUNT is
   for VITAL
   end for;
end CFG_FLEX_CARRYSC_COUNT_VITAL;



----- CELL AGLOBAL -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity AGLOBAL is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.799 ns, 1.799 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of AGLOBAL : entity is TRUE;
end AGLOBAL;

-- architecture body --
architecture VITAL of AGLOBAL is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

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
   ALIAS Y_zd : STD_LOGIC is Results(1);

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
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_AGLOBAL_VITAL of AGLOBAL is
   for VITAL
   end for;
end CFG_AGLOBAL_VITAL;


----- CELL ALCELL -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ALCELL is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ALCELL : entity is TRUE;
end ALCELL;

-- architecture body --
architecture VITAL of ALCELL is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

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
   ALIAS Y_zd : STD_LOGIC is Results(1);

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
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ALCELL_VITAL of ALCELL is
   for VITAL
   end for;
end CFG_ALCELL_VITAL;


----- CELL AMCELL -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity AMCELL is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of AMCELL : entity is TRUE;
end AMCELL;

-- architecture body --
architecture VITAL of AMCELL is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

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
   ALIAS Y_zd : STD_LOGIC is Results(1);

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
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_AMCELL_VITAL of AMCELL is
   for VITAL
   end for;
end CFG_AMCELL_VITAL;


----- CELL ASOFT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ASOFT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ASOFT : entity is TRUE;
end ASOFT;

-- architecture body --
architecture VITAL of ASOFT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

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
   ALIAS Y_zd : STD_LOGIC is Results(1);

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
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ASOFT_VITAL of ASOFT is
   for VITAL
   end for;
end CFG_ASOFT_VITAL;


----- CELL ATBL_1 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_1 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_1 : entity is TRUE;
end ATBL_1;

-- architecture body --
architecture VITAL of ATBL_1 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

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
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := (NOT IN1_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_1_VITAL of ATBL_1 is
   for VITAL
   end for;
end CFG_ATBL_1_VITAL;


----- CELL ATBL_2 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_2 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_2 : entity is TRUE;
end ATBL_2;

-- architecture body --
architecture VITAL of ATBL_2 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := (IN2_ipd) OR (IN1_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_2_VITAL of ATBL_2 is
   for VITAL
   end for;
end CFG_ATBL_2_VITAL;


----- CELL ATBL_3 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_3 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_3 : entity is TRUE;
end ATBL_3;

-- architecture body --
architecture VITAL of ATBL_3 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := (IN2_ipd) AND (IN1_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_3_VITAL of ATBL_3 is
   for VITAL
   end for;
end CFG_ATBL_3_VITAL;


----- CELL ATBL_4 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_4 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN3_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN3                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      IN3                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_4 : entity is TRUE;
end ATBL_4;

-- architecture body --
architecture VITAL of ATBL_4 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN3_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, IN3_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := (IN2_ipd) AND (IN1_ipd) AND (IN3_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE),
                 2 => (IN3_ipd'last_event, tpd_IN3_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_4_VITAL of ATBL_4 is
   for VITAL
   end for;
end CFG_ATBL_4_VITAL;


----- CELL ATBL_5 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_5 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN3_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN4_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN3                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN4                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      IN3                            :	in    STD_ULOGIC;
      IN4                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_5 : entity is TRUE;
end ATBL_5;

-- architecture body --
architecture VITAL of ATBL_5 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN3_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN4_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
   VitalWireDelay (IN4_ipd, IN4, tipd_IN4);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, IN3_ipd, IN4_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := (IN2_ipd) AND (IN1_ipd) AND (IN3_ipd) AND (IN4_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE),
                 2 => (IN3_ipd'last_event, tpd_IN3_Y, TRUE),
                 3 => (IN4_ipd'last_event, tpd_IN4_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_5_VITAL of ATBL_5 is
   for VITAL
   end for;
end CFG_ATBL_5_VITAL;


----- CELL ATBL_6 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_6 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN3_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN3                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      IN3                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_6 : entity is TRUE;
end ATBL_6;

-- architecture body --
architecture VITAL of ATBL_6 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN3_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, IN3_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := ((IN3_ipd) OR (IN2_ipd)) AND (IN1_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE),
                 2 => (IN3_ipd'last_event, tpd_IN3_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_6_VITAL of ATBL_6 is
   for VITAL
   end for;
end CFG_ATBL_6_VITAL;


----- CELL ATBL_7 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_7 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN3_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN4_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN3                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN4                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      IN3                            :	in    STD_ULOGIC;
      IN4                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_7 : entity is TRUE;
end ATBL_7;

-- architecture body --
architecture VITAL of ATBL_7 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN3_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN4_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
   VitalWireDelay (IN4_ipd, IN4, tipd_IN4);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, IN3_ipd, IN4_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := (IN2_ipd) AND (IN1_ipd) AND ((IN4_ipd) OR (IN3_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE),
                 2 => (IN3_ipd'last_event, tpd_IN3_Y, TRUE),
                 3 => (IN4_ipd'last_event, tpd_IN4_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_7_VITAL of ATBL_7 is
   for VITAL
   end for;
end CFG_ATBL_7_VITAL;


----- CELL ATBL_8 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_8 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN3_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN4_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN3                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN4                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      IN3                            :	in    STD_ULOGIC;
      IN4                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_8 : entity is TRUE;
end ATBL_8;

-- architecture body --
architecture VITAL of ATBL_8 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN3_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN4_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
   VitalWireDelay (IN4_ipd, IN4, tipd_IN4);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, IN3_ipd, IN4_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := ((IN3_ipd) OR (IN2_ipd) OR (IN4_ipd)) AND (IN1_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE),
                 2 => (IN3_ipd'last_event, tpd_IN3_Y, TRUE),
                 3 => (IN4_ipd'last_event, tpd_IN4_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_8_VITAL of ATBL_8 is
   for VITAL
   end for;
end CFG_ATBL_8_VITAL;


----- CELL ATBL_9 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_9 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN3_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN4_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN3                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN4                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      IN3                            :	in    STD_ULOGIC;
      IN4                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_9 : entity is TRUE;
end ATBL_9;

-- architecture body --
architecture VITAL of ATBL_9 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN3_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN4_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
   VitalWireDelay (IN4_ipd, IN4, tipd_IN4);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, IN3_ipd, IN4_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := ((IN4_ipd) OR (IN3_ipd)) AND ((IN2_ipd) OR (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE),
                 2 => (IN3_ipd'last_event, tpd_IN3_Y, TRUE),
                 3 => (IN4_ipd'last_event, tpd_IN4_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_9_VITAL of ATBL_9 is
   for VITAL
   end for;
end CFG_ATBL_9_VITAL;


----- CELL ATBL_10 -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATBL_10 is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN2_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN3_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tpd_IN4_Y                      :	VitalDelayType01 := (1.600 ns, 1.600 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN3                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN4                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      IN3                            :	in    STD_ULOGIC;
      IN4                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATBL_10 : entity is TRUE;
end ATBL_10;

-- architecture body --
architecture VITAL of ATBL_10 is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN3_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN4_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (IN3_ipd, IN3, tipd_IN3);
   VitalWireDelay (IN4_ipd, IN4, tipd_IN4);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, IN3_ipd, IN4_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := (((IN4_ipd) AND (IN3_ipd)) OR (IN2_ipd)) AND (IN1_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_Y, TRUE),
                 2 => (IN3_ipd'last_event, tpd_IN3_Y, TRUE),
                 3 => (IN4_ipd'last_event, tpd_IN4_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_ATBL_10_VITAL of ATBL_10 is
   for VITAL
   end for;
end CFG_ATBL_10_VITAL;


----- CELL ATRIBUF -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity ATRIBUF is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (4.400 ns, 4.400 ns);
      tpd_OE_Y                       :	VitalDelayType01z := 
               (6.300 ns, 6.300 ns, 6.300 ns, 6.300 ns, 6.300 ns, 6.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_OE                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      OE                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of ATRIBUF : entity is TRUE;
end ATRIBUF;

-- architecture body --
architecture VITAL of ATRIBUF is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL OE_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (OE_ipd, OE, tipd_OE);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, OE_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Y_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Y_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      Y_zd := VitalBUFIF0 (data => IN1_ipd,
              enable => (NOT OE_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01Z (
       OutSignal => Y,
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, VitalExtendToFillDelay(tpd_IN1_Y), TRUE),
                 1 => (OE_ipd'last_event, VitalExtendToFillDelay(tpd_OE_Y), TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING,
       OutputMap => "UX01ZWLH-");

end process;

end VITAL;

configuration CFG_ATRIBUF_VITAL of ATRIBUF is
   for VITAL
   end for;
end CFG_ATRIBUF_VITAL;


----- CELL DFF -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity DFF is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_CLRN_Q                     :	VitalDelayType01 := (3.099 ns, 3.099 ns);
      tpd_PRN_Q                      :	VitalDelayType01 := (3.000 ns, 3.000 ns);
      tpd_CLK_Q                      :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tsetup_D_CLK                   :	VitalDelayType := 0.200 ns;
      thold_D_CLK                    :	VitalDelayType := 0.000 ns;
      tipd_D                         :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLK                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLRN                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_PRN                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Q                              :	out   STD_ULOGIC;
      D                              :	in    STD_ULOGIC;
      CLK                            :	in    STD_ULOGIC;
      CLRN                           :	in    STD_ULOGIC;
      PRN                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of DFF : entity is TRUE;
end DFF;

-- architecture body --
architecture VITAL of DFF is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL D_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLK_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLRN_ipd    : STD_ULOGIC := 'U';
   SIGNAL PRN_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (D_ipd, D, tipd_D);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (CLRN_ipd, CLRN, tipd_CLRN);
   VitalWireDelay (PRN_ipd, PRN, tipd_PRN);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd)

   -- timing check results
   VARIABLE Tviol_D_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_D_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(1 to 5);
   VARIABLE D_delayed : STD_ULOGIC := 'X';
   VARIABLE CLK_delayed : STD_ULOGIC := 'X';
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Q_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Q_GlitchData	: VitalGlitchDataType;
   CONSTANT DFF_Q_tab : VitalStateTableType := (
    ( L,  x,  x,  x,  x,  x,  L ),
    ( H,  L,  H,  x,  H,  x,  H ),
    ( H,  H,  x,  H,  x,  x,  S ),
    ( H,  x,  x,  L,  x,  x,  H ),
    ( H,  x,  x,  H,  L,  x,  S ),
    ( x,  L,  L,  H,  H,  x,  L ));

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_D_CLK_posedge,
          TimingData              => Tmkr_D_CLK_posedge,
          TestSignal              => D_ipd,
          TestSignalName          => "D",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_D_CLK,
          SetupLow                => tsetup_D_CLK,
          HoldHigh                => thold_D_CLK,
          HoldLow                 => thold_D_CLK,
          CheckEnabled            => 
                           TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) )
                            /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/DFF",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_D_CLK_posedge;
      VitalStateTable(
        Result => Q_zd,
        PreviousDataIn => PrevData_Q,
        StateTable => DFF_Q_tab,
        DataIn => (
               CLRN_ipd, CLK_delayed, D_delayed, PRN_ipd, CLK_ipd));
      Q_zd := Violation XOR Q_zd;
      D_delayed := D_ipd;
      CLK_delayed := CLK_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       GlitchData => Q_GlitchData,
       OutSignalName => "Q",
       OutTemp => Q_zd,
       Paths => (0 => (CLRN_ipd'last_event, tpd_CLRN_Q, TRUE),
                 1 => (PRN_ipd'last_event, tpd_PRN_Q, TRUE),
                 2 => (CLK_ipd'last_event, tpd_CLK_Q, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_DFF_VITAL of DFF is
   for VITAL
   end for;
end CFG_DFF_VITAL;


----- CELL DFFE -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity DFFE is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_CLRN_Q                     :	VitalDelayType01 := (3.099 ns, 3.099 ns);
      tpd_PRN_Q                      :	VitalDelayType01 := (3.000 ns, 3.000 ns);
      tpd_CLK_Q                      :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tsetup_D_CLK                   :	VitalDelayType := 0.200 ns;
      thold_D_CLK                    :	VitalDelayType := 0.000 ns;
      tsetup_ENA_CLK                 :	VitalDelayType := 0.000 ns;
      thold_ENA_CLK                  :	VitalDelayType := 0.000 ns;
      tipd_D                         :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLK                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLRN                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_PRN                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_ENA                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Q                              :	out   STD_ULOGIC;
      D                              :	in    STD_ULOGIC;
      CLK                            :	in    STD_ULOGIC;
      CLRN                           :	in    STD_ULOGIC;
      PRN                            :	in    STD_ULOGIC;
      ENA                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of DFFE : entity is TRUE;
end DFFE;

-- architecture body --
architecture VITAL of DFFE is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL D_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLK_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLRN_ipd    : STD_ULOGIC := 'U';
   SIGNAL PRN_ipd    : STD_ULOGIC := 'U';
   SIGNAL ENA_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (D_ipd, D, tipd_D);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (CLRN_ipd, CLRN, tipd_CLRN);
   VitalWireDelay (PRN_ipd, PRN, tipd_PRN);
   VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, ENA_ipd)

   -- timing check results
   VARIABLE Tviol_D_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_D_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tviol_ENA_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_ENA_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(1 to 7);
   VARIABLE D_delayed : STD_ULOGIC := 'X';
   VARIABLE CLK_delayed : STD_ULOGIC := 'X';
   VARIABLE ENA_delayed : STD_ULOGIC := 'X';
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Q_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Q_GlitchData	: VitalGlitchDataType;
  CONSTANT DFFE_Q_tab : VitalStateTableType := (
    ( L,  x,  x,  x,  x,  x,  x,  x,  L ),
    ( H,  L,  H,  H,  x,  x,  H,  x,  H ),
    ( H,  L,  H,  x,  L,  x,  H,  x,  H ),
    ( H,  L,  x,  H,  H,  x,  H,  x,  H ),
    ( H,  H,  x,  x,  x,  H,  x,  x,  S ),
    ( H,  x,  x,  x,  x,  L,  x,  x,  H ),
    ( H,  x,  x,  x,  x,  H,  L,  x,  S ),
    ( x,  L,  L,  L,  x,  H,  H,  x,  L ),
    ( x,  L,  L,  x,  L,  H,  H,  x,  L ),
    ( x,  L,  x,  L,  H,  H,  H,  x,  L ));

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_D_CLK_posedge,
          TimingData              => Tmkr_D_CLK_posedge,
          TestSignal              => D_ipd,
          TestSignalName          => "D",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_D_CLK,
          SetupLow                => tsetup_D_CLK,
          HoldHigh                => thold_D_CLK,
          HoldLow                 => thold_D_CLK,
          CheckEnabled            => 
                           TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) )
                            /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/DFFE",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_ENA_CLK_posedge,
          TimingData              => Tmkr_ENA_CLK_posedge,
          TestSignal              => ENA_ipd,
          TestSignalName          => "ENA",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_ENA_CLK,
          SetupLow                => tsetup_ENA_CLK,
          HoldHigh                => thold_ENA_CLK,
          HoldLow                 => thold_ENA_CLK,
          CheckEnabled            => 
                           TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) )
                            /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/DFFE",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_D_CLK_posedge or Tviol_ENA_CLK_posedge;
      VitalStateTable(
        Result => Q_zd,
        PreviousDataIn => PrevData_Q,
        StateTable => DFFE_Q_tab,
        DataIn => (
               CLRN_ipd, CLK_delayed, Q_zd, D_delayed, ENA_delayed, PRN_ipd, CLK_ipd));
      Q_zd := Violation XOR Q_zd;
      D_delayed := D_ipd;
      CLK_delayed := CLK_ipd;
      ENA_delayed := ENA_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       GlitchData => Q_GlitchData,
       OutSignalName => "Q",
       OutTemp => Q_zd,
       Paths => (0 => (CLRN_ipd'last_event, tpd_CLRN_Q, TRUE),
                 1 => (PRN_ipd'last_event, tpd_PRN_Q, TRUE),
                 2 => (CLK_ipd'last_event, tpd_CLK_Q, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_DFFE_VITAL of DFFE is
   for VITAL
   end for;
end CFG_DFFE_VITAL;


----- CELL DFFS -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity DFFS is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_CLK_Q                      :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tsetup_D_CLK                   :	VitalDelayType := 0.200 ns;
      thold_D_CLK                    :	VitalDelayType := 0.000 ns;
      tipd_D                         :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLK                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Q                              :	out   STD_ULOGIC;
      D                              :	in    STD_ULOGIC;
      CLK                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of DFFS : entity is TRUE;
end DFFS;

-- architecture body --
architecture VITAL of DFFS is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL D_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLK_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (D_ipd, D, tipd_D);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (D_ipd, CLK_ipd)

   -- timing check results
   VARIABLE Tviol_D_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_D_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(1 to 3);
   VARIABLE D_delayed : STD_ULOGIC := 'X';
   VARIABLE CLK_delayed : STD_ULOGIC := 'X';
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Q_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Q_GlitchData	: VitalGlitchDataType;
  CONSTANT DFFS_Q_tab : VitalStateTableType := (
    ( L,  L,  H,  x,  L ),
    ( L,  H,  H,  x,  H ),
    ( H,  x,  x,  x,  S ),
    ( x,  x,  L,  x,  S ));

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_D_CLK_posedge,
          TimingData              => Tmkr_D_CLK_posedge,
          TestSignal              => D_ipd,
          TestSignalName          => "D",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_D_CLK,
          SetupLow                => tsetup_D_CLK,
          HoldHigh                => thold_D_CLK,
          HoldLow                 => thold_D_CLK,
          CheckEnabled            => 
                           TRUE,
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/DFFS",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_D_CLK_posedge;
      VitalStateTable(
        Result => Q_zd,
        PreviousDataIn => PrevData_Q,
        StateTable => DFFS_Q_tab,
        DataIn => (
               CLK_delayed, D_delayed, CLK_ipd));
      Q_zd := Violation XOR Q_zd;
      D_delayed := D_ipd;
      CLK_delayed := CLK_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       GlitchData => Q_GlitchData,
       OutSignalName => "Q",
       OutTemp => Q_zd,
       Paths => (0 => (CLK_ipd'last_event, tpd_CLK_Q, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_DFFS_VITAL of DFFS is
   for VITAL
   end for;
end CFG_DFFS_VITAL;


----- CELL FLEX_ADD -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_ADD is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_S                      :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_IN2_S                      :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_CI_S                       :	VitalDelayType01 := (1.399 ns, 1.399 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      S                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_ADD : entity is TRUE;
end FLEX_ADD;

-- architecture body --
architecture VITAL of FLEX_ADD is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS S_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE S_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      S_zd :=
       ((CI_ipd) AND ((NOT ((IN2_ipd) XOR (IN1_ipd))))) OR (((NOT CI_ipd))
         AND ((IN2_ipd) XOR (IN1_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => S,
       GlitchData => S_GlitchData,
       OutSignalName => "S",
       OutTemp => S_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_S, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_S, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_S, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_ADD_VITAL of FLEX_ADD is
   for VITAL
   end for;
end CFG_FLEX_ADD_VITAL;


----- CELL FLEX_ADD_CARRY -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_ADD_CARRY is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_S                      :	VitalDelayType01 := (1.100 ns, 1.100 ns);
      tpd_IN2_S                      :	VitalDelayType01 := (1.100 ns, 1.100 ns);
      tpd_CI_S                       :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_IN1_CO                     :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.200 ns, 0.200 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      S                              :	out   STD_ULOGIC;
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_ADD_CARRY : entity is TRUE;
end FLEX_ADD_CARRY;

-- architecture body --
architecture VITAL of FLEX_ADD_CARRY is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd	 : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd	 : STD_ULOGIC := 'U';
   SIGNAL CI_ipd	 : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 2) := (others => 'X');
   ALIAS S_zd : STD_LOGIC is Results(1);
   ALIAS CO_zd : STD_LOGIC is Results(2);

   -- output glitch detection variables
   VARIABLE S_GlitchData	: VitalGlitchDataType;
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      S_zd :=
       ((CI_ipd) AND ((NOT ((IN2_ipd) XOR (IN1_ipd))))) OR (((NOT CI_ipd))
         AND ((IN2_ipd) XOR (IN1_ipd)));
      CO_zd :=
       (((IN2_ipd) XOR (IN1_ipd)) AND (CI_ipd)) OR ((IN2_ipd) AND (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => S,
       GlitchData => S_GlitchData,
       OutSignalName => "S",
       OutTemp => S_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_S, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_S, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_S, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_ADD_CARRY_VITAL of FLEX_ADD_CARRY is
   for VITAL
   end for;
end CFG_FLEX_ADD_CARRY_VITAL;


----- CELL FLEX_BORROW -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_BORROW is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_BO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_BO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_BI_BO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_BI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      BO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      BI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_BORROW : entity is TRUE;
end FLEX_BORROW;

-- architecture body --
architecture VITAL of FLEX_BORROW is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL BI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (BI_ipd, BI, tipd_BI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, BI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS BO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE BO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      BO_zd :=
       (((IN2_ipd) XOR (BI_ipd)) AND ((NOT IN1_ipd))) OR ((IN2_ipd) AND
         (BI_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => BO,
       GlitchData => BO_GlitchData,
       OutSignalName => "BO",
       OutTemp => BO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_BO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_BO, TRUE),
                 2 => (BI_ipd'last_event, tpd_BI_BO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_BORROW_VITAL of FLEX_BORROW is
   for VITAL
   end for;
end CFG_FLEX_BORROW_VITAL;


----- CELL FLEX_CARRY -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRY is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRY : entity is TRUE;
end FLEX_CARRY;

-- architecture body --
architecture VITAL of FLEX_CARRY is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((IN2_ipd) XOR (IN1_ipd)) AND (CI_ipd)) OR ((IN2_ipd) AND (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRY_VITAL of FLEX_CARRY is
   for VITAL
   end for;
end CFG_FLEX_CARRY_VITAL;


----- CELL FLEX_CARRY_DEC -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRY_DEC is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_BO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_BI_BO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_BI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      BO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      BI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRY_DEC : entity is TRUE;
end FLEX_CARRY_DEC;

-- architecture body --
architecture VITAL of FLEX_CARRY_DEC is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL BI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (BI_ipd, BI, tipd_BI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, BI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS BO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE BO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      BO_zd := ((NOT IN1_ipd)) OR (BI_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => BO,
       GlitchData => BO_GlitchData,
       OutSignalName => "BO",
       OutTemp => BO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_BO, TRUE),
                 1 => (BI_ipd'last_event, tpd_BI_BO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRY_DEC_VITAL of FLEX_CARRY_DEC is
   for VITAL
   end for;
end CFG_FLEX_CARRY_DEC_VITAL;


----- CELL FLEX_CARRY_GT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRY_GT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRY_GT : entity is TRUE;
end FLEX_CARRY_GT;

-- architecture body --
architecture VITAL of FLEX_CARRY_GT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR (((NOT IN2_ipd))
         AND (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRY_GT_VITAL of FLEX_CARRY_GT is
   for VITAL
   end for;
end CFG_FLEX_CARRY_GT_VITAL;


----- CELL FLEX_CARRYS_GT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRYS_GT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRYS_GT : entity is TRUE;
end FLEX_CARRYS_GT;

-- architecture body --
architecture VITAL of FLEX_CARRYS_GT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR (((NOT IN2_ipd))
         AND (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRYS_GT_VITAL of FLEX_CARRYS_GT is
   for VITAL
   end for;
end CFG_FLEX_CARRYS_GT_VITAL;


----- CELL FLEX_CARRY_GTEQ -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRY_GTEQ is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRY_GTEQ : entity is TRUE;
end FLEX_CARRY_GTEQ;

-- architecture body --
architecture VITAL of FLEX_CARRY_GTEQ is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR (((NOT IN2_ipd))
         AND (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRY_GTEQ_VITAL of FLEX_CARRY_GTEQ is
   for VITAL
   end for;
end CFG_FLEX_CARRY_GTEQ_VITAL;


----- CELL FLEX_CARRYS_GTEQ -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRYS_GTEQ is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRYS_GTEQ : entity is TRUE;
end FLEX_CARRYS_GTEQ;

-- architecture body --
architecture VITAL of FLEX_CARRYS_GTEQ is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR (((NOT IN2_ipd))
         AND (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRYS_GTEQ_VITAL of FLEX_CARRYS_GTEQ is
   for VITAL
   end for;
end CFG_FLEX_CARRYS_GTEQ_VITAL;


----- CELL FLEX_CARRY_INC -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRY_INC is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRY_INC : entity is TRUE;
end FLEX_CARRY_INC;

-- architecture body --
architecture VITAL of FLEX_CARRY_INC is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd := (IN1_ipd) OR (CI_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRY_INC_VITAL of FLEX_CARRY_INC is
   for VITAL
   end for;
end CFG_FLEX_CARRY_INC_VITAL;


----- CELL FLEX_CARRY_LT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRY_LT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRY_LT : entity is TRUE;
end FLEX_CARRY_LT;

-- architecture body --
architecture VITAL of FLEX_CARRY_LT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR ((IN2_ipd) AND
         ((NOT IN1_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRY_LT_VITAL of FLEX_CARRY_LT is
   for VITAL
   end for;
end CFG_FLEX_CARRY_LT_VITAL;


----- CELL FLEX_CARRYS_LT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRYS_LT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRYS_LT : entity is TRUE;
end FLEX_CARRYS_LT;

-- architecture body --
architecture VITAL of FLEX_CARRYS_LT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR ((IN2_ipd) AND
         ((NOT IN1_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRYS_LT_VITAL of FLEX_CARRYS_LT is
   for VITAL
   end for;
end CFG_FLEX_CARRYS_LT_VITAL;


----- CELL FLEX_CARRY_LTEQ -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRY_LTEQ is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRY_LTEQ : entity is TRUE;
end FLEX_CARRY_LTEQ;

-- architecture body --
architecture VITAL of FLEX_CARRY_LTEQ is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR ((IN2_ipd) AND
         ((NOT IN1_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRY_LTEQ_VITAL of FLEX_CARRY_LTEQ is
   for VITAL
   end for;
end CFG_FLEX_CARRY_LTEQ_VITAL;


----- CELL FLEX_CARRYS_LTEQ -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_CARRYS_LTEQ is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_IN2_CO                     :	VitalDelayType01 := (0.100 ns, 0.100 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.300 ns, 0.300 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_CARRYS_LTEQ : entity is TRUE;
end FLEX_CARRYS_LTEQ;

-- architecture body --
architecture VITAL of FLEX_CARRYS_LTEQ is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS CO_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      CO_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR ((IN2_ipd) AND
         ((NOT IN1_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_CO, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_CARRYS_LTEQ_VITAL of FLEX_CARRYS_LTEQ is
   for VITAL
   end for;
end CFG_FLEX_CARRYS_LTEQ_VITAL;


----- CELL FLEX_COUNT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_COUNT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_RESET_COUNT                :	VitalDelayType01 := (3.099 ns, 3.099 ns);
      tpd_CLK_COUNT                  :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tsetup_CEN_CLK                 :	VitalDelayType := 0.800 ns;
      thold_CEN_CLK                  :	VitalDelayType := 0.000 ns;
      tsetup_CI_CLK                  :	VitalDelayType := 0.699 ns;
      thold_CI_CLK                   :	VitalDelayType := 0.000 ns;
      tsetup_DATA_CLK                :	VitalDelayType := 0.200 ns;
      thold_DATA_CLK                 :	VitalDelayType := 0.000 ns;
      tsetup_LOAD_CLK                :	VitalDelayType := 1.799 ns;
      thold_LOAD_CLK                 :	VitalDelayType := 0.000 ns;
      tipd_CEN                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_RESET                     :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLK                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DATA                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_LOAD                      :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      COUNT                          :	out   STD_ULOGIC;
      CEN                            :	in    STD_ULOGIC;
      RESET                          :	in    STD_ULOGIC;
      CLK                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC;
      DATA                           :	in    STD_ULOGIC;
      LOAD                           :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_COUNT : entity is TRUE;
end FLEX_COUNT;

-- architecture body --
architecture VITAL of FLEX_COUNT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL CEN_ipd    : STD_ULOGIC := 'U';
   SIGNAL RESET_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLK_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';
   SIGNAL DATA_ipd    : STD_ULOGIC := 'U';
   SIGNAL LOAD_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (CEN_ipd, CEN, tipd_CEN);
   VitalWireDelay (RESET_ipd, RESET, tipd_RESET);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   VitalWireDelay (DATA_ipd, DATA, tipd_DATA);
   VitalWireDelay (LOAD_ipd, LOAD, tipd_LOAD);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (CEN_ipd, RESET_ipd, CLK_ipd, CI_ipd, DATA_ipd, LOAD_ipd)

   -- timing check results
   VARIABLE Tviol_CEN_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_CEN_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tviol_CI_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_CI_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tviol_DATA_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_DATA_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tviol_LOAD_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_LOAD_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_COUNT : STD_LOGIC_VECTOR(1 to 8);
   VARIABLE CEN_delayed : STD_ULOGIC := 'X';
   VARIABLE CLK_delayed : STD_ULOGIC := 'X';
   VARIABLE CI_delayed : STD_ULOGIC := 'X';
   VARIABLE DATA_delayed : STD_ULOGIC := 'X';
   VARIABLE LOAD_delayed : STD_ULOGIC := 'X';
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS COUNT_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE COUNT_GlitchData	: VitalGlitchDataType;
  CONSTANT FLEX_COUNT_COUNT_tab : VitalStateTableType := (
    ( L,  x,  x,  x,  x,  x,  x,  x,  x,  L ),
    ( H,  L,  H,  L,  x,  H,  H,  H,  x,  H ),
    ( H,  L,  H,  H,  x,  L,  x,  H,  x,  H ),
    ( H,  L,  H,  H,  x,  x,  L,  H,  x,  H ),
    ( H,  L,  H,  x,  L,  x,  x,  H,  x,  H ),
    ( H,  L,  x,  L,  H,  H,  H,  H,  x,  H ),
    ( H,  L,  x,  H,  H,  L,  x,  H,  x,  H ),
    ( H,  L,  x,  H,  H,  x,  L,  H,  x,  H ),
    ( H,  H,  x,  x,  x,  x,  x,  x,  x,  S ),
    ( H,  x,  x,  x,  x,  x,  x,  L,  x,  S ),
    ( x,  L,  L,  L,  x,  L,  x,  H,  x,  L ),
    ( x,  L,  L,  L,  x,  x,  L,  H,  x,  L ),
    ( x,  L,  L,  H,  x,  H,  H,  H,  x,  L ),
    ( x,  L,  L,  x,  L,  x,  x,  H,  x,  L ),
    ( x,  L,  x,  L,  H,  L,  x,  H,  x,  L ),
    ( x,  L,  x,  L,  H,  x,  L,  H,  x,  L ),
    ( x,  L,  x,  H,  H,  H,  H,  H,  x,  L ));

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_CEN_CLK_posedge,
          TimingData              => Tmkr_CEN_CLK_posedge,
          TestSignal              => CEN_ipd,
          TestSignalName          => "CEN",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_CEN_CLK,
          SetupLow                => tsetup_CEN_CLK,
          HoldHigh                => thold_CEN_CLK,
          HoldLow                 => thold_CEN_CLK,
          CheckEnabled            => 
                           TO_X01((NOT RESET_ipd) ) /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/FLEX_COUNT",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_CI_CLK_posedge,
          TimingData              => Tmkr_CI_CLK_posedge,
          TestSignal              => CI_ipd,
          TestSignalName          => "CI",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_CI_CLK,
          SetupLow                => tsetup_CI_CLK,
          HoldHigh                => thold_CI_CLK,
          HoldLow                 => thold_CI_CLK,
          CheckEnabled            => 
                           TO_X01((NOT RESET_ipd) ) /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/FLEX_COUNT",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DATA_CLK_posedge,
          TimingData              => Tmkr_DATA_CLK_posedge,
          TestSignal              => DATA_ipd,
          TestSignalName          => "DATA",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DATA_CLK,
          SetupLow                => tsetup_DATA_CLK,
          HoldHigh                => thold_DATA_CLK,
          HoldLow                 => thold_DATA_CLK,
          CheckEnabled            => 
                           TO_X01((NOT RESET_ipd) ) /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/FLEX_COUNT",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_LOAD_CLK_posedge,
          TimingData              => Tmkr_LOAD_CLK_posedge,
          TestSignal              => LOAD_ipd,
          TestSignalName          => "LOAD",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_LOAD_CLK,
          SetupLow                => tsetup_LOAD_CLK,
          HoldHigh                => thold_LOAD_CLK,
          HoldLow                 => thold_LOAD_CLK,
          CheckEnabled            => 
                           TO_X01((NOT RESET_ipd) ) /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/FLEX_COUNT",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_CEN_CLK_posedge or Tviol_CI_CLK_posedge or Tviol_DATA_CLK_posedge or Tviol_LOAD_CLK_posedge;
      VitalStateTable(
        Result => COUNT_zd,
        PreviousDataIn => PrevData_COUNT,
        StateTable => FLEX_COUNT_COUNT_tab,
        DataIn => (
               RESET_ipd, CLK_delayed, DATA_delayed, COUNT_zd, LOAD_delayed, CI_delayed, CEN_delayed, CLK_ipd));
      COUNT_zd := Violation XOR COUNT_zd;
      CEN_delayed := CEN_ipd;
      CLK_delayed := CLK_ipd;
      CI_delayed := CI_ipd;
      DATA_delayed := DATA_ipd;
      LOAD_delayed := LOAD_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => COUNT,
       GlitchData => COUNT_GlitchData,
       OutSignalName => "COUNT",
       OutTemp => COUNT_zd,
       Paths => (0 => (RESET_ipd'last_event, tpd_RESET_COUNT, TRUE),
                 1 => (CLK_ipd'last_event, tpd_CLK_COUNT, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_COUNT_VITAL of FLEX_COUNT is
   for VITAL
   end for;
end CFG_FLEX_COUNT_VITAL;


----- CELL FLEX_DEC -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_DEC is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_DEC                    :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_BI_DEC                     :	VitalDelayType01 := (1.399 ns, 1.399 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_BI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      DEC                            :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      BI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_DEC : entity is TRUE;
end FLEX_DEC;

-- architecture body --
architecture VITAL of FLEX_DEC is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL BI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (BI_ipd, BI, tipd_BI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, BI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS DEC_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE DEC_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      DEC_zd := (NOT ((IN1_ipd) XOR (BI_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => DEC,
       GlitchData => DEC_GlitchData,
       OutSignalName => "DEC",
       OutTemp => DEC_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_DEC, TRUE),
                 1 => (BI_ipd'last_event, tpd_BI_DEC, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_DEC_VITAL of FLEX_DEC is
   for VITAL
   end for;
end CFG_FLEX_DEC_VITAL;


----- CELL FLEX_DEC_CARRY -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_DEC_CARRY is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_DEC                    :	VitalDelayType01 := (1.100 ns, 1.100 ns);
      tpd_BI_DEC                     :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_IN1_BO                     :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_BI_BO                      :	VitalDelayType01 := (0.200 ns, 0.200 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_BI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      DEC                            :	out   STD_ULOGIC;
      BO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      BI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_DEC_CARRY : entity is TRUE;
end FLEX_DEC_CARRY;

-- architecture body --
architecture VITAL of FLEX_DEC_CARRY is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd	 : STD_ULOGIC := 'U';
   SIGNAL BI_ipd	 : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (BI_ipd, BI, tipd_BI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, BI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 2) := (others => 'X');
   ALIAS DEC_zd : STD_LOGIC is Results(1);
   ALIAS BO_zd : STD_LOGIC is Results(2);

   -- output glitch detection variables
   VARIABLE DEC_GlitchData	: VitalGlitchDataType;
   VARIABLE BO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      DEC_zd := (NOT ((IN1_ipd) XOR (BI_ipd)));
      BO_zd := ((NOT IN1_ipd)) OR (BI_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => DEC,
       GlitchData => DEC_GlitchData,
       OutSignalName => "DEC",
       OutTemp => DEC_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_DEC, TRUE),
                 1 => (BI_ipd'last_event, tpd_BI_DEC, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);
      VitalPathDelay01 (
       OutSignal => BO,
       GlitchData => BO_GlitchData,
       OutSignalName => "BO",
       OutTemp => BO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_BO, TRUE),
                 1 => (BI_ipd'last_event, tpd_BI_BO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_DEC_CARRY_VITAL of FLEX_DEC_CARRY is
   for VITAL
   end for;
end CFG_FLEX_DEC_CARRY_VITAL;


----- CELL FLEX_GT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_GT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_GT                     :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_IN2_GT                     :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_CI_GT                      :	VitalDelayType01 := (1.399 ns, 1.399 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      GT                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_GT : entity is TRUE;
end FLEX_GT;

-- architecture body --
architecture VITAL of FLEX_GT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS GT_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE GT_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      GT_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR (((NOT IN2_ipd))
         AND (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => GT,
       GlitchData => GT_GlitchData,
       OutSignalName => "GT",
       OutTemp => GT_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_GT, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_GT, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_GT, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_GT_VITAL of FLEX_GT is
   for VITAL
   end for;
end CFG_FLEX_GT_VITAL;


----- CELL FLEX_GTEQ -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_GTEQ is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_GTEQ                   :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_IN2_GTEQ                   :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_CI_GTEQ                    :	VitalDelayType01 := (1.399 ns, 1.399 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      GTEQ                           :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_GTEQ : entity is TRUE;
end FLEX_GTEQ;

-- architecture body --
architecture VITAL of FLEX_GTEQ is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS GTEQ_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE GTEQ_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      GTEQ_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR (((NOT IN2_ipd))
         AND (IN1_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => GTEQ,
       GlitchData => GTEQ_GlitchData,
       OutSignalName => "GTEQ",
       OutTemp => GTEQ_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_GTEQ, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_GTEQ, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_GTEQ, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_GTEQ_VITAL of FLEX_GTEQ is
   for VITAL
   end for;
end CFG_FLEX_GTEQ_VITAL;


----- CELL FLEX_INC -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_INC is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_INC                    :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_CI_INC                     :	VitalDelayType01 := (1.399 ns, 1.399 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      INC                            :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_INC : entity is TRUE;
end FLEX_INC;

-- architecture body --
architecture VITAL of FLEX_INC is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS INC_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE INC_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      INC_zd := (NOT ((IN1_ipd) XOR (CI_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => INC,
       GlitchData => INC_GlitchData,
       OutSignalName => "INC",
       OutTemp => INC_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_INC, TRUE),
                 1 => (CI_ipd'last_event, tpd_CI_INC, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_INC_VITAL of FLEX_INC is
   for VITAL
   end for;
end CFG_FLEX_INC_VITAL;



----- CELL FLEX_INC_CARRY -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_INC_CARRY is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_INC                    :	VitalDelayType01 := (1.100 ns, 1.100 ns);
      tpd_CI_INC                     :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_IN1_CO                     :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_CI_CO                      :	VitalDelayType01 := (0.200 ns, 0.200 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      INC                            :	out   STD_ULOGIC;
      CO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_INC_CARRY : entity is TRUE;
end FLEX_INC_CARRY;

-- architecture body --
architecture VITAL of FLEX_INC_CARRY is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd	 : STD_ULOGIC := 'U';
   SIGNAL CI_ipd	 : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 2) := (others => 'X');
   ALIAS INC_zd : STD_LOGIC is Results(1);
   ALIAS CO_zd : STD_LOGIC is Results(2);

   -- output glitch detection variables
   VARIABLE INC_GlitchData	: VitalGlitchDataType;
   VARIABLE CO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      INC_zd := (NOT ((IN1_ipd) XOR (CI_ipd)));
      CO_zd := (IN1_ipd) OR (CI_ipd);

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => INC,
       GlitchData => INC_GlitchData,
       OutSignalName => "INC",
       OutTemp => INC_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_INC, TRUE),
                 1 => (CI_ipd'last_event, tpd_CI_INC, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);
      VitalPathDelay01 (
       OutSignal => CO,
       GlitchData => CO_GlitchData,
       OutSignalName => "CO",
       OutTemp => CO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_CO, TRUE),
                 1 => (CI_ipd'last_event, tpd_CI_CO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_INC_CARRY_VITAL of FLEX_INC_CARRY is
   for VITAL
   end for;
end CFG_FLEX_INC_CARRY_VITAL;



----- CELL FLEX_LT -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_LT is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_LT                     :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_IN2_LT                     :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_CI_LT                      :	VitalDelayType01 := (1.399 ns, 1.399 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      LT                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_LT : entity is TRUE;
end FLEX_LT;

-- architecture body --
architecture VITAL of FLEX_LT is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS LT_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE LT_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      LT_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR ((IN2_ipd) AND
         ((NOT IN1_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => LT,
       GlitchData => LT_GlitchData,
       OutSignalName => "LT",
       OutTemp => LT_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_LT, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_LT, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_LT, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_LT_VITAL of FLEX_LT is
   for VITAL
   end for;
end CFG_FLEX_LT_VITAL;


----- CELL FLEX_LTEQ -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_LTEQ is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_LTEQ                   :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_IN2_LTEQ                   :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_CI_LTEQ                    :	VitalDelayType01 := (1.399 ns, 1.399 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      LTEQ                           :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      CI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_LTEQ : entity is TRUE;
end FLEX_LTEQ;

-- architecture body --
architecture VITAL of FLEX_LTEQ is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL CI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (CI_ipd, CI, tipd_CI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, CI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS LTEQ_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE LTEQ_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      LTEQ_zd :=
       (((NOT ((IN2_ipd) XOR (IN1_ipd)))) AND (CI_ipd)) OR ((IN2_ipd) AND
         ((NOT IN1_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => LTEQ,
       GlitchData => LTEQ_GlitchData,
       OutSignalName => "LTEQ",
       OutTemp => LTEQ_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_LTEQ, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_LTEQ, TRUE),
                 2 => (CI_ipd'last_event, tpd_CI_LTEQ, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_LTEQ_VITAL of FLEX_LTEQ is
   for VITAL
   end for;
end CFG_FLEX_LTEQ_VITAL;


----- CELL FLEX_SUB -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity FLEX_SUB is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_D                      :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_IN2_D                      :	VitalDelayType01 := (2.299 ns, 2.299 ns);
      tpd_BI_D                       :	VitalDelayType01 := (1.399 ns, 1.399 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_BI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      D                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      BI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_SUB : entity is TRUE;
end FLEX_SUB;

-- architecture body --
architecture VITAL of FLEX_SUB is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd    : STD_ULOGIC := 'U';
   SIGNAL BI_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (BI_ipd, BI, tipd_BI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, BI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS D_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE D_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      D_zd :=
       ((BI_ipd) AND ((NOT ((IN2_ipd) XOR (IN1_ipd))))) OR (((NOT BI_ipd))
         AND ((IN2_ipd) XOR (IN1_ipd)));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => D,
       GlitchData => D_GlitchData,
       OutSignalName => "D",
       OutTemp => D_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_D, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_D, TRUE),
                 2 => (BI_ipd'last_event, tpd_BI_D, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_SUB_VITAL of FLEX_SUB is
   for VITAL
   end for;
end CFG_FLEX_SUB_VITAL;


----- CELL FLEX_SUB_BORROW -----


-- entity declaration --
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


entity FLEX_SUB_BORROW is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_D                      :	VitalDelayType01 := (1.100 ns, 1.100 ns);
      tpd_IN2_D                      :	VitalDelayType01 := (1.100 ns, 1.100 ns);
      tpd_BI_D                       :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_IN1_BO                     :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_IN2_BO                     :	VitalDelayType01 := (0.800 ns, 0.800 ns);
      tpd_BI_BO                      :	VitalDelayType01 := (0.200 ns, 0.200 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_IN2                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_BI                        :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      D                              :	out   STD_ULOGIC;
      BO                             :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC;
      IN2                            :	in    STD_ULOGIC;
      BI                             :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of FLEX_SUB_BORROW : entity is TRUE;
end FLEX_SUB_BORROW;

-- architecture body --
architecture VITAL of FLEX_SUB_BORROW is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd	 : STD_ULOGIC := 'U';
   SIGNAL IN2_ipd	 : STD_ULOGIC := 'U';
   SIGNAL BI_ipd	 : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (IN1_ipd, IN1, tipd_IN1);
   VitalWireDelay (IN2_ipd, IN2, tipd_IN2);
   VitalWireDelay (BI_ipd, BI, tipd_BI);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (IN1_ipd, IN2_ipd, BI_ipd)


   -- functionality results
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 2) := (others => 'X');
   ALIAS D_zd : STD_LOGIC is Results(1);
   ALIAS BO_zd : STD_LOGIC is Results(2);

   -- output glitch detection variables
   VARIABLE D_GlitchData	: VitalGlitchDataType;
   VARIABLE BO_GlitchData	: VitalGlitchDataType;

   begin

      -------------------------
      --  Functionality Section
      -------------------------
      D_zd :=
       ((BI_ipd) AND ((NOT ((IN2_ipd) XOR (IN1_ipd))))) OR (((NOT BI_ipd))
         AND ((IN2_ipd) XOR (IN1_ipd)));
      BO_zd :=
       (((IN2_ipd) XOR (BI_ipd)) AND ((NOT IN1_ipd))) OR ((IN2_ipd) AND
         (BI_ipd));

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => D,
       GlitchData => D_GlitchData,
       OutSignalName => "D",
       OutTemp => D_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_D, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_D, TRUE),
                 2 => (BI_ipd'last_event, tpd_BI_D, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);
      VitalPathDelay01 (
       OutSignal => BO,
       GlitchData => BO_GlitchData,
       OutSignalName => "BO",
       OutTemp => BO_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_BO, TRUE),
                 1 => (IN2_ipd'last_event, tpd_IN2_BO, TRUE),
                 2 => (BI_ipd'last_event, tpd_BI_BO, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_FLEX_SUB_BORROW_VITAL of FLEX_SUB_BORROW is
   for VITAL
   end for;
end CFG_FLEX_SUB_BORROW_VITAL;


----- CELL LATCH -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity LATCH is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_D_Q                        :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tpd_ENA_Q                      :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tsetup_D_ENA                   :	VitalDelayType := 0.200 ns;
      thold_D_ENA                    :	VitalDelayType := 0.000 ns;
      tipd_D                         :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_ENA                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Q                              :	out   STD_ULOGIC;
      D                              :	in    STD_ULOGIC;
      ENA                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of LATCH : entity is TRUE;
end LATCH;

-- architecture body --
architecture VITAL of LATCH is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL D_ipd    : STD_ULOGIC := 'U';
   SIGNAL ENA_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (D_ipd, D, tipd_D);
   VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (D_ipd, ENA_ipd)

   -- timing check results
   VARIABLE Tviol_D_ENA_negedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_D_ENA_negedge	: VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(1 to 2);
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Q_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Q_GlitchData	: VitalGlitchDataType;
   CONSTANT LATCH_Q_tab : VitalStateTableType := (
    ( L,  H,  x,  L ),
    ( H,  H,  x,  H ),
    ( x,  L,  x,  S ));

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_D_ENA_negedge,
          TimingData              => Tmkr_D_ENA_negedge,
          TestSignal              => D_ipd,
          TestSignalName          => "D",
          TestDelay               => 0 ns,
          RefSignal               => ENA_ipd,
          RefSignalName          => "ENA",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_D_ENA,
          SetupLow                => tsetup_D_ENA,
          HoldHigh                => thold_D_ENA,
          HoldLow                 => thold_D_ENA,
          CheckEnabled            => 
                           TRUE,
          RefTransition           => 'F',
          HeaderMsg               => InstancePath & "/LATCH",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_D_ENA_negedge;
      VitalStateTable(
        Result => Q_zd,
        PreviousDataIn => PrevData_Q,
        StateTable => LATCH_Q_tab,
        DataIn => (
               D_ipd, ENA_ipd));
      Q_zd := Violation XOR Q_zd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       GlitchData => Q_GlitchData,
       OutSignalName => "Q",
       OutTemp => Q_zd,
       Paths => (0 => (D_ipd'last_event, tpd_D_Q, TRUE),
                 1 => (ENA_ipd'last_event, tpd_ENA_Q, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_LATCH_VITAL of LATCH is
   for VITAL
   end for;
end CFG_LATCH_VITAL;


----- CELL OPNDRN -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity OPNDRN is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_IN1_Y                      :	VitalDelayType01 := (4.400 ns, 4.400 ns);
      tipd_IN1                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Y                              :	out   STD_ULOGIC;
      IN1                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of OPNDRN : entity is TRUE;
end OPNDRN;

-- architecture body --
architecture VITAL of OPNDRN is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL IN1_ipd    : STD_ULOGIC := 'U';

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
   ALIAS Y_zd : STD_LOGIC is Results(1);

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
       GlitchData => Y_GlitchData,
       OutSignalName => "Y",
       OutTemp => Y_zd,
       Paths => (0 => (IN1_ipd'last_event, tpd_IN1_Y, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_OPNDRN_VITAL of OPNDRN is
   for VITAL
   end for;
end CFG_OPNDRN_VITAL;


----- CELL TFF -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity TFF is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_CLRN_Q                     :	VitalDelayType01 := (3.099 ns, 3.099 ns);
      tpd_PRN_Q                      :	VitalDelayType01 := (3.000 ns, 3.000 ns);
      tpd_CLK_Q                      :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tsetup_T_CLK                   :	VitalDelayType := 0.200 ns;
      thold_T_CLK                    :	VitalDelayType := 0.000 ns;
      tipd_T                         :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLK                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLRN                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_PRN                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Q                              :	out   STD_ULOGIC;
      T                              :	in    STD_ULOGIC;
      CLK                            :	in    STD_ULOGIC;
      CLRN                           :	in    STD_ULOGIC;
      PRN                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of TFF : entity is TRUE;
end TFF;

-- architecture body --
architecture VITAL of TFF is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL T_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLK_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLRN_ipd    : STD_ULOGIC := 'U';
   SIGNAL PRN_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (T_ipd, T, tipd_T);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (CLRN_ipd, CLRN, tipd_CLRN);
   VitalWireDelay (PRN_ipd, PRN, tipd_PRN);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (T_ipd, CLK_ipd, CLRN_ipd, PRN_ipd)

   -- timing check results
   VARIABLE Tviol_T_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_T_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(1 to 6);
   VARIABLE T_delayed : STD_ULOGIC := 'X';
   VARIABLE CLK_delayed : STD_ULOGIC := 'X';
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Q_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Q_GlitchData	: VitalGlitchDataType;
  CONSTANT TFF_Q_tab : VitalStateTableType := (
    ( L,  x,  x,  x,  x,  x,  x,  L ),
    ( H,  L,  L,  H,  x,  H,  x,  H ),
    ( H,  L,  H,  L,  x,  H,  x,  H ),
    ( H,  H,  x,  x,  H,  x,  x,  S ),
    ( H,  x,  x,  x,  L,  x,  x,  H ),
    ( H,  x,  x,  x,  H,  L,  x,  S ),
    ( x,  L,  L,  L,  H,  H,  x,  L ),
    ( x,  L,  H,  H,  H,  H,  x,  L ));

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_T_CLK_posedge,
          TimingData              => Tmkr_T_CLK_posedge,
          TestSignal              => T_ipd,
          TestSignalName          => "T",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_T_CLK,
          SetupLow                => tsetup_T_CLK,
          HoldHigh                => thold_T_CLK,
          HoldLow                 => thold_T_CLK,
          CheckEnabled            => 
                           TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) )
                            /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/TFF",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_T_CLK_posedge;
      VitalStateTable(
        Result => Q_zd,
        PreviousDataIn => PrevData_Q,
        StateTable => TFF_Q_tab,
        DataIn => (
               CLRN_ipd, CLK_delayed, T_delayed, Q_zd, PRN_ipd, CLK_ipd));
      Q_zd := Violation XOR Q_zd;
      T_delayed := T_ipd;
      CLK_delayed := CLK_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       GlitchData => Q_GlitchData,
       OutSignalName => "Q",
       OutTemp => Q_zd,
       Paths => (0 => (CLRN_ipd'last_event, tpd_CLRN_Q, TRUE),
                 1 => (PRN_ipd'last_event, tpd_PRN_Q, TRUE),
                 2 => (CLK_ipd'last_event, tpd_CLK_Q, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_TFF_VITAL of TFF is
   for VITAL
   end for;
end CFG_TFF_VITAL;


----- CELL TFFE -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity TFFE is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_CLRN_Q                     :	VitalDelayType01 := (3.099 ns, 3.099 ns);
      tpd_PRN_Q                      :	VitalDelayType01 := (3.000 ns, 3.000 ns);
      tpd_CLK_Q                      :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tsetup_T_CLK                   :	VitalDelayType := 0.200 ns;
      thold_T_CLK                    :	VitalDelayType := 0.000 ns;
      tsetup_ENA_CLK                 :	VitalDelayType := 0.000 ns;
      thold_ENA_CLK                  :	VitalDelayType := 0.000 ns;
      tipd_T                         :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLK                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLRN                      :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_PRN                       :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_ENA                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Q                              :	out   STD_ULOGIC;
      T                              :	in    STD_ULOGIC;
      CLK                            :	in    STD_ULOGIC;
      CLRN                           :	in    STD_ULOGIC;
      PRN                            :	in    STD_ULOGIC;
      ENA                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of TFFE : entity is TRUE;
end TFFE;

-- architecture body --
architecture VITAL of TFFE is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL T_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLK_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLRN_ipd    : STD_ULOGIC := 'U';
   SIGNAL PRN_ipd    : STD_ULOGIC := 'U';
   SIGNAL ENA_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (T_ipd, T, tipd_T);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   VitalWireDelay (CLRN_ipd, CLRN, tipd_CLRN);
   VitalWireDelay (PRN_ipd, PRN, tipd_PRN);
   VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (T_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, ENA_ipd)

   -- timing check results
   VARIABLE Tviol_T_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_T_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tviol_ENA_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_ENA_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(1 to 7);
   VARIABLE T_delayed : STD_ULOGIC := 'X';
   VARIABLE CLK_delayed : STD_ULOGIC := 'X';
   VARIABLE ENA_delayed : STD_ULOGIC := 'X';
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Q_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Q_GlitchData	: VitalGlitchDataType;
  CONSTANT TFFE_Q_tab : VitalStateTableType := (
    ( L,  x,  x,  x,  x,  x,  x,  x,  L ),
    ( H,  L,  L,  H,  H,  x,  H,  x,  H ),
    ( H,  L,  H,  L,  x,  x,  H,  x,  H ),
    ( H,  L,  H,  x,  L,  x,  H,  x,  H ),
    ( H,  H,  x,  x,  x,  H,  x,  x,  S ),
    ( H,  x,  x,  x,  x,  L,  x,  x,  H ),
    ( H,  x,  x,  x,  x,  H,  L,  x,  S ),
    ( x,  L,  L,  L,  x,  H,  H,  x,  L ),
    ( x,  L,  L,  x,  L,  H,  H,  x,  L ),
    ( x,  L,  H,  H,  H,  H,  H,  x,  L ));

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_T_CLK_posedge,
          TimingData              => Tmkr_T_CLK_posedge,
          TestSignal              => T_ipd,
          TestSignalName          => "T",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_T_CLK,
          SetupLow                => tsetup_T_CLK,
          HoldHigh                => thold_T_CLK,
          HoldLow                 => thold_T_CLK,
          CheckEnabled            => 
                           TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) )
                            /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/TFFE",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_ENA_CLK_posedge,
          TimingData              => Tmkr_ENA_CLK_posedge,
          TestSignal              => ENA_ipd,
          TestSignalName          => "ENA",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_ENA_CLK,
          SetupLow                => tsetup_ENA_CLK,
          HoldHigh                => thold_ENA_CLK,
          HoldLow                 => thold_ENA_CLK,
          CheckEnabled            => 
                           TO_X01(( (NOT PRN_ipd) ) OR ( (NOT CLRN_ipd) ) )
                            /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/TFFE",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_T_CLK_posedge or Tviol_ENA_CLK_posedge;
      VitalStateTable(
        Result => Q_zd,
        PreviousDataIn => PrevData_Q,
        StateTable => TFFE_Q_tab,
        DataIn => (
               CLRN_ipd, CLK_delayed, Q_zd, T_delayed, ENA_delayed, PRN_ipd, CLK_ipd));
      Q_zd := Violation XOR Q_zd;
      T_delayed := T_ipd;
      CLK_delayed := CLK_ipd;
      ENA_delayed := ENA_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       GlitchData => Q_GlitchData,
       OutSignalName => "Q",
       OutTemp => Q_zd,
       Paths => (0 => (CLRN_ipd'last_event, tpd_CLRN_Q, TRUE),
                 1 => (PRN_ipd'last_event, tpd_PRN_Q, TRUE),
                 2 => (CLK_ipd'last_event, tpd_CLK_Q, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_TFFE_VITAL of TFFE is
   for VITAL
   end for;
end CFG_TFFE_VITAL;


----- CELL TFFS -----
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library IEEE;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
library flex_vtl;
use flex_vtl.SUPPORT.all;


-- entity declaration --
entity TFFS is
   generic(
      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := False;
      MsgOn: Boolean := True;
      tpd_CLK_Q                      :	VitalDelayType01 := (0.899 ns, 0.899 ns);
      tsetup_T_CLK                   :	VitalDelayType := 0.200 ns;
      thold_T_CLK                    :	VitalDelayType := 0.000 ns;
      tipd_T                         :	VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CLK                       :	VitalDelayType01 := (0.000 ns, 0.000 ns));

   port(
      Q                              :	out   STD_ULOGIC;
      T                              :	in    STD_ULOGIC;
      CLK                            :	in    STD_ULOGIC);
attribute VITAL_LEVEL0 of TFFS : entity is TRUE;
end TFFS;

-- architecture body --
architecture VITAL of TFFS is
   attribute VITAL_LEVEL1 of VITAL : architecture is TRUE;

   SIGNAL T_ipd    : STD_ULOGIC := 'U';
   SIGNAL CLK_ipd    : STD_ULOGIC := 'U';

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (T_ipd, T, tipd_T);
   VitalWireDelay (CLK_ipd, CLK, tipd_CLK);
   end block;
   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (T_ipd, CLK_ipd)

   -- timing check results
   VARIABLE Tviol_T_CLK_posedge	: STD_ULOGIC := '0';
   VARIABLE Tmkr_T_CLK_posedge	: VitalTimingDataType := VitalTimingDataInit;

   -- functionality results
   VARIABLE Violation : STD_ULOGIC := '0';
   VARIABLE PrevData_Q : STD_LOGIC_VECTOR(1 to 4);
   VARIABLE T_delayed : STD_ULOGIC := 'X';
   VARIABLE CLK_delayed : STD_ULOGIC := 'X';
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   ALIAS Q_zd : STD_LOGIC is Results(1);

   -- output glitch detection variables
   VARIABLE Q_GlitchData	: VitalGlitchDataType;
  CONSTANT TFFS_Q_tab : VitalStateTableType := (
    ( L,  L,  L,  H,  x,  L ),
    ( L,  L,  H,  H,  x,  H ),
    ( L,  H,  L,  H,  x,  H ),
    ( L,  H,  H,  H,  x,  L ),
    ( x,  x,  x,  L,  x,  S ));

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_T_CLK_posedge,
          TimingData              => Tmkr_T_CLK_posedge,
          TestSignal              => T_ipd,
          TestSignalName          => "T",
          TestDelay               => 0 ns,
          RefSignal               => CLK_ipd,
          RefSignalName          => "CLK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_T_CLK,
          SetupLow                => tsetup_T_CLK,
          HoldHigh                => thold_T_CLK,
          HoldLow                 => thold_T_CLK,
          CheckEnabled            => 
                           TRUE,
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/TFFS",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
      end if;

      -------------------------
      --  Functionality Section
      -------------------------
      Violation := Tviol_T_CLK_posedge;
      VitalStateTable(
        Result => Q_zd,
        PreviousDataIn => PrevData_Q,
        StateTable => TFFS_Q_tab,
        DataIn => (
               CLK_delayed, T_delayed, Q_zd, CLK_ipd));
      Q_zd := Violation XOR Q_zd;
      T_delayed := T_ipd;
      CLK_delayed := CLK_ipd;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       GlitchData => Q_GlitchData,
       OutSignalName => "Q",
       OutTemp => Q_zd,
       Paths => (0 => (CLK_ipd'last_event, tpd_CLK_Q, TRUE)),
       Mode => OnDetect,
       Xon => Xon,
       MsgOn => MsgOn,
       MsgSeverity => WARNING);

end process;

end VITAL;

configuration CFG_TFFS_VITAL of TFFS is
   for VITAL
   end for;
end CFG_TFFS_VITAL;


---- end of library ----
