-- Copyright (C) 1991-2009 Altera Corporation
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
-- Quartus II 9.0 Build 132 02/25/2009

LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.VITAL_Timing.all;
use work.apexii_atom_pack.all;

PACKAGE APEXII_COMPONENTS is

COMPONENT apexii_lcell
  GENERIC (
    operation_mode : string := "normal";
    output_mode    : string := "comb_and_reg";
    packed_mode    : string := "false";
    lut_mask       : string := "ffff";
    power_up       : string := "low";
    cin_used       : string := "false";
    lpm_type       : string := "apexii_lcell";
    x_on_violation : string := "on"
  );

  PORT (clk     : in std_logic := '0';
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
        devclrn : in std_logic := '1';
        devpor  : in std_logic := '1';
        combout   : out std_logic;
        regout    : out std_logic;
        cout  : out std_logic;
        cascout    : out std_logic);
END COMPONENT;

COMPONENT apexii_io
    GENERIC
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
	);
    PORT
	(
		datain          : in std_logic := '0';
		ddiodatain      : in std_logic := '0';
		oe              : in std_logic := '1';
		outclk          : in std_logic := '0';
		outclkena       : in std_logic := '1';
		inclk           : in std_logic := '0';
		inclkena        : in std_logic := '1';
		areset          : in std_logic := '0';
		devclrn         : in std_logic := '1';
		devpor          : in std_logic := '1';
		devoe           : in std_logic := '0';
		combout         : out std_logic;
		regout          : out std_logic;
		ddioregout      : out std_logic;
		padio           : inout std_logic
	);

END COMPONENT;

COMPONENT apexii_pterm 
  GENERIC (operation_mode     : string := "normal";
      output_mode        : string := "comb";
      invert_pterm1_mode : string := "false";
      power_up : string := "low");

  PORT (pterm0  : in std_logic_vector(31 downto 0) := (OTHERS => '1');
        pterm1  : in std_logic_vector(31 downto 0) := (OTHERS => '1');
        pexpin  : in std_logic := '0';
        clk     : in std_logic := '0';
        ena     : in std_logic := '1';
        aclr    : in std_logic := '0';
        devclrn : in std_logic := '1';
        devpor  : in std_logic := '1';
        dataout : out std_logic;
        pexpout : out std_logic );
END COMPONENT;

COMPONENT apexii_ram_block
    GENERIC (operation_mode                         : string := "single_port";
             port_a_operation_mode                  : string := "single_port";
             port_b_operation_mode                  : string := "single_port";
             logical_ram_name                       : string := "ram_xxx";
             port_a_logical_ram_name                : string := "ram_xxx";
             port_b_logical_ram_name                : string := "ram_xxx";
             init_file                              : string := "none";
             port_a_init_file                       : string := "none";
             port_b_init_file                       : string := "none";
             data_interleave_width_in_bits          : integer := 1;
             data_interleave_offset_in_bits         : integer := 1;
             port_a_data_interleave_width_in_bits   : integer := 1;
             port_a_data_interleave_offset_in_bits  : integer := 1;
             port_b_data_interleave_width_in_bits   : integer := 1;
             port_b_data_interleave_offset_in_bits  : integer := 1;

             port_a_write_deep_ram_mode             : string := "off";
             port_a_write_logical_ram_depth         : integer := 4096;
             port_a_write_logical_ram_width         : integer := 1;
             port_a_write_address_width             : integer := 16;
             port_a_read_deep_ram_mode              : string := "off";
             port_a_read_logical_ram_depth          : integer := 4096;
             port_a_read_logical_ram_width          : integer := 1;
             port_a_read_address_width              : integer := 16;

             port_a_data_in_clock                   : string := "none";
             port_a_data_in_clear                   : string := "none";
             port_a_write_logic_clock               : string := "none";
             port_a_write_address_clear             : string := "none";
             port_a_write_enable_clear              : string := "none";
             port_a_read_enable_clock               : string := "none";
             port_a_read_enable_clear               : string := "none";
             port_a_read_address_clock              : string := "none";
             port_a_read_address_clear              : string := "none";
             port_a_data_out_clock                  : string := "none";
             port_a_data_out_clear                  : string := "none";

             port_a_write_first_address             : integer := 0;
             port_a_write_last_address              : integer := 4095;
             port_a_write_first_bit_number          : integer := 1;
             port_a_write_data_width                : integer := 1;
             port_a_read_first_address              : integer := 0;
             port_a_read_last_address               : integer := 4095;
             port_a_read_first_bit_number           : integer := 1;
             port_a_read_data_width                 : integer := 1;

             port_b_write_deep_ram_mode             : string := "off";
             port_b_write_logical_ram_depth         : integer := 4096;
             port_b_write_logical_ram_width         : integer := 1;
             port_b_write_address_width             : integer := 16;
             port_b_read_deep_ram_mode              : string := "off";
             port_b_read_logical_ram_depth          : integer := 4096;
             port_b_read_logical_ram_width          : integer := 1;
             port_b_read_address_width              : integer := 16;

             port_b_data_in_clock                   : string := "none";
             port_b_data_in_clear                   : string := "none";
             port_b_write_logic_clock               : string := "none";
             port_b_write_address_clear             : string := "none";
             port_b_write_enable_clear              : string := "none";
             port_b_read_enable_clock               : string := "none";
             port_b_read_enable_clear               : string := "none";
             port_b_read_address_clock              : string := "none";
             port_b_read_address_clear              : string := "none";
             port_b_data_out_clock                  : string := "none";
             port_b_data_out_clear                  : string := "none";

             port_b_write_first_address             : integer := 0;
             port_b_write_last_address              : integer := 4095;
             port_b_write_first_bit_number          : integer := 1;
             port_b_write_data_width                : integer := 1;
             port_b_read_first_address              : integer := 0;
             port_b_read_last_address               : integer := 4095;
             port_b_read_first_bit_number           : integer := 1;
             port_b_read_data_width                 : integer := 1;

             power_up                               : string := "low";
             mem1                                   : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem2                                   : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem3                                   : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem4                                   : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem5                                   : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem6                                   : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem7                                   : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem8                                   : std_logic_vector(512 downto 1) := (OTHERS => '0')
            );

    PORT    (portadatain                            : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portaclk0                              : in std_logic := '0';
             portaclk1                              : in std_logic := '0';
             portaclr0                              : in std_logic := '0';
             portaclr1                              : in std_logic := '0';
             portaena0                              : in std_logic := '1';
             portaena1                              : in std_logic := '1';
             portawe                                : in std_logic := '0';
             portare                                : in std_logic := '1';
             portaraddr                             : in std_logic_vector(16 downto 0) := (OTHERS => '0');
             portawaddr                             : in std_logic_vector(16 downto 0) := (OTHERS => '0');
             portbdatain                            : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             portbclk0                              : in std_logic := '0';
             portbclk1                              : in std_logic := '0';
             portbclr0                              : in std_logic := '0';
             portbclr1                              : in std_logic := '0';
             portbena0                              : in std_logic := '1';
             portbena1                              : in std_logic := '1';
             portbwe                                : in std_logic := '0';
             portbre                                : in std_logic := '1';
             portbraddr                             : in std_logic_vector(16 downto 0) := (OTHERS => '0');
             portbwaddr                             : in std_logic_vector(16 downto 0) := (OTHERS => '0');
             portadataout                           : out std_logic_vector(15 downto 0);
             portbdataout                           : out std_logic_vector(15 downto 0);
             devclrn                                : in std_logic := '1';
             devpor                                 : in std_logic := '1';
             portamodesel                           : in std_logic_vector(20 downto 0) := (OTHERS => '0');
             portbmodesel                           : in std_logic_vector(20 downto 0) := (OTHERS => '0')
            );
END COMPONENT;

COMPONENT  apexii_cam_slice
    GENERIC (operation_mode             : string := "encoded_address";
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
             power_up                   : string := "low";
             init_mem_true              : apexii_mem_data := (OTHERS => "11111111111111111111111111111111");
             init_mem_comp              : apexii_mem_data := (OTHERS => "11111111111111111111111111111111")
            );

    PORT    (clk0                       : in std_logic := '0';
             clk1                       : in std_logic := '0';
             clr0                       : in std_logic := '0';
             clr1                       : in std_logic := '0';
             ena0                       : in std_logic := '1';
             ena1                       : in std_logic := '1';
             we                         : in std_logic := '0';
             datain                     : in std_logic := '0';
             wrinvert                   : in std_logic := '0';
             outputselect               : in std_logic := '0';
             waddr                      : in std_logic_vector(4 downto 0) := (OTHERS => '0');
             lit                        : in std_logic_vector(31 downto 0) := (OTHERS => '0');
             devclrn                    : in std_logic := '1';
             devpor                     : in std_logic := '1';
             modesel                    : in std_logic_vector(9 downto 0) := (OTHERS => '0');
             matchout                   : out std_logic_vector(15 downto 0);
             matchfound                 : out std_logic
            );

END COMPONENT;

COMPONENT apexii_hsdi_transmitter
    GENERIC (
                channel_width           : integer := 10;
					 center_align			 : String  := "off";
--		power_up		: string := "low";
                TimingChecksOn          : Boolean := True;
                MsgOn                   : Boolean := DefGlitchMsgOn;
                XOn                     : Boolean := DefGlitchXOn;
                MsgOnChecks             : Boolean := DefMsgOnChecks;
                XOnChecks               : Boolean := DefXOnChecks;
                InstancePath            : String := "*";
                tsetup_datain_clk1_noedge_posedge  : VitalDelayArrayType(9 downto 0) := (OTHERS => DefSetupHoldCnst);
                thold_datain_clk1_noedge_posedge   : VitalDelayArrayType(9 downto 0) := (OTHERS => DefSetupHoldCnst);
                tpd_clk0_dataout_negedge: VitalDelayType01 := DefPropDelay01;
                tipd_clk0               : VitalDelayType01 := DefpropDelay01;
                tipd_clk1               : VitalDelayType01 := DefpropDelay01;
                tipd_datain             : VitalDelayArrayType01(9 downto 0) := (
OTHERS => DefpropDelay01));

        PORT (
                clk0            : in std_logic;
                clk1            : in std_logic;
                datain          : in std_logic_vector(9 downto 0);
                devclrn         : in std_logic := '1';
		devpor		: in std_logic := '1';
                dataout         : out std_logic);
END COMPONENT;

COMPONENT apexii_hsdi_receiver
    GENERIC (
                channel_width           : integer := 10;
					 cds_mode					 : string  := "single_bit";
--		power_up		: string := "low";
                TimingChecksOn          : Boolean := True;
                MsgOn                   : Boolean := DefGlitchMsgOn;
                XOn                     : Boolean := DefGlitchXOn;
                MsgOnChecks             : Boolean := DefMsgOnChecks;
                XOnChecks               : Boolean := DefXOnChecks;
                InstancePath            : String := "*";
                tsetup_datain_clk0_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
                thold_datain_clk0_noedge_posedge   : VitalDelayType := DefSetupHoldCnst;
                tsetup_deskewin_clk0_noedge_posedge: VitalDelayType := DefSetupHoldCnst;
                thold_deskewin_clk0_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
                tpd_clk0_dataout_negedge: VitalDelayArrayType01(9 downto 0) := (OTHERS => DefPropDelay01);
                tipd_clk0               : VitalDelayType01 := DefpropDelay01;
                tipd_clk1               : VitalDelayType01 := DefpropDelay01;
                tipd_deskewin           : VitalDelayType01 := DefpropDelay01;
                tipd_datain             : VitalDelayType01 := DefpropDelay01);

        PORT (
                clk0            : in std_logic;
                clk1            : in std_logic;
                datain          : in std_logic;
                deskewin        : in std_logic := '0';
                devclrn         : in std_logic := '1';
		devpor		: in std_logic := '1';
                dataout         : out std_logic_vector(9 downto 0));
END COMPONENT;

COMPONENT apexii_pll
    GENERIC (input_frequency              : integer  := 1000;
             operation_mode               : string := "normal";
             simulation_type              : string := "timing";
             clk0_multiply_by             : integer := 1;
             clk0_divide_by               : integer := 1;
             clk1_multiply_by             : integer := 1;
             clk1_divide_by               : integer := 1;
             clk2_multiply_by             : integer := 1;
             clk2_divide_by               : integer := 1;
             phase_shift                  : integer := 0;
             effective_phase_shift        : integer := 0;
             effective_clk0_delay         : integer := 0;
             effective_clk1_delay         : integer := 0;
             effective_clk2_delay         : integer := 0;
             lock_high                    : integer := 1;
             invalid_lock_multiplier      : integer := 5;
             valid_lock_multiplier        : integer := 5;
             lock_low                     : integer := 1;
             MsgOn                        : Boolean := DefGlitchMsgOn;
             XOn                          : Boolean := DefGlitchXOn;
             tpd_ena_clk0                 : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk1                 : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk2                 : VitalDelayType01 := DefPropDelay01;
             tpd_clk_locked               : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk0                : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk1                : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk2                : VitalDelayType01 := DefPropDelay01;
             tipd_clk                     : VitalDelayType01 := DefpropDelay01;
             tipd_ena                     : VitalDelayType01 := DefpropDelay01;
             tipd_fbin                    : VitalDelayType01 := DefpropDelay01
            );

    PORT    (clk                          : in std_logic;
             ena                          : in std_logic := '1';
             fbin                         : in std_logic := '0';
             clk0                         : out std_logic;
             clk1                         : out std_logic;
             clk2                         : out std_logic;
             locked                       : out std_logic
            );
END COMPONENT;

COMPONENT  apexii_jtagb 
    PORT (tms : in std_logic := '0'; 
    		 tck : in std_logic := '0'; 
    		 tdi : in std_logic := '0'; 
    		 ntrst : in std_logic := '0'; 
    		 tdoutap : in std_logic := '0'; 
    		 tdouser : in std_logic := '0'; 
          tdo: out std_logic; 
          tmsutap: out std_logic; 
          tckutap: out std_logic; 
          tdiutap: out std_logic; 
          shiftuser: out std_logic; 
          clkdruser: out std_logic; 
          updateuser: out std_logic; 
          runidleuser: out std_logic; 
          usr1user: out std_logic);
END COMPONENT;

END APEXII_COMPONENTS;
