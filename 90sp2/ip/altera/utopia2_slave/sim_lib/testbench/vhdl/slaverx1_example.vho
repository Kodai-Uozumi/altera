--IP Functional Simulation Model
--VERSION_BEGIN 8.1 cbx_mgl 2008:07:11:15:23:48:SJ cbx_simgen 2008:07:09:16:50:58:SJ  VERSION_END


-- Legal Notice: � 2003 Altera Corporation. All rights reserved.
-- You may only use these  simulation  model  output files for simulation
-- purposes and expressly not for synthesis or any other purposes (in which
-- event  Altera disclaims all warranties of any kind). Your use of  Altera
-- Corporation's design tools, logic functions and other software and tools,
-- and its AMPP partner logic functions, and any output files any of the
-- foregoing (including device programming or simulation files), and any
-- associated documentation or information  are expressly subject to the
-- terms and conditions of the  Altera Program License Subscription Agreement
-- or other applicable license agreement, including, without limitation, that
-- your use is for the sole purpose of programming logic devices manufactured
-- by Altera and sold by Altera or its authorized distributors.  Please refer
-- to the applicable agreement for further details.


--synopsys translate_off

 LIBRARY altera_mf;
 USE altera_mf.altera_mf_components.all;

 LIBRARY lpm;
 USE lpm.lpm_components.all;

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = altdpram 1 lpm_counter 2 lut 175 mux21 67 oper_add 7 oper_decoder 2 oper_less_than 1 oper_mux 10 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  slaverx1_example IS 
	 PORT 
	 ( 
		 phy_rx_clav	:	OUT  STD_LOGIC;
		 phy_rx_clk	:	IN  STD_LOGIC;
		 phy_rx_data	:	IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 phy_rx_enb	:	OUT  STD_LOGIC;
		 phy_rx_soc	:	IN  STD_LOGIC;
		 phy_rx_valid	:	IN  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 rx_addr	:	IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 rx_bus_enb	:	OUT  STD_LOGIC;
		 rx_clav	:	OUT  STD_LOGIC;
		 rx_clav_enb	:	OUT  STD_LOGIC;
		 rx_clk	:	IN  STD_LOGIC;
		 rx_data	:	OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 rx_enb	:	IN  STD_LOGIC;
		 rx_prty	:	OUT  STD_LOGIC;
		 rx_soc	:	OUT  STD_LOGIC
	 ); 
 END slaverx1_example;

 ARCHITECTURE RTL OF slaverx1_example IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL  wire_n0Oii_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_vcc	:	STD_LOGIC;
	 SIGNAL  wire_n0Oii_q	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n0Oii_rdaddress	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n0Oii_wraddress	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n0Oii_wren	:	STD_LOGIC;
	 SIGNAL  wire_nl11l_w_lg_w_lg_ni1OO500w501w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlll0l53	:	STD_LOGIC := '0';
	 SIGNAL	 nlll0l54	:	STD_LOGIC := '0';
	 SIGNAL	 nlll0O51	:	STD_LOGIC := '0';
	 SIGNAL	 nlll0O52	:	STD_LOGIC := '0';
	 SIGNAL	 nllliO49	:	STD_LOGIC := '0';
	 SIGNAL	 nllliO50	:	STD_LOGIC := '0';
	 SIGNAL	 nlllli47	:	STD_LOGIC := '0';
	 SIGNAL	 nlllli48	:	STD_LOGIC := '0';
	 SIGNAL	 nllOll45	:	STD_LOGIC := '0';
	 SIGNAL	 nllOll46	:	STD_LOGIC := '0';
	 SIGNAL	 nllOOl43	:	STD_LOGIC := '0';
	 SIGNAL	 nllOOl44	:	STD_LOGIC := '0';
	 SIGNAL	 nlO00O29	:	STD_LOGIC := '0';
	 SIGNAL	 nlO00O30	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlO00O30_w_lg_q210w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlO01O31	:	STD_LOGIC := '0';
	 SIGNAL	 nlO01O32	:	STD_LOGIC := '0';
	 SIGNAL	 nlO0il27	:	STD_LOGIC := '0';
	 SIGNAL	 nlO0il28	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlO0il28_w_lg_w_lg_q205w206w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO0il28_w_lg_q205w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlO0li25	:	STD_LOGIC := '0';
	 SIGNAL	 nlO0li26	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlO0li26_w_lg_q198w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlO0lO23	:	STD_LOGIC := '0';
	 SIGNAL	 nlO0lO24	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlO0lO24_w_lg_w_lg_q193w194w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO0lO24_w_lg_q193w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlO0Ol21	:	STD_LOGIC := '0';
	 SIGNAL	 nlO0Ol22	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlO0Ol22_w_lg_w_lg_q188w189w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO0Ol22_w_lg_q188w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlO10l39	:	STD_LOGIC := '0';
	 SIGNAL	 nlO10l40	:	STD_LOGIC := '0';
	 SIGNAL	 nlO11O41	:	STD_LOGIC := '0';
	 SIGNAL	 nlO11O42	:	STD_LOGIC := '0';
	 SIGNAL	 nlO1ii37	:	STD_LOGIC := '0';
	 SIGNAL	 nlO1ii38	:	STD_LOGIC := '0';
	 SIGNAL	 nlO1iO35	:	STD_LOGIC := '0';
	 SIGNAL	 nlO1iO36	:	STD_LOGIC := '0';
	 SIGNAL	 nlO1lO33	:	STD_LOGIC := '0';
	 SIGNAL	 nlO1lO34	:	STD_LOGIC := '0';
	 SIGNAL	 nlOi1i19	:	STD_LOGIC := '0';
	 SIGNAL	 nlOi1i20	:	STD_LOGIC := '0';
	 SIGNAL	 nlOiil17	:	STD_LOGIC := '0';
	 SIGNAL	 nlOiil18	:	STD_LOGIC := '0';
	 SIGNAL	 nlOiiO15	:	STD_LOGIC := '0';
	 SIGNAL	 nlOiiO16	:	STD_LOGIC := '0';
	 SIGNAL	 nlOill13	:	STD_LOGIC := '0';
	 SIGNAL	 nlOill14	:	STD_LOGIC := '0';
	 SIGNAL	 nlOiOi11	:	STD_LOGIC := '0';
	 SIGNAL	 nlOiOi12	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlOiOi12_w_lg_w_lg_q153w154w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOiOi12_w_lg_q153w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlOiOl10	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlOiOl10_w_lg_w_lg_q146w147w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOiOl10_w_lg_q146w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlOiOl9	:	STD_LOGIC := '0';
	 SIGNAL	 nlOiOO7	:	STD_LOGIC := '0';
	 SIGNAL	 nlOiOO8	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlOiOO8_w_lg_w_lg_q81w82w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOiOO8_w_lg_q81w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlOl1i5	:	STD_LOGIC := '0';
	 SIGNAL	 nlOl1i6	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlOl1i6_w_lg_w_lg_q67w68w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOl1i6_w_lg_q67w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlOl1l3	:	STD_LOGIC := '0';
	 SIGNAL	 nlOl1l4	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlOl1l4_w_lg_w_lg_q22w23w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOl1l4_w_lg_q22w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nlOl1O1	:	STD_LOGIC := '0';
	 SIGNAL	 nlOl1O2	:	STD_LOGIC := '0';
	 SIGNAL  wire_nlOl1O2_w_lg_w_lg_q18w19w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOl1O2_w_lg_q18w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n00OO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n00Ol_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n00Ol_PRN	:	STD_LOGIC;
	 SIGNAL	n1O0l	:	STD_LOGIC := '0';
	 SIGNAL	wire_n1O0i_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n1O0i_PRN	:	STD_LOGIC;
	 SIGNAL	n1O1l	:	STD_LOGIC := '0';
	 SIGNAL  wire_n1O1i_w_lg_n1O1l645w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O1i_w_lg_w_lg_n1O1l645w646w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n010i	:	STD_LOGIC := '0';
	 SIGNAL	n010l	:	STD_LOGIC := '0';
	 SIGNAL	n010O	:	STD_LOGIC := '0';
	 SIGNAL	n011i	:	STD_LOGIC := '0';
	 SIGNAL	n011l	:	STD_LOGIC := '0';
	 SIGNAL	n011O	:	STD_LOGIC := '0';
	 SIGNAL	n01ii	:	STD_LOGIC := '0';
	 SIGNAL	n01il	:	STD_LOGIC := '0';
	 SIGNAL	n10i	:	STD_LOGIC := '0';
	 SIGNAL	n10l	:	STD_LOGIC := '0';
	 SIGNAL	n10O	:	STD_LOGIC := '0';
	 SIGNAL	n11i	:	STD_LOGIC := '0';
	 SIGNAL	n11l	:	STD_LOGIC := '0';
	 SIGNAL	n11O	:	STD_LOGIC := '0';
	 SIGNAL	n1ii	:	STD_LOGIC := '0';
	 SIGNAL	n1il	:	STD_LOGIC := '0';
	 SIGNAL	n1iO	:	STD_LOGIC := '0';
	 SIGNAL	n1li	:	STD_LOGIC := '0';
	 SIGNAL	n1ll	:	STD_LOGIC := '0';
	 SIGNAL	n1lll	:	STD_LOGIC := '0';
	 SIGNAL	n1llO	:	STD_LOGIC := '0';
	 SIGNAL	n1lO	:	STD_LOGIC := '0';
	 SIGNAL	n1lOi	:	STD_LOGIC := '0';
	 SIGNAL	n1lOl	:	STD_LOGIC := '0';
	 SIGNAL	n1lOO	:	STD_LOGIC := '0';
	 SIGNAL	n1O0O	:	STD_LOGIC := '0';
	 SIGNAL	n1O1O	:	STD_LOGIC := '0';
	 SIGNAL	n1Oii	:	STD_LOGIC := '0';
	 SIGNAL	n1Oil	:	STD_LOGIC := '0';
	 SIGNAL	n1OiO	:	STD_LOGIC := '0';
	 SIGNAL	n1Ol	:	STD_LOGIC := '0';
	 SIGNAL	n1Oli	:	STD_LOGIC := '0';
	 SIGNAL	n1Oll	:	STD_LOGIC := '0';
	 SIGNAL	n1OlO	:	STD_LOGIC := '0';
	 SIGNAL	n1OOi	:	STD_LOGIC := '0';
	 SIGNAL	n1OOl	:	STD_LOGIC := '0';
	 SIGNAL	n1OOO	:	STD_LOGIC := '0';
	 SIGNAL	nlliO	:	STD_LOGIC := '0';
	 SIGNAL	nllli	:	STD_LOGIC := '0';
	 SIGNAL	nllll	:	STD_LOGIC := '0';
	 SIGNAL	nlllO	:	STD_LOGIC := '0';
	 SIGNAL	nllOi	:	STD_LOGIC := '0';
	 SIGNAL	nllOl	:	STD_LOGIC := '0';
	 SIGNAL	nllOO	:	STD_LOGIC := '0';
	 SIGNAL	nlO0i	:	STD_LOGIC := '0';
	 SIGNAL	nlO0l	:	STD_LOGIC := '0';
	 SIGNAL	nlO0O	:	STD_LOGIC := '0';
	 SIGNAL	nlO1i	:	STD_LOGIC := '0';
	 SIGNAL	nlO1l	:	STD_LOGIC := '0';
	 SIGNAL	nlO1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOii	:	STD_LOGIC := '0';
	 SIGNAL	nlOil	:	STD_LOGIC := '0';
	 SIGNAL	nlOiO	:	STD_LOGIC := '0';
	 SIGNAL	nlOli	:	STD_LOGIC := '0';
	 SIGNAL	nlOll	:	STD_LOGIC := '0';
	 SIGNAL	nlOlO	:	STD_LOGIC := '0';
	 SIGNAL	nlOOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOOO	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOl	:	STD_LOGIC := '0';
	 SIGNAL	wire_n1Oi_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n1Oi_PRN	:	STD_LOGIC;
	 SIGNAL  wire_n1Oi_w_lg_w_lg_w208w211w212w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w208w211w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_w_lg_w_lg_n11l186w190w196w199w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w208w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_nlOli247w248w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_nlOlO254w255w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_w_lg_n11l186w190w196w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_n1li234w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_n1lO241w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11l186w190w196w199w200w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_n11i177w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_n11l176w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlO0i240w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlO0l245w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlO1l233w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlO1O238w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlOli247w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlOll252w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlOlO254w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlOOi259w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlOOl181w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlOOO179w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_n11l186w190w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_nlOOO191w195w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_n11l186w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_nlOOO191w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_w_lg_w_lg_n11l201w202w203w207w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_w_lg_n11l201w202w203w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_w_lg_n11l201w202w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oi_w_lg_n11l201w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niOli	:	STD_LOGIC := '0';
	 SIGNAL	niOlO	:	STD_LOGIC := '0';
	 SIGNAL	n0iOl	:	STD_LOGIC := '0';
	 SIGNAL	n0iOO	:	STD_LOGIC := '0';
	 SIGNAL	n0l0i	:	STD_LOGIC := '0';
	 SIGNAL	n0l0l	:	STD_LOGIC := '0';
	 SIGNAL	n0l0O	:	STD_LOGIC := '0';
	 SIGNAL	n0l1i	:	STD_LOGIC := '0';
	 SIGNAL	n0l1l	:	STD_LOGIC := '0';
	 SIGNAL	n0l1O	:	STD_LOGIC := '0';
	 SIGNAL	n0lii	:	STD_LOGIC := '0';
	 SIGNAL	n0lil	:	STD_LOGIC := '0';
	 SIGNAL	n0liO	:	STD_LOGIC := '0';
	 SIGNAL	n0lli	:	STD_LOGIC := '0';
	 SIGNAL	n0lll	:	STD_LOGIC := '0';
	 SIGNAL	n0llO	:	STD_LOGIC := '0';
	 SIGNAL	n0lOi	:	STD_LOGIC := '0';
	 SIGNAL	n0lOl	:	STD_LOGIC := '0';
	 SIGNAL	n0lOO	:	STD_LOGIC := '0';
	 SIGNAL	n0O0i	:	STD_LOGIC := '0';
	 SIGNAL	n0O1i	:	STD_LOGIC := '0';
	 SIGNAL	n0O1l	:	STD_LOGIC := '0';
	 SIGNAL	n0O1O	:	STD_LOGIC := '0';
	 SIGNAL	ni1OO	:	STD_LOGIC := '0';
	 SIGNAL	nii1O	:	STD_LOGIC := '0';
	 SIGNAL	niilO	:	STD_LOGIC := '0';
	 SIGNAL	niiOi	:	STD_LOGIC := '0';
	 SIGNAL	niiOl	:	STD_LOGIC := '0';
	 SIGNAL	niiOO	:	STD_LOGIC := '0';
	 SIGNAL	nil0i	:	STD_LOGIC := '0';
	 SIGNAL	nil0l	:	STD_LOGIC := '0';
	 SIGNAL	nil0O	:	STD_LOGIC := '0';
	 SIGNAL	nil1i	:	STD_LOGIC := '0';
	 SIGNAL	nil1l	:	STD_LOGIC := '0';
	 SIGNAL	nil1O	:	STD_LOGIC := '0';
	 SIGNAL	nilii	:	STD_LOGIC := '0';
	 SIGNAL	nilil	:	STD_LOGIC := '0';
	 SIGNAL	niliO	:	STD_LOGIC := '0';
	 SIGNAL	nilli	:	STD_LOGIC := '0';
	 SIGNAL	nilll	:	STD_LOGIC := '0';
	 SIGNAL	nillO	:	STD_LOGIC := '0';
	 SIGNAL	nilOi	:	STD_LOGIC := '0';
	 SIGNAL	nilOl	:	STD_LOGIC := '0';
	 SIGNAL	nilOO	:	STD_LOGIC := '0';
	 SIGNAL	niO0i	:	STD_LOGIC := '0';
	 SIGNAL	niO0l	:	STD_LOGIC := '0';
	 SIGNAL	niO0O	:	STD_LOGIC := '0';
	 SIGNAL	niO1i	:	STD_LOGIC := '0';
	 SIGNAL	niO1l	:	STD_LOGIC := '0';
	 SIGNAL	niO1O	:	STD_LOGIC := '0';
	 SIGNAL	niOii	:	STD_LOGIC := '0';
	 SIGNAL	niOil	:	STD_LOGIC := '0';
	 SIGNAL	niOiO	:	STD_LOGIC := '0';
	 SIGNAL	niOOi	:	STD_LOGIC := '0';
	 SIGNAL	niOOl	:	STD_LOGIC := '0';
	 SIGNAL	niOOO	:	STD_LOGIC := '0';
	 SIGNAL	nl11i	:	STD_LOGIC := '0';
	 SIGNAL	nl11O	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl11l_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_nl11l_w_lg_w_lg_w_lg_niOiO409w416w417w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_w_lg_niOiO409w416w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_niOiO409w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_ni1OO500w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_niilO437w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_niiOi439w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_niiOl441w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_niiOO443w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_nilOi429w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_nilOl431w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_nilOO433w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_niO1i435w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_w_lg_w_lg_niOiO412w413w414w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_w_lg_niOiO412w413w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11l_w_lg_niOiO412w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_lg_w_q_range579w606w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_lg_w_q_range582w609w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n01li_q	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n01li_w_q_range579w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_q_range582w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOlil_w_lg_w_q_range710w737w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOlil_w_lg_w_q_range712w736w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOlil_w_lg_w_q_range722w725w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOlil_w_lg_w_q_range728w729w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOlil_aclr	:	STD_LOGIC;
	 SIGNAL  wire_nlOlil_q	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlOlil_w_q_range710w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOlil_w_q_range712w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOlil_w_q_range722w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOlil_w_q_range728w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0iii_w_lg_w_lg_dataout451w452w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_dataout451w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0iil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0iil_w_lg_dataout418w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0ill_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0ill_w_lg_dataout449w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n10OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n110i_w_lg_w_lg_dataout164w165w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n110i_w_lg_dataout164w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n11ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOll_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlOOll_w_lg_dataout708w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlOOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n01iO_w_lg_w_o_range723w724w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01iO_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n01iO_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL  wire_n01iO_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n01iO_w_o_range723w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01O_a	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n01O_b	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n01O_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n0iO_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n0iO_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n0iO_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n0iO_w_o_range80w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iO_w_o_range145w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0O0l_w_lg_w_o_range604w605w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0O0l_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0O0l_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0O0l_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0O0l_w_o_range604w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0O0O_w_lg_w_o_range565w566w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0O0O_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0O0O_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0O0O_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0O0O_w_o_range565w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1li_a	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nl1li_b	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nl1li_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nl1ll_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl1ll_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl1ll_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n0li_w_lg_w_o_range227w228w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0li_w_lg_w_o_range221w222w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0li_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n0li_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0li_w_o_range227w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0li_w_o_range221w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nl1iO_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_n0i1i_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n0i1i_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n0i1i_o	:	STD_LOGIC;
	 SIGNAL  wire_n00i_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n00i_o	:	STD_LOGIC;
	 SIGNAL  wire_n00i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00l_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n00l_o	:	STD_LOGIC;
	 SIGNAL  wire_n00l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n00O_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n00O_o	:	STD_LOGIC;
	 SIGNAL  wire_n00O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ii_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n0ii_o	:	STD_LOGIC;
	 SIGNAL  wire_n0ii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0il_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n0il_o	:	STD_LOGIC;
	 SIGNAL  wire_n0il_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl10i_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nl10i_o	:	STD_LOGIC;
	 SIGNAL  wire_nl10i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl10l_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nl10l_o	:	STD_LOGIC;
	 SIGNAL  wire_nl10l_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl10O_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nl10O_o	:	STD_LOGIC;
	 SIGNAL  wire_nl10O_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl1ii_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nl1ii_o	:	STD_LOGIC;
	 SIGNAL  wire_nl1ii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl1il_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nl1il_o	:	STD_LOGIC;
	 SIGNAL  wire_nl1il_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllOiO419w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rx_addr_range651w654w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlll0i701w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlll1O644w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlllil640w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlllll588w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllO1l551w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllOil550w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlO01l706w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOili171w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlOlii648w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset625w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_rx_enb679w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_rx_addr_range652w653w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  nlliOl :	STD_LOGIC;
	 SIGNAL  nlliOO :	STD_LOGIC;
	 SIGNAL  nlll0i :	STD_LOGIC;
	 SIGNAL  nlll1i :	STD_LOGIC;
	 SIGNAL  nlll1l :	STD_LOGIC;
	 SIGNAL  nlll1O :	STD_LOGIC;
	 SIGNAL  nlllii :	STD_LOGIC;
	 SIGNAL  nlllil :	STD_LOGIC;
	 SIGNAL  nlllll :	STD_LOGIC;
	 SIGNAL  nllllO :	STD_LOGIC;
	 SIGNAL  nlllOi :	STD_LOGIC;
	 SIGNAL  nlllOl :	STD_LOGIC;
	 SIGNAL  nlllOO :	STD_LOGIC;
	 SIGNAL  nllO0i :	STD_LOGIC;
	 SIGNAL  nllO0l :	STD_LOGIC;
	 SIGNAL  nllO0O :	STD_LOGIC;
	 SIGNAL  nllO1i :	STD_LOGIC;
	 SIGNAL  nllO1l :	STD_LOGIC;
	 SIGNAL  nllO1O :	STD_LOGIC;
	 SIGNAL  nllOii :	STD_LOGIC;
	 SIGNAL  nllOil :	STD_LOGIC;
	 SIGNAL  nllOiO :	STD_LOGIC;
	 SIGNAL  nllOli :	STD_LOGIC;
	 SIGNAL  nllOlO :	STD_LOGIC;
	 SIGNAL  nllOOi :	STD_LOGIC;
	 SIGNAL  nlO00l :	STD_LOGIC;
	 SIGNAL  nlO01i :	STD_LOGIC;
	 SIGNAL  nlO01l :	STD_LOGIC;
	 SIGNAL  nlO11i :	STD_LOGIC;
	 SIGNAL  nlO11l :	STD_LOGIC;
	 SIGNAL  nlO1ll :	STD_LOGIC;
	 SIGNAL  nlO1Ol :	STD_LOGIC;
	 SIGNAL  nlO1OO :	STD_LOGIC;
	 SIGNAL  nlOi0i :	STD_LOGIC;
	 SIGNAL  nlOi0l :	STD_LOGIC;
	 SIGNAL  nlOi0O :	STD_LOGIC;
	 SIGNAL  nlOi1O :	STD_LOGIC;
	 SIGNAL  nlOiii :	STD_LOGIC;
	 SIGNAL  nlOili :	STD_LOGIC;
	 SIGNAL  nlOl0i :	STD_LOGIC;
	 SIGNAL  nlOlii :	STD_LOGIC;
	 SIGNAL  wire_w_rx_addr_range651w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_rx_addr_range652w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
 BEGIN

	wire_gnd <= '0';
	wire_vcc <= '1';
	wire_w_lg_nllOiO419w(0) <= nllOiO AND wire_n0iil_w_lg_dataout418w(0);
	wire_w_lg_w_rx_addr_range651w654w(0) <= wire_w_rx_addr_range651w(0) AND wire_w_lg_w_rx_addr_range652w653w(0);
	wire_w_lg_nlll0i701w(0) <= NOT nlll0i;
	wire_w_lg_nlll1O644w(0) <= NOT nlll1O;
	wire_w_lg_nlllil640w(0) <= NOT nlllil;
	wire_w_lg_nlllll588w(0) <= NOT nlllll;
	wire_w_lg_nllO1l551w(0) <= NOT nllO1l;
	wire_w_lg_nllOil550w(0) <= NOT nllOil;
	wire_w_lg_nlO01l706w(0) <= NOT nlO01l;
	wire_w_lg_nlOili171w(0) <= NOT nlOili;
	wire_w_lg_nlOlii648w(0) <= NOT nlOlii;
	wire_w_lg_reset625w(0) <= NOT reset;
	wire_w_lg_rx_enb679w(0) <= NOT rx_enb;
	wire_w_lg_w_rx_addr_range652w653w(0) <= NOT wire_w_rx_addr_range652w(0);
	nlliOl <= ((((((NOT wire_nlOlil_q(0)) AND (NOT (wire_nlOlil_q(1) XOR wire_n01iO_o(0)))) AND (NOT (wire_nlOlil_q(2) XOR wire_n01iO_o(1)))) AND (NOT wire_nlOlil_w_lg_w_q_range722w725w(0))) AND (NOT wire_nlOlil_w_lg_w_q_range728w729w(0))) AND (NOT (wire_nlOlil_q(5) XOR wire_n01iO_o(2))));
	nlliOO <= ((((wire_nlOlil_w_lg_w_q_range710w737w(0) AND (NOT wire_nlOlil_q(2))) AND (NOT wire_nlOlil_q(3))) AND (NOT wire_nlOlil_q(4))) AND (NOT wire_nlOlil_q(5)));
	nlll0i <= (nlOOOl AND (n1O1O OR n1lOO));
	nlll1i <= ((((((NOT wire_nlOlil_q(0)) AND (NOT (wire_nlOlil_q(1) XOR wire_n01iO_o(0)))) AND (NOT (wire_nlOlil_q(2) XOR wire_n01iO_o(1)))) AND (NOT wire_nlOlil_w_lg_w_q_range722w725w(0))) AND (NOT wire_nlOlil_w_lg_w_q_range728w729w(0))) AND (NOT (wire_nlOlil_q(5) XOR wire_n01iO_o(2))));
	nlll1l <= ((((((NOT wire_nlOlil_q(0)) AND wire_nlOlil_w_lg_w_q_range712w736w(0)) AND (NOT wire_nlOlil_q(2))) AND (NOT wire_nlOlil_q(3))) AND (NOT wire_nlOlil_q(4))) AND (NOT wire_nlOlil_q(5)));
	nlll1O <= (n1O1l AND wire_nlOOll_w_lg_dataout708w(0));
	nlllii <= ((((((NOT wire_nlOlil_q(0)) AND wire_nlOlil_w_lg_w_q_range712w736w(0)) AND (NOT wire_nlOlil_q(2))) AND wire_nlOlil_q(3)) AND wire_nlOlil_q(4)) AND (NOT wire_nlOlil_q(5)));
	nlllil <= (((((((((((((((wire_n11il_dataout XOR wire_n11iO_dataout) XOR wire_n11li_dataout) XOR wire_n11ll_dataout) XOR wire_n11lO_dataout) XOR wire_n11Oi_dataout) XOR wire_n11Ol_dataout) XOR wire_n11OO_dataout) XOR wire_n101i_dataout) XOR wire_n101l_dataout) XOR wire_n101O_dataout) XOR wire_n100i_dataout) XOR wire_n100l_dataout) XOR wire_n100O_dataout) XOR wire_n10ii_dataout) XOR wire_n10il_dataout);
	nlllll <= ((((((NOT wire_n01li_q(0)) AND (NOT wire_n01li_q(1))) AND (NOT wire_n01li_q(2))) AND (NOT wire_n01li_q(3))) AND (NOT wire_n01li_q(4))) AND (NOT wire_n01li_q(5)));
	nllllO <= ((((((NOT wire_n01li_q(0)) AND (NOT (wire_n01li_q(1) XOR wire_n0O0l_o(0)))) AND (NOT (wire_n01li_q(2) XOR wire_n0O0l_o(1)))) AND (NOT wire_n01li_w_lg_w_q_range579w606w(0))) AND (NOT wire_n01li_w_lg_w_q_range582w609w(0))) AND (NOT (wire_n01li_q(5) XOR wire_n0O0l_o(2))));
	nlllOi <= ((((((NOT wire_n01li_q(0)) AND (NOT wire_n01li_q(1))) AND (NOT wire_n01li_q(2))) AND (NOT wire_n01li_q(3))) AND (NOT wire_n01li_q(4))) AND (NOT wire_n01li_q(5)));
	nlllOl <= ((((((NOT wire_n01li_q(0)) AND (NOT wire_n01li_q(1))) AND (NOT wire_n01li_q(2))) AND (NOT wire_n01li_q(3))) AND (NOT wire_n01li_q(4))) AND (NOT wire_n01li_q(5)));
	nlllOO <= ((((((NOT wire_n01li_q(0)) AND (NOT (wire_n01li_q(1) XOR wire_n0O0l_o(0)))) AND (NOT (wire_n01li_q(2) XOR wire_n0O0l_o(1)))) AND (NOT wire_n01li_w_lg_w_q_range579w606w(0))) AND (NOT wire_n01li_w_lg_w_q_range582w609w(0))) AND (NOT (wire_n01li_q(5) XOR wire_n0O0l_o(2))));
	nllO0i <= (nilii OR wire_nl11l_w_lg_niiOl441w(0));
	nllO0l <= (nil0O OR wire_nl11l_w_lg_niiOi439w(0));
	nllO0O <= (nil0l OR wire_nl11l_w_lg_niilO437w(0));
	nllO1i <= (n0l1O AND n0iOO);
	nllO1l <= ((((((NOT wire_n01li_q(0)) AND (NOT wire_n01li_q(1))) AND (NOT wire_n01li_q(2))) AND (NOT wire_n01li_q(3))) AND (NOT wire_n01li_q(4))) AND (NOT wire_n01li_q(5)));
	nllO1O <= (nilil OR wire_nl11l_w_lg_niiOO443w(0));
	nllOii <= (((wire_n0iii_dataout AND wire_n0iil_dataout) AND wire_n0ill_w_lg_dataout449w(0)) OR (wire_n0iii_w_lg_w_lg_dataout451w452w(0) AND wire_n0ill_w_lg_dataout449w(0)));
	nllOil <= (wire_nl11l_w_lg_w_lg_w_lg_niOiO409w416w417w(0) OR wire_w_lg_nllOiO419w(0));
	nllOiO <= ((wire_nl11l_w_lg_niOiO409w(0) OR (niOii AND niO0O)) AND wire_nl11l_w_lg_w_lg_w_lg_niOiO412w413w414w(0));
	nllOli <= ((wire_n0iii_dataout AND wire_n0iil_dataout) AND wire_n0ill_w_lg_dataout449w(0));
	nllOlO <= (wire_n1Oi_w_lg_nlOOi259w(0) AND nlllO);
	nllOOi <= (wire_n1Oi_w_lg_w_lg_nlOlO254w255w(0) AND (nllOOl44 XOR nllOOl43));
	nlO00l <= ((((((NOT wire_nlOlil_q(0)) AND wire_nlOlil_w_lg_w_q_range712w736w(0)) AND (NOT wire_nlOlil_q(2))) AND wire_nlOlil_q(3)) AND wire_nlOlil_q(4)) AND (NOT wire_nlOlil_q(5)));
	nlO01i <= (n1Ol AND wire_n1Oi_w_lg_nlO0l245w(0));
	nlO01l <= (((((wire_n1Oi_w_lg_n11l176w(0) AND wire_n1Oi_w_lg_n11i177w(0)) AND wire_n1Oi_w_lg_nlOOO179w(0)) AND wire_n1Oi_w_lg_nlOOl181w(0)) AND (nlOi1i20 XOR nlOi1i19)) OR (wire_n1Oi_w_lg_w_lg_w208w211w212w(0) AND (nlO01O32 XOR nlO01O31)));
	nlO11i <= (wire_n1Oi_w_lg_nlOll252w(0) AND nllli);
	nlO11l <= (wire_n1Oi_w_lg_w_lg_nlOli247w248w(0) AND (nlO11O42 XOR nlO11O41));
	nlO1ll <= (wire_n1Oi_w_lg_n1li234w(0) AND (nlO1ii38 XOR nlO1ii37));
	nlO1Ol <= (n1ll AND wire_n1Oi_w_lg_nlO1O238w(0));
	nlO1OO <= (wire_n1Oi_w_lg_n1lO241w(0) AND (nlO10l40 XOR nlO10l39));
	nlOi0i <= (niO1O AND wire_nl11l_w_lg_nilOl431w(0));
	nlOi0l <= (niO0i AND wire_nl11l_w_lg_nilOO433w(0));
	nlOi0O <= (niO0l AND wire_nl11l_w_lg_niO1i435w(0));
	nlOi1O <= (niO1l AND wire_nl11l_w_lg_nilOi429w(0));
	nlOiii <= '1';
	nlOili <= ((wire_n110i_dataout AND wire_n11ii_dataout) OR (wire_n110i_w_lg_w_lg_dataout164w165w(0) AND (nlOill14 XOR nlOill13)));
	nlOl0i <= (n1lll AND (n1lOi AND n1llO));
	nlOlii <= (n1lOl AND nlll0i);
	phy_rx_clav <= n00OO;
	phy_rx_enb <= n0iOl;
	rx_bus_enb <= nlOOOl;
	rx_clav <= n1lOO;
	rx_clav_enb <= nlOl0i;
	rx_data <= ( n01ii & n010O & n010l & n010i & n011O & n011l & n011i & n1OOO & n1OOl & n1OOi & n1OlO & n1Oll & n1Oli & n1OiO & n1Oil & n1Oii);
	rx_prty <= n1O0O;
	rx_soc <= nlOlii;
	wire_w_rx_addr_range651w(0) <= rx_addr(0);
	wire_w_rx_addr_range652w(0) <= rx_addr(1);
	wire_n0Oii_data <= ( n0O0i & n0O1O & n0O1l & n0O1i & n0lOO & n0lOl & n0lOi & n0llO & n0lll & n0lli & n0liO & n0lil & n0lii & n0l0O & n0l0l & n0l0i);
	wire_n0Oii_rdaddress <= ( wire_n01i_dataout & wire_n1OO_dataout & wire_n0il_o & wire_n0ii_o & wire_n00O_o & wire_n00l_o & wire_n00i_o);
	wire_n0Oii_wraddress <= ( niOlO & niOli & nl11O & nl11i & niOOO & niOOl & niOOi);
	wire_n0Oii_wren <= wire_nl11l_w_lg_w_lg_ni1OO500w501w(0);
	wire_nl11l_w_lg_w_lg_ni1OO500w501w(0) <= wire_nl11l_w_lg_ni1OO500w(0) AND wire_n0iii_dataout;
	n0Oii :  altdpram
	  GENERIC MAP (
		BYTE_SIZE => 8,
		INDATA_ACLR => "OFF",
		INDATA_REG => "INCLOCK",
		INTENDED_DEVICE_FAMILY => "APEX20KE",
		NUMWORDS => 128,
		OUTDATA_ACLR => "OFF",
		OUTDATA_REG => "UNREGISTERED",
		RAM_BLOCK_TYPE => "AUTO",
		RDADDRESS_ACLR => "OFF",
		RDADDRESS_REG => "OUTCLOCK",
		RDCONTROL_ACLR => "OFF",
		RDCONTROL_REG => "OUTCLOCK",
		READ_DURING_WRITE_MODE_MIXED_PORTS => "DONT_CARE",
		WIDTH => 16,
		WIDTH_BYTEENA => 1,
		WIDTHAD => 7,
		WRADDRESS_ACLR => "OFF",
		WRADDRESS_REG => "INCLOCK",
		WRCONTROL_ACLR => "OFF",
		WRCONTROL_REG => "INCLOCK",
		lpm_hint => "DISABLE_LE_RAM_LIMIT_CHECK=OFF, USE_EAB=ON, WIDTH_BYTEENA_A=1, WIDTH_BYTEENA_B=1"
	  )
	  PORT MAP ( 
		data => wire_n0Oii_data,
		inclock => phy_rx_clk,
		inclocken => wire_vcc,
		outclock => rx_clk,
		outclocken => wire_vcc,
		q => wire_n0Oii_q,
		rdaddress => wire_n0Oii_rdaddress,
		rden => wire_vcc,
		wraddress => wire_n0Oii_wraddress,
		wren => wire_n0Oii_wren
	  );
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlll0l53 <= nlll0l54;
		END IF;
		if (now = 0 ns) then
			nlll0l53 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlll0l54 <= nlll0l53;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlll0O51 <= nlll0O52;
		END IF;
		if (now = 0 ns) then
			nlll0O51 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlll0O52 <= nlll0O51;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nllliO49 <= nllliO50;
		END IF;
		if (now = 0 ns) then
			nllliO49 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nllliO50 <= nllliO49;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlllli47 <= nlllli48;
		END IF;
		if (now = 0 ns) then
			nlllli47 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlllli48 <= nlllli47;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nllOll45 <= nllOll46;
		END IF;
		if (now = 0 ns) then
			nllOll45 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nllOll46 <= nllOll45;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nllOOl43 <= nllOOl44;
		END IF;
		if (now = 0 ns) then
			nllOOl43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nllOOl44 <= nllOOl43;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO00O29 <= nlO00O30;
		END IF;
		if (now = 0 ns) then
			nlO00O29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO00O30 <= nlO00O29;
		END IF;
	END PROCESS;
	wire_nlO00O30_w_lg_q210w(0) <= nlO00O30 XOR nlO00O29;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO01O31 <= nlO01O32;
		END IF;
		if (now = 0 ns) then
			nlO01O31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO01O32 <= nlO01O31;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO0il27 <= nlO0il28;
		END IF;
		if (now = 0 ns) then
			nlO0il27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO0il28 <= nlO0il27;
		END IF;
	END PROCESS;
	wire_nlO0il28_w_lg_w_lg_q205w206w(0) <= NOT wire_nlO0il28_w_lg_q205w(0);
	wire_nlO0il28_w_lg_q205w(0) <= nlO0il28 XOR nlO0il27;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO0li25 <= nlO0li26;
		END IF;
		if (now = 0 ns) then
			nlO0li25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO0li26 <= nlO0li25;
		END IF;
	END PROCESS;
	wire_nlO0li26_w_lg_q198w(0) <= nlO0li26 XOR nlO0li25;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO0lO23 <= nlO0lO24;
		END IF;
		if (now = 0 ns) then
			nlO0lO23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO0lO24 <= nlO0lO23;
		END IF;
	END PROCESS;
	wire_nlO0lO24_w_lg_w_lg_q193w194w(0) <= NOT wire_nlO0lO24_w_lg_q193w(0);
	wire_nlO0lO24_w_lg_q193w(0) <= nlO0lO24 XOR nlO0lO23;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO0Ol21 <= nlO0Ol22;
		END IF;
		if (now = 0 ns) then
			nlO0Ol21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO0Ol22 <= nlO0Ol21;
		END IF;
	END PROCESS;
	wire_nlO0Ol22_w_lg_w_lg_q188w189w(0) <= NOT wire_nlO0Ol22_w_lg_q188w(0);
	wire_nlO0Ol22_w_lg_q188w(0) <= nlO0Ol22 XOR nlO0Ol21;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO10l39 <= nlO10l40;
		END IF;
		if (now = 0 ns) then
			nlO10l39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO10l40 <= nlO10l39;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO11O41 <= nlO11O42;
		END IF;
		if (now = 0 ns) then
			nlO11O41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO11O42 <= nlO11O41;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO1ii37 <= nlO1ii38;
		END IF;
		if (now = 0 ns) then
			nlO1ii37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO1ii38 <= nlO1ii37;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO1iO35 <= nlO1iO36;
		END IF;
		if (now = 0 ns) then
			nlO1iO35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO1iO36 <= nlO1iO35;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO1lO33 <= nlO1lO34;
		END IF;
		if (now = 0 ns) then
			nlO1lO33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlO1lO34 <= nlO1lO33;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOi1i19 <= nlOi1i20;
		END IF;
		if (now = 0 ns) then
			nlOi1i19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOi1i20 <= nlOi1i19;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiil17 <= nlOiil18;
		END IF;
		if (now = 0 ns) then
			nlOiil17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiil18 <= nlOiil17;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiiO15 <= nlOiiO16;
		END IF;
		if (now = 0 ns) then
			nlOiiO15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiiO16 <= nlOiiO15;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOill13 <= nlOill14;
		END IF;
		if (now = 0 ns) then
			nlOill13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOill14 <= nlOill13;
		END IF;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiOi11 <= nlOiOi12;
		END IF;
		if (now = 0 ns) then
			nlOiOi11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiOi12 <= nlOiOi11;
		END IF;
	END PROCESS;
	wire_nlOiOi12_w_lg_w_lg_q153w154w(0) <= wire_nlOiOi12_w_lg_q153w(0) AND n1il;
	wire_nlOiOi12_w_lg_q153w(0) <= nlOiOi12 XOR nlOiOi11;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiOl10 <= nlOiOl9;
		END IF;
	END PROCESS;
	wire_nlOiOl10_w_lg_w_lg_q146w147w(0) <= wire_nlOiOl10_w_lg_q146w(0) AND wire_n0iO_w_o_range145w(0);
	wire_nlOiOl10_w_lg_q146w(0) <= nlOiOl10 XOR nlOiOl9;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiOl9 <= nlOiOl10;
		END IF;
		if (now = 0 ns) then
			nlOiOl9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiOO7 <= nlOiOO8;
		END IF;
		if (now = 0 ns) then
			nlOiOO7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOiOO8 <= nlOiOO7;
		END IF;
	END PROCESS;
	wire_nlOiOO8_w_lg_w_lg_q81w82w(0) <= wire_nlOiOO8_w_lg_q81w(0) AND wire_n0iO_w_o_range80w(0);
	wire_nlOiOO8_w_lg_q81w(0) <= nlOiOO8 XOR nlOiOO7;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOl1i5 <= nlOl1i6;
		END IF;
		if (now = 0 ns) then
			nlOl1i5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOl1i6 <= nlOl1i5;
		END IF;
	END PROCESS;
	wire_nlOl1i6_w_lg_w_lg_q67w68w(0) <= wire_nlOl1i6_w_lg_q67w(0) AND wire_n110i_dataout;
	wire_nlOl1i6_w_lg_q67w(0) <= nlOl1i6 XOR nlOl1i5;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOl1l3 <= nlOl1l4;
		END IF;
		if (now = 0 ns) then
			nlOl1l3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOl1l4 <= nlOl1l3;
		END IF;
	END PROCESS;
	wire_nlOl1l4_w_lg_w_lg_q22w23w(0) <= wire_nlOl1l4_w_lg_q22w(0) AND n1iO;
	wire_nlOl1l4_w_lg_q22w(0) <= nlOl1l4 XOR nlOl1l3;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOl1O1 <= nlOl1O2;
		END IF;
		if (now = 0 ns) then
			nlOl1O1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk)
	BEGIN
		IF (rx_clk = '1' AND rx_clk'event) THEN nlOl1O2 <= nlOl1O1;
		END IF;
	END PROCESS;
	wire_nlOl1O2_w_lg_w_lg_q18w19w(0) <= wire_nlOl1O2_w_lg_q18w(0) AND n1il;
	wire_nlOl1O2_w_lg_q18w(0) <= nlOl1O2 XOR nlOl1O1;
	PROCESS (phy_rx_clk, wire_n00Ol_PRN, wire_n00Ol_CLRN)
	BEGIN
		IF (wire_n00Ol_PRN = '0') THEN
				n00OO <= '1';
		ELSIF (wire_n00Ol_CLRN = '0') THEN
				n00OO <= '0';
		ELSIF (phy_rx_clk = '1' AND phy_rx_clk'event) THEN
				n00OO <= (NOT (nllOil OR (nii1O AND wire_w_lg_nlllll588w(0))));
		END IF;
		if (now = 0 ns) then
			n00OO <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n00Ol_CLRN <= (nlllli48 XOR nlllli47);
	wire_n00Ol_PRN <= ((nllliO50 XOR nllliO49) AND reset);
	PROCESS (rx_clk, wire_n1O0i_PRN, wire_n1O0i_CLRN)
	BEGIN
		IF (wire_n1O0i_PRN = '0') THEN
				n1O0l <= '1';
		ELSIF (wire_n1O0i_CLRN = '0') THEN
				n1O0l <= '0';
		ELSIF (rx_clk = '1' AND rx_clk'event) THEN
			IF (nlll0i = '1') THEN
				n1O0l <= nlllii;
			END IF;
		END IF;
	END PROCESS;
	wire_n1O0i_CLRN <= ((nlll0O52 XOR nlll0O51) AND reset);
	wire_n1O0i_PRN <= (nlll0l54 XOR nlll0l53);
	PROCESS (rx_clk, reset)
	BEGIN
		IF (reset = '0') THEN
				n1O1l <= '1';
		ELSIF (rx_clk = '1' AND rx_clk'event) THEN
				n1O1l <= wire_nlOOll_dataout;
		END IF;
		if (now = 0 ns) then
			n1O1l <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n1O1i_w_lg_n1O1l645w(0) <= NOT n1O1l;
	wire_n1O1i_w_lg_w_lg_n1O1l645w646w(0) <= wire_n1O1i_w_lg_n1O1l645w(0) OR wire_n1ili_dataout;
	PROCESS (rx_clk, wire_n1Oi_PRN, wire_n1Oi_CLRN)
	BEGIN
		IF (wire_n1Oi_PRN = '0') THEN
				n010i <= '1';
				n010l <= '1';
				n010O <= '1';
				n011i <= '1';
				n011l <= '1';
				n011O <= '1';
				n01ii <= '1';
				n01il <= '1';
				n10i <= '1';
				n10l <= '1';
				n10O <= '1';
				n11i <= '1';
				n11l <= '1';
				n11O <= '1';
				n1ii <= '1';
				n1il <= '1';
				n1iO <= '1';
				n1li <= '1';
				n1ll <= '1';
				n1lll <= '1';
				n1llO <= '1';
				n1lO <= '1';
				n1lOi <= '1';
				n1lOl <= '1';
				n1lOO <= '1';
				n1O0O <= '1';
				n1O1O <= '1';
				n1Oii <= '1';
				n1Oil <= '1';
				n1OiO <= '1';
				n1Ol <= '1';
				n1Oli <= '1';
				n1Oll <= '1';
				n1OlO <= '1';
				n1OOi <= '1';
				n1OOl <= '1';
				n1OOO <= '1';
				nlliO <= '1';
				nllli <= '1';
				nllll <= '1';
				nlllO <= '1';
				nllOi <= '1';
				nllOl <= '1';
				nllOO <= '1';
				nlO0i <= '1';
				nlO0l <= '1';
				nlO0O <= '1';
				nlO1i <= '1';
				nlO1l <= '1';
				nlO1O <= '1';
				nlOii <= '1';
				nlOil <= '1';
				nlOiO <= '1';
				nlOli <= '1';
				nlOll <= '1';
				nlOlO <= '1';
				nlOOi <= '1';
				nlOOl <= '1';
				nlOOO <= '1';
				nlOOOl <= '1';
		ELSIF (wire_n1Oi_CLRN = '0') THEN
				n010i <= '0';
				n010l <= '0';
				n010O <= '0';
				n011i <= '0';
				n011l <= '0';
				n011O <= '0';
				n01ii <= '0';
				n01il <= '0';
				n10i <= '0';
				n10l <= '0';
				n10O <= '0';
				n11i <= '0';
				n11l <= '0';
				n11O <= '0';
				n1ii <= '0';
				n1il <= '0';
				n1iO <= '0';
				n1li <= '0';
				n1ll <= '0';
				n1lll <= '0';
				n1llO <= '0';
				n1lO <= '0';
				n1lOi <= '0';
				n1lOl <= '0';
				n1lOO <= '0';
				n1O0O <= '0';
				n1O1O <= '0';
				n1Oii <= '0';
				n1Oil <= '0';
				n1OiO <= '0';
				n1Ol <= '0';
				n1Oli <= '0';
				n1Oll <= '0';
				n1OlO <= '0';
				n1OOi <= '0';
				n1OOl <= '0';
				n1OOO <= '0';
				nlliO <= '0';
				nllli <= '0';
				nllll <= '0';
				nlllO <= '0';
				nllOi <= '0';
				nllOl <= '0';
				nllOO <= '0';
				nlO0i <= '0';
				nlO0l <= '0';
				nlO0O <= '0';
				nlO1i <= '0';
				nlO1l <= '0';
				nlO1O <= '0';
				nlOii <= '0';
				nlOil <= '0';
				nlOiO <= '0';
				nlOli <= '0';
				nlOll <= '0';
				nlOlO <= '0';
				nlOOi <= '0';
				nlOOl <= '0';
				nlOOO <= '0';
				nlOOOl <= '0';
		ELSIF (rx_clk = '1' AND rx_clk'event) THEN
				n010i <= wire_n100l_dataout;
				n010l <= wire_n100O_dataout;
				n010O <= wire_n10ii_dataout;
				n011i <= wire_n101l_dataout;
				n011l <= wire_n101O_dataout;
				n011O <= wire_n100i_dataout;
				n01ii <= wire_n10il_dataout;
				n01il <= rx_enb;
				n10i <= wire_n00l_o;
				n10l <= wire_n00O_o;
				n10O <= wire_n0ii_o;
				n11i <= wire_nl01l_dataout;
				n11l <= wire_nl01O_dataout;
				n11O <= wire_n00i_o;
				n1ii <= wire_n0il_o;
				n1il <= wire_n1OO_dataout;
				n1iO <= wire_n01i_dataout;
				n1li <= wire_nliiO_dataout;
				n1ll <= wire_nlili_dataout;
				n1lll <= (NOT rx_addr(4));
				n1llO <= ((NOT rx_addr(2)) AND (NOT rx_addr(3)));
				n1lO <= wire_nlill_dataout;
				n1lOi <= wire_w_lg_w_rx_addr_range651w654w(0);
				n1lOl <= (wire_w_lg_nlOlii648w(0) AND (nlll1l OR wire_nlOOOO_dataout));
				n1lOO <= (wire_w_lg_nlll1O644w(0) AND wire_n1O1i_w_lg_w_lg_n1O1l645w646w(0));
				n1O0O <= wire_w_lg_nlllil640w(0);
				n1O1O <= wire_n1ili_dataout;
				n1Oii <= wire_n11il_dataout;
				n1Oil <= wire_n11iO_dataout;
				n1OiO <= wire_n11li_dataout;
				n1Ol <= wire_nlilO_dataout;
				n1Oli <= wire_n11ll_dataout;
				n1Oll <= wire_n11lO_dataout;
				n1OlO <= wire_n11Oi_dataout;
				n1OOi <= wire_n11Ol_dataout;
				n1OOl <= wire_n11OO_dataout;
				n1OOO <= wire_n101i_dataout;
				nlliO <= nlOli;
				nllli <= nlOll;
				nllll <= nlOlO;
				nlllO <= nlOOi;
				nllOi <= niilO;
				nllOl <= niiOi;
				nllOO <= niiOl;
				nlO0i <= nllOO;
				nlO0l <= nlO1i;
				nlO0O <= nlOi1O;
				nlO1i <= niiOO;
				nlO1l <= nllOi;
				nlO1O <= nllOl;
				nlOii <= nlOi0i;
				nlOil <= nlOi0l;
				nlOiO <= nlOi0O;
				nlOli <= nlO0O;
				nlOll <= nlOii;
				nlOlO <= nlOil;
				nlOOi <= nlOiO;
				nlOOl <= wire_nl1OO_dataout;
				nlOOO <= wire_nl01i_dataout;
				nlOOOl <= wire_n1l1l_dataout;
		END IF;
		if (now = 0 ns) then
			n010i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n010l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n010O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n011i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n011l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n011O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n01ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n01il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1ll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1lll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1llO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1lO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1lOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1lOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1lOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1O0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1O1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1Oii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1Oil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1OiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1Ol <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1Oli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1Oll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1OlO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1OOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1OOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1OOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlliO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlllO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nllOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOlO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOOl <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n1Oi_CLRN <= ((nlOiiO16 XOR nlOiiO15) AND reset);
	wire_n1Oi_PRN <= (nlOiil18 XOR nlOiil17);
	wire_n1Oi_w_lg_w_lg_w208w211w212w(0) <= wire_n1Oi_w_lg_w208w211w(0) AND nlO00l;
	wire_n1Oi_w_lg_w208w211w(0) <= wire_n1Oi_w208w(0) AND wire_nlO00O30_w_lg_q210w(0);
	wire_n1Oi_w_lg_w_lg_w_lg_w_lg_n11l186w190w196w199w(0) <= wire_n1Oi_w_lg_w_lg_w_lg_n11l186w190w196w(0) AND wire_nlO0li26_w_lg_q198w(0);
	wire_n1Oi_w208w(0) <= wire_n1Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11l186w190w196w199w200w(0) AND wire_n1Oi_w_lg_w_lg_w_lg_w_lg_n11l201w202w203w207w(0);
	wire_n1Oi_w_lg_w_lg_nlOli247w248w(0) <= wire_n1Oi_w_lg_nlOli247w(0) AND nlliO;
	wire_n1Oi_w_lg_w_lg_nlOlO254w255w(0) <= wire_n1Oi_w_lg_nlOlO254w(0) AND nllll;
	wire_n1Oi_w_lg_w_lg_w_lg_n11l186w190w196w(0) <= wire_n1Oi_w_lg_w_lg_n11l186w190w(0) AND wire_n1Oi_w_lg_w_lg_nlOOO191w195w(0);
	wire_n1Oi_w_lg_n1li234w(0) <= n1li AND wire_n1Oi_w_lg_nlO1l233w(0);
	wire_n1Oi_w_lg_n1lO241w(0) <= n1lO AND wire_n1Oi_w_lg_nlO0i240w(0);
	wire_n1Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11l186w190w196w199w200w(0) <= NOT wire_n1Oi_w_lg_w_lg_w_lg_w_lg_n11l186w190w196w199w(0);
	wire_n1Oi_w_lg_n11i177w(0) <= NOT n11i;
	wire_n1Oi_w_lg_n11l176w(0) <= NOT n11l;
	wire_n1Oi_w_lg_nlO0i240w(0) <= NOT nlO0i;
	wire_n1Oi_w_lg_nlO0l245w(0) <= NOT nlO0l;
	wire_n1Oi_w_lg_nlO1l233w(0) <= NOT nlO1l;
	wire_n1Oi_w_lg_nlO1O238w(0) <= NOT nlO1O;
	wire_n1Oi_w_lg_nlOli247w(0) <= NOT nlOli;
	wire_n1Oi_w_lg_nlOll252w(0) <= NOT nlOll;
	wire_n1Oi_w_lg_nlOlO254w(0) <= NOT nlOlO;
	wire_n1Oi_w_lg_nlOOi259w(0) <= NOT nlOOi;
	wire_n1Oi_w_lg_nlOOl181w(0) <= NOT nlOOl;
	wire_n1Oi_w_lg_nlOOO179w(0) <= NOT nlOOO;
	wire_n1Oi_w_lg_w_lg_n11l186w190w(0) <= wire_n1Oi_w_lg_n11l186w(0) OR wire_nlO0Ol22_w_lg_w_lg_q188w189w(0);
	wire_n1Oi_w_lg_w_lg_nlOOO191w195w(0) <= wire_n1Oi_w_lg_nlOOO191w(0) OR wire_nlO0lO24_w_lg_w_lg_q193w194w(0);
	wire_n1Oi_w_lg_n11l186w(0) <= n11l OR n11i;
	wire_n1Oi_w_lg_nlOOO191w(0) <= nlOOO OR nlOOl;
	wire_n1Oi_w_lg_w_lg_w_lg_w_lg_n11l201w202w203w207w(0) <= wire_n1Oi_w_lg_w_lg_w_lg_n11l201w202w203w(0) XOR wire_nlO0il28_w_lg_w_lg_q205w206w(0);
	wire_n1Oi_w_lg_w_lg_w_lg_n11l201w202w203w(0) <= wire_n1Oi_w_lg_w_lg_n11l201w202w(0) XOR nlOOl;
	wire_n1Oi_w_lg_w_lg_n11l201w202w(0) <= wire_n1Oi_w_lg_n11l201w(0) XOR nlOOO;
	wire_n1Oi_w_lg_n11l201w(0) <= n11l XOR n11i;
	PROCESS (phy_rx_clk, reset)
	BEGIN
		IF (reset = '0') THEN
				niOli <= '0';
				niOlO <= '0';
		ELSIF (phy_rx_clk = '1' AND phy_rx_clk'event) THEN
			IF (nllOli = '1') THEN
				niOli <= wire_nl1li_o(0);
				niOlO <= wire_nl1li_o(1);
			END IF;
		END IF;
		if (now = 0 ns) then
			niOli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niOlO <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (phy_rx_clk, wire_nl11l_CLRN)
	BEGIN
		IF (wire_nl11l_CLRN = '0') THEN
				n0iOl <= '0';
				n0iOO <= '0';
				n0l0i <= '0';
				n0l0l <= '0';
				n0l0O <= '0';
				n0l1i <= '0';
				n0l1l <= '0';
				n0l1O <= '0';
				n0lii <= '0';
				n0lil <= '0';
				n0liO <= '0';
				n0lli <= '0';
				n0lll <= '0';
				n0llO <= '0';
				n0lOi <= '0';
				n0lOl <= '0';
				n0lOO <= '0';
				n0O0i <= '0';
				n0O1i <= '0';
				n0O1l <= '0';
				n0O1O <= '0';
				ni1OO <= '0';
				nii1O <= '0';
				niilO <= '0';
				niiOi <= '0';
				niiOl <= '0';
				niiOO <= '0';
				nil0i <= '0';
				nil0l <= '0';
				nil0O <= '0';
				nil1i <= '0';
				nil1l <= '0';
				nil1O <= '0';
				nilii <= '0';
				nilil <= '0';
				niliO <= '0';
				nilli <= '0';
				nilll <= '0';
				nillO <= '0';
				nilOi <= '0';
				nilOl <= '0';
				nilOO <= '0';
				niO0i <= '0';
				niO0l <= '0';
				niO0O <= '0';
				niO1i <= '0';
				niO1l <= '0';
				niO1O <= '0';
				niOii <= '0';
				niOil <= '0';
				niOiO <= '0';
				niOOi <= '0';
				niOOl <= '0';
				niOOO <= '0';
				nl11i <= '0';
				nl11O <= '0';
		ELSIF (phy_rx_clk = '1' AND phy_rx_clk'event) THEN
				n0iOl <= wire_w_lg_nllOil550w(0);
				n0iOO <= n0iOl;
				n0l0i <= phy_rx_data(0);
				n0l0l <= phy_rx_data(1);
				n0l0O <= phy_rx_data(2);
				n0l1i <= wire_n0ill_dataout;
				n0l1l <= phy_rx_soc;
				n0l1O <= phy_rx_valid;
				n0lii <= phy_rx_data(3);
				n0lil <= phy_rx_data(4);
				n0liO <= phy_rx_data(5);
				n0lli <= phy_rx_data(6);
				n0lll <= phy_rx_data(7);
				n0llO <= phy_rx_data(8);
				n0lOi <= phy_rx_data(9);
				n0lOl <= phy_rx_data(10);
				n0lOO <= phy_rx_data(11);
				n0O0i <= phy_rx_data(15);
				n0O1i <= phy_rx_data(12);
				n0O1l <= phy_rx_data(13);
				n0O1O <= phy_rx_data(14);
				ni1OO <= (((wire_ni11i_dataout AND wire_n0OOO_dataout) AND wire_n0OOl_dataout) AND wire_n0OOi_dataout);
				nii1O <= nllOiO;
				niilO <= nil0l;
				niiOi <= nil0O;
				niiOl <= nilii;
				niiOO <= nilil;
				nil0i <= nlO01i;
				nil0l <= nil1i;
				nil0O <= nil1l;
				nil1i <= nlO1ll;
				nil1l <= nlO1Ol;
				nil1O <= nlO1OO;
				nilii <= nil1O;
				nilil <= nil0i;
				niliO <= nlliO;
				nilli <= nllli;
				nilll <= nllll;
				nillO <= nlllO;
				nilOi <= niliO;
				nilOl <= nilli;
				nilOO <= nilll;
				niO0i <= wire_ni0ll_dataout;
				niO0l <= wire_ni0lO_dataout;
				niO0O <= wire_n0OOi_dataout;
				niO1i <= nillO;
				niO1l <= wire_ni0iO_dataout;
				niO1O <= wire_ni0li_dataout;
				niOii <= wire_n0OOl_dataout;
				niOil <= wire_n0OOO_dataout;
				niOiO <= wire_ni11i_dataout;
				niOOi <= wire_nl10i_o;
				niOOl <= wire_nl10l_o;
				niOOO <= wire_nl10O_o;
				nl11i <= wire_nl1ii_o;
				nl11O <= wire_nl1il_o;
		END IF;
		if (now = 0 ns) then
			n0iOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0iOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0l0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0l0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0l0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0l1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0l1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0l1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0lii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0lil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0liO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0lli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0lll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0llO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0lOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0lOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0lOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0O0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0O1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0O1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0O1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni1OO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niilO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niiOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niiOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niiOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nil0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nil0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nil0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nil1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nil1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nil1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nilii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nilil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niliO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nilli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nilll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nillO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nilOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nilOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nilOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niO0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niO0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niO0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niO1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niO1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niO1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niOii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niOil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niOiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niOOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niOOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niOOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl11i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl11O <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nl11l_CLRN <= ((nllOll46 XOR nllOll45) AND reset);
	wire_nl11l_w_lg_w_lg_w_lg_niOiO409w416w417w(0) <= wire_nl11l_w_lg_w_lg_niOiO409w416w(0) AND niO0O;
	wire_nl11l_w_lg_w_lg_niOiO409w416w(0) <= wire_nl11l_w_lg_niOiO409w(0) AND niOii;
	wire_nl11l_w_lg_niOiO409w(0) <= niOiO AND niOil;
	wire_nl11l_w_lg_ni1OO500w(0) <= NOT ni1OO;
	wire_nl11l_w_lg_niilO437w(0) <= NOT niilO;
	wire_nl11l_w_lg_niiOi439w(0) <= NOT niiOi;
	wire_nl11l_w_lg_niiOl441w(0) <= NOT niiOl;
	wire_nl11l_w_lg_niiOO443w(0) <= NOT niiOO;
	wire_nl11l_w_lg_nilOi429w(0) <= NOT nilOi;
	wire_nl11l_w_lg_nilOl431w(0) <= NOT nilOl;
	wire_nl11l_w_lg_nilOO433w(0) <= NOT nilOO;
	wire_nl11l_w_lg_niO1i435w(0) <= NOT niO1i;
	wire_nl11l_w_lg_w_lg_w_lg_niOiO412w413w414w(0) <= wire_nl11l_w_lg_w_lg_niOiO412w413w(0) XOR niO0O;
	wire_nl11l_w_lg_w_lg_niOiO412w413w(0) <= wire_nl11l_w_lg_niOiO412w(0) XOR niOii;
	wire_nl11l_w_lg_niOiO412w(0) <= niOiO XOR niOil;
	wire_n01li_w_lg_w_q_range579w606w(0) <= wire_n01li_w_q_range579w(0) XOR wire_n0O0l_w_lg_w_o_range604w605w(0);
	wire_n01li_w_lg_w_q_range582w609w(0) <= wire_n01li_w_q_range582w(0) XOR wire_n0O0l_w_lg_w_o_range604w605w(0);
	wire_n01li_aclr <= wire_w_lg_reset625w(0);
	wire_n01li_w_q_range579w(0) <= wire_n01li_q(3);
	wire_n01li_w_q_range582w(0) <= wire_n01li_q(4);
	n01li :  lpm_counter
	  GENERIC MAP (
		LPM_DIRECTION => "UP",
		LPM_MODULUS => 0,
		LPM_PORT_UPDOWN => "PORT_CONNECTIVITY",
		LPM_SVALUE => "0",
		LPM_WIDTH => 6
	  )
	  PORT MAP ( 
		aclr => wire_n01li_aclr,
		clock => phy_rx_clk,
		cnt_en => wire_n0i1l_dataout,
		q => wire_n01li_q,
		sset => wire_n0i1O_dataout
	  );
	wire_nlOlil_w_lg_w_q_range710w737w(0) <= wire_nlOlil_w_q_range710w(0) AND wire_nlOlil_w_lg_w_q_range712w736w(0);
	wire_nlOlil_w_lg_w_q_range712w736w(0) <= NOT wire_nlOlil_w_q_range712w(0);
	wire_nlOlil_w_lg_w_q_range722w725w(0) <= wire_nlOlil_w_q_range722w(0) XOR wire_n01iO_w_lg_w_o_range723w724w(0);
	wire_nlOlil_w_lg_w_q_range728w729w(0) <= wire_nlOlil_w_q_range728w(0) XOR wire_n01iO_w_lg_w_o_range723w724w(0);
	wire_nlOlil_aclr <= wire_w_lg_reset625w(0);
	wire_nlOlil_w_q_range710w(0) <= wire_nlOlil_q(0);
	wire_nlOlil_w_q_range712w(0) <= wire_nlOlil_q(1);
	wire_nlOlil_w_q_range722w(0) <= wire_nlOlil_q(3);
	wire_nlOlil_w_q_range728w(0) <= wire_nlOlil_q(4);
	nlOlil :  lpm_counter
	  GENERIC MAP (
		LPM_DIRECTION => "UP",
		LPM_MODULUS => 0,
		LPM_PORT_UPDOWN => "PORT_CONNECTIVITY",
		LPM_SVALUE => "0",
		LPM_WIDTH => 6
	  )
	  PORT MAP ( 
		aclr => wire_nlOlil_aclr,
		clock => rx_clk,
		cnt_en => nlll0i,
		q => wire_nlOlil_q,
		sset => wire_nlOOOO_dataout
	  );
	wire_n01i_dataout <= n1iO WHEN wire_w_lg_nlOili171w(0) = '1'  ELSE wire_n01O_o(1);
	wire_n0i0i_dataout <= (n0l1l AND nlllOl) OR NOT(nlllOi);
	wire_n0i1l_dataout <= wire_n0i0i_dataout AND nllO1i;
	wire_n0i1O_dataout <= nllllO AND nllO1i;
	wire_n0iii_dataout <= (wire_w_lg_nllO1l551w(0) OR (nllO1l AND n0l1l)) AND nllO1i;
	wire_n0iii_w_lg_w_lg_dataout451w452w(0) <= wire_n0iii_w_lg_dataout451w(0) AND wire_n0iil_dataout;
	wire_n0iii_w_lg_dataout451w(0) <= NOT wire_n0iii_dataout;
	wire_n0iil_dataout <= nlllOO AND nllO1i;
	wire_n0iil_w_lg_dataout418w(0) <= wire_n0iil_dataout OR wire_n0i1i_o;
	wire_n0ill_dataout <= wire_n0ilO_dataout WHEN nllO1i = '1'  ELSE n0l1i;
	wire_n0ill_w_lg_dataout449w(0) <= NOT wire_n0ill_dataout;
	wire_n0ilO_dataout <= wire_n0iOi_dataout AND NOT(nllO1l);
	wire_n0iOi_dataout <= n0l1i OR n0l1l;
	wire_n0OOi_dataout <= (nllO0O AND (niO0O OR wire_nl1iO_o(0))) WHEN nllOii = '1'  ELSE (niO0O AND nllO0O);
	wire_n0OOl_dataout <= (nllO0l AND (niOii OR wire_nl1iO_o(1))) WHEN nllOii = '1'  ELSE (niOii AND nllO0l);
	wire_n0OOO_dataout <= (nllO0i AND (niOil OR wire_nl1iO_o(2))) WHEN nllOii = '1'  ELSE (niOil AND nllO0i);
	wire_n100i_dataout <= wire_n1i0l_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(11);
	wire_n100l_dataout <= wire_n1i0O_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(12);
	wire_n100O_dataout <= wire_n1iii_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(13);
	wire_n101i_dataout <= wire_n1i1l_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(8);
	wire_n101l_dataout <= wire_n1i1O_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(9);
	wire_n101O_dataout <= wire_n1i0i_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(10);
	wire_n10ii_dataout <= wire_n1iil_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(14);
	wire_n10il_dataout <= wire_n1iiO_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(15);
	wire_n10iO_dataout <= wire_n0Oii_q(0) WHEN nlll1O = '1'  ELSE n1Oii;
	wire_n10li_dataout <= wire_n0Oii_q(1) WHEN nlll1O = '1'  ELSE n1Oil;
	wire_n10ll_dataout <= wire_n0Oii_q(2) WHEN nlll1O = '1'  ELSE n1OiO;
	wire_n10lO_dataout <= wire_n0Oii_q(3) WHEN nlll1O = '1'  ELSE n1Oli;
	wire_n10Oi_dataout <= wire_n0Oii_q(4) WHEN nlll1O = '1'  ELSE n1Oll;
	wire_n10Ol_dataout <= wire_n0Oii_q(5) WHEN nlll1O = '1'  ELSE n1OlO;
	wire_n10OO_dataout <= wire_n0Oii_q(6) WHEN nlll1O = '1'  ELSE n1OOi;
	wire_n110i_dataout <= nlll1O OR (nlll0i AND (NOT (wire_nlOOll_dataout AND nlliOl)));
	wire_n110i_w_lg_w_lg_dataout164w165w(0) <= wire_n110i_w_lg_dataout164w(0) AND wire_n11ii_dataout;
	wire_n110i_w_lg_dataout164w(0) <= NOT wire_n110i_dataout;
	wire_n11ii_dataout <= n1O0l AND nlll0i;
	wire_n11il_dataout <= wire_n10iO_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(0);
	wire_n11iO_dataout <= wire_n10li_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(1);
	wire_n11li_dataout <= wire_n10ll_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(2);
	wire_n11ll_dataout <= wire_n10lO_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(3);
	wire_n11lO_dataout <= wire_n10Oi_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(4);
	wire_n11Oi_dataout <= wire_n10Ol_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(5);
	wire_n11Ol_dataout <= wire_n10OO_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(6);
	wire_n11OO_dataout <= wire_n1i1i_dataout WHEN wire_w_lg_nlll0i701w(0) = '1'  ELSE wire_n0Oii_q(7);
	wire_n1i0i_dataout <= wire_n0Oii_q(10) WHEN nlll1O = '1'  ELSE n011l;
	wire_n1i0l_dataout <= wire_n0Oii_q(11) WHEN nlll1O = '1'  ELSE n011O;
	wire_n1i0O_dataout <= wire_n0Oii_q(12) WHEN nlll1O = '1'  ELSE n010i;
	wire_n1i1i_dataout <= wire_n0Oii_q(7) WHEN nlll1O = '1'  ELSE n1OOl;
	wire_n1i1l_dataout <= wire_n0Oii_q(8) WHEN nlll1O = '1'  ELSE n1OOO;
	wire_n1i1O_dataout <= wire_n0Oii_q(9) WHEN nlll1O = '1'  ELSE n011i;
	wire_n1iii_dataout <= wire_n0Oii_q(13) WHEN nlll1O = '1'  ELSE n010l;
	wire_n1iil_dataout <= wire_n0Oii_q(14) WHEN nlll1O = '1'  ELSE n010O;
	wire_n1iiO_dataout <= wire_n0Oii_q(15) WHEN nlll1O = '1'  ELSE n01ii;
	wire_n1ili_dataout <= wire_n1ill_dataout OR nlliOO;
	wire_n1ill_dataout <= n1O1O AND NOT((nlll0i AND nlll1i));
	wire_n1l1l_dataout <= wire_n1l1O_dataout AND NOT(rx_enb);
	wire_n1l1O_dataout <= nlOOOl OR (nlOl0i AND (n01il AND wire_w_lg_rx_enb679w(0)));
	wire_n1OO_dataout <= n1il WHEN wire_w_lg_nlOili171w(0) = '1'  ELSE wire_n01O_o(0);
	wire_ni0iO_dataout <= (wire_nl1iO_o(0) OR nlOi1O) WHEN nllOii = '1'  ELSE nlOi1O;
	wire_ni0li_dataout <= (wire_nl1iO_o(1) OR nlOi0i) WHEN nllOii = '1'  ELSE nlOi0i;
	wire_ni0ll_dataout <= (wire_nl1iO_o(2) OR nlOi0l) WHEN nllOii = '1'  ELSE nlOi0l;
	wire_ni0lO_dataout <= (wire_nl1iO_o(3) OR nlOi0O) WHEN nllOii = '1'  ELSE nlOi0O;
	wire_ni11i_dataout <= (nllO1O AND (niOiO OR wire_nl1iO_o(3))) WHEN nllOii = '1'  ELSE (niOiO AND nllO1O);
	wire_nl01i_dataout <= (nlO11i OR (nlOOO AND (NOT wire_n0li_o(1)))) WHEN wire_n11ii_dataout = '1'  ELSE (nlOOO OR nlO11i);
	wire_nl01l_dataout <= (nllOOi OR (n11i AND (NOT wire_n0li_o(2)))) WHEN wire_n11ii_dataout = '1'  ELSE (n11i OR nllOOi);
	wire_nl01O_dataout <= (nllOlO OR (n11l AND (NOT wire_n0li_o(3)))) WHEN wire_n11ii_dataout = '1'  ELSE (n11l OR nllOlO);
	wire_nl1OO_dataout <= (nlO11l OR (nlOOl AND (NOT wire_n0li_o(0)))) WHEN wire_n11ii_dataout = '1'  ELSE (nlOOl OR nlO11l);
	wire_nliiO_dataout <= (wire_n0li_w_lg_w_o_range227w228w(0) OR (NOT (nlO1iO36 XOR nlO1iO35))) WHEN wire_n11ii_dataout = '1'  ELSE nlO1ll;
	wire_nlili_dataout <= (wire_n0li_w_lg_w_o_range221w222w(0) OR (NOT (nlO1lO34 XOR nlO1lO33))) WHEN wire_n11ii_dataout = '1'  ELSE nlO1Ol;
	wire_nlill_dataout <= (wire_n0li_o(2) OR nlO1OO) WHEN wire_n11ii_dataout = '1'  ELSE nlO1OO;
	wire_nlilO_dataout <= (wire_n0li_o(3) OR nlO01i) WHEN wire_n11ii_dataout = '1'  ELSE nlO01i;
	wire_nlOOll_dataout <= wire_nlOOlO_dataout OR nlO01l;
	wire_nlOOll_w_lg_dataout708w(0) <= NOT wire_nlOOll_dataout;
	wire_nlOOlO_dataout <= n1O1l AND NOT((nlll1l AND wire_w_lg_nlO01l706w(0)));
	wire_nlOOOO_dataout <= nlliOl AND nlll0i;
	wire_n01iO_w_lg_w_o_range723w724w(0) <= NOT wire_n01iO_w_o_range723w(0);
	wire_n01iO_a <= ( "0" & "0" & "0");
	wire_n01iO_b <= ( "0" & "0" & "1");
	wire_n01iO_w_o_range723w(0) <= wire_n01iO_o(2);
	n01iO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_n01iO_a,
		b => wire_n01iO_b,
		cin => wire_gnd,
		o => wire_n01iO_o
	  );
	wire_n01O_a <= ( n1iO & wire_nlOiOi12_w_lg_w_lg_q153w154w);
	wire_n01O_b <= ( "0" & "1");
	n01O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 2,
		width_b => 2,
		width_o => 2
	  )
	  PORT MAP ( 
		a => wire_n01O_a,
		b => wire_n01O_b,
		cin => wire_gnd,
		o => wire_n01O_o
	  );
	wire_n0iO_a <= ( n1ii & n10O & n10l & n10i & n11O);
	wire_n0iO_b <= ( "0" & "0" & "0" & "0" & "1");
	wire_n0iO_w_o_range80w(0) <= wire_n0iO_o(3);
	wire_n0iO_w_o_range145w(0) <= wire_n0iO_o(0);
	n0iO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_n0iO_a,
		b => wire_n0iO_b,
		cin => wire_gnd,
		o => wire_n0iO_o
	  );
	wire_n0O0l_w_lg_w_o_range604w605w(0) <= NOT wire_n0O0l_w_o_range604w(0);
	wire_n0O0l_a <= ( "0" & "0" & "0");
	wire_n0O0l_b <= ( "0" & "0" & "1");
	wire_n0O0l_w_o_range604w(0) <= wire_n0O0l_o(2);
	n0O0l :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_n0O0l_a,
		b => wire_n0O0l_b,
		cin => wire_gnd,
		o => wire_n0O0l_o
	  );
	wire_n0O0O_w_lg_w_o_range565w566w(0) <= NOT wire_n0O0O_w_o_range565w(0);
	wire_n0O0O_a <= ( "0" & "0" & "0" & "0");
	wire_n0O0O_b <= ( "0" & "0" & "0" & "1");
	wire_n0O0O_w_o_range565w(0) <= wire_n0O0O_o(3);
	n0O0O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_n0O0O_a,
		b => wire_n0O0O_b,
		cin => wire_gnd,
		o => wire_n0O0O_o
	  );
	wire_nl1li_a <= ( niOlO & niOli);
	wire_nl1li_b <= ( "0" & "1");
	nl1li :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 2,
		width_b => 2,
		width_o => 2
	  )
	  PORT MAP ( 
		a => wire_nl1li_a,
		b => wire_nl1li_b,
		cin => wire_gnd,
		o => wire_nl1li_o
	  );
	wire_nl1ll_a <= ( nl11O & nl11i & niOOO & niOOl & niOOi);
	wire_nl1ll_b <= ( "0" & "0" & "0" & "0" & "1");
	nl1ll :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_nl1ll_a,
		b => wire_nl1ll_b,
		cin => wire_gnd,
		o => wire_nl1ll_o
	  );
	wire_n0li_w_lg_w_o_range227w228w(0) <= wire_n0li_w_o_range227w(0) OR nlO1ll;
	wire_n0li_w_lg_w_o_range221w222w(0) <= wire_n0li_w_o_range221w(0) OR nlO1Ol;
	wire_n0li_i <= ( wire_nlOl1l4_w_lg_w_lg_q22w23w & wire_nlOl1O2_w_lg_w_lg_q18w19w);
	wire_n0li_w_o_range227w(0) <= wire_n0li_o(0);
	wire_n0li_w_o_range221w(0) <= wire_n0li_o(1);
	n0li :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n0li_i,
		o => wire_n0li_o
	  );
	wire_nl1iO_i <= ( niOlO & niOli);
	nl1iO :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_nl1iO_i,
		o => wire_nl1iO_o
	  );
	wire_n0i1i_a <= ( wire_n0O0O_o(3) & wire_n0O0O_w_lg_w_o_range565w566w & wire_n0O0O_w_lg_w_o_range565w566w & wire_n0O0O_o(2 DOWNTO 0));
	wire_n0i1i_b <= ( wire_n01li_q(5 DOWNTO 0));
	n0i1i :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6
	  )
	  PORT MAP ( 
		a => wire_n0i1i_a,
		b => wire_n0i1i_b,
		cin => wire_vcc,
		o => wire_n0i1i_o
	  );
	wire_n00i_data <= ( "0" & "0" & wire_nlOiOl10_w_lg_w_lg_q146w147w & "0" & "0" & "0" & n11O & "0");
	wire_n00i_sel <= ( wire_n110i_dataout & wire_n11ii_dataout & "1");
	n00i :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00i_data,
		o => wire_n00i_o,
		sel => wire_n00i_sel
	  );
	wire_n00l_data <= ( "0" & "0" & wire_n0iO_o(1) & "0" & "0" & "0" & n10i & "0");
	wire_n00l_sel <= ( wire_n110i_dataout & wire_n11ii_dataout & "1");
	n00l :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00l_data,
		o => wire_n00l_o,
		sel => wire_n00l_sel
	  );
	wire_n00O_data <= ( "0" & "0" & wire_n0iO_o(2) & "0" & "0" & "0" & n10l & "0");
	wire_n00O_sel <= ( wire_n110i_dataout & wire_n11ii_dataout & "1");
	n00O :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n00O_data,
		o => wire_n00O_o,
		sel => wire_n00O_sel
	  );
	wire_n0ii_data <= ( "0" & "0" & wire_nlOiOO8_w_lg_w_lg_q81w82w & "0" & "0" & "0" & n10O & "0");
	wire_n0ii_sel <= ( wire_nlOl1i6_w_lg_w_lg_q67w68w & wire_n11ii_dataout & "1");
	n0ii :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0ii_data,
		o => wire_n0ii_o,
		sel => wire_n0ii_sel
	  );
	wire_n0il_data <= ( "0" & "0" & wire_n0iO_o(4) & "0" & "0" & "0" & n1ii & "0");
	wire_n0il_sel <= ( wire_n110i_dataout & wire_n11ii_dataout & "1");
	n0il :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0il_data,
		o => wire_n0il_o,
		sel => wire_n0il_sel
	  );
	wire_nl10i_data <= ( "0" & "0" & wire_nl1ll_o(0) & "0" & niOOi & "0" & niOOi & "0");
	wire_nl10i_sel <= ( wire_n0iii_dataout & wire_n0iil_dataout & "1");
	nl10i :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl10i_data,
		o => wire_nl10i_o,
		sel => wire_nl10i_sel
	  );
	wire_nl10l_data <= ( "0" & "0" & wire_nl1ll_o(1) & "0" & niOOl & "0" & niOOl & "0");
	wire_nl10l_sel <= ( wire_n0iii_dataout & wire_n0iil_dataout & "1");
	nl10l :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl10l_data,
		o => wire_nl10l_o,
		sel => wire_nl10l_sel
	  );
	wire_nl10O_data <= ( "0" & "0" & wire_nl1ll_o(2) & "0" & niOOO & "0" & niOOO & "0");
	wire_nl10O_sel <= ( wire_n0iii_dataout & wire_n0iil_dataout & "1");
	nl10O :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl10O_data,
		o => wire_nl10O_o,
		sel => wire_nl10O_sel
	  );
	wire_nl1ii_data <= ( "0" & "0" & wire_nl1ll_o(3) & "0" & nl11i & "0" & nl11i & "0");
	wire_nl1ii_sel <= ( wire_n0iii_dataout & wire_n0iil_dataout & "1");
	nl1ii :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl1ii_data,
		o => wire_nl1ii_o,
		sel => wire_nl1ii_sel
	  );
	wire_nl1il_data <= ( "0" & "0" & wire_nl1ll_o(4) & "0" & nl11O & "0" & nl11O & "0");
	wire_nl1il_sel <= ( wire_n0iii_dataout & wire_n0iil_dataout & "1");
	nl1il :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nl1il_data,
		o => wire_nl1il_o,
		sel => wire_nl1il_sel
	  );

 END RTL; --slaverx1_example
--synopsys translate_on
--VALID FILE
