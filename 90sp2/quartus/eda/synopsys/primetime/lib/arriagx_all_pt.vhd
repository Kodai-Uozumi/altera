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


--
-- arriagx_IO
--
library IEEE;
use IEEE.std_logic_1164.all;

entity  arriagx_io is
    port (
			datain                       : in std_logic;
			ddiodatain                       : in std_logic;
			oe                       : in std_logic;
			outclk                       : in std_logic;
			outclkena                       : in std_logic;
			inclk                       : in std_logic;
			inclkena                       : in std_logic;
			areset                       : in std_logic;
			sreset                       : in std_logic;
			ddioinclk       : in std_logic;
			delayctrlin     : in std_logic_vector(5 downto 0);
			offsetctrlin    : in std_logic_vector(5 downto 0);
			dqsupdateen     : in std_logic;
			linkin		     : in std_logic;
      	terminationcontrol : in std_logic_vector(13 downto 0);
			devclrn         : in std_logic;
			devpor          : in std_logic;
			devoe           : in std_logic;
			padio           : inout std_logic;
			combout         : out std_logic;
			regout          : out std_logic;
			ddioregout      : out std_logic;
			dqsbusout		  : out std_logic;
			dqscoreout		  : out std_logic;
			linkout			  : out std_logic;
			modesel                       : in std_logic_vector(35 DOWNTO 0) 
		);
end arriagx_io;

architecture structure of arriagx_io is
component arriagx_asynch_io 
	port(
         datain : in  STD_LOGIC;
         oe     : in  STD_LOGIC;
         regin  : in std_logic;
         ddioregin  : in std_logic;
         modesel : in std_logic_vector(35 downto 0);
         delayctrlin: in std_logic_vector(5 downto 0);
         offsetctrlin: in std_logic_vector(5 downto 0);
         dqsupdateen  : in std_logic;
         padio  : inout STD_LOGIC;
         combout: out STD_LOGIC;
         regout : out STD_LOGIC;
         dqsbusout : out STD_LOGIC;
         ddioregout : out STD_LOGIC);
end component;
component arriagx_io_register 
	port(
         clk : in  STD_LOGIC;
         ena : in  STD_LOGIC;
         datain : in  STD_LOGIC;
         areset  : in std_logic;
         sreset  : in std_logic;
         modesel : in std_logic_vector(3 downto 0);
         regout : out STD_LOGIC);
end component;
  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;
  component AND1
  port(
       IN1 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;
  component OR2
   port( IN1 : in STD_LOGIC;
      IN2 : in STD_LOGIC;
      Y   : out STD_LOGIC);
end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
component mux21
	port (
		A : in std_logic;
        B : in std_logic;
        S : in std_logic;
        MO : out std_logic);
end component;
	signal	tmp_datain, ddio_data, oe_out, outclk_delayed : std_logic; 
	
    signal pmuxout, poutmux2, poutmux3, ddio_output_or_bidir : std_logic;
    signal in_reg_modesel : std_logic_vector(3 downto 0);
    signal out_reg_modesel : std_logic_vector(3 downto 0);
    signal oe_reg_modesel : std_logic_vector(3 downto 0);
    signal out_clk_ena, oe_clk_ena, inclk_inv, outclk_inv : std_logic;
    signal pmux2out, oe_reg_out, oe_w_wo_pulse_and_reg_out, oe_pulse_reg_out : std_logic;
    signal in_reg_out, in_ddio0_reg_out, in_ddio1_reg_out, out_reg_out: std_logic;
    signal output_or_bidir, out_ddio_reg_out: std_logic;

    signal one,zero : std_logic;
	 signal ddio_input_reg, ddio_output_reg, ddio_input_clkena : std_logic;
	 signal ddio_input_sreset, ddio_input_padio, oe_clk_ena_a, oe_clk_ena_a2 : std_logic;
	 signal ddio1_data_input, ddio_output_clkena, ddio_output_sreset: std_logic;
begin    
one <= '1';
zero <= '0'; 


        
      --  assign out_clk_ena = (tie_off_output_clock_enable == "false") ? outclkena : one;
		or2_1: OR2  port map(Y =>  out_clk_ena, IN1 =>  modesel(25), IN2 =>  outclkena);

		--assign oe_clk_ena = (tie_off_oe_clock_enable == "false") ? outclkena : one;
		or2_2: OR2  port map(Y =>  oe_clk_ena, IN1 =>  modesel(26), IN2 =>  outclkena);

		inv_44: INV port map(Y =>  inclk_inv, IN1 =>  inclk);

		inv_45: INV port map(Y =>  outclk_inv, IN1 =>  outclk);

        --input register
		in_reg_modesel(0) <= modesel(20);
		in_reg_modesel(1) <= modesel(21);
		in_reg_modesel(2) <= modesel(22);
		in_reg_modesel(3) <= modesel(23);
		in_reg : arriagx_io_register  port map(regout =>  in_reg_out, clk =>  inclk, ena =>  inclkena,
                        datain =>  padio, areset =>  areset, sreset =>  sreset,modesel =>  in_reg_modesel
                        );
		-- ddio input reg = ddio_input or ddio_bidir
		inst_ddio_input_reg : OR2 port map  ( Y =>  ddio_input_reg, IN1 =>  modesel(3), IN2 =>  modesel(5) );
		
		-- ddio output reg = ddio_output or ddio_bidir
		inst_ddio_output_reg : OR2 port map  ( Y =>  ddio_output_reg, IN1 =>  modesel(4), IN2 =>  modesel(5) );


		inst_ddio_input_clkena : AND2  port map  ( Y =>  ddio_input_clkena, IN1 =>  inclkena, IN2 =>  ddio_input_reg);
		inst_ddio_input_sreset : AND2  port map  ( Y =>  ddio_input_sreset, IN1 =>  sreset, IN2 =>  ddio_input_reg);
		inst_ddio_input_padio : AND2  port map  ( Y =>  ddio_input_padio, IN1 =>  padio, IN2 =>  ddio_input_reg);


        -- in_ddio0_reg
		in_ddio0_reg: arriagx_io_register  port map(regout =>  in_ddio0_reg_out, clk =>  inclk_inv, modesel =>  in_reg_modesel, ena  =>  ddio_input_clkena,
                        datain =>  ddio_input_padio, areset =>  areset,sreset =>  ddio_input_sreset
                        );
        
		-- disable ddio0 to ddio1 reg path when not in ddio input mode
		inst_ddio_input_reg2reg : AND2  port map  ( Y =>  ddio1_data_input, IN1 =>  in_ddio0_reg_out, IN2 =>  ddio_input_reg);
		-- in_ddio1_reg
        in_ddio1_reg: arriagx_io_register  port map(regout =>  in_ddio1_reg_out, clk =>  inclk, ena =>  ddio_input_clkena, modesel =>  in_reg_modesel,
                        datain =>  ddio1_data_input, areset =>  areset,sreset =>  ddio_input_sreset
                        );
                  
        -- out_reg
        --output register
		out_reg_modesel(0) <= modesel(9);
		out_reg_modesel(1) <= modesel(10);
		out_reg_modesel(2) <= modesel(11);
		out_reg_modesel(3) <= modesel(12);
		out_reg: arriagx_io_register  port map(regout =>  out_reg_out, clk =>  outclk, ena =>  out_clk_ena, modesel =>  out_reg_modesel, 
                        datain =>  datain, areset =>  areset,sreset =>  sreset
                        );
        
        -- out ddio reg
		inst_ddio_output_clkena : AND2  port map  ( Y =>  ddio_output_clkena, IN1 =>  out_clk_ena, IN2 =>  ddio_output_reg);
		inst_ddio_output_sreset : AND2  port map  ( Y =>  ddio_output_sreset, IN1 =>  sreset, IN2 =>  ddio_output_reg);
		out_ddio_reg: arriagx_io_register  port map(regout =>  out_ddio_reg_out, clk =>  outclk, ena =>  ddio_output_clkena, modesel =>  out_reg_modesel, 
                        datain =>  ddiodatain, areset =>  areset,sreset =>  ddio_output_sreset
                        );
        
		-- oe reg
        --output register
		oe_reg_modesel(0) <= modesel(15);
		oe_reg_modesel(1) <= modesel(16);
		oe_reg_modesel(2) <= modesel(17);
		oe_reg_modesel(3) <= modesel(18);

		and2_11 : AND2    port map  ( Y =>  oe_clk_ena_a, IN1 =>  oe_clk_ena, IN2 =>  modesel(14));

        oe_reg: arriagx_io_register  port map(regout  =>  oe_reg_out, clk =>  outclk, ena =>  oe_clk_ena_a, modesel =>  oe_reg_modesel,
                        datain =>  oe, areset =>  areset,sreset =>  sreset
                        );
        
		-- oe_clk_ena_a2 = extend_oe_disable & oe_register_mode=register & ena
		and2_12  : AND2 port map ( Y =>  oe_clk_ena_a2, IN1 =>  oe_clk_ena_a, IN2 =>  modesel(27));
        -- oe_pulse reg
		oe_pulse_reg : arriagx_io_register  port map(regout =>  oe_pulse_reg_out, clk =>  outclk_inv, ena =>  oe_clk_ena_a2, modesel =>  oe_reg_modesel,
                        datain =>  oe_reg_out, areset =>  areset,sreset =>  sreset
                        );

        --assign oe_out = (oe_register_mode == "register") ? (extend_oe_disable == "true" ? oe_pulse_reg_out && oe_reg_out : oe_reg_out) : oe;

		oe_mux: mux21 port map(MO =>  oe_out, A =>  oe, B =>  pmux2out, S =>  modesel(14));
		oe_mux2: mux21 port map(MO =>  pmux2out, A =>  oe_reg_out, B =>  oe_w_wo_pulse_and_reg_out, S =>  modesel(27));
		and2_oe_p_r_out: AND2      port map( Y =>  oe_w_wo_pulse_and_reg_out, IN1 =>  oe_pulse_reg_out, IN2 =>  oe_reg_out);

        sel_delaybuf: AND1      port map(Y =>  outclk_delayed, IN1 =>  outclk);

        ddio_data_mux: mux21     port map(MO  =>  ddio_data,
                               A  =>  out_ddio_reg_out,
                               B  =>  out_reg_out,
                              S  =>  outclk_delayed
                              );
		

		--ddio output_or_bidir = (ddio_mode == "output") || (ddio_mode == "bidir");
		or2_11: OR2   port map( Y =>  ddio_output_or_bidir, IN1 =>  modesel(4), IN2 =>  modesel(5));
		--output_or_bidir = (output_mode == "output") || (output_mode == "bidir");
		or2_12: OR2   port map( Y =>  output_or_bidir, IN1 =>  modesel(1), IN2 =>  modesel(2));

		--assign tmp_datain = (ddio_mode == "output" || ddio_mode == "bidir") ? ddio_data : ((operation_mode == "output" || operation_mode == "bidir") ? ((output_register_mode == "register") ? out_reg_out : datain) : 'b0);
		out_mux1: mux21  port map(MO =>  tmp_datain, B =>  ddio_data, A =>  poutmux2, S =>  ddio_output_or_bidir);
		and2_22: AND2      port map( Y =>  poutmux2, IN1 =>  poutmux3, IN2 =>  output_or_bidir);
		out_mux3: mux21  port map(MO =>  poutmux3, B =>  out_reg_out, A =>  datain, S =>  modesel(8));
        -- timing info in case output and/or input are not registered.
        inst1: arriagx_asynch_io   port map(datain =>  tmp_datain,
                                      oe =>  oe_out,
                                      modesel =>  modesel,
                                      regin =>  in_reg_out,
                                      ddioregin =>  in_ddio1_reg_out,
                                      padio =>  padio,
                                      delayctrlin =>  delayctrlin,
                                      offsetctrlin =>  offsetctrlin,
                                      dqsupdateen =>  dqsupdateen,
                                      dqsbusout =>  dqsbusout,
                                      combout =>  combout,
                                      regout =>  regout,
                                      ddioregout =>  ddioregout);
end structure;



library IEEE;
use IEEE.std_logic_1164.all;

-- 4-to-1 mux: 
entity mux41 is
	port (
		I0 : in std_logic;
		I1 : in std_logic;
		I2 : in std_logic;
		I3: in std_logic;
		S0: in std_logic;
		S1: in std_logic;
		MO: out std_logic );
end mux41;

architecture structure of mux41 is

component mux21
	port (
		A : in std_logic;
        B : in std_logic;
        S : in std_logic;
        MO : out std_logic);
end component;

signal int_01, int_23 : std_logic;
begin
	inst1: mux21 port map  (MO =>  int_01, A =>  I0, B =>  I1, S =>  S0);
	inst2: mux21 port map  (MO =>  int_23, A =>  I2, B =>  I3, S =>  S0);
	inst3: mux21 port map  (MO => MO, A =>  int_01, B =>  int_23, S =>  S1);

end structure;

library IEEE;
use IEEE.std_logic_1164.all;

entity arriagx_clkctrl is 
	port (
		ena : in std_logic;
		inclk : in std_logic_vector(3 downto 0);
		clkselect : in std_logic_vector(1 downto 0);
		modesel : in std_logic_vector(3 downto 0);
		outclk: out std_logic );
end arriagx_clkctrl;

architecture structure of arriagx_clkctrl is
  component dffe
   port(
      Q                              :  out   std_logic;
      D                              :  in    std_logic;
      CLRN                           :  in    std_logic;
      PRN                            :  in    std_logic;
      CLK                            :  in    std_logic;
      ENA                            :  in    std_logic);
end component;
	component mux41
	port (
			I0 : in std_logic;
			I1 : in std_logic;
			I2 : in std_logic;
			I3 : in std_logic;
			S0 : in std_logic;
			S1 : in std_logic;
			MO : out std_logic);
	end component;

	component bb2
	port (
			in1 : in std_logic;
			in2 : in std_logic;
			y : out std_logic);
	end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
	end component;

  component OR2
   port(
      IN2   : in STD_LOGIC;
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
	end component;

  component AND2
   port(
      IN2   : in STD_LOGIC;
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
	end component;

	signal    clkmux_out, clkmux_out_inv, cereg_out : std_logic;
	signal vcc : std_logic;
	signal ena_is_gnd, ena_is_used, ena_is_not_used, ce_out : std_logic;
	signal ena_is_not_gnd, clk_out : std_logic;
begin
	vcc <= '1';

	-- modelsel(0) : ena is gnd
	-- modelsel(1) : ena is used(i.e not vcc, and not connected)

	ena_is_gnd <=  modesel(0);
	ena_is_used <= modesel(1);


	mux_inst: mux41 port map  ( MO =>  clkmux_out, I0 =>  inclk(0), I1 => inclk(1), I2 =>  inclk(2), I3 =>  inclk(3) , S0 =>  clkselect(0), S1 =>  clkselect(1) );

	inv_1: INV port map  (Y =>  clkmux_out_inv, IN1 =>  clkmux_out);

	extena0_reg : dffe port map 	(Q =>  cereg_out, CLK =>  clkmux_out_inv, ENA =>  vcc, D =>  ena, CLRN =>  vcc, PRN =>  vcc);

	inv_2: INV port map  (Y =>  ena_is_not_used, IN1 =>  ena_is_used );
	or2_inst: OR2   port map  (Y =>  ce_out, IN1 =>  ena_is_not_used, IN2 =>  cereg_out);

	inv_3: INV port map  (Y =>  ena_is_not_gnd, IN1 =>  ena_is_gnd );
	and2_inst: AND2    port map  (Y =>  clk_out, IN1 =>  ena_is_not_gnd, IN2 =>  clkmux_out);
	bb_1: bb2 port map  (y =>  outclk, in1 =>  ce_out, in2 =>  clk_out );		
        
end structure;


library IEEE;
use IEEE.std_logic_1164.all;

-- special 4-to-1 mux: 
-- output of 4-1 mux is gated with ACTIVE LOW PASSN input
-- i.e if pass = 0, output = one of clocks
--     if pass = 1, output = 0
entity  mux41_spc is
    port (
			INP                       : in std_logic_vector(3 downto 0);
			S0                       : in std_logic;
			S1                       : in std_logic;
			PASSN                       : in std_logic;
			MO                       : out std_logic);
end mux41_spc;

architecture structure of mux41_spc is
component mux21
	port (
		A : in std_logic;
        B : in std_logic;
        S : in std_logic;
        MO : out std_logic);
end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;
signal int_01, int_23, int_0123, PASSN_INV : std_logic;

begin    

	inst1: mux21  port map(MO =>  int_01, A =>  INP(0), B =>  INP(1), S =>  S0);
	inst2: mux21  port map(MO =>  int_23, A =>  INP(2), B =>  INP(3), S =>  S0);
	inst3: mux21  port map(MO =>  int_0123, A =>  int_01, B =>  int_23, S =>  S1);
	inst4: INV  port map(Y =>  PASSN_INV, IN1 =>  PASSN);
	inst5: AND2  port map(Y =>  MO, IN1 =>  int_0123, IN2 =>  PASSN_INV);

end structure;



library IEEE;
use IEEE.std_logic_1164.all;

-- special 2-to-1 mux: 
-- output of 2-1 mux is gated with PASS input
-- output = 0 if pass = 0
-- output = one of inputs if pass = 1
entity  mux21_spc is
    port (
			IN0                       : in std_logic;
			IN1                       : in std_logic;
			S                       : in std_logic;
			PASS                       : in std_logic;
			MO                       : out std_logic);
end mux21_spc;

architecture structure of mux21_spc is
component mux21
	port (
		A : in std_logic := '0';
        B : in std_logic := '0';
        S : in std_logic := '0';
        MO : out std_logic);
end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;
signal int_01 : std_logic;
begin    

	inst1: mux21  port map(MO =>  int_01, A =>  IN0, B =>  IN1, S =>  S);
	inst3: AND2  port map(Y =>  MO, IN1 =>  int_01, IN2 =>  PASS);

end structure;



--
-- arriagx_RAM_BLOCK
--
library ieee;
use ieee.std_logic_1164.all;


entity arriagx_ram_block is
	port (
		portadatain : in std_logic_vector(143 downto 0);
		portaaddr : in std_logic_vector(15 downto 0);
		portawe  : in std_logic;
		modesel : in std_logic_vector(44 downto 0);
		portbdatain : in std_logic_vector(71 downto 0);
		portbaddr : in std_logic_vector(15 downto 0);
		portbrewe  : in std_logic;
		clk0  : in std_logic;
		clk1  : in std_logic;
	   ena0  : in std_logic;
		ena1  : in std_logic;
	   clr0  : in std_logic;
		clr1  : in std_logic;
	   portabyteenamasks : in std_logic_vector(15 downto 0);
	   portbbyteenamasks : in std_logic_vector(15 downto 0);
	   portaaddrstall : in std_logic;
		portbaddrstall : in std_logic;
	   clr0extension : in std_logic;
		clr1extension : in std_logic;
	   portadataout : out std_logic_vector(143 downto 0);
	   portbdataout : out std_logic_vector(143 downto 0));
end arriagx_ram_block;
 
architecture structure of arriagx_ram_block is

component mux21
          port (
                A : in std_logic;
                B : in std_logic;
                S : in std_logic;
                MO : out std_logic);
end component;

component mux21_spc
          port (
                IN0 : in std_logic;
                IN1 : in std_logic;
                S : in std_logic;
                PASS : in std_logic;
                MO : out std_logic);
end component;
component arriagx_ram_internal
    port (
		portadatain		: in std_logic_vector(143 downto 0);
		portaaddress		: in std_logic_vector(15 downto 0);
		portawriteenable		: in std_logic;
		modesel		: in std_logic_vector(44 downto 0);
		portbdatain		: in std_logic_vector(71 downto 0);
		portabyteenamasks		: in std_logic_vector(15 downto 0);
		portbbyteenamasks		: in std_logic_vector(15 downto 0);
		portbaddress		: in std_logic_vector(15 downto 0);
		portbrewe		: in std_logic;
		portadataout		: out std_logic_vector(143 downto 0);
		portbdataout		: out std_logic_vector(143 downto 0));
end component;

component arriagx_memory_register
    port (
		data		: in std_logic_vector(143 downto 0);
		clk, aclr, ena, async		: in std_logic;
		dataout		: out std_logic_vector(143 downto 0));
end component;

component arriagx_memory_addr_register
    port (
		address		: in std_logic_vector(15 downto 0);
		clk, ena, addrstall		: in std_logic;
		dataout		: out std_logic_vector(15 downto 0));
end component;

  component OR2
   port( IN1 : in STD_LOGIC;
      IN2 : in STD_LOGIC;
      Y   : out STD_LOGIC);
end component;
  component AND2
   port( IN1 : in STD_LOGIC;
      IN2 : in STD_LOGIC;
      Y   : out STD_LOGIC);
end component;
  component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
component dffe

   port(
      Q                              :  out   STD_LOGIC;
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
end component;


	signal porta_clk, porta_ena : std_logic; 
	signal porta_dataout : std_logic_vector(143 downto 0);
	signal porta_falling_edge_feedthru : std_logic_vector(143 downto 0); 
	signal portb_datain_clk, portb_addr_clk, portb_clk : std_logic; 
	signal portb_datain_ena, portb_addr_ena, portb_ena, portb_ena_in : std_logic; 
	signal portb_dataout : std_logic_vector(143 downto 0);
	signal portb_falling_edge_feedthru : std_logic_vector(143 downto 0);
	signal portb_byte_enable_clk : std_logic;
	signal select_porta_out_clk01, porta_out_clk_exists, porta_out_clk_none : std_logic;
	signal select_porta_out_clr01, porta_out_clr_exists : std_logic;
	signal select_portb_out_clk01, portb_out_clk_exists, portb_out_clk_none : std_logic;
	signal select_portb_out_clr01, portb_out_clr_exists : std_logic;

	signal select_portb_byte_enable_clr01 : std_logic;
	signal select_portb_rewe_clk01 : std_logic;

	signal porta_datain_reg : std_logic_vector(143 downto 0);
	signal  porta_addr_reg : std_logic_vector(15 downto 0);
	signal porta_we_reg : std_logic;
	signal portabyteenamasks_in, porta_byteenamasks_reg_out : std_logic_vector(143 downto 0);
   signal  porta_byteenamasks_reg : std_logic_vector(15 downto 0);
	signal portb_datain_reg : std_logic_vector(71 downto 0);
	signal  portb_addr_reg : std_logic_vector(15 downto 0);
	signal portb_rewe_reg : std_logic;
	signal portbbyteenamasks_in, portb_byteenamasks_reg_out : std_logic_vector(143 downto 0);
   signal  portb_byteenamasks_reg : std_logic_vector(15 downto 0);

	signal outa_ena, outa_ena_in, outb_ena, outb_ena_in : std_logic;
	signal disable_porta_ce_input_reg : std_logic;
	signal disable_porta_ce_output_reg : std_logic;
	signal disable_portb_ce_input_reg : std_logic;
	signal disable_portb_ce_output_reg : std_logic;
	signal porta_we_ce_used  : std_logic;
	signal porta_datain_ce_used  : std_logic;
	signal porta_addr_ce_used  : std_logic;
	signal porta_byte_enable_ce_used  : std_logic;
	signal porta_dataout_ce_used  : std_logic;
	signal portb_we_ce_used  : std_logic;
	signal portb_datain_ce_used  : std_logic;
	signal portb_addr_ce_used  : std_logic;
	signal portb_byte_enable_ce_used  : std_logic;
	signal portb_dataout_ce_used  : std_logic;
	signal vcc, gnd: std_logic;
	signal gnd_vec: std_logic_vector(143 downto 0);

	signal clr0_e, clr1_e, porta_datain_ena, porta_addr_ena, porta_we_ce_used_inv : std_logic;
	signal porta_we_ena, portb_we_ena, portb_we_ce_used_inv, portb_byte_enable_ena : std_logic;
	signal outb_clr, outa_clk, outa_clr, outa_dataout_ena, outb_dataout_ena : std_logic;
	signal porta_byte_enable_ena, outb_clk : std_logic;
	signal tmp_portbdatain, tmp_portb_datain_reg : std_logic_vector(143 downto 0);

begin

	vcc <= '1';
	gnd <= '0';
	gnd_vec <= (others => '0');	

	-- porta clk is fixed
	porta_clk <= clk0;

	-- clr0/1 and clr0/1extension ports are equivalent
	inst_aclr0: OR2   port map (Y =>  clr0_e, IN1 =>  clr0, IN2 =>  clr0extension);
	inst_aclr1: OR2   port map (Y =>  clr1_e, IN1 =>  clr1, IN2 =>  clr1extension);

	-- this clock select also selects all other register clocks
	--  since same clock has to be used on all registers on port b
	select_portb_rewe_clk01 <= modesel(21);

	disable_porta_ce_input_reg <= modesel(31); 
	disable_porta_ce_output_reg <= modesel(32); 
	disable_portb_ce_input_reg <= modesel(33); 
	disable_portb_ce_output_reg <= modesel(34); 

	porta_we_ce_used <= modesel(35); 
	porta_datain_ce_used <= modesel(36); 
	porta_addr_ce_used <= modesel(37); 
	porta_byte_enable_ce_used <= modesel(38); 
	porta_dataout_ce_used <= modesel(39); 
	portb_we_ce_used <= modesel(40); 
	portb_datain_ce_used <= modesel(41); 
	portb_addr_ce_used <= modesel(42); 
	portb_byte_enable_ce_used <= modesel(43); 
	portb_dataout_ce_used <= modesel(44); 

	-- porta has no ena0/ena1 selection(its always ena0). However
 	-- this ena can be optionally disabled
	select_porta_input_ena: mux21 port map ( MO =>  porta_ena, A =>  ena0, B =>  gnd, 
	                     S =>  disable_porta_ce_input_reg );
	
	-- PORT B READ/WRITE ENABLE REGISTER selection
	-- Note: CLK & ENA selections here apply to all registers, since
	-- all of them can have same clock and enable.
			  select_portb_rewe_clk: mux21_spc port map ( MO =>  portb_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_portb_rewe_clk01, 
	                     PASS =>  vcc);
	-- ena selection follows clk selection.
	select_portb_rewe_ena: mux21_spc port map ( MO =>  portb_ena_in, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_portb_rewe_clk01, 
	                     PASS =>  vcc);

	-- ena selected from above can be optionally disabled
	select_portb_input_ena: mux21 port map ( MO =>  portb_ena, A =>  portb_ena_in, B =>  gnd, 
	                     S =>  disable_portb_ce_input_reg );
	


	porta_datain_ena_inst : AND2    port map (Y =>  porta_datain_ena, IN1 =>  porta_ena, IN2 =>  porta_datain_ce_used);
ram_portadatain_reg: arriagx_memory_register 	
		port map (data =>  portadatain,
		 clk =>  porta_clk, 
		 aclr =>  gnd, 
		 ena =>  porta_datain_ena, 
		 async =>  gnd, 
		 dataout =>  porta_datain_reg 
		);

	porta_addr_ena_inst : AND2    port map (Y =>  porta_addr_ena, IN1 =>  porta_ena, IN2 =>  porta_addr_ce_used);
ram_portaaddr_reg: arriagx_memory_addr_register 	
		port map (address =>  portaaddr,
		 clk =>  porta_clk, 
		 ena =>  porta_addr_ena, 
		 addrstall =>  portaaddrstall, 
		 dataout =>  porta_addr_reg 
		);

	porta_we_ena_used_inv: INV   port map (Y =>  porta_we_ce_used_inv, IN1 =>  porta_we_ce_used);
	porta_we_ena_inst : OR2    port map (Y =>  porta_we_ena, IN1 =>  porta_ena, IN2 =>  porta_we_ce_used_inv);
	ram_portawe_reg : dffe	port map (Q =>  porta_we_reg, CLK =>  porta_clk, ENA =>  porta_we_ena, D =>  portawe, CLRN =>  vcc, PRN =>  vcc);

	portabyteenamasks_in(15 downto 0) <= portabyteenamasks;
	portabyteenamasks_in(143 downto 16) <= gnd_vec(143 downto 16);
	porta_byte_enable_ena_inst : AND2    port map (Y =>  porta_byte_enable_ena, IN1 =>  porta_ena, IN2 =>  porta_byte_enable_ce_used);
ram_portabyteenamasks_reg: arriagx_memory_register 	
		port map (data =>  portabyteenamasks_in,
		 clk =>  porta_clk, 
		 aclr =>  gnd, 
		 ena =>  porta_byte_enable_ena, 
		 async =>  gnd, 
		 dataout =>  porta_byteenamasks_reg_out 
		);
	porta_byteenamasks_reg <= porta_byteenamasks_reg_out(15 downto 0);

	portb_datain_ena_inst : AND2    port map (Y =>  portb_datain_ena, IN1 =>  portb_ena, IN2 =>  portb_datain_ce_used);
	tmp_portbdatain(71 downto 0) <= portbdatain;
ram_portbdatain_reg: arriagx_memory_register 	
		port map (data =>  tmp_portbdatain,
		 clk =>  portb_clk, 
		 aclr =>  gnd, 
		 ena =>  portb_datain_ena, 
		 async =>  gnd, 
		 dataout =>  tmp_portb_datain_reg 
		);

	portb_datain_reg <= tmp_portb_datain_reg(71 downto 0);

	portb_addr_ena_inst : AND2    port map (Y =>  portb_addr_ena, IN1 =>  portb_ena, IN2 =>  portb_addr_ce_used);
ram_portbaddr_reg: arriagx_memory_addr_register 	
		port map (address =>  portbaddr,
		 clk =>  portb_clk, 
		 ena =>  portb_addr_ena, 
		 addrstall =>  portbaddrstall, 
		 dataout =>  portb_addr_reg 
		);

	portb_we_ena_used_inv: INV   port map (Y =>  portb_we_ce_used_inv, IN1 =>  portb_we_ce_used);
	portb_we_ena_inst : OR2    port map (Y =>  portb_we_ena, IN1 =>  portb_ena, IN2 =>  portb_we_ce_used_inv);
	ram_portbrewe_reg : dffe	port map (Q =>  portb_rewe_reg, CLK =>  portb_clk, ENA =>  portb_we_ena, D =>  portbrewe, CLRN =>  vcc, PRN =>  vcc);

	portbbyteenamasks_in(15 downto 0) <= portbbyteenamasks;
	portbbyteenamasks_in(143 downto 16) <= gnd_vec(143 downto 16);
	portb_byte_enable_ena_inst : AND2    port map (Y =>  portb_byte_enable_ena, IN1 =>  portb_ena, IN2 =>  portb_byte_enable_ce_used);
ram_portbbyteenamasks_reg: arriagx_memory_register 	
		port map (data =>  portbbyteenamasks_in,
		 clk =>  portb_clk, 
		 aclr =>  gnd, 
		 ena =>  portb_byte_enable_ena, 
		 async =>  gnd, 
		 dataout =>  portb_byteenamasks_reg_out 
		);
	portb_byteenamasks_reg <= portb_byteenamasks_reg_out(15 downto 0);

	-- internal asynchronous memory: doesn't include input and output registers
  internal_ram: arriagx_ram_internal  
      port map (portadatain =>  porta_datain_reg, 
       portaaddress =>  porta_addr_reg, 
       portawriteenable =>  porta_we_reg, 
       portabyteenamasks =>  porta_byteenamasks_reg,
       modesel =>  modesel,
       portbdatain =>  portb_datain_reg, 
       portbaddress =>  portb_addr_reg, 
       portbrewe =>  portb_rewe_reg, 
       portbbyteenamasks =>  portb_byteenamasks_reg,
       portadataout =>  porta_dataout,
      portbdataout =>  portb_dataout);


	select_porta_out_clk01 <= modesel(12); 
	-- { this is modesel for porta outclock = clk1 }
	select_porta_out_clr01 <= modesel(14); 
	-- { this is modesel for porta outclr = clr1 }

	-- porta_out_clk_exists = porta outclock= clk0 or clk1
	modesel_or_1: OR2   port map (Y =>  porta_out_clk_exists, IN1 =>  modesel(11), IN2 =>  modesel(12));
	modesel_or_1_inv: INV   port map (Y =>  porta_out_clk_none, IN1 =>  porta_out_clk_exists);
	
	-- porta_out_clr_exists = porta outclr= clr0 or clr1
	modesel_or_2: OR2   port map (Y =>  porta_out_clr_exists, IN1 =>  modesel(13), IN2 =>  modesel(14));



	select_portb_out_clk01 <= modesel(28); 
	-- { this is modesel for portb outclock = clk1 }
	select_portb_out_clr01 <= modesel(30); 
	-- { this is modesel for portb outclr = clr1 }

	-- portb_out_clk_exists = portb outclock= clk0 or clk1
	modesel_or_3: OR2   port map (Y =>  portb_out_clk_exists, IN1 =>  modesel(27), IN2 =>  modesel(28));
	modesel_or_3_inv: INV port map (Y =>  portb_out_clk_none, IN1 =>  portb_out_clk_exists);
	
	-- portb_out_clr_exists = portb outclr= clr0 or clr1
	modesel_or_4: OR2   port map (Y =>  portb_out_clr_exists, IN1 =>  modesel(29), IN2 =>  modesel(30));


	-- PORT A OUTPUT REGISTER selection


	select_porta_out_clk: mux21_spc port map ( MO =>  outa_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_porta_out_clk01, 
	                     PASS =>  porta_out_clk_exists);
	-- ena selection follows clk selection
	select_porta_out_ena: mux21_spc port map ( MO =>  outa_ena_in, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_porta_out_clk01, 
	                     PASS =>  porta_out_clk_exists);
	-- ena selected from above can be optionally disabled
	select_porta_output_ena: mux21 port map ( MO =>  outa_ena, A =>  outa_ena_in, B =>  gnd, 
	                     S =>  disable_porta_ce_output_reg );
	
	select_porta_out_clr: mux21_spc port map ( MO =>  outa_clr, IN0 =>  clr0_e, IN1 =>  clr1_e, 
	                     S =>  select_porta_out_clr01, 
	                     PASS =>  porta_out_clr_exists);


	-- PORT B OUTPUT REGISTER selection
	select_portb_out_clk: mux21_spc port map ( MO =>  outb_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_portb_out_clk01, 
	                     PASS =>  portb_out_clk_exists);
	-- ena selection follows clk selection
	select_portb_out_ena: mux21_spc port map ( MO =>  outb_ena_in, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_portb_out_clk01, 
	                     PASS =>  portb_out_clk_exists);
	-- ena selected from above can be optionally disabled
	select_portb_output_ena: mux21 port map ( MO =>  outb_ena, A =>  outb_ena_in, B =>  gnd, 
	                     S =>  disable_portb_ce_output_reg );
	
	select_portb_out_clr: mux21_spc port map ( MO =>  outb_clr, IN0 =>  clr0_e, IN1 =>  clr1_e, 
	                     S =>  select_portb_out_clr01, 
	                     PASS =>  portb_out_clr_exists);


	porta_dataout_ena_inst : AND2    port map (Y =>  outa_dataout_ena, IN1 =>  outa_ena, IN2 =>  porta_dataout_ce_used);

porta_ram_output_reg: arriagx_memory_register 	
		port map (data =>  porta_dataout,
		 clk =>  outa_clk, 
		 aclr =>  outa_clr, 
		 ena =>  outa_dataout_ena, 
		 async =>  porta_out_clk_none, 
		 dataout =>  portadataout 
		);

	portb_dataout_ena_inst : AND2    port map (Y =>  outb_dataout_ena, IN1 =>  outb_ena, IN2 =>  portb_dataout_ce_used);
portb_ram_output_reg: arriagx_memory_register 	
		port map (data =>  portb_dataout,
		 clk =>  outb_clk, 
		 aclr =>  outb_clr, 
		 ena =>  outb_dataout_ena, 
		 async =>  portb_out_clk_none, 
		 dataout =>  portbdataout 
		);


end structure; -- arriagx_ram_bloctk

library IEEE;
use IEEE.std_logic_1164.all;

entity arriagx_mac_mult	is
	port (
   dataa: in std_logic_vector(17 downto 0);
   datab: in std_logic_vector(17 downto 0);
   scanina: in std_logic_vector(17 downto 0);
   scaninb: in std_logic_vector(17 downto 0);
	sourcea, sourceb: in std_logic;
   signa: in std_logic;
   signb: in std_logic;
   round: in std_logic;
   saturate: in std_logic;
   clk: in std_logic_vector(3 downto 0);
   aclr: in std_logic_vector(3 downto 0);
   ena: in std_logic_vector(3 downto 0);
   mode: in std_logic;
   zeroacc: in std_logic;
   modesel: in std_logic_vector(41 downto 0);
   dataout: out std_logic_vector(35 downto 0);
   scanouta: out std_logic_vector(17 downto 0);
   scanoutb: out std_logic_vector(17 downto 0) );
end arriagx_mac_mult;

architecture structure of arriagx_mac_mult is
	component mux41_spc
	port (
			INP                       : in std_logic_vector(3 downto 0);
			S0                       : in std_logic;
			S1                       : in std_logic;
			PASSN                       : in std_logic;
			MO                       : out std_logic);
	end component;

	component bmux21_18
	port (
			A                       : in std_logic_vector(17 downto 0);
			B                       : in std_logic_vector(17 downto 0);
			S                       : in std_logic;
			MO                       : out std_logic_vector(17 downto 0));
	end component;

  component arriagx_mac_register
   port(
      data   : in std_logic_vector(71 downto 0);
      clk, aclr, ena, async   : in std_logic;
      dataout    : out std_logic_vector(71 downto 0));
	end component;
  component arriagx_mac_mult_internal
   port(
      dataa   : in std_logic_vector(17 downto 0);
      datab   : in std_logic_vector(17 downto 0);
      signa, signb, round, saturate   : in std_logic;
      dataout    : out std_logic_vector(35 downto 0));
	end component;

  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
	end component;

  component b72AND1
  port(
       IN1 : in std_logic_vector(71 downto 0);
       Y   : out std_logic_vector(71 downto 0));
	end component;

   signal mult_output: std_logic_vector(35 downto 0);
   signal signa_out: std_logic; 
   signal signb_out: std_logic;
   signal saturate_out: std_logic;
   signal round_out: std_logic;
   
   signal dataa_out: std_logic_vector(17 downto 0);
   signal datab_out: std_logic_vector(17 downto 0);
  	signal dataa_reg_feedthru: std_logic; 
  	signal datab_reg_feedthru: std_logic; 
  	signal signa_reg_feedthru: std_logic; 
  	signal signb_reg_feedthru: std_logic; 
  	signal dataout_reg_feedthru: std_logic; 
	signal dataa_clk_none: std_logic;

	signal dataa_mux_out: std_logic_vector(17 downto 0);
	signal datab_mux_out: std_logic_vector(17 downto 0);
	signal dataa_int, dataa_out_int : std_logic_vector(71 downto 0);
	signal datab_int, datab_out_int : std_logic_vector(71 downto 0);
	signal signa_int, signa_out_int : std_logic_vector(71 downto 0);
	signal signb_int, signb_out_int : std_logic_vector(71 downto 0);
	signal saturate_int, saturate_out_int : std_logic_vector(71 downto 0);
	signal round_int, round_out_int : std_logic_vector(71 downto 0);
	signal mult_output_int, dataout_int : std_logic_vector(71 downto 0);
	signal scanouta_int, dataa_out_int2 : std_logic_vector(71 downto 0);
	signal scanoutb_int, datab_out_int2 : std_logic_vector(71 downto 0);
	signal clka, aclra, enaa, clkb, aclrb, enab, clksa, aclrsa, enasa : std_logic;
	signal clksb, enasb, aclrsb, clksat, aclrsat, enasat : std_logic;
	signal clkrnd, enarnd, aclrrnd : std_logic;
	signal clkout, aclrout, enaout : std_logic;
	signal gnd_vec: std_logic_vector(143 downto 0);

	begin


	gnd_vec <= (others => '0');	

	-- mux41_spc:
	-- S0,.S1 => encode clk selection: one of clk0, clk1, clk2, clk3
	-- PASSN => output is one of above clocks if PASS=0, output is 1 otherwise

	dataa_clk_inst1: mux41_spc	port map(MO =>  clka, INP =>  clk, S0 =>  modesel(1),S1 =>  modesel(2), PASSN =>  modesel(0));
	dataa_aclr_inst1: mux41_spc	port map(MO =>  aclra, INP =>  aclr, S0 =>  modesel(16),S1 =>  modesel(17), PASSN =>  modesel(15));
	dataa_ena_inst1: mux41_spc	port map(MO =>  enaa, INP =>  ena, S0 =>  modesel(1),S1 =>  modesel(2), PASSN =>  modesel(0));
   

	-- ASSUMPTION: Delays from outside and through this mux are taken care of in input ports
	dataa_mux: bmux21_18 port map( MO =>  dataa_mux_out, A =>  dataa, B =>  scanina, S =>  sourcea );
	dataa_int(17 downto 0) <= dataa_mux_out; 
	dataa_int(71 downto 18) <= gnd_vec(71 downto 18);
   dataa_mac_reg : arriagx_mac_register	port map(
	data  =>  dataa_int,
	clk  =>  clka,
	aclr  =>  aclra,
	ena  =>  enaa,
	dataout  =>  dataa_out_int,
	async  =>   modesel(0) -- represents !PASS modesel 
	);
	dataa_out <= dataa_out_int(17 downto 0);

	datab_clk_inst1: mux41_spc	port map(MO =>  clkb, INP =>  clk, S0 =>  modesel(4),S1 =>  modesel(5), PASSN =>  modesel(3));
	datab_clr_inst1: mux41_spc	port map(MO =>  aclrb, INP =>  aclr, S0 =>  modesel(19),S1 =>  modesel(20), PASSN =>  modesel(18));
	datab_ena_inst1: mux41_spc	port map(MO =>  enab, INP =>  ena, S0 =>  modesel(4),S1 =>  modesel(5), PASSN =>  modesel(3));
   
	-- ASSUMPTION: Delays from outside and through this mux are taken care of in input ports
	datab_mux: bmux21_18 port map( MO =>  datab_mux_out, A =>  datab, B =>  scaninb, S =>  sourceb );
	datab_int(17 downto 0) <= datab_mux_out; 
	datab_int(71 downto 18) <= gnd_vec(71 downto 18);
   datab_mac_reg : arriagx_mac_register	port map(
	data  =>  datab_int,
	clk  =>  clkb,
	aclr  =>  aclrb,
	ena  =>  enab,
	dataout  =>  datab_out_int,
	async  =>   modesel(3) 
	);
	datab_out <= datab_out_int(17 downto 0);

	signa_clk_inst1: mux41_spc	port map(MO =>  clksa, INP =>  clk, S0 =>  modesel(7),S1 =>  modesel(8), PASSN =>  modesel(6));
	signa_clr_inst1: mux41_spc	port map(MO =>  aclrsa, INP =>  aclr, S0 =>  modesel(22),S1 =>  modesel(23), PASSN =>  modesel(21));
	signa_ena_inst1: mux41_spc	port map(MO =>  enasa, INP =>  ena, S0 =>  modesel(7),S1 =>  modesel(8), PASSN =>  modesel(6));
  
	signa_int(0) <= signa; 
	signa_int(71 downto 1) <= gnd_vec(71 downto 1);
   signa_mac_reg : arriagx_mac_register	port map(
	data  =>  signa_int,
	clk  =>  clksa,
	aclr  =>  aclrsa,
	ena  =>  enasa,
	dataout  =>  signa_out_int,
	async  =>  modesel(6)
	);
	signa_out <= signa_out_int(0); 

	signb_clk_inst1: mux41_spc	port map(MO =>  clksb, INP =>  clk, S0 =>  modesel(10),S1 =>  modesel(11), PASSN =>  modesel(9));
	signb_clr_inst1: mux41_spc	port map(MO =>  aclrsb, INP =>  aclr, S0 =>  modesel(25),S1 =>  modesel(26), PASSN =>  modesel(24));
	signb_ena_inst1: mux41_spc	port map(MO =>  enasb, INP =>  ena, S0 =>  modesel(10),S1 =>  modesel(11), PASSN =>  modesel(9));
   
	signb_int(0) <= signb; 
	signb_int(71 downto 1) <= gnd_vec(71 downto 1);
   signb_mac_reg : arriagx_mac_register	port map(
	data  =>  signb_int,
	clk  =>  clksb,
	aclr  =>  aclrsb,
	ena  =>  enasb,
	dataout  =>  signb_out_int,
	async  =>   modesel(9)
	);
	signb_out <= signb_out_int(0); 

	saturate_clk_inst1: mux41_spc	port map(MO =>  clksat, INP =>  clk, S0 =>  modesel(31),S1 =>  modesel(32), PASSN =>  modesel(30));
	saturate_clr_inst1: mux41_spc	port map(MO =>  aclrsat, INP =>  aclr, S0 =>  modesel(34),S1 =>  modesel(35), PASSN =>  modesel(33));
	saturate_ena_inst1: mux41_spc	port map(MO =>  enasat, INP =>  ena, S0 =>  modesel(31),S1 =>  modesel(32), PASSN =>  modesel(30));

	saturate_int(0) <= saturate; 
	saturate_int(71 downto 1) <= gnd_vec(71 downto 1);
   saturate_mac_reg : arriagx_mac_register	port map(
	data  =>  saturate_int,
	clk  =>  clksat,
	aclr  =>  aclrsat,
	ena  =>  enasat,
	dataout  =>  saturate_out_int,
	async  =>   modesel(30)
	);
	saturate_out <= saturate_out_int(0); 

	round_clk_inst1: mux41_spc	port map(MO =>  clkrnd, INP =>  clk, S0 =>  modesel(34),S1 =>  modesel(35), PASSN =>  modesel(33));
	round_clr_inst1 : mux41_spc port map (MO =>  aclrrnd, INP =>  aclr, S0 =>  modesel(37),S1 =>  modesel(38), PASSN =>  modesel(36));
	round_ena_inst1: mux41_spc	 port map (MO =>  enarnd, INP =>  ena, S0 =>  modesel(34),S1 =>  modesel(35), PASSN =>  modesel(33));

	round_int(0) <= round; 
	round_int(71 downto 1) <= gnd_vec(71 downto 1);
   round_mac_reg : arriagx_mac_register	 port map (
	data  =>  round_int,
	clk  =>  clkrnd,
	aclr  =>  aclrrnd,
	ena  =>  enarnd,
	dataout  =>  round_out_int,
	async  =>   modesel(33)
	);
	round_out <= round_out_int(0); 

   mac_multiply : arriagx_mac_mult_internal  port map (
	dataa  =>  dataa_out,
	datab  =>  datab_out,
	signa  =>  signa_out,
	signb  =>  signb_out,
	saturate  =>  saturate_out,
	round  =>  round_out,
	dataout =>  mult_output
	);

	dataout_clk_inst1: mux41_spc	 port map (MO =>  clkout, INP =>  clk, S0 =>  modesel(13),S1 =>  modesel(14), PASSN =>  modesel(12));
	dataout_clr_inst1: mux41_spc	 port map (MO =>  aclrout, INP =>  aclr, S0 =>  modesel(28),S1 =>  modesel(29), PASSN =>  modesel(27));
	dataout_ena_inst1: mux41_spc	 port map (MO =>  enaout, INP =>  ena, S0 =>  modesel(13),S1 =>  modesel(14), PASSN =>  modesel(12));
   
	mult_output_int(35 downto 0) <= mult_output; 
	mult_output_int(71 downto 36) <= gnd_vec(71 downto 36);
   dataout_mac_reg : arriagx_mac_register	 port map (
	data  =>  mult_output_int,
	clk  =>  clkout,
	aclr  =>  aclrout,
	ena  =>  enaout,
	dataout  =>  dataout_int,
	async  =>   modesel(12)
	);
	dataout <= dataout_int(35 downto 0); 

	dataa_out_int2(17 downto 0) <= dataa_out;
	dataa_out_int2(71 downto 18) <= gnd_vec(71 downto 18);
	scanouta_delaybuf: b72AND1  port map (Y =>  scanouta_int, IN1 =>  dataa_out_int2);
	scanouta <= scanouta_int(17 downto 0);

	datab_out_int2(17 downto 0) <= datab_out;
	datab_out_int2(71 downto 18) <= gnd_vec(71 downto 18);
	scanoutb_delaybuf: b72AND1  port map (Y =>  scanoutb_int, IN1 =>  datab_out_int2);
	scanoutb <= scanoutb_int(17 downto 0);
      
end structure;

library IEEE;
use IEEE.std_logic_1164.all;

entity arriagx_mac_out	is
	port (
      dataa           : in std_logic_vector(35 downto 0);
      datab           : in std_logic_vector(35 downto 0);
      datac           : in std_logic_vector(35 downto 0);
      datad           : in std_logic_vector(35 downto 0);
      zeroacc           : in std_logic;
      addnsub0           : in std_logic;
      addnsub1           : in std_logic;
   	round0				: in std_logic;
   	round1				: in std_logic;
   	saturate				: in std_logic;
   	multabsaturate				: in std_logic;
   	multcdsaturate				: in std_logic;
   	signa				: in std_logic;
   	signb				: in std_logic;
      clk : in std_logic_vector(3 downto 0);
      aclr : in std_logic_vector(3 downto 0);
      ena : in std_logic_vector(3 downto 0);
   	mode0				: in std_logic;
   	mode1				: in std_logic;
   	zeroacc1				: in std_logic;
   	saturate1				: in std_logic;
      modesel           : in std_logic_vector(220 downto 0);
      dataout           : out std_logic_vector(143 downto 0);
      accoverflow           : out std_logic );
end arriagx_mac_out;
   
architecture structure of arriagx_mac_out is
	component bmux21_144
	port (
			A                       : in std_logic_vector(143 downto 0);
			B                       : in std_logic_vector(143 downto 0);
			S                       : in std_logic;
			MO                       : out std_logic_vector(143 downto 0));
	end component;
	component mux41_spc
	port (
			INP                       : in std_logic_vector(3 downto 0);
			S0                       : in std_logic;
			S1                       : in std_logic;
			PASSN                       : in std_logic;
			MO                       : out std_logic);
	end component;
  component arriagx_mac_register
   port(
      data   : in std_logic_vector(71 downto 0);
      clk, aclr, ena, async   : in std_logic;
      dataout    : out std_logic_vector(71 downto 0));
	end component;
  component arriagx_mac_out_internal
   port(
      dataa   : in std_logic_vector(35 downto 0);
      datab   : in std_logic_vector(35 downto 0);
      datac   : in std_logic_vector(35 downto 0);
      datad   : in std_logic_vector(35 downto 0);
      modesel   : in std_logic_vector(220 downto 0);
      signx, signy, addnsub0, addnsub1   : in std_logic;
      zeroacc   : in std_logic;
      saturate   : in std_logic;
      saturate1   : in std_logic;
      multabsaturate   : in std_logic;
      multcdsaturate   : in std_logic;
      round0   : in std_logic;
      round1   : in std_logic;
      mode0   : in std_logic;
      mode1   : in std_logic;
      zeroacc1   : in std_logic;
      feedback    : in std_logic_vector(143 downto 0);
      dataout    : out std_logic_vector(143 downto 0);
      accoverflow   : out std_logic);
	end component;
  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;

	signal gnd: std_logic;

   signal zeroacc_out, addnsub0_out, addnsub1_out : std_logic;
   signal saturate_out, multabsaturate_out, multcdsaturate_out : std_logic;
   signal round0_out, round1_out, mode0_out, mode1_out : std_logic;
   signal zeroacc1_out, saturate1_out : std_logic;
   signal dataout_signal: std_logic_vector(143 downto 0);
   signal dynamic_dataout: std_logic_vector(143 downto 0);
   signal normal_dataout: std_logic_vector(143 downto 0);
   signal 		     accoverflow_signal : std_logic;
   signal signa_int, signa_out_int: std_logic_vector(71 downto 0);
	signal signa_pipe: std_logic;
   signal signb_int, signb_pipe_int: std_logic_vector(71 downto 0);
	signal signb_pipe: std_logic;
   signal zeroacc_int, zeroacc_pipe_int: std_logic_vector(71 downto 0);
   signal zeroacc_pipe: std_logic;
   signal addnsub0_int, addnsub0_pipe_int: std_logic_vector(71 downto 0);
   signal addnsub0_pipe: std_logic;
   signal addnsub1_int, addnsub1_pipe_int: std_logic_vector(71 downto 0);
   signal addnsub1_pipe: std_logic;
   signal saturate_int, saturate_pipe_int: std_logic_vector(71 downto 0);
   signal saturate_pipe: std_logic;
   signal multabsaturate_int, multabsaturate_pipe_int: std_logic_vector(71 downto 0);
   signal multabsaturate_pipe: std_logic;
   signal multcdsaturate_int, multcdsaturate_pipe_int: std_logic_vector(71 downto 0);
   signal multcdsaturate_pipe: std_logic;
   signal round0_int, round0_pipe_int: std_logic_vector(71 downto 0);
   signal round0_pipe: std_logic;
   signal round1_int, round1_pipe_int: std_logic_vector(71 downto 0);
   signal round1_pipe: std_logic;
   signal mode0_int, mode0_pipe_int: std_logic_vector(71 downto 0);
   signal mode0_pipe: std_logic;
   signal mode1_int, mode1_pipe_int: std_logic_vector(71 downto 0);
   signal mode1_pipe: std_logic;
   signal zeroacc1_int, zeroacc1_pipe_int: std_logic_vector(71 downto 0);
   signal zeroacc1_pipe: std_logic;
   signal saturate1_int, saturate1_pipe_int: std_logic_vector(71 downto 0);
   signal saturate1_pipe: std_logic;
   signal signa_pipe_int: std_logic_vector(71 downto 0);
   signal signa_pipe_int2: std_logic_vector(71 downto 0);
   signal signa_out: std_logic;
   signal signb_pipe_int2, signb_out_int: std_logic_vector(71 downto 0);
   signal signb_out: std_logic;
   signal zeroacc_pipe_int2, zeroacc_out_int: std_logic_vector(71 downto 0);
   signal addnsub0_pipe_int2, addnsub0_out_int: std_logic_vector(71 downto 0);
   signal addnsub1_pipe_int2, addnsub1_out_int: std_logic_vector(71 downto 0);
   signal saturate_pipe_int2, saturate_out_int, saturate02_out_int: std_logic_vector(71 downto 0);
   signal multabsaturate_pipe_int2, multabsaturate_out_int: std_logic_vector(71 downto 0);
   signal multcdsaturate_pipe_int2, multcdsaturate_out_int: std_logic_vector(71 downto 0);
   signal round0_pipe_int2, round0_out_int: std_logic_vector(71 downto 0);
   signal round1_pipe_int2, round1_out_int: std_logic_vector(71 downto 0);
   signal mode0_pipe_int2, mode0_out_int: std_logic_vector(71 downto 0);
   signal mode1_pipe_int2, mode1_out_int: std_logic_vector(71 downto 0);
   signal zeroacc1_pipe_int2, zeroacc1_out_int: std_logic_vector(71 downto 0);
   signal saturate1_pipe_int2, saturate1_out_int: std_logic_vector(71 downto 0);
   signal dataout0_in, dataout0_reg: std_logic_vector(71 downto 0);
   signal dataout1_in, dataout1_reg: std_logic_vector(71 downto 0);
	signal clkaccout, aclraccout, enaaccout : std_logic;
   signal accoverflow_int, accoverflow_wire_int: std_logic_vector(71 downto 0);
	signal clksa1, aclrsa1, enasa1 : std_logic;
	signal clksb1, aclrsb1, enasb1, clkz1, aclrz1, enaz1 : std_logic;
	signal clkads01, aclrads01, enaads01 : std_logic;
	signal clkads11, aclrads11, enaads11 : std_logic;
	signal clksat1, aclrsat1, enasat1, clkmultabsat1, aclrmultabsat1, enamultabsat1: std_logic;
	signal clkmultcdsat1, aclrmultcdsat1, enamultcdsat1: std_logic;
	signal clkround01, aclrround01, enaround01: std_logic;
	signal clkround11, aclrround11, enaround11: std_logic;
	signal clkmode01, aclrmode01, enamode01: std_logic;
	signal clkmode11, aclrmode11, enamode11: std_logic;
	signal clkzeroacc11, aclrzeroacc11, enazeroacc11: std_logic;
	signal clksaturate11, aclrsaturate11, enasaturate11: std_logic;
	signal clksa2, aclrsa2, enasa2 : std_logic;
	signal clksb2, aclrsb2, enasb2 : std_logic;
	signal clkz2, aclrz2, enaz2 : std_logic;
	signal clkads02, aclrads02, enaads02 : std_logic;
	signal clkads12, aclrads12, enaads12 : std_logic;
	signal clksaturate02, aclrsaturate02, enasaturate02 : std_logic;
	signal clksaturate12, aclrsaturate12, enasaturate12 : std_logic;
	signal clkmultabsaturate12, aclrmultabsaturate12, enamultabsaturate12 : std_logic;
	signal clkmultcdsaturate12, aclrmultcdsaturate12, enamultcdsaturate12 : std_logic;
	signal clkround02, aclrround02, enaround02 : std_logic;
	signal clkround12, aclrround12, enaround12 : std_logic;
	signal clkmode02, aclrmode02, enamode02 : std_logic;
	signal clkmode12, aclrmode12, enamode12 : std_logic;
	signal clkzeroacc12, aclrzeroacc12, enazeroacc12 : std_logic;
	signal enaround1, accoverflow_wire : std_logic;
	signal clkout0, aclrout0, enaout0 : std_logic;
	signal clkout1, aclrout1, enaout1 : std_logic;
	signal clkout2, aclrout2, enaout2 : std_logic;
	signal clkout3, aclrout3, enaout3 : std_logic;
	signal clkout4, aclrout4, enaout4 : std_logic;
	signal clkout5, aclrout5, enaout5 : std_logic;
	signal clkout6, aclrout6, enaout6 : std_logic;
	signal clkout7, aclrout7, enaout7 : std_logic;

	signal feedback_sig : std_logic_vector(143 downto 0);
	signal dataout_wire : std_logic_vector(143 downto 0);
	signal dataout2_in, dataout2_reg: std_logic_vector(71 downto 0);
	signal dataout3_in, dataout3_reg: std_logic_vector(71 downto 0);
	signal dataout4_in, dataout4_reg: std_logic_vector(71 downto 0);
	signal dataout5_in, dataout5_reg: std_logic_vector(71 downto 0);
	signal dataout6_in, dataout6_reg: std_logic_vector(71 downto 0);
	signal dataout7_in, dataout7_reg: std_logic_vector(71 downto 0);
	signal gnd_vec: std_logic_vector(143 downto 0);

  
begin 

	gnd_vec <= (others => '0');	

   -- FIRST SET OF PIPELINE REGISTERS

	-- Note: mux41_spc selects one bit of 4-bit clk input port
	signa_clk_inst1: mux41_spc	port map(MO =>  clksa1, INP => clk  , S0 =>  modesel(10), S1 =>  modesel(11), PASSN =>  modesel(9));
	signa_clr_inst1: mux41_spc	port map(MO =>  aclrsa1, INP =>  aclr, S0 =>  modesel(28), S1 =>  modesel(29), PASSN =>  modesel(27));
	signa_ena_inst1: mux41_spc	port map(MO =>  enasa1, INP =>  ena, S0 =>  modesel(10), S1 =>  modesel(11), PASSN =>  modesel(9));
   

	signa_int(0) <= signa;
	signa_int(71 downto 1) <= gnd_vec(71 downto 1);
   signa_mac_reg : arriagx_mac_register	port map(
	data  =>  signa_int,
	clk  =>  clksa1,
	aclr  =>  aclrsa1, 
	ena  =>  enasa1,
	dataout  =>  signa_pipe_int,
	async  =>   modesel(9)
	);
	signa_pipe <= signa_pipe_int(0);

	signb_clk_inst1: mux41_spc	port map(MO =>  clksb1, INP =>  clk, S0 =>  modesel(13), S1 =>  modesel(14), PASSN =>  modesel(12));
	signb_clr_inst1: mux41_spc	port map(MO =>  aclrsb1, INP =>  aclr, S0 =>  modesel(31), S1 =>  modesel(32), PASSN =>  modesel(30));
	signb_ena_inst1: mux41_spc	port map(MO =>  enasb1, INP =>  ena, S0 =>  modesel(13), S1 =>  modesel(14), PASSN =>  modesel(12));
   
	signb_int(0) <= signb;
	signb_int(71 downto 1) <= gnd_vec(71 downto 1);
   signb_mac_reg : arriagx_mac_register	port map(
	data  =>  signb_int,
	clk  =>  clksb1,
	aclr  =>  aclrsb1,
	ena  =>  enasb1,
	dataout  =>  signb_pipe_int,
	async  =>   modesel(12)
	);
	signb_pipe <= signb_pipe_int(0);

	zeroacc_reg_inst1: mux41_spc	port map(MO =>  clkz1, INP =>  clk, S0 =>  modesel(7), S1 =>  modesel(8), PASSN =>  modesel(6));
	zeroacc_clr_inst1: mux41_spc	port map(MO =>  aclrz1, INP =>  aclr, S0 =>  modesel(25), S1 =>  modesel(26), PASSN =>  modesel(24));
	zeroacc_ena_inst1: mux41_spc	port map(MO =>  enaz1, INP =>  ena, S0 =>  modesel(7), S1 =>  modesel(8), PASSN =>  modesel(6));
   
	zeroacc_int(0) <= zeroacc;
	zeroacc_int(71 downto 1) <= gnd_vec(71 downto 1);
   zeroacc_mac_reg : arriagx_mac_register	port map(
	data  =>  zeroacc_int,
	clk  =>  clkz1,
	aclr  =>  aclrz1,
	ena  =>  enaz1,
	dataout  =>  zeroacc_pipe_int,
	async  =>   modesel(6)
	);
	zeroacc_pipe <= zeroacc_pipe_int(0);

	addnsub0_reg_inst1: mux41_spc	port map(MO =>  clkads01, INP =>  clk, S0 =>  modesel(1), S1 =>  modesel(2), PASSN =>  modesel(0));
	addnsub0_clr_inst1: mux41_spc	port map(MO =>  aclrads01, INP =>  aclr, S0 =>  modesel(19), S1 =>  modesel(20), PASSN =>  modesel(18));
	addnsub0_ena_inst1: mux41_spc	port map(MO =>  enaads01, INP =>  ena, S0 =>  modesel(1), S1 =>  modesel(2), PASSN =>  modesel(0));
   
	addnsub0_int(0) <= addnsub0;
	addnsub0_int(71 downto 1) <= gnd_vec(71 downto 1);
   addnsub0_mac_reg : arriagx_mac_register	port map(
	data  =>  addnsub0_int,
	clk  =>  clkads01,
	aclr  =>  aclrads01,
	ena  =>  enaads01,
	dataout  =>  addnsub0_pipe_int,
	async  =>   modesel(0)
	);
	addnsub0_pipe <= addnsub0_pipe_int(0);

	addnsub1_reg_inst1: mux41_spc port map(MO =>  clkads11, INP =>  clk, S0 =>  modesel(4), S1 =>  modesel(5), PASSN =>  modesel(3));
	addnsub1_clr_inst1: mux41_spc port map(MO =>  aclrads11, INP =>  aclr, S0 =>  modesel(22), S1 =>  modesel(23), PASSN =>  modesel(21));
	addnsub1_ena_inst1: mux41_spc port map(MO =>  enaads11, INP =>  ena, S0 =>  modesel(4), S1 =>  modesel(5), PASSN =>  modesel(3));
   
	addnsub1_int(0) <= addnsub1;
	addnsub1_int(71 downto 1) <= gnd_vec(71 downto 1);
   addnsub1_mac_reg : arriagx_mac_register port map 	(
	data  =>  addnsub1_int,
	clk  =>  clkads11,
	aclr  =>  aclrads11,
	ena  =>  enaads11,
	dataout  =>  addnsub1_pipe_int,
	async  =>   modesel(3)
	);
	addnsub1_pipe <= addnsub1_pipe_int(0);

	saturate_reg_inst1: mux41_spc port map 	(MO =>  clksat1, INP =>  clk, S0 =>  modesel(67), S1 =>  modesel(68), PASSN =>  modesel(66));
	saturate_clr_inst1: mux41_spc port map 	(MO =>  aclrsat1, INP =>  aclr, S0 =>  modesel(70), S1 =>  modesel(71), PASSN =>  modesel(69));
	saturate_ena_inst1: mux41_spc port map 	(MO =>  enasat1, INP =>  ena, S0 =>  modesel(67), S1 =>  modesel(68), PASSN =>  modesel(66));
   
	saturate_int(0) <= saturate;
	saturate_int(71 downto 1) <= gnd_vec(71 downto 1);
   saturate_mac_reg : arriagx_mac_register port map 	(
	data  =>  saturate_int,
	clk  =>  clksat1,
	aclr  =>  aclrsat1,
	ena  =>  enasat1,
	dataout  =>  saturate_pipe_int,
	async  =>   modesel(66)
	);
	saturate_pipe <= saturate_pipe_int(0);

	multabsaturate_reg_inst1: mux41_spc port map 	(MO =>  clkmultabsat1, INP =>  clk, S0 =>  modesel(73), S1 =>  modesel(74), PASSN =>  modesel(72));
	multabsaturate_clr_inst1: mux41_spc port map 	(MO =>  aclrmultabsat1, INP =>  aclr, S0 =>  modesel(76), S1 =>  modesel(77), PASSN =>  modesel(75));
	multabsaturate_ena_inst1: mux41_spc port map 	(MO =>  enamultabsat1, INP =>  ena, S0 =>  modesel(73), S1 =>  modesel(74), PASSN =>  modesel(72));
   
	multabsaturate_int(0) <= multabsaturate;
	multabsaturate_int(71 downto 1) <= gnd_vec(71 downto 1);
   multabsaturate_mac_reg : arriagx_mac_register port map 	(
	data  =>  multabsaturate_int,
	clk  =>  clkmultabsat1,
	aclr  =>  aclrmultabsat1,
	ena  =>  enamultabsat1,
	dataout  =>  multabsaturate_pipe_int,
	async  =>   modesel(72)
	);
	multabsaturate_pipe <= multabsaturate_pipe_int(0);

	multcdsaturate_reg_inst1: mux41_spc port map 	(MO =>  clkmultcdsat1, INP =>  clk, S0 =>  modesel(79), S1 =>  modesel(80), PASSN =>  modesel(78));
	multcdsaturate_clr_inst1: mux41_spc port map 	(MO =>  aclrmultcdsat1, INP =>  aclr, S0 =>  modesel(82), S1 =>  modesel(83), PASSN =>  modesel(81));
	multcdsaturate_ena_inst1: mux41_spc port map 	(MO =>  enamultcdsat1, INP =>  ena, S0 =>  modesel(79), S1 =>  modesel(80), PASSN =>  modesel(78));
   
	multcdsaturate_int(0) <= multcdsaturate;
	multcdsaturate_int(71 downto 1) <= gnd_vec(71 downto 1);
   multcdsaturate_mac_reg : arriagx_mac_register port map 	(
	data  =>  multcdsaturate_int,
	clk  =>  clkmultcdsat1,
	aclr  =>  aclrmultcdsat1,
	ena  =>  enamultcdsat1,
	dataout  =>  multcdsaturate_pipe_int,
	async  =>   modesel(78)
	);
	multcdsaturate_pipe <= multcdsaturate_pipe_int(0);

	round0_reg_inst1: mux41_spc port map 	(MO =>  clkround01, INP =>  clk, S0 =>  modesel(85), S1 =>  modesel(86), PASSN =>  modesel(84));
	round0_clr_inst1: mux41_spc port map 	(MO =>  aclrround01, INP =>  aclr, S0 =>  modesel(88), S1 =>  modesel(89), PASSN =>  modesel(87));
	round0_ena_inst1: mux41_spc port map 	(MO =>  enaround01, INP =>  ena, S0 =>  modesel(85), S1 =>  modesel(86), PASSN =>  modesel(84));
   
	round0_int(0) <= round0;
	round0_int(71 downto 1) <= gnd_vec(71 downto 1);
   round0_mac_reg : arriagx_mac_register port map 	(
	data  =>  round0_int,
	clk  =>  clkround01,
	aclr  =>  aclrround01,
	ena  =>  enaround01,
	dataout  =>  round0_pipe_int,
	async  =>   modesel(84)
	);
	round0_pipe <= round0_pipe_int(0);

	round1_reg_inst1: mux41_spc port map 	(MO =>  clkround11, INP =>  clk, S0 =>  modesel(91), S1 =>  modesel(92), PASSN =>  modesel(90));
	round1_clr_inst1: mux41_spc port map 	(MO =>  aclrround11, INP =>  aclr, S0 =>  modesel(94), S1 =>  modesel(95), PASSN =>  modesel(93));
	round1_ena_inst1: mux41_spc port map 	(MO =>  enaround11, INP =>  ena, S0 =>  modesel(91), S1 =>  modesel(92), PASSN =>  modesel(90));
   
	round1_int(0) <= round1;
	round1_int(71 downto 1) <= gnd_vec(71 downto 1);
   round1_mac_reg : arriagx_mac_register port map 	(
	data  =>  round1_int,
	clk  =>  clkround11,
	aclr  =>  aclrround11,
	ena  =>  enaround11,
	dataout  =>  round1_pipe_int,
	async  =>   modesel(90)
	);
	round1_pipe <= round1_pipe_int(0);

	mode0_reg_inst1: mux41_spc port map 	(MO =>  clkmode01, INP =>  clk, S0 =>  modesel(97), S1 =>  modesel(98), PASSN =>  modesel(96));
	mode0_clr_inst1: mux41_spc port map 	(MO =>  aclrmode01, INP =>  aclr, S0 =>  modesel(100), S1 =>  modesel(101), PASSN =>  modesel(99));
	mode0_ena_inst1: mux41_spc port map 	(MO =>  enamode01, INP =>  ena, S0 =>  modesel(97), S1 =>  modesel(98), PASSN =>  modesel(96));
   
	mode0_int(0) <= mode0;
	mode0_int(71 downto 1) <= gnd_vec(71 downto 1);
   mode0_mac_reg : arriagx_mac_register port map 	(
	data  =>  mode0_int,
	clk  =>  clkmode01,
	aclr  =>  aclrmode01,
	ena  =>  enamode01,
	dataout  =>  mode0_pipe_int,
	async  =>   modesel(96)
	);
	mode0_pipe <= mode0_pipe_int(0);

	mode1_reg_inst1: mux41_spc port map 	(MO =>  clkmode11, INP =>  clk, S0 =>  modesel(103), S1 =>  modesel(104), PASSN =>  modesel(102));
	mode1_clr_inst1: mux41_spc port map 	(MO =>  aclrmode11, INP =>  aclr, S0 =>  modesel(106), S1 =>  modesel(107), PASSN =>  modesel(105));
	mode1_ena_inst1: mux41_spc port map 	(MO =>  enamode11, INP =>  ena, S0 =>  modesel(103), S1 =>  modesel(104), PASSN =>  modesel(102));
   
	mode1_int(0) <= mode1;
	mode1_int(71 downto 1) <= gnd_vec(71 downto 1);
   mode1_mac_reg : arriagx_mac_register port map 	(
	data  =>  mode1_int,
	clk  =>  clkmode11,
	aclr  =>  aclrmode11,
	ena  =>  enamode11,
	dataout  =>  mode1_pipe_int,
	async  =>   modesel(102)
	);
	mode1_pipe <= mode1_pipe_int(0);

	zeroacc1_reg_inst1: mux41_spc port map 	(MO =>  clkzeroacc11, INP =>  clk, S0 =>  modesel(109), S1 =>  modesel(110), PASSN =>  modesel(108));
	zeroacc1_clr_inst1: mux41_spc port map 	(MO =>  aclrzeroacc11, INP =>  aclr, S0 =>  modesel(112), S1 =>  modesel(113), PASSN =>  modesel(111));
	zeroacc1_ena_inst1: mux41_spc port map 	(MO =>  enazeroacc11, INP =>  ena, S0 =>  modesel(109), S1 =>  modesel(110), PASSN =>  modesel(108));
   
	zeroacc1_int(0) <= zeroacc1;
	zeroacc1_int(71 downto 1) <= gnd_vec(71 downto 1);
   zeroacc1_mac_reg : arriagx_mac_register port map 	(
	data  =>  zeroacc1_int,
	clk  =>  clkzeroacc11,
	aclr  =>  aclrzeroacc11,
	ena  =>  enazeroacc11,
	dataout  =>  zeroacc1_pipe_int,
	async  =>   modesel(108)
	);
	zeroacc1_pipe <= zeroacc1_pipe_int(0);

	saturate1_reg_inst1: mux41_spc port map 	(MO =>  clksaturate11, INP =>  clk, S0 =>  modesel(115), S1 =>  modesel(116), PASSN =>  modesel(114));
	saturate1_clr_inst1: mux41_spc port map 	(MO =>  aclrsaturate11, INP =>  aclr, S0 =>  modesel(118), S1 =>  modesel(119), PASSN =>  modesel(117));
	saturate1_ena_inst1: mux41_spc port map 	(MO =>  enasaturate11, INP =>  ena, S0 =>  modesel(115), S1 =>  modesel(116), PASSN =>  modesel(114));
   
	saturate1_int(0) <= saturate1;
	saturate1_int(71 downto 1) <= gnd_vec(71 downto 1);
   saturate1_mac_reg : arriagx_mac_register port map 	(
	data  =>  saturate1_int,
	clk  =>  clksaturate11,
	aclr  =>  aclrsaturate11,
	ena  =>  enasaturate11,
	dataout  =>  saturate1_pipe_int,
	async  =>   modesel(114)
	);
	saturate1_pipe <= saturate1_pipe_int(0);

   -- SECOND SET OF PIPELINE REGISTERS
	signa_reg_inst2: mux41_spc port map 	(MO =>  clksa2, INP =>  clk, S0 =>  modesel(46), S1 =>  modesel(47), PASSN =>  modesel(45));
	signa_clr_inst2: mux41_spc port map 	(MO =>  aclrsa2, INP =>  aclr, S0 =>  modesel(61), S1 =>  modesel(62), PASSN =>  modesel(60));
	signa_ena_inst2: mux41_spc port map 	(MO =>  enasa2, INP =>  ena, S0 =>  modesel(46), S1 =>  modesel(47), PASSN =>  modesel(45));
   
	signa_pipe_int2(0) <= signa_pipe;
	signa_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   signa_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  signa_pipe_int2,
	clk  =>  clksa2,
	aclr  =>  aclrsa2,
	ena  =>  enasa2,
	dataout  =>  signa_out_int,
	async  =>   modesel(45)
	);
	signa_out <= signa_out_int(0);

	signb_reg_inst2: mux41_spc port map 	(MO =>  clksb2, INP =>  clk, S0 =>  modesel(49), S1 =>  modesel(50), PASSN =>  modesel(48));
	signb_clr_inst2: mux41_spc port map 	(MO =>  aclrsb2, INP =>  aclr, S0 =>  modesel(64), S1 =>  modesel(65), PASSN =>  modesel(63));
	signb_ena_inst2: mux41_spc port map 	(MO =>  enasb2, INP =>  ena, S0 =>  modesel(49), S1 =>  modesel(50), PASSN =>  modesel(48));

	signb_pipe_int2(0) <= signb_pipe;
	signb_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   signb_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  signb_pipe_int2,
	clk  =>  clksb2,
	aclr  =>  aclrsb2,
	ena  =>  enasb2,
	dataout  =>  signb_out_int,
	async  =>   modesel(48)
	);
	signb_out <= signb_out_int(0);

	zeroacc_reg_inst2: mux41_spc port map 	(MO =>  clkz2, INP =>  clk, S0 =>  modesel(43), S1 =>  modesel(44), PASSN =>  modesel(42));
	zeroacc_clr_inst2: mux41_spc port map 	(MO =>  aclrz2, INP =>  aclr, S0 =>  modesel(58), S1 =>  modesel(59), PASSN =>  modesel(57));
	zeroacc_ena_inst2: mux41_spc port map 	(MO =>  enaz2, INP =>  ena, S0 =>  modesel(43), S1 =>  modesel(44), PASSN =>  modesel(42));

	zeroacc_pipe_int2(0) <= zeroacc_pipe;
	zeroacc_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   zeroacc_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  zeroacc_pipe_int2,
	clk  =>  clkz2,
	aclr  =>  aclrz2,
	ena  =>  enaz2,
	dataout  =>  zeroacc_out_int,
	async  =>   modesel(42)
	);
	zeroacc_out <= zeroacc_out_int(0);

	addnsub0_reg_inst2: mux41_spc port map 	(MO =>  clkads02, INP =>  clk, S0 =>  modesel(37), S1 =>  modesel(38), PASSN =>  modesel(36));
	addnsub0_clr_inst2: mux41_spc port map 	(MO =>  aclrads02, INP =>  aclr, S0 =>  modesel(52), S1 =>  modesel(53), PASSN =>  modesel(51));
	addnsub0_ena_inst2: mux41_spc port map 	(MO =>  enaads02, INP =>  ena, S0 =>  modesel(37), S1 =>  modesel(38), PASSN =>  modesel(36));

	addnsub0_pipe_int2(0) <= addnsub0_pipe;
	addnsub0_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   addnsub0_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  addnsub0_pipe_int2,
	clk  =>  clkads02,
	aclr  =>  aclrads02,
	ena  =>  enaads02,
	dataout  =>  addnsub0_out_int,
	async  =>   modesel(36)
	);
	addnsub0_out <= addnsub0_out_int(0);

	addnsub1_reg_inst2: mux41_spc port map 	(MO =>  clkads12, INP =>  clk, S0 =>  modesel(40), S1 =>  modesel(41), PASSN =>  modesel(39));
	addnsub1_clr_inst2: mux41_spc port map 	(MO =>  aclrads12, INP =>  aclr, S0 =>  modesel(55), S1 =>  modesel(56), PASSN =>  modesel(54));
	addnsub1_ena_inst2: mux41_spc port map 	(MO =>  enaads12, INP =>  ena, S0 =>  modesel(40), S1 =>  modesel(41), PASSN =>  modesel(39));

	addnsub1_pipe_int2(0) <= addnsub1_pipe;
	addnsub1_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   addnsub1_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  addnsub1_pipe_int2,
	clk  =>  clkads12,
	aclr  =>  aclrads12,
	ena  =>  enaads12,
	dataout  =>  addnsub1_out_int,
	async  =>   modesel(39)
	);
	addnsub1_out <= addnsub1_out_int(0);

	saturate_reg_inst2: mux41_spc port map 	(MO =>  clksaturate12, INP =>  clk, S0 =>  modesel(121), S1 =>  modesel(122), PASSN =>  modesel(120));
	saturate_clr_inst2: mux41_spc port map 	(MO =>  aclrsaturate12, INP =>  aclr, S0 =>  modesel(124), S1 =>  modesel(125), PASSN =>  modesel(123));
	saturate_ena_inst2: mux41_spc port map 	(MO =>  enasaturate12, INP =>  ena, S0 =>  modesel(121), S1 =>  modesel(122), PASSN =>  modesel(120));

	saturate_pipe_int2(0) <= saturate_pipe;
	saturate_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   saturate_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  saturate_pipe_int2,
	clk  =>  clksaturate02,
	aclr  =>  aclrsaturate02,
	ena  =>  enasaturate02,
	dataout  =>  saturate02_out_int,
	async  =>   modesel(120)
	);
	saturate_out <= saturate02_out_int(0);

	multabsaturate_reg_inst2: mux41_spc port map 	(MO =>  clkmultabsaturate12, INP =>  clk, S0 =>  modesel(127), S1 =>  modesel(128), PASSN =>  modesel(126));
	multabsaturate_clr_inst2: mux41_spc port map 	(MO =>  aclrmultabsaturate12, INP =>  aclr, S0 =>  modesel(130), S1 =>  modesel(131), PASSN =>  modesel(129));
	multabsaturate_ena_inst2: mux41_spc port map 	(MO =>  enamultabsaturate12, INP =>  ena, S0 =>  modesel(127), S1 =>  modesel(128), PASSN =>  modesel(126));

	multabsaturate_pipe_int2(0) <= multabsaturate_pipe;
	multabsaturate_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   multabsaturate_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  multabsaturate_pipe_int2,
	clk  =>  clkmultabsaturate12,
	aclr  =>  aclrmultabsaturate12,
	ena  =>  enamultabsaturate12,
	dataout  =>  multabsaturate_out_int,
	async  =>   modesel(126)
	);
	multabsaturate_out <= multabsaturate_out_int(0);

	multcdsaturate_reg_inst2: mux41_spc port map 	(MO =>  clkmultcdsaturate12, INP =>  clk, S0 =>  modesel(133), S1 =>  modesel(134), PASSN =>  modesel(132));
	multcdsaturate_clr_inst2: mux41_spc port map 	(MO =>  aclrmultcdsaturate12, INP =>  aclr, S0 =>  modesel(136), S1 =>  modesel(137), PASSN =>  modesel(135));
	multcdsaturate_ena_inst2: mux41_spc port map 	(MO =>  enamultcdsaturate12, INP =>  ena, S0 =>  modesel(133), S1 =>  modesel(134), PASSN =>  modesel(132));

	multcdsaturate_pipe_int2(0) <= multcdsaturate_pipe;
	multcdsaturate_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   multcdsaturate_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  multcdsaturate_pipe_int2,
	clk  =>  clkmultcdsaturate12,
	aclr  =>  aclrmultcdsaturate12,
	ena  =>  enamultcdsaturate12,
	dataout  =>  multcdsaturate_out_int,
	async  =>   modesel(132)
	);
	multcdsaturate_out <= multcdsaturate_out_int(0);

	round0_reg_inst2: mux41_spc port map 	(MO =>  clkround02, INP =>  clk, S0 =>  modesel(139), S1 =>  modesel(140), PASSN =>  modesel(138));
	round0_clr_inst2: mux41_spc port map 	(MO =>  aclrround02, INP =>  aclr, S0 =>  modesel(142), S1 =>  modesel(143), PASSN =>  modesel(141));
	round0_ena_inst2: mux41_spc port map 	(MO =>  enaround02, INP =>  ena, S0 =>  modesel(139), S1 =>  modesel(140), PASSN =>  modesel(138));

	round0_pipe_int2(0) <= round0_pipe;
	round0_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   round0_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  round0_pipe_int2,
	clk  =>  clkround02,
	aclr  =>  aclrround02,
	ena  =>  enaround02,
	dataout  =>  round0_out_int,
	async  =>   modesel(138)
	);
	round0_out <= round0_out_int(0);

	round1_reg_inst2: mux41_spc port map 	(MO =>  clkround12, INP =>  clk, S0 =>  modesel(145), S1 =>  modesel(146), PASSN =>  modesel(144));
	round1_clr_inst2: mux41_spc port map 	(MO =>  aclrround12, INP =>  aclr, S0 =>  modesel(148), S1 =>  modesel(149), PASSN =>  modesel(147));
	round1_ena_inst2: mux41_spc port map 	(MO =>  enaround12, INP =>  ena, S0 =>  modesel(145), S1 =>  modesel(146), PASSN =>  modesel(144));

	round1_pipe_int2(0) <= round1_pipe;
	round1_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   round1_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  round1_pipe_int2,
	clk  =>  clkround12,
	aclr  =>  aclrround12,
	ena  =>  enaround12,
	dataout  =>  round1_out_int,
	async  =>   modesel(144)
	);
	round1_out <= round1_out_int(0);

	mode0_reg_inst2: mux41_spc port map 	(MO =>  clkmode02, INP =>  clk, S0 =>  modesel(151), S1 =>  modesel(152), PASSN =>  modesel(150));
	mode0_clr_inst2: mux41_spc port map 	(MO =>  aclrmode02, INP =>  aclr, S0 =>  modesel(154), S1 =>  modesel(155), PASSN =>  modesel(153));
	mode0_ena_inst2: mux41_spc port map 	(MO =>  enamode02, INP =>  ena, S0 =>  modesel(151), S1 =>  modesel(152), PASSN =>  modesel(150));

	mode0_pipe_int2(0) <= mode0_pipe;
	mode0_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   mode0_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  mode0_pipe_int2,
	clk  =>  clkmode02,
	aclr  =>  aclrmode02,
	ena  =>  enamode02,
	dataout  =>  mode0_out_int,
	async  =>   modesel(150)
	);
	mode0_out <= mode0_out_int(0);

	mode1_reg_inst2: mux41_spc port map 	(MO =>  clkmode12, INP =>  clk, S0 =>  modesel(157), S1 =>  modesel(158), PASSN =>  modesel(156));
	mode1_clr_inst2: mux41_spc port map 	(MO =>  aclrmode12, INP =>  aclr, S0 =>  modesel(160), S1 =>  modesel(161), PASSN =>  modesel(159));
	mode1_ena_inst2: mux41_spc port map 	(MO =>  enamode12, INP =>  ena, S0 =>  modesel(157), S1 =>  modesel(158), PASSN =>  modesel(156));

	mode1_pipe_int2(0) <= mode1_pipe;
	mode1_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   mode1_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  mode1_pipe_int2,
	clk  =>  clkmode12,
	aclr  =>  aclrmode12,
	ena  =>  enamode12,
	dataout  =>  mode1_out_int,
	async  =>   modesel(156)
	);
	mode1_out <= mode1_out_int(0);

	zeroacc1_reg_inst2: mux41_spc port map 	(MO =>  clkzeroacc12, INP =>  clk, S0 =>  modesel(163), S1 =>  modesel(164), PASSN =>  modesel(162));
	zeroacc1_clr_inst2: mux41_spc port map 	(MO =>  aclrzeroacc12, INP =>  aclr, S0 =>  modesel(166), S1 =>  modesel(167), PASSN =>  modesel(165));
	zeroacc1_ena_inst2: mux41_spc port map 	(MO =>  enazeroacc12, INP =>  ena, S0 =>  modesel(163), S1 =>  modesel(164), PASSN =>  modesel(162));

	zeroacc1_pipe_int2(0) <= zeroacc1_pipe;
	zeroacc1_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   zeroacc1_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  zeroacc1_pipe_int2,
	clk  =>  clkzeroacc12,
	aclr  =>  aclrzeroacc12,
	ena  =>  enazeroacc12,
	dataout  =>  zeroacc1_out_int,
	async  =>   modesel(162)
	);
	zeroacc1_out <= zeroacc1_out_int(0);

	saturate1_reg_inst2: mux41_spc port map 	(MO =>  clksaturate12, INP =>  clk, S0 =>  modesel(169), S1 =>  modesel(170), PASSN =>  modesel(168));
	saturate1_clr_inst2: mux41_spc port map 	(MO =>  aclrsaturate12, INP =>  aclr, S0 =>  modesel(172), S1 =>  modesel(173), PASSN =>  modesel(171));
	saturate1_ena_inst2: mux41_spc port map 	(MO =>  enasaturate12, INP =>  ena, S0 =>  modesel(169), S1 =>  modesel(170), PASSN =>  modesel(168));

	saturate1_pipe_int2(0) <= saturate1_pipe;
	saturate1_pipe_int2(71 downto 1) <= gnd_vec(71 downto 1);
   saturate1_mac_pipeline_reg : arriagx_mac_register port map 	(
	data  =>  saturate1_pipe_int2,
	clk  =>  clksaturate12,
	aclr  =>  aclrsaturate12,
	ena  =>  enasaturate12,
	dataout  =>  saturate1_out_int,
	async  =>   modesel(168)
	);
	saturate1_out <= saturate1_out_int(0);

	feedback_sig <= (gnd_vec(143 downto 72) & dataout0_reg);
-- MAIN ADDER MODULE
mac_adder : arriagx_mac_out_internal port map  (
	dataa  =>  dataa,
	datab  =>  datab,
	datac  =>  datac,
	datad  =>  datad,
	modesel  =>  modesel,
	signx  =>  signa_out,
	signy  =>  signb_out,
	addnsub0  =>  addnsub0_out,
	addnsub1  =>  addnsub1_out,
	zeroacc  =>  zeroacc_out,
	saturate  =>  saturate_out,
	saturate1  =>  saturate1_out,
	multabsaturate  =>  multabsaturate_out,
	multcdsaturate  =>  multcdsaturate_out,
	round0 =>  round0_out,
	round1 =>  round1_out,
	mode0 =>  mode0_out,
	mode1 =>  mode1_out,
	zeroacc1 =>  zeroacc1_out,
	feedback => feedback_sig,
	dataout  =>  dataout_wire,
	accoverflow  =>  accoverflow_wire
	);

	dataout0_reg_inst: mux41_spc port map 	(MO =>  clkout0, INP =>  clk, S0 =>  modesel(16), S1 =>  modesel(17), PASSN =>  modesel(15));
	dataout0_clr_inst: mux41_spc port map 	(MO =>  aclrout0, INP =>  aclr, S0 =>  modesel(34), S1 =>  modesel(35), PASSN =>  modesel(33));
	dataout0_ena_inst: mux41_spc port map 	(MO =>  enaout0, INP =>  ena, S0 =>  modesel(16), S1 =>  modesel(17), PASSN =>  modesel(15));
	dataout0_in(71 downto 0) <= dataout_wire(71 downto 0);
   output0_reg : arriagx_mac_register port map 	(
	data  =>  dataout0_in, 
	clk  =>  clkout0,
	aclr  =>  aclrout0,
	ena  =>  enaout0,
	dataout  =>  dataout0_reg,
	async  =>   modesel(15)
	);
	--dataout(17 downto 0) = dataout0_reg(17 downto 0);
	normal_dataout(71 downto 0) <= dataout0_reg;
	dynamic_dataout(17 downto 0) <= dataout0_reg(17 downto 0);

	dataout1_reg_inst: mux41_spc port map 	(MO =>  clkout1, INP =>  clk, S0 =>  modesel(175), S1 =>  modesel(176), PASSN =>  modesel(174));
	dataout1_clr_inst: mux41_spc port map 	(MO =>  aclrout1, INP =>  aclr, S0 =>  modesel(178), S1 =>  modesel(179), PASSN =>  modesel(177));
	dataout1_ena_inst: mux41_spc port map 	(MO =>  enaout1, INP =>  ena, S0 =>  modesel(175), S1 =>  modesel(176), PASSN =>  modesel(174));
	dataout1_in(17 downto 0) <= dataout_wire(35 downto 18);
	dataout1_in(71 downto 18) <= gnd_vec(71 downto 18);
   output1_reg : arriagx_mac_register port map 	(
	data  =>  dataout1_in, 
	clk  =>  clkout1,
	aclr  =>  aclrout1,
	ena  =>  enaout1,
	dataout  =>  dataout1_reg,  
	async  =>   modesel(174)
	);
	--dataout(35 downto 18) <= dataout1_reg(17 downto 0);
	dynamic_dataout(35 downto 18) <= dataout1_reg(17 downto 0);

	dataout2_reg_inst: mux41_spc port map 	(MO =>  clkout2, INP =>  clk, S0 =>  modesel(181), S1 =>  modesel(182), PASSN =>  modesel(180));
	dataout2_clr_inst: mux41_spc port map 	(MO =>  aclrout2, INP =>  aclr, S0 =>  modesel(184), S1 =>  modesel(185), PASSN =>  modesel(183));
	dataout2_ena_inst: mux41_spc port map 	(MO =>  enaout2, INP =>  ena, S0 =>  modesel(181), S1 =>  modesel(182), PASSN =>  modesel(180));
	dataout2_in(17 downto 0) <= dataout_wire(53 downto 36);
	dataout2_in(71 downto 18) <= gnd_vec(71 downto 18);
   output2_reg : arriagx_mac_register port map 	(
	data  =>  dataout2_in, 
	clk  =>  clkout2,
	aclr  =>  aclrout2,
	ena  =>  enaout2,
	dataout  =>  dataout2_reg,  
	async  =>   modesel(180)
	);
	--dataout(53 downto 36) <= dataout2_reg(17 downto 0);
	dynamic_dataout(53 downto 36) <= dataout2_reg(17 downto 0);

	dataout3_reg_inst: mux41_spc port map 	(MO =>  clkout3, INP =>  clk, S0 =>  modesel(187), S1 =>  modesel(188), PASSN =>  modesel(186));
	dataout3_clr_inst: mux41_spc port map 	(MO =>  aclrout3, INP =>  aclr, S0 =>  modesel(190), S1 =>  modesel(191), PASSN =>  modesel(189));
	dataout3_ena_inst: mux41_spc port map 	(MO =>  enaout3, INP =>  ena, S0 =>  modesel(187), S1 =>  modesel(188), PASSN =>  modesel(186));
	dataout3_in(17 downto 0) <= dataout_wire(71 downto 54);
	dataout3_in(71 downto 18) <= gnd_vec(71 downto 18);
   output3_reg : arriagx_mac_register port map 	(
	data  =>  dataout3_in, 
	clk  =>  clkout3,
	aclr  =>  aclrout3,
	ena  =>  enaout3,
	dataout  =>  dataout3_reg,  
	async  =>   modesel(186)
	);
	--dataout(71 downto 54) <= dataout3_reg(17 downto 0);
	dynamic_dataout(71 downto 54) <= dataout3_reg(17 downto 0);

	dataout4_reg_inst: mux41_spc port map 	(MO =>  clkout4, INP =>  clk, S0 =>  modesel(193), S1 =>  modesel(194), PASSN =>  modesel(192));
	dataout4_clr_inst: mux41_spc port map 	(MO =>  aclrout4, INP =>  aclr, S0 =>  modesel(196), S1 =>  modesel(197), PASSN =>  modesel(195));
	dataout4_ena_inst: mux41_spc port map 	(MO =>  enaout4, INP =>  ena, S0 =>  modesel(193), S1 =>  modesel(194), PASSN =>  modesel(192));
	dataout4_in(17 downto 0) <= dataout_wire(89 downto 72);
	dataout4_in(71 downto 18) <= gnd_vec(71 downto 18);
   output4_reg : arriagx_mac_register port map 	(
	data  =>  dataout4_in, 
	clk  =>  clkout4,
	aclr  =>  aclrout4,
	ena  =>  enaout4,
	dataout  =>  dataout4_reg,  
	async  =>   modesel(192)
	);
	--dataout(89 downto 72) <= dataout4_reg(17 downto 0);
	dynamic_dataout(89 downto 72) <= dataout4_reg(17 downto 0);

	dataout5_reg_inst: mux41_spc port map 	(MO =>  clkout5, INP =>  clk, S0 =>  modesel(199), S1 =>  modesel(200), PASSN =>  modesel(198));
	dataout5_clr_inst: mux41_spc port map 	(MO =>  aclrout5, INP =>  aclr, S0 =>  modesel(202), S1 =>  modesel(203), PASSN =>  modesel(201));
	dataout5_ena_inst: mux41_spc port map 	(MO =>  enaout5, INP =>  ena, S0 =>  modesel(199), S1 =>  modesel(200), PASSN =>  modesel(198));
	dataout5_in(17 downto 0) <= dataout_wire(107 downto 90);
	dataout5_in(71 downto 18) <= gnd_vec(71 downto 18);
   output5_reg : arriagx_mac_register port map 	(
	data  =>  dataout5_in, 
	clk  =>  clkout5,
	aclr  =>  aclrout5,
	ena  =>  enaout5,
	dataout  =>  dataout5_reg,  
	async  =>   modesel(198)
	);
	--dataout(107 downto 90) <= dataout5_reg(17 downto 0);
	dynamic_dataout(107 downto 90) <= dataout5_reg(17 downto 0);

	dataout6_reg_inst: mux41_spc port map 	(MO =>  clkout6, INP =>  clk, S0 =>  modesel(205), S1 =>  modesel(206), PASSN =>  modesel(204));
	dataout6_clr_inst: mux41_spc port map 	(MO =>  aclrout6, INP =>  aclr, S0 =>  modesel(208), S1 =>  modesel(209), PASSN =>  modesel(207));
	dataout6_ena_inst: mux41_spc port map 	(MO =>  enaout6, INP =>  ena, S0 =>  modesel(205), S1 =>  modesel(206), PASSN =>  modesel(204));
	dataout6_in(17 downto 0) <= dataout_wire(125 downto 108);
	dataout6_in(71 downto 18) <= gnd_vec(71 downto 18);
   output6_reg : arriagx_mac_register port map 	(
	data  =>  dataout6_in, 
	clk  =>  clkout6,
	aclr  =>  aclrout6,
	ena  =>  enaout6,
	dataout  =>  dataout6_reg,  
	async  =>   modesel(204)
	);
	--dataout(125 downto 108) <= dataout6_reg(17 downto 0);
	dynamic_dataout(125 downto 108) <= dataout6_reg(17 downto 0);

	dataout7_reg_inst: mux41_spc port map 	(MO =>  clkout7, INP =>  clk, S0 =>  modesel(211), S1 =>  modesel(212), PASSN =>  modesel(210));
	dataout7_clr_inst: mux41_spc port map 	(MO =>  aclrout7, INP =>  aclr, S0 =>  modesel(214), S1 =>  modesel(215), PASSN =>  modesel(213));
	dataout7_ena_inst: mux41_spc port map 	(MO =>  enaout7, INP =>  ena, S0 =>  modesel(211), S1 =>  modesel(212), PASSN =>  modesel(210));
	dataout7_in(17 downto 0) <= dataout_wire(143 downto 126);
	dataout7_in(71 downto 18) <= gnd_vec(71 downto 18);
   output7_reg : arriagx_mac_register port map 	(
	data  =>  dataout7_in, 
	clk  =>  clkout7,
	aclr  =>  aclrout7,
	ena  =>  enaout7,
	dataout  =>  dataout7_reg,  
	async  =>   modesel(15)
	);
	--dataout(143 downto 126) <= dataout7_reg(17 downto 0);
	dynamic_dataout(143 downto 126) <= dataout7_reg(17 downto 0);

	-- selection for accoverflow same as output register when overflow is used

	and2_clk : AND2    port map  ( Y =>  clkaccout, IN1 =>  clkout0, IN2 =>  modesel(217));
	and2_aclr : AND2    port map  ( Y =>  aclraccout, IN1 =>  aclrout0, IN2 =>  modesel(217));
	and2_ena : AND2    port map  ( Y =>  enaaccout, IN1 =>  enaout0, IN2 =>  modesel(217));

	accoverflow_wire_int(0) <= accoverflow_wire;
	accoverflow_wire_int(71 downto 1) <= gnd_vec(71 downto 1);
   accoverflow_out_reg : arriagx_mac_register port map 	(
	data  =>  accoverflow_wire_int,
	clk  =>  clkaccout,
	aclr  =>  aclraccout,
	ena  =>  enaaccout,
	dataout  =>  accoverflow_int, 
	async  =>   modesel(210)
	);
	accoverflow <= accoverflow_int(0);


	inst1 : bmux21_144 port map  ( MO =>  dataout, A =>  normal_dataout, B =>  dynamic_dataout, S =>  modesel(216) );
end structure;
