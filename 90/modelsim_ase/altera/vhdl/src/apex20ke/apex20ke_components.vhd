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
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.VITAL_Timing.all;
USE work.apex20ke_atom_pack.all;

PACKAGE APEX20KE_COMPONENTS IS

COMPONENT apex20ke_lcell
    GENERIC (operation_mode   : string := "normal";
             output_mode      : string := "comb_and_reg";
             packed_mode      : string := "false";
             lut_mask         : string := "ffff";
             power_up         : string := "low";
             cin_used         : string := "false";
             lpm_type         : string := "apex20ke_lcell";
             x_on_violation   : string := "on"
            );

    PORT    (clk              : in std_logic := '0';
             dataa            : in std_logic := '1';
             datab            : in std_logic := '1';
             datac            : in std_logic := '1';
             datad            : in std_logic := '1';
             aclr             : in std_logic := '0';
             sclr             : in std_logic := '0';
             sload            : in std_logic := '0';
             ena              : in std_logic := '1';
             cin              : in std_logic := '0';
             cascin           : in std_logic := '1';
             devclrn          : in std_logic := '1';
             devpor           : in std_logic := '1';
             combout          : out std_logic;
             regout           : out std_logic;
             cout             : out std_logic;
             cascout          : out std_logic
            );
END COMPONENT;

COMPONENT apex20ke_io 
    GENERIC (operation_mode    : string := "input";
             reg_source_mode   :  string := "none";
             feedback_mode     : string := "from_pin";
             power_up          : string := "low";
             open_drain_output : string := "false"
            );

    PORT    (clk               : in std_logic := '0';
             datain            : in std_logic := '1';
             aclr              : in std_logic := '0';
             preset            : in std_logic := '0';
             ena               : in std_logic := '1';
             oe                : in std_logic := '1';
             devclrn           : in std_logic := '1';
             devpor            : in std_logic := '1';
             devoe             : in std_logic := '0';
             padio             : inout std_logic;
             combout           : out std_logic;
             regout            : out std_logic
            );

END COMPONENT;

COMPONENT apex20ke_pterm 
    GENERIC (operation_mode     : string := "normal";
             output_mode        : string := "comb";
             invert_pterm1_mode : string := "false";
             power_up           : string := "low"
            );

    PORT    (pterm0             : in std_logic_vector(31 downto 0) := (OTHERS => '1');
             pterm1             : in std_logic_vector(31 downto 0) := (OTHERS => '1');
             pexpin             : in std_logic := '0';
             clk                : in std_logic := '0';
             ena                : in std_logic := '1';
             aclr               : in std_logic := '0';
             devclrn            : in std_logic := '1';
             devpor             : in std_logic := '1';
             dataout            : out std_logic;
             pexpout            : out std_logic
            );
END COMPONENT;

COMPONENT  apex20ke_ram_slice
    GENERIC (operation_mode      : string := "single_port";
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
             init_file           : string := "none";
             first_address       : integer:= 0;
             last_address        : integer:= 2047;
             bit_number          : integer:= 0;
             power_up            : string := "low";
             mem1                : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem2                : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem3                : std_logic_vector(512 downto 1) := (OTHERS => '0');
             mem4                : std_logic_vector(512 downto 1) := (OTHERS => '0')
            );
    
    PORT    (datain              : in std_logic := '0';
             clk0                : in std_logic := '0';
             clk1                : in std_logic := '0';
             clr0                : in std_logic := '0';
             clr1                : in std_logic := '0'; 
             ena0                : in std_logic := '1';
             ena1                : in std_logic := '1';
             we                  : in std_logic := '0';
             re                  : in std_logic := '1';
             raddr               : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             waddr               : in std_logic_vector(15 downto 0) := (OTHERS => '0');
             devclrn             : in std_logic := '1';
             devpor              : in std_logic := '1';
             modesel             : in std_logic_vector(17 downto 0) := (OTHERS => '0');
             dataout             : out std_logic
            );
END COMPONENT;

COMPONENT  apex20ke_cam_slice
    GENERIC (operation_mode      : string := "encoded_address";
             logical_cam_name    : string := "cam_xxx";
             logical_cam_depth   : integer := 32;
             logical_cam_width   : integer:= 32;
             address_width       : integer:= 5;
             waddr_clear         : string := "none";
             write_enable_clear  : string := "none";
             write_logic_clock   : string := "none";
             write_logic_clear   : string := "none";
             output_clock        : string := "none";
             output_clear        : string := "none";
             init_file           : string := "xxx";
             init_filex          : string := "xxx";
             first_address       : integer:= 0;
             last_address        : integer:= 31;
             first_pattern_bit   : integer:= 1;
             pattern_width       : integer:= 32;
             power_up            : string := "low";
             init_mem_true       : apex20ke_mem_data := (OTHERS => "11111111111111111111111111111111");
             init_mem_comp       : apex20ke_mem_data := (OTHERS => "11111111111111111111111111111111")
            );
    PORT    (clk0                : in std_logic := '0';
             clk1                : in std_logic := '0';
             clr0                : in std_logic := '0';
             clr1                : in std_logic := '0';
             ena0                : in std_logic := '1';
             ena1                : in std_logic := '1';
             we                  : in std_logic := '0';
             datain              : in std_logic := '0';
             wrinvert            : in std_logic := '0';
             outputselect        : in std_logic := '0';
             waddr               : in std_logic_vector(4 downto 0) := (OTHERS => '0');
             lit                 : in std_logic_vector(31 downto 0) := (OTHERS => '0');
             devclrn             : in std_logic := '1';
             devpor              : in std_logic := '1';
             modesel             : in std_logic_vector(9 downto 0) := (OTHERS => '0');
             matchout            : out std_logic_vector(15 downto 0);
             matchfound          : out std_logic
            );

END COMPONENT;

COMPONENT apex20ke_lvds_transmitter
    GENERIC (
                channel_width           : integer := 8;
--                power_up                : string := "low";
                TimingChecksOn          : Boolean := True;
                MsgOn                   : Boolean := DefGlitchMsgOn;
                XOn                     : Boolean := DefGlitchXOn;
                MsgOnChecks             : Boolean := DefMsgOnChecks;
                XOnChecks               : Boolean := DefXOnChecks;
                InstancePath            : String := "*";
                tsetup_datain_clk1_noedge_negedge  : VitalDelayArrayType(7 downto 0) := (OTHERS => DefSetupHoldCnst);
                thold_datain_clk1_noedge_negedge   : VitalDelayArrayType(7 downto 0) := (OTHERS => DefSetupHoldCnst);
                tpd_clk0_dataout_negedge: VitalDelayType01 := DefPropDelay01;
                tipd_clk0               : VitalDelayType01 := DefpropDelay01;
                tipd_clk1               : VitalDelayType01 := DefpropDelay01;
                tipd_datain             : VitalDelayArrayType01(7 downto 0) := (
OTHERS => DefpropDelay01));

        PORT (
                clk0            : in std_logic;
                clk1            : in std_logic;
                datain          : in std_logic_vector(7 downto 0);
                devclrn         : in std_logic := '1';
                devpor                : in std_logic := '1';
                dataout         : out std_logic);
END COMPONENT;

COMPONENT apex20ke_lvds_receiver
    GENERIC (
                channel_width           : integer := 8;
--                power_up                : string := "low";
                TimingChecksOn          : Boolean := True;
                MsgOn                   : Boolean := DefGlitchMsgOn;
                XOn                     : Boolean := DefGlitchXOn;
                MsgOnChecks             : Boolean := DefMsgOnChecks;
                XOnChecks               : Boolean := DefXOnChecks;
                InstancePath            : String := "*";
                tpd_clk0_dataout_negedge: VitalDelayArrayType01(7 downto 0) := (OTHERS => DefPropDelay01);
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
                devpor                : in std_logic := '1';
                dataout         : out std_logic_vector(7 downto 0));
END COMPONENT;

COMPONENT apex20ke_pll
    GENERIC (input_frequency         : integer  := 1000;
             operation_mode          : string := "normal";
             simulation_type         : string := "timing";
             clk0_multiply_by        : integer := 1;
             clk0_divide_by          : integer := 1;
             clk1_multiply_by        : integer := 1;
             clk1_divide_by          : integer := 1;
             phase_shift             : integer := 0;
             effective_phase_shift   : integer := 0;
             effective_clk0_delay    : integer := 0;
             effective_clk1_delay    : integer := 0;
             lock_high               : integer := 1;
             invalid_lock_multiplier : integer := 5;
             valid_lock_multiplier   : integer := 5;
             lock_low                : integer := 1;
             MsgOn                   : Boolean := DefGlitchMsgOn;
             XOn                     : Boolean := DefGlitchXOn;
             tpd_ena_clk0            : VitalDelayType01 := DefPropDelay01;
             tpd_ena_clk1            : VitalDelayType01 := DefPropDelay01;
             tpd_clk_locked          : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk0           : VitalDelayType01 := DefPropDelay01;
             tpd_fbin_clk1           : VitalDelayType01 := DefPropDelay01;
             tipd_clk                : VitalDelayType01 := DefpropDelay01;
             tipd_ena                : VitalDelayType01 := DefpropDelay01;
             tipd_fbin               : VitalDelayType01 := DefpropDelay01
            );

    PORT    (clk                     : in std_logic;
             ena                     : in std_logic := '1';
             fbin                    : in std_logic := '0';
             clk0                    : out std_logic;
             clk1                    : out std_logic;
             locked                  : out std_logic
            );
END COMPONENT;


COMPONENT apex20ke_jtagb
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


COMPONENT apex20ke_stripe
  GENERIC (
    dp0crambits                     : std_logic_vector(3 downto 0)       := "0000";
    dp1crambits                     : std_logic_vector(3 downto 0)       := "0000";
    globaldpcrambits                : std_logic_vector(1 downto 0)       := "00";
    device_size                     : integer                            := 1000;
    spare_width                     : integer                            := 5;
    dpram_a0width                   : integer                            := 16;
    processor                       : string                             := "ARM";
    boot_from_flash                 : string                             := "true";
    debug_extensions                : string                             := "false";
    ebi0_width                      : integer                            := 16;
    use_short_reset                 : string                             := "true";
    use_initialisation_files        : string                             := "true";
    tipd_clkref                     : VitalDelayType01                   := DefPropDelay01;
    tipd_slavhclk                   : VitalDelayType01                   := DefPropDelay01;
    tipd_shwrite                    : VitalDelayType01                   := DefPropDelay01;
    tipd_shreadyi                   : VitalDelayType01                   := DefPropDelay01;
    tipd_shselreg                   : VitalDelayType01                   := DefPropDelay01;
    tipd_shsel                      : VitalDelayType01                   := DefPropDelay01;
    tipd_shmastlock                 : VitalDelayType01                   := DefPropDelay01;
    tipd_shaddr                     : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tipd_shwdata                    : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tipd_shtrans                    : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tipd_shsize                     : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tipd_shburst                    : VitalDelayArrayType01(2 downto 0)  := (others => DefPropDelay01);
    tipd_masthclk                   : VitalDelayType01                   := DefPropDelay01;
    tipd_mhready                    : VitalDelayType01                   := DefPropDelay01;
    tipd_mhgrant                    : VitalDelayType01                   := DefPropDelay01;
    tipd_mhrdata                    : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tipd_mhresp                     : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tipd_debugbusout                : VitalDelayArrayType01(8 downto 0)  := (others => DefPropDelay01);
    tipd_intbusout                  : VitalDelayArrayType01(5 downto 0)  := (others => DefPropDelay01);
    tipd_intextpin                  : VitalDelayType01                   := DefPropDelay01;
    tipd_ebiack                     : VitalDelayType01                   := DefPropDelay01;
    tipd_ebidqin                    : VitalDelayArrayType01(15 downto 0) := (others => DefPropDelay01);
    tipd_uartctsn                   : VitalDelayType01                   := DefPropDelay01;
    tipd_uartdsrn                   : VitalDelayType01                   := DefPropDelay01;
    tipd_uartrxd                    : VitalDelayType01                   := DefPropDelay01;
    tipd_uartdcdin                  : VitalDelayType01                   := DefPropDelay01;
    tipd_uartriin                   : VitalDelayType01                   := DefPropDelay01;
    tipd_sdramdqin                  : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tipd_sdramdqsin                 : VitalDelayArrayType01(3 downto 0)  := (others => DefPropDelay01);
    tipd_clk0dp0                    : VitalDelayType01                   := DefPropDelay01;
    tipd_clk1dp0                    : VitalDelayType01                   := DefPropDelay01;
    tipd_clk0dp1                    : VitalDelayType01                   := DefPropDelay01;
    tipd_clk1dp1                    : VitalDelayType01                   := DefPropDelay01;
    tipd_r0a0                       : VitalDelayArrayType01(15 downto 0) := (others => DefPropDelay01);
    tipd_r0a1                       : VitalDelayArrayType01(14 downto 0) := (others => DefPropDelay01);
    tipd_r0ce0                      : VitalDelayType01                   := DefPropDelay01;
    tipd_r0ce1                      : VitalDelayType01                   := DefPropDelay01;
    tipd_r0rd                       : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tipd_r0rw0                      : VitalDelayType01                   := DefPropDelay01;
    tipd_r0rw1                      : VitalDelayType01                   := DefPropDelay01;
    tipd_r0lockrequest              : VitalDelayType01                   := DefPropDelay01;
    tipd_r1a0                       : VitalDelayArrayType01(15 downto 0) := (others => DefPropDelay01);
    tipd_r1a1                       : VitalDelayArrayType01(14 downto 0) := (others => DefPropDelay01);
    tipd_r1ce0                      : VitalDelayType01                   := DefPropDelay01;
    tipd_r1ce1                      : VitalDelayType01                   := DefPropDelay01;
    tipd_r1rd                       : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tipd_r1rw0                      : VitalDelayType01                   := DefPropDelay01;
    tipd_r1rw1                      : VitalDelayType01                   := DefPropDelay01;
    tipd_r1lockrequest              : VitalDelayType01                   := DefPropDelay01;
    tipd_highaddress                : VitalDelayType01                   := DefPropDelay01;
    tipd_npor                       : VitalDelayType01                   := DefPropDelay01;
    tipd_nreseti                    : VitalDelayType01                   := DefPropDelay01;
    tipd_spareoutl                  : VitalDelayArrayType01(5 downto 0)  := (others => DefPropDelay01);
    tipd_spareoutr                  : VitalDelayArrayType01(5 downto 0)  := (others => DefPropDelay01);
    tpd_slavhclk_shready_posedge    : VitalDelayType01                   := DefPropDelay01;
    tpd_slavhclk_mberrorint_posedge : VitalDelayType01                   := DefPropDelay01;
    tpd_slavhclk_shrdata_posedge    : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_slavhclk_shresp_posedge     : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tpd_masthclk_mhlock_posedge     : VitalDelayType01                   := DefPropDelay01;
    tpd_masthclk_mhwrite_posedge    : VitalDelayType01                   := DefPropDelay01;
    tpd_masthclk_mhbusreq_posedge   : VitalDelayType01                   := DefPropDelay01;
    tpd_masthclk_mhaddr_posedge     : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_masthclk_mhwdata_posedge    : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_masthclk_mhtrans_posedge    : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tpd_masthclk_mhsize_posedge     : VitalDelayArrayType01(1 downto 0)  := (others => DefPropDelay01);
    tpd_masthclk_mhburst_posedge    : VitalDelayArrayType01(2 downto 0)  := (others => DefPropDelay01);
    tpd_clk0dp0_r0rq_posedge        : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_clk1dp0_r0rq_posedge        : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_clk0dp0_r1rq_posedge        : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_clk0dp1_r1rq_posedge        : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tpd_clk1dp1_r1rq_posedge        : VitalDelayArrayType01(31 downto 0) := (others => DefPropDelay01);
    tsetup_mhgrant_masthclk         : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_mhrdata_masthclk         : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_mhready_masthclk         : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_mhresp_masthclk          : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shaddr_slavhclk          : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shburst_slavhclk         : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shreadyi_slavhclk        : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shsel_slavhclk           : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shselreg_slavhclk        : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shsize_slavhclk          : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shtrans_slavhclk         : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shwdata_slavhclk         : VitalDelayType                     := DefSetupHoldCnst;
    tsetup_shwrite_slavhclk         : VitalDelayType                     := DefSetupHoldCnst;
    thold_mhgrant_masthclk          : VitalDelayType                     := DefSetupHoldCnst;
    thold_mhrdata_masthclk          : VitalDelayType                     := DefSetupHoldCnst;
    thold_mhready_masthclk          : VitalDelayType                     := DefSetupHoldCnst;
    thold_mhresp_masthclk           : VitalDelayType                     := DefSetupHoldCnst;
    thold_shaddr_slavhclk           : VitalDelayType                     := DefSetupHoldCnst;
    thold_shburst_slavhclk          : VitalDelayType                     := DefSetupHoldCnst;
    thold_shreadyi_slavhclk         : VitalDelayType                     := DefSetupHoldCnst;
    thold_shsel_slavhclk            : VitalDelayType                     := DefSetupHoldCnst;
    thold_shselreg_slavhclk         : VitalDelayType                     := DefSetupHoldCnst;
    thold_shsize_slavhclk           : VitalDelayType                     := DefSetupHoldCnst;
    thold_shtrans_slavhclk          : VitalDelayType                     := DefSetupHoldCnst;
    thold_shwdata_slavhclk          : VitalDelayType                     := DefSetupHoldCnst;
    thold_shwrite_slavhclk          : VitalDelayType                     := DefSetupHoldCnst
    );


  PORT
    (
      clkref     : in  std_logic;
      slavhclk   : in  std_logic;
      shwrite    : in  std_logic;
      shreadyi   : in  std_logic;
      shselreg   : in  std_logic;
      shsel      : in  std_logic;
      shmastlock : in  std_logic;
      shaddr     : in  std_logic_vector(31 downto 0);
      shwdata    : in  std_logic_vector(31 downto 0);
      shtrans    : in  std_logic_vector(1 downto 0);
      shsize     : in  std_logic_vector(1 downto 0);
      shburst    : in  std_logic_vector(2 downto 0);
      shready    : out std_logic;
      mberrorint : out std_logic;
      shrdata    : out std_logic_vector(31 downto 0);
      shresp     : out std_logic_vector(1 downto 0);

      masthclk : in  std_logic;
      mhready  : in  std_logic;
      mhgrant  : in  std_logic;
      mhrdata  : in  std_logic_vector(31 downto 0);
      mhresp   : in  std_logic_vector(1 downto 0);
      mhlock   : out std_logic;
      mhwrite  : out std_logic;
      mhbusreq : out std_logic;
      mhaddr   : out std_logic_vector(31 downto 0);
      mhwdata  : out std_logic_vector(31 downto 0);
      mhtrans  : out std_logic_vector(1 downto 0);
      mhsize   : out std_logic_vector(1 downto 0);
      mhburst  : out std_logic_vector(2 downto 0);

      debugbusout : in std_logic_vector(8 downto 0);
      debugbusin : out std_logic_vector(6 downto 0);

      intbusout : in std_logic_vector(5 downto 0);
      intbusin : out std_logic_vector(4 downto 0);

      intextpin : in std_logic;

      ebiack     : in  std_logic;
      ebiwen     : out std_logic;
      ebioen     : out std_logic;
      ebiclk     : out std_logic;
      ebiaddress : out std_logic_vector(24 downto 0);
      ebicsn     : out std_logic_vector(3 downto 0);
      ebibe      : out std_logic_vector(1 downto 0);
      ebidqin    : in  std_logic_vector(15 downto 0);
      ebidqout   : out std_logic_vector(15 downto 0);
      ebidqoe    : out std_logic;

      uartctsn    : in  std_logic;
      uartdsrn    : in  std_logic;
      uartrxd     : in  std_logic;
      uarttxd     : out std_logic;
      uartrtsn    : out std_logic;
      uartdtrn    : out std_logic;
      uartdcdon   : out std_logic;
      uartrion    : out std_logic;
      uartdcdin   : in  std_logic;
      uartriin    : in  std_logic;
      uartdcdrioe : out std_logic;

      sdramclk     : out std_logic;
      sdramclkn    : out std_logic;
      sdramclke    : out std_logic;
      sdramwen     : out std_logic;
      sdramcasn    : out std_logic;
      sdramrasn    : out std_logic;
      sdramdqm     : out std_logic_vector(3 downto 0);
      sdramcsn     : out std_logic_vector(1 downto 0);
      sdramaddress : out std_logic_vector(14 downto 0);
      sdramdqin    : in  std_logic_vector(31 downto 0);
      sdramdqsin   : in  std_logic_vector(3 downto 0);
      sdramdqout   : out std_logic_vector(31 downto 0);
      sdramdqsout  : out std_logic_vector(3 downto 0);
      sdramdqsoe   : out std_logic;
      sdramdqoe    : out std_logic_vector(3 downto 0);

      traceclk      : out std_logic;
      tracesync     : out std_logic;
      tracepipestat : out std_logic_vector(2 downto 0);
      tracepkt      : out std_logic_vector(15 downto 0);

      clk0dp0 : in std_logic;
      clk1dp0 : in std_logic;
      clk0dp1 : in std_logic := '0';
      clk1dp1 : in std_logic := '0';

      r0a0          : in  std_logic_vector(dpram_a0width-1 downto 0);
      r0a1          : in  std_logic_vector(dpram_a0width-2 downto 0);
      r0ce0         : in  std_logic;
      r0ce1         : in  std_logic;
      r0rd          : in  std_logic_vector(31 downto 0);
      r0rw0         : in  std_logic;
      r0rw1         : in  std_logic;
      r0rq          : out std_logic_vector(31 downto 0);
      r0lockrequest : in  std_logic;
      r0lockgrant   : out std_logic;

      r1a0          : in  std_logic_vector(dpram_a0width-1 downto 0) := (others => '0');
      r1a1          : in  std_logic_vector(dpram_a0width-2 downto 0) := (others => '0');
      r1ce0         : in  std_logic := '0';
      r1ce1         : in  std_logic := '0';
      r1rd          : in  std_logic_vector(31 downto 0) := (others => '0');
      r1rw0         : in  std_logic := '0';
      r1rw1         : in  std_logic := '0';
      r1rq          : out std_logic_vector(31 downto 0);
      r1lockrequest : in  std_logic := '0';
      r1lockgrant   : out std_logic;

      highaddress : in std_logic := '0';

      npor    : in  std_logic;
      nreseti : in  std_logic;
      nreseto : out std_logic;
      nresetoe : out std_logic;

      spareoutl : in std_logic_vector(spare_width-1 downto 0);
      spareoutr : in std_logic_vector(spare_width-1 downto 0) := (others => '0');

      spareinl : out std_logic_vector(spare_width-1 downto 0);
      spareinr : out std_logic_vector(spare_width-1 downto 0)
      );

END COMPONENT;

END APEX20KE_COMPONENTS;
