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
-- FILENAME     :    mercury_components.vhd
-- FILE CONTENTS:    MERCURY VITAL Component Package (3.0)
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

package MERCURY_COMPONENTS is

component mercury_lcell
  generic (operation_mode    : string := "normal";
      output_mode   : string := "comb_and_reg";
      packed_mode   : string := "false";
		multiplier_output : string := "true";
		multiplier_mux_source : string := "gnd";
      lut_mask       : string := "ffff";
      power_up : string := "low";
      cin0_used       : string := "false";
      cin1_used       : string := "false";
		lpm_type : string := "mercury_lcell";
      cin_used       : string := "false");

  port (clk     : in std_logic := '0';
        dataa     : in std_logic := '1';
        datab     : in std_logic := '1';
        datac     : in std_logic := '1';
        datad     : in std_logic := '1';
        apre    : in std_logic := '0';
        aclr    : in std_logic := '0';
        aload : in std_logic := '0';
        sclr : in std_logic := '0';
        sload : in std_logic := '0';
        ena : in std_logic := '1';
        cin   : in std_logic := '0';
        cin0   : in std_logic := '0';
        cin1   : in std_logic := '1';
        multsela  : in std_logic := '1';
        multselb  : in std_logic := '1';
        modesel   : in std_logic_vector(6 downto 0) := "0000000";
        combout   : out std_logic;
        regout    : out std_logic;
        multout   : out std_logic;
        cout  : out std_logic;
        cout0  : out std_logic;
        cout1  : out std_logic);
end component;

component mercury_ram_block
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
		lpm_type : string := "mercury_ram_block";
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
                portaraddr                      : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                portawaddr                      : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                portbdatain                     : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                portbclk0                       : in std_logic := '0';
                portbclk1                       : in std_logic := '0';
                portbclr0                       : in std_logic := '0';
                portbclr1                       : in std_logic := '0'; 
                portbena0                       : in std_logic := '1';
                portbena1                       : in std_logic := '1';
                portbwe                         : in std_logic := '0';
                portbre                         : in std_logic := '1';
                portbraddr                      : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                portbwaddr                      : in std_logic_vector(15 downto 0) := (OTHERS => '0');
                portadataout                    : out std_logic_vector(15 downto 0);
                portbdataout                    : out std_logic_vector(15 downto 0);
                portamodesel                  : in std_logic_vector(20 downto 0) := (OTHERS => '0');
                portbmodesel                  : in std_logic_vector(20 downto 0) := (OTHERS => '0')
         );
end component;

component mercury_pll
    generic
      ( operation_mode          : string := "normal";
        clk0_multiply_by        : integer := 1;
        clk0_divide_by          : integer := 1;
        clk1_multiply_by        : integer := 1;
        clk1_divide_by          : integer := 1;
        extclk_multiply_by      : integer := 0;
        extclk_divide_by        : integer := 0;
        input_frequency         : integer := 1000;
        phase_shift             : integer := 0;
        lock_high               : integer := 1;
        lock_low                : integer := 1;
        valid_lock_multiplier   : integer := 5;
        invalid_lock_multiplier : integer := 5;
        clkin_settings          : string := "";
        clk0_settings           : string := "";
        clk1_settings           : string := "";
        extclk_settings         : string := "";
        clk2_multiply_by        : integer := 1;
        clk2_divide_by          : integer := 1;
        clk2_settings           : string := "";
        clk0_time_delay         : integer := 0;
        clk1_time_delay         : integer := 0;
        clk2_time_delay         : integer := 0;
        extclk_time_delay       : integer := 0;
        effective_phase_shift   : integer := 0;
        effective_clk0_delay    : integer := 0;
        effective_clk1_delay    : integer := 0;
        effective_clk2_delay    : integer := 0;
        effective_extclk_delay  : integer := 0;
		lpm_type : string := "mercury_pll";
        InstancePath            : String := "*" );

    port
      ( clk    : in std_logic;
        ena    : in std_logic := '1';
        fbin   : in std_logic := '1';
        clk0   : out std_logic;
        clk1   : out std_logic;
        clk2   : out std_logic;
        extclk : out std_logic;
        locked : out std_logic );
end component;

component mercury_cam_slice
    generic (
        operation_mode     : string := "single_match";
        logical_cam_name   : string := "cam_xxx";
        logical_cam_depth  : integer := 64;
        logical_cam_width  : integer := 32;
        address_width      : integer := 6;
        waddr_clear        : string := "none";
        write_enable_clear : string := "none";
        write_logic_clock  : string := "none";
        write_logic_clear  : string := "none";
        output_clock       : string := "none";
        output_clear       : string := "none";
        init_file          : string := "xxx";
        init_filex         : string := "xxx";
        first_address      : integer := 0;
        last_address       : integer := 63;
        first_pattern_bit  : integer := 0;
        pattern_width      : integer := 32;
		lpm_type : string := "mercury_cam_slice";
        power_up           : string := "low" );
    port (
        clk0, clk1 : in std_logic := '0';
        clr0, clr1 : in std_logic := '0';
        ena0, ena1 : in std_logic := '1';
        we, datain : in std_logic := '0';
        wrinvert, outputselect : in std_logic := '0';
        waddr : in std_logic_vector(5 downto 0);
        lit : in std_logic_vector(31 downto 0);
        modesel : in std_logic_vector(9 downto 0) := (OTHERS => '0');
        matchout : out std_logic_vector(31 downto 0);
        matchfound : out std_logic);
end component;

component mercury_hssi_transmitter
    generic (
                channel_width           : integer := 20;
                TimingChecksOn          : Boolean := True;
		lpm_type : string := "mercury_hssi_transmitter";
                InstancePath            : String := "*" );

        port (
                clk             : in std_logic;
                areset          : in std_logic := '0';
                datain          : in std_logic_vector(19 downto 0);
                clkout          : out std_logic;
                dataout         : out std_logic);
end component;

component mercury_hssi_receiver
    generic (
                channel_width           : integer := 20;
                operation_mode          : String  := "LVDS";
                run_length  	          : integer := 1;
                TimingChecksOn          : Boolean := True;
		lpm_type : string := "mercury_hssi_receiver";
                InstancePath            : String  := "*" );

        port (
					clk			: in std_logic;
					datain		: in std_logic;
					areset		: in std_logic := '0';
					feedback		: in std_logic := '0';
					fbkcntl		: in std_logic := '0';
					clkout		: out std_logic;
					rlv			: out std_logic;
					locked		: out std_logic;
					dataout		: out std_logic_vector(19 downto 0));
end component;

component mercury_hssi_pll
    generic
      ( clk0_multiply_by        : integer := 1;
        clk1_divide_by          : integer := 1;
        input_frequency         : integer := 1000;
        clkin_settings          : string := "";
		lpm_type : string := "mercury_hssi_pll";
        clk0_settings           : string := "" );
    port
      ( clk    : in std_logic := '0';
        areset : in std_logic := '0';
        clk0   : out std_logic;
        clk1   : out std_logic;
        locked : out std_logic );
end component;


component mercury_io
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
		lpm_type : string := "mercury_io";
			bus_hold : string := "false");
    port 
		(
			datain                       : in std_logic := '0';
			ddiodatain                       : in std_logic := '0';
			oe                       : in std_logic := '1';
			outclk                       : in std_logic := '0';
			outclkena                       : in std_logic := '1';
			oeclkena                       : in std_logic := '1';
			inclk                       : in std_logic := '0';
			inclkena                       : in std_logic := '1';
			areset                       : in std_logic := '0';
			modesel						: in std_logic_vector(32 downto 0) := (OTHERS => '0');
			combout                       : out std_logic;
			regout                       : out std_logic;
			ddioregout					 : out std_logic;
			padio                       : inout std_logic );

end component;

component mercury_hssi_synchronizer 
	generic (
		channel_width           : integer := 20;
		TimingChecksOn          : Boolean := True;
		lpm_type : string := "mercury_hssi_synchronizer";
		InstancePath            : String := "*" );

	port (
			clk0		: in std_logic;
			clk1		: in std_logic;
			datain	: in std_logic_vector(19 downto 0);
			we			: in std_logic := '1';
			re			: in std_logic := '1';
			areset		: in std_logic := '0';
			empty		: out std_logic;
			overflow	: out std_logic;
			dataout	: out std_logic_vector(19 downto 0));
end component;

end mercury_components;
