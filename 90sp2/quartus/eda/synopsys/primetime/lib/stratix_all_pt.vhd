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


library IEEE;
use IEEE.std_logic_1164.all;

entity stratix_lcell is
  port (clk     : in std_logic;
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        aclr    : in std_logic;
        aload    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        ena : in std_logic;
        cin   : in std_logic;
        cin0   : in std_logic;
        cin1   : in std_logic;
        inverta   : in std_logic;
        regcascin     : in std_logic;
        enable_asynch_arcs     : in std_logic;
        modesel   : in std_logic_vector(12 downto 0);
        pathsel   : in std_logic_vector(10 downto 0);
        combout   : out std_logic;
        regout    : out std_logic;
        cout    : out std_logic;
        cout0    : out std_logic;
        cout1  : out std_logic);
end stratix_lcell;
        
architecture vital_le_atom of stratix_lcell is

signal regin : std_logic;
signal dffin : std_logic;
signal qfbkin  : std_logic;

component stratix_asynch_lcell 
  port (
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        cin       : in std_logic;
        cin0       : in std_logic;
        cin1       : in std_logic;
        inverta       : in std_logic;
        qfbkin    : in std_logic;
        modesel   : in std_logic_vector(12 downto 0);
        pathsel   : in std_logic_vector(10 downto 0);
        regin   : out std_logic;
        combout   : out std_logic;
        cout      : out std_logic;
        cout0      : out std_logic;
        cout1      : out std_logic);
end component;

component stratix_lcell_register
  port (clk     : in std_logic;
        modesel   : in std_logic_vector(12 downto 0);
        aclr    : in std_logic;
        aload    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        ena : in std_logic;
        datain     : in std_logic;
        adata     : in std_logic;
        regcascin     : in std_logic;
        enable_asynch_arcs     : in std_logic;
        regout    : out std_logic;
        qfbkout     : out std_logic);
end component;

component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component; 


begin

lecomb: stratix_asynch_lcell
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cin0 => cin0, cin1 => cin1, inverta => inverta, qfbkin => qfbkin, modesel => modesel, pathsel => pathsel, regin => regin,
                  combout => combout, cout => cout, cout0 => cout0, cout1 => cout1);

regin_datac: AND2
   port map( Y =>  dffin, IN1 =>  regin, IN2 =>  datac);

lereg: stratix_lcell_register
  	port map (clk => clk, modesel => modesel, aclr => aclr, aload => aload, sclr => sclr, sload => sload, ena => ena, datain => dffin, adata => datac,
                  regcascin => regcascin, regout => regout,
                  qfbkout => qfbkin, enable_asynch_arcs => enable_asynch_arcs);


end vital_le_atom;



--
-- stratix_IO
--
library IEEE;
use IEEE.std_logic_1164.all;

entity  stratix_io is
    port (
			datain                       : in std_logic := '0';
			ddiodatain                       : in std_logic := '0';
			oe                       : in std_logic := '0';
			outclk                       : in std_logic := '0';
			outclkena                       : in std_logic := '1';
			inclk                       : in std_logic := '0';
			inclkena                       : in std_logic := '1';
			areset                       : in std_logic := '0';
			sreset                       : in std_logic := '0';
			delayctrlin                       : in std_logic := '0';
			modesel                       : in std_logic_vector(27 DOWNTO 0);
			padio                       : inout std_logic;
			combout                       : out std_logic;
			regout                       : out std_logic;
			ddioregout					 : out std_logic;
			dqsundelayedout					 : out std_logic);
end stratix_io;

architecture structure of stratix_io is
component stratix_asynch_io 
	port(
         datain : in  STD_LOGIC;
         oe     : in  STD_LOGIC;
         regin  : in std_logic;
         ddioregin  : in std_logic;
         modesel : in std_logic_vector(27 downto 0);
         padio  : inout STD_LOGIC;
         combout: out STD_LOGIC;
         regout : out STD_LOGIC;
         ddioregout : out STD_LOGIC;
         dqsundelayedout : out STD_LOGIC);
end component;
component stratix_io_register 
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
		A : in std_logic := '0';
        B : in std_logic := '0';
        S : in std_logic := '0';
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
	 signal ddio_input_sreset, ddio_input_padio, oe_clk_ena_a : std_logic;
	 signal ddio1_data_input, ddio_output_clkena, ddio_output_sreset: std_logic;
begin    
one <= '1';
zero <= '0'; 


        
      --  assign out_clk_ena = (tie_off_output_clock_enable == "false") ? outclkena : one;
		or2_1: OR2  port map(Y =>  out_clk_ena, IN1 =>  modesel(25), IN2 =>  outclkena);

		--assign oe_clk_ena = (tie_off_oe_clock_enable == "false") ? outclkena : one;
		or2_2: OR2  port map(Y =>  oe_clk_ena, IN1 =>  modesel(26), IN2 =>  outclkena);

		inv_4: INV port map(Y =>  inclk_inv, IN1 =>  inclk);

		inv_5: INV port map(Y =>  outclk_inv, IN1 =>  outclk);

        --input register
		in_reg_modesel(0) <= modesel(20);
		in_reg_modesel(1) <= modesel(21);
		in_reg_modesel(2) <= modesel(22);
		in_reg_modesel(3) <= modesel(23);
		in_reg : stratix_io_register  port map(regout =>  in_reg_out, clk =>  inclk, ena =>  inclkena,
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
		in_ddio0_reg: stratix_io_register  port map(regout =>  in_ddio0_reg_out, clk =>  inclk_inv, modesel =>  in_reg_modesel, ena  =>  ddio_input_clkena,
                        datain =>  ddio_input_padio, areset =>  areset,sreset =>  ddio_input_sreset
                        );
        
		-- disable ddio0 to ddio1 reg path when not in ddio input mode
		inst_ddio_input_reg2reg : AND2  port map  ( Y =>  ddio1_data_input, IN1 =>  in_ddio0_reg_out, IN2 =>  ddio_input_reg);

		-- in_ddio1_reg
        in_ddio1_reg: stratix_io_register  port map(regout =>  in_ddio1_reg_out, clk =>  inclk, ena =>  ddio_input_clkena, modesel =>  in_reg_modesel,
                        datain =>  in_ddio0_reg_out, areset =>  areset,sreset =>  ddio_input_sreset
                        );
                  
        -- out_reg
        --output register
		out_reg_modesel(0) <= modesel(9);
		out_reg_modesel(1) <= modesel(10);
		out_reg_modesel(2) <= modesel(11);
		out_reg_modesel(3) <= modesel(12);
		out_reg: stratix_io_register  port map(regout =>  out_reg_out, clk =>  outclk, ena =>  out_clk_ena, modesel =>  out_reg_modesel, 
                        datain =>  datain, areset =>  areset,sreset =>  sreset
                        );
        
        -- out ddio reg
		inst_ddio_output_clkena : AND2  port map  ( Y =>  ddio_output_clkena, IN1 =>  out_clk_ena, IN2 =>  ddio_output_reg);
		inst_ddio_output_sreset : AND2  port map  ( Y =>  ddio_output_sreset, IN1 =>  sreset, IN2 =>  ddio_output_reg);
		out_ddio_reg: stratix_io_register  port map(regout =>  out_ddio_reg_out, clk =>  outclk, ena =>  ddio_output_clkena,modesel =>  out_reg_modesel, 
                        datain =>  ddiodatain, areset =>  areset,sreset =>  ddio_output_sreset
                        );
        
		-- oe reg
        --output register
		oe_reg_modesel(0) <= modesel(15);
		oe_reg_modesel(1) <= modesel(16);
		oe_reg_modesel(2) <= modesel(17);
		oe_reg_modesel(3) <= modesel(18);

		and2_11 : AND2    port map  ( Y =>  oe_clk_ena_a, IN1 =>  oe_clk_ena, IN2 =>  modesel(14));

        oe_reg: stratix_io_register  port map(regout  =>  oe_reg_out, clk =>  outclk, ena =>  oe_clk_ena_a, modesel =>  oe_reg_modesel,
                        datain =>  oe, areset =>  areset,sreset =>  sreset
                        );
        
        -- oe_pulse reg
		oe_pulse_reg : stratix_io_register  port map(regout =>  oe_pulse_reg_out, clk =>  outclk_inv, ena =>  oe_clk_ena, modesel =>  oe_reg_modesel,
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
        inst1: stratix_asynch_io   port map(datain =>  tmp_datain,
                                      oe =>  oe_out,
                                      modesel =>  modesel,
                                      regin =>  in_reg_out,
                                      ddioregin =>  in_ddio1_reg_out,
                                      padio =>  padio,
                                      combout =>  combout,
                                      regout =>  regout,
                                      ddioregout =>  ddioregout,
                                      dqsundelayedout =>  dqsundelayedout);
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



library IEEE;
use IEEE.std_logic_1164.all;

entity  stratix_mac_mult is
    port (
      dataa           : in std_logic_vector(17 downto 0);
      datab           : in std_logic_vector(17 downto 0);
      signa           : in std_logic;
      signb           : in std_logic;
      clk             : in std_logic_vector(3 downto 0);
      aclr            : in std_logic_vector(3 downto 0);
      ena             : in std_logic_vector(3 downto 0);
      modesel             : in std_logic_vector(29 downto 0);
      
      dataout         : out std_logic_vector(35 downto 0); 
      scanouta        : out std_logic_vector(17 downto 0); 
      scanoutb        : out std_logic_vector(17 downto 0) 
		);
end stratix_mac_mult;

architecture structure of stratix_mac_mult is
	component mux41_spc
	port (
			INP                       : in std_logic_vector(3 downto 0);
			S0                       : in std_logic;
			S1                       : in std_logic;
			PASSN                       : in std_logic;
			MO                       : out std_logic);
	end component;
  component stratix_mac_register
   port(
      data   : in std_logic_vector(71 downto 0);
      clk, aclr, ena, async   : in std_logic;
      dataout    : out std_logic_vector(71 downto 0));
	end component;
  component stratix_mac_mult_internal
   port(
      dataa   : in std_logic_vector(17 downto 0);
      datab   : in std_logic_vector(17 downto 0);
      signa, signb   : in std_logic;
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
   signal 				  signa_out: std_logic; 
   signal 				  signb_out: std_logic;
   
   signal dataa_out : std_logic_vector(17 downto 0);
   signal datab_out : std_logic_vector(17 downto 0);
  	signal dataa_reg_feedthru, datab_reg_feedthru, signa_reg_feedthru, signb_reg_feedthru, dataout_reg_feedthru, dataa_clk_none : std_logic;

	signal dataa_int, dataa_out_int : std_logic_vector(71 downto 0);
	signal datab_int, datab_out_int : std_logic_vector(71 downto 0);
	signal signa_int, signa_out_int : std_logic_vector(71 downto 0);
	signal signb_int, signb_out_int : std_logic_vector(71 downto 0);
	signal mult_output_int, dataout_int : std_logic_vector(71 downto 0);
	signal scanouta_int, dataa_out_int2 : std_logic_vector(71 downto 0);
	signal scanoutb_int, datab_out_int2 : std_logic_vector(71 downto 0);
	signal clka, aclra, enaa, clkb, aclrb, enab, clksa, enasa, aclrsa, clksb, enasb, aclrsb : std_logic;
	signal clkout, aclrout, enaout : std_logic;
begin    



	-- mux41_spc:
	-- S0,.S1 => encode clk selection: one of clk0, clk1, clk2, clk3
	-- PASSN => output is one of above clocks if PASSN=0, output is 0 otherwise

	dataa_clk_inst1 : mux41_spc	 port map(MO =>  clka, INP =>  clk, S0 =>  modesel(1),S1 =>  modesel(2), PASSN =>  modesel(0));
	dataa_aclr_inst1: mux41_spc	 port map(MO =>  aclra, INP =>  aclr, S0 =>  modesel(16),S1 =>  modesel(17), PASSN =>  modesel(15));
	dataa_ena_inst1: mux41_spc	 port map(MO =>  enaa, INP =>  ena, S0 =>  modesel(1),S1 =>  modesel(2), PASSN =>  modesel(0));
   
	dataa_int(17 downto 0) <= dataa; 
   dataa_mac_reg  : stratix_mac_register	port map(
	data  =>  dataa_int,
	clk  =>  clka,
	aclr  =>  aclra,
	ena  =>  enaa,
	dataout  =>  dataa_out_int,
	async  =>   modesel(0) -- represents !PASS modesel 
	);
	dataa_out <= dataa_out_int(17 downto 0);

	datab_clk_inst1: mux41_spc	 port map(MO =>  clkb, INP =>  clk, S0 =>  modesel(4),S1 =>  modesel(5), PASSN =>  modesel(3));
	datab_clr_inst1: mux41_spc	 port map(MO =>  aclrb, INP =>  aclr, S0 =>  modesel(19),S1 =>  modesel(20), PASSN =>  modesel(18));
	datab_ena_inst1: mux41_spc	 port map(MO =>  enab, INP =>  ena, S0 =>  modesel(4),S1 =>  modesel(5), PASSN =>  modesel(3));
   
	datab_int(17 downto 0) <= datab; 
   datab_mac_reg : stratix_mac_register	 port map(
	data  =>  datab_int,
	clk  =>  clkb,
	aclr  =>  aclrb,
	ena  =>  enab,
	dataout  =>  datab_out_int,
	async  =>   modesel(3) 
	);
	datab_out <= datab_out_int(17 downto 0);

	signa_clk_inst1: mux41_spc	 port map(MO =>  clksa, INP =>  clk, S0 =>  modesel(7),S1 =>  modesel(8), PASSN =>  modesel(6));
	signa_clr_inst1: mux41_spc	 port map(MO =>  aclrsa, INP =>  aclr, S0 =>  modesel(22),S1 =>  modesel(23), PASSN =>  modesel(21));
	signa_ena_inst1: mux41_spc	 port map(MO =>  enasa, INP =>  ena, S0 =>  modesel(7),S1 =>  modesel(8), PASSN =>  modesel(6));
  
	signa_int(0) <= signa; 
   signa_mac_reg : stratix_mac_register	 port map(
	data  =>  signa_int,
	clk  =>  clksa,
	aclr  =>  aclrsa,
	ena  =>  enasa,
	dataout  =>  signa_out_int,
	async  =>  modesel(6)
	);
	signa_out <= signa_out_int(0); 

	signb_clk_inst1: mux41_spc	 port map(MO =>  clksb, INP =>  clk, S0 =>  modesel(10),S1 =>  modesel(11), PASSN =>  modesel(9));
	signb_clr_inst1: mux41_spc	 port map(MO =>  aclrsb, INP =>  aclr, S0 =>  modesel(25),S1 =>  modesel(26), PASSN =>  modesel(24));
	signb_ena_inst1: mux41_spc	 port map(MO =>  enasb, INP =>  ena, S0 =>  modesel(10),S1 =>  modesel(11), PASSN =>  modesel(9));
   
	signb_int(0) <= signb; 
   signb_mac_reg : stratix_mac_register	 port map(
	data  =>  signb_int,
	clk  =>  clksb,
	aclr  =>  aclrsb,
	ena  =>  enasb,
	dataout  =>  signb_out_int,
	async  =>   modesel(9)
	);
	signb_out <= signb_out_int(0); 

   mac_multiply : stratix_mac_mult_internal  port map(
	dataa  =>  dataa_out,
	datab  =>  datab_out,
	signa  =>  signa_out,
	signb  =>  signb_out,
	dataout =>  mult_output
	);

	dataout_clk_inst1: mux41_spc	 port map(MO =>  clkout, INP =>  clk, S0 =>  modesel(13),S1 =>  modesel(14), PASSN =>  modesel(12));
	dataout_clr_inst1: mux41_spc	 port map(MO =>  aclrout, INP =>  aclr, S0 =>  modesel(28),S1 =>  modesel(29), PASSN =>  modesel(27));
	dataout_ena_inst1: mux41_spc	 port map(MO =>  enaout, INP =>  ena, S0 =>  modesel(13),S1 =>  modesel(14), PASSN =>  modesel(12));
   
	mult_output_int(35 downto 0) <= mult_output; 
   dataout_mac_reg : stratix_mac_register	 port map(
	data  =>  mult_output_int,
	clk  =>  clkout,
	aclr  =>  aclrout,
	ena  =>  enaout,
	dataout  =>  dataout_int,
	async  =>   modesel(12)
	);
	dataout <= dataout_int(35 downto 0); 

	dataa_out_int2(17 downto 0) <= dataa_out;
	scanouta_delaybuf: b72AND1  port map(Y =>  scanouta_int, IN1 =>  dataa_out_int2);
	scanouta <= scanouta_int(17 downto 0);

	datab_out_int2(17 downto 0) <= datab_out;
	scanoutb_delaybuf: b72AND1  port map(Y =>  scanoutb_int, IN1 =>  datab_out_int2);
	scanoutb <= scanoutb_int(17 downto 0);

end structure;


library IEEE;
use IEEE.std_logic_1164.all;

entity  stratix_mac_out is
    port (
      dataa           : in std_logic_vector(35 downto 0);
      datab           : in std_logic_vector(35 downto 0);
      datac           : in std_logic_vector(35 downto 0);
      datad           : in std_logic_vector(35 downto 0);
      zeroacc           : in std_logic;
      addnsub0           : in std_logic;
      addnsub1           : in std_logic;
      signa           : in std_logic;
      signb           : in std_logic;
      clk             : in std_logic_vector(3 downto 0);
      aclr            : in std_logic_vector(3 downto 0);
      ena             : in std_logic_vector(3 downto 0);
      modesel             : in std_logic_vector(69 downto 0);
      
      dataout         : out std_logic_vector(71 downto 0); 
      accoverflow         : out std_logic
		);
end stratix_mac_out;

architecture structure of stratix_mac_out is
	component mux41_spc
	port (
			INP                       : in std_logic_vector(3 downto 0);
			S0                       : in std_logic;
			S1                       : in std_logic;
			PASSN                       : in std_logic;
			MO                       : out std_logic);
	end component;
  component stratix_mac_register
   port(
      data   : in std_logic_vector(71 downto 0);
      clk, aclr, ena, async   : in std_logic;
      dataout    : out std_logic_vector(71 downto 0));
	end component;
  component stratix_mac_out_internal
   port(
      dataa   : in std_logic_vector(35 downto 0);
      datab   : in std_logic_vector(35 downto 0);
      datac   : in std_logic_vector(35 downto 0);
      datad   : in std_logic_vector(35 downto 0);
      modesel   : in std_logic_vector(69 downto 0);
      signx, signy, addnsub0, addnsub1   : in std_logic;
      zeroacc   : in std_logic;
		feedback	: in std_logic_vector(71 downto 0); 
      dataout    : out std_logic_vector(71 downto 0);
      accoverflow   : out std_logic);
	end component;
  component AND2
  port(
       IN1 : in STD_LOGIC;
       IN2 : in STD_LOGIC;
       Y   : out STD_LOGIC);
end component;

  	signal zeroacc_out, addnsub0_out,  addnsub1_out, accoverflow_wire : std_logic;
   signal dataout_reg : std_logic_vector(71 downto 0);
   signal dataout_wire : std_logic_vector(71 downto 0);
   signal signa_int, signa_pipe_int : std_logic_vector(71 downto 0);
	signal signa_pipe: std_logic;
   signal accoverflow_int, accoverflow_wire_int : std_logic_vector(71 downto 0);
	signal clkaccout, aclraccout, enaaccout : std_logic;
   signal addnsub1_out_int, addnsub1_pipe_int2 : std_logic_vector(71 downto 0);
   signal addnsub0_out_int, addnsub0_pipe_int2 : std_logic_vector(71 downto 0);
   signal  zeroacc_pipe_int2, zeroacc_out_int : std_logic_vector(71 downto 0);
   signal  signb_pipe_int2, signb_out_int : std_logic_vector(71 downto 0);
	signal signb_out , signa_out, addnsub1_pipe, addnsub0_pipe, zeroacc_pipe, signb_pipe: std_logic;
   signal  signa_pipe_int2, signa_out_int : std_logic_vector(71 downto 0);
   signal  addnsub1_int, addnsub1_pipe_int : std_logic_vector(71 downto 0);
   signal  addnsub0_int, addnsub0_pipe_int : std_logic_vector(71 downto 0);
   signal  zeroacc_int, zeroacc_pipe_int : std_logic_vector(71 downto 0);
   signal  signb_int, signb_pipe_int : std_logic_vector(71 downto 0);
	signal enaout, clkout, aclrout : std_logic;
	signal clkads01, enaads01, aclrads01 : std_logic;
	signal clkads11, enaads11, aclrads11 : std_logic;
	signal clkads02, enaads02, aclrads02 : std_logic;
	signal clkads12, enaads12, aclrads12 : std_logic;
	signal clksa1, enasa1, aclrsa1 : std_logic;
	signal clksa2, enasa2, aclrsa2 : std_logic;
	signal clksb1, enasb1, aclrsb1 : std_logic;
	signal clksb2, enasb2, aclrsb2 : std_logic;
	signal clkz1, enaz1, aclrz1 : std_logic;
	signal clkz2, enaz2, aclrz2 : std_logic;

begin    

   -- FIRST SET OF PIPELINE REGISTERS

	-- Note: mux41_spc selects one bit of 4-bit clk input port
	signa_clk_inst1: mux41_spc	 port map(MO =>  clksa1, INP =>  clk, S0 =>  modesel(10), S1 =>  modesel(11), PASSN =>  modesel(9));
	signa_clr_inst1: mux41_spc	 port map(MO =>  aclrsa1, INP =>  aclr, S0 =>  modesel(28), S1 =>  modesel(29), PASSN =>  modesel(27));
	signa_ena_inst1: mux41_spc	 port map(MO =>  enasa1, INP =>  ena, S0 =>  modesel(10), S1 =>  modesel(11), PASSN =>  modesel(9));
   
	signa_int(0) <= signa;
   signa_mac_reg : stratix_mac_register	 port map(
	data  =>  signa_int,
	clk  =>  clksa1,
	aclr  =>  aclrsa1, 
	ena  =>  enasa1,
	dataout  =>  signa_pipe_int,
	async  =>   modesel(9)
	);
	signa_pipe <= signa_pipe_int(0);

	signb_clk_inst1: mux41_spc	 port map(MO =>  clksb1, INP =>  clk, S0 =>  modesel(13), S1 =>  modesel(14), PASSN =>  modesel(12));
	signb_clr_inst1: mux41_spc	 port map(MO =>  aclrsb1, INP =>  aclr, S0 =>  modesel(31), S1 =>  modesel(32), PASSN =>  modesel(30));
	signb_ena_inst1: mux41_spc	 port map(MO =>  enasb1, INP =>  ena, S0 =>  modesel(13), S1 =>  modesel(14), PASSN =>  modesel(12));
   
	signb_int(0) <= signb;
   signb_mac_reg : stratix_mac_register	 port map(
	data  =>  signb_int,
	clk  =>  clksb1,
	aclr  =>  aclrsb1,
	ena  =>  enasb1,
	dataout  =>  signb_pipe_int,
	async  =>   modesel(12)
	);
	signb_pipe <= signb_pipe_int(0);

	zeroacc_reg_inst1: mux41_spc	 port map(MO =>  clkz1, INP =>  clk, S0 =>  modesel(7), S1 =>  modesel(8), PASSN =>  modesel(6));
	zeroacc_clr_inst1: mux41_spc	 port map(MO =>  aclrz1, INP =>  aclr, S0 =>  modesel(25), S1 =>  modesel(26), PASSN =>  modesel(24));
	zeroacc_ena_inst1: mux41_spc	 port map(MO =>  enaz1, INP =>  ena, S0 =>  modesel(7), S1 =>  modesel(8), PASSN =>  modesel(6));
   
	zeroacc_int(0) <= zeroacc;
   zeroacc_mac_reg : stratix_mac_register	 port map(
	data  =>  zeroacc_int,
	clk  =>  clkz1,
	aclr  =>  aclrz1,
	ena  =>  enaz1,
	dataout  =>  zeroacc_pipe_int,
	async  =>   modesel(6)
	);
	zeroacc_pipe <= zeroacc_pipe_int(0);

	addnsub0_reg_inst1: mux41_spc	 port map(MO =>  clkads01, INP =>  clk, S0 =>  modesel(1), S1 =>  modesel(2), PASSN =>  modesel(0));
	addnsub0_clr_inst1: mux41_spc	 port map(MO =>  aclrads01, INP =>  aclr, S0 =>  modesel(19), S1 =>  modesel(20), PASSN =>  modesel(18));
	addnsub0_ena_inst1: mux41_spc	 port map(MO =>  enaads01, INP =>  ena, S0 =>  modesel(1), S1 =>  modesel(2), PASSN =>  modesel(0));
   
	addnsub0_int(0) <= addnsub0;
   addnsub0_mac_reg : stratix_mac_register	 port map(
	data  =>  addnsub0_int,
	clk  =>  clkads01,
	aclr  =>  aclrads01,
	ena  =>  enaads01,
	dataout  =>  addnsub0_pipe_int,
	async  =>   modesel(0)
	);
	addnsub0_pipe <= addnsub0_pipe_int(0);

	addnsub1_reg_inst1: mux41_spc	 port map(MO =>  clkads11, INP =>  clk, S0 =>  modesel(4), S1 =>  modesel(5), PASSN =>  modesel(3));
	addnsub1_clr_inst1 : mux41_spc	port map(MO =>  aclrads11, INP =>  aclr, S0 =>  modesel(22), S1 =>  modesel(23), PASSN =>  modesel(21));
	addnsub1_ena_inst1: mux41_spc	 port map(MO =>  enaads11, INP =>  ena, S0 =>  modesel(4), S1 =>  modesel(5), PASSN =>  modesel(3));
   
	addnsub1_int(0) <= addnsub1;
   addnsub1_mac_reg : stratix_mac_register	 port map(
	data  =>  addnsub1_int,
	clk  =>  clkads11,
	aclr  =>  aclrads11,
	ena  =>  enaads11,
	dataout  =>  addnsub1_pipe_int,
	async  =>   modesel(3)
	);
	addnsub1_pipe <= addnsub1_pipe_int(0);

   -- SECOND SET OF PIPELINE REGISTERS
	signa_reg_inst2: mux41_spc	 port map(MO =>  clksa2, INP =>  clk, S0 =>  modesel(46), S1 =>  modesel(47), PASSN =>  modesel(45));
	signa_clr_inst2: mux41_spc	 port map(MO =>  aclrsa2, INP =>  aclr, S0 =>  modesel(61), S1 =>  modesel(62), PASSN =>  modesel(60));
	signa_ena_inst2: mux41_spc	 port map(MO =>  enasa2, INP =>  ena, S0 =>  modesel(46), S1 =>  modesel(47), PASSN =>  modesel(45));
   
	signa_pipe_int2(0) <= signa_pipe;
   signa_mac_pipeline_reg : stratix_mac_register	 port map(
	data  =>  signa_pipe_int2,
	clk  =>  clksa2,
	aclr  =>  aclrsa2,
	ena  =>  enasa2,
	dataout  =>  signa_out_int,
	async  =>   modesel(45)
	);
	signa_out <= signa_out_int(0);

	signb_reg_inst2: mux41_spc	 port map(MO =>  clksb2, INP =>  clk, S0 =>  modesel(49), S1 =>  modesel(50), PASSN =>  modesel(48));
	signb_clr_inst2: mux41_spc	 port map(MO =>  aclrsb2, INP =>  aclr, S0 =>  modesel(64), S1 =>  modesel(65), PASSN =>  modesel(63));
	signb_ena_inst2: mux41_spc	 port map(MO =>  enasb2, INP =>  ena, S0 =>  modesel(49), S1 =>  modesel(50), PASSN =>  modesel(48));

	signb_pipe_int2(0) <= signb_pipe;
   signb_mac_pipeline_reg : stratix_mac_register	 port map(
	data  =>  signb_pipe_int2,
	clk  =>  clksb2,
	aclr  =>  aclrsb2,
	ena  =>  enasb2,
	dataout  =>  signb_out_int,
	async  =>   modesel(48)
	);
	signb_out <= signb_out_int(0);

	zeroacc_reg_inst2: mux41_spc	 port map(MO =>  clkz2, INP =>  clk, S0 =>  modesel(43), S1 =>  modesel(44), PASSN =>  modesel(42));
	zeroacc_clr_inst2: mux41_spc	 port map(MO =>  aclrz2, INP =>  aclr, S0 =>  modesel(58), S1 =>  modesel(59), PASSN =>  modesel(57));
	zeroacc_ena_inst2: mux41_spc	 port map(MO =>  enaz2, INP =>  ena, S0 =>  modesel(43), S1 =>  modesel(44), PASSN =>  modesel(42));

	zeroacc_pipe_int2(0) <= zeroacc_pipe;
   zeroacc_mac_pipeline_reg : stratix_mac_register	 port map(
	data  =>  zeroacc_pipe_int2,
	clk  =>  clkz2,
	aclr  =>  aclrz2,
	ena  =>  enaz2,
	dataout  =>  zeroacc_out_int,
	async  =>   modesel(42)
	);
	zeroacc_out <= zeroacc_out_int(0);

	addnsub0_reg_inst2: mux41_spc	port map(MO =>  clkads02, INP =>  clk, S0 =>  modesel(37), S1 =>  modesel(38), PASSN =>  modesel(36));
	addnsub0_clr_inst2: mux41_spc	 port map(MO =>  aclrads02, INP =>  aclr, S0 =>  modesel(52), S1 =>  modesel(53), PASSN =>  modesel(51));
	addnsub0_ena_inst2: mux41_spc	 port map(MO =>  enaads02, INP =>  ena, S0 =>  modesel(37), S1 =>  modesel(38), PASSN =>  modesel(36));

	addnsub0_pipe_int2(0) <= addnsub0_pipe;
   addnsub0_mac_pipeline_reg : stratix_mac_register	 port map(
	data  =>  addnsub0_pipe_int2,
	clk  =>  clkads02,
	aclr  =>  aclrads02,
	ena  =>  enaads02,
	dataout  =>  addnsub0_out_int,
	async  =>   modesel(36)
	);
	addnsub0_out <= addnsub0_out_int(0);

	addnsub1_reg_inst2: mux41_spc	 port map(MO =>  clkads12, INP =>  clk, S0 =>  modesel(40), S1 =>  modesel(41), PASSN =>  modesel(39));
	addnsub1_clr_inst2: mux41_spc	 port map(MO =>  aclrads12, INP =>  aclr, S0 =>  modesel(55), S1 =>  modesel(56), PASSN =>  modesel(54));
	addnsub1_ena_inst2: mux41_spc	 port map(MO =>  enaads12, INP =>  ena, S0 =>  modesel(40), S1 =>  modesel(41), PASSN =>  modesel(39));

	addnsub1_pipe_int2(0) <= addnsub1_pipe;
   addnsub1_mac_pipeline_reg : stratix_mac_register	 port map(
	data  =>  addnsub1_pipe_int2,
	clk  =>  clkads12,
	aclr  =>  aclrads12,
	ena  =>  enaads12,
	dataout  =>  addnsub1_out_int,
	async  =>   modesel(39)
	);
	addnsub1_out <= addnsub1_out_int(0);

-- MAIN ADDER MODULE
mac_adder : stratix_mac_out_internal  port map(
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
	feedback =>	 dataout_reg,
	dataout  =>  dataout_wire,
	accoverflow  =>  accoverflow_wire
	);

	dataout_reg_inst: mux41_spc	 port map(MO =>  clkout, INP =>  clk, S0 =>  modesel(16), S1 =>  modesel(17), PASSN =>  modesel(15));
	dataout_clr_inst: mux41_spc	 port map(MO =>  aclrout, INP =>  aclr, S0 =>  modesel(34), S1 =>  modesel(35), PASSN =>  modesel(33));
	dataout_ena_inst: mux41_spc	 port map(MO =>  enaout, INP =>  ena, S0 =>  modesel(16), S1 =>  modesel(17), PASSN =>  modesel(15));
   dataout_out_reg : stratix_mac_register	 port map(
	data  =>  dataout_wire, 
	clk  =>  clkout,
	aclr  =>  aclrout,
	ena  =>  enaout,
	dataout  =>  dataout_reg,  
	async  =>   modesel(15)
	);
	dataout <= dataout_reg;

	-- selection for accoverflow same as output register when overflow is used
	and2_clk: AND2  port map( Y => clkaccout, IN1 => clkout, IN2 => modesel(66));
	and2_aclr: AND2  port map( Y => aclraccout, IN1 => aclrout, IN2 => modesel(66));
	and2_ena: AND2  port map( Y => enaaccout, IN1 => enaout, IN2 => modesel(66));

	accoverflow_wire_int(0) <= accoverflow_wire;
   accoverflow_out_reg : stratix_mac_register	 port map(
	data  =>  accoverflow_wire_int,
	clk  =>  clkaccout,
	aclr  =>  aclraccout,
	ena  =>  enaaccout,
	dataout  =>  accoverflow_int, 
	async  =>   modesel(20)
	);
	accoverflow <= accoverflow_int(0);

end structure;

--
-- stratix_RAM_BLOCK
--
library ieee;
use ieee.std_logic_1164.all;


entity  stratix_ram_block is
    port (
		portadatain		: in std_logic_vector(143 downto 0);
		portaaddr		: in std_logic_vector(15 downto 0);
		portawe		: in std_logic;
		modesel		: in std_logic_vector(40 downto 0);
		portbdatain		: in std_logic_vector(71 downto 0);
		portbaddr		: in std_logic_vector(15 downto 0);
		portbrewe		: in std_logic;
		clk0, clk1		: in std_logic;
		ena0, ena1		: in std_logic;
		clr0, clr1		: in std_logic;
		portabyteenamasks		: in std_logic_vector(15 downto 0);
		portbbyteenamasks		: in std_logic_vector(15 downto 0);
		portadataout		: out std_logic_vector(143 downto 0);
		portbdataout		: out std_logic_vector(143 downto 0));
end stratix_ram_block;

architecture structure of stratix_ram_block is

component mux21_spc
          port (
                IN0 : in std_logic;
                IN1 : in std_logic;
                S : in std_logic;
                PASS : in std_logic;
                MO : out std_logic);
end component;
component stratix_core_mem
    port (
		portadatain		: in std_logic_vector(143 downto 0);
		portaaddr		: in std_logic_vector(15 downto 0);
		portawe		: in std_logic;
		portaclk		: in std_logic;
		portaclr		: in std_logic;
		portaena		: in std_logic;
		modesel		: in std_logic_vector(40 downto 0);
		portbdatain		: in std_logic_vector(71 downto 0);
		portabyteenamasks		: in std_logic_vector(15 downto 0);
		portbbyteenamasks		: in std_logic_vector(15 downto 0);
		portbaddr		: in std_logic_vector(15 downto 0);
		portbrewe		: in std_logic;
		portb_datain_clk		: in std_logic;
		portb_addr_clk		: in std_logic;
		portb_rewe_clk		: in std_logic;
		portb_byte_enable_clk		: in std_logic;
		portb_datain_ena		: in std_logic;
		portb_addr_ena		: in std_logic;
		portb_rewe_ena		: in std_logic;
		portb_byte_enable_ena		: in std_logic;
		portb_datain_clr		: in std_logic;
		portb_addr_clr		: in std_logic;
		portb_rewe_clr		: in std_logic;
		portb_byte_enable_clr		: in std_logic;
		portadataout		: out std_logic_vector(143 downto 0);
		portbdataout		: out std_logic_vector(143 downto 0));
end component;

component stratix_memory_register
    port (
		data		: in std_logic_vector(143 downto 0);
		clk, aclr, ena, async		: in std_logic;
		dataout		: out std_logic_vector(143 downto 0));
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

	signal porta_clk, porta_clr, porta_ena : std_logic;
	signal porta_dataout : std_logic_vector(143 downto 0);
	signal porta_falling_edge_feedthru : std_logic_vector(143 downto 0); 
	signal portb_datain_clk, portb_addr_clk, portb_rewe_clk : std_logic; 
	signal portb_datain_ena, portb_addr_ena, portb_rewe_ena : std_logic; 
	signal portb_datain_clr, portb_addr_clr, portb_rewe_clr : std_logic; 
	signal portb_dataout : std_logic_vector(143 downto 0);
	signal portb_falling_edge_feedthru : std_logic_vector(143 downto 0);
	signal portb_byte_enable_clk, portb_byte_enable_clr, porta_out_clk_none : std_logic;
	signal select_porta_out_clk01, porta_out_clk_exists : std_logic;
	signal select_porta_out_clr01, porta_out_clr_exists : std_logic;
	signal select_portb_out_clk01, portb_out_clk_exists, portb_out_clk_none : std_logic;
	signal select_portb_out_clr01, portb_out_clr_exists : std_logic;

	signal select_portb_datain_clr01 : std_logic;
	signal select_portb_addr_clr01 : std_logic;
	signal select_portb_rewe_clk01, select_portb_rewe_clr01 : std_logic;
	signal select_portb_byte_enable_clr01 : std_logic;
	signal portb_byte_enable_clr_exists : std_logic;
	signal portb_rewe_clr_exists : std_logic;

	signal outb_clr, outb_clk, outa_clr, outa_clk : std_logic;
	signal outa_ena, outb_ena : std_logic;
	signal outclk_inv : std_logic;
	signal portb_datain_clr_exists, portb_addr_clr_exists: std_logic;
	
	signal vcc : std_logic;
begin

	vcc <= '1';
	-- porta control signals are fixed
	porta_clk <= clk0;
	porta_clr <= clr0;
	porta_ena <= ena0;

	-- this clock select also selects all other register clocks
	--  since same clock has to be used on all registers on port b
	select_portb_rewe_clk01 <= modesel(21);


	-- select_* signals choose one of two clears
	select_portb_datain_clr01 <= modesel(17);
	select_portb_addr_clr01 <= modesel(20);
	select_portb_byte_enable_clr01 <= modesel(26);
	select_portb_rewe_clr01 <= modesel(23);

	-- *_exists signals determine whether to pass above selected clear signal through
	-- portb_datain_clr_exists = datain_clr = clr0 || clr1
	modesel_or_5: OR2    port map(Y =>  portb_datain_clr_exists, IN1 =>  modesel(16), IN2 =>  modesel(17));
	
	-- portb_addr_clr_exists = addr_in_clr = clr0 || clr1
	modesel_or_6: OR2    port map(Y =>  portb_addr_clr_exists, IN1 =>  modesel(19), IN2 =>  modesel(20));


	-- portb_rewe_clr_exists = re/we_in_clr = clr0 || clr1
	modesel_or_7: OR2    port map(Y =>  portb_rewe_clr_exists, IN1 =>  modesel(22), IN2 =>  modesel(23));


	-- portb_byte_enable_clr_exists = addr_in_clr = clr0 || clr1
	modesel_or_8: OR2    port map(Y =>  portb_byte_enable_clr_exists, IN1 =>  modesel(25), IN2 =>  modesel(26));


	-- PORT B DATAIN CLR 
	select_portb_datain_clr: mux21_spc  port map( MO =>  portb_datain_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_datain_clr01, 
	                     PASS =>  portb_datain_clr_exists);

	-- PORT B ADDR CLR 
	select_portb_addr_clr: mux21_spc port map( MO =>  portb_addr_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_addr_clr01, 
	                     PASS =>  portb_addr_clr_exists);

	-- PORT B BYTEENABLE CLR 
	select_portb_byte_enable_clr: mux21_spc  port map( MO =>  portb_byte_enable_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_byte_enable_clr01, 
	                     PASS =>  portb_byte_enable_clr_exists);

	-- PORT B READ/WRITE ENABLE REGISTER selection
	-- Note: CLK & ENA selections here apply to all registers, since
	-- all of them can have same clock and enable.
	select_portb_rewe_clk: mux21_spc port map( MO =>  portb_rewe_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_portb_rewe_clk01, 
	                     PASS =>  vcc);
	-- ena selection follows clk selection
	select_portb_rewe_ena: mux21_spc  port map( MO =>  portb_rewe_ena, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_portb_rewe_clk01, 
	                     PASS =>  vcc);
	select_portb_rewe_clr: mux21_spc  port map( MO =>  portb_rewe_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_rewe_clr01, 
	                     PASS =>  portb_rewe_clr_exists);


	-- internal synchronous memory: includes all input registers, but not 
	-- 											the output registers
  stratixmem  : stratix_core_mem	 
       port map(portadatain =>  portadatain, 
       portaaddr =>  portaaddr, 
       portawe =>  portawe, 
       portaclk =>  porta_clk, 
       portaclr =>  porta_clr, 
       portaena =>  porta_ena, 
       portadataout =>  porta_dataout,
       portabyteenamasks =>  portabyteenamasks,
       modesel =>  modesel,
       portbdatain =>  portbdatain, 
       portbaddr =>  portbaddr, 
       portbrewe =>  portbrewe, 
       portb_datain_clk =>  portb_rewe_clk, 
       portb_addr_clk =>  portb_rewe_clk, 
       portb_rewe_clk =>  portb_rewe_clk, 
       portb_datain_ena =>  portb_rewe_ena, 
       portb_addr_ena =>  portb_rewe_ena, 
       portb_rewe_ena =>  portb_rewe_ena, 
       portb_datain_clr =>  portb_datain_clr, 
       portb_addr_clr =>  portb_addr_clr, 
       portb_rewe_clr =>  portb_rewe_clr, 
       portbdataout =>  portb_dataout,
       portbbyteenamasks =>  portbbyteenamasks,
       portb_byte_enable_clk =>  portb_rewe_clk, 
       portb_byte_enable_ena =>  portb_rewe_ena, 
      portb_byte_enable_clr =>  portb_byte_enable_clr
       );


	select_porta_out_clk01 <= modesel(12); 
	-- { this is modesel for porta outclock = clk1 }

	-- porta_out_clk_exists = porta outclock= clk0 or clk1
	modesel_or_1: OR2    port map(Y =>  porta_out_clk_exists, IN1 =>  modesel(11), IN2 =>  modesel(12));
	modesel_or_1_inv: INV  port map(Y =>  porta_out_clk_none, IN1 =>  porta_out_clk_exists);
	
	-- porta_out_clr_exists = porta outclr= clr0 or clr1
	modesel_or_2: OR2    port map(Y =>  porta_out_clr_exists, IN1 =>  modesel(13), IN2 =>  modesel(14));



	select_portb_out_clk01 <= modesel(28); 
	-- { this is modesel for portb outclock = clk1 }

	-- portb_out_clk_exists = portb outclock= clk0 or clk1
	modesel_or_3: OR2    port map(Y =>  portb_out_clk_exists, IN1 =>  modesel(27), IN2 =>  modesel(28));
	modesel_or_3_inv: INV  port map(Y =>  portb_out_clk_none, IN1 =>  portb_out_clk_exists);
	
	-- portb_out_clr_exists = portb outclr= clr0 or clr1
	modesel_or_4: OR2    port map(Y =>  portb_out_clr_exists, IN1 =>  modesel(29), IN2 =>  modesel(30));


	-- PORT A OUTPUT REGISTER selection


	select_porta_out_clk: mux21_spc  port map( MO =>  outa_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_porta_out_clk01, 
	                     PASS =>  porta_out_clk_exists);
	-- ena selection follows clk selection
	select_porta_out_ena: mux21_spc  port map( MO =>  outa_ena, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_porta_out_clk01, 
	                     PASS =>  porta_out_clk_exists);
	select_porta_out_clr: mux21_spc  port map( MO =>  outa_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_porta_out_clr01, 
	                     PASS =>  porta_out_clr_exists);


	-- PORT B OUTPUT REGISTER selection
	select_portb_out_clk: mux21_spc  port map( MO =>  outb_clk, IN0 =>  clk0, IN1 =>  clk1, 
	                     S =>  select_portb_out_clk01, 
	                     PASS =>  portb_out_clk_exists);
	-- ena selection follows clk selection
	select_portb_out_ena: mux21_spc  port map( MO =>  outb_ena, IN0 =>  ena0, IN1 =>  ena1, 
	                     S =>  select_portb_out_clk01, 
	                     PASS =>  portb_out_clk_exists);
	select_portb_out_clr: mux21_spc  port map( MO =>  outb_clr, IN0 =>  clr0, IN1 =>  clr1, 
	                     S =>  select_portb_out_clr01, 
	                     PASS =>  portb_out_clr_exists);


porta_ram_output_reg: stratix_memory_register 	
		 port map(data =>  porta_dataout,
		 clk =>  outa_clk, 
		 aclr =>  outa_clr, 
		 ena =>  outa_ena, 
		 async =>  porta_out_clk_none, 
		 dataout =>  portadataout 
		);

portb_ram_output_reg: stratix_memory_register 	
		 port map(data =>  portb_dataout,
		 clk =>  outb_clk, 
		 aclr =>  outb_clr, 
		 ena =>  outb_ena, 
		 async =>  portb_out_clk_none, 
		 dataout =>  portbdataout 
		);


end structure;


