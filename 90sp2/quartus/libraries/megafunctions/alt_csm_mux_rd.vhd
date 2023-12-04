--------------------------------------------------------------------------------
--
--                 Altera Clock Shared Memory Read Mux Source File
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
--      File Name:          alt_csm_mux_rd.vhd
--      Entity Name:        alt_csm_mux_rd
--
--      Description:
--          This submodule of altcsmem implements the tdm read multiplexor.
--
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.alt_csm_const_pkg.all;
use work.alt_csm_func_pkg.all;


entity alt_csm_mux_rd is
	generic
	(
		addr_width		: natural := 4;
		num_inputs		: natural := 4;
		no_pipe_reg		: boolean := false
	);
	port
	(
		clk				: in  std_logic;
		reset			: in  std_logic;

		select0			: in  std_logic;
		select1			: in  std_logic;
		select2			: in  std_logic;
		select3			: in  std_logic;
		select_out		: out std_logic;

		addr_in0		: in  std_logic_vector(addr_width - 1 downto 0);
		addr_in1		: in  std_logic_vector(addr_width - 1 downto 0);
		addr_in2		: in  std_logic_vector(addr_width - 1 downto 0);
		addr_in3		: in  std_logic_vector(addr_width - 1 downto 0);
		addr_out		: out std_logic_vector(addr_width - 1 downto 0)
	);
end alt_csm_mux_rd;


architecture rtl of alt_csm_mux_rd is

--------------------------------------------------------------------------------
-- Signal and constant declarations
--------------------------------------------------------------------------------

	signal sel			: std_logic_vector(3 downto 0);
	signal select_reg	: std_logic;
	signal addr_reg		: std_logic_vector(addr_width - 1 downto 0);

	type mux_port_type is
	record
		clk				: std_logic;
		reset			: std_logic;
		select0			: std_logic;
		select1			: std_logic;
		select2			: std_logic;
		select3			: std_logic;
		select_out		: std_logic;
		addr_in0		: std_logic_vector(addr_width -1 downto 0);
		addr_in1		: std_logic_vector(addr_width -1 downto 0);
		addr_in2		: std_logic_vector(addr_width -1 downto 0);
		addr_in3		: std_logic_vector(addr_width -1 downto 0);
		addr_out		: std_logic_vector(addr_width -1 downto 0);
	end record;
	signal mux_port		: mux_port_type;

	type mux_port_in_type is
	record
		clk				: std_logic;
		reset			: std_logic;
		select0			: std_logic;
		select1			: std_logic;
		select2			: std_logic;
		select3			: std_logic;
		addr_in0		: std_logic_vector(addr_width -1 downto 0);
		addr_in1		: std_logic_vector(addr_width -1 downto 0);
		addr_in2		: std_logic_vector(addr_width -1 downto 0);
		addr_in3		: std_logic_vector(addr_width -1 downto 0);
	end record;
	signal mux_port_in	: mux_port_in_type;

	type mux_port_out_type is
	record
		select_out		: std_logic;
		addr_out		: std_logic_vector(addr_width -1 downto 0);
	end record;
	signal mux_port_out	: mux_port_out_type;

begin



--------------------------------------------------------------------------------
--
--  Update record
--
	mux_port.clk			<= clk;
	mux_port.reset			<= reset;
	mux_port.select0		<= select0;
	mux_port.select1		<= select1;
	mux_port.select2		<= select2;
	mux_port.select3		<= select3;
	mux_port.select_out		<= select_reg;
	mux_port.addr_in0		<= addr_in0;
	mux_port.addr_in1		<= addr_in1;
	mux_port.addr_in2		<= addr_in2;
	mux_port.addr_in3		<= addr_in3;
	mux_port.addr_out		<= addr_reg;

	mux_port_in.clk			<= clk;
	mux_port_in.reset		<= reset;
	mux_port_in.select0		<= select0;
	mux_port_in.select1		<= select1;
	mux_port_in.select2		<= select2;
	mux_port_in.select3		<= select3;
	mux_port_in.addr_in0	<= addr_in0;
	mux_port_in.addr_in1	<= addr_in1;
	mux_port_in.addr_in2	<= addr_in2;
	mux_port_in.addr_in3	<= addr_in3;

	mux_port_out.addr_out	<= addr_reg;
	mux_port_out.select_out	<= select_reg;

--
--  Initialize the data register on reset otherwise register the result of the
--  multiplexor.
--
	select_out <= select_reg;
	addr_out <= addr_reg;

	sel <= select3 & select2 & select1 & select0;


	four_inputs : if num_inputs = 0 or num_inputs = 4 generate
		mux : process(clk, reset)
		begin
			if reset = c_async_reset_val then
				addr_reg	<= (others => '0');
				select_reg	<= '0';
			elsif clk'event and clk = '1' then
				case sel is
					when "0001" =>
						addr_reg <= addr_in0;

					when "0010" =>
						addr_reg <= addr_in1;

					when "0100" =>
						addr_reg <= addr_in2;

					when "1000" =>
						addr_reg <= addr_in3;

					when others =>
						addr_reg <= (others => '-');
				end case;

				select_reg <= select0 or select1 or select2 or select3;

			end if;
		end process mux;
	end generate four_inputs;


	three_inputs : if num_inputs = 3 generate
		mux : process(clk, reset)
		begin
			if reset = c_async_reset_val then
				addr_reg	<= (others => '0');
				select_reg	<= '0';
			elsif clk'event and clk = '1' then
				case sel(2 downto 0) is
					when "001" =>
						addr_reg <= addr_in0;

					when "010" =>
						addr_reg <= addr_in1;

					when "100" =>
						addr_reg <= addr_in2;

					when others =>
						addr_reg <= (others => '-');
				end case;

				select_reg <= select0 or select1 or select2;

			end if;
		end process mux;
	end generate three_inputs;


	two_inputs : if num_inputs = 2 generate
		mux : process(clk, reset)
		begin
			if reset = c_async_reset_val then
				addr_reg	<= (others => '0');
				select_reg	<= '0';
			elsif clk'event and clk = '1' then
				case sel(1 downto 0) is
					when "01" =>
						addr_reg <= addr_in0;

					when "10" =>
						addr_reg <= addr_in1;

					when others =>
						addr_reg <= (others => '-');
				end case;

				select_reg <= select0 or select1;

			end if;
		end process mux;
	end generate two_inputs;


	one_input : if num_inputs = 1 generate
		no_delay : if no_pipe_reg generate
			addr_reg	<= addr_in0;
			select_reg	<= select0;
		end generate no_delay;

		one_delay : if not no_pipe_reg generate
			mux : process(clk, reset)
			begin
				if reset = c_async_reset_val then
					addr_reg	<= (others => '0');
					select_reg	<= '0';
				elsif clk'event and clk = '1' then
					addr_reg	<= addr_in0;
					select_reg	<= select0;
				end if;
			end process mux;
		end generate one_delay;
	end generate one_input;

end rtl;

