--------------------------------------------------------------------------------
--
--              Altera Clock Shared Memory FIFO Source File
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
--      File Name:          alt_csm_fifo.vhd
--      Entity Name:        alt_csm_fifo
--
--      Description:
--
--          This submodule of altcsmem implements the virtual fifo port.
--
--------------------------------------------------------------------------------
--
--      Revision History
--      ----------------
--          03/14/02    first release.
--
--	I/O
--	----------------
--	Inputs:
--
--
--	Outputs:
--
--
--	Other
--	----------------
--
--	Instantiated Functions:		None
--
--	Instantiated Procedures:	None
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.alt_csm_const_pkg.all;
use work.alt_csm_func_pkg.all;


entity alt_csm_fifo is
	generic
	(
		wr_port_type		: natural := 1;
		rd_port_type		: natural := 1;

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
end alt_csm_fifo;


architecture rtl of alt_csm_fifo is

--------------------------------------------------------------------------------
-- Signal and constant declarations
--------------------------------------------------------------------------------

--
-- FIFO wr side signals
--
constant FASTER_WR_FLAGS	: boolean := TRUE;

signal wr_data_reg		: std_logic_vector(wr_data_width -1 downto 0);
signal wr_en_reg		: std_logic;
signal wr_ef_reg		: std_logic;
signal wr_ff_reg		: std_logic;
signal wr_level_reg		: std_logic_vector(wr_addr_width -1 downto 0);

type fifo_wr_port_type is
record
	wr_clk		: std_logic;
	wr_data		: std_logic_vector(wr_data_width -1 downto 0);
	wr_en		: std_logic;
	wr_ff		: std_logic;
	wr_ef		: std_logic;
	wr_level	: std_logic_vector(wr_addr_width -1 downto 0);
end record;

signal fifo_wr_port	: fifo_wr_port_type;

type fifo_wr_port_reg_type is
record
	wr_data_reg		: std_logic_vector(wr_data_width -1 downto 0);
	wr_en_reg		: std_logic;
end record;

signal fifo_wr_port_reg	: fifo_wr_port_reg_type;


signal wr_clk_reg_t0	: std_logic;
signal wr_clk_reg_t1	: std_logic;

signal wr_clk_ped_t0	: std_logic;
signal wr_clk_ped_t1	: std_logic;

signal wr_en_req_t0		: std_logic;

type fifo_wr_clk_type is
record
	wr_clk_reg_t0	: std_logic;
	wr_clk_reg_t1	: std_logic;
	wr_clk_ped_t0	: std_logic;
	wr_clk_ped_t1	: std_logic;
	wr_en_req_t0	: std_logic;
end record;

signal fifo_wr_clks	: fifo_wr_clk_type;


signal wr_preg_sh		: boolean;
signal wr_preg_ld		: boolean;

signal wr_preg_dv0		: boolean;
signal wr_preg_dv1		: boolean;

signal wr_preg_d0		: std_logic_vector(wr_data_width -1 downto 0);
signal wr_preg_d1		: std_logic_vector(wr_data_width -1 downto 0);
signal wr_preg_dx_in	: std_logic_vector(wr_data_width -1 downto 0);

type fifo_wr_pipe_type is
record
	wr_preg_sh		: boolean;
	wr_preg_ld		: boolean;
	wr_preg_dv0		: boolean;
	wr_preg_dv1		: boolean;
	wr_preg_d0		: std_logic_vector(wr_data_width -1 downto 0);
	wr_preg_d1		: std_logic_vector(wr_data_width -1 downto 0);
	wr_preg_dx_in	: std_logic_vector(wr_data_width -1 downto 0);
end record;

signal fifo_wr_pipe	: fifo_wr_pipe_type;


--
-- FIFO rd side signals
--
constant FASTER_RD_FLAGS	: boolean := TRUE;
constant FASTER_RD_CNTLS	: boolean := TRUE;

signal rd_data_reg		: std_logic_vector(rd_data_width -1 downto 0);
signal rd_en_reg		: std_logic;
signal rd_ef_reg		: std_logic;
signal rd_ff_reg		: std_logic;
signal rd_level_reg		: std_logic_vector(rd_addr_width -1 downto 0);
signal rd_dv_reg		: std_logic;

type fifo_rd_port_type is
record
	rd_clk		: std_logic;
	rd_data		: std_logic_vector(rd_data_width -1 downto 0);
	rd_en		: std_logic;
	rd_ff		: std_logic;
	rd_ef		: std_logic;
	rd_level	: std_logic_vector(rd_addr_width -1 downto 0);
	rd_dv		: std_logic;
end record;

signal fifo_rd_port	: fifo_rd_port_type;

type fifo_rd_port_reg_type is
record
	rd_data_reg		: std_logic_vector(rd_data_width -1 downto 0);
	rd_en_reg		: std_logic;
end record;

signal fifo_rd_port_reg	: fifo_rd_port_reg_type;


signal rd_clk_reg_t0	: std_logic;
signal rd_clk_reg_t1	: std_logic;

signal rd_clk_ped_t0	: std_logic;
signal rd_clk_ped_t1	: std_logic;

signal rd_en_req_t0		: std_logic;

type fifo_rd_clk_type is
record
	rd_clk_reg_t0	: std_logic;
	rd_clk_reg_t1	: std_logic;
	rd_clk_ped_t0	: std_logic;
	rd_clk_ped_t1	: std_logic;
	rd_en_req_t0	: std_logic;
end record;

signal fifo_rd_clks	: fifo_rd_clk_type;


signal rd_preg_sh		: boolean;
signal rd_preg_ld		: boolean;

signal rd_preg_dv0		: boolean;
signal rd_preg_dv1		: boolean;
signal rd_preg_dv2		: boolean;
signal rd_preg_dv3		: boolean;

signal rd_preg_d0		: std_logic_vector(rd_data_width -1 downto 0);
signal rd_preg_d1		: std_logic_vector(rd_data_width -1 downto 0);
signal rd_preg_d2		: std_logic_vector(rd_data_width -1 downto 0);
signal rd_preg_d3		: std_logic_vector(rd_data_width -1 downto 0);
signal rd_preg_dx_in	: std_logic_vector(rd_data_width -1 downto 0);

type fifo_rd_pipe_type is
record
	rd_preg_sh		: boolean;
	rd_preg_ld		: boolean;
	rd_preg_dv0		: boolean;
	rd_preg_dv1		: boolean;
	rd_preg_dv2		: boolean;
	rd_preg_dv3		: boolean;
	rd_preg_d0		: std_logic_vector(rd_data_width -1 downto 0);
	rd_preg_d1		: std_logic_vector(rd_data_width -1 downto 0);
	rd_preg_d2		: std_logic_vector(rd_data_width -1 downto 0);
	rd_preg_d3		: std_logic_vector(rd_data_width -1 downto 0);
	rd_preg_dx_in	: std_logic_vector(rd_data_width -1 downto 0);
end record;

signal fifo_rd_pipe	: fifo_rd_pipe_type;

signal ram_b_mux_d0	: std_logic_vector((rd_data_width *1) -1 downto 0);
signal ram_b_mux_d1	: std_logic_vector((rd_data_width *2) -1 downto 0);
signal ram_b_mux_d2	: std_logic_vector((rd_data_width *4) -1 downto 0);
signal ram_b_mux_d3	: std_logic_vector((rd_data_width *8) -1 downto 0);


--
-- Internal Signals
--
signal wr_ram_addr_1 			: std_logic_vector(1 downto 0);
signal wr_ram_addr_2 			: std_logic_vector(2 downto 0);
signal wr_ram_addr_3 			: std_logic_vector(3 downto 0);
signal wr_ram_addr				: std_logic_vector(wr_addr_width -1 downto 0);
signal rd_ram_addr				: std_logic_vector(rd_addr_width -1 downto 0);

signal wr_port_addr				: std_logic_vector(wr_addr_width downto 0);
signal wr_cur_addr				: std_logic_vector(wr_addr_width downto 0);
signal wr_val_addr				: std_logic_vector(wr_addr_width downto 0);

signal rd_port_addr				: std_logic_vector(rd_addr_width downto 0);
signal rd_cur_addr				: std_logic_vector(rd_addr_width downto 0);

signal next_wr_ef				: std_logic;
signal next_wr_ff				: std_logic;
signal next_wr_level			: std_logic_vector(wr_addr_width -1 downto 0);

signal tdm_wr_level				: std_logic_vector(wr_addr_width -1 downto 0);
signal tdm_stable_wr_level		: std_logic_vector(wr_addr_width -1 downto 0);

signal tdm_wr_level_zero		: std_logic;
signal tdm_stable_wr_level_zero	: std_logic;

signal tdm_wr_level_full		: std_logic;
signal tdm_stable_wr_level_full	: std_logic;

signal tdm_wr_level_near_full			: std_logic;
signal tdm_stable_wr_level_near_full	: std_logic;

signal next_rd_ef				: std_logic;
signal next_rd_ff				: std_logic;
signal next_rd_level			: std_logic_vector(rd_addr_width -1 downto 0);

signal tdm_rd_level				: std_logic_vector(rd_addr_width -1 downto 0);
signal tdm_stable_rd_level		: std_logic_vector(rd_addr_width -1 downto 0);

signal tdm_rd_level_zero			: std_logic;
signal tdm_stable_rd_level_zero		: std_logic;

signal tdm_rd_level_full			: std_logic;
signal tdm_stable_rd_level_full		: std_logic;

signal wr_level_diff		: std_logic_vector(wr_addr_width -1 downto 0);
signal wr_level_zero		: boolean;
signal wr_level_full		: boolean;
signal wr_level_near_full	: boolean;

signal rd_level_diff		: std_logic_vector(rd_addr_width -1 downto 0);
signal rd_level_zero		: boolean;
signal rd_level_full		: boolean;

signal rd_cntl_diff			: std_logic_vector(rd_addr_width -1 downto 0);

signal rd_data_avail		: boolean;
signal rd_data_avail_reg	: boolean;

signal tdm_wr_serv_req		: std_logic;
signal tdm_wr_serv_ack		: std_logic;
signal tdm_wr_data_ack		: std_logic;

signal tdm_shift_wr_req		: std_logic_vector(tdm_wr_latency -1 downto 0);

signal next_tdm_rd_req		: std_logic;
signal tdm_rd_serv_req		: std_logic;
signal tdm_rd_serv_req_stb	: std_logic;
signal tdm_rd_serv_ack		: std_logic;
signal tdm_rd_data_ack		: std_logic;

signal tdm_shift_req	: std_logic_vector(tdm_rd_latency -1 downto 0);
signal tdm_shift_a0		: std_logic_vector(tdm_rd_latency -1 downto 0);
signal tdm_shift_a1		: std_logic_vector(tdm_rd_latency -1 downto 0);
signal tdm_shift_a2		: std_logic_vector(tdm_rd_latency -1 downto 0);
signal tdm_shift_a3		: std_logic_vector(tdm_rd_latency -1 downto 0);


--
-- RAM Signals
--
signal ram_a_data_reg	: std_logic_vector(ram_a_data_width -1 downto 0);
signal ram_a_addr_reg	: std_logic_vector(ram_a_addr_width -1 downto 0);
signal ram_a_byen_reg	: std_logic_vector(ram_a_byen_width -1 downto 0);
signal ram_a_wren_reg	: std_logic;

type ram_a_port_type is
record
	ram_a_data		: std_logic_vector(ram_a_data_width -1 downto 0);
	ram_a_addr		: std_logic_vector(ram_a_addr_width -1 downto 0);
	ram_a_byen		: std_logic_vector(ram_a_byen_width -1 downto 0);
	ram_a_wren		: std_logic;
end record;

signal ram_a_port	: ram_a_port_type;

signal ram_b_data_reg		: std_logic_vector(ram_b_data_width -1 downto 0);
signal ram_b_addr_reg		: std_logic_vector(ram_b_addr_width -1 downto 0);
signal ram_b_addr_ext_reg	: std_logic_vector(3 downto 0);
signal ram_b_addr_reg_ena	: std_logic;

type ram_b_port_type is
record
	ram_b_data		: std_logic_vector(ram_b_data_width -1 downto 0);
	ram_b_addr		: std_logic_vector(ram_b_addr_width -1 downto 0);
end record;

signal ram_b_port	: ram_b_port_type;


begin

--------------------------------------------------------------------------------
--
--  Assign values to records
--
	fifo_wr_port.wr_clk				<= wr_clk;
	fifo_wr_port.wr_data			<= wr_data;
	fifo_wr_port.wr_en				<= wr_en;
	fifo_wr_port.wr_ff				<= wr_ff_reg;
	fifo_wr_port.wr_ef				<= wr_ef_reg;
	fifo_wr_port.wr_level			<= wr_level_reg;

	fifo_wr_port_reg.wr_data_reg	<= wr_data_reg;
	fifo_wr_port_reg.wr_en_reg		<= wr_en_reg;

	fifo_wr_clks.wr_clk_reg_t0		<= wr_clk_reg_t0;
	fifo_wr_clks.wr_clk_reg_t1		<= wr_clk_reg_t1;
	fifo_wr_clks.wr_clk_ped_t0		<= wr_clk_ped_t0;
	fifo_wr_clks.wr_clk_ped_t1		<= wr_clk_ped_t1;
	fifo_wr_clks.wr_en_req_t0		<= wr_en_req_t0;

	fifo_wr_pipe.wr_preg_sh			<= wr_preg_sh;
	fifo_wr_pipe.wr_preg_ld			<= wr_preg_ld;
	fifo_wr_pipe.wr_preg_dv0		<= wr_preg_dv0;
	fifo_wr_pipe.wr_preg_dv1		<= wr_preg_dv1;
	fifo_wr_pipe.wr_preg_d0			<= wr_preg_d0;
	fifo_wr_pipe.wr_preg_d1			<= wr_preg_d1;
	fifo_wr_pipe.wr_preg_dx_in		<= wr_preg_dx_in;

	fifo_rd_port.rd_clk				<= rd_clk;
	fifo_rd_port.rd_data			<= rd_data_reg;
	fifo_rd_port.rd_en				<= rd_en;
	fifo_rd_port.rd_ff				<= rd_ff_reg;
	fifo_rd_port.rd_ef				<= rd_ef_reg;
	fifo_rd_port.rd_level			<= rd_level_reg;
	fifo_rd_port.rd_dv				<= rd_dv_reg;

	fifo_rd_port_reg.rd_data_reg	<= rd_data_reg;
	fifo_rd_port_reg.rd_en_reg		<= rd_en_reg;

	fifo_rd_clks.rd_clk_reg_t0		<= rd_clk_reg_t0;
	fifo_rd_clks.rd_clk_reg_t1		<= rd_clk_reg_t1;
	fifo_rd_clks.rd_clk_ped_t0		<= rd_clk_ped_t0;
	fifo_rd_clks.rd_clk_ped_t1		<= rd_clk_ped_t1;
	fifo_rd_clks.rd_en_req_t0		<= rd_en_req_t0;

	fifo_rd_pipe.rd_preg_sh			<= rd_preg_sh;
	fifo_rd_pipe.rd_preg_ld			<= rd_preg_ld;
	fifo_rd_pipe.rd_preg_dv0		<= rd_preg_dv0;
	fifo_rd_pipe.rd_preg_dv1		<= rd_preg_dv1;
	fifo_rd_pipe.rd_preg_dv2		<= rd_preg_dv2;
	fifo_rd_pipe.rd_preg_dv3		<= rd_preg_dv3;
	fifo_rd_pipe.rd_preg_d0			<= rd_preg_d0;
	fifo_rd_pipe.rd_preg_d1			<= rd_preg_d1;
	fifo_rd_pipe.rd_preg_d2			<= rd_preg_d2;
	fifo_rd_pipe.rd_preg_d3			<= rd_preg_d3;
	fifo_rd_pipe.rd_preg_dx_in		<= rd_preg_dx_in;

	ram_a_port.ram_a_data		<= ram_a_data_reg;
	ram_a_port.ram_a_addr		<= ram_a_addr_reg;
	ram_a_port.ram_a_byen		<= ram_a_byen_reg;
	ram_a_port.ram_a_wren		<= ram_a_wren_reg;

	ram_b_port.ram_b_data		<= ram_b_data;
	ram_b_port.ram_b_addr		<= ram_b_addr_reg;


--------------------------------------------------------------------------------
--
tdm_wr_side: if (wr_port_type = 1) generate
--
--------------------------------------------------------------------------------

--
--  Sample the inputs in the wr port clock domain
--

-- 2x synchronous mode
wr_sync_2: if (wr_clk_is_sync = 2) generate

	process(wr_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_en_reg <= '0';
			wr_data_reg <= (others => '0');
		elsif wr_clk'event and wr_clk = '1' then
			wr_en_reg <= wr_en;
			wr_data_reg <= wr_data;
		end if;
	end process;

end generate wr_sync_2;

-- 3x sync or async mode
wr_async: if (wr_clk_is_sync /= 2) generate

	process(wr_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_en_reg <= '0';
			wr_data_reg <= (others => '0');
		elsif wr_clk'event and wr_clk = '1' then
			wr_en_reg <= wr_en;
			wr_data_reg <= wr_data;
		end if;
	end process;

end generate wr_async;


--------------------------------------------------------------------------------
--
--  Generate flag signals and output synchronous to the wr port clock domain
--
	wr_ef <= wr_ef_reg;
	wr_ff <= wr_ff_reg;
	wr_level <= wr_level_reg;

	process(wr_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_ef_reg <= '1';
			wr_ff_reg <= '0';
			wr_level_reg <= (others => '0');
		elsif wr_clk'event and wr_clk = '1' then
			wr_ef_reg <= next_wr_ef;
			wr_ff_reg <= next_wr_ff;
			wr_level_reg <= next_wr_level;
		end if;
	end process;


--------------------------------------------------------------------------------
--
--  Detect the rising edge of the wr port clock
--
	wr_clk_ped_t0 <= wr_clk_reg_t0 AND NOT(wr_clk_reg_t1);
	wr_en_req_t0 <= wr_clk_ped_t0 AND wr_en_reg;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_clk_reg_t0 <= '1';
			wr_clk_reg_t1 <= '1';
			wr_clk_ped_t1 <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			wr_clk_reg_t0 <= wr_clk;
			wr_clk_reg_t1 <= wr_clk_reg_t0;
			wr_clk_ped_t1 <= wr_clk_ped_t0;
		end if;
	end process;


--------------------------------------------------------------------------------
--
-- Standard approach to flag generation, creates some long critical paths
--
wr_flags_std: if NOT(FASTER_WR_FLAGS) generate
begin

-- 2x synchronous mode
--
-- The current synchronized write level (+1 if wr_en is valid) is output to the
-- wr port as the current level on the rising port clock.  Any rd port activity that
-- has not propagated back and been synchronized will be picked up on the next
-- port clock cycle.
--
wr_sync_2: if (wr_clk_is_sync = 2) generate
begin

	next_wr_level <=
		(tdm_stable_wr_level +2) when ((wr_en = '1') AND (wr_en_reg = '1')) else
		(tdm_stable_wr_level +1) when ((wr_en = '1') AND (wr_en_reg = '0')) else
		(tdm_stable_wr_level +1) when ((wr_en = '0') AND (wr_en_reg = '1')) else
		(tdm_stable_wr_level);

end generate wr_sync_2;

-- 3x sync or async mode
--
-- The current synchronized write level (+1 if wr_en is valid) is output to the
-- wr port as the current level on the rising port clock.  Any rd port activity that
-- has not propagated back and been synchronized will be picked up on the next
-- port clock cycle.
--
wr_async: if (wr_clk_is_sync /= 2) generate
begin

	next_wr_level <=
		(tdm_stable_wr_level +1) when (wr_en = '1') else (tdm_stable_wr_level);
	
end generate wr_async;

	next_wr_ef <= '1' when
		(next_wr_level(next_wr_level'high) = '0') AND
		(next_wr_level(next_wr_level'high -1 downto 0) =
		 conv_std_logic_vector(16#0000#, next_wr_level'length -1)) else '0';

	next_wr_ff <= '1' when
		(next_wr_level(next_wr_level'high) = '1') AND
		(next_wr_level(next_wr_level'high -1 downto 0) =
		 conv_std_logic_vector(16#0000#, next_wr_level'length -1)) else '0';

--
-- create a stable level value (i.e. long enough to guarantee setup times
-- for wr_level_reg) by only updating tdm_wr_level in the clock cycle
-- following a port clock rising edge s.t. at least one tdm clock cycle
-- of settling time are provided.
--
-- ??? change to wr_clk_ped_t0 for 2x synchronous clock modes 
-- !!! this does not work for 2x synchronous mode, need a better solution
--
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_stable_wr_level <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			if (wr_clk_ped_t1 = '1') then
				tdm_stable_wr_level <= tdm_wr_level;
			end if;
		end if;
	end process;

end generate wr_flags_std;


--
-- !!! improved flag performance, two bits are stripped off for future
-- !!! inclusion of a last_wr_en signal in the 2x synchronous mode
--
wr_flags_opt: if (FASTER_WR_FLAGS) generate
begin

-- use a less accurate transient level indication
	next_wr_level <= tdm_stable_wr_level;
	
-- 2x synchronous mode
wr_sync_2: if (wr_clk_is_sync = 2) generate

-- check empty condition
	next_wr_ef <= '1' when (
		(tdm_stable_wr_level_zero = '1') AND (tdm_stable_wr_level_full = '0') AND
		(wr_en_reg = '0') AND (wr_en = '0')
		) else '0';

-- check full condition
	next_wr_ff <= '1' when (
		((tdm_stable_wr_level_zero = '1') AND (tdm_stable_wr_level_full = '1')) OR
		((tdm_stable_wr_level_near_full = '1') AND ((wr_en_reg = '1') OR (wr_en = '1')))
		) else '0';

end generate wr_sync_2;

-- 3x sync or async mode
wr_async: if (wr_clk_is_sync /= 2) generate
begin

-- check empty condition
	next_wr_ef <= '1' when (
		(tdm_stable_wr_level_zero = '1') AND (tdm_stable_wr_level_full = '0') AND
		(wr_en = '0')
		) else '0';

-- check full condition
	next_wr_ff <= '1' when (
		((tdm_stable_wr_level_zero = '1') AND (tdm_stable_wr_level_full = '1')) OR
		((tdm_stable_wr_level_near_full = '1') AND (wr_en = '1'))
		) else '0';

end generate wr_async;

	tdm_stable_wr_level_zero <= '1' when
		(tdm_stable_wr_level(tdm_stable_wr_level'high downto 0) = 
		 conv_std_logic_vector(16#0000#, tdm_stable_wr_level'length)) else '0';

	tdm_stable_wr_level_near_full <= '1' when
		(tdm_stable_wr_level(tdm_stable_wr_level'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, tdm_stable_wr_level'length -1)) else '0';

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_stable_wr_level <= (others => '0');
--			tdm_stable_wr_level_zero <= '0';
			tdm_stable_wr_level_full <= '0';
--			tdm_stable_wr_level_near_full <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			if (wr_clk_ped_t1 = '1') then
				tdm_stable_wr_level <= tdm_wr_level;
--				tdm_stable_wr_level_zero <= tdm_wr_level_zero;
				tdm_stable_wr_level_full <= tdm_wr_level_full;
--				tdm_stable_wr_level_near_full <= tdm_wr_level_near_full;
			end if;
		end if;
	end process;

end generate wr_flags_opt;


--------------------------------------------------------------------------------
--
--  wr pipeline data, control, and mux logic
--
--------------------------------------------------------------------------------

wr_preg_sh		<= (tdm_wr_serv_req = '1') AND (tdm_wr_serv_ack = '1');
wr_preg_ld		<= (wr_en_req_t0 = '1');
wr_preg_dx_in	<= wr_data_reg;

--
-- update register if shifting or loading and we are invalid
-- select data input based on whether the register above is valid
--
process(tdm_clk, reset)
begin
	if reset = c_async_reset_val then

		wr_preg_d0 <= (others => '0');
		wr_preg_d1 <= (others => '0');

	elsif tdm_clk'event and tdm_clk = '1' then

		if (wr_preg_sh OR (wr_preg_ld AND NOT(wr_preg_dv0))) then
			if (wr_preg_dv1) then
				wr_preg_d0 <= wr_preg_d1;
			else
				wr_preg_d0 <= wr_preg_dx_in;
			end if;
		end if;

		-- there is no pipelne register above so data is always be from data_in
		if (wr_preg_sh OR (wr_preg_ld AND NOT(wr_preg_dv1))) then
		end if;

	end if;
end process;


-- update dv register if shifting xor loading (if both dv state is unchaged)
--   if (write and register below is valid) or (read and register above is valid)
--   then we become valid, else we become invalid
process(tdm_clk, reset)
begin
	if reset = c_async_reset_val then

		wr_preg_dv0 <= FALSE;
		wr_preg_dv1 <= FALSE;

	elsif tdm_clk'event and tdm_clk = '1' then

		if (wr_preg_sh XOR wr_preg_ld) then

			-- the register below preg_d0 is assumed to be always valid when loading
			if ((TRUE        AND wr_preg_ld) OR (wr_preg_dv1 AND wr_preg_sh)) then
				wr_preg_dv0 <= TRUE;
			else
				wr_preg_dv0 <= FALSE;
			end if;

			-- the register above preg_d1 is assumed to always be invalid when shifting
			if ((wr_preg_dv0 AND wr_preg_ld) OR (FALSE       AND wr_preg_sh)) then
				wr_preg_dv1 <= TRUE;
			else
				wr_preg_dv1 <= FALSE;
			end if;

		end if;

	end if;
end process;

--------------------------------------------------------------------------------
--
end generate tdm_wr_side;
--
--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
--
com_wr_side: if (wr_port_type = 3) generate
--
--------------------------------------------------------------------------------

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_en_reg <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			wr_en_reg <= wr_en;
		end if;
	end process;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_preg_d0 <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			wr_preg_d0 <= wr_data;
		end if;
	end process;

	wr_en_req_t0 <= wr_en;

	tdm_wr_serv_ack <= wr_en_reg;
	tdm_wr_req <= '1' when (wr_en_reg = '1') else '0';
	tdm_wr_serv_req <= '1' when (wr_en_reg = '1') else '0';

--------------------------------------------------------------------------------
--
--  Generate flag signals and output synchronous to the wr port clock domain
--
	wr_ef <= wr_ef_reg;
	wr_ff <= wr_ff_reg;
	wr_level <= wr_level_reg;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_ef_reg <= '1';
			wr_ff_reg <= '0';
			wr_level_reg <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			wr_ef_reg <= next_wr_ef;
			wr_ff_reg <= next_wr_ff;
			wr_level_reg <= next_wr_level;
		end if;
	end process;

--
-- !!! improved flag performance, two bits are stripped off for future
-- !!! inclusion of a last_wr_en signal in the 2x synchronous mode
--
-- use a less accurate transient level indication
	next_wr_level <= tdm_stable_wr_level;

-- check empty condition
	next_wr_ef <= '1' when (
		(tdm_stable_wr_level_zero = '1') AND (tdm_stable_wr_level_full = '0') AND
		(wr_en_reg = '0') AND (wr_en = '0')
		) else '0';

-- check full condition
	next_wr_ff <= '1' when (
		((tdm_stable_wr_level_zero = '1') AND (tdm_stable_wr_level_full = '1')) OR
		((tdm_stable_wr_level_near_full = '1') AND ((wr_en_reg = '1') OR (wr_en = '1')))
		) else '0';

	tdm_stable_wr_level_zero <= '1' when
		(tdm_stable_wr_level(tdm_stable_wr_level'high downto 0) = 
		 conv_std_logic_vector(16#0000#, tdm_stable_wr_level'length)) else '0';

	tdm_stable_wr_level_near_full <= '1' when
		(tdm_stable_wr_level(tdm_stable_wr_level'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, tdm_stable_wr_level'length -1)) else '0';

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_stable_wr_level <= (others => '0');
			tdm_stable_wr_level_full <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_stable_wr_level <= tdm_wr_level;
			tdm_stable_wr_level_full <= tdm_wr_level_full;
		end if;
	end process;


--------------------------------------------------------------------------------
--
end generate com_wr_side;
--
--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
--
--  Write Service Controls.
--
--------------------------------------------------------------------------------
--
-- writes are initiated by the port wr_en signal.  When synchronized to the tdm
-- clock and sampled becomes tdm_wr_en_tx.  The tdm_wr_en_t0 signal is used to
-- write the port data into the wr data pipeline.  Requests for tdm write service
-- are intiated when data arrives in the preg_d0 register.  Thus, our write service
-- request is just the wr_preg_dv0 signal
--
-- write data is valid to the ram input mux when wr_preg_dv0 is true.  write address
-- and controls are valid from reset and update on tdm_wr_serv_ack.
--
--------------------------------------------------------------------------------
--
tdm_wr_side_2: if (wr_port_type = 1) generate
--
--------------------------------------------------------------------------------
	tdm_wr_serv_ack <= tdm_wr_ack;
	tdm_wr_req <= '1' when (wr_preg_dv0) else '0';

	tdm_wr_serv_req <= '1' when (wr_preg_dv0) else '0';
--------------------------------------------------------------------------------
--
end generate tdm_wr_side_2;
--
--------------------------------------------------------------------------------

--
--  track write request through the write pipeline to know when data is valid in ram
--
	tdm_wr_data_ack <= tdm_shift_wr_req(tdm_wr_latency -1);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_shift_wr_req <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_shift_wr_req(tdm_wr_latency -1 downto 1) <=
				tdm_shift_wr_req(tdm_wr_latency -2 downto 0);
			tdm_shift_wr_req(0) <= '0';

			if (tdm_wr_serv_ack = '1') then
				if (tdm_wr_serv_req = '1') then
					tdm_shift_wr_req(0) <= '1';
				end if;
			end if;
		end if;
	end process;


--------------------------------------------------------------------------------
--
--  Generate the ram a port signals.
--
	ram_a_data <= ram_a_data_reg;
	ram_a_addr <= ram_a_addr_reg;
	ram_a_byen <= ram_a_byen_reg;
	ram_a_wren <= ram_a_wren_reg;

	ram_a_wren_reg <=
		'1' when ((tdm_wr_serv_req = '1') AND (tdm_wr_serv_ack = '1')) else '0';


a_ratio1: if (ram_a_data_width / wr_data_width) = 1 generate

	ram_a_data_reg <=
		wr_preg_d0;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_a_addr_reg <=
				conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width);
			ram_a_byen_reg <=
				conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length);
		elsif tdm_clk'event and tdm_clk = '1' then
			if ((tdm_wr_serv_req = '1') AND (tdm_wr_serv_ack = '1')) then
				ram_a_addr_reg <=
					conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width) +
					wr_ram_addr(wr_addr_width -1 downto 0);
				ram_a_byen_reg <=
					conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length);
			end if;
		end if;
	end process;


end generate a_ratio1;


a_ratio2: if (ram_a_data_width / wr_data_width) = 2 generate

	ram_a_data_reg <=
		wr_preg_d0 & wr_preg_d0;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_a_addr_reg <=
				conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width);
			ram_a_byen_reg <=
				conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/2) &
				conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length/2);
		elsif tdm_clk'event and tdm_clk = '1' then
			if ((tdm_wr_serv_req = '1') AND (tdm_wr_serv_ack = '1')) then

				ram_a_addr_reg <=
					conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width) +
					wr_ram_addr(wr_addr_width -1 downto 1);

				if (wr_ram_addr(0) = '0') then
					ram_a_byen_reg <=
						conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/2) &
						conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length/2);
				else
					ram_a_byen_reg <=
						conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length/2) &
						conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/2);
				end if;

			end if;
		end if;
	end process;

end generate a_ratio2;


a_ratio4: if (ram_a_data_width / wr_data_width) = 4 generate
	ram_a_data_reg <=
		wr_preg_d0 & wr_preg_d0 & wr_preg_d0 & wr_preg_d0;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_a_addr_reg <=
				conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width);
			ram_a_byen_reg <=
				conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
				conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
				conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
				conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length/4);
		elsif tdm_clk'event and tdm_clk = '1' then
			if ((tdm_wr_serv_req = '1') AND (tdm_wr_serv_ack = '1')) then

				ram_a_addr_reg <=
					conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width) +
					wr_ram_addr(wr_addr_width -1 downto 2);
				wr_ram_addr_1 <= wr_ram_addr(1 downto 0);

				case wr_ram_addr_1 is
					when "00" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length/4);
					when "01" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4);
					when "10" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4);
					when "11" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#FFFF#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4) &
							conv_std_logic_vector(16#0000#, ram_a_byen_reg'length/4);
					when others =>
						ram_a_byen_reg <= (others => '-');
				end case;

			end if;
		end if;
	end process;

end generate a_ratio4;


a_ratio8: if (ram_a_data_width / wr_data_width) = 8 generate

	ram_a_data_reg <=
		wr_preg_d0 & wr_preg_d0 & wr_preg_d0 & wr_preg_d0 &
		wr_preg_d0 & wr_preg_d0 & wr_preg_d0 & wr_preg_d0;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_a_addr_reg <=
				conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width);
			ram_a_byen_reg <=
				conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 7)/8)) &
				conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 1)/8));
		elsif tdm_clk'event and tdm_clk = '1' then
			if ((tdm_wr_serv_req = '1') AND (tdm_wr_serv_ack = '1')) then

				ram_a_addr_reg <=
					conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width) +
					wr_ram_addr(wr_addr_width -1 downto 3);

				wr_ram_addr_2 <= wr_ram_addr(2 downto 0);
				case wr_ram_addr_2 is
					when "000" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 7)/8)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 1)/8));
					when "001" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 6)/8)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 1)/8)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 1)/8));
					when "010" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 5)/8)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 1)/8)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 2)/8));
					when "011" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 4)/8)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 1)/8)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 3)/8));
					when "100" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 3)/8)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 1)/8)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 4)/8));
					when "101" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 2)/8)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 1)/8)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 5)/8));
					when "110" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 1)/8)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 1)/8)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 6)/8));
					when "111" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 1)/8)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length * 7)/8));
					when others =>
						ram_a_byen_reg <= (others => '-');
				end case;

			end if;
		end if;
	end process;

end generate a_ratio8;


a_ratio16: if (ram_a_data_width / wr_data_width) = 16 generate

	ram_a_data_reg <=
		wr_preg_d0 & wr_preg_d0 & wr_preg_d0 & wr_preg_d0 &
		wr_preg_d0 & wr_preg_d0 & wr_preg_d0 & wr_preg_d0 &
		wr_preg_d0 & wr_preg_d0 & wr_preg_d0 & wr_preg_d0 &
		wr_preg_d0 & wr_preg_d0 & wr_preg_d0 & wr_preg_d0;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_a_addr_reg <=
				conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width);
			ram_a_byen_reg <=
				conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 15)/16)) &
				conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16));
		elsif tdm_clk'event and tdm_clk = '1' then
			if ((tdm_wr_serv_req = '1') AND (tdm_wr_serv_ack = '1')) then

				ram_a_addr_reg <=
					conv_std_logic_vector(ram_a_addr_offset, ram_a_addr_width) +
					wr_ram_addr(wr_addr_width -1 downto 4);

				wr_ram_addr_3 <= wr_ram_addr(3 downto 0);
				case wr_ram_addr_3 is
					when "0000" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 15)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16));
					when "0001" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 14)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  1)/16));
					when "0010" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 13)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  2)/16));
					when "0011" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 12)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  3)/16));
					when "0100" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 11)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  4)/16));
					when "0101" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 10)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  5)/16));
					when "0110" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  9)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  6)/16));
					when "0111" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  8)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  7)/16));
					when "1000" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  7)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  8)/16));
					when "1001" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  6)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  9)/16));
					when "1010" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  5)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 10)/16));
					when "1011" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  4)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 11)/16));
					when "1100" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  3)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 12)/16));
					when "1101" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  2)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 13)/16));
					when "1110" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 14)/16));
					when "1111" =>
						ram_a_byen_reg <=
							conv_std_logic_vector(16#FFFF#, ((ram_a_byen_reg'length *  1)/16)) &
							conv_std_logic_vector(16#0000#, ((ram_a_byen_reg'length * 15)/16));
					when others =>
						ram_a_byen_reg <= (others => '-');
				end case;

			end if;
		end if;
	end process;

end generate a_ratio16;


--------------------------------------------------------------------------------
--
--  Generate vport level value and information for flag construction.
--
-- The difference between the wr_addr and rd_addr counters indicates the
-- the amount of data in the fifo.  A level value of 0 has two interpretations
-- either empty (when the msbs of the counters are equal) or full (when the
-- msbs of the counters are not equal).
--

	tdm_wr_level <= wr_level_diff;
	tdm_wr_level_zero <= '1' when (wr_level_zero) else '0';
	tdm_wr_level_full <= '1' when (wr_level_full) else '0';
	tdm_wr_level_near_full <= '1' when (wr_level_near_full) else '0';

	tdm_rd_level <= rd_level_diff;
	tdm_rd_level_zero <= '1' when (rd_level_zero) else '0';
	tdm_rd_level_full <= '1' when (rd_level_full) else '0';


wr_ratio1: if (wr_data_width / rd_data_width) = 1 generate
--wr_ratio1: if (wr_data_width = rd_data_width) generate
begin
	wr_level_diff <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) -
		 rd_port_addr(rd_port_addr'high -1 downto 0));
	wr_level_full <=
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');
	wr_level_zero <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) =
		 rd_port_addr(rd_port_addr'high -1 downto 0));
	wr_level_near_full <=
		(wr_level_diff(wr_level_diff'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, wr_level_diff'length -2));

	rd_level_diff <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) -
		 rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_full <=
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');
	rd_level_zero <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) =
		 rd_port_addr(rd_port_addr'high -1 downto 0));

	rd_cntl_diff <=
		(wr_val_addr(wr_val_addr'high -1 downto 0) -
		 rd_cur_addr(rd_cur_addr'high -1 downto 0));
	rd_data_avail <=
		(wr_val_addr(wr_val_addr'high downto 0) /=
		 rd_cur_addr(rd_cur_addr'high downto 0));
end generate wr_ratio1;


wr_ratio2: if (wr_data_width / rd_data_width) = 2 generate
begin
-- !!! below could better share resources and provide
-- !!! non-zero indication on port with wider width when
-- !!! an address is partially full even though level = 0
--	wr_level <= fifo_level(fifo_level'high downto 1);
--	rd_level <= fifo_level;
--
--	fifo_level <=
--		((wr_port_addr(wr_port_addr'high -1 downto 0) & '0') -
--		  rd_port_addr(rd_port_addr'high -1 downto 0));
--	fifo_level_zero <=
--		((wr_port_addr(wr_port_addr'high -1 downto 0) & '0') =
--		  rd_port_addr(rd_port_addr'high -1 downto 0));
--	fifo_level_full <=
--		(wr_port_addr(wr_port_addr'high) = '1') XOR
--		(rd_port_addr(rd_port_addr'high) = '1');

	wr_level_diff <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) - 
		 rd_port_addr(rd_port_addr'high -1 downto 1));
	wr_level_zero <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) =
		 rd_port_addr(rd_port_addr'high -1 downto 1));
	wr_level_full <= 
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');
	wr_level_near_full <=
		(wr_level_diff(wr_level_diff'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, wr_level_diff'length -1));

	rd_level_diff <=
		((wr_port_addr(wr_port_addr'high -1 downto 0) & '0') -
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_zero <=
		((wr_port_addr(wr_port_addr'high -1 downto 0) & '0') =
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_full <=
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');

	rd_cntl_diff <=
		((wr_val_addr(wr_val_addr'high -1 downto 0) & '0') -
		  rd_cur_addr(rd_cur_addr'high -1 downto 0));
	rd_data_avail <=
		((wr_val_addr(wr_val_addr'high -1 downto 0) & '0') /=
		  rd_cur_addr(rd_cur_addr'high -1 downto 0));
end generate wr_ratio2;

wr_ratio4: if (wr_data_width / rd_data_width) = 4 generate
	wr_level_diff <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) - 
		 rd_port_addr(rd_port_addr'high -1 downto 2));
	wr_level_zero <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) =
		 rd_port_addr(rd_port_addr'high -1 downto 2));
	wr_level_full <= 
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');
	wr_level_near_full <=
		(wr_level_diff(wr_level_diff'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, wr_level_diff'length -1));

	rd_level_diff <=
		((wr_port_addr(wr_port_addr'high -1 downto 0) & "00") -
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_zero <=
		((wr_port_addr(wr_port_addr'high -1 downto 0) & "00") =
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_full <=
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');

	rd_cntl_diff <=
		((wr_val_addr(wr_val_addr'high -1 downto 0) & "00") -
		  rd_cur_addr(rd_cur_addr'high -1 downto 0));
	rd_data_avail <=
		((wr_val_addr(wr_val_addr'high -1 downto 0) & "00") /=
		  rd_cur_addr(rd_cur_addr'high -1 downto 0));
end generate wr_ratio4;

wr_ratio8: if (wr_data_width / rd_data_width) = 8 generate
	wr_level_diff <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) - 
		 rd_port_addr(rd_port_addr'high -1 downto 3));
	wr_level_zero <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) =
		 rd_port_addr(rd_port_addr'high -1 downto 3));
	wr_level_full <= 
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');
	wr_level_near_full <=
		(wr_level_diff(wr_level_diff'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, wr_level_diff'length -1));

	rd_level_diff <=
		((wr_port_addr(wr_port_addr'high -1 downto 0) & "000") -
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_zero <=
		((wr_port_addr(wr_port_addr'high -1 downto 0) & "000") =
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_full <=
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');

	rd_cntl_diff <=
		((wr_val_addr(wr_val_addr'high -1 downto 0) & "000") -
		  rd_cur_addr(rd_cur_addr'high -1 downto 0));
	rd_data_avail <=
		((wr_val_addr(wr_val_addr'high -1 downto 0) & "000") /=
		  rd_cur_addr(rd_cur_addr'high -1 downto 0));
end generate wr_ratio8;


rw_ratio2: if (rd_data_width / wr_data_width) = 2 generate
-- !!! below could better share resources and provide
-- !!! non-zero indication on port with wider width when
-- !!! an address is partially full even though level = 0
--	wr_level <= fifo_level;
--	rd_level <= fifo_level(fifo_level'high downto 1);
--
--	fifo_level <=
--		(wr_port_addr(wr_port_addr'high -1 downto 0) - 
--		 rd_port_addr(rd_port_addr'high -1 downto 0) & '0');
--	fifo_level_zero <=
--		(wr_port_addr(wr_port_addr'high -1 downto 0) =
--		 rd_port_addr(rd_port_addr'high -1 downto 0) & '0');
--	fifo_level_full <= 
--		(wr_port_addr(wr_port_addr'high) = '1') XOR
--		(rd_port_addr(rd_port_addr'high) = '1');

	wr_level_diff <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) - 
		 (rd_port_addr(rd_port_addr'high -1 downto 0) & '0'));
	wr_level_zero <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) =
		 (rd_port_addr(rd_port_addr'high -1 downto 0) & '0'));
	wr_level_full <= 
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');
	wr_level_near_full <=
		(wr_level_diff(wr_level_diff'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, wr_level_diff'length -1));

	rd_level_diff <=
		((wr_port_addr(wr_port_addr'high -1 downto 1)) -
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_zero <=
		((wr_port_addr(wr_port_addr'high -1 downto 1)) =
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_full <=
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');

	rd_cntl_diff <=
		(wr_val_addr(wr_val_addr'high -1 downto 1) -
		 rd_cur_addr(rd_cur_addr'high -1 downto 0));
	rd_data_avail <=
		(wr_val_addr(wr_val_addr'high downto 1) /=
		 rd_cur_addr(rd_cur_addr'high downto 0));
end generate rw_ratio2;

rw_ratio4: if (rd_data_width / wr_data_width) = 4 generate
	wr_level_diff <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) - 
		 (rd_port_addr(rd_port_addr'high -1 downto 0) & "00"));
	wr_level_zero <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) =
		 (rd_port_addr(rd_port_addr'high -1 downto 0) & "00"));
	wr_level_full <= 
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');
	wr_level_near_full <=
		(wr_level_diff(wr_level_diff'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, wr_level_diff'length -1));

	rd_level_diff <=
		((wr_port_addr(wr_port_addr'high -1 downto 2)) -
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_zero <=
		((wr_port_addr(wr_port_addr'high -1 downto 2)) =
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_full <=
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');

	rd_cntl_diff <=
		(wr_val_addr(wr_val_addr'high -1 downto 2) -
		 rd_cur_addr(rd_cur_addr'high -1 downto 0));
	rd_data_avail <=
		(wr_val_addr(wr_val_addr'high downto 2) /=
		 rd_cur_addr(rd_cur_addr'high downto 0));
end generate rw_ratio4;

rw_ratio8: if (rd_data_width / wr_data_width) = 8 generate
	wr_level_diff <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) - 
		 (rd_port_addr(rd_port_addr'high -1 downto 0) & "000"));
	wr_level_zero <=
		(wr_port_addr(wr_port_addr'high -1 downto 0) =
		 (rd_port_addr(rd_port_addr'high -1 downto 0) & "000"));
	wr_level_full <= 
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');
	wr_level_near_full <=
		(wr_level_diff(wr_level_diff'high downto 1) =
		 conv_std_logic_vector(16#FFFF#, wr_level_diff'length -1));

	rd_level_diff <=
		((wr_port_addr(wr_port_addr'high -1 downto 3)) -
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_zero <=
		((wr_port_addr(wr_port_addr'high -1 downto 3)) =
		  rd_port_addr(rd_port_addr'high -1 downto 0));
	rd_level_full <=
		(wr_port_addr(wr_port_addr'high) = '1') XOR
		(rd_port_addr(rd_port_addr'high) = '1');

	rd_cntl_diff <=
		(wr_val_addr(wr_val_addr'high -1 downto 3) -
		 rd_cur_addr(rd_cur_addr'high -1 downto 0));
	rd_data_avail <=
		(wr_val_addr(wr_val_addr'high downto 3) /=
		 rd_cur_addr(rd_cur_addr'high downto 0));
end generate rw_ratio8;


--------------------------------------------------------------------------------
--
--  FIFO write address generation.
--
	wr_ram_addr <= wr_cur_addr(wr_addr_width -1 downto 0);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_port_addr <= (others => '0');
			wr_cur_addr <= conv_std_logic_vector(1, wr_cur_addr'length);
			wr_val_addr <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			if (wr_en_req_t0 = '1') then
				wr_port_addr <= wr_port_addr +1;
			end if;
			if ((tdm_wr_serv_req = '1') AND (tdm_wr_serv_ack = '1')) then
				wr_cur_addr <= wr_cur_addr +1;
			end if;
			if (tdm_wr_data_ack = '1') then
				wr_val_addr <= wr_val_addr +1;
			end if;
		end if;
	end process;

--------------------------------------------------------------------------------
--
--  FIFO read address generation.
--
	rd_ram_addr <= rd_cur_addr(rd_addr_width -1 downto 0);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_port_addr <= (others => '0');
			rd_cur_addr <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			if (rd_en_req_t0 = '1') then
				rd_port_addr <= rd_port_addr +1;
			end if;
			if (tdm_rd_serv_req_stb = '1') then
				rd_cur_addr <= rd_cur_addr +1;
			end if;
		end if;
	end process;


--------------------------------------------------------------------------------
--
tdm_rd_side: if (rd_port_type = 1) generate
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--  Detect the rising edge of the rd port clock
--

	rd_clk_ped_t0 <= rd_clk_reg_t0 AND NOT(rd_clk_reg_t1);
	rd_en_req_t0 <= rd_clk_ped_t0 AND rd_en_reg;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_clk_reg_t0 <= '1';
			rd_clk_reg_t1 <= '1';
			rd_clk_ped_t1 <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			rd_clk_reg_t0 <= rd_clk;
			rd_clk_reg_t1 <= rd_clk_reg_t0;
			rd_clk_ped_t1 <= rd_clk_ped_t0;
		end if;
	end process;


--------------------------------------------------------------------------------
--
--  Sample rd inputs in the rd port clock domain
--
rd_sync_2: if (rd_clk_is_sync = 2) generate

	process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_en_reg <= '0';
		elsif rd_clk'event and rd_clk = '1' then
			rd_en_reg <= rd_en;
		end if;
	end process;

end generate rd_sync_2;

rd_async: if (rd_clk_is_sync /= 2) generate

	process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_en_reg <= '0';
		elsif rd_clk'event and rd_clk = '1' then
			rd_en_reg <= rd_en;
		end if;
	end process;

end generate rd_async;


--------------------------------------------------------------------------------
--
--  Synchronize rd outputs to the rd port clock domain
--
rd_en_is_ack: if (rd_lookahead = 1) generate
begin
	rd_data <= rd_preg_d0;
end generate rd_en_is_ack;

rd_en_is_req: if (rd_lookahead /= 1) generate
begin
	rd_data <= rd_data_reg;

	process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_data_reg <= (others => '0');
		elsif rd_clk'event and rd_clk = '1' then
			if (rd_en = '1') then
				rd_data_reg <= rd_preg_d0;
			end if;
		end if;
	end process;
end generate rd_en_is_req;


	rd_ef <= rd_ef_reg;
	rd_ff <= rd_ff_reg;
	rd_level <= rd_level_reg;
	rd_dv <= rd_dv_reg;

	rd_dv_reg <= '0';

	process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_ef_reg <= '1';
			rd_ff_reg <= '0';
			rd_level_reg <= (others => '0');
		elsif rd_clk'event and rd_clk = '1' then
			rd_ef_reg <= next_rd_ef;
			rd_ff_reg <= next_rd_ff;
			rd_level_reg <= next_rd_level;
		end if;
	end process;


--------------------------------------------------------------------------------
--
-- Standard approach to flag generation, creates some long critical paths
--
rd_flags_std: if NOT(FASTER_RD_FLAGS) generate
begin
--
--  The current synchronized read level (-1 if rd_en is valid) is output to the
--  rd port as the current level on the rising port clock.  Any wr port activity that
--  has not propagated to the ram and been synchronized will be picked up on the next
--  port clock cycle.
--

-- prepare the next read level
	next_rd_level <= (tdm_stable_rd_level -1) when (rd_en = '1') else (tdm_stable_rd_level);

-- check for empty condition
	next_rd_ef <= '1' when
		( (next_rd_level(next_rd_level'high) = '0') AND
		  (next_rd_level(next_rd_level'high -1 downto 0) = conv_std_logic_vector(16#0000#, next_rd_level'length -1)) ) OR
		( NOT(rd_preg_dv0) ) OR
		( NOT(rd_preg_dv1) AND (rd_en = '1') ) else '0';

-- check for full condition
	next_rd_ff <= '1' when
		( (next_rd_level(next_rd_level'high) = '1') AND
		  (next_rd_level(next_rd_level'high -1 downto 0) = conv_std_logic_vector(16#0000#, next_rd_level'length -1)) ) else '0';

-- tdm_rd_level reflects the updated level including the last request by the t1 cycle
-- hold this value for use in the next port clock cycle.
--
-- ??? change to rd_clk_ped_t0 for synchronous clock modes 
--
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_stable_rd_level <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			if (rd_clk_ped_t1 = '1') then
				tdm_stable_rd_level <= tdm_rd_level;
			end if;
		end if;
	end process;

end generate rd_flags_std;

--
-- !!! simplified flag generate to enhance performance
--
rd_flags_opt: if (FASTER_RD_FLAGS) generate
begin

-- prepare the next read level, not reflective of current rd activity
	next_rd_level <= tdm_stable_rd_level;

-- check for empty condition
	next_rd_ef <= '1' when
		( NOT(rd_preg_dv0) ) OR
		( NOT(rd_preg_dv1) AND (rd_en = '1') ) else '0';

-- check for full condition
	next_rd_ff <= '1' when
		(tdm_stable_rd_level_full = '1') AND (tdm_stable_rd_level_zero = '1') else '0';

-- tdm_rd_level reflects the updated level including the last request by the t1 cycle
-- hold this value for use in the next port clock cycle.
--
-- ??? change to rd_clk_ped_t0 for synchronous clock modes 
--
	tdm_stable_rd_level_zero <= '1' when
		(tdm_stable_rd_level(tdm_stable_rd_level'high downto 0) =
		 conv_std_logic_vector(16#0000#, tdm_stable_rd_level'length)) else '0';

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_stable_rd_level <= (others => '0');
			tdm_stable_rd_level_full <= '0';
--			tdm_stable_rd_level_zero <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			if (rd_clk_ped_t1 = '1') then
				tdm_stable_rd_level <= tdm_rd_level;
				tdm_stable_rd_level_full <= tdm_rd_level_full;
--				tdm_stable_rd_level_zero <= tdm_rd_level_zero;
			end if;
		end if;
	end process;

end generate rd_flags_opt;


--------------------------------------------------------------------------------
--
--  rd pipeline data, control, and mux logic
--
--------------------------------------------------------------------------------

rd_preg_sh		<= (rd_en_req_t0 = '1');
rd_preg_ld		<= (tdm_rd_data_ack = '1');
rd_preg_dx_in	<= ram_b_mux_d0;

--
-- update register if shifting or loading and we are invalid
-- select data input based on whether the register above is valid
--
process(tdm_clk, reset)
begin
	if reset = c_async_reset_val then

		rd_preg_d0 <= (others => '0');
		rd_preg_d1 <= (others => '0');
		rd_preg_d2 <= (others => '0');
		rd_preg_d3 <= (others => '0');

	elsif tdm_clk'event and tdm_clk = '1' then

		if (rd_preg_sh OR (rd_preg_ld AND NOT(rd_preg_dv0))) then
			if (rd_preg_dv1) then
				rd_preg_d0 <= rd_preg_d1;
			else
				rd_preg_d0 <= rd_preg_dx_in;
			end if;
		end if;

		if (rd_preg_sh OR (rd_preg_ld AND NOT(rd_preg_dv1))) then
			if (rd_preg_dv2) then
				rd_preg_d1 <= rd_preg_d2;
			else
				rd_preg_d1 <= rd_preg_dx_in;
			end if;
		end if;

		if (rd_preg_sh OR (rd_preg_ld AND NOT(rd_preg_dv2))) then
			if (rd_preg_dv3) then
				rd_preg_d2 <= rd_preg_d3;
			else
				rd_preg_d2 <= rd_preg_dx_in;
			end if;
		end if;

		-- there is no pipelne register above so data must always be from data_in
		if (rd_preg_sh OR (rd_preg_ld AND NOT(rd_preg_dv3))) then
			rd_preg_d3 <= rd_preg_dx_in;
		end if;

	end if;
end process;


-- update dv register if shifting xor loading (if both dv state is unchaged)
--   if (write and register below is valid) or (read and register above is valid)
--   then we become valid, else we become invalid
process(tdm_clk, reset)
begin
	if reset = c_async_reset_val then

		rd_preg_dv0 <= FALSE;
		rd_preg_dv1 <= FALSE;
		rd_preg_dv2 <= FALSE;
		rd_preg_dv3 <= FALSE;

	elsif tdm_clk'event and tdm_clk = '1' then

		if (rd_preg_sh XOR rd_preg_ld) then

			-- the register below preg0 is assumed to be always valid when loading
			if ((TRUE        AND rd_preg_ld) OR (rd_preg_dv1 AND rd_preg_sh)) then
				rd_preg_dv0 <= TRUE;
			else
				rd_preg_dv0 <= FALSE;
			end if;

			if ((rd_preg_dv0 AND rd_preg_ld) OR (rd_preg_dv2 AND rd_preg_sh)) then
				rd_preg_dv1 <= TRUE;
			else
				rd_preg_dv1 <= FALSE;
			end if;

			if ((rd_preg_dv1 AND rd_preg_ld) OR (rd_preg_dv3 AND rd_preg_sh)) then
				rd_preg_dv2 <= TRUE;
			else
				rd_preg_dv2 <= FALSE;
			end if;

			-- the register above preg3 is assumed to always be invalid when shifting
			if ((rd_preg_dv2 AND rd_preg_ld) OR (FALSE       AND rd_preg_sh)) then
				rd_preg_dv3 <= TRUE;
			else
				rd_preg_dv3 <= FALSE;
			end if;

		end if;

	end if;
end process;


--------------------------------------------------------------------------------
--
--  controls to fill the read pipeline and monitor progress
--
--------------------------------------------------------------------------------

--	process(tdm_clk, reset)
--	begin
--		if reset = c_async_reset_val then
--			rd_data_avail_reg <= FALSE;
--		elsif tdm_clk'event and tdm_clk = '1' then
--			rd_data_avail_reg <= rd_data_avail;
--		end if;
--	end process;
--!!! below is potential timing problem
	rd_data_avail_reg <= rd_data_avail;


rd_cntls_opt: if (FASTER_RD_CNTLS) generate

signal rd_preg_req			: boolean;
signal rd_preg_ack			: boolean;

signal rd_preg_req0		: boolean;
signal rd_preg_req1		: boolean;
signal rd_preg_req2		: boolean;
signal rd_preg_req3		: boolean;

begin

-- keep track of number of requests (whether serviced by tdm or not) that have not
-- been read by the port
	next_tdm_rd_req <= '1' when
		((rd_data_avail_reg) AND NOT(rd_preg_req3)) else '0';

	rd_preg_req		<= (tdm_rd_serv_req_stb = '1');
	rd_preg_ack		<= (rd_en_req_t0 = '1');


-- update dv register if shifting xor loading (if both dv state is unchaged)
--   if (write and register below is valid) or (read and register above is valid)
--   then we become valid, else we become invalid
process(tdm_clk, reset)
begin
	if reset = c_async_reset_val then

		rd_preg_req0 <= FALSE;
		rd_preg_req1 <= FALSE;
		rd_preg_req2 <= FALSE;
		rd_preg_req3 <= FALSE;

	elsif tdm_clk'event and tdm_clk = '1' then

		if (rd_preg_req XOR rd_preg_ack) then

			-- the register below preg0 is assumed to be always valid when loading
			if ((TRUE        AND rd_preg_req) OR (rd_preg_req1 AND rd_preg_ack)) then
				rd_preg_req0 <= TRUE;
			else
				rd_preg_req0 <= FALSE;
			end if;

			if ((rd_preg_req0 AND rd_preg_req) OR (rd_preg_req2 AND rd_preg_ack)) then
				rd_preg_req1 <= TRUE;
			else
				rd_preg_req1 <= FALSE;
			end if;

			if ((rd_preg_req1 AND rd_preg_req) OR (rd_preg_req3 AND rd_preg_ack)) then
				rd_preg_req2 <= TRUE;
			else
				rd_preg_req2 <= FALSE;
			end if;

			-- the register above preg3 is assumed to always be invalid when shifting
			if ((rd_preg_req2 AND rd_preg_req) OR (FALSE       AND rd_preg_ack)) then
				rd_preg_req3 <= TRUE;
			else
				rd_preg_req3 <= FALSE;
			end if;

		end if;

	end if;
end process;

end generate rd_cntls_opt;

--------------------------------------------------------------------------------
--
end generate tdm_rd_side;
--
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--
com_rd_side: if (rd_port_type = 3) generate
--
--------------------------------------------------------------------------------

	rd_en_req_t0 <= rd_en;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_en_reg <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			rd_en_reg <= rd_en;
		end if;
	end process;


	ram_b_addr_reg_ena <= rd_en_reg;
	next_tdm_rd_req <= rd_en_reg;
	tdm_rd_serv_req <= '0';
	tdm_rd_serv_req_stb <= rd_en;

	tdm_rd_req <= next_tdm_rd_req;

	rd_data <= rd_data_reg;


	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_data_reg <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			if (tdm_rd_data_ack = '1') then
--				rd_data_reg <= rd_preg_d0;
				rd_data_reg <= ram_b_mux_d0;
			end if;
		end if;
	end process;


	rd_ef <= rd_ef_reg;
	rd_ff <= rd_ff_reg;
	rd_level <= rd_level_reg;
	rd_dv <= rd_dv_reg;

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_ef_reg <= '1';
			rd_ff_reg <= '0';
			rd_level_reg <= (others => '0');
			rd_dv_reg <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			rd_ef_reg <= next_rd_ef;
			rd_ff_reg <= next_rd_ff;
			rd_level_reg <= next_rd_level;
			rd_dv_reg <= tdm_rd_data_ack;
		end if;
	end process;

-- prepare the next read level, not reflective of current rd activity
	next_rd_level <= tdm_stable_rd_level;

-- check for empty condition
--!!! reduce flags for data in pipeline
	next_rd_ef <= '1' when
		(tdm_stable_rd_level_full = '0') AND (tdm_stable_rd_level_zero = '1') else '0';

-- check for full condition
	next_rd_ff <= '1' when
		(tdm_stable_rd_level_full = '1') AND (tdm_stable_rd_level_zero = '1') else '0';

	tdm_stable_rd_level_zero <= '1' when
		(tdm_stable_rd_level(tdm_stable_rd_level'high downto 0) =
		 conv_std_logic_vector(16#0000#, tdm_stable_rd_level'length)) else '0';

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_stable_rd_level <= (others => '0');
			tdm_stable_rd_level_full <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_stable_rd_level <= tdm_rd_level;
			tdm_stable_rd_level_full <= tdm_rd_level_full;
		end if;
	end process;


	tdm_rd_data_ack <= tdm_shift_req(tdm_rd_latency -1);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_shift_req <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_shift_req(tdm_rd_latency -1 downto 1) <=
				tdm_shift_req(tdm_rd_latency -2 downto 0);
			tdm_shift_req(0) <= '0';

			if (rd_en_reg = '1') then
				tdm_shift_req(0) <= '1';
			end if;
		end if;
	end process;

--------------------------------------------------------------------------------
--
end generate com_rd_side;
--
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--
tdm_rd_side_2: if (rd_port_type = 1) generate
--
--------------------------------------------------------------------------------

--
--
--
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_rd_serv_req <= '0';
			tdm_rd_serv_req_stb <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			if (tdm_rd_serv_ack = '1') then
				tdm_rd_serv_req <= '0';
			end if;

			if ((next_tdm_rd_req = '1') AND (tdm_rd_serv_req = '0')) then
				tdm_rd_serv_req <= '1';
				tdm_rd_serv_req_stb <= '1';
			else
				tdm_rd_serv_req_stb <= '0';
			end if;
		end if;
	end process;


--
--  track our read request through the read pipeline to know when data is valid
--
	tdm_rd_serv_ack <= tdm_rd_ack;
--	tdm_rd_req <= tdm_rd_serv_req;
	tdm_rd_req <= tdm_rd_serv_req AND tdm_rd_ack;
	tdm_rd_data_ack <= tdm_shift_req(tdm_rd_latency -1);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_shift_req <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_shift_req(tdm_rd_latency -1 downto 1) <=
				tdm_shift_req(tdm_rd_latency -2 downto 0);
			tdm_shift_req(0) <= '0';

			if (tdm_rd_serv_ack = '1') then
				if (tdm_rd_serv_req = '1') then
					tdm_shift_req(0) <= '1';
				end if;
			end if;

		end if;
	end process;

ram_b_addr_reg_ena <=
	'1' when ((next_tdm_rd_req = '1') AND (tdm_rd_serv_req = '0')) else '0';

--------------------------------------------------------------------------------
--
end generate tdm_rd_side_2;
--
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--
--  register the input data from the ram to isolate the
--  muxing logic from the timing path
--
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_b_data_reg <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			ram_b_data_reg <= ram_b_data;
		end if;
	end process;

--
--  Generate the ram b addr and byte selection signals.
--
	ram_b_addr <= ram_b_addr_reg;


b_ratio1: if (ram_b_data_width / rd_data_width) = 1 generate
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_b_addr_reg <=
				conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width);
		elsif tdm_clk'event and tdm_clk = '1' then
			if (ram_b_addr_reg_ena = '1') then
				ram_b_addr_reg <=
					conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width) +
					rd_ram_addr(rd_addr_width -1 downto 0);
			end if;
		end if;
	end process;

	ram_b_mux_d0 <= ram_b_data_reg;

end generate b_ratio1;

b_ratio2: if (ram_b_data_width / rd_data_width) = 2 generate
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_b_addr_reg <=
				conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width);
			ram_b_addr_ext_reg(0) <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			if (ram_b_addr_reg_ena = '1') then
				ram_b_addr_reg <=
					conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width) +
					rd_ram_addr(rd_addr_width -1 downto 1);
				ram_b_addr_ext_reg(0) <= rd_ram_addr(0);
			end if;
		end if;
	end process;

	ram_b_mux_d0 <=
		ram_b_data_reg(ram_b_data_width/2 -1 downto 0) when (tdm_shift_a0(tdm_rd_latency -1) = '0') else
		ram_b_data_reg(ram_b_data_width -1 downto ram_b_data_width/2);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_shift_a0 <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_shift_a0(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a0(tdm_rd_latency -2 downto 0);

			tdm_shift_a0(0) <= ram_b_addr_ext_reg(0);
		end if;
	end process;

end generate b_ratio2;

b_ratio4: if (ram_b_data_width / rd_data_width) = 4 generate
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_b_addr_reg <=
				conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width);
			ram_b_addr_ext_reg(1 downto 0) <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			if (ram_b_addr_reg_ena = '1') then
				ram_b_addr_reg <=
					conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width) +
					rd_ram_addr(rd_addr_width -1 downto 2);
				ram_b_addr_ext_reg(1 downto 0) <= rd_ram_addr(1 downto 0);
			end if;
		end if;
	end process;

	ram_b_mux_d0 <=
		ram_b_mux_d1((ram_b_mux_d1'length/2) -1 downto 0) when (tdm_shift_a0(tdm_rd_latency -1) = '0') else
		ram_b_mux_d1((ram_b_mux_d1'length  ) -1 downto ram_b_mux_d1'length/2);
	ram_b_mux_d1 <=
		ram_b_data_reg((ram_b_data'length/2) -1 downto 0) when (tdm_shift_a1(tdm_rd_latency -1) = '0') else
		ram_b_data_reg((ram_b_data'length  ) -1 downto ram_b_data'length/2);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_shift_a1 <= (others => '0');
			tdm_shift_a0 <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_shift_a1(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a1(tdm_rd_latency -2 downto 0);
			tdm_shift_a0(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a0(tdm_rd_latency -2 downto 0);

			tdm_shift_a1(0) <= ram_b_addr_ext_reg(1);
			tdm_shift_a0(0) <= ram_b_addr_ext_reg(0);
		end if;
	end process;

end generate b_ratio4;

b_ratio8: if (ram_b_data_width / rd_data_width) = 8 generate
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_b_addr_reg <=
				conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width);
			ram_b_addr_ext_reg(2 downto 0) <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			if (ram_b_addr_reg_ena = '1') then
				ram_b_addr_reg <=
					conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width) +
					rd_ram_addr(rd_addr_width -1 downto 3);
				ram_b_addr_ext_reg(2 downto 0) <= rd_ram_addr(2 downto 0);
			end if;
		end if;
	end process;

	ram_b_mux_d0 <=
		ram_b_mux_d1((ram_b_mux_d1'length/2) -1 downto 0) when (tdm_shift_a0(tdm_rd_latency -1) = '0') else
		ram_b_mux_d1((ram_b_mux_d1'length  ) -1 downto ram_b_mux_d1'length/2);
	ram_b_mux_d1 <=
		ram_b_mux_d2((ram_b_mux_d2'length/2) -1 downto 0) when (tdm_shift_a1(tdm_rd_latency -1) = '0') else
		ram_b_mux_d2((ram_b_mux_d2'length  ) -1 downto ram_b_mux_d2'length/2);
	ram_b_mux_d2 <=
		ram_b_data_reg((ram_b_data'length/2) -1 downto 0) when (tdm_shift_a2(tdm_rd_latency -1) = '0') else
		ram_b_data_reg((ram_b_data'length  ) -1 downto ram_b_data'length/2);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_shift_a2 <= (others => '0');
			tdm_shift_a1 <= (others => '0');
			tdm_shift_a0 <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_shift_a2(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a2(tdm_rd_latency -2 downto 0);
			tdm_shift_a1(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a1(tdm_rd_latency -2 downto 0);
			tdm_shift_a0(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a0(tdm_rd_latency -2 downto 0);

			tdm_shift_a2(0) <= ram_b_addr_ext_reg(2);
			tdm_shift_a1(0) <= ram_b_addr_ext_reg(1);
			tdm_shift_a0(0) <= ram_b_addr_ext_reg(0);
		end if;
	end process;

end generate b_ratio8;


b_ratio16: if (ram_b_data_width / rd_data_width) = 16 generate
	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_b_addr_reg <=
				conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width);
			ram_b_addr_ext_reg(3 downto 0) <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			if (ram_b_addr_reg_ena = '1') then
				ram_b_addr_reg <=
					conv_std_logic_vector(ram_b_addr_offset, ram_b_addr_width) +
					rd_ram_addr(rd_addr_width -1 downto 4);
				ram_b_addr_ext_reg(3 downto 0) <= rd_ram_addr(3 downto 0);
			end if;
		end if;
	end process;

	ram_b_mux_d0 <=
		ram_b_mux_d1((ram_b_mux_d1'length/2) -1 downto 0) when (tdm_shift_a0(tdm_rd_latency -1) = '0') else
		ram_b_mux_d1((ram_b_mux_d1'length  ) -1 downto ram_b_mux_d1'length/2);
	ram_b_mux_d1 <=
		ram_b_mux_d2((ram_b_mux_d2'length/2) -1 downto 0) when (tdm_shift_a1(tdm_rd_latency -1) = '0') else
		ram_b_mux_d2((ram_b_mux_d2'length  ) -1 downto ram_b_mux_d2'length/2);
	ram_b_mux_d2 <=
		ram_b_mux_d3((ram_b_mux_d3'length/2) -1 downto 0) when (tdm_shift_a2(tdm_rd_latency -1) = '0') else
		ram_b_mux_d3((ram_b_mux_d3'length  ) -1 downto ram_b_mux_d3'length/2);
	ram_b_mux_d3 <=
		ram_b_data_reg((ram_b_data'length/2) -1 downto 0) when (tdm_shift_a3(tdm_rd_latency -1) = '0') else
		ram_b_data_reg((ram_b_data'length  ) -1 downto ram_b_data'length/2);

	process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			tdm_shift_a3 <= (others => '0');
			tdm_shift_a2 <= (others => '0');
			tdm_shift_a1 <= (others => '0');
			tdm_shift_a0 <= (others => '0');
		elsif tdm_clk'event and tdm_clk = '1' then
			tdm_shift_a3(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a3(tdm_rd_latency -2 downto 0);
			tdm_shift_a2(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a2(tdm_rd_latency -2 downto 0);
			tdm_shift_a1(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a1(tdm_rd_latency -2 downto 0);
			tdm_shift_a0(tdm_rd_latency -1 downto 1) <=
				tdm_shift_a0(tdm_rd_latency -2 downto 0);

			tdm_shift_a3(0) <= ram_b_addr_ext_reg(3);
			tdm_shift_a2(0) <= ram_b_addr_ext_reg(2);
			tdm_shift_a1(0) <= ram_b_addr_ext_reg(1);
			tdm_shift_a0(0) <= ram_b_addr_ext_reg(0);
		end if;
	end process;

end generate b_ratio16;


end rtl;

