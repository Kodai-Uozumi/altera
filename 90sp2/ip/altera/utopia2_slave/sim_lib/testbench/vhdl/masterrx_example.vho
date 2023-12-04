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

--synthesis_resources = altsyncram 2 lpm_decode 1 lpm_ff 31 lut 173 mux21 258 oper_add 10 oper_decoder 2 oper_selector 17 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  masterrx_example IS 
	 PORT 
	 ( 
		 atm_rx_data	:	OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 atm_rx_enb	:	IN  STD_LOGIC;
		 atm_rx_port	:	IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 atm_rx_port_load	:	IN  STD_LOGIC;
		 atm_rx_port_stat	:	OUT  STD_LOGIC_VECTOR (30 DOWNTO 0);
		 atm_rx_port_wait	:	OUT  STD_LOGIC;
		 atm_rx_soc	:	OUT  STD_LOGIC;
		 atm_rx_valid	:	OUT  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 rx_addr	:	OUT  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 rx_cell_err_pulse	:	OUT  STD_LOGIC;
		 rx_cell_pulse	:	OUT  STD_LOGIC;
		 rx_clav	:	IN  STD_LOGIC;
		 rx_clk_in	:	IN  STD_LOGIC;
		 rx_data	:	IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 rx_enb	:	OUT  STD_LOGIC;
		 rx_prty	:	IN  STD_LOGIC;
		 rx_prty_pulse	:	OUT  STD_LOGIC;
		 rx_soc	:	IN  STD_LOGIC
	 ); 
 END masterrx_example;

 ARCHITECTURE RTL OF masterrx_example IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL  wire_nl0lOl_address_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0lOl_address_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0lOl_data_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0lOl_q_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nlO1O_address_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO1O_address_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO1O_clock1	:	STD_LOGIC;
	 SIGNAL  wire_nlO1O_data_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL	 niOO0i55	:	STD_LOGIC := '0';
	 SIGNAL	 niOO0i56	:	STD_LOGIC := '0';
	 SIGNAL	 niOO0l53	:	STD_LOGIC := '0';
	 SIGNAL	 niOO0l54	:	STD_LOGIC := '0';
	 SIGNAL	 niOO0O51	:	STD_LOGIC := '0';
	 SIGNAL	 niOO0O52	:	STD_LOGIC := '0';
	 SIGNAL	 niOOii49	:	STD_LOGIC := '0';
	 SIGNAL	 niOOii50	:	STD_LOGIC := '0';
	 SIGNAL	 nl010l11	:	STD_LOGIC := '0';
	 SIGNAL	 nl010l12	:	STD_LOGIC := '0';
	 SIGNAL	 nl01il10	:	STD_LOGIC := '0';
	 SIGNAL	 nl01il9	:	STD_LOGIC := '0';
	 SIGNAL	 nl01li7	:	STD_LOGIC := '0';
	 SIGNAL	 nl01li8	:	STD_LOGIC := '0';
	 SIGNAL	 nl01ll5	:	STD_LOGIC := '0';
	 SIGNAL	 nl01ll6	:	STD_LOGIC := '0';
	 SIGNAL	 nl01Oi3	:	STD_LOGIC := '0';
	 SIGNAL	 nl01Oi4	:	STD_LOGIC := '0';
	 SIGNAL	 nl01OO1	:	STD_LOGIC := '0';
	 SIGNAL	 nl01OO2	:	STD_LOGIC := '0';
	 SIGNAL	 nl100l35	:	STD_LOGIC := '0';
	 SIGNAL	 nl100l36	:	STD_LOGIC := '0';
	 SIGNAL	 nl101i39	:	STD_LOGIC := '0';
	 SIGNAL	 nl101i40	:	STD_LOGIC := '0';
	 SIGNAL	 nl101O37	:	STD_LOGIC := '0';
	 SIGNAL	 nl101O38	:	STD_LOGIC := '0';
	 SIGNAL	 nl10ii33	:	STD_LOGIC := '0';
	 SIGNAL	 nl10ii34	:	STD_LOGIC := '0';
	 SIGNAL	 nl10iO31	:	STD_LOGIC := '0';
	 SIGNAL	 nl10iO32	:	STD_LOGIC := '0';
	 SIGNAL	 nl10ll29	:	STD_LOGIC := '0';
	 SIGNAL	 nl10ll30	:	STD_LOGIC := '0';
	 SIGNAL	 nl10Oi27	:	STD_LOGIC := '0';
	 SIGNAL	 nl10Oi28	:	STD_LOGIC := '0';
	 SIGNAL	 nl10OO25	:	STD_LOGIC := '0';
	 SIGNAL	 nl10OO26	:	STD_LOGIC := '0';
	 SIGNAL	 nl11il47	:	STD_LOGIC := '0';
	 SIGNAL	 nl11il48	:	STD_LOGIC := '0';
	 SIGNAL	 nl11li45	:	STD_LOGIC := '0';
	 SIGNAL	 nl11li46	:	STD_LOGIC := '0';
	 SIGNAL	 nl11lO43	:	STD_LOGIC := '0';
	 SIGNAL	 nl11lO44	:	STD_LOGIC := '0';
	 SIGNAL	 nl11Ol41	:	STD_LOGIC := '0';
	 SIGNAL	 nl11Ol42	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i0i21	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i0i22	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i0O19	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i0O20	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i1l23	:	STD_LOGIC := '0';
	 SIGNAL	 nl1i1l24	:	STD_LOGIC := '0';
	 SIGNAL	 nl1iiO17	:	STD_LOGIC := '0';
	 SIGNAL	 nl1iiO18	:	STD_LOGIC := '0';
	 SIGNAL	 nl1ill15	:	STD_LOGIC := '0';
	 SIGNAL	 nl1ill16	:	STD_LOGIC := '0';
	 SIGNAL	 nl1OOO13	:	STD_LOGIC := '0';
	 SIGNAL	 nl1OOO14	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl1OOO14_w_lg_w_lg_q162w163w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1OOO14_w_lg_q162w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n11iO	:	STD_LOGIC := '0';
	 SIGNAL	n11li	:	STD_LOGIC := '0';
	 SIGNAL	n11ll	:	STD_LOGIC := '0';
	 SIGNAL	n11lO	:	STD_LOGIC := '0';
	 SIGNAL	n11Ol	:	STD_LOGIC := '0';
	 SIGNAL	wire_n11Oi_PRN	:	STD_LOGIC;
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w321w370w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w314w362w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO316w317w318w366w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w297w335w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w321w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w349w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w314w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w342w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w329w356w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO305w306w337w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO305w326w354w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w317w318w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w317w347w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w332w358w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w297w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w320w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w313w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w329w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO305w306w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO305w326w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO316w317w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO316w332w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO186w295w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_w_lg_n11iO186w312w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11iO305w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11iO316w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11iO186w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11li294w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11ll296w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11lO298w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n11Oi_w_lg_n11Ol300w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl0iO	:	STD_LOGIC := '0';
	 SIGNAL	nl0li	:	STD_LOGIC := '0';
	 SIGNAL	nl0ll	:	STD_LOGIC := '0';
	 SIGNAL	nl0lO	:	STD_LOGIC := '0';
	 SIGNAL	nl0Ol	:	STD_LOGIC := '0';
	 SIGNAL  wire_nl0Oi_w_lg_nl0iO255w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0Oi_w_lg_nl0li254w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0Oi_w_lg_nl0ll256w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0Oi_w_lg_nl0lO258w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0Oi_w_lg_nl0Ol260w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n100l	:	STD_LOGIC := '0';
	 SIGNAL	n10il	:	STD_LOGIC := '0';
	 SIGNAL	n10iO	:	STD_LOGIC := '0';
	 SIGNAL	n10li	:	STD_LOGIC := '0';
	 SIGNAL	n10ll	:	STD_LOGIC := '0';
	 SIGNAL	n10lO	:	STD_LOGIC := '0';
	 SIGNAL	n10Oi	:	STD_LOGIC := '0';
	 SIGNAL	n10Ol	:	STD_LOGIC := '0';
	 SIGNAL	n10OO	:	STD_LOGIC := '0';
	 SIGNAL	n11ii	:	STD_LOGIC := '0';
	 SIGNAL	n11il	:	STD_LOGIC := '0';
	 SIGNAL	n11OO	:	STD_LOGIC := '0';
	 SIGNAL	n1i0i	:	STD_LOGIC := '0';
	 SIGNAL	n1i0l	:	STD_LOGIC := '0';
	 SIGNAL	n1i0O	:	STD_LOGIC := '0';
	 SIGNAL	n1i1i	:	STD_LOGIC := '0';
	 SIGNAL	n1i1l	:	STD_LOGIC := '0';
	 SIGNAL	n1i1O	:	STD_LOGIC := '0';
	 SIGNAL	n1iii	:	STD_LOGIC := '0';
	 SIGNAL	n1iil	:	STD_LOGIC := '0';
	 SIGNAL	n1iiO	:	STD_LOGIC := '0';
	 SIGNAL	niilO	:	STD_LOGIC := '0';
	 SIGNAL	nl00li	:	STD_LOGIC := '0';
	 SIGNAL	nl00ll	:	STD_LOGIC := '0';
	 SIGNAL	nl00lO	:	STD_LOGIC := '0';
	 SIGNAL	nl00Oi	:	STD_LOGIC := '0';
	 SIGNAL	nl00Ol	:	STD_LOGIC := '0';
	 SIGNAL	nl00OO	:	STD_LOGIC := '0';
	 SIGNAL	nl0lii	:	STD_LOGIC := '0';
	 SIGNAL	nl0lil	:	STD_LOGIC := '0';
	 SIGNAL	nli0l	:	STD_LOGIC := '0';
	 SIGNAL	nli1O	:	STD_LOGIC := '0';
	 SIGNAL	nlii0i	:	STD_LOGIC := '0';
	 SIGNAL	nlii0l	:	STD_LOGIC := '0';
	 SIGNAL	nlii0O	:	STD_LOGIC := '0';
	 SIGNAL	nliiii	:	STD_LOGIC := '0';
	 SIGNAL	nliO1l	:	STD_LOGIC := '0';
	 SIGNAL	nll00i	:	STD_LOGIC := '0';
	 SIGNAL	nll01i	:	STD_LOGIC := '0';
	 SIGNAL	nll01l	:	STD_LOGIC := '0';
	 SIGNAL	nll01O	:	STD_LOGIC := '0';
	 SIGNAL	nll0li	:	STD_LOGIC := '0';
	 SIGNAL	nll0ll	:	STD_LOGIC := '0';
	 SIGNAL	nll0Oi	:	STD_LOGIC := '0';
	 SIGNAL	nll0Ol	:	STD_LOGIC := '0';
	 SIGNAL	nll0OO	:	STD_LOGIC := '0';
	 SIGNAL	nll1Ol	:	STD_LOGIC := '0';
	 SIGNAL	nll1OO	:	STD_LOGIC := '0';
	 SIGNAL	nlli0i	:	STD_LOGIC := '0';
	 SIGNAL	nlli0l	:	STD_LOGIC := '0';
	 SIGNAL	nlli0O	:	STD_LOGIC := '0';
	 SIGNAL	nlli1i	:	STD_LOGIC := '0';
	 SIGNAL	nlli1l	:	STD_LOGIC := '0';
	 SIGNAL	nlli1O	:	STD_LOGIC := '0';
	 SIGNAL	nlliii	:	STD_LOGIC := '0';
	 SIGNAL	nlliil	:	STD_LOGIC := '0';
	 SIGNAL	nllili	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli0i_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_nli0i_w_lg_nl0lil984w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_n10il530w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_n11il569w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nl00li1030w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nl0lil982w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nlii0i945w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nlii0l867w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nlii0O868w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nliiii870w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nliO1l566w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nll01l195w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nll0ll194w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nll0Oi783w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nll0Ol781w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nll0OO779w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nlli1i777w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nlli1l775w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0i_w_lg_nlli1O774w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nli1l	:	STD_LOGIC := '0';
	 SIGNAL	wire_nli1i_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nli1i_w_lg_nli1l187w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nli0OO	:	STD_LOGIC := '0';
	 SIGNAL	nlii1i	:	STD_LOGIC := '0';
	 SIGNAL	nlii1O	:	STD_LOGIC := '0';
	 SIGNAL	wire_nlii1l_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_nlii1l_PRN	:	STD_LOGIC;
	 SIGNAL	nliiil	:	STD_LOGIC := '0';
	 SIGNAL	nliiiO	:	STD_LOGIC := '0';
	 SIGNAL	nliill	:	STD_LOGIC := '0';
	 SIGNAL	wire_nliili_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_nliili_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nliili_w_lg_w_lg_nliiil865w866w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliili_w_lg_nliiil865w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliili_w_lg_nliiil939w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliili_w_lg_nliiiO941w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliili_w_lg_nliill943w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nli00i	:	STD_LOGIC := '0';
	 SIGNAL	nli00l	:	STD_LOGIC := '0';
	 SIGNAL	nli00O	:	STD_LOGIC := '0';
	 SIGNAL	nli01i	:	STD_LOGIC := '0';
	 SIGNAL	nli01l	:	STD_LOGIC := '0';
	 SIGNAL	nli01O	:	STD_LOGIC := '0';
	 SIGNAL	nli0ii	:	STD_LOGIC := '0';
	 SIGNAL	nli0il	:	STD_LOGIC := '0';
	 SIGNAL	nli0iO	:	STD_LOGIC := '0';
	 SIGNAL	nli0li	:	STD_LOGIC := '0';
	 SIGNAL	nli0ll	:	STD_LOGIC := '0';
	 SIGNAL	nli0lO	:	STD_LOGIC := '0';
	 SIGNAL	nli0Oi	:	STD_LOGIC := '0';
	 SIGNAL	nli0Ol	:	STD_LOGIC := '0';
	 SIGNAL	nli1OO	:	STD_LOGIC := '0';
	 SIGNAL	nlil0l	:	STD_LOGIC := '0';
	 SIGNAL	n100O	:	STD_LOGIC := '0';
	 SIGNAL	n10ii	:	STD_LOGIC := '0';
	 SIGNAL	ni11O	:	STD_LOGIC := '0';
	 SIGNAL	niiil	:	STD_LOGIC := '0';
	 SIGNAL	niiiO	:	STD_LOGIC := '0';
	 SIGNAL	niili	:	STD_LOGIC := '0';
	 SIGNAL	niill	:	STD_LOGIC := '0';
	 SIGNAL	nl0i1i	:	STD_LOGIC := '0';
	 SIGNAL	nl0OO	:	STD_LOGIC := '0';
	 SIGNAL	nli0O	:	STD_LOGIC := '0';
	 SIGNAL	nliii	:	STD_LOGIC := '0';
	 SIGNAL	nliil	:	STD_LOGIC := '0';
	 SIGNAL	nliilO	:	STD_LOGIC := '0';
	 SIGNAL	nliiO	:	STD_LOGIC := '0';
	 SIGNAL	nlili	:	STD_LOGIC := '0';
	 SIGNAL	nlill	:	STD_LOGIC := '0';
	 SIGNAL	nlilO	:	STD_LOGIC := '0';
	 SIGNAL	nliOi	:	STD_LOGIC := '0';
	 SIGNAL	nliOl	:	STD_LOGIC := '0';
	 SIGNAL	nll00l	:	STD_LOGIC := '0';
	 SIGNAL	nll00O	:	STD_LOGIC := '0';
	 SIGNAL	nll0ii	:	STD_LOGIC := '0';
	 SIGNAL	nll0il	:	STD_LOGIC := '0';
	 SIGNAL	nll0iO	:	STD_LOGIC := '0';
	 SIGNAL	nll0lO	:	STD_LOGIC := '0';
	 SIGNAL	nll1i	:	STD_LOGIC := '0';
	 SIGNAL	nlliiO	:	STD_LOGIC := '0';
	 SIGNAL	wire_nliOO_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_nliOO_w_lg_n100O528w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO_w_lg_nl0OO126w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO_w_lg_nliilO848w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO_w_lg_w_lg_nlliiO732w733w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO_w_lg_w_lg_nlliiO624w743w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO_w_lg_w_lg_nlliiO624w625w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO_w_lg_w_lg_nlliiO624w752w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO_w_lg_nlliiO732w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nliOO_w_lg_nlliiO624w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ilO_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_vcc	:	STD_LOGIC;
	 SIGNAL  wire_n1ilO_eq	:	STD_LOGIC_VECTOR (31 DOWNTO 0);
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
	 SIGNAL  wire_n1Oll_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1Oll_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1Oll_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1OlO_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1OlO_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1OlO_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1OOi_aclr	:	STD_LOGIC;
	 SIGNAL  wire_n1OOi_data	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1OOi_q	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
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
	 SIGNAL	wire_n0OlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n100i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n101O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n110l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n111O_dataout	:	STD_LOGIC;
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
	 SIGNAL	wire_ni10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11l_dataout	:	STD_LOGIC;
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
	 SIGNAL	wire_nii0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nii1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiii_dataout	:	STD_LOGIC;
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
	 SIGNAL	wire_nl00i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl00i_w_lg_dataout283w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl01i_w_lg_dataout289w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl01l_w_lg_dataout287w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl01O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl01O_w_lg_dataout285w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nl0i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0i1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0l1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oll_dataout	:	STD_LOGIC;
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
	 SIGNAL	wire_nl1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1OO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nl1OO_w_lg_dataout284w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nli10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlil1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllOO_dataout	:	STD_LOGIC;
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
	 SIGNAL	wire_nlO0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ll_dataout	:	STD_LOGIC;
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
	 SIGNAL	wire_nlOiiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOliO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOllO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlOOii_w_lg_dataout846w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOOii_w_lg_dataout833w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlOOiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOli_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOOO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n1ili_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1ili_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1ili_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1ill_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n1ill_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_n1ill_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl00l_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl00l_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl00l_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl0iOl_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl0iOl_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl0iOl_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nl0liO_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0liO_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl0liO_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nl1Oi_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl1Oi_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nl1Oi_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_w_lg_w_lg_w_o_range834w843w844w845w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_w_lg_w_o_range834w843w844w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_w_o_range834w837w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_w_o_range834w843w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_lg_w_o_range835w836w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nli1ll_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nli1ll_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_o_range834w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_o_range835w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1ll_w_o_range838w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlilii_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlilii_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlilii_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlilli_a	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlilli_b	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlilli_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOO1i_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlOO1i_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlOO1i_o	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlOl1O_w_lg_w_lg_w_o_range460w462w463w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOl1O_w_lg_w_o_range460w462w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOl1O_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nlOl1O_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlOl1O_w_o_range460w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOl1O_w_o_range461w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOOil_i	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlOOil_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nllill_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nllill_o	:	STD_LOGIC;
	 SIGNAL  wire_nllill_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlliOi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlliOi_o	:	STD_LOGIC;
	 SIGNAL  wire_nlliOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlliOO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlliOO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlliOO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlll0i_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll0i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlll0i_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll0l_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll0l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlll0l_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll0O_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll0O_o	:	STD_LOGIC;
	 SIGNAL  wire_nlll0O_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll1l_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlll1l_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll1O_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlll1O_o	:	STD_LOGIC;
	 SIGNAL  wire_nlll1O_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlllii_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlllii_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllii_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlllil_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlllil_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllil_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nllliO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nllliO_o	:	STD_LOGIC;
	 SIGNAL  wire_nllliO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlllli_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlllli_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllli_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nllllO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nllllO_o	:	STD_LOGIC;
	 SIGNAL  wire_nllllO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlllOi_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlllOi_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlllOl_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlllOl_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllOl_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlllOO_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlllOO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlllOO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nllO1i_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nllO1i_o	:	STD_LOGIC;
	 SIGNAL  wire_nllO1i_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_atm_rx_enb985w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_niOOli842w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_niOOOl573w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_niOOOO570w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl01Ol160w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl110l533w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl110O532w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl111O639w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl11iO527w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset384w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_rx_clk_in104w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  niOO1l :	STD_LOGIC;
	 SIGNAL  niOO1O :	STD_LOGIC;
	 SIGNAL  niOOil :	STD_LOGIC;
	 SIGNAL  niOOiO :	STD_LOGIC;
	 SIGNAL  niOOli :	STD_LOGIC;
	 SIGNAL  niOOll :	STD_LOGIC;
	 SIGNAL  niOOlO :	STD_LOGIC;
	 SIGNAL  niOOOi :	STD_LOGIC;
	 SIGNAL  niOOOl :	STD_LOGIC;
	 SIGNAL  niOOOO :	STD_LOGIC;
	 SIGNAL  nl010i :	STD_LOGIC;
	 SIGNAL  nl011i :	STD_LOGIC;
	 SIGNAL  nl011l :	STD_LOGIC;
	 SIGNAL  nl011O :	STD_LOGIC;
	 SIGNAL  nl01ii :	STD_LOGIC;
	 SIGNAL  nl01lO :	STD_LOGIC;
	 SIGNAL  nl01Ol :	STD_LOGIC;
	 SIGNAL  nl110i :	STD_LOGIC;
	 SIGNAL  nl110l :	STD_LOGIC;
	 SIGNAL  nl110O :	STD_LOGIC;
	 SIGNAL  nl111i :	STD_LOGIC;
	 SIGNAL  nl111l :	STD_LOGIC;
	 SIGNAL  nl111O :	STD_LOGIC;
	 SIGNAL  nl11ii :	STD_LOGIC;
	 SIGNAL  nl11iO :	STD_LOGIC;
	 SIGNAL  nl1iil :	STD_LOGIC;
	 SIGNAL  nl1iOi :	STD_LOGIC;
	 SIGNAL  nl1iOl :	STD_LOGIC;
	 SIGNAL  nl1iOO :	STD_LOGIC;
	 SIGNAL  nl1l0i :	STD_LOGIC;
	 SIGNAL  nl1l0l :	STD_LOGIC;
	 SIGNAL  nl1l0O :	STD_LOGIC;
	 SIGNAL  nl1l1i :	STD_LOGIC;
	 SIGNAL  nl1l1l :	STD_LOGIC;
	 SIGNAL  nl1l1O :	STD_LOGIC;
	 SIGNAL  nl1lii :	STD_LOGIC;
	 SIGNAL  nl1lil :	STD_LOGIC;
	 SIGNAL  nl1liO :	STD_LOGIC;
	 SIGNAL  nl1lli :	STD_LOGIC;
	 SIGNAL  nl1lll :	STD_LOGIC;
	 SIGNAL  nl1llO :	STD_LOGIC;
	 SIGNAL  nl1lOi :	STD_LOGIC;
	 SIGNAL  nl1lOl :	STD_LOGIC;
	 SIGNAL  nl1lOO :	STD_LOGIC;
	 SIGNAL  nl1O0i :	STD_LOGIC;
	 SIGNAL  nl1O0l :	STD_LOGIC;
	 SIGNAL  nl1O0O :	STD_LOGIC;
	 SIGNAL  nl1O1i :	STD_LOGIC;
	 SIGNAL  nl1O1l :	STD_LOGIC;
	 SIGNAL  nl1O1O :	STD_LOGIC;
	 SIGNAL  nl1Oii :	STD_LOGIC;
	 SIGNAL  nl1Oil :	STD_LOGIC;
	 SIGNAL  nl1OiO :	STD_LOGIC;
	 SIGNAL  nl1Oli :	STD_LOGIC;
	 SIGNAL  nl1Oll :	STD_LOGIC;
	 SIGNAL  nl1OlO :	STD_LOGIC;
	 SIGNAL  nl1OOi :	STD_LOGIC;
	 SIGNAL  nl1OOl :	STD_LOGIC;
 BEGIN

	wire_gnd <= '0';
	wire_vcc <= '1';
	wire_w_lg_atm_rx_enb985w(0) <= atm_rx_enb AND wire_nli0i_w_lg_nl0lil984w(0);
	wire_w_lg_niOOli842w(0) <= NOT niOOli;
	wire_w_lg_niOOOl573w(0) <= NOT niOOOl;
	wire_w_lg_niOOOO570w(0) <= NOT niOOOO;
	wire_w_lg_nl01Ol160w(0) <= NOT nl01Ol;
	wire_w_lg_nl110l533w(0) <= NOT nl110l;
	wire_w_lg_nl110O532w(0) <= NOT nl110O;
	wire_w_lg_nl111O639w(0) <= NOT nl111O;
	wire_w_lg_nl11iO527w(0) <= NOT nl11iO;
	wire_w_lg_reset384w(0) <= NOT reset;
	wire_w_lg_rx_clk_in104w(0) <= NOT rx_clk_in;
	atm_rx_data <= ( wire_nli1li_dataout & wire_nli1iO_dataout & wire_nli1il_dataout & wire_nli1ii_dataout & wire_nli10O_dataout & wire_nli10l_dataout & wire_nli10i_dataout & wire_nli11O_dataout & wire_nli11l_dataout & wire_nli11i_dataout & wire_nl0OOO_dataout & wire_nl0OOl_dataout & wire_nl0OOi_dataout & wire_nl0OlO_dataout & wire_nl0Oll_dataout & wire_nl0Oli_dataout);
	atm_rx_port_stat <= ( wire_n1OOi_q(0) & wire_n1OlO_q(0) & wire_n1Oll_q(0) & wire_n1Oli_q(0) & wire_n1OiO_q(0) & wire_n1Oil_q(0) & wire_n1Oii_q(0) & wire_n1O0O_q(0) & wire_n1O0l_q(0) & wire_n1O0i_q(0) & wire_n1O1O_q(0) & wire_n1O1l_q(0) & wire_n1O1i_q(0) & wire_n1lOO_q(0) & wire_n1lOl_q(0) & wire_n1lOi_q(0) & wire_n1llO_q(0) & wire_n1lll_q(0) & wire_n1lli_q(0) & wire_n1liO_q(0) & wire_n1lil_q(0) & wire_n1lii_q(0) & wire_n1l0O_q(0) & wire_n1l0l_q(0) & wire_n1l0i_q(0) & wire_n1l1O_q(0) & wire_n1l1l_q(0) & wire_n1l1i_q(0) & wire_n1iOO_q(0) & wire_n1iOl_q(0) & wire_n1iOi_q(0));
	atm_rx_port_wait <= n11il;
	atm_rx_soc <= nl0lii;
	atm_rx_valid <= nl0lil;
	niOO1l <= (((((wire_nli0i_w_lg_nl00li1030w(0) AND (NOT (nl00ll XOR wire_nl0liO_o(0)))) AND (NOT (nl00lO XOR wire_nl0liO_o(1)))) AND (NOT (nl00Oi XOR (NOT wire_nl0liO_o(2))))) AND (NOT ((NOT wire_nl0liO_o(2)) XOR nl00Ol))) AND (NOT (wire_nl0liO_o(2) XOR nl00OO)));
	niOO1O <= (nl0lil AND atm_rx_enb);
	niOOil <= ((((NOT (nliiil XOR wire_nlilii_o(0))) AND (NOT (nliiiO XOR wire_nlilii_o(1)))) AND (NOT (nliill XOR wire_nlilii_o(2)))) AND (NOT wire_nlilii_o(3)));
	niOOiO <= (wire_nliOO_w_lg_nliilO848w(0) AND niOOli);
	niOOli <= ((wire_nli0i_w_lg_nl0lil982w(0) AND wire_nliOO_w_lg_nliilO848w(0)) OR wire_w_lg_atm_rx_enb985w(0));
	niOOll <= ((nlliii OR nlli0O) OR nlli0l);
	niOOlO <= (nli0l AND wire_nli0i_w_lg_nliO1l566w(0));
	niOOOi <= ((((((NOT wire_n1ill_o(0)) AND (NOT (wire_n1ili_o(0) XOR wire_n1ill_o(1)))) AND (NOT (wire_n1ili_o(1) XOR wire_n1ill_o(2)))) AND (NOT ((NOT wire_n1ili_o(2)) XOR wire_n1ill_o(3)))) AND (NOT ((NOT wire_n1ili_o(2)) XOR wire_n1ill_o(4)))) AND (NOT (wire_n1ili_o(2) XOR wire_n1ill_o(5))));
	niOOOl <= (n11il AND wire_nli0i_w_lg_nliO1l566w(0));
	niOOOO <= (((((NOT (nll00l XOR n11iO)) AND (NOT (nll00O XOR n11li))) AND (NOT (nll0ii XOR n11ll))) AND (NOT (nll0il XOR n11lO))) AND (NOT (nll0iO XOR n11Ol)));
	nl010i <= ((NOT ((nl01Ol OR nll0ll) OR (NOT (nl01il10 XOR nl01il9)))) OR ((nll0ll AND nl01ii) AND (nl010l12 XOR nl010l11)));
	nl011i <= (wire_w_lg_nl01Ol160w(0) AND nl011l);
	nl011l <= (((((NOT (nll00l XOR wire_nl1OO_dataout)) AND (NOT (nll00O XOR wire_nl01i_dataout))) AND (NOT (nll0ii XOR wire_nl01l_dataout))) AND (NOT (nll0il XOR wire_nl01O_dataout))) AND (NOT ((nll0iO XOR wire_nl00i_dataout) XOR (NOT (nl10OO26 XOR nl10OO25)))));
	nl011O <= ((((wire_nl0Oi_w_lg_nl0iO255w(0) AND wire_nl0Oi_w_lg_nl0ll256w(0)) AND wire_nl0Oi_w_lg_nl0lO258w(0)) AND wire_nl0Oi_w_lg_nl0Ol260w(0)) AND (nl1i1l24 XOR nl1i1l23));
	nl01ii <= ((((((NOT (nl0iO XOR n11iO)) AND (NOT (nl0li XOR n11li))) AND (NOT ((nl0ll XOR n11ll) XOR (NOT (nl1i0O20 XOR nl1i0O19))))) AND (NOT (nl0lO XOR n11lO))) AND (NOT (nl0Ol XOR n11Ol))) AND (nl1i0i22 XOR nl1i0i21));
	nl01lO <= '1';
	nl01Ol <= ((nll00i OR nll01O) OR (NOT (nl01OO2 XOR nl01OO1)));
	nl110i <= (((((wire_nli0i_w_lg_nll0Oi783w(0) AND (NOT (nll0Ol XOR wire_n1ili_o(0)))) AND (NOT (nll0OO XOR wire_n1ili_o(1)))) AND (NOT (nlli1i XOR (NOT wire_n1ili_o(2))))) AND (NOT (nlli1l XOR (NOT wire_n1ili_o(2))))) AND (NOT (nlli1O XOR wire_n1ili_o(2))));
	nl110l <= (wire_nli0i_w_lg_n10il530w(0) AND nl110O);
	nl110O <= (((((wire_nli0i_w_lg_nlli1O774w(0) AND wire_nli0i_w_lg_nlli1l775w(0)) AND wire_nli0i_w_lg_nlli1i777w(0)) AND wire_nli0i_w_lg_nll0OO779w(0)) AND wire_nli0i_w_lg_nll0Ol781w(0)) AND wire_nli0i_w_lg_nll0Oi783w(0));
	nl111i <= (wire_nli0i_w_lg_nliO1l566w(0) AND nll01i);
	nl111l <= ((((((NOT wire_n1ill_o(0)) AND (NOT wire_n1ill_o(1))) AND (NOT wire_n1ill_o(2))) AND wire_n1ill_o(3)) AND wire_n1ill_o(4)) AND (NOT wire_n1ill_o(5)));
	nl111O <= (nli0l AND wire_nli0i_w_lg_nliO1l566w(0));
	nl11ii <= (n10il AND wire_nliOO_w_lg_n100O528w(0));
	nl11iO <= ((((((((((((((((n10iO XOR n10li) XOR n10ll) XOR n10lO) XOR n10Oi) XOR n10Ol) XOR n10OO) XOR n1i1i) XOR n1i1l) XOR n1i1O) XOR n1i0i) XOR n1i0l) XOR n1i0O) XOR n1iii) XOR n1iil) XOR n1iiO) XOR n100l);
	nl1iil <= ((wire_nliOO_w_lg_nl0OO126w(0) AND (NOT (wire_nli0i_w_lg_nll0ll194w(0) AND wire_nli0i_w_lg_nll01l195w(0)))) AND (nl1iiO18 XOR nl1iiO17));
	nl1iOi <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w329w356w(0) AND n11Ol);
	nl1iOl <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO305w326w354w(0) AND n11Ol);
	nl1iOO <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w349w(0) AND n11Ol);
	nl1l0i <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w297w335w(0) AND n11Ol);
	nl1l0l <= ((wire_n11Oi_w_lg_w_lg_n11iO316w332w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND n11Ol);
	nl1l0O <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w329w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND n11Ol);
	nl1l1i <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w317w347w(0) AND n11Ol);
	nl1l1l <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w342w(0) AND n11Ol);
	nl1l1O <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO305w306w337w(0) AND n11Ol);
	nl1lii <= ((wire_n11Oi_w_lg_w_lg_n11iO305w326w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND n11Ol);
	nl1lil <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w321w370w(0) AND (nl11li46 XOR nl11li45));
	nl1liO <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO316w317w318w366w(0) AND (nl11lO44 XOR nl11lO43));
	nl1lli <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w314w362w(0) AND (nl11Ol42 XOR nl11Ol41));
	nl1lll <= ((wire_n11Oi_w_lg_w_lg_n11iO305w306w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND n11Ol);
	nl1llO <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w297w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND n11Ol);
	nl1lOi <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w332w358w(0) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1lOl <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w329w356w(0) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1lOO <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO305w326w354w(0) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1O0i <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO305w306w337w(0) AND wire_n11Oi_w_lg_n11Ol300w(0)) AND (nl100l36 XOR nl100l35));
	nl1O0l <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w297w335w(0) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1O0O <= ((wire_n11Oi_w_lg_w_lg_n11iO316w332w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1O1i <= ((wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w349w(0) AND wire_n11Oi_w_lg_n11Ol300w(0)) AND (nl101i40 XOR nl101i39));
	nl1O1l <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w317w347w(0) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1O1O <= ((wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w342w(0) AND wire_n11Oi_w_lg_n11Ol300w(0)) AND (nl101O38 XOR nl101O37));
	nl1Oii <= ((wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w329w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1Oil <= ((wire_n11Oi_w_lg_w_lg_n11iO305w326w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1OiO <= ((wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w321w(0) AND wire_n11Oi_w_lg_n11Ol300w(0)) AND (nl10ii34 XOR nl10ii33));
	nl1Oli <= (wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w317w318w(0) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1Oll <= (wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w314w(0) AND wire_n11Oi_w_lg_n11Ol300w(0));
	nl1OlO <= (((wire_n11Oi_w_lg_w_lg_n11iO305w306w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND wire_n11Oi_w_lg_n11Ol300w(0)) AND (nl10iO32 XOR nl10iO31));
	nl1OOi <= (((wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w297w(0) AND wire_n11Oi_w_lg_n11lO298w(0)) AND wire_n11Oi_w_lg_n11Ol300w(0)) AND (nl10ll30 XOR nl10ll29));
	nl1OOl <= ((((wire_nl1OO_w_lg_dataout284w(0) AND wire_nl01O_w_lg_dataout285w(0)) AND wire_nl01l_w_lg_dataout287w(0)) AND wire_nl01i_w_lg_dataout289w(0)) AND (nl10Oi28 XOR nl10Oi27));
	rx_addr <= ( nll1i & nliOl & nliOi & nlilO & nlill);
	rx_cell_err_pulse <= nll1OO;
	rx_cell_pulse <= nll1Ol;
	rx_enb <= nll0lO;
	rx_prty_pulse <= nllili;
	wire_nl0lOl_address_a <= ( nliiii & nlii0O & nlii0l);
	wire_nl0lOl_address_b <= ( wire_nli1Ol_dataout & wire_nli1Oi_dataout & wire_nli1lO_dataout);
	wire_nl0lOl_data_a <= ( n1iiO & n1iil & n1iii & n1i0O & n1i0l & n1i0i & n1i1O & n1i1l & n1i1i & n10OO & n10Ol & n10Oi & n10lO & n10ll & n10li & n10iO);
	nl0lOl :  altsyncram
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
		address_a => wire_nl0lOl_address_a,
		address_b => wire_nl0lOl_address_b,
		clock0 => rx_clk_in,
		data_a => wire_nl0lOl_data_a,
		q_b => wire_nl0lOl_q_b,
		wren_a => wire_nlOOii_dataout
	  );
	wire_nlO1O_address_a <= ( "0" & "1" & "0" & "1" & "0");
	wire_nlO1O_address_b <= ( wire_nillO_dataout & wire_nilll_dataout & wire_nilli_dataout & wire_niliO_dataout & wire_nilil_dataout);
	wire_nlO1O_clock1 <= wire_w_lg_rx_clk_in104w(0);
	wire_nlO1O_data_a <= ( "0" & "1" & "0" & "1" & "0");
	nlO1O :  altsyncram
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
		address_a => wire_nlO1O_address_a,
		address_b => wire_nlO1O_address_b,
		clock0 => rx_clk_in,
		clock1 => wire_nlO1O_clock1,
		data_a => wire_nlO1O_data_a,
		wren_a => wire_gnd
	  );
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN niOO0i55 <= niOO0i56;
		END IF;
		if (now = 0 ns) then
			niOO0i55 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN niOO0i56 <= niOO0i55;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN niOO0l53 <= niOO0l54;
		END IF;
		if (now = 0 ns) then
			niOO0l53 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN niOO0l54 <= niOO0l53;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN niOO0O51 <= niOO0O52;
		END IF;
		if (now = 0 ns) then
			niOO0O51 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN niOO0O52 <= niOO0O51;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN niOOii49 <= niOOii50;
		END IF;
		if (now = 0 ns) then
			niOOii49 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN niOOii50 <= niOOii49;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl010l11 <= nl010l12;
		END IF;
		if (now = 0 ns) then
			nl010l11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl010l12 <= nl010l11;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01il10 <= nl01il9;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01il9 <= nl01il10;
		END IF;
		if (now = 0 ns) then
			nl01il9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01li7 <= nl01li8;
		END IF;
		if (now = 0 ns) then
			nl01li7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01li8 <= nl01li7;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01ll5 <= nl01ll6;
		END IF;
		if (now = 0 ns) then
			nl01ll5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01ll6 <= nl01ll5;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01Oi3 <= nl01Oi4;
		END IF;
		if (now = 0 ns) then
			nl01Oi3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01Oi4 <= nl01Oi3;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01OO1 <= nl01OO2;
		END IF;
		if (now = 0 ns) then
			nl01OO1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl01OO2 <= nl01OO1;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl100l35 <= nl100l36;
		END IF;
		if (now = 0 ns) then
			nl100l35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl100l36 <= nl100l35;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl101i39 <= nl101i40;
		END IF;
		if (now = 0 ns) then
			nl101i39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl101i40 <= nl101i39;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl101O37 <= nl101O38;
		END IF;
		if (now = 0 ns) then
			nl101O37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl101O38 <= nl101O37;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10ii33 <= nl10ii34;
		END IF;
		if (now = 0 ns) then
			nl10ii33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10ii34 <= nl10ii33;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10iO31 <= nl10iO32;
		END IF;
		if (now = 0 ns) then
			nl10iO31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10iO32 <= nl10iO31;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10ll29 <= nl10ll30;
		END IF;
		if (now = 0 ns) then
			nl10ll29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10ll30 <= nl10ll29;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10Oi27 <= nl10Oi28;
		END IF;
		if (now = 0 ns) then
			nl10Oi27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10Oi28 <= nl10Oi27;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10OO25 <= nl10OO26;
		END IF;
		if (now = 0 ns) then
			nl10OO25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl10OO26 <= nl10OO25;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl11il47 <= nl11il48;
		END IF;
		if (now = 0 ns) then
			nl11il47 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl11il48 <= nl11il47;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl11li45 <= nl11li46;
		END IF;
		if (now = 0 ns) then
			nl11li45 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl11li46 <= nl11li45;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl11lO43 <= nl11lO44;
		END IF;
		if (now = 0 ns) then
			nl11lO43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl11lO44 <= nl11lO43;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl11Ol41 <= nl11Ol42;
		END IF;
		if (now = 0 ns) then
			nl11Ol41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl11Ol42 <= nl11Ol41;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1i0i21 <= nl1i0i22;
		END IF;
		if (now = 0 ns) then
			nl1i0i21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1i0i22 <= nl1i0i21;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1i0O19 <= nl1i0O20;
		END IF;
		if (now = 0 ns) then
			nl1i0O19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1i0O20 <= nl1i0O19;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1i1l23 <= nl1i1l24;
		END IF;
		if (now = 0 ns) then
			nl1i1l23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1i1l24 <= nl1i1l23;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1iiO17 <= nl1iiO18;
		END IF;
		if (now = 0 ns) then
			nl1iiO17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1iiO18 <= nl1iiO17;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1ill15 <= nl1ill16;
		END IF;
		if (now = 0 ns) then
			nl1ill15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1ill16 <= nl1ill15;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1OOO13 <= nl1OOO14;
		END IF;
		if (now = 0 ns) then
			nl1OOO13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (rx_clk_in)
	BEGIN
		IF (rx_clk_in = '1' AND rx_clk_in'event) THEN nl1OOO14 <= nl1OOO13;
		END IF;
	END PROCESS;
	wire_nl1OOO14_w_lg_w_lg_q162w163w(0) <= wire_nl1OOO14_w_lg_q162w(0) AND wire_nl1OO_dataout;
	wire_nl1OOO14_w_lg_q162w(0) <= nl1OOO14 XOR nl1OOO13;
	PROCESS (rx_clk_in, wire_n11Oi_PRN, reset)
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
		ELSIF (rx_clk_in = '1' AND rx_clk_in'event) THEN
			IF (atm_rx_port_load = '1') THEN
				n11iO <= atm_rx_port(0);
				n11li <= atm_rx_port(1);
				n11ll <= atm_rx_port(2);
				n11lO <= atm_rx_port(3);
				n11Ol <= atm_rx_port(4);
			END IF;
		END IF;
		if (now = 0 ns) then
			n11iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11ll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11lO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11Ol <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n11Oi_PRN <= (nl11il48 XOR nl11il47);
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w321w370w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w321w(0) AND n11Ol;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w314w362w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w314w(0) AND n11Ol;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO316w317w318w366w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w317w318w(0) AND n11Ol;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w297w335w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w297w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w321w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w320w(0) AND wire_n11Oi_w_lg_n11lO298w(0);
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w295w320w349w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w320w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w314w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w313w(0) AND wire_n11Oi_w_lg_n11lO298w(0);
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w313w342w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w313w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_w_lg_n11iO186w312w329w356w(0) <= wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w329w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO305w306w337w(0) <= wire_n11Oi_w_lg_w_lg_n11iO305w306w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO305w326w354w(0) <= wire_n11Oi_w_lg_w_lg_n11iO305w326w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w317w318w(0) <= wire_n11Oi_w_lg_w_lg_n11iO316w317w(0) AND wire_n11Oi_w_lg_n11lO298w(0);
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w317w347w(0) <= wire_n11Oi_w_lg_w_lg_n11iO316w317w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO316w332w358w(0) <= wire_n11Oi_w_lg_w_lg_n11iO316w332w(0) AND n11lO;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w297w(0) <= wire_n11Oi_w_lg_w_lg_n11iO186w295w(0) AND wire_n11Oi_w_lg_n11ll296w(0);
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w295w320w(0) <= wire_n11Oi_w_lg_w_lg_n11iO186w295w(0) AND n11ll;
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w313w(0) <= wire_n11Oi_w_lg_w_lg_n11iO186w312w(0) AND wire_n11Oi_w_lg_n11ll296w(0);
	wire_n11Oi_w_lg_w_lg_w_lg_n11iO186w312w329w(0) <= wire_n11Oi_w_lg_w_lg_n11iO186w312w(0) AND n11ll;
	wire_n11Oi_w_lg_w_lg_n11iO305w306w(0) <= wire_n11Oi_w_lg_n11iO305w(0) AND wire_n11Oi_w_lg_n11ll296w(0);
	wire_n11Oi_w_lg_w_lg_n11iO305w326w(0) <= wire_n11Oi_w_lg_n11iO305w(0) AND n11ll;
	wire_n11Oi_w_lg_w_lg_n11iO316w317w(0) <= wire_n11Oi_w_lg_n11iO316w(0) AND wire_n11Oi_w_lg_n11ll296w(0);
	wire_n11Oi_w_lg_w_lg_n11iO316w332w(0) <= wire_n11Oi_w_lg_n11iO316w(0) AND n11ll;
	wire_n11Oi_w_lg_w_lg_n11iO186w295w(0) <= wire_n11Oi_w_lg_n11iO186w(0) AND wire_n11Oi_w_lg_n11li294w(0);
	wire_n11Oi_w_lg_w_lg_n11iO186w312w(0) <= wire_n11Oi_w_lg_n11iO186w(0) AND n11li;
	wire_n11Oi_w_lg_n11iO305w(0) <= n11iO AND wire_n11Oi_w_lg_n11li294w(0);
	wire_n11Oi_w_lg_n11iO316w(0) <= n11iO AND n11li;
	wire_n11Oi_w_lg_n11iO186w(0) <= NOT n11iO;
	wire_n11Oi_w_lg_n11li294w(0) <= NOT n11li;
	wire_n11Oi_w_lg_n11ll296w(0) <= NOT n11ll;
	wire_n11Oi_w_lg_n11lO298w(0) <= NOT n11lO;
	wire_n11Oi_w_lg_n11Ol300w(0) <= NOT n11Ol;
	PROCESS (rx_clk_in, reset)
	BEGIN
		IF (reset = '0') THEN
				nl0iO <= '0';
				nl0li <= '0';
				nl0ll <= '0';
				nl0lO <= '0';
				nl0Ol <= '0';
		ELSIF (rx_clk_in = '1' AND rx_clk_in'event) THEN
			IF (nl0OO = '0') THEN
				nl0iO <= wire_niO1O_dataout;
				nl0li <= wire_niO0i_dataout;
				nl0ll <= wire_niO0l_dataout;
				nl0lO <= wire_niO0O_dataout;
				nl0Ol <= wire_niOii_dataout;
			END IF;
		END IF;
	END PROCESS;
	wire_nl0Oi_w_lg_nl0iO255w(0) <= nl0iO AND wire_nl0Oi_w_lg_nl0li254w(0);
	wire_nl0Oi_w_lg_nl0li254w(0) <= NOT nl0li;
	wire_nl0Oi_w_lg_nl0ll256w(0) <= NOT nl0ll;
	wire_nl0Oi_w_lg_nl0lO258w(0) <= NOT nl0lO;
	wire_nl0Oi_w_lg_nl0Ol260w(0) <= NOT nl0Ol;
	PROCESS (rx_clk_in, wire_nli0i_CLRN)
	BEGIN
		IF (wire_nli0i_CLRN = '0') THEN
				n100l <= '0';
				n10il <= '0';
				n10iO <= '0';
				n10li <= '0';
				n10ll <= '0';
				n10lO <= '0';
				n10Oi <= '0';
				n10Ol <= '0';
				n10OO <= '0';
				n11ii <= '0';
				n11il <= '0';
				n11OO <= '0';
				n1i0i <= '0';
				n1i0l <= '0';
				n1i0O <= '0';
				n1i1i <= '0';
				n1i1l <= '0';
				n1i1O <= '0';
				n1iii <= '0';
				n1iil <= '0';
				n1iiO <= '0';
				niilO <= '0';
				nl00li <= '0';
				nl00ll <= '0';
				nl00lO <= '0';
				nl00Oi <= '0';
				nl00Ol <= '0';
				nl00OO <= '0';
				nl0lii <= '0';
				nl0lil <= '0';
				nli0l <= '0';
				nli1O <= '0';
				nlii0i <= '0';
				nlii0l <= '0';
				nlii0O <= '0';
				nliiii <= '0';
				nliO1l <= '0';
				nll00i <= '0';
				nll01i <= '0';
				nll01l <= '0';
				nll01O <= '0';
				nll0li <= '0';
				nll0ll <= '0';
				nll0Oi <= '0';
				nll0Ol <= '0';
				nll0OO <= '0';
				nll1Ol <= '0';
				nll1OO <= '0';
				nlli0i <= '0';
				nlli0l <= '0';
				nlli0O <= '0';
				nlli1i <= '0';
				nlli1l <= '0';
				nlli1O <= '0';
				nlliii <= '0';
				nlliil <= '0';
				nllili <= '0';
		ELSIF (rx_clk_in = '1' AND rx_clk_in'event) THEN
				n100l <= rx_prty;
				n10il <= rx_soc;
				n10iO <= rx_data(0);
				n10li <= rx_data(1);
				n10ll <= rx_data(2);
				n10lO <= rx_data(3);
				n10Oi <= rx_data(4);
				n10Ol <= rx_data(5);
				n10OO <= rx_data(6);
				n11ii <= wire_w_lg_nl11iO527w(0);
				n11il <= wire_n101O_dataout;
				n11OO <= wire_nlOO0O_dataout;
				n1i0i <= rx_data(10);
				n1i0l <= rx_data(11);
				n1i0O <= rx_data(12);
				n1i1i <= rx_data(7);
				n1i1l <= rx_data(8);
				n1i1O <= rx_data(9);
				n1iii <= rx_data(13);
				n1iil <= rx_data(14);
				n1iiO <= rx_data(15);
				niilO <= rx_clav;
				nl00li <= wire_nl0i1l_dataout;
				nl00ll <= wire_nl0i1O_dataout;
				nl00lO <= wire_nl0i0i_dataout;
				nl00Oi <= wire_nl0i0l_dataout;
				nl00Ol <= wire_nl0i0O_dataout;
				nl00OO <= wire_nl0iii_dataout;
				nl0lii <= (wire_nl0l0i_dataout AND wire_nl0l1i_dataout);
				nl0lil <= wire_nl0l0i_dataout;
				nli0l <= wire_nll1O_dataout;
				nli1O <= wire_nll1l_dataout;
				nlii0i <= niOOli;
				nlii0l <= wire_nliiOi_dataout;
				nlii0O <= wire_nliiOl_dataout;
				nliiii <= wire_nliiOO_dataout;
				nliO1l <= wire_nliO1O_dataout;
				nll00i <= wire_nllill_o;
				nll01i <= wire_nlliOi_o;
				nll01l <= wire_nllliO_o;
				nll01O <= wire_nlllli_o;
				nll0li <= wire_nlliOO_o;
				nll0ll <= wire_nlllil_o;
				nll0Oi <= wire_nlOl0i_dataout;
				nll0Ol <= wire_nlOl0l_dataout;
				nll0OO <= wire_nlOl0O_dataout;
				nll1Ol <= wire_nlOO0i_dataout;
				nll1OO <= wire_nlOO1O_dataout;
				nlli0i <= wire_nlOOiO_dataout;
				nlli0l <= wire_nlll1O_o;
				nlli0O <= wire_nlll0i_o;
				nlli1i <= wire_nlOlii_dataout;
				nlli1l <= wire_nlOlil_dataout;
				nlli1O <= wire_nlOliO_dataout;
				nlliii <= wire_nlll0l_o;
				nlliil <= wire_nlll0O_o;
				nllili <= (n11OO AND n11ii);
		END IF;
	END PROCESS;
	wire_nli0i_CLRN <= ((nl01ll6 XOR nl01ll5) AND reset);
	wire_nli0i_w_lg_nl0lil984w(0) <= nl0lil AND wire_nliOO_w_lg_nliilO848w(0);
	wire_nli0i_w_lg_n10il530w(0) <= NOT n10il;
	wire_nli0i_w_lg_n11il569w(0) <= NOT n11il;
	wire_nli0i_w_lg_nl00li1030w(0) <= NOT nl00li;
	wire_nli0i_w_lg_nl0lil982w(0) <= NOT nl0lil;
	wire_nli0i_w_lg_nlii0i945w(0) <= NOT nlii0i;
	wire_nli0i_w_lg_nlii0l867w(0) <= NOT nlii0l;
	wire_nli0i_w_lg_nlii0O868w(0) <= NOT nlii0O;
	wire_nli0i_w_lg_nliiii870w(0) <= NOT nliiii;
	wire_nli0i_w_lg_nliO1l566w(0) <= NOT nliO1l;
	wire_nli0i_w_lg_nll01l195w(0) <= NOT nll01l;
	wire_nli0i_w_lg_nll0ll194w(0) <= NOT nll0ll;
	wire_nli0i_w_lg_nll0Oi783w(0) <= NOT nll0Oi;
	wire_nli0i_w_lg_nll0Ol781w(0) <= NOT nll0Ol;
	wire_nli0i_w_lg_nll0OO779w(0) <= NOT nll0OO;
	wire_nli0i_w_lg_nlli1i777w(0) <= NOT nlli1i;
	wire_nli0i_w_lg_nlli1l775w(0) <= NOT nlli1l;
	wire_nli0i_w_lg_nlli1O774w(0) <= NOT nlli1O;
	PROCESS (rx_clk_in, wire_nli1i_PRN, reset)
	BEGIN
		IF (wire_nli1i_PRN = '0') THEN
				nli1l <= '1';
		ELSIF (reset = '0') THEN
				nli1l <= '0';
		ELSIF (rx_clk_in = '1' AND rx_clk_in'event) THEN
			IF (nl0OO = '1') THEN
				nli1l <= (nli0l OR nli1O);
			END IF;
		END IF;
		if (now = 0 ns) then
			nli1l <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nli1i_PRN <= (nl01li8 XOR nl01li7);
	wire_nli1i_w_lg_nli1l187w(0) <= NOT nli1l;
	PROCESS (rx_clk_in, wire_nlii1l_PRN, wire_nlii1l_CLRN)
	BEGIN
		IF (wire_nlii1l_PRN = '0') THEN
				nli0OO <= '1';
				nlii1i <= '1';
				nlii1O <= '1';
		ELSIF (wire_nlii1l_CLRN = '0') THEN
				nli0OO <= '0';
				nlii1i <= '0';
				nlii1O <= '0';
		ELSIF (rx_clk_in = '1' AND rx_clk_in'event) THEN
			IF (niOOli = '1') THEN
				nli0OO <= nliiil;
				nlii1i <= nliiiO;
				nlii1O <= nliill;
			END IF;
		END IF;
		if (now = 0 ns) then
			nli0OO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlii1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlii1O <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nlii1l_CLRN <= ((niOO0l54 XOR niOO0l53) AND reset);
	wire_nlii1l_PRN <= (niOO0i56 XOR niOO0i55);
	PROCESS (rx_clk_in, wire_nliili_PRN, wire_nliili_CLRN)
	BEGIN
		IF (wire_nliili_PRN = '0') THEN
				nliiil <= '1';
				nliiiO <= '1';
				nliill <= '1';
		ELSIF (wire_nliili_CLRN = '0') THEN
				nliiil <= '0';
				nliiiO <= '0';
				nliill <= '0';
		ELSIF (rx_clk_in = '1' AND rx_clk_in'event) THEN
			IF (niOOiO = '1') THEN
				nliiil <= wire_nlilli_o(0);
				nliiiO <= wire_nlilli_o(1);
				nliill <= wire_nlilli_o(2);
			END IF;
		END IF;
	END PROCESS;
	wire_nliili_CLRN <= ((niOOii50 XOR niOOii49) AND reset);
	wire_nliili_PRN <= (niOO0O52 XOR niOO0O51);
	wire_nliili_w_lg_w_lg_nliiil865w866w(0) <= wire_nliili_w_lg_nliiil865w(0) AND nliill;
	wire_nliili_w_lg_nliiil865w(0) <= nliiil AND nliiiO;
	wire_nliili_w_lg_nliiil939w(0) <= NOT nliiil;
	wire_nliili_w_lg_nliiiO941w(0) <= NOT nliiiO;
	wire_nliili_w_lg_nliill943w(0) <= NOT nliill;
	PROCESS (rx_clk_in, reset)
	BEGIN
		IF (reset = '0') THEN
				nli00i <= '0';
				nli00l <= '0';
				nli00O <= '0';
				nli01i <= '0';
				nli01l <= '0';
				nli01O <= '0';
				nli0ii <= '0';
				nli0il <= '0';
				nli0iO <= '0';
				nli0li <= '0';
				nli0ll <= '0';
				nli0lO <= '0';
				nli0Oi <= '0';
				nli0Ol <= '0';
				nli1OO <= '0';
				nlil0l <= '0';
		ELSIF (rx_clk_in = '1' AND rx_clk_in'event) THEN
			IF (nlii0i = '1') THEN
				nli00i <= wire_nl0lOl_q_b(5);
				nli00l <= wire_nl0lOl_q_b(6);
				nli00O <= wire_nl0lOl_q_b(7);
				nli01i <= wire_nl0lOl_q_b(2);
				nli01l <= wire_nl0lOl_q_b(3);
				nli01O <= wire_nl0lOl_q_b(4);
				nli0ii <= wire_nl0lOl_q_b(8);
				nli0il <= wire_nl0lOl_q_b(9);
				nli0iO <= wire_nl0lOl_q_b(10);
				nli0li <= wire_nl0lOl_q_b(11);
				nli0ll <= wire_nl0lOl_q_b(12);
				nli0lO <= wire_nl0lOl_q_b(13);
				nli0Oi <= wire_nl0lOl_q_b(14);
				nli0Ol <= wire_nl0lOl_q_b(15);
				nli1OO <= wire_nl0lOl_q_b(1);
				nlil0l <= wire_nl0lOl_q_b(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (rx_clk_in, reset, wire_nliOO_CLRN)
	BEGIN
		IF (reset = '0') THEN
				n100O <= '1';
				n10ii <= '1';
				ni11O <= '1';
				niiil <= '1';
				niiiO <= '1';
				niili <= '1';
				niill <= '1';
				nl0i1i <= '1';
				nl0OO <= '1';
				nli0O <= '1';
				nliii <= '1';
				nliil <= '1';
				nliilO <= '1';
				nliiO <= '1';
				nlili <= '1';
				nlill <= '1';
				nlilO <= '1';
				nliOi <= '1';
				nliOl <= '1';
				nll00l <= '1';
				nll00O <= '1';
				nll0ii <= '1';
				nll0il <= '1';
				nll0iO <= '1';
				nll0lO <= '1';
				nll1i <= '1';
				nlliiO <= '1';
		ELSIF (wire_nliOO_CLRN = '0') THEN
				n100O <= '0';
				n10ii <= '0';
				ni11O <= '0';
				niiil <= '0';
				niiiO <= '0';
				niili <= '0';
				niill <= '0';
				nl0i1i <= '0';
				nl0OO <= '0';
				nli0O <= '0';
				nliii <= '0';
				nliil <= '0';
				nliilO <= '0';
				nliiO <= '0';
				nlili <= '0';
				nlill <= '0';
				nlilO <= '0';
				nliOi <= '0';
				nliOl <= '0';
				nll00l <= '0';
				nll00O <= '0';
				nll0ii <= '0';
				nll0il <= '0';
				nll0iO <= '0';
				nll0lO <= '0';
				nll1i <= '0';
				nlliiO <= '0';
		ELSIF (rx_clk_in = '1' AND rx_clk_in'event) THEN
				n100O <= n10ii;
				n10ii <= nll0lO;
				ni11O <= wire_niiOi_dataout;
				niiil <= wire_niiOl_dataout;
				niiiO <= wire_niiOO_dataout;
				niili <= wire_nil1i_dataout;
				niill <= wire_nil1l_dataout;
				nl0i1i <= wire_nl0l1i_dataout;
				nl0OO <= wire_nliOO_w_lg_nl0OO126w(0);
				nli0O <= wire_nlliO_dataout;
				nliii <= wire_nllli_dataout;
				nliil <= wire_nllll_dataout;
				nliilO <= wire_nlil1i_dataout;
				nliiO <= wire_nlllO_dataout;
				nlili <= wire_nllOi_dataout;
				nlill <= wire_nll0i_dataout;
				nlilO <= wire_nll0l_dataout;
				nliOi <= wire_nll0O_dataout;
				nliOl <= wire_nllii_dataout;
				nll00l <= wire_nllllO_o;
				nll00O <= wire_nlllOi_o;
				nll0ii <= wire_nlllOl_o;
				nll0il <= wire_nlllOO_o;
				nll0iO <= wire_nllO1i_o;
				nll0lO <= wire_nlll1l_o;
				nll1i <= wire_nllil_dataout;
				nlliiO <= wire_nlllii_o;
		END IF;
	END PROCESS;
	wire_nliOO_CLRN <= (nl01Oi4 XOR nl01Oi3);
	wire_nliOO_w_lg_n100O528w(0) <= NOT n100O;
	wire_nliOO_w_lg_nl0OO126w(0) <= NOT nl0OO;
	wire_nliOO_w_lg_nliilO848w(0) <= NOT nliilO;
	wire_nliOO_w_lg_w_lg_nlliiO732w733w(0) <= wire_nliOO_w_lg_nlliiO732w(0) OR nlli0l;
	wire_nliOO_w_lg_w_lg_nlliiO624w743w(0) <= wire_nliOO_w_lg_nlliiO624w(0) OR nlli0l;
	wire_nliOO_w_lg_w_lg_nlliiO624w625w(0) <= wire_nliOO_w_lg_nlliiO624w(0) OR nlli0O;
	wire_nliOO_w_lg_w_lg_nlliiO624w752w(0) <= wire_nliOO_w_lg_nlliiO624w(0) OR nlliii;
	wire_nliOO_w_lg_nlliiO732w(0) <= nlliiO OR nlli0O;
	wire_nliOO_w_lg_nlliiO624w(0) <= nlliiO OR nlliil;
	wire_n1ilO_data <= ( niill & niili & niiiO & niiil & ni11O);
	n1ilO :  lpm_decode
	  GENERIC MAP (
		LPM_DECODES => 32,
		LPM_PIPELINE => 0,
		LPM_WIDTH => 5
	  )
	  PORT MAP ( 
		data => wire_n1ilO_data,
		enable => wire_vcc,
		eq => wire_n1ilO_eq
	  );
	wire_n1iOi_aclr <= wire_w_lg_reset384w(0);
	wire_n1iOi_data(0) <= ( wire_ni11l_dataout);
	n1iOi :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1iOi_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1iOi_data,
		enable => wire_n0iOl_dataout,
		q => wire_n1iOi_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1iOl_aclr <= wire_w_lg_reset384w(0);
	wire_n1iOl_data(0) <= ( wire_ni11l_dataout);
	n1iOl :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1iOl_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1iOl_data,
		enable => wire_n0iOO_dataout,
		q => wire_n1iOl_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1iOO_aclr <= wire_w_lg_reset384w(0);
	wire_n1iOO_data(0) <= ( wire_ni11l_dataout);
	n1iOO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1iOO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1iOO_data,
		enable => wire_n0l1i_dataout,
		q => wire_n1iOO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l0i_aclr <= wire_w_lg_reset384w(0);
	wire_n1l0i_data(0) <= ( wire_ni11l_dataout);
	n1l0i :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l0i_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1l0i_data,
		enable => wire_n0l0l_dataout,
		q => wire_n1l0i_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l0l_aclr <= wire_w_lg_reset384w(0);
	wire_n1l0l_data(0) <= ( wire_ni11l_dataout);
	n1l0l :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l0l_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1l0l_data,
		enable => wire_n0l0O_dataout,
		q => wire_n1l0l_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l0O_aclr <= wire_w_lg_reset384w(0);
	wire_n1l0O_data(0) <= ( wire_ni11l_dataout);
	n1l0O :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l0O_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1l0O_data,
		enable => wire_n0lii_dataout,
		q => wire_n1l0O_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l1i_aclr <= wire_w_lg_reset384w(0);
	wire_n1l1i_data(0) <= ( wire_ni11l_dataout);
	n1l1i :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l1i_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1l1i_data,
		enable => wire_n0l1l_dataout,
		q => wire_n1l1i_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l1l_aclr <= wire_w_lg_reset384w(0);
	wire_n1l1l_data(0) <= ( wire_ni11l_dataout);
	n1l1l :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l1l_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1l1l_data,
		enable => wire_n0l1O_dataout,
		q => wire_n1l1l_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1l1O_aclr <= wire_w_lg_reset384w(0);
	wire_n1l1O_data(0) <= ( wire_ni11l_dataout);
	n1l1O :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1l1O_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1l1O_data,
		enable => wire_n0l0i_dataout,
		q => wire_n1l1O_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lii_aclr <= wire_w_lg_reset384w(0);
	wire_n1lii_data(0) <= ( wire_ni11l_dataout);
	n1lii :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lii_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1lii_data,
		enable => wire_n0lil_dataout,
		q => wire_n1lii_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lil_aclr <= wire_w_lg_reset384w(0);
	wire_n1lil_data(0) <= ( wire_ni11l_dataout);
	n1lil :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lil_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1lil_data,
		enable => wire_n0liO_dataout,
		q => wire_n1lil_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1liO_aclr <= wire_w_lg_reset384w(0);
	wire_n1liO_data(0) <= ( wire_ni11l_dataout);
	n1liO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1liO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1liO_data,
		enable => wire_n0lli_dataout,
		q => wire_n1liO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lli_aclr <= wire_w_lg_reset384w(0);
	wire_n1lli_data(0) <= ( wire_ni11l_dataout);
	n1lli :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lli_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1lli_data,
		enable => wire_n0lll_dataout,
		q => wire_n1lli_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lll_aclr <= wire_w_lg_reset384w(0);
	wire_n1lll_data(0) <= ( wire_ni11l_dataout);
	n1lll :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lll_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1lll_data,
		enable => wire_n0llO_dataout,
		q => wire_n1lll_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1llO_aclr <= wire_w_lg_reset384w(0);
	wire_n1llO_data(0) <= ( wire_ni11l_dataout);
	n1llO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1llO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1llO_data,
		enable => wire_n0lOi_dataout,
		q => wire_n1llO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lOi_aclr <= wire_w_lg_reset384w(0);
	wire_n1lOi_data(0) <= ( wire_ni11l_dataout);
	n1lOi :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lOi_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1lOi_data,
		enable => wire_n0lOl_dataout,
		q => wire_n1lOi_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lOl_aclr <= wire_w_lg_reset384w(0);
	wire_n1lOl_data(0) <= ( wire_ni11l_dataout);
	n1lOl :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lOl_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1lOl_data,
		enable => wire_n0lOO_dataout,
		q => wire_n1lOl_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1lOO_aclr <= wire_w_lg_reset384w(0);
	wire_n1lOO_data(0) <= ( wire_ni11l_dataout);
	n1lOO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1lOO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1lOO_data,
		enable => wire_n0O1i_dataout,
		q => wire_n1lOO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O0i_aclr <= wire_w_lg_reset384w(0);
	wire_n1O0i_data(0) <= ( wire_ni11l_dataout);
	n1O0i :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O0i_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1O0i_data,
		enable => wire_n0O0l_dataout,
		q => wire_n1O0i_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O0l_aclr <= wire_w_lg_reset384w(0);
	wire_n1O0l_data(0) <= ( wire_ni11l_dataout);
	n1O0l :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O0l_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1O0l_data,
		enable => wire_n0O0O_dataout,
		q => wire_n1O0l_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O0O_aclr <= wire_w_lg_reset384w(0);
	wire_n1O0O_data(0) <= ( wire_ni11l_dataout);
	n1O0O :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O0O_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1O0O_data,
		enable => wire_n0Oii_dataout,
		q => wire_n1O0O_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O1i_aclr <= wire_w_lg_reset384w(0);
	wire_n1O1i_data(0) <= ( wire_ni11l_dataout);
	n1O1i :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O1i_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1O1i_data,
		enable => wire_n0O1l_dataout,
		q => wire_n1O1i_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O1l_aclr <= wire_w_lg_reset384w(0);
	wire_n1O1l_data(0) <= ( wire_ni11l_dataout);
	n1O1l :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O1l_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1O1l_data,
		enable => wire_n0O1O_dataout,
		q => wire_n1O1l_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1O1O_aclr <= wire_w_lg_reset384w(0);
	wire_n1O1O_data(0) <= ( wire_ni11l_dataout);
	n1O1O :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1O1O_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1O1O_data,
		enable => wire_n0O0i_dataout,
		q => wire_n1O1O_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1Oii_aclr <= wire_w_lg_reset384w(0);
	wire_n1Oii_data(0) <= ( wire_ni11l_dataout);
	n1Oii :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1Oii_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1Oii_data,
		enable => wire_n0Oil_dataout,
		q => wire_n1Oii_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1Oil_aclr <= wire_w_lg_reset384w(0);
	wire_n1Oil_data(0) <= ( wire_ni11l_dataout);
	n1Oil :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1Oil_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1Oil_data,
		enable => wire_n0OiO_dataout,
		q => wire_n1Oil_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1OiO_aclr <= wire_w_lg_reset384w(0);
	wire_n1OiO_data(0) <= ( wire_ni11l_dataout);
	n1OiO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1OiO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1OiO_data,
		enable => wire_n0Oli_dataout,
		q => wire_n1OiO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1Oli_aclr <= wire_w_lg_reset384w(0);
	wire_n1Oli_data(0) <= ( wire_ni11l_dataout);
	n1Oli :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1Oli_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1Oli_data,
		enable => wire_n0Oll_dataout,
		q => wire_n1Oli_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1Oll_aclr <= wire_w_lg_reset384w(0);
	wire_n1Oll_data(0) <= ( wire_ni11l_dataout);
	n1Oll :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1Oll_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1Oll_data,
		enable => wire_n0OlO_dataout,
		q => wire_n1Oll_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1OlO_aclr <= wire_w_lg_reset384w(0);
	wire_n1OlO_data(0) <= ( wire_ni11l_dataout);
	n1OlO :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1OlO_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1OlO_data,
		enable => wire_n0OOi_dataout,
		q => wire_n1OlO_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n1OOi_aclr <= wire_w_lg_reset384w(0);
	wire_n1OOi_data(0) <= ( wire_ni11l_dataout);
	n1OOi :  lpm_ff
	  GENERIC MAP (
		LPM_FFTYPE => "DFF",
		LPM_WIDTH => 1
	  )
	  PORT MAP ( 
		aclr => wire_n1OOi_aclr,
		aload => wire_gnd,
		aset => wire_gnd,
		clock => rx_clk_in,
		data => wire_n1OOi_data,
		enable => wire_n0OOl_dataout,
		q => wire_n1OOi_q,
		sclr => wire_gnd,
		sload => wire_gnd,
		sset => wire_gnd
	  );
	wire_n0iOl_dataout <= wire_n1ilO_eq(0) AND NOT(nl1iil);
	wire_n0iOO_dataout <= wire_n1ilO_eq(1) AND NOT(nl1iil);
	wire_n0l0i_dataout <= wire_n1ilO_eq(5) AND NOT(nl1iil);
	wire_n0l0l_dataout <= wire_n1ilO_eq(6) AND NOT(nl1iil);
	wire_n0l0O_dataout <= wire_n1ilO_eq(7) AND NOT(nl1iil);
	wire_n0l1i_dataout <= wire_n1ilO_eq(2) AND NOT(nl1iil);
	wire_n0l1l_dataout <= wire_n1ilO_eq(3) AND NOT(nl1iil);
	wire_n0l1O_dataout <= wire_n1ilO_eq(4) AND NOT(nl1iil);
	wire_n0lii_dataout <= wire_n1ilO_eq(8) AND NOT(nl1iil);
	wire_n0lil_dataout <= wire_n1ilO_eq(9) AND NOT(nl1iil);
	wire_n0liO_dataout <= wire_n1ilO_eq(10) AND NOT(nl1iil);
	wire_n0lli_dataout <= wire_n1ilO_eq(11) AND NOT(nl1iil);
	wire_n0lll_dataout <= wire_n1ilO_eq(12) AND NOT(nl1iil);
	wire_n0llO_dataout <= wire_n1ilO_eq(13) AND NOT(nl1iil);
	wire_n0lOi_dataout <= wire_n1ilO_eq(14) AND NOT(nl1iil);
	wire_n0lOl_dataout <= wire_n1ilO_eq(15) AND NOT(nl1iil);
	wire_n0lOO_dataout <= wire_n1ilO_eq(16) AND NOT(nl1iil);
	wire_n0O0i_dataout <= wire_n1ilO_eq(20) AND NOT(nl1iil);
	wire_n0O0l_dataout <= wire_n1ilO_eq(21) AND NOT(nl1iil);
	wire_n0O0O_dataout <= wire_n1ilO_eq(22) AND NOT(nl1iil);
	wire_n0O1i_dataout <= wire_n1ilO_eq(17) AND NOT(nl1iil);
	wire_n0O1l_dataout <= wire_n1ilO_eq(18) AND NOT(nl1iil);
	wire_n0O1O_dataout <= wire_n1ilO_eq(19) AND NOT(nl1iil);
	wire_n0Oii_dataout <= wire_n1ilO_eq(23) AND NOT(nl1iil);
	wire_n0Oil_dataout <= wire_n1ilO_eq(24) AND NOT(nl1iil);
	wire_n0OiO_dataout <= wire_n1ilO_eq(25) AND NOT(nl1iil);
	wire_n0Oli_dataout <= wire_n1ilO_eq(26) AND NOT(nl1iil);
	wire_n0Oll_dataout <= wire_n1ilO_eq(27) AND NOT(nl1iil);
	wire_n0OlO_dataout <= wire_n1ilO_eq(28) AND NOT(nl1iil);
	wire_n0OOi_dataout <= wire_n1ilO_eq(29) AND NOT(nl1iil);
	wire_n0OOl_dataout <= wire_n1ilO_eq(30) AND NOT(nl1iil);
	wire_n100i_dataout <= n11il AND NOT(nll0li);
	wire_n101O_dataout <= wire_n100i_dataout OR atm_rx_port_load;
	wire_n110l_dataout <= nlli0i OR nl11ii;
	wire_n111i_dataout <= wire_w_lg_nl110O532w(0) AND n10il;
	wire_n111l_dataout <= nl110O AND n10il;
	wire_n111O_dataout <= nlli0i AND NOT(nl110l);
	wire_ni00i_dataout <= wire_n1O1i_q(0) WHEN nl1lli = '1'  ELSE wire_ni00l_dataout;
	wire_ni00l_dataout <= wire_n1lOO_q(0) WHEN nl1lll = '1'  ELSE wire_ni00O_dataout;
	wire_ni00O_dataout <= wire_n1lOl_q(0) WHEN nl1llO = '1'  ELSE wire_ni0ii_dataout;
	wire_ni01i_dataout <= wire_n1O0i_q(0) WHEN nl1lii = '1'  ELSE wire_ni01l_dataout;
	wire_ni01l_dataout <= wire_n1O1O_q(0) WHEN nl1lil = '1'  ELSE wire_ni01O_dataout;
	wire_ni01O_dataout <= wire_n1O1l_q(0) WHEN nl1liO = '1'  ELSE wire_ni00i_dataout;
	wire_ni0ii_dataout <= wire_n1lOi_q(0) WHEN nl1lOi = '1'  ELSE wire_ni0il_dataout;
	wire_ni0il_dataout <= wire_n1llO_q(0) WHEN nl1lOl = '1'  ELSE wire_ni0iO_dataout;
	wire_ni0iO_dataout <= wire_n1lll_q(0) WHEN nl1lOO = '1'  ELSE wire_ni0li_dataout;
	wire_ni0li_dataout <= wire_n1lli_q(0) WHEN nl1O1i = '1'  ELSE wire_ni0ll_dataout;
	wire_ni0ll_dataout <= wire_n1liO_q(0) WHEN nl1O1l = '1'  ELSE wire_ni0lO_dataout;
	wire_ni0lO_dataout <= wire_n1lil_q(0) WHEN nl1O1O = '1'  ELSE wire_ni0Oi_dataout;
	wire_ni0Oi_dataout <= wire_n1lii_q(0) WHEN nl1O0i = '1'  ELSE wire_ni0Ol_dataout;
	wire_ni0Ol_dataout <= wire_n1l0O_q(0) WHEN nl1O0l = '1'  ELSE wire_ni0OO_dataout;
	wire_ni0OO_dataout <= wire_n1l0l_q(0) WHEN nl1O0O = '1'  ELSE wire_nii1i_dataout;
	wire_ni10i_dataout <= niilO AND ((wire_nli1i_w_lg_nli1l187w(0) OR (nli1l AND nll01l)) OR (NOT (nl1ill16 XOR nl1ill15)));
	wire_ni11l_dataout <= wire_ni10i_dataout AND nl0OO;
	wire_ni1ii_dataout <= wire_n1OOi_q(0) WHEN nl1iOi = '1'  ELSE wire_ni1il_dataout;
	wire_ni1il_dataout <= wire_n1OlO_q(0) WHEN nl1iOl = '1'  ELSE wire_ni1iO_dataout;
	wire_ni1iO_dataout <= wire_n1Oll_q(0) WHEN nl1iOO = '1'  ELSE wire_ni1li_dataout;
	wire_ni1li_dataout <= wire_n1Oli_q(0) WHEN nl1l1i = '1'  ELSE wire_ni1ll_dataout;
	wire_ni1ll_dataout <= wire_n1OiO_q(0) WHEN nl1l1l = '1'  ELSE wire_ni1lO_dataout;
	wire_ni1lO_dataout <= wire_n1Oil_q(0) WHEN nl1l1O = '1'  ELSE wire_ni1Oi_dataout;
	wire_ni1Oi_dataout <= wire_n1Oii_q(0) WHEN nl1l0i = '1'  ELSE wire_ni1Ol_dataout;
	wire_ni1Ol_dataout <= wire_n1O0O_q(0) WHEN nl1l0l = '1'  ELSE wire_ni1OO_dataout;
	wire_ni1OO_dataout <= wire_n1O0l_q(0) WHEN nl1l0O = '1'  ELSE wire_ni01i_dataout;
	wire_nii0i_dataout <= wire_n1l1i_q(0) WHEN nl1Oli = '1'  ELSE wire_nii0l_dataout;
	wire_nii0l_dataout <= wire_n1iOO_q(0) WHEN nl1Oll = '1'  ELSE wire_nii0O_dataout;
	wire_nii0O_dataout <= wire_n1iOl_q(0) WHEN nl1OlO = '1'  ELSE wire_niiii_dataout;
	wire_nii1i_dataout <= wire_n1l0i_q(0) WHEN nl1Oii = '1'  ELSE wire_nii1l_dataout;
	wire_nii1l_dataout <= wire_n1l1O_q(0) WHEN nl1Oil = '1'  ELSE wire_nii1O_dataout;
	wire_nii1O_dataout <= wire_n1l1l_q(0) WHEN nl1OiO = '1'  ELSE wire_nii0i_dataout;
	wire_niiii_dataout <= wire_n1iOi_q(0) AND nl1OOi;
	wire_niiOi_dataout <= wire_nil1O_dataout WHEN nl0OO = '1'  ELSE nli0O;
	wire_niiOl_dataout <= wire_nil0i_dataout WHEN nl0OO = '1'  ELSE nliii;
	wire_niiOO_dataout <= wire_nil0l_dataout WHEN nl0OO = '1'  ELSE nliil;
	wire_nil0i_dataout <= n11li WHEN nll0ll = '1'  ELSE nll00O;
	wire_nil0l_dataout <= n11ll WHEN nll0ll = '1'  ELSE nll0ii;
	wire_nil0O_dataout <= n11lO WHEN nll0ll = '1'  ELSE nll0il;
	wire_nil1i_dataout <= wire_nil0O_dataout WHEN nl0OO = '1'  ELSE nliiO;
	wire_nil1l_dataout <= wire_nilii_dataout WHEN nl0OO = '1'  ELSE nlili;
	wire_nil1O_dataout <= n11iO WHEN nll0ll = '1'  ELSE nll00l;
	wire_nilii_dataout <= n11Ol WHEN nll0ll = '1'  ELSE nll0iO;
	wire_nilil_dataout <= n11iO WHEN nll0ll = '1'  ELSE wire_nilOi_dataout;
	wire_niliO_dataout <= n11li WHEN nll0ll = '1'  ELSE wire_nilOl_dataout;
	wire_nilli_dataout <= n11ll WHEN nll0ll = '1'  ELSE wire_nilOO_dataout;
	wire_nilll_dataout <= n11lO WHEN nll0ll = '1'  ELSE wire_niO1i_dataout;
	wire_nillO_dataout <= n11Ol WHEN nll0ll = '1'  ELSE wire_niO1l_dataout;
	wire_nilOi_dataout <= nll00l WHEN nl01Ol = '1'  ELSE nl0iO;
	wire_nilOl_dataout <= nll00O WHEN nl01Ol = '1'  ELSE nl0li;
	wire_nilOO_dataout <= nll0ii WHEN nl01Ol = '1'  ELSE nl0ll;
	wire_niO0i_dataout <= wire_niOOl_dataout WHEN nl010i = '1'  ELSE wire_niOiO_dataout;
	wire_niO0l_dataout <= wire_niOOO_dataout WHEN nl010i = '1'  ELSE wire_niOli_dataout;
	wire_niO0O_dataout <= wire_nl11i_dataout WHEN nl010i = '1'  ELSE wire_niOll_dataout;
	wire_niO1i_dataout <= nll0il WHEN nl01Ol = '1'  ELSE nl0lO;
	wire_niO1l_dataout <= nll0iO WHEN nl01Ol = '1'  ELSE nl0Ol;
	wire_niO1O_dataout <= wire_niOOi_dataout WHEN nl010i = '1'  ELSE wire_niOil_dataout;
	wire_niOii_dataout <= wire_nl11l_dataout WHEN nl010i = '1'  ELSE wire_niOlO_dataout;
	wire_niOil_dataout <= wire_n11Oi_w_lg_n11iO186w(0) WHEN nll0ll = '1'  ELSE nl0iO;
	wire_niOiO_dataout <= nl0li AND NOT(nll0ll);
	wire_niOli_dataout <= nl0ll AND NOT(nll0ll);
	wire_niOll_dataout <= nl0lO AND NOT(nll0ll);
	wire_niOlO_dataout <= nl0Ol AND NOT(nll0ll);
	wire_niOOi_dataout <= wire_n11Oi_w_lg_n11iO186w(0) WHEN nll0ll = '1'  ELSE wire_nl11O_dataout;
	wire_niOOl_dataout <= wire_nl10i_dataout AND NOT(nll0ll);
	wire_niOOO_dataout <= wire_nl10l_dataout AND NOT(nll0ll);
	wire_nl00i_dataout <= wire_nl00l_o(4) AND NOT(nl011O);
	wire_nl00i_w_lg_dataout283w(0) <= NOT wire_nl00i_dataout;
	wire_nl01i_dataout <= wire_nl00l_o(1) AND NOT(nl011O);
	wire_nl01i_w_lg_dataout289w(0) <= NOT wire_nl01i_dataout;
	wire_nl01l_dataout <= wire_nl00l_o(2) AND NOT(nl011O);
	wire_nl01l_w_lg_dataout287w(0) <= NOT wire_nl01l_dataout;
	wire_nl01O_dataout <= wire_nl00l_o(3) AND NOT(nl011O);
	wire_nl01O_w_lg_dataout285w(0) <= NOT wire_nl01O_dataout;
	wire_nl0i0i_dataout <= wire_nl0ili_dataout AND NOT(wire_nl0l1l_dataout);
	wire_nl0i0l_dataout <= wire_nl0ill_dataout AND NOT(wire_nl0l1l_dataout);
	wire_nl0i0O_dataout <= wire_nl0ilO_dataout AND NOT(wire_nl0l1l_dataout);
	wire_nl0i1l_dataout <= wire_nl0iil_dataout AND NOT(wire_nl0l1l_dataout);
	wire_nl0i1O_dataout <= wire_nl0iiO_dataout AND NOT(wire_nl0l1l_dataout);
	wire_nl0iii_dataout <= wire_nl0iOi_dataout AND NOT(wire_nl0l1l_dataout);
	wire_nl0iil_dataout <= wire_nl0iOl_o(0) WHEN niOO1O = '1'  ELSE nl00li;
	wire_nl0iiO_dataout <= wire_nl0iOl_o(1) WHEN niOO1O = '1'  ELSE nl00ll;
	wire_nl0ili_dataout <= wire_nl0iOl_o(2) WHEN niOO1O = '1'  ELSE nl00lO;
	wire_nl0ill_dataout <= wire_nl0iOl_o(3) WHEN niOO1O = '1'  ELSE nl00Oi;
	wire_nl0ilO_dataout <= wire_nl0iOl_o(4) WHEN niOO1O = '1'  ELSE nl00Ol;
	wire_nl0iOi_dataout <= wire_nl0iOl_o(5) WHEN niOO1O = '1'  ELSE nl00OO;
	wire_nl0l0i_dataout <= wire_nliOO_w_lg_nliilO848w(0) WHEN wire_nli0i_w_lg_nl0lil982w(0) = '1'  ELSE wire_nl0l0l_dataout;
	wire_nl0l0l_dataout <= nl0lil AND NOT((nliilO AND atm_rx_enb));
	wire_nl0l1i_dataout <= niOO1l WHEN niOO1O = '1'  ELSE nl0i1i;
	wire_nl0l1l_dataout <= niOO1l AND niOO1O;
	wire_nl0Oli_dataout <= nlil0l WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(0);
	wire_nl0Oll_dataout <= nli1OO WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(1);
	wire_nl0OlO_dataout <= nli01i WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(2);
	wire_nl0OOi_dataout <= nli01l WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(3);
	wire_nl0OOl_dataout <= nli01O WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(4);
	wire_nl0OOO_dataout <= nli00i WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(5);
	wire_nl10i_dataout <= wire_nl1iO_dataout WHEN nl011i = '1'  ELSE wire_nl01i_dataout;
	wire_nl10l_dataout <= wire_nl1li_dataout WHEN nl011i = '1'  ELSE wire_nl01l_dataout;
	wire_nl10O_dataout <= wire_nl1ll_dataout WHEN nl011i = '1'  ELSE wire_nl01O_dataout;
	wire_nl11i_dataout <= wire_nl10O_dataout AND NOT(nll0ll);
	wire_nl11l_dataout <= wire_nl1ii_dataout AND NOT(nll0ll);
	wire_nl11O_dataout <= wire_nl1il_dataout WHEN nl011i = '1'  ELSE wire_nl1OO_dataout;
	wire_nl1ii_dataout <= wire_nl1lO_dataout WHEN nl011i = '1'  ELSE wire_nl00i_dataout;
	wire_nl1il_dataout <= wire_nl1Oi_o(0) AND NOT(nl1OOl);
	wire_nl1iO_dataout <= wire_nl1Oi_o(1) AND NOT(nl1OOl);
	wire_nl1li_dataout <= wire_nl1Oi_o(2) AND NOT(nl1OOl);
	wire_nl1ll_dataout <= wire_nl1Oi_o(3) AND NOT(nl1OOl);
	wire_nl1lO_dataout <= wire_nl1Oi_o(4) AND NOT(nl1OOl);
	wire_nl1OO_dataout <= wire_nl00l_o(0) AND NOT(nl011O);
	wire_nl1OO_w_lg_dataout284w(0) <= wire_nl1OO_dataout AND wire_nl00i_w_lg_dataout283w(0);
	wire_nli10i_dataout <= nli0il WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(9);
	wire_nli10l_dataout <= nli0iO WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(10);
	wire_nli10O_dataout <= nli0li WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(11);
	wire_nli11i_dataout <= nli00l WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(6);
	wire_nli11l_dataout <= nli00O WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(7);
	wire_nli11O_dataout <= nli0ii WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(8);
	wire_nli1ii_dataout <= nli0ll WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(12);
	wire_nli1il_dataout <= nli0lO WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(13);
	wire_nli1iO_dataout <= nli0Oi WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(14);
	wire_nli1li_dataout <= nli0Ol WHEN wire_nli0i_w_lg_nlii0i945w(0) = '1'  ELSE wire_nl0lOl_q_b(15);
	wire_nli1lO_dataout <= nliiil WHEN niOOli = '1'  ELSE nli0OO;
	wire_nli1Oi_dataout <= nliiiO WHEN niOOli = '1'  ELSE nlii1i;
	wire_nli1Ol_dataout <= nliill WHEN niOOli = '1'  ELSE nlii1O;
	wire_nliiOi_dataout <= wire_nlilii_o(0) WHEN wire_nlOOii_dataout = '1'  ELSE nlii0l;
	wire_nliiOl_dataout <= wire_nlilii_o(1) WHEN wire_nlOOii_dataout = '1'  ELSE nlii0O;
	wire_nliiOO_dataout <= wire_nlilii_o(2) WHEN wire_nlOOii_dataout = '1'  ELSE nliiii;
	wire_nlil1i_dataout <= wire_nlil1l_dataout WHEN wire_nlOOii_dataout = '1'  ELSE wire_nlilil_dataout;
	wire_nlil1l_dataout <= wire_nlilil_dataout WHEN (wire_w_lg_niOOli842w(0) AND niOOil) = '1'  ELSE wire_nlil1O_dataout;
	wire_nlil1O_dataout <= wire_nlilil_dataout AND niOOil;
	wire_nlilil_dataout <= wire_nliliO_dataout WHEN niOOiO = '1'  ELSE nliilO;
	wire_nliliO_dataout <= nliilO OR (wire_nlOOii_w_lg_dataout833w(0) AND ((wire_nliili_w_lg_w_lg_nliiil865w866w(0) AND ((wire_nli0i_w_lg_nlii0l867w(0) AND wire_nli0i_w_lg_nlii0O868w(0)) AND wire_nli0i_w_lg_nliiii870w(0))) OR ((((NOT (nlii0l XOR wire_nlilli_o(0))) AND (NOT (nlii0O XOR wire_nlilli_o(1)))) AND (NOT (nliiii XOR wire_nlilli_o(2)))) AND (NOT wire_nlilli_o(3)))));
	wire_nliO0i_dataout <= nliO1l AND NOT((niOOli AND (wire_nlOOii_w_lg_dataout833w(0) AND (wire_nli1ll_w_lg_w_o_range834w837w(0) AND wire_nli1ll_o(3)))));
	wire_nliO1O_dataout <= wire_nliO0i_dataout OR (wire_w_lg_niOOli842w(0) AND wire_nlOOii_w_lg_dataout846w(0));
	wire_nll0i_dataout <= wire_nilil_dataout OR nl0OO;
	wire_nll0l_dataout <= wire_niliO_dataout OR nl0OO;
	wire_nll0O_dataout <= wire_nilli_dataout OR nl0OO;
	wire_nll1l_dataout <= wire_nllOl_dataout AND NOT(nl0OO);
	wire_nll1O_dataout <= wire_nllOO_dataout AND NOT(nl0OO);
	wire_nllii_dataout <= wire_nilll_dataout OR nl0OO;
	wire_nllil_dataout <= wire_nillO_dataout OR nl0OO;
	wire_nlliO_dataout <= nli0O WHEN nl0OO = '1'  ELSE wire_nilil_dataout;
	wire_nllli_dataout <= nliii WHEN nl0OO = '1'  ELSE wire_niliO_dataout;
	wire_nllll_dataout <= nliil WHEN nl0OO = '1'  ELSE wire_nilli_dataout;
	wire_nlllO_dataout <= nliiO WHEN nl0OO = '1'  ELSE wire_nilll_dataout;
	wire_nllO0i_dataout <= nlli0O AND NOT(niOOlO);
	wire_nllO0l_dataout <= nlliii OR niOOlO;
	wire_nllO0O_dataout <= nlliil AND NOT(niOOlO);
	wire_nllO1O_dataout <= nlli0l AND NOT(niOOlO);
	wire_nllOi_dataout <= nlili WHEN nl0OO = '1'  ELSE wire_nillO_dataout;
	wire_nllOii_dataout <= nlliiO AND NOT(niOOlO);
	wire_nllOil_dataout <= nll0lO AND NOT(niOOlO);
	wire_nllOiO_dataout <= nll00i AND NOT(niOOlO);
	wire_nllOl_dataout <= nll01O AND NOT(nll0ll);
	wire_nllOll_dataout <= nlli0l OR wire_nli0i_w_lg_nliO1l566w(0);
	wire_nllOlO_dataout <= nlli0O AND NOT(wire_nli0i_w_lg_nliO1l566w(0));
	wire_nllOO_dataout <= wire_ni1ii_dataout WHEN nll0ll = '1'  ELSE nll00i;
	wire_nllOOi_dataout <= nlliii AND NOT(wire_nli0i_w_lg_nliO1l566w(0));
	wire_nllOOl_dataout <= nlliil AND NOT(wire_nli0i_w_lg_nliO1l566w(0));
	wire_nllOOO_dataout <= nlliiO AND NOT(wire_nli0i_w_lg_nliO1l566w(0));
	wire_nlO00i_dataout <= wire_nlO0ii_dataout AND nll01i;
	wire_nlO00l_dataout <= wire_nlO0il_dataout WHEN nl111i = '1'  ELSE nll0ll;
	wire_nlO00O_dataout <= wire_nlO0li_dataout WHEN nl111i = '1'  ELSE wire_nlO0Oi_dataout;
	wire_nlO01i_dataout <= nlliii AND wire_nli0i_w_lg_nliO1l566w(0);
	wire_nlO01l_dataout <= nlliil AND wire_nli0i_w_lg_nliO1l566w(0);
	wire_nlO01O_dataout <= nlliiO AND wire_nli0i_w_lg_nliO1l566w(0);
	wire_nlO0ii_dataout <= wire_nlO0ll_dataout WHEN nl111i = '1'  ELSE nll01O;
	wire_nlO0il_dataout <= nll0ll OR (n11il AND wire_w_lg_niOOOO570w(0));
	wire_nlO0li_dataout <= wire_nlO0Oi_dataout AND wire_nli0i_w_lg_n11il569w(0);
	wire_nlO0ll_dataout <= nll01O OR wire_nli0i_w_lg_n11il569w(0);
	wire_nlO0Oi_dataout <= wire_nlO0Ol_dataout AND NOT(nll01O);
	wire_nlO0Ol_dataout <= nll01i OR nl111l;
	wire_nlO0OO_dataout <= n11iO WHEN nl111O = '1'  ELSE nll00l;
	wire_nlO10i_dataout <= wire_nlO1li_dataout WHEN niOOOi = '1'  ELSE nliO1l;
	wire_nlO10l_dataout <= wire_nlO1Ol_dataout AND NOT(niOOOi);
	wire_nlO10O_dataout <= wire_nlO1OO_dataout AND NOT(niOOOi);
	wire_nlO11i_dataout <= nll00i OR wire_nli0i_w_lg_nliO1l566w(0);
	wire_nlO11l_dataout <= nll01i OR nll01O;
	wire_nlO11O_dataout <= wire_nlO1ll_dataout AND niOOOi;
	wire_nlO1ii_dataout <= wire_nlO1ll_dataout WHEN niOOOi = '1'  ELSE wire_nlO01i_dataout;
	wire_nlO1il_dataout <= wire_nlO1lO_dataout WHEN niOOOi = '1'  ELSE wire_nlO01l_dataout;
	wire_nlO1iO_dataout <= wire_w_lg_niOOOl573w(0) WHEN niOOOi = '1'  ELSE wire_nlO01O_dataout;
	wire_nlO1li_dataout <= wire_w_lg_niOOOO570w(0) OR NOT(niOOOl);
	wire_nlO1ll_dataout <= niOOOO AND niOOOl;
	wire_nlO1lO_dataout <= wire_w_lg_niOOOO570w(0) AND niOOOl;
	wire_nlO1Ol_dataout <= nlli0l AND wire_nli0i_w_lg_nliO1l566w(0);
	wire_nlO1OO_dataout <= nlli0O OR NOT(wire_nli0i_w_lg_nliO1l566w(0));
	wire_nlOi0i_dataout <= n11Ol WHEN nl111O = '1'  ELSE nll0iO;
	wire_nlOi0l_dataout <= nlli0l AND NOT(nl111O);
	wire_nlOi0O_dataout <= nlli0O AND NOT(nl111O);
	wire_nlOi1i_dataout <= n11li WHEN nl111O = '1'  ELSE nll00O;
	wire_nlOi1l_dataout <= n11ll WHEN nl111O = '1'  ELSE nll0ii;
	wire_nlOi1O_dataout <= n11lO WHEN nl111O = '1'  ELSE nll0il;
	wire_nlOiii_dataout <= nlliii OR nl111O;
	wire_nlOiil_dataout <= nlliil AND NOT(nl111O);
	wire_nlOiiO_dataout <= nlliiO AND NOT(nl111O);
	wire_nlOill_dataout <= nlli0l AND NOT(n11il);
	wire_nlOilO_dataout <= nlli0O AND NOT(n11il);
	wire_nlOiOi_dataout <= nlliii AND NOT(n11il);
	wire_nlOiOl_dataout <= nlliil OR n11il;
	wire_nlOiOO_dataout <= nlliiO AND NOT(n11il);
	wire_nlOl0i_dataout <= wire_nlOlli_dataout AND NOT(wire_nlOO1l_dataout);
	wire_nlOl0l_dataout <= wire_nlOlll_dataout AND NOT(wire_nlOO1l_dataout);
	wire_nlOl0O_dataout <= wire_nlOllO_dataout AND NOT(wire_nlOO1l_dataout);
	wire_nlOl1i_dataout <= nll0ll OR n11il;
	wire_nlOlii_dataout <= wire_nlOlOi_dataout AND NOT(wire_nlOO1l_dataout);
	wire_nlOlil_dataout <= wire_nlOlOl_dataout AND NOT(wire_nlOO1l_dataout);
	wire_nlOliO_dataout <= wire_nlOlOO_dataout AND NOT(wire_nlOO1l_dataout);
	wire_nlOlli_dataout <= wire_nlOO1i_o(0) WHEN wire_nlOO0l_dataout = '1'  ELSE nll0Oi;
	wire_nlOlll_dataout <= wire_nlOO1i_o(1) WHEN wire_nlOO0l_dataout = '1'  ELSE nll0Ol;
	wire_nlOllO_dataout <= wire_nlOO1i_o(2) WHEN wire_nlOO0l_dataout = '1'  ELSE nll0OO;
	wire_nlOlOi_dataout <= wire_nlOO1i_o(3) WHEN wire_nlOO0l_dataout = '1'  ELSE nlli1i;
	wire_nlOlOl_dataout <= wire_nlOO1i_o(4) WHEN wire_nlOO0l_dataout = '1'  ELSE nlli1l;
	wire_nlOlOO_dataout <= wire_nlOO1i_o(5) WHEN wire_nlOO0l_dataout = '1'  ELSE nlli1O;
	wire_nlOO0i_dataout <= wire_nlOOlO_dataout WHEN wire_nlOOil_o(1) = '1'  ELSE nl11ii;
	wire_nlOO0l_dataout <= wire_nlOOOi_dataout WHEN wire_nlOOil_o(1) = '1'  ELSE nl11ii;
	wire_nlOO0O_dataout <= wire_nlOOOi_dataout WHEN wire_nlOOil_o(1) = '1'  ELSE nl11ii;
	wire_nlOO1l_dataout <= wire_nlOOli_dataout AND wire_nlOOil_o(1);
	wire_nlOO1O_dataout <= wire_nlOOll_dataout AND wire_nlOOil_o(1);
	wire_nlOOii_dataout <= wire_nlOOOl_dataout WHEN wire_nlOOil_o(1) = '1'  ELSE nl11ii;
	wire_nlOOii_w_lg_dataout846w(0) <= wire_nlOOii_dataout AND wire_nli1ll_w_lg_w_lg_w_lg_w_o_range834w843w844w845w(0);
	wire_nlOOii_w_lg_dataout833w(0) <= NOT wire_nlOOii_dataout;
	wire_nlOOiO_dataout <= wire_nlOOOO_dataout WHEN wire_nlOOil_o(1) = '1'  ELSE wire_n110l_dataout;
	wire_nlOOli_dataout <= nl110i AND wire_nliOO_w_lg_n100O528w(0);
	wire_nlOOll_dataout <= wire_n111i_dataout AND wire_nliOO_w_lg_n100O528w(0);
	wire_nlOOlO_dataout <= wire_n111l_dataout AND wire_nliOO_w_lg_n100O528w(0);
	wire_nlOOOi_dataout <= wire_w_lg_nl110l533w(0) AND wire_nliOO_w_lg_n100O528w(0);
	wire_nlOOOl_dataout <= wire_w_lg_nl110l533w(0) AND wire_nliOO_w_lg_n100O528w(0);
	wire_nlOOOO_dataout <= wire_n111O_dataout WHEN wire_nliOO_w_lg_n100O528w(0) = '1'  ELSE nlli0i;
	wire_n1ili_a <= ( "0" & "0" & "0");
	wire_n1ili_b <= ( "0" & "0" & "1");
	n1ili :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_n1ili_a,
		b => wire_n1ili_b,
		cin => wire_gnd,
		o => wire_n1ili_o
	  );
	wire_n1ill_a <= ( nlli1O & nlli1l & nlli1i & nll0OO & nll0Ol & nll0Oi);
	wire_n1ill_b <= ( "0" & "0" & "0" & "0" & wire_nlOl1O_o(0) & wire_nlOl1O_w_lg_w_lg_w_o_range460w462w463w);
	n1ill :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_n1ill_a,
		b => wire_n1ill_b,
		cin => wire_gnd,
		o => wire_n1ill_o
	  );
	wire_nl00l_a <= ( nl0Ol & nl0lO & nl0ll & nl0li & nl0iO);
	wire_nl00l_b <= ( "0" & "0" & "0" & "0" & "1");
	nl00l :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_nl00l_a,
		b => wire_nl00l_b,
		cin => wire_gnd,
		o => wire_nl00l_o
	  );
	wire_nl0iOl_a <= ( nl00OO & nl00Ol & nl00Oi & nl00lO & nl00ll & nl00li);
	wire_nl0iOl_b <= ( "0" & "0" & "0" & "0" & "0" & "1");
	nl0iOl :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_nl0iOl_a,
		b => wire_nl0iOl_b,
		cin => wire_gnd,
		o => wire_nl0iOl_o
	  );
	wire_nl0liO_a <= ( "0" & "0" & "0");
	wire_nl0liO_b <= ( "0" & "0" & "1");
	nl0liO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_nl0liO_a,
		b => wire_nl0liO_b,
		cin => wire_gnd,
		o => wire_nl0liO_o
	  );
	wire_nl1Oi_a <= ( wire_nl00i_dataout & wire_nl01O_dataout & wire_nl01l_dataout & wire_nl01i_dataout & wire_nl1OOO14_w_lg_w_lg_q162w163w);
	wire_nl1Oi_b <= ( "0" & "0" & "0" & "0" & "1");
	nl1Oi :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_nl1Oi_a,
		b => wire_nl1Oi_b,
		cin => wire_gnd,
		o => wire_nl1Oi_o
	  );
	wire_nli1ll_w_lg_w_lg_w_lg_w_o_range834w843w844w845w(0) <= wire_nli1ll_w_lg_w_lg_w_o_range834w843w844w(0) AND wire_nli1ll_w_o_range838w(0);
	wire_nli1ll_w_lg_w_lg_w_o_range834w843w844w(0) <= wire_nli1ll_w_lg_w_o_range834w843w(0) AND wire_nli1ll_w_lg_w_o_range835w836w(0);
	wire_nli1ll_w_lg_w_o_range834w837w(0) <= wire_nli1ll_w_o_range834w(0) AND wire_nli1ll_w_lg_w_o_range835w836w(0);
	wire_nli1ll_w_lg_w_o_range834w843w(0) <= NOT wire_nli1ll_w_o_range834w(0);
	wire_nli1ll_w_lg_w_o_range835w836w(0) <= NOT wire_nli1ll_w_o_range835w(0);
	wire_nli1ll_a <= ( nliiii & nlii0O & nlii0l & "1");
	wire_nli1ll_b <= ( wire_nliili_w_lg_nliill943w & wire_nliili_w_lg_nliiiO941w & wire_nliili_w_lg_nliiil939w & "1");
	wire_nli1ll_w_o_range834w(0) <= wire_nli1ll_o(1);
	wire_nli1ll_w_o_range835w(0) <= wire_nli1ll_o(2);
	wire_nli1ll_w_o_range838w(0) <= wire_nli1ll_o(3);
	nli1ll :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_nli1ll_a,
		b => wire_nli1ll_b,
		cin => wire_gnd,
		o => wire_nli1ll_o
	  );
	wire_nlilii_a <= ( "0" & nliiii & nlii0O & nlii0l);
	wire_nlilii_b <= ( "0" & "0" & "0" & "1");
	nlilii :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_nlilii_a,
		b => wire_nlilii_b,
		cin => wire_gnd,
		o => wire_nlilii_o
	  );
	wire_nlilli_a <= ( "0" & nliill & nliiiO & nliiil);
	wire_nlilli_b <= ( "0" & "0" & "0" & "1");
	nlilli :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 4,
		width_b => 4,
		width_o => 4
	  )
	  PORT MAP ( 
		a => wire_nlilli_a,
		b => wire_nlilli_b,
		cin => wire_gnd,
		o => wire_nlilli_o
	  );
	wire_nlOO1i_a <= ( nlli1O & nlli1l & nlli1i & nll0OO & nll0Ol & nll0Oi);
	wire_nlOO1i_b <= ( "0" & "0" & "0" & "0" & "0" & "1");
	nlOO1i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6,
		width_o => 6
	  )
	  PORT MAP ( 
		a => wire_nlOO1i_a,
		b => wire_nlOO1i_b,
		cin => wire_gnd,
		o => wire_nlOO1i_o
	  );
	wire_nlOl1O_w_lg_w_lg_w_o_range460w462w463w(0) <= NOT wire_nlOl1O_w_lg_w_o_range460w462w(0);
	wire_nlOl1O_w_lg_w_o_range460w462w(0) <= wire_nlOl1O_w_o_range460w(0) OR wire_nlOl1O_w_o_range461w(0);
	wire_nlOl1O_i <= ( n10ii & n100O);
	wire_nlOl1O_w_o_range460w(0) <= wire_nlOl1O_o(0);
	wire_nlOl1O_w_o_range461w(0) <= wire_nlOl1O_o(3);
	nlOl1O :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_nlOl1O_i,
		o => wire_nlOl1O_o
	  );
	wire_nlOOil_i(0) <= ( nlli0i);
	nlOOil :  oper_decoder
	  GENERIC MAP (
		width_i => 1,
		width_o => 2
	  )
	  PORT MAP ( 
		i => wire_nlOOil_i,
		o => wire_nlOOil_o
	  );
	wire_nllill_data <= ( nll00i & wire_nlO11i_dataout & wire_nllOiO_dataout);
	wire_nllill_sel <= ( wire_nliOO_w_lg_w_lg_nlliiO624w752w & nlli0O & nlli0l);
	nllill :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nllill_data,
		o => wire_nllill_o,
		sel => wire_nllill_sel
	  );
	wire_nlliOi_data <= ( nll01i & wire_nlO00O_dataout & wire_nlO11l_dataout);
	wire_nlliOi_sel <= ( wire_nliOO_w_lg_w_lg_nlliiO624w743w & nlliii & nlli0O);
	nlliOi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlliOi_data,
		o => wire_nlliOi_o,
		sel => wire_nlliOi_sel
	  );
	wire_nlliOO_data <= ( "0" & nl111O & wire_nlO11O_dataout);
	wire_nlliOO_sel <= ( wire_nliOO_w_lg_w_lg_nlliiO732w733w & nlliil & nlliii);
	nlliOO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlliOO_data,
		o => wire_nlliOO_o,
		sel => wire_nlliOO_sel
	  );
	wire_nlll0i_data <= ( wire_nlOilO_dataout & wire_nlOi0O_dataout & wire_nlO10O_dataout & wire_nllOlO_dataout & wire_nllO0i_dataout);
	wire_nlll0i_sel <= ( nlliiO & nlliil & nlliii & nlli0O & nlli0l);
	nlll0i :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlll0i_data,
		o => wire_nlll0i_o,
		sel => wire_nlll0i_sel
	  );
	wire_nlll0l_data <= ( wire_nlOiOi_dataout & wire_nlOiii_dataout & wire_nlO1ii_dataout & wire_nllOOi_dataout & wire_nllO0l_dataout);
	wire_nlll0l_sel <= ( nlliiO & nlliil & nlliii & nlli0O & nlli0l);
	nlll0l :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlll0l_data,
		o => wire_nlll0l_o,
		sel => wire_nlll0l_sel
	  );
	wire_nlll0O_data <= ( wire_nlOiOl_dataout & wire_nlOiil_dataout & wire_nlO1il_dataout & wire_nllOOl_dataout & wire_nllO0O_dataout);
	wire_nlll0O_sel <= ( nlliiO & nlliil & nlliii & nlli0O & nlli0l);
	nlll0O :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlll0O_data,
		o => wire_nlll0O_o,
		sel => wire_nlll0O_sel
	  );
	wire_nlll1l_data <= ( nll0lO & wire_w_lg_nl111O639w & wire_nlO10i_dataout & "1" & wire_nllOil_dataout);
	wire_nlll1l_sel <= ( nlliiO & nlliil & nlliii & nlli0O & nlli0l);
	nlll1l :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlll1l_data,
		o => wire_nlll1l_o,
		sel => wire_nlll1l_sel
	  );
	wire_nlll1O_data <= ( wire_nlOill_dataout & wire_nlOi0l_dataout & wire_nlO10l_dataout & wire_nllOll_dataout & wire_nllO1O_dataout);
	wire_nlll1O_sel <= ( nlliiO & nlliil & nlliii & nlli0O & nlli0l);
	nlll1O :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlll1O_data,
		o => wire_nlll1O_o,
		sel => wire_nlll1O_sel
	  );
	wire_nlllii_data <= ( wire_nlOiOO_dataout & wire_nlOiiO_dataout & wire_nlO1iO_dataout & wire_nllOOO_dataout & wire_nllOii_dataout);
	wire_nlllii_sel <= ( nlliiO & nlliil & nlliii & nlli0O & nlli0l);
	nlllii :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlllii_data,
		o => wire_nlllii_o,
		sel => wire_nlllii_sel
	  );
	wire_nlllil_data <= ( wire_nlOl1i_dataout & wire_w_lg_nl111O639w & wire_nlO00l_dataout & "0" & nll0ll);
	wire_nlllil_sel <= ( nlliiO & nlliil & nlliii & nlli0O & nlli0l);
	nlllil :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlllil_data,
		o => wire_nlllil_o,
		sel => wire_nlllil_sel
	  );
	wire_nllliO_data <= ( "1" & wire_w_lg_nl111O639w & "0");
	wire_nllliO_sel <= ( nlliiO & nlliil & niOOll);
	nllliO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nllliO_data,
		o => wire_nllliO_o,
		sel => wire_nllliO_sel
	  );
	wire_nlllli_data <= ( "0" & wire_nlO00i_dataout & nll01O);
	wire_nlllli_sel <= ( wire_nliOO_w_lg_w_lg_nlliiO624w625w & nlliii & nlli0l);
	nlllli :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlllli_data,
		o => wire_nlllli_o,
		sel => wire_nlllli_sel
	  );
	wire_nllllO_data <= ( "1" & wire_nlO0OO_dataout & nll00l);
	wire_nllllO_sel <= ( nlliiO & nlliil & niOOll);
	nllllO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nllllO_data,
		o => wire_nllllO_o,
		sel => wire_nllllO_sel
	  );
	wire_nlllOi_data <= ( "1" & wire_nlOi1i_dataout & nll00O);
	wire_nlllOi_sel <= ( nlliiO & nlliil & niOOll);
	nlllOi :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlllOi_data,
		o => wire_nlllOi_o,
		sel => wire_nlllOi_sel
	  );
	wire_nlllOl_data <= ( "1" & wire_nlOi1l_dataout & nll0ii);
	wire_nlllOl_sel <= ( nlliiO & nlliil & niOOll);
	nlllOl :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlllOl_data,
		o => wire_nlllOl_o,
		sel => wire_nlllOl_sel
	  );
	wire_nlllOO_data <= ( "1" & wire_nlOi1O_dataout & nll0il);
	wire_nlllOO_sel <= ( nlliiO & nlliil & niOOll);
	nlllOO :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlllOO_data,
		o => wire_nlllOO_o,
		sel => wire_nlllOO_sel
	  );
	wire_nllO1i_data <= ( "1" & wire_nlOi0i_dataout & nll0iO);
	wire_nllO1i_sel <= ( nlliiO & nlliil & niOOll);
	nllO1i :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nllO1i_data,
		o => wire_nllO1i_o,
		sel => wire_nllO1i_sel
	  );

 END RTL; --masterrx_example
--synopsys translate_on
--VALID FILE
