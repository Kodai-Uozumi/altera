--------------------------------------------------------------------------------
--
--           Altera CSM Unidirectional Dual Port Write Source File
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
--      File Name:          alt_csm_unidpram_com_bus_wr.vhd
--      Entity Name:        alt_csm_unidpram_com_bus_wr
--
--      Description:
--
--          This module implements the common bus unidirectional dual port ram 
--          write side used in 1:N common bus mode.
--
--------------------------------------------------------------------------------
--
--      Revision History
--      ----------------
--          04/23/02    first release.
--
--      I/O
--      ----------------
--      Inputs:
--          wr_clk              common clock for the write side
--          reset               active low reset signal
--          vp_sel_in           virtual port "chip select"
--          wren_in             write enable signal
--          data_in             input data bus for the DPRAM
--          addr_in             input address bus for the DPRAM
--          byen_in             input byte_enable bus for the DPRAM
--
--
--      Outputs:
--          ram_data            output data bus for the DPRAM
--          ram_addr            output address bus for the DPRAM
--          ram_byen            output byte enable bus for the DPRAM
--          ram_wren            output bit for signaling valid RAM data
--
--
--      Generics:
--          addr_width          the width of the incoming address bus
--          byen_width          the width of the incoming byte enable bus
--          ram_addr_width      the width of the outgoing ram address bus
--          ram_byen_width      the width of the outgoing ram byte enable bus
--          vp_addr_offset      the starting address in the ram
--
--      Other
--      ----------------
--
--      Instantiated Functions: None
--
--      Instantiated Procedures: None
--
--      Instantiated Components: None
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.alt_csm_const_pkg.all;
use work.alt_csm_func_pkg.all;


entity alt_csm_unidpram_com_bus_wr is
	generic
	(
		implement_data_path		: boolean := false;
		data_width				: natural := 8;
		addr_width				: natural := 4;
		byen_width				: natural := 1;
		ram_data_width			: natural := 8;
		ram_addr_width			: natural := 4;
		ram_byen_width			: natural := 1;
		ram_offset_addr			: natural := 0
	);
	port
	(
		wr_clk					: in  std_logic;
		reset					: in  std_logic;
		wren_in					: in  std_logic;
		vp_sel_in				: in  std_logic;
		data_in					: in  std_logic_vector(data_width -1 downto 0);
		addr_in					: in  std_logic_vector(addr_width -1 downto 0);
		byen_in					: in  std_logic_vector(byen_width -1 downto 0);
		ram_data				: out std_logic_vector(ram_data_width -1 downto 0);
		ram_addr				: out std_logic_vector(ram_addr_width -1 downto 0);
		ram_byen				: out std_logic_vector(ram_byen_width -1 downto 0);
		ram_wren				: out std_logic
	);
end alt_csm_unidpram_com_bus_wr;

architecture rtl of alt_csm_unidpram_com_bus_wr is


--------------------------------------------------------------------------------
-- Signal and constant declarations
--------------------------------------------------------------------------------
--!	constant DATA_SIZE_RATIO	: natural := ram_data_width / data_width;

	signal wren_in_preg			: std_logic;
	signal vp_sel_in_preg		: std_logic;
	signal data_in_preg			: std_logic_vector(data_width -1 downto 0);
	signal addr_in_preg			: std_logic_vector(addr_width -1 downto 0);
	signal byen_in_preg			: std_logic_vector(byen_width -1 downto 0);

	signal ram_data_reg			: std_logic_vector(ram_data_width -1 downto 0) := (others => '0');
	signal ram_addr_reg			: std_logic_vector(ram_addr_width -1 downto 0);
	signal ram_byen_reg			: std_logic_vector(ram_byen_width -1 downto 0);
	signal ram_wren_reg			: std_logic;

	type unidpram_port_type is
	record
		wr_clk					: std_logic;
		reset					: std_logic;
		wren_in					: std_logic;
		vp_sel_in				: std_logic;
		data_in					: std_logic_vector(data_width -1 downto 0);
		addr_in					: std_logic_vector(addr_width -1 downto 0);
		byen_in					: std_logic_vector(byen_width -1 downto 0);
		ram_data				: std_logic_vector(ram_data_width -1 downto 0);
		ram_addr				: std_logic_vector(ram_addr_width -1 downto 0);
		ram_byen				: std_logic_vector(ram_byen_width -1 downto 0);
		ram_wren				: std_logic;
	end record;

	signal unidpram_port		: unidpram_port_type;

	type unidpram_reg_type is
	record
		wren_in_preg			: std_logic;
		vp_sel_in_preg			: std_logic;
		data_in_preg			: std_logic_vector(data_width -1 downto 0);
		addr_in_preg			: std_logic_vector(addr_width -1 downto 0);
		byen_in_preg			: std_logic_vector(byen_width -1 downto 0);
		ram_data_reg			: std_logic_vector(ram_data_width -1 downto 0);
		ram_addr_reg			: std_logic_vector(ram_addr_width -1 downto 0);
		ram_byen_reg			: std_logic_vector(ram_byen_width -1 downto 0);
		ram_wren_reg			: std_logic;
	end record;

	signal unidpram_reg			: unidpram_reg_type;

begin

--------------------------------------------------------------------------------
--
--  Assign values to records
--
	unidpram_port.wr_clk				<= wr_clk;
	unidpram_port.reset					<= reset;
	unidpram_port.wren_in				<= wren_in;
	unidpram_port.vp_sel_in				<= vp_sel_in;
	unidpram_port.data_in				<= data_in;
	unidpram_port.addr_in				<= addr_in;
	unidpram_port.byen_in				<= byen_in;
	unidpram_port.ram_data				<= ram_data_reg;
	unidpram_port.ram_addr				<= ram_addr_reg;
	unidpram_port.ram_byen				<= ram_byen_reg;
	unidpram_port.ram_wren				<= ram_wren_reg;

	unidpram_reg.wren_in_preg			<= wren_in_preg;
	unidpram_reg.vp_sel_in_preg			<= vp_sel_in_preg;
	unidpram_reg.data_in_preg			<= data_in_preg;
	unidpram_reg.addr_in_preg			<= addr_in_preg;
	unidpram_reg.byen_in_preg			<= byen_in_preg;
	unidpram_reg.ram_data_reg			<= ram_data_reg;
	unidpram_reg.ram_addr_reg			<= ram_addr_reg;
	unidpram_reg.ram_byen_reg			<= ram_byen_reg;
	unidpram_reg.ram_wren_reg			<= ram_wren_reg;

--------------------------------------------------------------------------------
--
--  Connect registers to output ports
--
	ram_data <= ram_data_reg;
	ram_addr <= ram_addr_reg;
	ram_byen <= ram_byen_reg;
	ram_wren <= ram_wren_reg;


--------------------------------------------------------------------------------
--
--  Sample the inputs in the port's clock domain
--
		sample_cntls : process(wr_clk, reset)
		begin
			if reset = c_async_reset_val then
				wren_in_preg	<= '0';
				vp_sel_in_preg	<= '0';
				addr_in_preg	<= (others => '0');
				byen_in_preg	<= (others => '0');
			elsif wr_clk'event and wr_clk = '1' then
				wren_in_preg	<= wren_in;
				vp_sel_in_preg	<= vp_sel_in;
				addr_in_preg	<= addr_in;
				byen_in_preg	<= byen_in;
			end if;
		end process sample_cntls;

	gen_data_path_1 : if (implement_data_path) generate
		sample_data : process(wr_clk, reset)
		begin
			if reset = c_async_reset_val then
				data_in_preg	<= (others => '0');
			elsif wr_clk'event and wr_clk = '1' then
				data_in_preg	<= data_in;
			end if;
		end process sample_data;
	end generate gen_data_path_1;

--------------------------------------------------------------------------------
--
--  Generate the write request address, data, and byte enable
--  There are two major modes of operation.
--
--  Not constant write mode requires that the write multiplexor track the write
--  enable signal from the port to the RAM.  This creates more logic and is
--  untested.
--
--------------------------------------------------------------------------------
--
--  This code implements the addr offset supplied by paramters as an independent
--  address extension.  This assumes that the ram offsets are page alligned
--  to the implied width of the addressable range.  full addr approach commented
--  with --!
--

	gen_ram_cntls : process(wr_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_addr_reg <=
				conv_std_logic_vector(ram_offset_addr, ram_addr_width);
			ram_byen_reg <= (others => '1');
			ram_wren_reg <= '0';
		elsif wr_clk'event and wr_clk = '1' then
			ram_addr_reg <=
				conv_std_logic_vector(ram_offset_addr, ram_addr_width) + addr_in_preg;
--!			ram_addr_reg <=
--!				conv_std_logic_vector(ram_offset_addr, ram_addr_width)(ram_addr_width -1 downto addr_width)
--!				& addr_in_preg;
			ram_byen_reg <= byen_in_preg;
			ram_wren_reg <= wren_in_preg and vp_sel_in_preg;
		end if;
	end process gen_ram_cntls;

	gen_data_path_2 : if (implement_data_path) generate
		gen_ram_data : process(wr_clk, reset)
		begin
			if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
				elsif wr_clk'event and wr_clk = '1' then
					ram_data_reg <= data_in_preg;
				end if;
			end process gen_ram_data;
	end generate gen_data_path_2;


end rtl;
