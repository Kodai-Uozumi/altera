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
-- Copyright (C) 1991-2007 Altera Corporation
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
-- Quartus II 7.2 Internal Build 86 06/10/2007

library IEEE,stratixiv;
use IEEE.STD_LOGIC_1164.all;

package stratixiv_components is

---------------------------------------------------------------------
--
-- Entity Name :  stratixiv_ff
-- 
-- Description :  Stratix III FF VHDL simulation model
--  
--
---------------------------------------------------------------------

--
--  stratixiv_CLKSELECT Model
--

component stratixiv_clkselect 
    generic (
             lpm_type : string := "stratixiv_clkselect"
             );
    port (
          inclk : in std_logic_vector(3 downto 0) := "0000";
          clkselect : in std_logic_vector(1 downto 0) := "00";
          outclk : out std_logic
          );    
end component;

--
-- stratixiv_CLKENA
--

component stratixiv_clkena

    generic (
             clock_type : string := "unsed";
             lpm_type : string := "stratixiv_clkena";
             ena_register_mode : string := "falling_edge"
             );
    port (
          inclk : in std_logic := '0';
          ena : in std_logic := '1';
          devclrn : in std_logic := '1';
          devpor : in std_logic := '1';
          enaout : out std_logic;
          outclk : out std_logic
          );    

end component;	
--
-- stratixiv_MLAB_CELL
--

component stratixiv_mlab_cell
  generic 
    (
        logical_ram_name               :  string := "lutram";
        init_file                      :  string := "UNUSED";    
        data_interleave_offset_in_bits :  integer := 1;    
        logical_ram_depth       :  integer := 0;    
        logical_ram_width       :  integer := 0;    
        first_address           :  integer := 0;    
        last_address            :  integer := 0;    
        first_bit_number        :  integer := 0;
        data_width              :  integer := 1;    
        address_width           :  integer := 1;    
        byte_enable_mask_width  :  integer := 1;    
        lpm_type                  : string := "stratixiv_mlab_cell";
		mixed_port_feed_through_mode : string := "dont_care";
        mem_init0 : bit_vector := X"0"
    );
  port
    (
        portadatain             : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)    := (OTHERS => '0');   
        portaaddr               : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        portabyteenamasks       : IN STD_LOGIC_VECTOR(byte_enable_mask_width - 1 DOWNTO 0) := (OTHERS => '1');   
        portbaddr               : IN STD_LOGIC_VECTOR(address_width - 1 DOWNTO 0) := (OTHERS => '0');   
        clk0                : IN STD_LOGIC := '0';   
        ena0                : IN STD_LOGIC := '1';   
        portbdataout            : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
end component;

--
-- stratixiv_IO_IBUF
--

component stratixiv_io_ibuf 
    GENERIC (
             differential_mode       :  string := "false";
             bus_hold                :  string := "false";
             lpm_type                :  string := "stratixiv_io_ibuf"
            );    
    port (
          i                       : IN std_logic := '0';   
          ibar                    : IN std_logic := '0';   
          dynamicterminationcontrol  : IN std_logic := '0';   
          o                       : OUT std_logic
         );       
end component;

--
-- stratixiv_IO_OBUF
--

component stratixiv_io_obuf 
    GENERIC (
             open_drain_output                :  string := "false";              
             shift_series_termination_control :  string := "false";  
             bus_hold                         :  string := "false";              
             lpm_type                         :  string := "stratixiv_io_obuf"
            );               
    port (
           i                       : IN std_logic := '0';                                                 
           oe                      : IN std_logic := '1';                                                 
           dynamicterminationcontrol   : IN std_logic := '0';                                 
           seriesterminationcontrol    : IN std_logic_vector(13 DOWNTO 0) := (others => '0'); 
           parallelterminationcontrol  : IN std_logic_vector(13 DOWNTO 0) := (others => '0'); 
           devoe                   : IN std_logic := '1'; 
           o                       : OUT std_logic;                                                       
           obar                    : OUT std_logic
         );                                                      
end component;

--                                      
-- stratixiv_DDIO_IN                        
--                                      

component stratixiv_ddio_in                                                                                        
    generic(                                                                                                  
            power_up                           :  string := "low";                                            
            async_mode                         :  string := "none";                                         
            sync_mode                          :  string := "none";                                         
            use_clkn                           :  string := "false";                                          
            lpm_type                           :  string := "stratixiv_ddio_in"                                   
           );                                                                                                 
    port (                                                                                                    
           datain                  : IN std_logic := '0';                                                     
           clk                     : IN std_logic := '0';                                                     
           clkn                    : IN std_logic := '0';                                                     
           ena                     : IN std_logic := '1';                                                     
           areset                  : IN std_logic := '0';                                                     
           sreset                  : IN std_logic := '0';                                                     
           regoutlo                : OUT std_logic;                                                           
           regouthi                : OUT std_logic;                                                           
           dfflo                   : OUT std_logic;                                                           
           devclrn                 : IN std_logic := '1';                                                     
           devpor                  : IN std_logic := '1'                                                      
        );                                                                                                    
end component;                                                                                            

--
-- stratixiv_DDIO_OE
--

component stratixiv_ddio_oe 
    generic(
            power_up              :  string := "low";    
            async_mode            :  string := "none";    
            sync_mode             :  string := "none";
            lpm_type              :  string := "stratixiv_ddio_oe"
           );    
      
    port (
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
end component;
--
-- stratixiv_DDIO_OUT
--

component stratixiv_ddio_out 
    generic(
            power_up                           :  string := "low";          
            async_mode                         :  string := "none";       
            sync_mode                          :  string := "none";   
            half_rate_mode                     :  string := "false";           
            lpm_type                           :  string := "stratixiv_ddio_out"
           );
    port (
          datainlo                : IN std_logic := '0';   
          datainhi                : IN std_logic := '0';   
          clk                     : IN std_logic := '0';   
          ena                     : IN std_logic := '1';   
          areset                  : IN std_logic := '0';   
          sreset                  : IN std_logic := '0';   
          dataout                 : OUT std_logic;         
          dfflo                   : OUT std_logic;         
          dffhi                   : OUT std_logic ;         
          devclrn                 : IN std_logic := '1';   
          devpor                  : IN std_logic := '1'   
        );   
end component;



component stratixiv_termination
    GENERIC (
        runtime_control                :  string := "false";    
        allow_serial_data_from_core    :  string := "false";    
        power_down                     :  string := "true";    
        enable_parallel_termination    :  string := "false";    
        test_mode                      :  string := "false"; 
        lpm_type                       :  string := "stratixiv_termination");    
    port (
        rup                     : IN std_logic := '0';   
        rdn                     : IN std_logic := '0';   
        terminationclock        : IN std_logic := '0';   
        terminationclear        : IN std_logic := '0';   
        terminationenable       : IN std_logic := '1';   
        serializerenable        : IN std_logic := '0';   
        terminationcontrolin    : IN std_logic := '0';   
        otherserializerenable   : IN std_logic_vector(8 DOWNTO 0) := (OTHERS => '0');   
        devclrn                 : IN std_logic := '1';   
        devpor                  : IN std_logic := '1';   
        incrup                  : OUT std_logic;   
        incrdn                  : OUT std_logic;   
        serializerenableout     : OUT std_logic;   
        terminationcontrol      : OUT std_logic;   
        terminationcontrolprobe : OUT std_logic;   
        shiftregisterprobe      : OUT std_logic);   
end component;

component stratixiv_termination_logic
    GENERIC (
        lpm_type                       : string := "stratixiv_termination_logic");    
    port (
        serialloadenable        : IN std_logic := '0';   
        terminationclock        : IN std_logic := '0';   
        parallelloadenable      : IN std_logic := '0';   
        terminationdata         : IN std_logic := '0';   
        devclrn                 : IN std_logic := '1';   
        devpor                  : IN std_logic := '1';   
        seriesterminationcontrol   : OUT std_logic_vector(13 DOWNTO 0);   
        parallelterminationcontrol : OUT std_logic_vector(13 DOWNTO 0));   
end component;


component stratixiv_delay_chain
    GENERIC ( 
        use_delayctrlin                   : string := "true";
        delay_setting                     : integer := 0;
        lpm_type                          : string := "stratixiv_delay_chain"
    );
    
    port (
        datain       : IN std_logic := '0';
        delayctrlin  : IN std_logic_vector(3 downto 0) := (OTHERS => '0');
        devclrn      : IN std_logic := '1';
        devpor       : IN std_logic := '1';
        dataout      : OUT std_logic
    );

end component;
    
--
-- stratixiv_mac_mult
--

component stratixiv_mac_mult 
   GENERIC (
            dataa_width                    :  integer := 18;    
            datab_width                    :  integer := 18;    
            dataa_clock                    :  string := "none";    
            datab_clock                    :  string := "none";    
            signa_clock                    :  string := "none";    
            signb_clock                    :  string := "none";    
            scanouta_clock                 :  string := "none";    
            dataa_clear                    :  string := "none";    
            datab_clear                    :  string := "none";    
            signa_clear                    :  string := "none";    
            signb_clear                    :  string := "none";    
            scanouta_clear                 :  string := "none";    
            signa_internally_grounded      :  string := "false";    
            signb_internally_grounded      :  string := "false";
			dataout_width                  :  integer := 36;
            lpm_type                       :  string := "stratixiv_mac_mult"
           );    
   port (
         dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '1');    
         datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '1');    
         signa                   : IN std_logic := '1';  
         signb                   : IN std_logic := '1';  
         clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
         aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
         ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');   
         dataout                 : OUT std_logic_vector(dataa_width + datab_width - 1 DOWNTO 0);    
         scanouta                : OUT std_logic_vector(dataa_width - 1 DOWNTO 0);   
         devclrn                 : IN std_logic := '1';  
         devpor                  : IN std_logic := '1'
        );   
end component;

--
-- stratixiv_mac_out
--

component stratixiv_mac_out
  GENERIC (
            operation_mode                 :  string := "output_only";    
            dataa_width                    :  integer := 1;    
            datab_width                    :  integer := 1;    
            datac_width                    :  integer := 1;    
            datad_width                    :  integer := 1;    
            chainin_width                  :  integer := 1;    
            round_width                    :  integer := 15;    
            round_chain_out_width          :  integer := 15;    
            saturate_width                 :  integer := 15;    
            saturate_chain_out_width       :  integer := 15;    
            first_adder0_clock             :  string := "none";    
            first_adder0_clear             :  string := "none";    
            first_adder1_clock             :  string := "none";    
            first_adder1_clear             :  string := "none";    
            second_adder_clock             :  string := "none";    
            second_adder_clear             :  string := "none";    
            output_clock                   :  string := "none";    
            output_clear                   :  string := "none";    
            signa_clock                    :  string := "none";    
            signa_clear                    :  string := "none";    
            signb_clock                    :  string := "none";    
            signb_clear                    :  string := "none";    
            round_clock                    :  string := "none";    
            round_clear                    :  string := "none";    
            roundchainout_clock            :  string := "none";    
            roundchainout_clear            :  string := "none";    
            saturate_clock                 :  string := "none";    
            saturate_clear                 :  string := "none";    
            saturatechainout_clock         :  string := "none";    
            saturatechainout_clear         :  string := "none";    
            zeroacc_clock                  :  string := "none";    
            zeroacc_clear                  :  string := "none";    
            zeroloopback_clock             :  string := "none";    
            zeroloopback_clear             :  string := "none";    
            rotate_clock                   :  string := "none";    
            rotate_clear                   :  string := "none";    
            shiftright_clock               :  string := "none";    
            shiftright_clear               :  string := "none";    
            signa_pipeline_clock           :  string := "none";    
            signa_pipeline_clear           :  string := "none";    
            signb_pipeline_clock           :  string := "none";    
            signb_pipeline_clear           :  string := "none";    
            round_pipeline_clock           :  string := "none";    
            round_pipeline_clear           :  string := "none";    
            roundchainout_pipeline_clock   :  string := "none";    
            roundchainout_pipeline_clear   :  string := "none";    
            saturate_pipeline_clock        :  string := "none";    
            saturate_pipeline_clear        :  string := "none";    
            saturatechainout_pipeline_clock:  string := "none";    
            saturatechainout_pipeline_clear:  string := "none";    
            zeroacc_pipeline_clock         :  string := "none";    
            zeroacc_pipeline_clear         :  string := "none";    
            zeroloopback_pipeline_clock    :  string := "none";    
            zeroloopback_pipeline_clear    :  string := "none";    
            rotate_pipeline_clock          :  string := "none";    
            rotate_pipeline_clear          :  string := "none";    
            shiftright_pipeline_clock      :  string := "none";    
            shiftright_pipeline_clear      :  string := "none";    
            roundchainout_output_clock     :  string := "none";    
            roundchainout_output_clear     :  string := "none";    
            saturatechainout_output_clock  :  string := "none";    
            saturatechainout_output_clear  :  string := "none";    
            zerochainout_output_clock      :  string := "none";    
            zerochainout_output_clear      :  string := "none";    
            zeroloopback_output_clock      :  string := "none";    
            zeroloopback_output_clear      :  string := "none";    
            rotate_output_clock            :  string := "none";    
            rotate_output_clear            :  string := "none";    
            shiftright_output_clock        :  string := "none";    
            shiftright_output_clear        :  string := "none";    
            first_adder0_mode              :  string := "add";    
            first_adder1_mode              :  string := "add";    
            acc_adder_operation            :  string := "add";    
            round_mode                     :  string := "nearest_integer";    
            round_chain_out_mode           :  string := "nearest_integer";    
            saturate_mode                  :  string := "asymmetric";    
            saturate_chain_out_mode        :  string := "asymmetric";
            lpm_type                       :  string := "stratixiv_mac_out";
            dataout_width                  :  integer:= 72
           );    
    port (
          dataa                   : IN std_logic_vector(dataa_width - 1 DOWNTO 0):= (others => '1');   
          datab                   : IN std_logic_vector(datab_width - 1 DOWNTO 0):= (others => '1');   
          datac                   : IN std_logic_vector(datac_width - 1 DOWNTO 0):= (others => '1');   
          datad                   : IN std_logic_vector(datad_width - 1 DOWNTO 0):= (others => '1');   
          signa                   : IN std_logic := '1';  
          signb                   : IN std_logic := '1';  
          chainin                 : IN std_logic_vector(chainin_width - 1 DOWNTO 0):= (others => '0');   
          round                   : IN std_logic := '0';  
          saturate                : IN std_logic := '0';  
          zeroacc                 : IN std_logic := '0';  
          roundchainout           : IN std_logic := '0';  
          saturatechainout        : IN std_logic := '0';  
          zerochainout            : IN std_logic := '0';  
          zeroloopback            : IN std_logic := '0';  
          rotate                  : IN std_logic := '0';  
          shiftright              : IN std_logic := '0';  
          clk                     : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
          ena                     : IN std_logic_vector(3 DOWNTO 0) := (others => '1');   
          aclr                    : IN std_logic_vector(3 DOWNTO 0) := (others => '0');   
          loopbackout             : OUT std_logic_vector(17 DOWNTO 0):= (others => '0');   
          dataout                 : OUT std_logic_vector(71 DOWNTO 0) := (others => '0');   
          overflow                : OUT std_logic := '0'; 
          saturatechainoutoverflow: OUT std_logic := '0';
          dftout                  : OUT std_logic := '0';
          devpor                  : IN std_logic := '1';  
          devclrn                 : IN std_logic := '1'
       );   
end component;

--
-- stratixiv_IO_PAD
--
component stratixiv_io_pad 

	generic (
		lpm_type : string := "stratixiv_io_pad"
		);
	port ( 
       		padin : in std_logic := '1'; 
       		padout: out std_logic
     	     );
end component;
--
-- stratixiv_PLL
--

component stratixiv_pll
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
        
         dpa_multiply_by : integer := 0;
         dpa_divide_by   : integer := 0;
         dpa_divider     : integer := 0;
        
        bandwidth                    : integer := 0;
        bandwidth_type               : string  := "auto";
        use_dc_coupling              : string  := "false";

        
        
        lock_c                      : integer := 4;
        sim_gate_lock_device_behavior : string := "off";
        lock_high                   : integer := 0;
        lock_low                    : integer := 0;
        lock_window_ui              : string := "0.05";
		lock_window_ui_bits         : string := "UNUSED";
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

        clk5_output_frequency       : integer := 0;
        clk5_multiply_by            : integer := 0;
        clk5_divide_by              : integer := 0;
        clk5_phase_shift            : string := "0";
        clk5_duty_cycle             : integer := 50;
        
        clk6_output_frequency       : integer := 0;
        clk6_multiply_by            : integer := 0;
        clk6_divide_by              : integer := 0;
        clk6_phase_shift            : string := "0";
        clk6_duty_cycle             : integer := 50;
        
        clk7_output_frequency       : integer := 0;
        clk7_multiply_by            : integer := 0;
        clk7_divide_by              : integer := 0;
        clk7_phase_shift            : string := "0";
        clk7_duty_cycle             : integer := 50;
        
        clk8_output_frequency       : integer := 0;
        clk8_multiply_by            : integer := 0;
        clk8_divide_by              : integer := 0;
        clk8_phase_shift            : string := "0";
        clk8_duty_cycle             : integer := 50;
        
        clk9_output_frequency       : integer := 0;
        clk9_multiply_by            : integer := 0;
        clk9_divide_by              : integer := 0;
        clk9_phase_shift            : string := "0";
        clk9_duty_cycle             : integer := 50;
        

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
        
        c5_high                     : integer := 1;
        c5_low                      : integer := 1;
        c5_initial                  : integer := 1;
        c5_mode                     : string := "bypass";
        c5_ph                       : integer := 0;
        
        c6_high                     : integer := 1;
        c6_low                      : integer := 1;
        c6_initial                  : integer := 1;
        c6_mode                     : string := "bypass";
        c6_ph                       : integer := 0;
        
        c7_high                     : integer := 1;
        c7_low                      : integer := 1;
        c7_initial                  : integer := 1;
        c7_mode                     : string := "bypass";
        c7_ph                       : integer := 0;
        
        c8_high                     : integer := 1;
        c8_low                      : integer := 1;
        c8_initial                  : integer := 1;
        c8_mode                     : string := "bypass";
        c8_ph                       : integer := 0;
        
        c9_high                     : integer := 1;
        c9_low                      : integer := 1;
        c9_initial                  : integer := 1;
        c9_mode                     : string := "bypass";
        c9_ph                       : integer := 0;
        
        m_ph                        : integer := 0;
        
        clk0_counter                : string := "unused";
        clk1_counter                : string := "unused";
        clk2_counter                : string := "unused";
        clk3_counter                : string := "unused";
        clk4_counter                : string := "unused";
        clk5_counter                : string := "unused";
        clk6_counter                : string := "unused";
        clk7_counter                : string := "unused";
        clk8_counter                : string := "unused";
        clk9_counter                : string := "unused";
        
        c1_use_casc_in              : string := "off";
        c2_use_casc_in              : string := "off";
        c3_use_casc_in              : string := "off";
        c4_use_casc_in              : string := "off";
         c5_use_casc_in              : string := "off";
         c6_use_casc_in              : string := "off";
         c7_use_casc_in              : string := "off";
         c8_use_casc_in              : string := "off";
         c9_use_casc_in              : string := "off";
        
        m_test_source               : integer := -1;
        c0_test_source              : integer := -1;
        c1_test_source              : integer := -1;
        c2_test_source              : integer := -1;
        c3_test_source              : integer := -1;
        c4_test_source              : integer := -1;
         c5_test_source              : integer := -1;
         c6_test_source              : integer := -1;
         c7_test_source              : integer := -1;
         c8_test_source              : integer := -1;
         c9_test_source              : integer := -1;
        
        vco_multiply_by             : integer := 0;
        vco_divide_by               : integer := 0;
        vco_post_scale              : integer := 1;
        vco_frequency_control       : string  := "auto";
        vco_phase_shift_step        : integer := 0;
        vco_range_detector_high_bits	: string := "UNUSED";
		vco_range_detector_low_bits 	: string := "UNUSED";
		
        lpm_type                    : string := "stratixiv_pll";
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
    	clk5_use_even_counter_mode  : string := "off";
        clk6_use_even_counter_mode  : string := "off";
        clk7_use_even_counter_mode  : string := "off";
        clk8_use_even_counter_mode  : string := "off";
        clk9_use_even_counter_mode  : string := "off";
        
        clk0_use_even_counter_value : string := "off";
        clk1_use_even_counter_value : string := "off";
        clk2_use_even_counter_value : string := "off";
        clk3_use_even_counter_value : string := "off";
        clk4_use_even_counter_value : string := "off";
        clk5_use_even_counter_value : string := "off";
        clk6_use_even_counter_value : string := "off";
        clk7_use_even_counter_value : string := "off";
        clk8_use_even_counter_value : string := "off";
        clk9_use_even_counter_value : string := "off"
     );

    port    (
        inclk                       : in std_logic_vector(1 downto 0);
        fbin                         : in std_logic := '0';
        fbout                        : out std_logic;
        clkswitch                   : in std_logic := '0';
        areset                      : in std_logic := '0';
        pfdena                      : in std_logic := '1';
        scandata                    : in std_logic := '0';
        scanclk                     : in std_logic := '0';
        scanclkena                  : in std_logic := '0';
        configupdate                : in std_logic := '0';
        clk                         : out std_logic_vector(9 downto 0);
        phasecounterselect          : in std_logic_vector(3 downto 0) := "0000";
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
end component;
--
-- stratixiv_ASMIBLOCK
--
component  stratixiv_asmiblock
    generic (
        lpm_type : string := "stratixiv_asmiblock"
        );	
    port (
        dclkin : in std_logic := '0'; 
        scein : in std_logic := '0'; 
        sdoin : in std_logic := '0'; 
        data0in : in std_logic := '0'; 
        oe : in std_logic := '0'; 
        dclkout : out std_logic; 
        sceout : out std_logic; 
        sdoout : out std_logic; 
        data0out: out std_logic
        );

end component;

--
-- stratixiv_lvds_receiver
--

component stratixiv_lvds_receiver
    GENERIC ( channel_width                  :  integer := 10;
              data_align_rollover            :  integer := 2;
              enable_dpa                     :  string := "off";
              lose_lock_on_one_change        :  string := "off";
              reset_fifo_at_first_lock       :  string := "on";
              align_to_rising_edge_only      :  string := "on";
              use_serial_feedback_input      :  string := "off";
              dpa_debug                      :  string := "off";
              enable_soft_cdr                : string := "off";
              dpa_output_clock_phase_shift   : integer := 0;    
              enable_dpa_initial_phase_selection  : string := "off";
              dpa_initial_phase_value        : integer := 0;
              enable_dpa_align_to_rising_edge_only   : string := "off";
              net_ppm_variation     : integer := 0;
              is_negative_ppm_drift   : string := "off";
              rx_input_path_delay_engineering_bits : integer := -1;              
              x_on_bitslip                   :  string := "on";
              lpm_type                       :  string := "stratixiv_lvds_receiver"
            );

    port    ( clk0                    : IN std_logic;
              datain                  : IN std_logic := '0';
              enable0                 : IN std_logic := '0';
              dpareset                : IN std_logic := '0';
              dpahold                 : IN std_logic := '0';
              dpaswitch               : IN std_logic := '0';
              fiforeset               : IN std_logic := '0';
              bitslip                 : IN std_logic := '0';
              bitslipreset            : IN std_logic := '0';
              serialfbk               : IN std_logic := '0';
              dataout                 : OUT std_logic_vector(channel_width - 1 DOWNTO 0);
              dpalock                 : OUT std_logic;
              bitslipmax              : OUT std_logic;
              serialdataout           : OUT std_logic;
              postdpaserialdataout    : OUT std_logic;
              divfwdclk           : OUT std_logic;
              dpaclkout               : OUT std_logic;
              devclrn                 : IN std_logic := '1';
              devpor                  : IN std_logic := '1'
            );

end component;
-- stratixiv_pseudo_diff_out

component stratixiv_pseudo_diff_out IS 
 GENERIC (
             lpm_type                         :  string := "stratixiv_pseudo_diff_out"
            );               

 port (
           i                       : IN std_logic := '0';
           o                       : OUT std_logic;   
           obar                    : OUT std_logic
         );                                                      
end component;					

--
-- stratixiv_bias_block
--

--
-- stratixiv_ASMIBLOCK
--
component  stratixiv_tsdblock
    generic (
        poi_cal_temperature : integer := 85;
        clock_divider_enable : string := "on";
        sim_tsdcalo : integer := 0;
        lpm_type : string := "stratixiv_tsdblock"
        );	
    port (
        offset : in std_logic_vector(5 downto 0);
        clk : in std_logic; 
        ce : in std_logic; 
        clr : in std_logic; 
        tsdcalo : out std_logic_vector(7 downto 0);
        tsdcaldone : out std_logic; 
        fdbkctrlfromcore : in std_logic := '0';
        compouttest : in std_logic := '0';
        tsdcompout : out std_logic; 
        offsetout : out std_logic_vector(5 downto 0)
        );
end component;


--
-- stratixiv_LCELL_COMB
--
  
component stratixiv_lcell_comb
    generic (
             lut_mask : std_logic_vector(63 downto 0) := (OTHERS => '1');
             shared_arith : string := "off";
             extended_lut : string := "off";
             dont_touch : string := "off";
             lpm_type : string := "stratixiv_lcell_comb"
            );
    
    port (
          dataa : in std_logic := '0';
          datab : in std_logic := '0';
          datac : in std_logic := '0';
          datad : in std_logic := '0';
          datae : in std_logic := '0';
          dataf : in std_logic := '0';
          datag : in std_logic := '0';
          cin : in std_logic := '0';
          sharein : in std_logic := '0';
          combout : out std_logic;
          sumout : out std_logic;
          cout : out std_logic;
          shareout : out std_logic
         );

end component;

--
-- stratixiv_JTAG
--

component  stratixiv_jtag 
    generic (
            lpm_type	: string := "stratixiv_jtag"
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
--  stratixiv_CRCBLOCK 
--
--

component  stratixiv_crcblock 
    generic (
            lpm_type : string := "stratixiv_crcblock"
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
-- stratixiv_LVDS_TRANSMITTER
--

component stratixiv_lvds_transmitter
    GENERIC ( channel_width                    : integer := 10;
              bypass_serializer                : string  := "false";
              invert_clock                     : string  := "false";
              use_falling_clock_edge           : string  := "false";
              use_serial_data_input            : string  := "false";
              use_post_dpa_serial_data_input   : string  := "false";
     is_used_as_outclk              : string  := "false";
     tx_output_path_delay_engineering_bits : Integer  := -1;
     enable_dpaclk_to_lvdsout    : string := "off";
              preemphasis_setting              : integer := 0;
              vod_setting                      : integer := 0;
              differential_drive               : integer := 0;
              lpm_type                         : string  := "stratixiv_lvds_transmitter"
             );

    port     ( clk0                     : in std_logic;
               enable0                  : in std_logic := '0';
               datain                   : in std_logic_vector(channel_width - 1 downto 0) := (OTHERS => '0');
               serialdatain             : in std_logic := '0';
               postdpaserialdatain      : in std_logic := '0';
      dpaclkin                 : in std_logic := '0';
               devclrn                  : in std_logic := '1';
               devpor                   : in std_logic := '1';
               dataout                  : out std_logic;
               serialfdbkout            : out std_logic
             );
end component;

--
--
--  stratixiv_RUBLOCK
--
--

component  stratixiv_rublock 
	generic
	(
		lpm_type: string := "stratixiv_rublock"
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
-- stratixiv_ram_block
--

component stratixiv_ram_block
  generic 
    (
      operation_mode            : string := "single_port";
      mixed_port_feed_through_mode : string := "dont_care"; 
      ram_block_type            : string := "auto"; 
      logical_ram_name          : string := "ram_name"; 
      init_file                 : string := "init_file.hex"; 
      init_file_layout          : string := "none";
       enable_ecc               :  string := "false";
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
      port_b_write_enable_clock: string := "clock1";    
      port_b_read_enable_clock: string := "clock1";    
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
      lpm_type                  : string := "stratixiv_ram_block";
      lpm_hint                  : string := "true";
      clk0_input_clock_enable  : string := "none"; -- ena0,ena2,none
      clk0_core_clock_enable   : string := "none"; -- ena0,ena2,none
      clk0_output_clock_enable : string := "none"; -- ena0,none
      clk1_input_clock_enable  : string := "none"; -- ena1,ena3,none
      clk1_core_clock_enable   : string := "none"; -- ena1,ena3,none
      clk1_output_clock_enable : string := "none"; -- ena1,none
      port_a_read_during_write_mode  :  string  := "new_data_no_nbe_read";
      port_b_read_during_write_mode  :  string  := "new_data_no_nbe_read";
        mem_init0 : bit_vector  := X"0";
        mem_init1 : bit_vector  := X"0";
        mem_init2 : bit_vector := X"0";
        mem_init3 : bit_vector := X"0";
        mem_init4 : bit_vector := X"0";
         mem_init5 : bit_vector := X"0";
         mem_init6 : bit_vector := X"0";
         mem_init7 : bit_vector := X"0";
         mem_init8 : bit_vector := X"0";
         mem_init9 : bit_vector := X"0";
         mem_init10 : bit_vector := X"0";
         mem_init11 : bit_vector := X"0";
         mem_init12 : bit_vector := X"0";
         mem_init13 : bit_vector := X"0";
         mem_init14 : bit_vector := X"0";
         mem_init15 : bit_vector := X"0";
         mem_init16 : bit_vector := X"0";
         mem_init17 : bit_vector := X"0";
         mem_init18 : bit_vector := X"0";
         mem_init19 : bit_vector := X"0";
         mem_init20 : bit_vector := X"0";
         mem_init21 : bit_vector := X"0";
         mem_init22 : bit_vector := X"0";
         mem_init23 : bit_vector := X"0";
         mem_init24 : bit_vector := X"0";
         mem_init25 : bit_vector := X"0";
         mem_init26 : bit_vector := X"0";
         mem_init27 : bit_vector := X"0";
         mem_init28 : bit_vector := X"0";
         mem_init29 : bit_vector := X"0";
         mem_init30 : bit_vector := X"0";
         mem_init31 : bit_vector := X"0";
         mem_init32 : bit_vector := X"0";
         mem_init33 : bit_vector := X"0";
         mem_init34 : bit_vector := X"0";
         mem_init35 : bit_vector := X"0";
         mem_init36 : bit_vector := X"0";
         mem_init37 : bit_vector := X"0";
         mem_init38 : bit_vector := X"0";
         mem_init39 : bit_vector := X"0";
         mem_init40 : bit_vector := X"0";
         mem_init41 : bit_vector := X"0";
         mem_init42 : bit_vector := X"0";
         mem_init43 : bit_vector := X"0";
         mem_init44 : bit_vector := X"0";
         mem_init45 : bit_vector := X"0";
         mem_init46 : bit_vector := X"0";
         mem_init47 : bit_vector := X"0";
         mem_init48 : bit_vector := X"0";
         mem_init49 : bit_vector := X"0";
         mem_init50 : bit_vector := X"0";
         mem_init51 : bit_vector := X"0";
         mem_init52 : bit_vector := X"0";
         mem_init53 : bit_vector := X"0";
         mem_init54 : bit_vector := X"0";
         mem_init55 : bit_vector := X"0";
         mem_init56 : bit_vector := X"0";
         mem_init57 : bit_vector := X"0";
         mem_init58 : bit_vector := X"0";
         mem_init59 : bit_vector := X"0";
         mem_init60 : bit_vector := X"0";
         mem_init61 : bit_vector := X"0";
         mem_init62 : bit_vector := X"0";
         mem_init63 : bit_vector := X"0";
         mem_init64 : bit_vector := X"0";
         mem_init65 : bit_vector := X"0";
         mem_init66 : bit_vector := X"0";
         mem_init67 : bit_vector := X"0";
         mem_init68 : bit_vector := X"0";
         mem_init69 : bit_vector := X"0";
         mem_init70 : bit_vector := X"0";
         mem_init71 : bit_vector := X"0";
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
       eccstatus : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
       dftout : OUT STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
      portadataout      : out std_logic_vector (port_a_data_width - 1 DOWNTO 0);
      portbdataout      : out std_logic_vector (port_b_data_width - 1 DOWNTO 0)
    );
end component;


end stratixiv_components;
