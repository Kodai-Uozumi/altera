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
use work.arriaii_atom_pack.all;

package ARRIAII_COMPONENTS is

--
-- arriaii_ff
-- 

component arriaii_ff
    generic (
             power_up : string := "low";
             x_on_violation : string := "on";
             lpm_type : string := "arriaii_ff";
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
--  ARRIAII_CLKSELECT Model
--

component arriaii_clkselect 
    generic (
             lpm_type : STRING := "arriaii_clkselect";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01); 
             tipd_clkselect : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01);
             tpd_inclk_outclk : VitalDelayArrayType01(3 downto 0) := (OTHERS => DefPropDelay01);
             tpd_clkselect_outclk : VitalDelayArrayType01(1 downto 0) := (OTHERS => DefPropDelay01)
             );
    port (
          inclk : in std_logic_vector(3 downto 0) := "0000";
          clkselect : in std_logic_vector(1 downto 0) := "00";
          outclk : out std_logic
          );    
end component;

--
-- ARRIAII_CLKENA
--

component arriaii_clkena

    generic (
             clock_type : STRING := "Auto";
             lpm_type : STRING := "arriaii_clkena";
             ena_register_mode : STRING := "Falling Edge";
             TimingChecksOn : Boolean := True;
             MsgOn : Boolean := DefGlitchMsgOn;
             XOn : Boolean := DefGlitchXOn;
             MsgOnChecks : Boolean := DefMsgOnChecks;
             XOnChecks : Boolean := DefXOnChecks;
             InstancePath : STRING := "*";
             tipd_inclk : VitalDelayType01 := DefPropDelay01; 
             tipd_ena : VitalDelayType01 := DefPropDelay01
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
-- ARRIAII_MLAB_CELL
--

component arriaii_mlab_cell
    GENERIC (
        -- -------- GLOBAL PARAMETERS ---------
        logical_ram_name               :  STRING := "lutram";    
        init_file                      :  STRING := "UNUSED";    
        data_interleave_offset_in_bits :  INTEGER := 1;    
        logical_ram_depth       :  INTEGER := 0;    
        logical_ram_width       :  INTEGER := 0;    
        first_address           :  INTEGER := 0;    
        last_address            :  INTEGER := 0;    
        first_bit_number        :  INTEGER := 0;
        data_width              :  INTEGER := 1;    
        address_width           :  INTEGER := 1;    
        byte_enable_mask_width  :  INTEGER := 1;    
	byte_size               :  INTEGER := 1;
        lpm_type                  : string := "arriaii_mlab_cell";
        lpm_hint                  : string := "true";
	mixed_port_feed_through_mode : string := "dont_care";
        mem_init0 : BIT_VECTOR := X"0";
        -- --------- VITAL PARAMETERS --------
        tipd_clk0        : VitalDelayType01 := DefPropDelay01;
        tipd_ena0        : VitalDelayType01 := DefPropDelay01;
        tipd_portaaddr   : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_portbaddr   : VitalDelayArrayType01(7 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tipd_portabyteenamasks        : VitalDelayArrayType01(20 DOWNTO 0) := (OTHERS => DefPropDelay01);
        tsetup_portaaddr_clk0_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_portabyteenamasks_clk0_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        tsetup_ena0_clk0_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
        thold_portaaddr_clk0_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_portabyteenamasks_clk0_noedge_negedge : VitalDelayType := DefSetupHoldCnst;
        thold_ena0_clk0_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
	tpd_portbaddr_portbdataout : VitalDelayType01 := DefPropDelay01

        );    
    -- -------- PORT DECLARATIONS ---------
    PORT (
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
-- ARRIAII_IO_IBUF
--

COMPONENT arriaii_io_ibuf 
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
             lpm_type                :  string := "arriaii_io_ibuf"
            );    
    PORT (
          i                       : IN std_logic := '0';   
          ibar                    : IN std_logic := '0';   
          o                       : OUT std_logic
         );       
END COMPONENT;

--
-- ARRIAII_IO_OBUF
--

COMPONENT arriaii_io_obuf 
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
             lpm_type                         :  string := "arriaii_io_obuf"
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
-- ARRIAII_DDIO_IN                        
--                                      

COMPONENT arriaii_ddio_in                                                                                        
    generic(                                                                                                  
            tipd_datain                        : VitalDelayType01 := DefPropDelay01;                          
            tipd_clk                           : VitalDelayType01 := DefPropDelay01;                          
            tipd_clkn                          : VitalDelayType01 := DefPropDelay01;                          
            tipd_ena                           : VitalDelayType01 := DefPropDelay01;                          
            tipd_areset                        : VitalDelayType01 := DefPropDelay01;                          
            tipd_sreset                        : VitalDelayType01 := DefPropDelay01;                          
            XOn                                : Boolean := DefGlitchXOn;                                     
            MsgOn                              : Boolean := DefGlitchMsgOn;                                   
            power_up                           :  string := "low";                                            
            async_mode                         :  string := "none";                                         
            sync_mode                          :  string := "none";                                         
            use_clkn                           :  string := "false";                                          
            lpm_type                           :  string := "arriaii_ddio_in"                                   
           );                                                                                                 
    PORT (                                                                                                    
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
END COMPONENT;                                                                                            

--
-- ARRIAII_DDIO_OE
--

COMPONENT arriaii_ddio_oe 
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
            lpm_type              :  string := "arriaii_ddio_oe"
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
-- ARRIAII_DDIO_OUT
--

COMPONENT arriaii_ddio_out 
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
            half_rate_mode                     :  string := "false";       
            use_new_clocking_model             :  string := "false";
            lpm_type                           :  string := "arriaii_ddio_out"
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
          dffhi                   : OUT std_logic_vector(1 downto 0) ;      
          devclrn                 : IN std_logic := '1';   
          devpor                  : IN std_logic := '1'   
        );   
END COMPONENT;



--
-- arriaii_dll Model
--

COMPONENT arriaii_dll
    GENERIC ( 
    input_frequency          : string := "0 ps";
    delay_buffer_mode        : string := "low";
    delay_chain_length       : integer := 12;
    delayctrlout_mode        : string := "normal";
    jitter_reduction         : string := "false";
    use_upndnin              : string := "false";
    use_upndninclkena        : string := "false";
    dual_phase_comparators   : string := "true";
    sim_valid_lock           : integer := 16;
    sim_valid_lockcount      : integer := 0;  -- 10000 = 1000 + 100*dllcounter
    sim_low_buffer_intrinsic_delay  : integer := 350;
    sim_high_buffer_intrinsic_delay : integer := 175;
    sim_buffer_delay_increment      : integer := 10;
    static_delay_ctrl        : integer := 0;
    lpm_type                 : string := "arriaii_dll";
    tipd_clk                 : VitalDelayType01 := DefpropDelay01;
    tipd_aload               : VitalDelayType01 := DefpropDelay01;
    tipd_upndnin             : VitalDelayType01 := DefpropDelay01;
    tipd_upndninclkena       : VitalDelayType01 := DefpropDelay01;
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tsetup_upndnin_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_upndnin_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tsetup_upndninclkena_clk_noedge_posedge : VitalDelayType := DefSetupHoldCnst;
    thold_upndninclkena_clk_noedge_posedge  : VitalDelayType := DefSetupHoldCnst;
    tpd_clk_upndnout_posedge                : VitalDelayType01 := DefPropDelay01;
    tpd_clk_delayctrlout_posedge            : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01)
    );

    PORT    ( clk                      : IN std_logic := '0';
              aload                    : IN std_logic := '0';
              upndnin                  : IN std_logic := '1';
              upndninclkena            : IN std_logic := '1';
              devclrn                  : IN std_logic := '1';
              devpor                   : IN std_logic := '0';
              delayctrlout             : OUT std_logic_vector(5 DOWNTO 0);
              dqsupdate                : OUT std_logic;
              offsetdelayctrlout       : OUT std_logic_vector(5 DOWNTO 0);
              offsetdelayctrlclkout    : OUT std_logic;
              upndnout                 : OUT std_logic	
            );

END COMPONENT;

--
-- arriaii_dll_offset_ctrl Model
--

COMPONENT arriaii_dll_offset_ctrl
    GENERIC ( 
    use_offset               : string := "false";
    static_offset            : string := "0";
    delay_buffer_mode        : string := "low";
    lpm_type                 : string := "arriaii_dll_offset_ctrl";
    tipd_clk                 : VitalDelayType01 := DefpropDelay01;
    tipd_aload               : VitalDelayType01 := DefpropDelay01;
    tipd_offset              : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
    tipd_offsetdelayctrlin   : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
    tipd_addnsub             : VitalDelayType01 := DefpropDelay01;
    TimingChecksOn           : Boolean := True;
    MsgOn                    : Boolean := DefGlitchMsgOn;
    XOn                      : Boolean := DefGlitchXOn;
    MsgOnChecks              : Boolean := DefMsgOnChecks;
    XOnChecks                : Boolean := DefXOnChecks;
    InstancePath             : String := "*";
    tsetup_offset_clk_noedge_posedge        : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    thold_offset_clk_noedge_posedge         : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
    tsetup_addnsub_clk_noedge_posedge       : VitalDelayType := DefSetupHoldCnst;
    thold_addnsub_clk_noedge_posedge        : VitalDelayType := DefSetupHoldCnst;
    tpd_clk_offsetctrlout_posedge           : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01)
    );

    PORT    ( clk                      : IN std_logic := '0';
              aload                    : IN std_logic := '0';
              offsetdelayctrlin        : IN std_logic_vector(5 DOWNTO 0) := "000000";
              offset                   : IN std_logic_vector(5 DOWNTO 0) := "000000";
              addnsub                  : IN std_logic := '1';
              devclrn                  : IN std_logic := '1';
              devpor                   : IN std_logic := '0';
              offsettestout            : OUT std_logic_vector(5 DOWNTO 0);
              offsetctrlout            : OUT std_logic_vector(5 DOWNTO 0)
            );

END COMPONENT;

--
-- arriaii_dqs_enable Model
--

COMPONENT arriaii_dqs_enable
    GENERIC ( 
        lpm_type               : string := "arriaii_dqs_enable";
        tipd_dqsin               : VitalDelayType01 := DefpropDelay01;
        tipd_dqsenable           : VitalDelayType01 := DefpropDelay01;
        tpd_dqsin_dqsbusout      : VitalDelayType01 := DefPropDelay01;
        tpd_dqsenable_dqsbusout  : VitalDelayType01 := DefPropDelay01;
        TimingChecksOn           : Boolean := True;
        MsgOn                    : Boolean := DefGlitchMsgOn;
        XOn                      : Boolean := DefGlitchXOn;
        MsgOnChecks              : Boolean := DefMsgOnChecks;
        XOnChecks                : Boolean := DefXOnChecks;
        InstancePath             : String := "*"   
    );
    
    PORT (
        dqsin        : IN std_logic := '0';
        dqsenable    : IN std_logic := '1';
        devclrn      : IN std_logic := '1';
        devpor       : IN std_logic := '1';
        dqsbusout    : OUT std_logic
    );

END COMPONENT;
    
--
-- arriaii_delay_chain Model
--

    
--
-- arriaii_MAC_MULT
--

component arriaii_mac_mult 
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
            lpm_type                       :  string := "arriaii_mac_mult"
           );    
   PORT (
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
END component;

--
-- arriaii_MAC_OUT
--

component arriaii_mac_out
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
            multa_signa_internally_grounded : string := "false";
            multa_signb_internally_grounded : string := "false";
            multb_signa_internally_grounded : string := "false";
            multb_signb_internally_grounded : string := "false";
            multc_signa_internally_grounded : string := "false";
            multc_signb_internally_grounded : string := "false";
            multd_signa_internally_grounded : string := "false";
            multd_signb_internally_grounded : string := "false";
            lpm_type                       :  string := "arriaii_mac_out";
            dataout_width                  :  integer:= 72
           );    
    PORT (
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
-- ARRIAII_IO_PAD
--
component arriaii_io_pad 

	generic (
		lpm_type : STRING := "arriaii_io_pad"
		);
	PORT ( 
       		padin : in std_logic := '1'; 
       		padout: out std_logic
     	     );
end component;
--
-- ARRIAII_PLL
--

COMPONENT arriaii_pll
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
        
        lpm_type                    : string := "arriaii_pll";
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
        clk9_use_even_counter_value : string := "off";
            
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
         test_counter_c6_delay_chain_bits : integer := 0;
         test_counter_c7_delay_chain_bits : integer := 0;
         test_counter_c8_delay_chain_bits : integer := 0;
         test_counter_c9_delay_chain_bits : integer := 0;
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
         dpa_output_clock_phase_shift : integer := 0;
          test_counter_c3_sclk_delay_chain_bits   : integer := -1;
         test_counter_c4_sclk_delay_chain_bits   : integer := -1;
         test_counter_c5_lden_delay_chain_bits   : integer := -1;
         test_counter_c6_lden_delay_chain_bits   : integer := -1;
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
--REM_MF       tipd_phasecounterselect     : VitalDelayArrayType01(3 DOWNTO 0) := (OTHERS => DefPropDelay01);
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
END COMPONENT;
--
-- ARRIAII_ASMIBLOCK
--
component  arriaii_asmiblock
    generic (
        lpm_type : string := "arriaii_asmiblock"
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
-- arriaii_LVDS_RECEIVER
--

COMPONENT arriaii_lvds_receiver
    GENERIC ( channel_width                  :  integer := 10;
              data_align_rollover            :  integer := 2;
              enable_dpa                     :  string := "off";
              lose_lock_on_one_change        :  string := "off";
              reset_fifo_at_first_lock       :  string := "on";
              align_to_rising_edge_only      :  string := "on";
              use_serial_feedback_input      :  string := "off";
              dpa_debug                      :  string := "off";
              enable_soft_cdr                : string := "off";
              dpa_output_clock_phase_shift   : INTEGER := 0;    
              enable_dpa_initial_phase_selection  : string := "off";
              dpa_initial_phase_value    : INTEGER := 0;
              enable_dpa_align_to_rising_edge_only   : string := "off";
              net_ppm_variation     : INTEGER := 0;
              is_negative_ppm_drift   : string := "off";
                rx_input_path_delay_engineering_bits : INTEGER := 2;            
              x_on_bitslip                   :  string := "on";
              lpm_type                       :  string := "arriaii_lvds_receiver";
              MsgOn                    : Boolean := DefGlitchMsgOn;
              XOn                      : Boolean := DefGlitchXOn;
              MsgOnChecks              : Boolean := DefMsgOnChecks;
              XOnChecks                : Boolean := DefXOnChecks;
              InstancePath             : String := "*";
              tipd_clk0                : VitalDelayType01 := DefpropDelay01;
              tipd_datain              : VitalDelayType01 := DefpropDelay01;
              tipd_enable0             : VitalDelayType01 := DefpropDelay01;
              tipd_dpareset            : VitalDelayType01 := DefpropDelay01;
              tipd_dpahold             : VitalDelayType01 := DefpropDelay01;
              tipd_dpaswitch           : VitalDelayType01 := DefpropDelay01;
              tipd_fiforeset           : VitalDelayType01 := DefpropDelay01;
              tipd_bitslip             : VitalDelayType01 := DefpropDelay01;
              tipd_bitslipreset        : VitalDelayType01 := DefpropDelay01;
              tipd_serialfbk           : VitalDelayType01 := DefpropDelay01;
              tpd_clk0_dpalock_posedge : VitalDelayType01 := DefPropDelay01
            );

    PORT    ( clk0                    : IN std_logic;
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

END COMPONENT;
--
-- arriaii_pseudo_diff_out
--

COMPONENT arriaii_pseudo_diff_out
 GENERIC (
          tipd_i          : VitalDelayType01 := DefPropDelay01;
          tpd_i_o         : VitalDelayType01 := DefPropDelay01;
          tpd_i_obar      : VitalDelayType01 := DefPropDelay01;
          XOn             : Boolean := DefGlitchXOn;
          MsgOn           : Boolean := DefGlitchMsgOn;
          lpm_type        :  string := "arriaii_pseudo_diff_out"
         );

 PORT (
        i                       : IN std_logic := '0';
        o                       : OUT std_logic;
        obar                    : OUT std_logic
      );
END COMPONENT;

--
-- ARRIAII_LCELL_COMB
--
  
component arriaii_lcell_comb
    generic (
             lut_mask : std_logic_vector(63 downto 0) := (OTHERS => '1');
             shared_arith : string := "off";
             extended_lut : string := "off";
             dont_touch : string := "off";
             lpm_type : string := "arriaii_lcell_comb";
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
             tpd_datae_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_combout : VitalDelayType01 := DefPropDelay01;
             tpd_datag_combout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_sharein_sumout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_cout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_cout : VitalDelayType01 := DefPropDelay01;
             tpd_dataf_cout : VitalDelayType01 := DefPropDelay01;
             tpd_cin_cout : VitalDelayType01 := DefPropDelay01;
             tpd_sharein_cout : VitalDelayType01 := DefPropDelay01;
             tpd_dataa_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datab_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datac_shareout : VitalDelayType01 := DefPropDelay01;
             tpd_datad_shareout : VitalDelayType01 := DefPropDelay01;
             tipd_dataa : VitalDelayType01 := DefPropDelay01; 
             tipd_datab : VitalDelayType01 := DefPropDelay01; 
             tipd_datac : VitalDelayType01 := DefPropDelay01; 
             tipd_datad : VitalDelayType01 := DefPropDelay01; 
             tipd_datae : VitalDelayType01 := DefPropDelay01; 
             tipd_dataf : VitalDelayType01 := DefPropDelay01; 
             tipd_datag : VitalDelayType01 := DefPropDelay01; 
             tipd_cin : VitalDelayType01 := DefPropDelay01; 
             tipd_sharein : VitalDelayType01 := DefPropDelay01
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
-- ARRIAII_ROUTING_WIRE
--

component arriaii_routing_wire
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
-- ARRIAII_LVDS_TRANSMITTER
--

COMPONENT arriaii_lvds_transmitter
    GENERIC ( channel_width                    : integer := 10;
              bypass_serializer                : String  := "false";
              invert_clock                     : String  := "false";
              use_falling_clock_edge           : String  := "false";
              use_serial_data_input            : String  := "false";
              use_post_dpa_serial_data_input   : String  := "false";
     is_used_as_outclk              : String  := "false";
     tx_output_path_delay_engineering_bits : Integer  := -1;
     enable_dpaclk_to_lvdsout    : string := "off";
              preemphasis_setting              : integer := 0;
              vod_setting                      : integer := 0;
              differential_drive               : integer := 0;
              lpm_type                         : String  := "arriaii_lvds_transmitter";
              TimingChecksOn                   : Boolean := True;
              MsgOn                            : Boolean := DefGlitchMsgOn;
              XOn                              : Boolean := DefGlitchXOn;
              MsgOnChecks                      : Boolean := DefMsgOnChecks;
              XOnChecks                        : Boolean := DefXOnChecks;
              InstancePath                     : String  := "*";
              tpd_clk0_dataout_posedge         : VitalDelayType01 := DefPropDelay01;
              tpd_clk0_dataout_negedge         : VitalDelayType01 := DefPropDelay01;
              tpd_serialdatain_dataout         : VitalDelayType01 := DefPropDelay01;
              tpd_postdpaserialdatain_dataout  : VitalDelayType01 := DefPropDelay01;
              tipd_clk0                        : VitalDelayType01 := DefpropDelay01;
              tipd_enable0                     : VitalDelayType01 := DefpropDelay01;
              tipd_datain                      : VitalDelayArrayType01(9 downto 0) := (OTHERS => DefpropDelay01);
              tipd_serialdatain                : VitalDelayType01 := DefpropDelay01;
              tipd_postdpaserialdatain         : VitalDelayType01 := DefpropDelay01
             );

    PORT     ( clk0                     : in std_logic;
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
END COMPONENT;

--
--
--  ARRIAII_RUBLOCK
--
--

component  arriaii_rublock 
	generic
	(
		sim_init_config			: string := "factory";
		sim_init_watchdog_value	: integer := 0;
		sim_init_status			: integer := 0;
		lpm_type: string := "arriaii_rublock"
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
--  ARRIAII_OSCILLATOR
--
--

component  arriaii_oscillator 
	generic
	(
		lpm_type: string := "arriaii_oscillator"
	);
	port 
	(
		oscena	        : in std_logic; 
--ADD_TARPON		clkout1		: out std_logic;
--ADD_TARPON		observableoutputport		: out std_logic;
		clkout		: out std_logic
	);
end component;

--
-- arriaii_ram_block
--

component arriaii_ram_block
  generic 
    (
      operation_mode            : string := "single_port";
      mixed_port_feed_through_mode : string := "dont_care"; 
      ram_block_type            : string := "auto"; 
      logical_ram_name          : string := "ram_name"; 
      init_file                 : string := "init_file.hex"; 
      init_file_layout          : string := "none";
       enable_ecc               :  STRING := "false";
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
      lpm_type                  : string := "arriaii_ram_block";
      lpm_hint                  : string := "true";
      clk0_input_clock_enable  : STRING := "none"; -- ena0,ena2,none
      clk0_core_clock_enable   : STRING := "none"; -- ena0,ena2,none
      clk0_output_clock_enable : STRING := "none"; -- ena0,none
      clk1_input_clock_enable  : STRING := "none"; -- ena1,ena3,none
      clk1_core_clock_enable   : STRING := "none"; -- ena1,ena3,none
      clk1_output_clock_enable : STRING := "none"; -- ena1,none
      port_a_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";
      port_b_read_during_write_mode  :  STRING  := "new_data_no_nbe_read";
        mem_init0 : BIT_VECTOR  := X"0";
        mem_init1 : BIT_VECTOR  := X"0";
        mem_init2 : BIT_VECTOR := X"0";
        mem_init3 : BIT_VECTOR := X"0";
        mem_init4 : BIT_VECTOR := X"0";
         mem_init5 : BIT_VECTOR := X"0";
         mem_init6 : BIT_VECTOR := X"0";
         mem_init7 : BIT_VECTOR := X"0";
         mem_init8 : BIT_VECTOR := X"0";
         mem_init9 : BIT_VECTOR := X"0";
         mem_init10 : BIT_VECTOR := X"0";
         mem_init11 : BIT_VECTOR := X"0";
         mem_init12 : BIT_VECTOR := X"0";
         mem_init13 : BIT_VECTOR := X"0";
         mem_init14 : BIT_VECTOR := X"0";
         mem_init15 : BIT_VECTOR := X"0";
         mem_init16 : BIT_VECTOR := X"0";
         mem_init17 : BIT_VECTOR := X"0";
         mem_init18 : BIT_VECTOR := X"0";
         mem_init19 : BIT_VECTOR := X"0";
         mem_init20 : BIT_VECTOR := X"0";
         mem_init21 : BIT_VECTOR := X"0";
         mem_init22 : BIT_VECTOR := X"0";
         mem_init23 : BIT_VECTOR := X"0";
         mem_init24 : BIT_VECTOR := X"0";
         mem_init25 : BIT_VECTOR := X"0";
         mem_init26 : BIT_VECTOR := X"0";
         mem_init27 : BIT_VECTOR := X"0";
         mem_init28 : BIT_VECTOR := X"0";
         mem_init29 : BIT_VECTOR := X"0";
         mem_init30 : BIT_VECTOR := X"0";
         mem_init31 : BIT_VECTOR := X"0";
         mem_init32 : BIT_VECTOR := X"0";
         mem_init33 : BIT_VECTOR := X"0";
         mem_init34 : BIT_VECTOR := X"0";
         mem_init35 : BIT_VECTOR := X"0";
         mem_init36 : BIT_VECTOR := X"0";
         mem_init37 : BIT_VECTOR := X"0";
         mem_init38 : BIT_VECTOR := X"0";
         mem_init39 : BIT_VECTOR := X"0";
         mem_init40 : BIT_VECTOR := X"0";
         mem_init41 : BIT_VECTOR := X"0";
         mem_init42 : BIT_VECTOR := X"0";
         mem_init43 : BIT_VECTOR := X"0";
         mem_init44 : BIT_VECTOR := X"0";
         mem_init45 : BIT_VECTOR := X"0";
         mem_init46 : BIT_VECTOR := X"0";
         mem_init47 : BIT_VECTOR := X"0";
         mem_init48 : BIT_VECTOR := X"0";
         mem_init49 : BIT_VECTOR := X"0";
         mem_init50 : BIT_VECTOR := X"0";
         mem_init51 : BIT_VECTOR := X"0";
         mem_init52 : BIT_VECTOR := X"0";
         mem_init53 : BIT_VECTOR := X"0";
         mem_init54 : BIT_VECTOR := X"0";
         mem_init55 : BIT_VECTOR := X"0";
         mem_init56 : BIT_VECTOR := X"0";
         mem_init57 : BIT_VECTOR := X"0";
         mem_init58 : BIT_VECTOR := X"0";
         mem_init59 : BIT_VECTOR := X"0";
         mem_init60 : BIT_VECTOR := X"0";
         mem_init61 : BIT_VECTOR := X"0";
         mem_init62 : BIT_VECTOR := X"0";
         mem_init63 : BIT_VECTOR := X"0";
         mem_init64 : BIT_VECTOR := X"0";
         mem_init65 : BIT_VECTOR := X"0";
         mem_init66 : BIT_VECTOR := X"0";
         mem_init67 : BIT_VECTOR := X"0";
         mem_init68 : BIT_VECTOR := X"0";
         mem_init69 : BIT_VECTOR := X"0";
         mem_init70 : BIT_VECTOR := X"0";
         mem_init71 : BIT_VECTOR := X"0";
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


--
-- arriaii_dqs_delay_chain Model
--

COMPONENT arriaii_dqs_delay_chain
   GENERIC (
      
      lpm_type                         : STRING := "arriaii_dqs_delay_chain";
      delay_buffer_mode                : STRING := "low";
      dqs_ctrl_latches_enable          : STRING := "false";
      dqs_input_frequency              : STRING := "unused";
      dqs_offsetctrl_enable            : STRING := "false";
      dqs_phase_shift                  : INTEGER := 0;
      phase_setting                    : INTEGER := 0;
      sim_buffer_delay_increment       : INTEGER := 10;
      sim_high_buffer_intrinsic_delay  : INTEGER := 175;
      sim_low_buffer_intrinsic_delay   : INTEGER := 350;
      test_enable                      : STRING := "false";
      test_select                      : INTEGER := 0  ;
      tipd_dqsin               : VitalDelayType01 := DefpropDelay01;
      tipd_delayctrlin         : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
      tipd_offsetctrlin        : VitalDelayArrayType01(5 downto 0) := (OTHERS => DefPropDelay01);
      tipd_dqsupdateen         : VitalDelayType01 := DefpropDelay01;
      tpd_dqsin_dqsbusout      : VitalDelayType01 := DefPropDelay01;
      tsetup_delayctrlin_dqsupdateen_noedge_posedge  : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
      thold_delayctrlin_dqsupdateen_noedge_posedge   : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
      tsetup_offsetctrlin_dqsupdateen_noedge_posedge : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
      thold_offsetctrlin_dqsupdateen_noedge_posedge  : VitalDelayArrayType(5 downto 0) := (OTHERS => DefSetupHoldCnst);
      TimingChecksOn           : Boolean := True;
      MsgOn                    : Boolean := DefGlitchMsgOn;
      XOn                      : Boolean := DefGlitchXOn;
      MsgOnChecks              : Boolean := DefMsgOnChecks;
      XOnChecks                : Boolean := DefXOnChecks;
      InstancePath             : String := "*"   
   );
   PORT (
      
      delayctrlin                      : IN STD_LOGIC_VECTOR(5 DOWNTO 0):= (OTHERS => '0');
      dqsin                            : IN STD_LOGIC := '0';
      dqsupdateen                      : IN STD_LOGIC := '1';
      offsetctrlin                     : IN STD_LOGIC_VECTOR(5 DOWNTO 0):= (OTHERS => '0');
      devclrn                          : IN std_logic := '1'; 
      devpor                           : IN std_logic := '1'; 
      dqsbusout                        : OUT STD_LOGIC
   );
   END COMPONENT;
    

--
-- arriaii_dqs_enable_ctrl Model
--

COMPONENT arriaii_dqs_enable_ctrl
   GENERIC (
      
      lpm_type                         : STRING := "arriaii_dqs_enable_ctrl";
      delay_dqs_enable_by_half_cycle   : STRING := "false";
      tipd_dqsenablein         : VitalDelayType01 := DefpropDelay01;
      tipd_clk                 : VitalDelayType01 := DefpropDelay01;
      TimingChecksOn           : Boolean := True;
      MsgOn                    : Boolean := DefGlitchMsgOn;
      XOn                      : Boolean := DefGlitchXOn;
      MsgOnChecks              : Boolean := DefMsgOnChecks;
      XOnChecks                : Boolean := DefXOnChecks;
      InstancePath             : String := "*"   
   );
   PORT (
      
      clk                              : IN STD_LOGIC := '0';
      dqsenablein                      : IN STD_LOGIC := '1';
      devclrn                          : IN std_logic := '1'; 
      devpor                           : IN std_logic := '1'; 
      dqsenableout                     : OUT STD_LOGIC
   );
END COMPONENT;
   
--
-- arriaii_JTAG
--

component  arriaii_jtag 
    generic (
            lpm_type    : string := "arriaii_jtag"
            );
    port    (
            tms : in std_logic := '0'; 
            tck : in std_logic := '0'; 
            tdi : in std_logic := '0'; 
            tdoutap : in std_logic := '0'; 
            tdouser : in std_logic := '0'; 
            tdicore : in std_logic := '0';
            tckcore : in std_logic := '0';
            tmscore : in std_logic := '0';
            corectl : in std_logic := '0';
            tdocore : out std_logic;
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
--  arriaii_CRCBLOCK 
--
--

component  arriaii_crcblock 
    generic (
            oscillator_divider : integer := 1;
            crc_deld_disable : string := "off";   
            error_delay : integer :=  0 ;         
            error_dra_dl_bypass : string := "off";
            lpm_type : string := "arriaii_crcblock"
            );
    port    (
            clk         : in std_logic := '0'; 
            shiftnld    : in std_logic := '0'; 
            crcerror    : out std_logic; 
            regout      : out std_logic
            ); 
end component;

--
--
-- arriaii_CONTROLLER
--
--

component arriaii_controller 
    generic (
        lpm_type : string := "arriaii_controller"
        ); 
    port (
        nceout : out std_logic
        ); 
end component;

--
--
--  arriaii_SPIBLOCK 
--
--

component arriaii_spiblock 
    port (
    dclkin : in std_logic; 
    scein : in std_logic; 
    sdoin : in std_logic; 
    oe : in std_logic; 
    data0in : in std_logic; 
    data0out : out std_logic;
    dclkout : out std_logic;
    sceout : out std_logic;
    sdoout : out std_logic
        ); 
end component;
component arriaii_termination_logic 
   GENERIC (

          --  generic control parameters  --
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_terminationclock                : VitalDelayType01 := DefpropDelay01;
      tipd_terminationselect                : VitalDelayType01 := DefpropDelay01;
      tipd_terminationdata                : VitalDelayType01 := DefpropDelay01;
      
      --INPUT PORTS
      lpm_type            : STRING := "arriaii_termination_logic"
   );
   PORT (
      terminationclock    : IN STD_LOGIC := '0';
      terminationdata     : IN STD_LOGIC := '0';
      terminationselect   : IN STD_LOGIC := '0';
      
      --OUTPUT PORTS
      terminationcontrol  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
   );
END component;
component arriaii_termination 
   GENERIC (

          --  generic control parameters  --
       MsgOn                   : Boolean := DefGlitchMsgOn;
       XOn                     : Boolean := DefGlitchXOn;
       MsgOnChecks             : Boolean := DefMsgOnChecks;
       XOnChecks               : Boolean := DefXOnChecks;
       InstancePath            : String := "*";
       TimingChecksOn          : Boolean := True;
      tipd_scanshiftmux                : VitalDelayType01 := DefpropDelay01;
      tipd_scaninmux                : VitalDelayType01 := DefpropDelay01;
      tipd_scanin                : VitalDelayType01 := DefpropDelay01;
      tipd_terminationuserclock                : VitalDelayType01 := DefpropDelay01;
      tipd_scanclock                : VitalDelayType01 := DefpropDelay01;
      tipd_terminationuserclear                : VitalDelayType01 := DefpropDelay01;
      tipd_rdn                : VitalDelayType01 := DefpropDelay01;
      tipd_rup                : VitalDelayType01 := DefpropDelay01;
      
      lpm_type                 : STRING := "arriaii_termination";
      runtime_control          : STRING := "false"
   );
   PORT (
      rdn                      : IN STD_LOGIC := '0';
      rup                      : IN STD_LOGIC := '0';
      scanclock                : IN STD_LOGIC := '0';
      scanin                   : IN STD_LOGIC := '0';
      scaninmux                : IN STD_LOGIC := '0';
      scanshiftmux             : IN STD_LOGIC := '0';
      terminationuserclear     : IN STD_LOGIC := '0';
      terminationuserclock     : IN STD_LOGIC := '0';
      
      comparatorprobe          : OUT STD_LOGIC;
      scanout                  : OUT STD_LOGIC;
      terminationclockout      : OUT STD_LOGIC;
      terminationcontrolprobe  : OUT STD_LOGIC;
      terminationdataout       : OUT STD_LOGIC;
      terminationdone          : OUT STD_LOGIC;
      terminationselectout     : OUT STD_LOGIC
   );
END component;

end arriaii_components;
