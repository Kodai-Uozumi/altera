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

--synthesis_resources = altsyncram 2 lpm_decode 1 lpm_ff 31 lut 193 mux21 299 oper_add 10 oper_decoder 1 oper_selector 19 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  mastertx_example IS 
	 PORT 
	 ( 
		 atm_tx_data	:	IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 atm_tx_enb	:	OUT  STD_LOGIC;
		 atm_tx_port	:	IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 atm_tx_port_load	:	IN  STD_LOGIC;
		 atm_tx_port_stat	:	OUT  STD_LOGIC_VECTOR (30 DOWNTO 0);
		 atm_tx_port_wait	:	OUT  STD_LOGIC;
		 atm_tx_soc	:	IN  STD_LOGIC;
		 atm_tx_valid	:	IN  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 tx_addr	:	OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 tx_clav	:	IN  STD_LOGIC;
		 tx_clk_in	:	IN  STD_LOGIC;
		 tx_data	:	OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 tx_enb	:	OUT  STD_LOGIC;
		 tx_prty	:	OUT  STD_LOGIC;
		 tx_soc	:	OUT  STD_LOGIC
	 ); 
 END mastertx_example;

 ARCHITECTURE RTL OF mastertx_example IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL  wire_nl01Ol_address_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl01Ol_address_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl01Ol_data_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl01Ol_q_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlO0O_address_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO0O_address_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO0O_clock1	:	STD_LOGIC;
	 SIGNAL  wire_nlO0O_data_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL	 nilOll59	:	STD_LOGIC := '0';
	 SIGNAL	 nilOll60	:	STD_LOGIC := '0';
	 SIGNAL	 nilOOi57	:	STD_LOGIC := '0';
	 SIGNAL	 nilOOi58	:	STD_LOGIC := '0';
	 SIGNAL	 nilOOO55	:	STD_LOGIC := '0';
	 SIGNAL	 nilOOO56	:	STD_LOGIC := '0';
	 SIGNAL	 niO00i45	:	STD_LOGIC := '0';
	 SIGNAL	 niO00i46	:	STD_LOGIC := '0';
	 SIGNAL	 niO00O43	:	STD_LOGIC := '0';
	 SIGNAL	 niO00O44	:	STD_LOGIC := '0';
	 SIGNAL	 niO01l47	:	STD_LOGIC := '0';
	 SIGNAL	 niO01l48	:	STD_LOGIC := '0';
	 SIGNAL	 niO0il41	:	STD_LOGIC := '0';
	 SIGNAL	 niO0il42	:	STD_LOGIC := '0';
	 SIGNAL	 niO0li39	:	STD_LOGIC := '0';
	 SIGNAL	 niO0li40	:	STD_LOGIC := '0';
	 SIGNAL	 niO0lO37	:	STD_LOGIC := '0';
	 SIGNAL	 niO0lO38	:	STD_LOGIC := '0';
	 SIGNAL	 niO0Ol35	:	STD_LOGIC := '0';
	 SIGNAL	 niO0Ol36	:	STD_LOGIC := '0';
	 SIGNAL	 niO11i53	:	STD_LOGIC := '0';
	 SIGNAL	 niO11i54	:	STD_LOGIC := '0';
	 SIGNAL	 niO1Oi51	:	STD_LOGIC := '0';
	 SIGNAL	 niO1Oi52	:	STD_LOGIC := '0';
	 SIGNAL	 niO1OO49	:	STD_LOGIC := '0';
	 SIGNAL	 niO1OO50	:	STD_LOGIC := '0';
	 SIGNAL	 niOi0O29	:	STD_LOGIC := '0';
	 SIGNAL	 niOi0O30	:	STD_LOGIC := '0';
	 SIGNAL	 niOi1i33	:	STD_LOGIC := '0';
	 SIGNAL	 niOi1i34	:	STD_LOGIC := '0';
	 SIGNAL	 niOi1O31	:	STD_LOGIC := '0';
	 SIGNAL	 niOi1O32	:	STD_LOGIC := '0';
	 SIGNAL	 niOiil27	:	STD_LOGIC := '0';
	 SIGNAL	 niOiil28	:	STD_LOGIC := '0';
	 SIGNAL	 niOili25	:	STD_LOGIC := '0';
	 SIGNAL	 niOili26	:	STD_LOGIC := '0';
	 SIGNAL	 niOilO23	:	STD_LOGIC := '0';
	 SIGNAL	 niOilO24	:	STD_LOGIC := '0';
	 SIGNAL	 nl100i5	:	STD_LOGIC := '0';
	 SIGNAL	 nl100i6	:	STD_LOGIC := '0';
	 SIGNAL	 nl100l3	:	STD_LOGIC := '0';
	 SIGNAL	 nl100l4	:	STD_LOGIC := '0';
	 SIGNAL	 nl101i10	:	STD_LOGIC := '0';
	 SIGNAL	 nl101i9	:	STD_LOGIC := '0';
	 SIGNAL	 nl101l7	:	STD_LOGIC := '0';
	 SIGNAL	 nl101l8	:	STD_LOGIC := '0';
	 SIGNAL	 nl10ii1	:	STD_LOGIC := '0';
	 SIGNAL	 nl10ii2	:	STD_LOGIC := '0';
	 SIGNAL	 nl111i21	:	STD_LOGIC := '0';
	 SIGNAL	 nl111i22	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl111i22_w_lg_w_lg_q183w184w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl111i22_w_lg_q183w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl111O19	:	STD_LOGIC := '0';
	 SIGNAL	 nl111O20	:	STD_LOGIC := '0';
	 SIGNAL	 nl11iO17	:	STD_LOGIC := '0';
	 SIGNAL	 nl11iO18	:	STD_LOGIC := '0';
	 SIGNAL	 nl11ll15	:	STD_LOGIC := '0';
	 SIGNAL	 nl11ll16	:	STD_LOGIC := '0';
	 SIGNAL	 nl11lO13	:	STD_LOGIC := '0';
	 SIGNAL	 nl11lO14	:	STD_LOGIC := '0';
	 SIGNAL	 nl11Ol11	:	STD_LOGIC := '0';
	 SIGNAL	 nl11Ol12	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl11Ol12_w_lg_w_lg_q130w131w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl11Ol12_w_lg_q130w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n11iO	:	STD_LOGIC := '0';
	 SIGNAL	n11li	:	STD_LOGIC := '0';
	 SIGNAL	n11ll	:	STD_LOGIC := '0';
	 SIGNAL	n11lO	:	STD_LOGIC := '0';
	 SIGNAL	n11Ol	:	STD_LOGIC := '0';
	 SIGNAL	wire_n11Oi_PRN	:	STD_LOGIC;
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w337w339w371w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w337w359w379w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w351w352w375w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w351w365w383w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO347w348w373w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO347w362w381w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO355w356w377w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO355w368w385w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w339w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w359w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w352w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w365w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO347w348w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO347w362w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO355w356w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO355w368w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO202w337w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO202w351w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11iO347w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11iO355w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11iO202w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11li336w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11ll338w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11lO340w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11Ol342w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0ii	:	STD_LOGIC := '0';
	 SIGNAL	nl0il	:	STD_LOGIC := '0';
	 SIGNAL	nl0iO	:	STD_LOGIC := '0';
	 SIGNAL	nl0li	:	STD_LOGIC := '0';
	 SIGNAL	nl0lO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0ll_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nl0ll_w_lg_nl0ii292w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_lg_nl0il291w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_lg_nl0iO293w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_lg_nl0li295w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ll_w_lg_nl0lO297w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0Oii	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oil	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oli	:	STD_LOGIC := '0';
	 SIGNAL	wire_nl0OiO_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nl0OiO_w_lg_w_lg_nl0Oii889w890w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0OiO_w_lg_nl0Oii889w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0OiO_w_lg_nl0Oii959w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0OiO_w_lg_nl0Oil961w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0OiO_w_lg_nl0Oli963w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0Ol	:	STD_LOGIC := '0';
	 SIGNAL	nli1i	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0OO_w_lg_nli1i204w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0OO_w_lg_nli1i203w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0OO_w_lg_nl0Ol205w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0iOO	:	STD_LOGIC := '0';
	 SIGNAL	nl0l0i	:	STD_LOGIC := '0';
	 SIGNAL	nl0l0l	:	STD_LOGIC := '0';
	 SIGNAL	nl0l0O	:	STD_LOGIC := '0';
	 SIGNAL	nl0l1i	:	STD_LOGIC := '0';
	 SIGNAL	nl0l1l	:	STD_LOGIC := '0';
	 SIGNAL	nl0l1O	:	STD_LOGIC := '0';
	 SIGNAL	nl0lii	:	STD_LOGIC := '0';
	 SIGNAL	nl0lil	:	STD_LOGIC := '0';
	 SIGNAL	nl0liO	:	STD_LOGIC := '0';
	 SIGNAL	nl0lli	:	STD_LOGIC := '0';
	 SIGNAL	nl0lll	:	STD_LOGIC := '0';
	 SIGNAL	nl0llO	:	STD_LOGIC := '0';
	 SIGNAL	nl0lOi	:	STD_LOGIC := '0';
	 SIGNAL	nl0lOl	:	STD_LOGIC := '0';
	 SIGNAL	nli10i	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli11O_PRN	:	STD_LOGIC;
	 SIGNAL	n100i	:	STD_LOGIC := '0';
	 SIGNAL	n100l	:	STD_LOGIC := '0';
	 SIGNAL	n100O	:	STD_LOGIC := '0';
	 SIGNAL	n101i	:	STD_LOGIC := '0';
	 SIGNAL	n101l	:	STD_LOGIC := '0';
	 SIGNAL	n101O	:	STD_LOGIC := '0';
	 SIGNAL	n10ii	:	STD_LOGIC := '0';
	 SIGNAL	n10il	:	STD_LOGIC := '0';
	 SIGNAL	n10iO	:	STD_LOGIC := '0';
	 SIGNAL	n10li	:	STD_LOGIC := '0';
	 SIGNAL	n10ll	:	STD_LOGIC := '0';
	 SIGNAL	n10lO	:	STD_LOGIC := '0';
	 SIGNAL	n10Oi	:	STD_LOGIC := '0';
	 SIGNAL	n10Ol	:	STD_LOGIC := '0';
	 SIGNAL	n10OO	:	STD_LOGIC := '0';
	 SIGNAL	n11il	:	STD_LOGIC := '0';
	 SIGNAL	n11OO	:	STD_LOGIC := '0';
	 SIGNAL	n1i1i	:	STD_LOGIC := '0';
	 SIGNAL	n1i1l	:	STD_LOGIC := '0';
	 SIGNAL	niili	:	STD_LOGIC := '0';
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
	 SIGNAL	nl0O0i	:	STD_LOGIC := '0';
	 SIGNAL	nl0O0l	:	STD_LOGIC := '0';
	 SIGNAL	nl0O0O	:	STD_LOGIC := '0';
	 SIGNAL	nl0O1O	:	STD_LOGIC := '0';
	 SIGNAL	nl1i0i	:	STD_LOGIC := '0';
	 SIGNAL	nl1i0l	:	STD_LOGIC := '0';
	 SIGNAL	nl1i0O	:	STD_LOGIC := '0';
	 SIGNAL	nl1i1O	:	STD_LOGIC := '0';
	 SIGNAL	nl1iii	:	STD_LOGIC := '0';
	 SIGNAL	nl1iil	:	STD_LOGIC := '0';
	 SIGNAL	nl1O1i	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oil	:	STD_LOGIC := '0';
	 SIGNAL	nl1OiO	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oli	:	STD_LOGIC := '0';
	 SIGNAL	nl1Oll	:	STD_LOGIC := '0';
	 SIGNAL	nl1OlO	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOi	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOl	:	STD_LOGIC := '0';
	 SIGNAL	nl1OOO	:	STD_LOGIC := '0';
	 SIGNAL	nli01i	:	STD_LOGIC := '0';
	 SIGNAL	nli01l	:	STD_LOGIC := '0';
	 SIGNAL	nli01O	:	STD_LOGIC := '0';
	 SIGNAL	nli0i	:	STD_LOGIC := '0';
	 SIGNAL	nli1l	:	STD_LOGIC := '0';
	 SIGNAL	nlil0i	:	STD_LOGIC := '0';
	 SIGNAL	nlil0l	:	STD_LOGIC := '0';
	 SIGNAL	nlil0O	:	STD_LOGIC := '0';
	 SIGNAL	nlil1O	:	STD_LOGIC := '0';
	 SIGNAL	nlilii	:	STD_LOGIC := '0';
	 SIGNAL	nlilil	:	STD_LOGIC := '0';
	 SIGNAL	nlilOl	:	STD_LOGIC := '0';
	 SIGNAL	nlilOO	:	STD_LOGIC := '0';
	 SIGNAL	nliOil	:	STD_LOGIC := '0';
	 SIGNAL	nliOli	:	STD_LOGIC := '0';
	 SIGNAL	nliOll	:	STD_LOGIC := '0';
	 SIGNAL	nliOlO	:	STD_LOGIC := '0';
	 SIGNAL	nliOOi	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli1O_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_nli1O_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nli1O_w_lg_nli0i133w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_n1i1l581w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl0O0i891w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl0O0l892w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl0O0O894w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl0O1O965w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl1i0i1073w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl1i0l1071w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl1i0O1069w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl1i1O1075w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl1iii1067w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl1O1i1066w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nl1Oli1034w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nli01O1w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nlil0l570w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nlilii216w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nlilOO215w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nliOlO653w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_w_lg_nlilil128w132w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nli1l134w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1O_w_lg_nlilil128w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nliO0i	:	STD_LOGIC := '0';
	 SIGNAL	nliO0l	:	STD_LOGIC := '0';
	 SIGNAL	nliO1i	:	STD_LOGIC := '0';
	 SIGNAL	nliO1l	:	STD_LOGIC := '0';
	 SIGNAL	nliO1O	:	STD_LOGIC := '0';
	 SIGNAL	nliOii	:	STD_LOGIC := '0';
	 SIGNAL	wire_nliO0O_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_nliO0O_w_lg_w_lg_nliO1i796w797w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliO0O_w_lg_nliO1i796w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliO0O_w_lg_nliOii798w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0OOO	:	STD_LOGIC := '0';
	 SIGNAL	nii0O	:	STD_LOGIC := '0';
	 SIGNAL	niiii	:	STD_LOGIC := '0';
	 SIGNAL	niiil	:	STD_LOGIC := '0';
	 SIGNAL	niiiO	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oi	:	STD_LOGIC := '0';
	 SIGNAL	nl0Oll	:	STD_LOGIC := '0';
	 SIGNAL	nli0l	:	STD_LOGIC := '0';
	 SIGNAL	nli0O	:	STD_LOGIC := '0';
	 SIGNAL	nliii	:	STD_LOGIC := '0';
	 SIGNAL	nliil	:	STD_LOGIC := '0';
	 SIGNAL	nliiO	:	STD_LOGIC := '0';
	 SIGNAL	nlili	:	STD_LOGIC := '0';
	 SIGNAL	nliliO	:	STD_LOGIC := '0';
	 SIGNAL	nlill	:	STD_LOGIC := '0';
	 SIGNAL	nlilli	:	STD_LOGIC := '0';
	 SIGNAL	nlilll	:	STD_LOGIC := '0';
	 SIGNAL	nlillO	:	STD_LOGIC := '0';
	 SIGNAL	nlilO	:	STD_LOGIC := '0';
	 SIGNAL	nlilOi	:	STD_LOGIC := '0';
	 SIGNAL	nliOi	:	STD_LOGIC := '0';
	 SIGNAL	nliOiO	:	STD_LOGIC := '0';
	 SIGNAL	nliOO	:	STD_LOGIC := '0';
	 SIGNAL	nliOOl	:	STD_LOGIC := '0';
	 SIGNAL	wire_nliOl_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nliOl_w_lg_nl0Oi141w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOl_w_lg_nl0Oll540w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOl_w_lg_nliOiO579w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOl_w_lg_w_lg_nliOOl754w755w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOl_w_lg_w_lg_nliOOl754w775w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOl_w_lg_w_lg_nliOOl754w784w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOl_w_lg_nliOOl754w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0lOO	:	STD_LOGIC := '0';
	 SIGNAL	nl0O1i	:	STD_LOGIC := '0';
	 SIGNAL	nl0O1l	:	STD_LOGIC := '0';
	 SIGNAL	nll11i	:	STD_LOGIC := '0';
	 SIGNAL	wire_nliOOO_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_nliOOO_w_lg_nll11i549w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iiO_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_vcc	:	STD_LOGIC;
	 SIGNAL  wire_n1iiO_eq	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	 SIGNAL  wire_n1ili_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1ili_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ili_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ill_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1ill_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ill_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ilO_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1ilO_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ilO_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iOi_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1iOi_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iOi_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iOl_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1iOl_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iOl_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iOO_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1iOO_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iOO_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l0i_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1l0i_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l0i_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l0l_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1l0l_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l0l_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l0O_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1l0O_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l0O_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l1i_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1l1i_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l1i_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l1l_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1l1l_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l1l_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l1O_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1l1O_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1l1O_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lii_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1lii_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lii_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lil_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1lil_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lil_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1liO_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1liO_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1liO_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lli_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1lli_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lli_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lll_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1lll_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lll_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1llO_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1llO_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1llO_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lOi_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1lOi_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lOi_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lOl_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1lOl_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lOl_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lOO_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1lOO_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lOO_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O0i_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1O0i_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O0i_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O0l_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1O0l_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O0l_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O0O_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1O0O_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O0O_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O1i_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1O1i_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O1i_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O1l_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1O1l_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O1l_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O1O_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1O1O_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1O1O_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oii_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1Oii_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oii_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oil_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1Oil_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oil_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1OiO_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1OiO_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1OiO_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oli_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1Oli_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oli_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0Oll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n11ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl01i_w_lg_dataout330w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl01l_w_lg_dataout328w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl0i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1l1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1liO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl1liO_w_lg_dataout864w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1liO_w_lg_dataout866w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl1lll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1llO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Oi_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl1Oi_w_lg_dataout329w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl1Ol_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl1Ol_w_lg_dataout334w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl1OO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl1OO_w_lg_dataout332w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nli00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll11l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nll11l_w_lg_dataout857w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOl_dataout	:	STD_LOGIC;
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
	 SIGNAL	wire_nlOi0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlil_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlOlil_w_lg_dataout544w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlOliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n1iii_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1iii_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1iii_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n1iil_w_lg_w_o_range495w496w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iil_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1iil_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1iil_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1iil_w_o_range495w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl01lO_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl01lO_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl01lO_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl01O_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl01O_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl01O_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl0ill_w_lg_w_lg_w_o_range858w860w863w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ill_w_lg_w_o_range858w860w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ill_w_lg_w_o_range861w862w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ill_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl0ill_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl0ill_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nl0ill_w_o_range858w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ill_w_o_range859w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0ill_w_o_range861w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1l0O_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl1l0O_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl1l0O_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl1ll_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl1ll_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl1ll_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nli10O_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nli10O_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nli10O_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nli1iO_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nli1iO_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nli1iO_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOi0l_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlOi0l_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlOi0l_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl1lli_i	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1lli_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nll00i_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll00i_o	:	STD_LOGIC;
	 SIGNAL  wire_nll00i_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll00l_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll00l_o	:	STD_LOGIC;
	 SIGNAL  wire_nll00l_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll00O_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll00O_o	:	STD_LOGIC;
	 SIGNAL  wire_nll00O_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll01i_w_lg_o790w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll01i_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll01i_o	:	STD_LOGIC;
	 SIGNAL  wire_nll01i_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll01l_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll01l_o	:	STD_LOGIC;
	 SIGNAL  wire_nll01l_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll01O_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll01O_o	:	STD_LOGIC;
	 SIGNAL  wire_nll01O_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll0ii_data	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nll0ii_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0ii_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nll0il_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll0il_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0il_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nll0iO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0iO_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0iO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0li_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0li_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0li_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0ll_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0ll_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0ll_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0lO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0lO_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0lO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0Oi_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll0Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_nll0Oi_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll10i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll10i_o	:	STD_LOGIC;
	 SIGNAL  wire_nll10i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1ii_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1ii_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1ii_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1iO_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll1iO_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1iO_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nll1ll_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1ll_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1ll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1Oi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1Oi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1Ol_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nll1Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_nll1Ol_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nl100O173w174w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nilOii1036w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_niO1li650w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_niO1Ol531w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl100O173w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset402w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_tx_clk_in105w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  nilO0O :	STD_LOGIC;
	 SIGNAL  nilOii :	STD_LOGIC;
	 SIGNAL  nilOil :	STD_LOGIC;
	 SIGNAL  nilOiO :	STD_LOGIC;
	 SIGNAL  nilOli :	STD_LOGIC;
	 SIGNAL  nilOlO :	STD_LOGIC;
	 SIGNAL  nilOOl :	STD_LOGIC;
	 SIGNAL  niO10i :	STD_LOGIC;
	 SIGNAL  niO10l :	STD_LOGIC;
	 SIGNAL  niO10O :	STD_LOGIC;
	 SIGNAL  niO11l :	STD_LOGIC;
	 SIGNAL  niO11O :	STD_LOGIC;
	 SIGNAL  niO1ii :	STD_LOGIC;
	 SIGNAL  niO1il :	STD_LOGIC;
	 SIGNAL  niO1iO :	STD_LOGIC;
	 SIGNAL  niO1li :	STD_LOGIC;
	 SIGNAL  niO1ll :	STD_LOGIC;
	 SIGNAL  niO1lO :	STD_LOGIC;
	 SIGNAL  niO1Ol :	STD_LOGIC;
	 SIGNAL  niOi0l :	STD_LOGIC;
	 SIGNAL  niOiOl :	STD_LOGIC;
	 SIGNAL  niOiOO :	STD_LOGIC;
	 SIGNAL  niOl0i :	STD_LOGIC;
	 SIGNAL  niOl0l :	STD_LOGIC;
	 SIGNAL  niOl0O :	STD_LOGIC;
	 SIGNAL  niOl1i :	STD_LOGIC;
	 SIGNAL  niOl1l :	STD_LOGIC;
	 SIGNAL  niOl1O :	STD_LOGIC;
	 SIGNAL  niOlii :	STD_LOGIC;
	 SIGNAL  niOlil :	STD_LOGIC;
	 SIGNAL  niOliO :	STD_LOGIC;
	 SIGNAL  niOlli :	STD_LOGIC;
	 SIGNAL  niOlll :	STD_LOGIC;
	 SIGNAL  niOllO :	STD_LOGIC;
	 SIGNAL  niOlOi :	STD_LOGIC;
	 SIGNAL  niOlOl :	STD_LOGIC;
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
	 SIGNAL  niOOOO :	STD_LOGIC;
	 SIGNAL  nl100O :	STD_LOGIC;
	 SIGNAL  nl101O :	STD_LOGIC;
	 SIGNAL  nl110l :	STD_LOGIC;
	 SIGNAL  nl110O :	STD_LOGIC;
	 SIGNAL  nl111l :	STD_LOGIC;
	 SIGNAL  nl11ii :	STD_LOGIC;
	 SIGNAL  nl11il :	STD_LOGIC;
 BEGIN

	wire_gnd <= '0';
	wire_vcc <= '1';
	wire_w_lg_w_lg_nl100O173w174w(0) <= wire_w_lg_nl100O173w(0) AND nl110l;
	wire_w_lg_nilOii1036w(0) <= NOT nilOii;
	wire_w_lg_niO1li650w(0) <= NOT niO1li;
	wire_w_lg_niO1Ol531w(0) <= NOT niO1Ol;
	wire_w_lg_nl100O173w(0) <= NOT nl100O;
	wire_w_lg_reset402w(0) <= NOT reset;
	wire_w_lg_tx_clk_in105w(0) <= NOT tx_clk_in;
	atm_tx_enb <= wire_nli1O_w_lg_nli01O1w(0);
	atm_tx_port_stat <= ( wire_n1Oli_q(0) & wire_n1OiO_q(0) & wire_n1Oil_q(0) & wire_n1Oii_q(0) & wire_n1O0O_q(0) & wire_n1O0l_q(0) & wire_n1O0i_q(0) & wire_n1O1O_q(0) & wire_n1O1l_q(0) & wire_n1O1i_q(0) & wire_n1lOO_q(0) & wire_n1lOl_q(0) & wire_n1lOi_q(0) & wire_n1llO_q(0) & wire_n1lll_q(0) & wire_n1lli_q(0) & wire_n1liO_q(0) & wire_n1lil_q(0) & wire_n1lii_q(0) & wire_n1l0O_q(0) & wire_n1l0l_q(0) & wire_n1l0i_q(0) & wire_n1l1O_q(0) & wire_n1l1l_q(0) & wire_n1l1i_q(0) & wire_n1iOO_q(0) & wire_n1iOl_q(0) & wire_n1iOi_q(0) & wire_n1ilO_q(0) & wire_n1ill_q(0) & wire_n1ili_q(0));
	atm_tx_port_wait <= n11il;
	nilO0O <= (((((wire_nli1O_w_lg_nl1O1i1066w(0) AND (NOT (nl1i1O XOR wire_nl01lO_o(0)))) AND (NOT (nl1i0i XOR wire_nl01lO_o(1)))) AND (NOT (nl1i0l XOR (NOT wire_nl01lO_o(2))))) AND (NOT (nl1i0O XOR (NOT wire_nl01lO_o(2))))) AND (NOT (nl1iii XOR wire_nl01lO_o(2))));
	nilOii <= (wire_nli1O_w_lg_nl1Oli1034w(0) AND nilOil);
	nilOil <= (((((wire_nli1O_w_lg_nl1O1i1066w(0) AND wire_nli1O_w_lg_nl1iii1067w(0)) AND wire_nli1O_w_lg_nl1i0O1069w(0)) AND wire_nli1O_w_lg_nl1i0l1071w(0)) AND wire_nli1O_w_lg_nl1i0i1073w(0)) AND wire_nli1O_w_lg_nl1i1O1075w(0));
	nilOiO <= (nilOli AND nl1Oli);
	nilOli <= (nl1OiO AND nl1Oil);
	nilOlO <= ((((NOT (nl0Oii XOR wire_nli10O_o(0))) AND (NOT (nl0Oil XOR wire_nli10O_o(1)))) AND (NOT (nl0Oli XOR wire_nli10O_o(2)))) AND (NOT wire_nli10O_o(3)));
	nilOOl <= (wire_nliOl_w_lg_nl0Oll540w(0) AND wire_nll11l_dataout);
	niO10i <= (nli0i AND nll11i);
	niO10l <= (wire_nli1O_w_lg_nlilOO215w(0) AND nll11i);
	niO10O <= (((((wire_nliO0O_w_lg_nliO1i796w(0) AND (NOT (nliO1l XOR wire_n1iil_o(0)))) AND (NOT (nliO1O XOR wire_n1iil_o(1)))) AND (NOT (nliO0i XOR wire_n1iil_w_lg_w_o_range495w496w(0)))) AND (NOT (wire_n1iil_w_lg_w_o_range495w496w(0) XOR nliO0l))) AND (NOT (wire_n1iil_o(2) XOR nliOii)));
	niO11l <= ((nliOOl OR nliOll) OR nliOli);
	niO11O <= (nliOll OR nliOli);
	niO1ii <= ((((((NOT (nliO1i XOR wire_n1iii_o(1))) AND (NOT (nliO1l XOR wire_n1iii_o(2)))) AND (NOT (nliO1O XOR wire_n1iii_o(3)))) AND (NOT (nliO0i XOR wire_n1iii_o(4)))) AND (NOT (nliO0l XOR wire_n1iii_o(5)))) AND (NOT (nliOii XOR wire_n1iii_o(6))));
	niO1il <= (nliOiO AND (NOT (niili AND nll11i)));
	niO1iO <= ((((wire_nliO0O_w_lg_w_lg_nliO1i796w797w(0) AND wire_nliO0O_w_lg_nliOii798w(0)) AND (NOT (nliO1l XOR wire_n1iil_o(0)))) AND (NOT (nliO1O XOR wire_n1iil_o(1)))) AND (NOT (nliO0i XOR wire_n1iil_o(2))));
	niO1li <= (nli0i AND nll11i);
	niO1ll <= (n11il AND wire_nliOl_w_lg_nl0Oll540w(0));
	niO1lO <= (((((NOT (nliliO XOR n11iO)) AND (NOT (nlilli XOR n11li))) AND (NOT (nlilll XOR n11ll))) AND (NOT (nlillO XOR n11lO))) AND (NOT (nlilOi XOR n11Ol)));
	niO1Ol <= (((((((((((((((wire_nl00li_dataout XOR wire_nl00ll_dataout) XOR wire_nl00lO_dataout) XOR wire_nl00Oi_dataout) XOR wire_nl00Ol_dataout) XOR wire_nl00OO_dataout) XOR wire_nl0i1i_dataout) XOR wire_nl0i1l_dataout) XOR wire_nl0i1O_dataout) XOR wire_nl0i0i_dataout) XOR wire_nl0i0l_dataout) XOR wire_nl0i0O_dataout) XOR wire_nl0iii_dataout) XOR wire_nl0iil_dataout) XOR wire_nl0iiO_dataout) XOR wire_nl0ili_dataout);
	niOi0l <= ((wire_nliOl_w_lg_nl0Oi141w(0) AND (NOT ((wire_nli1O_w_lg_nlilOO215w(0) AND wire_nli1O_w_lg_nlilii216w(0)) AND (niOiil28 XOR niOiil27)))) AND (niOi0O30 XOR niOi0O29));
	niOiOl <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w351w365w383w(0) AND n11Ol);
	niOiOO <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO347w362w381w(0) AND n11Ol);
	niOl0i <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO347w348w373w(0) AND n11Ol);
	niOl0l <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w337w339w371w(0) AND n11Ol);
	niOl0O <= ((wire_n11Oi_w_lg_w_lg_n11iO355w368w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND n11Ol);
	niOl1i <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w337w359w379w(0) AND n11Ol);
	niOl1l <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO355w356w377w(0) AND n11Ol);
	niOl1O <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w351w352w375w(0) AND n11Ol);
	niOlii <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w365w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND n11Ol);
	niOlil <= ((wire_n11Oi_w_lg_w_lg_n11iO347w362w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND n11Ol);
	niOliO <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w359w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND n11Ol);
	niOlli <= ((wire_n11Oi_w_lg_w_lg_n11iO355w356w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND n11Ol);
	niOlll <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w352w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND n11Ol);
	niOllO <= ((wire_n11Oi_w_lg_w_lg_n11iO347w348w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND n11Ol);
	niOlOi <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w339w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND n11Ol);
	niOlOl <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO355w368w385w(0) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOlOO <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w351w365w383w(0) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOO0i <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w351w352w375w(0) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOO0l <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO347w348w373w(0) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOO0O <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w337w339w371w(0) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOO1i <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO347w362w381w(0) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOO1l <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w337w359w379w(0) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOO1O <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO355w356w377w(0) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOOii <= ((wire_n11Oi_w_lg_w_lg_n11iO355w368w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOOil <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w365w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOOiO <= ((wire_n11Oi_w_lg_w_lg_n11iO347w362w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOOli <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w359w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOOll <= ((wire_n11Oi_w_lg_w_lg_n11iO355w356w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOOlO <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w352w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOOOi <= ((wire_n11Oi_w_lg_w_lg_n11iO347w348w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND wire_n11Oi_w_lg_n11Ol342w(0));
	niOOOl <= (((wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w339w(0) AND wire_n11Oi_w_lg_n11lO340w(0)) AND wire_n11Oi_w_lg_n11Ol342w(0)) AND (niO1OO50 XOR niO1OO49));
	niOOOO <= (((wire_nl1Oi_w_lg_dataout329w(0) AND wire_nl01i_w_lg_dataout330w(0)) AND wire_nl1OO_w_lg_dataout332w(0)) AND wire_nl1Ol_w_lg_dataout334w(0));
	nl100O <= ((nlilil OR nlil0i) OR (NOT (nl10ii2 XOR nl10ii1)));
	nl101O <= '1';
	nl110l <= ((((((NOT (nliliO XOR wire_nl1Oi_dataout)) AND (NOT ((nlilli XOR wire_nl1Ol_dataout) XOR (NOT (niO0il42 XOR niO0il41))))) AND (NOT ((nlilll XOR wire_nl1OO_dataout) XOR (NOT (niO00O44 XOR niO00O43))))) AND (NOT ((nlillO XOR wire_nl01i_dataout) XOR (NOT (niO00i46 XOR niO00i45))))) AND (NOT (nlilOi XOR wire_nl01l_dataout))) AND (niO01l48 XOR niO01l47));
	nl110O <= (((wire_nl0ll_w_lg_nl0ii292w(0) AND wire_nl0ll_w_lg_nl0iO293w(0)) AND wire_nl0ll_w_lg_nl0li295w(0)) AND wire_nl0ll_w_lg_nl0lO297w(0));
	nl111l <= (wire_w_lg_w_lg_nl100O173w174w(0) AND (nl111O20 XOR nl111O19));
	nl11ii <= ((NOT ((nl100O OR nlilOO) OR (NOT (nl11iO18 XOR nl11iO17)))) OR (nlilOO AND nl11il));
	nl11il <= (((((NOT ((nl0ii XOR n11iO) XOR (NOT (niOi1O32 XOR niOi1O31)))) AND (NOT ((nl0il XOR n11li) XOR (NOT (niOi1i34 XOR niOi1i33))))) AND (NOT ((nl0iO XOR n11ll) XOR (NOT (niO0Ol36 XOR niO0Ol35))))) AND (NOT ((nl0li XOR n11lO) XOR (NOT (niO0lO38 XOR niO0lO37))))) AND (NOT ((nl0lO XOR n11Ol) XOR (NOT (niO0li40 XOR niO0li39)))));
	tx_addr <= ( nliOO & nliOi & nlilO & nlill & nlili);
	tx_data <= ( n1i1i & n10OO & n10Ol & n10Oi & n10lO & n10ll & n10li & n10iO & n10il & n10ii & n100O & n100l & n100i & n101O & n101l & n101i);
	tx_enb <= nliOiO;
	tx_prty <= n11OO;
	tx_soc <= nliOil;
	wire_nl01Ol_address_a <= ( nl0O0O & nl0O0l & nl0O0i);
	wire_nl01Ol_address_b <= ( wire_nl0iOl_dataout & wire_nl0iOi_dataout & wire_nl0ilO_dataout);
	wire_nl01Ol_data_a <= ( nl01ll & nl01li & nl01iO & nl01il & nl01ii & nl010O & nl010l & nl010i & nl011O & nl011l & nl011i & nl1OOO & nl1OOl & nl1OOi & nl1OlO & nl1Oll);
	nl01Ol :  altsyncram
	  GENERIC MAP (
		ADDRESS_ACLR_A => "NONE",
		ADDRESS_ACLR_B => "NONE",
		ADDRESS_REG_B => "CLOCK0",
		BYTE_SIZE => 8,
		BYTEENA_ACLR_A => "NONE",
		BYTEENA_ACLR_B => "NONE",
		BYTEENA_REG_B => "CLOCK1",
		CLOCK_ENABLE_CORE_A => "USE_INPUT_CLKEN",
		CLOCK_ENABLE_CORE_B => "USE_INPUT_CLKEN",
		CLOCK_ENABLE_INPUT_A => "NORMAL",
		CLOCK_ENABLE_INPUT_B => "NORMAL",
		CLOCK_ENABLE_OUTPUT_A => "NORMAL",
		CLOCK_ENABLE_OUTPUT_B => "NORMAL",
		ENABLE_ECC => "FALSE",
		INDATA_ACLR_A => "NONE",
		INDATA_ACLR_B => "NONE",
		INDATA_REG_B => "CLOCK1",
		INIT_FILE_LAYOUT => "PORT_A",
		INTENDED_DEVICE_FAMILY => "Stratix II",
		NUMWORDS_A => 8,
		NUMWORDS_B => 8,
		OPERATION_MODE => "DUAL_PORT",
		OUTDATA_ACLR_A => "NONE",
		OUTDATA_ACLR_B => "NONE",
		OUTDATA_REG_A => "UNREGISTERED",
		OUTDATA_REG_B => "UNREGISTERED",
		RAM_BLOCK_TYPE => "AUTO",
		RDCONTROL_ACLR_B => "NONE",
		RDCONTROL_REG_B => "CLOCK1",
		READ_DURING_WRITE_MODE_MIXED_PORTS => "OLD_DATA",
		READ_DURING_WRITE_MODE_PORT_A => "NEW_DATA_NO_NBE_READ",
		READ_DURING_WRITE_MODE_PORT_B => "NEW_DATA_NO_NBE_READ",
		WIDTH_A => 16,
		WIDTH_B => 16,
		WIDTH_BYTEENA_A => 1,
		WIDTH_BYTEENA_B => 1,
		WIDTHAD_A => 3,
		WIDTHAD_B => 3,
		WRCONTROL_ACLR_A => "NONE",
		WRCONTROL_ACLR_B => "NONE",
		WRCONTROL_WRADDRESS_REG_B => "CLOCK1",
		lpm_hint => "WIDTH_BYTEENA=1"
	  )
	  PORT MAP ( 
		address_a => wire_nl01Ol_address_a,
		address_b => wire_nl01Ol_address_b,
		clock0 => tx_clk_in,
		data_a => wire_nl01Ol_data_a,
		q_b => wire_nl01Ol_q_b,
		wren_a => wire_nl1liO_dataout
	  );
	wire_nlO0O_address_a <= ( "0" & "1" & "0" & "1" & "0");
	wire_nlO0O_address_b <= ( wire_nilli_dataout & wire_niliO_dataout & wire_nilil_dataout & wire_nilii_dataout & wire_nil0O_dataout);
	wire_nlO0O_clock1 <= wire_w_lg_tx_clk_in105w(0);
	wire_nlO0O_data_a <= ( "0" & "1" & "0" & "1" & "0");
	nlO0O :  altsyncram
	  GENERIC MAP (
		ADDRESS_ACLR_A => "NONE",
		ADDRESS_ACLR_B => "NONE",
		ADDRESS_REG_B => "CLOCK1",
		BYTE_SIZE => 8,
		BYTEENA_ACLR_A => "NONE",
		BYTEENA_ACLR_B => "NONE",
		BYTEENA_REG_B => "CLOCK1",
		CLOCK_ENABLE_CORE_A => "USE_INPUT_CLKEN",
		CLOCK_ENABLE_CORE_B => "USE_INPUT_CLKEN",
		CLOCK_ENABLE_INPUT_A => "NORMAL",
		CLOCK_ENABLE_INPUT_B => "NORMAL",
		CLOCK_ENABLE_OUTPUT_A => "NORMAL",
		CLOCK_ENABLE_OUTPUT_B => "NORMAL",
		ENABLE_ECC => "FALSE",
		INDATA_ACLR_A => "NONE",
		INDATA_ACLR_B => "NONE",
		INDATA_REG_B => "CLOCK1",
		INIT_FILE_LAYOUT => "PORT_A",
		INTENDED_DEVICE_FAMILY => "Stratix II",
		NUMWORDS_A => 32,
		NUMWORDS_B => 32,
		OPERATION_MODE => "DUAL_PORT",
		OUTDATA_ACLR_A => "NONE",
		OUTDATA_ACLR_B => "NONE",
		OUTDATA_REG_A => "UNREGISTERED",
		OUTDATA_REG_B => "UNREGISTERED",
		RAM_BLOCK_TYPE => "AUTO",
		RDCONTROL_ACLR_B => "NONE",
		RDCONTROL_REG_B => "CLOCK1",
		READ_DURING_WRITE_MODE_MIXED_PORTS => "DONT_CARE",
		READ_DURING_WRITE_MODE_PORT_A => "NEW_DATA_NO_NBE_READ",
		READ_DURING_WRITE_MODE_PORT_B => "NEW_DATA_NO_NBE_READ",
		WIDTH_A => 5,
		WIDTH_B => 5,
		WIDTH_BYTEENA_A => 1,
		WIDTH_BYTEENA_B => 1,
		WIDTHAD_A => 5,
		WIDTHAD_B => 5,
		WRCONTROL_ACLR_A => "NONE",
		WRCONTROL_ACLR_B => "NONE",
		WRCONTROL_WRADDRESS_REG_B => "CLOCK1",
		lpm_hint => "WIDTH_BYTEENA=1"
	  )
	  PORT MAP ( 
		address_a => wire_nlO0O_address_a,
		address_b => wire_nlO0O_address_b,
		clock0 => tx_clk_in,
		clock1 => wire_nlO0O_clock1,
		data_a => wire_nlO0O_data_a,
		wren_a => wire_gnd
	  );
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nilOll59 <= nilOll60;
		END IF;
		if (now = 0 ns) then
			nilOll59 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nilOll60 <= nilOll59;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nilOOi57 <= nilOOi58;
		END IF;
		if (now = 0 ns) then
			nilOOi57 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nilOOi58 <= nilOOi57;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nilOOO55 <= nilOOO56;
		END IF;
		if (now = 0 ns) then
			nilOOO55 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nilOOO56 <= nilOOO55;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO00i45 <= niO00i46;
		END IF;
		if (now = 0 ns) then
			niO00i45 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO00i46 <= niO00i45;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO00O43 <= niO00O44;
		END IF;
		if (now = 0 ns) then
			niO00O43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO00O44 <= niO00O43;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO01l47 <= niO01l48;
		END IF;
		if (now = 0 ns) then
			niO01l47 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO01l48 <= niO01l47;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO0il41 <= niO0il42;
		END IF;
		if (now = 0 ns) then
			niO0il41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO0il42 <= niO0il41;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO0li39 <= niO0li40;
		END IF;
		if (now = 0 ns) then
			niO0li39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO0li40 <= niO0li39;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO0lO37 <= niO0lO38;
		END IF;
		if (now = 0 ns) then
			niO0lO37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO0lO38 <= niO0lO37;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO0Ol35 <= niO0Ol36;
		END IF;
		if (now = 0 ns) then
			niO0Ol35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO0Ol36 <= niO0Ol35;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO11i53 <= niO11i54;
		END IF;
		if (now = 0 ns) then
			niO11i53 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO11i54 <= niO11i53;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO1Oi51 <= niO1Oi52;
		END IF;
		if (now = 0 ns) then
			niO1Oi51 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO1Oi52 <= niO1Oi51;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO1OO49 <= niO1OO50;
		END IF;
		if (now = 0 ns) then
			niO1OO49 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niO1OO50 <= niO1OO49;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOi0O29 <= niOi0O30;
		END IF;
		if (now = 0 ns) then
			niOi0O29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOi0O30 <= niOi0O29;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOi1i33 <= niOi1i34;
		END IF;
		if (now = 0 ns) then
			niOi1i33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOi1i34 <= niOi1i33;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOi1O31 <= niOi1O32;
		END IF;
		if (now = 0 ns) then
			niOi1O31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOi1O32 <= niOi1O31;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOiil27 <= niOiil28;
		END IF;
		if (now = 0 ns) then
			niOiil27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOiil28 <= niOiil27;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOili25 <= niOili26;
		END IF;
		if (now = 0 ns) then
			niOili25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOili26 <= niOili25;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOilO23 <= niOilO24;
		END IF;
		if (now = 0 ns) then
			niOilO23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN niOilO24 <= niOilO23;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl100i5 <= nl100i6;
		END IF;
		if (now = 0 ns) then
			nl100i5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl100i6 <= nl100i5;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl100l3 <= nl100l4;
		END IF;
		if (now = 0 ns) then
			nl100l3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl100l4 <= nl100l3;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl101i10 <= nl101i9;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl101i9 <= nl101i10;
		END IF;
		if (now = 0 ns) then
			nl101i9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl101l7 <= nl101l8;
		END IF;
		if (now = 0 ns) then
			nl101l7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl101l8 <= nl101l7;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl10ii1 <= nl10ii2;
		END IF;
		if (now = 0 ns) then
			nl10ii1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl10ii2 <= nl10ii1;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl111i21 <= nl111i22;
		END IF;
		if (now = 0 ns) then
			nl111i21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl111i22 <= nl111i21;
		END IF;
	END PROCESS;
	wire_nl111i22_w_lg_w_lg_q183w184w(0) <= wire_nl111i22_w_lg_q183w(0) AND wire_nl01l_dataout;
	wire_nl111i22_w_lg_q183w(0) <= nl111i22 XOR nl111i21;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl111O19 <= nl111O20;
		END IF;
		if (now = 0 ns) then
			nl111O19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl111O20 <= nl111O19;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl11iO17 <= nl11iO18;
		END IF;
		if (now = 0 ns) then
			nl11iO17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl11iO18 <= nl11iO17;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl11ll15 <= nl11ll16;
		END IF;
		if (now = 0 ns) then
			nl11ll15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl11ll16 <= nl11ll15;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl11lO13 <= nl11lO14;
		END IF;
		if (now = 0 ns) then
			nl11lO13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl11lO14 <= nl11lO13;
		END IF;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl11Ol11 <= nl11Ol12;
		END IF;
		if (now = 0 ns) then
			nl11Ol11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk_in)
	BEGIN
		IF (tx_clk_in = '1' AND tx_clk_in'event) THEN nl11Ol12 <= nl11Ol11;
		END IF;
	END PROCESS;
	wire_nl11Ol12_w_lg_w_lg_q130w131w(0) <= NOT wire_nl11Ol12_w_lg_q130w(0);
	wire_nl11Ol12_w_lg_q130w(0) <= nl11Ol12 XOR nl11Ol11;
	PROCESS (tx_clk_in, wire_n11Oi_PRN, reset)
	BEGIN
		IF (wire_n11Oi_PRN = '0') THEN
				n11iO <= '1';
				n11li <= '1';
				n11ll <= '1';
				n11lO <= '1';
				n11Ol <= '1';
		ELSIF (reset = '0') THEN
				n11iO <= '0';
				n11li <= '0';
				n11ll <= '0';
				n11lO <= '0';
				n11Ol <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
			IF (atm_tx_port_load = '1') THEN
				n11iO <= atm_tx_port(0);
				n11li <= atm_tx_port(1);
				n11ll <= atm_tx_port(2);
				n11lO <= atm_tx_port(3);
				n11Ol <= atm_tx_port(4);
			END IF;
		END IF;
	END PROCESS;
	wire_n11Oi_PRN <= (niO1Oi52 XOR niO1Oi51);
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w337w339w371w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w339w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w337w359w379w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w359w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w351w352w375w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w352w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO202w351w365w383w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w365w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO347w348w373w(0) <= wire_n11Oi_w_lg_w_lg_n11iO347w348w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO347w362w381w(0) <= wire_n11Oi_w_lg_w_lg_n11iO347w362w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO355w356w377w(0) <= wire_n11Oi_w_lg_w_lg_n11iO355w356w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO355w368w385w(0) <= wire_n11Oi_w_lg_w_lg_n11iO355w368w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w339w(0) <= wire_n11Oi_w_lg_w_lg_n11iO202w337w(0) AND wire_n11Oi_w_lg_n11ll338w(0);
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w337w359w(0) <= wire_n11Oi_w_lg_w_lg_n11iO202w337w(0) AND n11ll;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w352w(0) <= wire_n11Oi_w_lg_w_lg_n11iO202w351w(0) AND wire_n11Oi_w_lg_n11ll338w(0);
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO202w351w365w(0) <= wire_n11Oi_w_lg_w_lg_n11iO202w351w(0) AND n11ll;
	wire_n11Oi_w_lg_w_lg_n11iO347w348w(0) <= wire_n11Oi_w_lg_n11iO347w(0) AND wire_n11Oi_w_lg_n11ll338w(0);
	wire_n11Oi_w_lg_w_lg_n11iO347w362w(0) <= wire_n11Oi_w_lg_n11iO347w(0) AND n11ll;
	wire_n11Oi_w_lg_w_lg_n11iO355w356w(0) <= wire_n11Oi_w_lg_n11iO355w(0) AND wire_n11Oi_w_lg_n11ll338w(0);
	wire_n11Oi_w_lg_w_lg_n11iO355w368w(0) <= wire_n11Oi_w_lg_n11iO355w(0) AND n11ll;
	wire_n11Oi_w_lg_w_lg_n11iO202w337w(0) <= wire_n11Oi_w_lg_n11iO202w(0) AND wire_n11Oi_w_lg_n11li336w(0);
	wire_n11Oi_w_lg_w_lg_n11iO202w351w(0) <= wire_n11Oi_w_lg_n11iO202w(0) AND n11li;
	wire_n11Oi_w_lg_n11iO347w(0) <= n11iO AND wire_n11Oi_w_lg_n11li336w(0);
	wire_n11Oi_w_lg_n11iO355w(0) <= n11iO AND n11li;
	wire_n11Oi_w_lg_n11iO202w(0) <= NOT n11iO;
	wire_n11Oi_w_lg_n11li336w(0) <= NOT n11li;
	wire_n11Oi_w_lg_n11ll338w(0) <= NOT n11ll;
	wire_n11Oi_w_lg_n11lO340w(0) <= NOT n11lO;
	wire_n11Oi_w_lg_n11Ol342w(0) <= NOT n11Ol;
	PROCESS (tx_clk_in, wire_nl0ll_PRN, reset)
	BEGIN
		IF (wire_nl0ll_PRN = '0') THEN
				nl0ii <= '1';
				nl0il <= '1';
				nl0iO <= '1';
				nl0li <= '1';
				nl0lO <= '1';
		ELSIF (reset = '0') THEN
				nl0ii <= '0';
				nl0il <= '0';
				nl0iO <= '0';
				nl0li <= '0';
				nl0lO <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
			IF (nl0Oi = '0') THEN
				nl0ii <= wire_niO1i_dataout;
				nl0il <= wire_niO1l_dataout;
				nl0iO <= wire_niO1O_dataout;
				nl0li <= wire_niO0i_dataout;
				nl0lO <= wire_niO0l_dataout;
			END IF;
		END IF;
		if (now = 0 ns) then
			nl0ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0lO <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nl0ll_PRN <= (nl11ll16 XOR nl11ll15);
	wire_nl0ll_w_lg_nl0ii292w(0) <= nl0ii AND wire_nl0ll_w_lg_nl0il291w(0);
	wire_nl0ll_w_lg_nl0il291w(0) <= NOT nl0il;
	wire_nl0ll_w_lg_nl0iO293w(0) <= NOT nl0iO;
	wire_nl0ll_w_lg_nl0li295w(0) <= NOT nl0li;
	wire_nl0ll_w_lg_nl0lO297w(0) <= NOT nl0lO;
	PROCESS (tx_clk_in, wire_nl0OiO_PRN, reset)
	BEGIN
		IF (wire_nl0OiO_PRN = '0') THEN
				nl0Oii <= '1';
				nl0Oil <= '1';
				nl0Oli <= '1';
		ELSIF (reset = '0') THEN
				nl0Oii <= '0';
				nl0Oil <= '0';
				nl0Oli <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
			IF (nilOOl = '1') THEN
				nl0Oii <= wire_nli1iO_o(0);
				nl0Oil <= wire_nli1iO_o(1);
				nl0Oli <= wire_nli1iO_o(2);
			END IF;
		END IF;
		if (now = 0 ns) then
			nl0Oii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0Oil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0Oli <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nl0OiO_PRN <= (nilOll60 XOR nilOll59);
	wire_nl0OiO_w_lg_w_lg_nl0Oii889w890w(0) <= wire_nl0OiO_w_lg_nl0Oii889w(0) AND nl0Oli;
	wire_nl0OiO_w_lg_nl0Oii889w(0) <= nl0Oii AND nl0Oil;
	wire_nl0OiO_w_lg_nl0Oii959w(0) <= NOT nl0Oii;
	wire_nl0OiO_w_lg_nl0Oil961w(0) <= NOT nl0Oil;
	wire_nl0OiO_w_lg_nl0Oli963w(0) <= NOT nl0Oli;
	PROCESS (tx_clk_in, reset)
	BEGIN
		IF (reset = '0') THEN
				nl0Ol <= '0';
				nli1i <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
			IF (nl0Oi = '1') THEN
				nl0Ol <= (nlilii AND (nli0i OR nli1l));
				nli1i <= (wire_nli1O_w_lg_nli1l134w(0) OR (NOT (nl11lO14 XOR nl11lO13)));
			END IF;
		END IF;
		if (now = 0 ns) then
			nl0Ol <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli1i <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nl0OO_w_lg_nli1i204w(0) <= nli1i AND nlilii;
	wire_nl0OO_w_lg_nli1i203w(0) <= NOT nli1i;
	wire_nl0OO_w_lg_nl0Ol205w(0) <= nl0Ol OR wire_nl0OO_w_lg_nli1i204w(0);
	PROCESS (tx_clk_in, wire_nli11O_PRN, reset)
	BEGIN
		IF (wire_nli11O_PRN = '0') THEN
				nl0iOO <= '1';
				nl0l0i <= '1';
				nl0l0l <= '1';
				nl0l0O <= '1';
				nl0l1i <= '1';
				nl0l1l <= '1';
				nl0l1O <= '1';
				nl0lii <= '1';
				nl0lil <= '1';
				nl0liO <= '1';
				nl0lli <= '1';
				nl0lll <= '1';
				nl0llO <= '1';
				nl0lOi <= '1';
				nl0lOl <= '1';
				nli10i <= '1';
		ELSIF (reset = '0') THEN
				nl0iOO <= '0';
				nl0l0i <= '0';
				nl0l0l <= '0';
				nl0l0O <= '0';
				nl0l1i <= '0';
				nl0l1l <= '0';
				nl0l1O <= '0';
				nl0lii <= '0';
				nl0lil <= '0';
				nl0liO <= '0';
				nl0lli <= '0';
				nl0lll <= '0';
				nl0llO <= '0';
				nl0lOi <= '0';
				nl0lOl <= '0';
				nli10i <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
			IF (nl0O1O = '1') THEN
				nl0iOO <= wire_nl01Ol_q_b(1);
				nl0l0i <= wire_nl01Ol_q_b(5);
				nl0l0l <= wire_nl01Ol_q_b(6);
				nl0l0O <= wire_nl01Ol_q_b(7);
				nl0l1i <= wire_nl01Ol_q_b(2);
				nl0l1l <= wire_nl01Ol_q_b(3);
				nl0l1O <= wire_nl01Ol_q_b(4);
				nl0lii <= wire_nl01Ol_q_b(8);
				nl0lil <= wire_nl01Ol_q_b(9);
				nl0liO <= wire_nl01Ol_q_b(10);
				nl0lli <= wire_nl01Ol_q_b(11);
				nl0lll <= wire_nl01Ol_q_b(12);
				nl0llO <= wire_nl01Ol_q_b(13);
				nl0lOi <= wire_nl01Ol_q_b(14);
				nl0lOl <= wire_nl01Ol_q_b(15);
				nli10i <= wire_nl01Ol_q_b(0);
			END IF;
		END IF;
	END PROCESS;
	wire_nli11O_PRN <= (nilOOi58 XOR nilOOi57);
	PROCESS (tx_clk_in, wire_nli1O_PRN, wire_nli1O_CLRN)
	BEGIN
		IF (wire_nli1O_PRN = '0') THEN
				n100i <= '1';
				n100l <= '1';
				n100O <= '1';
				n101i <= '1';
				n101l <= '1';
				n101O <= '1';
				n10ii <= '1';
				n10il <= '1';
				n10iO <= '1';
				n10li <= '1';
				n10ll <= '1';
				n10lO <= '1';
				n10Oi <= '1';
				n10Ol <= '1';
				n10OO <= '1';
				n11il <= '1';
				n11OO <= '1';
				n1i1i <= '1';
				n1i1l <= '1';
				niili <= '1';
				nl010i <= '1';
				nl010l <= '1';
				nl010O <= '1';
				nl011i <= '1';
				nl011l <= '1';
				nl011O <= '1';
				nl01ii <= '1';
				nl01il <= '1';
				nl01iO <= '1';
				nl01li <= '1';
				nl01ll <= '1';
				nl0O0i <= '1';
				nl0O0l <= '1';
				nl0O0O <= '1';
				nl0O1O <= '1';
				nl1i0i <= '1';
				nl1i0l <= '1';
				nl1i0O <= '1';
				nl1i1O <= '1';
				nl1iii <= '1';
				nl1iil <= '1';
				nl1O1i <= '1';
				nl1Oil <= '1';
				nl1OiO <= '1';
				nl1Oli <= '1';
				nl1Oll <= '1';
				nl1OlO <= '1';
				nl1OOi <= '1';
				nl1OOl <= '1';
				nl1OOO <= '1';
				nli01i <= '1';
				nli01l <= '1';
				nli01O <= '1';
				nli0i <= '1';
				nli1l <= '1';
				nlil0i <= '1';
				nlil0l <= '1';
				nlil0O <= '1';
				nlil1O <= '1';
				nlilii <= '1';
				nlilil <= '1';
				nlilOl <= '1';
				nlilOO <= '1';
				nliOil <= '1';
				nliOli <= '1';
				nliOll <= '1';
				nliOlO <= '1';
				nliOOi <= '1';
		ELSIF (wire_nli1O_CLRN = '0') THEN
				n100i <= '0';
				n100l <= '0';
				n100O <= '0';
				n101i <= '0';
				n101l <= '0';
				n101O <= '0';
				n10ii <= '0';
				n10il <= '0';
				n10iO <= '0';
				n10li <= '0';
				n10ll <= '0';
				n10lO <= '0';
				n10Oi <= '0';
				n10Ol <= '0';
				n10OO <= '0';
				n11il <= '0';
				n11OO <= '0';
				n1i1i <= '0';
				n1i1l <= '0';
				niili <= '0';
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
				nl0O0i <= '0';
				nl0O0l <= '0';
				nl0O0O <= '0';
				nl0O1O <= '0';
				nl1i0i <= '0';
				nl1i0l <= '0';
				nl1i0O <= '0';
				nl1i1O <= '0';
				nl1iii <= '0';
				nl1iil <= '0';
				nl1O1i <= '0';
				nl1Oil <= '0';
				nl1OiO <= '0';
				nl1Oli <= '0';
				nl1Oll <= '0';
				nl1OlO <= '0';
				nl1OOi <= '0';
				nl1OOl <= '0';
				nl1OOO <= '0';
				nli01i <= '0';
				nli01l <= '0';
				nli01O <= '0';
				nli0i <= '0';
				nli1l <= '0';
				nlil0i <= '0';
				nlil0l <= '0';
				nlil0O <= '0';
				nlil1O <= '0';
				nlilii <= '0';
				nlilil <= '0';
				nlilOl <= '0';
				nlilOO <= '0';
				nliOil <= '0';
				nliOli <= '0';
				nliOll <= '0';
				nliOlO <= '0';
				nliOOi <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
				n100i <= wire_nl00Oi_dataout;
				n100l <= wire_nl00Ol_dataout;
				n100O <= wire_nl00OO_dataout;
				n101i <= wire_nl00li_dataout;
				n101l <= wire_nl00ll_dataout;
				n101O <= wire_nl00lO_dataout;
				n10ii <= wire_nl0i1i_dataout;
				n10il <= wire_nl0i1l_dataout;
				n10iO <= wire_nl0i1O_dataout;
				n10li <= wire_nl0i0i_dataout;
				n10ll <= wire_nl0i0l_dataout;
				n10lO <= wire_nl0i0O_dataout;
				n10Oi <= wire_nl0iii_dataout;
				n10Ol <= wire_nl0iil_dataout;
				n10OO <= wire_nl0iiO_dataout;
				n11il <= wire_n1i1O_dataout;
				n11OO <= wire_w_lg_niO1Ol531w(0);
				n1i1i <= wire_nl0ili_dataout;
				n1i1l <= wire_nll1ii_o;
				niili <= tx_clav;
				nl010i <= atm_tx_data(8);
				nl010l <= atm_tx_data(9);
				nl010O <= atm_tx_data(10);
				nl011i <= atm_tx_data(5);
				nl011l <= atm_tx_data(6);
				nl011O <= atm_tx_data(7);
				nl01ii <= atm_tx_data(11);
				nl01il <= atm_tx_data(12);
				nl01iO <= atm_tx_data(13);
				nl01li <= atm_tx_data(14);
				nl01ll <= atm_tx_data(15);
				nl0O0i <= wire_nl0OlO_dataout;
				nl0O0l <= wire_nl0OOi_dataout;
				nl0O0O <= wire_nl0OOl_dataout;
				nl0O1O <= wire_nll11l_dataout;
				nl1i0i <= wire_nl1ill_dataout;
				nl1i0l <= wire_nl1ilO_dataout;
				nl1i0O <= wire_nl1iOi_dataout;
				nl1i1O <= wire_nl1ili_dataout;
				nl1iii <= wire_nl1iOl_dataout;
				nl1iil <= wire_nl1lll_dataout;
				nl1O1i <= wire_nl1iiO_dataout;
				nl1Oil <= wire_nli1O_w_lg_nli01O1w(0);
				nl1OiO <= atm_tx_valid;
				nl1Oli <= atm_tx_soc;
				nl1Oll <= atm_tx_data(0);
				nl1OlO <= atm_tx_data(1);
				nl1OOi <= atm_tx_data(2);
				nl1OOl <= atm_tx_data(3);
				nl1OOO <= atm_tx_data(4);
				nli01i <= (wire_nll11l_dataout AND (wire_nl1liO_w_lg_dataout866w(0) AND (((NOT wire_nl0ill_o(1)) AND (NOT wire_nl0ill_o(2))) AND wire_nl0ill_o(3))));
				nli01l <= (wire_nll11l_w_lg_dataout857w(0) AND wire_nl1liO_w_lg_dataout864w(0));
				nli01O <= wire_nli00i_dataout;
				nli0i <= wire_nll1l_dataout;
				nli1l <= wire_nll1i_dataout;
				nlil0i <= wire_nll1iO_o;
				nlil0l <= wire_n110i_dataout;
				nlil0O <= wire_nll10O_dataout;
				nlil1O <= wire_nll1ll_o;
				nlilii <= wire_nll0ii_o;
				nlilil <= wire_nll10i_o;
				nlilOl <= wire_nll1Oi_o;
				nlilOO <= wire_nll0il_o;
				nliOil <= wire_nll1Ol_o;
				nliOli <= wire_nll01l_o;
				nliOll <= wire_nll01O_o;
				nliOlO <= wire_nll00i_o;
				nliOOi <= wire_nll00l_o;
		END IF;
		if (now = 0 ns) then
			n100i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n100l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n100O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n101i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n101l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n101O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10ll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10lO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10Oi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10Ol <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10OO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11OO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1i1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1i1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niili <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl010i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl010l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl010O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl011i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl011l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl011O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl01ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl01il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl01iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl01li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl01ll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0O0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0O0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0O0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0O1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1i0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1i0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1i0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1i1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1iii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1iil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1O1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1Oil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1OiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1Oli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1Oll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1OlO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1OOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1OOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl1OOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli01i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli01l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli01O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlil0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlil0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlil0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlil1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlilii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlilil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlilOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlilOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOlO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOOi <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nli1O_CLRN <= ((nl101l8 XOR nl101l7) AND reset);
	wire_nli1O_PRN <= (nl101i10 XOR nl101i9);
	wire_nli1O_w_lg_nli0i133w(0) <= nli0i AND wire_nli1O_w_lg_w_lg_nlilil128w132w(0);
	wire_nli1O_w_lg_n1i1l581w(0) <= NOT n1i1l;
	wire_nli1O_w_lg_nl0O0i891w(0) <= NOT nl0O0i;
	wire_nli1O_w_lg_nl0O0l892w(0) <= NOT nl0O0l;
	wire_nli1O_w_lg_nl0O0O894w(0) <= NOT nl0O0O;
	wire_nli1O_w_lg_nl0O1O965w(0) <= NOT nl0O1O;
	wire_nli1O_w_lg_nl1i0i1073w(0) <= NOT nl1i0i;
	wire_nli1O_w_lg_nl1i0l1071w(0) <= NOT nl1i0l;
	wire_nli1O_w_lg_nl1i0O1069w(0) <= NOT nl1i0O;
	wire_nli1O_w_lg_nl1i1O1075w(0) <= NOT nl1i1O;
	wire_nli1O_w_lg_nl1iii1067w(0) <= NOT nl1iii;
	wire_nli1O_w_lg_nl1O1i1066w(0) <= NOT nl1O1i;
	wire_nli1O_w_lg_nl1Oli1034w(0) <= NOT nl1Oli;
	wire_nli1O_w_lg_nli01O1w(0) <= NOT nli01O;
	wire_nli1O_w_lg_nlil0l570w(0) <= NOT nlil0l;
	wire_nli1O_w_lg_nlilii216w(0) <= NOT nlilii;
	wire_nli1O_w_lg_nlilOO215w(0) <= NOT nlilOO;
	wire_nli1O_w_lg_nliOlO653w(0) <= NOT nliOlO;
	wire_nli1O_w_lg_w_lg_nlilil128w132w(0) <= wire_nli1O_w_lg_nlilil128w(0) OR wire_nl11Ol12_w_lg_w_lg_q130w131w(0);
	wire_nli1O_w_lg_nli1l134w(0) <= nli1l OR wire_nli1O_w_lg_nli0i133w(0);
	wire_nli1O_w_lg_nlilil128w(0) <= nlilil OR nlilOO;
	PROCESS (tx_clk_in, wire_nliO0O_CLRN)
	BEGIN
		IF (wire_nliO0O_CLRN = '0') THEN
				nliO0i <= '0';
				nliO0l <= '0';
				nliO1i <= '0';
				nliO1l <= '0';
				nliO1O <= '0';
				nliOii <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
			IF (nliOlO = '1') THEN
				nliO0i <= wire_nllOiO_dataout;
				nliO0l <= wire_nllOli_dataout;
				nliO1i <= wire_nllO0O_dataout;
				nliO1l <= wire_nllOii_dataout;
				nliO1O <= wire_nllOil_dataout;
				nliOii <= wire_nllOll_dataout;
			END IF;
		END IF;
		if (now = 0 ns) then
			nliO0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliO0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliO1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliO1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliO1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOii <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nliO0O_CLRN <= ((nilOOO56 XOR nilOOO55) AND reset);
	wire_nliO0O_w_lg_w_lg_nliO1i796w797w(0) <= wire_nliO0O_w_lg_nliO1i796w(0) AND nliO0l;
	wire_nliO0O_w_lg_nliO1i796w(0) <= NOT nliO1i;
	wire_nliO0O_w_lg_nliOii798w(0) <= NOT nliOii;
	PROCESS (tx_clk_in, wire_nliOl_PRN, wire_nliOl_CLRN)
	BEGIN
		IF (wire_nliOl_PRN = '0') THEN
				n0OOO <= '1';
				nii0O <= '1';
				niiii <= '1';
				niiil <= '1';
				niiiO <= '1';
				nl0Oi <= '1';
				nl0Oll <= '1';
				nli0l <= '1';
				nli0O <= '1';
				nliii <= '1';
				nliil <= '1';
				nliiO <= '1';
				nlili <= '1';
				nliliO <= '1';
				nlill <= '1';
				nlilli <= '1';
				nlilll <= '1';
				nlillO <= '1';
				nlilO <= '1';
				nlilOi <= '1';
				nliOi <= '1';
				nliOiO <= '1';
				nliOO <= '1';
				nliOOl <= '1';
		ELSIF (wire_nliOl_CLRN = '0') THEN
				n0OOO <= '0';
				nii0O <= '0';
				niiii <= '0';
				niiil <= '0';
				niiiO <= '0';
				nl0Oi <= '0';
				nl0Oll <= '0';
				nli0l <= '0';
				nli0O <= '0';
				nliii <= '0';
				nliil <= '0';
				nliiO <= '0';
				nlili <= '0';
				nliliO <= '0';
				nlill <= '0';
				nlilli <= '0';
				nlilll <= '0';
				nlillO <= '0';
				nlilO <= '0';
				nlilOi <= '0';
				nliOi <= '0';
				nliOiO <= '0';
				nliOO <= '0';
				nliOOl <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
				n0OOO <= wire_niill_dataout;
				nii0O <= wire_niilO_dataout;
				niiii <= wire_niiOi_dataout;
				niiil <= wire_niiOl_dataout;
				niiiO <= wire_niiOO_dataout;
				nl0Oi <= wire_nliOl_w_lg_nl0Oi141w(0);
				nl0Oll <= wire_nl0OOO_dataout;
				nli0l <= wire_nllil_dataout;
				nli0O <= wire_nlliO_dataout;
				nliii <= wire_nllli_dataout;
				nliil <= wire_nllll_dataout;
				nliiO <= wire_nlllO_dataout;
				nlili <= wire_nll1O_dataout;
				nliliO <= wire_nll0iO_o;
				nlill <= wire_nll0i_dataout;
				nlilli <= wire_nll0li_o;
				nlilll <= wire_nll0ll_o;
				nlillO <= wire_nll0lO_o;
				nlilO <= wire_nll0l_dataout;
				nlilOi <= wire_nll0Oi_o;
				nliOi <= wire_nll0O_dataout;
				nliOiO <= wire_nll01i_o;
				nliOO <= wire_nllii_dataout;
				nliOOl <= wire_nll00O_o;
		END IF;
		if (now = 0 ns) then
			n0OOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niiii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niiil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niiiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0Oi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0Oll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nli0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlili <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliliO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlill <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlilli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlilll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlillO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlilO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlilOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nliOOl <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nliOl_CLRN <= (nl100l4 XOR nl100l3);
	wire_nliOl_PRN <= ((nl100i6 XOR nl100i5) AND reset);
	wire_nliOl_w_lg_nl0Oi141w(0) <= NOT nl0Oi;
	wire_nliOl_w_lg_nl0Oll540w(0) <= NOT nl0Oll;
	wire_nliOl_w_lg_nliOiO579w(0) <= NOT nliOiO;
	wire_nliOl_w_lg_w_lg_nliOOl754w755w(0) <= wire_nliOl_w_lg_nliOOl754w(0) OR nliOli;
	wire_nliOl_w_lg_w_lg_nliOOl754w775w(0) <= wire_nliOl_w_lg_nliOOl754w(0) OR nliOll;
	wire_nliOl_w_lg_w_lg_nliOOl754w784w(0) <= wire_nliOl_w_lg_nliOOl754w(0) OR nliOlO;
	wire_nliOl_w_lg_nliOOl754w(0) <= nliOOl OR nliOOi;
	PROCESS (tx_clk_in, wire_nliOOO_CLRN)
	BEGIN
		IF (wire_nliOOO_CLRN = '0') THEN
				nl0lOO <= '0';
				nl0O1i <= '0';
				nl0O1l <= '0';
				nll11i <= '0';
		ELSIF (tx_clk_in = '1' AND tx_clk_in'event) THEN
			IF (wire_nll11l_dataout = '1') THEN
				nl0lOO <= nl0Oii;
				nl0O1i <= nl0Oil;
				nl0O1l <= nl0Oli;
				nll11i <= wire_nliOl_w_lg_nl0Oll540w(0);
			END IF;
		END IF;
		if (now = 0 ns) then
			nl0lOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0O1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nl0O1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nll11i <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nliOOO_CLRN <= ((niO11i54 XOR niO11i53) AND reset);
	wire_nliOOO_w_lg_nll11i549w(0) <= NOT nll11i;
	wire_n1iiO_data <= ( niiiO & niiil & niiii & nii0O & n0OOO);
	n1iiO :  lpm_decode
	  GENERIC MAP (
		LPM_DECODES => 32,
		LPM_PIPELINE => 0,
		LPM_WIDTH => 5
	  )
	  PORT MAP ( 
		data => wire_n1iiO_data,
		enable => wire_vcc,
		eq => wire_n1iiO_eq
	  );
	wire_n1ili_aclr <= wire_w_lg_reset402w(0);
	wire_n1ili_data(0) <= ( wire_n0OOl_dataout);
	n1ili :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1ili_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1ili_data,
		enable => wire_n0ill_dataout,
		q => wire_n1ili_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1ill_aclr <= wire_w_lg_reset402w(0);
	wire_n1ill_data(0) <= ( wire_n0OOl_dataout);
	n1ill :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1ill_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1ill_data,
		enable => wire_n0ilO_dataout,
		q => wire_n1ill_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1ilO_aclr <= wire_w_lg_reset402w(0);
	wire_n1ilO_data(0) <= ( wire_n0OOl_dataout);
	n1ilO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1ilO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1ilO_data,
		enable => wire_n0iOi_dataout,
		q => wire_n1ilO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1iOi_aclr <= wire_w_lg_reset402w(0);
	wire_n1iOi_data(0) <= ( wire_n0OOl_dataout);
	n1iOi :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1iOi_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1iOi_data,
		enable => wire_n0iOl_dataout,
		q => wire_n1iOi_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1iOl_aclr <= wire_w_lg_reset402w(0);
	wire_n1iOl_data(0) <= ( wire_n0OOl_dataout);
	n1iOl :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1iOl_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1iOl_data,
		enable => wire_n0iOO_dataout,
		q => wire_n1iOl_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1iOO_aclr <= wire_w_lg_reset402w(0);
	wire_n1iOO_data(0) <= ( wire_n0OOl_dataout);
	n1iOO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1iOO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1iOO_data,
		enable => wire_n0l1i_dataout,
		q => wire_n1iOO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l0i_aclr <= wire_w_lg_reset402w(0);
	wire_n1l0i_data(0) <= ( wire_n0OOl_dataout);
	n1l0i :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l0i_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1l0i_data,
		enable => wire_n0l0l_dataout,
		q => wire_n1l0i_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l0l_aclr <= wire_w_lg_reset402w(0);
	wire_n1l0l_data(0) <= ( wire_n0OOl_dataout);
	n1l0l :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l0l_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1l0l_data,
		enable => wire_n0l0O_dataout,
		q => wire_n1l0l_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l0O_aclr <= wire_w_lg_reset402w(0);
	wire_n1l0O_data(0) <= ( wire_n0OOl_dataout);
	n1l0O :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l0O_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1l0O_data,
		enable => wire_n0lii_dataout,
		q => wire_n1l0O_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l1i_aclr <= wire_w_lg_reset402w(0);
	wire_n1l1i_data(0) <= ( wire_n0OOl_dataout);
	n1l1i :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l1i_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1l1i_data,
		enable => wire_n0l1l_dataout,
		q => wire_n1l1i_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l1l_aclr <= wire_w_lg_reset402w(0);
	wire_n1l1l_data(0) <= ( wire_n0OOl_dataout);
	n1l1l :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l1l_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1l1l_data,
		enable => wire_n0l1O_dataout,
		q => wire_n1l1l_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l1O_aclr <= wire_w_lg_reset402w(0);
	wire_n1l1O_data(0) <= ( wire_n0OOl_dataout);
	n1l1O :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l1O_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1l1O_data,
		enable => wire_n0l0i_dataout,
		q => wire_n1l1O_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lii_aclr <= wire_w_lg_reset402w(0);
	wire_n1lii_data(0) <= ( wire_n0OOl_dataout);
	n1lii :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lii_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1lii_data,
		enable => wire_n0lil_dataout,
		q => wire_n1lii_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lil_aclr <= wire_w_lg_reset402w(0);
	wire_n1lil_data(0) <= ( wire_n0OOl_dataout);
	n1lil :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lil_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1lil_data,
		enable => wire_n0liO_dataout,
		q => wire_n1lil_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1liO_aclr <= wire_w_lg_reset402w(0);
	wire_n1liO_data(0) <= ( wire_n0OOl_dataout);
	n1liO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1liO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1liO_data,
		enable => wire_n0lli_dataout,
		q => wire_n1liO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lli_aclr <= wire_w_lg_reset402w(0);
	wire_n1lli_data(0) <= ( wire_n0OOl_dataout);
	n1lli :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lli_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1lli_data,
		enable => wire_n0lll_dataout,
		q => wire_n1lli_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lll_aclr <= wire_w_lg_reset402w(0);
	wire_n1lll_data(0) <= ( wire_n0OOl_dataout);
	n1lll :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lll_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1lll_data,
		enable => wire_n0llO_dataout,
		q => wire_n1lll_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1llO_aclr <= wire_w_lg_reset402w(0);
	wire_n1llO_data(0) <= ( wire_n0OOl_dataout);
	n1llO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1llO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1llO_data,
		enable => wire_n0lOi_dataout,
		q => wire_n1llO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lOi_aclr <= wire_w_lg_reset402w(0);
	wire_n1lOi_data(0) <= ( wire_n0OOl_dataout);
	n1lOi :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lOi_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1lOi_data,
		enable => wire_n0lOl_dataout,
		q => wire_n1lOi_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lOl_aclr <= wire_w_lg_reset402w(0);
	wire_n1lOl_data(0) <= ( wire_n0OOl_dataout);
	n1lOl :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lOl_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1lOl_data,
		enable => wire_n0lOO_dataout,
		q => wire_n1lOl_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lOO_aclr <= wire_w_lg_reset402w(0);
	wire_n1lOO_data(0) <= ( wire_n0OOl_dataout);
	n1lOO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lOO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1lOO_data,
		enable => wire_n0O1i_dataout,
		q => wire_n1lOO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O0i_aclr <= wire_w_lg_reset402w(0);
	wire_n1O0i_data(0) <= ( wire_n0OOl_dataout);
	n1O0i :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O0i_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1O0i_data,
		enable => wire_n0O0l_dataout,
		q => wire_n1O0i_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O0l_aclr <= wire_w_lg_reset402w(0);
	wire_n1O0l_data(0) <= ( wire_n0OOl_dataout);
	n1O0l :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O0l_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1O0l_data,
		enable => wire_n0O0O_dataout,
		q => wire_n1O0l_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O0O_aclr <= wire_w_lg_reset402w(0);
	wire_n1O0O_data(0) <= ( wire_n0OOl_dataout);
	n1O0O :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O0O_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1O0O_data,
		enable => wire_n0Oii_dataout,
		q => wire_n1O0O_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O1i_aclr <= wire_w_lg_reset402w(0);
	wire_n1O1i_data(0) <= ( wire_n0OOl_dataout);
	n1O1i :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O1i_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1O1i_data,
		enable => wire_n0O1l_dataout,
		q => wire_n1O1i_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O1l_aclr <= wire_w_lg_reset402w(0);
	wire_n1O1l_data(0) <= ( wire_n0OOl_dataout);
	n1O1l :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O1l_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1O1l_data,
		enable => wire_n0O1O_dataout,
		q => wire_n1O1l_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O1O_aclr <= wire_w_lg_reset402w(0);
	wire_n1O1O_data(0) <= ( wire_n0OOl_dataout);
	n1O1O :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O1O_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1O1O_data,
		enable => wire_n0O0i_dataout,
		q => wire_n1O1O_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1Oii_aclr <= wire_w_lg_reset402w(0);
	wire_n1Oii_data(0) <= ( wire_n0OOl_dataout);
	n1Oii :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1Oii_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1Oii_data,
		enable => wire_n0Oil_dataout,
		q => wire_n1Oii_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1Oil_aclr <= wire_w_lg_reset402w(0);
	wire_n1Oil_data(0) <= ( wire_n0OOl_dataout);
	n1Oil :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1Oil_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1Oil_data,
		enable => wire_n0OiO_dataout,
		q => wire_n1Oil_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1OiO_aclr <= wire_w_lg_reset402w(0);
	wire_n1OiO_data(0) <= ( wire_n0OOl_dataout);
	n1OiO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1OiO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1OiO_data,
		enable => wire_n0Oli_dataout,
		q => wire_n1OiO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1Oli_aclr <= wire_w_lg_reset402w(0);
	wire_n1Oli_data(0) <= ( wire_n0OOl_dataout);
	n1Oli :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1Oli_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => tx_clk_in,
		data => wire_n1Oli_data,
		enable => wire_n0Oll_dataout,
		q => wire_n1Oli_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n0ill_dataout <= wire_n1iiO_eq(0) AND NOT(niOi0l);
	wire_n0ilO_dataout <= wire_n1iiO_eq(1) AND NOT(niOi0l);
	wire_n0iOi_dataout <= wire_n1iiO_eq(2) AND NOT(niOi0l);
	wire_n0iOl_dataout <= wire_n1iiO_eq(3) AND NOT(niOi0l);
	wire_n0iOO_dataout <= wire_n1iiO_eq(4) AND NOT(niOi0l);
	wire_n0l0i_dataout <= wire_n1iiO_eq(8) AND NOT(niOi0l);
	wire_n0l0l_dataout <= wire_n1iiO_eq(9) AND NOT(niOi0l);
	wire_n0l0O_dataout <= wire_n1iiO_eq(10) AND NOT(niOi0l);
	wire_n0l1i_dataout <= wire_n1iiO_eq(5) AND NOT(niOi0l);
	wire_n0l1l_dataout <= wire_n1iiO_eq(6) AND NOT(niOi0l);
	wire_n0l1O_dataout <= wire_n1iiO_eq(7) AND NOT(niOi0l);
	wire_n0lii_dataout <= wire_n1iiO_eq(11) AND NOT(niOi0l);
	wire_n0lil_dataout <= wire_n1iiO_eq(12) AND NOT(niOi0l);
	wire_n0liO_dataout <= wire_n1iiO_eq(13) AND NOT(niOi0l);
	wire_n0lli_dataout <= wire_n1iiO_eq(14) AND NOT(niOi0l);
	wire_n0lll_dataout <= wire_n1iiO_eq(15) AND NOT(niOi0l);
	wire_n0llO_dataout <= wire_n1iiO_eq(16) AND NOT(niOi0l);
	wire_n0lOi_dataout <= wire_n1iiO_eq(17) AND NOT(niOi0l);
	wire_n0lOl_dataout <= wire_n1iiO_eq(18) AND NOT(niOi0l);
	wire_n0lOO_dataout <= wire_n1iiO_eq(19) AND NOT(niOi0l);
	wire_n0O0i_dataout <= wire_n1iiO_eq(23) AND NOT(niOi0l);
	wire_n0O0l_dataout <= wire_n1iiO_eq(24) AND NOT(niOi0l);
	wire_n0O0O_dataout <= wire_n1iiO_eq(25) AND NOT(niOi0l);
	wire_n0O1i_dataout <= wire_n1iiO_eq(20) AND NOT(niOi0l);
	wire_n0O1l_dataout <= wire_n1iiO_eq(21) AND NOT(niOi0l);
	wire_n0O1O_dataout <= wire_n1iiO_eq(22) AND NOT(niOi0l);
	wire_n0Oii_dataout <= wire_n1iiO_eq(26) AND NOT(niOi0l);
	wire_n0Oil_dataout <= wire_n1iiO_eq(27) AND NOT(niOi0l);
	wire_n0OiO_dataout <= wire_n1iiO_eq(28) AND NOT(niOi0l);
	wire_n0Oli_dataout <= wire_n1iiO_eq(29) AND NOT(niOi0l);
	wire_n0Oll_dataout <= wire_n1iiO_eq(30) AND NOT(niOi0l);
	wire_n0OOl_dataout <= wire_ni11i_dataout AND nl0Oi;
	wire_n110i_dataout <= (wire_ni10l_dataout AND niO1lO) AND n11il;
	wire_n110O_dataout <= nlilii AND NOT(nlil0O);
	wire_n111l_dataout <= nlilOO AND NOT((nlil0l OR nlilOl));
	wire_n11ii_dataout <= nlilOl AND n11il;
	wire_n1i0i_dataout <= n11il AND NOT((wire_nliOl_w_lg_nl0Oi141w(0) AND nlilOl));
	wire_n1i1O_dataout <= wire_n1i0i_dataout OR atm_tx_port_load;
	wire_ni00i_dataout <= wire_n1lll_q(0) WHEN niOlOi = '1'  ELSE wire_ni00l_dataout;
	wire_ni00l_dataout <= wire_n1lli_q(0) WHEN niOlOl = '1'  ELSE wire_ni00O_dataout;
	wire_ni00O_dataout <= wire_n1liO_q(0) WHEN niOlOO = '1'  ELSE wire_ni0ii_dataout;
	wire_ni01i_dataout <= wire_n1lOl_q(0) WHEN niOlli = '1'  ELSE wire_ni01l_dataout;
	wire_ni01l_dataout <= wire_n1lOi_q(0) WHEN niOlll = '1'  ELSE wire_ni01O_dataout;
	wire_ni01O_dataout <= wire_n1llO_q(0) WHEN niOllO = '1'  ELSE wire_ni00i_dataout;
	wire_ni0ii_dataout <= wire_n1lil_q(0) WHEN niOO1i = '1'  ELSE wire_ni0il_dataout;
	wire_ni0il_dataout <= wire_n1lii_q(0) WHEN niOO1l = '1'  ELSE wire_ni0iO_dataout;
	wire_ni0iO_dataout <= wire_n1l0O_q(0) WHEN niOO1O = '1'  ELSE wire_ni0li_dataout;
	wire_ni0li_dataout <= wire_n1l0l_q(0) WHEN niOO0i = '1'  ELSE wire_ni0ll_dataout;
	wire_ni0ll_dataout <= wire_n1l0i_q(0) WHEN niOO0l = '1'  ELSE wire_ni0lO_dataout;
	wire_ni0lO_dataout <= wire_n1l1O_q(0) WHEN niOO0O = '1'  ELSE wire_ni0Oi_dataout;
	wire_ni0Oi_dataout <= wire_n1l1l_q(0) WHEN niOOii = '1'  ELSE wire_ni0Ol_dataout;
	wire_ni0Ol_dataout <= wire_n1l1i_q(0) WHEN niOOil = '1'  ELSE wire_ni0OO_dataout;
	wire_ni0OO_dataout <= wire_n1iOO_q(0) WHEN niOOiO = '1'  ELSE wire_nii1i_dataout;
	wire_ni10l_dataout <= wire_n1Oli_q(0) WHEN niOiOl = '1'  ELSE wire_ni10O_dataout;
	wire_ni10O_dataout <= wire_n1OiO_q(0) WHEN niOiOO = '1'  ELSE wire_ni1ii_dataout;
	wire_ni11i_dataout <= niili AND ((wire_nl0OO_w_lg_nli1i203w(0) OR (wire_nl0OO_w_lg_nl0Ol205w(0) OR (NOT (niOilO24 XOR niOilO23)))) OR (NOT (niOili26 XOR niOili25)));
	wire_ni1ii_dataout <= wire_n1Oil_q(0) WHEN niOl1i = '1'  ELSE wire_ni1il_dataout;
	wire_ni1il_dataout <= wire_n1Oii_q(0) WHEN niOl1l = '1'  ELSE wire_ni1iO_dataout;
	wire_ni1iO_dataout <= wire_n1O0O_q(0) WHEN niOl1O = '1'  ELSE wire_ni1li_dataout;
	wire_ni1li_dataout <= wire_n1O0l_q(0) WHEN niOl0i = '1'  ELSE wire_ni1ll_dataout;
	wire_ni1ll_dataout <= wire_n1O0i_q(0) WHEN niOl0l = '1'  ELSE wire_ni1lO_dataout;
	wire_ni1lO_dataout <= wire_n1O1O_q(0) WHEN niOl0O = '1'  ELSE wire_ni1Oi_dataout;
	wire_ni1Oi_dataout <= wire_n1O1l_q(0) WHEN niOlii = '1'  ELSE wire_ni1Ol_dataout;
	wire_ni1Ol_dataout <= wire_n1O1i_q(0) WHEN niOlil = '1'  ELSE wire_ni1OO_dataout;
	wire_ni1OO_dataout <= wire_n1lOO_q(0) WHEN niOliO = '1'  ELSE wire_ni01i_dataout;
	wire_nii0i_dataout <= wire_n1ill_q(0) WHEN niOOOi = '1'  ELSE wire_nii0l_dataout;
	wire_nii0l_dataout <= wire_n1ili_q(0) AND niOOOl;
	wire_nii1i_dataout <= wire_n1iOl_q(0) WHEN niOOli = '1'  ELSE wire_nii1l_dataout;
	wire_nii1l_dataout <= wire_n1iOi_q(0) WHEN niOOll = '1'  ELSE wire_nii1O_dataout;
	wire_nii1O_dataout <= wire_n1ilO_q(0) WHEN niOOlO = '1'  ELSE wire_nii0i_dataout;
	wire_niill_dataout <= wire_nil1i_dataout WHEN nl0Oi = '1'  ELSE nli0l;
	wire_niilO_dataout <= wire_nil1l_dataout WHEN nl0Oi = '1'  ELSE nli0O;
	wire_niiOi_dataout <= wire_nil1O_dataout WHEN nl0Oi = '1'  ELSE nliii;
	wire_niiOl_dataout <= wire_nil0i_dataout WHEN nl0Oi = '1'  ELSE nliil;
	wire_niiOO_dataout <= wire_nil0l_dataout WHEN nl0Oi = '1'  ELSE nliiO;
	wire_nil0i_dataout <= n11lO WHEN nlilOO = '1'  ELSE nlillO;
	wire_nil0l_dataout <= n11Ol WHEN nlilOO = '1'  ELSE nlilOi;
	wire_nil0O_dataout <= n11iO WHEN nlilOO = '1'  ELSE wire_nilll_dataout;
	wire_nil1i_dataout <= n11iO WHEN nlilOO = '1'  ELSE nliliO;
	wire_nil1l_dataout <= n11li WHEN nlilOO = '1'  ELSE nlilli;
	wire_nil1O_dataout <= n11ll WHEN nlilOO = '1'  ELSE nlilll;
	wire_nilii_dataout <= n11li WHEN nlilOO = '1'  ELSE wire_nillO_dataout;
	wire_nilil_dataout <= n11ll WHEN nlilOO = '1'  ELSE wire_nilOi_dataout;
	wire_niliO_dataout <= n11lO WHEN nlilOO = '1'  ELSE wire_nilOl_dataout;
	wire_nilli_dataout <= n11Ol WHEN nlilOO = '1'  ELSE wire_nilOO_dataout;
	wire_nilll_dataout <= nliliO WHEN nl100O = '1'  ELSE nl0ii;
	wire_nillO_dataout <= nlilli WHEN nl100O = '1'  ELSE nl0il;
	wire_nilOi_dataout <= nlilll WHEN nl100O = '1'  ELSE nl0iO;
	wire_nilOl_dataout <= nlillO WHEN nl100O = '1'  ELSE nl0li;
	wire_nilOO_dataout <= nlilOi WHEN nl100O = '1'  ELSE nl0lO;
	wire_niO0i_dataout <= wire_niOOl_dataout WHEN nl11ii = '1'  ELSE wire_niOiO_dataout;
	wire_niO0l_dataout <= wire_niOOO_dataout WHEN nl11ii = '1'  ELSE wire_niOli_dataout;
	wire_niO0O_dataout <= wire_n11Oi_w_lg_n11iO202w(0) WHEN nlilOO = '1'  ELSE nl0ii;
	wire_niO1i_dataout <= wire_niOll_dataout WHEN nl11ii = '1'  ELSE wire_niO0O_dataout;
	wire_niO1l_dataout <= wire_niOlO_dataout WHEN nl11ii = '1'  ELSE wire_niOii_dataout;
	wire_niO1O_dataout <= wire_niOOi_dataout WHEN nl11ii = '1'  ELSE wire_niOil_dataout;
	wire_niOii_dataout <= nl0il AND NOT(nlilOO);
	wire_niOil_dataout <= nl0iO AND NOT(nlilOO);
	wire_niOiO_dataout <= nl0li AND NOT(nlilOO);
	wire_niOli_dataout <= nl0lO AND NOT(nlilOO);
	wire_niOll_dataout <= wire_n11Oi_w_lg_n11iO202w(0) WHEN nlilOO = '1'  ELSE wire_nl11i_dataout;
	wire_niOlO_dataout <= wire_nl11l_dataout AND NOT(nlilOO);
	wire_niOOi_dataout <= wire_nl11O_dataout AND NOT(nlilOO);
	wire_niOOl_dataout <= wire_nl10i_dataout AND NOT(nlilOO);
	wire_niOOO_dataout <= wire_nl10l_dataout AND NOT(nlilOO);
	wire_nl00li_dataout <= nli10i WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(0);
	wire_nl00ll_dataout <= nl0iOO WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(1);
	wire_nl00lO_dataout <= nl0l1i WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(2);
	wire_nl00Oi_dataout <= nl0l1l WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(3);
	wire_nl00Ol_dataout <= nl0l1O WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(4);
	wire_nl00OO_dataout <= nl0l0i WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(5);
	wire_nl01i_dataout <= wire_nl01O_o(3) AND NOT(nl110O);
	wire_nl01i_w_lg_dataout330w(0) <= NOT wire_nl01i_dataout;
	wire_nl01l_dataout <= wire_nl01O_o(4) AND NOT(nl110O);
	wire_nl01l_w_lg_dataout328w(0) <= NOT wire_nl01l_dataout;
	wire_nl0i0i_dataout <= nl0lil WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(9);
	wire_nl0i0l_dataout <= nl0liO WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(10);
	wire_nl0i0O_dataout <= nl0lli WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(11);
	wire_nl0i1i_dataout <= nl0l0l WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(6);
	wire_nl0i1l_dataout <= nl0l0O WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(7);
	wire_nl0i1O_dataout <= nl0lii WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(8);
	wire_nl0iii_dataout <= nl0lll WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(12);
	wire_nl0iil_dataout <= nl0llO WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(13);
	wire_nl0iiO_dataout <= nl0lOi WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(14);
	wire_nl0ili_dataout <= nl0lOl WHEN wire_nli1O_w_lg_nl0O1O965w(0) = '1'  ELSE wire_nl01Ol_q_b(15);
	wire_nl0ilO_dataout <= nl0Oii WHEN wire_nll11l_dataout = '1'  ELSE nl0lOO;
	wire_nl0iOi_dataout <= nl0Oil WHEN wire_nll11l_dataout = '1'  ELSE nl0O1i;
	wire_nl0iOl_dataout <= nl0Oli WHEN wire_nll11l_dataout = '1'  ELSE nl0O1l;
	wire_nl0OlO_dataout <= wire_nli10O_o(0) WHEN wire_nl1liO_dataout = '1'  ELSE nl0O0i;
	wire_nl0OOi_dataout <= wire_nli10O_o(1) WHEN wire_nl1liO_dataout = '1'  ELSE nl0O0l;
	wire_nl0OOl_dataout <= wire_nli10O_o(2) WHEN wire_nl1liO_dataout = '1'  ELSE nl0O0O;
	wire_nl0OOO_dataout <= wire_nli11i_dataout WHEN wire_nl1liO_dataout = '1'  ELSE wire_nli1ii_dataout;
	wire_nl10i_dataout <= wire_nl1iO_dataout WHEN nl111l = '1'  ELSE wire_nl01i_dataout;
	wire_nl10l_dataout <= wire_nl1li_dataout WHEN nl111l = '1'  ELSE wire_nl01l_dataout;
	wire_nl10O_dataout <= wire_nl1ll_o(0) AND NOT(niOOOO);
	wire_nl11i_dataout <= wire_nl10O_dataout WHEN nl111l = '1'  ELSE wire_nl1Oi_dataout;
	wire_nl11l_dataout <= wire_nl1ii_dataout WHEN nl111l = '1'  ELSE wire_nl1Ol_dataout;
	wire_nl11O_dataout <= wire_nl1il_dataout WHEN nl111l = '1'  ELSE wire_nl1OO_dataout;
	wire_nl1ii_dataout <= wire_nl1ll_o(1) AND NOT(niOOOO);
	wire_nl1iiO_dataout <= wire_nl1iOO_dataout AND NOT(wire_nl1lii_dataout);
	wire_nl1il_dataout <= wire_nl1ll_o(2) AND NOT(niOOOO);
	wire_nl1ili_dataout <= wire_nl1l1i_dataout AND NOT(wire_nl1lii_dataout);
	wire_nl1ill_dataout <= wire_nl1l1l_dataout AND NOT(wire_nl1lii_dataout);
	wire_nl1ilO_dataout <= wire_nl1l1O_dataout AND NOT(wire_nl1lii_dataout);
	wire_nl1iO_dataout <= wire_nl1ll_o(3) AND NOT(niOOOO);
	wire_nl1iOi_dataout <= wire_nl1l0i_dataout AND NOT(wire_nl1lii_dataout);
	wire_nl1iOl_dataout <= wire_nl1l0l_dataout AND NOT(wire_nl1lii_dataout);
	wire_nl1iOO_dataout <= wire_nl1l0O_o(0) WHEN wire_nl1lil_dataout = '1'  ELSE nl1O1i;
	wire_nl1l0i_dataout <= wire_nl1l0O_o(4) WHEN wire_nl1lil_dataout = '1'  ELSE nl1i0O;
	wire_nl1l0l_dataout <= wire_nl1l0O_o(5) WHEN wire_nl1lil_dataout = '1'  ELSE nl1iii;
	wire_nl1l1i_dataout <= wire_nl1l0O_o(1) WHEN wire_nl1lil_dataout = '1'  ELSE nl1i1O;
	wire_nl1l1l_dataout <= wire_nl1l0O_o(2) WHEN wire_nl1lil_dataout = '1'  ELSE nl1i0i;
	wire_nl1l1O_dataout <= wire_nl1l0O_o(3) WHEN wire_nl1lil_dataout = '1'  ELSE nl1i0l;
	wire_nl1li_dataout <= wire_nl1ll_o(4) AND NOT(niOOOO);
	wire_nl1lii_dataout <= wire_nl1llO_dataout AND wire_nl1lli_o(1);
	wire_nl1lil_dataout <= wire_nl1lOi_dataout WHEN wire_nl1lli_o(1) = '1'  ELSE nilOiO;
	wire_nl1liO_dataout <= wire_nl1lOl_dataout WHEN wire_nl1lli_o(1) = '1'  ELSE wire_nl1O0l_dataout;
	wire_nl1liO_w_lg_dataout864w(0) <= wire_nl1liO_dataout AND wire_nl0ill_w_lg_w_lg_w_o_range858w860w863w(0);
	wire_nl1liO_w_lg_dataout866w(0) <= NOT wire_nl1liO_dataout;
	wire_nl1lll_dataout <= wire_nl1lOO_dataout WHEN wire_nl1lli_o(1) = '1'  ELSE wire_nl1O0O_dataout;
	wire_nl1llO_dataout <= nilO0O AND nilOli;
	wire_nl1lOi_dataout <= wire_w_lg_nilOii1036w(0) AND nilOli;
	wire_nl1lOl_dataout <= wire_nl1O1l_dataout AND nilOli;
	wire_nl1lOO_dataout <= wire_nl1O1O_dataout WHEN nilOli = '1'  ELSE nl1iil;
	wire_nl1O0l_dataout <= nilOli AND nilOiO;
	wire_nl1O0O_dataout <= nl1iil OR nilOiO;
	wire_nl1O1l_dataout <= nilOli AND NOT(nilOii);
	wire_nl1O1O_dataout <= nl1iil AND NOT(nilOii);
	wire_nl1Oi_dataout <= wire_nl01O_o(0) AND NOT(nl110O);
	wire_nl1Oi_w_lg_dataout329w(0) <= wire_nl1Oi_dataout AND wire_nl01l_w_lg_dataout328w(0);
	wire_nl1Ol_dataout <= wire_nl01O_o(1) AND NOT(nl110O);
	wire_nl1Ol_w_lg_dataout334w(0) <= NOT wire_nl1Ol_dataout;
	wire_nl1OO_dataout <= wire_nl01O_o(2) AND NOT(nl110O);
	wire_nl1OO_w_lg_dataout332w(0) <= NOT wire_nl1OO_dataout;
	wire_nli00i_dataout <= wire_nli00l_dataout OR nli01l;
	wire_nli00l_dataout <= nli01O AND NOT(nli01i);
	wire_nli11i_dataout <= wire_nli1ii_dataout WHEN (wire_nll11l_w_lg_dataout857w(0) AND nilOlO) = '1'  ELSE wire_nli11l_dataout;
	wire_nli11l_dataout <= wire_nli1ii_dataout AND nilOlO;
	wire_nli1ii_dataout <= wire_nli1il_dataout WHEN nilOOl = '1'  ELSE nl0Oll;
	wire_nli1il_dataout <= nl0Oll OR (wire_nl1liO_w_lg_dataout866w(0) AND ((wire_nl0OiO_w_lg_w_lg_nl0Oii889w890w(0) AND ((wire_nli1O_w_lg_nl0O0i891w(0) AND wire_nli1O_w_lg_nl0O0l892w(0)) AND wire_nli1O_w_lg_nl0O0O894w(0))) OR ((((NOT (nl0O0i XOR wire_nli1iO_o(0))) AND (NOT (nl0O0l XOR wire_nli1iO_o(1)))) AND (NOT (nl0O0O XOR wire_nli1iO_o(2)))) AND (NOT wire_nli1iO_o(3)))));
	wire_nll0i_dataout <= wire_nilii_dataout OR nl0Oi;
	wire_nll0l_dataout <= wire_nilil_dataout OR nl0Oi;
	wire_nll0O_dataout <= wire_niliO_dataout OR nl0Oi;
	wire_nll0OO_dataout <= wire_nlliiO_dataout WHEN niO10i = '1'  ELSE nlil0i;
	wire_nll10O_dataout <= wire_nllO1l_dataout AND nliOlO;
	wire_nll11l_dataout <= wire_nll01i_w_lg_o790w(0) OR (wire_nliOOO_w_lg_nll11i549w(0) AND wire_nliOl_w_lg_nl0Oll540w(0));
	wire_nll11l_w_lg_dataout857w(0) <= NOT wire_nll11l_dataout;
	wire_nll1i_dataout <= wire_nllOi_dataout AND NOT(nl0Oi);
	wire_nll1l_dataout <= wire_nllOl_dataout AND NOT(nl0Oi);
	wire_nll1O_dataout <= wire_nil0O_dataout OR nl0Oi;
	wire_nlli0i_dataout <= nliOlO OR niO10i;
	wire_nlli0l_dataout <= nliOOi AND NOT(niO10i);
	wire_nlli0O_dataout <= nliOOl AND NOT(niO10i);
	wire_nlli1i_dataout <= n1i1l AND NOT(niO10i);
	wire_nlli1l_dataout <= nliOli AND NOT(niO10i);
	wire_nlli1O_dataout <= nliOll AND NOT(niO10i);
	wire_nllii_dataout <= wire_nilli_dataout OR nl0Oi;
	wire_nlliii_dataout <= nliOiO AND NOT(niO10i);
	wire_nlliil_dataout <= nlilil AND NOT(niO10i);
	wire_nlliiO_dataout <= nlil0i OR (nlil1O AND wire_nli1O_w_lg_n1i1l581w(0));
	wire_nllil_dataout <= nli0l WHEN nl0Oi = '1'  ELSE wire_nil0O_dataout;
	wire_nllilO_dataout <= nliOli OR niO10l;
	wire_nlliO_dataout <= nli0O WHEN nl0Oi = '1'  ELSE wire_nilii_dataout;
	wire_nlliOi_dataout <= nliOll AND NOT(niO10l);
	wire_nlliOl_dataout <= nliOlO AND NOT(niO10l);
	wire_nlliOO_dataout <= nliOOi AND NOT(niO10l);
	wire_nlll0i_dataout <= nlil1O OR nlil0i;
	wire_nlll0l_dataout <= wire_nllOlO_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nliliO;
	wire_nlll0O_dataout <= wire_nllOOi_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nlilli;
	wire_nlll1i_dataout <= nliOOl AND NOT(niO10l);
	wire_nlll1l_dataout <= nlilil OR niO10l;
	wire_nllli_dataout <= nliii WHEN nl0Oi = '1'  ELSE wire_nilil_dataout;
	wire_nlllii_dataout <= wire_nllOOl_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nlilll;
	wire_nlllil_dataout <= wire_nllOOO_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nlillO;
	wire_nllliO_dataout <= wire_nlO11i_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nlilOi;
	wire_nllll_dataout <= nliil WHEN nl0Oi = '1'  ELSE wire_niliO_dataout;
	wire_nlllli_dataout <= wire_nlO11O_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_n11ii_dataout;
	wire_nlllll_dataout <= wire_nlO10i_dataout AND wire_nliOl_w_lg_nliOiO579w(0);
	wire_nllllO_dataout <= wire_nlO10l_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_nlOiii_dataout;
	wire_nlllO_dataout <= nliiO WHEN nl0Oi = '1'  ELSE wire_nilli_dataout;
	wire_nlllOi_dataout <= wire_nlO10O_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_nlOiil_dataout;
	wire_nlllOl_dataout <= wire_nlO1ii_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_nlOiiO_dataout;
	wire_nlllOO_dataout <= wire_nlO1il_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_nlOili_dataout;
	wire_nllO0i_dataout <= wire_nlO1ll_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_nlOilO_dataout;
	wire_nllO0l_dataout <= wire_nlO11l_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_n111l_dataout;
	wire_nllO0O_dataout <= wire_nlO1lO_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nliO1i;
	wire_nllO1i_dataout <= wire_nlO1iO_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_nlOill_dataout;
	wire_nllO1l_dataout <= niO10O AND wire_nliOl_w_lg_nliOiO579w(0);
	wire_nllO1O_dataout <= wire_nlO1li_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE wire_nlOl0O_dataout;
	wire_nllOi_dataout <= nlil0i AND NOT(nlilOO);
	wire_nllOii_dataout <= wire_nlO1Oi_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nliO1l;
	wire_nllOil_dataout <= wire_nlO1Ol_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nliO1O;
	wire_nllOiO_dataout <= wire_nlO1OO_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nliO0i;
	wire_nllOl_dataout <= wire_ni10l_dataout WHEN nlilOO = '1'  ELSE nlilil;
	wire_nllOli_dataout <= wire_nlO01i_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nliO0l;
	wire_nllOll_dataout <= wire_nlO01l_dataout WHEN wire_nliOl_w_lg_nliOiO579w(0) = '1'  ELSE nliOii;
	wire_nllOlO_dataout <= wire_nlO01O_dataout WHEN niO10O = '1'  ELSE nliliO;
	wire_nllOOi_dataout <= wire_nlO00i_dataout WHEN niO10O = '1'  ELSE nlilli;
	wire_nllOOl_dataout <= wire_nlO00l_dataout WHEN niO10O = '1'  ELSE nlilll;
	wire_nllOOO_dataout <= wire_nlO00O_dataout WHEN niO10O = '1'  ELSE nlillO;
	wire_nlO00i_dataout <= nlilli OR NOT(nll11i);
	wire_nlO00l_dataout <= nlilll OR NOT(nll11i);
	wire_nlO00O_dataout <= nlillO OR NOT(nll11i);
	wire_nlO01i_dataout <= wire_nlOi0l_o(4) AND NOT(niO10O);
	wire_nlO01l_dataout <= wire_nlOi0l_o(5) AND NOT(niO10O);
	wire_nlO01O_dataout <= nliliO OR NOT(nll11i);
	wire_nlO0ii_dataout <= nlilOi OR NOT(nll11i);
	wire_nlO0il_dataout <= wire_nlOi1l_dataout AND nll11i;
	wire_nlO0iO_dataout <= wire_nlO0Ol_dataout WHEN nll11i = '1'  ELSE wire_nlOi1i_dataout;
	wire_nlO0li_dataout <= wire_nlO0OO_dataout WHEN nll11i = '1'  ELSE wire_n11ii_dataout;
	wire_nlO0ll_dataout <= wire_nli1O_w_lg_nlil0l570w(0) OR NOT(nll11i);
	wire_nlO0lO_dataout <= nlil0l AND nll11i;
	wire_nlO0Oi_dataout <= wire_nli1O_w_lg_nlil0l570w(0) AND nll11i;
	wire_nlO0Ol_dataout <= wire_nlOi1i_dataout AND NOT(nlil0l);
	wire_nlO0OO_dataout <= wire_n11ii_dataout OR nlil0l;
	wire_nlO10i_dataout <= wire_nlO0lO_dataout AND niO10O;
	wire_nlO10l_dataout <= wire_nlOiii_dataout AND NOT(niO10O);
	wire_nlO10O_dataout <= wire_nlOiil_dataout AND NOT(niO10O);
	wire_nlO11i_dataout <= wire_nlO0ii_dataout WHEN niO10O = '1'  ELSE nlilOi;
	wire_nlO11l_dataout <= wire_nlO0il_dataout WHEN niO10O = '1'  ELSE wire_nlOi1l_dataout;
	wire_nlO11O_dataout <= wire_nlO0li_dataout WHEN niO10O = '1'  ELSE wire_n11ii_dataout;
	wire_nlO1ii_dataout <= wire_nlO0lO_dataout WHEN niO10O = '1'  ELSE wire_nlOiiO_dataout;
	wire_nlO1il_dataout <= wire_nlO0Oi_dataout WHEN niO10O = '1'  ELSE wire_nlOili_dataout;
	wire_nlO1iO_dataout <= wire_nliOOO_w_lg_nll11i549w(0) WHEN niO10O = '1'  ELSE wire_nlOill_dataout;
	wire_nlO1li_dataout <= wire_nlO0iO_dataout WHEN niO10O = '1'  ELSE wire_nlOl0O_dataout;
	wire_nlO1ll_dataout <= wire_nlO0ll_dataout WHEN niO10O = '1'  ELSE wire_nlOilO_dataout;
	wire_nlO1lO_dataout <= wire_nlOi0l_o(0) AND NOT(niO10O);
	wire_nlO1Oi_dataout <= wire_nlOi0l_o(1) AND NOT(niO10O);
	wire_nlO1Ol_dataout <= wire_nlOi0l_o(2) AND NOT(niO10O);
	wire_nlO1OO_dataout <= wire_nlOi0l_o(3) AND NOT(niO10O);
	wire_nlOi0O_dataout <= n1i1l WHEN niO1il = '1'  ELSE wire_nlOiOi_dataout;
	wire_nlOi1i_dataout <= wire_nlOl0O_dataout AND nl0Oi;
	wire_nlOi1l_dataout <= wire_n111l_dataout OR (wire_nli1O_w_lg_nlil0l570w(0) AND (n11il AND niO1ii));
	wire_nlOiii_dataout <= nliOli WHEN niO1il = '1'  ELSE wire_nlOiOl_dataout;
	wire_nlOiil_dataout <= nliOll WHEN niO1il = '1'  ELSE wire_nlOiOO_dataout;
	wire_nlOiiO_dataout <= nliOlO WHEN niO1il = '1'  ELSE wire_nlOl1i_dataout;
	wire_nlOili_dataout <= nliOOi WHEN niO1il = '1'  ELSE wire_nlOl1l_dataout;
	wire_nlOill_dataout <= nliOOl WHEN niO1il = '1'  ELSE wire_nlOl1O_dataout;
	wire_nlOilO_dataout <= wire_nliOOO_w_lg_nll11i549w(0) OR niO1il;
	wire_nlOiOi_dataout <= n1i1l WHEN nll11i = '1'  ELSE niO1iO;
	wire_nlOiOl_dataout <= nliOli AND nll11i;
	wire_nlOiOO_dataout <= nliOll OR NOT(nll11i);
	wire_nlOl0O_dataout <= wire_n110O_dataout OR (nlil0i AND wire_nlOlil_w_lg_dataout544w(0));
	wire_nlOl1i_dataout <= nliOlO AND nll11i;
	wire_nlOl1l_dataout <= nliOOi AND nll11i;
	wire_nlOl1O_dataout <= nliOOl AND nll11i;
	wire_nlOlil_dataout <= wire_nlOliO_dataout AND nlil1O;
	wire_nlOlil_w_lg_dataout544w(0) <= NOT wire_nlOlil_dataout;
	wire_nlOliO_dataout <= nlil0i OR (nll11i AND nlil1O);
	wire_nlOlll_dataout <= wire_nlOllO_dataout AND NOT(nlil0i);
	wire_nlOllO_dataout <= nlil1O OR niO1iO;
	wire_nlOlOi_dataout <= n11iO WHEN niO1li = '1'  ELSE nliliO;
	wire_nlOlOl_dataout <= n11li WHEN niO1li = '1'  ELSE nlilli;
	wire_nlOlOO_dataout <= n11ll WHEN niO1li = '1'  ELSE nlilll;
	wire_nlOO0i_dataout <= nliOil OR niO1li;
	wire_nlOO0l_dataout <= nliOli AND NOT(niO1li);
	wire_nlOO0O_dataout <= nliOll AND NOT(niO1li);
	wire_nlOO1i_dataout <= n11lO WHEN niO1li = '1'  ELSE nlillO;
	wire_nlOO1l_dataout <= n11Ol WHEN niO1li = '1'  ELSE nlilOi;
	wire_nlOO1O_dataout <= wire_n11ii_dataout OR niO1li;
	wire_nlOOii_dataout <= nliOlO OR niO1li;
	wire_nlOOil_dataout <= nliOOi AND NOT(niO1li);
	wire_nlOOiO_dataout <= nliOOl AND NOT(niO1li);
	wire_nlOOll_dataout <= nliOli AND NOT(niO1ll);
	wire_nlOOlO_dataout <= nliOll AND NOT(niO1ll);
	wire_nlOOOi_dataout <= nliOlO AND NOT(niO1ll);
	wire_nlOOOl_dataout <= nliOOi OR niO1ll;
	wire_nlOOOO_dataout <= nliOOl AND NOT(niO1ll);
	wire_n1iii_a <= ( wire_n1iil_o(2) & wire_n1iil_w_lg_w_o_range495w496w & wire_n1iil_w_lg_w_o_range495w496w & wire_n1iil_o(1 DOWNTO 0) & "0" & "1");
	wire_n1iii_b <= ( "1" & "1" & "1" & "1" & "1" & "0" & "1");
	n1iii :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_n1iii_a,
		b => wire_n1iii_b,
		cin => wire_gnd,
		o => wire_n1iii_o
	  );
	wire_n1iil_w_lg_w_o_range495w496w(0) <= NOT wire_n1iil_w_o_range495w(0);
	wire_n1iil_a <= ( "0" & "0" & "0");
	wire_n1iil_b <= ( "0" & "0" & "1");
	wire_n1iil_w_o_range495w(0) <= wire_n1iil_o(2);
	n1iil :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_n1iil_a,
		b => wire_n1iil_b,
		cin => wire_gnd,
		o => wire_n1iil_o
	  );
	wire_nl01lO_a <= ( "0" & "0" & "0");
	wire_nl01lO_b <= ( "0" & "0" & "1");
	nl01lO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_nl01lO_a,
		b => wire_nl01lO_b,
		cin => wire_gnd,
		o => wire_nl01lO_o
	  );
	wire_nl01O_a <= ( nl0lO & nl0li & nl0iO & nl0il & nl0ii);
	wire_nl01O_b <= ( "0" & "0" & "0" & "0" & "1");
	nl01O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_nl01O_a,
		b => wire_nl01O_b,
		cin => wire_gnd,
		o => wire_nl01O_o
	  );
	wire_nl0ill_w_lg_w_lg_w_o_range858w860w863w(0) <= wire_nl0ill_w_lg_w_o_range858w860w(0) AND wire_nl0ill_w_lg_w_o_range861w862w(0);
	wire_nl0ill_w_lg_w_o_range858w860w(0) <= wire_nl0ill_w_o_range858w(0) AND wire_nl0ill_w_o_range859w(0);
	wire_nl0ill_w_lg_w_o_range861w862w(0) <= NOT wire_nl0ill_w_o_range861w(0);
	wire_nl0ill_a <= ( nl0O0O & nl0O0l & nl0O0i & "1");
	wire_nl0ill_b <= ( wire_nl0OiO_w_lg_nl0Oli963w & wire_nl0OiO_w_lg_nl0Oil961w & wire_nl0OiO_w_lg_nl0Oii959w & "1");
	wire_nl0ill_w_o_range858w(0) <= wire_nl0ill_o(1);
	wire_nl0ill_w_o_range859w(0) <= wire_nl0ill_o(2);
	wire_nl0ill_w_o_range861w(0) <= wire_nl0ill_o(3);
	nl0ill :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_nl0ill_a,
		b => wire_nl0ill_b,
		cin => wire_gnd,
		o => wire_nl0ill_o
	  );
	wire_nl1l0O_a <= ( nl1iii & nl1i0O & nl1i0l & nl1i0i & nl1i1O & nl1O1i);
	wire_nl1l0O_b <= ( "0" & "0" & "0" & "0" & "0" & "1");
	nl1l0O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_nl1l0O_a,
		b => wire_nl1l0O_b,
		cin => wire_gnd,
		o => wire_nl1l0O_o
	  );
	wire_nl1ll_a <= ( wire_nl111i22_w_lg_w_lg_q183w184w & wire_nl01i_dataout & wire_nl1OO_dataout & wire_nl1Ol_dataout & wire_nl1Oi_dataout);
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
	wire_nli10O_a <= ( "0" & nl0O0O & nl0O0l & nl0O0i);
	wire_nli10O_b <= ( "0" & "0" & "0" & "1");
	nli10O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_nli10O_a,
		b => wire_nli10O_b,
		cin => wire_gnd,
		o => wire_nli10O_o
	  );
	wire_nli1iO_a <= ( "0" & nl0Oli & nl0Oil & nl0Oii);
	wire_nli1iO_b <= ( "0" & "0" & "0" & "1");
	nli1iO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_nli1iO_a,
		b => wire_nli1iO_b,
		cin => wire_gnd,
		o => wire_nli1iO_o
	  );
	wire_nlOi0l_a <= ( nliOii & nliO0l & nliO0i & nliO1O & nliO1l & nliO1i);
	wire_nlOi0l_b <= ( "0" & "0" & "0" & "0" & "0" & "1");
	nlOi0l :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_nlOi0l_a,
		b => wire_nlOi0l_b,
		cin => wire_gnd,
		o => wire_nlOi0l_o
	  );
	wire_nl1lli_i(0) <= ( nl1iil);
	nl1lli :  oper_decoder
	  GENERIC MAP (
		width_i => 1,
		width_o => 2
	  )
	  PORT MAP ( 
		i => wire_nl1lli_i,
		o => wire_nl1lli_o
	  );
	wire_nll00i_data <= ( wire_nlOOOi_dataout & wire_nlOOii_dataout & wire_nlllOl_dataout & wire_nlliOl_dataout & wire_nlli0i_dataout);
	wire_nll00i_sel <= ( nliOOl & nliOOi & nliOlO & nliOll & nliOli);
	nll00i :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nll00i_data,
		o => wire_nll00i_o,
		sel => wire_nll00i_sel
	  );
	wire_nll00l_data <= ( wire_nlOOOl_dataout & wire_nlOOil_dataout & wire_nlllOO_dataout & wire_nlliOO_dataout & wire_nlli0l_dataout);
	wire_nll00l_sel <= ( nliOOl & nliOOi & nliOlO & nliOll & nliOli);
	nll00l :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nll00l_data,
		o => wire_nll00l_o,
		sel => wire_nll00l_sel
	  );
	wire_nll00O_data <= ( wire_nlOOOO_dataout & wire_nlOOiO_dataout & wire_nllO1i_dataout & wire_nlll1i_dataout & wire_nlli0O_dataout);
	wire_nll00O_sel <= ( nliOOl & nliOOi & nliOlO & nliOll & nliOli);
	nll00O :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nll00O_data,
		o => wire_nll00O_o,
		sel => wire_nll00O_sel
	  );
	wire_nll01i_w_lg_o790w(0) <= NOT wire_nll01i_o;
	wire_nll01i_data <= ( nliOiO & wire_w_lg_niO1li650w & wire_nllO0i_dataout & "1" & wire_nlliii_dataout);
	wire_nll01i_sel <= ( nliOOl & nliOOi & nliOlO & nliOll & nliOli);
	nll01i :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nll01i_data,
		o => wire_nll01i_o,
		sel => wire_nll01i_sel
	  );
	wire_nll01l_data <= ( wire_nlOOll_dataout & wire_nlOO0l_dataout & wire_nllllO_dataout & wire_nllilO_dataout & wire_nlli1l_dataout);
	wire_nll01l_sel <= ( nliOOl & nliOOi & nliOlO & nliOll & nliOli);
	nll01l :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nll01l_data,
		o => wire_nll01l_o,
		sel => wire_nll01l_sel
	  );
	wire_nll01O_data <= ( wire_nlOOlO_dataout & wire_nlOO0O_dataout & wire_nlllOi_dataout & wire_nlliOi_dataout & wire_nlli1O_dataout);
	wire_nll01O_sel <= ( nliOOl & nliOOi & nliOlO & nliOll & nliOli);
	nll01O :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nll01O_data,
		o => wire_nll01O_o,
		sel => wire_nll01O_sel
	  );
	wire_nll0ii_data <= ( wire_nllO1O_dataout & wire_n110O_dataout);
	wire_nll0ii_sel <= ( nliOlO & wire_nli1O_w_lg_nliOlO653w);
	nll0ii :  oper_selector
	  GENERIC MAP (
		width_data => 2,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_nll0ii_data,
		o => wire_nll0ii_o,
		sel => wire_nll0ii_sel
	  );
	wire_nll0il_data <= ( niO1ll & wire_w_lg_niO1li650w & wire_nllO0l_dataout & "0" & wire_n111l_dataout);
	wire_nll0il_sel <= ( nliOOl & nliOOi & nliOlO & nliOll & nliOli);
	nll0il :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nll0il_data,
		o => wire_nll0il_o,
		sel => wire_nll0il_sel
	  );
	wire_nll0iO_data <= ( "1" & wire_nlOlOi_dataout & wire_nlll0l_dataout & nliliO);
	wire_nll0iO_sel <= ( nliOOl & nliOOi & nliOlO & niO11O);
	nll0iO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0iO_data,
		o => wire_nll0iO_o,
		sel => wire_nll0iO_sel
	  );
	wire_nll0li_data <= ( "1" & wire_nlOlOl_dataout & wire_nlll0O_dataout & nlilli);
	wire_nll0li_sel <= ( nliOOl & nliOOi & nliOlO & niO11O);
	nll0li :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0li_data,
		o => wire_nll0li_o,
		sel => wire_nll0li_sel
	  );
	wire_nll0ll_data <= ( "1" & wire_nlOlOO_dataout & wire_nlllii_dataout & nlilll);
	wire_nll0ll_sel <= ( nliOOl & nliOOi & nliOlO & niO11O);
	nll0ll :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0ll_data,
		o => wire_nll0ll_o,
		sel => wire_nll0ll_sel
	  );
	wire_nll0lO_data <= ( "1" & wire_nlOO1i_dataout & wire_nlllil_dataout & nlillO);
	wire_nll0lO_sel <= ( nliOOl & nliOOi & nliOlO & niO11O);
	nll0lO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0lO_data,
		o => wire_nll0lO_o,
		sel => wire_nll0lO_sel
	  );
	wire_nll0Oi_data <= ( "1" & wire_nlOO1l_dataout & wire_nllliO_dataout & nlilOi);
	wire_nll0Oi_sel <= ( nliOOl & nliOOi & nliOlO & niO11O);
	nll0Oi :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll0Oi_data,
		o => wire_nll0Oi_o,
		sel => wire_nll0Oi_sel
	  );
	wire_nll10i_data <= ( nlilil & wire_nlll1l_dataout & wire_nlliil_dataout);
	wire_nll10i_sel <= ( wire_nliOl_w_lg_w_lg_nliOOl754w784w & nliOll & nliOli);
	nll10i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nll10i_data,
		o => wire_nll10i_o,
		sel => wire_nll10i_sel
	  );
	wire_nll1ii_data <= ( n1i1l & wire_nlOi0O_dataout & wire_nlli1i_dataout);
	wire_nll1ii_sel <= ( wire_nliOl_w_lg_w_lg_nliOOl754w775w & nliOlO & nliOli);
	nll1ii :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nll1ii_data,
		o => wire_nll1ii_o,
		sel => wire_nll1ii_sel
	  );
	wire_nll1iO_data <= ( nlil0i & wire_nlOlil_dataout & "0" & wire_nll0OO_dataout);
	wire_nll1iO_sel <= ( wire_nliOl_w_lg_nliOOl754w & nliOlO & nliOll & nliOli);
	nll1iO :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nll1iO_data,
		o => wire_nll1iO_o,
		sel => wire_nll1iO_sel
	  );
	wire_nll1ll_data <= ( nlil1O & wire_nlOlll_dataout & wire_nlll0i_dataout);
	wire_nll1ll_sel <= ( wire_nliOl_w_lg_w_lg_nliOOl754w755w & nliOlO & nliOll);
	nll1ll :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nll1ll_data,
		o => wire_nll1ll_o,
		sel => wire_nll1ll_sel
	  );
	wire_nll1Oi_data <= ( wire_n11ii_dataout & wire_nlOO1O_dataout & wire_nlllli_dataout);
	wire_nll1Oi_sel <= ( niO11l & nliOOi & nliOlO);
	nll1Oi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nll1Oi_data,
		o => wire_nll1Oi_o,
		sel => wire_nll1Oi_sel
	  );
	wire_nll1Ol_data <= ( nliOil & wire_nlOO0i_dataout & wire_nlllll_dataout);
	wire_nll1Ol_sel <= ( niO11l & nliOOi & nliOlO);
	nll1Ol :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nll1Ol_data,
		o => wire_nll1Ol_o,
		sel => wire_nll1Ol_sel
	  );

 END RTL; --mastertx_example
--synopsys translate_on
--VALID FILE
