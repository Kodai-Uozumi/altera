--------------------------------------------------------------------------------
--
--           Altera CSM Unidirectional Dual Port Read Source File
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
--      File Name:          alt_csm_unidpram_com_bus_rd.vhd
--      Entity Name:        alt_csm_unidpram_com_bus_rd
--
--      Description:
--
--          This module is the read side of the altcsmem unidirectional dual
--          port ram when operating in common bus mode.
--
--
--      Outstanding Issues
--          buffer for holding address while waiting for ram latency is fixed at
--              mux_ram_delay - 2 in size.  It can be smaller if the correct value
--              is passed into the module
--          remove latency tweak
--
--
--------------------------------------------------------------------------------
--
--      Revision History
--      ----------------
--          03/14/02    first release.
--
--      I/O
--      ----------------
--      Inputs:
--          tdm_clk                 time domain clock for sequencer
--          pclk                    clock
--          reset                   active low reset signal
--          vport_req_ack_b         '1' when this port can access the RAM
--          read_b                  read enable signal
--          addr_in                 input address bus for the DPRAM
--
--
--      Outputs:
--          data_out                input data bus for the DPRAM
--          ram_data                output data bus for the DPRAM
--          ram_addr                output address bus for the DPRAM
--          vport_rd_req_accept_b   output signal for write mux
--          data_valid              data on data out is valid
--
--
--      Generics:
--          implement_data_path when true this instance drives the data_out
--                              and data_valid signals
--          data_width          the width of the incoming data bus
--          addr_width          the width of the incoming address bus
--          ram_data_width      the width of the outgoing ram data bus
--          ram_addr_width      the width of the outgoing ram address bus
--          ram_offset_addr     the starting address in the ram
--          mux_ram_delay       the number of tdm cycles delay for data to come
--                                  back from the RAM
--          latency             the number of port clock until data should be
--                              available on data_out
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


entity alt_csm_unidpram_com_bus_rd is
	generic
	(
		implement_data_path	: boolean := false;
		data_width			: natural := 8;
		addr_width			: natural := 4;
		ram_data_width		: natural := 8;
		ram_addr_width		: natural := 4;
		ram_offset_addr		: natural := 0;
		mux_ram_delay		: natural := 3;
		latency				: natural := 6
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
end alt_csm_unidpram_com_bus_rd;

architecture rtl of alt_csm_unidpram_com_bus_rd is



--------------------------------------------------------------------------------
-- Signal and constant declarations
--------------------------------------------------------------------------------

	signal addr_in_preg			: std_logic_vector(addr_width -1 downto 0);
	signal vp_sel_in_preg		: std_logic;
	signal read_b_preg			: std_logic;

	signal data_out_preg		: std_logic_vector(data_width -1 downto 0) := (others => '0');
	signal data_valid_preg		: std_logic := '0';
	signal rd_req_b				: std_logic;

	signal ram_addr_reg			: std_logic_vector(ram_addr_width -1 downto 0);

	signal data_valid_shift		: std_logic_vector(mux_ram_delay -1 downto 0);

	type unidpram_port_type is
	record
		reset				: std_logic;
		rd_clk				: std_logic;
		vp_sel_in			: std_logic;
		read_b				: std_logic;
		addr_in				: std_logic_vector(addr_width -1 downto 0);
		ram_data			: std_logic_vector(ram_data_width -1 downto 0);
		ram_addr			: std_logic_vector(ram_addr_width -1 downto 0);
		vp_rd_req_b			: std_logic;
		data_valid			: std_logic;
		data_out			: std_logic_vector(data_width -1 downto 0);
	end record;
	signal unidpram_port	: unidpram_port_type;

	type unidpram_reg_type is
	record
		read_b_preg			: std_logic;
		addr_in_preg		: std_logic_vector(addr_width -1 downto 0);
		vp_sel_in_preg		: std_logic;
		rd_req_b			: std_logic;
		ram_addr_reg		: std_logic_vector(ram_addr_width -1 downto 0);
		data_valid_shift	: std_logic_vector(mux_ram_delay -1 downto 0);
		data_out_preg		: std_logic_vector(data_width -1 downto 0);
		data_valid_preg		: std_logic;
	end record;
	signal unidpram_reg		: unidpram_reg_type;


begin

--------------------------------------------------------------------------------
--
--  Assign values to records
--
	unidpram_port.reset				<= reset;
	unidpram_port.rd_clk			<= rd_clk;
	unidpram_port.vp_sel_in			<= vp_sel_in;
	unidpram_port.read_b			<= read_b;
	unidpram_port.addr_in			<= addr_in;
	unidpram_port.data_out			<= data_out_preg;
	unidpram_port.ram_data			<= ram_data;
	unidpram_port.ram_addr			<= ram_addr_reg;
	unidpram_port.vp_rd_req_b		<= rd_req_b;
	unidpram_port.data_valid		<= data_valid_preg;

	unidpram_reg.read_b_preg		<= read_b_preg;
	unidpram_reg.addr_in_preg		<= addr_in_preg;
	unidpram_reg.vp_sel_in_preg		<= vp_sel_in_preg;
	unidpram_reg.rd_req_b			<= rd_req_b;
	unidpram_reg.ram_addr_reg		<= ram_addr_reg;
	unidpram_reg.data_valid_shift	<= data_valid_shift;
	unidpram_reg.data_out_preg		<= data_out_preg;
	unidpram_reg.data_valid_preg	<= data_valid_preg;


--------------------------------------------------------------------------------
--
--  Sample the inputs in the port's clock domain
--
		sample_inputs : process(rd_clk, reset)
		begin
			if reset = c_async_reset_val then
				read_b_preg <= '0';
				vp_sel_in_preg <= '0';
				addr_in_preg <= (others => '0');
			elsif rd_clk'event and rd_clk = '1' then
				read_b_preg <= read_b;
				vp_sel_in_preg <= vp_sel_in;
				addr_in_preg <= addr_in;
			end if;
		end process sample_inputs;


--------------------------------------------------------------------------------
--
--  Generate the read request signal for this port
--  The read signal is tracked through the data valid shift register to
--  monitor which data from the RAM is valid.
--
	vp_rd_req_b <= rd_req_b;

	request : process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_req_b <= '0';
		elsif rd_clk'event and rd_clk = '1' then
			if (vp_sel_in_preg = '1' and read_b_preg = '1') then
				rd_req_b <= '1';
			else
				rd_req_b <= '0';
			end if;
		end if;
	end process request;


--------------------------------------------------------------------------------
--
--  Generate the address with the offset address extention
--
	ram_addr <= ram_addr_reg;

	gen_ram_signals : process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			ram_addr_reg <= (others => '0');
--!			ram_addr_reg <=
--!				conv_std_logic_vector(ram_offset_addr, ram_addr_width);
		elsif rd_clk'event and rd_clk = '1' then
			if (vp_sel_in_preg = '1' and read_b_preg = '1') then
				ram_addr_reg <=
					conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
					addr_in_preg;
--!					conv_std_logic_vector(ram_offset_addr, ram_addr_width)
--!						(ram_addr_width -1 downto addr_width)
--!					& addr_in_preg;
			end if;
		end if;
	end process gen_ram_signals;


--------------------------------------------------------------------------------
--
--  Generate Data Valid Signal
--  This shift register tracks the read request and data valid signal
--  through the read mux and the RAM.
--
	data_valid <= data_valid_preg;

	gen_data_valid : process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			data_valid_shift <= (others => '0');
		elsif rd_clk'event and rd_clk = '1' then
			data_valid_shift <=
				rd_req_b & data_valid_shift(mux_ram_delay -1 downto 1);
		end if;
	end process gen_data_valid;

	process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			data_valid_preg <= '0';
		elsif rd_clk'event and rd_clk = '1' then
			data_valid_preg <= data_valid_shift(0);
		end if;
	end process;

--------------------------------------------------------------------------------
--
--  Transfer the outputs to the port's clock domain
--
	data_out <= data_out_preg;

gen_data_path : if (implement_data_path) generate
	process(rd_clk, reset)
	begin
		if reset = c_async_reset_val then
			data_out_preg <= (others => '0');
		elsif rd_clk'event and rd_clk = '1' then
			data_out_preg <= ram_data;
		end if;
	end process;
end generate gen_data_path;

end rtl;
