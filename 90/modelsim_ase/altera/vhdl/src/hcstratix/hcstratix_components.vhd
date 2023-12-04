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
use work.hcstratix_atom_pack.all;

package HCSTRATIX_COMPONENTS is

--
-- HCSTRATIX_LCELL
--
  
component hcstratix_lcell
  generic 
    (
      operation_mode  : string := "normal";
      synch_mode      : string := "off";
      register_cascade_mode   : string := "off";
      sum_lutc_input  : string := "datac";
      lut_mask        : string := "ffff";
      power_up        : string := "low";
      cin0_used       : string := "false";
      cin1_used       : string := "false";
      cin_used        : string := "false";
      output_mode     : string := "reg_and_comb";
      lpm_type        : string := "hcstratix_lcell";
      x_on_violation  : string := "on"
      );
  port
    (
      clk       : in std_logic := '0';
      dataa     : in std_logic := '1';
      datab     : in std_logic := '1';
      datac     : in std_logic := '1';
      datad     : in std_logic := '1';
      aclr      : in std_logic := '0';
      aload     : in std_logic := '0';
      sclr      : in std_logic := '0';
      sload     : in std_logic := '0';
      ena       : in std_logic := '1';
      cin       : in std_logic := '0';
      cin0      : in std_logic := '0';
      cin1      : in std_logic := '1';
      inverta   : in std_logic := '0';
      regcascin : in std_logic := '0';
      devclrn   : in std_logic := '1';
      devpor    : in std_logic := '1';
      combout   : out std_logic;
      regout    : out std_logic;
      cout      : out std_logic;
      cout0     : out std_logic;
      cout1     : out std_logic
      );
end component;

--
-- HCSTRATIX_IO
--

component hcstratix_io
  generic
    (
      operation_mode            : string := "input";
      ddio_mode                 : string := "none";
      open_drain_output         : string := "false";
      bus_hold                  : string := "false";
      output_register_mode      : string := "none";
      output_async_reset        : string := "none";
      output_sync_reset         : string := "none";
      output_power_up           : string := "low";
      tie_off_output_clock_enable : string := "false";
      oe_register_mode          : string := "none";
      oe_async_reset            : string := "none";
      oe_sync_reset             : string := "none";
      oe_power_up               : string := "low";
      tie_off_oe_clock_enable   : string := "false";
      input_register_mode       : string := "none";
      input_async_reset         : string := "none";
      input_sync_reset          : string := "none";
      input_power_up            : string := "low";
      extend_oe_disable         : string := "false";
      sim_dll_phase_shift       : string := "0";
      sim_dqs_input_frequency   : string  := "10000 ps";
      lpm_type                  : string := "hcstratix_io"
      );
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
      sreset          : in std_logic := '0';
      devclrn         : in std_logic := '1';
      devpor          : in std_logic := '1';
      devoe           : in std_logic := '0';
      delayctrlin     : in std_logic := '0';
      combout         : out std_logic;
      regout          : out std_logic;
      ddioregout      : out std_logic;
      dqsundelayedout : out std_logic;
      padio           : inout std_logic
      );
end component;

--
-- HCSTRATIX_MAC_MULT
--

component hcstratix_mac_mult
  generic 
    (
      dataa_width : integer := 0;
      datab_width : integer := 0;
      dataa_clock	: string := "none";
      datab_clock	: string := "none";
      signa_clock	: string := "none"; 
      signb_clock	: string := "none"; 
      output_clock	: string := "none"; 
      dataa_clear	: string := "none";
      datab_clear	: string := "none";
      signa_clear	: string := "none"; 
      signb_clear	: string := "none"; 
      output_clear	: string := "none";
      signa_internally_grounded : string := "false";
      signb_internally_grounded : string := "false";
      lpm_hint        : string := "true";
      lpm_type        : string := "hcstratix_mac_mult"
    );

  port
    (
      dataa : in std_logic_vector (dataa_width-1 downto 0) := (others => '0');
      datab : in std_logic_vector (datab_width-1 downto 0) := (others => '0');
      signa : in std_logic := '1';
      signb : in std_logic := '1';
      clk      : in std_logic_vector (3 downto 0) := "0000";
      aclr     : in std_logic_vector (3 downto 0) := "0000";
      ena      : in std_logic_vector (3 downto 0) := "1111";
      devclrn  : in std_logic := '1';   
      devpor   : in std_logic := '1';
      dataout  : out std_logic_vector  ((dataa_width+datab_width)-1 downto 0);
      scanouta : out std_logic_vector (dataa_width-1 downto 0);
      scanoutb : out std_logic_vector (datab_width-1 downto 0)
    ); 
end component;

--
-- HCSTRATIX_MAC_OUT
--

component hcstratix_mac_out
  generic 
    (
      operation_mode    : string := "output_only";
      dataa_width       : integer := 1;
      datab_width       : integer := 1;
      datac_width       : integer := 1;
      datad_width       : integer := 1;
      dataout_width     : integer := 0;
      addnsub0_clock    : string := "none";
      addnsub1_clock    : string := "none";
      zeroacc_clock     : string := "none";
      signa_clock       : string := "none";
      signb_clock       : string := "none";
      output_clock      : string := "none";
      addnsub0_clear    : string := "none";
      addnsub1_clear    : string := "none";
      zeroacc_clear     : string := "none";
      signa_clear       : string := "none";
      signb_clear       : string := "none";
      output_clear      : string := "none";
      addnsub0_pipeline_clock : string := "none";
      addnsub1_pipeline_clock : string := "none";
      zeroacc_pipeline_clock : string := "none";
      signa_pipeline_clock : string := "none";
      signb_pipeline_clock : string := "none";
      addnsub0_pipeline_clear : string := "none";
      addnsub1_pipeline_clear : string := "none";
      zeroacc_pipeline_clear : string := "none";
      signa_pipeline_clear : string := "none";
      signb_pipeline_clear : string := "none";
      overflow_programmable_invert : std_logic := '0';
      data_out_programmable_invert : std_logic_vector(71 downto 0) 
      := (OTHERS => '0');
      lpm_hint          : string := "true";
      lpm_type	        : string := "hcstratix_mac_out"
    );

  port
    (
      dataa     : in std_logic_vector (dataa_width-1 downto 0) := (others => '0');
      datab     : in std_logic_vector (datab_width-1 downto 0) := (others => '0');
      datac     : in std_logic_vector (datac_width-1 downto 0) := (others => '0');
      datad     : in std_logic_vector (datad_width-1 downto 0) := (others => '0');
      zeroacc   : in std_logic := '0';
      addnsub0  : in std_logic := '1';
      addnsub1  : in std_logic := '1';
      signa     : in std_logic := '1';
      signb     : in std_logic := '1';
      clk       : in std_logic_vector (3 downto 0) := "0000";
      aclr      : in std_logic_vector (3 downto 0) := "0000";
      ena       : in std_logic_vector (3 downto 0) := "1111";
      devclrn   : in std_logic := '1';   
      devpor    : in std_logic := '1';
      dataout   : out std_logic_vector (dataout_width-1 downto 0);
      accoverflow : out std_logic
    );
end component;

--
-- hcstratix_ram_block
--

component hcstratix_ram_block
  generic 
    (
      operation_mode            : string := "single_port";
      mixed_port_feed_through_mode : string := "dont_care"; 
      ram_block_type            : string := "auto"; 
      logical_ram_name          : string := "ram_name"; 
      init_file                 : string := "init_file.hex"; 
      init_file_layout          : string := "none";
      data_interleave_width_in_bits : integer := 1;
      data_interleave_offset_in_bits : integer := 1;
      port_a_logical_ram_depth  : integer := 0;
      port_a_logical_ram_width  : integer := 0;
      port_a_data_in_clear      : string := "none";
      port_a_address_clear      : string := "none";
      port_a_write_enable_clear : string := "none";
      port_a_data_out_clock     : string := "none";
      port_a_data_out_clear     : string := "none";
      port_a_first_address      : integer := 0;
      port_a_last_address       : integer := 0;
      port_a_first_bit_number   : integer := 0;
      port_a_data_width         : integer := 1;
      port_a_byte_enable_clear  : string := "none";
      port_a_data_in_clock      : string := "clock0"; 
      port_a_address_clock      : string := "clock0"; 
      port_a_write_enable_clock : string := "clock0";
      port_a_byte_enable_clock  : string := "clock0";
      port_b_logical_ram_depth  : integer := 0;
      port_b_logical_ram_width  : integer := 0;
      port_b_data_in_clock      : string := "clock1";
      port_b_data_in_clear      : string := "none";
      port_b_address_clock      : string := "clock1";
      port_b_address_clear      : string := "none";
      port_b_read_enable_write_enable_clock : string := "clock1";
      port_b_read_enable_write_enable_clear : string := "none";
      port_b_data_out_clock     : string := "none";
      port_b_data_out_clear     : string := "none";
      port_b_first_address      : integer := 0;
      port_b_last_address       : integer := 0;
      port_b_first_bit_number   : integer := 0;
      port_b_data_width         : integer := 1;
      port_b_byte_enable_clear  : string := "none";
      port_b_byte_enable_clock  : string := "clock1";
      port_a_address_width      : integer := 1; 
      port_b_address_width      : integer := 1; 
      port_a_byte_enable_mask_width : integer := 1; 
      port_b_byte_enable_mask_width : integer := 1; 
      power_up_uninitialized	: string := "false";
      lpm_type                  : string := "hcstratix_ram_block";
      lpm_hint                  : string := "true";
        mem_init0 : BIT_VECTOR  := X"0";
        mem_init1 : BIT_VECTOR  := X"0";
        connectivity_checking     : string := "off"
        ); 
  port
    (
      portawe           : in std_logic := '0';
      portabyteenamasks : in std_logic_vector (port_a_byte_enable_mask_width - 1 DOWNTO 0) := (others => '1');
      portbbyteenamasks : in std_logic_vector (port_b_byte_enable_mask_width - 1 DOWNTO 0) := (others => '1');
      portbrewe         : in std_logic := '0';
      clr0              : in std_logic := '0';
      clr1              : in std_logic := '0';
      clk0              : in std_logic := '0';
      clk1              : in std_logic := '0';
      ena0              : in std_logic := '1';
      ena1              : in std_logic := '1';
      portadatain       : in std_logic_vector (port_a_data_width - 1 DOWNTO 0) := (others => '0');
      portbdatain       : in std_logic_vector (port_b_data_width - 1 DOWNTO 0) := (others => '0');
      portaaddr         : in std_logic_vector (port_a_address_width - 1 DOWNTO 0) := (others => '0');
      portbaddr         : in std_logic_vector (port_b_address_width - 1 DOWNTO 0) := (others => '0');
      devclrn           : in std_logic := '1';
      devpor            : in std_logic := '1';
      portadataout      : out std_logic_vector (port_a_data_width - 1 DOWNTO 0);
      portbdataout      : out std_logic_vector (port_b_data_width - 1 DOWNTO 0)
    );
end component;

--
-- HCSTRATIX_LVDS_TRANSMITTER
--

component hcstratix_lvds_transmitter
    generic (
		channel_width		: integer := 10;
		bypass_serializer	: String := "false";
		invert_clock	: String := "false";
		use_falling_clock_edge	: String := "false";
        lpm_type : string := "hcstratix_lvds_transmitter";
		InstancePath		: String := "*";
		tipd_clk0		: VitalDelayType01 := DefpropDelay01
    );

	port (
		clk0		: in std_logic;
		enable0		: in std_logic;
		datain		: in std_logic_vector(channel_width - 1 downto 0);
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic);
end component;

--
-- HCSTRATIX_LVDS_RECEIVER
--

component hcstratix_lvds_receiver
    generic (
		channel_width		: integer := 10;
		use_enable1			: String := "false";
        lpm_type : string := "hcstratix_lvds_receiver";
		InstancePath		: String := "*"
		);

	port (
		clk0		: in std_logic;
		enable0		: in std_logic;
		enable1		: in std_logic := '0';
		datain		: in std_logic;
		devclrn		: in std_logic := '1';
		devpor		: in std_logic := '1';
		dataout		: out std_logic_vector(channel_width - 1 downto 0));
end component;
--
-- HCSTRATIX_PLL
--

COMPONENT hcstratix_pll
    GENERIC   ( operation_mode              : string := "normal";
                qualify_conf_done           : string := "off";
                compensate_clock            : string := "clk0";
                pll_type                    : string := "auto";
                scan_chain                  : string := "long";
                lpm_type                    : string := "hcstratix_pll";

                clk0_multiply_by            : integer := 1;
                clk0_divide_by              : integer := 1;
                clk0_phase_shift            : string := "0";
                clk0_time_delay             : string := "0";
                clk0_duty_cycle             : integer := 50;

                clk1_multiply_by            : integer := 1;
                clk1_divide_by              : integer := 1;
                clk1_phase_shift            : string := "0";
                clk1_time_delay             : string := "0";
                clk1_duty_cycle             : integer := 50;

                clk2_multiply_by            : integer := 1;
                clk2_divide_by              : integer := 1;
                clk2_phase_shift            : string := "0";
                clk2_time_delay             : string := "0";
                clk2_duty_cycle             : integer := 50;

                clk3_multiply_by            : integer := 1;
                clk3_divide_by              : integer := 1;
                clk3_phase_shift            : string := "0";
                clk3_time_delay             : string := "0";
                clk3_duty_cycle             : integer := 50;

                clk4_multiply_by            : integer := 1;
                clk4_divide_by              : integer := 1;
                clk4_phase_shift            : string := "0";
                clk4_time_delay             : string := "0";
                clk4_duty_cycle             : integer := 50;

                clk5_multiply_by            : integer := 1;
                clk5_divide_by              : integer := 1;
                clk5_phase_shift            : string := "0";
                clk5_time_delay             : string := "0";
                clk5_duty_cycle             : integer := 50;

                extclk0_multiply_by         : integer := 1;
                extclk0_divide_by           : integer := 1;
                extclk0_phase_shift         : string := "0";
                extclk0_time_delay          : string := "0";
                extclk0_duty_cycle          : integer := 50;

                extclk1_multiply_by         : integer := 1;
                extclk1_divide_by           : integer := 1;
                extclk1_phase_shift         : string := "0";
                extclk1_time_delay          : string := "0";
                extclk1_duty_cycle          : integer := 50;

                extclk2_multiply_by         : integer := 1;
                extclk2_divide_by           : integer := 1;
                extclk2_phase_shift         : string := "0";
                extclk2_time_delay          : string := "0";
                extclk2_duty_cycle          : integer := 50;

                extclk3_multiply_by         : integer := 1;
                extclk3_divide_by           : integer := 1;
                extclk3_phase_shift         : string := "0";
                extclk3_time_delay          : string := "0";
                extclk3_duty_cycle          : integer := 50;

                primary_clock               : string := "inclk0";
                inclk0_input_frequency      : integer := 10000;
                inclk1_input_frequency      : integer := 10000;
                gate_lock_signal            : string := "no";
                gate_lock_counter           : integer := 1;
                valid_lock_multiplier       : integer := 5;
                invalid_lock_multiplier     : integer := 5;
                switch_over_on_lossclk      : string := "off";
                switch_over_on_gated_lock   : string := "off";
                enable_switch_over_counter  : string := "off";
                switch_over_counter         : integer := 1;
                feedback_source             : string := "extclk0";
                bandwidth_type              : string := "auto";
                bandwidth                   : integer := 0;
                spread_frequency            : integer := 0;
                down_spread                 : string := "0 %";
                common_rx_tx                : string := "off";
                rx_outclock_resource        : string := "auto";
                use_vco_bypass              : string := "false";
                use_dc_coupling             : string := "false";

                pfd_min                     : integer := 0;
                pfd_max                     : integer := 0;
                vco_min                     : integer := 0;
                vco_max                     : integer := 0;
                vco_center                  : integer := 0;

                -- ADVANCED USE PARAMETERS
                m_initial                   : integer := 1;
                m                           : integer := 0;
                n                           : integer := 1;
                m2                          : integer := 1;
                n2                          : integer := 1;
                ss                          : integer := 0;

                l0_high                     : integer := 1;
                l0_low                      : integer := 1;
                l0_initial                  : integer := 1;
                l0_mode                     : string := "bypass";
                l0_ph                       : integer := 0;
                l0_time_delay               : integer := 0;

                l1_high                     : integer := 1;
                l1_low                      : integer := 1;
                l1_initial                  : integer := 1;
                l1_mode                     : string := "bypass";
                l1_ph                       : integer := 0;
                l1_time_delay               : integer := 0;

                g0_high                     : integer := 1;
                g0_low                      : integer := 1;
                g0_initial                  : integer := 1;
                g0_mode                     : string := "bypass";
                g0_ph                       : integer := 0;
                g0_time_delay               : integer := 0;

                g1_high                     : integer := 1;
                g1_low                      : integer := 1;
                g1_initial                  : integer := 1;
                g1_mode                     : string := "bypass";
                g1_ph                       : integer := 0;
                g1_time_delay               : integer := 0;

                g2_high                     : integer := 1;
                g2_low                      : integer := 1;
                g2_initial                  : integer := 1;
                g2_mode                     : string := "bypass";
                g2_ph                       : integer := 0;
                g2_time_delay               : integer := 0;

                g3_high                     : integer := 1;
                g3_low                      : integer := 1;
                g3_initial                  : integer := 1;
                g3_mode                     : string := "bypass";
                g3_ph                       : integer := 0;
                g3_time_delay               : integer := 0;

                e0_high                     : integer := 1;
                e0_low                      : integer := 1;
                e0_initial                  : integer := 1;
                e0_mode                     : string := "bypass";
                e0_ph                       : integer := 0;
                e0_time_delay               : integer := 0;

                e1_high                     : integer := 1;
                e1_low                      : integer := 1;
                e1_initial                  : integer := 1;
                e1_mode                     : string := "bypass";
                e1_ph                       : integer := 0;
                e1_time_delay               : integer := 0;

                e2_high                     : integer := 1;
                e2_low                      : integer := 1;
                e2_initial                  : integer := 1;
                e2_mode                     : string := "bypass";
                e2_ph                       : integer := 0;
                e2_time_delay               : integer := 0;

                e3_high                     : integer := 1;
                e3_low                      : integer := 1;
                e3_initial                  : integer := 1;
                e3_mode                     : string := "bypass";
                e3_ph                       : integer := 0;
                e3_time_delay               : integer := 0;

                m_ph                        : integer := 0;
                m_time_delay                : integer := 0;
                n_time_delay                : integer := 0;

                extclk0_counter             : string := "e0";
                extclk1_counter             : string := "e1";
                extclk2_counter             : string := "e2";
                extclk3_counter             : string := "e3";
                clk0_counter                : string := "g0";
                clk1_counter                : string := "g1";
                clk2_counter                : string := "g2";
                clk3_counter                : string := "g3";
                clk4_counter                : string := "l0";
                clk5_counter                : string := "l1";
                enable0_counter             : string := "l0";
                enable1_counter             : string := "l0";

                charge_pump_current         : integer := 0;
                loop_filter_c               : integer := 1;
                loop_filter_r               : string := "1.0" ;

                pll_compensation_delay      : integer := 0;
                simulation_type             : string := "timing";
                source_is_pll               : string := "off";

                clk0_use_even_counter_mode  : string := "off";
                clk1_use_even_counter_mode  : string := "off";
                clk2_use_even_counter_mode  : string := "off";
                clk3_use_even_counter_mode  : string := "off";
                clk4_use_even_counter_mode  : string := "off";
                clk5_use_even_counter_mode  : string := "off";
                extclk0_use_even_counter_mode  : string := "off";
                extclk1_use_even_counter_mode  : string := "off";
                extclk2_use_even_counter_mode  : string := "off";
                extclk3_use_even_counter_mode  : string := "off";

                clk0_use_even_counter_value : string := "off";
                clk1_use_even_counter_value : string := "off";
                clk2_use_even_counter_value : string := "off";
                clk3_use_even_counter_value : string := "off";
                clk4_use_even_counter_value : string := "off";
                clk5_use_even_counter_value : string := "off";
                extclk0_use_even_counter_value : string := "off";
                extclk1_use_even_counter_value : string := "off";
                extclk2_use_even_counter_value : string := "off";
                extclk3_use_even_counter_value : string := "off";
--REM_CYC                scan_chain_mif_file            : string := "";

                skip_vco                    : string := "off";

                XOn: Boolean                := DefGlitchXOn;
                MsgOn: Boolean              := DefGlitchMsgOn;
                tipd_inclk                  : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
                tipd_clkena                 : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
                tipd_extclkena              : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
                tipd_ena                    : VitalDelayType01 := DefPropDelay01;
                tipd_pfdena                 : VitalDelayType01 := DefPropDelay01;
                tipd_areset                 : VitalDelayType01 := DefPropDelay01;
                tipd_fbin                   : VitalDelayType01 := DefPropDelay01;
                tipd_scanclk                : VitalDelayType01 := DefPropDelay01;
                tipd_scanaclr               : VitalDelayType01 := DefPropDelay01;
                tipd_scandata               : VitalDelayType01 := DefPropDelay01;
                tipd_comparator             : VitalDelayType01 := DefPropDelay01 );

    PORT      ( inclk          : IN std_logic_vector(1 downto 0);
                fbin           : IN std_logic := '0';
                ena            : IN std_logic := '1';
                clkswitch      : IN std_logic := '0';
                areset         : IN std_logic := '0';
                pfdena         : IN std_logic := '1';
                clkena         : IN std_logic_vector(5 downto 0) := "111111";
                extclkena      : IN std_logic_vector(3 downto 0) := "1111";
                scanaclr       : IN std_logic := '0';
                scandata       : IN std_logic := '0';
                scanclk        : IN std_logic := '0';
                clk            : OUT std_logic_vector(5 downto 0);
                extclk         : OUT std_logic_vector(3 downto 0);
                clkbad         : OUT std_logic_vector(1 downto 0);
                activeclock    : OUT std_logic;
                locked         : OUT std_logic;
                clkloss        : OUT std_logic;
                scandataout    : OUT std_logic;
                -- lvds specific ports
                comparator     : IN std_logic := '0';
                enable0        : OUT std_logic;
                enable1        : OUT std_logic
            );
END COMPONENT;
--
-- HCSTRATIX_DLL
--

COMPONENT hcstratix_dll
    GENERIC ( input_frequency   : string  := "10000 ps";
              phase_shift       : string  := "0";
              sim_valid_lock    : integer := 1;
              sim_invalid_lock  : integer := 5;
              lpm_type          : string  := "hcstratix_dll"
            );

    PORT    (clk            : IN std_logic;
             delayctrlout   : OUT std_logic
            );
END COMPONENT;
--
-- HCSTRATIX_JTAG
--

component  hcstratix_jtag 
    generic (
            lpm_type	: string := "hcstratix_jtag"
            );
    port    (
            tms : in std_logic := '0'; 
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
            usr1user: out std_logic
            );
end component;

--
--
--  HCSTRATIX_CRCBLOCK 
--
--

component  hcstratix_crcblock 
    generic (
            oscillator_divider : integer := 1;
            lpm_type : string := "hcstratix_crcblock"
            );
	port    (
            clk         : in std_logic := '0'; 
            shiftnld    : in std_logic := '0'; 
           ldsrc       : in std_logic := '0'; 
            crcerror    : out std_logic; 
            regout      : out std_logic
            ); 
end component;
--
--
--  HCSTRATIX_RUBLOCK
--
--

component  hcstratix_rublock 
	generic
	(
		operation_mode		: string := "remote";
		sim_init_config			: string := "factory";
		sim_init_watchdog_value	: integer := 0;
		sim_init_page_select	: integer := 0;
		sim_init_status			: integer := 0;
		lpm_type				: string := "hcstratix_rublock"
	);
	port 
	(
		clk			: in std_logic; 
		shiftnld	: in std_logic; 
		captnupdt	: in std_logic; 
		regin		: in std_logic; 
		rsttimer	: in std_logic; 
		rconfig		: in std_logic; 
		regout		: out std_logic; 
		pgmout		: out std_logic_vector(2 downto 0)
	);
end component;


end hcstratix_components;
