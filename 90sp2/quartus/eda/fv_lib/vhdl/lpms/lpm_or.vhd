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
--////////////////////////////// LPM_OR  for Verplex /////////////////////////////////////
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
--@ Or                                            -                                   //
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
ENTITY lpm_or IS
-- INTERFACE BEGIN
    GENERIC (
        lpm_width : NATURAL;
        lpm_size  : NATURAL;
        lpm_type  : STRING := "LPM_OR";
        lpm_hint  : STRING := "UNUSED"
    );
    PORT (
        data   : IN  std_logic_2d(lpm_size-1 downto 0, lpm_width-1 downto 0);
        result : OUT std_logic_vector(lpm_width-1 downto 0)
    );
-- INTERFACE END
END lpm_or;

-- IMPLEMENTATION BEGIN
ARCHITECTURE LPM_SYN OF lpm_or is

-- SIGNAL DECLARATION
SIGNAL result_int : std_logic_2d(lpm_size-1 downto 0,lpm_width-1 downto 0);
-- ******* AND logic ********* 
begin
    L1: FOR i IN 0 TO lpm_width-1 GENERATE
            result_int(0,i) <= data(0,i);
    L2:     FOR j IN 0 TO lpm_size-2 GENERATE
                result_int(j+1,i) <=  result_int(j,i) or data(j+1,i);
    L3:         IF j = lpm_size-2 GENERATE
                    result(i) <= result_int(lpm_size-1,i);
                END GENERATE L3;
            END GENERATE L2;
        END GENERATE L1;

END LPM_SYN;

-- IMPLEMENTATION END
-- MODEL END

