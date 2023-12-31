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
use work.cycloneiii_atom_pack.all;

package CYCLONEIII_COMPONENTS is

--
-- cycloneiii_ff
-- 

component cycloneiii_ff
    generic (
             power_up : string := "low";
             x_on_violation : string := "on";
             lpm_type : string := "cycloneiii_ff";
             tsetup_d_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             tsetup_sload_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_d_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             thold_asdata_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sclr_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_sload_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge	: VitalDelayType := DefSetupHoldCnst;
             tpd_clk_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_clrn_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_aload_q_posedge : VitalDelayType01 := DefPropDelay01;
             tpd_asdata_q: VitalDelayType01 := DefPropDelay01;
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_d : VitalDelayType01 := DefPropDelay01;
             tipd_asdata : VitalDelayType01 := DefPropDelay01;
             tipd_sclr : VitalDelayType01 := DefPropDelay01; 
             tipd_sload : VitalDelayType01 := DefPropDelay01;
             tipd_clrn : VitalDelayType01 := DefPropDelay01; 
             tipd_aload : VitalDelayType01 := DefPropDelay01; 
             tipd_ena : VitalDelayType01 := DefPropDelay01; 
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*"
            );
    
    port (
          d : in std_logic := '0';
          clk : in std_logic := '0';
          clrn : in std_logic := '1';
          aload : in std_logic := '0';
          sclr : in std_logic := '0';
          sload : in std_logic := '0';
          ena : in std_logic := '1';
          asdata : in std_logic := '0';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          q : out std_logic
         );
end component;
        
--
-- cycloneiii_ram_block
--

component cycloneiii_ram_block
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
      port_a_address_clear      : string := "none";
      port_a_data_out_clock     : string := "none";
      port_a_data_out_clear     : string := "none";
      port_a_first_address      : integer := 0;
      port_a_last_address       : integer := 0;
      port_a_first_bit_number   : integer := 0;
      port_a_data_width         : integer := 1;
      port_a_data_in_clock      : string := "clock0"; 
      port_a_address_clock      : string := "clock0"; 
      port_a_write_enable_clock : string := "clock0";
      port_a_read_enable_clock : string := "clock0";      
      port_a_byte_enable_clock  : string := "clock0";
      port_b_logical_ram_depth  : integer := 0;
      port_b_logical_ram_width  : integer := 0;
      port_b_data_in_clock      : string := "clock1";
      port_b_address_clock      : string := "clock1";
      port_b_address_clear      : string := "none";
      port_b_write_enable_clock: STRING := "clock1";    
      port_b_read_enable_clock: STRING := "clock1";    
      port_b_data_out_clock     : string := "none";
      port_b_data_out_clear     : string := "none";
      port_b_first_address      : integer := 0;
      port_b_last_address       : integer := 0;
      port_b_first_bit_number   : integer := 0;
      port_b_data_width         : integer := 1;
      port_b_byte_enable_clock  : string := "clock1";
      port_a_address_width      : integer := 1; 
      port_b_address_width      : integer := 1; 
      port_a_byte_enable_mask_width : integer := 1; 
      port_b_byte_enable_mask_width : integer := 1; 
      power_up_uninitialized	: string := "false";
       port_a_byte_size : integer := 0;
       port_b_byte_size : integer := 0;
      safe_write : string := "err_on_2clk";
      init_file_restructured : string := "unused";
      lpm_type                  : string := "cycloneiii_ram_block";
      lpm_hint                  : string := "true";
      clk0_input_clock_enable  : STRING := "none"; -- ena0,ena2,none
      clk0_core_clock_enable   : STRING := "none"; -- ena0,ena2,none
      clk0_output_clock_enable : STRING := "none"; -- ena0,none
      clk1_input_clock_enable  : STRING := "none"; -- ena1,ena3,none
      clk1_core_clock_enable   : STRING := "none"; -- ena1,ena3,none
      clk1_output_clock_enable : STRING := "none"; -- ena1,none
	-- REMStratix IV -- REMArria II GX -- REMHardCopy III clock_duty_cycle_dependence : STRING := "Auto";
      port_a_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";
      port_b_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";
        mem_init0 : BIT_VECTOR  := X"0";
        mem_init1 : BIT_VECTOR  := X"0";
        mem_init2 : BIT_VECTOR := X"0";
        mem_init3 : BIT_VECTOR := X"0";
        mem_init4 : BIT_VECTOR := X"0";
        connectivity_checking     : string := "off"
        ); 
  port
    (
      portawe           : in std_logic := '0';
      portare           : in std_logic := '1';
      portabyteenamasks : in std_logic_vector (port_a_byte_enable_mask_width - 1 DOWNTO 0) := (others => '1');
      portbbyteenamasks : in std_logic_vector (port_b_byte_enable_mask_width - 1 DOWNTO 0) := (others => '1');
      portbre         : in std_logic := '1';
      portbwe         : in std_logic := '0';
      clr0              : in std_logic := '0';
      clr1              : in std_logic := '0';
      clk0              : in std_logic := '0';
      clk1              : in std_logic := '0';
      ena0              : in std_logic := '1';
      ena1              : in std_logic := '1';
      ena2              : in std_logic := '1';
      ena3              : in std_logic := '1';
      portadatain       : in std_logic_vector (port_a_data_width - 1 DOWNTO 0) := (others => '0');
      portbdatain       : in std_logic_vector (port_b_data_width - 1 DOWNTO 0) := (others => '0');
      portaaddr         : in std_logic_vector (port_a_address_width - 1 DOWNTO 0) := (others => '0');
      portbaddr         : in std_logic_vector (port_b_address_width - 1 DOWNTO 0) := (others => '0');
       portaaddrstall    : in std_logic := '0';
       portbaddrstall    : in std_logic := '0';
      devclrn           : in std_logic := '1';
      devpor            : in std_logic := '1';
      portadataout      : out std_logic_vector (port_a_data_width - 1 DOWNTO 0);
      portbdataout      : out std_logic_vector (port_b_data_width - 1 DOWNTO 0)
    );
end component;


--
-- CYCLONEIII_LCELL_COMB
--
  
component cycloneiii_lcell_comb
    generic (
             lut_mask : std_logic_vector(15 downto 0) := (OTHERS => '1');
             sum_lutc_input : string := "datac";
              dont_touch : string := "off";
             lpm_type : string := "cycloneiii_lcell_comb";
             TimingChecksOn: Boolean := True;
             MsgOn: Boolean := DefGlitchMsgOn;
             XOn: Boolean := DefGlitchXOn;
             MsgOnChecks: Boolean := DefMsgOnChecks;
             XOnChecks: Boolean := DefXOnChecks;
             InstancePath: STRING := "*";
             tpd_dataa_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_combout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_cin : VitalDelayType01 := DefPropDelay01
            );
    
    port (
          dataa : in std_logic := '1';
          datab : in std_logic := '1';
          datac : in std_logic := '1';
          datad : in std_logic := '1';
          cin : in std_logic := '0';
          combout : out std_logic;
          cout : out std_logic
         );

end component;


--
-- CYCLONEIII_CLKCTRL
--

component cycloneiii_clkctrl
    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "cycloneiii_clkctrl";
             ena_register_mode : STRING := "Falling Edge";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_clkselect : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_ena : VitalDelayType01 := DefPropDelay01
             );
    port (
          inclk       : in std_logic_vector(3 downto 0) := "0000";
          clkselect   : in std_logic_vector(1 downto 0) := "00";
          ena         : in std_logic := '1';
          devclrn     : in std_logic := '1';
          devpor      : in std_logic := '1';
          outclk      : out std_logic
         );

end component;	

--
-- CYCLONEIII_ROUTING_WIRE
--

component cycloneiii_routing_wire
    generic (
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             tpd_datain_dataout : VitalDelayType01 := DefPropDelay01;
             tpd_datainglitch_dataout : VitalDelayType01 := DefPropDelay01;
             tipd_datain : VitalDelayType01 := DefPropDelay01
            );
    PORT (
          datain : in std_logic;
          dataout : out std_logic
         );
end component;

--
-- CYCLONEIII_PLL
--

COMPONENT cycloneiii_pll
    GENERIC (

        operation_mode              : string := "normal";
        pll_type                    : string := "auto";  -- EGPP/FAST/AUTO
        compensate_clock            : string := "clock0";
        
        inclk0_input_frequency      : integer := 0;
        inclk1_input_frequency      : integer := 0;
        
        self_reset_on_loss_lock     : string  := "off";
        switch_over_type            : string  := "auto";
    switch_over_counter         : integer := 1;
        enable_switch_over_counter  : string := "off";
        
        
        bandwidth                    : integer := 0;
        bandwidth_type               : string  := "auto";
        use_dc_coupling              : string  := "false";

        
        
        lock_c                      : integer := 4;
        sim_gate_lock_device_behavior : string := "off";
        lock_high                   : integer := 0;
        lock_low                    : integer := 0;
        lock_window_ui              : string := "0.05";
        lock_window                 : time := 5 ps;
        test_bypass_lock_detect     : string := "off";
        

        clk0_output_frequency       : integer := 0;
        clk0_multiply_by            : integer := 0;
        clk0_divide_by              : integer := 0;
        clk0_phase_shift            : string := "0";
        clk0_duty_cycle             : integer := 50;

        clk1_output_frequency       : integer := 0;
        clk1_multiply_by            : integer := 0;
        clk1_divide_by              : integer := 0;
        clk1_phase_shift            : string := "0";
        clk1_duty_cycle             : integer := 50;

        clk2_output_frequency       : integer := 0;
        clk2_multiply_by            : integer := 0;
        clk2_divide_by              : integer := 0;
        clk2_phase_shift            : string := "0";
        clk2_duty_cycle             : integer := 50;

        clk3_output_frequency       : integer := 0;
        clk3_multiply_by            : integer := 0;
        clk3_divide_by              : integer := 0;
        clk3_phase_shift            : string := "0";
        clk3_duty_cycle             : integer := 50;

        clk4_output_frequency       : integer := 0;
        clk4_multiply_by            : integer := 0;
        clk4_divide_by              : integer := 0;
        clk4_phase_shift            : string := "0";
        clk4_duty_cycle             : integer := 50;

        
        
        
        
        

        pfd_min                     : integer := 0;
        pfd_max                     : integer := 0;
        vco_min                     : integer := 0;
        vco_max                     : integer := 0;
        vco_center                  : integer := 0;

        -- ADVANCED USER PARAMETERS
        m_initial                   : integer := 1;
        m                           : integer := 0;
        n                           : integer := 1;

        c0_high                     : integer := 1;
        c0_low                      : integer := 1;
        c0_initial                  : integer := 1; 
        c0_mode                     : string := "bypass";
        c0_ph                       : integer := 0;

        c1_high                     : integer := 1;
        c1_low                      : integer := 1;
        c1_initial                  : integer := 1;
        c1_mode                     : string := "bypass";
        c1_ph                       : integer := 0;

        c2_high                     : integer := 1;
        c2_low                      : integer := 1;
        c2_initial                  : integer := 1;
        c2_mode                     : string := "bypass";
        c2_ph                       : integer := 0;

        c3_high                     : integer := 1;
        c3_low                      : integer := 1;
        c3_initial                  : integer := 1;
        c3_mode                     : string := "bypass";
        c3_ph                       : integer := 0;

        c4_high                     : integer := 1;
        c4_low                      : integer := 1;
        c4_initial                  : integer := 1;
        c4_mode                     : string := "bypass";
        c4_ph                       : integer := 0;
        
        
        
        
        
        
        m_ph                        : integer := 0;
        
        clk0_counter                : string := "unused";
        clk1_counter                : string := "unused";
        clk2_counter                : string := "unused";
        clk3_counter                : string := "unused";
        clk4_counter                : string := "unused";
        
        c1_use_casc_in              : string := "off";
        c2_use_casc_in              : string := "off";
        c3_use_casc_in              : string := "off";
        c4_use_casc_in              : string := "off";
        
        m_test_source               : integer := -1;
        c0_test_source              : integer := -1;
        c1_test_source              : integer := -1;
        c2_test_source              : integer := -1;
        c3_test_source              : integer := -1;
        c4_test_source              : integer := -1;
        
        vco_multiply_by             : integer := 0;
        vco_divide_by               : integer := 0;
        vco_post_scale              : integer := 1;
        vco_frequency_control       : string  := "auto";
        vco_phase_shift_step        : integer := 0;
        
        lpm_type                    : string := "cycloneiii_pll";
        charge_pump_current         : integer := 10;
        loop_filter_r               : string := " 1.0";
        loop_filter_c               : integer := 0;

        
        pll_compensation_delay      : integer := 0;
        simulation_type             : string := "functional";
        
        clk0_use_even_counter_mode  : string := "off";
        clk1_use_even_counter_mode  : string := "off";
        clk2_use_even_counter_mode  : string := "off";
        clk3_use_even_counter_mode  : string := "off";
        clk4_use_even_counter_mode  : string := "off";
        
        clk0_use_even_counter_value : string := "off";
        clk1_use_even_counter_value : string := "off";
        clk2_use_even_counter_value : string := "off";
        clk3_use_even_counter_value : string := "off";
        clk4_use_even_counter_value : string := "off";
            
-- Test only
        init_block_reset_a_count    : integer := 1;
        init_block_reset_b_count    : integer := 1;
        charge_pump_current_bits : integer := 0;
        lock_window_ui_bits : integer := 0;
        loop_filter_c_bits : integer := 0;
        loop_filter_r_bits : integer := 0;
        test_counter_c0_delay_chain_bits : integer := 0;
        test_counter_c1_delay_chain_bits : integer := 0;
        test_counter_c2_delay_chain_bits : integer := 0;
        test_counter_c3_delay_chain_bits : integer := 0;
        test_counter_c4_delay_chain_bits : integer := 0;
        test_counter_c5_delay_chain_bits : integer := 0;
        test_counter_m_delay_chain_bits : integer := 0;
        test_counter_n_delay_chain_bits : integer := 0;
        test_feedback_comp_delay_chain_bits : integer := 0;
        test_input_comp_delay_chain_bits : integer := 0;
        test_volt_reg_output_mode_bits : integer := 0;
        test_volt_reg_output_voltage_bits : integer := 0;
        test_volt_reg_test_mode : string := "false";
        vco_range_detector_high_bits : integer := -1;
        vco_range_detector_low_bits : integer := -1;
    scan_chain_mif_file : string := "";
         auto_settings : string  := "true";    
--REM_MF        -- VITAL generics
--REM_MF        XOn                         : Boolean := DefGlitchXOn;
--REM_MF        MsgOn                       : Boolean := DefGlitchMsgOn;
--REM_MF        MsgOnChecks                 : Boolean := DefMsgOnChecks;
--REM_MF        XOnChecks                   : Boolean := DefXOnChecks;
--REM_MF        TimingChecksOn              : Boolean := true;
--REM_MF        InstancePath                : STRING := "*";
--REM_MF        tipd_inclk                  : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
--REM_MF        tipd_ena                    : VitalDelayType01 := DefPropDelay01;
--REM_MF        tipd_pfdena                 : VitalDelayType01 := DefPropDelay01;
--REM_MF        tipd_areset                 : VitalDelayType01 := DefPropDelay01;
--REM_MF       tipd_fbin                   : VitalDelayType01 := DefPropDelay01;
--REM_MF       tipd_scanclk                : VitalDelayType01 := DefPropDelay01;
--REM_MF       tipd_scanclkena             : VitalDelayType01 := DefPropDelay01;
--REM_MF       tipd_scandata               : VitalDelayType01 := DefPropDelay01;
--REM_MF       tipd_configupdate           : VitalDelayType01 := DefPropDelay01;
--REM_MF       tipd_clkswitch              : VitalDelayType01 := DefPropDelay01;
--REM_MF       tipd_phaseupdown            : VitalDelayType01 := DefPropDelay01;
--REM_MF       tipd_phasecounterselect     : VitalDelayArrayType01(2 DOWNTO 0) := (OTHERS => DefPropDelay01);
--REM_MF       tipd_phasestep              : VitalDelayType01 := DefPropDelay01;
--REM_MF       tsetup_scandata_scanclk_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
--REM_MF       thold_scandata_scanclk_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
--REM_MF       tsetup_scanclkena_scanclk_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
--REM_MF       thold_scanclkena_scanclk_noedge_negedge  : VitalDelayType := DefSetupHoldCnst;
        use_vco_bypass              : string := "false"
            );

    PORT    (
        inclk                       : in std_logic_vector(1 downto 0);
        fbin                         : in std_logic := '0';
        fbout                        : out std_logic;
        clkswitch                   : in std_logic := '0';
        areset                      : in std_logic := '0';
        pfdena                      : in std_logic := '1';
        scandata                    : in std_logic := '0';
        scanclk                     : in std_logic := '0';
        scanclkena                  : in std_logic := '1';
        configupdate                : in std_logic := '0';
        clk                         : out std_logic_vector(4 downto 0);
        phasecounterselect          : in std_logic_vector(2 downto 0) := "000";
        phaseupdown                 : in std_logic := '0';
        phasestep                   : in std_logic := '0';
        clkbad                      : out std_logic_vector(1 downto 0);
        activeclock                 : out std_logic;
        locked                      : out std_logic;
        scandataout                 : out std_logic;
        scandone                    : out std_logic;
        phasedone                   : out std_logic;
        vcooverrange                : out std_logic;
        vcounderrange               : out std_logic

            );
END COMPONENT;
--
-- cycloneiii_mac_mult
--

component cycloneiii_mac_mult
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             dataa_width : integer := 18;    
             datab_width : integer := 18;    
             dataa_clock : string := "none";    
             datab_clock : string := "none";    
             signa_clock : string := "none";    
             signb_clock : string := "none";    
             lpm_hint : string := "true";    
             lpm_type : string := "cycloneiii_mac_mult"
            );
    PORT (
          dataa : IN std_logic_vector(dataa_width-1 DOWNTO 0) := (OTHERS => '0');
          datab : IN std_logic_vector(datab_width-1 DOWNTO 0) := (OTHERS => '0');
          signa : IN std_logic := '1';   
          signb : IN std_logic := '1';
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '1';
          dataout : OUT std_logic_vector((dataa_width+datab_width)-1 DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );
end component;

--
-- cycloneiii_mac_out
--

component cycloneiii_mac_out
    GENERIC (
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_dataa : VitalDelayArrayType01(35 downto 0)
                                   := (OTHERS => DefPropDelay01);
             tipd_clk : VitalDelayType01 := DefPropDelay01;
             tipd_ena : VitalDelayType01 := DefPropDelay01;
             tipd_aclr : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_dataout :VitalDelayArrayType01(36*36 -1 downto 0) :=(others => DefPropDelay01);
             tpd_aclr_dataout_posedge : VitalDelayArrayType01(35 downto 0) :=(others => DefPropDelay01);
             tpd_clk_dataout_posedge :VitalDelayArrayType01(35  downto 0) :=(others => DefPropDelay01);
             tsetup_dataa_clk_noedge_posedge : VitalDelayArrayType(35 downto 0) := (OTHERS => DefSetupHoldCnst);
             thold_dataa_clk_noedge_posedge :  VitalDelayArrayType(35 downto 0) := (OTHERS => DefSetupHoldCnst);
             tsetup_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             thold_ena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
             dataa_width                    :  integer := 1;    
             output_clock                   :  string := "none";    
             lpm_hint                       :  string := "true";    
             lpm_type                       :  string := "cycloneiii_mac_out"
            );
    PORT (
          dataa : IN std_logic_vector(dataa_width-1  DOWNTO 0) := (OTHERS => '0');
          clk : IN std_logic := '0';
          aclr : IN std_logic := '0';
          ena : IN std_logic := '1';
          dataout : OUT std_logic_vector(dataa_width-1  DOWNTO 0);   
          devclrn : IN std_logic := '1';
          devpor : IN std_logic := '1'
         );   
end component;

--
-- cycloneiii_termination Model
--

COMPONENT cycloneiii_termination
    GENERIC (
         pullup_control_to_core:  string := "false";    
         power_down            :  string := "true";    
         test_mode             :  string := "false";    
         left_shift_termination_code :  string := "false";    
         pullup_adder          :  integer := 0;    
         pulldown_adder        :  integer := 0;    
         clock_divide_by      :  integer := 32;    --  1, 4, 32
         runtime_control       :  string := "false";    
         shift_vref_rup        :  string := "true";    
         shift_vref_rdn        :  string := "true";    
         shifted_vref_control  :  string := "true";    
         lpm_type              :  string := "cycloneiii_termination");
    PORT (
        rup                     : IN std_logic := '0';   
        rdn                     : IN std_logic := '0';   
        terminationclock        : IN std_logic := '0';   
        terminationclear        : IN std_logic := '0';  
        devpor                  : IN std_logic := '1';   
        devclrn                 : IN std_logic := '1';   
        comparatorprobe         : OUT std_logic;   
        terminationcontrolprobe : OUT std_logic;   
        calibrationdone         : OUT std_logic;   
        terminationcontrol      : OUT std_logic_vector(15 DOWNTO 0));   
END COMPONENT;
--
-- CYCLONEIII_IO_IBUF
--

COMPONENT cycloneiii_io_ibuf 
    GENERIC (
             tipd_i                  : VitalDelayType01 := DefPropDelay01;
             tipd_ibar               : VitalDelayType01 := DefPropDelay01;
             tpd_i_o                 : VitalDelayType01 := DefPropDelay01;
             tpd_ibar_o              : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;
             differential_mode       :  string := "false";
             bus_hold                :  string := "false";
             simulate_z_as          : string    := "Z";
             lpm_type                :  string := "cycloneiii_io_ibuf"
            );    
    PORT (
          i                       : IN std_logic := '0';   
          ibar                    : IN std_logic := '0';   
          o                       : OUT std_logic
         );       
END COMPONENT;

--
-- CYCLONEIII_IO_OBUF
--

COMPONENT cycloneiii_io_obuf 
    GENERIC (
             tipd_i                           : VitalDelayType01 := DefPropDelay01;
             tipd_oe                          : VitalDelayType01 := DefPropDelay01;
             tpd_i_o                          : VitalDelayType01 := DefPropDelay01;
             tpd_oe_o                         : VitalDelayType01 := DefPropDelay01;
             tpd_i_obar                       : VitalDelayType01 := DefPropDelay01;
             tpd_oe_obar                      : VitalDelayType01 := DefPropDelay01;
             XOn                           : Boolean := DefGlitchXOn;
             MsgOn                         : Boolean := DefGlitchMsgOn;  
             open_drain_output                :  string := "false";              
             bus_hold                         :  string := "false";              
             lpm_type                         :  string := "cycloneiii_io_obuf"
            );               
    PORT (
           i                       : IN std_logic := '0';                                                 
           oe                      : IN std_logic := '1';                                                 
           seriesterminationcontrol    : IN std_logic_vector(15 DOWNTO 0) := (others => '0'); 
           devoe                   : IN std_logic := '1'; 
           o                       : OUT std_logic;                                                       
           obar                    : OUT std_logic
         );                                                      
END COMPONENT;



--
-- CYCLONEIII_DDIO_OE
--

COMPONENT cycloneiii_ddio_oe 
    generic(
            tipd_oe                        : VitalDelayType01 := DefPropDelay01;
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;
            XOn                                : Boolean := DefGlitchXOn;           
            MsgOn                              : Boolean := DefGlitchMsgOn;         
            power_up              :  string := "low";    
            async_mode            :  string := "none";    
            sync_mode             :  string := "none";
            lpm_type              :  string := "cycloneiii_ddio_oe"
           );    
      
    PORT (
          oe                      : IN std_logic := '1';   
          clk                     : IN std_logic := '0';   
          ena                     : IN std_logic := '1';   
          areset                  : IN std_logic := '0';   
          sreset                  : IN std_logic := '0';   
          dataout                 : OUT std_logic;         
          dfflo                   : OUT std_logic;         
          dffhi                   : OUT std_logic;         
          devclrn                 : IN std_logic := '1';               
          devpor                  : IN std_logic := '1'
         );             
END COMPONENT;
--
-- CYCLONEIII_DDIO_OUT
--

COMPONENT cycloneiii_ddio_out 
    generic(
            tipd_datainlo                      : VitalDelayType01 := DefPropDelay01;
            tipd_datainhi                      : VitalDelayType01 := DefPropDelay01;
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;
            tipd_clkhi                         : VitalDelayType01 := DefPropDelay01;
            tipd_clklo                         : VitalDelayType01 := DefPropDelay01;
            tipd_muxsel                        : VitalDelayType01 := DefPropDelay01;
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;
            XOn                                : Boolean := DefGlitchXOn;           
            MsgOn                              : Boolean := DefGlitchMsgOn;         
            power_up                           :  string := "low";          
            async_mode                         :  string := "none";       
            sync_mode                          :  string := "none";
            use_new_clocking_model             :  string := "false";
            lpm_type                           :  string := "cycloneiii_ddio_out"
           );
    PORT (
          datainlo                : IN std_logic := '0';   
          datainhi                : IN std_logic := '0';   
          clk                     : IN std_logic := '0'; 
          clkhi                   : IN std_logic := '0'; 
          clklo                   : IN std_logic := '0'; 
          muxsel                  : IN std_logic := '0';   
          ena                     : IN std_logic := '1';   
          areset                  : IN std_logic := '0';   
          sreset                  : IN std_logic := '0';   
          dataout                 : OUT std_logic;         
          dfflo                   : OUT std_logic;         
          dffhi                   : OUT std_logic ;         
          devclrn                 : IN std_logic := '1';   
          devpor                  : IN std_logic := '1'   
        );   
END COMPONENT;


--
-- cycloneiii_pseudo_diff_out
--

COMPONENT cycloneiii_pseudo_diff_out
 GENERIC (
          tipd_i          : VitalDelayType01 := DefPropDelay01;
          tpd_i_o         : VitalDelayType01 := DefPropDelay01;
          tpd_i_obar      : VitalDelayType01 := DefPropDelay01;
          XOn             : Boolean := DefGlitchXOn;
          MsgOn           : Boolean := DefGlitchMsgOn;
          lpm_type        :  string := "cycloneiii_pseudo_diff_out"
         );

 PORT (
        i                       : IN std_logic := '0';
        o                       : OUT std_logic;
        obar                    : OUT std_logic
      );
END COMPONENT;
--
-- CYCLONEIII_IO_PAD
--
component cycloneiii_io_pad 

	generic (
		lpm_type : STRING := "cycloneiii_io_pad"
		);
	PORT ( 
       		padin : in std_logic := '1'; 
       		padout: out std_logic
     	     );
end component;
--
--
--  CYCLONEIII_RUBLOCK
--
--

component  cycloneiii_rublock 
	generic
	(
		sim_init_config			: string := "factory";
		sim_init_watchdog_value	: integer := 0;
		sim_init_status			: integer := 0;
		lpm_type: string := "cycloneiii_rublock"
	);
	port 
	(
		clk	        : in std_logic; 
		shiftnld	: in std_logic; 
		captnupdt	: in std_logic; 
		regin		: in std_logic; 
		rsttimer	: in std_logic; 
		rconfig		: in std_logic; 
		regout		: out std_logic
	);
end component;

--
--
--  CYCLONEIII_APFCONTROLLER
--
--

component  cycloneiii_apfcontroller 
	generic
	(
		lpm_type: string := "cycloneiii_apfcontroller"
	);
	port 
	(
		usermode  : out std_logic;  --REM_TARPON
		nceout	: out std_logic
	);
end component;

--
-- CYCLONEIII_JTAG
--

component  cycloneiii_jtag 
    generic (
            lpm_type	: string := "cycloneiii_jtag"
            );
    port    (
            tms : in std_logic := '0'; 
            tck : in std_logic := '0'; 
            tdi : in std_logic := '0'; 
--REM_CYCyclone III            ntrst : in std_logic := '0'; 
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
--  CYCLONEIII_CRCBLOCK 
--
--

component  cycloneiii_crcblock 
    generic (
            oscillator_divider : integer := 1;
            lpm_type : string := "cycloneiii_crcblock"
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
--  CYCLONEIII_OSCILLATOR
--
--

component  cycloneiii_oscillator 
	generic
	(
		lpm_type: string := "cycloneiii_oscillator"
	);
	port 
	(
		oscena	        : in std_logic; 
		clkout		: out std_logic
	);
end component;


end cycloneiii_components;
