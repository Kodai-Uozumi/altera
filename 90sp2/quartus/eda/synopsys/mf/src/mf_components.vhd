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



library ieee;
use ieee.std_logic_1164.all;

package maxplus2 is
    component A_81MUX
        port (A, B, C, GN : in std_logic;
              D0, D1, D2, D3, D4, D5, D6, D7 : in std_logic;
              Y, WN : out std_logic);
    end component;

    component A_8COUNT
        port (A, B, C, D, E, F, G, H : in std_logic;
              LDN, GN, DNUP, SETN, CLRN, CLK: in std_logic;
              QA, QB, QC, QD, QE, QF, QG, QH, COUT : out std_logic);
    end component;

    component A_8FADD
        port (A8, A7, A6, A5, A4, A3, A2, A1 : in std_logic;
              B8, B7, B6, B5, B4, B3, B2, B1 : in std_logic;
              CIN : in std_logic;
              SUM8, SUM7, SUM6, SUM5, SUM4, SUM3, SUM2, SUM1, COUT : out std_logic);

    end component;

    component A_8MCOMP
        port (A7, A6, A5, A4, A3, A2, A1, A0 : in std_logic;
              B7, B6, B5, B4, B3, B2, B1, B0 : in std_logic;
              ALTB, AEQB, AGTB : out std_logic;
              AEB7, AEB6, AEB5, AEB4, AEB3, AEB2, AEB1, AEB0 : out std_logic);
    end component;
end maxplus2;
