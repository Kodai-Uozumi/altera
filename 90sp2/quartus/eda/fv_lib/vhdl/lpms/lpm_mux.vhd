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
--////////////////////////////// LPM_MUX for Verplex /////////////////////////////////////
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
--@ --------------------------------------------------------------------------------- //
--@ Element          Name          Drivers        Condition(Parameters)               //
--@ --------------------------------------------------------------------------------- //
--@ Mux                                           -                                   //
--@ - Input          data                                                             //
--@ - Output         result        data           -                                   //
--@/////////////////////////////////////////////////////////////////////////////////////////
--@/////////////////////////////////////////////////////////////////////////////////////////
--@ Revision History                                  //////////////////////////////////////
--@ AGUIN : Create first revision : 9/29              //////////////////////////////////////
--@
--@/////////////////////////////////////////////////////////////////////////////////////////

library IEEE;
use IEEE.std_logic_1164.all;

library LPM;
USE LPM.lpm_components.ALL;

-- MODEL BEGIN
ENTITY lpm_mux IS
-- INTERFACE BEGIN
    GENERIC (
        lpm_width : NATURAL;
        lpm_size  : NATURAL;
	lpm_widths: NATURAL;
	lpm_pipeline : NATURAL := 0;
        lpm_type  : STRING := "LPM_MUX";
        lpm_hint  : STRING := "UNUSED"
    );
    PORT (
        data   : IN  std_logic_2d(lpm_size-1 downto 0, lpm_width-1 downto 0);
	sel   : in std_logic_vector(lpm_widths-1 downto 0); 
        clock : in std_logic ;
        aclr  : in std_logic ;
        clken : in std_logic ;
        result : OUT std_logic_vector(lpm_width-1 downto 0)
    );
-- INTERFACE END
END lpm_mux;

-- IMPLEMENTATION BEGIN
ARCHITECTURE LPM_SYN OF lpm_mux is

-- TYPE DECLARATION
SIGNAL selected : std_logic_vector(lpm_width - 1 downto 0);
-- ******* MUX logic ********* 
BEGIN

mux : PROCESS (data,sel)
BEGIN
FOR i in 0 to lpm_width-1 LOOP
   selected(i) <= data(TO_INT(sel),i);
END LOOP;

END PROCESS mux;

-- ******* Synchronous logic *********

output_latency : pipeline_internal_fv
	generic map (
		data_width => lpm_width,
		latency    => lpm_pipeline
	)

	port map (
                clk => clock,
                ena => clken,
                clr => aclr,
                d   => selected,
                piped => result
        );

END LPM_SYN;

-- IMPLEMENTATION END
-- MODEL END

