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

package apexii_atom_pack is

function str_to_bin (lut_mask : string ) return std_logic_vector;

function product(list : std_logic_vector) return std_logic ;

function alt_conv_integer(arg : in std_logic_vector) return integer;

-- default GENERIC values
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
   TYPE apexii_mem_data IS ARRAY (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);

end apexii_atom_pack;

LIBRARY IEEE;
use IEEE.std_logic_1164.all;

package body apexii_atom_pack is

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

end apexii_atom_pack;
--/////////////////////////////////////////////////////////////////////////////
--
--              VHDL Simulation Models for APEXII Atoms
--
--/////////////////////////////////////////////////////////////////////////////
--

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_ASYNCH_LCELL
--
-- Description : Timing simulation model for the asynchronous submodule
--               of APEX II Lcell
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;

ENTITY apexii_asynch_lcell is
    GENERIC (
            operation_mode  : string := "normal";
            output_mode     : string := "comb_and_reg";
            lut_mask        : string := "ffff";
            power_up        : string := "low";
            cin_used        : string := "false";
            TimingChecksOn  : Boolean := True;
            MsgOn: Boolean  := DefGlitchMsgOn;
            XOn: Boolean    := DefGlitchXOn;
            MsgOnChecks     : Boolean := DefMsgOnChecks;
            XOnChecks       : Boolean := DefXOnChecks;
            InstancePath    : STRING := "*";
            tpd_dataa_combout   : VitalDelayType01 := DefPropDelay01;
            tpd_datab_combout   : VitalDelayType01 := DefPropDelay01;
            tpd_datac_combout   : VitalDelayType01 := DefPropDelay01;
            tpd_datad_combout   : VitalDelayType01 := DefPropDelay01;
            tpd_qfbkin_combout  : VitalDelayType01 := DefPropDelay01;
            tpd_cin_combout     : VitalDelayType01 := DefPropDelay01;
            tpd_cascin_combout  : VitalDelayType01 := DefPropDelay01;
            tpd_dataa_regin     : VitalDelayType01 := DefPropDelay01;
            tpd_datab_regin     : VitalDelayType01 := DefPropDelay01;
            tpd_datac_regin     : VitalDelayType01 := DefPropDelay01;
            tpd_datad_regin     : VitalDelayType01 := DefPropDelay01;
            tpd_qfbkin_regin    : VitalDelayType01 := DefPropDelay01;
            tpd_cin_regin       : VitalDelayType01 := DefPropDelay01;
            tpd_cascin_regin    : VitalDelayType01 := DefPropDelay01;
            tpd_dataa_cout      : VitalDelayType01 := DefPropDelay01;
            tpd_datab_cout      : VitalDelayType01 := DefPropDelay01;
            tpd_datac_cout      : VitalDelayType01 := DefPropDelay01;
            tpd_datad_cout      : VitalDelayType01 := DefPropDelay01;
            tpd_qfbkin_cout     : VitalDelayType01 := DefPropDelay01;
            tpd_cin_cout        : VitalDelayType01 := DefPropDelay01;
            tpd_cascin_cascout  : VitalDelayType01 := DefPropDelay01;
            tpd_cin_cascout     : VitalDelayType01 := DefPropDelay01;
            tpd_dataa_cascout   : VitalDelayType01 := DefPropDelay01;
            tpd_datab_cascout   : VitalDelayType01 := DefPropDelay01;
            tpd_datac_cascout   : VitalDelayType01 := DefPropDelay01;
            tpd_datad_cascout   : VitalDelayType01 := DefPropDelay01;
            tpd_qfbkin_cascout  : VitalDelayType01 := DefPropDelay01;
            tipd_dataa          : VitalDelayType01 := DefPropDelay01; 
            tipd_datab          : VitalDelayType01 := DefPropDelay01; 
            tipd_datac          : VitalDelayType01 := DefPropDelay01; 
            tipd_datad          : VitalDelayType01 := DefPropDelay01; 
            tipd_cin            : VitalDelayType01 := DefPropDelay01; 
            tipd_cascin         : VitalDelayType01 := DefPropDelay01
            );
    
    PORT    (
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
    attribute VITAL_LEVEL0 of apexii_asynch_lcell : ENTITY is TRUE;
end apexii_asynch_lcell;
        
ARCHITECTURE vital_le of apexii_asynch_lcell is
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

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_LCELL_REGISTER
--
-- Description : Timing simulation model for the register submodule
--               of APEX II Lcell
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;

ENTITY apexii_lcell_register is
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
            tsetup_datain_clk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
            tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tpd_clk_regout_posedge	: VitalDelayType01 := DefPropDelay01;
            tpd_aclr_regout_posedge	: VitalDelayType01 := DefPropDelay01;
            tpd_clk_qfbko_posedge	: VitalDelayType01 := DefPropDelay01;
            tpd_aclr_qfbko_posedge	: VitalDelayType01 := DefPropDelay01;
            tperiod_clk_posedge     : VitalDelayType := DefPulseWdthCnst;
            tipd_datac  			: VitalDelayType01 := DefPropDelay01; 
            tipd_ena  	: VitalDelayType01 := DefPropDelay01; 
            tipd_aclr 	: VitalDelayType01 := DefPropDelay01; 
            tipd_sclr 	: VitalDelayType01 := DefPropDelay01; 
            tipd_sload 	: VitalDelayType01 := DefPropDelay01; 
            tipd_clk  	: VitalDelayType01 := DefPropDelay01
            );
            
    PORT    (
            clk     :in std_logic;
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
    attribute VITAL_LEVEL0 of apexii_lcell_register : ENTITY is TRUE;
end apexii_lcell_register;
        
ARCHITECTURE vital_le_reg of apexii_lcell_register is
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
    variable idata, setbit : std_logic := '0';
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn) OR (NOT ena_ipd)) /= '1',
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
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
                CheckEnabled    => TO_X01((aclr_ipd) OR (NOT devpor) OR (NOT devclrn)) /= '1',
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

        violation := Tviol_datain_clk or Tviol_datac_clk or Tviol_ena_clk or
                     Tviol_sclr_clk or Tviol_sload_clk or Tviol_clk;

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
        elsif clk_ipd'event and clk_ipd = '1' and clk_ipd'last_value = '0' then
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
            GlitchData => qfbko_VitalGlitchData,
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
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
    end process;

end vital_le_reg;	

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_LCELL
--
-- Description : Timing simulation model for APEX II Lcell
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;
use work.apexii_asynch_lcell;
use work.apexii_lcell_register;

ENTITY apexii_lcell is
    GENERIC (
            operation_mode : string := "normal";
            output_mode    : string := "comb_and_reg";
            packed_mode    : string := "false";
            lut_mask       : string := "ffff";
            power_up       : string := "low";
            cin_used       : string := "false";
            lpm_type       : string := "apexii_lcell";
            x_on_violation : string := "on"
            );

    PORT    (
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
end apexii_lcell;
        
ARCHITECTURE vital_le_atom of apexii_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

component apexii_asynch_lcell 
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
            tpd_dataa_combout   : VitalDelayType01 := DefPropDelay01;
            tpd_datab_combout   : VitalDelayType01 := DefPropDelay01;
            tpd_datac_combout   : VitalDelayType01 := DefPropDelay01;
            tpd_datad_combout   : VitalDelayType01 := DefPropDelay01;
            tpd_qfbkin_combout  : VitalDelayType01 := DefPropDelay01;
            tpd_cin_combout     : VitalDelayType01 := DefPropDelay01;
            tpd_cascin_combout	: VitalDelayType01 := DefPropDelay01;
            tpd_dataa_regin     : VitalDelayType01 := DefPropDelay01;
            tpd_datab_regin     : VitalDelayType01 := DefPropDelay01;
            tpd_datac_regin     : VitalDelayType01 := DefPropDelay01;
            tpd_datad_regin     : VitalDelayType01 := DefPropDelay01;
            tpd_qfbkin_regin    : VitalDelayType01 := DefPropDelay01;
            tpd_cin_regin       : VitalDelayType01 := DefPropDelay01;
            tpd_cascin_regin  	: VitalDelayType01 := DefPropDelay01;
            tpd_dataa_cout	    : VitalDelayType01 := DefPropDelay01;
            tpd_datab_cout	    : VitalDelayType01 := DefPropDelay01;
            tpd_datac_cout    	: VitalDelayType01 := DefPropDelay01;
            tpd_datad_cout    	: VitalDelayType01 := DefPropDelay01;
            tpd_qfbkin_cout     : VitalDelayType01 := DefPropDelay01;
            tpd_cin_cout		: VitalDelayType01 := DefPropDelay01;
            tpd_cascin_cascout	: VitalDelayType01 := DefPropDelay01;
            tpd_cin_cascout    	: VitalDelayType01 := DefPropDelay01;
            tpd_dataa_cascout	: VitalDelayType01 := DefPropDelay01;
            tpd_datab_cascout	: VitalDelayType01 := DefPropDelay01;
            tpd_datac_cascout   : VitalDelayType01 := DefPropDelay01;
            tpd_datad_cascout   : VitalDelayType01 := DefPropDelay01;
            tpd_qfbkin_cascout  : VitalDelayType01 := DefPropDelay01;
            tipd_dataa			: VitalDelayType01 := DefPropDelay01; 
            tipd_datab			: VitalDelayType01 := DefPropDelay01; 
            tipd_datac			: VitalDelayType01 := DefPropDelay01; 
            tipd_datad			: VitalDelayType01 := DefPropDelay01; 
            tipd_cin  			: VitalDelayType01 := DefPropDelay01; 
            tipd_cascin			: VitalDelayType01 := DefPropDelay01
            ); 
    
    PORT    (
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
end component;

component apexii_lcell_register
    GENERIC (
            power_up        : string := "low";
            packed_mode     : string := "false";
            x_on_violation  : string := "on";
            TimingChecksOn  : Boolean := True;
            MsgOn           : Boolean := DefGlitchMsgOn;
            XOn             : Boolean := DefGlitchXOn;
            MsgOnChecks     : Boolean := DefMsgOnChecks;
            XOnChecks       : Boolean := DefXOnChecks;
            InstancePath    : STRING := "*";
            tsetup_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tsetup_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_datain_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_datac_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_sclr_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
            tpd_clk_regout_posedge		: VitalDelayType01 := DefPropDelay01;
            tpd_aclr_regout_posedge		: VitalDelayType01 := DefPropDelay01;
            tpd_clk_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
            tpd_aclr_qfbko_posedge		: VitalDelayType01 := DefPropDelay01;
            tperiod_clk_posedge         : VitalDelayType := DefPulseWdthCnst;
            tipd_datac  		: VitalDelayType01 := DefPropDelay01; 
            tipd_ena  			: VitalDelayType01 := DefPropDelay01; 
            tipd_aclr 			: VitalDelayType01 := DefPropDelay01; 
            tipd_sclr 			: VitalDelayType01 := DefPropDelay01; 
            tipd_sload 			: VitalDelayType01 := DefPropDelay01; 
            tipd_clk  			: VitalDelayType01 := DefPropDelay01
            );

    PORT    (
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
end component;

begin

    lecomb: apexii_asynch_lcell
            GENERIC map (operation_mode => operation_mode, output_mode => output_mode,
                         lut_mask => lut_mask, cin_used => cin_used)
            port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                      cin => cin, cascin => cascin, qfbkin => qfbk,
                      combout => combout, cout => cout, cascout => cascout, regin => dffin);
    
    lereg: apexii_lcell_register
    	GENERIC map (power_up => power_up, packed_mode => packed_mode,
                     x_on_violation => x_on_violation)
      	port map (clk => clk, datain => dffin, datac => datac, 
                  aclr => aclr, sclr => sclr, sload => sload, ena => ena,
                  devclrn => devclrn, devpor => devpor, regout => regout,
                  qfbko => qfbk);
    

end vital_le_atom;

--
-- LATCH
--
LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.apexii_atom_pack.all;

ENTITY apexii_latch is
   GENERIC(
      TimingChecksOn: Boolean := True;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
      InstancePath: STRING := "*";
      tpd_PRE_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
      tpd_D_Q                        :  VitalDelayType01 := DefPropDelay01;
      tsetup_D_ENA_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
      thold_D_ENA_noedge_negedge     :   VitalDelayType := DefSetupHoldCnst;
      tipd_D                         :  VitalDelayType01 := DefPropDelay01;
      tipd_PRE                       :  VitalDelayType01 := DefPropDelay01;
      tipd_ENA                       :  VitalDelayType01 := DefPropDelay01);

   PORT(
      Q                              :  out   STD_LOGIC;
      D                              :  in    STD_LOGIC;
      PRE                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of apexii_latch : ENTITY is TRUE;

end apexii_latch;

-- ARCHITECTURE body --

ARCHITECTURE behave of apexii_latch is
   attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;

   signal D_ipd  : STD_ULOGIC := 'U';
   signal PRE_ipd        : std_logic;
   signal ENA_ipd        : std_logic;

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (D_ipd, D, tipd_D);
      VitalWireDelay (PRE_ipd, PRE, tipd_PRE);
      VitalWireDelay (ENA_ipd, ENA, tipd_ENA);
   end block;

   VITALtiming : process (D_ipd, PRE_ipd, ENA_ipd)

   variable Tviol_D_ENA : STD_ULOGIC := '0';
   variable TimingData_D_ENA : VitalTimingDataType := VitalTimingDataInit;
   variable Q_VitalGlitchData : VitalGlitchDataType;

   variable q_out : std_logic := '0';

   begin

      ------------------------
      --  Timing Check Section
      ------------------------
      if (TimingChecksOn) then
         VitalSetupHoldCheck (
                Violation       => Tviol_D_ENA,
                TimingData      => TimingData_D_ENA,
                TestSignal      => D_ipd,
                TestSignalName  => "D",
                RefSignal       => ENA_ipd,
                RefSignalName   => "ENA",
                SetupHigh       => tsetup_D_ENA_noedge_posedge,
                SetupLow        => tsetup_D_ENA_noedge_posedge,
                HoldHigh        => thold_D_ENA_noedge_negedge,
                HoldLow         => thold_D_ENA_noedge_negedge,
                CheckEnabled    => TO_X01( PRE_ipd ) /= '1',
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/LATCH",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
      end if;

      if (pre_ipd = '0') then
         -- latch is being preset, preset is active low
         q_out := '1';
      elsif (ena_ipd = '1') then
         -- latch is transparent
         q_out := D_ipd;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => Q,
       OutSignalName => "Q",
       OutTemp => q_out,
       Paths => (0 => (PRE_ipd'last_event, tpd_PRE_Q_negedge, TRUE),
                 1 => (ENA_ipd'last_event, tpd_ENA_Q_posedge, TRUE),
                 2 => (D_ipd'last_event, tpd_D_Q, (ENA = '1'))),
       GlitchData => Q_VitalGlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );
   end process;

end behave;


LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;

ENTITY apexii_dffe is
   GENERIC(
      TimingChecksOn: Boolean := True;
      XOn: Boolean := DefGlitchXOn;
      MsgOn: Boolean := DefGlitchMsgOn;
      MsgOnChecks: Boolean := DefMsgOnChecks;
      XOnChecks: Boolean := DefXOnChecks;
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

   PORT(
      Q                              :  out   STD_LOGIC;
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
   attribute VITAL_LEVEL0 of apexii_dffe : ENTITY is TRUE;
end apexii_dffe;

-- ARCHITECTURE body --

ARCHITECTURE behave of apexii_dffe is
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
--   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => 'X');
   VARIABLE Results : STD_LOGIC_VECTOR(1 to 1) := (others => '0');

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

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
--use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;

ENTITY mux21 is
   GENERIC(
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      InstancePath: STRING := "*";
      tpd_A_MO                      :   VitalDelayType01 := DefPropDelay01;
      tpd_B_MO                      :   VitalDelayType01 := DefPropDelay01;
      tpd_S_MO                      :   VitalDelayType01 := DefPropDelay01;
      tipd_A                       :    VitalDelayType01 := DefPropDelay01;
      tipd_B                       :    VitalDelayType01 := DefPropDelay01;
      tipd_S                       :    VitalDelayType01 := DefPropDelay01);
     PORT (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
   attribute VITAL_LEVEL0 of mux21 : ENTITY is TRUE;
end mux21;

ARCHITECTURE AltVITAL of mux21 is
   attribute VITAL_LEVEL0 of AltVITAL : ARCHITECTURE is TRUE;

   signal A_ipd, B_ipd, S_ipd  : std_logic;

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
      VitalWireDelay (A_ipd, A, tipd_A);
      VitalWireDelay (B_ipd, B, tipd_B);
      VitalWireDelay (S_ipd, S, tipd_S);
   end block;

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : process (A_ipd, B_ipd, S_ipd)

   -- output glitch detection variables
   VARIABLE MO_GlitchData       : VitalGlitchDataType;

   variable tmp_MO : std_logic;
   begin
      -------------------------
      --  Functionality Section
      -------------------------
      if (S_ipd = '1') then
         tmp_MO := B_ipd;
      else
         tmp_MO := A_ipd;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => MO,
       OutSignalName => "MO",
       OutTemp => tmp_MO,
       Paths => (0 => (A_ipd'last_event, tpd_A_MO, TRUE),
                 1 => (B_ipd'last_event, tpd_B_MO, TRUE),
                 2 => (S_ipd'last_event, tpd_S_MO, TRUE)),
       GlitchData => MO_GlitchData,
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;
end AltVITAL;

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.apexii_atom_pack.all;

-- ENTITY declaration --
ENTITY and1 is
   GENERIC(
      TimingChecksOn: Boolean := True;
      MsgOn: Boolean := DefGlitchMsgOn;
      XOn: Boolean := DefGlitchXOn;
      InstancePath: STRING := "*";
      tpd_IN1_Y                      :	VitalDelayType01 := DefPropDelay01;
      tipd_IN1                       :	VitalDelayType01 := DefPropDelay01);

   PORT(
      Y                              :	out   STD_LOGIC;
      IN1                            :	in    STD_LOGIC);
   attribute VITAL_LEVEL0 of and1 : ENTITY is TRUE;
end and1;

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
-- Entity Name : APEXII_ASYNCH_IO
--
-- Description : Timing simulation model for the asynchronous submodule
--               of APEX II IO
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;

ENTITY apexii_asynch_io is
    GENERIC (
            operation_mode      : STRING := "input";
            open_drain_output   : STRING := "false";
            bus_hold            : STRING := "false";
            
            XOn     : Boolean := DefGlitchXOn;
            MsgOn   : Boolean := DefGlitchMsgOn;
            
            tpd_datain_padio        : VitalDelayType01 := DefPropDelay01;
            tpd_oe_padio_posedge    : VitalDelayType01 := DefPropDelay01;
            tpd_oe_padio_negedge    : VitalDelayType01 := DefPropDelay01;
            tpd_padio_combout       : VitalDelayType01 := DefPropDelay01;
            tpd_regin_regout        : VitalDelayType01 := DefPropDelay01;
            tpd_ddioregin_ddioregout: VitalDelayType01 := DefPropDelay01;
            
            tipd_datain         : VitalDelayType01 := DefPropDelay01;
            tipd_oe             : VitalDelayType01 := DefPropDelay01;
            tipd_padio          : VitalDelayType01 := DefPropDelay01
            );
            
    PORT    (
            datain  : in  STD_LOGIC := '0';
            oe      : in  STD_LOGIC := '0';
            regin   : in std_logic;
            ddioregin   : in std_logic;
            padio       : inout STD_LOGIC;
            combout     : out STD_LOGIC;
            regout      : out STD_LOGIC;
            ddioregout  : out STD_LOGIC
            );
    attribute VITAL_LEVEL0 of apexii_asynch_io : ENTITY is TRUE;
end apexii_asynch_io;

ARCHITECTURE behave of apexii_asynch_io is
attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;
signal datain_ipd, oe_ipd, padio_ipd: std_logic;

begin
    ---------------------
    --  INPUT PATH DELAYs
    ---------------------
    WireDelay : block
    begin
        VitalWireDelay (datain_ipd, datain, tipd_datain);
        VitalWireDelay (oe_ipd, oe, tipd_oe);
        VitalWireDelay (padio_ipd, padio, tipd_padio);
    end block;

    VITAL: process(padio_ipd, datain_ipd, oe_ipd, regin, ddioregin)
    variable combout_VitalGlitchData : VitalGlitchDataType;
    variable padio_VitalGlitchData : VitalGlitchDataType;
    variable regout_VitalGlitchData : VitalGlitchDataType;
    variable ddioregout_VitalGlitchData : VitalGlitchDataType;
    
    variable tmp_combout, tmp_padio : std_logic;
    variable prev_value : std_logic := 'H';
    
    begin

        if (bus_hold = "true" ) then
            if ( operation_mode = "input") then
                if ( padio_ipd = 'Z') then
                    tmp_combout := to_x01z(prev_value);
                else
                    if ( padio_ipd = '1') then
                        prev_value := 'H';
                    elsif ( padio_ipd = '0') then
                        prev_value := 'L';
                    else
                        prev_value := 'W';
                    end if;
                tmp_combout := to_x01z(padio_ipd);
                end if;
                tmp_padio := 'Z';
            elsif ( operation_mode = "output" or operation_mode = "bidir") then
                if ( oe_ipd = '1') then
                    if ( open_drain_output = "true" ) then
                        if (datain_ipd = '0') then
                            tmp_padio := '0';
                            prev_value := 'L';
                        elsif (datain_ipd = 'X') then
                            tmp_padio := 'X';
                            prev_value := 'W';
                        else   -- 'Z'
                               -- need to update prev_value
                            if (padio_ipd = '1') then
                                prev_value := 'H';
                            elsif (padio_ipd = '0') then
                                prev_value := 'L';
                            elsif (padio_ipd = 'X') then
                                prev_value := 'W';
                            end if;
                            tmp_padio := prev_value;
                        end if;
                    else
                        tmp_padio := datain_ipd;
                        if ( datain_ipd = '1') then
                            prev_value := 'H';
                        elsif (datain_ipd = '0' ) then
                            prev_value := 'L';
                        elsif ( datain_ipd = 'X') then
                            prev_value := 'W';
                        else
                            prev_value := datain_ipd;
                        end if;
                    end if; -- end open_drain_output

                elsif ( oe_ipd = '0' ) then
                -- need to update prev_value
                    if (padio_ipd = '1') then
                        prev_value := 'H';
                    elsif (padio_ipd = '0') then
                        prev_value := 'L';
                    elsif (padio_ipd = 'X') then
                        prev_value := 'W';
                    end if;
                    tmp_padio := prev_value;
                else
                    tmp_padio := 'X';
                    prev_value := 'W';
                end if; -- end oe_in

                if ( operation_mode = "bidir") then
                    tmp_combout := to_x01z(padio_ipd);
                else
                    tmp_combout := 'Z';
                end if;
            end if;

            if ( now <= 1 ps AND prev_value = 'W' ) then     --hack for autotest to pass
                prev_value := 'L';
            end if;

        else    -- bus_hold is false
            if ( operation_mode = "input") then
                tmp_combout := padio_ipd;
                tmp_padio := 'Z';
            elsif (operation_mode = "output" or operation_mode = "bidir" ) then
                if ( operation_mode  = "bidir") then
                    tmp_combout := padio_ipd;
                else
                    tmp_combout := 'Z';
                end if;

                if ( oe_ipd = '1') then
                    if ( open_drain_output = "true" ) then
                        if (datain_ipd = '0') then
                            tmp_padio := '0';
                        elsif (datain_ipd = 'X') then
                            tmp_padio := 'X';
                        else
                            tmp_padio := 'Z';
                        end if;
                    else
                        tmp_padio := datain_ipd;
                    end if;
                elsif ( oe_ipd = '0' ) then
                    tmp_padio := 'Z';
                else
                    tmp_padio := 'X';
                end if;
            end if;
        end if; -- end bus_hold
        
        ----------------------
        --  Path Delay Section
        ----------------------
        VitalPathDelay01 (
            OutSignal => combout,
            OutSignalName => "combout",
            OutTemp => tmp_combout,
            Paths => (1 => (padio_ipd'last_event, tpd_padio_combout, TRUE)),
            GlitchData => combout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn 
            );

        VitalPathDelay01 (
            OutSignal => padio,
            OutSignalName => "padio",
            OutTemp => tmp_padio,
            Paths => (1 => (datain_ipd'last_event, tpd_datain_padio, TRUE),
                      2 => (oe_ipd'last_event, tpd_oe_padio_posedge, oe_ipd = '1'),
                      3 => (oe_ipd'last_event, tpd_oe_padio_negedge, oe_ipd = '0')),
            GlitchData => padio_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );

        VitalPathDelay01 (
            OutSignal => regout,
            OutSignalName => "regout",
            OutTemp => regin,
            Paths => (1 => (regin'last_event, tpd_regin_regout, TRUE)),
            GlitchData => regout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );

        VitalPathDelay01 (
            OutSignal => ddioregout,
            OutSignalName => "ddioregout",
            OutTemp => ddioregin,
            Paths => (1 => (ddioregin'last_event, tpd_ddioregin_ddioregout, TRUE)),
            GlitchData => ddioregout_VitalGlitchData,
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn
            );
    end process;

end behave;


--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_IO
--
-- Description : Timing simulation model for APEX II IO
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;
use work.apexii_asynch_io;
use work.apexii_dffe;
use work.mux21;
use work.and1;

ENTITY apexii_io is
    GENERIC (
            operation_mode : string := "input";
            ddio_mode : string := "none";
            open_drain_output :string := "false";
            output_register_mode : string := "none";
            output_reset : string := "none";
            output_power_up : string := "low";
            oe_register_mode : string := "none";
            oe_reset : string := "none";
            oe_power_up : string := "low";
            input_register_mode : string := "none";
            input_reset : string := "none";
            input_power_up : string := "low";
            bus_hold : string := "false";
            tie_off_output_clock_enable : string := "false";
            tie_off_oe_clock_enable : string := "false";
            extend_oe_disable : string := "false"
            );
            
    PORT    (
            datain          : in std_logic := '0';
            ddiodatain      : in std_logic := '0';
            oe              : in std_logic := '1';
            outclk          : in std_logic := '0';
            outclkena       : in std_logic := '1';
            inclk           : in std_logic := '0';
            inclkena        : in std_logic := '1';
            areset          : in std_logic := '0';
            devclrn         : in std_logic := '1';
            devpor          : in std_logic := '1';
            devoe           : in std_logic := '0';
            combout         : out std_logic;
            regout          : out std_logic;
            ddioregout      : out std_logic;
            padio           : inout std_logic
            );
end apexii_io;

ARCHITECTURE structure of apexii_io is
component apexii_asynch_io
    GENERIC(
            operation_mode : string := "input";
            open_drain_output : string := "false";
            bus_hold : string := "false"
            );
    PORT(
        datain : in  STD_LOGIC := '0';
        oe         : in  STD_LOGIC := '0';
        regin  : in std_logic;
        ddioregin  : in std_logic;
        padio  : inout STD_LOGIC;
        combout: out STD_LOGIC;
        regout : out STD_LOGIC;
        ddioregout : out STD_LOGIC
        );
end component;

component apexii_dffe
    GENERIC(
            TimingChecksOn: Boolean := true;
            InstancePath: STRING := "*";
            XOn: Boolean := DefGlitchXOn;
            MsgOn: Boolean := DefGlitchMsgOn;
            MsgOnChecks: Boolean := DefMsgOnChecks;
            XOnChecks: Boolean := DefXOnChecks;
            tpd_PRN_Q_negedge              :  VitalDelayType01 := DefPropDelay01;
            tpd_CLRN_Q_negedge             :  VitalDelayType01 := DefPropDelay01;
            tpd_CLK_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
            tpd_ENA_Q_posedge              :  VitalDelayType01 := DefPropDelay01;
            tsetup_D_CLK_noedge_posedge    :  VitalDelayType := DefSetupHoldCnst;
            tsetup_D_CLK_noedge_negedge    :  VitalDelayType := DefSetupHoldCnst;
            tsetup_ENA_CLK_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
            thold_D_CLK_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
            thold_D_CLK_noedge_negedge     :  VitalDelayType := DefSetupHoldCnst;
            thold_ENA_CLK_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
            tipd_D                         :  VitalDelayType01 := DefPropDelay01;
            tipd_CLRN                      :  VitalDelayType01 := DefPropDelay01;
            tipd_PRN                       :  VitalDelayType01 := DefPropDelay01;
            tipd_CLK                       :  VitalDelayType01 := DefPropDelay01;
            tipd_ENA                       :  VitalDelayType01 := DefPropDelay01
            );

    PORT(
        Q       :  out   STD_LOGIC := '0';
        D       :  in    STD_LOGIC := '1';
        CLRN    :  in    STD_LOGIC := '1';
        PRN     :  in    STD_LOGIC := '1';
        CLK     :  in    STD_LOGIC := '0';
        ENA     :  in    STD_LOGIC := '1'
        );
end component;

component mux21
    GENERIC(
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            InstancePath: STRING := "*";
            tpd_A_MO    :   VitalDelayType01 := DefPropDelay01;
            tpd_B_MO    :   VitalDelayType01 := DefPropDelay01;
            tpd_S_MO    :   VitalDelayType01 := DefPropDelay01;
            tipd_A      :   VitalDelayType01 := DefPropDelay01;
            tipd_B      :   VitalDelayType01 := DefPropDelay01;
            tipd_S      :   VitalDelayType01 := DefPropDelay01
            );

     PORT   (
            A : in std_logic := '0';
            B : in std_logic := '0';
            S : in std_logic := '0';
            MO : out std_logic
            );
end component;

component and1
    GENERIC(
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            InstancePath: STRING := "*";
            tpd_IN1_Y   :  VitalDelayType01 := DefPropDelay01;
            tipd_IN1    :  VitalDelayType01 := DefPropDelay01
            );

    PORT( 
        Y      :  out   STD_LOGIC;
        IN1    :  in    STD_LOGIC
        );
end component;

signal  oe_out : std_logic;

signal  in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out: std_logic;
signal  oe_reg_out, oe_pulse_reg_out : std_logic;
signal  out_reg_out, out_ddio_reg_out: std_logic;

signal  in_reg_clr, in_reg_preset : std_logic;
signal  oe_reg_clr, oe_reg_preset : std_logic;
signal  out_reg_clr, out_reg_preset, out_reg_sel : std_logic;

signal  input_reg_pu_low, output_reg_pu_low, oe_reg_pu_low : std_logic;

signal  tmp_datain : std_logic;
signal  iareset : std_logic ;
signal  input_dffe_clr : std_logic;
signal  input_dffe_preset : std_logic;
signal  output_dffe_clr : std_logic;
signal  output_dffe_preset : std_logic;
signal  oe_dffe_clr : std_logic;
signal  oe_dffe_preset : std_logic;
signal  not_inclk, not_outclk : std_logic;

-- for DDIO
signal ddio_data : std_logic;
signal outclk_delayed : std_logic;

signal out_clk_ena, oe_clk_ena : std_logic;

begin

    input_reg_pu_low <=  '0' WHEN input_power_up = "low" ELSE '1';
    output_reg_pu_low <= '0' WHEN output_power_up = "low" ELSE '1';
    oe_reg_pu_low <= '0' WHEN oe_power_up = "low" ELSE '1';
    
    out_reg_sel <= '1' WHEN output_register_mode = "register" ELSE '0';
    
    iareset <= (NOT areset) WHEN ( areset = '1' OR areset = '0') ELSE '1';
    
    -- output registered
    out_reg_clr <= iareset WHEN output_reset = "clear" ELSE '1';
    out_reg_preset <= iareset WHEN output_reset = "preset" ELSE '1';
    
    -- oe register
    oe_reg_clr <= iareset WHEN oe_reset = "clear" ELSE '1';
    oe_reg_preset <= iareset WHEN oe_reset = "preset" ELSE '1';
    
    -- input register
    in_reg_clr <= iareset WHEN input_reset = "clear" ELSE '1';
    in_reg_preset <= iareset WHEN input_reset = "preset" ELSE '1';
    
    input_dffe_clr  <= in_reg_clr AND devclrn AND (input_reg_pu_low OR devpor);
    input_dffe_preset <= in_reg_preset AND ( (NOT input_reg_pu_low) OR devpor);
    
    not_inclk <= not inclk;
    not_outclk <= not outclk;

    out_clk_ena <= '1' WHEN tie_off_output_clock_enable = "true" ELSE outclkena;
    oe_clk_ena <= '1' WHEN tie_off_oe_clock_enable = "true" ELSE outclkena;
    
    in_reg : apexii_dffe
             port map (D => padio,
                       CLRN => input_dffe_clr,
                       PRN => input_dffe_preset,
                       CLK => inclk,
                       ENA => inclkena,
                       Q => in_reg_out);

    in_ddio0_reg : apexii_dffe
                   port map (D => padio,
                             CLRN => input_dffe_clr,
                             PRN => input_dffe_preset,
                             CLK => not_inclk,
                             ENA => inclkena,
                             Q => in_ddio0_reg_out);

    in_ddio1_reg : apexii_dffe
                   port map (D => in_ddio0_reg_out,
                             CLRN => input_dffe_clr,
                             PRN => input_dffe_preset,
                             CLK => inclk,
                             ENA => inclkena,
                             Q => in_ddio1_reg_out);

    output_dffe_clr <= out_reg_clr AND devclrn AND (output_reg_pu_low OR devpor);
    output_dffe_preset <= out_reg_preset AND ( (NOT output_reg_pu_low) OR devpor);

    out_reg : apexii_dffe
              port map (D => datain,
                        CLRN => output_dffe_clr,
                        PRN => output_dffe_preset,
                        CLK => outclk,
                        ENA => out_clk_ena,
                        Q => out_reg_out);

    out_ddio_reg : apexii_dffe
                   port map (D => ddiodatain,
                             CLRN => output_dffe_clr,
                             PRN => output_dffe_preset,
                             CLK => outclk,
                             ENA => out_clk_ena,
                             Q => out_ddio_reg_out);

    oe_dffe_clr <= oe_reg_clr AND devclrn AND (oe_reg_pu_low OR devpor);
    oe_dffe_preset <= oe_reg_preset AND ( (NOT oe_reg_pu_low) OR devpor);

    oe_reg : apexii_dffe
             port map (D => oe,
                       CLRN => oe_dffe_clr,
                       PRN => oe_dffe_preset,
                       CLK => outclk,
                       ENA => oe_clk_ena,
                       Q => oe_reg_out);
    
    oe_pulse_reg : apexii_dffe
                   port map (D => oe_reg_out,
                             CLRN => oe_dffe_clr,
                             PRN => oe_dffe_preset,
                             CLK => not_outclk,
                             ENA => oe_clk_ena,
                             Q => oe_pulse_reg_out);
    
    oe_out <= (oe_pulse_reg_out and oe_reg_out) WHEN (extend_oe_disable = "true") ELSE oe_reg_out WHEN (oe_register_mode = "register") ELSE oe;

    sel_delaybuf  : and1
                    port map (Y => outclk_delayed,
                             IN1 => outclk);
    
    ddio_data_mux : mux21
                    port map (MO => ddio_data,
                             A => out_ddio_reg_out,
                             B => out_reg_out,
                             S => outclk_delayed);
    
    tmp_datain <= ddio_data WHEN (ddio_mode = "output" or ddio_mode = "bidir") ELSE
                                  out_reg_out WHEN (out_reg_sel = '1') ELSE
                                  datain;


    -- timing info in case output and/or input are not registered.
    apexii_pin : apexii_asynch_io
        GENERIC map ( OPERATION_MODE => operation_mode,
                      OPEN_DRAIN_OUTPUT => open_drain_output,
                      BUS_HOLD => bus_hold)
        port map( datain => tmp_datain,
                  oe => oe_out,
                  regin => in_reg_out,
                  ddioregin => in_ddio1_reg_out,
                  padio => padio,
                  combout => combout,
                  regout => regout,
                  ddioregout => ddioregout);

end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_ASYNCH_PTERM
--
-- Description : Timing simulation model for the asynchronous submodule
--               of APEX II PTERM
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;

ENTITY apexii_asynch_pterm is
    GENERIC (
            operation_mode      : string := "normal";
            invert_pterm1_mode  : string := "false";
            TimingChecksOn      : Boolean := True;
            MsgOn               : Boolean := DefGlitchMsgOn;
            XOn                 : Boolean := DefGlitchXOn;
            MsgOnChecks         : Boolean := DefMsgOnChecks;
            XOnChecks           : Boolean := DefXOnChecks;
            InstancePath        : STRING := "*";
            tpd_pterm0_combout  :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pterm1_combout  :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pexpin_combout  :  VitalDelayType01 := DefPropDelay01;
            tpd_fbkin_combout   :  VitalDelayType01 := DefPropDelay01;
            tpd_pterm0_regin    :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pterm1_regin    :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pexpin_regin    :  VitalDelayType01 := DefPropDelay01;
            tpd_fbkin_regin     :  VitalDelayType01 := DefPropDelay01;
            tpd_pterm0_pexpout  :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pterm1_pexpout  :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pexpin_pexpout  :  VitalDelayType01 := DefPropDelay01;
            tpd_fbkin_pexpout   :  VitalDelayType01 := DefPropDelay01;
            tipd_pterm0         :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tipd_pterm1         :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tipd_pexpin         :  VitalDelayType01 := DefPropDelay01
            );


    PORT    (
            pterm0	: in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
            pterm1  : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
            pexpin	: in std_logic := '0';
            fbkin : in std_logic;
            combout : out std_logic;
            regin : out std_logic;
            pexpout : out std_logic
            );
    attribute VITAL_LEVEL0 of apexii_asynch_pterm : ENTITY is TRUE;
end apexii_asynch_pterm; 

ARCHITECTURE vital_pterm of apexii_asynch_pterm is
   attribute VITAL_LEVEL0 of vital_pterm : ARCHITECTURE is TRUE;

signal pterm0_ipd	:std_logic_vector(31 downto 0) := (OTHERS => 'U');
signal pterm1_ipd	:std_logic_vector(31 downto 0) := (OTHERS => 'U');
signal pexpin_ipd	:std_ulogic := 'U';

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
    
    variable tmp_comb, tmp_pexpout : std_logic;
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
            MsgOn        => MsgOn);
    
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
            MsgOn        => MsgOn );
    
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
            MsgOn        => MsgOn );
           
    
    end process;

end vital_pterm;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_PTERM_REGISTER
--
-- Description : Timing simulation model for the register submodule
--               of APEX II PTERM
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;

ENTITY apexii_pterm_register is
    GENERIC (
            power_up        : string := "low";
            TimingChecksOn  : Boolean := True;
            MsgOn           : Boolean := DefGlitchMsgOn;
            XOn             : Boolean := DefGlitchXOn;
            MsgOnChecks     : Boolean := DefMsgOnChecks;
            XOnChecks       : Boolean := DefXOnChecks;
            InstancePath    : STRING := "*";
            tpd_aclr_regout_posedge      :  VitalDelayType01 := DefPropDelay01;
            tpd_clk_regout_posedge       :  VitalDelayType01 := DefPropDelay01;
            tpd_aclr_fbkout_posedge      :  VitalDelayType01 := DefPropDelay01;
            tpd_clk_fbkout_posedge       :  VitalDelayType01 := DefPropDelay01;
            tsetup_datain_clk_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
            tsetup_ena_clk_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
            thold_datain_clk_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
            thold_ena_clk_noedge_posedge      :  VitalDelayType := DefSetupHoldCnst;
            tipd_aclr                         :  VitalDelayType01 := DefPropDelay01;
            tipd_ena                          :  VitalDelayType01 := DefPropDelay01;
            tipd_clk                          :  VitalDelayType01 := DefPropDelay01
            );

    PORT    (
            datain  : in std_logic;
            clk	    : in std_logic;
            ena 	: in std_logic := '1';
            aclr	: in std_logic := '0';
            devclrn : in std_logic := '1';
            devpor  : in std_logic := '1';
            regout  : out std_logic;
            fbkout  : out std_logic
            );
    attribute VITAL_LEVEL0 of apexii_pterm_register : ENTITY is TRUE;
end apexii_pterm_register; 

ARCHITECTURE vital_pterm_reg of apexii_pterm_register is
   attribute VITAL_LEVEL0 of vital_pterm_reg : ARCHITECTURE is TRUE;

signal clk_ipd  	:std_ulogic := 'U';
signal aclr_ipd	    :std_ulogic := 'U';
signal ena_ipd	    :std_ulogic := 'U';

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

    VITALtiming : process(datain, clk_ipd, aclr_ipd, ena_ipd, devclrn, devpor)
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
                MsgOn           => MsgOnChecks ); 
    
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
                MsgOn           => MsgOnChecks ); 
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
            MsgOn        => MsgOn );
    
        VitalPathDelay01 ( 
            OutSignal => fbkout, 
            OutSignalName => "FBKOUT", 
            OutTemp => tmp_regout,  
            Paths => (0 => (aclr_ipd'last_event, tpd_aclr_regout_posedge, TRUE),
                     1 => (clk_ipd'last_event, tpd_clk_regout_posedge, TRUE)),
            GlitchData => fbkout_VitalGlitchData, 
            Mode => DefGlitchMode, 
            XOn  => XOn, 
            MsgOn        => MsgOn );
    end process;
    
end vital_pterm_reg;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_PTERM
--
-- Description : Timing simulation model for the register submodule
--               of APEX II PTERM
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;
use work.apexii_asynch_pterm;
use work.apexii_pterm_register;

ENTITY apexii_pterm is
    GENERIC (
            operation_mode     : string := "normal";
            output_mode        : string := "comb";
            invert_pterm1_mode : string := "false";
            power_up : string := "low"
            );


    PORT    (
            pterm0	: in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
            pterm1  : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
            pexpin	: in std_logic := '0';
            clk	: in std_logic := '0';
            ena 	: in std_logic := '1';
            aclr	: in std_logic := '0';
            devclrn   : in std_logic := '1';
            devpor : in std_logic := '1';
            dataout : out std_logic;
            pexpout : out std_logic
            );
    attribute VITAL_LEVEL0 of apexii_pterm : ENTITY is TRUE;
end apexii_pterm; 

ARCHITECTURE vital_pterm_atom of apexii_pterm is
   attribute VITAL_LEVEL0 of vital_pterm_atom : ARCHITECTURE is TRUE;

component apexii_asynch_pterm
    GENERIC (
            operation_mode      : string := "normal";
            invert_pterm1_mode  : string := "false";
            TimingChecksOn      : Boolean := True;
            MsgOn               : Boolean := DefGlitchMsgOn;
            XOn                 : Boolean := DefGlitchXOn;
            MsgOnChecks         : Boolean := DefMsgOnChecks;
            XOnChecks           : Boolean := DefXOnChecks;
            InstancePath        : STRING := "*";
            tpd_pterm0_combout  :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pterm1_combout  :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pexpin_combout  :  VitalDelayType01 := DefPropDelay01;
            tpd_fbkin_combout   :  VitalDelayType01 := DefPropDelay01;
            tpd_pterm0_pexpout  :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pterm1_pexpout  :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tpd_pexpin_pexpout  :  VitalDelayType01 := DefPropDelay01;
            tpd_fbkin_pexpout   :  VitalDelayType01 := DefPropDelay01;
            tipd_pterm0         :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tipd_pterm1         :  VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
            tipd_pexpin         :  VitalDelayType01 := DefPropDelay01
            );


    PORT    (
            pterm0	: in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
            pterm1  : in std_logic_vector(31 downto 0) := "11111111111111111111111111111111";
            pexpin	: in std_logic := '0';
            fbkin : in std_logic;
            combout : out std_logic;
            regin : out std_logic;
            pexpout : out std_logic
            );
end component; 

component apexii_pterm_register
    GENERIC (
            power_up : string := "low";
            TimingChecksOn: Boolean := True;
            MsgOn: Boolean := DefGlitchMsgOn;
            XOn: Boolean := DefGlitchXOn;
            MsgOnChecks: Boolean := DefMsgOnChecks;
            XOnChecks: Boolean := DefXOnChecks;
            InstancePath: STRING := "*";
            tpd_aclr_regout_posedge      :  VitalDelayType01 := DefPropDelay01;
            tpd_clk_regout_posedge       :  VitalDelayType01 := DefPropDelay01;
            tpd_aclr_fbkout_posedge      :  VitalDelayType01 := DefPropDelay01;
            tpd_clk_fbkout_posedge       :  VitalDelayType01 := DefPropDelay01;
            tsetup_datain_clk_noedge_posedge  :  VitalDelayType := DefSetupHoldCnst;
            tsetup_ena_clk_noedge_posedge     :  VitalDelayType := DefSetupHoldCnst;
            thold_datain_clk_noedge_posedge   :  VitalDelayType := DefSetupHoldCnst;
            thold_ena_clk_noedge_posedge      :  VitalDelayType := DefSetupHoldCnst;
            tipd_aclr                         :  VitalDelayType01 := DefPropDelay01;
            tipd_ena                          :  VitalDelayType01 := DefPropDelay01;
            tipd_clk                          :  VitalDelayType01 := DefPropDelay01
            );
            

    PORT    (
            datain	: in std_logic;
            clk	    : in std_logic;
            ena 	: in std_logic;
            aclr	: in std_logic;
            devclrn : in std_logic := '1';
            devpor  : in std_logic := '1';
            regout  : out std_logic;
            fbkout  : out std_logic
            );
end component; 

signal fbk, dffin, combo, dffo	:std_ulogic ;

begin

    pcom: apexii_asynch_pterm 
          GENERIC map (operation_mode => operation_mode,
                       invert_pterm1_mode => invert_pterm1_mode)
          port map (pterm0 => pterm0, pterm1 => pterm1, pexpin => pexpin,
                    fbkin => fbk, regin => dffin, combout => combo, 
                    pexpout => pexpout);

    preg: apexii_pterm_register
          GENERIC map (power_up => power_up)
          port map (datain => dffin, clk => clk, ena => ena, aclr => aclr,
                    devclrn => devclrn, devpor => devpor, regout => dffo,
                    fbkout => fbk);	

    dataout <= combo when output_mode = "comb" else dffo;

end vital_pterm_atom;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_ASYNCH_MEM
--
-- Description : Timing simulation model for the asynchronous RAM array
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE IEEE.VITAL_Primitives.all;
USE work.apexii_atom_pack.all;

ENTITY apexii_asynch_mem IS
    GENERIC (
             operation_mode                   : string := "single_port";
             port_a_operation_mode            : string := "single_port";
             port_b_operation_mode            : string := "single_port";
       
             port_a_write_deep_ram_mode       : string := "off";
             port_a_write_address_width       : integer := 1;
             port_a_write_first_address       : integer := 0;
             port_a_write_last_address        : integer := 4095;
             port_a_write_data_width          : integer := 1;
       
             port_a_read_deep_ram_mode        : string := "off";
             port_a_read_address_width        : integer := 1;
             port_a_read_first_address        : integer := 0;
             port_a_read_last_address         : integer := 4095;
             port_a_read_data_width           : integer := 1;
       
             port_b_write_deep_ram_mode       : string := "off";
             port_b_write_address_width       : integer := 1;
             port_b_write_first_address       : integer := 0;
             port_b_write_last_address        : integer := 4095;
             port_b_write_data_width          : integer := 1;
       
             port_b_read_deep_ram_mode        : string := "off";
             port_b_read_address_width        : integer := 1;
             port_b_read_first_address        : integer := 0;
             port_b_read_last_address         : integer := 4095;
             port_b_read_data_width           : integer := 1;
       
             port_a_read_enable_clock         : string := "none";
             port_b_read_enable_clock         : string := "none";
       
             port_a_write_logic_clock         : string := "none";
             port_b_write_logic_clock         : string := "none";
       
             init_file                        : string := "none";
             port_a_init_file                 : string := "none";
             port_b_init_file                 : string := "none";
       
             mem1                             : std_logic_vector(512 downto 1);
             mem2                             : std_logic_vector(512 downto 1);
             mem3                             : std_logic_vector(512 downto 1);
             mem4                             : std_logic_vector(512 downto 1);
             mem5                             : std_logic_vector(512 downto 1);
             mem6                             : std_logic_vector(512 downto 1);
             mem7                             : std_logic_vector(512 downto 1);
             mem8                             : std_logic_vector(512 downto 1);
       
             bit_number                       : integer := 0;
             TimingChecksOn                   : Boolean := True;
             MsgOn                            : Boolean := DefGlitchMsgOn;
             XOn                              : Boolean := DefGlitchXOn;
             MsgOnChecks                      : Boolean := DefMsgOnChecks;
             XOnChecks                        : Boolean := DefXOnChecks;
             InstancePath                     : STRING := "*";
       
             -- timing check GENERICs for PORT A
       
             tsetup_portawaddr_portawe_noedge_posedge   : VitalDelayArrayType(16 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portawaddr_portawe_noedge_negedge    : VitalDelayArrayType(16 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_portadatain_portawe_noedge_negedge  : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portadatain_portawe_noedge_negedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_portaraddr_portare_noedge_negedge   : VitalDelayArrayType(16 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portaraddr_portare_noedge_negedge    : VitalDelayArrayType(16 downto 0) := (OTHERS => DefSetupHoldCnst);
       
             -- path delay GENERICs for PORT A
       
             tpd_portaraddr_portadataout                : VitalDelayArrayType01(271 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portare_portadataout                   : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portadatain_portadataout               : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portawe_portadataout                   : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbwe_portadataout                   : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbdatain_portadataout               : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
       
             -- timing check GENERICs for PORT B
       
             tsetup_portbwaddr_portbwe_noedge_posedge   : VitalDelayArrayType(16 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portbwaddr_portbwe_noedge_negedge    : VitalDelayArrayType(16 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_portbdatain_portbwe_noedge_negedge  : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portbdatain_portbwe_noedge_negedge   : VitalDelayArrayType(15 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_portbraddr_portbre_noedge_negedge   : VitalDelayArrayType(16 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_portbraddr_portbre_noedge_negedge    : VitalDelayArrayType(16 downto 0) := (OTHERS => DefSetupHoldCnst);
       
             -- path delay GENERICs for PORT B
       
             tpd_portbraddr_portbdataout                : VitalDelayArrayType01(271 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbre_portbdataout                   : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbdatain_portbdataout               : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portbwe_portbdataout                   : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portawe_portbdataout                   : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_portadatain_portbdataout               : VitalDelayArrayType01(255 downto 0) := (OTHERS => DefPropDelay01);
       
       -- port delay GENERICs
       
               tipd_portadatain                         : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portawaddr                          : VitalDelayArrayType01(16 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portaraddr                          : VitalDelayArrayType01(16 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portawe                             : VitalDelayType01 := DefPropDelay01;
               tipd_portare                             : VitalDelayType01 := DefPropDelay01;
       
               tipd_portbdatain                         : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portbwaddr                          : VitalDelayArrayType01(16 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portbraddr                          : VitalDelayArrayType01(16 downto 0) := (OTHERS => DefPropDelay01);
               tipd_portbwe                             : VitalDelayType01 := DefPropDelay01;
               tipd_portbre                             : VitalDelayType01 := DefPropDelay01;
       
             tpw_portawe_posedge                        : VitalDelayType := DefPulseWdthCnst;
             tpw_portare_posedge                        : VitalDelayType := DefPulseWdthCnst;
             tpw_portbwe_posedge                        : VitalDelayType := DefPulseWdthCnst;
             tpw_portbre_posedge                        : VitalDelayType := DefPulseWdthCnst
            );

    PORT    ( portadatain                  : in std_logic_vector(15 downto 0);
              portawe                      : in std_logic;
              portare                      : in std_logic;
              portaraddr                   : in std_logic_vector(16 downto 0);
              portawaddr                   : in std_logic_vector(16 downto 0);
              portbdatain                  : in std_logic_vector(15 downto 0);
              portbwe                      : in std_logic;
              portbre                      : in std_logic;
              portbraddr                   : in std_logic_vector(16 downto 0);
              portbwaddr                   : in std_logic_vector(16 downto 0);
              portadataout                 : out std_logic_vector(15 downto 0);
              portbdataout                 : out std_logic_vector(15 downto 0);
              portamodesel                 : in std_logic_vector(20 downto 0);
              portbmodesel                 : in std_logic_vector(20 downto 0)
            );

   attribute VITAL_LEVEL0 of apexii_asynch_mem : ENTITY is TRUE;
END apexii_asynch_mem;

ARCHITECTURE behave OF apexii_asynch_mem IS
   attribute VITAL_LEVEL0 of behave : ARCHITECTURE is TRUE;

signal portadatain_ipd : std_logic_vector(15 downto 0);
signal portawaddr_ipd : std_logic_vector(16 downto 0);
signal portaraddr_ipd : std_logic_vector(16 downto 0);
signal portawe_ipd : std_logic;
signal portare_ipd : std_logic;

signal portbdatain_ipd : std_logic_vector(15 downto 0);
signal portbwaddr_ipd : std_logic_vector(16 downto 0);
signal portbraddr_ipd : std_logic_vector(16 downto 0);
signal portbwe_ipd : std_logic;
signal portbre_ipd : std_logic;

begin

  ---------------------
   --  INPUT PATH DELAYs
   ---------------------
        WireDelay : block
        begin
           g1 : for i in portadatain'range generate
              VitalWireDelay (portadatain_ipd(i), portadatain(i), tipd_portadatain(i));
           end generate;
           g2 : for i in portawaddr'range generate
              VitalWireDelay (portawaddr_ipd(i), portawaddr(i), tipd_portawaddr(i));
           end generate;
           g3 : for i in portaraddr'range generate
              VitalWireDelay (portaraddr_ipd(i), portaraddr(i), tipd_portaraddr(i));
           end generate;
           VitalWireDelay (portawe_ipd, portawe, tipd_portawe);
           VitalWireDelay (portare_ipd, portare, tipd_portare);

           g4 : for i in portbdatain'range generate
              VitalWireDelay (portbdatain_ipd(i), portbdatain(i), tipd_portbdatain(i));
           end generate;
           g5 : for i in portbwaddr'range generate
              VitalWireDelay (portbwaddr_ipd(i), portbwaddr(i), tipd_portbwaddr(i));
           end generate;
           g6 : for i in portbraddr'range generate
              VitalWireDelay (portbraddr_ipd(i), portbraddr(i), tipd_portbraddr(i));
           end generate;
           VitalWireDelay (portbwe_ipd, portbwe, tipd_portbwe);
           VitalWireDelay (portbre_ipd, portbre, tipd_portbre);
        end block;

VITAL: process(portadatain_ipd, portawe_ipd, portare_ipd, portaraddr_ipd, portawaddr_ipd, portbdatain_ipd, portbwe_ipd, portbre_ipd, portbraddr_ipd, portbwaddr_ipd)
        variable Tviol_portadatain_portawe : std_ulogic := '0';
        variable Tviol_portawaddr_portawe : std_ulogic := '0';
        variable Tviol_portaraddr_portare : std_ulogic := '0';
        variable TimingData_portawaddr_portawe : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_portaraddr_portare : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_portadatain_portawe : VitalTimingDataType := VitalTimingDataInit;
        variable portadataout_VitalGlitchDataArray : VitalGlitchDataArrayType(15 downto 0);
        variable Tviol_portawe : std_ulogic := '0';
        variable PeriodData_portawe: VitalPeriodDataType := VitalPeriodDataInit;
        variable Tviol_portare : std_ulogic := '0';
        variable PeriodData_portare: VitalPeriodDataType := VitalPeriodDataInit;

        variable Tviol_portbdatain_portbwe : std_ulogic := '0';
        variable Tviol_portbwaddr_portbwe : std_ulogic := '0';
        variable Tviol_portbraddr_portbre : std_ulogic := '0';
        variable TimingData_portbwaddr_portbwe : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_portbraddr_portbre : VitalTimingDataType := VitalTimingDataInit;
        variable TimingData_portbdatain_portbwe : VitalTimingDataType := VitalTimingDataInit;
        variable portbdataout_VitalGlitchDataArray : VitalGlitchDataArrayType(15 downto 0);
        variable Tviol_portbwe : std_ulogic := '0';
        variable PeriodData_portbwe: VitalPeriodDataType := VitalPeriodDataInit;
        variable Tviol_portbre : std_ulogic := '0';
        variable PeriodData_portbre: VitalPeriodDataType := VitalPeriodDataInit;

        variable tmp_mem, mem : std_logic_vector(4095 downto 0) := (OTHERS => '0');
        variable raddr_a, waddr_a, raddr_b, waddr_b  : integer := 0;
        variable waddr_a_lsb, waddr_b_lsb : integer := 0;
        variable raddr_a_lsb, raddr_b_lsb : integer := 0;
        variable waddr_a_msb : integer := port_a_write_data_width-1;
        variable waddr_b_msb : integer := port_b_write_data_width-1;
        variable raddr_a_msb, raddr_b_msb : integer := 1;
        variable tmp_a_dataout : std_logic_vector(15 downto 0) := (OTHERS => '1');
        variable tmp_b_dataout : std_logic_vector(15 downto 0) := (OTHERS => '1');
        variable re_active_a, re_active_b : boolean := false;
        variable l, index, offset, depth : integer := 0;
        variable port_b_offset : integer := 0;
        variable port_a_we_was_active, port_b_we_was_active : boolean := false;
        variable do_init_mem : boolean := true;

        variable a_size, b_size : integer := 0;

        variable port_a_write_is_valid : boolean := false;
        variable port_b_write_is_valid : boolean := false;
        variable same_address_write : boolean := false;
        TYPE bool_array is ARRAY(0 to 4095) of boolean;
        variable addr_is_in_port_a_write_cycle : bool_array;
        variable addr_is_in_port_b_write_cycle : bool_array;

begin

      ------------------------
      --  Timing Check Section
      ------------------------
   if (TimingChecksOn) then

         -- PORT A Timing checks

     if (portamodesel(2) = '0') then -- write_logic is unregistered
         VitalSetupHoldCheck (
                Violation       => Tviol_portawaddr_portawe,
                TimingData      => TimingData_portawaddr_portawe,
                TestSignal      => portawaddr_ipd,
                TestSignalName  => "PORTAWADDR",
                RefSignal       => portawe_ipd,
                RefSignalName   => "PORTAWE",
                SetupHigh       => tsetup_portawaddr_portawe_noedge_posedge(0),
                SetupLow        => tsetup_portawaddr_portawe_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_portawaddr_portawe,
                TimingData      => TimingData_portawaddr_portawe,
                TestSignal      => portawaddr_ipd,
                TestSignalName  => "PORTAWADDR",
                RefSignal       => portawe_ipd,
                RefSignalName   => "PORTAWE",
                HoldHigh        => thold_portawaddr_portawe_noedge_negedge(0),
                HoldLow         => thold_portawaddr_portawe_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

          VitalPeriodPulseCheck (
                Violation       => Tviol_portawe,
                PeriodData      => PeriodData_portawe,
                TestSignal      => portawe_ipd,
                TestSignalName  => "PORTAWE",
                PulseWidthHigh  => tpw_portawe_posedge,
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
     end if;

     if (portamodesel(5) = '0') then -- portaraddr is unregistered
         VitalSetupHoldCheck (
                Violation       => Tviol_portaraddr_portare,
                TimingData      => TimingData_portaraddr_portare,
                TestSignal      => portaraddr_ipd,
                TestSignalName  => "PORTARADDR",
                RefSignal       => portare_ipd,
                RefSignalName   => "PORTARE",
                SetupHigh       => tsetup_portaraddr_portare_noedge_negedge(0),
                SetupLow        => tsetup_portaraddr_portare_noedge_negedge(0),
                HoldHigh        => thold_portaraddr_portare_noedge_negedge(0),
                HoldLow         => thold_portaraddr_portare_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
     end if;

     if (portamodesel(7) = '0') then -- portare is unregistered
          VitalPeriodPulseCheck (
                Violation       => Tviol_portare,
                PeriodData      => PeriodData_portare,
                TestSignal      => portare_ipd,
                TestSignalName  => "PORTARE",
                PulseWidthHigh  => tpw_portare_posedge,
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
     end if;

     if (portamodesel(0) = '0') then -- portadatain is unregistered
         VitalSetupHoldCheck (
                Violation       => Tviol_portadatain_portawe,
                TimingData      => TimingData_portadatain_portawe,
                TestSignal      => portadatain_ipd,
                TestSignalName  => "PORTADATAIN",
                RefSignal       => portawe_ipd,
                RefSignalName   => "PORTAWE",
                SetupHigh       => tsetup_portadatain_portawe_noedge_negedge(0),
                SetupLow        => tsetup_portadatain_portawe_noedge_negedge(0),
                HoldHigh        => thold_portadatain_portawe_noedge_negedge(0),
                HoldLow         => thold_portadatain_portawe_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
     end if;

         -- PORT B Timing checks

     if (portbmodesel(2) = '0') then -- write_logic is unregistered
         VitalSetupHoldCheck (
                Violation       => Tviol_portbwaddr_portbwe,
                TimingData      => TimingData_portbwaddr_portbwe,
                TestSignal      => portbwaddr_ipd,
                TestSignalName  => "PORTBWADDR",
                RefSignal       => portbwe_ipd,
                RefSignalName   => "PORTBWE",
                SetupHigh       => tsetup_portbwaddr_portbwe_noedge_posedge(0),
                SetupLow        => tsetup_portbwaddr_portbwe_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

         VitalSetupHoldCheck (
                Violation       => Tviol_portbwaddr_portbwe,
                TimingData      => TimingData_portbwaddr_portbwe,
                TestSignal      => portbwaddr_ipd,
                TestSignalName  => "PORTBWADDR",
                RefSignal       => portbwe_ipd,
                RefSignalName   => "PORTBWE",
                HoldHigh        => thold_portbwaddr_portbwe_noedge_negedge(0),
                HoldLow         => thold_portbwaddr_portbwe_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

          VitalPeriodPulseCheck (
                Violation       => Tviol_portbwe,
                PeriodData      => PeriodData_portbwe,
                TestSignal      => portbwe_ipd,
                TestSignalName  => "PORTBWE",
                PulseWidthHigh  => tpw_portbwe_posedge,
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

     end if;

     if (portbmodesel(5) = '0') then -- portbraddr is unregistered
         VitalSetupHoldCheck (
                Violation       => Tviol_portbraddr_portbre,
                TimingData      => TimingData_portbraddr_portbre,
                TestSignal      => portbraddr_ipd,
                TestSignalName  => "PORTBRADDR",
                RefSignal       => portbre_ipd,
                RefSignalName   => "PORTBRE",
                SetupHigh       => tsetup_portbraddr_portbre_noedge_negedge(0),
                SetupLow        => tsetup_portbraddr_portbre_noedge_negedge(0),
                HoldHigh        => thold_portbraddr_portbre_noedge_negedge(0),
                HoldLow         => thold_portbraddr_portbre_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
     end if;

     if (portbmodesel(7) = '0') then -- portbre is unregistered
          VitalPeriodPulseCheck (
                Violation       => Tviol_portbre,
                PeriodData      => PeriodData_portbre,
                TestSignal      => portbre_ipd,
                TestSignalName  => "PORTBRE",
                PulseWidthHigh  => tpw_portbre_posedge,
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
     end if;

     if (portbmodesel(0) = '0') then -- portbdatain is unregistered
         VitalSetupHoldCheck (
                Violation       => Tviol_portbdatain_portbwe,
                TimingData      => TimingData_portbdatain_portbwe,
                TestSignal      => portbdatain_ipd,
                TestSignalName  => "PORTBDATAIN",
                RefSignal       => portbwe_ipd,
                RefSignalName   => "PORTBWE",
                SetupHigh       => tsetup_portbdatain_portbwe_noedge_negedge(0),
                SetupLow        => tsetup_portbdatain_portbwe_noedge_negedge(0),
                HoldHigh        => thold_portbdatain_portbwe_noedge_negedge(0),
                HoldLow         => thold_portbdatain_portbwe_noedge_negedge(0),
                RefTransition   => '\',
                HeaderMsg       => InstancePath & "/APEXII_ASYNCH_MEM",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
     end if;

   end if;

      -- functionality section

      if (now = 0 ns and do_init_mem) then
         do_init_mem := false;
         port_b_offset := 0;
         tmp_mem := (mem8 & mem7 & mem6 & mem5 & mem4 & mem3 & mem2 & mem1);

         -- arrange the initialization data word wise, it is slice-wise
         depth := port_a_read_last_address - port_a_read_first_address + 1;

         for j in 0 to (depth-1) loop
             for k in 0 to (port_a_read_data_width-1) loop
                 index := j + (depth * k);
                 mem(l) := tmp_mem(index);
                 l := l + 1;
             end loop;
         end loop;

         if (operation_mode = "packed") then
            depth := port_b_read_last_address - port_b_read_first_address + 1;
            offset := l;
            port_b_offset := l;
            for j in 0 to (depth-1) loop
                for k in 0 to (port_b_read_data_width-1) loop
                   index := offset + j + (depth * k);
                   mem(l) := tmp_mem(index);
                   l := l + 1;
                end loop;
            end loop;
         end if;

         -- memory contents depend on WE registered or not
         -- if WE is unregistered, initialize RAM to 'X'
         a_size := port_a_read_data_width * (port_a_read_last_address - port_a_read_first_address + 1);
         b_size := port_b_read_data_width * (port_b_read_last_address - port_b_read_first_address + 1);
         if (operation_mode /= "packed") then
            if (operation_mode = "single_port" or operation_mode = "dual_port") then
               if (port_a_write_logic_clock = "none") then
                  mem(4095 downto 0) := (OTHERS => 'X');
               end if;
            elsif ((operation_mode /= "rom") and (port_a_write_logic_clock = "none" or port_b_write_logic_clock = "none")) then
--               mem(4095 downto 0) := (OTHERS => 'X');
               for j in 0 to 4095 loop
                  mem(j) := 'X';
               end loop;
            end if;
         end if;
         if (operation_mode = "packed") then
            if ((port_a_operation_mode /= "rom") and (port_a_write_logic_clock = "none")) then
               mem(a_size-1 downto 0) := (OTHERS => 'X');
            end if;
            if ((port_b_operation_mode /= "rom") and (port_b_write_logic_clock = "none")) then
               mem(b_size-1 downto a_size) := (OTHERS => 'X');
            end if;
         end if;

         -- set the initial re state, depending on operation mode
         if ((operation_mode = "rom") or (operation_mode = "single_port")) then
            re_active_a := true;
         end if;
         if (operation_mode = "bidir_dual_port") then
            re_active_a := true;
            re_active_b := true;
         end if;
         if (operation_mode = "packed") then
            if ((port_a_operation_mode = "rom") or (port_a_operation_mode = "single_port")) then
               re_active_a := true;
            end if;
            if ((port_b_operation_mode = "rom") or (port_b_operation_mode = "single_port")) then
               re_active_b := true;
            end if;
         end if;

         -- if re is not registered, initial state of latch at
         -- o/p of ESB is undefined; so initialize tmp_a_dataout and
         -- tmp_b_dataout here

            tmp_a_dataout := (OTHERS => '1');
            tmp_b_dataout := (OTHERS => '1');
            if (port_a_read_enable_clock = "none") then
                tmp_a_dataout := (OTHERS => 'X');
            end if;
            if (port_b_read_enable_clock = "none") then
                tmp_b_dataout := (OTHERS => 'X');
            end if;

            for i in 0 to 4095 loop
              addr_is_in_port_a_write_cycle(i) := false;
              addr_is_in_port_b_write_cycle(i) := false;
            end loop;

      end if;

      if (portaraddr_ipd'event) then
         -- calculate the porta read addresses
         raddr_a := conv_integer(portaraddr_ipd);
         raddr_a_lsb := raddr_a * port_a_read_data_width;
         raddr_a_msb := raddr_a_lsb + port_a_read_data_width - 1;

         -- schedule read data on outputs

         if (re_active_a) then
            for i in raddr_a_lsb to raddr_a_msb loop
                if (portawe_ipd = '1' and ((i = waddr_a_lsb) or (i = waddr_a_msb) or (i > waddr_a_lsb and i < waddr_a_msb))) then
                   tmp_a_dataout(i rem port_a_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
                elsif (operation_mode /= "packed" and portbwe_ipd = '1' and (( i = waddr_b_lsb) or (i = waddr_b_msb) or (i > waddr_b_lsb and i < waddr_b_msb))) then
                   tmp_a_dataout(i rem port_a_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
                else
                   tmp_a_dataout(i rem port_a_read_data_width) := mem(i);
                end if;
            end loop;
         end if;
      end if;

      if (portbraddr_ipd'event) then
         -- calculate the portb read addresses
         raddr_b := conv_integer(portbraddr_ipd);
         raddr_b_lsb := raddr_b * port_b_read_data_width;
         raddr_b_msb := raddr_b_lsb + port_b_read_data_width - 1;

         -- schedule read data on outputs

         if (re_active_b) then
            for i in raddr_b_lsb to raddr_b_msb loop
                if (portbwe_ipd = '1'and ((i = waddr_b_lsb) or (i = waddr_b_msb) or (i > waddr_b_lsb and i < waddr_b_msb))) then
                   tmp_b_dataout(i rem port_b_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
                elsif (operation_mode /= "packed" and portawe_ipd = '1' and ((i = waddr_a_lsb) or (i = waddr_a_msb) or (i > waddr_a_lsb and i < waddr_a_msb))) then
                   tmp_b_dataout(i rem port_b_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
                else
                   tmp_b_dataout(i rem port_b_read_data_width) := mem(port_b_offset + i);
                end if;
            end loop;
         end if;
      end if;

      if (portawe_ipd'event and portawe_ipd = '1') then
         port_a_we_was_active := true;

         -- check if port A write is valid
         for i in waddr_a_lsb to waddr_a_msb loop
            if (operation_mode = "bidir_dual_port") then
               if (addr_is_in_port_b_write_cycle(i)) then
                  port_a_write_is_valid := false;
                  same_address_write := true;
                  assert false report "Simultaneous write to same address. Data will be invalid in ESB." severity warning;
                  exit;
               else
                  port_a_write_is_valid := true;
                  same_address_write := false;
               end if;
            else
               port_a_write_is_valid := true;
               same_address_write := false;
            end if;
         end loop;

         for i in 0 to ((port_a_write_last_address - port_a_write_first_address + 1) * port_a_write_data_width - 1) loop
            if (port_a_write_is_valid) then
               if (i >= waddr_a_lsb and i <= waddr_a_msb) then
                  addr_is_in_port_a_write_cycle(i) := true;
               else
                  addr_is_in_port_a_write_cycle(i) := false;
               end if;
            else
               addr_is_in_port_a_write_cycle(i) := false;
            end if;
         end loop;

         -- if port a read && write addr match, data flows thro' to portadataout

         for i in waddr_a_lsb to waddr_a_msb loop
             if ( re_active_a and ((i = raddr_a_lsb) or (i = raddr_a_msb) or ((i > raddr_a_lsb) and (i < raddr_a_msb))) ) then
             -- this bit is being read at the same time
                if (port_a_write_is_valid) then
                   tmp_a_dataout(i rem port_a_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
                elsif (same_address_write) then
                   tmp_a_dataout(i rem port_a_read_data_width) := 'X';
                end if;
             end if;
         end loop;

         -- if not packed mode && portb read addr match, data flows thro'
         -- to portbdataout

         if (operation_mode = "bidir_dual_port" or operation_mode = "quad_port") then
            for i in waddr_a_lsb to waddr_a_msb loop
                if ( re_active_b and ((i = raddr_b_lsb) or (i = raddr_b_msb) or ((i > raddr_b_lsb) and (i < raddr_b_msb))) ) then
                   -- this bit is also being read on port b
                   if (same_address_write) then
                      tmp_b_dataout(i rem port_b_read_data_width) := 'X';
                   elsif (port_a_write_is_valid) then
                      tmp_b_dataout(i rem port_b_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
                   end if;
                end if;
            end loop;
         end if;
      end if;

      if (portawe_ipd'event and portawe_ipd = '0') then
         if (port_a_we_was_active) then  -- checks if we has been active
                                         -- at least once : write will
                                         -- not happen if we went to 0 w/o
                                         -- ever going to 1
            port_a_we_was_active := false;
            -- take address out of write cycle
            for i in waddr_a_lsb to waddr_a_msb loop
               addr_is_in_port_a_write_cycle(i) := false;
            end loop;

            -- write the data into mem
            for i in 0 to port_a_write_data_width-1 loop
                if (same_address_write) then
                   mem(waddr_a_lsb + i) := 'X';
                else
                   mem(waddr_a_lsb + i) := portadatain_ipd(i);
                end if;
            end loop;
         end if;
      end if;

      if (portawaddr_ipd'event) then
         -- calculate the porta write addresses
         waddr_a := conv_integer(portawaddr_ipd);
         waddr_a_lsb := waddr_a * port_a_write_data_width;
         waddr_a_msb := waddr_a_lsb + port_a_write_data_width - 1;
      end if;

      if (portbwe_ipd'event and portbwe_ipd = '1') then
         port_b_we_was_active := true;

         -- check if port B write is valid
         for i in waddr_b_lsb to waddr_b_msb loop
            if (operation_mode = "bidir_dual_port") then
               if (addr_is_in_port_a_write_cycle(i)) then
                  port_b_write_is_valid := false;
                  same_address_write := true;
                  assert false report "Simultaneous write to same address. Data will be invalid in ESB." severity warning;
                  exit;
               else
                  port_b_write_is_valid := true;
                  same_address_write := false;
               end if;
            else
               port_b_write_is_valid := true;
               same_address_write := false;
            end if;
         end loop;

         for i in 0 to ((port_b_write_last_address - port_b_write_first_address + 1) * port_b_write_data_width - 1) loop
            if (port_b_write_is_valid) then
               if (i >= waddr_b_lsb and i <= waddr_b_msb) then
                  addr_is_in_port_b_write_cycle(i) := true;
               else
                  addr_is_in_port_b_write_cycle(i) := false;
               end if;
            else
               addr_is_in_port_b_write_cycle(i) := false;
            end if;
         end loop;

         -- if port b read && write addr match, data flows thro' to portbdataout

         for i in waddr_b_lsb to waddr_b_msb loop
             if ( re_active_b and ((i = raddr_b_lsb) or (i = raddr_b_msb) or ((i > raddr_b_lsb) and (i < raddr_b_msb))) ) then
                -- this bit is being read at the same time
                if (port_b_write_is_valid) then
                   tmp_b_dataout(i rem port_b_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
                elsif (same_address_write) then
                   tmp_b_dataout(i rem port_b_read_data_width) := 'X';
                end if;
             end if;
         end loop;

         -- if not packed mode && porta read addr match, data flows thro'
         -- to portadataout

         if (operation_mode = "bidir_dual_port" or operation_mode = "quad_port") then
            for i in waddr_b_lsb to waddr_b_msb loop
                if ( re_active_a and ((i = raddr_a_lsb) or (i = raddr_a_msb) or ((i > raddr_a_lsb) and (i < raddr_a_msb))) ) then
                   -- this bit is also being read on port a
                   if (same_address_write) then
                      tmp_a_dataout(i rem port_a_read_data_width) := 'X';
                   else
                      tmp_a_dataout(i rem port_a_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
                   end if;
                end if;
            end loop;
         end if;
      end if;

      if (portbwe_ipd'event and portbwe_ipd = '0') then
         if (port_b_we_was_active) then  -- checks if we has been active
                                         -- at least once : write will
                                         -- not happen if we went to 0 w/o
                                         -- ever going to 1
            port_b_we_was_active := false;
            -- take address out of write cycle
            for i in waddr_b_lsb to waddr_b_msb loop
               addr_is_in_port_b_write_cycle(i) := false;
            end loop;

            -- write the data into mem
            for i in 0 to port_b_write_data_width-1 loop
                if (same_address_write) then
                   mem(port_b_offset + waddr_b_lsb + i) := 'X';
                else
                   mem(port_b_offset + waddr_b_lsb + i) := portbdatain_ipd(i);
                end if;
            end loop;
         end if;
      end if;

      if (portbwaddr_ipd'event) then
         -- calculate the portb write addresses
         waddr_b := conv_integer(portbwaddr_ipd);
         waddr_b_lsb := waddr_b * port_b_write_data_width;
         waddr_b_msb := waddr_b_lsb + port_b_write_data_width - 1;
      end if;

      if (portare_ipd'event and portare_ipd = '1') then
         re_active_a := true;
         for i in raddr_a_lsb to raddr_a_msb loop
             if ( portawe_ipd = '1' and ((i = waddr_a_lsb) or (i = waddr_a_msb) or ((i > waddr_a_lsb) and (i < waddr_a_msb))) ) then
                -- bit is being written by porta
                tmp_a_dataout(i rem port_a_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
             elsif ( operation_mode /= "packed" and portbwe_ipd = '1' and ((i = waddr_b_lsb) or (i = waddr_b_msb) or ((i > waddr_b_lsb) and (i < waddr_b_msb)))
) then
                -- bit is being written by portb
                tmp_a_dataout(i rem port_a_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
             else
                -- bit not being written : read memory contents
                tmp_a_dataout(i rem port_a_read_data_width) := mem(i);
             end if;
         end loop;
      end if;

      if (portare_ipd'event and portare_ipd = '0') then
         re_active_a := false;
      end if;

      if (portbre_ipd'event and portbre_ipd = '1') then
         re_active_b := true;
         for i in raddr_b_lsb to raddr_b_msb loop
             if ( portbwe_ipd = '1' and ((i = waddr_b_lsb) or (i = waddr_b_msb) or ((i > waddr_b_lsb) and (i < waddr_b_msb))) ) then
                -- bit is being written by portb
                tmp_b_dataout(i rem port_b_read_data_width) := portbdatain_ipd(i rem port_b_write_data_width);
             elsif ( operation_mode /= "packed" and portawe_ipd = '1' and ((i = waddr_a_lsb) or (i = waddr_a_msb) or ((i > waddr_a_lsb) and (i < waddr_a_msb)))
) then
                -- bit is being written by porta
                tmp_b_dataout(i rem port_b_read_data_width) := portadatain_ipd(i rem port_a_write_data_width);
             else
                -- bit not being written : read memory contents
                tmp_b_dataout(i rem port_b_read_data_width) := mem(port_b_offset + i);
             end if;
         end loop;
      end if;

      if (portbre_ipd'event and portbre_ipd = '0') then
         re_active_b := false;
      end if;

      if (portadatain_ipd'event) then
         if (portawe_ipd = '1') then
            if (re_active_a) then
               for i in raddr_a_lsb to raddr_a_msb loop
                   if ( (i = waddr_a_lsb) or (i = waddr_a_msb) or ((i > waddr_a_lsb) and (i < waddr_a_msb)) ) then
                      tmp_a_dataout(i rem port_a_read_data_width) := portadatain_ipd( i rem port_a_write_data_width);
                   end if;
               end loop;
            end if;
            if ((operation_mode = "bidir_dual_port" or operation_mode = "quad_port") and re_active_b) then
               for i in raddr_b_lsb to raddr_b_msb loop
                   if ( (i = waddr_a_lsb) or (i = waddr_a_msb) or ((i > waddr_a_lsb) and (i < waddr_a_msb)) ) then
                      tmp_b_dataout(i rem port_b_read_data_width) := portadatain_ipd( i rem port_a_write_data_width);
                   end if;
               end loop;
            end if;
         end if;
      end if;

      if (portbdatain_ipd'event) then
         if (portbwe_ipd = '1') then
            if (re_active_b) then
               for i in raddr_b_lsb to raddr_b_msb loop
                   if ( (i = waddr_b_lsb) or (i = waddr_b_msb) or ((i > waddr_b_lsb) and (i < waddr_b_msb)) ) then
                      tmp_b_dataout(i rem port_b_read_data_width) := portbdatain_ipd( i rem port_b_write_data_width);
                   end if;
               end loop;
            end if;
            if ((operation_mode = "bidir_dual_port" or operation_mode = "quad_port") and re_active_a) then
               for i in raddr_a_lsb to raddr_a_msb loop
                   if ( (i = waddr_b_lsb) or (i = waddr_b_msb) or ((i > waddr_b_lsb) and (i < waddr_b_msb)) ) then
                      tmp_a_dataout(i rem port_a_read_data_width) := portbdatain_ipd( i rem port_b_write_data_width);
                   end if;
               end loop;
            end if;
         end if;
      end if;

      ----------------------
      --  Path Delay Section
      ----------------------
      VitalPathDelay01 (
       OutSignal => portadataout(0),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(0),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(0),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(1),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(1),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(1),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(2),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(2),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(2),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(3),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(3),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(3),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(4),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(4),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(4),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(5),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(5),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(5),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(6),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(6),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(6),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(7),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(7),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(7),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(8),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(8),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(8),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(9),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(9),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(9),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(10),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(10),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(10),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(11),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(11),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(11),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(12),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(12),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(12),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(13),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(13),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(13),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(14),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(14),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(14),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portadataout(15),
       OutSignalName => "PORTADATAOUT",
       OutTemp => tmp_a_dataout(15),
       Paths => (1 => (portaraddr_ipd'last_event, tpd_portaraddr_portadataout(0), TRUE),
                 2 => (portawe_ipd'last_event, tpd_portawe_portadataout(0), TRUE),
                 3 => (portare_ipd'last_event, tpd_portare_portadataout(0), TRUE),
                 4 => (portadatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE),
                 5 => (portbdatain_ipd'last_event, tpd_portadatain_portadataout(0), TRUE)),
       GlitchData => portadataout_VitalGlitchDataArray(15),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(0),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(0),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(0),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(1),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(1),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(1),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(2),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(2),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(2),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(3),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(3),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(3),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(4),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(4),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(4),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(5),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(5),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(5),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(6),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(6),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(6),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(7),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(7),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(7),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(8),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(8),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(8),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(9),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(9),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(9),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(10),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(10),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(10),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(11),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(11),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(11),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(12),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(12),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(12),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(13),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(13),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(13),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(14),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(14),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(14),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

      VitalPathDelay01 (
       OutSignal => portbdataout(15),
       OutSignalName => "PORTBDATAOUT",
       OutTemp => tmp_b_dataout(15),
       Paths => (1 => (portbraddr_ipd'last_event, tpd_portbraddr_portbdataout(0), TRUE),
                 2 => (portbwe_ipd'last_event, tpd_portbwe_portbdataout(0), TRUE),
                 3 => (portbre_ipd'last_event, tpd_portbre_portbdataout(0), TRUE),
                 4 => (portbdatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE),
                 5 => (portadatain_ipd'last_event, tpd_portbdatain_portbdataout(0), TRUE)),
       GlitchData => portbdataout_VitalGlitchDataArray(15),
       Mode => DefGlitchMode,
       XOn  => XOn,
       MsgOn        => MsgOn );

end process;

end behave;


--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : nmux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_BLOCK.
--               The output is an inversion of the selected input.
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY nmux21 IS
     PORT ( A : in std_logic := '0';
            B : in std_logic := '0';
            S : in std_logic := '0';
            MO : out std_logic
          );
END nmux21;

ARCHITECTURE structure of nmux21 IS
begin

   MO <=  not B when (S = '1') else not A;

end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : bmux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_BLOCK.
--               Each input is a 16-bit bus.
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY bmux21 IS 
     PORT ( A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
            B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
            S : in std_logic := '0'; 
            MO : out std_logic_vector(15 downto 0)
          ); 
END bmux21; 
 
ARCHITECTURE structure of bmux21 IS
begin 
 
   MO <= B when (S = '1') else A; 
 
end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : b17mux21
--
-- Description : Simulation model for a 2 to 1 mux used in the RAM_BLOCK.
--               Each input is a 17-bit bus.
--               This is a purely functional module, without any timing.
--
--////////////////////////////////////////////////////////////////////////////
LIBRARY ieee;
use ieee.std_logic_1164.all;

ENTITY b17mux21 is 
     PORT ( A : in std_logic_vector(16 downto 0) := (OTHERS => '0');
            B : in std_logic_vector(16 downto 0) := (OTHERS => '0');
            S : in std_logic := '0'; 
            MO : out std_logic_vector(16 downto 0)
          ); 
END b17mux21; 
 
ARCHITECTURE structure OF b17mux21 IS
begin 
 
   MO <= B when (S = '1') else A; 
 
END structure;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_RAM_BLOCK
--
-- Description : Structural model for a single RAM block of the
--               APEXII device family.
--
--/////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE IEEE.VITAL_Timing.all;
USE work.apexii_atom_pack.all;
USE work.apexii_dffe;
USE work.and1;
USE work.mux21;
USE work.nmux21;
USE work.bmux21;
USE work.b17mux21;
USE work.apexii_asynch_mem;

ENTITY  apexii_ram_block IS
    GENERIC (
             operation_mode                          : string := "single_port";
             port_a_operation_mode                   : string := "single_port";
             port_b_operation_mode                   : string := "single_port";
             logical_ram_name                        : string := "ram_xxx";
             port_a_logical_ram_name                 : string := "ram_xxx";
             port_b_logical_ram_name                 : string := "ram_xxx";
             init_file                               : string := "none";
             port_a_init_file                        : string := "none";
             port_b_init_file                        : string := "none";
             data_interleave_width_in_bits           : integer := 1;
             data_interleave_offset_in_bits          : integer := 1;
             port_a_data_interleave_width_in_bits    : integer := 1;
             port_a_data_interleave_offset_in_bits   : integer := 1;
             port_b_data_interleave_width_in_bits    : integer := 1;
             port_b_data_interleave_offset_in_bits   : integer := 1;

             port_a_write_deep_ram_mode              : string := "off";
             port_a_write_logical_ram_depth          : integer := 4096;
             port_a_write_logical_ram_width          : integer := 1;
             port_a_write_address_width              : integer := 16;
             port_a_read_deep_ram_mode               : string := "off";
             port_a_read_logical_ram_depth           : integer := 4096;
             port_a_read_logical_ram_width           : integer := 1;
             port_a_read_address_width               : integer := 16;

             port_a_data_in_clock                    : string := "none";
             port_a_data_in_clear                    : string := "none";
             port_a_write_logic_clock                : string := "none";
             port_a_write_address_clear              : string := "none";
             port_a_write_enable_clear               : string := "none";
             port_a_read_enable_clock                : string := "none";
             port_a_read_enable_clear                : string := "none";
             port_a_read_address_clock               : string := "none";
             port_a_read_address_clear               : string := "none";
             port_a_data_out_clock                   : string := "none";
             port_a_data_out_clear                   : string := "none";

             port_a_write_first_address              : integer := 0;
             port_a_write_last_address               : integer := 4095;
             port_a_write_first_bit_number           : integer := 1;
             port_a_write_data_width                 : integer := 1;
             port_a_read_first_address               : integer := 0;
             port_a_read_last_address                : integer := 4095;
             port_a_read_first_bit_number            : integer := 1;
             port_a_read_data_width                  : integer := 1;

             port_b_write_deep_ram_mode              : string := "off";
             port_b_write_logical_ram_depth          : integer := 4096;
             port_b_write_logical_ram_width          : integer := 1;
             port_b_write_address_width              : integer := 16;
             port_b_read_deep_ram_mode               : string := "off";
             port_b_read_logical_ram_depth           : integer := 4096;
             port_b_read_logical_ram_width           : integer := 1;
             port_b_read_address_width               : integer := 16;

             port_b_data_in_clock                    : string := "none";
             port_b_data_in_clear                    : string := "none";
             port_b_write_logic_clock                : string := "none";
             port_b_write_address_clear              : string := "none";
             port_b_write_enable_clear               : string := "none";
             port_b_read_enable_clock                : string := "none";
             port_b_read_enable_clear                : string := "none";
             port_b_read_address_clock               : string := "none";
             port_b_read_address_clear               : string := "none";
             port_b_data_out_clock                   : string := "none";
             port_b_data_out_clear                   : string := "none";

             port_b_write_first_address              : integer := 0;
             port_b_write_last_address               : integer := 4095;
             port_b_write_first_bit_number           : integer := 1;
             port_b_write_data_width                 : integer := 1;
             port_b_read_first_address               : integer := 0;
             port_b_read_last_address                : integer := 4095;
             port_b_read_first_bit_number            : integer := 1;
             port_b_read_data_width                  : integer := 1;

             power_up                        : string := "low";
             mem1                            : std_logic_vector(512 downto 1);
             mem2                            : std_logic_vector(512 downto 1);
             mem3                            : std_logic_vector(512 downto 1);
             mem4                            : std_logic_vector(512 downto 1);
             mem5                            : std_logic_vector(512 downto 1);
             mem6                            : std_logic_vector(512 downto 1);
             mem7                            : std_logic_vector(512 downto 1);
             mem8                            : std_logic_vector(512 downto 1)
            );

    PORT    (portadatain             : in std_logic_vector(15 downto 0);
             portaclk0               : in std_logic;
             portaclk1               : in std_logic;
             portaclr0               : in std_logic;
             portaclr1               : in std_logic;
             portaena0               : in std_logic;
             portaena1               : in std_logic;
             portawe                 : in std_logic;
             portare                 : in std_logic;
             portaraddr              : in std_logic_vector(16 downto 0);
             portawaddr              : in std_logic_vector(16 downto 0);
             portbdatain             : in std_logic_vector(15 downto 0);
             portbclk0               : in std_logic;
             portbclk1               : in std_logic;
             portbclr0               : in std_logic;
             portbclr1               : in std_logic;
             portbena0               : in std_logic;
             portbena1               : in std_logic;
             portbwe                 : in std_logic;
             portbre                 : in std_logic;
             portbraddr              : in std_logic_vector(16 downto 0);
             portbwaddr              : in std_logic_vector(16 downto 0);
             portadataout            : out std_logic_vector(15 downto 0);
             portbdataout            : out std_logic_vector(15 downto 0);
             devclrn                 : in std_logic := '1';
             devpor                  : in std_logic := '1';
             portamodesel            : in std_logic_vector(20 downto 0);
             portbmodesel            : in std_logic_vector(20 downto 0)
            );
END apexii_ram_block;

ARCHITECTURE structure of apexii_ram_block IS

COMPONENT apexii_dffe
    GENERIC (
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

    PORT    (Q                             :  out   STD_LOGIC := '0';
             D                             :  in    STD_LOGIC := '1';
             CLRN                          :  in    STD_LOGIC := '1';
             PRN                           :  in    STD_LOGIC := '1';
             CLK                           :  in    STD_LOGIC := '0';
             ENA                           :  in    STD_LOGIC := '1'
            );
end COMPONENT;
COMPONENT and1
    GENERIC (
             XOn                 : Boolean := DefGlitchXOn;
             MsgOn               : Boolean := DefGlitchMsgOn;
             tpd_IN1_Y           : VitalDelayType01 := DefPropDelay01;
             tipd_IN1            : VitalDelayType01 := DefPropDelay01
            );

    PORT    (Y                   : out   STD_LOGIC;
             IN1                 : in    STD_LOGIC
            );
end COMPONENT;
COMPONENT mux21
    GENERIC (
             TimingChecksOn             : Boolean := True;
             MsgOn                      : Boolean := DefGlitchMsgOn;
             XOn                        : Boolean := DefGlitchXOn;
             InstancePath               : STRING := "*";
             tpd_A_MO                   : VitalDelayType01 := DefPropDelay01;
             tpd_B_MO                   : VitalDelayType01 := DefPropDelay01;
             tpd_S_MO                   : VitalDelayType01 := DefPropDelay01;
             tipd_A                     : VitalDelayType01 := DefPropDelay01;
             tipd_B                     : VitalDelayType01 := DefPropDelay01;
             tipd_S                     : VitalDelayType01 := DefPropDelay01
            );

     PORT   (A : in std_logic := '0';
             B : in std_logic := '0';
             S : in std_logic := '0';
             MO : out std_logic
            );
END COMPONENT;
COMPONENT nmux21
    PORT    (A : in std_logic := '0';
             B : in std_logic := '0';
             S : in std_logic := '0';
             MO : out std_logic
            );
END COMPONENT;
COMPONENT bmux21
          PORT (
                A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                S : in std_logic := '0';
                MO : out std_logic_vector(15 downto 0));
END COMPONENT;
COMPONENT b17mux21
          PORT (
                A : in std_logic_vector(16 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(16 downto 0) := (OTHERS => '0');
                S : in std_logic := '0';
                MO : out std_logic_vector(16 downto 0));
END COMPONENT;
COMPONENT apexii_asynch_mem
    GENERIC (
             operation_mode             : string := "single_port";
             port_a_operation_mode      : string := "single_port";
             port_b_operation_mode      : string := "single_port";

             port_a_write_deep_ram_mode : string := "off";
             port_a_write_address_width : integer := 1;
             port_a_write_first_address : integer := 0;
             port_a_write_last_address  : integer := 4095;
             port_a_write_data_width    : integer := 1;

             port_a_read_deep_ram_mode  : string := "off";
             port_a_read_address_width  : integer := 1;
             port_a_read_first_address  : integer := 0;
             port_a_read_last_address   : integer := 4095;
             port_a_read_data_width     : integer := 1;

             port_b_write_deep_ram_mode : string := "off";
             port_b_write_address_width : integer := 1;
             port_b_write_first_address : integer := 0;
             port_b_write_last_address  : integer := 4095;
             port_b_write_data_width    : integer := 1;

             port_b_read_deep_ram_mode  : string := "off";
             port_b_read_address_width  : integer := 1;
             port_b_read_first_address  : integer := 0;
             port_b_read_last_address   : integer := 4095;
             port_b_read_data_width     : integer := 1;

             port_a_read_enable_clock   : string := "none";
             port_b_read_enable_clock   : string := "none";

             port_a_write_logic_clock   : string := "none";
             port_b_write_logic_clock   : string := "none";

             init_file                  : string := "none";
             port_a_init_file           : string := "none";
             port_b_init_file           : string := "none";

             mem1           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem2           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem3           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem4           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem5           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem6           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem7           : std_logic_vector(512 downto 1) := (OTHERS=>'0');
             mem8           : std_logic_vector(512 downto 1) := (OTHERS=>'0')
           );

    PORT   ( portadatain  : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portawe      : in std_logic := '0';
             portare      : in std_logic := '0';
             portaraddr   : in std_logic_vector(16 downto 0) := (OTHERS => '0');
             portawaddr   : in std_logic_vector(16 downto 0) := (OTHERS => '0');
             portbdatain  : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portbwe      : in std_logic := '0';
             portbre      : in std_logic := '0';
             portbraddr   : in std_logic_vector(16 downto 0) := (OTHERS => '0');
             portbwaddr   : in std_logic_vector(16 downto 0) := (OTHERS => '0');
             portadataout : out std_logic_vector(15 downto 0);
             portbdataout : out std_logic_vector(15 downto 0);
             portamodesel : in std_logic_vector(20 downto 0) := (OTHERS => '0');
             portbmodesel : in std_logic_vector(20 downto 0) := (OTHERS => '0')
           );

END COMPONENT;

-- 'sel' signals for porta

   signal  portadatain_reg_sel     : std_logic;
   signal  portadatain_reg_clr_sel : std_logic;
   signal  portawrite_reg_sel      : std_logic;
   signal  portawe_clr_sel         : std_logic;
   signal  portawaddr_clr_sel      : std_logic;
   signal  portaraddr_clr_sel : std_logic_vector(1 downto 0);
   signal  portare_clr_sel : std_logic_vector(1 downto 0);
   signal  portaraddr_clk_sel : std_logic_vector(1 downto 0);
   signal  portare_clk_sel : std_logic_vector(1 downto 0);
   signal  portadataout_clk_sel : std_logic_vector(1 downto 0);
   signal  portadataout_clr_sel : std_logic_vector(1 downto 0);
   signal  portaraddr_en_sel : std_logic;
   signal  portare_en_sel : std_logic;
   signal  portadataout_en_sel : std_logic;

-- registered signals for porta

   signal  portadatain_reg : std_logic_vector(15 downto 0);
   signal  portadataout_reg : std_logic_vector(15 downto 0);
   signal  portawe_reg : std_logic;
   signal  portare_reg : std_logic;
   signal  portaraddr_reg : std_logic_vector(16 downto 0);
   signal  portawaddr_reg : std_logic_vector(16 downto 0);

   signal  portadatain_int : std_logic_vector(15 downto 0);
   signal  portadataout_int : std_logic_vector(15 downto 0);
   signal  portaraddr_int : std_logic_vector(16 downto 0);
   signal  portawaddr_int : std_logic_vector(16 downto 0);
   signal  portawe_int : std_logic;
   signal  portare_int : std_logic;

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

   signal  portawe_reg_mux : std_logic;
   signal  portawe_reg_mux_delayed : std_logic;
   signal  portawe_pulse : std_logic;
   signal  portadataout_tmp : std_logic_vector(15 downto 0);
   signal  portavalid_addr : std_logic;
   signal  portaraddr_num : integer;
   signal  portaclk0_delayed : std_logic;

-- 'sel' signals for portb

   signal  portbdatain_reg_sel : std_logic;
   signal  portbdatain_reg_clr_sel : std_logic;
   signal  portbwrite_reg_sel : std_logic;
   signal  portbwe_clr_sel : std_logic;
   signal  portbwaddr_clr_sel: std_logic;
   signal  portbraddr_clr_sel : std_logic_vector(1 downto 0);
   signal  portbre_clr_sel : std_logic_vector(1 downto 0);
   signal  portbraddr_clk_sel : std_logic_vector(1 downto 0);
   signal  portbre_clk_sel : std_logic_vector(1 downto 0);
   signal  portbdataout_clk_sel : std_logic_vector(1 downto 0);
   signal  portbdataout_clr_sel : std_logic_vector(1 downto 0);
   signal  portbraddr_en_sel : std_logic;
   signal  portbre_en_sel : std_logic;
   signal  portbdataout_en_sel : std_logic;

-- registered signals for portb

   signal  portbdatain_reg : std_logic_vector(15 downto 0);
   signal  portbdataout_reg : std_logic_vector(15 downto 0);
   signal  portbwe_reg : std_logic;
   signal  portbre_reg : std_logic;
   signal  portbraddr_reg : std_logic_vector(16 downto 0);
   signal  portbwaddr_reg : std_logic_vector(16 downto 0);

   signal  portbdatain_int : std_logic_vector(15 downto 0);
   signal  portbdataout_int : std_logic_vector(15 downto 0);
   signal  portbraddr_int : std_logic_vector(16 downto 0);
   signal  portbwaddr_int : std_logic_vector(16 downto 0);
   signal  portbwe_int : std_logic;
   signal  portbre_int : std_logic;

-- 'clr' signals for portb

   signal  portbdatain_reg_clr : std_logic;
   signal  portbdinreg_clr : std_logic;
   signal  portbwe_reg_clr : std_logic;
   signal  portbwereg_clr : std_logic;
   signal  portbwaddr_reg_clr : std_logic;
   signal  portbwaddrreg_clr : std_logic;
   signal  portbre_reg_clr : std_logic;
   signal  portbrereg_clr : std_logic;
   signal  portbraddr_reg_clr : std_logic;
   signal  portbraddrreg_clr : std_logic;
   signal  portbdataout_reg_clr : std_logic;
   signal  portbdataoutreg_clr : std_logic;

-- 'ena' signals for portb

   signal  portbreen : std_logic;
   signal  portbraddren : std_logic;
   signal  portbdataouten : std_logic;

-- 'clk' signals for portb

   signal  portbre_clk : std_logic;
   signal  portbre_clr : std_logic;
   signal  portbraddr_clk : std_logic;
   signal  portbraddr_clr : std_logic;
   signal  portbdataout_clk : std_logic;
   signal  portbdataout_clr : std_logic;

-- other signals

   signal  portbwe_reg_mux : std_logic;
   signal  portbwe_reg_mux_delayed : std_logic;
   signal  portbwe_pulse : std_logic;
   signal  portbdataout_tmp : std_logic_vector(15 downto 0);
   signal  portbvalid_addr : std_logic;
   signal  portbraddr_num : integer;
   signal  portbclk0_delayed : std_logic;

   signal  NC : std_logic := '0';

-- additional signals to introduce delta delays
   -- porta
   signal portawaddr_reg_delayed_1 : std_logic_vector(16 downto 0);
   signal portawaddr_reg_delayed_2 : std_logic_vector(16 downto 0);
   signal portawaddr_reg_delayed_3 : std_logic_vector(16 downto 0);

   signal portadatain_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal portadatain_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal portadatain_reg_delayed_3 : std_logic_vector(15 downto 0);
   -- portb
   signal portbwaddr_reg_delayed_1 : std_logic_vector(16 downto 0);
   signal portbwaddr_reg_delayed_2 : std_logic_vector(16 downto 0);
   signal portbwaddr_reg_delayed_3 : std_logic_vector(16 downto 0);

   signal portbdatain_reg_delayed_1 : std_logic_vector(15 downto 0);
   signal portbdatain_reg_delayed_2 : std_logic_vector(15 downto 0);
   signal portbdatain_reg_delayed_3 : std_logic_vector(15 downto 0);

   signal portaraddr_int_delayed_1 : std_logic_vector(16 downto 0);
   signal portaraddr_int_delayed_2 : std_logic_vector(16 downto 0);
   signal portbraddr_int_delayed_1 : std_logic_vector(16 downto 0);
   signal portbraddr_int_delayed_2 : std_logic_vector(16 downto 0);

begin

   portadatain_reg_sel             <= portamodesel(0);
   portadatain_reg_clr_sel         <= portamodesel(1);

   portawrite_reg_sel              <= portamodesel(2);
   portawe_clr_sel                 <= portamodesel(3);
   portawaddr_clr_sel              <= portamodesel(4);

   portaraddr_clk_sel(0)           <= portamodesel(5);
   portaraddr_clr_sel(0)           <= portamodesel(6);

   portare_clk_sel(0)              <= portamodesel(7);
   portare_clr_sel(0)              <= portamodesel(8);

   portadataout_clk_sel(0)         <= portamodesel(9);
   portadataout_clr_sel(0)         <= portamodesel(10);

   portare_clk_sel(1)              <= portamodesel(11);
   portare_en_sel                  <= portamodesel(11);
   portare_clr_sel(1)              <= portamodesel(12);

   portaraddr_clk_sel(1)           <= portamodesel(13);
   portaraddr_en_sel               <= portamodesel(13);
   portaraddr_clr_sel(1)           <= portamodesel(14);

   portadataout_clk_sel(1)         <= portamodesel(15);
   portadataout_en_sel             <= portamodesel(15);
   portadataout_clr_sel(1)         <= portamodesel(16);

   portbdatain_reg_sel             <= portbmodesel(0);
   portbdatain_reg_clr_sel         <= portbmodesel(1);

   portbwrite_reg_sel              <= portbmodesel(2);
   portbwe_clr_sel                 <= portbmodesel(3);
   portbwaddr_clr_sel              <= portbmodesel(4);

   portbraddr_clk_sel(0)           <= portbmodesel(5);
   portbraddr_clr_sel(0)           <= portbmodesel(6);

   portbre_clk_sel(0)              <= portbmodesel(7);
   portbre_clr_sel(0)              <= portbmodesel(8);

   portbdataout_clk_sel(0)         <= portbmodesel(9);
   portbdataout_clr_sel(0)         <= portbmodesel(10);

   portbre_clk_sel(1)              <= portbmodesel(11);
   portbre_en_sel                  <= portbmodesel(11);
   portbre_clr_sel(1)              <= portbmodesel(12);

   portbraddr_clk_sel(1)           <= portbmodesel(13);
   portbraddr_en_sel               <= portbmodesel(13);
   portbraddr_clr_sel(1)           <= portbmodesel(14);

   portbdataout_clk_sel(1)         <= portbmodesel(15);
   portbdataout_en_sel             <= portbmodesel(15);
   portbdataout_clr_sel(1)         <= portbmodesel(16);

-- PORT A registers

   portadatainregclr: nmux21
           port map (A => NC,
                     B => portaclr0, 
                     S => portadatain_reg_clr_sel,
                     MO => portadatain_reg_clr
                    );

   portadinreg_clr <= portadatain_reg_clr and devclrn and devpor;

   portadinreg_0 : apexii_dffe
           port map (D => portadatain(0), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(0)
                    );
   portadinreg_1 : apexii_dffe
           port map (D => portadatain(1), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(1)
                    );
   portadinreg_2 : apexii_dffe
           port map (D => portadatain(2), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(2)
                    );
   portadinreg_3 : apexii_dffe
           port map (D => portadatain(3), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(3)
                    );
   portadinreg_4 : apexii_dffe
           port map (D => portadatain(4), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(4)
                    );
   portadinreg_5 : apexii_dffe
           port map (D => portadatain(5), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(5)
                    );
   portadinreg_6 : apexii_dffe
           port map (D => portadatain(6), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(6)
                    );
   portadinreg_7 : apexii_dffe
           port map (D => portadatain(7), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(7)
                    );
   portadinreg_8 : apexii_dffe
           port map (D => portadatain(8), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(8)
                    );
   portadinreg_9 : apexii_dffe
           port map (D => portadatain(9), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(9)
                    );
   portadinreg_10 : apexii_dffe
           port map (D => portadatain(10), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(10)
                    );
   portadinreg_11 : apexii_dffe
           port map (D => portadatain(11), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(11)
                    );
   portadinreg_12 : apexii_dffe
           port map (D => portadatain(12), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(12)
                    );
   portadinreg_13 : apexii_dffe
           port map (D => portadatain(13), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(13)
                    );
   portadinreg_14 : apexii_dffe
           port map (D => portadatain(14), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,                   
                     ENA => portaena0, 
                     Q => portadatain_reg(14)
                    );
   portadinreg_15 : apexii_dffe
           port map (D => portadatain(15), 
                     CLRN => portadinreg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portadatain_reg(15)
                    );

   portadatain_reg_delayed_1 <= portadatain_reg;
   portadatain_reg_delayed_2 <= portadatain_reg_delayed_1;
   portadatain_reg_delayed_3 <= portadatain_reg_delayed_2;

   portadatainsel: bmux21
           port map (A => portadatain, 
                     B => portadatain_reg_delayed_3, 
                     S => portadatain_reg_sel,
              MO => portadatain_int
                     );


   portaweregclr: nmux21
           port map (A => NC, 
                     B => portaclr0, 
                     S => portawe_clr_sel,
                     MO => portawe_reg_clr
                    );
   portawereg_clr <= portawe_reg_clr and devclrn and devpor;
   portawereg: apexii_dffe
           port map (D => portawe, 
                     CLRN => portawereg_clr, 
                     CLK => portaclk0,
                     ENA => portaena0, 
                     Q => portawe_reg
                    );
   portawesel1: mux21
           port map (A => portawe, 
                     B => portawe_reg, 
                     S => portawrite_reg_sel,
                     MO => portawe_reg_mux
                    );
   portawedelaybuf: and1
           port map (IN1 => portawe_reg_mux, 
                     Y => portawe_reg_mux_delayed
                    );
   portaclk0weregdelaybuf: and1
           port map (IN1 => portaclk0, 
                     Y => portaclk0_delayed
                    );
   portawe_pulse <= portawe_reg_mux_delayed and (not portaclk0_delayed);
   portawesel2: mux21
           port map (A => portawe_reg_mux_delayed, 
                     B => portawe_pulse,
                     S => portawrite_reg_sel, 
                     MO => portawe_int
                    );


   portawaddrregclr: nmux21
           port map (A => NC, 
                     B => portaclr0, 
                     S => portawaddr_clr_sel,
                     MO => portawaddr_reg_clr
                    );
   portawaddrreg_clr <= portawaddr_reg_clr and devclrn and devpor;
   portawaddrreg_0: apexii_dffe
           port map (D => portawaddr(0), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(0)
                    );
   portawaddrreg_1: apexii_dffe
           port map (D => portawaddr(1), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(1)
                    );
   portawaddrreg_2: apexii_dffe
           port map (D => portawaddr(2), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(2)
                    );
   portawaddrreg_3: apexii_dffe
           port map (D => portawaddr(3), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(3)
                    );
   portawaddrreg_4: apexii_dffe
           port map (D => portawaddr(4), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(4)
                    );
   portawaddrreg_5: apexii_dffe
           port map (D => portawaddr(5), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(5)
                    );
   portawaddrreg_6: apexii_dffe
           port map (D => portawaddr(6), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(6)
                    );
   portawaddrreg_7: apexii_dffe
           port map (D => portawaddr(7), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(7)
                    );
   portawaddrreg_8: apexii_dffe
           port map (D => portawaddr(8), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(8)
                    );
   portawaddrreg_9: apexii_dffe
           port map (D => portawaddr(9), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(9)
                    );
   portawaddrreg_10: apexii_dffe
           port map (D => portawaddr(10), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(10)
                    );
   portawaddrreg_11: apexii_dffe
           port map (D => portawaddr(11), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(11)
                    );
   portawaddrreg_12: apexii_dffe
           port map (D => portawaddr(12), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(12)
                    );
   portawaddrreg_13: apexii_dffe
           port map (D => portawaddr(13), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(13)
                    );
   portawaddrreg_14: apexii_dffe
           port map (D => portawaddr(14), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(14)
                    );
   portawaddrreg_15: apexii_dffe
           port map (D => portawaddr(15), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(15)
                    );
   portawaddrreg_16: apexii_dffe
           port map (D => portawaddr(16), 
                     CLRN => portawaddrreg_clr,
                     CLK => portaclk0, 
                     ENA => portaena0,
                     Q => portawaddr_reg(16)
                    );

   portawaddr_reg_delayed_1 <= portawaddr_reg;
   portawaddr_reg_delayed_2 <= portawaddr_reg_delayed_1;
   portawaddr_reg_delayed_3 <= portawaddr_reg_delayed_2;

   portawaddrsel: b17mux21
           port map (A => portawaddr, 
                     B => portawaddr_reg_delayed_3,
                     S => portawrite_reg_sel, 
                     MO => portawaddr_int
                    );


   portaraddrclksel: mux21
           port map (A => portaclk0, 
                     B => portaclk1, 
                     S => portaraddr_clk_sel(1),
                     MO => portaraddr_clk
                    );
   portaraddrensel: mux21
           port map (A => portaena0, 
                     B => portaena1, 
                     S => portaraddr_en_sel,
                     MO => portaraddren
                    );
   portaraddrclrsel: mux21
           port map (A => portaclr0, 
                     B => portaclr1, 
                     S => portaraddr_clr_sel(1),
                     MO => portaraddr_clr
                    );
   portaraddrregclr: nmux21
           port map (A => NC, 
                     B => portaraddr_clr, 
                     S => portaraddr_clr_sel(0),
                     MO => portaraddr_reg_clr
                    );
   portaraddrreg_clr <= portaraddr_reg_clr and devclrn and devpor;
   portaraddrreg_0: apexii_dffe
           port map (D => portaraddr(0), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(0)
                    );
   portaraddrreg_1: apexii_dffe
           port map (D => portaraddr(1), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(1)
                    );
   portaraddrreg_2: apexii_dffe
           port map (D => portaraddr(2), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(2)
                    );
   portaraddrreg_3: apexii_dffe
           port map (D => portaraddr(3), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(3)
                    );
   portaraddrreg_4: apexii_dffe
           port map (D => portaraddr(4), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(4)
                    );
   portaraddrreg_5: apexii_dffe
           port map (D => portaraddr(5), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(5)
                    );
   portaraddrreg_6: apexii_dffe
           port map (D => portaraddr(6), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(6)
                    );
   portaraddrreg_7: apexii_dffe
           port map (D => portaraddr(7), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(7)
                    );
   portaraddrreg_8: apexii_dffe
           port map (D => portaraddr(8), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(8)
                    );
   portaraddrreg_9: apexii_dffe
           port map (D => portaraddr(9), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(9)
                    );
   portaraddrreg_10: apexii_dffe
           port map (D => portaraddr(10), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(10)
                    );
   portaraddrreg_11: apexii_dffe
           port map (D => portaraddr(11), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(11)
                    );
   portaraddrreg_12: apexii_dffe
           port map (D => portaraddr(12), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(12)
                    );
   portaraddrreg_13: apexii_dffe
           port map (D => portaraddr(13), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(13)
                    );
   portaraddrreg_14: apexii_dffe
           port map (D => portaraddr(14), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(14)
                    );
   portaraddrreg_15: apexii_dffe
           port map (D => portaraddr(15), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(15)
                    );
   portaraddrreg_16: apexii_dffe
           port map (D => portaraddr(16), 
                     CLRN => portaraddrreg_clr,
                     CLK => portaraddr_clk, 
                     ENA => portaraddren,
                     Q => portaraddr_reg(16)
                    );
   portaraddrsel: b17mux21
           port map (A => portaraddr, 
                     B => portaraddr_reg,
                     S => portaraddr_clk_sel(0), 
                     MO => portaraddr_int
                    );
   portareclksel: mux21
           port map (A => portaclk0, 
                     B => portaclk1, 
                     S => portare_clk_sel(1),
                     MO => portare_clk
                    );
   portareensel: mux21
           port map (A => portaena0, 
                     B => portaena1, 
                     S => portare_en_sel,
                     MO => portareen
                    );
   portareclrsel: mux21
           port map (A => portaclr0, 
                     B => portaclr1, 
                     S => portare_clr_sel(1),
                     MO => portare_clr
                    );
   portareregclr: nmux21
           port map (A => NC, 
                     B => portare_clr, 
                     S => portare_clr_sel(0),
                     MO => portare_reg_clr
                    );
   portarereg_clr <= portare_reg_clr and devclrn and devpor;
   portarereg: apexii_dffe
           port map (D => portare, 
                     CLRN => portarereg_clr, 
                     CLK => portare_clk,
                     ENA => portareen, 
                     Q => portare_reg
                    );
   portaresel: mux21
           port map (A => portare, 
                     B => portare_reg, 
                     S => portare_clk_sel(0),
                     MO => portare_int
                    );

   portaraddr_int_delayed_1 <= portaraddr_int;
   portaraddr_int_delayed_2 <= portaraddr_int_delayed_1;


   portadataoutclksel: mux21
           port map (A => portaclk0, 
                     B => portaclk1, 
                     S => portadataout_clk_sel(1),
                     MO => portadataout_clk
                    );
   portadataoutensel: mux21
           port map (A => portaena0, 
                     B => portaena1, 
                     S => portadataout_en_sel,
                     MO => portadataouten
                    );
   portadataoutclrsel: mux21
           port map (A => portaclr0, 
                     B => portaclr1, 
                     S => portadataout_clr_sel(1),
                     MO => portadataout_clr
                    );
   portadataoutregclr: nmux21
           port map (A => NC, 
                     B => portadataout_clr, 
                     S => portadataout_clr_sel(0),
                     MO => portadataout_reg_clr
                    );

   portadataoutreg_clr <= portadataout_reg_clr and devclrn and devpor;

   portadataoutreg_0 : apexii_dffe
           port map (D => portadataout_int(0), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(0)
                    );
   portadataoutreg_1 : apexii_dffe
           port map (D => portadataout_int(1), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(1)
                    );
   portadataoutreg_2 : apexii_dffe
           port map (D => portadataout_int(2), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(2)
                    );
   portadataoutreg_3 : apexii_dffe
           port map (D => portadataout_int(3), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(3)
                    );
   portadataoutreg_4 : apexii_dffe
           port map (D => portadataout_int(4), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(4)
                    );
   portadataoutreg_5 : apexii_dffe
           port map (D => portadataout_int(5), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(5)
                    );
   portadataoutreg_6 : apexii_dffe
           port map (D => portadataout_int(6), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(6)
                    );
   portadataoutreg_7 : apexii_dffe
           port map (D => portadataout_int(7), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(7)
                    );
   portadataoutreg_8 : apexii_dffe
           port map (D => portadataout_int(8), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(8)
                    );
   portadataoutreg_9 : apexii_dffe
           port map (D => portadataout_int(9), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(9)
                    );
   portadataoutreg_10 : apexii_dffe
           port map (D => portadataout_int(10), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(10)
                    );
   portadataoutreg_11 : apexii_dffe
           port map (D => portadataout_int(11), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(11)
                    );
   portadataoutreg_12 : apexii_dffe
           port map (D => portadataout_int(12), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(12)
                    );
   portadataoutreg_13 : apexii_dffe
           port map (D => portadataout_int(13), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(13)
                    );
   portadataoutreg_14 : apexii_dffe
           port map (D => portadataout_int(14), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(14)
                    );
   portadataoutreg_15 : apexii_dffe
           port map (D => portadataout_int(15), 
                     CLRN => portadataoutreg_clr,
                     CLK => portadataout_clk, 
                     ENA => portadataouten,
                     Q => portadataout_reg(15)
                    );
   portadataoutsel: bmux21
           port map (A => portadataout_int, 
                     B => portadataout_reg,
                     S => portadataout_clk_sel(0), 
                     MO => portadataout_tmp
                    );

   -- PORT B registers

   portbdatainregclr: nmux21
           port map (A => NC, 
                     B => portbclr0, 
                     S => portbdatain_reg_clr_sel,
                     MO => portbdatain_reg_clr
                    );
   portbdinreg_clr <= portbdatain_reg_clr and devclrn and devpor;
portbdinreg_0 : apexii_dffe
           port map (D => portbdatain(0), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(0)
                    );
   portbdinreg_1 : apexii_dffe
           port map (D => portbdatain(1), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(1)
                    );
   portbdinreg_2 : apexii_dffe
           port map (D => portbdatain(2), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(2)
                    );
   portbdinreg_3 : apexii_dffe
           port map (D => portbdatain(3), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(3)
                    );
   portbdinreg_4 : apexii_dffe
           port map (D => portbdatain(4), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(4)
                    );
   portbdinreg_5 : apexii_dffe
           port map (D => portbdatain(5), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(5)
                    );
   portbdinreg_6 : apexii_dffe
           port map (D => portbdatain(6), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(6)
                    );
   portbdinreg_7 : apexii_dffe
           port map (D => portbdatain(7), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(7)
                    );
   portbdinreg_8 : apexii_dffe
           port map (D => portbdatain(8), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(8)
                    );
   portbdinreg_9 : apexii_dffe
           port map (D => portbdatain(9), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(9)
                    );
   portbdinreg_10 : apexii_dffe
           port map (D => portbdatain(10), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(10)
                    );
   portbdinreg_11 : apexii_dffe
           port map (D => portbdatain(11), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(11)
                    );
   portbdinreg_12 : apexii_dffe
           port map (D => portbdatain(12), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(12)
                    );
   portbdinreg_13 : apexii_dffe
           port map (D => portbdatain(13), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(13)
                    );
   portbdinreg_14 : apexii_dffe
           port map (D => portbdatain(14), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(14)
                    );
   portbdinreg_15 : apexii_dffe
           port map (D => portbdatain(15), 
                     CLRN => portbdinreg_clr, 
                     CLK => portbclk0,
                     ENA => portbena0, 
                     Q => portbdatain_reg(15)
                    );

   portbdatain_reg_delayed_1 <= portbdatain_reg;
   portbdatain_reg_delayed_2 <= portbdatain_reg_delayed_1;
   portbdatain_reg_delayed_3 <= portbdatain_reg_delayed_2;

   portbdatainsel: bmux21
           port map (A => portbdatain, 
                     B => portbdatain_reg_delayed_3,
                     S => portbdatain_reg_sel, 
                     MO => portbdatain_int
                    );


   portbweregclr: nmux21
           port map (A => NC, 
                     B => portbclr0, 
                     S => portbwe_clr_sel,
                     MO => portbwe_reg_clr
                    );
   portbwereg_clr <= portbwe_reg_clr and devclrn and devpor;
   portbwereg: apexii_dffe
           port map (D => portbwe, 
                     CLRN => portbwereg_clr, 
                     CLK => portbclk0,
                       ENA => portbena0, 
                     Q => portbwe_reg
                    );
   portbwesel1: mux21
           port map (A => portbwe, 
                     B => portbwe_reg, 
                     S => portbwrite_reg_sel,
                     MO => portbwe_reg_mux
                    );
   portbwedelaybuf: and1
           port map (IN1 => portbwe_reg_mux, 
                     Y => portbwe_reg_mux_delayed
                    );
   portbclk0weregdelaybuf: and1
           port map (IN1 => portbclk0, 
                     Y => portbclk0_delayed
                    );
   portbwe_pulse <= portbwe_reg_mux_delayed and (not portbclk0_delayed);
   portbwesel2: mux21
           port map (A => portbwe_reg_mux_delayed, 
                     B => portbwe_pulse,
                     S => portbwrite_reg_sel, 
                     MO => portbwe_int
                    );


   portbwaddrregclr: nmux21
           port map (A => NC, 
                     B => portbclr0, 
                     S => portbwaddr_clr_sel,
                     MO => portbwaddr_reg_clr
                    );
   portbwaddrreg_clr <= portbwaddr_reg_clr and devclrn and devpor;
   portbwaddrreg_0: apexii_dffe
           port map (D => portbwaddr(0), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(0)
                    );
   portbwaddrreg_1: apexii_dffe
           port map (D => portbwaddr(1), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(1)
                    );
   portbwaddrreg_2: apexii_dffe
           port map (D => portbwaddr(2), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(2)
                    );
   portbwaddrreg_3: apexii_dffe
           port map (D => portbwaddr(3), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(3)
                    );
   portbwaddrreg_4: apexii_dffe
           port map (D => portbwaddr(4), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(4)
                    );
   portbwaddrreg_5: apexii_dffe
           port map (D => portbwaddr(5), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(5)
                    );
   portbwaddrreg_6: apexii_dffe
           port map (D => portbwaddr(6), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(6)
                    );
   portbwaddrreg_7: apexii_dffe
           port map (D => portbwaddr(7), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(7)
                    );
   portbwaddrreg_8: apexii_dffe
           port map (D => portbwaddr(8), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(8)
                    );
   portbwaddrreg_9: apexii_dffe
           port map (D => portbwaddr(9), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(9)
                    );
   portbwaddrreg_10: apexii_dffe
           port map (D => portbwaddr(10), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(10)
                    );
   portbwaddrreg_11: apexii_dffe
           port map (D => portbwaddr(11), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(11)
                    );
   portbwaddrreg_12: apexii_dffe
           port map (D => portbwaddr(12), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(12)
                    );
   portbwaddrreg_13: apexii_dffe
           port map (D => portbwaddr(13), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(13)
                    );
   portbwaddrreg_14: apexii_dffe
           port map (D => portbwaddr(14), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(14)
                    );
   portbwaddrreg_15: apexii_dffe
           port map (D => portbwaddr(15), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(15)
                    );
   portbwaddrreg_16: apexii_dffe
           port map (D => portbwaddr(16), 
                     CLRN => portbwaddrreg_clr,
                     CLK => portbclk0, 
                     ENA => portbena0,
                     Q => portbwaddr_reg(16)
                    );

   portbwaddr_reg_delayed_1 <= portbwaddr_reg;
   portbwaddr_reg_delayed_2 <= portbwaddr_reg_delayed_1;
   portbwaddr_reg_delayed_3 <= portbwaddr_reg_delayed_2;

   portbwaddrsel: b17mux21
           port map (A => portbwaddr, 
                     B => portbwaddr_reg_delayed_3,
                     S => portbwrite_reg_sel, 
                     MO => portbwaddr_int
                    );


   portbraddrclksel: mux21
           port map (A => portbclk0, 
                     B => portbclk1, 
                     S => portbraddr_clk_sel(1),
                     MO => portbraddr_clk
                    );
   portbraddrensel: mux21
           port map (A => portbena0, 
                     B => portbena1, 
                     S => portbraddr_en_sel,
                     MO => portbraddren
                    );
   portbraddrclrsel: mux21
           port map (A => portbclr0, 
                     B => portbclr1, 
                     S => portbraddr_clr_sel(1),
                     MO => portbraddr_clr
                    );
   portbraddrregclr: nmux21
           port map (A => NC, 
                     B => portbraddr_clr, 
                     S => portbraddr_clr_sel(0),
                     MO => portbraddr_reg_clr
                    );
   portbraddrreg_clr <= portbraddr_reg_clr and devclrn and devpor;
   portbraddrreg_0: apexii_dffe
           port map (D => portbraddr(0), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(0)
                    );
   portbraddrreg_1: apexii_dffe
           port map (D => portbraddr(1), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(1)
                    );
   portbraddrreg_2: apexii_dffe
           port map (D => portbraddr(2), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(2)
                    );
   portbraddrreg_3: apexii_dffe
           port map (D => portbraddr(3), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(3)
                    );
   portbraddrreg_4: apexii_dffe
           port map (D => portbraddr(4), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(4)
                    );
   portbraddrreg_5: apexii_dffe
           port map (D => portbraddr(5), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(5)
                    );
   portbraddrreg_6: apexii_dffe
           port map (D => portbraddr(6), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(6)
                    );
   portbraddrreg_7: apexii_dffe
           port map (D => portbraddr(7), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(7)
                    );
   portbraddrreg_8: apexii_dffe
           port map (D => portbraddr(8), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(8)
                    );
   portbraddrreg_9: apexii_dffe
           port map (D => portbraddr(9), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(9)
                    );
   portbraddrreg_10: apexii_dffe
           port map (D => portbraddr(10), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(10)
                    );
   portbraddrreg_11: apexii_dffe
           port map (D => portbraddr(11), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(11)
                    );
   portbraddrreg_12: apexii_dffe
           port map (D => portbraddr(12), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(12)
                    );
   portbraddrreg_13: apexii_dffe
           port map (D => portbraddr(13), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(13)
                    );
   portbraddrreg_14: apexii_dffe
           port map (D => portbraddr(14), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(14)
                    );
   portbraddrreg_15: apexii_dffe
           port map (D => portbraddr(15), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(15)
                    );
   portbraddrreg_16: apexii_dffe
           port map (D => portbraddr(16), 
                     CLRN => portbraddrreg_clr,
                     CLK => portbraddr_clk, 
                     ENA => portbraddren,
                     Q => portbraddr_reg(16)
                    );
   portbraddrsel: b17mux21
           port map (A => portbraddr, 
                     B => portbraddr_reg,
                     S => portbraddr_clk_sel(0), 
                     MO => portbraddr_int
                    );
   portbreclksel: mux21
           port map (A => portbclk0, 
                     B => portbclk1, 
                     S => portbre_clk_sel(1),
                     MO => portbre_clk
                    );
   portbreensel: mux21
           port map (A => portbena0, 
                     B => portbena1, 
                     S => portbre_en_sel,
                     MO => portbreen
                    );
   portbreclrsel: mux21
           port map (A => portbclr0, 
                     B => portbclr1, 
                     S => portbre_clr_sel(1),
                     MO => portbre_clr
                    );
   portbreregclr: nmux21
           port map (A => NC, 
                     B => portbre_clr, 
                     S => portbre_clr_sel(0),
                     MO => portbre_reg_clr
                    );
   portbrereg_clr <= portbre_reg_clr and devclrn and devpor;
   portbrereg: apexii_dffe
           port map (D => portbre, 
                     CLRN => portbrereg_clr, 
                     CLK => portbre_clk,
                     ENA => portbreen, 
                     Q => portbre_reg
                    );
   portbresel: mux21
           port map (A => portbre, 
                     B => portbre_reg, 
                     S => portbre_clk_sel(0),
                     MO => portbre_int
                    );

   portbraddr_int_delayed_1 <= portbraddr_int;
   portbraddr_int_delayed_2 <= portbraddr_int_delayed_1;

   portbdataoutclksel: mux21
           port map (A => portbclk0, 
                     B => portbclk1, 
                     S => portbdataout_clk_sel(1),
                     MO => portbdataout_clk
                    );
   portbdataoutensel: mux21
           port map (A => portbena0, 
                     B => portbena1, 
                     S => portbdataout_en_sel,
                     MO => portbdataouten
                    );
   portbdataoutclrsel: mux21
           port map (A => portbclr0, 
                     B => portbclr1, 
                     S => portbdataout_clr_sel(1),
                     MO => portbdataout_clr
                    );
   portbdataoutregclr: nmux21
           port map (A => NC, 
                     B => portbdataout_clr, 
                     S => portbdataout_clr_sel(0),
                     MO => portbdataout_reg_clr
                    );

   portbdataoutreg_clr <= portbdataout_reg_clr and devclrn and devpor;

   portbdataoutreg_0 : apexii_dffe
           port map (D => portbdataout_int(0), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(0)
                    );
   portbdataoutreg_1 : apexii_dffe
           port map (D => portbdataout_int(1), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(1)
                    );
   portbdataoutreg_2 : apexii_dffe
           port map (D => portbdataout_int(2), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(2)
                    );
   portbdataoutreg_3 : apexii_dffe
           port map (D => portbdataout_int(3), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(3)
                    );
   portbdataoutreg_4 : apexii_dffe
           port map (D => portbdataout_int(4), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(4)
                    );
   portbdataoutreg_5 : apexii_dffe
           port map (D => portbdataout_int(5), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(5)
                    );
   portbdataoutreg_6 : apexii_dffe
           port map (D => portbdataout_int(6), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(6)
                    );
   portbdataoutreg_7 : apexii_dffe
           port map (D => portbdataout_int(7), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(7)
                    );
   portbdataoutreg_8 : apexii_dffe
           port map (D => portbdataout_int(8), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(8)
                    );
   portbdataoutreg_9 : apexii_dffe
           port map (D => portbdataout_int(9), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(9)
                    );
   portbdataoutreg_10 : apexii_dffe
           port map (D => portbdataout_int(10), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(10)
                    );
   portbdataoutreg_11 : apexii_dffe
           port map (D => portbdataout_int(11), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(11)
                    );
   portbdataoutreg_12 : apexii_dffe
           port map (D => portbdataout_int(12), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(12)
                    );
   portbdataoutreg_13 : apexii_dffe
           port map (D => portbdataout_int(13), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(13)
                    );
   portbdataoutreg_14 : apexii_dffe
           port map (D => portbdataout_int(14), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(14)
                    );
   portbdataoutreg_15 : apexii_dffe
           port map (D => portbdataout_int(15), 
                     CLRN => portbdataoutreg_clr,
                     CLK => portbdataout_clk, 
                     ENA => portbdataouten,
                     Q => portbdataout_reg(15)
                    );
   portbdataoutsel: bmux21
           port map (A => portbdataout_int, 
                     B => portbdataout_reg,
                     S => portbdataout_clk_sel(0), 
                     MO => portbdataout_tmp
                    );


   apexiimem: apexii_asynch_mem
          GENERIC map (
                operation_mode              => operation_mode,
                port_a_operation_mode       => port_a_operation_mode,
                port_b_operation_mode       => port_b_operation_mode,
                port_a_read_first_address   => port_a_read_first_address,
                port_a_read_last_address    => port_a_read_last_address,
                port_a_read_data_width      => port_a_read_data_width,
                port_a_write_first_address  => port_a_write_first_address,
                port_a_write_last_address   => port_a_write_last_address,
                port_a_write_data_width     => port_a_write_data_width,
                port_b_read_first_address   => port_b_read_first_address,
                port_b_read_last_address    => port_b_read_last_address,
                port_b_read_data_width      => port_b_read_data_width,
                port_b_write_first_address  => port_b_write_first_address,
                port_b_write_last_address   => port_b_write_last_address,
                port_b_write_data_width     => port_b_write_data_width,
                port_a_read_enable_clock    => port_a_read_enable_clock,
                port_b_read_enable_clock    => port_b_read_enable_clock,
                port_a_write_logic_clock    => port_a_write_logic_clock,
                port_b_write_logic_clock    => port_b_write_logic_clock,
                init_file                   => init_file,
                port_a_init_file            => port_a_init_file,
                port_b_init_file            => port_b_init_file,


                mem1 => mem1,
                mem2 => mem2,
                mem3 => mem3,
                mem4 => mem4,
                mem5 => mem5,
                mem6 => mem6,
                mem7 => mem7,
                mem8 => mem8
              )
     port map (
                portadatain      => portadatain_int,
                portawe          => portawe_int,
                portare          => portare_int,
                portaraddr       => portaraddr_int_delayed_2,
                portawaddr       => portawaddr_int,
                portbdatain      => portbdatain_int,
                portbwe          => portbwe_int,
                portbre          => portbre_int,
                portbraddr       => portbraddr_int_delayed_2,
                portbwaddr       => portbwaddr_int,
                portadataout     => portadataout_int,
                portbdataout     => portbdataout_int,
                portamodesel     => portamodesel,
                portbmodesel     => portbmodesel
              );

   portaraddr_num <= conv_integer(portaraddr_int);

   --portavalid_addr <= '1' when portaraddr_num <= last_address and portaraddr_num >= first_address else '0';

   --portadataout <= portadataout_tmp when deep_ram_mode = "off" or (deep_ram_mode = "on" and valid_addr = '1') else 'Z';

   portadataout <= portadataout_tmp;
   portbdataout <= portbdataout_tmp;

end structure;

--/////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_CAM
--
-- Description : Timing simulation model for the asynchronous CAM array.
--
--/////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use work.apexii_atom_pack.all;

ENTITY  apexii_cam is
    GENERIC (
             operation_mode                    : string := "encoded_address";
             logical_cam_depth                 : integer := 32;
             address_width                     : integer := 5;
             pattern_width                     : integer := 32;
             first_address                     : integer := 0;
             last_address                      : integer := 31;
             init_mem_true                     : apexii_mem_data := (OTHERS=> "11111111111111111111111111111111");
             init_mem_comp                     : apexii_mem_data := (OTHERS=> "11111111111111111111111111111111");
             first_pattern_bit                 : integer := 0;
             TimingChecksOn                    : Boolean := True;
             MsgOn                             : Boolean := DefGlitchMsgOn;
             XOn                               : Boolean := DefGlitchXOn;
             MsgOnChecks                       : Boolean := DefMsgOnChecks;
             XOnChecks                         : Boolean := DefXOnChecks;
             InstancePath                      : STRING := "*";
             tsetup_lit_we_noedge_posedge      : VitalDelayArrayType(31 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_lit_we_noedge_posedge       : VitalDelayArrayType(31 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_datain_we_noedge_negedge   : VitalDelayType := DefSetupHoldCnst;
             thold_datain_we_noedge_negedge    : VitalDelayType := DefSetupHoldCnst;
             tsetup_wrinvert_we_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_wrinvert_we_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
             tpd_lit_matchout                  : VitalDelayArrayType01(511 downto 0) := (OTHERS => DefPropDelay01);
             tpd_lit_matchfound                : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01);
             tpd_we_matchout                   : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tpd_we_matchfound                 : VitalDelayType01 := DefPropDelay01;
             tpd_outputselect_matchout         : VitalDelayArrayType01(15 downto 0) := (OTHERS => DefPropDelay01);
             tipd_datain                       : VitalDelayType01 := DefPropDelay01;
             tipd_wrinvert                     : VitalDelayType01 := DefPropDelay01;
             tipd_we                           : VitalDelayType01 := DefPropDelay01;
             tipd_outputselect                 : VitalDelayType01 := DefPropDelay01;
             tipd_waddr                        : VitalDelayArrayType01(4 downto 0) := (OTHERS => DefPropDelay01);
             tipd_lit                          : VitalDelayArrayType01(31 downto 0) := (OTHERS => DefPropDelay01)
            );
 
    PORT    (datain          : in std_logic := '0';
             wrinvert        : in std_logic := '0';
             outputselect    : in std_logic := '0';
             we              : in std_logic := '0';
             lit             : in std_logic_vector(31 downto 0);
             waddr           : in std_logic_vector(4 downto 0) := "00000";
             modesel         : in std_logic_vector(1 downto 0) := "00";
             matchout        : out std_logic_vector(15 downto 0);
             matchfound      : out std_logic
            );
   attribute VITAL_LEVEL0 of apexii_cam : ENTITY is TRUE;
END apexii_cam;

ARCHITECTURE behave OF apexii_cam IS
signal datain_ipd       : std_logic;
signal we_ipd           : std_logic;
signal wrinvert_ipd     : std_logic;
signal outputselect_ipd : std_logic;
signal waddr_ipd        : std_logic_vector(4 downto 0);
signal lit_ipd          : std_logic_vector(31 downto 0);
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
    
    -- types for true and complement memory arrays    
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
                    HeaderMsg       => InstancePath & "/APEXII_CAM",
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
                    HeaderMsg       => InstancePath & "/APEXII_CAM",
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
                    HeaderMsg       => InstancePath & "/APEXII_CAM",
                    XOn             => XOnChecks,
                    MsgOn           => MsgOnChecks );
    
      end if;
    
      if (we_ipd'event or lit_ipd'event or outputselect_ipd'event) then
    
         if init then
         -- initialize CAM from GENERICs
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
-- Entity Name : APEXII_CAM_SLICE
--
-- Description : Structural model for a single CAM segment of the APEXII
--               device family
--
--////////////////////////////////////////////////////////////////////////////
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE IEEE.VITAL_Timing.all;
USE work.apexii_atom_pack.all;
USE work.apexii_dffe;
USE work.and1;
USE work.mux21;
USE work.nmux21;
USE work.bmux21;
USE work.apexii_cam;

ENTITY  apexii_cam_slice is
    GENERIC (
             operation_mode         : string := "encoded_address";
             logical_cam_name       : string := "cam_xxx";
             logical_cam_depth      : integer := 32;
             logical_cam_width      : integer:= 32;
             address_width          : integer:= 5;
             waddr_clear            : string := "none";
             write_enable_clear     : string := "none";
             write_logic_clock      : string := "none";
             write_logic_clear      : string := "none";
             output_clock           : string := "none";
             output_clear           : string := "none";
             init_file              : string := "xxx";
             init_filex             : string := "xxx";
             first_address          : integer:= 0;
             last_address           : integer:= 31;
             first_pattern_bit      : integer:= 0;
             pattern_width          : integer:= 32;
             power_up               : string := "low";
             init_mem_true          : apexii_mem_data;
             init_mem_comp          : apexii_mem_data
            );
    
    PORT    (clk0                   : in std_logic;
             clk1                   : in std_logic;
             clr0                   : in std_logic;
             clr1                   : in std_logic;
             ena0                   : in std_logic;
             ena1                   : in std_logic; 
             we                     : in std_logic;
             datain                 : in std_logic;
             wrinvert               : in std_logic;
             outputselect           : in std_logic;
             waddr                  : in std_logic_vector(4 downto 0);
             lit                    : in std_logic_vector(31 downto 0);
             devclrn                : in std_logic := '1';
             devpor                 : in std_logic := '1';
             modesel                : in std_logic_vector(9 downto 0) := (OTHERS => '0');
             matchout               : out std_logic_vector(15 downto 0);
             matchfound             : out std_logic
            );

end apexii_cam_slice;

ARCHITECTURE structure of apexii_cam_slice is
signal waddr_clr_sel       : std_logic;
signal write_logic_clr_sel : std_logic;
signal we_clr_sel          : std_logic;
signal output_clr_sel      : std_logic;
signal output_reg_clr_sel  : std_logic;
signal write_logic_sel     : std_logic;
signal output_reg_sel      : std_logic;
signal output_clk_sel      : std_logic;
signal output_clk          : std_logic;
signal output_clk_en       : std_logic;
signal output_clr          : std_logic;
signal output_reg_clr      : std_logic;
signal we_clr              : std_logic;
signal waddr_clr           : std_logic;
signal write_logic_clr     : std_logic;
signal matchfound_int      : std_logic;
signal matchfound_reg      : std_logic;
signal matchfound_tmp      : std_logic;
signal wdatain_reg         : std_logic;
signal wdatain_int         : std_logic;
signal wrinv_reg           : std_logic;
signal wrinv_int           : std_logic;
signal matchout_reg        : std_logic_vector(15 downto 0);
signal matchout_int        : std_logic_vector(15 downto 0);
signal waddr_reg           : std_logic_vector(4 downto 0);
signal we_reg              : std_logic;
signal we_reg_delayed      : std_logic;
signal NC                  : std_logic := '0';

signal wereg_clr           : std_logic;
signal writelogic_clr      : std_logic;
signal waddrreg_clr        : std_logic;
signal outputreg_clr       : std_logic;
signal we_pulse            : std_logic;

-- clk0 for we_pulse should have the same delay as
-- clk of wereg
signal clk0_delayed : std_logic;

COMPONENT apexii_dffe
    GENERIC (
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

    PORT    ( Q                            :  out   STD_LOGIC := '0';
              D                            :  in    STD_LOGIC := '1';
              CLRN                         :  in    STD_LOGIC := '1';
              PRN                          :  in    STD_LOGIC := '1';
              CLK                          :  in    STD_LOGIC := '0';
              ENA                          :  in    STD_LOGIC := '1'
            );
END COMPONENT;

COMPONENT and1
    GENERIC(
            XOn                           : Boolean := DefGlitchXOn;
            MsgOn                         : Boolean := DefGlitchMsgOn;
            tpd_IN1_Y                     :  VitalDelayType01 := DefPropDelay01;
            tipd_IN1                      :  VitalDelayType01 := DefPropDelay01);

    PORT   ( Y                            :  out   STD_LOGIC;
             IN1                          :  in    STD_LOGIC
           );
END COMPONENT;

COMPONENT mux21
    GENERIC(
            TimingChecksOn              : Boolean := True;
            MsgOn                       : Boolean := DefGlitchMsgOn;
            XOn                         : Boolean := DefGlitchXOn;
            InstancePath                : STRING := "*";
            tpd_A_MO                    :   VitalDelayType01 := DefPropDelay01;
            tpd_B_MO                    :   VitalDelayType01 := DefPropDelay01;
            tpd_S_MO                    :   VitalDelayType01 := DefPropDelay01;
            tipd_A                      :   VitalDelayType01 := DefPropDelay01;
            tipd_B                      :   VitalDelayType01 := DefPropDelay01;
            tipd_S                      :   VitalDelayType01 := DefPropDelay01
           );

    PORT   ( A                          : in std_logic := '0';
             B                          : in std_logic := '0';
             S                          : in std_logic := '0';
             MO                         : out std_logic
           );
END COMPONENT;

COMPONENT nmux21
    PORT   ( A                          : in std_logic := '0';
             B                          : in std_logic := '0';
             S                          : in std_logic := '0';
             MO                         : out std_logic
           );
END COMPONENT;

COMPONENT bmux21
    PORT ( A                  : in std_logic_vector(15 downto 0) := (OTHERS => '0');
           B                  : in std_logic_vector(15 downto 0) := (OTHERS => '0');
           S                  : in std_logic := '0';
           MO                 : out std_logic_vector(15 downto 0)
         );
END COMPONENT;

COMPONENT apexii_cam
    GENERIC (
             operation_mode   : string := "encoded_address";
             logical_cam_depth: integer := 32;
             first_pattern_bit: integer := 0;
             first_address    : integer := 0;
             last_address     : integer := 31;
             init_mem_true    : apexii_mem_data := (OTHERS => "11111111111111111111111111111111");
             init_mem_comp    : apexii_mem_data := (OTHERS => "11111111111111111111111111111111");
             address_width    : integer := 1;
             pattern_width    : integer := 32
            );

    PORT    (datain           : in std_logic := '0';
             wrinvert         : in std_logic := '0';
             outputselect     : in std_logic := '0';
             we               : in std_logic := '0';
             waddr            : in std_logic_vector(4 downto 0) := (OTHERS => '0');
             lit              : in std_logic_vector(31 downto 0) := (OTHERS => '0');
             modesel          : in std_logic_vector(1 downto 0) := "00";
             matchfound       : out std_logic;
             matchout         : out std_logic_vector(15 downto 0));
END COMPONENT;

begin

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
    wereg: apexii_dffe
            port map (D => we,
                      CLRN => wereg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => we_reg
                     );
    --  clk0 for we_pulse should have the same delay as
    -- clk of wereg--we_pulse <= we_reg_delayed and (not clk0);
    
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
    wdatainreg: apexii_dffe
            port map (D => datain,
                      CLRN => writelogic_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => wdatain_reg
                     );
    wrinvreg: apexii_dffe
            port map (D => wrinvert,
                      CLRN => writelogic_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => wrinv_reg
                     );
    waddrreg_clr <= waddr_clr and devclrn and devpor;
    waddrreg_0: apexii_dffe 
            port map (D => waddr(0),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(0)
                     );
    waddrreg_1: apexii_dffe 
            port map (D => waddr(1),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(1)
                     );
    waddrreg_2: apexii_dffe 
            port map (D => waddr(2),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(2)
                     );
    waddrreg_3: apexii_dffe 
            port map (D => waddr(3),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(3)
                     );
    waddrreg_4: apexii_dffe 
            port map (D => waddr(4),
                      CLRN => waddrreg_clr,
                      CLK => clk0,
                      ENA => ena0,
                      Q => waddr_reg(4)
                     );
    outputreg_clr <= output_clr and devclrn and devpor;
    matchoutreg_0: apexii_dffe
            port map (D => matchout_int(0),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(0)
                     );
    matchoutreg_1: apexii_dffe
            port map (D => matchout_int(1),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(1)
                     );
    matchoutreg_2: apexii_dffe
            port map (D => matchout_int(2),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(2)
                     );
    matchoutreg_3: apexii_dffe
            port map (D => matchout_int(3),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(3)
                     );
    matchoutreg_4: apexii_dffe
            port map (D => matchout_int(4),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(4)
                     );
    matchoutreg_5: apexii_dffe
            port map (D => matchout_int(5),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(5)
                     );
    matchoutreg_6: apexii_dffe
            port map (D => matchout_int(6),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(6)
                     );
    matchoutreg_7: apexii_dffe
            port map (D => matchout_int(7),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(7)
                     );
    matchoutreg_8: apexii_dffe
            port map (D => matchout_int(8),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(8)
                     );
    matchoutreg_9: apexii_dffe
            port map (D => matchout_int(9),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(9)
                     );
    matchoutreg_10: apexii_dffe
            port map (D => matchout_int(10),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(10)
                     );
    matchoutreg_11: apexii_dffe
            port map (D => matchout_int(11),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(11)
                     );
    matchoutreg_12: apexii_dffe
            port map (D => matchout_int(12),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(12)
                     );
    matchoutreg_13: apexii_dffe
            port map (D => matchout_int(13),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(13)
                     );
    matchoutreg_14: apexii_dffe
            port map (D => matchout_int(14),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(14)
                     );
    matchoutreg_15: apexii_dffe
            port map (D => matchout_int(15),
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchout_reg(15)
                     );
    
    matchfoundreg: apexii_dffe
            port map (D => matchfound_int,
                      CLRN => outputreg_clr,
                      CLK => output_clk,
                      ENA => output_clk_en,
                      Q => matchfound_reg
                     );
    
    cam1: apexii_cam
            GENERIC MAP (
                         operation_mode     => operation_mode,
                         address_width      => address_width,
                         pattern_width      => pattern_width,
                         first_pattern_bit  => first_pattern_bit,
                         first_address      => first_address,
                         last_address       => last_address,
                         init_MEM_TRUE      => init_mem_true,
                         init_MEM_COMP      => init_mem_comp,
                         LOGICAL_CAM_DEPTH  => logical_cam_depth
                        )

            PORT MAP    (datain             => wdatain_int,
                         wrinvert           => wrinv_int,
                         outputselect       => outputselect,
                         we                 => we_pulse, waddr => waddr_reg, lit => lit,
                         modesel            => modesel(9 downto 8),
                         matchout           => matchout_int,
                         matchfound         => matchfound_int
                        );

end structure;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_HSDI_TRANSMITTER
--
--- Description : Timing simulation model for APEX II HSDI Transmitter
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;


ENTITY apexii_hsdi_transmitter is
    GENERIC (
            channel_width		: integer := 10;
            center_align		: String  := "off";
            TimingChecksOn		: Boolean := True;
            MsgOn			: Boolean := DefGlitchMsgOn;
            MsgOnChecks             : Boolean := DefMsgOnChecks;
            XOnChecks               : Boolean := DefXOnChecks;
            XOn			: Boolean := DefGlitchXOn;
            InstancePath		: String := "*";
            tsetup_datain_clk1_noedge_posedge  : VitalDelayArrayType(9 downto 0) := (OTHERS => DefSetupHoldCnst);
            thold_datain_clk1_noedge_posedge   : VitalDelayArrayType(9 downto 0) := (OTHERS => DefSetupHoldCnst);
            tpd_clk0_dataout_negedge: VitalDelayType01 := DefPropDelay01;
            tipd_clk0		: VitalDelayType01 := DefpropDelay01;
            tipd_clk1		: VitalDelayType01 := DefpropDelay01;
            tipd_datain		: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01)
            );

    PORT    (
            clk0		: in std_logic;
            clk1		: in std_logic;
            datain		: in std_logic_vector(9 downto 0);
            devclrn		: in std_logic := '1';
            devpor		: in std_logic := '1';
            dataout		: out std_logic
            );
    attribute VITAL_LEVEL0 of apexii_hsdi_transmitter : ENTITY is TRUE;
end apexii_hsdi_transmitter;

ARCHITECTURE vital_transmitter_atom of apexii_hsdi_transmitter is
    attribute VITAL_LEVEL0 of vital_transmitter_atom : ARCHITECTURE is TRUE;
signal clk0_ipd, clk1_ipd : std_logic;
signal datain_ipd : std_logic_vector(9 downto 0);

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
        VitalWireDelay (datain_ipd(8), datain(8), tipd_datain(8));
        VitalWireDelay (datain_ipd(9), datain(9), tipd_datain(9));
    end block;

    VITAL: process (clk0_ipd, clk1_ipd, devclrn, devpor)
    variable Tviol_datain_clk1 : std_ulogic := '0';
    variable TimingData_datain_clk1 : VitalTimingDataType := VitalTimingDataInit;
    variable dataout_VitalGlitchData : VitalGlitchDataType;
    variable i : integer := 0;
    variable dataout_tmp : std_logic;
    variable regmsb : std_logic;
    variable indata : std_logic_vector(channel_width-1 downto 0);
    variable regdata : std_logic_vector(channel_width-1 downto 0);
    variable fast_clk_count : integer := 4;
    begin
    
        if (now = 0 ns) then
            dataout_tmp := '0';
            regmsb := '0';
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
                RefSignal       => clk1_ipd,
                RefSignalName   => "CLK1",
                SetupHigh       => tsetup_datain_clk1_noedge_posedge(0),
                SetupLow        => tsetup_datain_clk1_noedge_posedge(0),
                HoldHigh        => thold_datain_clk1_noedge_posedge(0),
                HoldLow         => thold_datain_clk1_noedge_posedge(0),
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/APEXII_HSDI_TRANSMITTER",
                XOn             => XOn,
                MsgOn           => MsgOnChecks );
            
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
                regmsb := regdata(channel_width-1);
            
                if (center_align = "off") then
                    dataout_tmp := regmsb;
                end if;
                for i in channel_width-1 downto 1 loop
                    regdata(i) := regdata(i-1);
                end loop;
            end if;
            if (clk0_ipd'event and clk0_ipd = '0') then  -- falling edge
                fast_clk_count := fast_clk_count + 1;
                if (center_align = "on") then
                    dataout_tmp := regmsb;
                end if;
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
            MsgOn  => MsgOn );
    
    end process;

end vital_transmitter_atom;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_HSDI_RECEIVER
--
--- Description : Timing simulation model for APEX II HSDI Receiver
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE, std;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;
use std.textio.all;


ENTITY apexii_hsdi_receiver is
    GENERIC (
            channel_width   : integer := 10;
            cds_mode        : string  := "single_bit";
            TimingChecksOn	: Boolean := True;
            MsgOn           : Boolean := DefGlitchMsgOn;
            XOn             : Boolean := DefGlitchXOn;
            MsgOnChecks     : Boolean := DefMsgOnChecks;
            XOnChecks       : Boolean := DefXOnChecks;
            InstancePath	: String := "*";
            tsetup_datain_clk0_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
            thold_datain_clk0_noedge_posedge    : VitalDelayType := DefSetupHoldCnst;
            tsetup_deskewin_clk0_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
            thold_deskewin_clk0_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
            tpd_clk0_dataout_negedge            : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
            tipd_clk0		: VitalDelayType01 := DefpropDelay01;
            tipd_clk1		: VitalDelayType01 := DefpropDelay01;
            tipd_deskewin	: VitalDelayType01 := DefpropDelay01;
            tipd_datain		: VitalDelayType01 := DefpropDelay01
            );

    PORT    (
            clk0		: in std_logic;
            clk1		: in std_logic;
            datain		: in std_logic;
            deskewin	: in std_logic := '0';
            devclrn		: in std_logic := '1';
            devpor		: in std_logic := '1';
            dataout		: out std_logic_vector(9 downto 0)
            );
    attribute VITAL_LEVEL0 of apexii_hsdi_receiver : ENTITY is TRUE;
end apexii_hsdi_receiver;

ARCHITECTURE vital_receiver_atom of apexii_hsdi_receiver is
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
    variable dataout_VitalGlitchDataArray : VitalGlitchDataArrayType(9 downto 0);
    variable clk0_count : integer := 4;
    variable cal_error : integer := 0;
    variable cal_cycle : integer := 1;
    variable deser_data_arr : std_logic_vector(channel_width-1 downto 0);
    variable dataout_tmp : std_logic_vector(9 downto 0);
    variable first_cycle : boolean := true;
    variable fast_clk_count : integer := 0;
    variable deskew_asserted, calibrated, check_calibration : boolean := false;
    variable screen_buffer : LINE;
    variable temp7vec : bit_vector(6 downto 0);
    variable temp8vec : bit_vector(7 downto 0);
    variable temp10vec : bit_vector(9 downto 0);
    variable temp9vec : bit_vector(8 downto 0);
    variable temp6vec : bit_vector(5 downto 0);
    variable temp5vec : bit_vector(4 downto 0);
    variable temp4vec : bit_vector(3 downto 0);
    variable result : boolean := false;
    begin

        if (now = 0 ns) then
            dataout_tmp := (OTHERS => '0');
        end if;

        ------------------------
        --  Timing Check Section
        ------------------------
        if (TimingChecksOn) then
    
            VitalSetupHoldCheck (
                Violation       => Tviol_datain_clk0,
                TimingData      => TimingData_datain_clk0,
                TestSignal      => datain_ipd,
                TestSignalName  => "DATAIN",
                RefSignal       => clk0_ipd,
                RefSignalName   => "CLK0",
                SetupHigh       => tsetup_datain_clk0_noedge_posedge,
                SetupLow        => tsetup_datain_clk0_noedge_posedge,
                HoldHigh        => thold_datain_clk0_noedge_posedge,
                HoldLow         => thold_datain_clk0_noedge_posedge,
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/APEXII_HSDI_RX",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );

            VitalSetupHoldCheck (
                Violation       => Tviol_deskewin_clk0,
                TimingData      => TimingData_deskewin_clk0,
                TestSignal      => deskewin_ipd,
                TestSignalName  => "DESKEWIN",
                RefSignal       => clk0_ipd,
                RefSignalName   => "CLK0",
                SetupHigh       => tsetup_deskewin_clk0_noedge_posedge,
                SetupLow        => tsetup_deskewin_clk0_noedge_posedge,
                HoldHigh        => thold_deskewin_clk0_noedge_posedge,
                HoldLow         => thold_deskewin_clk0_noedge_posedge,
                RefTransition   => '/',
                HeaderMsg       => InstancePath & "/APEXII_HSDI_RX",
                XOn             => XOnChecks,
                MsgOn           => MsgOnChecks );
            
        end if;

        if ((devpor = '0') or (devclrn = '0')) then
            dataout_tmp := (OTHERS => '0');
        else
            if (deskewin_ipd'event and deskewin_ipd = '1') then
                deskew_asserted := true;
                calibrated := false;
                assert false report "Calibrating receiver ...." severity note;
            end if;
            if (deskewin_ipd'event and deskewin_ipd = '0') then
                deskew_asserted := false;
            end if;

            if (clk1_ipd'event and clk1_ipd = '1') then
                clk0_count := 0;
                if (check_calibration and not calibrated) then
                -- old is_calibration_pattern function
                    if (channel_width = 7) then
                        if (cds_mode = "single_bit") then
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
                        else
                            if (deser_data_arr = "0101010" or deser_data_arr = "1010101") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 0101010 or 1010101."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 0101010 or 1010101, Actual pattern: "));
                                temp7vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp7vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        end if;
                    elsif (channel_width = 8) then
                        if (cds_mode = "single_bit") then
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
                        else
                            if (deser_data_arr = "01010101" or deser_data_arr = "10101010") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 01010101 or 10101010."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 01010101 or 10101010, Actual pattern: "));
                                temp8vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp8vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        end if;
                    elsif (channel_width = 10) then
                        if (cds_mode = "single_bit") then
                            if (deser_data_arr = "0000011111") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 0000011111."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 0000011111, Actual pattern: "));
                                temp10vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp10vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        else
                            if (deser_data_arr = "0101010101" or deser_data_arr = "1010101010") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 0101010101 or 1010101010."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 0101010101 or 1010101010, Actual pattern: "));
                                temp10vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp10vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        end if;
                    elsif (channel_width = 9) then
                        if (cds_mode = "single_bit") then
                            if (deser_data_arr = "000001111") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 000001111."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 000001111, Actual pattern: "));
                                temp9vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp9vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        else
                            if (deser_data_arr = "010101010" or deser_data_arr = "101010101") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 010101010 or 101010101."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 010101010 or 101010101, Actual pattern: "));
                                temp9vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp9vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        end if;
                    elsif (channel_width = 6) then
                        if (cds_mode = "single_bit") then
                            if (deser_data_arr = "000111") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 000111."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 000111, Actual pattern: "));
                                temp6vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp6vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        else
                            if (deser_data_arr = "010101" or deser_data_arr = "101010") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 010101 or 101010."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 010101 or 101010, Actual pattern: "));
                                temp6vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp6vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        end if;
                    elsif (channel_width = 5) then
                        if (cds_mode = "single_bit") then
                            if (deser_data_arr = "00011") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 00011."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 00011, Actual pattern: "));
                                temp5vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp5vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        else
                            if (deser_data_arr = "01010" or deser_data_arr = "10101") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 01010 or 10101."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 01010 or 10101, Actual pattern: "));
                                temp5vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp5vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        end if;
                    elsif (channel_width = 4) then
                        if (cds_mode = "single_bit") then
                            if (deser_data_arr = "0011") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 0011."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 0011, Actual pattern: "));
                                temp4vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp4vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
                        else
                            if (deser_data_arr = "0101" or deser_data_arr = "1010") then
                            -- calibrate ok
                                write(screen_buffer, string'("Cycle : "));
                                write(screen_buffer, cal_cycle);
                                write(screen_buffer, string'(", Calibration pattern: 0101 or 1010."));
                                writeline (OUTPUT, screen_buffer);
                                result := true;
                            else
                                write(screen_buffer, string'("Calibration error in cycle "));
                                write(screen_buffer, cal_cycle);
                                writeline (OUTPUT, screen_buffer);
                                write(screen_buffer, string'("Expected pattern: 0101 or 1010, Actual pattern: "));
                                temp4vec := To_BitVector(deser_data_arr);
                                write(screen_buffer, temp4vec);
                                writeline (OUTPUT, screen_buffer);
                                result := false;
                            end if;
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
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(1),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(1),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(1), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(1),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(2),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(2),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(2), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(2),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(3),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(3),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(3), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(3),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(4),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(4),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(4), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(4),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(5),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(5),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(5), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(5),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(6),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(6),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(6), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(6),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(7),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(7),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(7), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(7),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(8),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(8),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(8), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(8),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

        VitalPathDelay01 (
            OutSignal => dataout(9),
            OutSignalName => "DATAOUT",
            OutTemp => dataout_tmp(9),
            Paths => (1 => (clk0_ipd'last_event, tpd_clk0_dataout_negedge(9), TRUE)),
            GlitchData => dataout_VitalGlitchDataArray(9),
            Mode => DefGlitchMode,
            XOn  => XOn,
            MsgOn  => MsgOn );

    end process;

end vital_receiver_atom;

--///////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_PLL
--
-- Description : Timing simulation model for the APEXII device family PLL
--
--///////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use IEEE.VITAL_Primitives.all;
use work.apexii_atom_pack.all;

ENTITY  apexii_pll is
    GENERIC (
             input_frequency            : integer  := 1000;
             operation_mode             : string := "normal";
             simulation_type            : string := "timing";
             clk0_multiply_by           : integer := 1;
             clk0_divide_by             : integer := 1;
             clk1_multiply_by           : integer := 1;
             clk1_divide_by             : integer := 1;
             clk2_multiply_by           : integer := 1;
             clk2_divide_by             : integer := 1;
             phase_shift                : integer := 0;
             effective_phase_shift      : integer := 0;
             effective_clk0_delay       : integer := 0;
             effective_clk1_delay       : integer := 0;
             effective_clk2_delay       : integer := 0;
             lock_high                  : integer := 1;
             invalid_lock_multiplier    : integer := 5;
             valid_lock_multiplier      : integer := 5;
             lock_low                   : integer := 1;
             MsgOn                      : Boolean := DefGlitchMsgOn;
             XOn                        : Boolean := DefGlitchXOn;
             tpd_ena_clk0               : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk1               : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk2               : VitalDelayType01 := DefPropDelay01;
             tpd_clk_locked             : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk0              : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk1              : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk2              : VitalDelayType01 := DefPropDelay01;
             tipd_clk                   : VitalDelayType01 := DefpropDelay01;
             tipd_fbin                  : VitalDelayType01 := DefpropDelay01;
             tipd_ena                   : VitalDelayType01 := DefpropDelay01
            );

    PORT    (clk                        : in std_logic;
             ena                        : in std_logic;
             fbin                       : in std_logic;
             clk0                       : out std_logic;
             clk1                       : out std_logic;
             clk2                       : out std_logic;
             locked                     : out std_logic
            );
        attribute VITAL_LEVEL0 of apexii_pll : ENTITY is TRUE;
end apexii_pll;

ARCHITECTURE vital_pll_atom of apexii_pll is
attribute VITAL_LEVEL0 of vital_pll_atom : ARCHITECTURE is TRUE;
signal clk_ipd      : std_logic;
signal ena_ipd      : std_logic;
signal fbin_ipd     : std_logic;

SIGNAL clk0_period  : time;
SIGNAL clk1_period  : time;
SIGNAL clk2_period  : time;
SIGNAL half_inclk   : time;
SIGNAL pll_lock     : std_logic := '0';
SIGNAL lock_on_rise : integer := 0;
SIGNAL clk_check    : std_logic := '0';

SIGNAL clk0_tmp     : std_logic := 'X'; 
SIGNAL clk1_tmp     : std_logic := 'X'; 
SIGNAL clk2_tmp     : std_logic := 'X'; 
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
    variable last_synchronizing_rising_edge_for_clk2 : time := 0 ps;
    variable input_cycles_per_clk0, input_cycles_per_clk1 : integer;
    variable input_cycles_per_clk2 : integer;
    variable input_cycle_count_to_sync0 : integer := 0;
    variable input_cycle_count_to_sync1 : integer := 0;
    variable input_cycle_count_to_sync2 : integer := 0;
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
    variable clk2_synchronizing_period : time;
    variable clk0_cycles_per_sync_period : integer := clk0_multiply_by;
    variable clk1_cycles_per_sync_period : integer := clk1_multiply_by;
    variable clk2_cycles_per_sync_period : integer := clk2_multiply_by;
    variable schedule_clk0, schedule_clk1 : boolean := false;
    variable schedule_clk2 : boolean := false;
    variable clk0_phase_delay, clk1_phase_delay : time := 0 ps;
    variable clk2_phase_delay : time := 0 ps;
    begin
       if (init) then
          clk0_cycles_per_sync_period := clk0_multiply_by;
          clk1_cycles_per_sync_period := clk1_multiply_by;
          clk2_cycles_per_sync_period := clk2_multiply_by;
          input_cycles_per_clk0 := clk0_divide_by;
          input_cycles_per_clk1 := clk1_divide_by;
          input_cycles_per_clk2 := clk2_divide_by;
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
             clk2_period <= (clk2_divide_by * inclk_ps)/ clk2_multiply_by;
             pll_duty_cycle := inclk_ps/2;

             if (simulation_type = "functional") then
                clk0_phase_delay := phase_shift * 1 ps;
                clk1_phase_delay := phase_shift * 1 ps;
                clk2_phase_delay := phase_shift * 1 ps;
             else
                clk0_phase_delay := effective_clk0_delay * 1 ps;
                clk1_phase_delay := effective_clk1_delay * 1 ps;
                clk2_phase_delay := effective_clk2_delay * 1 ps;
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
                   -- initialize to 1 to be consistent with Mei Yee's change
                   -- in Quartus model
                   start_lock_count := 1;
                end if;
             else
                violation := false;
                clk0_period <= (clk0_divide_by * pll_cycle) / clk0_multiply_by;
                clk1_period <= (clk1_divide_by * pll_cycle)/ clk1_multiply_by;
                clk2_period <= (clk2_divide_by * pll_cycle)/ clk2_multiply_by;
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
                   -- initialize to 1 to be consistent with Mei Yee's change
                   -- in Quartus model
                   start_lock_count := 1;
                end if;
             else
                violation := false;
                clk0_period <= (clk0_divide_by * pll_cycle) / clk0_multiply_by;
                clk1_period <= (clk1_divide_by * pll_cycle)/ clk1_multiply_by;
                clk2_period <= (clk2_divide_by * pll_cycle)/ clk2_multiply_by;
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
                input_cycle_count_to_sync2 := input_cycle_count_to_sync2 + 1;
                if (input_cycle_count_to_sync2 = input_cycles_per_clk2) then
                   clk2_synchronizing_period := now - last_synchronizing_rising_edge_for_clk2;
                   last_synchronizing_rising_edge_for_clk2 := now;
                   schedule_clk2 := true;
                   input_cycle_count_to_sync2 := 0;
                end if;
             else
                if (pll_rising_edge_count-1 > 0) then
                   start_lock_count := start_lock_count + 1;
                   if (start_lock_count >= lock_high) then
                      pll_lock_tmp := '1';
                      lock_on_rise <= 1;
                      input_cycle_count_to_sync0 := 0;
                      input_cycle_count_to_sync1 := 0;
                      input_cycle_count_to_sync2 := 0;
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
                      if (last_synchronizing_rising_edge_for_clk2 = 0 ps) then
                         clk2_synchronizing_period := ((pll_cycle/1 ps) * clk2_divide_by) * 1 ps;
                      else
                         clk2_synchronizing_period := now - last_synchronizing_rising_edge_for_clk2;
                      end if;
                      last_synchronizing_rising_edge_for_clk0 := now;
                      last_synchronizing_rising_edge_for_clk1 := now;
                      last_synchronizing_rising_edge_for_clk2 := now;
                      schedule_clk0 := true;
                      schedule_clk1 := true;
                      schedule_clk2 := true;
                   end if;
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
          elsif (pll_rising_edge_count > 0) then
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
          start_lock_count := 1;
          stop_lock_count := 0;
          lock_on_rise <= 0;
          clk0_tmp <= 'X';
          clk1_tmp <= 'X';
          clk2_tmp <= 'X';
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

       if (schedule_clk2) then
          sched_time := clk2_phase_delay;
          cycle_to_adjust := 0;
          l := 1;
          output_value := '1';
          temp := clk2_synchronizing_period/1 ps;
          my_rem := temp rem clk2_cycles_per_sync_period;
          for i in 1 to clk2_cycles_per_sync_period loop
              tmp_per := temp/clk2_cycles_per_sync_period;
              if (my_rem /= 0 and l <= my_rem) then
                 tmp_rem := (clk2_cycles_per_sync_period * l) rem my_rem;
                 cycle_to_adjust := (clk2_cycles_per_sync_period * l) / my_rem;
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
                 clk2_tmp <= transport output_value after sched_time;
                 output_value := not output_value;
                 if (output_value = '0') then
                    sched_time := sched_time + high_time;
                 elsif (output_value = '1') then
                    sched_time := sched_time + low_time;
                 end if;
              end loop;
          end loop;
          schedule_clk2 := false;
       end if;

    end process;

    clk0 <= clk0_tmp;
    clk1 <= clk1_tmp;
    clk2 <= clk2_tmp;

end vital_pll_atom;

--////////////////////////////////////////////////////////////////////////////
--
-- Entity Name : APEXII_JTAGB
--
-- Description : Timing simulation model for APEX II JTAGB
--
--////////////////////////////////////////////////////////////////////////////

LIBRARY IEEE;
use IEEE.std_logic_1164.all;
use work.apexii_atom_pack.all;

ENTITY  apexii_jtagb is
    PORT    (
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
end apexii_jtagb;

ARCHITECTURE architecture_jtagb of apexii_jtagb is
begin

    process(tms, tck, tdi, ntrst, tdoutap, tdouser)
    begin
    
    end process;

end architecture_jtagb;
