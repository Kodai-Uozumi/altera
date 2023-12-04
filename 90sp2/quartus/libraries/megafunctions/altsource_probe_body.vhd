--------------------------------------------------------------------
--
--  ALTSOURCE_PROBE Parameterized Megafunction Body
--
--  Copyright 1991-2009 Corporation  
--  Your use of Altera Corporation's design tools, logic functions  
--  and other software and tools, and its AMPP partner logic  
--  functions, and any output files from any of the foregoing  
--  (including device programming or simulation files), and any  
--  associated documentation or information are expressly subject  
--  to the terms and conditions of the Altera Program License  
--  Subscription Agreement, Altera MegaCore Function License  
--  Agreement, or other applicable license agreement, including,  
--  without limitation, that your use is for the sole purpose of  
--  programming logic devices manufactured by Altera and sold by  
--  Altera or its authorized distributors.  Please refer to the  
--  applicable agreement for further details. 
--  
--  9.0 Build 235  03/01/2009   
--
--	Version 1.0

--************************************************************
-- Description:
--
-- This module contains altsource_probe megafunction body
--************************************************************

-------------------------------------------------------------------------------
-- Description    : IP for Interactive Probe. Capture internal signals using the
--                  probe input, drive internal signals using the source output.
--                  The captured value and the input source value generated are 
--                  transmitted through the JTAG interface.
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.altsource_probe_pkg.all;

entity altsource_probe_body is
    generic (
	    SLD_IR_WIDTH              : integer := 4; -- @no_decl
										
        INSTANCE_ID               : string  := "UNUSED";  -- optional name for the instance.        
        PROBE_WIDTH               : integer := 1;  -- probe port width
        SOURCE_WIDTH              : integer := 1;  -- source port width
        SOURCE_INITIAL_VALUE      : string := "0";  -- initial source port value
        ENABLE_METASTABILITY      : string  := "NO");  -- yes to add two registers to meta-stabilize the source port.
    port (
        probe                       : in  std_logic_vector(if_zero_then_b(PROBE_WIDTH,1) - 1 downto 0) := (others => '0'); -- probe inputs
        source                      : out std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0);  -- source outputs
        source_clk                  : in  std_logic := '0'; -- clock of the registers used to metastabilize the source output
        source_ena                  : in std_logic := '1'; -- enable of the registers used to metastabilize the source output
        
        raw_tck						: in std_logic := '0';		-- Real TCK from the JTAG HUB.	@no_decl
        tdi							: in std_logic := '0';		-- TDI from the JTAG HUB.  It gets the data from JTAG TDI.	@no_decl
        usr1						: in std_logic := '0';		-- USR1 from the JTAG HUB.  Indicate whether it is in USER1 or USER0	@no_decl
        jtag_state_cdr				: in std_logic := '0';		-- CDR from the JTAG HUB.  Indicate whether it is in Capture_DR state.	@no_decl
        jtag_state_sdr				: in std_logic := '0';		-- SDR from the JTAG HUB.  Indicate whether it is in Shift_DR state.	@no_decl
        jtag_state_e1dr				: in std_logic := '0';		-- EDR from the JTAG HUB.  Indicate whether it is in Exit1_DR state.	@no_decl
        jtag_state_udr				: in std_logic := '0';		-- UDR from the JTAG HUB.  Indicate whether it is in Update_DR state.	@no_decl
        jtag_state_cir				: in std_logic := '0';		-- CIR from the JTAG HUB.  Indicate whether it is in Capture_IR state.	@no_decl
        jtag_state_uir				: in std_logic := '0';		-- UIR from the JTAG HUB.  Indicate whether it is in Update_IR state.	@no_decl
        jtag_state_tlr				: in std_logic := '0';		-- UIR from the JTAG HUB.  Indicate whether it is in Test_Logic_Reset state.	@no_decl
        clrn						: in std_logic := '0';		-- CLRN from the JTAG HUB.  Indicate whether hub request global reset.	@no_decl
        ena							: in std_logic := '0';		-- ENA from the JTAG HUB.  Indicate whether this node should establish JTAG chain.	@no_decl
        ir_in						: in std_logic_vector (SLD_IR_WIDTH-1 downto 0) := (others => '0');	-- IR_OUT from the JTAG HUB.  It hold the current instruction for the node.		@no_decl
        
        ir_out						: out std_logic_vector (SLD_IR_WIDTH-1 downto 0);	-- IR_IN to the JTAG HUB.  It supplies the updated value for IR_IN.	@no_decl
        tdo							: out std_logic);		-- TDO to the JTAG HUB.  It supplies the data to JTAG TDO.	@no_decl
end altsource_probe_body;

architecture rtl of altsource_probe_body is

    -- the altsource_probe_impl component declaration.
    component altsource_probe_impl
        generic (
            INSTR_WIDTH          : integer;
            PROBE_WIDTH          : integer;
            SOURCE_WIDTH         : integer;
            SHIFT_WIDTH          : integer;
            SOURCE_INITIAL_VALUE : string;
            ENABLE_METASTABILITY : string;
            INSTANCE_ID          : string);
        port (
            probe       : in  std_logic_vector(if_zero_then_b(PROBE_WIDTH,1) - 1 downto 0);
            reset       : in  std_logic;
            tck         : in  std_logic;
            tdi         : in  std_logic;
            source_clk  : in  std_logic;
            source_ena  : in  std_logic;
            vjtag_cdr   : in  std_logic;
            vjtag_sdr   : in  std_logic;
            vjtag_e1dr  : in  std_logic;
            vjtag_udr   : in  std_logic;
            vjtag_cir   : in  std_logic;
            vjtag_uir   : in  std_logic;            
            vjtag_ir_in : in  std_logic_vector(INSTR_WIDTH - 1 downto 0);
            tdo         : out std_logic;
            source      : out std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0));
    end component;


    -- the virtual jtag component
    component sld_virtual_jtag_basic
        generic (
            sld_mfg_id              : natural range 0 to 2047;
            sld_type_id             : natural range 0 to 255;           
            sld_version             : natural range 0 to 31;
            lpm_type                : string;
            sld_auto_instance_index : string;
            sld_instance_index      : integer;
            sld_ir_width            : integer;
            sld_sim_n_scan          : integer;
            sld_sim_total_length    : integer;
            sld_sim_action          : string);
        port (
            tdo                : in  std_logic                                   := '0';
            ir_out             : in  std_logic_vector(sld_ir_width - 1 downto 0) := (others => '0');
            tck                : out std_logic;
            tdi                : out std_logic;
            ir_in              : out std_logic_vector(sld_ir_width - 1 downto 0);
            virtual_state_cdr  : out std_logic;
            virtual_state_sdr  : out std_logic;
            virtual_state_e1dr : out std_logic;
            virtual_state_pdr  : out std_logic;
            virtual_state_e2dr : out std_logic;
            virtual_state_udr  : out std_logic;
            virtual_state_cir  : out std_logic;
            virtual_state_uir  : out std_logic;
            jtag_state_tlr     : out std_logic);
        
    end component;
    -- constants for VJTAG
    -- constant sld_ir_width            : integer := 3;
    constant sld_sim_n_scan          : integer := 0;
    constant sld_sim_total_length    : integer := 0;
    constant sld_sim_action          : string  := "UNUSED";
    constant sld_mfg_id  : natural := 110;
    constant sld_type_id : natural := 9;
    constant sld_version : natural := 0;
    constant ir_out_c : std_logic_vector(sld_ir_width - 1 downto 0) := (others => '0');  
                                        -- constant value for ir_out                                 
    
    -- signals used by JBNL
    signal probe_i   : std_logic_vector(if_zero_then_b(PROBE_WIDTH,1) - 1 downto 0);
    signal reset_i       : std_logic;
    signal tck_i         : std_logic;
    signal tdi_i         : std_logic;
    signal vjtag_cdr_i   : std_logic;
    signal vjtag_sdr_i   : std_logic;
    signal vjtag_e1dr_i  : std_logic;
    signal vjtag_udr_i   : std_logic;
    signal vjtag_cir_i   : std_logic;
    signal vjtag_uir_i   : std_logic;
    signal vjtag_ir_in_i : std_logic_vector(sld_ir_width - 1 downto 0);
    signal tdo_i         : std_logic;
    signal source_i : std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0);    
    -- signals for VJTAG
    signal ir_out_i : std_logic_vector(sld_ir_width - 1 downto 0);  -- ir out signal

    signal usr0							: std_logic;  -- Indicates the USER0 mode.  == not usr1
    signal dr_scan						: std_logic;  -- Indicates the Node DR_Scan mode
    signal ir_scan						: std_logic;  -- Indicates the Node IR_Scan mode

   
begin  -- rtl


	assert( PROBE_WIDTH >= 0 and PROBE_WIDTH <= 511 )
	report "PROBE_WIDTH must be less than and equal to 511 and greater than equal to 0"
	severity ERROR;

	assert( SOURCE_WIDTH >= 0 and SOURCE_WIDTH <= 511 )
	report "SOURCE_WIDTH must be less than and equal to 511 and greater than and equal to 0"
	severity ERROR;

	assert( not( SOURCE_WIDTH = 0 and PROBE_WIDTH = 0 ) )
	report "PROBE_WIDTH and SOURCE_WIDTH cannot be both 0"
	severity ERROR;

    ir_out_i <= ir_out_c;

    tck_i <= raw_tck;
    tdi_i <= tdi;
    tdo <= tdo_i;
    vjtag_ir_in_i <= ir_in;
    ir_out <= ir_out_i;
	usr0 <= not usr1;
	dr_scan <= usr0 and ena;
	ir_scan <= usr1 and ena;
    vjtag_cdr_i <= jtag_state_cdr and dr_scan;
    vjtag_sdr_i <= jtag_state_sdr and dr_scan;
    vjtag_e1dr_i <= jtag_state_e1dr and dr_scan;
    vjtag_udr_i <= jtag_state_udr and dr_scan;
    vjtag_cir_i <= jtag_state_cdr and ir_scan;
    vjtag_uir_i <= jtag_state_udr and ir_scan;
    vjtag_ir_in_i <= ir_in;
    reset_i <= jtag_state_tlr;
    
    -- Equivalent sld_virtual_jtag megafunction instantiation
    -- vjtag_inst: sld_virtual_jtag_basic
    --     generic map (
    --             lpm_type                => lpm_type,
    --             sld_mfg_id              => sld_mfg_id,
    --             sld_type_id             => sld_type_id,
    --             sld_version             => sld_version,
    --             sld_auto_instance_index => sld_auto_instance_index,
    --             sld_instance_index      => sld_instance_index,
    --             sld_ir_width            => sld_ir_width,
    --             sld_sim_n_scan          => sld_sim_n_scan,
    --             sld_sim_total_length    => sld_sim_total_length,
    --             sld_sim_action          => sld_sim_action)
    --     port map (
    --             tdo                => tdo_i,
    --             ir_out             => ir_out_i,
    --             tck                => tck_i,
    --             tdi                => tdi_i,
    --             ir_in              => vjtag_ir_in_i,
    --             virtual_state_cdr  => vjtag_cdr_i,
    --             virtual_state_sdr  => vjtag_sdr_i,
    --             virtual_state_e1dr => vjtag_e1dr_i,
    --             virtual_state_pdr  => open,
    --             virtual_state_e2dr => open,
    --             virtual_state_udr  => vjtag_udr_i,
    --             virtual_state_cir  => vjtag_cir_i,
    --             virtual_state_uir  => vjtag_uir_i,
    --             jtag_state_tlr => reset_i);

    wider_probe_gen: if (PROBE_WIDTH > SOURCE_WIDTH) generate
        wider_probe_inst: altsource_probe_impl
            generic map (
                    INSTR_WIDTH          => sld_ir_width,
                    PROBE_WIDTH          => PROBE_WIDTH,
                    SOURCE_WIDTH         => SOURCE_WIDTH,
                    SHIFT_WIDTH          => PROBE_WIDTH,
                    SOURCE_INITIAL_VALUE => SOURCE_INITIAL_VALUE,
                    ENABLE_METASTABILITY => ENABLE_METASTABILITY,
                    INSTANCE_ID          => INSTANCE_ID)
            port map (
                    probe       => probe,
                    reset       => reset_i,
                    tck         => tck_i,
                    tdi         => tdi_i,
                    source_clk  => source_clk,
                    source_ena  => source_ena,
                    vjtag_cdr   => vjtag_cdr_i,
                    vjtag_sdr   => vjtag_sdr_i,
                    vjtag_e1dr  => vjtag_e1dr_i,
                    vjtag_udr   => vjtag_udr_i,
                    vjtag_cir   => vjtag_cir_i,
                    vjtag_uir   => vjtag_uir_i,
                    vjtag_ir_in => vjtag_ir_in_i,
                    tdo         => tdo_i,
                    source      => source);
    end generate wider_probe_gen;

    wider_source_gen: if (SOURCE_WIDTH > PROBE_WIDTH) generate
        wider_source_inst: altsource_probe_impl
            generic map (
                    INSTR_WIDTH          => sld_ir_width,
                    PROBE_WIDTH          => PROBE_WIDTH,
                    SOURCE_WIDTH         => SOURCE_WIDTH,
                    SHIFT_WIDTH          => SOURCE_WIDTH,
                    SOURCE_INITIAL_VALUE => SOURCE_INITIAL_VALUE,
                    ENABLE_METASTABILITY => ENABLE_METASTABILITY,
                    INSTANCE_ID          => INSTANCE_ID)
            port map (
                    probe       => probe,
                    reset       => reset_i,
                    tck         => tck_i,
                    tdi         => tdi_i,
                    source_clk  => source_clk,
                    source_ena  => source_ena,
                    vjtag_cdr   => vjtag_cdr_i,
                    vjtag_sdr   => vjtag_sdr_i,
                    vjtag_e1dr  => vjtag_e1dr_i,
                    vjtag_udr   => vjtag_udr_i,
                    vjtag_cir   => vjtag_cir_i,
                    vjtag_uir   => vjtag_uir_i,
                    vjtag_ir_in => vjtag_ir_in_i,
                    tdo         => tdo_i,
                    source      => source);
    end generate wider_source_gen;

    equal_width_gen: if (PROBE_WIDTH = SOURCE_WIDTH) generate
        equal_width_inst: altsource_probe_impl
            generic map (
                    INSTR_WIDTH          => sld_ir_width,
                    PROBE_WIDTH          => SOURCE_WIDTH,
                    SOURCE_WIDTH         => SOURCE_WIDTH,
                    SHIFT_WIDTH          => SOURCE_WIDTH,
                    SOURCE_INITIAL_VALUE => SOURCE_INITIAL_VALUE,
                    ENABLE_METASTABILITY => ENABLE_METASTABILITY,
                    INSTANCE_ID          => INSTANCE_ID)                    
            port map (
                    probe       => probe,
                    reset       => reset_i,
                    tck         => tck_i,
                    tdi         => tdi_i,
                    source_clk  => source_clk,
                    source_ena  => source_ena,
                    vjtag_cdr   => vjtag_cdr_i,
                    vjtag_sdr   => vjtag_sdr_i,
                    vjtag_e1dr  => vjtag_e1dr_i,
                    vjtag_udr   => vjtag_udr_i,
                    vjtag_cir   => vjtag_cir_i,
                    vjtag_uir   => vjtag_uir_i,
                    vjtag_ir_in => vjtag_ir_in_i,
                    tdo         => tdo_i,
                    source      => source);
    end generate equal_width_gen;


end rtl;

-------------------------------------------------------------------------------
-- Description    : Core implementation for Interactive Probe. Capture internal signals using the
--                  probe input, drive internal signals using the source output.
--                  The captured value and the input source value generated are 
--                  transmitted through the JTAG interface.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.altsource_probe_pkg.all;

entity altsource_probe_impl is
    generic (
        PROBE_WIDTH               : integer;  -- probe port width
        SOURCE_WIDTH              : integer;  -- source port width
        INSTR_WIDTH               : integer;  -- the width of the instruction register
        SHIFT_WIDTH               : integer;  -- the width of the LSR and data register
        SOURCE_INITIAL_VALUE      : string;   -- the hexadecimal default value of the output in a string
        ENABLE_METASTABILITY      : string;  -- Yes to make outputs metastable.
        INSTANCE_ID               : string);  -- the 4-character instance id
    port (
        probe              : in  std_logic_vector(if_zero_then_b(PROBE_WIDTH,1) - 1 downto 0); -- the probe inputs from the user design  
        source             : out std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0); -- the source outputs to the user design
        source_clk         : in  std_logic;  -- source port clock (used when metastability enabled)
        source_ena         : in  std_logic;  -- source port enable (used when metastability enabled)
                                             
        reset              : in  std_logic;  -- reset signal
        tck                : in  std_logic;  -- tck clock
        tdi                : in  std_logic;  -- tdi signal
        vjtag_cdr          : in  std_logic;  -- cdr state signal
        vjtag_sdr          : in  std_logic;  -- sdr state signal
        vjtag_e1dr         : in  std_logic;  -- e1dr state signal
        vjtag_udr          : in  std_logic;  -- udr state signal
        vjtag_cir          : in  std_logic;  -- cir state signal
        vjtag_uir          : in  std_logic;  -- uir state signal
        vjtag_ir_in        : in  std_logic_vector(INSTR_WIDTH - 1 downto 0);  -- instruction signal
        tdo                : out std_logic);  -- tdo signal
end altsource_probe_impl;

architecture rtl of altsource_probe_impl is

    component sld_rom_sr
        generic (
            COMMON_IP_VERSION : natural;
            N_BITS            : natural;
            WORD_SIZE         : natural);
        port (
            ROM_DATA : in  std_logic_vector (N_BITS-1 downto 0) := (others => '0');
            TCK      : in  std_logic;
            SHIFT    : in  std_logic;
            UPDATE   : in  std_logic;
            USR1     : in  std_logic;
            ENA      : in  std_logic;
            TDI      : in  std_logic;
            TDO      : out std_logic);
    end component;

    -- One-hot Instruction Assignment
    constant WRITE_SOURCE_INSTR   : natural := 3; -- write source instruction: "1000"
    constant READ_SOURCE_INSTR    : natural := 2; -- read source instruction: "0100"
    constant READ_PROBE_INSTR     : natural := 1; -- read probe instruction: "0010"
    constant READ_INFO_INSTR      : natural := 0; -- read info instruction "0001"
                                  
    -- Powerup Default Value Inversion Mask for the Output Ports                 
    constant OUTPUT_INVERTERS     : std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0) := serialize_output_default(SOURCE_INITIAL_VALUE, if_zero_then_b(SOURCE_WIDTH,1));  
                                        -- the bit representation of the default output

    -- constants for sld_rom_sr
    constant COMMON_IP_VERSION      : natural := 0;    
    constant WORD_SIZE              : natural := 4;
    constant ROM_INFO_MODE_WIDTH    : natural := 4;
    constant ROM_INFO_PORT_WIDTH    : natural := 8;
    constant ROM_INFO_INST_ID_WIDTH : natural := 32;
    constant ROM_INFO_MAX_WIDTH     : natural := ROM_INFO_MODE_WIDTH + ROM_INFO_PORT_WIDTH + ROM_INFO_PORT_WIDTH + ROM_INFO_INST_ID_WIDTH;
    
    signal ROM_INFO_MODE_CONSTANT   : std_logic_vector(ROM_INFO_MODE_WIDTH-1 downto 0);
    signal PROBE_WIDTH_CONSTANT     : std_logic_vector(ROM_INFO_PORT_WIDTH-1 downto 0);  
    signal SOURCE_WIDTH_CONSTANT    : std_logic_vector(ROM_INFO_PORT_WIDTH-1 downto 0);  
                                        -- the lights width and the buttons width.
    signal INSTANCE_ID_CONSTANT     : std_logic_vector(ROM_INFO_INST_ID_WIDTH-1 downto 0);  
                                        -- the 4-character instance id
    signal ROM_INFO_CONSTANT        : std_logic_vector(ROM_INFO_MAX_WIDTH-1 downto 0);
    signal rom_info_out  : std_logic;

    signal is_write_source_instr_on : std_logic;
    signal is_read_source_instr_on  : std_logic;
    signal is_read_probe_instr_on   : std_logic;
    signal is_read_info_instr_on    : std_logic;
    
	signal shift_reg : std_logic_vector(SHIFT_WIDTH - 1 downto 0);
                                        -- the shift register
    signal hold_reg  : std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0);
                                        -- the hold register for buttons
    signal bypass_reg : std_logic;         -- bypass register
    signal tdo_iid    : std_logic;
    signal tdo_iid2   : std_logic;
    
    signal metastable_l1_reg : std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0);
                                        -- first metastable reg
    signal metastable_l2_reg : std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0);
                                        -- second (final) metastable reg
    signal hold_m_out : std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0);
                                        -- final source output
                                        -- net
    signal source_int : std_logic_vector(if_zero_then_b(SOURCE_WIDTH,1) - 1 downto 0);

	signal is_probe_width_0 : std_logic;
	signal is_source_width_0 : std_logic;

    attribute altera_attribute : string;
	-- Set altera_reserved_tck to be asynchronous with other clocks 
    attribute altera_attribute of rtl : architecture is "-name NOT_GATE_PUSH_BACK OFF; -name POWER_UP_LEVEL LOW; -name AUTO_SHIFT_REGISTER_RECOGNITION OFF; SUPPRESS_DA_RULE_INTERNAL=D101;"	-- power-up registers
														& "-name SDC_STATEMENT ""set_clock_groups -asynchronous -group {altera_reserved_tck}"" ";
	attribute altera_attribute of hold_reg: signal is "-name AUTO_CLOCK_ENABLE_RECOGNITION OFF";	
	attribute altera_attribute of metastable_l1_reg : signal is "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS";
	attribute altera_attribute of metastable_l2_reg : signal is "-name SYNCHRONIZER_IDENTIFICATION FORCED_IF_ASYNCHRONOUS";
                           
begin  -- rtl

	probe_width_0_gen: if ( PROBE_WIDTH = 0 or PROBE_WIDTH > 256 ) generate
		is_probe_width_0 <= '1';

		probe_width_const_0_gen: if ( PROBE_WIDTH = 0 ) generate
			PROBE_WIDTH_CONSTANT <= std_logic_vector(conv_unsigned(PROBE_WIDTH,ROM_INFO_PORT_WIDTH));
		end generate probe_width_const_0_gen;

		probe_width_const_257_511_gen: if ( PROBE_WIDTH > 256 ) generate
			PROBE_WIDTH_CONSTANT <= std_logic_vector(conv_unsigned(PROBE_WIDTH - 256,ROM_INFO_PORT_WIDTH));
		end generate probe_width_const_257_511_gen;

	end generate probe_width_0_gen;

	probe_width_non_0_gen: if ( PROBE_WIDTH > 0 and PROBE_WIDTH <= 256 ) generate
		is_probe_width_0 <= '0';

		PROBE_WIDTH_CONSTANT <= std_logic_vector(conv_unsigned(PROBE_WIDTH-1,ROM_INFO_PORT_WIDTH));
	end generate probe_width_non_0_gen;

	source_width_0_gen: if ( SOURCE_WIDTH = 0 or SOURCE_WIDTH > 256 ) generate
		is_source_width_0 <= '1';

		source_width_const_0_gen: if ( SOURCE_WIDTH = 0 ) generate
			SOURCE_WIDTH_CONSTANT <= std_logic_vector(conv_unsigned(SOURCE_WIDTH,ROM_INFO_PORT_WIDTH));
		end generate source_width_const_0_gen;

		source_width_const_257_511_gen: if ( SOURCE_WIDTH > 256 ) generate
			SOURCE_WIDTH_CONSTANT <= std_logic_vector(conv_unsigned(SOURCE_WIDTH - 256,ROM_INFO_PORT_WIDTH));
		end generate source_width_const_257_511_gen;

	end generate source_width_0_gen;

	source_width_non_0_gen: if ( SOURCE_WIDTH > 0 and SOURCE_WIDTH <= 256 ) generate
		is_source_width_0 <= '0';

		SOURCE_WIDTH_CONSTANT <= std_logic_vector(conv_unsigned(SOURCE_WIDTH-1,ROM_INFO_PORT_WIDTH));
	end generate source_width_non_0_gen;

    instance_id_gen: if (INSTANCE_ID'length > 0 and not(INSTANCE_ID = "UNUSED" or INSTANCE_ID = "NONE" or INSTANCE_ID = "00")) generate
		
        ROM_INFO_MODE_CONSTANT <= '0' & is_source_width_0 & is_probe_width_0 & '1';
        INSTANCE_ID_CONSTANT <= serialize_instance_id(INSTANCE_ID);
        ROM_INFO_CONSTANT <= INSTANCE_ID_CONSTANT & SOURCE_WIDTH_CONSTANT & PROBE_WIDTH_CONSTANT & ROM_INFO_MODE_CONSTANT;

        rom_info_inst: sld_rom_sr
            generic map (
                COMMON_IP_VERSION => COMMON_IP_VERSION,
                N_BITS            => ROM_INFO_MAX_WIDTH,
                WORD_SIZE         => WORD_SIZE)
            port map (
                rom_data => ROM_INFO_CONSTANT,
                tck      => tck,
                shift    => vjtag_sdr,
                update   => vjtag_uir,
                usr1     => vjtag_uir,
                ena      => (vjtag_sdr or vjtag_cdr),
                tdi      => tdi,
                tdo      => rom_info_out);
    end generate instance_id_gen;

    no_instance_id_gen: if (INSTANCE_ID'length = 0 or INSTANCE_ID = "UNUSED" or INSTANCE_ID = "NONE" or INSTANCE_ID = "00") generate
        ROM_INFO_MODE_CONSTANT <= '0' & is_source_width_0 & is_probe_width_0 & '0';
        ROM_INFO_CONSTANT((ROM_INFO_MAX_WIDTH - ROM_INFO_INST_ID_WIDTH -1) downto 0) <= SOURCE_WIDTH_CONSTANT & PROBE_WIDTH_CONSTANT & ROM_INFO_MODE_CONSTANT;
    
        rom_info_inst: sld_rom_sr
            generic map (
                COMMON_IP_VERSION => COMMON_IP_VERSION,
                N_BITS            => (ROM_INFO_MAX_WIDTH - ROM_INFO_INST_ID_WIDTH),
                WORD_SIZE         => WORD_SIZE)
            port map (
                rom_data => ROM_INFO_CONSTANT((ROM_INFO_MAX_WIDTH - ROM_INFO_INST_ID_WIDTH -1) downto 0),
                tck      => tck,
                shift    => vjtag_sdr,
                update   => vjtag_uir,
                usr1     => vjtag_uir,
                ena      => (vjtag_sdr or vjtag_cdr),
                tdi      => tdi,
                tdo      => rom_info_out);
    end generate no_instance_id_gen;
    
    -- Instruction decoder
    is_write_source_instr_on <= vjtag_ir_in(WRITE_SOURCE_INSTR);
    is_read_source_instr_on <= vjtag_ir_in(READ_SOURCE_INSTR);
    is_read_probe_instr_on <= vjtag_ir_in(READ_PROBE_INSTR);
    is_read_info_instr_on <= vjtag_ir_in(READ_INFO_INSTR);
    
    -- purpose: Shifts in data during SDR state. Captures probe during cdr. Pushes data to source during UDR.
    -- type   : sequential
    -- inputs : tck, reset, tdi, probe, vjtag_sdr, vjtag_udr, vjtag_cdr
    -- outputs: source, tdo
    shiftReg : process (tck, reset)
    begin  -- process shiftReg
        if reset = '1' then                 -- asynchronous reset (active high)
            shift_reg  <= (others => '0');
            bypass_reg    <= '0';
        elsif tck'event and tck = '1' then  -- rising clock edge
            bypass_reg <= tdi;

            -- on cdr capture whatever is being fed to the lights
            -- also capture whatever is in the hold register
            if (vjtag_cdr = '1') then
                if (is_read_source_instr_on = '1') then
                    shift_reg <= extend_std_logic_vector(source_int, SHIFT_WIDTH);
                elsif (is_read_probe_instr_on = '1') then                    
                    shift_reg(if_zero_then_b(PROBE_WIDTH,1) - 1 downto 0)  <= probe(if_zero_then_b(PROBE_WIDTH,1) - 1 downto 0);                
                end if;
            end if;
            
            if (vjtag_sdr = '1') then                
				if (SHIFT_WIDTH > 1 ) then
	                shift_reg(SHIFT_WIDTH - 1 downto 0) <=  tdi & shift_reg(SHIFT_WIDTH - 1 downto 1);
				else
	                shift_reg(0) <=  tdi;
				end if;
            end if;

            -- on udr push to hold register
            if (vjtag_e1dr = '1') then
                if ( is_write_source_instr_on = '1' ) then
                    hold_reg <= (shift_reg(if_zero_then_b(SOURCE_WIDTH,1)-1 downto 0) xor OUTPUT_INVERTERS);
                end if;
            end if;
        end if;
    end process shiftReg;


    --tdo output
    process(is_read_source_instr_on, is_read_probe_instr_on, is_write_source_instr_on, is_read_info_instr_on, shift_reg(0), rom_info_out, bypass_reg )
    begin
        if (is_read_source_instr_on = '1' or is_read_probe_instr_on = '1' or is_write_source_instr_on = '1') then
            tdo <= shift_reg(0);
        elsif (is_read_info_instr_on = '1') then
            tdo <= rom_info_out;
        else
            tdo <= bypass_reg;
        end if;
    end process;
    

    metastability_gen: if (ENABLE_METASTABILITY = "YES" ) generate
        -- purpose: register for metastability. With an enable signal
        -- type   : sequential
        -- inputs : source_clk, reset
        -- outputs: 
        metastable_enable_reg: process (source_clk, reset, metastable_l2_reg)
        begin  -- process metastable_enable_reg
            if source_clk'event and source_clk = '1' then  
                                        -- rising clock edge
                metastable_l1_reg <= hold_reg;
                if (source_ena = '1') then
                    metastable_l2_reg <= metastable_l1_reg;
                end if;
            end if;

			hold_m_out <= metastable_l2_reg;
        end process metastable_enable_reg;
    end generate metastability_gen;

    no_metastability_gen: if (ENABLE_METASTABILITY = "NO") generate
        hold_m_out <= hold_reg;
    end generate no_metastability_gen;
    
	source_int <= (hold_m_out xor OUTPUT_INVERTERS);
    source <= source_int;

end rtl;

-------------------------------------------------------------------------------
-- Description    : Package containing helper functions to be used by altsource_probe
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package altsource_probe_pkg is

    constant BYTE : natural := 8;       -- the number of bits in a character
    constant INSTANCE_ID_LENGTH : integer := 4 * BYTE;  
                                        -- the maximum length of the instance name. This is 4 characters.

	function if_zero_then_b (
		a, b : in natural )
		return natural;

    function serialize_instance_id (
        constant instance_id : string)  -- the instance id to be serialized
        return std_logic_vector;

    function serialize_output_default (
        constant output_default : string;
                                            -- the hexadecimal default output value
        constant width          : natural)  -- the width of the output
        return std_logic_vector;
    
    function char_to_bits (
        constant char : character)      
                                        -- the character to be converted to its ascii bit stream
        return std_logic_vector;

    -- purpose: converts a character to a 4 bit value. All characters beyond F generate a warning and convert to
    -- zero 
    function hexToBits (
        constant hexValue : character)  -- the charcater to be decoded
        return std_logic_vector;

    function extend_std_logic_vector( 
        signal      input_vec : std_logic_vector;
        constant    output_width : natural )
        return std_logic_vector;
    
end altsource_probe_pkg;

package body altsource_probe_pkg is

	function if_zero_then_b(a, b : in natural) return natural is
		variable ret : natural := 0;
	begin
		if (a = 0) then
			ret := b;
		else
			ret := a;
		end if;
		
		return ret;
	end if_zero_then_b;

    -- purpose: converts a character into its 8-bit ascii representation
    -- can also be done using the pos attribute and some constants.
    function char_to_bits (
        constant char : character)      -- the character to be converted
        return std_logic_vector is
    begin  -- char_to_bits
        case char is
            when '@' => return "01000000";
            when 'A' => return "01000001";
            when 'B' => return "01000010";
            when 'C' => return "01000011";
            when 'D' => return "01000100";
            when 'E' => return "01000101";
            when 'F' => return "01000110";
            when 'G' => return "01000111";
            when 'H' => return "01001000";
            when 'I' => return "01001001";
            when 'J' => return "01001010";
            when 'K' => return "01001011";
            when 'L' => return "01001100";
            when 'M' => return "01001101";
            when 'N' => return "01001110";
            when 'O' => return "01001111";
            when 'P' => return "01010000";
            when 'Q' => return "01010001";
            when 'R' => return "01010010";
            when 'S' => return "01010011";
            when 'T' => return "01010100";
            when 'U' => return "01010101";
            when 'V' => return "01010110";
            when 'W' => return "01010111";
            when 'X' => return "01011000";
            when 'Y' => return "01011001";
            when 'Z' => return "01011010";
            when '[' => return "01011011";
            when '\' => return "01011100";
            when ']' => return "01011101";
            when '^' => return "01011110";
            when '_' => return "01011111";
            when 'a' => return "01100001";
            when 'b' => return "01100010";
            when 'c' => return "01100011";
            when 'd' => return "01100100";
            when 'e' => return "01100101";
            when 'f' => return "01100110";
            when 'g' => return "01100111";
            when 'h' => return "01101000";
            when 'i' => return "01101001";
            when 'j' => return "01101010";
            when 'k' => return "01101011";
            when 'l' => return "01101100";
            when 'm' => return "01101101";
            when 'n' => return "01101110";
            when 'o' => return "01101111";
            when 'p' => return "01110000";
            when 'q' => return "01110001";
            when 'r' => return "01110010";
            when 's' => return "01110011";
            when 't' => return "01110100";
            when 'u' => return "01110101";
            when 'v' => return "01110110";
            when 'w' => return "01110111";
            when 'x' => return "01111000";
            when 'y' => return "01111001";
            when 'z' => return "01111010";
            when '{' => return "01111011";
            when '|' => return "01111100";
            when '}' => return "01111101";
            when '~' => return "01111110";
            when '0' => return "00110000";
            when '1' => return "00110001";
            when '2' => return "00110010";
            when '3' => return "00110011";
            when '4' => return "00110100";
            when '5' => return "00110101";
            when '6' => return "00110110";
            when '7' => return "00110111";
            when '8' => return "00111000";
            when '9' => return "00111001";
            when ':' => return "00111010";
            when ';' => return "00111011";
            when '<' => return "00111100";
            when '=' => return "00111101";
            when '>' => return "00111110";
            when '?' => return "00111111";
            when ' ' => return "00100000";
            when '!' => return "00100001";
            when '"' => return "00100010";
            when '#' => return "00100011";
            when '$' => return "00100100";
            when '%' => return "00100101";
            when '&' => return "00100110";
            when ''' => return "00100111";
            when '(' => return "00101000";
            when ')' => return "00101001";
            when '*' => return "00101010";
            when '+' => return "00101011";
            when ',' => return "00101100";
            when '-' => return "00101101";
            when '.' => return "00101110";
            when '/' => return "00101111";
            when others => return "00000000";
        end case;
    end char_to_bits;

    -- purpose: converts a character to a 4 bit value. All characters beyond F generate a warning and convert to
    -- zero 
    function hexToBits (
        constant hexValue : character)  -- the character to be converted
        return std_logic_vector is
        variable result   : std_logic_vector(3 downto 0) := (others => '0');
                                        -- variable to hold decoded bits
    begin  -- hexToBits
        case hexValue is
            when '0'                                        => result := "0000";
            when '1'                                        => result := "0001";
            when '2'                                        => result := "0010";
            when '3'                                        => result := "0011";
            when '4'                                        => result := "0100";
            when '5'                                        => result := "0101";
            when '6'                                        => result := "0110";
            when '7'                                        => result := "0111";
            when '8'                                        => result := "1000";
            when '9'                                        => result := "1001";
            when 'A'                                        => result := "1010";
            when 'a'                                        => result := "1010";
            when 'B'                                        => result := "1011";
            when 'b'                                        => result := "1011";
            when 'C'                                        => result := "1100";
            when 'c'                                        => result := "1100";
            when 'D'                                        => result := "1101";
            when 'd'                                        => result := "1101";
            when 'E'                                        => result := "1110";
            when 'e'                                        => result := "1110";
            when 'F'                                        => result := "1111";
            when 'f'                                        => result := "1111";
            when others                                     => result := "0000";
        end case;
        return result;
    end hexToBits;

    -- purpose: converts the instance id string into a 32-bit vector.
    function serialize_instance_id (
        constant instance_id : string)  -- the instance id to be serialized
        return std_logic_vector is
		
        variable serial_id : std_logic_vector(INSTANCE_ID_LENGTH - 1 downto 0) := (others => '0');  
        variable charValue : std_logic_vector(7 downto 0) := (others => '0');  
                                        -- temporarily holds the ascii value of a character
    begin  -- serialize_instance_id
        for i in instance_id'length downto 1 loop
            charValue := char_to_bits(instance_id(i));
            for j in 0 to 7 loop
                serial_id := (charValue(j) & serial_id(INSTANCE_ID_LENGTH - 1 downto 1));
            end loop;  -- j
            exit when i = instance_id'length - 3;
        end loop;  -- i
        return serial_id;
    end serialize_instance_id;

    -- purpose: takes the hexadecimal default output and converts it into the appropriate length bit vector.
    function serialize_output_default (
        constant output_default : string;
                                            -- the hexadecimal default output value
        constant width          : natural)  -- the width of the output
        return std_logic_vector is
        variable hexVal : std_logic_vector(3 downto 0) := (others => '0');  
                                        -- temporarily holds the decoded value
        variable serial_default : std_logic_vector(width - 1 downto 0) := (others => '0');  
		variable serial_default_index : natural := 0;
                                        -- holds serialized data
    begin  -- serialize_output_default
        for j in output_default'length downto 1 loop
            hexVal := hexToBits(output_default(j));
            for k in 0 to 3 loop
				exit when serial_default_index = width;
                serial_default(serial_default_index) := hexVal(k);
				serial_default_index := serial_default_index + 1;
            end loop;  -- k
			exit when serial_default_index = width;
        end loop;  -- j
        return serial_default;
    end serialize_output_default;

    -- purpose: pad leading 0s to match the resulting vector size
    function extend_std_logic_vector( 
        signal     input_vec : std_logic_vector;
        constant   output_width : natural )
        return std_logic_vector is
        variable   output_vec : std_logic_vector(output_width-1 downto 0) := (others => '0');
        variable   len : natural; 
    begin
        if ( input_vec'length > output_width ) then
            len := output_width;
        else
            len := input_vec'length;
        end if;

        for i in len-1 downto 0 loop
            output_vec(i) := input_vec(i);
        end loop;

        return output_vec;
    end extend_std_logic_vector;

	
end altsource_probe_pkg;

