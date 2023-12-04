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
--      File Name:          alt_csm_unidpram_rd.vhd
--      Entity Name:        alt_csm_unidpram_rd
--
--      Description:
--
--          This module is the read side of the altcsmem unidirectional dual
--          port ram.
--
--
--      Outstanding Issues:
--          buffer for holding address while waiting for ram latency is fixed at
--              mux_ram_delay - 2 in size.  It can be smaller if the correct value
--              is passed into the module
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
--          tdm_clk             time domain clock for sequencer
--          pclk                clock
--          reset               active low reset signal
--          vp_sel_stb_b        '1' when this port can access the RAM
--          read_b              read enable signal
--          addr_in             input address bus for the DPRAM
--
--      Outputs:
--          data_out            input data bus for the DPRAM
--          ram_data            output data bus for the DPRAM
--          ram_addr            output address bus for the DPRAM
--          vp_rd_req_b         output signal for write mux
--          data_valid          data on data out is valid
--
--      Generics:
--          buffer_input_data   when this is true, supply a single level FIFO
--                                  for the external inputs.
--          constant_rd_mode    when this is true the ram output registers
--                              are only updated on a read request
--          synchronous_clock   0 -> asynchronous >= 3x,
--                              1 -> synchronous >= 3x,
--                              2 -> synchronous = 2x
--          data_width          the width of the incoming data bus
--          addr_width          the width of the incoming address bus
--          ram_data_width      the width of the outgoing ram data bus
--          ram_addr_width      the width of the outgoing ram address bus
--          ram_offset_addr     the starting address in the ram
--          mux_ram_delay       the number of tdm cycles delay for data to come
--                                  back from the RAM
--          latency             the number of port clock until data should be
--                              available on data_out
--          invert_tdm_clk      when 1 invert the tdm_clk for internal use.
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


entity alt_csm_unidpram_rd is
	generic
	(
		buffer_input_data	: boolean := false;
		constant_rd_mode	: boolean := true;
		synchronous_clock	: natural := 0;
		data_width			: natural := 8;
		addr_width			: natural := 4;
		ram_data_width		: natural := 8;
		ram_addr_width		: natural := 4;
		ram_offset_addr		: natural := 0;
		mux_ram_delay		: natural := 3;
		latency				: natural := 5;
		invert_tdm_clk		: natural := 0
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
end alt_csm_unidpram_rd;


architecture rtl of alt_csm_unidpram_rd is

--------------------------------------------------------------------------------
-- Signal and constant declarations
--------------------------------------------------------------------------------

	constant DATA_SIZE_RATIO	: natural := (ram_data_width / data_width);
	constant ADDR_BITS			: natural := unsigned_num_bits(DATA_SIZE_RATIO -1);

	signal int_tdm_clk			: std_logic;
	signal pclk_ctreg			: std_logic;
	signal pclk_treg1			: std_logic;
	signal pclk_treg2			: std_logic;
	signal pclk_ped				: std_logic;
	signal read_b_preg			: std_logic;
	signal read_b_treg			: std_logic;
	signal data_out_preg		: std_logic_vector(data_width -1 downto 0);
	signal data_out_treg		: std_logic_vector(data_width -1 downto 0);
	signal ram_data_treg		: std_logic_vector(data_width -1 downto 0);
	signal ram_ready_treg		: std_logic;
	signal ram_valid_treg		: std_logic;
	signal data_valid_treg		: std_logic;
	signal data_valid_preg		: std_logic;

	signal addr_in_preg			: std_logic_vector(addr_width -1 downto 0);
	signal addr_in_treg			: std_logic_vector(addr_width -1 downto 0);
	signal set_vport_rd_req_b	: std_logic;
	signal rd_req_b				: std_logic;

	signal ram_addr_reg			: std_logic_vector(ram_addr_width -1 downto 0);

	signal data_fifo0_treg		: std_logic_vector(data_width -1 downto 0);
	signal data_valid0_treg		: std_logic;
	signal fifo0_used			: std_logic;
	signal data_fifo1_treg		: std_logic_vector(data_width -1 downto 0);
	signal data_valid1_treg		: std_logic;
	signal fifo1_used			: std_logic;

	signal read_fifo			: std_logic;

	signal addr_shift_in_reg	: std_logic_vector(ADDR_BITS -1 downto 0);
	signal addr0_shift_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
	signal addr1_shift_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
	signal addr2_shift_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
	signal addr3_shift_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
	signal addr_shift_out		: std_logic_vector(ADDR_BITS -1 downto 0);
	signal read_comp_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
	signal data_valid_shift_in	: std_logic;
	signal data_valid_shift		: std_logic_vector(mux_ram_delay -2 downto 0);
	signal pclk_count			: std_logic_vector(2 downto 0);
	signal pclk_cnt_started		: std_logic;
	signal rd_fifo_sel			: std_logic_vector(3 downto 0);

	type unidpram_port_type is
	record
		reset				: std_logic;
		pclk				: std_logic;
		read_b				: std_logic;
		addr_in				: std_logic_vector(addr_width -1 downto 0);
		tdm_clk				: std_logic;
		vp_sel_stb_b		: std_logic;
		vp_rd_req_b			: std_logic;
		ram_data			: std_logic_vector(ram_data_width -1 downto 0);
		ram_addr			: std_logic_vector(ram_addr_width -1 downto 0);
		data_valid			: std_logic;
		data_out			: std_logic_vector(data_width -1 downto 0);
	end record;
	signal unidpram_port	: unidpram_port_type;

	type unidpram_reg_type is
	record
		int_tdm_clk			: std_logic;
		pclk_ctreg			: std_logic;
		pclk_treg1			: std_logic;
		pclk_treg2			: std_logic;
		read_b_preg			: std_logic;
		read_b_treg			: std_logic;
		addr_in_preg		: std_logic_vector(addr_width -1 downto 0);
		addr_in_treg		: std_logic_vector(addr_width -1 downto 0);
		pclk_ped			: std_logic;
		set_vport_rd_req_b	: std_logic;
		rd_req_b			: std_logic;
		ram_addr_reg		: std_logic_vector(ram_addr_width -1 downto 0);
		read_comp_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
		data_valid_shift_in	: std_logic;
		data_valid_shift	: std_logic_vector(mux_ram_delay -2 downto 0);
	end record;

	signal unidpram_reg	: unidpram_reg_type;

	type unidpram_fifo_type is
	record
		pclk_ped			: std_logic;
		pclk_count			: std_logic_vector(2 downto 0);
		data_out_preg		: std_logic_vector(data_width -1 downto 0);
		data_valid_preg		: std_logic;
		data_out_treg		: std_logic_vector(data_width -1 downto 0);
		data_valid_treg		: std_logic;
		read_fifo			: std_logic;

		fifo0_used			: std_logic;
		data_fifo0_treg		: std_logic_vector(data_width -1 downto 0);
		data_valid0_treg	: std_logic;
		fifo1_used			: std_logic;
		data_fifo1_treg		: std_logic_vector(data_width -1 downto 0);
		data_valid1_treg	: std_logic;

		ram_data_treg		: std_logic_vector(data_width -1 downto 0);
		ram_ready_treg		: std_logic;
		ram_valid_treg		: std_logic;
	end record;
	signal unidpram_fifo	: unidpram_fifo_type;


	type unidpram_addr_shift_type is
	record
		addr_shift_in_reg	: std_logic_vector(ADDR_BITS -1 downto 0);
		addr0_shift_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
		addr1_shift_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
		addr2_shift_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
		addr3_shift_reg		: std_logic_vector(mux_ram_delay -2 downto 0);
		addr_shift_out		: std_logic_vector(ADDR_BITS -1 downto 0);
	end record;
	signal unidpram_shift		: unidpram_addr_shift_type;
-- temporary wires added to get over the compilation errors in NCVHDL
	signal addr_shift_out_wire1 : std_logic_vector(1 downto 0);
	signal addr_shift_out_wire2 : std_logic_vector(2 downto 0);
	signal addr_shift_out_wire3 : std_logic_vector(3 downto 0);	

begin

--------------------------------------------------------------------------------
--
--  Assign values to records
--
	unidpram_port.tdm_clk				<= tdm_clk;
	unidpram_port.pclk					<= pclk;
	unidpram_port.reset					<= reset;
	unidpram_port.vp_sel_stb_b			<= vp_sel_stb_b;
	unidpram_port.read_b				<= read_b;
	unidpram_port.addr_in				<= addr_in;
	unidpram_port.data_out				<= data_out_preg;
	unidpram_port.ram_data				<= ram_data;
	unidpram_port.ram_addr				<= ram_addr_reg;
	unidpram_port.vp_rd_req_b			<= vp_sel_stb_b and rd_req_b;
	unidpram_port.data_valid			<= data_valid_preg;

	unidpram_reg.int_tdm_clk			<= int_tdm_clk;
	unidpram_reg.pclk_ctreg				<= pclk_ctreg;
	unidpram_reg.pclk_treg1				<= pclk_treg1;
	unidpram_reg.pclk_treg2				<= pclk_treg2;
	unidpram_reg.read_b_preg			<= read_b_preg;
	unidpram_reg.read_b_treg			<= read_b_treg;
	unidpram_reg.addr_in_preg			<= addr_in_preg;
	unidpram_reg.addr_in_treg			<= addr_in_treg;
	unidpram_reg.set_vport_rd_req_b		<= set_vport_rd_req_b;
	unidpram_reg.rd_req_b				<= rd_req_b;
	unidpram_reg.ram_addr_reg			<= ram_addr_reg;
	unidpram_reg.read_comp_reg			<= read_comp_reg;
	unidpram_reg.data_valid_shift_in	<= data_valid_shift_in;
	unidpram_reg.data_valid_shift		<= data_valid_shift;
	unidpram_reg.pclk_ped				<= pclk_ped;

	unidpram_fifo.data_out_preg			<= data_out_preg;
	unidpram_fifo.data_valid_preg		<= data_valid_preg;
	unidpram_fifo.data_out_treg			<= data_out_treg;
	unidpram_fifo.data_valid_treg		<= data_valid_treg;
	unidpram_fifo.fifo0_used			<= fifo0_used;
	unidpram_fifo.data_fifo0_treg		<= data_fifo0_treg;
	unidpram_fifo.data_valid0_treg		<= data_valid0_treg;
	unidpram_fifo.fifo1_used			<= fifo1_used;
	unidpram_fifo.data_fifo1_treg		<= data_fifo1_treg;
	unidpram_fifo.data_valid1_treg		<= data_valid1_treg;
	unidpram_fifo.ram_data_treg			<= ram_data_treg;
	unidpram_fifo.ram_ready_treg		<= ram_ready_treg;
	unidpram_fifo.ram_valid_treg		<= ram_valid_treg;
	unidpram_fifo.read_fifo				<= read_fifo;
	unidpram_fifo.pclk_count			<= pclk_count;
	unidpram_fifo.pclk_ped				<= pclk_ped;

	unidpram_shift.addr_shift_in_reg	<= addr_shift_in_reg;
	unidpram_shift.addr0_shift_reg		<= addr0_shift_reg;
	unidpram_shift.addr1_shift_reg		<= addr1_shift_reg;
	unidpram_shift.addr2_shift_reg		<= addr2_shift_reg;
	unidpram_shift.addr3_shift_reg		<= addr3_shift_reg;
	unidpram_shift.addr_shift_out		<= addr_shift_out;


--------------------------------------------------------------------------------
--
--  Invert TDM clk if necessary
--
	inv_tdm : if invert_tdm_clk = 1 generate
		int_tdm_clk <= not(tdm_clk);
	end generate inv_tdm;

	no_inv_tdm : if invert_tdm_clk = 0 generate
		int_tdm_clk <= tdm_clk;
	end generate no_inv_tdm;


--------------------------------------------------------------------------------
--
--  Connect registers to output ports
--
	ram_addr <= ram_addr_reg;
	data_valid <= data_valid_preg;
	vp_rd_req_b <= vp_sel_stb_b and rd_req_b;

--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
--
--  Asynchronous mode is limited to 1/3 the tdm clock.  This allows the process
--  to sample the inputs in the port clock domain and transfer them to the tdm
--  clock domain.
--

	asynchronous : if synchronous_clock = 0 generate

--
--      Sample the inputs in the port's clock domain
--
		sample_inputs : process(pclk, reset)
		begin
			if reset = c_async_reset_val then
				read_b_preg <= '0';
				addr_in_preg <= (others => '0');
			elsif pclk'event and pclk = '1' then
				read_b_preg <= read_b;
				addr_in_preg <= addr_in;
			end if;
		end process sample_inputs;

--
--      Sample address, byte enable and read enable signals.
--
		sample_tdm_inputs : process(int_tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				read_b_treg <= '0';
				addr_in_treg <= (others => '0');
			elsif int_tdm_clk'event and int_tdm_clk = '1' then
				if pclk_ctreg = '1' then
					read_b_treg <= read_b_preg;
					addr_in_treg <= addr_in_preg;
				end if;
			end if;
		end process sample_tdm_inputs;

--
--      Convert the data from the port's clock domain to the TDM clock domain.
--      Also sample the port's clock for edge detection.
--
		sample_tdm : process(int_tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				pclk_ctreg <= '0';
				pclk_treg1 <= '0';
				pclk_treg2 <= '0';
			elsif int_tdm_clk'event and int_tdm_clk = '1' then
				pclk_ctreg <= pclk;
				pclk_treg1 <= pclk_ctreg;
				pclk_treg2 <= pclk_treg1;
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

--
--      Convert the data from the port's clock domain to the TDM clock domain.
--      Also sample the port's clock for edge detection.
--
		sample_tdm : process(int_tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				pclk_ctreg <= '0';
				pclk_treg1 <= '0';
				pclk_treg2 <= '0';
				read_b_preg <= '0';
				addr_in_preg <= (others => '0');
			elsif int_tdm_clk'event and int_tdm_clk = '1' then
				pclk_treg1 <= pclk;
				pclk_treg2 <= pclk_treg1;
				read_b_preg <= read_b;
				addr_in_preg <= addr_in;
			end if;
		end process sample_tdm;
		addr_in_treg <= addr_in_preg;
		read_b_treg <= read_b_preg;

	end generate synchronous;

--------------------------------------------------------------------------------




--------------------------------------------------------------------------------
--
--  Detect the rising edge of the port's clock
--

	pclk_ped <= pclk_treg1 and not(pclk_treg2);
	set_vport_rd_req_b <= pclk_ped and read_b_treg;

--------------------------------------------------------------------------------
--
--  Generate the read request signal for this port
--  A read request occurs on every positive edge of the port clock after the
--  first read is detected.  This keeps the read response FIFO at the correct
--  level.  The read signal is tracked through the data valid shift register to
--  monitor which data from the RAM is valid.
--
	request : process(int_tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			rd_req_b <= '0';
		elsif int_tdm_clk'event and int_tdm_clk = '1' then
			if (pclk_ped = '1' and read_b_treg = '1') or
			   (pclk_cnt_started = '1' and pclk_ped = '1') then
--			   (pclk_count /= conv_std_logic_vector(latency, pclk_count'length) - 2 and
				if rd_req_b = '1' and vp_sel_stb_b = '0' then
					assert false report "Pending read request lost " severity error;
				end if;
				rd_req_b <= '1';
			elsif vp_sel_stb_b = '1' then
				rd_req_b <= '0';
			end if;
		end if;
	end process request;


--------------------------------------------------------------------------------
--
--  Generate Read Complete Signal and Data Valid Signal
--  This is a shift register that tracks the read request and data valid signal
--  through the read mux and the RAM.
--

	gen_read_complete : process(int_tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			read_comp_reg <= (others => '0');
			data_valid_shift <= (others => '0');
		elsif int_tdm_clk'event and int_tdm_clk = '1' then
			read_comp_reg <=
				(rd_req_b and vp_sel_stb_b) & read_comp_reg(mux_ram_delay - 2 downto 1);
			data_valid_shift <=
				(data_valid_shift_in and rd_req_b and vp_sel_stb_b) &
				data_valid_shift(mux_ram_delay -2 downto 1);
		end if;
	end process gen_read_complete;


--------------------------------------------------------------------------------
--
--  Track requested low order address bits while waiting for data from RAM
--

	gen_addr0_shift_reg : if DATA_SIZE_RATIO > 1 generate
		addr0 : process(int_tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				addr0_shift_reg <= (others => '0');
			elsif int_tdm_clk'event and int_tdm_clk = '1' then
				addr0_shift_reg(mux_ram_delay -3 downto 0) <= addr0_shift_reg(mux_ram_delay - 2 downto 1);
				if rd_req_b = '1' and vp_sel_stb_b = '1' then
					addr0_shift_reg(mux_ram_delay -2) <= addr_shift_in_reg(0);
				end if;
			end if;
		end process addr0;
		addr_shift_out(0) <= addr0_shift_reg(0);
	end generate gen_addr0_shift_reg;

	gen_addr1_shift_reg : if DATA_SIZE_RATIO > 2 generate
		addr1 : process(int_tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				addr1_shift_reg(mux_ram_delay -3 downto 0) <= (others => '0');
			elsif int_tdm_clk'event and int_tdm_clk = '1' then
				addr1_shift_reg(mux_ram_delay -3 downto 0) <= addr1_shift_reg(mux_ram_delay - 2 downto 1);
				if rd_req_b = '1' and vp_sel_stb_b = '1' then
					addr1_shift_reg(mux_ram_delay -2) <= addr_shift_in_reg(1);
				end if;
			end if;
		end process addr1;
		addr_shift_out(1) <= addr1_shift_reg(0);
	end generate gen_addr1_shift_reg;

	gen_addr2_shift_reg : if DATA_SIZE_RATIO > 4 generate
		addr2 : process(int_tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				addr2_shift_reg <= (others => '0');
			elsif int_tdm_clk'event and int_tdm_clk = '1' then
				addr2_shift_reg(mux_ram_delay -3 downto 0) <= addr2_shift_reg(mux_ram_delay - 2 downto 1);
				if rd_req_b = '1' and vp_sel_stb_b = '1' then
					addr2_shift_reg(mux_ram_delay -2) <= addr_shift_in_reg(2);
				end if;
			end if;
		end process addr2;
		addr_shift_out(2) <= addr2_shift_reg(0);
	end generate gen_addr2_shift_reg;

	gen_addr3_shift_reg : if DATA_SIZE_RATIO > 8 generate
		addr3 : process(int_tdm_clk, reset)
		begin
			if reset = c_async_reset_val then
				addr3_shift_reg <= (others => '0');
			elsif int_tdm_clk'event and int_tdm_clk = '1' then
				addr3_shift_reg(mux_ram_delay -3 downto 0) <= addr3_shift_reg(mux_ram_delay - 2 downto 1);
				if rd_req_b = '1' and vp_sel_stb_b = '1' then
					addr3_shift_reg(mux_ram_delay -2) <= addr_shift_in_reg(3);
				end if;
			end if;
		end process addr3;
		addr_shift_out(3) <= addr3_shift_reg(0);
	end generate gen_addr3_shift_reg;

--------------------------------------------------------------------------------
--
--  Count Port Clock Edges
--
--  This process monitors the port clock and the read enable signal looking for
--  the first read.  At that point it counts port clock cycles to properly align
--  the data with the port clock after the correct latency.
--

--	pclk_cnt_started <=
--		'0' when pclk_count = conv_std_logic_vector(latency, pclk_count'length) -2 else '1';

	cnt_port_clk : process(int_tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			pclk_cnt_started <= '0';
			pclk_count <= conv_std_logic_vector(latency, pclk_count'length) - 2;
		elsif int_tdm_clk'event and int_tdm_clk = '1' then
			if pclk_count /= 0 then
				if (pclk_cnt_started = '0' and set_vport_rd_req_b = '1') or
				   (pclk_cnt_started = '1' and pclk_ped = '1') then
					pclk_count <= pclk_count -1;
					pclk_cnt_started <= '1';
				end if;

--				if pclk_count = conv_std_logic_vector(latency, pclk_count'length) - 2 then
--					if set_vport_rd_req_b = '1' then
--						pclk_count <= pclk_count - 1;
--					end if;
--				elsif pclk_ped = '1' then
--					pclk_count <= pclk_count - 1;
--				end if;

			end if;
		end if;
	end process cnt_port_clk;

--------------------------------------------------------------------------------
--
--  Read Response FIFO
--

	rd_fifo_sel <= ram_ready_treg & read_fifo & fifo0_used & fifo1_used;

	rd_resp : process(int_tdm_clk, reset)
	begin
		if reset = c_async_reset_val then
			fifo0_used <= '0';
			fifo1_used <= '0';
			data_fifo0_treg <= (others => '0');
			data_fifo1_treg <= (others => '0');
			data_valid0_treg <= '0';
			data_valid1_treg <= '0';
			data_out_treg <= (others => '0');
			data_valid_treg <= '0';
		elsif int_tdm_clk'event and int_tdm_clk = '1' then
			case rd_fifo_sel is

-- new data from RAM into empty FIFO
				when "1000" =>
					fifo0_used <= '1';
					data_fifo0_treg <= ram_data_treg;
					data_valid0_treg <= ram_valid_treg;

-- error condition
				when "1001" =>
					assert false report "Detected empty first position in unidpram read FIFO " severity error;

-- new data from RAM into a FIFO with one used entry
				when "1010" =>
					fifo1_used <= '1';
					data_fifo1_treg <= ram_data_treg;
					data_valid1_treg <= ram_valid_treg;

-- error condtion, new data into a full FIFO
				when "1011" =>
					assert false report "Overflow in unidpram read response FIFO " severity error;

-- error condition, reading from an empty FIFO
				when "0100" =>
					assert false report "Underflow in unidpram read response FIFO " severity error;

-- error condition
				when "0101" =>
					assert false report "Detected empty first position in unidpram read response FIFO " severity error;

-- reading data from a FIFO with one used entry
				when "0110" =>
					data_out_treg <= data_fifo0_treg;
					data_valid_treg <= data_valid0_treg;
					fifo0_used <= '0';
					data_fifo0_treg <= (others => '-');
					data_valid0_treg <= '0';

-- reading data from a full FIFO
				when "0111" =>
					data_out_treg <= data_fifo0_treg;
					data_valid_treg <= data_valid0_treg;
					data_fifo0_treg <= data_fifo1_treg;
					data_valid0_treg <= data_valid1_treg;
					fifo1_used <= '0';
					data_fifo1_treg <= (others => '-');
					data_valid1_treg <= '0';

-- simultaneously reading data and adding data to an empty FIFO
				when "1100" =>
					data_out_treg <= ram_data_treg;
					data_valid_treg <= ram_valid_treg;

-- error condition
				when "1101" =>
					assert false report "Detected empty first position in unidpram read response FIFO " severity error;

-- simultaneously reading data and adding data to a FIFO with one used entry
				when "1110" =>
					data_out_treg <= data_fifo0_treg;
					data_valid_treg <= data_valid0_treg;
					data_fifo0_treg <= ram_data_treg;
					data_valid0_treg <= ram_valid_treg;

-- simultaneously reading data and adding data to a full FIFO
				when "1111" =>
					data_out_treg <= data_fifo0_treg;
					data_valid_treg <= data_valid0_treg;
					data_fifo0_treg <= data_fifo1_treg;
					data_valid0_treg <= data_valid1_treg;
					data_fifo1_treg <= ram_data_treg;
					data_valid1_treg <= ram_valid_treg;

				when "0000" =>
				when "0010" =>
				when "0011" =>
					null;

-- error condition
				when "0001" =>
					assert false report "Detected empty first position in unidpram read response FIFO " severity error;

				when others =>
					null;
			end case;
		end if;
	end process rd_resp;

	read_fifo <= '1' when pclk_ped = '1' and pclk_count = 0 else '0';


--------------------------------------------------------------------------------
--
--  Transfer the outputs to the port's clock domain
--
	sample_outputs : process(pclk, reset)
	begin
		if reset = c_async_reset_val then
			data_out_preg <= (others => '0');
			data_valid_preg <= '0';
		elsif pclk'event and pclk = '1' then
			data_out_preg <= data_out_treg;
			data_valid_preg <= data_valid_treg;
		end if;
	end process sample_outputs;
	data_out <= data_out_preg;


--------------------------------------------------------------------------------
--
--  Generate the write request address, data, and byte enable
--  Each section is based on the width of the port data vs. the width of the RAM
--  data.  For each data ratio there are two sections.
--
--  One section, calculates the correct RAM address and the data valid shift
--    register input.
--
--  The other section uses the output of the address shift register to capture
--  the correct portion of the RAM data bus.  It also captures the output of the
--  data valid shift register.
--

	const_rd_mode : if constant_rd_mode generate
		ratio1 : if DATA_SIZE_RATIO = 1 generate
			gen_ram_out_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_addr_reg <= (others => '0');
					data_valid_shift_in <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if pclk_ped = '1' then
						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg;
						data_valid_shift_in <= read_b_treg;
					end if;
				end if;
			end process gen_ram_out_signals;

			gen_ram_in_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_treg  <= (others => '0');
					ram_ready_treg <= '0';
					ram_valid_treg <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if read_comp_reg(0) = '1' then
						ram_data_treg <= ram_data;
						ram_ready_treg <= '1';
						ram_valid_treg <= data_valid_shift(0);
					else
						ram_ready_treg <= '0';
						ram_valid_treg <= '0';
					end if;
				end if;
			end process gen_ram_in_signals;
		end generate ratio1;


--------------------------------------------------------------------------------

		ratio2 : if DATA_SIZE_RATIO = 2 generate
			gen_ram_out_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					addr_shift_in_reg(0) <= '0';
					data_valid_shift_in <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if pclk_ped = '1' then
						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg(addr_width -1 downto 1);
						addr_shift_in_reg(0) <= addr_in_treg(0);
						data_valid_shift_in <= read_b_treg;
					end if;
				end if;
			end process gen_ram_out_signals;

			gen_ram_in_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_treg  <= (others => '0');
					ram_ready_treg <= '0';
					ram_valid_treg <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if read_comp_reg(0) = '1' then
						if addr_shift_out(0) = '0' then
							ram_data_treg <= ram_data(data_width -1 downto 0);
						else
							ram_data_treg <= ram_data(ram_data_width -1 downto data_width);
						end if;
						ram_ready_treg <= '1';
						ram_valid_treg <= data_valid_shift(0);
					else
						ram_ready_treg <= '0';
						ram_valid_treg <= '0';
					end if;
				end if;
			end process gen_ram_in_signals;
		end generate ratio2;


--------------------------------------------------------------------------------

		ratio4 : if DATA_SIZE_RATIO = 4 generate
			gen_ram_out_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					addr_shift_in_reg <= (others => '0');
					data_valid_shift_in <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if pclk_ped = '1' then
						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg(addr_width -1 downto 2);
						addr_shift_in_reg <= addr_in_treg(1 downto 0);
						data_valid_shift_in <= read_b_treg;
					end if;
				end if;
			end process gen_ram_out_signals;

			gen_ram_in_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_treg  <= (others => '0');
					ram_ready_treg <= '0';
					ram_valid_treg <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if read_comp_reg(0) = '1' then
						addr_shift_out_wire1 <=  addr_shift_out(1 downto 0);
						case addr_shift_out_wire1 is
							when "00" =>
								ram_data_treg <= ram_data(data_width -1 downto 0);
							when "01" =>
								ram_data_treg <= ram_data((2 * data_width) -1 downto data_width);
							when "10" =>
								ram_data_treg <= ram_data((3 * data_width) -1 downto 2 * data_width);
							when "11" =>
								ram_data_treg <= ram_data(ram_data_width -1 downto 3 * data_width);
							when others =>
								ram_data_treg <= (others => '-');
						end case;

						ram_ready_treg <= '1';
						ram_valid_treg <= data_valid_shift(0);
					else
						ram_ready_treg <= '0';
						ram_valid_treg <= '0';
					end if;
				end if;
			end process gen_ram_in_signals;
		end generate ratio4;


--------------------------------------------------------------------------------

		ratio8 : if DATA_SIZE_RATIO = 8 generate
			gen_ram_out_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					addr_shift_in_reg <= (others => '0');
					data_valid_shift_in <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if pclk_ped = '1' then
						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg(addr_width -1 downto 3);
						addr_shift_in_reg <= addr_in_treg(2 downto 0);
						data_valid_shift_in <= read_b_treg;
					end if;
				end if;
			end process gen_ram_out_signals;

			gen_ram_in_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_treg  <= (others => '0');
					ram_ready_treg <= '0';
					ram_valid_treg <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if read_comp_reg(0) = '1' then
						addr_shift_out_wire2 <= addr_shift_out(2 downto 0);
						case addr_shift_out_wire2 is
							when "000" =>
								ram_data_treg <= ram_data(data_width -1 downto 0);
							when "001" =>
								ram_data_treg <= ram_data((2 * data_width) -1 downto data_width);
							when "010" =>
								ram_data_treg <= ram_data((3 * data_width) -1 downto 2 * data_width);
							when "011" =>
								ram_data_treg <= ram_data((4 * data_width) -1 downto 3 * data_width);
							when "100" =>
								ram_data_treg <= ram_data((5 * data_width) -1 downto 4 * data_width);
							when "101" =>
								ram_data_treg <= ram_data((6 * data_width) -1 downto 5 * data_width);
							when "110" =>
								ram_data_treg <= ram_data((7 * data_width) -1 downto 6 * data_width);
							when "111" =>
								ram_data_treg <= ram_data(ram_data_width -1 downto 7 * data_width);
							when others =>
								ram_data_treg <= (others => '-');
						end case;

						ram_ready_treg <= '1';
						ram_valid_treg <= data_valid_shift(0);
					else
						ram_ready_treg <= '0';
						ram_valid_treg <= '0';
					end if;
				end if;
			end process gen_ram_in_signals;
		end generate ratio8;


--------------------------------------------------------------------------------

		ratio16 : if DATA_SIZE_RATIO = 16 generate
			gen_ram_out_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_addr_reg <= conv_std_logic_vector(ram_offset_addr, ram_addr_width);
					addr_shift_in_reg <= (others => '0');
					data_valid_shift_in <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if pclk_ped = '1' then
						ram_addr_reg <=
							conv_std_logic_vector(ram_offset_addr, ram_addr_width) +
							addr_in_treg(addr_width -1 downto 4);
						addr_shift_in_reg <= addr_in_treg(3 downto 0);
						data_valid_shift_in <= read_b_treg;
					end if;
				end if;
			end process gen_ram_out_signals;

			gen_ram_in_signals : process(int_tdm_clk, reset)
			begin
				if reset = c_async_reset_val then
					ram_data_treg  <= (others => '0');
					ram_ready_treg <= '0';
					ram_valid_treg <= '0';
				elsif int_tdm_clk'event and int_tdm_clk = '1' then
					if read_comp_reg(0) = '1' then
						addr_shift_out_wire3 <= addr_shift_out(3 downto 0);
						case addr_shift_out_wire3 is
							when "0000" =>
								ram_data_treg <= ram_data(data_width -1 downto 0);
							when "0001" =>
								ram_data_treg <= ram_data(( 2 * data_width) -1 downto data_width);
							when "0010" =>
								ram_data_treg <= ram_data(( 3 * data_width) -1 downto  2 * data_width);
							when "0011" =>
								ram_data_treg <= ram_data(( 4 * data_width) -1 downto  3 * data_width);
							when "0100" =>
								ram_data_treg <= ram_data(( 5 * data_width) -1 downto  4 * data_width);
							when "0101" =>
								ram_data_treg <= ram_data(( 6 * data_width) -1 downto  5 * data_width);
							when "0110" =>
								ram_data_treg <= ram_data(( 7 * data_width) -1 downto  6 * data_width);
							when "0111" =>
								ram_data_treg <= ram_data(( 8 * data_width) -1 downto  7 * data_width);
							when "1000" =>
								ram_data_treg <= ram_data(( 9 * data_width) -1 downto  8 * data_width);
							when "1001" =>
								ram_data_treg <= ram_data((10 * data_width) -1 downto  9 * data_width);
							when "1010" =>
								ram_data_treg <= ram_data((11 * data_width) -1 downto 10 * data_width);
							when "1011" =>
								ram_data_treg <= ram_data((12 * data_width) -1 downto 11 * data_width);
							when "1100" =>
								ram_data_treg <= ram_data((13 * data_width) -1 downto 12 * data_width);
							when "1101" =>
								ram_data_treg <= ram_data((14 * data_width) -1 downto 13 * data_width);
							when "1110" =>
								ram_data_treg <= ram_data((15 * data_width) -1 downto 14 * data_width);
							when "1111" =>
								ram_data_treg <= ram_data(ram_data_width -1 downto 15 * data_width);
							when others =>
								ram_data_treg <= (others => '-');
						end case;

						ram_ready_treg <= '1';
						ram_valid_treg <= data_valid_shift(0);
					else
						ram_ready_treg <= '0';
						ram_valid_treg <= '0';
					end if;
				end if;
			end process gen_ram_in_signals;
		end generate ratio16;
	end generate const_rd_mode;



end rtl;
