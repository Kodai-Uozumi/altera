--IP Functional Simulation Model
--VERSION_BEGIN 6.0 cbx_mgl 2006:03:29:17:46:26:SJ cbx_simgen 2006:03:22:01:13:28:SJ  VERSION_END


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

 LIBRARY sgate;
 USE sgate.sgate_pack.all;

--synthesis_resources = altsyncram 1 lut 356 mux21 131 oper_add 14 oper_less_than 4 oper_selector 10 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  auk_pac_mrx_pl3_link IS 
	 PORT 
	 ( 
		 a_rdat	:	IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 a_renb	:	OUT  STD_LOGIC;
		 a_reop	:	IN  STD_LOGIC;
		 a_rerr	:	IN  STD_LOGIC;
		 a_rfclk	:	IN  STD_LOGIC;
		 a_rmod	:	IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 a_rprty	:	IN  STD_LOGIC;
		 a_rreset_n	:	IN  STD_LOGIC;
		 a_rsop	:	IN  STD_LOGIC;
		 a_rval	:	IN  STD_LOGIC;
		 b_clk	:	IN  STD_LOGIC;
		 b_dat	:	OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 b_dav	:	OUT  STD_LOGIC;
		 b_ena	:	IN  STD_LOGIC;
		 b_eop	:	OUT  STD_LOGIC;
		 b_err	:	OUT  STD_LOGIC;
		 b_mty	:	OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 b_par	:	OUT  STD_LOGIC;
		 b_reset_n	:	IN  STD_LOGIC;
		 b_sop	:	OUT  STD_LOGIC;
		 b_val	:	OUT  STD_LOGIC
	 ); 
 END auk_pac_mrx_pl3_link;

 ARCHITECTURE RTL OF auk_pac_mrx_pl3_link IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL  wire_n111O_w_lg_w_q_b_range98w653w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n111O_address_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n111O_address_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_vcc	:	STD_LOGIC;
	 SIGNAL  wire_n111O_data_a	:	STD_LOGIC_VECTOR (37 DOWNTO 0);
	 SIGNAL  wire_n111O_q_b	:	STD_LOGIC_VECTOR (37 DOWNTO 0);
	 SIGNAL  wire_n111O_w_q_b_range98w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 niOOOO58	:	STD_LOGIC := '1';
	 SIGNAL	 niOOOO59	:	STD_LOGIC := '1';
	 SIGNAL  wire_niOOOO59_w_lg_Q357w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 niOOOO60	:	STD_LOGIC := '0';
	 SIGNAL	 nl100l4	:	STD_LOGIC := '1';
	 SIGNAL	 nl100l5	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl100l5_w_lg_Q116w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl100l6	:	STD_LOGIC := '0';
	 SIGNAL	 nl101i10	:	STD_LOGIC := '1';
	 SIGNAL	 nl101i11	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl101i11_w_lg_Q133w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl101i12	:	STD_LOGIC := '0';
	 SIGNAL	 nl101l7	:	STD_LOGIC := '1';
	 SIGNAL	 nl101l8	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl101l8_w_lg_Q129w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl101l9	:	STD_LOGIC := '0';
	 SIGNAL	 nl10il1	:	STD_LOGIC := '1';
	 SIGNAL	 nl10il2	:	STD_LOGIC := '1';
	 SIGNAL	 nl10il3	:	STD_LOGIC := '0';
	 SIGNAL	 nl110i46	:	STD_LOGIC := '1';
	 SIGNAL	 nl110i47	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl110i47_w_lg_Q330w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl110i48	:	STD_LOGIC := '0';
	 SIGNAL	 nl110l43	:	STD_LOGIC := '1';
	 SIGNAL	 nl110l44	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl110l44_w_lg_Q318w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl110l45	:	STD_LOGIC := '0';
	 SIGNAL	 nl110O40	:	STD_LOGIC := '1';
	 SIGNAL	 nl110O41	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl110O41_w_lg_Q213w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl110O42	:	STD_LOGIC := '0';
	 SIGNAL	 nl111i55	:	STD_LOGIC := '1';
	 SIGNAL	 nl111i56	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl111i56_w_lg_Q349w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl111i57	:	STD_LOGIC := '0';
	 SIGNAL	 nl111l52	:	STD_LOGIC := '1';
	 SIGNAL	 nl111l53	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl111l53_w_lg_Q340w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl111l54	:	STD_LOGIC := '0';
	 SIGNAL	 nl111O49	:	STD_LOGIC := '1';
	 SIGNAL	 nl111O50	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl111O50_w_lg_Q334w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl111O51	:	STD_LOGIC := '0';
	 SIGNAL	 nl11ii37	:	STD_LOGIC := '1';
	 SIGNAL	 nl11ii38	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11ii38_w_lg_Q210w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11ii39	:	STD_LOGIC := '0';
	 SIGNAL	 nl11il34	:	STD_LOGIC := '1';
	 SIGNAL	 nl11il35	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11il35_w_lg_Q200w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11il36	:	STD_LOGIC := '0';
	 SIGNAL	 nl11iO31	:	STD_LOGIC := '1';
	 SIGNAL	 nl11iO32	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11iO32_w_lg_Q197w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11iO33	:	STD_LOGIC := '0';
	 SIGNAL	 nl11li28	:	STD_LOGIC := '1';
	 SIGNAL	 nl11li29	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11li29_w_lg_Q193w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11li30	:	STD_LOGIC := '0';
	 SIGNAL	 nl11ll25	:	STD_LOGIC := '1';
	 SIGNAL	 nl11ll26	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11ll26_w_lg_Q185w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11ll27	:	STD_LOGIC := '0';
	 SIGNAL	 nl11lO22	:	STD_LOGIC := '1';
	 SIGNAL	 nl11lO23	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11lO23_w_lg_Q181w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11lO24	:	STD_LOGIC := '0';
	 SIGNAL	 nl11Oi19	:	STD_LOGIC := '1';
	 SIGNAL	 nl11Oi20	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11Oi20_w_lg_Q177w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11Oi21	:	STD_LOGIC := '0';
	 SIGNAL	 nl11Ol16	:	STD_LOGIC := '1';
	 SIGNAL	 nl11Ol17	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11Ol17_w_lg_Q167w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11Ol18	:	STD_LOGIC := '0';
	 SIGNAL	 nl11OO13	:	STD_LOGIC := '1';
	 SIGNAL	 nl11OO14	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl11OO14_w_lg_Q157w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl11OO15	:	STD_LOGIC := '0';
	 SIGNAL	n000i	:	STD_LOGIC := '1';
	 SIGNAL	n000l	:	STD_LOGIC := '1';
	 SIGNAL	n001i	:	STD_LOGIC := '1';
	 SIGNAL	n001l	:	STD_LOGIC := '1';
	 SIGNAL	n001O	:	STD_LOGIC := '1';
	 SIGNAL	n00ii	:	STD_LOGIC := '1';
	 SIGNAL	n01OO	:	STD_LOGIC := '1';
	 SIGNAL	n1O0i	:	STD_LOGIC := '1';
	 SIGNAL	n1O0l	:	STD_LOGIC := '1';
	 SIGNAL	n1O0O	:	STD_LOGIC := '1';
	 SIGNAL	n1O1O	:	STD_LOGIC := '1';
	 SIGNAL	n1Oii	:	STD_LOGIC := '1';
	 SIGNAL	n1Oil	:	STD_LOGIC := '1';
	 SIGNAL	n1OiO	:	STD_LOGIC := '1';
	 SIGNAL	n00il	:	STD_LOGIC := '1';
	 SIGNAL	n00iO	:	STD_LOGIC := '1';
	 SIGNAL	n00li	:	STD_LOGIC := '1';
	 SIGNAL	n00ll	:	STD_LOGIC := '1';
	 SIGNAL	n00lO	:	STD_LOGIC := '1';
	 SIGNAL	n00Oi	:	STD_LOGIC := '1';
	 SIGNAL	n00OO	:	STD_LOGIC := '1';
	 SIGNAL	n010i	:	STD_LOGIC := '1';
	 SIGNAL	n010l	:	STD_LOGIC := '1';
	 SIGNAL	n010O	:	STD_LOGIC := '1';
	 SIGNAL	n01ii	:	STD_LOGIC := '1';
	 SIGNAL	n01il	:	STD_LOGIC := '1';
	 SIGNAL	n01iO	:	STD_LOGIC := '1';
	 SIGNAL	n01ll	:	STD_LOGIC := '1';
	 SIGNAL  wire_n01li_w_lg_n010i184w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_lg_n010l180w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_lg_n010O176w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_lg_n01ii173w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_lg_n01il171w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_lg_n01iO169w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01li_w_lg_n01ll166w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0i0i	:	STD_LOGIC := '0';
	 SIGNAL	n0i0l	:	STD_LOGIC := '0';
	 SIGNAL	n0i0O	:	STD_LOGIC := '0';
	 SIGNAL	n0i1i	:	STD_LOGIC := '0';
	 SIGNAL	n0i1l	:	STD_LOGIC := '0';
	 SIGNAL	n0i1O	:	STD_LOGIC := '0';
	 SIGNAL	n0iii	:	STD_LOGIC := '0';
	 SIGNAL	n0iil	:	STD_LOGIC := '0';
	 SIGNAL	n0iiO	:	STD_LOGIC := '0';
	 SIGNAL	n0ili	:	STD_LOGIC := '0';
	 SIGNAL	n0ill	:	STD_LOGIC := '0';
	 SIGNAL	n0ilO	:	STD_LOGIC := '0';
	 SIGNAL	n0iOl	:	STD_LOGIC := '0';
	 SIGNAL	n0l1i	:	STD_LOGIC := '1';
	 SIGNAL	n0l0l	:	STD_LOGIC := '1';
	 SIGNAL	nliiii	:	STD_LOGIC := '1';
	 SIGNAL	n0lii	:	STD_LOGIC := '1';
	 SIGNAL	n011i	:	STD_LOGIC := '0';
	 SIGNAL	n011l	:	STD_LOGIC := '0';
	 SIGNAL	n011O	:	STD_LOGIC := '0';
	 SIGNAL	n01lO	:	STD_LOGIC := '0';
	 SIGNAL	n01Oi	:	STD_LOGIC := '0';
	 SIGNAL	n01Ol	:	STD_LOGIC := '0';
	 SIGNAL	n0l1O	:	STD_LOGIC := '0';
	 SIGNAL	n1lOO	:	STD_LOGIC := '0';
	 SIGNAL	n1O1i	:	STD_LOGIC := '0';
	 SIGNAL	n1O1l	:	STD_LOGIC := '0';
	 SIGNAL	n1Oli	:	STD_LOGIC := '0';
	 SIGNAL	n1Oll	:	STD_LOGIC := '0';
	 SIGNAL	n1OlO	:	STD_LOGIC := '0';
	 SIGNAL	n1OOi	:	STD_LOGIC := '0';
	 SIGNAL	n1OOl	:	STD_LOGIC := '0';
	 SIGNAL	n1OOO	:	STD_LOGIC := '0';
	 SIGNAL	nl000i	:	STD_LOGIC := '0';
	 SIGNAL	nl000l	:	STD_LOGIC := '0';
	 SIGNAL	nl000O	:	STD_LOGIC := '0';
	 SIGNAL	nl001i	:	STD_LOGIC := '0';
	 SIGNAL	nl001l	:	STD_LOGIC := '0';
	 SIGNAL	nl001O	:	STD_LOGIC := '0';
	 SIGNAL	nl00ii	:	STD_LOGIC := '0';
	 SIGNAL	nl00il	:	STD_LOGIC := '0';
	 SIGNAL	nl00iO	:	STD_LOGIC := '0';
	 SIGNAL	nl00li	:	STD_LOGIC := '0';
	 SIGNAL	nl00ll	:	STD_LOGIC := '0';
	 SIGNAL	nl010i	:	STD_LOGIC := '0';
	 SIGNAL	nl010l	:	STD_LOGIC := '0';
	 SIGNAL	nl010O	:	STD_LOGIC := '0';
	 SIGNAL	nl011i	:	STD_LOGIC := '0';
	 SIGNAL	nl011l	:	STD_LOGIC := '0';
	 SIGNAL	nl011O	:	STD_LOGIC := '0';
	 SIGNAL	nl01ii	:	STD_LOGIC := '0';
	 SIGNAL	nl01il	:	STD_LOGIC := '0';
	 SIGNAL	nl01iO	:	STD_LOGIC := '0';
	 SIGNAL	nl01li	:	STD_LOGIC := '0';
	 SIGNAL	nl01ll	:	STD_LOGIC := '0';
	 SIGNAL	nl01lO	:	STD_LOGIC := '0';
	 SIGNAL	nl01Oi	:	STD_LOGIC := '0';
	 SIGNAL	nl01Ol	:	STD_LOGIC := '0';
	 SIGNAL	nl01OO	:	STD_LOGIC := '0';
	 SIGNAL	nl1OiO	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oli	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oll	:	STD_LOGIC := '0';
	 SIGNAL	nl1OlO	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOi	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOl	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOO	:	STD_LOGIC := '0';
	 SIGNAL	nli00i	:	STD_LOGIC := '0';
	 SIGNAL	nli01i	:	STD_LOGIC := '0';
	 SIGNAL	nli0ii	:	STD_LOGIC := '0';
	 SIGNAL	nli0li	:	STD_LOGIC := '0';
	 SIGNAL	nli0Oi	:	STD_LOGIC := '0';
	 SIGNAL	nli0Ol	:	STD_LOGIC := '0';
	 SIGNAL	nlii0i	:	STD_LOGIC := '0';
	 SIGNAL	nlii0l	:	STD_LOGIC := '0';
	 SIGNAL	nlii0O	:	STD_LOGIC := '0';
	 SIGNAL	nliiil	:	STD_LOGIC := '0';
	 SIGNAL	nliiiO	:	STD_LOGIC := '0';
	 SIGNAL	nliili	:	STD_LOGIC := '0';
	 SIGNAL	nliill	:	STD_LOGIC := '0';
	 SIGNAL	nliilO	:	STD_LOGIC := '0';
	 SIGNAL	nll00i	:	STD_LOGIC := '0';
	 SIGNAL	nll00l	:	STD_LOGIC := '0';
	 SIGNAL	nll00O	:	STD_LOGIC := '0';
	 SIGNAL	nll01i	:	STD_LOGIC := '0';
	 SIGNAL	nll01l	:	STD_LOGIC := '0';
	 SIGNAL	nll01O	:	STD_LOGIC := '0';
	 SIGNAL	nll0ii	:	STD_LOGIC := '0';
	 SIGNAL	nll0il	:	STD_LOGIC := '0';
	 SIGNAL	nll0iO	:	STD_LOGIC := '0';
	 SIGNAL	nll0li	:	STD_LOGIC := '0';
	 SIGNAL	nll0ll	:	STD_LOGIC := '0';
	 SIGNAL	nll0lO	:	STD_LOGIC := '0';
	 SIGNAL	nll0Oi	:	STD_LOGIC := '0';
	 SIGNAL	nll0Ol	:	STD_LOGIC := '0';
	 SIGNAL	nll11l	:	STD_LOGIC := '0';
	 SIGNAL	nll1OO	:	STD_LOGIC := '0';
	 SIGNAL	nlli0i	:	STD_LOGIC := '0';
	 SIGNAL	nlli0l	:	STD_LOGIC := '0';
	 SIGNAL	nlli0O	:	STD_LOGIC := '0';
	 SIGNAL	nlli1i	:	STD_LOGIC := '0';
	 SIGNAL	nlli1l	:	STD_LOGIC := '0';
	 SIGNAL	nlli1O	:	STD_LOGIC := '0';
	 SIGNAL	nlliii	:	STD_LOGIC := '0';
	 SIGNAL	nlliil	:	STD_LOGIC := '0';
	 SIGNAL	nlliiO	:	STD_LOGIC := '0';
	 SIGNAL	nllOii	:	STD_LOGIC := '0';
	 SIGNAL	nlOiiO	:	STD_LOGIC := '0';
	 SIGNAL	nlOili	:	STD_LOGIC := '0';
	 SIGNAL	nlOill	:	STD_LOGIC := '0';
	 SIGNAL	nlOiOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOiOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOiOO	:	STD_LOGIC := '0';
	 SIGNAL  wire_n0l1l_w1608w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_w_lg_w_lg_w1599w1601w1603w1605w1607w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_w_lg_w1599w1601w1603w1605w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_w1599w1601w1603w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w1599w1601w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w1599w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_w_lg_w_lg_w1589w1591w1593w1595w1597w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_w_lg_w1589w1591w1593w1595w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_w1589w1591w1593w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w1589w1591w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w1589w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_w_lg_w_lg_nll0Ol1581w1583w1585w1587w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_w_lg_nll0Ol1581w1583w1585w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_w_lg_nll0Ol1581w1583w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_n01Oi120w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_n0l1O108w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_n1lOO914w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_n1O1l912w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nl1OiO1309w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nlii0i1304w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nliilO1609w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll00i1600w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll00l1598w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll00O1596w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll01i1606w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll01l1604w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll01O1602w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll0ii1594w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll0il1592w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll0iO1590w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll0li1588w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll0ll1586w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll0lO1584w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll0Oi1582w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll0Ol1581w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nlOiiO1303w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nli00i1306w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll11l1310w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1l_w_lg_nll11l1305w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0lll	:	STD_LOGIC := '0';
	 SIGNAL	n0llO	:	STD_LOGIC := '0';
	 SIGNAL	n0lOi	:	STD_LOGIC := '0';
	 SIGNAL	n0lOl	:	STD_LOGIC := '0';
	 SIGNAL	n0lOO	:	STD_LOGIC := '0';
	 SIGNAL	n0O1i	:	STD_LOGIC := '0';
	 SIGNAL	n0O1O	:	STD_LOGIC := '0';
	 SIGNAL	n111l	:	STD_LOGIC := '0';
	 SIGNAL	nllili	:	STD_LOGIC := '0';
	 SIGNAL	nllill	:	STD_LOGIC := '0';
	 SIGNAL	nllilO	:	STD_LOGIC := '0';
	 SIGNAL	nlliOi	:	STD_LOGIC := '0';
	 SIGNAL	nlliOl	:	STD_LOGIC := '0';
	 SIGNAL	nlliOO	:	STD_LOGIC := '0';
	 SIGNAL	nlll0i	:	STD_LOGIC := '0';
	 SIGNAL	nlll0l	:	STD_LOGIC := '0';
	 SIGNAL	nlll0O	:	STD_LOGIC := '0';
	 SIGNAL	nlll1i	:	STD_LOGIC := '0';
	 SIGNAL	nlll1l	:	STD_LOGIC := '0';
	 SIGNAL	nlll1O	:	STD_LOGIC := '0';
	 SIGNAL	nlllii	:	STD_LOGIC := '0';
	 SIGNAL	nlllil	:	STD_LOGIC := '0';
	 SIGNAL	nllliO	:	STD_LOGIC := '0';
	 SIGNAL	nlllli	:	STD_LOGIC := '0';
	 SIGNAL	nlOilO	:	STD_LOGIC := '0';
	 SIGNAL	nlOl1i	:	STD_LOGIC := '0';
	 SIGNAL	nlOl1l	:	STD_LOGIC := '0';
	 SIGNAL	nlOl1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOlil	:	STD_LOGIC := '0';
	 SIGNAL	nlOlOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOlOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOlOO	:	STD_LOGIC := '0';
	 SIGNAL	nlOO0i	:	STD_LOGIC := '0';
	 SIGNAL	nlOO0l	:	STD_LOGIC := '0';
	 SIGNAL	nlOO1i	:	STD_LOGIC := '0';
	 SIGNAL	nlOO1l	:	STD_LOGIC := '0';
	 SIGNAL	nlOO1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOO	:	STD_LOGIC := '0';
	 SIGNAL	n1lOl	:	STD_LOGIC := '1';
	 SIGNAL	nll0OO	:	STD_LOGIC := '1';
	 SIGNAL	ni00O	:	STD_LOGIC := '1';
	 SIGNAL	ni0ii	:	STD_LOGIC := '0';
	 SIGNAL	ni0li	:	STD_LOGIC := '0';
	 SIGNAL  wire_ni0iO_w_lg_ni0ii652w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0iO_w_lg_ni0li613w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nii0l	:	STD_LOGIC := '1';
	 SIGNAL  wire_nii0i_w_lg_nii0l573w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0lil	:	STD_LOGIC := '1';
	 SIGNAL	n0liO	:	STD_LOGIC := '1';
	 SIGNAL	n0lli	:	STD_LOGIC := '1';
	 SIGNAL	n0O0i	:	STD_LOGIC := '1';
	 SIGNAL	n0O0l	:	STD_LOGIC := '1';
	 SIGNAL	n0O0O	:	STD_LOGIC := '1';
	 SIGNAL	n0Oii	:	STD_LOGIC := '1';
	 SIGNAL	n0Oil	:	STD_LOGIC := '1';
	 SIGNAL	n0OiO	:	STD_LOGIC := '1';
	 SIGNAL	n0Oli	:	STD_LOGIC := '1';
	 SIGNAL	n0Oll	:	STD_LOGIC := '1';
	 SIGNAL	n0OlO	:	STD_LOGIC := '1';
	 SIGNAL	ni00i	:	STD_LOGIC := '1';
	 SIGNAL	ni0il	:	STD_LOGIC := '1';
	 SIGNAL	ni0ll	:	STD_LOGIC := '1';
	 SIGNAL	ni0lO	:	STD_LOGIC := '1';
	 SIGNAL	ni0Oi	:	STD_LOGIC := '1';
	 SIGNAL	ni0Ol	:	STD_LOGIC := '1';
	 SIGNAL	ni0OO	:	STD_LOGIC := '1';
	 SIGNAL	ni10l	:	STD_LOGIC := '1';
	 SIGNAL	ni10O	:	STD_LOGIC := '1';
	 SIGNAL	ni1ii	:	STD_LOGIC := '1';
	 SIGNAL	ni1il	:	STD_LOGIC := '1';
	 SIGNAL	ni1iO	:	STD_LOGIC := '1';
	 SIGNAL	ni1li	:	STD_LOGIC := '1';
	 SIGNAL	ni1ll	:	STD_LOGIC := '1';
	 SIGNAL	ni1lO	:	STD_LOGIC := '1';
	 SIGNAL	ni1Oi	:	STD_LOGIC := '1';
	 SIGNAL	ni1Ol	:	STD_LOGIC := '1';
	 SIGNAL	nii1i	:	STD_LOGIC := '1';
	 SIGNAL	nii1O	:	STD_LOGIC := '1';
	 SIGNAL  wire_nii1l_w_lg_n0lil909w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1l_w_lg_n0lli907w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1l_w_lg_ni10O557w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl00Oi	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl00lO_ENA	:	STD_LOGIC;
	 SIGNAL	nl00OO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl00Ol_ENA	:	STD_LOGIC;
	 SIGNAL	nl0i0O	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0i0l_ENA	:	STD_LOGIC;
	 SIGNAL	nl0i1l	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0i1i_ENA	:	STD_LOGIC;
	 SIGNAL	nl0i0i	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0i1O_ENA	:	STD_LOGIC;
	 SIGNAL	nl0iil	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0iii_ENA	:	STD_LOGIC;
	 SIGNAL	nl0ili	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0iiO_ENA	:	STD_LOGIC;
	 SIGNAL	nl0ilO	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0ill_ENA	:	STD_LOGIC;
	 SIGNAL	nl0iOl	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0iOi_ENA	:	STD_LOGIC;
	 SIGNAL	nl0l1i	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0iOO_ENA	:	STD_LOGIC;
	 SIGNAL	nl0l0l	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0l0i_ENA	:	STD_LOGIC;
	 SIGNAL	nl0lii	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0l0O_ENA	:	STD_LOGIC;
	 SIGNAL	nl0l1O	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0l1l_ENA	:	STD_LOGIC;
	 SIGNAL	nl0liO	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0lil_ENA	:	STD_LOGIC;
	 SIGNAL	nl0lll	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0lli_ENA	:	STD_LOGIC;
	 SIGNAL	nl0lOi	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0llO_ENA	:	STD_LOGIC;
	 SIGNAL	nl0lOO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0lOl_ENA	:	STD_LOGIC;
	 SIGNAL	nl0O0O	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0O0l_ENA	:	STD_LOGIC;
	 SIGNAL	nl0O1l	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0O1i_ENA	:	STD_LOGIC;
	 SIGNAL	nl0O0i	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0O1O_ENA	:	STD_LOGIC;
	 SIGNAL	nl0Oil	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0Oii_ENA	:	STD_LOGIC;
	 SIGNAL	nl0Oli	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0OiO_ENA	:	STD_LOGIC;
	 SIGNAL	nl0OlO	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0Oll_ENA	:	STD_LOGIC;
	 SIGNAL	nl0OOl	:	STD_LOGIC := '1';
	 SIGNAL	wire_nl0OOi_ENA	:	STD_LOGIC;
	 SIGNAL	nli11i	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0OOO_ENA	:	STD_LOGIC;
	 SIGNAL	nii0O	:	STD_LOGIC := '0';
	 SIGNAL	niiii	:	STD_LOGIC := '0';
	 SIGNAL	niiil	:	STD_LOGIC := '0';
	 SIGNAL	niiiO	:	STD_LOGIC := '0';
	 SIGNAL	niili	:	STD_LOGIC := '0';
	 SIGNAL	niill	:	STD_LOGIC := '0';
	 SIGNAL	niilO	:	STD_LOGIC := '0';
	 SIGNAL	niliO	:	STD_LOGIC := '0';
	 SIGNAL	niO0l	:	STD_LOGIC := '0';
	 SIGNAL	niOii	:	STD_LOGIC := '0';
	 SIGNAL	nl10O	:	STD_LOGIC := '0';
	 SIGNAL	nl1ii	:	STD_LOGIC := '0';
	 SIGNAL	nl1iO	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1il_w_lg_nii0O575w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niiii577w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niiil579w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niiiO581w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niili583w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niill585w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niilO600w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niliO602w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niO0l604w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_niOii606w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_nl10O608w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_nl1ii610w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1il_w_lg_nl1iO612w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1ll	:	STD_LOGIC := '0';
	 SIGNAL	nli00O	:	STD_LOGIC := '1';
	 SIGNAL	wire_nli00l_ENA	:	STD_LOGIC;
	 SIGNAL	nli01O	:	STD_LOGIC := '1';
	 SIGNAL	wire_nli01l_ENA	:	STD_LOGIC;
	 SIGNAL	nli0iO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli0il_ENA	:	STD_LOGIC;
	 SIGNAL	nli0lO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli0ll_ENA	:	STD_LOGIC;
	 SIGNAL	nlii1i	:	STD_LOGIC := '1';
	 SIGNAL	wire_nli0OO_ENA	:	STD_LOGIC;
	 SIGNAL	nli10l	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli10i_ENA	:	STD_LOGIC;
	 SIGNAL	nli1ii	:	STD_LOGIC := '1';
	 SIGNAL	wire_nli10O_ENA	:	STD_LOGIC;
	 SIGNAL	nli11O	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli11l_ENA	:	STD_LOGIC;
	 SIGNAL	nli1iO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli1il_ENA	:	STD_LOGIC;
	 SIGNAL	nli1ll	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli1li_ENA	:	STD_LOGIC;
	 SIGNAL	nli1Oi	:	STD_LOGIC := '1';
	 SIGNAL	wire_nli1lO_ENA	:	STD_LOGIC;
	 SIGNAL	nli1OO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli1Ol_ENA	:	STD_LOGIC;
	 SIGNAL	nlii1O	:	STD_LOGIC := '0';
	 SIGNAL	wire_nlii1l_ENA	:	STD_LOGIC;
	 SIGNAL	nl01i	:	STD_LOGIC := '0';
	 SIGNAL	nl01l	:	STD_LOGIC := '0';
	 SIGNAL	nl01O	:	STD_LOGIC := '0';
	 SIGNAL	nl1lO	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oi	:	STD_LOGIC := '0';
	 SIGNAL	nl1Ol	:	STD_LOGIC := '0';
	 SIGNAL	nl1OO	:	STD_LOGIC := '0';
	 SIGNAL	nliil	:	STD_LOGIC := '0';
	 SIGNAL	nlili	:	STD_LOGIC := '0';
	 SIGNAL	nlliO	:	STD_LOGIC := '0';
	 SIGNAL	nllOi	:	STD_LOGIC := '0';
	 SIGNAL	nllOl	:	STD_LOGIC := '0';
	 SIGNAL	nlO1i	:	STD_LOGIC := '0';
	 SIGNAL	n0OOi	:	STD_LOGIC := '1';
	 SIGNAL	n0OOl	:	STD_LOGIC := '1';
	 SIGNAL	n0OOO	:	STD_LOGIC := '1';
	 SIGNAL	ni01i	:	STD_LOGIC := '1';
	 SIGNAL	ni01l	:	STD_LOGIC := '1';
	 SIGNAL	ni01O	:	STD_LOGIC := '1';
	 SIGNAL	ni10i	:	STD_LOGIC := '1';
	 SIGNAL	ni11i	:	STD_LOGIC := '1';
	 SIGNAL	ni11l	:	STD_LOGIC := '1';
	 SIGNAL	ni11O	:	STD_LOGIC := '1';
	 SIGNAL	ni1OO	:	STD_LOGIC := '1';
	 SIGNAL	nlO0l	:	STD_LOGIC := '1';
	 SIGNAL	nlO1l	:	STD_LOGIC := '1';
	 SIGNAL	nlO1O	:	STD_LOGIC := '1';
	 SIGNAL	wire_n1lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nil0O_w_lg_dataout879w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1iO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nll1iO_w_lg_dataout1545w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOiO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlOOiO_w_lg_dataout1097w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlOOll_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlOOll_w_lg_dataout1096w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nil1O_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil1O_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL  wire_nil1O_o	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nilii_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nilii_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nilii_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niO0O_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niO0O_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niO0O_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niO1O_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niO1O_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niO1O_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niOil_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niOil_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niOil_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nl00i_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nl00i_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nl00i_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nl0iO_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0iO_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0iO_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0ll_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0ll_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0ll_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_o_range327w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_o_range331w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_o_range337w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_o_range315w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_o_range346w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0i_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0i_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0l_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0l_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0l_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nlill_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nlill_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nlill_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nlilOO_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nlilOO_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nlilOO_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll10i_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll10i_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll10i_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll11O_a	:	STD_LOGIC_VECTOR (14 DOWNTO 0);
	 SIGNAL  wire_nll11O_b	:	STD_LOGIC_VECTOR (14 DOWNTO 0);
	 SIGNAL  wire_nll11O_o	:	STD_LOGIC_VECTOR (14 DOWNTO 0);
	 SIGNAL  wire_nil0l_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil0l_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil0l_o	:	STD_LOGIC;
	 SIGNAL  wire_nil1l_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil1l_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0il_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0il_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0il_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0li_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0li_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0li_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllll_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nlllll_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllll_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nlllOi_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nlllOi_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllOi_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nlllOl_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nlllOl_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllOl_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nlllOO_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nlllOO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllOO_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nllO0i_data	:	STD_LOGIC_VECTOR (9 DOWNTO 0);
	 SIGNAL  wire_nllO0i_o	:	STD_LOGIC;
	 SIGNAL  wire_nllO0i_sel	:	STD_LOGIC_VECTOR (9 DOWNTO 0);
	 SIGNAL  wire_nllO0l_data	:	STD_LOGIC_VECTOR (9 DOWNTO 0);
	 SIGNAL  wire_nllO0l_o	:	STD_LOGIC;
	 SIGNAL  wire_nllO0l_sel	:	STD_LOGIC_VECTOR (9 DOWNTO 0);
	 SIGNAL  wire_nllO0O_data	:	STD_LOGIC_VECTOR (9 DOWNTO 0);
	 SIGNAL  wire_nllO0O_o	:	STD_LOGIC;
	 SIGNAL  wire_nllO0O_sel	:	STD_LOGIC_VECTOR (9 DOWNTO 0);
	 SIGNAL  wire_nllO1i_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nllO1i_o	:	STD_LOGIC;
	 SIGNAL  wire_nllO1i_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nllO1l_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nllO1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nllO1l_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nllO1O_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nllO1O_o	:	STD_LOGIC;
	 SIGNAL  wire_nllO1O_sel	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nl10ii889w890w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_niOOlO908w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl100i913w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl101O906w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl10ii889w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl10Ol107w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  niOlOO :	STD_LOGIC;
	 SIGNAL  niOO0i :	STD_LOGIC;
	 SIGNAL  niOO0l :	STD_LOGIC;
	 SIGNAL  niOO0O :	STD_LOGIC;
	 SIGNAL  niOO1i :	STD_LOGIC;
	 SIGNAL  niOO1l :	STD_LOGIC;
	 SIGNAL  niOO1O :	STD_LOGIC;
	 SIGNAL  niOOii :	STD_LOGIC;
	 SIGNAL  niOOil :	STD_LOGIC;
	 SIGNAL  niOOiO :	STD_LOGIC;
	 SIGNAL  niOOli :	STD_LOGIC;
	 SIGNAL  niOOll :	STD_LOGIC;
	 SIGNAL  niOOlO :	STD_LOGIC;
	 SIGNAL  niOOOi :	STD_LOGIC;
	 SIGNAL  niOOOl :	STD_LOGIC;
	 SIGNAL  nl100i :	STD_LOGIC;
	 SIGNAL  nl101O :	STD_LOGIC;
	 SIGNAL  nl10ii :	STD_LOGIC;
	 SIGNAL  nl10li :	STD_LOGIC;
	 SIGNAL  nl10ll :	STD_LOGIC;
	 SIGNAL  nl10Ol :	STD_LOGIC;
 BEGIN

	wire_gnd <= '0';
	wire_vcc <= '1';
	wire_w_lg_w_lg_nl10ii889w890w(0) <= wire_w_lg_nl10ii889w(0) AND niOO0O;
	wire_w_lg_niOOlO908w(0) <= NOT niOOlO;
	wire_w_lg_nl100i913w(0) <= NOT nl100i;
	wire_w_lg_nl101O906w(0) <= NOT nl101O;
	wire_w_lg_nl10ii889w(0) <= NOT nl10ii;
	wire_w_lg_nl10Ol107w(0) <= NOT nl10Ol;
	a_renb <= nliiii;
	b_dat <= ( wire_n111O_q_b(31 DOWNTO 0));
	b_dav <= ni00i;
	b_eop <= wire_n111O_q_b(33);
	b_err <= wire_n111O_q_b(34);
	b_mty <= ( wire_n111O_q_b(37 DOWNTO 36));
	b_par <= wire_n111O_q_b(35);
	b_sop <= wire_n111O_q_b(32);
	b_val <= ni00O;
	niOlOO <= (wire_n0l1l_w1608w(0) AND wire_n0l1l_w_lg_nliilO1609w(0));
	niOO0i <= (nli00O AND nli0iO);
	niOO0l <= (nlli1i OR nll0OO);
	niOO0O <= (((((((NOT (n0l1i XOR n01ll)) AND (NOT (n0iOl XOR n01iO))) AND (NOT (n0ilO XOR n01il))) AND (NOT (n0ill XOR n01ii))) AND (NOT (n0ili XOR n010O))) AND (NOT (n0iiO XOR n010l))) AND (NOT (n0iil XOR n010i)));
	niOO1i <= (nlii0i AND nlii0l);
	niOO1l <= (wire_n0l1l_w_lg_nlii0i1304w(0) OR wire_n0l1l_w_lg_nll11l1310w(0));
	niOO1O <= ((nlli1l OR nlli1i) OR nll0OO);
	niOOii <= (((((((NOT (n01ll XOR wire_nlill_o(0))) AND (NOT (n01iO XOR wire_nlill_o(1)))) AND (NOT (n01il XOR wire_nlill_o(2)))) AND (NOT (n01ii XOR wire_nlill_o(3)))) AND (NOT (n010O XOR wire_nlill_o(4)))) AND (NOT (n010l XOR wire_nlill_o(5)))) AND (NOT (n010i XOR wire_nlill_o(6))));
	niOOil <= (((((((NOT (nlO1l XOR nl1ll)) AND (NOT (nlO1O XOR nl1lO))) AND (NOT (nlO0l XOR nl1Oi))) AND (NOT (ni01O XOR nl1Ol))) AND (NOT (ni01l XOR nl1OO))) AND (NOT (ni01i XOR nl01i))) AND (NOT (ni1OO XOR nl01l)));
	niOOiO <= (((((((NOT (nlO1l XOR nl01O)) AND (NOT (nlO1O XOR nliil))) AND (NOT (nlO0l XOR nlili))) AND (NOT (nlliO XOR ni01O))) AND (NOT (nllOi XOR ni01l))) AND (NOT (nllOl XOR ni01i))) AND (NOT (nlO1i XOR ni1OO)));
	niOOli <= (((((((NOT (nii0l XOR ni10i)) AND (NOT (nii0O XOR ni11O))) AND (NOT (niiii XOR ni11l))) AND (NOT (niiil XOR ni11i))) AND (NOT (niiiO XOR n0OOO))) AND (NOT (niili XOR n0OOl))) AND (NOT (niill XOR n0OOi)));
	niOOll <= (((((((NOT (niilO XOR ni10i)) AND (NOT (niliO XOR ni11O))) AND (NOT (niO0l XOR ni11l))) AND (NOT (niOii XOR ni11i))) AND (NOT (nl10O XOR n0OOO))) AND (NOT (nl1ii XOR n0OOl))) AND (NOT (nl1iO XOR n0OOi)));
	niOOlO <= (n0lii AND (NOT (n0O0l XOR n0lli)));
	niOOOi <= (b_ena AND wire_ni0iO_w_lg_ni0li613w(0));
	niOOOl <= (wire_n0l1l_w_lg_n0l1O108w(0) AND (nlOiOl AND nl10ii));
	nl100i <= (n1lOl AND (NOT ((n1Oll XOR n1O1l) XOR wire_nl100l5_w_lg_Q116w(0))));
	nl101O <= (n01Ol XOR wire_n0l1l_w_lg_n01Oi120w(0));
	nl10ii <= ((wire_n0l1l_w_lg_n0l1O108w(0) AND nllOii) AND nl10il2);
	nl10li <= (wire_ni0iO_w_lg_ni0ii652w(0) AND wire_n111O_w_lg_w_q_b_range98w653w(0));
	nl10ll <= '1';
	nl10Ol <= (ni1ii XOR wire_nii1l_w_lg_ni10O557w(0));
	wire_n111O_w_lg_w_q_b_range98w653w(0) <= wire_n111O_w_q_b_range98w(0) AND ni0il;
	wire_n111O_address_a <= ( n0i1i & n0i1l & n0i1O & n0i0i & n0i0l & n0i0O & n0iii);
	wire_n111O_address_b <= ( nl1iO & nl1ii & nl10O & niOii & niO0l & niliO & niilO);
	wire_n111O_data_a <= ( nlOill & nlOili & nlOilO & nlOiOi & nlOiOl & nlOiOO & nllili & nllill & nllilO & nlliOi & nlliOl & nlliOO & nlll1i & nlll1l & nlll1O & nlll0i & nlll0l & nlll0O & nlllii & nlllil & nllliO & nlllli & n111l & nlOOOO & nlOOOl & nlOOOi & nlOO0l & nlOO0i & nlOO1O & nlOO1l & nlOO1i & nlOlOO & nlOlOl & nlOlOi & nlOlil & nlOl1O & nlOl1l & nlOl1i);
	wire_n111O_w_q_b_range98w(0) <= wire_n111O_q_b(33);
	n111O :  altsyncram
	  GENERIC MAP (
		ADDRESS_ACLR_A => "NONE",
		ADDRESS_ACLR_B => "NONE",
		ADDRESS_REG_B => "CLOCK1",
		BYTE_SIZE => 8,
		BYTEENA_ACLR_A => "NONE",
		BYTEENA_ACLR_B => "NONE",
		BYTEENA_REG_B => "CLOCK1",
		CLOCK_ENABLE_INPUT_A => "NORMAL",
		CLOCK_ENABLE_INPUT_B => "NORMAL",
		CLOCK_ENABLE_OUTPUT_A => "NORMAL",
		CLOCK_ENABLE_OUTPUT_B => "NORMAL",
		INDATA_ACLR_A => "NONE",
		INDATA_ACLR_B => "NONE",
		INDATA_REG_B => "CLOCK1",
		INIT_FILE_LAYOUT => "PORT_A",
		INTENDED_DEVICE_FAMILY => "Stratix",
		NUMWORDS_A => 128,
		NUMWORDS_B => 128,
		OPERATION_MODE => "DUAL_PORT",
		OUTDATA_ACLR_A => "NONE",
		OUTDATA_ACLR_B => "NONE",
		OUTDATA_REG_A => "UNREGISTERED",
		OUTDATA_REG_B => "UNREGISTERED",
		RAM_BLOCK_TYPE => "AUTO",
		RDCONTROL_ACLR_B => "NONE",
		RDCONTROL_REG_B => "CLOCK1",
		READ_DURING_WRITE_MODE_MIXED_PORTS => "DONT_CARE",
		WIDTH_A => 38,
		WIDTH_B => 38,
		WIDTH_BYTEENA_A => 1,
		WIDTH_BYTEENA_B => 1,
		WIDTHAD_A => 7,
		WIDTHAD_B => 7,
		WRCONTROL_ACLR_A => "NONE",
		WRCONTROL_ACLR_B => "NONE",
		WRCONTROL_WRADDRESS_REG_B => "CLOCK1"
	  )
	  PORT MAP ( 
		address_a => wire_n111O_address_a,
		address_b => wire_n111O_address_b,
		clock0 => a_rfclk,
		clock1 => b_clk,
		clocken0 => wire_vcc,
		clocken1 => b_ena,
		data_a => wire_n111O_data_a,
		q_b => wire_n111O_q_b,
		wren_a => nl10ii
	  );
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN niOOOO58 <= niOOOO60;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN niOOOO59 <= (niOOOO60 XOR niOOOO58);
		END IF;
	END PROCESS;
	wire_niOOOO59_w_lg_Q357w(0) <= niOOOO59 AND wire_nli1i_dataout;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN niOOOO60 <= niOOOO58;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl100l4 <= nl100l6;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl100l5 <= (nl100l6 XOR nl100l4);
		END IF;
	END PROCESS;
	wire_nl100l5_w_lg_Q116w(0) <= NOT nl100l5;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl100l6 <= nl100l4;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl101i10 <= nl101i12;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl101i11 <= (nl101i12 XOR nl101i10);
		END IF;
	END PROCESS;
	wire_nl101i11_w_lg_Q133w(0) <= nl101i11 AND n0iil;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl101i12 <= nl101i10;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl101l7 <= nl101l9;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl101l8 <= (nl101l9 XOR nl101l7);
		END IF;
	END PROCESS;
	wire_nl101l8_w_lg_Q129w(0) <= nl101l8 AND n0ili;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl101l9 <= nl101l7;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl10il1 <= nl10il3;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl10il2 <= (nl10il3 XOR nl10il1);
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl10il3 <= nl10il1;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110i46 <= nl110i48;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110i47 <= (nl110i48 XOR nl110i46);
		END IF;
	END PROCESS;
	wire_nl110i47_w_lg_Q330w(0) <= nl110i47 AND wire_nl0ll_w_o_range327w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110i48 <= nl110i46;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110l43 <= nl110l45;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110l44 <= (nl110l45 XOR nl110l43);
		END IF;
	END PROCESS;
	wire_nl110l44_w_lg_Q318w(0) <= nl110l44 AND wire_nl0ll_w_o_range315w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110l45 <= nl110l43;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110O40 <= nl110O42;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110O41 <= (nl110O42 XOR nl110O40);
		END IF;
	END PROCESS;
	wire_nl110O41_w_lg_Q213w(0) <= nl110O41 AND wire_n01li_w_lg_n010O176w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl110O42 <= nl110O40;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111i55 <= nl111i57;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111i56 <= (nl111i57 XOR nl111i55);
		END IF;
	END PROCESS;
	wire_nl111i56_w_lg_Q349w(0) <= nl111i56 AND wire_nl0ll_w_o_range346w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111i57 <= nl111i55;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111l52 <= nl111l54;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111l53 <= (nl111l54 XOR nl111l52);
		END IF;
	END PROCESS;
	wire_nl111l53_w_lg_Q340w(0) <= nl111l53 AND wire_nl0ll_w_o_range337w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111l54 <= nl111l52;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111O49 <= nl111O51;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111O50 <= (nl111O51 XOR nl111O49);
		END IF;
	END PROCESS;
	wire_nl111O50_w_lg_Q334w(0) <= nl111O50 AND wire_nl0ll_w_o_range331w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl111O51 <= nl111O49;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11ii37 <= nl11ii39;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11ii38 <= (nl11ii39 XOR nl11ii37);
		END IF;
	END PROCESS;
	wire_nl11ii38_w_lg_Q210w(0) <= nl11ii38 AND wire_n01li_w_lg_n01ii173w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11ii39 <= nl11ii37;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11il34 <= nl11il36;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11il35 <= (nl11il36 XOR nl11il34);
		END IF;
	END PROCESS;
	wire_nl11il35_w_lg_Q200w(0) <= nl11il35 AND n0i1l;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11il36 <= nl11il34;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11iO31 <= nl11iO33;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11iO32 <= (nl11iO33 XOR nl11iO31);
		END IF;
	END PROCESS;
	wire_nl11iO32_w_lg_Q197w(0) <= nl11iO32 AND n0i1O;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11iO33 <= nl11iO31;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11li28 <= nl11li30;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11li29 <= (nl11li30 XOR nl11li28);
		END IF;
	END PROCESS;
	wire_nl11li29_w_lg_Q193w(0) <= nl11li29 AND n0i0l;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11li30 <= nl11li28;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11ll25 <= nl11ll27;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11ll26 <= (nl11ll27 XOR nl11ll25);
		END IF;
	END PROCESS;
	wire_nl11ll26_w_lg_Q185w(0) <= nl11ll26 AND wire_n01li_w_lg_n010i184w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11ll27 <= nl11ll25;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11lO22 <= nl11lO24;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11lO23 <= (nl11lO24 XOR nl11lO22);
		END IF;
	END PROCESS;
	wire_nl11lO23_w_lg_Q181w(0) <= nl11lO23 AND wire_n01li_w_lg_n010l180w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11lO24 <= nl11lO22;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11Oi19 <= nl11Oi21;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11Oi20 <= (nl11Oi21 XOR nl11Oi19);
		END IF;
	END PROCESS;
	wire_nl11Oi20_w_lg_Q177w(0) <= nl11Oi20 AND wire_n01li_w_lg_n010O176w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11Oi21 <= nl11Oi19;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11Ol16 <= nl11Ol18;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11Ol17 <= (nl11Ol18 XOR nl11Ol16);
		END IF;
	END PROCESS;
	wire_nl11Ol17_w_lg_Q167w(0) <= nl11Ol17 AND wire_n01li_w_lg_n01ll166w(0);
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11Ol18 <= nl11Ol16;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11OO13 <= nl11OO15;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11OO14 <= (nl11OO15 XOR nl11OO13);
		END IF;
	END PROCESS;
	wire_nl11OO14_w_lg_Q157w(0) <= nl11OO14 AND n0ill;
	PROCESS (a_rfclk)
	BEGIN
		IF (a_rfclk = '1' AND a_rfclk'event) THEN nl11OO15 <= nl11OO13;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n000i <= '0';
				n000l <= '0';
				n001i <= '0';
				n001l <= '0';
				n001O <= '0';
				n00ii <= '0';
				n01OO <= '0';
				n1O0i <= '0';
				n1O0l <= '0';
				n1O0O <= '0';
				n1O1O <= '0';
				n1Oii <= '0';
				n1Oil <= '0';
				n1OiO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (nl100i = '1') THEN
				n000i <= n00lO;
				n000l <= n00Oi;
				n001i <= n00iO;
				n001l <= n00li;
				n001O <= n00ll;
				n00ii <= n00OO;
				n01OO <= n00il;
				n1O0i <= n0i1l;
				n1O0l <= n0i1O;
				n1O0O <= n0i0i;
				n1O1O <= n0i1i;
				n1Oii <= n0i0l;
				n1Oil <= n0i0O;
				n1OiO <= n0iii;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n00il <= '0';
				n00iO <= '0';
				n00li <= '0';
				n00ll <= '0';
				n00lO <= '0';
				n00Oi <= '0';
				n00OO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (niOOOl = '1') THEN
				n00il <= wire_nl00i_o(6);
				n00iO <= wire_nl00i_o(5);
				n00li <= wire_nl00i_o(4);
				n00ll <= wire_nl00i_o(3);
				n00lO <= wire_nl00i_o(2);
				n00Oi <= wire_nl00i_o(1);
				n00OO <= wire_nl00i_o(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n010i <= '0';
				n010l <= '0';
				n010O <= '0';
				n01ii <= '0';
				n01il <= '0';
				n01iO <= '0';
				n01ll <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (nl101O = '0') THEN
				n010i <= n1OlO;
				n010l <= n1OOi;
				n010O <= n1OOl;
				n01ii <= n1OOO;
				n01il <= n011i;
				n01iO <= n011l;
				n01ll <= n011O;
			END IF;
		END IF;
	END PROCESS;
	wire_n01li_w_lg_n010i184w(0) <= NOT n010i;
	wire_n01li_w_lg_n010l180w(0) <= NOT n010l;
	wire_n01li_w_lg_n010O176w(0) <= NOT n010O;
	wire_n01li_w_lg_n01ii173w(0) <= NOT n01ii;
	wire_n01li_w_lg_n01il171w(0) <= NOT n01il;
	wire_n01li_w_lg_n01iO169w(0) <= NOT n01iO;
	wire_n01li_w_lg_n01ll166w(0) <= NOT n01ll;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n0i0i <= '0';
				n0i0l <= '0';
				n0i0O <= '0';
				n0i1i <= '0';
				n0i1l <= '0';
				n0i1O <= '0';
				n0iii <= '0';
				n0iil <= '0';
				n0iiO <= '0';
				n0ili <= '0';
				n0ill <= '0';
				n0ilO <= '0';
				n0iOl <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (nl10ii = '1') THEN
				n0i0i <= n0ill;
				n0i0l <= n0ilO;
				n0i0O <= n0iOl;
				n0i1i <= n0iil;
				n0i1l <= n0iiO;
				n0i1O <= n0ili;
				n0iii <= n0l1i;
				n0iil <= wire_nlill_o(6);
				n0iiO <= wire_nlill_o(5);
				n0ili <= wire_nlill_o(4);
				n0ill <= wire_nlill_o(3);
				n0ilO <= wire_nlill_o(2);
				n0iOl <= wire_nlill_o(1);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n0l1i <= '1';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (nl10ii = '1') THEN
				n0l1i <= wire_nlill_o(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n0l0l <= '1';
				nliiii <= '1';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
				n0l0l <= wire_nl00O_dataout;
				nliiii <= wire_nll1iO_w_lg_dataout1545w(0);
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n0lii <= '1';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
				n0lii <= wire_niOlO_dataout;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n011i <= '0';
				n011l <= '0';
				n011O <= '0';
				n01lO <= '0';
				n01Oi <= '0';
				n01Ol <= '0';
				n0l1O <= '0';
				n1lOO <= '0';
				n1O1i <= '0';
				n1O1l <= '0';
				n1Oli <= '0';
				n1Oll <= '0';
				n1OlO <= '0';
				n1OOi <= '0';
				n1OOl <= '0';
				n1OOO <= '0';
				nl000i <= '0';
				nl000l <= '0';
				nl000O <= '0';
				nl001i <= '0';
				nl001l <= '0';
				nl001O <= '0';
				nl00ii <= '0';
				nl00il <= '0';
				nl00iO <= '0';
				nl00li <= '0';
				nl00ll <= '0';
				nl010i <= '0';
				nl010l <= '0';
				nl010O <= '0';
				nl011i <= '0';
				nl011l <= '0';
				nl011O <= '0';
				nl01ii <= '0';
				nl01il <= '0';
				nl01iO <= '0';
				nl01li <= '0';
				nl01ll <= '0';
				nl01lO <= '0';
				nl01Oi <= '0';
				nl01Ol <= '0';
				nl01OO <= '0';
				nl1OiO <= '0';
				nl1Oli <= '0';
				nl1Oll <= '0';
				nl1OlO <= '0';
				nl1OOi <= '0';
				nl1OOl <= '0';
				nl1OOO <= '0';
				nli00i <= '0';
				nli01i <= '0';
				nli0ii <= '0';
				nli0li <= '0';
				nli0Oi <= '0';
				nli0Ol <= '0';
				nlii0i <= '0';
				nlii0l <= '0';
				nlii0O <= '0';
				nliiil <= '0';
				nliiiO <= '0';
				nliili <= '0';
				nliill <= '0';
				nliilO <= '0';
				nll00i <= '0';
				nll00l <= '0';
				nll00O <= '0';
				nll01i <= '0';
				nll01l <= '0';
				nll01O <= '0';
				nll0ii <= '0';
				nll0il <= '0';
				nll0iO <= '0';
				nll0li <= '0';
				nll0ll <= '0';
				nll0lO <= '0';
				nll0Oi <= '0';
				nll0Ol <= '0';
				nll11l <= '0';
				nll1OO <= '0';
				nlli0i <= '0';
				nlli0l <= '0';
				nlli0O <= '0';
				nlli1i <= '0';
				nlli1l <= '0';
				nlli1O <= '0';
				nlliii <= '0';
				nlliil <= '0';
				nlliiO <= '0';
				nllOii <= '0';
				nlOiiO <= '0';
				nlOili <= '0';
				nlOill <= '0';
				nlOiOi <= '0';
				nlOiOl <= '0';
				nlOiOO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
				n011i <= n0lOO;
				n011l <= n0O1i;
				n011O <= n0O1O;
				n01lO <= n0lli;
				n01Oi <= n01lO;
				n01Ol <= n01Oi;
				n0l1O <= ((nl10ii AND niOOii) OR wire_w_lg_w_lg_nl10ii889w890w(0));
				n1lOO <= wire_nliOl_dataout;
				n1O1i <= wire_nliOi_dataout;
				n1O1l <= wire_n1lii_dataout;
				n1Oli <= ni1ii;
				n1Oll <= n1Oli;
				n1OlO <= n0lll;
				n1OOi <= n0llO;
				n1OOl <= n0lOi;
				n1OOO <= n0lOl;
				nl000i <= a_rdat(7);
				nl000l <= a_rdat(6);
				nl000O <= a_rdat(5);
				nl001i <= a_rdat(10);
				nl001l <= a_rdat(9);
				nl001O <= a_rdat(8);
				nl00ii <= a_rdat(4);
				nl00il <= a_rdat(3);
				nl00iO <= a_rdat(2);
				nl00li <= a_rdat(1);
				nl00ll <= a_rdat(0);
				nl010i <= a_rdat(22);
				nl010l <= a_rdat(21);
				nl010O <= a_rdat(20);
				nl011i <= a_rdat(25);
				nl011l <= a_rdat(24);
				nl011O <= a_rdat(23);
				nl01ii <= a_rdat(19);
				nl01il <= a_rdat(18);
				nl01iO <= a_rdat(17);
				nl01li <= a_rdat(16);
				nl01ll <= a_rdat(15);
				nl01lO <= a_rdat(14);
				nl01Oi <= a_rdat(13);
				nl01Ol <= a_rdat(12);
				nl01OO <= a_rdat(11);
				nl1OiO <= wire_nll1iO_dataout;
				nl1Oli <= a_rdat(31);
				nl1Oll <= a_rdat(30);
				nl1OlO <= a_rdat(29);
				nl1OOi <= a_rdat(28);
				nl1OOl <= a_rdat(27);
				nl1OOO <= a_rdat(26);
				nli00i <= a_reop;
				nli01i <= a_rsop;
				nli0ii <= a_rerr;
				nli0li <= a_rprty;
				nli0Oi <= a_rmod(1);
				nli0Ol <= a_rmod(0);
				nlii0i <= a_rval;
				nlii0l <= nlii0i;
				nlii0O <= wire_nll1il_dataout;
				nliiil <= wire_nll1iO_dataout;
				nliiiO <= nliiil;
				nliili <= nliiiO;
				nliill <= nliili;
				nliilO <= wire_nlilOl_dataout;
				nll00i <= wire_nlil1O_dataout;
				nll00l <= wire_nlil0i_dataout;
				nll00O <= wire_nlil0l_dataout;
				nll01i <= wire_nliiOO_dataout;
				nll01l <= wire_nlil1i_dataout;
				nll01O <= wire_nlil1l_dataout;
				nll0ii <= wire_nlil0O_dataout;
				nll0il <= wire_nlilii_dataout;
				nll0iO <= wire_nlilil_dataout;
				nll0li <= wire_nliliO_dataout;
				nll0ll <= wire_nlilli_dataout;
				nll0lO <= wire_nlilll_dataout;
				nll0Oi <= wire_nlillO_dataout;
				nll0Ol <= wire_nlilOi_dataout;
				nll11l <= wire_nliiOi_dataout;
				nll1OO <= wire_nliiOl_dataout;
				nlli0i <= wire_nllO1l_o;
				nlli0l <= wire_nllO1i_o;
				nlli0O <= wire_nlllOO_o;
				nlli1i <= wire_nllO0l_o;
				nlli1l <= wire_nllO0i_o;
				nlli1O <= wire_nllO1O_o;
				nlliii <= wire_nlllOl_o;
				nlliil <= wire_nlllOi_o;
				nlliiO <= wire_nlllll_o;
				nllOii <= (wire_nllO0l_o OR (nlii0O AND wire_nllO0i_o));
				nlOiiO <= n0l0l;
				nlOili <= wire_nlOl0O_dataout;
				nlOill <= wire_nlOlii_dataout;
				nlOiOi <= wire_nlOliO_dataout;
				nlOiOl <= wire_nlOlli_dataout;
				nlOiOO <= wire_nlOlll_dataout;
		END IF;
	END PROCESS;
	wire_n0l1l_w1608w(0) <= wire_n0l1l_w_lg_w_lg_w_lg_w_lg_w1599w1601w1603w1605w1607w(0) AND nll1OO;
	wire_n0l1l_w_lg_w_lg_w_lg_w_lg_w1599w1601w1603w1605w1607w(0) <= wire_n0l1l_w_lg_w_lg_w_lg_w1599w1601w1603w1605w(0) AND wire_n0l1l_w_lg_nll01i1606w(0);
	wire_n0l1l_w_lg_w_lg_w_lg_w1599w1601w1603w1605w(0) <= wire_n0l1l_w_lg_w_lg_w1599w1601w1603w(0) AND wire_n0l1l_w_lg_nll01l1604w(0);
	wire_n0l1l_w_lg_w_lg_w1599w1601w1603w(0) <= wire_n0l1l_w_lg_w1599w1601w(0) AND wire_n0l1l_w_lg_nll01O1602w(0);
	wire_n0l1l_w_lg_w1599w1601w(0) <= wire_n0l1l_w1599w(0) AND wire_n0l1l_w_lg_nll00i1600w(0);
	wire_n0l1l_w1599w(0) <= wire_n0l1l_w_lg_w_lg_w_lg_w_lg_w1589w1591w1593w1595w1597w(0) AND wire_n0l1l_w_lg_nll00l1598w(0);
	wire_n0l1l_w_lg_w_lg_w_lg_w_lg_w1589w1591w1593w1595w1597w(0) <= wire_n0l1l_w_lg_w_lg_w_lg_w1589w1591w1593w1595w(0) AND wire_n0l1l_w_lg_nll00O1596w(0);
	wire_n0l1l_w_lg_w_lg_w_lg_w1589w1591w1593w1595w(0) <= wire_n0l1l_w_lg_w_lg_w1589w1591w1593w(0) AND wire_n0l1l_w_lg_nll0ii1594w(0);
	wire_n0l1l_w_lg_w_lg_w1589w1591w1593w(0) <= wire_n0l1l_w_lg_w1589w1591w(0) AND wire_n0l1l_w_lg_nll0il1592w(0);
	wire_n0l1l_w_lg_w1589w1591w(0) <= wire_n0l1l_w1589w(0) AND wire_n0l1l_w_lg_nll0iO1590w(0);
	wire_n0l1l_w1589w(0) <= wire_n0l1l_w_lg_w_lg_w_lg_w_lg_nll0Ol1581w1583w1585w1587w(0) AND wire_n0l1l_w_lg_nll0li1588w(0);
	wire_n0l1l_w_lg_w_lg_w_lg_w_lg_nll0Ol1581w1583w1585w1587w(0) <= wire_n0l1l_w_lg_w_lg_w_lg_nll0Ol1581w1583w1585w(0) AND wire_n0l1l_w_lg_nll0ll1586w(0);
	wire_n0l1l_w_lg_w_lg_w_lg_nll0Ol1581w1583w1585w(0) <= wire_n0l1l_w_lg_w_lg_nll0Ol1581w1583w(0) AND wire_n0l1l_w_lg_nll0lO1584w(0);
	wire_n0l1l_w_lg_w_lg_nll0Ol1581w1583w(0) <= wire_n0l1l_w_lg_nll0Ol1581w(0) AND wire_n0l1l_w_lg_nll0Oi1582w(0);
	wire_n0l1l_w_lg_n01Oi120w(0) <= NOT n01Oi;
	wire_n0l1l_w_lg_n0l1O108w(0) <= NOT n0l1O;
	wire_n0l1l_w_lg_n1lOO914w(0) <= NOT n1lOO;
	wire_n0l1l_w_lg_n1O1l912w(0) <= NOT n1O1l;
	wire_n0l1l_w_lg_nl1OiO1309w(0) <= NOT nl1OiO;
	wire_n0l1l_w_lg_nlii0i1304w(0) <= NOT nlii0i;
	wire_n0l1l_w_lg_nliilO1609w(0) <= NOT nliilO;
	wire_n0l1l_w_lg_nll00i1600w(0) <= NOT nll00i;
	wire_n0l1l_w_lg_nll00l1598w(0) <= NOT nll00l;
	wire_n0l1l_w_lg_nll00O1596w(0) <= NOT nll00O;
	wire_n0l1l_w_lg_nll01i1606w(0) <= NOT nll01i;
	wire_n0l1l_w_lg_nll01l1604w(0) <= NOT nll01l;
	wire_n0l1l_w_lg_nll01O1602w(0) <= NOT nll01O;
	wire_n0l1l_w_lg_nll0ii1594w(0) <= NOT nll0ii;
	wire_n0l1l_w_lg_nll0il1592w(0) <= NOT nll0il;
	wire_n0l1l_w_lg_nll0iO1590w(0) <= NOT nll0iO;
	wire_n0l1l_w_lg_nll0li1588w(0) <= NOT nll0li;
	wire_n0l1l_w_lg_nll0ll1586w(0) <= NOT nll0ll;
	wire_n0l1l_w_lg_nll0lO1584w(0) <= NOT nll0lO;
	wire_n0l1l_w_lg_nll0Oi1582w(0) <= NOT nll0Oi;
	wire_n0l1l_w_lg_nll0Ol1581w(0) <= NOT nll0Ol;
	wire_n0l1l_w_lg_nlOiiO1303w(0) <= NOT nlOiiO;
	wire_n0l1l_w_lg_nli00i1306w(0) <= nli00i OR wire_n0l1l_w_lg_nll11l1305w(0);
	wire_n0l1l_w_lg_nll11l1310w(0) <= nll11l OR wire_n0l1l_w_lg_nl1OiO1309w(0);
	wire_n0l1l_w_lg_nll11l1305w(0) <= nll11l OR wire_n0l1l_w_lg_nlii0i1304w(0);
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n0lll <= '0';
				n0llO <= '0';
				n0lOi <= '0';
				n0lOl <= '0';
				n0lOO <= '0';
				n0O1i <= '0';
				n0O1O <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (niOOlO = '1') THEN
				n0lll <= nl1iO;
				n0llO <= nl1ii;
				n0lOi <= nl10O;
				n0lOl <= niOii;
				n0lOO <= niO0l;
				n0O1i <= niliO;
				n0O1O <= niilO;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n111l <= '0';
				nllili <= '0';
				nllill <= '0';
				nllilO <= '0';
				nlliOi <= '0';
				nlliOl <= '0';
				nlliOO <= '0';
				nlll0i <= '0';
				nlll0l <= '0';
				nlll0O <= '0';
				nlll1i <= '0';
				nlll1l <= '0';
				nlll1O <= '0';
				nlllii <= '0';
				nlllil <= '0';
				nllliO <= '0';
				nlllli <= '0';
				nlOilO <= '0';
				nlOl1i <= '0';
				nlOl1l <= '0';
				nlOl1O <= '0';
				nlOlil <= '0';
				nlOlOi <= '0';
				nlOlOl <= '0';
				nlOlOO <= '0';
				nlOO0i <= '0';
				nlOO0l <= '0';
				nlOO1i <= '0';
				nlOO1l <= '0';
				nlOO1O <= '0';
				nlOOOi <= '0';
				nlOOOl <= '0';
				nlOOOO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (nlii0O = '1') THEN
				n111l <= nl0lOO;
				nllili <= nl00Oi;
				nllill <= nl00OO;
				nllilO <= nl0i1l;
				nlliOi <= nl0i0i;
				nlliOl <= nl0i0O;
				nlliOO <= nl0iil;
				nlll0i <= nl0l1i;
				nlll0l <= nl0l1O;
				nlll0O <= nl0l0l;
				nlll1i <= nl0ili;
				nlll1l <= nl0ilO;
				nlll1O <= nl0iOl;
				nlllii <= nl0lii;
				nlllil <= nl0liO;
				nllliO <= nl0lll;
				nlllli <= nl0lOi;
				nlOilO <= nli0lO;
				nlOl1i <= nli1OO;
				nlOl1l <= nli1Oi;
				nlOl1O <= nli1ll;
				nlOlil <= nli1iO;
				nlOlOi <= nli1ii;
				nlOlOl <= nli10l;
				nlOlOO <= nli11O;
				nlOO0i <= nl0Oli;
				nlOO0l <= nl0Oil;
				nlOO1i <= nli11i;
				nlOO1l <= nl0OOl;
				nlOO1O <= nl0OlO;
				nlOOOi <= nl0O0O;
				nlOOOl <= nl0O0i;
				nlOOOO <= nl0O1l;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				n1lOl <= '1';
				nll0OO <= '1';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
				n1lOl <= wire_nliOO_dataout;
				nll0OO <= wire_nllO0O_o;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				ni00O <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (b_ena = '1') THEN
				ni00O <= wire_ni0iO_w_lg_ni0li613w(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				ni0ii <= '1';
				ni0li <= '1';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
				ni0ii <= ni0li;
				ni0li <= wire_niO1l_dataout;
		END IF;
	END PROCESS;
	wire_ni0iO_w_lg_ni0ii652w(0) <= NOT ni0ii;
	wire_ni0iO_w_lg_ni0li613w(0) <= NOT ni0li;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				nii0l <= '1';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (niOOOi = '1') THEN
				nii0l <= wire_niO1O_o(0);
			END IF;
		END IF;
	END PROCESS;
	wire_nii0i_w_lg_nii0l573w(0) <= NOT nii0l;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n0lil <= '0';
				n0liO <= '0';
				n0lli <= '0';
				n0O0i <= '0';
				n0O0l <= '0';
				n0O0O <= '0';
				n0Oii <= '0';
				n0Oil <= '0';
				n0OiO <= '0';
				n0Oli <= '0';
				n0Oll <= '0';
				n0OlO <= '0';
				ni00i <= '0';
				ni0il <= '0';
				ni0ll <= '0';
				ni0lO <= '0';
				ni0Oi <= '0';
				ni0Ol <= '0';
				ni0OO <= '0';
				ni10l <= '0';
				ni10O <= '0';
				ni1ii <= '0';
				ni1il <= '0';
				ni1iO <= '0';
				ni1li <= '0';
				ni1ll <= '0';
				ni1lO <= '0';
				ni1Oi <= '0';
				ni1Ol <= '0';
				nii1i <= '0';
				nii1O <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
				n0lil <= wire_niOll_dataout;
				n0liO <= wire_niOli_dataout;
				n0lli <= wire_n1lil_dataout;
				n0O0i <= n01Ol;
				n0O0l <= n0O0i;
				n0O0O <= n1O1O;
				n0Oii <= n1O0i;
				n0Oil <= n1O0l;
				n0OiO <= n1O0O;
				n0Oli <= n1Oii;
				n0Oll <= n1Oil;
				n0OlO <= n1OiO;
				ni00i <= wire_niiOi_dataout;
				ni0il <= b_ena;
				ni0ll <= wire_nilli_dataout;
				ni0lO <= wire_nilll_dataout;
				ni0Oi <= wire_nillO_dataout;
				ni0Ol <= wire_nilOi_dataout;
				ni0OO <= wire_nilOl_dataout;
				ni10l <= n1O1l;
				ni10O <= ni10l;
				ni1ii <= ni10O;
				ni1il <= n01OO;
				ni1iO <= n001i;
				ni1li <= n001l;
				ni1ll <= n001O;
				ni1lO <= n000i;
				ni1Oi <= n000l;
				ni1Ol <= n00ii;
				nii1i <= wire_nilOO_dataout;
				nii1O <= wire_niO1i_dataout;
		END IF;
	END PROCESS;
	wire_nii1l_w_lg_n0lil909w(0) <= NOT n0lil;
	wire_nii1l_w_lg_n0lli907w(0) <= NOT n0lli;
	wire_nii1l_w_lg_ni10O557w(0) <= NOT ni10O;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl00Oi <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl00lO_ENA = '1') THEN
				nl00Oi <= nl1Oli;
			END IF;
		END IF;
	END PROCESS;
	wire_nl00lO_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl00OO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl00Ol_ENA = '1') THEN
				nl00OO <= nl1Oll;
			END IF;
		END IF;
	END PROCESS;
	wire_nl00Ol_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0i0O <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0i0l_ENA = '1') THEN
				nl0i0O <= nl1OOl;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0i0l_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0i1l <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0i1i_ENA = '1') THEN
				nl0i1l <= nl1OlO;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0i1i_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0i0i <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0i1O_ENA = '1') THEN
				nl0i0i <= nl1OOi;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0i1O_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0iil <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0iii_ENA = '1') THEN
				nl0iil <= nl1OOO;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0iii_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0ili <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0iiO_ENA = '1') THEN
				nl0ili <= nl011i;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0iiO_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0ilO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0ill_ENA = '1') THEN
				nl0ilO <= nl011l;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0ill_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0iOl <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0iOi_ENA = '1') THEN
				nl0iOl <= nl011O;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0iOi_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0l1i <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0iOO_ENA = '1') THEN
				nl0l1i <= nl010i;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0iOO_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0l0l <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0l0i_ENA = '1') THEN
				nl0l0l <= nl010O;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0l0i_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0lii <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0l0O_ENA = '1') THEN
				nl0lii <= nl01ii;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0l0O_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0l1O <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0l1l_ENA = '1') THEN
				nl0l1O <= nl010l;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0l1l_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0liO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0lil_ENA = '1') THEN
				nl0liO <= nl01il;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0lil_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0lll <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0lli_ENA = '1') THEN
				nl0lll <= nl01iO;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0lli_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0lOi <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0llO_ENA = '1') THEN
				nl0lOi <= nl01li;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0llO_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0lOO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0lOl_ENA = '1') THEN
				nl0lOO <= nl01ll;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0lOl_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0O0O <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0O0l_ENA = '1') THEN
				nl0O0O <= nl01Ol;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0O0l_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0O1l <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0O1i_ENA = '1') THEN
				nl0O1l <= nl01lO;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0O1i_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0O0i <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0O1O_ENA = '1') THEN
				nl0O0i <= nl01Oi;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0O1O_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0Oil <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0Oii_ENA = '1') THEN
				nl0Oil <= nl01OO;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0Oii_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0Oli <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0OiO_ENA = '1') THEN
				nl0Oli <= nl001i;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0OiO_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0OlO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0Oll_ENA = '1') THEN
				nl0OlO <= nl001l;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0Oll_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nl0OOl <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0OOi_ENA = '1') THEN
				nl0OOl <= nl001O;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0OOi_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli11i <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nl0OOO_ENA = '1') THEN
				nli11i <= nl000i;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0OOO_ENA <= (nlii0i AND nliill);
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				nii0O <= '0';
				niiii <= '0';
				niiil <= '0';
				niiiO <= '0';
				niili <= '0';
				niill <= '0';
				niilO <= '0';
				niliO <= '0';
				niO0l <= '0';
				niOii <= '0';
				nl10O <= '0';
				nl1ii <= '0';
				nl1iO <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (niOOOi = '1') THEN
				nii0O <= wire_niO1O_o(1);
				niiii <= wire_niO1O_o(2);
				niiil <= wire_niO1O_o(3);
				niiiO <= wire_niO1O_o(4);
				niili <= wire_niO1O_o(5);
				niill <= wire_niO1O_o(6);
				niilO <= nii0l;
				niliO <= nii0O;
				niO0l <= niiii;
				niOii <= niiil;
				nl10O <= niiiO;
				nl1ii <= niili;
				nl1iO <= niill;
			END IF;
		END IF;
	END PROCESS;
	wire_nl1il_w_lg_nii0O575w(0) <= NOT nii0O;
	wire_nl1il_w_lg_niiii577w(0) <= NOT niiii;
	wire_nl1il_w_lg_niiil579w(0) <= NOT niiil;
	wire_nl1il_w_lg_niiiO581w(0) <= NOT niiiO;
	wire_nl1il_w_lg_niili583w(0) <= NOT niili;
	wire_nl1il_w_lg_niill585w(0) <= NOT niill;
	wire_nl1il_w_lg_niilO600w(0) <= NOT niilO;
	wire_nl1il_w_lg_niliO602w(0) <= NOT niliO;
	wire_nl1il_w_lg_niO0l604w(0) <= NOT niO0l;
	wire_nl1il_w_lg_niOii606w(0) <= NOT niOii;
	wire_nl1il_w_lg_nl10O608w(0) <= NOT nl10O;
	wire_nl1il_w_lg_nl1ii610w(0) <= NOT nl1ii;
	wire_nl1il_w_lg_nl1iO612w(0) <= NOT nl1iO;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				nl1ll <= '1';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (nl10li = '1') THEN
				nl1ll <= wire_nilii_o(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli00O <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli00l_ENA = '1') THEN
				nli00O <= nli00i;
			END IF;
		END IF;
	END PROCESS;
	wire_nli00l_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli01O <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli01l_ENA = '1') THEN
				nli01O <= nli01i;
			END IF;
		END IF;
	END PROCESS;
	wire_nli01l_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli0iO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli0il_ENA = '1') THEN
				nli0iO <= nli0ii;
			END IF;
		END IF;
	END PROCESS;
	wire_nli0il_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli0lO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli0ll_ENA = '1') THEN
				nli0lO <= nli0li;
			END IF;
		END IF;
	END PROCESS;
	wire_nli0ll_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nlii1i <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli0OO_ENA = '1') THEN
				nlii1i <= nli0Oi;
			END IF;
		END IF;
	END PROCESS;
	wire_nli0OO_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli10l <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli10i_ENA = '1') THEN
				nli10l <= nl000O;
			END IF;
		END IF;
	END PROCESS;
	wire_nli10i_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli1ii <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli10O_ENA = '1') THEN
				nli1ii <= nl00ii;
			END IF;
		END IF;
	END PROCESS;
	wire_nli10O_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli11O <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli11l_ENA = '1') THEN
				nli11O <= nl000l;
			END IF;
		END IF;
	END PROCESS;
	wire_nli11l_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli1iO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli1il_ENA = '1') THEN
				nli1iO <= nl00il;
			END IF;
		END IF;
	END PROCESS;
	wire_nli1il_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli1ll <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli1li_ENA = '1') THEN
				nli1ll <= nl00iO;
			END IF;
		END IF;
	END PROCESS;
	wire_nli1li_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli1Oi <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli1lO_ENA = '1') THEN
				nli1Oi <= nl00li;
			END IF;
		END IF;
	END PROCESS;
	wire_nli1lO_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nli1OO <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nli1Ol_ENA = '1') THEN
				nli1OO <= nl00ll;
			END IF;
		END IF;
	END PROCESS;
	wire_nli1Ol_ENA <= (nlii0i AND nliill);
	PROCESS (a_rfclk, a_rreset_n)
	BEGIN
		IF (a_rreset_n = '0') THEN
				nlii1O <= '0';
		ELSIF (a_rfclk = '1' AND a_rfclk'event) THEN
			IF (wire_nlii1l_ENA = '1') THEN
				nlii1O <= nli0Ol;
			END IF;
		END IF;
	END PROCESS;
	wire_nlii1l_ENA <= (nlii0i AND nliill);
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				nl01i <= '0';
				nl01l <= '0';
				nl01O <= '0';
				nl1lO <= '0';
				nl1Oi <= '0';
				nl1Ol <= '0';
				nl1OO <= '0';
				nliil <= '0';
				nlili <= '0';
				nlliO <= '0';
				nllOi <= '0';
				nllOl <= '0';
				nlO1i <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (nl10li = '1') THEN
				nl01i <= wire_nilii_o(5);
				nl01l <= wire_nilii_o(6);
				nl01O <= nl1ll;
				nl1lO <= wire_nilii_o(1);
				nl1Oi <= wire_nilii_o(2);
				nl1Ol <= wire_nilii_o(3);
				nl1OO <= wire_nilii_o(4);
				nliil <= nl1lO;
				nlili <= nl1Oi;
				nlliO <= nl1Ol;
				nllOi <= nl1OO;
				nllOl <= nl01i;
				nlO1i <= nl01l;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n0OOi <= '0';
				n0OOl <= '0';
				n0OOO <= '0';
				ni01i <= '0';
				ni01l <= '0';
				ni01O <= '0';
				ni10i <= '0';
				ni11i <= '0';
				ni11l <= '0';
				ni11O <= '0';
				ni1OO <= '0';
				nlO0l <= '0';
				nlO1l <= '0';
				nlO1O <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (nl10Ol = '0') THEN
				n0OOi <= n0O0O;
				n0OOl <= n0Oii;
				n0OOO <= n0Oil;
				ni01i <= ni1iO;
				ni01l <= ni1li;
				ni01O <= ni1ll;
				ni10i <= n0OlO;
				ni11i <= n0OiO;
				ni11l <= n0Oli;
				ni11O <= n0Oll;
				ni1OO <= ni1il;
				nlO0l <= ni1lO;
				nlO1l <= ni1Ol;
				nlO1O <= ni1Oi;
			END IF;
		END IF;
	END PROCESS;
	wire_n1lii_dataout <= wire_n0l1l_w_lg_n1O1l912w(0) WHEN (n1O1i AND (wire_w_lg_nl100i913w(0) AND wire_n0l1l_w_lg_n1lOO914w(0))) = '1'  ELSE n1O1l;
	wire_n1lil_dataout <= wire_nii1l_w_lg_n0lli907w(0) WHEN (n0liO AND (wire_w_lg_niOOlO908w(0) AND wire_nii1l_w_lg_n0lil909w(0))) = '1'  ELSE n0lli;
	wire_niiOi_dataout <= wire_niiOl_dataout OR (wire_nil0O_w_lg_dataout879w(0) OR wire_nil0l_o);
	wire_niiOl_dataout <= ni00i AND NOT((b_ena AND (wire_nil0O_dataout AND wire_nil1l_o)));
	wire_nil0O_dataout <= niOOil WHEN nl10li = '1'  ELSE niOOiO;
	wire_nil0O_w_lg_dataout879w(0) <= NOT wire_nil0O_dataout;
	wire_nilli_dataout <= wire_niOil_o(1) WHEN niOOOi = '1'  ELSE wire_niO0O_o(1);
	wire_nilll_dataout <= wire_niOil_o(2) WHEN niOOOi = '1'  ELSE wire_niO0O_o(2);
	wire_nillO_dataout <= wire_niOil_o(3) WHEN niOOOi = '1'  ELSE wire_niO0O_o(3);
	wire_nilOi_dataout <= wire_niOil_o(4) WHEN niOOOi = '1'  ELSE wire_niO0O_o(4);
	wire_nilOl_dataout <= wire_niOil_o(5) WHEN niOOOi = '1'  ELSE wire_niO0O_o(5);
	wire_nilOO_dataout <= wire_niOil_o(6) WHEN niOOOi = '1'  ELSE wire_niO0O_o(6);
	wire_niO1i_dataout <= wire_niOil_o(7) WHEN niOOOi = '1'  ELSE wire_niO0O_o(7);
	wire_niO1l_dataout <= niOOli WHEN niOOOi = '1'  ELSE niOOll;
	wire_niOli_dataout <= wire_niOOi_dataout AND NOT(niOOlO);
	wire_niOll_dataout <= wire_niOOl_dataout OR niOOlO;
	wire_niOlO_dataout <= wire_niOOO_dataout AND NOT(niOOlO);
	wire_niOOi_dataout <= wire_nl11i_dataout OR n0lil;
	wire_niOOl_dataout <= wire_nl11l_dataout AND NOT(n0lil);
	wire_niOOO_dataout <= wire_nl11O_dataout AND NOT(n0lil);
	wire_nl00O_dataout <= wire_nl0ii_dataout AND NOT(wire_nl0li_o);
	wire_nl0ii_dataout <= n0l0l OR wire_nl0il_o;
	wire_nl0lO_dataout <= wire_nli0l_o(1) WHEN nl10ii = '1'  ELSE wire_nli0i_o(1);
	wire_nl0Oi_dataout <= wire_nli0l_o(2) WHEN nl10ii = '1'  ELSE wire_nli0i_o(2);
	wire_nl0Ol_dataout <= wire_nli0l_o(3) WHEN nl10ii = '1'  ELSE wire_nli0i_o(3);
	wire_nl0OO_dataout <= wire_nli0l_o(4) WHEN nl10ii = '1'  ELSE wire_nli0i_o(4);
	wire_nl11i_dataout <= n0liO AND NOT(n0liO);
	wire_nl11l_dataout <= n0lil AND NOT(n0liO);
	wire_nl11O_dataout <= n0lii OR n0liO;
	wire_nli1i_dataout <= wire_nli0l_o(5) WHEN nl10ii = '1'  ELSE wire_nli0i_o(5);
	wire_nli1l_dataout <= wire_nli0l_o(6) WHEN nl10ii = '1'  ELSE wire_nli0i_o(6);
	wire_nli1O_dataout <= wire_nli0l_o(7) WHEN nl10ii = '1'  ELSE wire_nli0i_o(7);
	wire_nliiOi_dataout <= niOlOO AND NOT(niOO1l);
	wire_nliiOl_dataout <= wire_nliO1i_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(1);
	wire_nliiOO_dataout <= wire_nliO1l_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(2);
	wire_nlil0i_dataout <= wire_nliO0O_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(6);
	wire_nlil0l_dataout <= wire_nliOii_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(7);
	wire_nlil0O_dataout <= wire_nliOil_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(8);
	wire_nlil1i_dataout <= wire_nliO1O_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(3);
	wire_nlil1l_dataout <= wire_nliO0i_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(4);
	wire_nlil1O_dataout <= wire_nliO0l_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(5);
	wire_nlilii_dataout <= wire_nliOiO_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(9);
	wire_nlilil_dataout <= wire_nliOli_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(10);
	wire_nliliO_dataout <= wire_nliOll_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(11);
	wire_nlilli_dataout <= wire_nliOlO_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(12);
	wire_nlilll_dataout <= wire_nliOOi_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(13);
	wire_nlillO_dataout <= wire_nliOOl_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(14);
	wire_nlilOi_dataout <= wire_nliOOO_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(15);
	wire_nlilOl_dataout <= wire_nll11i_dataout WHEN niOO1l = '1'  ELSE wire_nlilOO_o(16);
	wire_nliO0i_dataout <= wire_nll10i_o(4) WHEN niOO1i = '1'  ELSE wire_nll11O_o(2);
	wire_nliO0l_dataout <= wire_nll10i_o(5) WHEN niOO1i = '1'  ELSE wire_nll11O_o(3);
	wire_nliO0O_dataout <= wire_nll10i_o(6) WHEN niOO1i = '1'  ELSE wire_nll11O_o(4);
	wire_nliO1i_dataout <= wire_nll10i_o(1) AND niOO1i;
	wire_nliO1l_dataout <= wire_nll10i_o(2) AND niOO1i;
	wire_nliO1O_dataout <= wire_nll10i_o(3) WHEN niOO1i = '1'  ELSE wire_nll11O_o(1);
	wire_nliOi_dataout <= wire_nll1i_dataout AND NOT(nl100i);
	wire_nliOii_dataout <= wire_nll10i_o(7) WHEN niOO1i = '1'  ELSE wire_nll11O_o(5);
	wire_nliOil_dataout <= wire_nll10i_o(8) WHEN niOO1i = '1'  ELSE wire_nll11O_o(6);
	wire_nliOiO_dataout <= wire_nll10i_o(9) WHEN niOO1i = '1'  ELSE wire_nll11O_o(7);
	wire_nliOl_dataout <= wire_nll1l_dataout OR nl100i;
	wire_nliOli_dataout <= wire_nll10i_o(10) WHEN niOO1i = '1'  ELSE wire_nll11O_o(8);
	wire_nliOll_dataout <= wire_nll10i_o(11) WHEN niOO1i = '1'  ELSE wire_nll11O_o(9);
	wire_nliOlO_dataout <= wire_nll10i_o(12) WHEN niOO1i = '1'  ELSE wire_nll11O_o(10);
	wire_nliOO_dataout <= wire_nll1O_dataout AND NOT(nl100i);
	wire_nliOOi_dataout <= wire_nll10i_o(13) WHEN niOO1i = '1'  ELSE wire_nll11O_o(11);
	wire_nliOOl_dataout <= wire_nll10i_o(14) WHEN niOO1i = '1'  ELSE wire_nll11O_o(12);
	wire_nliOOO_dataout <= wire_nll10i_o(15) WHEN niOO1i = '1'  ELSE wire_nll11O_o(13);
	wire_nll0i_dataout <= n1O1i AND NOT(n1O1i);
	wire_nll0l_dataout <= n1lOO AND NOT(n1O1i);
	wire_nll0O_dataout <= n1lOl OR n1O1i;
	wire_nll11i_dataout <= wire_nll10i_o(16) WHEN niOO1i = '1'  ELSE wire_nll11O_o(14);
	wire_nll1i_dataout <= wire_nll0i_dataout OR n1lOO;
	wire_nll1il_dataout <= nliill AND nlii0i;
	wire_nll1iO_dataout <= wire_nll1Oi_dataout WHEN wire_n0l1l_w_lg_nl1OiO1309w(0) = '1'  ELSE (NOT (wire_n0l1l_w_lg_nlOiiO1303w(0) AND wire_n0l1l_w_lg_nli00i1306w(0)));
	wire_nll1iO_w_lg_dataout1545w(0) <= NOT wire_nll1iO_dataout;
	wire_nll1l_dataout <= wire_nll0l_dataout AND NOT(n1lOO);
	wire_nll1O_dataout <= wire_nll0O_dataout AND NOT(n1lOO);
	wire_nll1Oi_dataout <= (nlOiiO AND nlii0i) OR nlOiiO;
	wire_nllOil_dataout <= wire_nlO01i_dataout OR NOT(nlii0O);
	wire_nllOiO_dataout <= wire_nlO1OO_dataout OR NOT(nlii0O);
	wire_nllOli_dataout <= wire_nlO1Ol_dataout OR NOT(nlii0O);
	wire_nllOll_dataout <= wire_nlO1Oi_dataout OR NOT(nlii0O);
	wire_nllOlO_dataout <= wire_nlO1lO_dataout OR NOT(nlii0O);
	wire_nllOOi_dataout <= wire_nlO1li_dataout AND nlii0O;
	wire_nllOOl_dataout <= wire_nlO1ll_dataout OR NOT(nlii0O);
	wire_nllOOO_dataout <= wire_nlO1li_dataout OR NOT(nlii0O);
	wire_nlO00i_dataout <= wire_nlO0Ol_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlO00l_dataout <= nlliiO AND NOT(wire_nlOOiO_dataout);
	wire_nlO00O_dataout <= nlliil AND NOT(wire_nlOOiO_dataout);
	wire_nlO01i_dataout <= wire_nlO0ll_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlO01l_dataout <= wire_nlO0lO_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlO01O_dataout <= wire_nlO0Oi_dataout OR wire_nlOOll_dataout;
	wire_nlO0ii_dataout <= nlliii AND NOT(wire_nlOOiO_dataout);
	wire_nlO0il_dataout <= nlli0O AND NOT(wire_nlOOiO_dataout);
	wire_nlO0iO_dataout <= nlli0l AND NOT(wire_nlOOiO_dataout);
	wire_nlO0li_dataout <= nlli0i AND NOT(wire_nlOOiO_dataout);
	wire_nlO0ll_dataout <= nlli1O AND NOT(wire_nlOOiO_dataout);
	wire_nlO0lO_dataout <= nlli1l AND NOT(wire_nlOOiO_dataout);
	wire_nlO0Oi_dataout <= nlli1i OR wire_nlOOiO_dataout;
	wire_nlO0Ol_dataout <= nll0OO AND NOT(wire_nlOOiO_dataout);
	wire_nlO0OO_dataout <= wire_nlOi1l_dataout OR NOT(nlii0O);
	wire_nlO10i_dataout <= wire_nlO1Ol_dataout AND nlii0O;
	wire_nlO10l_dataout <= wire_nlO1OO_dataout AND nlii0O;
	wire_nlO10O_dataout <= wire_nlO01i_dataout AND nlii0O;
	wire_nlO11i_dataout <= wire_nlO1ll_dataout AND nlii0O;
	wire_nlO11l_dataout <= wire_nlO1lO_dataout AND nlii0O;
	wire_nlO11O_dataout <= wire_nlO1Oi_dataout AND nlii0O;
	wire_nlO1ii_dataout <= wire_nlO01l_dataout AND nlii0O;
	wire_nlO1il_dataout <= wire_nlO01O_dataout AND nlii0O;
	wire_nlO1iO_dataout <= wire_nlO00i_dataout AND nlii0O;
	wire_nlO1li_dataout <= wire_nlO00l_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlO1ll_dataout <= wire_nlO00O_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlO1lO_dataout <= wire_nlO0ii_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlO1Oi_dataout <= wire_nlO0il_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlO1Ol_dataout <= wire_nlO0iO_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlO1OO_dataout <= wire_nlO0li_dataout AND NOT(wire_nlOOll_dataout);
	wire_nlOi0i_dataout <= wire_nlOiii_dataout AND nlii0O;
	wire_nlOi0l_dataout <= wire_nlOiil_dataout AND nlii0O;
	wire_nlOi0O_dataout <= wire_nlOOll_w_lg_dataout1096w(0) OR NOT(nlii0O);
	wire_nlOi1i_dataout <= wire_nlOi1O_dataout AND nlii0O;
	wire_nlOi1l_dataout <= wire_nlOOiO_w_lg_dataout1097w(0) AND NOT(wire_nlOOll_dataout);
	wire_nlOi1O_dataout <= wire_nlOOiO_dataout OR wire_nlOOll_dataout;
	wire_nlOiii_dataout <= wire_nlOOiO_w_lg_dataout1097w(0) AND NOT(wire_nlOOll_w_lg_dataout1096w(0));
	wire_nlOiil_dataout <= wire_nlOOiO_dataout AND NOT(wire_nlOOll_w_lg_dataout1096w(0));
	wire_nlOl0O_dataout <= nlii1O AND wire_nllO0l_o;
	wire_nlOlii_dataout <= nlii1i AND wire_nllO0l_o;
	wire_nlOliO_dataout <= wire_nlOO0O_dataout AND wire_nllO0l_o;
	wire_nlOlli_dataout <= wire_nlOOiO_dataout AND wire_nllO0l_o;
	wire_nlOlll_dataout <= wire_nlOOll_dataout WHEN niOO0l = '1'  ELSE wire_nlOllO_dataout;
	wire_nlOllO_dataout <= nlOiOO AND NOT(nlli1l);
	wire_nlOO0O_dataout <= niOO0i WHEN niOO0l = '1'  ELSE (nli01O OR niOO0i);
	wire_nlOOiO_dataout <= nli00O WHEN niOO0l = '1'  ELSE (nli01O OR nli00O);
	wire_nlOOiO_w_lg_dataout1097w(0) <= NOT wire_nlOOiO_dataout;
	wire_nlOOll_dataout <= nli01O AND niOO0l;
	wire_nlOOll_w_lg_dataout1096w(0) <= NOT wire_nlOOll_dataout;
	wire_nil1O_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "0" & "0" & "0");
	wire_nil1O_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nil1O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16,
		width_o => 16
	  )
	  PORT MAP ( 
		a => wire_nil1O_a,
		b => wire_nil1O_b,
		cin => wire_gnd,
		o => wire_nil1O_o
	  );
	wire_nilii_a <= ( nl01l & nl01i & nl1OO & nl1Ol & nl1Oi & nl1lO & nl1ll);
	wire_nilii_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nilii :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_nilii_a,
		b => wire_nilii_b,
		cin => wire_gnd,
		o => wire_nilii_o
	  );
	wire_niO0O_a <= ( n0OOi & n0OOl & n0OOO & ni11i & ni11l & ni11O & ni10i & "1");
	wire_niO0O_b <= ( wire_nl1il_w_lg_nl1iO612w & wire_nl1il_w_lg_nl1ii610w & wire_nl1il_w_lg_nl10O608w & wire_nl1il_w_lg_niOii606w & wire_nl1il_w_lg_niO0l604w & wire_nl1il_w_lg_niliO602w & wire_nl1il_w_lg_niilO600w & "1");
	niO0O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8,
		width_o => 8
	  )
	  PORT MAP ( 
		a => wire_niO0O_a,
		b => wire_niO0O_b,
		cin => wire_gnd,
		o => wire_niO0O_o
	  );
	wire_niO1O_a <= ( niill & niili & niiiO & niiil & niiii & nii0O & nii0l);
	wire_niO1O_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "1");
	niO1O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_niO1O_a,
		b => wire_niO1O_b,
		cin => wire_gnd,
		o => wire_niO1O_o
	  );
	wire_niOil_a <= ( n0OOi & n0OOl & n0OOO & ni11i & ni11l & ni11O & ni10i & "1");
	wire_niOil_b <= ( wire_nl1il_w_lg_niill585w & wire_nl1il_w_lg_niili583w & wire_nl1il_w_lg_niiiO581w & wire_nl1il_w_lg_niiil579w & wire_nl1il_w_lg_niiii577w & wire_nl1il_w_lg_nii0O575w & wire_nii0i_w_lg_nii0l573w & "1");
	niOil :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8,
		width_o => 8
	  )
	  PORT MAP ( 
		a => wire_niOil_a,
		b => wire_niOil_b,
		cin => wire_gnd,
		o => wire_niOil_o
	  );
	wire_nl00i_a <= ( n00il & n00iO & n00li & n00ll & n00lO & n00Oi & n00OO);
	wire_nl00i_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nl00i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_nl00i_a,
		b => wire_nl00i_b,
		cin => wire_gnd,
		o => wire_nl00i_o
	  );
	wire_nl0iO_a <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1" & "1" & "1" & "1" & "1");
	wire_nl0iO_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nl0iO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nl0iO_a,
		b => wire_nl0iO_b,
		cin => wire_gnd,
		o => wire_nl0iO_o
	  );
	wire_nl0ll_a <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1" & "1" & "1" & "1" & "1");
	wire_nl0ll_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1");
	wire_nl0ll_w_o_range327w(0) <= wire_nl0ll_o(10);
	wire_nl0ll_w_o_range331w(0) <= wire_nl0ll_o(11);
	wire_nl0ll_w_o_range337w(0) <= wire_nl0ll_o(13);
	wire_nl0ll_w_o_range315w(0) <= wire_nl0ll_o(6);
	wire_nl0ll_w_o_range346w(0) <= wire_nl0ll_o(16);
	nl0ll :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nl0ll_a,
		b => wire_nl0ll_b,
		cin => wire_gnd,
		o => wire_nl0ll_o
	  );
	wire_nli0i_a <= ( n0i1i & wire_nl11il35_w_lg_Q200w & wire_nl11iO32_w_lg_Q197w & n0i0i & wire_nl11li29_w_lg_Q193w & n0i0O & n0iii & "1");
	wire_nli0i_b <= ( wire_n01li_w_lg_n010i184w & wire_n01li_w_lg_n010l180w & wire_nl110O41_w_lg_Q213w & wire_nl11ii38_w_lg_Q210w & wire_n01li_w_lg_n01il171w & wire_n01li_w_lg_n01iO169w & wire_n01li_w_lg_n01ll166w & "1");
	nli0i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8,
		width_o => 8
	  )
	  PORT MAP ( 
		a => wire_nli0i_a,
		b => wire_nli0i_b,
		cin => wire_gnd,
		o => wire_nli0i_o
	  );
	wire_nli0l_a <= ( n0iil & n0iiO & n0ili & wire_nl11OO14_w_lg_Q157w & n0ilO & n0iOl & n0l1i & "1");
	wire_nli0l_b <= ( wire_nl11ll26_w_lg_Q185w & wire_nl11lO23_w_lg_Q181w & wire_nl11Oi20_w_lg_Q177w & wire_n01li_w_lg_n01ii173w & wire_n01li_w_lg_n01il171w & wire_n01li_w_lg_n01iO169w & wire_nl11Ol17_w_lg_Q167w & "1");
	nli0l :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8,
		width_o => 8
	  )
	  PORT MAP ( 
		a => wire_nli0l_a,
		b => wire_nli0l_b,
		cin => wire_gnd,
		o => wire_nli0l_o
	  );
	wire_nlill_a <= ( wire_nl101i11_w_lg_Q133w & n0iiO & wire_nl101l8_w_lg_Q129w & n0ill & n0ilO & n0iOl & n0l1i);
	wire_nlill_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nlill :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_nlill_a,
		b => wire_nlill_b,
		cin => wire_gnd,
		o => wire_nlill_o
	  );
	wire_nlilOO_a <= ( nliilO & nll0Ol & nll0Oi & nll0lO & nll0ll & nll0li & nll0iO & nll0il & nll0ii & nll00O & nll00l & nll00i & nll01O & nll01l & nll01i & nll1OO & "1");
	wire_nlilOO_b <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1");
	nlilOO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nlilOO_a,
		b => wire_nlilOO_b,
		cin => wire_gnd,
		o => wire_nlilOO_o
	  );
	wire_nll10i_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "0" & "0" & "0" & "1");
	wire_nll10i_b <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1");
	nll10i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nll10i_a,
		b => wire_nll10i_b,
		cin => wire_gnd,
		o => wire_nll10i_o
	  );
	wire_nll11O_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "0" & "1");
	wire_nll11O_b <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1");
	nll11O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 15,
		width_b => 15,
		width_o => 15
	  )
	  PORT MAP ( 
		a => wire_nll11O_a,
		b => wire_nll11O_b,
		cin => wire_gnd,
		o => wire_nll11O_o
	  );
	wire_nil0l_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "1" & "1" & "0");
	wire_nil0l_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & nii1O & nii1i & ni0OO & ni0Ol & ni0Oi & ni0lO & ni0ll);
	nil0l :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16
	  )
	  PORT MAP ( 
		a => wire_nil0l_a,
		b => wire_nil0l_b,
		cin => wire_gnd,
		o => wire_nil0l_o
	  );
	wire_nil1l_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & nii1O & nii1i & ni0OO & ni0Ol & ni0Oi & ni0lO & ni0ll);
	wire_nil1l_b <= ( wire_nil1O_o(15 DOWNTO 0));
	nil1l :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16
	  )
	  PORT MAP ( 
		a => wire_nil1l_a,
		b => wire_nil1l_b,
		cin => wire_gnd,
		o => wire_nil1l_o
	  );
	wire_nl0il_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nli1O_dataout & wire_nli1l_dataout & wire_nli1i_dataout & wire_nl0OO_dataout & wire_nl0Ol_dataout & wire_nl0Oi_dataout & wire_nl0lO_dataout);
	wire_nl0il_b <= ( wire_nl0iO_o(16 DOWNTO 1));
	nl0il :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16
	  )
	  PORT MAP ( 
		a => wire_nl0il_a,
		b => wire_nl0il_b,
		cin => wire_vcc,
		o => wire_nl0il_o
	  );
	wire_nl0li_a <= ( wire_nl111i56_w_lg_Q349w & wire_nl0ll_o(15 DOWNTO 14) & wire_nl111l53_w_lg_Q340w & wire_nl0ll_o(12) & wire_nl111O50_w_lg_Q334w & wire_nl110i47_w_lg_Q330w & wire_nl0ll_o(9 DOWNTO 7) & wire_nl110l44_w_lg_Q318w & wire_nl0ll_o(5 DOWNTO 1));
	wire_nl0li_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nli1O_dataout & wire_nli1l_dataout & wire_niOOOO59_w_lg_Q357w & wire_nl0OO_dataout & wire_nl0Ol_dataout & wire_nl0Oi_dataout & wire_nl0lO_dataout);
	nl0li :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16
	  )
	  PORT MAP ( 
		a => wire_nl0li_a,
		b => wire_nl0li_b,
		cin => wire_gnd,
		o => wire_nl0li_o
	  );
	wire_nlllll_data <= ( "0" & wire_nllOOO_dataout & wire_nllOOi_dataout & wire_nllOOi_dataout & wire_nllOOi_dataout & wire_nllOOi_dataout & wire_nllOOi_dataout & wire_nllOOi_dataout);
	wire_nlllll_sel <= ( niOO1O & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nlllll :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_nlllll_data,
		o => wire_nlllll_o,
		sel => wire_nlllll_sel
	  );
	wire_nlllOi_data <= ( "0" & wire_nlO11i_dataout & wire_nllOOl_dataout & wire_nlO11i_dataout & wire_nlO11i_dataout & wire_nlO11i_dataout & wire_nlO11i_dataout & wire_nlO11i_dataout);
	wire_nlllOi_sel <= ( niOO1O & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nlllOi :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_nlllOi_data,
		o => wire_nlllOi_o,
		sel => wire_nlllOi_sel
	  );
	wire_nlllOl_data <= ( "0" & wire_nlO11l_dataout & wire_nlO11l_dataout & wire_nllOlO_dataout & wire_nlO11l_dataout & wire_nlO11l_dataout & wire_nlO11l_dataout & wire_nlO11l_dataout);
	wire_nlllOl_sel <= ( niOO1O & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nlllOl :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_nlllOl_data,
		o => wire_nlllOl_o,
		sel => wire_nlllOl_sel
	  );
	wire_nlllOO_data <= ( "0" & wire_nlO11O_dataout & wire_nlO11O_dataout & wire_nlO11O_dataout & wire_nllOll_dataout & wire_nlO11O_dataout & wire_nlO11O_dataout & wire_nlO11O_dataout);
	wire_nlllOO_sel <= ( niOO1O & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nlllOO :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_nlllOO_data,
		o => wire_nlllOO_o,
		sel => wire_nlllOO_sel
	  );
	wire_nllO0i_data <= ( wire_nlOi0i_dataout & wire_nlOi0i_dataout & wire_nlO0OO_dataout & wire_nlO1ii_dataout & wire_nlO1ii_dataout & wire_nlO1ii_dataout & wire_nlO1ii_dataout & wire_nlO1ii_dataout & wire_nlO1ii_dataout & wire_nlO1ii_dataout);
	wire_nllO0i_sel <= ( nll0OO & nlli1i & nlli1l & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nllO0i :  oper_selector
	  GENERIC MAP (
		width_data => 10,
		width_sel => 10
	  )
	  PORT MAP ( 
		data => wire_nllO0i_data,
		o => wire_nllO0i_o,
		sel => wire_nllO0i_sel
	  );
	wire_nllO0l_data <= ( wire_nlOi0l_dataout & wire_nlOi0l_dataout & wire_nlOi1i_dataout & wire_nlO1il_dataout & wire_nlO1il_dataout & wire_nlO1il_dataout & wire_nlO1il_dataout & wire_nlO1il_dataout & wire_nlO1il_dataout & wire_nlO1il_dataout);
	wire_nllO0l_sel <= ( nll0OO & nlli1i & nlli1l & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nllO0l :  oper_selector
	  GENERIC MAP (
		width_data => 10,
		width_sel => 10
	  )
	  PORT MAP ( 
		data => wire_nllO0l_data,
		o => wire_nllO0l_o,
		sel => wire_nllO0l_sel
	  );
	wire_nllO0O_data <= ( wire_nlOi0O_dataout & wire_nlOi0O_dataout & "0" & wire_nlO1iO_dataout & wire_nlO1iO_dataout & wire_nlO1iO_dataout & wire_nlO1iO_dataout & wire_nlO1iO_dataout & wire_nlO1iO_dataout & wire_nlO1iO_dataout);
	wire_nllO0O_sel <= ( nll0OO & nlli1i & nlli1l & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nllO0O :  oper_selector
	  GENERIC MAP (
		width_data => 10,
		width_sel => 10
	  )
	  PORT MAP ( 
		data => wire_nllO0O_data,
		o => wire_nllO0O_o,
		sel => wire_nllO0O_sel
	  );
	wire_nllO1i_data <= ( "0" & wire_nlO10i_dataout & wire_nlO10i_dataout & wire_nlO10i_dataout & wire_nlO10i_dataout & wire_nllOli_dataout & wire_nlO10i_dataout & wire_nlO10i_dataout);
	wire_nllO1i_sel <= ( niOO1O & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nllO1i :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_nllO1i_data,
		o => wire_nllO1i_o,
		sel => wire_nllO1i_sel
	  );
	wire_nllO1l_data <= ( "0" & wire_nlO10l_dataout & wire_nlO10l_dataout & wire_nlO10l_dataout & wire_nlO10l_dataout & wire_nlO10l_dataout & wire_nllOiO_dataout & wire_nlO10l_dataout);
	wire_nllO1l_sel <= ( niOO1O & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nllO1l :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_nllO1l_data,
		o => wire_nllO1l_o,
		sel => wire_nllO1l_sel
	  );
	wire_nllO1O_data <= ( "0" & wire_nlO10O_dataout & wire_nlO10O_dataout & wire_nlO10O_dataout & wire_nlO10O_dataout & wire_nlO10O_dataout & wire_nlO10O_dataout & wire_nllOil_dataout);
	wire_nllO1O_sel <= ( niOO1O & nlliiO & nlliil & nlliii & nlli0O & nlli0l & nlli0i & nlli1O);
	nllO1O :  oper_selector
	  GENERIC MAP (
		width_data => 8,
		width_sel => 8
	  )
	  PORT MAP ( 
		data => wire_nllO1O_data,
		o => wire_nllO1O_o,
		sel => wire_nllO1O_sel
	  );

 END RTL; --auk_pac_mrx_pl3_link
--synopsys translate_on
--VALID FILE
