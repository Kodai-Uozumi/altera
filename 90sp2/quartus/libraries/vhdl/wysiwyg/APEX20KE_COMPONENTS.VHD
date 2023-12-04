--
-- Copyright (C) 1988-2000 Altera Corporation
-- Any megafunction design, and related net list (encrypted or decrypted),
-- support information, device programming or simulation file, and any other
-- associated documentation or information provided by Altera or a partner
-- under Altera's Megafunction Partnership Program may be used only to
-- program PLD devices (but not masked PLD devices) from Altera.  Any other
-- use of such megafunction design, net list, support information, device
-- programming or simulation file, or any other related documentation or
-- information is prohibited for any other purpose, including, but not
-- limited to modification, reverse engineering, de-compiling, or use with
-- any other silicon devices, unless such use is explicitly licensed under
-- a separate agreement with Altera or a megafunction partner.  Title to
-- the intellectual property, including patents, copyrights, trademarks,
-- trade secrets, or maskworks, embodied in any such megafunction design,
-- net list, support information, device programming or simulation file, or
-- any other related documentation or information provided by Altera or a
-- megafunction partner, remains with Altera, the megafunction partner, or
-- their respective licensors.  No other licenses, including any licenses
-- needed under any third party's intellectual property, are provided herein.
--
-- FILENAME     :    apex20ke_components.vhd
-- FILE CONTENTS:    APEX20K VITAL Component Package (3.0)
-- DATE CREATED :    Tue Nov 17 17:43:50 PST 1998
--
-- LIBRARY      :    work
-- REVISION     :    QII 1.0
-- LOGIC SYSTEM :    IEEE-1164
-- NOTES        :
-- HISTORY      :
--
----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package APEX20KE_COMPONENTS is

component apex20ke_lcell
  generic (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      packed_mode   : string := "false";
      lut_mask       : string := "ffff";
      power_up : string := "low";
		lpm_type : string := "apex20ke_lcell";
	  cin_used       : string := "false");

  port (clk     : in std_logic := '0';
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        aclr    : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        cin   : in std_logic := '0';
        cascin     : in std_logic := '1';
        modesel : in std_logic_vector(7 downto 0) := "00000000";
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
end component;

component apex20ke_io 
   generic (operation_mode : string := "input";
      reg_source_mode :  string := "none";
      feedback_mode : string := "from_pin";
      power_up : string := "low";
		lpm_type : string := "apex20ke_io";
      open_drain_output : string := "false");

    port (clk    : in std_logic := '0';
          datain : in std_logic := '1';
          aclr   : in std_logic := '0';
          preset : in std_logic := '0';
          ena    : in std_logic := '1';
          oe     : in std_logic := '1';
          modesel : in std_logic_vector(11 downto 0) := "000000000000";
          padio  : inout std_logic;
          combout : out std_logic;
          regout  : out std_logic);

end component;

component apex20ke_pterm 
  generic (operation_mode     : string := "normal";
      output_mode        : string := "comb";
      invert_pterm1_mode : string := "false";
      power_up : string := "low";
      TimingChecksOn: Boolean := True;
		lpm_type : string := "apex20ke_pterm";
      InstancePath: STRING := "*" );


  port (pterm0  : in std_logic_vector(31 downto 0) := (OTHERS => '1');
        pterm1  : in std_logic_vector(31 downto 0) := (OTHERS => '1');
        pexpin  : in std_logic := '0';
        clk     : in std_logic := '0';
        ena     : in std_logic := '1';
        aclr    : in std_logic := '0';
        modesel : in std_logic_vector(9 downto 0) := "0000000000";
        dataout : out std_logic;
        pexpout : out std_logic );
end component;

component  apex20ke_ram_slice
    generic (operation_mode     : string := "single_port";
     deep_ram_mode       : string := "off";
     logical_ram_name    : string := "ram_xxx";
     logical_ram_depth   : integer := 2048;
     logical_ram_width   : integer:= 1;
     address_width       : integer:= 16;
     data_in_clock       : string := "none";
     data_in_clear       : string := "none";
     write_logic_clock   : string := "none";
     write_logic_clear   : string := "none";
     read_enable_clock   : string := "none";
     read_enable_clear   : string := "none";
     read_address_clock  : string := "none";
     read_address_clear  : string := "none";
     data_out_clock      : string := "none";
     data_out_clear      : string := "none";
     init_file           : string := "xxx";
     first_address       : integer:= 0;
     last_address        : integer:= 2047;
     bit_number          : integer:= 0;
     power_up      : string := "low";
		lpm_type : string := "apex20ke_ram_slice";
     mem1                : std_logic_vector(512 downto 1) := (OTHERS => '0');
     mem2                : std_logic_vector(512 downto 1) := (OTHERS => '0');
     mem3                : std_logic_vector(512 downto 1) := (OTHERS => '0');
     mem4                : std_logic_vector(512 downto 1) := (OTHERS => '0'));
    port (datain         : in std_logic := '0';
         clk0            : in std_logic := '0';
         clk1            : in std_logic := '0';
         clr0            : in std_logic := '0';
         clr1            : in std_logic := '0'; 
         ena0            : in std_logic := '1';
         ena1            : in std_logic := '1';
         we              : in std_logic := '0';
         re              : in std_logic := '1';
         raddr           : in std_logic_vector(15 downto 0) := (OTHERS => '0');
         waddr           : in std_logic_vector(15 downto 0) := (OTHERS => '0');
         modesel         : in std_logic_vector(17 downto 0) := (OTHERS => '0');
         dataout         : out std_logic);
end component;

component  apex20ke_cam_slice
    generic (
     operation_mode             : string := "encoded_address";
     logical_cam_name           : string := "cam_xxx";
     logical_cam_depth          : integer := 32;
     logical_cam_width          : integer:= 32;
     address_width              : integer:= 5;
     waddr_clear                : string := "none";
     write_enable_clear         : string := "none";
     write_logic_clock          : string := "none";
     write_logic_clear          : string := "none";
     output_clock               : string := "none";
     output_clear               : string := "none";
     init_file                  : string := "xxx";
     init_filex                 : string := "xxx";
     first_address              : integer:= 0;
     last_address               : integer:= 31;
     first_pattern_bit          : integer:= 1;
     pattern_width              : integer:= 32;
		lpm_type : string := "apex20ke_cam_slice";
     power_up             : string := "low" );
    port (clk0		: in std_logic := '0';
	  clk1		: in std_logic := '0';
	  clr0		: in std_logic := '0';
	  clr1		: in std_logic := '0';
	  ena0		: in std_logic := '1';
	  ena1		: in std_logic := '1';
          we		: in std_logic := '0';
	  datain	: in std_logic := '0';
	  wrinvert	: in std_logic := '0';
	  outputselect	: in std_logic := '0';
          waddr		: in std_logic_vector(4 downto 0) := (OTHERS => '0');
          lit		: in std_logic_vector(31 downto 0) := (OTHERS => '0');
          modesel : in std_logic_vector(9 downto 0) := (OTHERS => '0');
          matchout : out std_logic_vector(15 downto 0);
          matchfound : out std_logic);

end component;

component apex20ke_lvds_transmitter
    generic (
                channel_width           : integer := 8;
                TimingChecksOn          : Boolean := True;
		lpm_type : string := "apex20ke_lvds_transmitter";
                InstancePath            : String := "*" );

        port (
                clk0            : in std_logic;
                clk1            : in std_logic;
                datain          : in std_logic_vector(7 downto 0);
                dataout         : out std_logic);
end component;

component apex20ke_lvds_receiver
    generic (
                channel_width           : integer := 8;
                TimingChecksOn          : Boolean := True;
		lpm_type : string := "apex20ke_lvds_receiver";
                InstancePath            : String := "*" );

        port (
                clk0            : in std_logic;
                clk1            : in std_logic;
                datain          : in std_logic;
                deskewin        : in std_logic := '0';
                dataout         : out std_logic_vector(7 downto 0));
end component;

component apex20ke_pll
    generic (
                input_frequency         : integer  := 1000;
                operation_mode          : string := "normal";
                clk0_multiply_by        : integer := 1;
                clk0_divide_by          : integer := 1;
                clk1_multiply_by        : integer := 1;
                clk1_divide_by          : integer := 1;
                phase_shift             : integer := 0;
                effective_phase_shift   : integer := 0;
                effective_clk0_delay    : integer := 0;
                effective_clk1_delay    : integer := 0;
                lock_high               : integer := 1;
		invalid_lock_multiplier	: integer := 5;
		valid_lock_multiplier	: integer := 5;
		lpm_type : string := "apex20ke_pll";
                lock_low                : integer := 1 );

        port (
                clk : in std_logic;
                ena : in std_logic := '1';
                fbin : in std_logic := '0';
                clk0 : out std_logic;
                clk1 : out std_logic;
                locked : out std_logic);
end component;

component apex20ke_dpram
  generic ( 
            operation_mode                              : string;
            output_mode                                 : string;
            width                                       : integer;
            addrwidth                                   : integer;
            depth                                       : integer;
            ramblock                                    : integer                            := -1;
		lpm_type : string := "apex20ke_dpram";
            ramcontent                                  : string                             := "none");

  port (
         portaclk     : in  std_logic                     := '0';
         portaena     : in  std_logic                     := '0';
         portawe      : in  std_logic                     := '0';
         portaaddr    : in  std_logic_vector(addrwidth-1 downto 0) := (others => '0');
         portadatain  : in  std_logic_vector(width-1 downto 0) := (others => '0');
         portadataout : out std_logic_vector(width-1 downto 0) ;
         portbclk     : in  std_logic                     := '0';
         portbena     : in  std_logic                     := '0';
         portbwe      : in  std_logic                     := '0';
         portbaddr    : in  std_logic_vector(addrwidth-1 downto 0) := (others => '0');
         portbdatain  : in  std_logic_vector(width-1 downto 0) := (others => '0');
         portbdataout : out std_logic_vector(width-1 downto 0));

end component;


component apex20ke_upcore
  generic ( 
            processor   : string  := "arm";
            source      : string  := "";
            sdram_width : integer := 32;
            sdramdqm_width : integer := 4;
		lpm_type : string := "apex20ke_upcore";
            gpio_width  : integer := 4);

  port (
            clkref         : in  std_logic                      := '0';
            npor           : in  std_logic                      := '0';
            nreseti        : in  std_logic                      := '0';
            nreseto        : out std_logic                      ;
            nresetoe       : out std_logic                      ;

            intpld         : in  std_logic_vector ( 5 downto 0) := (others => '0');
            intnmi         : in  std_logic                      := '0';
            perreset       : out std_logic                      ;
            intuart        : out std_logic                      ;
            inttimer0      : out std_logic                      ;
            inttimer1      : out std_logic                      ;
            intproc0       : out std_logic                      ;
            intproc1       : out std_logic                      ;

            debugrq        : in  std_logic                      := '0';
            debugext0      : in  std_logic                      := '0';
            debugext1      : in  std_logic                      := '0';
            debugiebrkpt   : in  std_logic                      := '0';
            debugdewpt     : in  std_logic                      := '0';
            debugextin     : in  std_logic_vector ( 3 downto 0) := (others => '0');    
            debugack       : out std_logic                      ;
            debugrng0      : out std_logic                      ;
            debugrng1      : out std_logic                      ;
            debugextout    : out std_logic_vector ( 3 downto 0) ;    

            slavehclk      : in  std_logic                      := '0';
            slavehwrite    : in  std_logic                      := '0';
            slavehreadyi   : in  std_logic                      := '0';
            slavehselreg   : in  std_logic                      := '0';
            slavehsel      : in  std_logic                      := '0';
            slavehmastlock : in  std_logic                      := '0';
            slavehaddr     : in  std_logic_vector (31 downto 0) := (others => '0');
            slavehwdata    : in  std_logic_vector (31 downto 0) := (others => '0');
            slavehtrans    : in  std_logic_vector ( 1 downto 0) := (others => '0');
            slavehsize     : in  std_logic_vector ( 1 downto 0) := (others => '0');
            slavehburst    : in  std_logic_vector ( 2 downto 0) := (others => '0');
            slavehreadyo   : out std_logic                      ;
            slavebuserrint : out std_logic                      ;
            slavehrdata    : out std_logic_vector (31 downto 0) ;
            slavehresp     : out std_logic_vector ( 1 downto 0) ;

            masterhclk     : in  std_logic                      := '0';
            masterhrdata   : in  std_logic_vector (31 downto 0) := (others => '0');
            masterhresp    : in  std_logic_vector ( 1 downto 0) := (others => '0');
            masterhwrite   : out std_logic                      ;
            masterhlock    : out std_logic                      ;
            masterhbusreq  : out std_logic                      ;
            masterhaddr    : out std_logic_vector (31 downto 0) ;
            masterhwdata   : out std_logic_vector (31 downto 0) ;
            masterhtrans   : out std_logic_vector ( 1 downto 0) ;
            masterhsize    : out std_logic_vector ( 1 downto 0) ;
            masterhready   : in  std_logic                      := '0';
            masterhburst   : out std_logic_vector ( 2 downto 0) ;
            masterhgrant   : in  std_logic                      := '0';

            lockreqdp0     : in  std_logic                      := '0';
            lockreqdp1     : in  std_logic                      := '0';
            lockgrantdp0   : out std_logic                      ;
            lockgrantdp1   : out std_logic                      ;

            ebiack         : in  std_logic                      := '0';
            ebiwen         : out std_logic                      ;
            ebioen         : out std_logic                      ;
            ebiclk         : out std_logic                      ;
            ebibe          : out std_logic_vector ( 1 downto 0) ;
            ebicsn         : out std_logic_vector ( 3 downto 0) ;
            ebiaddr        : out std_logic_vector (24 downto 0) ;
            ebidqoe        : out std_logic                      ;
            ebidqout       : out std_logic_vector (15 downto 0) ;
            ebidqin        : in  std_logic_vector (15 downto 0) := (others => '0');

            uarttxd        : out std_logic                      ;
            uartrtsn       : out std_logic                      ;
            uartdtrn       : out std_logic                      ;
            uartctsn       : in  std_logic                      := '0';
            uartdsrn       : in  std_logic                      := '0';
            uartrxd        : in  std_logic                      := '0';
            uartdcdon      : out std_logic                      ;
            uartdcdin      : in  std_logic                      := '0';
            uartriin       : in  std_logic                      := '0';
            uartrion       : out std_logic                      ;
            uartdcdrioe    : out std_logic                      ;

              
            sdramclk       : out std_logic                      ;
            sdramclkn      : out std_logic                      ;
            sdramclke      : out std_logic                      ;
            sdramwen       : out std_logic                      ;
            sdramcasn      : out std_logic                      ;
            sdramrasn      : out std_logic                      ;
            sdramdqm       : out std_logic_vector (sdramdqm_width-1 downto 0) ;
            sdramaddr      : out std_logic_vector (14 downto 0) ;
            sdramdqoe      : out std_logic_vector (sdramdqm_width-1 downto 0) ;
            sdramdqout     : out std_logic_vector (sdram_width-1 downto 0) ;
            sdramdqin      : in  std_logic_vector (sdram_width-1 downto 0) := (others => '0');
            sdramdqsoe     : out std_logic                      ;
            sdramcsn       : out std_logic_vector ( 1 downto 0) ;
            sdramdqsout    : out std_logic_vector (sdramdqm_width-1 downto 0) ;
            sdramdqsin     : in  std_logic_vector (sdramdqm_width-1 downto 0) := (others => '0');

            intextpin      : in  std_logic                      := '0';
            traceclk       : out std_logic                      ;
            tracesync      : out std_logic                      ;
            tracepipestat  : out std_logic_vector ( 2 downto 0) ;
            tracepkt       : out std_logic_vector (15 downto 0) ;

            gpi            : in  std_logic_vector (gpio_width-1 downto 0) := (others => '0');
            gpo            : out std_logic_vector (gpio_width-1 downto 0) ) ;

end component;




end apex20ke_components;
