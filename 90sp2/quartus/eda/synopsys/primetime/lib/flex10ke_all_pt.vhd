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

entity flex10ke_lcell is
  port (clk     : in std_logic;
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        aclr    : in std_logic;
        aload : in std_logic;
        cin   : in std_logic;
        cascin     : in std_logic;
        modesel   : in std_logic_vector(6 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end flex10ke_lcell;
        
architecture vital_le_atom of flex10ke_lcell is

signal dffin : std_logic;
signal qfbk  : std_logic;

component flex10ke_asynch_lcell 
  port (
        dataa     : in std_logic;
        datab     : in std_logic;
        datac     : in std_logic;
        datad     : in std_logic;
        cin       : in std_logic;
        cascin    : in std_logic;
        qfbkin    : in std_logic;
        modesel   : in std_logic_vector(6 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        combout   : out std_logic;
        cout      : out std_logic;
        cascout   : out std_logic;
        regin     : out std_logic);
end component;

component flex10ke_lcell_register
  port (clk     : in std_logic;
        datain     : in std_logic;
        dataa     : in std_logic;
        datab     : in std_logic;
        datad     : in std_logic;
        datac     : in std_logic;
        aclr    : in std_logic;
        aload : in std_logic;
        modesel   : in std_logic_vector(6 downto 0);
        pathsel   : in std_logic_vector(9 downto 0);
        regout    : out std_logic;
        qfbko     : out std_logic);
end component;

begin

lecomb: flex10ke_asynch_lcell
        port map (dataa => dataa, datab => datab, datac => datac, datad => datad,
                  cin => cin, cascin => cascin, qfbkin => qfbk, modesel => modesel, pathsel => pathsel,
                  combout => combout, cout => cout, cascout => cascout, regin => dffin);

lereg: flex10ke_lcell_register
  	port map (clk => clk, datain => dffin, dataa => dataa, datab =>datab, datad => datad, datac => datac, 
                  aclr => aclr, aload => aload, modesel => modesel, pathsel => pathsel, 
                  regout => regout,
                  qfbko => qfbk);


end vital_le_atom;


library IEEE;
use IEEE.std_logic_1164.all;

entity  flex10ke_io is
    port ( datain : in std_logic;
          clk     : in std_logic;
          aclr     : in std_logic;
          ena     : in std_logic;
          oe     : in std_logic;
          modesel : in std_logic_vector(10 downto 0);
          padio  : inout std_logic;
          dataout  : out std_logic);

end flex10ke_io;

architecture arch of flex10ke_io is

   signal comb_out, ioreg_clr, dffeD, dffeQ : std_logic;
	signal vcc : std_logic;

component flex10ke_asynch_io
    port (datain : in std_logic;
          oe   : in std_logic;
          dffeQ   : in std_logic;
          modesel : in std_logic_vector(10 downto 0);
          padio  : inout std_logic;
          dataout  : out std_logic;
          dffeD  : out std_logic);
end component;

component INV
          port (
                IN1 : in std_logic;
                Y : out std_logic);
end component;

component dffe

   port(
      Q                              :  out   STD_LOGIC := '0';
      D                              :  in    STD_LOGIC := '1';
      CLRN                           :  in    STD_LOGIC := '1';
      PRN                            :  in    STD_LOGIC := '1';
      CLK                            :  in    STD_LOGIC := '0';
      ENA                            :  in    STD_LOGIC := '1');
end component;

begin

vcc <= '1';

inv_1 : INV
    port map ( Y => ioreg_clr, IN1 => aclr);

inst1: flex10ke_asynch_io
     port map (datain => datain, oe => oe, padio => padio, dffeD => dffeD,
                           dffeQ => dffeQ, dataout => dataout, modesel => modesel);

io_reg: dffe
      port map (D => dffeD, clk => clk, ena => ena, Q => dffeQ,
              CLRN => ioreg_clr, PRN => vcc);
end arch;


library IEEE;
use IEEE.std_logic_1164.all;

entity  flex10ke_ram_slice is
    port (datain, clk0, clk1, clr0, ena0, ena1, 
          we, re: in std_logic;
          raddr, waddr: in std_logic_vector(10 downto 0);
          modesel : in std_logic_vector(15 downto 0) := (OTHERS => '0');
          dataout : out std_logic);
end flex10ke_ram_slice;

architecture structure of flex10ke_ram_slice is
   signal  datain_reg, we_reg, re_reg, dataout_reg : std_logic;
   signal  raddr_reg, waddr_reg : std_logic_vector(10 downto 0);
   signal  datain_int, we_int, re_int, dataout_int : std_logic;
   signal  raddr_int, waddr_int : std_logic_vector(10 downto 0);
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
   signal  waddr_reg_sel, we_reg_clr_sel, waddr_reg_clr, we_reg_mux_delayed: std_logic;
   signal  waddr_reg_clr_sel, we_reg_clr, we_reg_mux : std_logic;
   signal  dinreg_clr, wereg_clr, waddrreg_clr, clk0_delayed_inv, rereg_clr, dataoutreg_clr, raddrreg_clr: std_logic;
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

component bmux21_11
          port (
                A : in std_logic_vector(10 downto 0) := (OTHERS => '0');
                B : in std_logic_vector(10 downto 0) := (OTHERS => '0');
                S : in std_logic := '0';
                MO : out std_logic_vector(10 downto 0));
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

component flex10ke_asynch_mem

          port (datain : in std_logic := '0';
                we : in std_logic := '0';
                re : in std_logic := '0';
                raddr : in std_logic_vector(10 downto 0) := (OTHERS => '0');
                waddr : in std_logic_vector(10 downto 0) := (OTHERS => '0');
                modesel : in std_logic_vector(15 downto 0);
                dataout : out std_logic);
end component;
 
begin     

vcc <= '1';
gnd <= '0';

datain_reg_sel 	 	<= modesel(0);
datain_reg_clr_sel   	<= modesel(1);
write_reg_sel 	 	<= modesel(2);
waddr_reg_clr_sel	<= modesel(15);
we_reg_clr_sel		<= modesel(3);
raddr_reg_sel   	<= modesel(4);
raddr_reg_clr_sel	<= modesel(5);
re_reg_sel 	 	<= modesel(6);
re_reg_clr_sel	 	<= modesel(7);
dataout_reg_sel  	<= modesel(8);
dataout_reg_clr_sel  	<= modesel(9);
re_clk_sel 	 	<= modesel(10);
re_en_sel 	 	<= modesel(10);
raddr_clk_sel 	 	<= modesel(11);
raddr_en_sel 	 	<= modesel(11);
dataout_en_sel   	<= modesel(12);

datainsel: mux21 

           port map (A => datain, B => datain_reg, S => datain_reg_sel, 
                     MO => datain_int);

datainregclr: nmux21

           port map (A => NC, B => clr0, S => datain_reg_clr_sel,
                     MO => datain_reg_clr);

waddrsel: bmux21_11 

           port map (A => waddr, B => waddr_reg, S => write_reg_sel, 
                     MO => waddr_int);

waddrregclr: nmux21
	   port map (A => NC, B => clr0, S => waddr_reg_clr_sel,
                     MO => waddr_reg_clr);
weregclr: nmux21
	   port map (A => NC, B => clr0, S => we_reg_clr_sel,
                     MO => we_reg_clr);


wesel2: mux21
           port map (A => we_reg_mux_delayed, B => we_pulse, S => write_reg_sel,
                     MO => we_int);

wesel1: mux21
           port map (A => we, B => we_reg, S => write_reg_sel,
                     MO => we_reg_mux);

raddrsel: bmux21_11
	   port map (A => raddr, B => raddr_reg, S => raddr_reg_sel,
                     MO => raddr_int);

raddrregclr: nmux21
           port map (A => NC, B => clr0, S => raddr_reg_clr_sel,
                     MO => raddr_reg_clr);

resel: mux21
           port map (A => re, B => re_reg, S => re_reg_sel,
                     MO => re_int); 
 
dataoutsel: mux21
           port map (A => dataout_int, B => dataout_reg, S => dataout_reg_sel,
                     MO => dataout); 
 
dataoutregclr: nmux21
           port map (A => NC, B => clr0, S => dataout_reg_clr_sel,
                     MO => dataout_reg_clr);

raddrclksel: mux21
           port map (A => clk0, B => clk1, S => raddr_clk_sel,
                     MO => raddr_clk); 

raddrensel: mux21
           port map (A => ena0, B => ena1, S => raddr_en_sel,
                     MO => raddren); 
  

reclksel: mux21
           port map (A => clk0, B => clk1, S => re_clk_sel,
                     MO => re_clk); 
  
reensel: mux21
           port map (A => ena0, B => ena1, S => re_en_sel,
                     MO => reen); 
  

reregclr: nmux21
	   port map (A => NC, B => clr0, S => re_reg_clr_sel,
                     MO => re_reg_clr);

  
dataoutensel: mux21
           port map (A => NC, B => ena1, S => dataout_en_sel,
                     MO => dataouten); 



dinreg_clr <= datain_reg_clr;
dinreg: dffe
         port map (D => datain, CLRN => dinreg_clr, PRN => vcc, CLK => clk0,
                       ENA => ena0, Q => datain_reg);

wereg_clr <= we_reg_clr;
waddrreg_clr <= waddr_reg_clr;

wereg: dffe 
         port map (D => we, CLRN => wereg_clr, PRN => vcc, CLK => clk0,
                       ENA => ena0, Q => we_reg);

pt_and2_1: AND2
			port map (Y => we_pulse, IN1 => clk0_delayed_inv, IN2 => we_reg_mux_delayed);

wedelaybuf: and1
        port map (IN1 => we_reg_mux, Y => we_reg_mux_delayed);

clk0weregdelaybuf: and1
        port map (IN1 => clk0, Y => clk0_delayed);

pt_inv_1: INV
			port map (Y => clk0_delayed_inv, IN1 => clk0_delayed);


rereg_clr <= re_reg_clr;
rereg: dffe 
         port map (D => re, CLRN => rereg_clr, PRN => vcc, CLK => re_clk,
                       ENA => reen, Q => re_reg);

dataoutreg_clr <= dataout_reg_clr;
dataoutreg: dffe 
         port map (D => dataout_int, PRN => vcc, CLRN => dataoutreg_clr, 
                   CLK => clk1, ENA => dataouten, Q => dataout_reg);


waddrreg_0: dffe 
          port map (D => waddr(0), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(0));

waddrreg_1: dffe 
          port map (D => waddr(1), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(1));

waddrreg_2: dffe 
          port map (D => waddr(2), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(2));

waddrreg_3: dffe 
          port map (D => waddr(3), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(3));

waddrreg_4: dffe 
          port map (D => waddr(4), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(4));

waddrreg_5: dffe 
          port map (D => waddr(5), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(5));

waddrreg_6: dffe 
          port map (D => waddr(6), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(6));

waddrreg_7: dffe 
          port map (D => waddr(7), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(7));

waddrreg_8: dffe 
          port map (D => waddr(8), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(8));

waddrreg_9: dffe 
          port map (D => waddr(9), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(9));

waddrreg_10: dffe 
          port map (D => waddr(10), PRN => vcc, CLRN => waddrreg_clr, CLK => clk0,
                       ENA => ena0, Q => waddr_reg(10));






raddrreg_clr <= raddr_reg_clr;
raddrreg_0: dffe 
          port map (D => raddr(0),  PRN => vcc,CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(0));

raddrreg_1: dffe 
          port map (D => raddr(1), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(1));

raddrreg_2: dffe 
          port map (D => raddr(2), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(2));

raddrreg_3: dffe 
          port map (D => raddr(3), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(3));

raddrreg_4: dffe 
          port map (D => raddr(4), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(4));

raddrreg_5: dffe 
          port map (D => raddr(5), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(5));

raddrreg_6: dffe 
          port map (D => raddr(6), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(6));

raddrreg_7: dffe 
          port map (D => raddr(7), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(7));

raddrreg_8: dffe 
          port map (D => raddr(8), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(8));

raddrreg_9: dffe 
          port map (D => raddr(9), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(9));

raddrreg_10: dffe 
          port map (D => raddr(10), PRN => vcc, CLRN => raddrreg_clr, CLK => raddr_clk,
                       ENA => raddren, Q => raddr_reg(10));

flexmem: flex10ke_asynch_mem

	  port map (DATAIN => datain_int, WE => we_int, RE => re_int,
                    RADDR => raddr_int, WADDR => waddr_int, 
                    MODESEL => modesel, DATAOUT => dataout_int);

end structure;
