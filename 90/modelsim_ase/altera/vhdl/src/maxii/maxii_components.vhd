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
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.maxii_atom_pack.all;

package MAXII_COMPONENTS is

--
-- MAXII_LCELL
--
  
component maxii_lcell
  generic 
    (
      operation_mode  : string := "normal";
      synch_mode      : string := "off";
      register_cascade_mode   : string := "off";
      sum_lutc_input  : string := "datac";
      lut_mask        : string := "ffff";
      power_up        : string := "low";
      cin0_used       : string := "false";
      cin1_used       : string := "false";
      cin_used        : string := "false";
      output_mode     : string := "reg_and_comb";
      lpm_type        : string := "maxii_lcell";
      x_on_violation  : string := "on"
      );
  port
    (
      clk       : in std_logic := '0';
      dataa     : in std_logic := '1';
      datab     : in std_logic := '1';
      datac     : in std_logic := '1';
      datad     : in std_logic := '1';
      aclr      : in std_logic := '0';
      aload     : in std_logic := '0';
      sclr      : in std_logic := '0';
      sload     : in std_logic := '0';
      ena       : in std_logic := '1';
      cin       : in std_logic := '0';
      cin0      : in std_logic := '0';
      cin1      : in std_logic := '1';
      inverta   : in std_logic := '0';
      regcascin : in std_logic := '0';
      devclrn   : in std_logic := '1';
      devpor    : in std_logic := '1';
      combout   : out std_logic;
      regout    : out std_logic;
      cout      : out std_logic;
      cout0     : out std_logic;
      cout1     : out std_logic
      );
end component;

--
-- MAXII_JTAG
--

component  maxii_jtag 
    generic (
            lpm_type	: string := "maxii_jtag"
            );
    port    (
            tms : in std_logic := '0'; 
            tck : in std_logic := '0'; 
            tdi : in std_logic := '0'; 
            ntrst : in std_logic := '0'; 
            tdoutap : in std_logic := '0'; 
            tdouser : in std_logic := '0'; 
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
end component;

--
--
--  MAXII_CRCBLOCK 
--
--

component  maxii_crcblock 
    generic (
            oscillator_divider : integer := 1;
            lpm_type : string := "maxii_crcblock"
            );
	port    (
            clk         : in std_logic := '0'; 
            shiftnld    : in std_logic := '0'; 
-- REMTITAN            ldsrc       : in std_logic := '0'; 
            crcerror    : out std_logic; 
            regout      : out std_logic
            ); 
end component;
--
-- MAXII_UFM
--

component maxii_ufm
    generic (
            -- PARAMETER DECLARATION
            address_width   : integer := 9;
            init_file       : string := "none";
            lpm_type        : string := "maxii_ufm";
            mem1            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem2            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem3            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem4            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem5            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem6            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem7            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem8            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem9            : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem10           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem11           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem12           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem13           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem14           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem15           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            mem16           : std_logic_vector(511 downto 0) := (OTHERS=>'1');
            osc_sim_setting : integer := 180000; -- default osc frequency to 5.56MHz
            program_time    : integer := 1600000; -- default program_time is 1600ns
            erase_time      : integer := 500000000; -- default erase time is 500us

            TimingChecksOn: Boolean := True;
            XOn: Boolean := DefGlitchXOn;
            MsgOn: Boolean := DefGlitchMsgOn;

            tpd_program_busy_posedge: VitalDelayType01 := DefPropDelay01;
            tpd_erase_busy_posedge  : VitalDelayType01 := DefPropDelay01;
            tpd_drclk_drdout_posedge: VitalDelayType01 := DefPropDelay01;
            tpd_oscena_osc_posedge  : VitalDelayType01 := DefPropDelay01;
            tpd_sbdin_sbdout : VitalDelayType01 := DefPropDelay01;

            tsetup_arshft_arclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
            tsetup_ardin_arclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
            tsetup_drshft_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
            tsetup_drdin_drclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
            tsetup_oscena_program_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
            tsetup_oscena_erase_noedge_posedge : VitalDelayType := DefSetupHoldCnst;

            thold_arshft_arclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
            thold_ardin_arclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
            thold_drshft_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
            thold_drdin_drclk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;

            thold_program_drclk_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
            thold_erase_arclk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
            thold_oscena_program_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
            thold_oscena_erase_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
            thold_program_busy_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
            thold_erase_busy_noedge_negedge : VitalDelayType := DefSetupHoldCnst;

            tipd_program  : VitalDelayType01 := DefPropDelay01;
            tipd_erase : VitalDelayType01 := DefPropDelay01;
            tipd_oscena : VitalDelayType01 := DefPropDelay01;
            tipd_arclk : VitalDelayType01 := DefPropDelay01;
            tipd_arshft : VitalDelayType01 := DefPropDelay01;
            tipd_ardin : VitalDelayType01 := DefPropDelay01;
            tipd_drclk : VitalDelayType01 := DefPropDelay01;
            tipd_drshft : VitalDelayType01 := DefPropDelay01;
            tipd_drdin : VitalDelayType01 := DefPropDelay01;
            tipd_sbdin : VitalDelayType01 := DefPropDelay01
            );
    port (
            program                 : IN std_logic := '0';
            erase                   : IN std_logic := '0';
            oscena                  : IN std_logic;
            arclk                   : IN std_logic;
            arshft                  : IN std_logic;
            ardin                   : IN std_logic;
            drclk                   : IN std_logic;
            drshft                  : IN std_logic;
            drdin                   : IN std_logic := '0';
            sbdin                   : IN std_logic := '0';
            devclrn                 : IN std_logic := '1';
            devpor                  : IN std_logic := '1';
            ctrl_bgpbusy            : IN std_logic := '0';
            busy                    : OUT std_logic;
            osc                     : OUT std_logic := 'X';
            drdout                  : OUT std_logic;
            sbdout                  : OUT std_logic;
            bgpbusy                 : OUT std_logic
        );
end component;

--
-- MAXII_IO
--

component maxii_io
    generic (
             lpm_type : string := "maxii_io";
             operation_mode : string := "input";
             open_drain_output : string := "false";
             bus_hold : string := "false"
            );
    port (
        datain : in std_logic := '0';
        oe : in std_logic := '1';
        combout : out std_logic;
        padio : inout std_logic
        );
end component;


--
-- MAXII_ROUTING_WIRE
--

component maxii_routing_wire
    generic (
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             tpd_datain_dataout : VitalDelayType01 := DefPropDelay01;
             tpd_datainglitch_dataout : VitalDelayType01 := DefPropDelay01;
             tipd_datain : VitalDelayType01 := DefPropDelay01
            );
    PORT (
          datain : in std_logic;
          dataout : out std_logic
         );
end component;


end maxii_components;
