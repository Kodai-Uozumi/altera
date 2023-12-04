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

--synthesis_resources = altsyncram 1 lut 317 mux21 100 oper_add 16 oper_decoder 1 oper_less_than 4 oper_selector 7 
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

 ENTITY  auk_pac_mtx_pl3_link IS 
	 PORT 
	 ( 
		 a_dtpa	:	IN  STD_LOGIC_VECTOR (0 DOWNTO 0);
		 a_tdat	:	OUT  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 a_tenb	:	OUT  STD_LOGIC;
		 a_teop	:	OUT  STD_LOGIC;
		 a_terr	:	OUT  STD_LOGIC;
		 a_tfclk	:	IN  STD_LOGIC;
		 a_tmod	:	OUT  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 a_tprty	:	OUT  STD_LOGIC;
		 a_treset_n	:	IN  STD_LOGIC;
		 a_tsop	:	OUT  STD_LOGIC;
		 b_clk	:	IN  STD_LOGIC;
		 b_dat	:	IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		 b_dav	:	OUT  STD_LOGIC;
		 b_ena	:	IN  STD_LOGIC;
		 b_eop	:	IN  STD_LOGIC;
		 b_err	:	IN  STD_LOGIC;
		 b_mty	:	IN  STD_LOGIC_VECTOR (1 DOWNTO 0);
		 b_par	:	IN  STD_LOGIC;
		 b_reset_n	:	IN  STD_LOGIC;
		 b_sop	:	IN  STD_LOGIC
	 ); 
 END auk_pac_mtx_pl3_link;

 ARCHITECTURE RTL OF auk_pac_mtx_pl3_link IS

	 ATTRIBUTE synthesis_clearbox : boolean;
	 ATTRIBUTE synthesis_clearbox OF RTL : ARCHITECTURE IS true;
	 SIGNAL  wire_n110i_w_lg_w_q_b_range583w584w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n110i_address_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_n110i_address_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_vcc	:	STD_LOGIC;
	 SIGNAL  wire_n110i_data_a	:	STD_LOGIC_VECTOR (37 DOWNTO 0);
	 SIGNAL  wire_n110i_q_b	:	STD_LOGIC_VECTOR (37 DOWNTO 0);
	 SIGNAL  wire_n110i_w_q_b_range583w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0iii58	:	STD_LOGIC := '1';
	 SIGNAL	 nl0iii59	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0iii59_w_lg_Q422w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0iii60	:	STD_LOGIC := '0';
	 SIGNAL	 nl0iil55	:	STD_LOGIC := '1';
	 SIGNAL	 nl0iil56	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0iil56_w_lg_Q384w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0iil57	:	STD_LOGIC := '0';
	 SIGNAL	 nl0iiO52	:	STD_LOGIC := '1';
	 SIGNAL	 nl0iiO53	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0iiO53_w_lg_Q380w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0iiO54	:	STD_LOGIC := '0';
	 SIGNAL	 nl0ili49	:	STD_LOGIC := '1';
	 SIGNAL	 nl0ili50	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0ili50_w_lg_Q374w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0ili51	:	STD_LOGIC := '0';
	 SIGNAL	 nl0ill46	:	STD_LOGIC := '1';
	 SIGNAL	 nl0ill47	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0ill47_w_lg_Q283w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0ill48	:	STD_LOGIC := '0';
	 SIGNAL	 nl0ilO43	:	STD_LOGIC := '1';
	 SIGNAL	 nl0ilO44	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0ilO44_w_lg_Q280w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0ilO45	:	STD_LOGIC := '0';
	 SIGNAL	 nl0iOi40	:	STD_LOGIC := '1';
	 SIGNAL	 nl0iOi41	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0iOi41_w_lg_Q277w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0iOi42	:	STD_LOGIC := '0';
	 SIGNAL	 nl0iOl37	:	STD_LOGIC := '1';
	 SIGNAL	 nl0iOl38	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0iOl38_w_lg_Q269w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0iOl39	:	STD_LOGIC := '0';
	 SIGNAL	 nl0iOO34	:	STD_LOGIC := '1';
	 SIGNAL	 nl0iOO35	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0iOO35_w_lg_Q260w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0iOO36	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l0i22	:	STD_LOGIC := '1';
	 SIGNAL	 nl0l0i23	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0l0i23_w_lg_Q112w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0l0i24	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l0l19	:	STD_LOGIC := '1';
	 SIGNAL	 nl0l0l20	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0l0l20_w_lg_Q94w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0l0l21	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l0O16	:	STD_LOGIC := '1';
	 SIGNAL	 nl0l0O17	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0l0O17_w_lg_Q68w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0l0O18	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l1i31	:	STD_LOGIC := '1';
	 SIGNAL	 nl0l1i32	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0l1i32_w_lg_Q251w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0l1i33	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l1l28	:	STD_LOGIC := '1';
	 SIGNAL	 nl0l1l29	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0l1l29_w_lg_Q242w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0l1l30	:	STD_LOGIC := '0';
	 SIGNAL	 nl0l1O25	:	STD_LOGIC := '1';
	 SIGNAL	 nl0l1O26	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0l1O26_w_lg_Q132w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0l1O27	:	STD_LOGIC := '0';
	 SIGNAL	 nl0lii13	:	STD_LOGIC := '1';
	 SIGNAL	 nl0lii14	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0lii14_w_lg_Q62w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0lii15	:	STD_LOGIC := '0';
	 SIGNAL	 nl0lil10	:	STD_LOGIC := '1';
	 SIGNAL	 nl0lil11	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0lil11_w_lg_Q59w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0lil12	:	STD_LOGIC := '0';
	 SIGNAL	 nl0lll7	:	STD_LOGIC := '1';
	 SIGNAL	 nl0lll8	:	STD_LOGIC := '1';
	 SIGNAL	 nl0lll9	:	STD_LOGIC := '0';
	 SIGNAL	 nl0lOi4	:	STD_LOGIC := '1';
	 SIGNAL	 nl0lOi5	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl0lOi5_w_lg_Q46w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	 nl0lOi6	:	STD_LOGIC := '0';
	 SIGNAL	 nl0O1i1	:	STD_LOGIC := '1';
	 SIGNAL	 nl0O1i2	:	STD_LOGIC := '1';
	 SIGNAL	 nl0O1i3	:	STD_LOGIC := '0';
	 SIGNAL	n000i	:	STD_LOGIC := '0';
	 SIGNAL	n000l	:	STD_LOGIC := '0';
	 SIGNAL	n000O	:	STD_LOGIC := '0';
	 SIGNAL	n001i	:	STD_LOGIC := '0';
	 SIGNAL	n001l	:	STD_LOGIC := '0';
	 SIGNAL	n001O	:	STD_LOGIC := '0';
	 SIGNAL	n00il	:	STD_LOGIC := '0';
	 SIGNAL	n1O0i	:	STD_LOGIC := '0';
	 SIGNAL	n1O0l	:	STD_LOGIC := '0';
	 SIGNAL	n1O0O	:	STD_LOGIC := '0';
	 SIGNAL	n1Oii	:	STD_LOGIC := '0';
	 SIGNAL	n1Oil	:	STD_LOGIC := '0';
	 SIGNAL	n1OiO	:	STD_LOGIC := '0';
	 SIGNAL	n1Oli	:	STD_LOGIC := '0';
	 SIGNAL	n00iO	:	STD_LOGIC := '1';
	 SIGNAL	n00li	:	STD_LOGIC := '1';
	 SIGNAL	n00ll	:	STD_LOGIC := '1';
	 SIGNAL	n00lO	:	STD_LOGIC := '1';
	 SIGNAL	n00Oi	:	STD_LOGIC := '1';
	 SIGNAL	n00Ol	:	STD_LOGIC := '1';
	 SIGNAL	n0i1i	:	STD_LOGIC := '1';
	 SIGNAL	n010l	:	STD_LOGIC := '1';
	 SIGNAL	n010O	:	STD_LOGIC := '1';
	 SIGNAL	n01ii	:	STD_LOGIC := '1';
	 SIGNAL	n01il	:	STD_LOGIC := '1';
	 SIGNAL	n01iO	:	STD_LOGIC := '1';
	 SIGNAL	n01li	:	STD_LOGIC := '1';
	 SIGNAL	n01lO	:	STD_LOGIC := '1';
	 SIGNAL  wire_n01ll_w_lg_n010l114w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01ll_w_lg_n010O111w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01ll_w_lg_n01ii108w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01ll_w_lg_n01il106w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01ll_w_lg_n01iO104w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01ll_w_lg_n01li102w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n01ll_w_lg_n01lO100w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0i0i	:	STD_LOGIC := '1';
	 SIGNAL	n0i0l	:	STD_LOGIC := '1';
	 SIGNAL	n0i0O	:	STD_LOGIC := '1';
	 SIGNAL	n0i1l	:	STD_LOGIC := '1';
	 SIGNAL	n0i1O	:	STD_LOGIC := '1';
	 SIGNAL	n0iii	:	STD_LOGIC := '1';
	 SIGNAL	n0iil	:	STD_LOGIC := '1';
	 SIGNAL	n0iiO	:	STD_LOGIC := '1';
	 SIGNAL	n0ili	:	STD_LOGIC := '1';
	 SIGNAL	n0ill	:	STD_LOGIC := '1';
	 SIGNAL	n0ilO	:	STD_LOGIC := '1';
	 SIGNAL	n0iOi	:	STD_LOGIC := '1';
	 SIGNAL	n0iOO	:	STD_LOGIC := '1';
	 SIGNAL	n0l0O	:	STD_LOGIC := '1';
	 SIGNAL	n0l1l	:	STD_LOGIC := '1';
	 SIGNAL	n010i	:	STD_LOGIC := '1';
	 SIGNAL	n011i	:	STD_LOGIC := '1';
	 SIGNAL	n011l	:	STD_LOGIC := '1';
	 SIGNAL	n011O	:	STD_LOGIC := '1';
	 SIGNAL	n01Oi	:	STD_LOGIC := '1';
	 SIGNAL	n01Ol	:	STD_LOGIC := '1';
	 SIGNAL	n01OO	:	STD_LOGIC := '1';
	 SIGNAL	n0l0i	:	STD_LOGIC := '1';
	 SIGNAL	n1O1i	:	STD_LOGIC := '1';
	 SIGNAL	n1O1l	:	STD_LOGIC := '1';
	 SIGNAL	n1O1O	:	STD_LOGIC := '1';
	 SIGNAL	n1Oll	:	STD_LOGIC := '1';
	 SIGNAL	n1OlO	:	STD_LOGIC := '1';
	 SIGNAL	n1OOi	:	STD_LOGIC := '1';
	 SIGNAL	n1OOl	:	STD_LOGIC := '1';
	 SIGNAL	n1OOO	:	STD_LOGIC := '1';
	 SIGNAL  wire_n0l1O_w_lg_n01Ol53w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1O_w_lg_n0l0i38w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1O_w_lg_n1O1i845w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0l1O_w_lg_n1O1O843w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0lil	:	STD_LOGIC := '1';
	 SIGNAL	nli0iO	:	STD_LOGIC := '1';
	 SIGNAL	nlllOO	:	STD_LOGIC := '1';
	 SIGNAL  wire_n0lii_w_lg_nli0iO1313w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_n0lii_w_lg_nlllOO1093w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0llO	:	STD_LOGIC := '1';
	 SIGNAL	n0lOi	:	STD_LOGIC := '1';
	 SIGNAL	n0lOl	:	STD_LOGIC := '1';
	 SIGNAL	n0lOO	:	STD_LOGIC := '1';
	 SIGNAL	n0O0i	:	STD_LOGIC := '1';
	 SIGNAL	n0O1i	:	STD_LOGIC := '1';
	 SIGNAL	n0O1l	:	STD_LOGIC := '1';
	 SIGNAL	n111i	:	STD_LOGIC := '0';
	 SIGNAL	n111O	:	STD_LOGIC := '0';
	 SIGNAL	nllO0i	:	STD_LOGIC := '0';
	 SIGNAL	nllO0l	:	STD_LOGIC := '0';
	 SIGNAL	nllO0O	:	STD_LOGIC := '0';
	 SIGNAL	nllOii	:	STD_LOGIC := '0';
	 SIGNAL	nllOil	:	STD_LOGIC := '0';
	 SIGNAL	nllOiO	:	STD_LOGIC := '0';
	 SIGNAL	nllOli	:	STD_LOGIC := '0';
	 SIGNAL	nllOll	:	STD_LOGIC := '0';
	 SIGNAL	nllOlO	:	STD_LOGIC := '0';
	 SIGNAL	nllOOi	:	STD_LOGIC := '0';
	 SIGNAL	nllOOl	:	STD_LOGIC := '0';
	 SIGNAL	nllOOO	:	STD_LOGIC := '0';
	 SIGNAL	nlO11i	:	STD_LOGIC := '0';
	 SIGNAL	nlO11l	:	STD_LOGIC := '0';
	 SIGNAL	nlOi0i	:	STD_LOGIC := '0';
	 SIGNAL	nlOi0l	:	STD_LOGIC := '0';
	 SIGNAL	nlOi0O	:	STD_LOGIC := '0';
	 SIGNAL	nlOiii	:	STD_LOGIC := '0';
	 SIGNAL	nlOiil	:	STD_LOGIC := '0';
	 SIGNAL	nlOiiO	:	STD_LOGIC := '0';
	 SIGNAL	nlOili	:	STD_LOGIC := '0';
	 SIGNAL	nlOill	:	STD_LOGIC := '0';
	 SIGNAL	nlOilO	:	STD_LOGIC := '0';
	 SIGNAL	nlOiOi	:	STD_LOGIC := '0';
	 SIGNAL	nlOl1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOlii	:	STD_LOGIC := '0';
	 SIGNAL	nlOliO	:	STD_LOGIC := '0';
	 SIGNAL	nlOlli	:	STD_LOGIC := '0';
	 SIGNAL	nlOlll	:	STD_LOGIC := '0';
	 SIGNAL	nlOO0i	:	STD_LOGIC := '0';
	 SIGNAL	nlOO0l	:	STD_LOGIC := '0';
	 SIGNAL	nlOO0O	:	STD_LOGIC := '0';
	 SIGNAL	nlOO1l	:	STD_LOGIC := '0';
	 SIGNAL	nlOO1O	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOl	:	STD_LOGIC := '0';
	 SIGNAL	nlOOOO	:	STD_LOGIC := '0';
	 SIGNAL	n1lOO	:	STD_LOGIC := '1';
	 SIGNAL	ni0ii	:	STD_LOGIC := '0';
	 SIGNAL  wire_ni00O_w_lg_ni0ii1106w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni00O_w_lg_ni0ii1142w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	ni0il	:	STD_LOGIC := '1';
	 SIGNAL	ni0ll	:	STD_LOGIC := '1';
	 SIGNAL	nliO0i	:	STD_LOGIC := '1';
	 SIGNAL  wire_ni0li_w_lg_ni0il582w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_ni0li_w_lg_ni0ll543w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nii0O	:	STD_LOGIC := '0';
	 SIGNAL  wire_nii0l_w_lg_nii0O503w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0liO	:	STD_LOGIC := '1';
	 SIGNAL	n0lli	:	STD_LOGIC := '1';
	 SIGNAL	n0lll	:	STD_LOGIC := '1';
	 SIGNAL	n0O0l	:	STD_LOGIC := '1';
	 SIGNAL	n0O0O	:	STD_LOGIC := '1';
	 SIGNAL	n0Oii	:	STD_LOGIC := '1';
	 SIGNAL	n0Oil	:	STD_LOGIC := '1';
	 SIGNAL	n0OiO	:	STD_LOGIC := '1';
	 SIGNAL	n0Oli	:	STD_LOGIC := '1';
	 SIGNAL	n0Oll	:	STD_LOGIC := '1';
	 SIGNAL	n0OlO	:	STD_LOGIC := '1';
	 SIGNAL	n0OOi	:	STD_LOGIC := '1';
	 SIGNAL	ni00l	:	STD_LOGIC := '1';
	 SIGNAL	ni0iO	:	STD_LOGIC := '1';
	 SIGNAL	ni0lO	:	STD_LOGIC := '1';
	 SIGNAL	ni0Oi	:	STD_LOGIC := '1';
	 SIGNAL	ni0Ol	:	STD_LOGIC := '1';
	 SIGNAL	ni0OO	:	STD_LOGIC := '1';
	 SIGNAL	ni10O	:	STD_LOGIC := '1';
	 SIGNAL	ni1ii	:	STD_LOGIC := '1';
	 SIGNAL	ni1il	:	STD_LOGIC := '1';
	 SIGNAL	ni1iO	:	STD_LOGIC := '1';
	 SIGNAL	ni1li	:	STD_LOGIC := '1';
	 SIGNAL	ni1ll	:	STD_LOGIC := '1';
	 SIGNAL	ni1lO	:	STD_LOGIC := '1';
	 SIGNAL	ni1Oi	:	STD_LOGIC := '1';
	 SIGNAL	ni1Ol	:	STD_LOGIC := '1';
	 SIGNAL	ni1OO	:	STD_LOGIC := '1';
	 SIGNAL	nii0i	:	STD_LOGIC := '1';
	 SIGNAL	nii1i	:	STD_LOGIC := '1';
	 SIGNAL	nii1l	:	STD_LOGIC := '1';
	 SIGNAL	nl0Oil	:	STD_LOGIC := '1';
	 SIGNAL	nl0OiO	:	STD_LOGIC := '1';
	 SIGNAL	nl0Oli	:	STD_LOGIC := '1';
	 SIGNAL	nl0OlO	:	STD_LOGIC := '1';
	 SIGNAL	nli00O	:	STD_LOGIC := '1';
	 SIGNAL	nli01O	:	STD_LOGIC := '1';
	 SIGNAL	nli0li	:	STD_LOGIC := '1';
	 SIGNAL	nli0ll	:	STD_LOGIC := '1';
	 SIGNAL	nli0lO	:	STD_LOGIC := '1';
	 SIGNAL	nli0Oi	:	STD_LOGIC := '1';
	 SIGNAL	nli0Ol	:	STD_LOGIC := '1';
	 SIGNAL	nli0OO	:	STD_LOGIC := '1';
	 SIGNAL	nlii0i	:	STD_LOGIC := '1';
	 SIGNAL	nlii0l	:	STD_LOGIC := '1';
	 SIGNAL	nlii0O	:	STD_LOGIC := '1';
	 SIGNAL	nlii1i	:	STD_LOGIC := '1';
	 SIGNAL	nlii1l	:	STD_LOGIC := '1';
	 SIGNAL	nlii1O	:	STD_LOGIC := '1';
	 SIGNAL	nliiii	:	STD_LOGIC := '1';
	 SIGNAL	nliiil	:	STD_LOGIC := '1';
	 SIGNAL	nliiiO	:	STD_LOGIC := '1';
	 SIGNAL	nliili	:	STD_LOGIC := '1';
	 SIGNAL	nliill	:	STD_LOGIC := '1';
	 SIGNAL	nliilO	:	STD_LOGIC := '1';
	 SIGNAL	nliiOi	:	STD_LOGIC := '1';
	 SIGNAL	nliiOl	:	STD_LOGIC := '1';
	 SIGNAL	nliiOO	:	STD_LOGIC := '1';
	 SIGNAL	nlil0i	:	STD_LOGIC := '1';
	 SIGNAL	nlil0l	:	STD_LOGIC := '1';
	 SIGNAL	nlil0O	:	STD_LOGIC := '1';
	 SIGNAL	nlil1i	:	STD_LOGIC := '1';
	 SIGNAL	nlil1l	:	STD_LOGIC := '1';
	 SIGNAL	nlil1O	:	STD_LOGIC := '1';
	 SIGNAL	nlilii	:	STD_LOGIC := '1';
	 SIGNAL	nlilil	:	STD_LOGIC := '1';
	 SIGNAL	nliliO	:	STD_LOGIC := '1';
	 SIGNAL	nlilli	:	STD_LOGIC := '1';
	 SIGNAL	nlilll	:	STD_LOGIC := '1';
	 SIGNAL	nlillO	:	STD_LOGIC := '1';
	 SIGNAL	nlilOi	:	STD_LOGIC := '1';
	 SIGNAL	nlilOl	:	STD_LOGIC := '1';
	 SIGNAL	nlilOO	:	STD_LOGIC := '1';
	 SIGNAL	nliO0l	:	STD_LOGIC := '1';
	 SIGNAL	nliO0O	:	STD_LOGIC := '1';
	 SIGNAL	nliO1i	:	STD_LOGIC := '1';
	 SIGNAL	nliO1l	:	STD_LOGIC := '1';
	 SIGNAL	nliO1O	:	STD_LOGIC := '1';
	 SIGNAL	nll1ll	:	STD_LOGIC := '1';
	 SIGNAL	nlllOl	:	STD_LOGIC := '1';
	 SIGNAL	nllO1i	:	STD_LOGIC := '1';
	 SIGNAL	nllO1l	:	STD_LOGIC := '1';
	 SIGNAL	nllO1O	:	STD_LOGIC := '1';
	 SIGNAL	nlO01O	:	STD_LOGIC := '1';
	 SIGNAL	nlO1iO	:	STD_LOGIC := '1';
	 SIGNAL	nlO1ll	:	STD_LOGIC := '1';
	 SIGNAL  wire_nii1O_w_lg_nl0OiO1314w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nllO1l1196w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nllO1O1200w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_n0liO840w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_n0lll838w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_ni1ii487w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nl0Oil1288w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nl0Oli1541w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nl0OlO1538w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nli0li1296w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nlO01O1292w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nllO1i1148w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nii1O_w_lg_nllO1l1105w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	niiii	:	STD_LOGIC := '1';
	 SIGNAL	niiil	:	STD_LOGIC := '1';
	 SIGNAL	niiiO	:	STD_LOGIC := '1';
	 SIGNAL	niili	:	STD_LOGIC := '1';
	 SIGNAL	niill	:	STD_LOGIC := '1';
	 SIGNAL	niilO	:	STD_LOGIC := '1';
	 SIGNAL	niiOi	:	STD_LOGIC := '1';
	 SIGNAL	nilli	:	STD_LOGIC := '1';
	 SIGNAL	niO0O	:	STD_LOGIC := '1';
	 SIGNAL	niOil	:	STD_LOGIC := '1';
	 SIGNAL	nl1ii	:	STD_LOGIC := '1';
	 SIGNAL	nl1il	:	STD_LOGIC := '1';
	 SIGNAL	nl1li	:	STD_LOGIC := '1';
	 SIGNAL  wire_nl1iO_w_lg_niiii505w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_niiil507w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_niiiO509w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_niili511w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_niill513w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_niilO515w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_niiOi530w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_nilli532w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_niO0O534w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_niOil536w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_nl1ii538w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_nl1il540w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl1iO_w_lg_nl1li542w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	nl1lO	:	STD_LOGIC := '1';
	 SIGNAL	nli00l	:	STD_LOGIC := '0';
	 SIGNAL	nll0iO	:	STD_LOGIC := '0';
	 SIGNAL	nlli1O	:	STD_LOGIC := '0';
	 SIGNAL	nlliOi	:	STD_LOGIC := '0';
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
	 SIGNAL	nlllll	:	STD_LOGIC := '0';
	 SIGNAL	nlllOi	:	STD_LOGIC := '0';
	 SIGNAL  wire_nllllO_w_lg_nlli1O1523w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlliOi1521w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlliOO1519w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlll0i1511w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlll0l1509w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlll0O1507w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlll1i1517w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlll1l1515w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlll1O1513w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlllii1505w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlllil1503w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nllliO1501w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlllli1499w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlllll1497w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nllllO_w_lg_nlllOi1496w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	n0OOl	:	STD_LOGIC := '1';
	 SIGNAL	n0OOO	:	STD_LOGIC := '1';
	 SIGNAL	ni00i	:	STD_LOGIC := '1';
	 SIGNAL	ni01i	:	STD_LOGIC := '1';
	 SIGNAL	ni01l	:	STD_LOGIC := '1';
	 SIGNAL	ni01O	:	STD_LOGIC := '1';
	 SIGNAL	ni10i	:	STD_LOGIC := '1';
	 SIGNAL	ni10l	:	STD_LOGIC := '1';
	 SIGNAL	ni11i	:	STD_LOGIC := '1';
	 SIGNAL	ni11l	:	STD_LOGIC := '1';
	 SIGNAL	ni11O	:	STD_LOGIC := '1';
	 SIGNAL	nlO0i	:	STD_LOGIC := '1';
	 SIGNAL	nlO0O	:	STD_LOGIC := '1';
	 SIGNAL	nlO1O	:	STD_LOGIC := '1';
	 SIGNAL	nl00i	:	STD_LOGIC := '1';
	 SIGNAL	nl01i	:	STD_LOGIC := '1';
	 SIGNAL	nl01l	:	STD_LOGIC := '1';
	 SIGNAL	nl01O	:	STD_LOGIC := '1';
	 SIGNAL	nl1Oi	:	STD_LOGIC := '1';
	 SIGNAL	nl1Ol	:	STD_LOGIC := '1';
	 SIGNAL	nl1OO	:	STD_LOGIC := '1';
	 SIGNAL	nliiO	:	STD_LOGIC := '1';
	 SIGNAL	nlill	:	STD_LOGIC := '1';
	 SIGNAL	nllli	:	STD_LOGIC := '1';
	 SIGNAL	nllOl	:	STD_LOGIC := '1';
	 SIGNAL	nllOO	:	STD_LOGIC := '1';
	 SIGNAL	nlO1l	:	STD_LOGIC := '1';
	 SIGNAL	wire_n1lil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_n1liO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilii_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nilii_w_lg_dataout810w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nilll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nillO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nilOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niO1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOlO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_niOOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl0OOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nl11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli01i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1li_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1ll_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nli1Ol_dataout	:	STD_LOGIC;
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
	 SIGNAL	wire_nll10i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll10l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll10O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll11i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll11l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll11O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nll1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlli0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nllii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlliiO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO00O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0ii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0il_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0iO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0lO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Oi_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0Ol_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlO0OO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOi1O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOl_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOiOO_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0i_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0l_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOl0O_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOlil_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOii_dataout	:	STD_LOGIC;
	 SIGNAL	wire_nlOOli_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlOOli_w_lg_dataout1140w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL	wire_nlOOlO_dataout	:	STD_LOGIC;
	 SIGNAL  wire_nlOOlO_w_lg_dataout1139w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nil0i_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil0i_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_gnd	:	STD_LOGIC;
	 SIGNAL  wire_nil0i_o	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nilil_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nilil_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nilil_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niO0i_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niO0i_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niO0i_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_niOii_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niOii_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niOii_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niOiO_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niOiO_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_niOiO_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nl00l_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nl00l_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nl00l_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nl0li_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0li_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0li_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0li_w_o_range419w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0lO_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0lO_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0lO_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nl0lO_w_o_range248w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0lO_w_o_range257w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0lO_w_o_range239w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nl0lO_w_o_range266w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli01l_a	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli01l_b	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli01l_o	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli0l_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0l_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0l_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0O_a	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0O_b	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli0O_o	:	STD_LOGIC_VECTOR (7 DOWNTO 0);
	 SIGNAL  wire_nli1OO_a	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1OO_b	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli1OO_o	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlilO_a	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nlilO_b	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nlilO_o	:	STD_LOGIC_VECTOR (6 DOWNTO 0);
	 SIGNAL  wire_nll1iO_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll1iO_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll1iO_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll1li_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll1li_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nll1li_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nlliOl_a	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nlliOl_b	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nlliOl_o	:	STD_LOGIC_VECTOR (16 DOWNTO 0);
	 SIGNAL  wire_nli11l_i	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nli11l_o	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nil0O_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil0O_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil0O_o	:	STD_LOGIC;
	 SIGNAL  wire_nil1O_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil1O_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nil1O_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0iO_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0iO_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0iO_o	:	STD_LOGIC;
	 SIGNAL  wire_nl0ll_a	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0ll_b	:	STD_LOGIC_VECTOR (15 DOWNTO 0);
	 SIGNAL  wire_nl0ll_o	:	STD_LOGIC;
	 SIGNAL  wire_nlli1i_data	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nlli1i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlli1i_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nlli1l_data	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nlli1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlli1l_sel	:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	 SIGNAL  wire_nlO01i_w_lg_o1112w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO01i_data	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlO01i_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO01i_sel	:	STD_LOGIC_VECTOR (3 DOWNTO 0);
	 SIGNAL  wire_nlO1lO_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO1lO_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO1lO_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO1Oi_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO1Oi_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO1Oi_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlO1Ol_w_lg_o1114w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_nlO1Ol_data	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlO1Ol_o	:	STD_LOGIC;
	 SIGNAL  wire_nlO1Ol_sel	:	STD_LOGIC_VECTOR (2 DOWNTO 0);
	 SIGNAL  wire_nlOl1l_data	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_nlOl1l_o	:	STD_LOGIC;
	 SIGNAL  wire_nlOl1l_sel	:	STD_LOGIC_VECTOR (4 DOWNTO 0);
	 SIGNAL  wire_w_lg_w_lg_nl0lOO820w821w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl00ii1107w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl000O1115w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl001l1291w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl01ll1540w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl01Ol1489w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0i0i839w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0liO837w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0lli844w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0lOO820w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl0Oii37w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  wire_w_lg_nl00il1197w	:	STD_LOGIC_VECTOR (0 DOWNTO 0);
	 SIGNAL  nl000i :	STD_LOGIC;
	 SIGNAL  nl000l :	STD_LOGIC;
	 SIGNAL  nl000O :	STD_LOGIC;
	 SIGNAL  nl001i :	STD_LOGIC;
	 SIGNAL  nl001l :	STD_LOGIC;
	 SIGNAL  nl001O :	STD_LOGIC;
	 SIGNAL  nl00ii :	STD_LOGIC;
	 SIGNAL  nl00il :	STD_LOGIC;
	 SIGNAL  nl00iO :	STD_LOGIC;
	 SIGNAL  nl00li :	STD_LOGIC;
	 SIGNAL  nl00ll :	STD_LOGIC;
	 SIGNAL  nl00lO :	STD_LOGIC;
	 SIGNAL  nl00Oi :	STD_LOGIC;
	 SIGNAL  nl00Ol :	STD_LOGIC;
	 SIGNAL  nl00OO :	STD_LOGIC;
	 SIGNAL  nl01li :	STD_LOGIC;
	 SIGNAL  nl01ll :	STD_LOGIC;
	 SIGNAL  nl01lO :	STD_LOGIC;
	 SIGNAL  nl01Oi :	STD_LOGIC;
	 SIGNAL  nl01Ol :	STD_LOGIC;
	 SIGNAL  nl01OO :	STD_LOGIC;
	 SIGNAL  nl0i0i :	STD_LOGIC;
	 SIGNAL  nl0i0l :	STD_LOGIC;
	 SIGNAL  nl0i0O :	STD_LOGIC;
	 SIGNAL  nl0i1i :	STD_LOGIC;
	 SIGNAL  nl0i1l :	STD_LOGIC;
	 SIGNAL  nl0i1O :	STD_LOGIC;
	 SIGNAL  nl0liO :	STD_LOGIC;
	 SIGNAL  nl0lli :	STD_LOGIC;
	 SIGNAL  nl0lOO :	STD_LOGIC;
	 SIGNAL  nl0O0i :	STD_LOGIC;
	 SIGNAL  nl0O1O :	STD_LOGIC;
	 SIGNAL  nl0Oii :	STD_LOGIC;
 BEGIN

	wire_gnd <= '0';
	wire_vcc <= '1';
	wire_w_lg_w_lg_nl0lOO820w821w(0) <= wire_w_lg_nl0lOO820w(0) AND nl00lO;
	wire_w_lg_nl00ii1107w(0) <= nl00ii AND wire_ni00O_w_lg_ni0ii1106w(0);
	wire_w_lg_nl000O1115w(0) <= NOT nl000O;
	wire_w_lg_nl001l1291w(0) <= NOT nl001l;
	wire_w_lg_nl01ll1540w(0) <= NOT nl01ll;
	wire_w_lg_nl01Ol1489w(0) <= NOT nl01Ol;
	wire_w_lg_nl0i0i839w(0) <= NOT nl0i0i;
	wire_w_lg_nl0liO837w(0) <= NOT nl0liO;
	wire_w_lg_nl0lli844w(0) <= NOT nl0lli;
	wire_w_lg_nl0lOO820w(0) <= NOT nl0lOO;
	wire_w_lg_nl0Oii37w(0) <= NOT nl0Oii;
	wire_w_lg_nl00il1197w(0) <= nl00il OR wire_nii1O_w_lg_nllO1l1196w(0);
	a_tdat <= ( nli0ll & nli0lO & nli0Oi & nli0Ol & nli0OO & nlii1i & nlii1l & nlii1O & nlii0i & nlii0l & nlii0O & nliiii & nliiil & nliiiO & nliili & nliill & nliilO & nliiOi & nliiOl & nliiOO & nlil1i & nlil1l & nlil1O & nlil0i & nlil0l & nlil0O & nlilii & nlilil & nliliO & nlilli & nlilll & nlillO);
	a_tenb <= nliO0i;
	a_teop <= nlilOl;
	a_terr <= nlilOO;
	a_tmod <= ( nliO1l & nliO1O);
	a_tprty <= nliO1i;
	a_tsop <= nlilOi;
	b_dav <= n0l0O;
	nl000i <= (nl0Oil OR (nl001i OR (wire_nii1O_w_lg_nl0Oil1288w(0) AND nliO0l)));
	nl000l <= (nl00ii AND ni0ii);
	nl000O <= (nl00ii AND wire_ni00O_w_lg_ni0ii1142w(0));
	nl001i <= (nll1ll OR (nli0iO AND wire_nlli1l_o));
	nl001l <= (wire_nii1O_w_lg_nl0Oil1288w(0) AND (nlO01O AND nll1ll));
	nl001O <= (nlO01O AND nlOiil);
	nl00ii <= (nli0li OR (nli0iO AND nl0OiO));
	nl00il <= (nllO1i OR nlllOO);
	nl00iO <= (wire_n110i_q_b(33) AND wire_n110i_q_b(34));
	nl00li <= wire_n0lii_w_lg_nlllOO1093w(0);
	nl00ll <= ((nl00il AND ni0ii) OR wire_w_lg_nl00ii1107w(0));
	nl00lO <= (((((((NOT (n01lO XOR n0l1l)) AND (NOT (n01li XOR n0iOO))) AND (NOT (n01iO XOR n0iOi))) AND (NOT (n01il XOR n0ilO))) AND (NOT (n01ii XOR n0ill))) AND (NOT (n010O XOR n0ili))) AND (NOT (n010l XOR n0iiO)));
	nl00Oi <= (((((((NOT (n01lO XOR wire_nlilO_o(0))) AND (NOT (n01li XOR wire_nlilO_o(1)))) AND (NOT (n01iO XOR wire_nlilO_o(2)))) AND (NOT (n01il XOR wire_nlilO_o(3)))) AND (NOT (n01ii XOR wire_nlilO_o(4)))) AND (NOT (n010O XOR wire_nlilO_o(5)))) AND (NOT (n010l XOR wire_nlilO_o(6))));
	nl00Ol <= (((((((NOT (nlO1O XOR nl1lO)) AND (NOT (nlO0i XOR nl1Oi))) AND (NOT (nlO0O XOR nl1Ol))) AND (NOT (ni00i XOR nl1OO))) AND (NOT (ni01O XOR nl01i))) AND (NOT (ni01l XOR nl01l))) AND (NOT (ni01i XOR nl01O)));
	nl00OO <= (((((((NOT (nlO1O XOR nl00i)) AND (NOT (nlO0i XOR nliiO))) AND (NOT (nlO0O XOR nlill))) AND (NOT (nllli XOR ni00i))) AND (NOT (nllOl XOR ni01O))) AND (NOT (nllOO XOR ni01l))) AND (NOT (nlO1l XOR ni01i)));
	nl01li <= (nl01ll AND wire_nii1O_w_lg_nl0OlO1538w(0));
	nl01ll <= (nl0Oil AND nlO1iO);
	nl01lO <= (nl0OiO AND nliO0O);
	nl01Oi <= (((((((((((((((wire_nllllO_w_lg_nlllOi1496w(0) AND wire_nllllO_w_lg_nlllll1497w(0)) AND wire_nllllO_w_lg_nlllli1499w(0)) AND wire_nllllO_w_lg_nllliO1501w(0)) AND wire_nllllO_w_lg_nlllil1503w(0)) AND wire_nllllO_w_lg_nlllii1505w(0)) AND wire_nllllO_w_lg_nlll0O1507w(0)) AND wire_nllllO_w_lg_nlll0l1509w(0)) AND wire_nllllO_w_lg_nlll0i1511w(0)) AND wire_nllllO_w_lg_nlll1O1513w(0)) AND wire_nllllO_w_lg_nlll1l1515w(0)) AND wire_nllllO_w_lg_nlll1i1517w(0)) AND wire_nllllO_w_lg_nlliOO1519w(0)) AND wire_nllllO_w_lg_nlliOi1521w(0)) AND wire_nllllO_w_lg_nlli1O1523w(0)) AND nll0iO);
	nl01Ol <= ((nli0li AND nlO01O) OR wire_nii1O_w_lg_nl0OiO1314w(0));
	nl01OO <= (nl0Oil OR nl001i);
	nl0i0i <= (n0lil AND (NOT (n0O0O XOR n0lll)));
	nl0i0l <= (nl0i1O AND wire_ni0li_w_lg_ni0ll543w(0));
	nl0i0O <= (wire_n0l1O_w_lg_n0l0i38w(0) AND (b_eop AND nl0lOO));
	nl0i1i <= (((((((NOT (nii0O XOR ni10l)) AND (NOT (niiii XOR ni10i))) AND (NOT (niiil XOR ni11O))) AND (NOT (niiiO XOR ni11l))) AND (NOT (niili XOR ni11i))) AND (NOT (niill XOR n0OOO))) AND (NOT (niilO XOR n0OOl)));
	nl0i1l <= (((((((NOT (niiOi XOR ni10l)) AND (NOT (nilli XOR ni10i))) AND (NOT (niO0O XOR ni11O))) AND (NOT (niOil XOR ni11l))) AND (NOT (nl1ii XOR ni11i))) AND (NOT (nl1il XOR n0OOO))) AND (NOT (nl1li XOR n0OOl)));
	nl0i1O <= ((wire_w_lg_nl00il1197w(0) OR (nl00ii AND nllO1O)) OR wire_nii1O_w_lg_nllO1O1200w(0));
	nl0liO <= (n01OO XOR wire_n0l1O_w_lg_n01Ol53w(0));
	nl0lli <= ((n1lOO AND (NOT ((n1OlO XOR n1O1O) XOR wire_nl0lOi5_w_lg_Q46w(0)))) AND nl0lll8);
	nl0lOO <= ((wire_n0l1O_w_lg_n0l0i38w(0) AND b_ena) AND nl0O1i2);
	nl0O0i <= '1';
	nl0O1O <= (wire_ni0li_w_lg_ni0il582w(0) AND wire_n110i_w_lg_w_q_b_range583w584w(0));
	nl0Oii <= (ni1il XOR wire_nii1O_w_lg_ni1ii487w(0));
	wire_n110i_w_lg_w_q_b_range583w584w(0) <= wire_n110i_w_q_b_range583w(0) AND ni0iO;
	wire_n110i_address_a <= ( n0i1l & n0i1O & n0i0i & n0i0l & n0i0O & n0iii & n0iil);
	wire_n110i_address_b <= ( nl1li & nl1il & nl1ii & niOil & niO0O & nilli & niiOi);
	wire_n110i_data_a <= ( b_mty(1 DOWNTO 0) & b_par & b_err & b_eop & b_sop & b_dat(31 DOWNTO 0));
	wire_n110i_w_q_b_range583w(0) <= wire_n110i_q_b(33);
	n110i :  altsyncram
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
		address_a => wire_n110i_address_a,
		address_b => wire_n110i_address_b,
		clock0 => b_clk,
		clock1 => a_tfclk,
		clocken0 => wire_vcc,
		clocken1 => nl0i1O,
		data_a => wire_n110i_data_a,
		q_b => wire_n110i_q_b,
		wren_a => nl0lOO
	  );
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iii58 <= nl0iii60;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iii59 <= (nl0iii60 XOR nl0iii58);
		END IF;
	END PROCESS;
	wire_nl0iii59_w_lg_Q422w(0) <= nl0iii59 AND wire_nl0li_w_o_range419w(0);
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iii60 <= nl0iii58;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iil55 <= nl0iil57;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iil56 <= (nl0iil57 XOR nl0iil55);
		END IF;
	END PROCESS;
	wire_nl0iil56_w_lg_Q384w(0) <= nl0iil56 AND wire_nli1O_dataout;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iil57 <= nl0iil55;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iiO52 <= nl0iiO54;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iiO53 <= (nl0iiO54 XOR nl0iiO52);
		END IF;
	END PROCESS;
	wire_nl0iiO53_w_lg_Q380w(0) <= nl0iiO53 AND wire_nli1i_dataout;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iiO54 <= nl0iiO52;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ili49 <= nl0ili51;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ili50 <= (nl0ili51 XOR nl0ili49);
		END IF;
	END PROCESS;
	wire_nl0ili50_w_lg_Q374w(0) <= nl0ili50 AND wire_nl0Oi_dataout;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ili51 <= nl0ili49;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ill46 <= nl0ill48;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ill47 <= (nl0ill48 XOR nl0ill46);
		END IF;
	END PROCESS;
	wire_nl0ill47_w_lg_Q283w(0) <= nl0ill47 AND wire_nli0i_dataout;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ill48 <= nl0ill46;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ilO43 <= nl0ilO45;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ilO44 <= (nl0ilO45 XOR nl0ilO43);
		END IF;
	END PROCESS;
	wire_nl0ilO44_w_lg_Q280w(0) <= nl0ilO44 AND wire_nli1O_dataout;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0ilO45 <= nl0ilO43;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOi40 <= nl0iOi42;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOi41 <= (nl0iOi42 XOR nl0iOi40);
		END IF;
	END PROCESS;
	wire_nl0iOi41_w_lg_Q277w(0) <= nl0iOi41 AND wire_nli1l_dataout;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOi42 <= nl0iOi40;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOl37 <= nl0iOl39;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOl38 <= (nl0iOl39 XOR nl0iOl37);
		END IF;
	END PROCESS;
	wire_nl0iOl38_w_lg_Q269w(0) <= nl0iOl38 AND wire_nl0lO_w_o_range266w(0);
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOl39 <= nl0iOl37;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOO34 <= nl0iOO36;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOO35 <= (nl0iOO36 XOR nl0iOO34);
		END IF;
	END PROCESS;
	wire_nl0iOO35_w_lg_Q260w(0) <= nl0iOO35 AND wire_nl0lO_w_o_range257w(0);
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0iOO36 <= nl0iOO34;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0i22 <= nl0l0i24;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0i23 <= (nl0l0i24 XOR nl0l0i22);
		END IF;
	END PROCESS;
	wire_nl0l0i23_w_lg_Q112w(0) <= nl0l0i23 AND wire_n01ll_w_lg_n010O111w(0);
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0i24 <= nl0l0i22;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0l19 <= nl0l0l21;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0l20 <= (nl0l0l21 XOR nl0l0l19);
		END IF;
	END PROCESS;
	wire_nl0l0l20_w_lg_Q94w(0) <= nl0l0l20 AND n0ili;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0l21 <= nl0l0l19;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0O16 <= nl0l0O18;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0O17 <= (nl0l0O18 XOR nl0l0O16);
		END IF;
	END PROCESS;
	wire_nl0l0O17_w_lg_Q68w(0) <= nl0l0O17 AND n0iiO;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l0O18 <= nl0l0O16;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1i31 <= nl0l1i33;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1i32 <= (nl0l1i33 XOR nl0l1i31);
		END IF;
	END PROCESS;
	wire_nl0l1i32_w_lg_Q251w(0) <= nl0l1i32 AND wire_nl0lO_w_o_range248w(0);
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1i33 <= nl0l1i31;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1l28 <= nl0l1l30;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1l29 <= (nl0l1l30 XOR nl0l1l28);
		END IF;
	END PROCESS;
	wire_nl0l1l29_w_lg_Q242w(0) <= nl0l1l29 AND wire_nl0lO_w_o_range239w(0);
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1l30 <= nl0l1l28;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1O25 <= nl0l1O27;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1O26 <= (nl0l1O27 XOR nl0l1O25);
		END IF;
	END PROCESS;
	wire_nl0l1O26_w_lg_Q132w(0) <= nl0l1O26 AND wire_n01ll_w_lg_n01iO104w(0);
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0l1O27 <= nl0l1O25;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lii13 <= nl0lii15;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lii14 <= (nl0lii15 XOR nl0lii13);
		END IF;
	END PROCESS;
	wire_nl0lii14_w_lg_Q62w(0) <= nl0lii14 AND n0iOi;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lii15 <= nl0lii13;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lil10 <= nl0lil12;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lil11 <= (nl0lil12 XOR nl0lil10);
		END IF;
	END PROCESS;
	wire_nl0lil11_w_lg_Q59w(0) <= nl0lil11 AND n0iOO;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lil12 <= nl0lil10;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lll7 <= nl0lll9;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lll8 <= (nl0lll9 XOR nl0lll7);
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lll9 <= nl0lll7;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lOi4 <= nl0lOi6;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lOi5 <= (nl0lOi6 XOR nl0lOi4);
		END IF;
	END PROCESS;
	wire_nl0lOi5_w_lg_Q46w(0) <= NOT nl0lOi5;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0lOi6 <= nl0lOi4;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0O1i1 <= nl0O1i3;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0O1i2 <= (nl0O1i3 XOR nl0O1i1);
		END IF;
	END PROCESS;
	PROCESS (a_tfclk)
	BEGIN
		IF (a_tfclk = '1' AND a_tfclk'event) THEN nl0O1i3 <= nl0O1i1;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n000i <= '0';
				n000l <= '0';
				n000O <= '0';
				n001i <= '0';
				n001l <= '0';
				n001O <= '0';
				n00il <= '0';
				n1O0i <= '0';
				n1O0l <= '0';
				n1O0O <= '0';
				n1Oii <= '0';
				n1Oil <= '0';
				n1OiO <= '0';
				n1Oli <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (nl0lli = '1') THEN
				n000i <= n00lO;
				n000l <= n00Oi;
				n000O <= n00Ol;
				n001i <= n00iO;
				n001l <= n00li;
				n001O <= n00ll;
				n00il <= n0i1i;
				n1O0i <= n0i1l;
				n1O0l <= n0i1O;
				n1O0O <= n0i0i;
				n1Oii <= n0i0l;
				n1Oil <= n0i0O;
				n1OiO <= n0iii;
				n1Oli <= n0iil;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n00iO <= '0';
				n00li <= '0';
				n00ll <= '0';
				n00lO <= '0';
				n00Oi <= '0';
				n00Ol <= '0';
				n0i1i <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (nl0i0O = '1') THEN
				n00iO <= wire_nl00l_o(6);
				n00li <= wire_nl00l_o(5);
				n00ll <= wire_nl00l_o(4);
				n00lO <= wire_nl00l_o(3);
				n00Oi <= wire_nl00l_o(2);
				n00Ol <= wire_nl00l_o(1);
				n0i1i <= wire_nl00l_o(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n010l <= '0';
				n010O <= '0';
				n01ii <= '0';
				n01il <= '0';
				n01iO <= '0';
				n01li <= '0';
				n01lO <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (nl0liO = '0') THEN
				n010l <= n1OOi;
				n010O <= n1OOl;
				n01ii <= n1OOO;
				n01il <= n011i;
				n01iO <= n011l;
				n01li <= n011O;
				n01lO <= n010i;
			END IF;
		END IF;
	END PROCESS;
	wire_n01ll_w_lg_n010l114w(0) <= NOT n010l;
	wire_n01ll_w_lg_n010O111w(0) <= NOT n010O;
	wire_n01ll_w_lg_n01ii108w(0) <= NOT n01ii;
	wire_n01ll_w_lg_n01il106w(0) <= NOT n01il;
	wire_n01ll_w_lg_n01iO104w(0) <= NOT n01iO;
	wire_n01ll_w_lg_n01li102w(0) <= NOT n01li;
	wire_n01ll_w_lg_n01lO100w(0) <= NOT n01lO;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n0i0i <= '0';
				n0i0l <= '0';
				n0i0O <= '0';
				n0i1l <= '0';
				n0i1O <= '0';
				n0iii <= '0';
				n0iil <= '0';
				n0iiO <= '0';
				n0ili <= '0';
				n0ill <= '0';
				n0ilO <= '0';
				n0iOi <= '0';
				n0iOO <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (nl0lOO = '1') THEN
				n0i0i <= n0ill;
				n0i0l <= n0ilO;
				n0i0O <= n0iOi;
				n0i1l <= n0iiO;
				n0i1O <= n0ili;
				n0iii <= n0iOO;
				n0iil <= n0l1l;
				n0iiO <= wire_nlilO_o(6);
				n0ili <= wire_nlilO_o(5);
				n0ill <= wire_nlilO_o(4);
				n0ilO <= wire_nlilO_o(3);
				n0iOi <= wire_nlilO_o(2);
				n0iOO <= wire_nlilO_o(1);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n0l0O <= '1';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
				n0l0O <= wire_nl0ii_dataout;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n0l1l <= '1';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
			IF (nl0lOO = '1') THEN
				n0l1l <= wire_nlilO_o(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n010i <= '0';
				n011i <= '0';
				n011l <= '0';
				n011O <= '0';
				n01Oi <= '0';
				n01Ol <= '0';
				n01OO <= '0';
				n0l0i <= '0';
				n1O1i <= '0';
				n1O1l <= '0';
				n1O1O <= '0';
				n1Oll <= '0';
				n1OlO <= '0';
				n1OOi <= '0';
				n1OOl <= '0';
				n1OOO <= '0';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
				n010i <= n0O0i;
				n011i <= n0lOO;
				n011l <= n0O1i;
				n011O <= n0O1l;
				n01Oi <= n0lll;
				n01Ol <= n01Oi;
				n01OO <= n01Ol;
				n0l0i <= ((nl0lOO AND nl00Oi) OR wire_w_lg_w_lg_nl0lOO820w821w(0));
				n1O1i <= wire_nliOO_dataout;
				n1O1l <= wire_nliOl_dataout;
				n1O1O <= wire_n1lil_dataout;
				n1Oll <= ni1il;
				n1OlO <= n1Oll;
				n1OOi <= n0llO;
				n1OOl <= n0lOi;
				n1OOO <= n0lOl;
		END IF;
	END PROCESS;
	wire_n0l1O_w_lg_n01Ol53w(0) <= NOT n01Ol;
	wire_n0l1O_w_lg_n0l0i38w(0) <= NOT n0l0i;
	wire_n0l1O_w_lg_n1O1i845w(0) <= NOT n1O1i;
	wire_n0l1O_w_lg_n1O1O843w(0) <= NOT n1O1O;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				n0lil <= '1';
				nli0iO <= '1';
				nlllOO <= '1';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
				n0lil <= wire_niOOi_dataout;
				nli0iO <= wire_nlli1l_o;
				nlllOO <= wire_nlO01i_o;
		END IF;
	END PROCESS;
	wire_n0lii_w_lg_nli0iO1313w(0) <= nli0iO AND nlO01O;
	wire_n0lii_w_lg_nlllOO1093w(0) <= nlllOO OR nllO1l;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				n0llO <= '0';
				n0lOi <= '0';
				n0lOl <= '0';
				n0lOO <= '0';
				n0O0i <= '0';
				n0O1i <= '0';
				n0O1l <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl0i0i = '1') THEN
				n0llO <= nl1li;
				n0lOi <= nl1il;
				n0lOl <= nl1ii;
				n0lOO <= niOil;
				n0O0i <= niiOi;
				n0O1i <= niO0O;
				n0O1l <= nilli;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				n111i <= '0';
				n111O <= '0';
				nllO0i <= '0';
				nllO0l <= '0';
				nllO0O <= '0';
				nllOii <= '0';
				nllOil <= '0';
				nllOiO <= '0';
				nllOli <= '0';
				nllOll <= '0';
				nllOlO <= '0';
				nllOOi <= '0';
				nllOOl <= '0';
				nllOOO <= '0';
				nlO11i <= '0';
				nlO11l <= '0';
				nlOi0i <= '0';
				nlOi0l <= '0';
				nlOi0O <= '0';
				nlOiii <= '0';
				nlOiil <= '0';
				nlOiiO <= '0';
				nlOili <= '0';
				nlOill <= '0';
				nlOilO <= '0';
				nlOiOi <= '0';
				nlOl1O <= '0';
				nlOlii <= '0';
				nlOliO <= '0';
				nlOlli <= '0';
				nlOlll <= '0';
				nlOO0i <= '0';
				nlOO0l <= '0';
				nlOO0O <= '0';
				nlOO1l <= '0';
				nlOO1O <= '0';
				nlOOOl <= '0';
				nlOOOO <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl00ll = '1') THEN
				n111i <= wire_n110i_q_b(16);
				n111O <= wire_n110i_q_b(17);
				nllO0i <= wire_n110i_q_b(31);
				nllO0l <= wire_n110i_q_b(30);
				nllO0O <= wire_n110i_q_b(29);
				nllOii <= wire_n110i_q_b(28);
				nllOil <= wire_n110i_q_b(27);
				nllOiO <= wire_n110i_q_b(26);
				nllOli <= wire_n110i_q_b(25);
				nllOll <= wire_n110i_q_b(24);
				nllOlO <= wire_n110i_q_b(23);
				nllOOi <= wire_n110i_q_b(22);
				nllOOl <= wire_n110i_q_b(21);
				nllOOO <= wire_n110i_q_b(20);
				nlO11i <= wire_n110i_q_b(19);
				nlO11l <= wire_n110i_q_b(18);
				nlOi0i <= wire_n110i_q_b(36);
				nlOi0l <= wire_n110i_q_b(37);
				nlOi0O <= wire_n110i_q_b(35);
				nlOiii <= wire_nlOOii_dataout;
				nlOiil <= wire_nlOOli_dataout;
				nlOiiO <= wire_nlOOlO_dataout;
				nlOili <= wire_n110i_q_b(0);
				nlOill <= wire_n110i_q_b(1);
				nlOilO <= wire_n110i_q_b(2);
				nlOiOi <= wire_n110i_q_b(3);
				nlOl1O <= wire_n110i_q_b(4);
				nlOlii <= wire_n110i_q_b(5);
				nlOliO <= wire_n110i_q_b(6);
				nlOlli <= wire_n110i_q_b(7);
				nlOlll <= wire_n110i_q_b(8);
				nlOO0i <= wire_n110i_q_b(11);
				nlOO0l <= wire_n110i_q_b(12);
				nlOO0O <= wire_n110i_q_b(13);
				nlOO1l <= wire_n110i_q_b(9);
				nlOO1O <= wire_n110i_q_b(10);
				nlOOOl <= wire_n110i_q_b(14);
				nlOOOO <= wire_n110i_q_b(15);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (b_clk, b_reset_n)
	BEGIN
		IF (b_reset_n = '0') THEN
				n1lOO <= '1';
		ELSIF (b_clk = '1' AND b_clk'event) THEN
				n1lOO <= wire_nll1i_dataout;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				ni0ii <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl0i1O = '1') THEN
				ni0ii <= wire_ni0li_w_lg_ni0ll543w(0);
			END IF;
		END IF;
	END PROCESS;
	wire_ni00O_w_lg_ni0ii1106w(0) <= ni0ii AND wire_nii1O_w_lg_nllO1l1105w(0);
	wire_ni00O_w_lg_ni0ii1142w(0) <= NOT ni0ii;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				ni0il <= '1';
				ni0ll <= '1';
				nliO0i <= '1';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
				ni0il <= ni0ll;
				ni0ll <= wire_niO1O_dataout;
				nliO0i <= wire_w_lg_nl01Ol1489w(0);
		END IF;
	END PROCESS;
	wire_ni0li_w_lg_ni0il582w(0) <= NOT ni0il;
	wire_ni0li_w_lg_ni0ll543w(0) <= NOT ni0ll;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				nii0O <= '1';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl0i0l = '1') THEN
				nii0O <= wire_niO0i_o(0);
			END IF;
		END IF;
	END PROCESS;
	wire_nii0l_w_lg_nii0O503w(0) <= NOT nii0O;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				n0liO <= '0';
				n0lli <= '0';
				n0lll <= '0';
				n0O0l <= '0';
				n0O0O <= '0';
				n0Oii <= '0';
				n0Oil <= '0';
				n0OiO <= '0';
				n0Oli <= '0';
				n0Oll <= '0';
				n0OlO <= '0';
				n0OOi <= '0';
				ni00l <= '0';
				ni0iO <= '0';
				ni0lO <= '0';
				ni0Oi <= '0';
				ni0Ol <= '0';
				ni0OO <= '0';
				ni10O <= '0';
				ni1ii <= '0';
				ni1il <= '0';
				ni1iO <= '0';
				ni1li <= '0';
				ni1ll <= '0';
				ni1lO <= '0';
				ni1Oi <= '0';
				ni1Ol <= '0';
				ni1OO <= '0';
				nii0i <= '0';
				nii1i <= '0';
				nii1l <= '0';
				nl0Oil <= '0';
				nl0OiO <= '0';
				nl0Oli <= '0';
				nl0OlO <= '0';
				nli00O <= '0';
				nli01O <= '0';
				nli0li <= '0';
				nli0ll <= '0';
				nli0lO <= '0';
				nli0Oi <= '0';
				nli0Ol <= '0';
				nli0OO <= '0';
				nlii0i <= '0';
				nlii0l <= '0';
				nlii0O <= '0';
				nlii1i <= '0';
				nlii1l <= '0';
				nlii1O <= '0';
				nliiii <= '0';
				nliiil <= '0';
				nliiiO <= '0';
				nliili <= '0';
				nliill <= '0';
				nliilO <= '0';
				nliiOi <= '0';
				nliiOl <= '0';
				nliiOO <= '0';
				nlil0i <= '0';
				nlil0l <= '0';
				nlil0O <= '0';
				nlil1i <= '0';
				nlil1l <= '0';
				nlil1O <= '0';
				nlilii <= '0';
				nlilil <= '0';
				nliliO <= '0';
				nlilli <= '0';
				nlilll <= '0';
				nlillO <= '0';
				nlilOi <= '0';
				nlilOl <= '0';
				nlilOO <= '0';
				nliO0l <= '0';
				nliO0O <= '0';
				nliO1i <= '0';
				nliO1l <= '0';
				nliO1O <= '0';
				nll1ll <= '0';
				nlllOl <= '0';
				nllO1i <= '0';
				nllO1l <= '0';
				nllO1O <= '0';
				nlO01O <= '0';
				nlO1iO <= '0';
				nlO1ll <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
				n0liO <= wire_niOlO_dataout;
				n0lli <= wire_niOll_dataout;
				n0lll <= wire_n1liO_dataout;
				n0O0l <= n01OO;
				n0O0O <= n0O0l;
				n0Oii <= n1O0i;
				n0Oil <= n1O0l;
				n0OiO <= n1O0O;
				n0Oli <= n1Oii;
				n0Oll <= n1Oil;
				n0OlO <= n1OiO;
				n0OOi <= n1Oli;
				ni00l <= wire_niiOl_dataout;
				ni0iO <= nl0i1O;
				ni0lO <= wire_nilll_dataout;
				ni0Oi <= wire_nillO_dataout;
				ni0Ol <= wire_nilOi_dataout;
				ni0OO <= wire_nilOl_dataout;
				ni10O <= n1O1O;
				ni1ii <= ni10O;
				ni1il <= ni1ii;
				ni1iO <= n001i;
				ni1li <= n001l;
				ni1ll <= n001O;
				ni1lO <= n000i;
				ni1Oi <= n000l;
				ni1Ol <= n000O;
				ni1OO <= n00il;
				nii0i <= wire_niO1l_dataout;
				nii1i <= wire_nilOO_dataout;
				nii1l <= wire_niO1i_dataout;
				nl0Oil <= nlllOl;
				nl0OiO <= (wire_nli10l_dataout OR wire_nli11i_dataout);
				nl0Oli <= wire_nli10l_dataout;
				nl0OlO <= wire_nl0OOl_dataout;
				nli00O <= wire_nli10i_dataout;
				nli01O <= wire_nli1Oi_dataout;
				nli0li <= wire_nlli1i_o;
				nli0ll <= nllO0i;
				nli0lO <= nllO0l;
				nli0Oi <= nllO0O;
				nli0Ol <= nllOii;
				nli0OO <= nllOil;
				nlii0i <= nllOlO;
				nlii0l <= nllOOi;
				nlii0O <= nllOOl;
				nlii1i <= nllOiO;
				nlii1l <= nllOli;
				nlii1O <= nllOll;
				nliiii <= nllOOO;
				nliiil <= nlO11i;
				nliiiO <= nlO11l;
				nliili <= n111O;
				nliill <= n111i;
				nliilO <= nlOOOO;
				nliiOi <= nlOOOl;
				nliiOl <= nlOO0O;
				nliiOO <= nlOO0l;
				nlil0i <= nlOlll;
				nlil0l <= nlOlli;
				nlil0O <= nlOliO;
				nlil1i <= nlOO0i;
				nlil1l <= nlOO1O;
				nlil1O <= nlOO1l;
				nlilii <= nlOlii;
				nlilil <= nlOl1O;
				nliliO <= nlOiOi;
				nlilli <= nlOilO;
				nlilll <= nlOill;
				nlillO <= nlOili;
				nlilOi <= (nl01Ol AND nlOiiO);
				nlilOl <= (nl01Ol AND nlOiil);
				nlilOO <= (nl01Ol AND nlOiii);
				nliO0l <= nl01Ol;
				nliO0O <= wire_nlli1l_o;
				nliO1i <= (nl01Ol AND nlOi0O);
				nliO1l <= (nl01Ol AND nlOi0l);
				nliO1O <= (nl01Ol AND nlOi0i);
				nll1ll <= wire_nli0il_dataout;
				nlllOl <= a_dtpa(0);
				nllO1i <= wire_nlO1Ol_o;
				nllO1l <= wire_nlO1Oi_o;
				nllO1O <= wire_nlO1lO_o;
				nlO01O <= wire_nlOl1l_o;
				nlO1iO <= wire_nlOiOl_dataout;
				nlO1ll <= wire_nlOiOl_dataout;
		END IF;
	END PROCESS;
	wire_nii1O_w_lg_nl0OiO1314w(0) <= nl0OiO AND wire_n0lii_w_lg_nli0iO1313w(0);
	wire_nii1O_w_lg_nllO1l1196w(0) <= nllO1l AND nl00ii;
	wire_nii1O_w_lg_nllO1O1200w(0) <= nllO1O AND wire_ni00O_w_lg_ni0ii1142w(0);
	wire_nii1O_w_lg_n0liO840w(0) <= NOT n0liO;
	wire_nii1O_w_lg_n0lll838w(0) <= NOT n0lll;
	wire_nii1O_w_lg_ni1ii487w(0) <= NOT ni1ii;
	wire_nii1O_w_lg_nl0Oil1288w(0) <= NOT nl0Oil;
	wire_nii1O_w_lg_nl0Oli1541w(0) <= NOT nl0Oli;
	wire_nii1O_w_lg_nl0OlO1538w(0) <= NOT nl0OlO;
	wire_nii1O_w_lg_nli0li1296w(0) <= NOT nli0li;
	wire_nii1O_w_lg_nlO01O1292w(0) <= NOT nlO01O;
	wire_nii1O_w_lg_nllO1i1148w(0) <= nllO1i OR nllO1O;
	wire_nii1O_w_lg_nllO1l1105w(0) <= nllO1l OR nllO1O;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				niiii <= '0';
				niiil <= '0';
				niiiO <= '0';
				niili <= '0';
				niill <= '0';
				niilO <= '0';
				niiOi <= '0';
				nilli <= '0';
				niO0O <= '0';
				niOil <= '0';
				nl1ii <= '0';
				nl1il <= '0';
				nl1li <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl0i0l = '1') THEN
				niiii <= wire_niO0i_o(1);
				niiil <= wire_niO0i_o(2);
				niiiO <= wire_niO0i_o(3);
				niili <= wire_niO0i_o(4);
				niill <= wire_niO0i_o(5);
				niilO <= wire_niO0i_o(6);
				niiOi <= nii0O;
				nilli <= niiii;
				niO0O <= niiil;
				niOil <= niiiO;
				nl1ii <= niili;
				nl1il <= niill;
				nl1li <= niilO;
			END IF;
		END IF;
	END PROCESS;
	wire_nl1iO_w_lg_niiii505w(0) <= NOT niiii;
	wire_nl1iO_w_lg_niiil507w(0) <= NOT niiil;
	wire_nl1iO_w_lg_niiiO509w(0) <= NOT niiiO;
	wire_nl1iO_w_lg_niili511w(0) <= NOT niili;
	wire_nl1iO_w_lg_niill513w(0) <= NOT niill;
	wire_nl1iO_w_lg_niilO515w(0) <= NOT niilO;
	wire_nl1iO_w_lg_niiOi530w(0) <= NOT niiOi;
	wire_nl1iO_w_lg_nilli532w(0) <= NOT nilli;
	wire_nl1iO_w_lg_niO0O534w(0) <= NOT niO0O;
	wire_nl1iO_w_lg_niOil536w(0) <= NOT niOil;
	wire_nl1iO_w_lg_nl1ii538w(0) <= NOT nl1ii;
	wire_nl1iO_w_lg_nl1il540w(0) <= NOT nl1il;
	wire_nl1iO_w_lg_nl1li542w(0) <= NOT nl1li;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				nl1lO <= '1';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl0O1O = '1') THEN
				nl1lO <= wire_nilil_o(0);
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				nli00l <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl01lO = '1') THEN
				nli00l <= nli00O;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				nll0iO <= '0';
				nlli1O <= '0';
				nlliOi <= '0';
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
				nlllll <= '0';
				nlllOi <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl000i = '1') THEN
				nll0iO <= wire_nliOil_dataout;
				nlli1O <= wire_nliOiO_dataout;
				nlliOi <= wire_nliOli_dataout;
				nlliOO <= wire_nliOll_dataout;
				nlll0i <= wire_nliOOO_dataout;
				nlll0l <= wire_nll11i_dataout;
				nlll0O <= wire_nll11l_dataout;
				nlll1i <= wire_nliOlO_dataout;
				nlll1l <= wire_nliOOi_dataout;
				nlll1O <= wire_nliOOl_dataout;
				nlllii <= wire_nll11O_dataout;
				nlllil <= wire_nll10i_dataout;
				nllliO <= wire_nll10l_dataout;
				nlllli <= wire_nll10O_dataout;
				nlllll <= wire_nll1ii_dataout;
				nlllOi <= wire_nll1il_dataout;
			END IF;
		END IF;
	END PROCESS;
	wire_nllllO_w_lg_nlli1O1523w(0) <= NOT nlli1O;
	wire_nllllO_w_lg_nlliOi1521w(0) <= NOT nlliOi;
	wire_nllllO_w_lg_nlliOO1519w(0) <= NOT nlliOO;
	wire_nllllO_w_lg_nlll0i1511w(0) <= NOT nlll0i;
	wire_nllllO_w_lg_nlll0l1509w(0) <= NOT nlll0l;
	wire_nllllO_w_lg_nlll0O1507w(0) <= NOT nlll0O;
	wire_nllllO_w_lg_nlll1i1517w(0) <= NOT nlll1i;
	wire_nllllO_w_lg_nlll1l1515w(0) <= NOT nlll1l;
	wire_nllllO_w_lg_nlll1O1513w(0) <= NOT nlll1O;
	wire_nllllO_w_lg_nlllii1505w(0) <= NOT nlllii;
	wire_nllllO_w_lg_nlllil1503w(0) <= NOT nlllil;
	wire_nllllO_w_lg_nllliO1501w(0) <= NOT nllliO;
	wire_nllllO_w_lg_nlllli1499w(0) <= NOT nlllli;
	wire_nllllO_w_lg_nlllll1497w(0) <= NOT nlllll;
	wire_nllllO_w_lg_nlllOi1496w(0) <= NOT nlllOi;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				n0OOl <= '0';
				n0OOO <= '0';
				ni00i <= '0';
				ni01i <= '0';
				ni01l <= '0';
				ni01O <= '0';
				ni10i <= '0';
				ni10l <= '0';
				ni11i <= '0';
				ni11l <= '0';
				ni11O <= '0';
				nlO0i <= '0';
				nlO0O <= '0';
				nlO1O <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl0Oii = '0') THEN
				n0OOl <= n0Oii;
				n0OOO <= n0Oil;
				ni00i <= ni1lO;
				ni01i <= ni1iO;
				ni01l <= ni1li;
				ni01O <= ni1ll;
				ni10i <= n0OlO;
				ni10l <= n0OOi;
				ni11i <= n0OiO;
				ni11l <= n0Oli;
				ni11O <= n0Oll;
				nlO0i <= ni1Ol;
				nlO0O <= ni1Oi;
				nlO1O <= ni1OO;
			END IF;
		END IF;
	END PROCESS;
	PROCESS (a_tfclk, a_treset_n)
	BEGIN
		IF (a_treset_n = '0') THEN
				nl00i <= '0';
				nl01i <= '0';
				nl01l <= '0';
				nl01O <= '0';
				nl1Oi <= '0';
				nl1Ol <= '0';
				nl1OO <= '0';
				nliiO <= '0';
				nlill <= '0';
				nllli <= '0';
				nllOl <= '0';
				nllOO <= '0';
				nlO1l <= '0';
		ELSIF (a_tfclk = '1' AND a_tfclk'event) THEN
			IF (nl0O1O = '1') THEN
				nl00i <= nl1lO;
				nl01i <= wire_nilil_o(4);
				nl01l <= wire_nilil_o(5);
				nl01O <= wire_nilil_o(6);
				nl1Oi <= wire_nilil_o(1);
				nl1Ol <= wire_nilil_o(2);
				nl1OO <= wire_nilil_o(3);
				nliiO <= nl1Oi;
				nlill <= nl1Ol;
				nllli <= nl1OO;
				nllOl <= nl01i;
				nllOO <= nl01l;
				nlO1l <= nl01O;
			END IF;
		END IF;
	END PROCESS;
	wire_n1lil_dataout <= wire_n0l1O_w_lg_n1O1O843w(0) WHEN (n1O1l AND (wire_w_lg_nl0lli844w(0) AND wire_n0l1O_w_lg_n1O1i845w(0))) = '1'  ELSE n1O1O;
	wire_n1liO_dataout <= wire_nii1O_w_lg_n0lll838w(0) WHEN (n0lli AND (wire_w_lg_nl0i0i839w(0) AND wire_nii1O_w_lg_n0liO840w(0))) = '1'  ELSE n0lll;
	wire_niiOl_dataout <= wire_niiOO_dataout OR (wire_nilii_w_lg_dataout810w(0) OR wire_nil0O_o);
	wire_niiOO_dataout <= ni00l AND NOT((nl0i1O AND (wire_nilii_dataout AND wire_nil1O_o)));
	wire_nilii_dataout <= nl00Ol WHEN nl0O1O = '1'  ELSE nl00OO;
	wire_nilii_w_lg_dataout810w(0) <= NOT wire_nilii_dataout;
	wire_nilll_dataout <= wire_niOiO_o(1) WHEN nl0i0l = '1'  ELSE wire_niOii_o(1);
	wire_nillO_dataout <= wire_niOiO_o(2) WHEN nl0i0l = '1'  ELSE wire_niOii_o(2);
	wire_nilOi_dataout <= wire_niOiO_o(3) WHEN nl0i0l = '1'  ELSE wire_niOii_o(3);
	wire_nilOl_dataout <= wire_niOiO_o(4) WHEN nl0i0l = '1'  ELSE wire_niOii_o(4);
	wire_nilOO_dataout <= wire_niOiO_o(5) WHEN nl0i0l = '1'  ELSE wire_niOii_o(5);
	wire_niO1i_dataout <= wire_niOiO_o(6) WHEN nl0i0l = '1'  ELSE wire_niOii_o(6);
	wire_niO1l_dataout <= wire_niOiO_o(7) WHEN nl0i0l = '1'  ELSE wire_niOii_o(7);
	wire_niO1O_dataout <= nl0i1i WHEN nl0i0l = '1'  ELSE nl0i1l;
	wire_niOll_dataout <= wire_niOOl_dataout AND NOT(nl0i0i);
	wire_niOlO_dataout <= wire_niOOO_dataout OR nl0i0i;
	wire_niOOi_dataout <= wire_nl11i_dataout AND NOT(nl0i0i);
	wire_niOOl_dataout <= wire_nl11l_dataout OR n0liO;
	wire_niOOO_dataout <= wire_nl11O_dataout AND NOT(n0liO);
	wire_nl0ii_dataout <= wire_nl0il_dataout AND NOT(wire_nl0ll_o);
	wire_nl0il_dataout <= n0l0O OR wire_nl0iO_o;
	wire_nl0Oi_dataout <= wire_nli0O_o(1) WHEN nl0lOO = '1'  ELSE wire_nli0l_o(1);
	wire_nl0Ol_dataout <= wire_nli0O_o(2) WHEN nl0lOO = '1'  ELSE wire_nli0l_o(2);
	wire_nl0OO_dataout <= wire_nli0O_o(3) WHEN nl0lOO = '1'  ELSE wire_nli0l_o(3);
	wire_nl0OOl_dataout <= wire_nli11l_o(0) WHEN nl01lO = '1'  ELSE wire_nl0OOO_dataout;
	wire_nl0OOO_dataout <= nl0OlO AND NOT(nliO0O);
	wire_nl10i_dataout <= n0lil OR n0lli;
	wire_nl11i_dataout <= wire_nl10i_dataout AND NOT(n0liO);
	wire_nl11l_dataout <= n0lli AND NOT(n0lli);
	wire_nl11O_dataout <= n0liO AND NOT(n0lli);
	wire_nli01i_dataout <= wire_nli01l_o(0) AND nli00O;
	wire_nli0i_dataout <= wire_nli0O_o(7) WHEN nl0lOO = '1'  ELSE wire_nli0l_o(7);
	wire_nli0il_dataout <= wire_nliOii_dataout WHEN nl000i = '1'  ELSE nll1ll;
	wire_nli10i_dataout <= wire_nli1li_dataout WHEN wire_nii1O_w_lg_nl0Oli1541w(0) = '1'  ELSE wire_nli10O_dataout;
	wire_nli10l_dataout <= wire_nli1ll_dataout WHEN wire_nii1O_w_lg_nl0Oli1541w(0) = '1'  ELSE wire_nli1ii_dataout;
	wire_nli10O_dataout <= nli00O WHEN nliO0O = '1'  ELSE wire_nli1il_dataout;
	wire_nli11i_dataout <= nl01ll AND NOT(nl01lO);
	wire_nli1i_dataout <= wire_nli0O_o(4) WHEN nl0lOO = '1'  ELSE wire_nli0l_o(4);
	wire_nli1ii_dataout <= wire_nli1iO_dataout AND NOT(nliO0O);
	wire_nli1il_dataout <= nli00l WHEN wire_w_lg_nl01ll1540w(0) = '1'  ELSE nli00O;
	wire_nli1iO_dataout <= nl0Oli AND NOT(wire_w_lg_nl01ll1540w(0));
	wire_nli1l_dataout <= wire_nli0O_o(5) WHEN nl0lOO = '1'  ELSE wire_nli0l_o(5);
	wire_nli1li_dataout <= nli01O WHEN nl01li = '1'  ELSE nli00O;
	wire_nli1ll_dataout <= nl0Oli OR nl01li;
	wire_nli1O_dataout <= wire_nli0O_o(6) WHEN nl0lOO = '1'  ELSE wire_nli0l_o(6);
	wire_nli1Oi_dataout <= wire_nli01i_dataout WHEN nl01lO = '1'  ELSE wire_nli1Ol_dataout;
	wire_nli1Ol_dataout <= wire_nli1OO_o(0) AND nli01O;
	wire_nliOii_dataout <= nl01Oi AND NOT(nl01OO);
	wire_nliOil_dataout <= wire_nll1li_o(1) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(1);
	wire_nliOiO_dataout <= wire_nll1li_o(2) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(2);
	wire_nliOl_dataout <= wire_nll1l_dataout AND NOT(nl0lli);
	wire_nliOli_dataout <= wire_nll1li_o(3) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(3);
	wire_nliOll_dataout <= wire_nll1li_o(4) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(4);
	wire_nliOlO_dataout <= wire_nll1li_o(5) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(5);
	wire_nliOO_dataout <= wire_nll1O_dataout OR nl0lli;
	wire_nliOOi_dataout <= wire_nll1li_o(6) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(6);
	wire_nliOOl_dataout <= wire_nll1li_o(7) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(7);
	wire_nliOOO_dataout <= wire_nll1li_o(8) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(8);
	wire_nll0i_dataout <= wire_nllii_dataout AND NOT(n1O1i);
	wire_nll0l_dataout <= n1O1l AND NOT(n1O1l);
	wire_nll0O_dataout <= n1O1i AND NOT(n1O1l);
	wire_nll10i_dataout <= wire_nll1li_o(12) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(12);
	wire_nll10l_dataout <= wire_nll1li_o(13) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(13);
	wire_nll10O_dataout <= wire_nll1li_o(14) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(14);
	wire_nll11i_dataout <= wire_nll1li_o(9) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(9);
	wire_nll11l_dataout <= wire_nll1li_o(10) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(10);
	wire_nll11O_dataout <= wire_nll1li_o(11) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(11);
	wire_nll1i_dataout <= wire_nll0i_dataout AND NOT(nl0lli);
	wire_nll1ii_dataout <= wire_nll1li_o(15) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(15);
	wire_nll1il_dataout <= wire_nll1li_o(16) WHEN nl01OO = '1'  ELSE wire_nll1iO_o(16);
	wire_nll1l_dataout <= wire_nll0l_dataout OR n1O1i;
	wire_nll1O_dataout <= wire_nll0O_dataout AND NOT(n1O1i);
	wire_nlli0i_dataout <= wire_nlliil_dataout AND NOT(wire_nii1O_w_lg_nlO01O1292w(0));
	wire_nlli0l_dataout <= wire_nlliiO_dataout OR wire_nii1O_w_lg_nlO01O1292w(0);
	wire_nlli0O_dataout <= wire_nlliil_dataout AND nl0OiO;
	wire_nllii_dataout <= n1lOO OR n1O1l;
	wire_nlliii_dataout <= wire_nlliiO_dataout OR NOT(nl0OiO);
	wire_nlliil_dataout <= wire_w_lg_nl001l1291w(0) AND NOT(nl001O);
	wire_nlliiO_dataout <= nl001l OR nl001O;
	wire_nlO00i_dataout <= wire_nlOOli_w_lg_dataout1140w(0) WHEN nl000l = '1'  ELSE wire_w_lg_nl000O1115w(0);
	wire_nlO00l_dataout <= wire_nlOOli_dataout AND nl000l;
	wire_nlO00O_dataout <= nl000O AND NOT(nl000l);
	wire_nlO0ii_dataout <= wire_nlOi1l_dataout AND nl000l;
	wire_nlO0il_dataout <= wire_nlOi1O_dataout WHEN nl000l = '1'  ELSE wire_w_lg_nl000O1115w(0);
	wire_nlO0iO_dataout <= wire_nlOOlO_w_lg_dataout1139w(0) WHEN nl000l = '1'  ELSE nl000O;
	wire_nlO0lO_dataout <= wire_nlOOli_w_lg_dataout1140w(0) AND ni0ii;
	wire_nlO0Oi_dataout <= wire_nlOOli_dataout AND ni0ii;
	wire_nlO0Ol_dataout <= wire_nlOi1l_dataout AND ni0ii;
	wire_nlO0OO_dataout <= wire_nlOi1O_dataout AND ni0ii;
	wire_nlOi1i_dataout <= wire_nlOOlO_w_lg_dataout1139w(0) OR NOT(ni0ii);
	wire_nlOi1l_dataout <= wire_nlOOli_w_lg_dataout1140w(0) AND NOT(wire_nlOOlO_w_lg_dataout1139w(0));
	wire_nlOi1O_dataout <= wire_nlOOli_dataout AND NOT(wire_nlOOlO_w_lg_dataout1139w(0));
	wire_nlOiOl_dataout <= ni00l WHEN nl00ll = '1'  ELSE wire_nlOiOO_dataout;
	wire_nlOiOO_dataout <= ni00l WHEN nl00ii = '1'  ELSE (ni00l OR nlO1ll);
	wire_nlOl0i_dataout <= wire_w_lg_nl000O1115w(0) OR nl000l;
	wire_nlOl0l_dataout <= wire_nlO01i_w_lg_o1112w(0) WHEN nl000l = '1'  ELSE wire_w_lg_nl000O1115w(0);
	wire_nlOl0O_dataout <= wire_nlO1Ol_w_lg_o1114w(0) AND ni0ii;
	wire_nlOlil_dataout <= wire_nlO01i_w_lg_o1112w(0) AND ni0ii;
	wire_nlOOii_dataout <= nl00iO WHEN nl00li = '1'  ELSE (wire_n110i_q_b(32) OR nl00iO);
	wire_nlOOli_dataout <= wire_n110i_q_b(33) WHEN nl00li = '1'  ELSE (wire_n110i_q_b(32) OR wire_n110i_q_b(33));
	wire_nlOOli_w_lg_dataout1140w(0) <= NOT wire_nlOOli_dataout;
	wire_nlOOlO_dataout <= wire_n110i_q_b(32) AND nl00li;
	wire_nlOOlO_w_lg_dataout1139w(0) <= NOT wire_nlOOlO_dataout;
	wire_nil0i_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0");
	wire_nil0i_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nil0i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16,
		width_o => 16
	  )
	  PORT MAP ( 
		a => wire_nil0i_a,
		b => wire_nil0i_b,
		cin => wire_gnd,
		o => wire_nil0i_o
	  );
	wire_nilil_a <= ( nl01O & nl01l & nl01i & nl1OO & nl1Ol & nl1Oi & nl1lO);
	wire_nilil_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nilil :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_nilil_a,
		b => wire_nilil_b,
		cin => wire_gnd,
		o => wire_nilil_o
	  );
	wire_niO0i_a <= ( niilO & niill & niili & niiiO & niiil & niiii & nii0O);
	wire_niO0i_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "1");
	niO0i :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_niO0i_a,
		b => wire_niO0i_b,
		cin => wire_gnd,
		o => wire_niO0i_o
	  );
	wire_niOii_a <= ( n0OOl & n0OOO & ni11i & ni11l & ni11O & ni10i & ni10l & "1");
	wire_niOii_b <= ( wire_nl1iO_w_lg_nl1li542w & wire_nl1iO_w_lg_nl1il540w & wire_nl1iO_w_lg_nl1ii538w & wire_nl1iO_w_lg_niOil536w & wire_nl1iO_w_lg_niO0O534w & wire_nl1iO_w_lg_nilli532w & wire_nl1iO_w_lg_niiOi530w & "1");
	niOii :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8,
		width_o => 8
	  )
	  PORT MAP ( 
		a => wire_niOii_a,
		b => wire_niOii_b,
		cin => wire_gnd,
		o => wire_niOii_o
	  );
	wire_niOiO_a <= ( n0OOl & n0OOO & ni11i & ni11l & ni11O & ni10i & ni10l & "1");
	wire_niOiO_b <= ( wire_nl1iO_w_lg_niilO515w & wire_nl1iO_w_lg_niill513w & wire_nl1iO_w_lg_niili511w & wire_nl1iO_w_lg_niiiO509w & wire_nl1iO_w_lg_niiil507w & wire_nl1iO_w_lg_niiii505w & wire_nii0l_w_lg_nii0O503w & "1");
	niOiO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8,
		width_o => 8
	  )
	  PORT MAP ( 
		a => wire_niOiO_a,
		b => wire_niOiO_b,
		cin => wire_gnd,
		o => wire_niOiO_o
	  );
	wire_nl00l_a <= ( n00iO & n00li & n00ll & n00lO & n00Oi & n00Ol & n0i1i);
	wire_nl00l_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nl00l :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_nl00l_a,
		b => wire_nl00l_b,
		cin => wire_gnd,
		o => wire_nl00l_o
	  );
	wire_nl0li_a <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1" & "1" & "0" & "0" & "1");
	wire_nl0li_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1");
	wire_nl0li_w_o_range419w(0) <= wire_nl0li_o(6);
	nl0li :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nl0li_a,
		b => wire_nl0li_b,
		cin => wire_gnd,
		o => wire_nl0li_o
	  );
	wire_nl0lO_a <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1" & "0" & "0" & "1");
	wire_nl0lO_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1");
	wire_nl0lO_w_o_range248w(0) <= wire_nl0lO_o(10);
	wire_nl0lO_w_o_range257w(0) <= wire_nl0lO_o(13);
	wire_nl0lO_w_o_range239w(0) <= wire_nl0lO_o(7);
	wire_nl0lO_w_o_range266w(0) <= wire_nl0lO_o(16);
	nl0lO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nl0lO_a,
		b => wire_nl0lO_b,
		cin => wire_gnd,
		o => wire_nl0lO_o
	  );
	wire_nli01l_a(0) <= ( nli00O);
	wire_nli01l_b <= ( "1");
	nli01l :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 1,
		width_b => 1,
		width_o => 1
	  )
	  PORT MAP ( 
		a => wire_nli01l_a,
		b => wire_nli01l_b,
		cin => wire_gnd,
		o => wire_nli01l_o
	  );
	wire_nli0l_a <= ( n0i1l & n0i1O & n0i0i & n0i0l & n0i0O & n0iii & n0iil & "1");
	wire_nli0l_b <= ( wire_n01ll_w_lg_n010l114w & wire_n01ll_w_lg_n010O111w & wire_n01ll_w_lg_n01ii108w & wire_n01ll_w_lg_n01il106w & wire_nl0l1O26_w_lg_Q132w & wire_n01ll_w_lg_n01li102w & wire_n01ll_w_lg_n01lO100w & "1");
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
	wire_nli0O_a <= ( n0iiO & wire_nl0l0l20_w_lg_Q94w & n0ill & n0ilO & n0iOi & n0iOO & n0l1l & "1");
	wire_nli0O_b <= ( wire_n01ll_w_lg_n010l114w & wire_nl0l0i23_w_lg_Q112w & wire_n01ll_w_lg_n01ii108w & wire_n01ll_w_lg_n01il106w & wire_n01ll_w_lg_n01iO104w & wire_n01ll_w_lg_n01li102w & wire_n01ll_w_lg_n01lO100w & "1");
	nli0O :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 8,
		width_b => 8,
		width_o => 8
	  )
	  PORT MAP ( 
		a => wire_nli0O_a,
		b => wire_nli0O_b,
		cin => wire_gnd,
		o => wire_nli0O_o
	  );
	wire_nli1OO_a(0) <= ( nli01O);
	wire_nli1OO_b <= ( "1");
	nli1OO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 1,
		width_b => 1,
		width_o => 1
	  )
	  PORT MAP ( 
		a => wire_nli1OO_a,
		b => wire_nli1OO_b,
		cin => wire_gnd,
		o => wire_nli1OO_o
	  );
	wire_nlilO_a <= ( wire_nl0l0O17_w_lg_Q68w & n0ili & n0ill & n0ilO & wire_nl0lii14_w_lg_Q62w & wire_nl0lil11_w_lg_Q59w & n0l1l);
	wire_nlilO_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "1");
	nlilO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 7,
		width_b => 7,
		width_o => 7
	  )
	  PORT MAP ( 
		a => wire_nlilO_a,
		b => wire_nlilO_b,
		cin => wire_gnd,
		o => wire_nlilO_o
	  );
	wire_nll1iO_a <= ( nlllOi & nlllll & nlllli & nllliO & nlllil & nlllii & nlll0O & nlll0l & nlll0i & nlll1O & nlll1l & nlll1i & nlliOO & nlliOi & nlli1O & nll0iO & "1");
	wire_nll1iO_b <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1");
	nll1iO :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nll1iO_a,
		b => wire_nll1iO_b,
		cin => wire_gnd,
		o => wire_nll1iO_o
	  );
	wire_nll1li_a <= ( wire_nlliOl_o(16 DOWNTO 1) & "1");
	wire_nll1li_b <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "1");
	nll1li :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nll1li_a,
		b => wire_nll1li_b,
		cin => wire_gnd,
		o => wire_nll1li_o
	  );
	wire_nlliOl_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "0" & "0" & "0" & "1");
	wire_nlliOl_b <= ( "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "1" & "0" & "0" & "1");
	nlliOl :  oper_add
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 17,
		width_b => 17,
		width_o => 17
	  )
	  PORT MAP ( 
		a => wire_nlliOl_a,
		b => wire_nlliOl_b,
		cin => wire_gnd,
		o => wire_nlliOl_o
	  );
	wire_nli11l_i(0) <= ( nli00O);
	nli11l :  oper_decoder
	  GENERIC MAP (
		width_i => 1,
		width_o => 2
	  )
	  PORT MAP ( 
		i => wire_nli11l_i,
		o => wire_nli11l_o
	  );
	wire_nil0O_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "1" & "1" & "0" & "1");
	wire_nil0O_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & nii0i & nii1l & nii1i & ni0OO & ni0Ol & ni0Oi & ni0lO);
	nil0O :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16
	  )
	  PORT MAP ( 
		a => wire_nil0O_a,
		b => wire_nil0O_b,
		cin => wire_gnd,
		o => wire_nil0O_o
	  );
	wire_nil1O_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & nii0i & nii1l & nii1i & ni0OO & ni0Ol & ni0Oi & ni0lO);
	wire_nil1O_b <= ( wire_nil0i_o(15 DOWNTO 0));
	nil1O :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16
	  )
	  PORT MAP ( 
		a => wire_nil1O_a,
		b => wire_nil1O_b,
		cin => wire_gnd,
		o => wire_nil1O_o
	  );
	wire_nl0iO_a <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nli0i_dataout & wire_nl0iil56_w_lg_Q384w & wire_nli1l_dataout & wire_nl0iiO53_w_lg_Q380w & wire_nl0OO_dataout & wire_nl0Ol_dataout & wire_nl0ili50_w_lg_Q374w);
	wire_nl0iO_b <= ( wire_nl0li_o(16 DOWNTO 7) & wire_nl0iii59_w_lg_Q422w & wire_nl0li_o(5 DOWNTO 1));
	nl0iO :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16
	  )
	  PORT MAP ( 
		a => wire_nl0iO_a,
		b => wire_nl0iO_b,
		cin => wire_vcc,
		o => wire_nl0iO_o
	  );
	wire_nl0ll_a <= ( wire_nl0iOl38_w_lg_Q269w & wire_nl0lO_o(15 DOWNTO 14) & wire_nl0iOO35_w_lg_Q260w & wire_nl0lO_o(12 DOWNTO 11) & wire_nl0l1i32_w_lg_Q251w & wire_nl0lO_o(9 DOWNTO 8) & wire_nl0l1l29_w_lg_Q242w & wire_nl0lO_o(6 DOWNTO 1));
	wire_nl0ll_b <= ( "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & "0" & wire_nl0ill47_w_lg_Q283w & wire_nl0ilO44_w_lg_Q280w & wire_nl0iOi41_w_lg_Q277w & wire_nli1i_dataout & wire_nl0OO_dataout & wire_nl0Ol_dataout & wire_nl0Oi_dataout);
	nl0ll :  oper_less_than
	  GENERIC MAP (
		sgate_representation => 0,
		width_a => 16,
		width_b => 16
	  )
	  PORT MAP ( 
		a => wire_nl0ll_a,
		b => wire_nl0ll_b,
		cin => wire_gnd,
		o => wire_nl0ll_o
	  );
	wire_nlli1i_data <= ( wire_nlli0O_dataout & wire_nlli0i_dataout);
	wire_nlli1i_sel <= ( wire_nii1O_w_lg_nli0li1296w & nli0li);
	nlli1i :  oper_selector
	  GENERIC MAP (
		width_data => 2,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_nlli1i_data,
		o => wire_nlli1i_o,
		sel => wire_nlli1i_sel
	  );
	wire_nlli1l_data <= ( wire_nlliii_dataout & wire_nlli0l_dataout);
	wire_nlli1l_sel <= ( wire_nii1O_w_lg_nli0li1296w & nli0li);
	nlli1l :  oper_selector
	  GENERIC MAP (
		width_data => 2,
		width_sel => 2
	  )
	  PORT MAP ( 
		data => wire_nlli1l_data,
		o => wire_nlli1l_o,
		sel => wire_nlli1l_sel
	  );
	wire_nlO01i_w_lg_o1112w(0) <= NOT wire_nlO01i_o;
	wire_nlO01i_data <= ( wire_nlOi1i_dataout & "0" & "1" & wire_nlO0iO_dataout);
	wire_nlO01i_sel <= ( nlllOO & wire_nii1O_w_lg_nllO1i1148w & "0" & nllO1l);
	nlO01i :  oper_selector
	  GENERIC MAP (
		width_data => 4,
		width_sel => 4
	  )
	  PORT MAP ( 
		data => wire_nlO01i_data,
		o => wire_nlO01i_o,
		sel => wire_nlO01i_sel
	  );
	wire_nlO1lO_data <= ( wire_nlO0Ol_dataout & wire_nlO0lO_dataout & "0" & wire_nlO0ii_dataout & wire_nlO00i_dataout);
	wire_nlO1lO_sel <= ( nlllOO & nllO1i & "0" & nllO1l & nllO1O);
	nlO1lO :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlO1lO_data,
		o => wire_nlO1lO_o,
		sel => wire_nlO1lO_sel
	  );
	wire_nlO1Oi_data <= ( wire_nlO0OO_dataout & wire_nlO0Oi_dataout & "0" & wire_nlO0il_dataout & wire_nlO00l_dataout);
	wire_nlO1Oi_sel <= ( nlllOO & nllO1i & "0" & nllO1l & nllO1O);
	nlO1Oi :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlO1Oi_data,
		o => wire_nlO1Oi_o,
		sel => wire_nlO1Oi_sel
	  );
	wire_nlO1Ol_w_lg_o1114w(0) <= NOT wire_nlO1Ol_o;
	wire_nlO1Ol_data <= ( "0" & wire_ni00O_w_lg_ni0ii1142w & wire_nlO00O_dataout);
	wire_nlO1Ol_sel <= ( wire_n0lii_w_lg_nlllOO1093w & nllO1i & nllO1O);
	nlO1Ol :  oper_selector
	  GENERIC MAP (
		width_data => 3,
		width_sel => 3
	  )
	  PORT MAP ( 
		data => wire_nlO1Ol_data,
		o => wire_nlO1Ol_o,
		sel => wire_nlO1Ol_sel
	  );
	wire_nlOl1l_data <= ( wire_nlOlil_dataout & wire_nlOl0O_dataout & "1" & wire_nlOl0l_dataout & wire_nlOl0i_dataout);
	wire_nlOl1l_sel <= ( nlllOO & nllO1i & "0" & nllO1l & nllO1O);
	nlOl1l :  oper_selector
	  GENERIC MAP (
		width_data => 5,
		width_sel => 5
	  )
	  PORT MAP ( 
		data => wire_nlOl1l_data,
		o => wire_nlOl1l_o,
		sel => wire_nlOl1l_sel
	  );

 END RTL; --auk_pac_mtx_pl3_link
--synopsys translate_on
--VALID FILE
