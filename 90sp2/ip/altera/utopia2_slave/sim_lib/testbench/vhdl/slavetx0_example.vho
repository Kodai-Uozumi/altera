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

--synthesis_resources = altdpram 1 lpm_counter 2 lut 202 mux21 77 oper_add 8 oper_decoder 2 oper_less_than 1 oper_mux 10 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  slavetx0_example IS 
	 PORT 
	 ( 
		 phy_tx_clav	:	OUT  STD_LOGIC;
		 phy_tx_clk	:	IN  STD_LOGIC;
		 phy_tx_data	:	OUT  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 phy_tx_enb	:	IN  STD_LOGIC;
		 phy_tx_fifo_full	:	OUT  STD_LOGIC;
		 phy_tx_soc	:	OUT  STD_LOGIC;
		 phy_tx_valid	:	OUT  STD_LOGIC;
		 reset	:	IN  STD_LOGIC;
		 tx_addr	:	IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		 tx_cell_disc_pulse	:	OUT  STD_LOGIC;
		 tx_cell_err_pulse	:	OUT  STD_LOGIC;
		 tx_cell_pulse	:	OUT  STD_LOGIC;
		 tx_clav	:	OUT  STD_LOGIC;
		 tx_clav_enb	:	OUT  STD_LOGIC;
		 tx_clk	:	IN  STD_LOGIC;
		 tx_data	:	IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
		 tx_enb	:	IN  STD_LOGIC;
		 tx_prty	:	IN  STD_LOGIC;
		 tx_prty_pulse	:	OUT  STD_LOGIC;
		 tx_soc	:	IN  STD_LOGIC
	 ); 
 END slavetx0_example;

 ARCHITECTURE RTL OF slavetx0_example IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL  wire_n10Oi_data	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_vcc	:	STD_LOGIC;
	 SIGNAL  wire_n10Oi_q	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_n10Oi_rdaddress	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n10Oi_wraddress	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n10Oi_wren	:	STD_LOGIC;
	 SIGNAL  wire_n0iii_w_lg_w_lg_n1l0O654w655w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nliO1i55	:	STD_LOGIC := '0';
	 SIGNAL	 nliO1i56	:	STD_LOGIC := '0';
	 SIGNAL	 nliO1l53	:	STD_LOGIC := '0';
	 SIGNAL	 nliO1l54	:	STD_LOGIC := '0';
	 SIGNAL	 nliOOi51	:	STD_LOGIC := '0';
	 SIGNAL	 nliOOi52	:	STD_LOGIC := '0';
	 SIGNAL	 nliOOl49	:	STD_LOGIC := '0';
	 SIGNAL	 nliOOl50	:	STD_LOGIC := '0';
	 SIGNAL	 nll00l41	:	STD_LOGIC := '0';
	 SIGNAL	 nll00l42	:	STD_LOGIC := '0';
	 SIGNAL	 nll01i45	:	STD_LOGIC := '0';
	 SIGNAL	 nll01i46	:	STD_LOGIC := '0';
	 SIGNAL	 nll01O43	:	STD_LOGIC := '0';
	 SIGNAL	 nll01O44	:	STD_LOGIC := '0';
	 SIGNAL	 nll0ii39	:	STD_LOGIC := '0';
	 SIGNAL	 nll0ii40	:	STD_LOGIC := '0';
	 SIGNAL	 nll0iO37	:	STD_LOGIC := '0';
	 SIGNAL	 nll0iO38	:	STD_LOGIC := '0';
	 SIGNAL	 nll0ll35	:	STD_LOGIC := '0';
	 SIGNAL	 nll0ll36	:	STD_LOGIC := '0';
	 SIGNAL	 nll0Oi33	:	STD_LOGIC := '0';
	 SIGNAL	 nll0Oi34	:	STD_LOGIC := '0';
	 SIGNAL	 nll0OO31	:	STD_LOGIC := '0';
	 SIGNAL	 nll0OO32	:	STD_LOGIC := '0';
	 SIGNAL	 nll1Ol47	:	STD_LOGIC := '0';
	 SIGNAL	 nll1Ol48	:	STD_LOGIC := '0';
	 SIGNAL	 nlli0i27	:	STD_LOGIC := '0';
	 SIGNAL	 nlli0i28	:	STD_LOGIC := '0';
	 SIGNAL	 nlli0O25	:	STD_LOGIC := '0';
	 SIGNAL	 nlli0O26	:	STD_LOGIC := '0';
	 SIGNAL	 nlli1l29	:	STD_LOGIC := '0';
	 SIGNAL	 nlli1l30	:	STD_LOGIC := '0';
	 SIGNAL	 nllili23	:	STD_LOGIC := '0';
	 SIGNAL	 nllili24	:	STD_LOGIC := '0';
	 SIGNAL	 nlliOl21	:	STD_LOGIC := '0';
	 SIGNAL	 nlliOl22	:	STD_LOGIC := '0';
	 SIGNAL	 nlll0l17	:	STD_LOGIC := '0';
	 SIGNAL	 nlll0l18	:	STD_LOGIC := '0';
	 SIGNAL	 nlll1i19	:	STD_LOGIC := '0';
	 SIGNAL	 nlll1i20	:	STD_LOGIC := '0';
	 SIGNAL	 nlllil15	:	STD_LOGIC := '0';
	 SIGNAL	 nlllil16	:	STD_LOGIC := '0';
	 SIGNAL	 nllliO13	:	STD_LOGIC := '0';
	 SIGNAL	 nllliO14	:	STD_LOGIC := '0';
	 SIGNAL	 nllllO11	:	STD_LOGIC := '0';
	 SIGNAL	 nllllO12	:	STD_LOGIC := '0';
	 SIGNAL	 nlllOi10	:	STD_LOGIC := '0';
	 SIGNAL	 nlllOi9	:	STD_LOGIC := '0';
	 SIGNAL	 nlllOl7	:	STD_LOGIC := '0';
	 SIGNAL	 nlllOl8	:	STD_LOGIC := '0';
	 SIGNAL	 nllO0i3	:	STD_LOGIC := '0';
	 SIGNAL	 nllO0i4	:	STD_LOGIC := '0';
	 SIGNAL	 nllO1i5	:	STD_LOGIC := '0';
	 SIGNAL	 nllO1i6	:	STD_LOGIC := '0';
	 SIGNAL	 nllOil1	:	STD_LOGIC := '0';
	 SIGNAL	 nllOil2	:	STD_LOGIC := '0';
	 SIGNAL	n00OO	:	STD_LOGIC := '0';
	 SIGNAL	n0i1l	:	STD_LOGIC := '0';
	 SIGNAL	wire_n0i1i_CLRN	:	STD_LOGIC;
	 SIGNAL	n000i	:	STD_LOGIC := '0';
	 SIGNAL	n000l	:	STD_LOGIC := '0';
	 SIGNAL	n000O	:	STD_LOGIC := '0';
	 SIGNAL	n001i	:	STD_LOGIC := '0';
	 SIGNAL	n001l	:	STD_LOGIC := '0';
	 SIGNAL	n001O	:	STD_LOGIC := '0';
	 SIGNAL	n00ii	:	STD_LOGIC := '0';
	 SIGNAL	n00il	:	STD_LOGIC := '0';
	 SIGNAL	n00iO	:	STD_LOGIC := '0';
	 SIGNAL	n00li	:	STD_LOGIC := '0';
	 SIGNAL	n00ll	:	STD_LOGIC := '0';
	 SIGNAL	n00lO	:	STD_LOGIC := '0';
	 SIGNAL	n00Oi	:	STD_LOGIC := '0';
	 SIGNAL	n00Ol	:	STD_LOGIC := '0';
	 SIGNAL	n010i	:	STD_LOGIC := '0';
	 SIGNAL	n010l	:	STD_LOGIC := '0';
	 SIGNAL	n010O	:	STD_LOGIC := '0';
	 SIGNAL	n011l	:	STD_LOGIC := '0';
	 SIGNAL	n011O	:	STD_LOGIC := '0';
	 SIGNAL	n01ii	:	STD_LOGIC := '0';
	 SIGNAL	n01il	:	STD_LOGIC := '0';
	 SIGNAL	n01iO	:	STD_LOGIC := '0';
	 SIGNAL	n01li	:	STD_LOGIC := '0';
	 SIGNAL	n01ll	:	STD_LOGIC := '0';
	 SIGNAL	n01lO	:	STD_LOGIC := '0';
	 SIGNAL	n01Oi	:	STD_LOGIC := '0';
	 SIGNAL	n01Ol	:	STD_LOGIC := '0';
	 SIGNAL	n01OO	:	STD_LOGIC := '0';
	 SIGNAL	n0i0i	:	STD_LOGIC := '0';
	 SIGNAL	n0i0l	:	STD_LOGIC := '0';
	 SIGNAL	n0i0O	:	STD_LOGIC := '0';
	 SIGNAL	n0i1O	:	STD_LOGIC := '0';
	 SIGNAL	n0iil	:	STD_LOGIC := '0';
	 SIGNAL	n100i	:	STD_LOGIC := '0';
	 SIGNAL	n100l	:	STD_LOGIC := '0';
	 SIGNAL	n100O	:	STD_LOGIC := '0';
	 SIGNAL	n101i	:	STD_LOGIC := '0';
	 SIGNAL	n101l	:	STD_LOGIC := '0';
	 SIGNAL	n101O	:	STD_LOGIC := '0';
	 SIGNAL	n10il	:	STD_LOGIC := '0';
	 SIGNAL	n110i	:	STD_LOGIC := '0';
	 SIGNAL	n110l	:	STD_LOGIC := '0';
	 SIGNAL	n110O	:	STD_LOGIC := '0';
	 SIGNAL	n111i	:	STD_LOGIC := '0';
	 SIGNAL	n111l	:	STD_LOGIC := '0';
	 SIGNAL	n111O	:	STD_LOGIC := '0';
	 SIGNAL	n11ii	:	STD_LOGIC := '0';
	 SIGNAL	n11il	:	STD_LOGIC := '0';
	 SIGNAL	n11iO	:	STD_LOGIC := '0';
	 SIGNAL	n11li	:	STD_LOGIC := '0';
	 SIGNAL	n11ll	:	STD_LOGIC := '0';
	 SIGNAL	n11lO	:	STD_LOGIC := '0';
	 SIGNAL	n11Oi	:	STD_LOGIC := '0';
	 SIGNAL	n11Ol	:	STD_LOGIC := '0';
	 SIGNAL	n11OO	:	STD_LOGIC := '0';
	 SIGNAL	n1l0O	:	STD_LOGIC := '0';
	 SIGNAL	nlO01l	:	STD_LOGIC := '0';
	 SIGNAL	nlOl0O	:	STD_LOGIC := '0';
	 SIGNAL	nlOlii	:	STD_LOGIC := '0';
	 SIGNAL	nlOlil	:	STD_LOGIC := '0';
	 SIGNAL	nlOliO	:	STD_LOGIC := '0';
	 SIGNAL	nlOlli	:	STD_LOGIC := '0';
	 SIGNAL	nlOlll	:	STD_LOGIC := '0';
	 SIGNAL	nlOllO	:	STD_LOGIC := '0';
	 SIGNAL	nlOlOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOlOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOlOO	:	STD_LOGIC := '0';
	 SIGNAL	nlOO0i	:	STD_LOGIC := '0';
	 SIGNAL	nlOO0l	:	STD_LOGIC := '0';
	 SIGNAL	nlOO0O	:	STD_LOGIC := '0';
	 SIGNAL	nlOO1i	:	STD_LOGIC := '0';
	 SIGNAL	nlOO1l	:	STD_LOGIC := '0';
	 SIGNAL	nlOO1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOOii	:	STD_LOGIC := '0';
	 SIGNAL	nlOOil	:	STD_LOGIC := '0';
	 SIGNAL	nlOOiO	:	STD_LOGIC := '0';
	 SIGNAL	nlOOlO	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOO	:	STD_LOGIC := '0';
	 SIGNAL	wire_n0iii_PRN	:	STD_LOGIC;
	 SIGNAL  wire_n0iii_w_lg_w_lg_w_lg_n00Ol563w564w565w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_w_lg_n00Ol563w564w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_w_lg_n110i605w606w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n00Ol563w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n000i585w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n000l587w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n000O589w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n001O583w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n010i595w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n010l597w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n011l591w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n011O593w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n100O720w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n110i605w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n111l603w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n1l0O654w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_w_lg_w_lg_n00Ol568w569w570w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_w_lg_n00Ol568w569w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0iii_w_lg_n00Ol568w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n10l	:	STD_LOGIC := '0';
	 SIGNAL	n11O	:	STD_LOGIC := '0';
	 SIGNAL	wire_n10i_CLRN	:	STD_LOGIC;
	 SIGNAL  wire_n10i_w_lg_n10l89w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n10i_w_lg_w_lg_n10l89w90w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n10i_w_lg_n10l18w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n10i_w_lg_n11O75w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n10i_w_lg_w_lg_n10l18w19w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n10ii	:	STD_LOGIC := '0';
	 SIGNAL	n10iO	:	STD_LOGIC := '0';
	 SIGNAL	n10ll	:	STD_LOGIC := '0';
	 SIGNAL  wire_n10li_w_lg_n10ll704w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n1il	:	STD_LOGIC := '0';
	 SIGNAL	wire_n1ii_CLRN	:	STD_LOGIC;
	 SIGNAL	n10O	:	STD_LOGIC := '0';
	 SIGNAL	n11i	:	STD_LOGIC := '0';
	 SIGNAL	n11l	:	STD_LOGIC := '0';
	 SIGNAL	n1li	:	STD_LOGIC := '0';
	 SIGNAL	ni00i	:	STD_LOGIC := '0';
	 SIGNAL	ni00l	:	STD_LOGIC := '0';
	 SIGNAL	ni00O	:	STD_LOGIC := '0';
	 SIGNAL	ni01i	:	STD_LOGIC := '0';
	 SIGNAL	ni01l	:	STD_LOGIC := '0';
	 SIGNAL	ni01O	:	STD_LOGIC := '0';
	 SIGNAL	ni0ii	:	STD_LOGIC := '0';
	 SIGNAL	ni0il	:	STD_LOGIC := '0';
	 SIGNAL	ni0iO	:	STD_LOGIC := '0';
	 SIGNAL	ni0li	:	STD_LOGIC := '0';
	 SIGNAL	ni0ll	:	STD_LOGIC := '0';
	 SIGNAL	ni0lO	:	STD_LOGIC := '0';
	 SIGNAL	ni0Oi	:	STD_LOGIC := '0';
	 SIGNAL	ni0Ol	:	STD_LOGIC := '0';
	 SIGNAL	ni0OO	:	STD_LOGIC := '0';
	 SIGNAL	ni1OO	:	STD_LOGIC := '0';
	 SIGNAL	nii0i	:	STD_LOGIC := '0';
	 SIGNAL	nii0l	:	STD_LOGIC := '0';
	 SIGNAL	nii0O	:	STD_LOGIC := '0';
	 SIGNAL	nii1i	:	STD_LOGIC := '0';
	 SIGNAL	nii1l	:	STD_LOGIC := '0';
	 SIGNAL	nii1O	:	STD_LOGIC := '0';
	 SIGNAL	niiii	:	STD_LOGIC := '0';
	 SIGNAL	niiil	:	STD_LOGIC := '0';
	 SIGNAL	niiiO	:	STD_LOGIC := '0';
	 SIGNAL	niili	:	STD_LOGIC := '0';
	 SIGNAL	niill	:	STD_LOGIC := '0';
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
	 SIGNAL	wire_n1iO_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_n1iO_PRN	:	STD_LOGIC;
	 SIGNAL  wire_n1iO_w_lg_w_lg_n10O76w77w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_ni0il398w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_ni0iO400w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_ni0li402w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_ni0ll404w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_nii0i412w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_nii0l381w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_nii0O382w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_nii1i406w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_nii1l408w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_nii1O410w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_niiii384w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_niiil386w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_n10O76w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_w_lg_w_lg_nii0l377w378w379w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_w_lg_nii0l377w378w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1iO_w_lg_nii0l377w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nlOOll	:	STD_LOGIC := '0';
	 SIGNAL	wire_nlOOli_CLRN	:	STD_LOGIC;
	 SIGNAL	wire_nlOOli_PRN	:	STD_LOGIC;
	 SIGNAL  wire_nlOOli_w_lg_nlOOll719w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO1O_w_lg_w_q_range122w224w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO1O_w_lg_w_q_range124w156w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO1O_w_lg_w_q_range138w141w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO1O_w_lg_w_q_range144w145w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO1O_aclr	:	STD_LOGIC;
	 SIGNAL  wire_niO1O_q	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_niO1O_w_q_range122w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO1O_w_q_range124w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO1O_w_q_range138w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_niO1O_w_q_range144w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllOOi_w_lg_w_q_range754w799w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllOOi_w_lg_w_q_range757w802w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllOOi_aclr	:	STD_LOGIC;
	 SIGNAL  wire_nllOOi_q	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nllOOi_w_q_range754w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllOOi_w_q_range757w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_n0l0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1i0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1iii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1lOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1O1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_ni11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl01O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl1Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nliOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll0l_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nll0l_w_lg_w_lg_dataout364w365w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nll0l_w_lg_dataout364w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nll0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOili_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOill_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOilO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl1O_dataout	:	STD_LOGIC;
	 SIGNAL  wire_n0iOO_a	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n0iOO_b	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL  wire_n0iOO_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n0l1i_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n0l1i_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n0l1i_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_n10lO_w_lg_w_o_range797w798w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n10lO_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n10lO_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n10lO_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n10lO_w_o_range797w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1ll_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1ll_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1ll_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1lO_w_lg_w_o_range139w140w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n1lO_a	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1lO_b	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1lO_o	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n1lO_w_o_range139w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nilli_a	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nilli_b	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nilli_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_niO1i_a	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_niO1i_b	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_niO1i_o	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO00i_a	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nlO00i_b	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nlO00i_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n0iOl_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_n0iOl_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_niO1l_i	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_niO1l_o	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlO01O_a	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlO01O_b	:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	 SIGNAL  wire_nlO01O_o	:	STD_LOGIC;
	 SIGNAL  wire_n0iiO_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n0iiO_o	:	STD_LOGIC;
	 SIGNAL  wire_n0iiO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ili_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n0ili_o	:	STD_LOGIC;
	 SIGNAL  wire_n0ili_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ill_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n0ill_o	:	STD_LOGIC;
	 SIGNAL  wire_n0ill_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0ilO_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n0ilO_o	:	STD_LOGIC;
	 SIGNAL  wire_n0ilO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_n0iOi_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_n0iOi_o	:	STD_LOGIC;
	 SIGNAL  wire_n0iOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nilll_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nilll_o	:	STD_LOGIC;
	 SIGNAL  wire_nilll_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nillO_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nillO_o	:	STD_LOGIC;
	 SIGNAL  wire_nillO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nilOi_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nilOi_o	:	STD_LOGIC;
	 SIGNAL  wire_nilOi_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nilOl_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nilOl_o	:	STD_LOGIC;
	 SIGNAL  wire_nilOl_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nilOO_data	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nilOO_o	:	STD_LOGIC;
	 SIGNAL  wire_nilOO_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlll1O117w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllO0O91w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nliliO717w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlilll714w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nliO0i708w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nliOll703w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nll1Oi368w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlliil116w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlll1O83w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nlllii78w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllO0O111w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nllO1O71w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_reset229w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  nliliO :	STD_LOGIC;
	 SIGNAL  nlilli :	STD_LOGIC;
	 SIGNAL  nlilll :	STD_LOGIC;
	 SIGNAL  nlillO :	STD_LOGIC;
	 SIGNAL  nlilOi :	STD_LOGIC;
	 SIGNAL  nlilOl :	STD_LOGIC;
	 SIGNAL  nlilOO :	STD_LOGIC;
	 SIGNAL  nliO0i :	STD_LOGIC;
	 SIGNAL  nliO0l :	STD_LOGIC;
	 SIGNAL  nliO0O :	STD_LOGIC;
	 SIGNAL  nliO1O :	STD_LOGIC;
	 SIGNAL  nliOii :	STD_LOGIC;
	 SIGNAL  nliOil :	STD_LOGIC;
	 SIGNAL  nliOiO :	STD_LOGIC;
	 SIGNAL  nliOli :	STD_LOGIC;
	 SIGNAL  nliOll :	STD_LOGIC;
	 SIGNAL  nliOlO :	STD_LOGIC;
	 SIGNAL  nliOOO :	STD_LOGIC;
	 SIGNAL  nll10i :	STD_LOGIC;
	 SIGNAL  nll10l :	STD_LOGIC;
	 SIGNAL  nll10O :	STD_LOGIC;
	 SIGNAL  nll11i :	STD_LOGIC;
	 SIGNAL  nll11l :	STD_LOGIC;
	 SIGNAL  nll11O :	STD_LOGIC;
	 SIGNAL  nll1ii :	STD_LOGIC;
	 SIGNAL  nll1il :	STD_LOGIC;
	 SIGNAL  nll1iO :	STD_LOGIC;
	 SIGNAL  nll1li :	STD_LOGIC;
	 SIGNAL  nll1ll :	STD_LOGIC;
	 SIGNAL  nll1lO :	STD_LOGIC;
	 SIGNAL  nll1Oi :	STD_LOGIC;
	 SIGNAL  nlliil :	STD_LOGIC;
	 SIGNAL  nlliiO :	STD_LOGIC;
	 SIGNAL  nllilO :	STD_LOGIC;
	 SIGNAL  nlliOi :	STD_LOGIC;
	 SIGNAL  nlll0i :	STD_LOGIC;
	 SIGNAL  nlll1O :	STD_LOGIC;
	 SIGNAL  nlllii :	STD_LOGIC;
	 SIGNAL  nlllli :	STD_LOGIC;
	 SIGNAL  nlllll :	STD_LOGIC;
	 SIGNAL  nllO0O :	STD_LOGIC;
	 SIGNAL  nllO1O :	STD_LOGIC;
	 SIGNAL  nllOii :	STD_LOGIC;
	 SIGNAL  nllOlO :	STD_LOGIC;
 BEGIN

	wire_gnd <= '0';
	wire_vcc <= '1';
	wire_w_lg_nlll1O117w(0) <= nlll1O AND wire_w_lg_nlliil116w(0);
	wire_w_lg_nllO0O91w(0) <= nllO0O AND wire_n10i_w_lg_w_lg_n10l89w90w(0);
	wire_w_lg_nliliO717w(0) <= NOT nliliO;
	wire_w_lg_nlilll714w(0) <= NOT nlilll;
	wire_w_lg_nliO0i708w(0) <= NOT nliO0i;
	wire_w_lg_nliOll703w(0) <= NOT nliOll;
	wire_w_lg_nll1Oi368w(0) <= NOT nll1Oi;
	wire_w_lg_nlliil116w(0) <= NOT nlliil;
	wire_w_lg_nlll1O83w(0) <= NOT nlll1O;
	wire_w_lg_nlllii78w(0) <= NOT nlllii;
	wire_w_lg_nllO0O111w(0) <= NOT nllO0O;
	wire_w_lg_nllO1O71w(0) <= NOT nllO1O;
	wire_w_lg_reset229w(0) <= NOT reset;
	nliliO <= (((((((((((((((n100l XOR n100i) XOR n101O) XOR n101l) XOR n101i) XOR n11OO) XOR n11Ol) XOR n11Oi) XOR n11lO) XOR n11ll) XOR n11li) XOR n11iO) XOR n11il) XOR n11ii) XOR n110O) XOR n110l);
	nlilli <= ((((((NOT wire_nllOOi_q(0)) AND (NOT (wire_nllOOi_q(1) XOR wire_n10lO_o(0)))) AND (NOT (wire_nllOOi_q(2) XOR wire_n10lO_o(1)))) AND (NOT wire_nllOOi_w_lg_w_q_range754w799w(0))) AND (NOT wire_nllOOi_w_lg_w_q_range757w802w(0))) AND (NOT (wire_nllOOi_q(5) XOR wire_n10lO_o(2))));
	nlilll <= ((((((NOT wire_nllOOi_q(0)) AND (NOT wire_nllOOi_q(1))) AND (NOT wire_nllOOi_q(2))) AND (NOT wire_nllOOi_q(3))) AND (NOT wire_nllOOi_q(4))) AND (NOT wire_nllOOi_q(5)));
	nlillO <= ((((((NOT wire_nllOOi_q(0)) AND (NOT (wire_nllOOi_q(1) XOR wire_n10lO_o(0)))) AND (NOT (wire_nllOOi_q(2) XOR wire_n10lO_o(1)))) AND (NOT wire_nllOOi_w_lg_w_q_range754w799w(0))) AND (NOT wire_nllOOi_w_lg_w_q_range757w802w(0))) AND (NOT (wire_nllOOi_q(5) XOR wire_n10lO_o(2))));
	nlilOi <= ((((((NOT wire_nllOOi_q(0)) AND (NOT wire_nllOOi_q(1))) AND (NOT wire_nllOOi_q(2))) AND (NOT wire_nllOOi_q(3))) AND (NOT wire_nllOOi_q(4))) AND (NOT wire_nllOOi_q(5)));
	nlilOl <= ((((((NOT wire_nllOOi_q(0)) AND (NOT wire_nllOOi_q(1))) AND (NOT wire_nllOOi_q(2))) AND (NOT wire_nllOOi_q(3))) AND (NOT wire_nllOOi_q(4))) AND (NOT wire_nllOOi_q(5)));
	nlilOO <= ((((((NOT wire_nllOOi_q(0)) AND (NOT wire_nllOOi_q(1))) AND (NOT wire_nllOOi_q(2))) AND (NOT wire_nllOOi_q(3))) AND (NOT wire_nllOOi_q(4))) AND (NOT wire_nllOOi_q(5)));
	nliO0i <= (n111O AND n111l);
	nliO0l <= (n111i XOR wire_w_lg_nliliO717w(0));
	nliO0O <= (n01Oi OR wire_n0iii_w_lg_n010l597w(0));
	nliO1O <= (n100O AND nlilll);
	nliOii <= (n01lO OR wire_n0iii_w_lg_n010i595w(0));
	nliOil <= (n01ll OR wire_n0iii_w_lg_n011O593w(0));
	nliOiO <= (n01li OR wire_n0iii_w_lg_n011l591w(0));
	nliOli <= (((n110i AND n111O) AND wire_n0iii_w_lg_n111l603w(0)) OR (wire_n0iii_w_lg_w_lg_n110i605w606w(0) AND wire_n0iii_w_lg_n111l603w(0)));
	nliOll <= (wire_n0iii_w_lg_w_lg_w_lg_n00Ol563w564w565w(0) OR (((wire_n0iii_w_lg_n00Ol563w(0) OR (n00lO AND n00ll)) AND wire_n0iii_w_lg_w_lg_w_lg_n00Ol568w569w570w(0)) AND (n111O OR wire_nlO01O_o)));
	nliOlO <= ((n110i AND n111O) AND wire_n0iii_w_lg_n111l603w(0));
	nliOOO <= (wire_n1iO_w_lg_nii0i412w(0) AND ni01O);
	nll10i <= (nil1l AND wire_n1iO_w_lg_ni0il398w(0));
	nll10l <= (nil0i AND wire_n1iO_w_lg_ni0iO400w(0));
	nll10O <= (nil0l AND wire_n1iO_w_lg_ni0li402w(0));
	nll11i <= (wire_n1iO_w_lg_nii1O410w(0) AND ni01l);
	nll11l <= (wire_n1iO_w_lg_nii1l408w(0) AND ni01i);
	nll11O <= (wire_n1iO_w_lg_nii1i406w(0) AND ni1OO);
	nll1ii <= (nil0O AND wire_n1iO_w_lg_ni0ll404w(0));
	nll1il <= (n00ii AND wire_n0iii_w_lg_n001O583w(0));
	nll1iO <= (n00il AND wire_n0iii_w_lg_n000i585w(0));
	nll1li <= (n00iO AND wire_n0iii_w_lg_n000l587w(0));
	nll1ll <= (n00li AND wire_n0iii_w_lg_n000O589w(0));
	nll1lO <= ((NOT ((niiii OR niiil) AND (nii0l OR nii0O))) AND wire_n1iO_w_lg_w_lg_w_lg_nii0l377w378w379w(0));
	nll1Oi <= ((wire_nll0l_dataout AND wire_nll1O_dataout) OR wire_nll0l_w_lg_w_lg_dataout364w365w(0));
	nlliil <= ((((wire_n1iO_w_lg_nii0l381w(0) AND wire_n1iO_w_lg_nii0O382w(0)) AND wire_n1iO_w_lg_niiii384w(0)) AND wire_n1iO_w_lg_niiil386w(0)) OR (nll1lO AND wire_nll0i_dataout));
	nlliiO <= ((((wire_niO1O_w_lg_w_q_range122w224w(0) AND (NOT wire_niO1O_q(2))) AND (NOT wire_niO1O_q(3))) AND (NOT wire_niO1O_q(4))) AND (NOT wire_niO1O_q(5)));
	nllilO <= ((((((NOT wire_niO1O_q(0)) AND (NOT ((wire_niO1O_q(1) XOR wire_n1lO_o(0)) XOR (NOT (nll01O44 XOR nll01O43))))) AND (NOT ((wire_niO1O_q(2) XOR wire_n1lO_o(1)) XOR (NOT (nll01i46 XOR nll01i45))))) AND (NOT (wire_niO1O_w_lg_w_q_range138w141w(0) XOR (NOT (nll1Ol48 XOR nll1Ol47))))) AND (NOT wire_niO1O_w_lg_w_q_range144w145w(0))) AND (NOT (wire_niO1O_q(5) XOR wire_n1lO_o(2))));
	nlliOi <= (((((((NOT wire_niO1O_q(0)) AND wire_niO1O_q(4)) AND (NOT wire_niO1O_q(5))) AND (NOT (wire_niO1O_q(1) XOR wire_n1ll_o(0)))) AND (NOT ((wire_niO1O_q(2) XOR wire_n1ll_o(1)) XOR (NOT (nll0Oi34 XOR nll0Oi33))))) AND (NOT ((wire_niO1O_q(3) XOR wire_n1ll_o(2)) XOR (NOT (nll0ll36 XOR nll0ll35))))) AND (nll0iO38 XOR nll0iO37));
	nlll0i <= ((((((NOT wire_niO1O_q(0)) AND (NOT (wire_niO1O_q(1) XOR wire_n1lO_o(0)))) AND (NOT ((wire_niO1O_q(2) XOR wire_n1lO_o(1)) XOR (NOT (nlli0i28 XOR nlli0i27))))) AND (NOT wire_niO1O_w_lg_w_q_range138w141w(0))) AND (NOT (wire_niO1O_w_lg_w_q_range144w145w(0) XOR (NOT (nlli1l30 XOR nlli1l29))))) AND (NOT (wire_niO1O_q(5) XOR wire_n1lO_o(2))));
	nlll1O <= (((((((NOT wire_niO1O_q(0)) AND wire_niO1O_w_lg_w_q_range124w156w(0)) AND (NOT wire_niO1O_q(2))) AND (NOT wire_niO1O_q(3))) AND (NOT wire_niO1O_q(4))) AND (NOT wire_niO1O_q(5))) AND (nll0OO32 XOR nll0OO31));
	nlllii <= (n11O AND wire_n10i_w_lg_n10l18w(0));
	nlllli <= (((((((NOT wire_niO1O_q(0)) AND wire_niO1O_w_lg_w_q_range124w156w(0)) AND (NOT wire_niO1O_q(2))) AND wire_niO1O_q(3)) AND wire_niO1O_q(4)) AND (NOT wire_niO1O_q(5))) AND (nll00l42 XOR nll00l41));
	nlllll <= '1';
	nllO0O <= ((wire_n1iO_w_lg_w_lg_n10O76w77w(0) AND wire_w_lg_nlllii78w(0)) AND (nlll0l18 XOR nlll0l17));
	nllO1O <= (((((((NOT wire_niO1O_q(0)) AND wire_niO1O_w_lg_w_q_range124w156w(0)) AND (NOT wire_niO1O_q(2))) AND (NOT wire_niO1O_q(3))) AND (NOT wire_niO1O_q(4))) AND (NOT wire_niO1O_q(5))) AND (nll0ii40 XOR nll0ii39));
	nllOii <= (wire_n10i_w_lg_w_lg_n10l18w19w(0) OR (NOT (nllOil2 XOR nllOil1)));
	nllOlO <= (nlOOii AND (nlOOiO AND nlOOil));
	phy_tx_clav <= n11i;
	phy_tx_data <= ( nlOOO & nlOOl & nlOOi & nlOlO & nlOll & nlOli & nlOiO & nlOil & nlOii & nlO0O & nlO0l & nlO0i & nlO1O & nlO1l & nlO1i & nllOO);
	phy_tx_fifo_full <= nil1i;
	phy_tx_soc <= n11l;
	phy_tx_valid <= n1li;
	tx_cell_disc_pulse <= nlOOOl;
	tx_cell_err_pulse <= nlOOlO;
	tx_cell_pulse <= nlOOOi;
	tx_clav <= nlOO0O;
	tx_clav_enb <= nllOlO;
	tx_prty_pulse <= nlOOOO;
	wire_n10Oi_data <= ( nlOO0l & nlOO0i & nlOO1O & nlOO1l & nlOO1i & nlOlOO & nlOlOl & nlOlOi & nlOllO & nlOlll & nlOlli & nlOliO & nlOlil & nlOlii & nlOl0O & nlO01l);
	wire_n10Oi_rdaddress <= ( wire_nilil_dataout & wire_nilii_dataout & wire_nilOO_o & wire_nilOl_o & wire_nilOi_o & wire_nillO_o & wire_nilll_o);
	wire_n10Oi_wraddress <= ( n0i1l & n00OO & n0iil & n0i0O & n0i0l & n0i0i & n0i1O);
	wire_n10Oi_wren <= wire_n0iii_w_lg_w_lg_n1l0O654w655w(0);
	wire_n0iii_w_lg_w_lg_n1l0O654w655w(0) <= wire_n0iii_w_lg_n1l0O654w(0) AND n110i;
	n10Oi :  altdpram
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
		data => wire_n10Oi_data,
		inclock => tx_clk,
		inclocken => wire_vcc,
		outclock => phy_tx_clk,
		outclocken => wire_vcc,
		q => wire_n10Oi_q,
		rdaddress => wire_n10Oi_rdaddress,
		rden => wire_vcc,
		wraddress => wire_n10Oi_wraddress,
		wren => wire_n10Oi_wren
	  );
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nliO1i55 <= nliO1i56;
		END IF;
		if (now = 0 ns) then
			nliO1i55 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nliO1i56 <= nliO1i55;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nliO1l53 <= nliO1l54;
		END IF;
		if (now = 0 ns) then
			nliO1l53 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nliO1l54 <= nliO1l53;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nliOOi51 <= nliOOi52;
		END IF;
		if (now = 0 ns) then
			nliOOi51 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nliOOi52 <= nliOOi51;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nliOOl49 <= nliOOl50;
		END IF;
		if (now = 0 ns) then
			nliOOl49 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nliOOl50 <= nliOOl49;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll00l41 <= nll00l42;
		END IF;
		if (now = 0 ns) then
			nll00l41 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll00l42 <= nll00l41;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll01i45 <= nll01i46;
		END IF;
		if (now = 0 ns) then
			nll01i45 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll01i46 <= nll01i45;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll01O43 <= nll01O44;
		END IF;
		if (now = 0 ns) then
			nll01O43 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll01O44 <= nll01O43;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0ii39 <= nll0ii40;
		END IF;
		if (now = 0 ns) then
			nll0ii39 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0ii40 <= nll0ii39;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0iO37 <= nll0iO38;
		END IF;
		if (now = 0 ns) then
			nll0iO37 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0iO38 <= nll0iO37;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0ll35 <= nll0ll36;
		END IF;
		if (now = 0 ns) then
			nll0ll35 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0ll36 <= nll0ll35;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0Oi33 <= nll0Oi34;
		END IF;
		if (now = 0 ns) then
			nll0Oi33 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0Oi34 <= nll0Oi33;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0OO31 <= nll0OO32;
		END IF;
		if (now = 0 ns) then
			nll0OO31 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll0OO32 <= nll0OO31;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll1Ol47 <= nll1Ol48;
		END IF;
		if (now = 0 ns) then
			nll1Ol47 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nll1Ol48 <= nll1Ol47;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlli0i27 <= nlli0i28;
		END IF;
		if (now = 0 ns) then
			nlli0i27 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlli0i28 <= nlli0i27;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlli0O25 <= nlli0O26;
		END IF;
		if (now = 0 ns) then
			nlli0O25 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlli0O26 <= nlli0O25;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlli1l29 <= nlli1l30;
		END IF;
		if (now = 0 ns) then
			nlli1l29 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlli1l30 <= nlli1l29;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllili23 <= nllili24;
		END IF;
		if (now = 0 ns) then
			nllili23 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllili24 <= nllili23;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlliOl21 <= nlliOl22;
		END IF;
		if (now = 0 ns) then
			nlliOl21 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlliOl22 <= nlliOl21;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlll0l17 <= nlll0l18;
		END IF;
		if (now = 0 ns) then
			nlll0l17 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlll0l18 <= nlll0l17;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlll1i19 <= nlll1i20;
		END IF;
		if (now = 0 ns) then
			nlll1i19 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlll1i20 <= nlll1i19;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlllil15 <= nlllil16;
		END IF;
		if (now = 0 ns) then
			nlllil15 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlllil16 <= nlllil15;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllliO13 <= nllliO14;
		END IF;
		if (now = 0 ns) then
			nllliO13 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllliO14 <= nllliO13;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllllO11 <= nllllO12;
		END IF;
		if (now = 0 ns) then
			nllllO11 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllllO12 <= nllllO11;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlllOi10 <= nlllOi9;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlllOi9 <= nlllOi10;
		END IF;
		if (now = 0 ns) then
			nlllOi9 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlllOl7 <= nlllOl8;
		END IF;
		if (now = 0 ns) then
			nlllOl7 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nlllOl8 <= nlllOl7;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllO0i3 <= nllO0i4;
		END IF;
		if (now = 0 ns) then
			nllO0i3 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllO0i4 <= nllO0i3;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllO1i5 <= nllO1i6;
		END IF;
		if (now = 0 ns) then
			nllO1i5 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllO1i6 <= nllO1i5;
		END IF;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllOil1 <= nllOil2;
		END IF;
		if (now = 0 ns) then
			nllOil1 <= '1' after 1 ps;
		end if;
	END PROCESS;
	PROCESS (tx_clk)
	BEGIN
		IF (tx_clk = '1' AND tx_clk'event) THEN nllOil2 <= nllOil1;
		END IF;
	END PROCESS;
	PROCESS (tx_clk, wire_n0i1i_CLRN)
	BEGIN
		IF (wire_n0i1i_CLRN = '0') THEN
				n00OO <= '0';
				n0i1l <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN
			IF (nliOlO = '1') THEN
				n00OO <= wire_n0iOO_o(0);
				n0i1l <= wire_n0iOO_o(1);
			END IF;
		END IF;
	END PROCESS;
	wire_n0i1i_CLRN <= ((nliOOi52 XOR nliOOi51) AND reset);
	PROCESS (tx_clk, wire_n0iii_PRN, reset)
	BEGIN
		IF (wire_n0iii_PRN = '0') THEN
				n000i <= '1';
				n000l <= '1';
				n000O <= '1';
				n001i <= '1';
				n001l <= '1';
				n001O <= '1';
				n00ii <= '1';
				n00il <= '1';
				n00iO <= '1';
				n00li <= '1';
				n00ll <= '1';
				n00lO <= '1';
				n00Oi <= '1';
				n00Ol <= '1';
				n010i <= '1';
				n010l <= '1';
				n010O <= '1';
				n011l <= '1';
				n011O <= '1';
				n01ii <= '1';
				n01il <= '1';
				n01iO <= '1';
				n01li <= '1';
				n01ll <= '1';
				n01lO <= '1';
				n01Oi <= '1';
				n01Ol <= '1';
				n01OO <= '1';
				n0i0i <= '1';
				n0i0l <= '1';
				n0i0O <= '1';
				n0i1O <= '1';
				n0iil <= '1';
				n100i <= '1';
				n100l <= '1';
				n100O <= '1';
				n101i <= '1';
				n101l <= '1';
				n101O <= '1';
				n10il <= '1';
				n110i <= '1';
				n110l <= '1';
				n110O <= '1';
				n111i <= '1';
				n111l <= '1';
				n111O <= '1';
				n11ii <= '1';
				n11il <= '1';
				n11iO <= '1';
				n11li <= '1';
				n11ll <= '1';
				n11lO <= '1';
				n11Oi <= '1';
				n11Ol <= '1';
				n11OO <= '1';
				n1l0O <= '1';
				nlO01l <= '1';
				nlOl0O <= '1';
				nlOlii <= '1';
				nlOlil <= '1';
				nlOliO <= '1';
				nlOlli <= '1';
				nlOlll <= '1';
				nlOllO <= '1';
				nlOlOi <= '1';
				nlOlOl <= '1';
				nlOlOO <= '1';
				nlOO0i <= '1';
				nlOO0l <= '1';
				nlOO0O <= '1';
				nlOO1i <= '1';
				nlOO1l <= '1';
				nlOO1O <= '1';
				nlOOii <= '1';
				nlOOil <= '1';
				nlOOiO <= '1';
				nlOOlO <= '1';
				nlOOOi <= '1';
				nlOOOl <= '1';
				nlOOOO <= '1';
		ELSIF (reset = '0') THEN
				n000i <= '0';
				n000l <= '0';
				n000O <= '0';
				n001i <= '0';
				n001l <= '0';
				n001O <= '0';
				n00ii <= '0';
				n00il <= '0';
				n00iO <= '0';
				n00li <= '0';
				n00ll <= '0';
				n00lO <= '0';
				n00Oi <= '0';
				n00Ol <= '0';
				n010i <= '0';
				n010l <= '0';
				n010O <= '0';
				n011l <= '0';
				n011O <= '0';
				n01ii <= '0';
				n01il <= '0';
				n01iO <= '0';
				n01li <= '0';
				n01ll <= '0';
				n01lO <= '0';
				n01Oi <= '0';
				n01Ol <= '0';
				n01OO <= '0';
				n0i0i <= '0';
				n0i0l <= '0';
				n0i0O <= '0';
				n0i1O <= '0';
				n0iil <= '0';
				n100i <= '0';
				n100l <= '0';
				n100O <= '0';
				n101i <= '0';
				n101l <= '0';
				n101O <= '0';
				n10il <= '0';
				n110i <= '0';
				n110l <= '0';
				n110O <= '0';
				n111i <= '0';
				n111l <= '0';
				n111O <= '0';
				n11ii <= '0';
				n11il <= '0';
				n11iO <= '0';
				n11li <= '0';
				n11ll <= '0';
				n11lO <= '0';
				n11Oi <= '0';
				n11Ol <= '0';
				n11OO <= '0';
				n1l0O <= '0';
				nlO01l <= '0';
				nlOl0O <= '0';
				nlOlii <= '0';
				nlOlil <= '0';
				nlOliO <= '0';
				nlOlli <= '0';
				nlOlll <= '0';
				nlOllO <= '0';
				nlOlOi <= '0';
				nlOlOl <= '0';
				nlOlOO <= '0';
				nlOO0i <= '0';
				nlOO0l <= '0';
				nlOO0O <= '0';
				nlOO1i <= '0';
				nlOO1l <= '0';
				nlOO1O <= '0';
				nlOOii <= '0';
				nlOOil <= '0';
				nlOOiO <= '0';
				nlOOlO <= '0';
				nlOOOi <= '0';
				nlOOOl <= '0';
				nlOOOO <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN
				n000i <= n01OO;
				n000l <= n001i;
				n000O <= n001l;
				n001i <= ni01l;
				n001l <= ni01O;
				n001O <= n01Ol;
				n00ii <= wire_n1lOO_dataout;
				n00il <= wire_n1O1i_dataout;
				n00iO <= wire_n1O1l_dataout;
				n00li <= wire_n1O1O_dataout;
				n00ll <= wire_n1i0i_dataout;
				n00lO <= wire_n1i0l_dataout;
				n00Oi <= wire_n1i0O_dataout;
				n00Ol <= wire_n1iii_dataout;
				n010i <= n01lO;
				n010l <= n01Oi;
				n010O <= nll10i;
				n011l <= n01li;
				n011O <= n01ll;
				n01ii <= nll10l;
				n01il <= nll10O;
				n01iO <= nll1ii;
				n01li <= n010O;
				n01ll <= n01ii;
				n01lO <= n01il;
				n01Oi <= n01iO;
				n01Ol <= ni1OO;
				n01OO <= ni01i;
				n0i0i <= wire_n0ili_o;
				n0i0l <= wire_n0ill_o;
				n0i0O <= wire_n0ilO_o;
				n0i1O <= wire_n0iiO_o;
				n0iil <= wire_n0iOi_o;
				n100i <= tx_data(14);
				n100l <= tx_data(15);
				n100O <= tx_soc;
				n101i <= tx_data(11);
				n101l <= tx_data(12);
				n101O <= tx_data(13);
				n10il <= wire_nlOiOl_dataout;
				n110i <= wire_nlOi1i_dataout;
				n110l <= tx_data(0);
				n110O <= tx_data(1);
				n111i <= tx_prty;
				n111l <= wire_nlO0ll_dataout;
				n111O <= wire_nlOi1l_dataout;
				n11ii <= tx_data(2);
				n11il <= tx_data(3);
				n11iO <= tx_data(4);
				n11li <= tx_data(5);
				n11ll <= tx_data(6);
				n11lO <= tx_data(7);
				n11Oi <= tx_data(8);
				n11Ol <= tx_data(9);
				n11OO <= tx_data(10);
				n1l0O <= (((wire_n1iii_dataout AND wire_n1i0O_dataout) AND wire_n1i0l_dataout) AND wire_n1i0i_dataout);
				nlO01l <= n110l;
				nlOl0O <= n110O;
				nlOlii <= n11ii;
				nlOlil <= n11il;
				nlOliO <= n11iO;
				nlOlli <= n11li;
				nlOlll <= n11ll;
				nlOllO <= n11lO;
				nlOlOi <= n11Oi;
				nlOlOl <= n11Ol;
				nlOlOO <= n11OO;
				nlOO0i <= n100i;
				nlOO0l <= n100l;
				nlOO0O <= wire_w_lg_nliOll703w(0);
				nlOO1i <= n101i;
				nlOO1l <= n101l;
				nlOO1O <= n101O;
				nlOOii <= (NOT tx_addr(4));
				nlOOil <= ((NOT tx_addr(2)) AND (NOT tx_addr(3)));
				nlOOiO <= ((NOT tx_addr(0)) AND (NOT tx_addr(1)));
				nlOOlO <= wire_nlO00l_dataout;
				nlOOOi <= (wire_nlOiOl_dataout AND nliO1O);
				nlOOOl <= nliO0i;
				nlOOOO <= (wire_nlOiOl_dataout AND nliO0l);
		END IF;
		if (now = 0 ns) then
			n000i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n000l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n000O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n001i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n001l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n001O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n00ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n00il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n00iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n00li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n00ll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n00lO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n00Oi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n00Ol <= '1' after 1 ps;
		end if;
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
			n01iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n01li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n01ll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n01lO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n01Oi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n01Ol <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n01OO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0i0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0i0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0i0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0i1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n0iil <= '1' after 1 ps;
		end if;
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
			n10il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n110i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n110l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n110O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n111i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n111l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n111O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11il <= '1' after 1 ps;
		end if;
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
			n11Oi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11Ol <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11OO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n1l0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlO01l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOl0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOlii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOlil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOliO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOlli <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOlll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOllO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOlOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOlOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOlOO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOO0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOO0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOO0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOO1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOO1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOO1O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOil <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOiO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOlO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOOi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOOl <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nlOOOO <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n0iii_PRN <= (nliOOl50 XOR nliOOl49);
	wire_n0iii_w_lg_w_lg_w_lg_n00Ol563w564w565w(0) <= wire_n0iii_w_lg_w_lg_n00Ol563w564w(0) AND n00ll;
	wire_n0iii_w_lg_w_lg_n00Ol563w564w(0) <= wire_n0iii_w_lg_n00Ol563w(0) AND n00lO;
	wire_n0iii_w_lg_w_lg_n110i605w606w(0) <= wire_n0iii_w_lg_n110i605w(0) AND n111O;
	wire_n0iii_w_lg_n00Ol563w(0) <= n00Ol AND n00Oi;
	wire_n0iii_w_lg_n000i585w(0) <= NOT n000i;
	wire_n0iii_w_lg_n000l587w(0) <= NOT n000l;
	wire_n0iii_w_lg_n000O589w(0) <= NOT n000O;
	wire_n0iii_w_lg_n001O583w(0) <= NOT n001O;
	wire_n0iii_w_lg_n010i595w(0) <= NOT n010i;
	wire_n0iii_w_lg_n010l597w(0) <= NOT n010l;
	wire_n0iii_w_lg_n011l591w(0) <= NOT n011l;
	wire_n0iii_w_lg_n011O593w(0) <= NOT n011O;
	wire_n0iii_w_lg_n100O720w(0) <= NOT n100O;
	wire_n0iii_w_lg_n110i605w(0) <= NOT n110i;
	wire_n0iii_w_lg_n111l603w(0) <= NOT n111l;
	wire_n0iii_w_lg_n1l0O654w(0) <= NOT n1l0O;
	wire_n0iii_w_lg_w_lg_w_lg_n00Ol568w569w570w(0) <= wire_n0iii_w_lg_w_lg_n00Ol568w569w(0) XOR n00ll;
	wire_n0iii_w_lg_w_lg_n00Ol568w569w(0) <= wire_n0iii_w_lg_n00Ol568w(0) XOR n00lO;
	wire_n0iii_w_lg_n00Ol568w(0) <= n00Ol XOR n00Oi;
	PROCESS (phy_tx_clk, reset, wire_n10i_CLRN)
	BEGIN
		IF (reset = '0') THEN
				n10l <= '1';
				n11O <= '1';
		ELSIF (wire_n10i_CLRN = '0') THEN
				n10l <= '0';
				n11O <= '0';
		ELSIF (phy_tx_clk = '1' AND phy_tx_clk'event) THEN
				n10l <= wire_nl1li_dataout;
				n11O <= n10l;
		END IF;
		if (now = 0 ns) then
			n10l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n11O <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n10i_CLRN <= (nlllil16 XOR nlllil15);
	wire_n10i_w_lg_n10l89w(0) <= n10l AND nlll0i;
	wire_n10i_w_lg_w_lg_n10l89w90w(0) <= NOT wire_n10i_w_lg_n10l89w(0);
	wire_n10i_w_lg_n10l18w(0) <= NOT n10l;
	wire_n10i_w_lg_n11O75w(0) <= NOT n11O;
	wire_n10i_w_lg_w_lg_n10l18w19w(0) <= wire_n10i_w_lg_n10l18w(0) OR wire_nl1Oi_dataout;
	PROCESS (tx_clk, reset)
	BEGIN
		IF (reset = '0') THEN
				n10ii <= '1';
				n10iO <= '1';
				n10ll <= '1';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN
				n10ii <= nllOlO;
				n10iO <= n10ll;
				n10ll <= tx_enb;
		END IF;
		if (now = 0 ns) then
			n10ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			n10ll <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n10li_w_lg_n10ll704w(0) <= NOT n10ll;
	PROCESS (phy_tx_clk, wire_n1ii_CLRN)
	BEGIN
		IF (wire_n1ii_CLRN = '0') THEN
				n1il <= '0';
		ELSIF (phy_tx_clk = '1' AND phy_tx_clk'event) THEN
			IF (nllO0O = '1') THEN
				n1il <= nlllli;
			END IF;
		END IF;
		if (now = 0 ns) then
			n1il <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_n1ii_CLRN <= ((nllliO14 XOR nllliO13) AND reset);
	PROCESS (phy_tx_clk, wire_n1iO_PRN, wire_n1iO_CLRN)
	BEGIN
		IF (wire_n1iO_PRN = '0') THEN
				n10O <= '1';
				n11i <= '1';
				n11l <= '1';
				n1li <= '1';
				ni00i <= '1';
				ni00l <= '1';
				ni00O <= '1';
				ni01i <= '1';
				ni01l <= '1';
				ni01O <= '1';
				ni0ii <= '1';
				ni0il <= '1';
				ni0iO <= '1';
				ni0li <= '1';
				ni0ll <= '1';
				ni0lO <= '1';
				ni0Oi <= '1';
				ni0Ol <= '1';
				ni0OO <= '1';
				ni1OO <= '1';
				nii0i <= '1';
				nii0l <= '1';
				nii0O <= '1';
				nii1i <= '1';
				nii1l <= '1';
				nii1O <= '1';
				niiii <= '1';
				niiil <= '1';
				niiiO <= '1';
				niili <= '1';
				niill <= '1';
				niilO <= '1';
				niiOi <= '1';
				niiOl <= '1';
				niiOO <= '1';
				nil0i <= '1';
				nil0l <= '1';
				nil0O <= '1';
				nil1i <= '1';
				nil1l <= '1';
				nil1O <= '1';
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
		ELSIF (wire_n1iO_CLRN = '0') THEN
				n10O <= '0';
				n11i <= '0';
				n11l <= '0';
				n1li <= '0';
				ni00i <= '0';
				ni00l <= '0';
				ni00O <= '0';
				ni01i <= '0';
				ni01l <= '0';
				ni01O <= '0';
				ni0ii <= '0';
				ni0il <= '0';
				ni0iO <= '0';
				ni0li <= '0';
				ni0ll <= '0';
				ni0lO <= '0';
				ni0Oi <= '0';
				ni0Ol <= '0';
				ni0OO <= '0';
				ni1OO <= '0';
				nii0i <= '0';
				nii0l <= '0';
				nii0O <= '0';
				nii1i <= '0';
				nii1l <= '0';
				nii1O <= '0';
				niiii <= '0';
				niiil <= '0';
				niiiO <= '0';
				niili <= '0';
				niill <= '0';
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
		ELSIF (phy_tx_clk = '1' AND phy_tx_clk'event) THEN
				n10O <= wire_nl1Oi_dataout;
				n11i <= (NOT (n10l OR (nil1O AND wire_w_lg_nllO1O71w(0))));
				n11l <= wire_n1Oi_dataout;
				n1li <= nllOii;
				ni00i <= n011l;
				ni00l <= n011O;
				ni00O <= n010i;
				ni01i <= nii1l;
				ni01l <= nii1O;
				ni01O <= nii0i;
				ni0ii <= n010l;
				ni0il <= ni00i;
				ni0iO <= ni00l;
				ni0li <= ni00O;
				ni0ll <= ni0ii;
				ni0lO <= nll1il;
				ni0Oi <= nll1iO;
				ni0Ol <= nll1li;
				ni0OO <= nll1ll;
				ni1OO <= nii1i;
				nii0i <= ni0OO;
				nii0l <= wire_n0l0O_dataout;
				nii0O <= wire_n0lii_dataout;
				nii1i <= ni0lO;
				nii1l <= ni0Oi;
				nii1O <= ni0Ol;
				niiii <= wire_n0lil_dataout;
				niiil <= wire_n0liO_dataout;
				niiiO <= wire_nilll_o;
				niili <= wire_nillO_o;
				niill <= wire_nilOi_o;
				niilO <= wire_nilOl_o;
				niiOi <= wire_nilOO_o;
				niiOl <= wire_nilii_dataout;
				niiOO <= wire_nilil_dataout;
				nil0i <= wire_ni11i_dataout;
				nil0l <= wire_ni11l_dataout;
				nil0O <= wire_ni11O_dataout;
				nil1i <= (((wire_n0l0O_dataout AND wire_n0lii_dataout) AND wire_n0lil_dataout) AND wire_n0liO_dataout);
				nil1l <= wire_n0OOO_dataout;
				nil1O <= nll1lO;
				nllOO <= wire_nl01i_dataout;
				nlO0i <= wire_nl00l_dataout;
				nlO0l <= wire_nl00O_dataout;
				nlO0O <= wire_nl0ii_dataout;
				nlO1i <= wire_nl01l_dataout;
				nlO1l <= wire_nl01O_dataout;
				nlO1O <= wire_nl00i_dataout;
				nlOii <= wire_nl0il_dataout;
				nlOil <= wire_nl0iO_dataout;
				nlOiO <= wire_nl0li_dataout;
				nlOli <= wire_nl0ll_dataout;
				nlOll <= wire_nl0lO_dataout;
				nlOlO <= wire_nl0Oi_dataout;
				nlOOi <= wire_nl0Ol_dataout;
				nlOOl <= wire_nl0OO_dataout;
				nlOOO <= wire_nli1i_dataout;
		END IF;
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
			n1li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni00i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni00l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni00O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni01i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni01l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni01O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0ii <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0il <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0iO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0li <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0ll <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0lO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0Oi <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0Ol <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni0OO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			ni1OO <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii0i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii0l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii0O <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii1i <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii1l <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			nii1O <= '1' after 1 ps;
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
			niili <= '1' after 1 ps;
		end if;
		if (now = 0 ns) then
			niill <= '1' after 1 ps;
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
	END PROCESS;
	wire_n1iO_CLRN <= ((nlllOi10 XOR nlllOi9) AND reset);
	wire_n1iO_PRN <= (nllllO12 XOR nllllO11);
	wire_n1iO_w_lg_w_lg_n10O76w77w(0) <= wire_n1iO_w_lg_n10O76w(0) AND phy_tx_enb;
	wire_n1iO_w_lg_ni0il398w(0) <= NOT ni0il;
	wire_n1iO_w_lg_ni0iO400w(0) <= NOT ni0iO;
	wire_n1iO_w_lg_ni0li402w(0) <= NOT ni0li;
	wire_n1iO_w_lg_ni0ll404w(0) <= NOT ni0ll;
	wire_n1iO_w_lg_nii0i412w(0) <= NOT nii0i;
	wire_n1iO_w_lg_nii0l381w(0) <= NOT nii0l;
	wire_n1iO_w_lg_nii0O382w(0) <= NOT nii0O;
	wire_n1iO_w_lg_nii1i406w(0) <= NOT nii1i;
	wire_n1iO_w_lg_nii1l408w(0) <= NOT nii1l;
	wire_n1iO_w_lg_nii1O410w(0) <= NOT nii1O;
	wire_n1iO_w_lg_niiii384w(0) <= NOT niiii;
	wire_n1iO_w_lg_niiil386w(0) <= NOT niiil;
	wire_n1iO_w_lg_n10O76w(0) <= n10O OR wire_n10i_w_lg_n11O75w(0);
	wire_n1iO_w_lg_w_lg_w_lg_nii0l377w378w379w(0) <= wire_n1iO_w_lg_w_lg_nii0l377w378w(0) XOR niiil;
	wire_n1iO_w_lg_w_lg_nii0l377w378w(0) <= wire_n1iO_w_lg_nii0l377w(0) XOR niiii;
	wire_n1iO_w_lg_nii0l377w(0) <= nii0l XOR nii0O;
	PROCESS (tx_clk, wire_nlOOli_PRN, wire_nlOOli_CLRN)
	BEGIN
		IF (wire_nlOOli_PRN = '0') THEN
				nlOOll <= '1';
		ELSIF (wire_nlOOli_CLRN = '0') THEN
				nlOOll <= '0';
		ELSIF (tx_clk = '1' AND tx_clk'event) THEN
			IF (wire_nlOiOl_dataout = '1') THEN
				nlOOll <= wire_nlO0ii_dataout;
			END IF;
		END IF;
		if (now = 0 ns) then
			nlOOll <= '1' after 1 ps;
		end if;
	END PROCESS;
	wire_nlOOli_CLRN <= ((nliO1l54 XOR nliO1l53) AND reset);
	wire_nlOOli_PRN <= (nliO1i56 XOR nliO1i55);
	wire_nlOOli_w_lg_nlOOll719w(0) <= NOT nlOOll;
	wire_niO1O_w_lg_w_q_range122w224w(0) <= wire_niO1O_w_q_range122w(0) AND wire_niO1O_w_lg_w_q_range124w156w(0);
	wire_niO1O_w_lg_w_q_range124w156w(0) <= NOT wire_niO1O_w_q_range124w(0);
	wire_niO1O_w_lg_w_q_range138w141w(0) <= wire_niO1O_w_q_range138w(0) XOR wire_n1lO_w_lg_w_o_range139w140w(0);
	wire_niO1O_w_lg_w_q_range144w145w(0) <= wire_niO1O_w_q_range144w(0) XOR wire_n1lO_w_lg_w_o_range139w140w(0);
	wire_niO1O_aclr <= wire_w_lg_reset229w(0);
	wire_niO1O_w_q_range122w(0) <= wire_niO1O_q(0);
	wire_niO1O_w_q_range124w(0) <= wire_niO1O_q(1);
	wire_niO1O_w_q_range138w(0) <= wire_niO1O_q(3);
	wire_niO1O_w_q_range144w(0) <= wire_niO1O_q(4);
	niO1O :  lpm_counter
	  GENERIC MAP (
		LPM_DIRECTION => "UP",
		LPM_MODULUS => 0,
		LPM_PORT_UPDOWN => "PORT_CONNECTIVITY",
		LPM_SVALUE => "0",
		LPM_WIDTH => 6
	  )
	  PORT MAP ( 
		aclr => wire_niO1O_aclr,
		clock => phy_tx_clk,
		cnt_en => nllO0O,
		q => wire_niO1O_q,
		sset => wire_nllll_dataout
	  );
	wire_nllOOi_w_lg_w_q_range754w799w(0) <= wire_nllOOi_w_q_range754w(0) XOR wire_n10lO_w_lg_w_o_range797w798w(0);
	wire_nllOOi_w_lg_w_q_range757w802w(0) <= wire_nllOOi_w_q_range757w(0) XOR wire_n10lO_w_lg_w_o_range797w798w(0);
	wire_nllOOi_aclr <= wire_w_lg_reset229w(0);
	wire_nllOOi_w_q_range754w(0) <= wire_nllOOi_q(3);
	wire_nllOOi_w_q_range757w(0) <= wire_nllOOi_q(4);
	nllOOi :  lpm_counter
	  GENERIC MAP (
		LPM_DIRECTION => "UP",
		LPM_MODULUS => 0,
		LPM_PORT_UPDOWN => "PORT_CONNECTIVITY",
		LPM_SVALUE => "0",
		LPM_WIDTH => 6
	  )
	  PORT MAP ( 
		aclr => wire_nllOOi_aclr,
		clock => tx_clk,
		cnt_en => wire_nlOili_dataout,
		q => wire_nllOOi_q,
		sset => wire_nlOill_dataout
	  );
	wire_n0l0O_dataout <= (nll11O OR (nii0l AND (NOT wire_niO1l_o(0)))) WHEN wire_nll1O_dataout = '1'  ELSE (nii0l OR nll11O);
	wire_n0lii_dataout <= (nll11l OR (nii0O AND (NOT wire_niO1l_o(1)))) WHEN wire_nll1O_dataout = '1'  ELSE (nii0O OR nll11l);
	wire_n0lil_dataout <= (nll11i OR (niiii AND (NOT wire_niO1l_o(2)))) WHEN wire_nll1O_dataout = '1'  ELSE (niiii OR nll11i);
	wire_n0liO_dataout <= (nliOOO OR (niiil AND (NOT wire_niO1l_o(3)))) WHEN wire_nll1O_dataout = '1'  ELSE (niiil OR nliOOO);
	wire_n0OOO_dataout <= (wire_niO1l_o(0) OR nll10i) WHEN wire_nll1O_dataout = '1'  ELSE nll10i;
	wire_n1i0i_dataout <= (nliOiO AND (n00ll OR wire_n0iOl_o(0))) WHEN nliOli = '1'  ELSE (n00ll AND nliOiO);
	wire_n1i0l_dataout <= (nliOil AND (n00lO OR wire_n0iOl_o(1))) WHEN nliOli = '1'  ELSE (n00lO AND nliOil);
	wire_n1i0O_dataout <= (nliOii AND (n00Oi OR wire_n0iOl_o(2))) WHEN nliOli = '1'  ELSE (n00Oi AND nliOii);
	wire_n1iii_dataout <= (nliO0O AND (n00Ol OR wire_n0iOl_o(3))) WHEN nliOli = '1'  ELSE (n00Ol AND nliO0O);
	wire_n1lOO_dataout <= (wire_n0iOl_o(0) OR nll1il) WHEN nliOli = '1'  ELSE nll1il;
	wire_n1O1i_dataout <= (wire_n0iOl_o(1) OR nll1iO) WHEN nliOli = '1'  ELSE nll1iO;
	wire_n1O1l_dataout <= (wire_n0iOl_o(2) OR nll1li) WHEN nliOli = '1'  ELSE nll1li;
	wire_n1O1O_dataout <= (wire_n0iOl_o(3) OR nll1ll) WHEN nliOli = '1'  ELSE nll1ll;
	wire_n1Oi_dataout <= wire_n1OO_dataout AND NOT(((nllO0O AND nllO1O) AND (nlllOl8 XOR nlllOl7)));
	wire_n1OO_dataout <= (nllOii AND ((nllO0O AND wire_nllll_dataout) AND (nllO0i4 XOR nllO0i3))) OR ((nllO1O AND nllOii) AND (nllO1i6 XOR nllO1i5));
	wire_ni11i_dataout <= (wire_niO1l_o(1) OR nll10l) WHEN wire_nll1O_dataout = '1'  ELSE nll10l;
	wire_ni11l_dataout <= (wire_niO1l_o(2) OR nll10O) WHEN wire_nll1O_dataout = '1'  ELSE nll10O;
	wire_ni11O_dataout <= (wire_niO1l_o(3) OR nll1ii) WHEN wire_nll1O_dataout = '1'  ELSE nll1ii;
	wire_nilii_dataout <= niiOl WHEN wire_w_lg_nll1Oi368w(0) = '1'  ELSE wire_nilli_o(0);
	wire_nilil_dataout <= niiOO WHEN wire_w_lg_nll1Oi368w(0) = '1'  ELSE wire_nilli_o(1);
	wire_nl00i_dataout <= wire_nli0l_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(3);
	wire_nl00l_dataout <= wire_nli0O_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(4);
	wire_nl00O_dataout <= wire_nliii_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(5);
	wire_nl01i_dataout <= wire_nli1l_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(0);
	wire_nl01l_dataout <= wire_nli1O_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(1);
	wire_nl01O_dataout <= wire_nli0i_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(2);
	wire_nl0ii_dataout <= wire_nliil_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(6);
	wire_nl0il_dataout <= wire_nliiO_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(7);
	wire_nl0iO_dataout <= wire_nlili_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(8);
	wire_nl0li_dataout <= wire_nlill_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(9);
	wire_nl0ll_dataout <= wire_nlilO_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(10);
	wire_nl0lO_dataout <= wire_nliOi_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(11);
	wire_nl0Oi_dataout <= wire_nliOl_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(12);
	wire_nl0Ol_dataout <= wire_nliOO_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(13);
	wire_nl0OO_dataout <= wire_nll1i_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(14);
	wire_nl1li_dataout <= wire_nl1ll_dataout OR nlliil;
	wire_nl1ll_dataout <= n10l AND NOT((wire_w_lg_nlll1O117w(0) AND (nlli0O26 XOR nlli0O25)));
	wire_nl1Oi_dataout <= wire_nl1Ol_dataout OR nlliiO;
	wire_nl1Ol_dataout <= n10O AND NOT(((nllO0O AND nllilO) AND (nllili24 XOR nllili23)));
	wire_nli0i_dataout <= wire_n10Oi_q(2) WHEN nlllii = '1'  ELSE nlO1l;
	wire_nli0l_dataout <= wire_n10Oi_q(3) WHEN nlllii = '1'  ELSE nlO1O;
	wire_nli0O_dataout <= wire_n10Oi_q(4) WHEN nlllii = '1'  ELSE nlO0i;
	wire_nli1i_dataout <= wire_nll1l_dataout WHEN wire_w_lg_nllO0O111w(0) = '1'  ELSE wire_n10Oi_q(15);
	wire_nli1l_dataout <= wire_n10Oi_q(0) WHEN nlllii = '1'  ELSE nllOO;
	wire_nli1O_dataout <= wire_n10Oi_q(1) WHEN nlllii = '1'  ELSE nlO1i;
	wire_nliii_dataout <= wire_n10Oi_q(5) WHEN nlllii = '1'  ELSE nlO0l;
	wire_nliil_dataout <= wire_n10Oi_q(6) WHEN nlllii = '1'  ELSE nlO0O;
	wire_nliiO_dataout <= wire_n10Oi_q(7) WHEN nlllii = '1'  ELSE nlOii;
	wire_nlili_dataout <= wire_n10Oi_q(8) WHEN nlllii = '1'  ELSE nlOil;
	wire_nlill_dataout <= wire_n10Oi_q(9) WHEN nlllii = '1'  ELSE nlOiO;
	wire_nlilO_dataout <= wire_n10Oi_q(10) WHEN nlllii = '1'  ELSE nlOli;
	wire_nliOi_dataout <= wire_n10Oi_q(11) WHEN nlllii = '1'  ELSE nlOll;
	wire_nliOl_dataout <= wire_n10Oi_q(12) WHEN nlllii = '1'  ELSE nlOlO;
	wire_nliOO_dataout <= wire_n10Oi_q(13) WHEN nlllii = '1'  ELSE nlOOi;
	wire_nll0i_dataout <= nlliOi AND NOT(nlll0i);
	wire_nll0l_dataout <= wire_nll0O_dataout WHEN (wire_w_lg_nllO0O91w(0) AND (nlliOl22 XOR nlliOl21)) = '1'  ELSE nlllii;
	wire_nll0l_w_lg_w_lg_dataout364w365w(0) <= wire_nll0l_w_lg_dataout364w(0) AND wire_nll1O_dataout;
	wire_nll0l_w_lg_dataout364w(0) <= NOT wire_nll0l_dataout;
	wire_nll0O_dataout <= nlllii OR (wire_w_lg_nlll1O83w(0) OR ((n11l AND nlll1O) AND (nlll1i20 XOR nlll1i19)));
	wire_nll1i_dataout <= wire_n10Oi_q(14) WHEN nlllii = '1'  ELSE nlOOl;
	wire_nll1l_dataout <= wire_n10Oi_q(15) WHEN nlllii = '1'  ELSE nlOOO;
	wire_nll1O_dataout <= n1il AND nllO0O;
	wire_nllll_dataout <= nlll0i AND nllO0O;
	wire_nlO00l_dataout <= wire_nlO00O_dataout AND wire_nlOiOl_dataout;
	wire_nlO00O_dataout <= wire_nlO0il_dataout WHEN nlilll = '1'  ELSE n100O;
	wire_nlO0ii_dataout <= wire_n0iii_w_lg_n100O720w(0) WHEN nlilll = '1'  ELSE nlOOll;
	wire_nlO0il_dataout <= wire_nlOOli_w_lg_nlOOll719w(0) AND wire_n0iii_w_lg_n100O720w(0);
	wire_nlO0ll_dataout <= wire_nlO0Oi_dataout OR nliO0l;
	wire_nlO0Oi_dataout <= wire_nlO0Ol_dataout AND NOT(nlilll);
	wire_nlO0Ol_dataout <= n111l OR (n100O AND wire_nlOiOl_dataout);
	wire_nlOi1i_dataout <= wire_nlOi1O_dataout AND wire_nlOiOl_dataout;
	wire_nlOi1l_dataout <= nlilli AND wire_nlOiOl_dataout;
	wire_nlOi1O_dataout <= nlilli OR (wire_w_lg_nlilll714w(0) OR nliO1O);
	wire_nlOili_dataout <= wire_nlOilO_dataout AND wire_nlOiOl_dataout;
	wire_nlOill_dataout <= nlillO AND wire_nlOiOl_dataout;
	wire_nlOilO_dataout <= (n100O AND nlilOl) OR NOT(nlilOi);
	wire_nlOiOl_dataout <= wire_nlOl1l_dataout AND NOT(((nlilOO AND nliOll) AND wire_w_lg_nliO0i708w(0)));
	wire_nlOl1l_dataout <= wire_nlOl1O_dataout AND NOT(n10ll);
	wire_nlOl1O_dataout <= n10il OR (n10ii AND (wire_n10li_w_lg_n10ll704w(0) AND n10iO));
	wire_n0iOO_a <= ( n0i1l & n00OO);
	wire_n0iOO_b <= ( "0" & "1");
	n0iOO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 2,
		width_b => 2,
		width_o => 2
	  )
	  PORT MAP ( 
		a => wire_n0iOO_a,
		b => wire_n0iOO_b,
		cin => wire_gnd,
		o => wire_n0iOO_o
	  );
	wire_n0l1i_a <= ( n0iil & n0i0O & n0i0l & n0i0i & n0i1O);
	wire_n0l1i_b <= ( "0" & "0" & "0" & "0" & "1");
	n0l1i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_n0l1i_a,
		b => wire_n0l1i_b,
		cin => wire_gnd,
		o => wire_n0l1i_o
	  );
	wire_n10lO_w_lg_w_o_range797w798w(0) <= NOT wire_n10lO_w_o_range797w(0);
	wire_n10lO_a <= ( "0" & "0" & "0");
	wire_n10lO_b <= ( "0" & "0" & "1");
	wire_n10lO_w_o_range797w(0) <= wire_n10lO_o(2);
	n10lO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_n10lO_a,
		b => wire_n10lO_b,
		cin => wire_gnd,
		o => wire_n10lO_o
	  );
	wire_n1ll_a <= ( "0" & "0" & "0");
	wire_n1ll_b <= ( "0" & "1" & "1");
	n1ll :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_n1ll_a,
		b => wire_n1ll_b,
		cin => wire_gnd,
		o => wire_n1ll_o
	  );
	wire_n1lO_w_lg_w_o_range139w140w(0) <= NOT wire_n1lO_w_o_range139w(0);
	wire_n1lO_a <= ( "0" & "0" & "0");
	wire_n1lO_b <= ( "0" & "0" & "1");
	wire_n1lO_w_o_range139w(0) <= wire_n1lO_o(2);
	n1lO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 3,
		width_b => 3,
		width_o => 3
	  )
	  PORT MAP ( 
		a => wire_n1lO_a,
		b => wire_n1lO_b,
		cin => wire_gnd,
		o => wire_n1lO_o
	  );
	wire_nilli_a <= ( niiOO & niiOl);
	wire_nilli_b <= ( "0" & "1");
	nilli :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 2,
		width_b => 2,
		width_o => 2
	  )
	  PORT MAP ( 
		a => wire_nilli_a,
		b => wire_nilli_b,
		cin => wire_gnd,
		o => wire_nilli_o
	  );
	wire_niO1i_a <= ( niiOi & niilO & niill & niili & niiiO);
	wire_niO1i_b <= ( "0" & "0" & "0" & "0" & "1");
	niO1i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 5,
		width_b => 5,
		width_o => 5
	  )
	  PORT MAP ( 
		a => wire_niO1i_a,
		b => wire_niO1i_b,
		cin => wire_gnd,
		o => wire_niO1i_o
	  );
	wire_nlO00i_a <= ( "0" & "0");
	wire_nlO00i_b <= ( "0" & "1");
	nlO00i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 2,
		width_b => 2,
		width_o => 2
	  )
	  PORT MAP ( 
		a => wire_nlO00i_a,
		b => wire_nlO00i_b,
		cin => wire_gnd,
		o => wire_nlO00i_o
	  );
	wire_n0iOl_i <= ( n0i1l & n00OO);
	n0iOl :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_n0iOl_i,
		o => wire_n0iOl_o
	  );
	wire_niO1l_i <= ( niiOO & niiOl);
	niO1l :  oper_decoder
	  GENERIC MAP (
		width_i => 2,
		width_o => 4
	  )
	  PORT MAP ( 
		i => wire_niO1l_i,
		o => wire_niO1l_o
	  );
	wire_nlO01O_a <= ( "0" & "1" & wire_nlO00i_o(1 DOWNTO 0) & "0" & "0");
	wire_nlO01O_b <= ( wire_nllOOi_q(5 DOWNTO 0));
	nlO01O :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 6,
		width_b => 6
	  )
	  PORT MAP ( 
		a => wire_nlO01O_a,
		b => wire_nlO01O_b,
		cin => wire_vcc,
		o => wire_nlO01O_o
	  );
	wire_n0iiO_data <= ( "0" & "0" & wire_n0l1i_o(0) & "0" & n0i1O & "0" & n0i1O & "0");
	wire_n0iiO_sel <= ( n110i & n111O & "1");
	n0iiO :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0iiO_data,
		o => wire_n0iiO_o,
		sel => wire_n0iiO_sel
	  );
	wire_n0ili_data <= ( "0" & "0" & wire_n0l1i_o(1) & "0" & n0i0i & "0" & n0i0i & "0");
	wire_n0ili_sel <= ( n110i & n111O & "1");
	n0ili :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0ili_data,
		o => wire_n0ili_o,
		sel => wire_n0ili_sel
	  );
	wire_n0ill_data <= ( "0" & "0" & wire_n0l1i_o(2) & "0" & n0i0l & "0" & n0i0l & "0");
	wire_n0ill_sel <= ( n110i & n111O & "1");
	n0ill :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0ill_data,
		o => wire_n0ill_o,
		sel => wire_n0ill_sel
	  );
	wire_n0ilO_data <= ( "0" & "0" & wire_n0l1i_o(3) & "0" & n0i0O & "0" & n0i0O & "0");
	wire_n0ilO_sel <= ( n110i & n111O & "1");
	n0ilO :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0ilO_data,
		o => wire_n0ilO_o,
		sel => wire_n0ilO_sel
	  );
	wire_n0iOi_data <= ( "0" & "0" & wire_n0l1i_o(4) & "0" & n0iil & "0" & n0iil & "0");
	wire_n0iOi_sel <= ( n110i & n111O & "1");
	n0iOi :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_n0iOi_data,
		o => wire_n0iOi_o,
		sel => wire_n0iOi_sel
	  );
	wire_nilll_data <= ( "0" & "0" & wire_niO1i_o(0) & "0" & "0" & "0" & niiiO & "0");
	wire_nilll_sel <= ( wire_nll0l_dataout & wire_nll1O_dataout & "1");
	nilll :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nilll_data,
		o => wire_nilll_o,
		sel => wire_nilll_sel
	  );
	wire_nillO_data <= ( "0" & "0" & wire_niO1i_o(1) & "0" & "0" & "0" & niili & "0");
	wire_nillO_sel <= ( wire_nll0l_dataout & wire_nll1O_dataout & "1");
	nillO :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nillO_data,
		o => wire_nillO_o,
		sel => wire_nillO_sel
	  );
	wire_nilOi_data <= ( "0" & "0" & wire_niO1i_o(2) & "0" & "0" & "0" & niill & "0");
	wire_nilOi_sel <= ( wire_nll0l_dataout & wire_nll1O_dataout & "1");
	nilOi :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nilOi_data,
		o => wire_nilOi_o,
		sel => wire_nilOi_sel
	  );
	wire_nilOl_data <= ( "0" & "0" & wire_niO1i_o(3) & "0" & "0" & "0" & niilO & "0");
	wire_nilOl_sel <= ( wire_nll0l_dataout & wire_nll1O_dataout & "1");
	nilOl :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nilOl_data,
		o => wire_nilOl_o,
		sel => wire_nilOl_sel
	  );
	wire_nilOO_data <= ( "0" & "0" & wire_niO1i_o(4) & "0" & "0" & "0" & niiOi & "0");
	wire_nilOO_sel <= ( wire_nll0l_dataout & wire_nll1O_dataout & "1");
	nilOO :  oper_mux
	  GENERIC MAP (
		width_data => 8,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nilOO_data,
		o => wire_nilOO_o,
		sel => wire_nilOO_sel
	  );

 END RTL; --slavetx0_example
--synopsys translate_on
--VALID FILE
