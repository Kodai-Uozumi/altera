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

entity apex20k_lcell is
  port (clk     : in std_logic;
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        aclr    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        ena : in std_logic;
        cin   : in std_logic;
        cascin     : in std_logic;
        modesel   : in std_logic_vector(8 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end apex20k_lcell;
        
architecture vital_le_atom of apex20k_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

component apex20k_asynch_lcell 
  port (
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        cin       : in std_logic;
        cascin    : in std_logic;
        qfbkin    : in std_logic;
        modesel   : in std_logic_vector(8 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        combout   : out std_logic;
        cout      : out std_logic;
        cascout   : out std_logic;
        regin     : out std_logic);
end component;

component apex20k_lcell_register
  port (clk     : in std_logic;
        datain     : in std_logic;
        datac     : in std_logic;
        aclr    : in std_logic;
        sclr : in std_logic;
        sload : in std_logic;
        ena : in std_logic;
        modesel   : in std_logic_vector(8 downto 0);
        regout    : out std_logic;
        qfbko     : out std_logic);
end component;

begin

lecomb: apex20k_asynch_lcell
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cascin => cascin, qfbkin => qfbk, modesel => modesel, pathsel => pathsel,
                  combout => combout, cout => cout, cascout => cascout, regin => dffin);

lereg: apex20k_lcell_register
  	port map (clk => clk, datain => dffin, datac => datac, modesel => modesel,
                  aclr => aclr, sclr => sclr, sload => sload, ena => ena,
                   regout => regout,
                  qfbko => qfbk);


end vital_le_atom;


-- APEX20KE_IO
--
library IEEE;
use IEEE.std_logic_1164.all;

entity  apex20k_io is
    port (clk    : in std_logic;
          datain : in std_logic;
          aclr   : in std_logic;
          ena    : in std_logic;
          oe     : in std_logic;
          modesel : in std_logic_vector(11 downto 0);
          padio  : inout std_logic;
          combout : out std_logic;
          regout  : out std_logic);

end apex20k_io;

architecture arch of apex20k_io is

   signal reg_clr, reg_pre : std_logic;
   signal ioreg_clr, ioreg_pre : std_logic;
   signal dffeD : std_logic;
   signal comb_out, reg_out : std_logic;
   signal dffe_Q : std_logic;
	signal vcc : std_logic;

component dffe_io
   port(
      Q                              :  out   STD_LOGIC;
      D                              :  in    STD_LOGIC;
      CLRN                           :  in    STD_LOGIC;
      PRN                            :  in    STD_LOGIC;
      CLK                            :  in    STD_LOGIC;
      ENA                            :  in    STD_LOGIC);
end component;

component apex20k_asynch_io
    port (datain : in std_logic;
          dffeQ : in std_logic;
          oe   : in std_logic;
          modesel : in std_logic_vector(11 downto 0);
          padio  : inout std_logic;
          dffeD : out std_logic;
          combout : out std_logic;
          regout  : out std_logic);
end component;

component INV
   port(
      IN1   : in STD_LOGIC;
      Y    : out STD_LOGIC);
end component;
begin

vcc <= '1';

inv_1 : INV
    port map ( Y => ioreg_clr, IN1 => aclr);

asynch_inst: apex20k_asynch_io
     port map (datain => datain, oe => oe, padio => padio, 
                           dffeD => dffeD, dffeQ => dffe_Q, combout => combout,
                           regout => regout, modesel => modesel);

io_reg: dffe_io
      port map (D => dffeD, clk => clk, ena => ena, Q => dffe_Q,
              CLRN => ioreg_clr, PRN => vcc);

end arch;


library IEEE;
use IEEE.std_logic_1164.all;

entity  apex20k_ram_slice is
    port (datain, clk0, clk1, clr0, clr1, ena0, ena1, 
          we, re: in std_logic;
          raddr, waddr: in std_logic_vector(15 downto 0);
          modesel : in std_logic_vector(17 downto 0) := (OTHERS => '0');
          dataout : out std_logic);
end apex20k_ram_slice;

architecture structure of apex20k_ram_slice is
   signal  datain_reg, we_reg, re_reg, dataout_reg : std_logic;
   signal  raddr_reg, waddr_reg : std_logic_vector(15 downto 0);
   signal  datain_int, we_int, re_int, dataout_int : std_logic;
   signal  raddr_int, waddr_int : std_logic_vector(15 downto 0);
   signal  reen, raddren, dataouten : std_logic;
   signal  datain_clr : std_logic;
   signal  re_clk, re_clr, raddr_clk, raddr_clr : std_logic;
   signal  dataout_clk, dataout_clr : std_logic;
   signal  datain_reg_sel, write_reg_sel, raddr_reg_sel : std_logic;
   signal  re_reg_sel, dataout_reg_sel, re_clk_sel, re_en_sel : std_logic;
   signal  re_clr_sel, raddr_clk_sel, raddr_clr_sel, raddr_en_sel : std_logic;
   signal  dataout_clk_sel, dataout_clr_sel, dataout_en_sel : std_logic; 
   signal  datain_reg_clr, write_reg_clr, raddr_reg_clr : std_logic;
   signal  re_reg_clr, dataout_reg_clr : std_logic;
   signal  datain_reg_clr_sel, write_reg_clr_sel, raddr_reg_clr_sel: std_logic;
   signal  re_reg_clr_sel, dataout_reg_clr_sel : std_logic;
   signal  we_reg2, we_reg2_delayed, we_pulse, clk0_inv1, clk0_delayed: std_logic;
   signal  NC : std_logic;
   signal  vcc : std_logic;
   signal  gnd : std_logic;

component dffe

   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end component;


component mux21
          port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end component;

component nmux21
          port (
                A : in std_logic := '0';
                B : in std_logic := '0';
                S : in std_logic := '0';
                MO : out std_logic);
end component;

component bmux21
          port (
                A : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                S : in std_logic := '0';
                MO : out std_logic_vector(15 downto 0));
end component;

component INV
          port (
                IN1 : in std_logic;
                Y : out std_logic);
end component;

component AND1
          port (
                IN1 : in std_logic;
                Y : out std_logic);
end component;

component AND2
          port (
                IN1 : in std_logic;
                IN2 : in std_logic;
                Y : out std_logic);
end component;

component apex20k_asynch_mem

          port (datain : in std_logic := '0';
                we : in std_logic := '0';
                re : in std_logic := '0';
                raddr : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                waddr : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                modesel : in std_logic_vector(1 downto 0) := "00";
                dataout : out std_logic);
end component;
 
begin     

vcc <= '1';
gnd <= '0';

datain_reg_sel 	 	<= modesel(0);
datain_reg_clr_sel   	<= modesel(1);
write_reg_sel 	 	<= modesel(2);
write_reg_clr_sel	<= modesel(3);
raddr_reg_sel   	<= modesel(4);
raddr_reg_clr_sel	<= modesel(5);
re_reg_sel 	 	<= modesel(6);
re_reg_clr_sel	 	<= modesel(7);
dataout_reg_sel  	<= modesel(8);
dataout_reg_clr_sel  	<= modesel(9);
re_clk_sel 	 	<= modesel(10);
re_en_sel 	 	<= modesel(10);
re_clr_sel 	 	<= modesel(11);
raddr_clk_sel 	 	<= modesel(12);
raddr_en_sel 	 	<= modesel(12);
raddr_clr_sel 	 	<= modesel(13);
dataout_clk_sel  	<= modesel(14);
dataout_en_sel   	<= modesel(14);
dataout_clr_sel  	<= modesel(15);

datainsel: mux21 

           port map (A => datain, B => datain_reg, S => datain_reg_sel, 
                     MO => datain_int);

datainregclr: nmux21

           port map (A => NC, B => clr0, S => datain_reg_clr_sel,
                     MO => datain_reg_clr);

waddrsel: bmux21 

           port map (A => waddr, B => waddr_reg, S => write_reg_sel, 
                     MO => waddr_int);

writeregclr: nmux21

	   port map (A => NC, B => clr0, S => write_reg_clr_sel,
                     MO => write_reg_clr);

wesel2: mux21

           port map (A => we_reg2_delayed, B => we_pulse, S => write_reg_sel,
                     MO => we_int);

wesel1: mux21

           port map (A => we, B => we_reg, S => write_reg_sel,
                     MO => we_reg2);

raddrsel: bmux21

	   port map (A => raddr, B => raddr_reg, S => raddr_reg_sel,
                     MO => raddr_int);

raddrregclr: nmux21

           port map (A => NC, B => raddr_clr, S => raddr_reg_clr_sel,
                     MO => raddr_reg_clr);

resel: mux21

           port map (A => re, B => re_reg, S => re_reg_sel,
                     MO => re_int); 
 
dataoutsel: mux21

           port map (A => dataout_int, B => dataout_reg, S => dataout_reg_sel,
                     MO => dataout); 
 
dataoutregclr: nmux21
       
           port map (A => NC, B => dataout_clr, S => dataout_reg_clr_sel,
                     MO => dataout_reg_clr);

raddrclksel: mux21
 
           port map (A => clk0, B => clk1, S => raddr_clk_sel,
                     MO => raddr_clk); 

raddrensel: mux21
 
           port map (A => ena0, B => ena1, S => raddr_en_sel,
                     MO => raddren); 
  
raddrclrsel: nmux21
 
           port map (A => clr0, B => clr1, S => raddr_clr_sel,
                     MO => raddr_clr); 

reclksel: mux21
 
           port map (A => clk0, B => clk1, S => re_clk_sel,
                     MO => re_clk); 
  
reensel: mux21
 
           port map (A => ena0, B => ena1, S => re_en_sel,
                     MO => reen); 
  
reclrsel: nmux21
 
           port map (A => clr0, B => clr1, S => re_clr_sel,
                     MO => re_clr); 

reregclr: nmux21

	   port map (A => NC, B => re_clr, S => re_reg_clr_sel,
                     MO => re_reg_clr);

dataoutclksel: mux21
 
           port map (A => clk0, B => clk1, S => dataout_clk_sel,
                     MO => dataout_clk); 
  
dataoutensel: mux21
 
           port map (A => ena0, B => ena1, S => dataout_en_sel,
                     MO => dataouten); 
  
dataoutclrsel: nmux21
 
           port map (A => clr0, B => clr1, S => dataout_clr_sel,
                     MO => dataout_clr); 
  
dinreg: dffe 

         port map (D => datain, CLRN => datain_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => datain_reg);

wereg: dffe 

         port map (D => we, CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => we_reg);

pt_inv_1: INV

			port map (Y => clk0_inv1, IN1 => clk0_delayed);

clk0weregdelaybuf: AND1

        port map (Y => clk0_delayed, IN1 => clk0);

pt_and2_1: AND2

			port map (Y => we_pulse, IN1 => clk0_inv1, IN2 => we_reg2_delayed);

wedelaybuf: AND1

			port map (Y => we_reg2_delayed, IN1 => we_reg2);

rereg: dffe 

         port map (D => re, CLRN => re_reg_clr, CLK => re_clk,
                       ENA => reen, PRN => vcc, Q => re_reg);

dataoutreg: dffe 

         port map (D => dataout_int, CLRN => dataout_reg_clr, 
                   CLK => dataout_clk, PRN => vcc, ENA => dataouten, Q => dataout_reg);

waddrreg_0: dffe 
       
          port map (D => waddr(0), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(0));

waddrreg_1: dffe 
       
          port map (D => waddr(1), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(1));

waddrreg_2: dffe 
       
          port map (D => waddr(2), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(2));

waddrreg_3: dffe 
       
          port map (D => waddr(3), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(3));

waddrreg_4: dffe 
       
          port map (D => waddr(4), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(4));

waddrreg_5: dffe 
       
          port map (D => waddr(5), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(5));

waddrreg_6: dffe 
       
          port map (D => waddr(6), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(6));

waddrreg_7: dffe 
       
          port map (D => waddr(7), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(7));

waddrreg_8: dffe 
       
          port map (D => waddr(8), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(8));

waddrreg_9: dffe 
       
          port map (D => waddr(9), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(9));

waddrreg_10: dffe 
       
          port map (D => waddr(10), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(10));

waddrreg_11: dffe 
      
          port map (D => waddr(11), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(11));

waddrreg_12: dffe 
       
          port map (D => waddr(12), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(12));

waddrreg_13: dffe 
       
          port map (D => waddr(13), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(13));

waddrreg_14: dffe 
       
          port map (D => waddr(14), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(14));

waddrreg_15: dffe 
       
          port map (D => waddr(15), CLRN => write_reg_clr, CLK => clk0,
                       ENA => ena0, PRN => vcc, Q => waddr_reg(15));

raddrreg_0: dffe 
       
          port map (D => raddr(0), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(0));

raddrreg_1: dffe 
       
          port map (D => raddr(1), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(1));

raddrreg_2: dffe 
       
          port map (D => raddr(2), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(2));

raddrreg_3: dffe 
       
          port map (D => raddr(3), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(3));

raddrreg_4: dffe 
       
          port map (D => raddr(4), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(4));

raddrreg_5: dffe 
       
          port map (D => raddr(5), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(5));

raddrreg_6: dffe 
       
          port map (D => raddr(6), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(6));

raddrreg_7: dffe 
       
          port map (D => raddr(7), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(7));

raddrreg_8: dffe 
       
          port map (D => raddr(8), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(8));

raddrreg_9: dffe 
       
          port map (D => raddr(9), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(9));

raddrreg_10: dffe 
       
          port map (D => raddr(10), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(10));

raddrreg_11: dffe 
      
          port map (D => raddr(11), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(11));

raddrreg_12: dffe 
       
          port map (D => raddr(12), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(12));

raddrreg_13: dffe 
       
          port map (D => raddr(13), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(13));

raddrreg_14: dffe 
       
          port map (D => raddr(14), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(14));

raddrreg_15: dffe 
       
          port map (D => raddr(15), CLRN => raddr_reg_clr, CLK => raddr_clk,
                       ENA => raddren, PRN => vcc, Q => raddr_reg(15));

apexmem: apex20k_asynch_mem

	  port map (DATAIN => datain_int, WE => we_int, RE => re_int,
                    RADDR => raddr_int, WADDR => waddr_int, 
                    MODESEL => modesel(17 downto 16), DATAOUT => dataout_int);

end structure;


library IEEE;
use IEEE.std_logic_1164.all;

entity apex20k_pterm is

  port (pterm0	: in std_logic_vector(31 downto 0);
        pterm1  : in std_logic_vector(31 downto 0);
        pexpin	: in std_logic;
        clk	: in std_logic;
        ena 	: in std_logic;
		aclr	: in std_logic;
        modesel : in std_logic_vector(9 downto 0);
	dataout : out std_logic;
        pexpout : out std_logic );
end apex20k_pterm; 

architecture vital_pterm_atom of apex20k_pterm is

component apex20k_asynch_pterm
  port (pterm0	: in std_logic_vector(31 downto 0) := 
			"11111111111111111111111111111111";
        pterm1  : in std_logic_vector(31 downto 0) := 
			"11111111111111111111111111111111";
        pexpin	: in std_logic := '0';
        fbkin : in std_logic;
	combout : out std_logic;
        regin : out std_logic;
        modesel : in std_logic_vector(9 downto 0);
        pexpout : out std_logic );
end component; 

component apex20k_pterm_register
  port (
        datain	: in std_logic;
        clk	: in std_logic;
        ena 	: in std_logic;
	aclr	: in std_logic;
	regout : out std_logic;
        modesel : in std_logic_vector(9 downto 0);
        fbkout : out std_logic);
end component; 

component mux21
  port (
        A	: in std_logic;
        B	: in std_logic;
        S 	: in std_logic;
        MO : out std_logic);
end component; 

signal fbk, dffin, combo, dffo	:std_logic ;
signal modesel_tmp : std_logic;
begin

pcom: apex20k_asynch_pterm 
	port map ( pterm0 => pterm0, pterm1 => pterm1, pexpin => pexpin,
                   fbkin => fbk, regin => dffin, combout => combo, 
                   pexpout => pexpout, modesel => modesel);

preg: apex20k_pterm_register
	port map ( datain => dffin, clk => clk, ena => ena, aclr => aclr,
                   regout => dffo,
                   fbkout => fbk, modesel => modesel);	

--dataout <= combo when output_mode = "comb" else dffo;

modesel_tmp <= modesel(8);

mux21_inst1: mux21 
	port map ( MO => dataout, S => modesel_tmp, A => combo, B => dffo);

end vital_pterm_atom;

