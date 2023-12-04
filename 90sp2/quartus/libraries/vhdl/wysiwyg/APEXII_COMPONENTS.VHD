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
-- FILENAME     :    apexii_components.vhd
-- FILE CONTENTS:    APEXII VITAL Component Package (3.0)
-- DATE CREATED :    Tue Oct 17 17:43:50 PST 2000
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

package APEXII_COMPONENTS is

component apexii_lcell
  generic (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      packed_mode   : string := "false";
      lut_mask       : string := "ffff";
      power_up : string := "low";
		lpm_type : string := "apexii_lcell";
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

component apexii_io
    generic
	(
		operation_mode : string := "input";
		ddio_mode : string := "none";
		open_drain_output :string := "false";
		output_register_mode : string := "none";
		output_reset : string := "none";
		output_power_up : string := "low";
		oe_register_mode : string := "none";
		oe_reset : string := "none";
		oe_power_up : string := "low";
		input_register_mode : string := "none";
		input_reset : string := "none";
		input_power_up : string := "low";
		bus_hold : string := "false";
		tie_off_output_clock_enable : string := "false";
		tie_off_oe_clock_enable : string := "false";
		extend_oe_disable : string := "false"
;
		lpm_type : string := "apexii_io"	);
    port
	(
		datain          : in std_logic := '0';
		ddiodatain      : in std_logic := '0';
		oe              : in std_logic := '1';
		outclk          : in std_logic := '0';
		outclkena       : in std_logic := '1';
		inclk           : in std_logic := '0';
		inclkena        : in std_logic := '1';
		areset          : in std_logic := '0';
		modesel         : in std_logic_vector(36 downto 0) := (OTHERS => '0');
		combout         : out std_logic;
		regout          : out std_logic;
		ddioregout      : out std_logic;
		padio           : inout std_logic
	);

end component;


component apexii_pterm 
  generic (operation_mode     : string := "normal";
      output_mode        : string := "comb";
      invert_pterm1_mode : string := "false";
		lpm_type : string := "apexii_pterm";
      power_up : string := "low");

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

component apexii_ram_block
    generic (
                operation_mode                  : string := "single_port";
                port_a_operation_mode           : string := "single_port";
                port_b_operation_mode           : string := "single_port";
                logical_ram_name                : string := "ram_xxx";
                port_a_logical_ram_name         : string := "ram_xxx";
                port_b_logical_ram_name         : string := "ram_xxx";
                init_file                       : string := "xxx";
                port_a_init_file                : string := "xxx";
                port_b_init_file                : string := "xxx";
                data_interleave_width_in_bits   : integer := 1;
                data_interleave_offset_in_bits  : integer := 1;
                port_a_data_interleave_width_in_bits   : integer := 1;
                port_a_data_interleave_offset_in_bits  : integer := 1;
                port_b_data_interleave_width_in_bits   : integer := 1;
                port_b_data_interleave_offset_in_bits  : integer := 1;

                port_a_write_deep_ram_mode      : string := "off";
                port_a_write_logical_ram_depth  : integer := 4096;
                port_a_write_logical_ram_width  : integer := 1;
                port_a_write_address_width      : integer := 16;
                port_a_read_deep_ram_mode       : string := "off";
                port_a_read_logical_ram_depth   : integer := 4096;
                port_a_read_logical_ram_width   : integer := 1;
                port_a_read_address_width       : integer := 16;

                port_a_data_in_clock            : string := "none";
                port_a_data_in_clear            : string := "none";
                port_a_write_logic_clock        : string := "none";
                port_a_write_address_clear      : string := "none";
                port_a_write_enable_clear       : string := "none";
                port_a_read_enable_clock        : string := "none";
                port_a_read_enable_clear        : string := "none";
                port_a_read_address_clock       : string := "none";
                port_a_read_address_clear       : string := "none";
                port_a_data_out_clock           : string := "none";
                port_a_data_out_clear           : string := "none";

                port_a_write_first_address      : integer := 0;
                port_a_write_last_address       : integer := 4095;
                port_a_write_first_bit_number   : integer := 1;
                port_a_write_data_width         : integer := 1;
                port_a_read_first_address       : integer := 0;
                port_a_read_last_address        : integer := 4095;
                port_a_read_first_bit_number    : integer := 1;
                port_a_read_data_width          : integer := 1;

                port_b_write_deep_ram_mode      : string := "off";
                port_b_write_logical_ram_depth  : integer := 4096;
                port_b_write_logical_ram_width  : integer := 1;
                port_b_write_address_width      : integer := 16;
                port_b_read_deep_ram_mode       : string := "off";
                port_b_read_logical_ram_depth   : integer := 4096;
                port_b_read_logical_ram_width   : integer := 1;
                port_b_read_address_width       : integer := 16;

                port_b_data_in_clock            : string := "none";
                port_b_data_in_clear            : string := "none";
                port_b_write_logic_clock        : string := "none";
                port_b_write_address_clear      : string := "none";
                port_b_write_enable_clear       : string := "none";
                port_b_read_enable_clock        : string := "none";
                port_b_read_enable_clear        : string := "none";
                port_b_read_address_clock       : string := "none";
                port_b_read_address_clear       : string := "none";
                port_b_data_out_clock           : string := "none";
                port_b_data_out_clear           : string := "none";

                port_b_write_first_address      : integer := 0;
                port_b_write_last_address       : integer := 4095;
                port_b_write_first_bit_number   : integer := 1;
                port_b_write_data_width         : integer := 1;
                port_b_read_first_address       : integer := 0;
                port_b_read_last_address        : integer := 4095;
                port_b_read_first_bit_number    : integer := 1;
                port_b_read_data_width          : integer := 1;

                power_up                        : string := "low";
		lpm_type : string := "apexii_ram_block";
                mem1       : std_logic_vector(512 downto 1) := (OTHERS => '0');
                mem2       : std_logic_vector(512 downto 1) := (OTHERS => '0');
                mem3       : std_logic_vector(512 downto 1) := (OTHERS => '0');
                mem4       : std_logic_vector(512 downto 1) := (OTHERS => '0');
                mem5       : std_logic_vector(512 downto 1) := (OTHERS => '0');
                mem6       : std_logic_vector(512 downto 1) := (OTHERS => '0');
                mem7       : std_logic_vector(512 downto 1) := (OTHERS => '0');
                mem8       : std_logic_vector(512 downto 1) := (OTHERS => '0'));

    port (
                portadatain                     : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                portaclk0                       : in std_logic := '0';
                portaclk1                       : in std_logic := '0';
                portaclr0                       : in std_logic := '0';
                portaclr1                       : in std_logic := '0';
                portaena0                       : in std_logic := '1';
                portaena1                       : in std_logic := '1';
                portawe                         : in std_logic := '0';
                portare                         : in std_logic := '1';
                portaraddr                      : in std_logic_vector(16 downto 0) := (OTHERS => '0');
                portawaddr                      : in std_logic_vector(16 downto 0) := (OTHERS => '0');
                portbdatain                     : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                portbclk0                       : in std_logic := '0';
                portbclk1                       : in std_logic := '0';
                portbclr0                       : in std_logic := '0';
                portbclr1                       : in std_logic := '0';
                portbena0                       : in std_logic := '1';
                portbena1                       : in std_logic := '1';
                portbwe                         : in std_logic := '0';
                portbre                         : in std_logic := '1';
                portbraddr                      : in std_logic_vector(16 downto 0) := (OTHERS => '0');
                portbwaddr                      : in std_logic_vector(16 downto 0) := (OTHERS => '0');
                portadataout                    : out std_logic_vector(15 downto 0);
                portbdataout                    : out std_logic_vector(15 downto 0);
                portamodesel                  : in std_logic_vector(20 downto 0) := (OTHERS => '0');
                portbmodesel                  : in std_logic_vector(20 downto 0) := (OTHERS => '0')
         );
end component;

component  apexii_cam_slice
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
		lpm_type : string := "apexii_cam_slice";
     power_up             : string := "low");
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

component apexii_hsdi_transmitter
    generic (
                channel_width           : integer := 10;
--		power_up		: string := "low";
                TimingChecksOn          : Boolean := True;
		lpm_type : string := "apexii_hsdi_transmitter";
                InstancePath            : String := "*");

        port (
                clk0            : in std_logic;
                clk1            : in std_logic;
                datain          : in std_logic_vector(9 downto 0);
                dataout         : out std_logic);
end component;

component apexii_hsdi_receiver
    generic (
                channel_width           : integer := 10;
--		power_up		: string := "low";
                TimingChecksOn          : Boolean := True;
		lpm_type : string := "apexii_hsdi_receiver";
                InstancePath            : String := "*");

        port (
                clk0            : in std_logic;
                clk1            : in std_logic;
                datain          : in std_logic;
                deskewin        : in std_logic := '0';
                dataout         : out std_logic_vector(9 downto 0));
end component;

component apexii_pll
    generic (
                input_frequency         : integer  := 1000;
                operation_mode          : string := "normal";
                clk0_multiply_by        : integer := 1;
                clk0_divide_by          : integer := 1;
                clk1_multiply_by        : integer := 1;
                clk1_divide_by          : integer := 1;
                clk2_multiply_by        : integer := 1;
                clk2_divide_by          : integer := 1;
                phase_shift             : integer := 0;
                effective_phase_shift   : integer := 0;
                effective_clk0_delay    : integer := 0;
                effective_clk1_delay    : integer := 0;
                effective_clk2_delay    : integer := 0;
                lock_high               : integer := 1;
				invalid_lock_multiplier	: integer := 5;
				valid_lock_multiplier	: integer := 5;
		lpm_type : string := "apexii_pll";
                lock_low                : integer := 1);

        port (
                clk : in std_logic;
                ena : in std_logic := '1';
                fbin : in std_logic := '0';
                clk0 : out std_logic;
                clk1 : out std_logic;
				clk2 : out std_logic;
                locked : out std_logic);
end component;

component apexii_hsdi_pll
    generic (
                input_frequency         : integer  := 1000;
                clk0_multiply_by        : integer := 1;
                clk1_divide_by          : integer := 1;
                clkin_settings          : string := "";
		lpm_type : string := "apexii_hsdi_pll";
                clk0_settings           : string := "");

        port (
                clk    : in std_logic := '0';
                areset : in std_logic := '0';
                clk0   : out std_logic;
                clk1   : out std_logic;
                locked : out std_logic);
end component;


component apexii_dpram
  generic ( operation_mode                              : string                             := "single_port";
            output_mode                                 : string                             := "unreg";
            width                                       : integer                            := 32;
            widthad                                     : integer                            := 14;
            depth                                       : integer                            := 16768;
            ramblock                                    : integer                            := 65535;
            ramcontent                                  : string                             := "" ;
            InstancePath                                : String                             := "*";
		lpm_type : string := "apexii_dpram";
            clocked : Boolean := True);

  port ( portadatain  : in  std_logic_vector(63 downto 0) ;
         portadataout : out std_logic_vector(63 downto 0) ;
         portaaddr    : in  std_logic_vector(16 downto 0) ;
         portawe      : in  std_logic                     := '0';
         portaena     : in  std_logic                     := '0';
         portaclk     : in  std_logic                     ;
         portbdatain  : in  std_logic_vector(15 downto 0) ;
         portbdataout : out std_logic_vector(15 downto 0) ;
         portbaddr    : in  std_logic_vector(14 downto 0) ;
         portbwe      : in  std_logic                     := '0';
         portbena     : in  std_logic                     := '0';
         portbclk     : in  std_logic                     ) ;

end component;


component apexii_upcore
  generic ( processor      : string := "ARM"           ;
            InstancePath   : String  := "*"            ;
		lpm_type : string := "apexii_upcore";
            clocked        : Boolean := True           ) ;

  port (
            intpld         : in  std_logic_vector ( 5 downto 0) ;
            intuart        : out std_logic                      ;
            inttimer0      : out std_logic                      ;
            inttimer1      : out std_logic                      ;
            intproc0       : out std_logic                      ;
            intproc1       : out std_logic                      ;

            debugrq        : in  std_logic                      ;
            debugext0      : in  std_logic                      ;
            debugext1      : in  std_logic                      ;
            debugiebrkpt   : in  std_logic                      ;
            debugdewpt     : in  std_logic                      ;
            debugextin     : in  std_logic_vector ( 3 downto 0) ;    
            debugack       : out std_logic                      ;
            debugrng0      : out std_logic                      ;
            debugrng1      : out std_logic                      ;
            debugextout    : out std_logic_vector ( 3 downto 0) ;    

            slavehclk      : in  std_logic                      ;
            slavehwrite    : in  std_logic                      ;
            slavehreadyi   : in  std_logic                      ;
            slavehselreg   : in  std_logic                      ;
            slavehsel      : in  std_logic                      ;
            slavehmastlock : in  std_logic                      ;
            slavehaddr     : in  std_logic_vector (31 downto 0) ;
            slavehwdata    : in  std_logic_vector (31 downto 0) ;
            slavehtrans    : in  std_logic_vector ( 1 downto 0) ;
            slavehsize     : in  std_logic_vector ( 1 downto 0) ;
            slavehburst    : in  std_logic_vector ( 2 downto 0) ;
            slavehreadyo   : out std_logic                      ;
            slavebuserrint : out std_logic                      ;
            slavehrdata    : out std_logic_vector (31 downto 0) ;
            slavehresp     : out std_logic_vector ( 1 downto 0) ;

            masterhclk     : in  std_logic                      ;
            masterhrdata   : in  std_logic_vector (31 downto 0) ;
            masterhresp    : in  std_logic_vector ( 1 downto 0) ;
            masterhwrite   : out std_logic                      ;
            masterhlock    : out std_logic                      ;
            masterhbusreq  : out std_logic                      ;
            masterhaddr    : out std_logic_vector (31 downto 0) ;
            masterhwdata   : out std_logic_vector (31 downto 0) ;
            masterhtrans   : out std_logic_vector ( 1 downto 0) ;
            masterhsize    : out std_logic_vector ( 1 downto 0) ;
            masterhready   : in  std_logic                      ;
            masterhburst   : out std_logic_vector ( 2 downto 0) ;
            masterhgrant   : in  std_logic                      ;

            lockreqdp0     : in  std_logic                      ;
            lockreqdp1     : in  std_logic                      ;
            lockgrantdp0   : out std_logic                      ;
            lockgrantdp1   : out std_logic                      ;

            ebiack         : in  std_logic                      ;
            ebiwen         : out std_logic                      ;
            ebioen         : out std_logic                      ;
            ebiclk         : out std_logic                      ;
            ebibe          : out std_logic_vector ( 1 downto 0) ;
            ebicsn         : out std_logic_vector ( 3 downto 0) ;
            ebiaddr        : out std_logic_vector (24 downto 0) ;
            ebidqoe        : out std_logic                      ;
            ebidqout       : out std_logic_vector (15 downto 0) ;
            ebidqin        : in  std_logic_vector (15 downto 0) ;

            uarttxd        : out std_logic                      ;
            uartrtsn       : out std_logic                      ;
            uartdtrn       : out std_logic                      ;
            uartctsn       : in  std_logic                      ;
            uartdsrn       : in  std_logic                      ;
            uartrxd        : in  std_logic                      ;
            uartdcdon      : out std_logic                      ;
            uartdcdin      : in  std_logic                      ;
            uartriin       : in  std_logic                      ;
            uartrion       : out std_logic                      ;
            uartdcdrioe    : out std_logic                      ;

              
            sdramclk       : out std_logic                      ;
            sdramclkn      : out std_logic                      ;
            sdramclke      : out std_logic                      ;
            sdramwen       : out std_logic                      ;
            sdramcasn      : out std_logic                      ;
            sdramrasn      : out std_logic                      ;
            sdramdqm       : out std_logic_vector ( 3 downto 0) ;
            sdramaddr      : out std_logic_vector (14 downto 0) ;
            sdramdqoe      : out std_logic_vector ( 3 downto 0) ;
            sdramdqout     : out std_logic_vector (31 downto 0) ;
            sdramdqin      : in  std_logic_vector (31 downto 0) ;
            sdramdqsoe     : out std_logic                      ;
            sdramcsn       : out std_logic_vector ( 1 downto 0) ;
            sdramdqsout    : out std_logic_vector ( 3 downto 0) ;
            sdramdqsin     : in  std_logic_vector ( 3 downto 0) ;

            intextpin      : in  std_logic                      ;
            traceclk       : out std_logic                      ;
            tracesync      : out std_logic                      ;
            tracepipestat  : out std_logic_vector ( 2 downto 0) ;
            tracepkt       : out std_logic_vector (15 downto 0) ) ;

end component;




end apexii_components;
