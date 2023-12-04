--------------------------------------------------------------------------------
--
--                   Altera Clock Shared Memory Source File
--                           Copyright DDC, 2002
--                           All Rights Reserved
--                     DDC Confidential and Proprietary
--
--------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------
--
--      File Name:          alt_csm_core.vhd
--      Entity Name:        alt_csm_core
--
--      Description:
--
--          This module generates appropriate submodules to create the specified
--          altcsmem instance based on the parameters supplied by wizard
--          generated source files.  The alt_csm_core uses parameter arrays
--          formed by the higher level altcsmem wrapper.
--
--      Notes:
--
--          Commented lines
--              --r reserved for future use, just a placeholder
--              --n non-implemented functionality, implement in later phase
--              --x deletion candidate, remove in cleanup pass
--              --! important note
--              --? unresolved issue or question
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.alt_csm_const_pkg.all;
use work.alt_csm_func_pkg.all;

--x pragma translate_off
library altera_mf;
use altera_mf.altera_mf_components.all;
--x pragma translate_on


entity alt_csm_core is
	generic
	(
		param_topology					: string := "FIFO_AND_UNIDPRAM_MODE";

		param_num_a_ports				: natural := 1;
		param_num_b_ports				: natural := 1;
		param_a_port_type				: port_natural_array_type := (others => 0);
		param_b_port_type				: port_natural_array_type := (others => 0);

		param_aggr_wr_data_a_width		: natural := 8;
		param_wr_data_a_port_start		: port_natural_array_type := (others => 0);
		param_wr_data_a_port_end		: port_natural_array_type := (others => 0);

		param_aggr_rd_data_b_width		: natural := 8;
		param_rd_data_b_port_start		: port_natural_array_type := (others => 0);
		param_rd_data_b_port_end		: port_natural_array_type := (others => 0);

		param_aggr_addr_a_width			: natural := 1;
		param_addr_a_port_start			: port_natural_array_type := (others => 0);
		param_addr_a_port_end			: port_natural_array_type := (others => 0);

		param_aggr_addr_b_width			: natural := 1;
		param_addr_b_port_start			: port_natural_array_type := (others => 0);
		param_addr_b_port_end			: port_natural_array_type := (others => 0);

		param_aggr_wr_fifo_level_width	: natural := 1;
		param_wr_fifo_level_start		: port_natural_array_type := (others => 0);
		param_wr_fifo_level_end			: port_natural_array_type := (others => 0);

		param_aggr_rd_fifo_level_width	: natural := 1;
		param_rd_fifo_level_start		: port_natural_array_type := (others => 0);
		param_rd_fifo_level_end			: port_natural_array_type := (others => 0);

		param_rd_fifo_lookahead			: port_natural_array_type := (others => 0);

		param_aggr_byte_en_a_width		: natural := 1;
		param_byte_en_a_port_start		: port_natural_array_type := (others => 0);
		param_byte_en_a_port_end		: port_natural_array_type := (others => 0);

		param_port_a_ram_wr_data_width	: natural := 8;
		param_port_a_ram_addr_width		: natural := 4;
		param_port_a_ram_byte_en_width	: natural := 1;

		param_port_b_ram_rd_data_width	: natural := 8;
		param_port_b_ram_addr_width		: natural := 4;

		param_byte_size					: natural := 8;
		param_ram_block_type			: string := "MEGARAM";
		param_intended_device_family	: string := "Stratix";

		param_port_a_port_addr_offset	: port_natural_array_type := (others => 0);
		param_port_b_port_addr_offset	: port_natural_array_type := (others => 0);

		param_rd_latency				: port_natural_array_type := (others => 0);

--n		param_use_rd_clk_en				: port_natural_array_type := (others => 0);
		param_use_common_dp_output_reg	: port_natural_array_type := (others => 0);

		param_use_ext_ram				: natural := 0;
		param_aclr_polarity				: natural := 0;

		param_port_a_clk_is_sync		: port_natural_array_type := (others => 0);
		param_port_b_clk_is_sync		: port_natural_array_type := (others => 0);

		param_num_a_states				: natural := 1;
		param_seq_a_rom_mif				: string := "";

		param_num_b_states				: natural := 1;
		param_seq_b_rom_mif				: string := ""
	);
	port
	(
		tdm_clk				: in  std_logic;
		reset				: in  std_logic := NOT c_async_reset_val;

		clk_port_a			: in  std_logic_vector(param_num_a_ports -1 downto 0) := (others => '0');
		clk_port_b			: in  std_logic_vector(param_num_b_ports -1 downto 0) := (others => '0');

--n		rd_data_clk_en_b	: in  std_logic_vector(param_num_b_ports -1 downto 0);

		wr_data_a			: in  std_logic_vector(param_aggr_wr_data_a_width -1 downto 0) := (others => '0');
		addr_a				: in  std_logic_vector(param_aggr_addr_a_width -1 downto 0) := (others => '0');
		byte_en_a			: in  std_logic_vector(param_aggr_byte_en_a_width -1 downto 0) := (others => '0');
		wr_en_a				: in  std_logic_vector(param_num_a_ports -1 downto 0) := (others => '0');
		com_dpram_cs_a		: in  std_logic_vector(param_num_a_ports -1 downto 0) := (others => '0');

		rd_data_b			: out std_logic_vector(param_aggr_rd_data_b_width -1 downto 0);
		addr_b				: in  std_logic_vector(param_aggr_addr_b_width -1 downto 0) := (others => '0');
		read_b				: in  std_logic_vector(param_num_b_ports -1 downto 0) := (others => '0');
		com_dpram_cs_b		: in  std_logic_vector(param_num_b_ports -1 downto 0) := (others => '0');

		data_valid_b		: out std_logic_vector(param_num_b_ports -1 downto 0);

		wr_full				: out std_logic_vector(param_num_a_ports -1 downto 0);
		wr_empty			: out std_logic_vector(param_num_a_ports -1 downto 0);
		wr_level			: out std_logic_vector(param_aggr_wr_fifo_level_width -1 downto 0);

		rd_full				: out std_logic_vector(param_num_b_ports -1 downto 0);
		rd_empty			: out std_logic_vector(param_num_b_ports -1 downto 0);
		rd_level			: out std_logic_vector(param_aggr_rd_fifo_level_width -1 downto 0);

		ext_ram_wr_data_a		: out std_logic_vector(param_port_a_ram_wr_data_width -1 downto 0);
		ext_ram_addr_a			: out std_logic_vector(param_port_a_ram_addr_width -1 downto 0);
		ext_ram_byte_en_a		: out std_logic_vector(param_port_a_ram_byte_en_width -1 downto 0);
		ext_ram_wr_en_a			: out std_logic;

		ext_ram_rd_data_b_in	: in  std_logic_vector(param_port_b_ram_rd_data_width -1 downto 0) := (others => '0');
		ext_ram_rd_data_b_out	: out std_logic_vector(param_port_b_ram_rd_data_width -1 downto 0);
		ext_ram_addr_b			: out std_logic_vector(param_port_b_ram_addr_width -1 downto 0)
	);
end alt_csm_core;


architecture rtl of alt_csm_core is

--------------------------------------------------------------------------------
-- Component Definitions
--------------------------------------------------------------------------------


component alt_csm_sequence
	generic
	(
		num_states			: natural := 2;
		num_states_width	: natural := 1;
		num_ports			: natural := 2;
		num_ports_width		: natural := 1;
		seq_rom_mif			: string := ""
	);
	port
	(
		clk					: in  std_logic;
		reset				: in  std_logic;
		active_port_stb		: out std_logic_vector(num_ports -1 downto 0);
		active_port_num		: out std_logic_vector(num_ports_width -1 downto 0)
	);
end component;


component alt_csm_fifo
	generic
	(
		wr_data_width		: natural := 8;
		wr_addr_width		: natural := 4;

		rd_data_width		: natural := 8;
		rd_addr_width		: natural := 4;

		ram_a_data_width	: natural := 8;
		ram_a_addr_width	: natural := 4;
		ram_a_byen_width	: natural := 1;
		ram_a_addr_offset	: natural := 0;

		ram_b_data_width	: natural := 8;
		ram_b_addr_width	: natural := 4;
		ram_b_addr_offset	: natural := 0;

		rd_lookahead		: natural := 0;

		wr_clk_is_sync		: natural := 0;
		rd_clk_is_sync		: natural := 0;

		wr_port_type		: natural := 0;
		rd_port_type		: natural := 0;

		tdm_wr_latency		: natural := 4;
		tdm_rd_latency		: natural := 4
	);
	port
	(
		tdm_clk			: in  std_logic;
		reset			: in  std_logic;

		wr_clk			: in  std_logic;
		wr_data			: in  std_logic_vector(wr_data_width -1 downto 0);
		wr_en			: in  std_logic;
		wr_ff			: out std_logic;
		wr_ef			: out std_logic;
		wr_level		: out std_logic_vector(wr_addr_width -1 downto 0);

		rd_clk			: in  std_logic;
		rd_data			: out std_logic_vector(rd_data_width -1 downto 0);
		rd_en			: in  std_logic;
		rd_ff			: out std_logic;
		rd_ef			: out std_logic;
		rd_level		: out std_logic_vector(rd_addr_width -1 downto 0);
		rd_dv			: out std_logic;

		tdm_wr_req		: out std_logic;
		tdm_wr_ack		: in  std_logic;

		ram_a_data		: out std_logic_vector(ram_a_data_width -1 downto 0);
		ram_a_addr		: out std_logic_vector(ram_a_addr_width -1 downto 0);
		ram_a_byen		: out std_logic_vector(ram_a_byen_width -1 downto 0);
		ram_a_wren		: out std_logic;

		tdm_rd_req		: out std_logic;
		tdm_rd_ack		: in  std_logic;

		ram_b_data		: in  std_logic_vector(ram_b_data_width -1 downto 0);
		ram_b_addr		: out std_logic_vector(ram_b_addr_width -1 downto 0)
	);
end component;


component alt_csm_unidpram_wr
	generic
	(
		constant_wr_mode	: boolean := true;
		synchronous_clock	: natural := 0;
		data_width			: natural := 8;
		addr_width			: natural := 4;
		byen_width			: natural := 1;
		ram_data_width		: natural := 8;
		ram_addr_width		: natural := 4;
		ram_byen_width		: natural := 1;
		ram_offset_addr		: natural := 0
	);
	port
	(
		tdm_clk				: in  std_logic;
		pclk				: in  std_logic;
		reset				: in  std_logic;
		vp_sel_stb_a		: in  std_logic;
		wr_en_a				: in  std_logic;
		data_in				: in  std_logic_vector(data_width -1 downto 0);
		addr_in				: in  std_logic_vector(addr_width -1 downto 0);
		byen_in				: in  std_logic_vector(byen_width -1 downto 0);
		ram_data			: out std_logic_vector(ram_data_width -1 downto 0);
		ram_addr			: out std_logic_vector(ram_addr_width -1 downto 0);
		ram_byen			: out std_logic_vector(ram_byen_width -1 downto 0);
		ram_wren			: out std_logic;
		vp_wr_req_a			: out std_logic
	);
end component;


component alt_csm_unidpram_com_bus_wr
	generic
	(
		implement_data_path	: boolean;
		data_width			: natural;
		addr_width			: natural;
		byen_width			: natural;
		ram_data_width		: natural;
		ram_addr_width		: natural;
		ram_byen_width		: natural;
		ram_offset_addr		: natural
	);
	port
	(
		wr_clk				: in  std_logic;
		reset				: in  std_logic;
		wren_in				: in  std_logic;
		vp_sel_in			: in  std_logic;
		data_in				: in  std_logic_vector(data_width -1 downto 0);
		addr_in				: in  std_logic_vector(addr_width -1 downto 0);
		byen_in				: in  std_logic_vector(byen_width -1 downto 0);
		ram_data			: out std_logic_vector(ram_data_width -1 downto 0);
		ram_addr			: out std_logic_vector(ram_addr_width -1 downto 0);
		ram_byen			: out std_logic_vector(ram_byen_width -1 downto 0);
		ram_wren			: out std_logic
	);
end component;


component alt_csm_unidpram_rd
	generic
	(
		buffer_input_data	: boolean;
		constant_rd_mode	: boolean;
		synchronous_clock	: natural;
		data_width			: natural;
		addr_width			: natural;
		ram_data_width		: natural;
		ram_addr_width		: natural;
		ram_offset_addr		: natural;
		mux_ram_delay		: natural;
		latency				: natural;
		invert_tdm_clk		: natural
	);
	port
	(
		tdm_clk				: in  std_logic;
		pclk				: in  std_logic;
		reset				: in  std_logic;
		vp_sel_stb_b		: in  std_logic;
		read_b				: in  std_logic;
		addr_in				: in  std_logic_vector(addr_width -1 downto 0);
		data_out			: out std_logic_vector(data_width -1 downto 0);
		ram_data			: in  std_logic_vector(ram_data_width -1 downto 0);
		ram_addr			: out std_logic_vector(ram_addr_width -1 downto 0);
		vp_rd_req_b			: out std_logic;
		data_valid			: out std_logic
	);
end component;


component alt_csm_unidpram_com_bus_rd
	generic
	(
		implement_data_path	: boolean;
		data_width			: natural;
		addr_width			: natural;
		ram_data_width		: natural;
		ram_addr_width		: natural;
		ram_offset_addr		: natural;
		mux_ram_delay		: natural;
		latency				: natural
	);
	port
	(
		rd_clk				: in  std_logic;
		reset				: in  std_logic;
		vp_sel_in			: in  std_logic;
		read_b				: in  std_logic;
		addr_in				: in  std_logic_vector(addr_width -1 downto 0);
		data_out			: out std_logic_vector(data_width -1 downto 0);
		ram_data			: in  std_logic_vector(ram_data_width -1 downto 0);
		ram_addr			: out std_logic_vector(ram_addr_width -1 downto 0);
		vp_rd_req_b			: out std_logic;
		data_valid			: out std_logic
	);
end component;


component alt_csm_mux_wr
	generic
	(
		data_width		: natural := 8;
		addr_width		: natural := 4;
		byen_width		: natural := 1;
		num_inputs		: natural := 4;
		no_data_mux		: boolean := false;
		no_pipe_reg		: boolean := false
	);
	port
	(
		clk				: in	std_logic;
		reset			: in	std_logic;

		select0			: in	std_logic;
		select1			: in	std_logic;
		select2			: in	std_logic;
		select3			: in	std_logic;
		select_out		: out	std_logic;

		data_in0		: in	std_logic_vector(data_width -1 downto 0);
		data_in1		: in	std_logic_vector(data_width -1 downto 0);
		data_in2		: in	std_logic_vector(data_width -1 downto 0);
		data_in3		: in	std_logic_vector(data_width -1 downto 0);
		data_out		: out	std_logic_vector(data_width -1 downto 0);

		addr_in0		: in	std_logic_vector(addr_width -1 downto 0);
		addr_in1		: in	std_logic_vector(addr_width -1 downto 0);
		addr_in2		: in	std_logic_vector(addr_width -1 downto 0);
		addr_in3		: in	std_logic_vector(addr_width -1 downto 0);
		addr_out		: out	std_logic_vector(addr_width -1 downto 0);

		byen_in0		: in	std_logic_vector(byen_width -1 downto 0);
		byen_in1		: in	std_logic_vector(byen_width -1 downto 0);
		byen_in2		: in	std_logic_vector(byen_width -1 downto 0);
		byen_in3		: in	std_logic_vector(byen_width -1 downto 0);
		byen_out		: out	std_logic_vector(byen_width -1 downto 0)
	);
end component;


component alt_csm_mux_rd
	generic
	(
		addr_width		: natural := 4;
		num_inputs		: natural := 4;
		no_pipe_reg		: boolean := false
	);
	port
	(
		clk				: in	std_logic;
		reset			: in	std_logic;

		select0			: in	std_logic;
		select1			: in	std_logic;
		select2			: in	std_logic;
		select3			: in	std_logic;
		select_out		: out	std_logic;

		addr_in0		: in	std_logic_vector(addr_width -1 downto 0);
		addr_in1		: in	std_logic_vector(addr_width -1 downto 0);
		addr_in2		: in	std_logic_vector(addr_width -1 downto 0);
		addr_in3		: in	std_logic_vector(addr_width -1 downto 0);
		addr_out		: out	std_logic_vector(addr_width -1 downto 0)
	);
end component;


component altsyncram
	generic
	(
		operation_mode			: string := "DUAL_PORT";
--x		maximum_depth			: integer;
		width_a					: integer;
		widthad_a				: integer;
		numwords_a				: integer;
		width_b					: integer;
		widthad_b				: integer;
		numwords_b				: integer;
		byte_size				: integer := 8;
		width_byteena_a			: integer := 1;
		indata_aclr_a			: string := "NONE";
		wrcontrol_aclr_a		: string := "NONE";
		address_aclr_a			: string := "NONE";
		byteena_aclr_a			: string := "NONE";
		address_reg_b			: string := "CLOCK1";
		outdata_reg_b			: string := "CLOCK1";
		address_aclr_b			: string := "NONE";
		outdata_aclr_b			: string := "NONE";
		ram_block_type			: string := "MEGARAM";
		lpm_type                : string := "altsyncram";
		intended_device_family	: string := "Stratix"
	);
	port
	(
		wren_a			:  in std_logic := '0';
		data_a			:  in std_logic_vector(width_a -1 downto 0):= (others => '0');
		address_a		:  in std_logic_vector(widthad_a -1 downto 0) := (others => '0');
		address_b		:  in std_logic_vector(widthad_b -1 downto 0) := (others => '0');
		clock0			:  in std_logic := '1';
		clock1			:  in std_logic := '1';
		clocken0		:  in std_logic := '1';
		clocken1		:  in std_logic := '1';
		byteena_a		:  in std_logic_vector(width_byteena_a -1 downto 0) := (others => '1');
		q_b				: out std_logic_vector(width_b -1 downto 0)
	);
end component;


--------------------------------------------------------------------------------
-- Type definitions
--------------------------------------------------------------------------------

type port_a_ram_wr_data_type is array (0 to 255) of std_logic_vector(param_port_a_ram_wr_data_width -1 downto 0);
type mux_a_L0_data_type		 is array (0 to  63) of std_logic_vector(param_port_a_ram_wr_data_width -1 downto 0);
type mux_a_L1_data_type		 is array (0 to  15) of std_logic_vector(param_port_a_ram_wr_data_width -1 downto 0);
type mux_a_L2_data_type		 is array (0 to   3) of std_logic_vector(param_port_a_ram_wr_data_width -1 downto 0);

type port_a_ram_addr_type	 is array (0 to 255) of std_logic_vector(param_port_a_ram_addr_width -1 downto 0);
type mux_a_L0_addr_type		 is array (0 to  63) of std_logic_vector(param_port_a_ram_addr_width -1 downto 0);
type mux_a_L1_addr_type		 is array (0 to  15) of std_logic_vector(param_port_a_ram_addr_width -1 downto 0);
type mux_a_L2_addr_type		 is array (0 to   3) of std_logic_vector(param_port_a_ram_addr_width -1 downto 0);

type port_a_ram_byen_type	 is array (0 to 255) of std_logic_vector(param_port_a_ram_byte_en_width -1 downto 0);
type mux_a_L0_byen_type		 is array (0 to  63) of std_logic_vector(param_port_a_ram_byte_en_width -1 downto 0);
type mux_a_L1_byen_type		 is array (0 to  15) of std_logic_vector(param_port_a_ram_byte_en_width -1 downto 0);
type mux_a_L2_byen_type		 is array (0 to   3) of std_logic_vector(param_port_a_ram_byte_en_width -1 downto 0);

type port_a_ram_wren_type	 is array (0 to 255) of std_logic;
type mux_a_L0_wren_type		 is array (0 to  63) of std_logic;
type mux_a_L1_wren_type		 is array (0 to  15) of std_logic;
type mux_a_L2_wren_type		 is array (0 to   3) of std_logic;

type port_b_ram_addr_type	 is array (0 to 255) of std_logic_vector(param_port_b_ram_addr_width -1 downto 0);
type mux_b_L0_addr_type		 is array (0 to  63) of std_logic_vector(param_port_b_ram_addr_width -1 downto 0);
type mux_b_L1_addr_type		 is array (0 to  15) of std_logic_vector(param_port_b_ram_addr_width -1 downto 0);
type mux_b_L2_addr_type		 is array (0 to   3) of std_logic_vector(param_port_b_ram_addr_width -1 downto 0);


--------------------------------------------------------------------------------
-- Constant Declarations
--------------------------------------------------------------------------------

-- How many levels of mux registers are required for the number of specified ports
-- Calculation assumes a 4:1 mux implementation.

constant c_mux_a_levels		: natural := calc_mux_levels(param_num_a_ports -1);
constant c_mux_b_levels		: natural := calc_mux_levels(param_num_b_ports -1);

-- clock cycles from port write to ram until available for read (used in fifo)
constant c_mux_ram_a_latency	: natural := c_mux_a_levels +2;
-- clock cycles from port read of ram until data available at port
constant c_mux_ram_b_latency	: natural := c_mux_b_levels +2;

constant fifo_c_mux_ram_b_latency	: natural := calc_mux_levels(param_num_b_ports) +2;

-- controls whether the wr mux tree operates on data or not.
constant c_no_wr_data_mux	: boolean := (param_topology = "UNIDPRAM_COMMON_BUS_MODE_1_TO_N");

-- round up the number of ports to an integer divisible by 4 (the basic mux width)
-- use this to create internal signals s.t. the mux generation code is happy.
constant num_a_ports_rnd_up	: natural := ((((param_num_a_ports -1) /4) +1) *4);
constant num_b_ports_rnd_up	: natural := ((((param_num_b_ports -1) /4) +1) *4);

constant vp_sel_num_a_width : natural := unsigned_num_bits(param_num_a_ports -1);
constant vp_sel_num_b_width : natural := unsigned_num_bits(param_num_b_ports -1);
--------------------------------------------------------------------------------
-- Signal Declarations
--------------------------------------------------------------------------------

signal int_async_reset		: std_logic;

signal ram_wr_clk			: std_logic;
signal ram_rd_clk			: std_logic;

signal vp_sel_stb_a			: std_logic_vector(num_a_ports_rnd_up -1 downto 0) := (others => '0');
signal vp_sel_num_a			: std_logic_vector(7 downto 0) := (others => '0');
signal vp_wr_req_a			: std_logic_vector(num_a_ports_rnd_up -1 downto 0) := (others => '0');

signal vp_sel_stb_b			: std_logic_vector(num_b_ports_rnd_up -1 downto 0) := (others => '0');
signal vp_sel_num_b			: std_logic_vector(7 downto 0) := (others => '0');
signal vp_rd_req_b			: std_logic_vector(num_b_ports_rnd_up -1 downto 0) := (others => '0');

signal ram_data_b			: std_logic_vector(param_port_b_ram_rd_data_width -1 downto 0);

--------------------------------------------------------------------------------
--
-- A side data mux signals
--
signal vport_data_a			: port_a_ram_wr_data_type;
signal mux_a_L0_data		: mux_a_L0_data_type;
signal mux_a_L1_data		: mux_a_L1_data_type;
signal mux_a_L2_data		: mux_a_L2_data_type;
signal ram_data_a			: std_logic_vector(param_port_a_ram_wr_data_width -1 downto 0);

--------------------------------------------------------------------------------
--
-- A side address mux signals
--
signal vport_addr_a			: port_a_ram_addr_type;
signal mux_a_L0_addr		: mux_a_L0_addr_type;
signal mux_a_L1_addr		: mux_a_L1_addr_type;
signal mux_a_L2_addr		: mux_a_L2_addr_type;
signal ram_addr_a			: std_logic_vector(param_port_a_ram_addr_width -1 downto 0);

--------------------------------------------------------------------------------
--
-- A side byte enable mux signals
--
signal vport_byen_a			: port_a_ram_byen_type;
signal mux_a_L0_byen		: mux_a_L0_byen_type;
signal mux_a_L1_byen		: mux_a_L1_byen_type;
signal mux_a_L2_byen		: mux_a_L2_byen_type;
signal ram_byen_a			: std_logic_vector(param_port_a_ram_byte_en_width -1 downto 0);

--------------------------------------------------------------------------------
--
-- A side write enable mux signals
--
signal vport_wren_a			: port_a_ram_wren_type;
signal mux_a_L0_wren		: mux_a_L0_wren_type;
signal mux_a_L1_wren		: mux_a_L1_wren_type;
signal mux_a_L2_wren		: mux_a_L2_wren_type;
signal ram_wren_a			: std_logic;

--------------------------------------------------------------------------------
--
-- B side address mux signals
--
signal vport_addr_b			: port_b_ram_addr_type;
signal mux_b_L0_addr		: mux_b_L0_addr_type;
signal mux_b_L1_addr		: mux_b_L1_addr_type;
signal mux_b_L2_addr		: mux_b_L2_addr_type;
signal ram_addr_b			: std_logic_vector(param_port_b_ram_addr_width -1 downto 0);

--------------------------------------------------------------------------------
--
-- B side read enable mux signals
--
signal rd_mux_b_L0_read		: std_logic_vector(63 downto 0);
signal rd_mux_b_L1_read		: std_logic_vector(15 downto 0);
signal rd_mux_b_L2_read		: std_logic_vector( 3 downto 0);
signal ram_read_b			: std_logic;

begin

--? this construct not accepted by Synplicity /= not overloaded for string types
--? would like to check this
--?	mode_err : if (param_topology /= "FIFO_AND_UNIDPRAM_MODE") generate
--?		assert false report "param_topology must be FIFO_AND_UNIDPRAM_MODE" severity error;
--?	end generate;

	num_a_ports_err : if ((param_num_a_ports < 2) OR (param_num_a_ports > 256)) generate
		assert false report "param_num_a_ports must in range 2 to 256" severity error;
	end generate;

	num_b_ports_err : if ((param_num_b_ports < 2) OR (param_num_b_ports > 256)) generate
		assert false report "param_num_b_ports must in range 2 to 256" severity error;
	end generate;

	ext_ram_err : if (param_use_ext_ram /= 0) generate
		assert false report "param_use_ext_ram must be 0, external ram mode not supported yet" severity error;
	end generate;

	gen_hi_aclr : if (param_aclr_polarity = 0) generate
		int_async_reset <= c_async_reset_val when (reset = '0') else NOT c_async_reset_val;
	end generate;

	gen_lo_aclr : if (param_aclr_polarity /= 0) generate
		int_async_reset <= c_async_reset_val when (reset = '1') else NOT c_async_reset_val;
	end generate;


--------------------------------------------------------------------------------
--
-- drive ram signals to port pin for testing purposes
--
--n		ram_addr_a <= ram_addr_a;
--n		ram_byte_en_a
--n		ram_wr_en_a
--n		ram_addr_b

--------------------------------------------------------------------------------

	gen_clk_1 : if
		(param_topology = "FIFO_AND_UNIDPRAM_MODE") OR
		(param_topology = "FIFO_COMMON_CLOCK_MODE_1_TO_N") OR
		(param_topology = "FIFO_COMMON_CLOCK_MODE_N_TO_1")
	generate
		ram_wr_clk <= tdm_clk;
		ram_rd_clk <= tdm_clk;
	end generate gen_clk_1;

	gen_clk_2 : if
		(param_topology = "UNIDPRAM_COMMON_BUS_MODE_1_TO_N")
	generate
		ram_wr_clk <= clk_port_a(0);
		ram_rd_clk <= tdm_clk;
	end generate gen_clk_2;

	gen_clk_3 : if
		(param_topology = "UNIDPRAM_COMMON_BUS_MODE_N_TO_1")
	generate
		ram_wr_clk <= tdm_clk;
		ram_rd_clk <= clk_port_b(0);
	end generate gen_clk_3;


--n	int_ram : if (param_use_ext_ram = 0) generate

gen_1byte_ram : if ((param_port_a_ram_wr_data_width / param_byte_size = 1)) generate
	inst_megaram : altsyncram
	generic map
	(
--x		maximum_depth		=> param_port_a_ram_wr_data_width * (2 ** param_port_a_ram_addr_width),
		width_a				=> param_port_a_ram_wr_data_width,
		widthad_a			=> param_port_a_ram_addr_width,
		numwords_a			=> 2 ** param_port_a_ram_addr_width,
		width_b				=> param_port_b_ram_rd_data_width,
		widthad_b			=> param_port_b_ram_addr_width,
		numwords_b			=> 2 ** param_port_b_ram_addr_width,
		byte_size			=> param_byte_size,
		width_byteena_a		=> unsigned_max_val(1, param_port_a_ram_byte_en_width),
		ram_block_type		=> param_ram_block_type,
		intended_device_family	=> param_intended_device_family
	)
	port map
	(
		wren_a		=> ram_wren_a,
		data_a		=> ram_data_a,
		address_a	=> ram_addr_a,
		address_b	=> ram_addr_b,
		clock0		=> ram_wr_clk,
		clock1		=> ram_rd_clk,
		clocken0	=> '1',
		clocken1	=> '1',
--!		byteena_a	=> ram_byen_a,
		q_b			=> ram_data_b
	);
end generate gen_1byte_ram;

gen_nbyte_ram : if ((param_port_a_ram_wr_data_width / param_byte_size) /= 1) generate
	inst_megaram : altsyncram
	generic map
	(
--x		maximum_depth		=> param_port_a_ram_wr_data_width * (2 ** param_port_a_ram_addr_width),
		width_a				=> param_port_a_ram_wr_data_width,
		widthad_a			=> param_port_a_ram_addr_width,
		numwords_a			=> 2 ** param_port_a_ram_addr_width,
		width_b				=> param_port_b_ram_rd_data_width,
		widthad_b			=> param_port_b_ram_addr_width,
		numwords_b			=> 2 ** param_port_b_ram_addr_width,
		byte_size			=> param_byte_size,
		width_byteena_a		=> unsigned_max_val(1, param_port_a_ram_byte_en_width),
		ram_block_type		=> param_ram_block_type,
		intended_device_family	=> param_intended_device_family
	)
	port map
	(
		wren_a		=> ram_wren_a,
		data_a		=> ram_data_a,
		address_a	=> ram_addr_a,
		address_b	=> ram_addr_b,
		clock0		=> ram_wr_clk,
		clock1		=> ram_rd_clk,
		clocken0	=> '1',
		clocken1	=> '1',
		byteena_a	=> ram_byen_a,
		q_b			=> ram_data_b
	);
end generate gen_nbyte_ram;

--n	end generate int_ram;


gen_a_seq : if 
	(param_topology = "FIFO_AND_UNIDPRAM_MODE") or 
	(param_topology = "UNIDPRAM_COMMON_BUS_MODE_N_TO_1") or 
	(param_topology = "FIFO_COMMON_CLOCK_MODE_N_TO_1")
generate

	inst_a_seq : alt_csm_sequence
	generic map
	(
		num_states			=> param_num_a_states,
		num_states_width	=> unsigned_num_bits(param_num_a_states -1),
		num_ports			=> param_num_a_ports,
		num_ports_width		=> unsigned_num_bits(param_num_a_ports -1),
		seq_rom_mif			=> param_seq_a_rom_mif
	)
	port map
	(
		clk					=> tdm_clk,
		reset				=> int_async_reset,
		active_port_stb		=> vp_sel_stb_a(param_num_a_ports -1 downto 0),
		active_port_num		=> vp_sel_num_a(vp_sel_num_a_width -1 downto 0)
	);

end generate gen_a_seq;


gen_b_seq : if
	(param_topology = "FIFO_AND_UNIDPRAM_MODE") or 
	(param_topology = "UNIDPRAM_COMMON_BUS_MODE_1_TO_N") or 
	(param_topology = "FIFO_COMMON_CLOCK_MODE_1_TO_N")
generate

	inst_b_seq : alt_csm_sequence
	generic map
	(
		num_states			=> param_num_b_states,
		num_states_width	=> unsigned_num_bits(param_num_b_states -1),
		num_ports			=> param_num_b_ports,
		num_ports_width		=> unsigned_num_bits(param_num_b_ports -1),
		seq_rom_mif			=> param_seq_b_rom_mif
	)
	port map
	(
		clk					=> tdm_clk,
		reset				=> int_async_reset,
		active_port_stb		=> vp_sel_stb_b(param_num_b_ports -1 downto 0),
		active_port_num		=> vp_sel_num_b(vp_sel_num_b_width -1 downto 0)
	);

end generate gen_b_seq;


gen_port : for i in 0 to param_num_a_ports -1 generate

	fifo_port_n_to_n : if (param_a_port_type(i) = 1) AND (param_b_port_type(i) = 1) generate
		constant wr_width	: natural := (param_wr_data_a_port_end(i) - param_wr_data_a_port_start(i) +1);
		constant rd_width	: natural := (param_rd_data_b_port_end(i) - param_rd_data_b_port_start(i) +1);
		constant wr_depth	: natural := (param_wr_fifo_level_end(i) - param_wr_fifo_level_start(i) +1);
		constant rd_depth	: natural := (param_rd_fifo_level_end(i) - param_rd_fifo_level_start(i) +1);
	begin
		inst_fifo : alt_csm_fifo
		generic map
		(
			wr_port_type		=> 1,
			rd_port_type		=> 1,

			wr_data_width		=> wr_width,
			wr_addr_width		=> wr_depth,

			rd_data_width		=> rd_width,
			rd_addr_width		=> rd_depth,

			ram_a_data_width	=> param_port_a_ram_wr_data_width,
			ram_a_addr_width	=> param_port_a_ram_addr_width,
			ram_a_byen_width	=> param_port_a_ram_byte_en_width,
			ram_a_addr_offset	=> param_port_a_port_addr_offset(i),

			ram_b_data_width	=> param_port_b_ram_rd_data_width,
			ram_b_addr_width	=> param_port_b_ram_addr_width,
			ram_b_addr_offset	=> param_port_b_port_addr_offset(i),

			rd_lookahead		=> param_rd_fifo_lookahead(i),

			wr_clk_is_sync		=> param_port_a_clk_is_sync(i),
			rd_clk_is_sync		=> param_port_b_clk_is_sync(i),

--x			tdm_wr_latency		=> c_mux_ram_a_latency +2,
			tdm_wr_latency		=> c_mux_ram_a_latency,
			tdm_rd_latency		=> fifo_c_mux_ram_b_latency +1
		)
		port map
		(
			tdm_clk		=> tdm_clk,
			reset		=> int_async_reset,
			wr_clk		=> clk_port_a(i),
			rd_clk		=> clk_port_b(i),

			wr_data		=> wr_data_a(param_wr_data_a_port_end(i) downto param_wr_data_a_port_start(i)),
			wr_en		=> wr_en_a(i),
			wr_ff		=> wr_full(i),
			wr_ef		=> wr_empty(i),
			wr_level	=> wr_level(param_wr_fifo_level_end(i) downto param_wr_fifo_level_start(i)),

			rd_data		=> rd_data_b(param_rd_data_b_port_end(i) downto param_rd_data_b_port_start(i)),
			rd_en		=> read_b(i),
			rd_ff		=> rd_full(i),
			rd_ef		=> rd_empty(i),
			rd_level	=> rd_level(param_rd_fifo_level_end(i) downto param_rd_fifo_level_start(i)),
			rd_dv		=> data_valid_b(i),

			tdm_wr_req	=> vp_wr_req_a(i),
			tdm_wr_ack	=> vp_sel_stb_a(i),

			ram_a_data	=> vport_data_a(i),
			ram_a_addr	=> vport_addr_a(i),
			ram_a_byen	=> vport_byen_a(i),
			ram_a_wren	=> vport_wren_a(i),

			tdm_rd_req	=> vp_rd_req_b(i),
			tdm_rd_ack	=> vp_sel_stb_b(i),

			ram_b_data	=> ram_data_b,
			ram_b_addr	=> vport_addr_b(i)
		);
	end generate fifo_port_n_to_n;

	fifo_port_1_to_n : if (param_a_port_type(i) = 3) AND (param_b_port_type(i) = 1) generate
		constant wr_width	: natural := (param_wr_data_a_port_end(i) - param_wr_data_a_port_start(i) +1);
		constant rd_width	: natural := (param_rd_data_b_port_end(i) - param_rd_data_b_port_start(i) +1);
		constant wr_depth	: natural := (param_wr_fifo_level_end(i) - param_wr_fifo_level_start(i) +1);
		constant rd_depth	: natural := (param_rd_fifo_level_end(i) - param_rd_fifo_level_start(i) +1);
	begin
		inst_fifo : alt_csm_fifo
		generic map
		(
			wr_port_type		=> 3,
			rd_port_type		=> 1,

			wr_data_width		=> wr_width,
			wr_addr_width		=> wr_depth,

			rd_data_width		=> rd_width,
			rd_addr_width		=> rd_depth,

			ram_a_data_width	=> param_port_a_ram_wr_data_width,
			ram_a_addr_width	=> param_port_a_ram_addr_width,
			ram_a_byen_width	=> param_port_a_ram_byte_en_width,
			ram_a_addr_offset	=> param_port_a_port_addr_offset(i),

			ram_b_data_width	=> param_port_b_ram_rd_data_width,
			ram_b_addr_width	=> param_port_b_ram_addr_width,
			ram_b_addr_offset	=> param_port_b_port_addr_offset(i),

			rd_lookahead		=> param_rd_fifo_lookahead(i),

			wr_clk_is_sync		=> param_port_a_clk_is_sync(i),
			rd_clk_is_sync		=> param_port_b_clk_is_sync(i),

			tdm_wr_latency		=> c_mux_ram_a_latency +2,
			tdm_rd_latency		=> c_mux_ram_b_latency +1
		)
		port map
		(
			tdm_clk		=> tdm_clk,
			reset		=> int_async_reset,
			wr_clk		=> tdm_clk, --!!!
			rd_clk		=> clk_port_b(i),

			wr_data		=> wr_data_a(param_wr_data_a_port_end(i) downto param_wr_data_a_port_start(i)),
			wr_en		=> wr_en_a(i),
			wr_ff		=> wr_full(i),
			wr_ef		=> wr_empty(i),
			wr_level	=> wr_level(param_wr_fifo_level_end(i) downto param_wr_fifo_level_start(i)),

			rd_data		=> rd_data_b(param_rd_data_b_port_end(i) downto param_rd_data_b_port_start(i)),
			rd_en		=> read_b(i),
			rd_ff		=> rd_full(i),
			rd_ef		=> rd_empty(i),
			rd_level	=> rd_level(param_rd_fifo_level_end(i) downto param_rd_fifo_level_start(i)),
			rd_dv		=> data_valid_b(i),

			tdm_wr_req	=> vp_wr_req_a(i),
			tdm_wr_ack	=> vp_sel_stb_a(i),

			ram_a_data	=> vport_data_a(i),
			ram_a_addr	=> vport_addr_a(i),
			ram_a_byen	=> vport_byen_a(i),
			ram_a_wren	=> vport_wren_a(i),

			tdm_rd_req	=> vp_rd_req_b(i),
			tdm_rd_ack	=> vp_sel_stb_b(i),

			ram_b_data	=> ram_data_b,
			ram_b_addr	=> vport_addr_b(i)
		);
	end generate fifo_port_1_to_n;

	fifo_port_n_to_1 : if (param_a_port_type(i) = 1) AND (param_b_port_type(i) = 3) generate
		constant wr_width	: natural := (param_wr_data_a_port_end(i) - param_wr_data_a_port_start(i) +1);
		constant rd_width	: natural := (param_rd_data_b_port_end(i) - param_rd_data_b_port_start(i) +1);
		constant wr_depth	: natural := (param_wr_fifo_level_end(i) - param_wr_fifo_level_start(i) +1);
		constant rd_depth	: natural := (param_rd_fifo_level_end(i) - param_rd_fifo_level_start(i) +1);
	begin
		inst_fifo : alt_csm_fifo
		generic map
		(
			wr_port_type		=> 1,
			rd_port_type		=> 3,

			wr_data_width		=> wr_width,
			wr_addr_width		=> wr_depth,

			rd_data_width		=> rd_width,
			rd_addr_width		=> rd_depth,

			ram_a_data_width	=> param_port_a_ram_wr_data_width,
			ram_a_addr_width	=> param_port_a_ram_addr_width,
			ram_a_byen_width	=> param_port_a_ram_byte_en_width,
			ram_a_addr_offset	=> param_port_a_port_addr_offset(i),

			ram_b_data_width	=> param_port_b_ram_rd_data_width,
			ram_b_addr_width	=> param_port_b_ram_addr_width,
			ram_b_addr_offset	=> param_port_b_port_addr_offset(i),

			rd_lookahead		=> param_rd_fifo_lookahead(i),

			wr_clk_is_sync		=> param_port_a_clk_is_sync(i),
			rd_clk_is_sync		=> param_port_b_clk_is_sync(i),

			tdm_wr_latency		=> c_mux_ram_a_latency +2,
			tdm_rd_latency		=> c_mux_ram_b_latency +1
		)
		port map
		(
			tdm_clk		=> tdm_clk,
			reset		=> int_async_reset,
			wr_clk		=> clk_port_a(i),
			rd_clk		=> tdm_clk,

			wr_data		=> wr_data_a(param_wr_data_a_port_end(i) downto param_wr_data_a_port_start(i)),
			wr_en		=> wr_en_a(i),
			wr_ff		=> wr_full(i),
			wr_ef		=> wr_empty(i),
			wr_level	=> wr_level(param_wr_fifo_level_end(i) downto param_wr_fifo_level_start(i)),

			rd_data		=> rd_data_b(param_rd_data_b_port_end(i) downto param_rd_data_b_port_start(i)),
			rd_en		=> read_b(i),
			rd_ff		=> rd_full(i),
			rd_ef		=> rd_empty(i),
			rd_level	=> rd_level(param_rd_fifo_level_end(i) downto param_rd_fifo_level_start(i)),
			rd_dv		=> data_valid_b(i),

			tdm_wr_req	=> vp_wr_req_a(i),
			tdm_wr_ack	=> vp_sel_stb_a(i),

			ram_a_data	=> vport_data_a(i),
			ram_a_addr	=> vport_addr_a(i),
			ram_a_byen	=> vport_byen_a(i),
			ram_a_wren	=> vport_wren_a(i),

			tdm_rd_req	=> vp_rd_req_b(i),
			tdm_rd_ack	=> vp_sel_stb_b(i),

			ram_b_data	=> ram_data_b,
			ram_b_addr	=> vport_addr_b(i)
		);
	end generate fifo_port_n_to_1;

	unidpram_wr_n_port : if param_a_port_type(i) = 2 generate
		inst_unidpram_wr : alt_csm_unidpram_wr
		generic map
		(
			constant_wr_mode	=> false,
			synchronous_clock	=> param_port_a_clk_is_sync(i),
			data_width			=> (param_wr_data_a_port_end(i) - param_wr_data_a_port_start(i) +1),
			addr_width			=> (param_addr_a_port_end(i) - param_addr_a_port_start(i) +1),
			byen_width			=> (param_byte_en_a_port_end(i) - param_byte_en_a_port_start(i) +1),
			ram_data_width		=> param_port_a_ram_wr_data_width,
			ram_addr_width		=> param_port_a_ram_addr_width,
			ram_byen_width		=> param_port_a_ram_byte_en_width,
			ram_offset_addr		=> param_port_a_port_addr_offset(i)
		)
		port map
		(
			tdm_clk			=> tdm_clk,
			pclk			=> clk_port_a(i),
			reset			=> int_async_reset,
			vp_sel_stb_a	=> vp_sel_stb_a(i),
			wr_en_a			=> wr_en_a(i),
			data_in			=> wr_data_a(param_wr_data_a_port_end(i) downto param_wr_data_a_port_start(i)),
			addr_in			=> addr_a(param_addr_a_port_end(i) downto param_addr_a_port_start(i)),
			byen_in			=> byte_en_a(param_byte_en_a_port_end(i) downto param_byte_en_a_port_start(i)),
			ram_data		=> vport_data_a(i),
			ram_addr		=> vport_addr_a(i),
			ram_byen		=> vport_byen_a(i),
			ram_wren		=> vport_wren_a(i),
			vp_wr_req_a		=> vp_wr_req_a(i)
		);
	end generate unidpram_wr_n_port;

	unidpram_wr_1_port : if param_a_port_type(i) = 4 generate
		inst_unidpram_wr : alt_csm_unidpram_com_bus_wr
		generic map
		(
			implement_data_path	=> (i = 0), -- only implement a data path for vport 0
			data_width			=> (param_wr_data_a_port_end(i) - param_wr_data_a_port_start(i) +1),
			addr_width			=> (param_addr_a_port_end(i) - param_addr_a_port_start(i) +1),
			byen_width			=> (param_byte_en_a_port_end(i) - param_byte_en_a_port_start(i) +1),
			ram_data_width		=> param_port_a_ram_wr_data_width,
			ram_addr_width		=> param_port_a_ram_addr_width,
			ram_byen_width		=> param_port_a_ram_byte_en_width,
			ram_offset_addr		=> param_port_a_port_addr_offset(i)
		)
		port map
		(
			wr_clk			=> ram_wr_clk,
			reset			=> int_async_reset,
			wren_in			=> wr_en_a(0),
			vp_sel_in		=> com_dpram_cs_a(i),
			data_in			=> wr_data_a(param_wr_data_a_port_end(i) downto param_wr_data_a_port_start(i)),
			addr_in			=> addr_a(param_addr_a_port_end(i) downto param_addr_a_port_start(i)),
			byen_in			=> byte_en_a(param_byte_en_a_port_end(i) downto param_byte_en_a_port_start(i)),
			ram_data		=> vport_data_a(i), -- data is only routed through vport 0, others disabled in mux
			ram_addr		=> vport_addr_a(i),
			ram_byen		=> vport_byen_a(i),
			ram_wren		=> vport_wren_a(i)
		);
	end generate unidpram_wr_1_port;

	unidpram_rd_n_port : if param_b_port_type(i) = 2 generate
		inst_unidpram_rd : alt_csm_unidpram_rd
		generic map
		(
			buffer_input_data	=> false,
			constant_rd_mode	=> true,
			synchronous_clock	=> param_port_b_clk_is_sync(i),
			data_width			=> (param_rd_data_b_port_end(i) - param_rd_data_b_port_start(i) +1),
			addr_width			=> (param_addr_b_port_end(i) - param_addr_b_port_start(i) +1),
			ram_data_width		=> param_port_b_ram_rd_data_width,
			ram_addr_width		=> param_port_b_ram_addr_width,
			ram_offset_addr		=> param_port_b_port_addr_offset(i),
			mux_ram_delay		=> c_mux_ram_b_latency +1,
			latency				=> param_rd_latency(i),
			invert_tdm_clk		=> 0
		)
		port map
		(
			tdm_clk			=> tdm_clk,
			pclk			=> clk_port_b(i),
			reset			=> int_async_reset,
			vp_sel_stb_b	=> vp_sel_stb_b(i),
			read_b			=> read_b(i),
			addr_in			=> addr_b(param_addr_b_port_end(i) downto param_addr_b_port_start(i)),
			data_out		=> rd_data_b(param_rd_data_b_port_end(i) downto param_rd_data_b_port_start(i)),
			ram_data		=> ram_data_b,
			ram_addr		=> vport_addr_b(i),
			vp_rd_req_b		=> vp_rd_req_b(i),
			data_valid		=> data_valid_b(i)
		);
	end generate unidpram_rd_n_port;

	unidpram_rd_1_port : if param_b_port_type(i) = 4 generate
		gen_port_0 : if i = 0 generate
			inst_unidpram_rd : alt_csm_unidpram_com_bus_rd
			generic map
			(
				implement_data_path	=> true, -- only implement a data path for vport 0
				data_width			=> (param_rd_data_b_port_end(i) - param_rd_data_b_port_start(i) +1),
				addr_width			=> (param_addr_b_port_end(i) - param_addr_b_port_start(i) +1),
				ram_data_width		=> param_port_b_ram_rd_data_width,
				ram_addr_width		=> param_port_b_ram_addr_width,
				ram_offset_addr		=> param_port_b_port_addr_offset(i),
				mux_ram_delay		=> c_mux_ram_b_latency,
				latency				=> param_rd_latency(i)
			)
			port map
			(
				rd_clk			=> ram_rd_clk,
				reset			=> int_async_reset,
				vp_sel_in		=> com_dpram_cs_b(i),
				read_b			=> read_b(0),
				addr_in			=> addr_b(param_addr_b_port_end(i) downto param_addr_b_port_start(i)),
				data_out		=> rd_data_b(param_rd_data_b_port_end(i) downto param_rd_data_b_port_start(i)),
				ram_data		=> ram_data_b,
				ram_addr		=> vport_addr_b(i),
				vp_rd_req_b		=> vp_rd_req_b(i),
				data_valid		=> data_valid_b(i)
			);
		end generate gen_port_0;

		gen_port_n : if i /= 0 generate
			inst_unidpram_rd : alt_csm_unidpram_com_bus_rd
			generic map
			(
				implement_data_path	=> false, -- only implement a data path for vport 0
				data_width			=> (param_rd_data_b_port_end(i) - param_rd_data_b_port_start(i) +1),
				addr_width			=> (param_addr_b_port_end(i) - param_addr_b_port_start(i) +1),
				ram_data_width		=> param_port_b_ram_rd_data_width,
				ram_addr_width		=> param_port_b_ram_addr_width,
				ram_offset_addr		=> param_port_b_port_addr_offset(i),
				mux_ram_delay		=> c_mux_ram_b_latency,
				latency				=> param_rd_latency(i)
			)
			port map
			(
				rd_clk			=> ram_rd_clk,
				reset			=> int_async_reset,
				vp_sel_in		=> com_dpram_cs_b(i),
				read_b			=> read_b(0),
				addr_in			=> addr_b(param_addr_b_port_end(i) downto param_addr_b_port_start(i)),
--!				data_out		=> rd_data_b(param_rd_data_b_port_end(i) downto param_rd_data_b_port_start(i)),
				ram_data		=> ram_data_b,
				ram_addr		=> vport_addr_b(i),
				vp_rd_req_b		=> vp_rd_req_b(i),
				data_valid		=> data_valid_b(i)
			);
		end generate gen_port_n;

	end generate unidpram_rd_1_port;

end generate gen_port;


--------------------------------------------------------------------------------
--
--  Generate the write mux for port a
--
	wr_mux_a_L0 : for i in 0 to (param_num_a_ports -1)/4 generate
		other_wr_mux_a_L0 : if i /= (param_num_a_ports -1)/4 generate
			inst_wr_mux_a_L0 : alt_csm_mux_wr
				generic map
				(
					data_width		=> param_port_a_ram_wr_data_width,
					addr_width		=> param_port_a_ram_addr_width,
					byen_width		=> param_port_a_ram_byte_en_width,
					num_inputs		=> 4,
					no_data_mux		=> c_no_wr_data_mux, -- if com bus dpram, data on d0 only
					no_pipe_reg		=> false
				)
				port map
				(
					clk				=> ram_wr_clk,
					reset			=> int_async_reset,
					select0			=> vport_wren_a(i * 4),
					select1			=> vport_wren_a(i * 4 +1),
					select2			=> vport_wren_a(i * 4 +2),
					select3			=> vport_wren_a(i * 4 +3),
					select_out		=> mux_a_L0_wren(i),
					data_in0		=> vport_data_a(i * 4),
					data_in1		=> vport_data_a(i * 4 +1),
					data_in2		=> vport_data_a(i * 4 +2),
					data_in3		=> vport_data_a(i * 4 +3),
					data_out		=> mux_a_L0_data(i),
					addr_in0		=> vport_addr_a(i * 4),
					addr_in1		=> vport_addr_a(i * 4 +1),
					addr_in2		=> vport_addr_a(i * 4 +2),
					addr_in3		=> vport_addr_a(i * 4 +3),
					addr_out		=> mux_a_L0_addr(i),
					byen_in0		=> vport_byen_a(i * 4),
					byen_in1		=> vport_byen_a(i * 4 +1),
					byen_in2		=> vport_byen_a(i * 4 +2),
					byen_in3		=> vport_byen_a(i * 4 +3),
					byen_out		=> mux_a_L0_byen(i)
				);
		end generate other_wr_mux_a_L0;

		last_wr_mux_a_L0 : if i = (param_num_a_ports -1)/4 generate
			inst_wr_mux_a_L0 : alt_csm_mux_wr
				generic map
				(
					data_width		=> param_port_a_ram_wr_data_width,
					addr_width		=> param_port_a_ram_addr_width,
					byen_width		=> param_port_a_ram_byte_en_width,
					num_inputs		=> ((param_num_a_ports -1) MOD 4) +1,
					no_data_mux		=> c_no_wr_data_mux,
					no_pipe_reg		=> false
				)
				port map
				(
					clk				=> ram_wr_clk,
					reset			=> int_async_reset,
					select0			=> vport_wren_a(i * 4),
					select1			=> vport_wren_a(i * 4 +1),
					select2			=> vport_wren_a(i * 4 +2),
					select3			=> vport_wren_a(i * 4 +3),
					select_out		=> mux_a_L0_wren(i),
					data_in0		=> vport_data_a(i * 4),
					data_in1		=> vport_data_a(i * 4 +1),
					data_in2		=> vport_data_a(i * 4 +2),
					data_in3		=> vport_data_a(i * 4 +3),
					data_out		=> mux_a_L0_data(i),
					addr_in0		=> vport_addr_a(i * 4),
					addr_in1		=> vport_addr_a(i * 4 +1),
					addr_in2		=> vport_addr_a(i * 4 +2),
					addr_in3		=> vport_addr_a(i * 4 +3),
					addr_out		=> mux_a_L0_addr(i),
					byen_in0		=> vport_byen_a(i * 4),
					byen_in1		=> vport_byen_a(i * 4 +1),
					byen_in2		=> vport_byen_a(i * 4 +2),
					byen_in3		=> vport_byen_a(i * 4 +3),
					byen_out		=> mux_a_L0_byen(i)
				);
		end generate last_wr_mux_a_L0;
	end generate wr_mux_a_L0;

	wr_mux_a_L1 : for i in 0 to (param_num_a_ports -1)/16 generate
		other_wr_mux_a_L1 : if i /= (param_num_a_ports -1)/16 generate
			inst_wr_mux_a_L1 : alt_csm_mux_wr
				generic map
				(
					data_width		=> param_port_a_ram_wr_data_width,
					addr_width		=> param_port_a_ram_addr_width,
					byen_width		=> param_port_a_ram_byte_en_width,
					num_inputs		=> 4,
					no_data_mux		=> c_no_wr_data_mux,
					no_pipe_reg		=> (c_mux_a_levels < 2)
				)
				port map
				(
					clk				=> ram_wr_clk,
					reset			=> int_async_reset,
					select0			=> mux_a_L0_wren(i * 4),
					select1			=> mux_a_L0_wren(i * 4 +1),
					select2			=> mux_a_L0_wren(i * 4 +2),
					select3			=> mux_a_L0_wren(i * 4 +3),
					select_out		=> mux_a_L1_wren(i),
					data_in0		=> mux_a_L0_data(i * 4),
					data_in1		=> mux_a_L0_data(i * 4 +1),
					data_in2		=> mux_a_L0_data(i * 4 +2),
					data_in3		=> mux_a_L0_data(i * 4 +3),
					data_out		=> mux_a_L1_data(i),
					addr_in0		=> mux_a_L0_addr(i * 4),
					addr_in1		=> mux_a_L0_addr(i * 4 +1),
					addr_in2		=> mux_a_L0_addr(i * 4 +2),
					addr_in3		=> mux_a_L0_addr(i * 4 +3),
					addr_out		=> mux_a_L1_addr(i),
					byen_in0		=> mux_a_L0_byen(i * 4),
					byen_in1		=> mux_a_L0_byen(i * 4 +1),
					byen_in2		=> mux_a_L0_byen(i * 4 +2),
					byen_in3		=> mux_a_L0_byen(i * 4 +3),
					byen_out		=> mux_a_L1_byen(i)
				);
		end generate other_wr_mux_a_L1;

		last_wr_mux_a_L1 : if i = (param_num_a_ports -1)/16 generate
			inst_wr_mux_a_L1 : alt_csm_mux_wr
				generic map
				(
					data_width		=> param_port_a_ram_wr_data_width,
					addr_width		=> param_port_a_ram_addr_width,
					byen_width		=> param_port_a_ram_byte_en_width,
					num_inputs		=> (((param_num_a_ports -1) / 4) MOD 4) +1,
					no_data_mux		=> c_no_wr_data_mux,
					no_pipe_reg		=> (c_mux_a_levels < 2)
				)
				port map
				(
					clk				=> ram_wr_clk,
					reset			=> int_async_reset,
					select0			=> mux_a_L0_wren(i * 4),
					select1			=> mux_a_L0_wren(i * 4 +1),
					select2			=> mux_a_L0_wren(i * 4 +2),
					select3			=> mux_a_L0_wren(i * 4 +3),
					select_out		=> mux_a_L1_wren(i),
					data_in0		=> mux_a_L0_data(i * 4),
					data_in1		=> mux_a_L0_data(i * 4 +1),
					data_in2		=> mux_a_L0_data(i * 4 +2),
					data_in3		=> mux_a_L0_data(i * 4 +3),
					data_out		=> mux_a_L1_data(i),
					addr_in0		=> mux_a_L0_addr(i * 4),
					addr_in1		=> mux_a_L0_addr(i * 4 +1),
					addr_in2		=> mux_a_L0_addr(i * 4 +2),
					addr_in3		=> mux_a_L0_addr(i * 4 +3),
					addr_out		=> mux_a_L1_addr(i),
					byen_in0		=> mux_a_L0_byen(i * 4),
					byen_in1		=> mux_a_L0_byen(i * 4 +1),
					byen_in2		=> mux_a_L0_byen(i * 4 +2),
					byen_in3		=> mux_a_L0_byen(i * 4 +3),
					byen_out		=> mux_a_L1_byen(i)
				);
		end generate last_wr_mux_a_L1;
	end generate wr_mux_a_L1;

	wr_mux_a_L2 : for i in 0 to (param_num_a_ports -1)/64 generate
		other_wr_mux_a_L2 : if i /= (param_num_a_ports -1)/64 generate
			inst_wr_mux_a_L2 : alt_csm_mux_wr
				generic map
				(
					data_width		=> param_port_a_ram_wr_data_width,
					addr_width		=> param_port_a_ram_addr_width,
					byen_width		=> param_port_a_ram_byte_en_width,
					num_inputs		=> 4,
					no_data_mux		=> c_no_wr_data_mux,
					no_pipe_reg		=> (c_mux_a_levels < 3)
				)
				port map
				(
					clk				=> ram_wr_clk,
					reset			=> int_async_reset,
					select0			=> mux_a_L1_wren(i * 4),
					select1			=> mux_a_L1_wren(i * 4 +1),
					select2			=> mux_a_L1_wren(i * 4 +2),
					select3			=> mux_a_L1_wren(i * 4 +3),
					select_out		=> mux_a_L2_wren(i),
					data_in0		=> mux_a_L1_data(i * 4),
					data_in1		=> mux_a_L1_data(i * 4 +1),
					data_in2		=> mux_a_L1_data(i * 4 +2),
					data_in3		=> mux_a_L1_data(i * 4 +3),
					data_out		=> mux_a_L2_data(i),
					addr_in0		=> mux_a_L1_addr(i * 4),
					addr_in1		=> mux_a_L1_addr(i * 4 +1),
					addr_in2		=> mux_a_L1_addr(i * 4 +2),
					addr_in3		=> mux_a_L1_addr(i * 4 +3),
					addr_out		=> mux_a_L2_addr(i),
					byen_in0		=> mux_a_L1_byen(i * 4),
					byen_in1		=> mux_a_L1_byen(i * 4 +1),
					byen_in2		=> mux_a_L1_byen(i * 4 +2),
					byen_in3		=> mux_a_L1_byen(i * 4 +3),
					byen_out		=> mux_a_L2_byen(i)
				);
		end generate other_wr_mux_a_L2;

		last_wr_mux_a_L2 : if i = (param_num_a_ports -1)/64 generate
			inst_wr_mux_a_L2 : alt_csm_mux_wr
				generic map
				(
					data_width		=> param_port_a_ram_wr_data_width,
					addr_width		=> param_port_a_ram_addr_width,
					byen_width		=> param_port_a_ram_byte_en_width,
					num_inputs		=> (((param_num_a_ports -1) / 16) MOD 4) +1,
					no_data_mux		=> c_no_wr_data_mux,
					no_pipe_reg		=> (c_mux_a_levels < 3)
				)
				port map
				(
					clk				=> ram_wr_clk,
					reset			=> int_async_reset,
					select0			=> mux_a_L1_wren(i * 4),
					select1			=> mux_a_L1_wren(i * 4 +1),
					select2			=> mux_a_L1_wren(i * 4 +2),
					select3			=> mux_a_L1_wren(i * 4 +3),
					select_out		=> mux_a_L2_wren(i),
					data_in0		=> mux_a_L1_data(i * 4),
					data_in1		=> mux_a_L1_data(i * 4 +1),
					data_in2		=> mux_a_L1_data(i * 4 +2),
					data_in3		=> mux_a_L1_data(i * 4 +3),
					data_out		=> mux_a_L2_data(i),
					addr_in0		=> mux_a_L1_addr(i * 4),
					addr_in1		=> mux_a_L1_addr(i * 4 +1),
					addr_in2		=> mux_a_L1_addr(i * 4 +2),
					addr_in3		=> mux_a_L1_addr(i * 4 +3),
					addr_out		=> mux_a_L2_addr(i),
					byen_in0		=> mux_a_L1_byen(i * 4),
					byen_in1		=> mux_a_L1_byen(i * 4 +1),
					byen_in2		=> mux_a_L1_byen(i * 4 +2),
					byen_in3		=> mux_a_L1_byen(i * 4 +3),
					byen_out		=> mux_a_L2_byen(i)
				);
		end generate last_wr_mux_a_L2;
	end generate wr_mux_a_L2;

	wr_mux_a_L3 : if 256 > 65 generate
		inst_wr_mux_a_L3 : alt_csm_mux_wr
			generic map
			(
				data_width		=> param_port_a_ram_wr_data_width,
				addr_width		=> param_port_a_ram_addr_width,
				byen_width		=> param_port_a_ram_byte_en_width,
				num_inputs		=> ((param_num_a_ports -1) / 64) +1,
				no_data_mux		=> c_no_wr_data_mux,
				no_pipe_reg		=> (c_mux_a_levels < 4)
			)
			port map
			(
				clk				=> ram_wr_clk,
				reset			=> int_async_reset,
				select0			=> mux_a_L2_wren(0),
				select1			=> mux_a_L2_wren(1),
				select2			=> mux_a_L2_wren(2),
				select3			=> mux_a_L2_wren(3),
				select_out		=> ram_wren_a,
				data_in0		=> mux_a_L2_data(0),
				data_in1		=> mux_a_L2_data(1),
				data_in2		=> mux_a_L2_data(2),
				data_in3		=> mux_a_L2_data(3),
				data_out		=> ram_data_a,
				addr_in0		=> mux_a_L2_addr(0),
				addr_in1		=> mux_a_L2_addr(1),
				addr_in2		=> mux_a_L2_addr(2),
				addr_in3		=> mux_a_L2_addr(3),
				addr_out		=> ram_addr_a,
				byen_in0		=> mux_a_L2_byen(0),
				byen_in1		=> mux_a_L2_byen(1),
				byen_in2		=> mux_a_L2_byen(2),
				byen_in3		=> mux_a_L2_byen(3),
				byen_out		=> ram_byen_a
			);
	end generate wr_mux_a_L3;


--------------------------------------------------------------------------------
--
--  Generate the read mux for port b
--
	rd_mux_b_L0 : for i in 0 to (param_num_b_ports -1)/4 generate
		other_rd_mux_b_L0 : if i /= (param_num_b_ports -1)/4 generate
			inst_rd_mux_b_L0 : alt_csm_mux_rd
				generic map
				(
					addr_width		=> param_port_b_ram_addr_width,
					num_inputs		=> 4,
					no_pipe_reg		=> false
				)
				port map
				(
					clk				=> ram_rd_clk,
					reset			=> int_async_reset,
					select0			=> vp_rd_req_b(i * 4),
					select1			=> vp_rd_req_b(i * 4 +1),
					select2			=> vp_rd_req_b(i * 4 +2),
					select3			=> vp_rd_req_b(i * 4 +3),
					select_out		=> rd_mux_b_L0_read(i),
					addr_in0		=> vport_addr_b(i * 4),
					addr_in1		=> vport_addr_b(i * 4 +1),
					addr_in2		=> vport_addr_b(i * 4 +2),
					addr_in3		=> vport_addr_b(i * 4 +3),
					addr_out		=> mux_b_L0_addr(i)
				);
		end generate other_rd_mux_b_L0;

		last_rd_mux_b_L0 : if i = (param_num_b_ports -1)/4 generate
			inst_rd_mux_b_L0 : alt_csm_mux_rd
				generic map
				(
					addr_width		=> param_port_b_ram_addr_width,
					num_inputs		=> ((param_num_b_ports -1) MOD 4) +1,
					no_pipe_reg		=> false
				)
				port map
				(
					clk				=> ram_rd_clk,
					reset			=> int_async_reset,
					select0			=> vp_rd_req_b(i * 4),
					select1			=> vp_rd_req_b(i * 4 +1),
					select2			=> vp_rd_req_b(i * 4 +2),
					select3			=> vp_rd_req_b(i * 4 +3),
					select_out		=> rd_mux_b_L0_read(i),
					addr_in0		=> vport_addr_b(i * 4),
					addr_in1		=> vport_addr_b(i * 4 +1),
					addr_in2		=> vport_addr_b(i * 4 +2),
					addr_in3		=> vport_addr_b(i * 4 +3),
					addr_out		=> mux_b_L0_addr(i)
				);
		end generate last_rd_mux_b_L0;
	end generate rd_mux_b_L0;

	rd_mux_b_L1 : for i in 0 to (param_num_b_ports -1)/16 generate
		other_rd_mux_b_L1 : if i /= (param_num_b_ports -1)/16 generate
			inst_rd_mux_b_L1 : alt_csm_mux_rd
				generic map
				(
					addr_width		=> param_port_b_ram_addr_width,
					num_inputs		=> 4,
					no_pipe_reg		=> (c_mux_b_levels < 2)
				)
				port map
				(
					clk				=> ram_rd_clk,
					reset			=> int_async_reset,
					select0			=> rd_mux_b_L0_read(i * 4),
					select1			=> rd_mux_b_L0_read(i * 4 +1),
					select2			=> rd_mux_b_L0_read(i * 4 +2),
					select3			=> rd_mux_b_L0_read(i * 4 +3),
					select_out		=> rd_mux_b_L1_read(i),
					addr_in0		=> mux_b_L0_addr(i * 4),
					addr_in1		=> mux_b_L0_addr(i * 4 +1),
					addr_in2		=> mux_b_L0_addr(i * 4 +2),
					addr_in3		=> mux_b_L0_addr(i * 4 +3),
					addr_out		=> mux_b_L1_addr(i)
				);
		end generate other_rd_mux_b_L1;

		last_rd_mux_b_L1 : if i = (param_num_b_ports -1)/16 generate
			inst_rd_mux_b_L1 : alt_csm_mux_rd
				generic map
				(
					addr_width		=> param_port_b_ram_addr_width,
					num_inputs		=> (((param_num_b_ports -1) / 4) MOD 4) +1,
					no_pipe_reg		=> (c_mux_b_levels < 2)
				)
				port map
				(
					clk				=> ram_rd_clk,
					reset			=> int_async_reset,
					select0			=> rd_mux_b_L0_read(i * 4),
					select1			=> rd_mux_b_L0_read(i * 4 +1),
					select2			=> rd_mux_b_L0_read(i * 4 +2),
					select3			=> rd_mux_b_L0_read(i * 4 +3),
					select_out		=> rd_mux_b_L1_read(i),
					addr_in0		=> mux_b_L0_addr(i * 4),
					addr_in1		=> mux_b_L0_addr(i * 4 +1),
					addr_in2		=> mux_b_L0_addr(i * 4 +2),
					addr_in3		=> mux_b_L0_addr(i * 4 +3),
					addr_out		=> mux_b_L1_addr(i)
				);
		end generate last_rd_mux_b_L1;
	end generate rd_mux_b_L1;

	rd_mux_b_L2 : for i in 0 to (param_num_b_ports -1)/64 generate
		other_rd_mux_b_L2 : if i /= (param_num_b_ports -1)/64 generate
			inst_rd_mux_b_L2 : alt_csm_mux_rd
				generic map
				(
					addr_width		=> param_port_b_ram_addr_width,
					num_inputs		=> 4,
					no_pipe_reg		=> (c_mux_b_levels < 3)
				)
				port map
				(
					clk				=> ram_rd_clk,
					reset			=> int_async_reset,
					select0			=> rd_mux_b_L1_read(i * 4),
					select1			=> rd_mux_b_L1_read(i * 4 +1),
					select2			=> rd_mux_b_L1_read(i * 4 +2),
					select3			=> rd_mux_b_L1_read(i * 4 +3),
					select_out		=> rd_mux_b_L2_read(i),
					addr_in0		=> mux_b_L1_addr(i * 4),
					addr_in1		=> mux_b_L1_addr(i * 4 +1),
					addr_in2		=> mux_b_L1_addr(i * 4 +2),
					addr_in3		=> mux_b_L1_addr(i * 4 +3),
					addr_out		=> mux_b_L2_addr(i)
				);
		end generate other_rd_mux_b_L2;

		last_rd_mux_b_L2 : if i = (param_num_b_ports -1)/64 generate
			inst_rd_mux_b_L2 : alt_csm_mux_rd
				generic map
				(
					addr_width		=> param_port_b_ram_addr_width,
					num_inputs		=> (((param_num_b_ports -1) / 16) MOD 4) +1,
					no_pipe_reg		=> (c_mux_b_levels < 3)
				)
				port map
				(
					clk				=> ram_rd_clk,
					reset			=> int_async_reset,
					select0			=> rd_mux_b_L1_read(i * 4),
					select1			=> rd_mux_b_L1_read(i * 4 +1),
					select2			=> rd_mux_b_L1_read(i * 4 +2),
					select3			=> rd_mux_b_L1_read(i * 4 +3),
					select_out		=> rd_mux_b_L2_read(i),
					addr_in0		=> mux_b_L1_addr(i * 4),
					addr_in1		=> mux_b_L1_addr(i * 4 +1),
					addr_in2		=> mux_b_L1_addr(i * 4 +2),
					addr_in3		=> mux_b_L1_addr(i * 4 +3),
					addr_out		=> mux_b_L2_addr(i)
				);
		end generate last_rd_mux_b_L2;
	end generate rd_mux_b_L2;

	rd_mux_b_L3 : if 256 > 64 generate
		inst_rd_mux_b_L3 : alt_csm_mux_rd
			generic map
			(
				addr_width		=> param_port_b_ram_addr_width,
				num_inputs		=> ((param_num_b_ports -1) / 64) +1,
				no_pipe_reg		=> (c_mux_b_levels < 4)
			)
			port map
			(
				clk				=> ram_rd_clk,
				reset			=> int_async_reset,
				select0			=> rd_mux_b_L2_read(0),
				select1			=> rd_mux_b_L2_read(1),
				select2			=> rd_mux_b_L2_read(2),
				select3			=> rd_mux_b_L2_read(3),
				select_out		=> ram_read_b,
				addr_in0		=> mux_b_L2_addr(0),
				addr_in1		=> mux_b_L2_addr(1),
				addr_in2		=> mux_b_L2_addr(2),
				addr_in3		=> mux_b_L2_addr(3),
				addr_out		=> ram_addr_b
			);
	end generate rd_mux_b_L3;

end rtl;
