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
--      File Name:          alt_csm_unidpram_wr.vhd
--      Entity Name:        alt_csm_unidpram_wr
--
--      Description:
--
--          This module is the write side of the altcsmem unidirectional dual
--          port ram.
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
--          vp_sel_stb_a           '1' when this port can access the RAM
--          wr_en_a                 write enable signal
--          data_in                 input data bus for the DPRAM
--          addr_in                 input address bus for the DPRAM
--          byen_in                 input byte_enable bus for the DPRAM
--
--
--      Outputs:
--          ram_data                output data bus for the DPRAM
--          ram_addr                output address bus for the DPRAM
--          ram_byen                output byte enable bus for the DPRAM
--          ram_wren                output bit for signaling valid RAM data
--          vp_wr_req_a             output signal for write mux
--
--
--      Generics:
--          constant_wr_mode    when this is true the ram output registers
--                              are only updated on a write request
--          synchronous_clock   0 -> asynchronous, 1 -> synchronous ò 3x,
--                                                 2 -> synchronous = 2x
--          data_width          the width of the incoming data bus
--          addr_width          the width of the incoming address bus
--          byen_width          the width of the incoming byte enable bus
--          ram_data_width      the width of the outgoing ram data bus
--          ram_addr_width      the width of the outgoing ram address bus
--          ram_byen_width      the width of the outgoing ram byte enable bus
--          ram_offset_addr     the starting address in the ram
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


entity alt_csm_unidpram_wr is
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
		tdm_clk			: in  std_logic;
		pclk			: in  std_logic;
		reset			: in  std_logic;
		vp_sel_stb_a	: in  std_logic;
		wr_en_a			: in  std_logic;
		data_in			: in  std_logic_vector(data_width - 1 downto 0);
		addr_in			: in  std_logic_vector(addr_width - 1 downto 0);
		byen_in			: in  std_logic_vector(byen_width - 1 downto 0);
		ram_data		: out std_logic_vector(ram_data_width - 1 downto 0);
		ram_addr		: out std_logic_vector(ram_addr_width - 1 downto 0);
		ram_byen		: out std_logic_vector(ram_byen_width - 1 downto 0);
		ram_wren		: out std_logic;
		vp_wr_req_a		: out std_logic
	);
end alt_csm_unidpram_wr;

architecture rtl of alt_csm_unidpram_wr is




--------------------------------------------------------------------------------
-- Signal and constant declarations
--------------------------------------------------------------------------------
	constant DATA_SIZE_RATIO	: natural := ram_data_width / data_width;

	signal pclk_treg		: std_logic;
	signal pclk1_treg		: std_logic;
	signal pclk2_treg		: std_logic;
	signal wr_en_a_preg		: std_logic;
	signal wr_en_a_treg		: std_logic;
	signal data_in_preg		: std_logic_vector(data_width - 1 downto 0);
	signal data_in_treg		: std_logic_vector(data_width - 1 downto 0);
	signal addr_in_preg		: std_logic_vector(addr_width - 1 downto 0);
	signal addr_in_treg		: std_logic_vector(addr_width - 1 downto 0);
	signal byen_in_preg		: std_logic_vector(byen_width - 1 downto 0);
	signal byen_in_treg		: std_logic_vector(byen_width - 1 downto 0);
	signal set_vp_wr_req_a	: std_logic;
	signal wr_req_a			: std_logic;

	signal ram_data_reg		: std_logic_vector(ram_data_width - 1 downto 0);
	signal ram_addr_reg		: std_logic_vector(ram_addr_width - 1 downto 0);
	signal ram_byen_reg		: std_logic_vector(ram_byen_width - 1 downto 0);

	type unidpram_port_type is
	record
		tdm_clk				: std_logic;
		pclk				: std_logic;
		reset				: std_logic;
		vp_sel_stb_a		: std_logic;
		wr_en_a				: std_logic;
		data_in				: std_logic_vector(data_width - 1 downto 0);
		addr_in				: std_logic_vector(addr_width - 1 downto 0);
		byen_in				: std_logic_vector(byen_width - 1 downto 0);
		ram_data			: std_logic_vector(ram_data_width - 1 downto 0);
		ram_addr			: std_logic_vector(ram_addr_width - 1 downto 0);
		ram_byen			: std_logic_vector(ram_byen_width - 1 downto 0);
		ram_wren			: std_logic;
		vp_wr_req_a			: std_logic;
	end record;
	signal unidpram_port	: unidpram_port_type;

	type unidpram_reg_type is
	record
		pclk_treg			: std_logic;
		pclk1_treg			: std_logic;
		pclk2_treg			: std_logic;
		wr_en_a_preg		: std_logic;
		wr_en_a_treg		: std_logic;
		data_in_preg		: std_logic_vector(data_width - 1 downto 0);
		data_in_treg		: std_logic_vector(data_width - 1 downto 0);
		addr_in_preg		: std_logic_vector(addr_width - 1 downto 0);
		addr_in_treg		: std_logic_vector(addr_width - 1 downto 0);
		byen_in_preg		: std_logic_vector(byen_width - 1 downto 0);
		byen_in_treg		: std_logic_vector(byen_width - 1 downto 0);
		set_vp_wr_req_a		: std_logic;
		wr_req_a			: std_logic;
		ram_data_reg		: std_logic_vector(ram_data_width - 1 downto 0);
		ram_addr_reg		: std_logic_vector(ram_addr_width - 1 downto 0);
		ram_byen_reg		: std_logic_vector(ram_byen_width - 1 downto 0);
	end record;
	signal unidpram_reg		: unidpram_reg_type;

-- temporary wires added to get over the NCVHDL compiler errors
	signal addr_in_treg_wire1 : std_logic_vector(1 downto 0);
	signal addr_in_treg_wire2 : std_logic_vector(2 downto 0);
	signal addr_in_treg_wire3 : std_logic_vector(3 downto 0);	

begin

--------------------------------------------------------------------------------
--
--  Assign values to records
--
	unidpram_port.tdm_clk			<= tdm_clk;
	unidpram_port.pclk				<= pclk;
	unidpram_port.reset				<= reset;
	unidpram_port.vp_sel_stb_a		<= vp_sel_stb_a;
	unidpram_port.wr_en_a			<= wr_en_a;
	unidpram_port.data_in			<= data_in;
	unidpram_port.addr_in			<= addr_in;
	unidpram_port.byen_in			<= byen_in;
	unidpram_port.ram_data			<= ram_data_reg;
	unidpram_port.ram_addr			<= ram_addr_reg;
	unidpram_port.ram_byen			<= ram_byen_reg;
	unidpram_port.ram_wren			<= set_vp_wr_req_a or wr_req_a;
	unidpram_port.vp_wr_req_a		<= vp_sel_stb_a and wr_req_a;

	unidpram_reg.pclk_treg			<= pclk_treg;
	unidpram_reg.pclk1_treg			<= pclk1_treg;
	unidpram_reg.pclk2_treg			<= pclk2_treg;
	unidpram_reg.wr_en_a_preg		<= wr_en_a_preg;
	unidpram_reg.wr_en_a_treg		<= wr_en_a_treg;
	unidpram_reg.data_in_preg		<= data_in_preg;
	unidpram_reg.data_in_treg		<= data_in_treg;
	unidpram_reg.addr_in_preg		<= addr_in_preg;
	unidpram_reg.addr_in_treg		<= addr_in_treg;
	unidpram_reg.byen_in_preg		<= byen_in_preg;
	unidpram_reg.byen_in_treg		<= byen_in_treg;
	unidpram_reg.set_vp_wr_req_a	<= set_vp_wr_req_a;
	unidpram_reg.wr_req_a			<= wr_req_a;
	unidpram_reg.ram_data_reg		<= ram_data_reg;
	unidpram_reg.ram_addr_reg		<= ram_addr_reg;
	unidpram_reg.ram_byen_reg		<= ram_byen_reg;

--------------------------------------------------------------------------------
--
--  Connect registers to output ports
--
	ram_data <= ram_data_reg;
	ram_addr <= ram_addr_reg;
	ram_byen <= ram_byen_reg;
	ram_wren <= set_vp_wr_req_a or wr_req_a;

--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
--
--  Asynchronous mode is limited to 1/3 the tdm clock.  This allows the process
--  to sample the inputs in the port clock domain and transfer them to the tdm
--  clock domain.
--

	asynchronous : if synchronous_clock = 0 generate

--------------------------------------------------------------------------------
--
--      Sample the inputs in the port's clock domain
--
		sample_inputs : process(pclk, reset)
		begin
			if reset = c_async_reset_val then
				wr_en_a_preg <= '0';
				data_in_preg <= (others => '0');
				addr_in_preg <= (others => '0');
				byen_in_preg <= (others => '0');
			elsif pclk'event and pclk = '1' then
				wr_en_a_preg <= wr_en_a;
				data_in_preg <= data_in;
				addr_in_preg <= addr_in;
				byen_in_preg <= byen_in;
			end if;
		end process sample_inputs;


--------------------------------------------------------------------------------
--
--      Convert the data from the port's clock domain to the TDM clock domain.
--      Also sample the port's clock for edge detection.
--
		sample_tdm : process(tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				pclk_treg <= '1';
				pclk1_treg <= '1';
				pclk2_treg <= '1';
				wr_en_a_treg <= '0';
				data_in_treg <= (others => '0');
				addr_in_treg <= (others => '0');
				byen_in_treg <= (others => '0');
			elsif tdm_clk'event and tdm_clk = '1' then
				pclk_treg <= pclk;
				pclk1_treg <= pclk_treg;
				pclk2_treg <= pclk1_treg;
				wr_en_a_treg <= wr_en_a_preg;
				data_in_treg <= data_in_preg;
				addr_in_treg <= addr_in_preg;
				byen_in_treg <= byen_in_preg;
			end if;
		end process sample_tdm;

	end generate asynchronous;

--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
--
--  Synchronous mode requires that the tdm clock be an integer multiple of the
--  port clock (2, 3, ...).  The data is registered in the port clock domain.
--  These registers are used by the tdm based processes directly.
--

	synchronous : if synchronous_clock /= 0 generate


--------------------------------------------------------------------------------
--
--      Convert the data from the port's clock domain to the TDM clock domain.
--      Also sample the port's clock for edge detection.
--
		sample_tdm : process(tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				pclk1_treg <= '1';
				pclk2_treg <= '1';
				wr_en_a_treg <= '0';
				data_in_treg <= (others => '0');
				addr_in_treg <= (others => '0');
				byen_in_treg <= (others => '0');
			elsif tdm_clk'event and tdm_clk = '1' then
				pclk1_treg <= pclk;
				pclk2_treg <= pclk1_treg;
				wr_en_a_treg <= wr_en_a;
				data_in_treg <= data_in;
				addr_in_treg <= addr_in;
				byen_in_treg <= byen_in;
			end if;
		end process sample_tdm;
	end generate synchronous;


--------------------------------------------------------------------------------
--
--  Detect the rising edge of the port's clock
--
    set_vp_wr_req_a <= not(pclk2_treg) and pclk1_treg and wr_en_a_treg;

--------------------------------------------------------------------------------
--
--  Generate the write request signal for this port
--
	request : process(tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			wr_req_a <= '0';
		elsif tdm_clk'event and tdm_clk = '1' then
			if set_vp_wr_req_a = '1' then
				if wr_req_a = '1' then
					assert false report "Pending write request lost " severity error;
				end if;
				wr_req_a <= '1';
			end if;

			if vp_sel_stb_a = '1' then
				wr_req_a <= '0';
			end if;

		end if;
	end process request;

	vp_wr_req_a <= vp_sel_stb_a and wr_req_a;

--------------------------------------------------------------------------------
--
--  Generate the write request address, data, and byte enable
--  There are two major modes of operation.
--
--  Constant write mode only updates the RAM write registers with valid data and
--  this data is then re-written on each time the sequencer activates this port.
--  This mode is the normal mode of operation for this port.
--
--  Not constant write mode requires that the write multiplexor track the write
--  enable signal from the port to the RAM.  This creates more logic and is
--  untested.
--
--  In each major mode there are 5 different data ratio: 1, 2, 4, 8, and 16.
--  The different ratios map the external write data and address to the correct
--  RAM write data, RAM byte enables, and RAM address.
--
--

	const_wr_mode : if constant_wr_mode generate
		ratio1 : if DATA_SIZE_RATIO = 1 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '1');
				elsif tdm_clk'event and tdm_clk = '1' then
					if set_vp_wr_req_a = '1' then
						ram_data_reg <= data_in_treg;

						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg;

						ram_byen_reg <= byen_in_treg;
					end if;
				end if;
			end process gen_ram_signals;
		end generate ratio1;



--------------------------------------------------------------------------------

		ratio2 : if DATA_SIZE_RATIO = 2 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '0');
				elsif tdm_clk'event and tdm_clk = '1' then
					if set_vp_wr_req_a = '1' then
						ram_data_reg(ram_data_width -1 downto 0) <=
							data_in_treg & data_in_treg;

						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg(addr_width -1 downto 1);

						if addr_in_treg(0) = '0' then
							ram_byen_reg(ram_byen_width -1 downto byen_width) <= (others => '0');
							ram_byen_reg(byen_width -1     downto 0)          <= byen_in_treg;
						else
							ram_byen_reg(ram_byen_width -1 downto byen_width) <= byen_in_treg;
							ram_byen_reg(byen_width -1     downto 0)          <= (others => '0');
						end if;
					end if;
				end if;
			end process gen_ram_signals;
		end generate ratio2;



--------------------------------------------------------------------------------

		ratio4 : if DATA_SIZE_RATIO = 4 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '0');
				elsif tdm_clk'event and tdm_clk = '1' then
					if set_vp_wr_req_a = '1' then
						ram_data_reg(ram_data_width -1 downto 0) <=
							data_in_treg & data_in_treg & data_in_treg & data_in_treg;

						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg(addr_width -1 downto 2);

						addr_in_treg_wire1 <= addr_in_treg(1 downto 0);
						case addr_in_treg_wire1 is
							when "00" =>
								ram_byen_reg(ram_byen_width -1 downto byen_width) <= (others => '0');
								ram_byen_reg(    byen_width -1 downto 0)          <= byen_in_treg;

							when "01" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 2) <= (others => '0');
								ram_byen_reg((byen_width * 2) -1 downto byen_width)     <= byen_in_treg;
								ram_byen_reg(      byen_width -1 downto 0)              <= (others => '0');

							when "10" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 3) <= (others => '0');
								ram_byen_reg((byen_width * 3) -1 downto byen_width * 2) <= byen_in_treg;
								ram_byen_reg((byen_width * 2) -1 downto 0)              <= (others => '0');

							when "11" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 3) <= byen_in_treg;
								ram_byen_reg((byen_width * 3) -1 downto 0)              <= (others => '0');

							when others =>
								ram_byen_reg <= (others => '-');

						end case;

					end if;
				end if;
			end process gen_ram_signals;
		end generate ratio4;



--------------------------------------------------------------------------------

		ratio8 : if DATA_SIZE_RATIO = 8 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '0');
				elsif tdm_clk'event and tdm_clk = '1' then
					if set_vp_wr_req_a = '1' then
						ram_data_reg(ram_data_width -1 downto 0) <=
							data_in_treg & data_in_treg & data_in_treg & data_in_treg &
							data_in_treg & data_in_treg & data_in_treg & data_in_treg;

						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg(addr_width -1 downto 3);
						
						addr_in_treg_wire2 <=  addr_in_treg(2 downto 0);
						case addr_in_treg_wire2 is
							when "000" =>
								ram_byen_reg(ram_byen_width -1 downto byen_width) <= (others => '0');
								ram_byen_reg(    byen_width -1 downto 0)          <= byen_in_treg;

							when "001" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 2) <= (others => '0');
								ram_byen_reg((byen_width * 2) -1 downto byen_width)     <= byen_in_treg;
								ram_byen_reg(      byen_width -1 downto 0)              <= (others => '0');

							when "010" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 3) <= (others => '0');
								ram_byen_reg((byen_width * 3) -1 downto byen_width * 2) <= byen_in_treg;
								ram_byen_reg((byen_width * 2) -1 downto 0)              <= (others => '0');

							when "011" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 4) <= (others => '0');
								ram_byen_reg((byen_width * 4) -1 downto byen_width * 3) <= byen_in_treg;
								ram_byen_reg((byen_width * 3) -1 downto 0)              <= (others => '0');

							when "100" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 5) <= (others => '0');
								ram_byen_reg((byen_width * 5) -1 downto byen_width * 4) <= byen_in_treg;
								ram_byen_reg((byen_width * 4) -1 downto 0)              <= (others => '0');

							when "101" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 6) <= (others => '0');
								ram_byen_reg((byen_width * 6) -1 downto byen_width * 5) <= byen_in_treg;
								ram_byen_reg((byen_width * 5) -1 downto 0)              <= (others => '0');

							when "110" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 7) <= (others => '0');
								ram_byen_reg((byen_width * 7) -1 downto byen_width * 6) <= byen_in_treg;
								ram_byen_reg((byen_width * 6) -1 downto 0)              <= (others => '0');

							when "111" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 7) <= byen_in_treg;
								ram_byen_reg((byen_width * 7) -1 downto 0)              <= (others => '0');

							when others =>
								ram_byen_reg <= (others => '-');

						end case;

					end if;
				end if;
			end process gen_ram_signals;
		end generate ratio8;



--------------------------------------------------------------------------------

		ratio16 : if DATA_SIZE_RATIO = 16 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '0');
				elsif tdm_clk'event and tdm_clk = '1' then
					if set_vp_wr_req_a = '1' then
						ram_data_reg(ram_data_width -1 downto 0) <=
							data_in_treg & data_in_treg & data_in_treg & data_in_treg &
							data_in_treg & data_in_treg & data_in_treg & data_in_treg &
							data_in_treg & data_in_treg & data_in_treg & data_in_treg &
							data_in_treg & data_in_treg & data_in_treg & data_in_treg;

						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg(addr_width -1 downto 4);
						
						addr_in_treg_wire3 <= addr_in_treg(3 downto 0);
						case addr_in_treg_wire3 is
							when "0000" =>
								ram_byen_reg(ram_byen_width -1 downto byen_width) <= (others => '0');
								ram_byen_reg(    byen_width -1 downto 0)          <= byen_in_treg;

							when "0001" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 2) <= (others => '0');
								ram_byen_reg((byen_width * 2) -1 downto byen_width)     <= byen_in_treg;
								ram_byen_reg(      byen_width -1 downto 0)              <= (others => '0');

							when "0010" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 3) <= (others => '0');
								ram_byen_reg((byen_width * 3) -1 downto byen_width * 2) <= byen_in_treg;
								ram_byen_reg((byen_width * 2) -1 downto 0)              <= (others => '0');

							when "0011" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 4) <= (others => '0');
								ram_byen_reg((byen_width * 4) -1 downto byen_width * 3) <= byen_in_treg;
								ram_byen_reg((byen_width * 3) -1 downto 0)              <= (others => '0');

							when "0100" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 5) <= (others => '0');
								ram_byen_reg((byen_width * 5) -1 downto byen_width * 4) <= byen_in_treg;
								ram_byen_reg((byen_width * 4) -1 downto 0)              <= (others => '0');

							when "0101" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 6) <= (others => '0');
								ram_byen_reg((byen_width * 6) -1 downto byen_width * 5) <= byen_in_treg;
								ram_byen_reg((byen_width * 5) -1 downto 0)              <= (others => '0');

							when "0110" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 7) <= (others => '0');
								ram_byen_reg((byen_width * 7) -1 downto byen_width * 6) <= byen_in_treg;
								ram_byen_reg((byen_width * 6) -1 downto 0)              <= (others => '0');

							when "0111" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 8) <= (others => '0');
								ram_byen_reg((byen_width * 8) -1 downto byen_width * 7) <= byen_in_treg;
								ram_byen_reg((byen_width * 7) -1 downto 0)              <= (others => '0');

							when "1000" =>
								ram_byen_reg(  ram_byen_width -1 downto byen_width * 9) <= (others => '0');
								ram_byen_reg((byen_width * 9) -1 downto byen_width * 8) <= byen_in_treg;
								ram_byen_reg((byen_width * 8) -1 downto 0)              <= (others => '0');

							when "1001" =>
								ram_byen_reg(  ram_byen_width  -1 downto byen_width * 10) <= (others => '0');
								ram_byen_reg((byen_width * 10) -1 downto byen_width *  9) <= byen_in_treg;
								ram_byen_reg((byen_width *  9) -1 downto 0)               <= (others => '0');

							when "1010" =>
								ram_byen_reg(  ram_byen_width  -1 downto byen_width * 11) <= (others => '0');
								ram_byen_reg((byen_width * 11) -1 downto byen_width * 10) <= byen_in_treg;
								ram_byen_reg((byen_width * 10) -1 downto 0)               <= (others => '0');

							when "1011" =>
								ram_byen_reg(  ram_byen_width  -1 downto byen_width * 12) <= (others => '0');
								ram_byen_reg((byen_width * 12) -1 downto byen_width * 11) <= byen_in_treg;
								ram_byen_reg((byen_width * 11) -1 downto 0)               <= (others => '0');

							when "1100" =>
								ram_byen_reg(  ram_byen_width  -1 downto byen_width * 13) <= (others => '0');
								ram_byen_reg((byen_width * 13) -1 downto byen_width * 12) <= byen_in_treg;
								ram_byen_reg((byen_width * 12) -1 downto 0)               <= (others => '0');

							when "1101" =>
								ram_byen_reg(  ram_byen_width  -1 downto byen_width * 14) <= (others => '0');
								ram_byen_reg((byen_width * 14) -1 downto byen_width * 13) <= byen_in_treg;
								ram_byen_reg((byen_width * 13) -1 downto 0)               <= (others => '0');

							when "1110" =>
								ram_byen_reg(  ram_byen_width  -1 downto byen_width * 15) <= (others => '0');
								ram_byen_reg((byen_width * 15) -1 downto byen_width * 14) <= byen_in_treg;
								ram_byen_reg((byen_width * 14) -1 downto 0)               <= (others => '0');

							when "1111" =>
								ram_byen_reg(  ram_byen_width  -1 downto byen_width * 15) <= byen_in_treg;
								ram_byen_reg((byen_width * 15) -1 downto 0)              <= (others => '0');

							when others =>
								ram_byen_reg <= (others => '-');

						end case;

					end if;
				end if;
			end process gen_ram_signals;
		end generate ratio16;
	end generate const_wr_mode;



--------------------------------------------------------------------------------

	not_const_wr_mode : if not(constant_wr_mode) generate
		ratio1 : if DATA_SIZE_RATIO = 1 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '1');
				elsif tdm_clk'event and tdm_clk = '1' then
					ram_data_reg <= data_in_treg;
					ram_addr_reg <=
						conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
						addr_in_treg;
					ram_byen_reg <= byen_in_treg;
				end if;
			end process gen_ram_signals;
		end generate ratio1;



--------------------------------------------------------------------------------

		ratio2 : if DATA_SIZE_RATIO = 2 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '0');
				elsif tdm_clk'event and tdm_clk = '1' then
					ram_data_reg(ram_data_width -1 downto 0) <=
						data_in_treg & data_in_treg;

					ram_addr_reg <=
						conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
						addr_in_treg(addr_width -1 downto 1);

					if addr_in_treg(0) = '0' then
						ram_byen_reg(ram_byen_width -1 downto byen_width) <= (others => '0');
						ram_byen_reg(byen_width -1     downto 0)          <= byen_in_treg;
					else
						ram_byen_reg(ram_byen_width -1 downto byen_width) <= byen_in_treg;
						ram_byen_reg(byen_width -1     downto 0)          <= (others => '0');
					end if;
				end if;
			end process gen_ram_signals;
		end generate ratio2;



--------------------------------------------------------------------------------

		ratio4 : if DATA_SIZE_RATIO = 4 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '0');
				elsif tdm_clk'event and tdm_clk = '1' then
					ram_data_reg(ram_data_width -1 downto 0) <=
						data_in_treg & data_in_treg & data_in_treg & data_in_treg;

					ram_addr_reg <=
						conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
						addr_in_treg(addr_width -1 downto 2);
					
					addr_in_treg_wire1 <= addr_in_treg(1 downto 0);
					case addr_in_treg_wire1 is
						when "00" =>
							ram_byen_reg(ram_byen_width -1 downto byen_width) <= (others => '0');
							ram_byen_reg(    byen_width -1 downto 0)          <= byen_in_treg;

						when "01" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 2) <= (others => '0');
							ram_byen_reg((byen_width * 2) -1 downto byen_width)     <= byen_in_treg;
							ram_byen_reg(      byen_width -1 downto 0)              <= (others => '0');

						when "10" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 3) <= (others => '0');
							ram_byen_reg((byen_width * 3) -1 downto byen_width * 2) <= byen_in_treg;
							ram_byen_reg((byen_width * 2) -1 downto 0)              <= (others => '0');

						when "11" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 3) <= byen_in_treg;
							ram_byen_reg((byen_width * 3) -1 downto 0)              <= (others => '0');

						when others =>
							ram_byen_reg <= (others => '-');

					end case;

				end if;
			end process gen_ram_signals;
		end generate ratio4;



--------------------------------------------------------------------------------

		ratio8 : if DATA_SIZE_RATIO = 8 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '0');
				elsif tdm_clk'event and tdm_clk = '1' then
					ram_data_reg(ram_data_width -1 downto 0) <=
						data_in_treg & data_in_treg & data_in_treg & data_in_treg &
						data_in_treg & data_in_treg & data_in_treg & data_in_treg;

					ram_addr_reg <=
						conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
						addr_in_treg(addr_width -1 downto 3);

					addr_in_treg_wire2 <= addr_in_treg(2 downto 0);
					case addr_in_treg_wire2 is
						when "000" =>
							ram_byen_reg(ram_byen_width -1 downto byen_width) <= (others => '0');
							ram_byen_reg(    byen_width -1 downto 0)          <= byen_in_treg;

						when "001" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 2) <= (others => '0');
							ram_byen_reg((byen_width * 2) -1 downto byen_width)     <= byen_in_treg;
							ram_byen_reg(      byen_width -1 downto 0)              <= (others => '0');

						when "010" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 3) <= (others => '0');
							ram_byen_reg((byen_width * 3) -1 downto byen_width * 2) <= byen_in_treg;
							ram_byen_reg((byen_width * 2) -1 downto 0)              <= (others => '0');

						when "011" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 4) <= (others => '0');
							ram_byen_reg((byen_width * 4) -1 downto byen_width * 3) <= byen_in_treg;
							ram_byen_reg((byen_width * 3) -1 downto 0)              <= (others => '0');

						when "100" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 5) <= (others => '0');
							ram_byen_reg((byen_width * 5) -1 downto byen_width * 4) <= byen_in_treg;
							ram_byen_reg((byen_width * 4) -1 downto 0)              <= (others => '0');

						when "101" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 6) <= (others => '0');
							ram_byen_reg((byen_width * 6) -1 downto byen_width * 5) <= byen_in_treg;
							ram_byen_reg((byen_width * 5) -1 downto 0)              <= (others => '0');

						when "110" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 7) <= (others => '0');
							ram_byen_reg((byen_width * 7) -1 downto byen_width * 6) <= byen_in_treg;
							ram_byen_reg((byen_width * 6) -1 downto 0)              <= (others => '0');

						when "111" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 7) <= byen_in_treg;
							ram_byen_reg((byen_width * 7) -1 downto 0)              <= (others => '0');

						when others =>
							ram_byen_reg <= (others => '-');

					end case;

				end if;
			end process gen_ram_signals;
		end generate ratio8;



--------------------------------------------------------------------------------

		ratio16 : if DATA_SIZE_RATIO = 16 generate
			gen_ram_signals : process(tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_reg <= (others => '0');
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					ram_byen_reg <= (others => '0');
				elsif tdm_clk'event and tdm_clk = '1' then
					ram_data_reg(ram_data_width -1 downto 0) <=
						data_in_treg & data_in_treg & data_in_treg & data_in_treg &
						data_in_treg & data_in_treg & data_in_treg & data_in_treg &
						data_in_treg & data_in_treg & data_in_treg & data_in_treg &
						data_in_treg & data_in_treg & data_in_treg & data_in_treg;

					ram_addr_reg <=
						conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
						addr_in_treg(addr_width -1 downto 4);

					addr_in_treg_wire3 <= addr_in_treg(3 downto 0);
					case addr_in_treg_wire3 is
						when "0000" =>
							ram_byen_reg(ram_byen_width -1 downto byen_width) <= (others => '0');
							ram_byen_reg(    byen_width -1 downto 0)          <= byen_in_treg;

						when "0001" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 2) <= (others => '0');
							ram_byen_reg((byen_width * 2) -1 downto byen_width)     <= byen_in_treg;
							ram_byen_reg(      byen_width -1 downto 0)              <= (others => '0');

						when "0010" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 3) <= (others => '0');
							ram_byen_reg((byen_width * 3) -1 downto byen_width * 2) <= byen_in_treg;
							ram_byen_reg((byen_width * 2) -1 downto 0)              <= (others => '0');

						when "0011" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 4) <= (others => '0');
							ram_byen_reg((byen_width * 4) -1 downto byen_width * 3) <= byen_in_treg;
							ram_byen_reg((byen_width * 3) -1 downto 0)              <= (others => '0');

						when "0100" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 5) <= (others => '0');
							ram_byen_reg((byen_width * 5) -1 downto byen_width * 4) <= byen_in_treg;
							ram_byen_reg((byen_width * 4) -1 downto 0)              <= (others => '0');

						when "0101" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 6) <= (others => '0');
							ram_byen_reg((byen_width * 6) -1 downto byen_width * 5) <= byen_in_treg;
							ram_byen_reg((byen_width * 5) -1 downto 0)              <= (others => '0');

						when "0110" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 7) <= (others => '0');
							ram_byen_reg((byen_width * 7) -1 downto byen_width * 6) <= byen_in_treg;
							ram_byen_reg((byen_width * 6) -1 downto 0)              <= (others => '0');

						when "0111" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 8) <= (others => '0');
							ram_byen_reg((byen_width * 8) -1 downto byen_width * 7) <= byen_in_treg;
							ram_byen_reg((byen_width * 7) -1 downto 0)              <= (others => '0');

						when "1000" =>
							ram_byen_reg(  ram_byen_width -1 downto byen_width * 9) <= (others => '0');
							ram_byen_reg((byen_width * 9) -1 downto byen_width * 8) <= byen_in_treg;
							ram_byen_reg((byen_width * 8) -1 downto 0)              <= (others => '0');

						when "1001" =>
							ram_byen_reg(  ram_byen_width  -1 downto byen_width * 10) <= (others => '0');
							ram_byen_reg((byen_width * 10) -1 downto byen_width *  9) <= byen_in_treg;
							ram_byen_reg((byen_width *  9) -1 downto 0)               <= (others => '0');

						when "1010" =>
							ram_byen_reg(  ram_byen_width  -1 downto byen_width * 11) <= (others => '0');
							ram_byen_reg((byen_width * 11) -1 downto byen_width * 10) <= byen_in_treg;
							ram_byen_reg((byen_width * 10) -1 downto 0)               <= (others => '0');

						when "1011" =>
							ram_byen_reg(  ram_byen_width  -1 downto byen_width * 12) <= (others => '0');
							ram_byen_reg((byen_width * 12) -1 downto byen_width * 11) <= byen_in_treg;
							ram_byen_reg((byen_width * 11) -1 downto 0)               <= (others => '0');

						when "1100" =>
							ram_byen_reg(  ram_byen_width  -1 downto byen_width * 13) <= (others => '0');
							ram_byen_reg((byen_width * 13) -1 downto byen_width * 12) <= byen_in_treg;
							ram_byen_reg((byen_width * 12) -1 downto 0)               <= (others => '0');

						when "1101" =>
							ram_byen_reg(  ram_byen_width  -1 downto byen_width * 14) <= (others => '0');
							ram_byen_reg((byen_width * 14) -1 downto byen_width * 13) <= byen_in_treg;
							ram_byen_reg((byen_width * 13) -1 downto 0)               <= (others => '0');

						when "1110" =>
							ram_byen_reg(  ram_byen_width  -1 downto byen_width * 15) <= (others => '0');
							ram_byen_reg((byen_width * 15) -1 downto byen_width * 14) <= byen_in_treg;
							ram_byen_reg((byen_width * 14) -1 downto 0)               <= (others => '0');

						when "1111" =>
							ram_byen_reg(  ram_byen_width  -1 downto byen_width * 15) <= byen_in_treg;
							ram_byen_reg((byen_width * 15) -1 downto 0)              <= (others => '0');

						when others =>
							ram_byen_reg <= (others => '-');

					end case;

				end if;
			end process gen_ram_signals;
		end generate ratio16;
	end generate not_const_wr_mode;


end rtl;
