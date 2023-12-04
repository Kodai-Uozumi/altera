begin_group VHDL
begin_group Full Designs
begin_group RAMs and ROMs
begin_template Single-Port RAM
-- Quartus II VHDL Template
-- Single port RAM with single read/write address 

library ieee;
use ieee.std_logic_1164.all;

entity single_port_ram is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);

	port 
	(
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of single_port_ram is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal ram : memory_t;

	-- Register to hold the address 
	signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(we = '1') then
			ram(addr) <= data;
		end if;

		-- Register the address for reading
		addr_reg <= addr;
	end if;
	end process;

	q <= ram(addr_reg);

end rtl;
end_template
begin_template Single-Port RAM w/ Initial Contents
-- Quartus II VHDL Template
-- Single-port RAM with single read/write address and initial contents	

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_ram_with_init is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);

	port 
	(
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end single_port_ram_with_init;

architecture rtl of single_port_ram_with_init is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	function init_ram
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize each address with the address itself
			tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, DATA_WIDTH));
		end loop;
		return tmp;
	end init_ram;	 

	-- Declare the RAM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal ram : memory_t := init_ram;

	-- Register to hold the address 
	signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(we = '1') then
			ram(addr) <= data;
		end if;

		-- Register the address for reading
		addr_reg <= addr;
	end if;
	end process;

	q <= ram(addr_reg);

end rtl;
end_template
begin_template Simple Dual-Port RAM (single clock)
-- Quartus II VHDL Template
-- Simple Dual-Port RAM with different read/write addresses but
-- single read/write clock

library ieee;
use ieee.std_logic_1164.all;

entity simple_dual_port_ram_single_clock is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);

	port 
	(
		clk		: in std_logic;
		raddr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		waddr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end simple_dual_port_ram_single_clock;

architecture rtl of simple_dual_port_ram_single_clock is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal ram : memory_t;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then 
		if(we = '1') then
			ram(waddr) <= data;
		end if;
 
		-- On a read during a write to the same address, the read will
		-- return the OLD data at the address
		q <= ram(raddr);
	end if;
	end process;

end rtl;
end_template
begin_template Simple Dual-Port RAM (dual clock)
-- Quartus II VHDL Template
-- Simple Dual-Port RAM with different read/write addresses and
-- different read/write clock

library ieee;
use ieee.std_logic_1164.all;

entity simple_dual_port_ram_dual_clock is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);

	port 
	(
		rclk	: in std_logic;
		wclk	: in std_logic;
		raddr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		waddr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end simple_dual_port_ram_dual_clock;

architecture rtl of simple_dual_port_ram_dual_clock is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal.	
	signal ram : memory_t;

begin

	process(wclk)
	begin
	if(rising_edge(wclk)) then 
		if(we = '1') then
			ram(waddr) <= data;
		end if;
	end if;
	end process;

	process(rclk)
	begin
	if(rising_edge(rclk)) then 
		q <= ram(raddr);
	end if;
	end process;

end rtl;
end_template
begin_template True Dual-Port RAM (single clock)
-- Quartus II VHDL Template
-- True Dual-Port RAM with single clock
--
-- Read-during-write on port A or B returns newly written data
-- 
-- Read-during-write between A and B returns either new or old data depending
-- on the order in which the simulator executes the process statements.
-- Quartus II will consider this read-during-write scenario as a 
-- don't care condition to optimize the performance of the RAM.  If you
-- need a read-during-write between ports to return the old data, you
-- must instantiate the altsyncram Megafunction directly.

library ieee;
use ieee.std_logic_1164.all;

entity true_dual_port_ram_single_clock is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);

	port 
	(
		clk		: in std_logic;
		addr_a	: in natural range 0 to 2**ADDR_WIDTH - 1;
		addr_b	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data_a	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		data_b	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we_a	: in std_logic := '1';
		we_b	: in std_logic := '1';
		q_a		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		q_b		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end true_dual_port_ram_single_clock;

architecture rtl of true_dual_port_ram_single_clock is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM 
	shared variable ram : memory_t;

begin


	-- Port A
	process(clk)
	begin
	if(rising_edge(clk)) then 
		if(we_a = '1') then
			ram(addr_a) := data_a;
		end if;
		q_a <= ram(addr_a);
	end if;
	end process;

	-- Port B 
	process(clk)
	begin
	if(rising_edge(clk)) then 
		if(we_b = '1') then
			ram(addr_b) := data_b;
		end if;
  	    q_b <= ram(addr_b);
	end if;
	end process;

end rtl;
end_template
begin_template True Dual Port RAM (dual clock)
-- Quartus II VHDL Template
-- True Dual-Port RAM with dual clock
--
-- Read-during-write on port A or B returns newly written data
-- 
-- Read-during-write on port A and B returns unknown data.

library ieee;
use ieee.std_logic_1164.all;

entity true_dual_port_ram_dual_clock is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 6
	);

	port 
	(
		clk_a	: in std_logic;
		clk_b	: in std_logic;
		addr_a	: in natural range 0 to 2**ADDR_WIDTH - 1;
		addr_b	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data_a	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		data_b	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we_a	: in std_logic := '1';
		we_b	: in std_logic := '1';
		q_a		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		q_b		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end true_dual_port_ram_dual_clock;

architecture rtl of true_dual_port_ram_dual_clock is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM 
	shared variable ram : memory_t;

begin

	-- Port A
	process(clk_a)
	begin
	if(rising_edge(clk_a)) then 
		if(we_a = '1') then
			ram(addr_a) := data_a;
		end if;
		q_a <= ram(addr_a);
	end if;
	end process;

	-- Port B
	process(clk_b)
	begin
	if(rising_edge(clk_b)) then 
		if(we_b = '1') then
			ram(addr_b) := data_b;
		end if;
		q_b <= ram(addr_b);
	end if;
	end process;

end rtl;
end_template
begin_template Single-Port ROM
-- Quartus II VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_rom is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 8
	);

	port 
	(
		clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of single_port_rom is

	-- Build a 2-D array type for the RoM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	function init_rom
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize each address with the address itself
			tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, DATA_WIDTH));
		end loop;
		return tmp;
	end init_rom;	 

	-- Declare the ROM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal rom : memory_t := init_rom;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		q <= rom(addr);
	end if;
	end process;

end rtl;
end_template
begin_template Dual-Port ROM
-- Quartus II VHDL Template
-- Dual-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_port_rom is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 8
	);

	port 
	(
		clk		: in std_logic;
		addr_a	: in natural range 0 to 2**ADDR_WIDTH - 1;
		addr_b	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q_a		: out std_logic_vector((DATA_WIDTH -1) downto 0);
		q_b		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of dual_port_rom is

	-- Build a 2-D array type for the ROM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	function init_rom
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize each address with the address itself
			tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, DATA_WIDTH));
		end loop;
		return tmp;
	end init_rom;	 

	-- Declare the ROM signal and specify a default value.	Quartus II
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal rom : memory_t := init_rom;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		q_a <= rom(addr_a);
		q_b <= rom(addr_b);
	end if;
	end process;

end rtl;
end_template
end_group
begin_group Shift Registers
begin_template Basic Shift Register
-- Quartus II VHDL Template
-- Basic Shift Register

library ieee;
use ieee.std_logic_1164.all;

entity basic_shift_register is

	generic
	(
		NUM_STAGES : natural := 64
	);

	port 
	(
		clk		: in std_logic;
		enable	: in std_logic;
		sr_in	    : in std_logic;
		sr_out	: out std_logic
	);

end entity;

architecture rtl of basic_shift_register is

	-- Build an array type for the shift register
	type sr_length is array ((NUM_STAGES-1) downto 0) of std_logic;

	-- Declare the shift register signal
	signal sr: sr_length;

begin

	process (clk)
	begin
		if (rising_edge(clk)) then

			if (enable = '1') then

				-- Shift data by one stage; data from last stage is lost
				sr((NUM_STAGES-1) downto 1) <= sr((NUM_STAGES-2) downto 0);

				-- Load new data into the first stage
				sr(0) <= sr_in;

			end if;
		end if;
	end process;

	-- Capture the data from the last stage, before it is lost
	sr_out <= sr(NUM_STAGES-1);

end rtl;
end_template
begin_template Basic Shift Register with Asynchronous Reset
-- Quartus II VHDL Template
-- One-bit wide, N-bit long shift register with asynchronous reset

library ieee;
use ieee.std_logic_1164.all;

entity basic_shift_register_asynchronous_reset is

	generic
	(
		NUM_STAGES : natural := 64
	);

	port 
	(
		clk	    : in std_logic;
		enable	: in std_logic;
		reset   : in std_logic;
		sr_in	    : in std_logic;
		sr_out	: out std_logic
	);

end entity;

architecture rtl of basic_shift_register_asynchronous_reset is

	-- Build an array type for the shift register
	type sr_length is array ((NUM_STAGES-1) downto 0) of std_logic;

	-- Declare the shift register signal
	signal sr: sr_length;

begin

	process (clk, reset)
	begin
		if (reset = '1') then
			sr <= (others=>'0');
		elsif (rising_edge(clk)) then

			if (enable = '1') then

				-- Shift data by one stage; data from last stage is lost
				sr((NUM_STAGES-1) downto 1) <= sr((NUM_STAGES-2) downto 0);

				-- Load new data into the first stage
				sr(0) <= sr_in;

			end if;
		end if;
	end process;

	-- Capture the data from the last stage, before it is lost
	sr_out <= sr(NUM_STAGES-1);

end rtl;
end_template
begin_template Barrel Shifter
-- Quartus II VHDL Template
-- Barrel Shifter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity barrel_shifter is

	generic
	(
		DIST_WIDTH : natural := 3;
		NUM_STAGES : natural := 8
	);

	port 
	(
		clk			: in std_logic;
		enable		: in std_logic;
		is_left		: in std_logic;
		data		: in std_logic_vector((NUM_STAGES-1) downto 0);
		distance	: in unsigned((DIST_WIDTH-1) downto 0);
		sr_out		: out std_logic_vector((NUM_STAGES-1) downto 0)
	);

end entity;

architecture rtl of barrel_shifter is

	-- Declare the shift register signal
	signal sr : unsigned ((NUM_STAGES-1) downto 0);

begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (enable = '1') then

				-- Perform rotation with functions rol and ror
				if (is_left = '1') then
					sr <= unsigned(data) rol to_integer(distance);
				else
					sr <= unsigned(data) ror to_integer(distance);
				end if;

			end if;
		end if;
	end process;

	sr_out <= std_logic_vector(sr);

end rtl;
end_template
begin_template Basic Shift Register with Multiple Taps
-- Quartus II VHDL Template
-- Basic Shift Register with Multiple Taps

library ieee;
use ieee.std_logic_1164.all;

entity basic_shift_register_with_multiple_taps is

	generic
	(
		DATA_WIDTH : natural := 8;
		NUM_STAGES : natural := 64
	);

	port 
	(
		clk			 : in std_logic;
		enable		 : in std_logic;
		sr_in		 : in std_logic_vector((DATA_WIDTH-1) downto 0);
		sr_tap_one	 : out std_logic_vector((DATA_WIDTH-1) downto 0);
		sr_tap_two	 : out std_logic_vector((DATA_WIDTH-1) downto 0);
		sr_tap_three : out std_logic_vector((DATA_WIDTH-1) downto 0);
		sr_out		 : out std_logic_vector((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of basic_shift_register_with_multiple_taps is

	-- Build a 2-D array type for the shift register
	subtype sr_width is std_logic_vector((DATA_WIDTH-1) downto 0);
	type sr_length is array ((NUM_STAGES-1) downto 0) of sr_width;

	-- Declare the shift register signal
	signal sr: sr_length;

begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (enable = '1') then

				-- Shift data by one stage; data from last stage is lost
				sr((NUM_STAGES-1) downto 1) <= sr((NUM_STAGES-2) downto 0);

				-- Load new data into the first stage
				sr(0) <= sr_in;

			end if;
		end if;
	end process;

	-- Capture data from multiple stages in the shift register
	sr_tap_one <= sr((NUM_STAGES/4)-1);
	sr_tap_two <= sr((NUM_STAGES/2)-1);
	sr_tap_three <= sr((3*NUM_STAGES/4)-1);
	sr_out <= sr(NUM_STAGES-1);

end rtl;
end_template
end_group
begin_group State Machines
begin_template Four-State Mealy State Machine
-- Quartus II VHDL Template
-- Four-State Mealy State Machine

-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;

entity four_state_mealy_state_machine is

	port
	(
		clk		 : in	std_logic;
		input	 : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic_vector(1 downto 0)
	);

end entity;

architecture rtl of four_state_mealy_state_machine is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3);

	-- Register to hold the current state
	signal state : state_type;

begin

	process (clk, reset)
	begin

		if reset = '1' then
			state <= s0;

		elsif (rising_edge(clk)) then

			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when s0=>
					if input = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					if input = '1' then
						state <= s2;
					else
						state <= s1;
					end if;
				when s2=>
					if input = '1' then
						state <= s3;
					else
						state <= s2;
					end if;
				when s3=>
					if input = '1' then
						state <= s3;
					else
						state <= s1;
					end if;
			end case;

		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state, input)
	begin
			case state is
				when s0=>
					if input = '1' then
						output <= "00";
					else
						output <= "01";
					end if;
				when s1=>
					if input = '1' then
						output <= "01";
					else
						output <= "11";
					end if;
				when s2=>
					if input = '1' then
						output <= "10";
					else
						output <= "10";
					end if;
				when s3=>
					if input = '1' then
						output <= "11";
					else
						output <= "10";
					end if;
			end case;
	end process;

end rtl;
end_template
begin_template Four-State Moore State Machine
-- Quartus II VHDL Template
-- Four-State Moore State Machine

-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;

entity four_state_moore_state_machine is

	port(
		clk		 : in	std_logic;
		input	 : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic_vector(1 downto 0)
	);

end entity;

architecture rtl of four_state_moore_state_machine is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3);

	-- Register to hold the current state
	signal state   : state_type;

begin

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk)) then
			case state is
				when s0=>
					if input = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					if input = '1' then
						state <= s2;
					else
						state <= s1;
					end if;
				when s2=>
					if input = '1' then
						state <= s3;
					else
						state <= s2;
					end if;
				when s3 =>
					if input = '1' then
						state <= s0;
					else
						state <= s3;
					end if;
			end case;
		end if;
	end process;

	-- Output depends solely on the current state
	process (state)
	begin
		case state is
			when s0 =>
				output <= "00";
			when s1 =>
				output <= "01";
			when s2 =>
				output <= "10";
			when s3 =>
				output <= "11";
		end case;
	end process;

end rtl;
end_template
begin_template Safe State Machine
-- Quartus II VHDL Template
-- Safe State Machine

library ieee;
use ieee.std_logic_1164.all;

entity safe_state_machine is

	port(
		clk		 : in	std_logic;
		input	 : in	std_logic;
		reset	 : in	std_logic;
		output	 : out	std_logic_vector(1 downto 0)
	);

end entity;

architecture rtl of safe_state_machine is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2);

	-- Register to hold the current state
	signal state   : state_type;

	-- Attribute "safe" implements a safe state machine.
	-- This is a state machine that can recover from an
	-- illegal state (by returning to the reset state).
	attribute syn_encoding : string;
	attribute syn_encoding of state_type : type is "safe";

begin

	-- Logic to advance to the next state
	process (clk, reset)
	begin
		if reset = '1' then
			state <= s0;
		elsif (rising_edge(clk)) then
			case state is
				when s0=>
					if input = '1' then
						state <= s1;
					else
						state <= s0;
					end if;
				when s1=>
					if input = '1' then
						state <= s2;
					else
						state <= s1;
					end if;
				when s2=>
					if input = '1' then
						state <= s0;
					else
						state <= s2;
					end if;
			end case;
		end if;
	end process;

	-- Logic to determine output
	process (state)
	begin
		case state is
			when s0 =>
				output <= "00";
			when s1 =>
				output <= "01";
			when s2 =>
				output <= "10";
		end case;
	end process;

end rtl;
end_template
begin_template User-Encoded State Machine
-- Quartus II VHDL Template
-- User-Encoded State Machine

library ieee;
use ieee.std_logic_1164.all;

entity user_encoded_state_machine is

	port 
	(
		updown	  : in std_logic;
		clock	  : in std_logic;
		lsb		  : out std_logic;
		msb		  : out std_logic
	);

end entity;

architecture rtl of user_encoded_state_machine is

	-- Build an enumerated type for the state machine
	type count_state is (zero, one, two, three);

	-- Registers to hold the current state and the next state
	signal present_state, next_state	   : count_state;

	-- Attribute to declare a specific encoding for the states
	attribute syn_encoding				  : string;
	attribute syn_encoding of count_state : type is "11 01 10 00";

begin

	-- Determine what the next state will be, and set the output bits
	process (present_state, updown)
	begin
		case present_state is
			when zero =>
				if (updown = '0') then
					next_state <= one;
					lsb <= '0';
					msb <= '0';
				else
					next_state <= three;
					lsb <= '1';
					msb <= '1';
				end if;
			when one =>
				if (updown = '0') then
					next_state <= two;
					lsb <= '1';
					msb <= '0';
				else
					next_state <= zero;
					lsb <= '0';
					msb <= '0';
				end if;
			when two =>
				if (updown = '0') then
					next_state <= three;
					lsb <= '0';
					msb <= '1';
				else
					next_state <= one;
					lsb <= '1';
					msb <= '0';
				end if;
			when three =>
				if (updown = '0') then
					next_state <= zero;
					lsb <= '1';
					msb <= '1';
				else
					next_state <= two;
					lsb <= '0';
					msb <= '1';
				end if;
		end case;
	end process;

	-- Move to the next state
	process
	begin
		wait until rising_edge(clock);
		present_state <= next_state;
	end process;

end rtl;
end_template
end_group
begin_group Arithmetic
begin_group Adders
begin_template Signed Adder
-- Quartus II VHDL Template
-- Signed Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_adder is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a	   : in signed	((DATA_WIDTH-1) downto 0);
		b	   : in signed	((DATA_WIDTH-1) downto 0);
		result : out signed ((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of signed_adder is
begin

	result <= a + b;

end rtl;
end_template
begin_template Unsigned Adder
-- Quartus II VHDL Template
-- Unsigned Adder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unsigned_adder is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a	   : in unsigned  ((DATA_WIDTH-1) downto 0);
		b	   : in unsigned  ((DATA_WIDTH-1) downto 0);
		result : out unsigned ((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of unsigned_adder is
begin

	result <= a + b;

end rtl;
end_template
begin_template Signed Adder/Subtractor
-- Quartus II VHDL Template
-- Signed Adder/Subtractor

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_adder_subtractor is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a		: in signed ((DATA_WIDTH-1) downto 0);
		b		: in signed ((DATA_WIDTH-1) downto 0);
		add_sub : in std_logic;
		result	: out signed ((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of signed_adder_subtractor is
begin

	process(a,b,add_sub)
	begin
		-- Add if "add_sub" is 1, else subtract
		if (add_sub = '1') then
			result <= a + b;
		else
			result <= a - b;
		end if;
	end process;

end rtl;
end_template
begin_template Unsigned Adder/Subtractor
-- Quartus II VHDL Template
-- Unsigned Adder/Subtractor

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unsigned_adder_subtractor is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a		: in unsigned ((DATA_WIDTH-1) downto 0);
		b		: in unsigned ((DATA_WIDTH-1) downto 0);
		add_sub : in std_logic;
		result	: out unsigned ((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of unsigned_adder_subtractor is
begin

	process(a,b,add_sub)
	begin
		-- add if "add_sub" is 1, else subtract
		if (add_sub = '1') then
			result <= a + b;
		else
			result <= a - b;
		end if;
	end process;

end rtl;
end_template
begin_template Pipelined Binary Adder Tree
-- Quartus II VHDL Template
-- Pipelined Binary Adder Tree

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipelined_binary_adder_tree is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a	   : in unsigned ((DATA_WIDTH-1) downto 0);
		b	   : in unsigned ((DATA_WIDTH-1) downto 0);
		c	   : in unsigned ((DATA_WIDTH-1) downto 0);
		d	   : in unsigned ((DATA_WIDTH-1) downto 0);
		e	   : in unsigned ((DATA_WIDTH-1) downto 0);
		clk	   : in std_logic;
		result : out unsigned ((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of pipelined_binary_adder_tree is

	-- Declare registers to hold intermediate sums
	signal sum1, sum2, sum3 : unsigned ((DATA_WIDTH-1) downto 0);

begin

	process (clk)
	begin
		if (rising_edge(clk)) then

			-- Generate and store intermediate values in the pipeline
			sum1 <= a + b;
			sum2 <= c + d;
			sum3 <= sum1 + sum2;

			-- Generate and store the last value, the result
			result <= sum3 + e;

		end if;
	end process;

end rtl;
end_template
end_group
begin_group Counters
begin_template Binary Counter
-- Quartus II VHDL Template
-- Binary Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_counter is

	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := 255
	);

	port
	(
		clk		  : in std_logic;
		reset	  : in std_logic;
		enable	  : in std_logic;
		q		  : out integer range MIN_COUNT to MAX_COUNT
	);

end entity;

architecture rtl of binary_counter is
begin

	process (clk)
		variable   cnt		   : integer range MIN_COUNT to MAX_COUNT;
	begin
		if (rising_edge(clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			elsif enable = '1' then
				-- Increment the counter if counting is enabled			   
				cnt := cnt + 1;

			end if;
		end if;

		-- Output the current count
		q <= cnt;
	end process;

end rtl;
end_template
begin_template Binary Up/Down Counter
-- Quartus II VHDL Template
-- Binary Up/Down Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_up_down_counter is

	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := 255
	);

	port
	(
		clk		   : in std_logic;
		reset	   : in std_logic;
		enable	   : in std_logic;
		updown	   : in std_logic;
		q		   : out integer range MIN_COUNT to MAX_COUNT
	);

end entity;

architecture rtl of binary_up_down_counter is
	signal direction : integer;
begin

	process (updown)
	begin
		-- Determine the increment/decrement of the counter
		if (updown = '1') then
			direction <= 1;
		else
			direction <= -1;
		end if;
	end process;


	process (clk)
		variable   cnt			: integer range MIN_COUNT to MAX_COUNT;
	begin
		
		-- Synchronously update counter
		if (rising_edge(clk)) then

			if reset = '1' then
				-- Reset the counter to 0
				cnt := 0;

			elsif enable = '1' then
				-- Increment/decrement the counter
				cnt := cnt + direction;

			end if;
		end if;

		-- Output the current count
		q <= cnt;
	end process;

end rtl;
end_template
begin_template Binary Up/Down Counter with Saturation
-- Quartus II VHDL Template
-- Binary Up/Down Counter with Saturation

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_up_down_counter_with_saturation is

	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := 255
	);

	port 
	(
		clk		   : in std_logic;
		reset	   : in std_logic;
		enable	   : in std_logic;
		updown	   : in std_logic;
		q		   : out integer range MIN_COUNT to MAX_COUNT
	);

end entity;

architecture rtl of binary_up_down_counter_with_saturation is
	signal direction : integer;
	signal limit : integer range MIN_COUNT to MAX_COUNT;
begin

	process (updown)
	begin
		-- Set counter increment/decrement, and corresponding limit
		if (updown = '1') then
			direction <= 1;
			limit <= MAX_COUNT;
		else
			direction <= -1;
			limit <= MIN_COUNT;
		end if;
	end process;


	process (clk)
		variable cnt : integer range MIN_COUNT to MAX_COUNT;
	begin

		-- Synchronously update the counter
		if (rising_edge(clk)) then

			if (reset = '1') then
				-- Reset the counter to 0
				cnt := 0;

			elsif (enable = '1' and cnt /= limit) then
				-- Increment/decrement the counter, 
				-- if the limit is not exceeded
				cnt := cnt + direction;

			end if;
		end if;

		-- Output the current count
		q <= cnt;
	end process;

end rtl;
end_template
begin_template Gray Counter
-- Quartus II VHDL Template
-- Gray Counter

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gray_counter is

	generic
	(
		WIDTH : natural := 8
	);

	port 
	(
		clk		   : in std_logic;
		reset	   : in std_logic;
		enable	   : in std_logic;
		gray_count : out std_logic_vector(WIDTH-1 downto 0)
	);

end entity;

-- Implementation:

-- There is an imaginary bit in the counter, at q(0), that resets to 1
-- (unlike the rest of the bits of the counter) and flips every clock cycle.
-- The decision of whether to flip any non-imaginary bit in the counter
-- depends solely on the bits below it, down to the imaginary bit.	It flips
-- only if all these bits, taken together, match the pattern 10* (a one
-- followed by any number of zeros).

-- Almost every non-imaginary bit has a component instance that sets the 
-- bit based on the values of the lower-order bits, as described above.
-- The rules have to differ slightly for the most significant bit or else 
-- the counter would saturate at it's highest value, 1000...0.

architecture rtl of gray_counter is
  
	-- q contains all the values of the counter, plus the imaginary bit
	-- (values are shifted to make room for the imaginary bit at q(0))
	signal q  : std_logic_vector (WIDTH downto 0);

	-- no_ones_below(x) = 1 iff there are no 1's in q below q(x)
	signal no_ones_below  : std_logic_vector (WIDTH downto 0);

	-- q_msb is a modification to make the msb logic work
	signal q_msb : std_logic;
  
begin

	q_msb <= q(WIDTH-1) or q(WIDTH);

	process(clk, reset, enable)
	begin

		if(reset = '1') then

			-- Resetting involves setting the imaginary bit to 1
			q(0) <= '1';
			q(WIDTH downto 1) <= (others => '0');

		elsif(rising_edge(clk) and enable='1') then

			-- Toggle the imaginary bit
			q(0) <= not q(0);
	  
			for i in 1 to WIDTH loop

				-- Flip q(i) if lower bits are a 1 followed by all 0's
				q(i) <= q(i) xor (q(i-1) and no_ones_below(i-1));
		
			end loop;  -- i

			q(WIDTH) <= q(WIDTH) xor (q_msb and no_ones_below(WIDTH-1));

		end if;

	end process;

	-- There are never any 1's beneath the lowest bit
	no_ones_below(0) <= '1';

	process(q, no_ones_below)
	begin
		for j in 1 to WIDTH loop
			no_ones_below(j) <= no_ones_below(j-1) and not q(j-1);
		end loop;
	end process;

	-- Copy over everything but the imaginary bit
	gray_count <= q(WIDTH downto 1);
	  
end rtl;
end_template
end_group
begin_group Multipliers
begin_template Unsigned Multiply
-- Quartus II VHDL Template
-- Unsigned Multiply

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unsigned_multiply is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a	   : in unsigned ((DATA_WIDTH-1) downto 0);
		b	   : in unsigned ((DATA_WIDTH-1) downto 0);
		result  : out unsigned ((2*DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of unsigned_multiply is
begin

	result <= a * b;

end rtl;
end_template
begin_template Signed Multiply
-- Quartus II VHDL Template
-- Signed Multiply

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_multiply is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a	   : in signed ((DATA_WIDTH-1) downto 0);
		b	   : in signed ((DATA_WIDTH-1) downto 0);
		result  : out signed ((2*DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of signed_multiply is
begin

	result <= a * b;

end rtl;
end_template
begin_template Unsigned Multiply with Input and Output Registers
-- Quartus II VHDL Template
-- Unsigned Multiply with Input and Output Registers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unsigned_multiply_with_input_and_output_registers is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a		: in unsigned ((DATA_WIDTH-1) downto 0);
		b		: in unsigned ((DATA_WIDTH-1) downto 0);
		clk		: in std_logic;
		clear	    : in std_logic;
		result	: out unsigned ((2*DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of unsigned_multiply_with_input_and_output_registers is

	-- Declare I/O registers
	signal a_reg, b_reg : unsigned ((DATA_WIDTH-1) downto 0);
	signal out_reg	  : unsigned ((2*DATA_WIDTH-1) downto 0);

begin

	process (clk, clear)
	begin
		if (clear ='1') then

			-- Reset all register data to 0
			a_reg <= (others => '0');
			b_reg <= (others => '0');
			out_reg <= (others => '0');

		elsif (rising_edge(clk)) then

			-- Store input and output values in registers
			a_reg <= a;
			b_reg <= b;
			out_reg <= a_reg * b_reg;

		end if;
	end process;

	-- Output multiplication result
	result <= out_reg;

end rtl;
end_template
begin_template Signed Multiply with Input and Output Registers
-- Quartus II VHDL Template
-- Signed Multiply with Input and Output Registers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_multiply_with_input_and_output_registers is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	( 
		a		: in signed ((DATA_WIDTH-1) downto 0);
		b		: in signed ((DATA_WIDTH-1) downto 0);
		clk		: in std_logic;
		clear	    : in std_logic;
		result	: out signed ((2*DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of signed_multiply_with_input_and_output_registers is

	-- Declare I/O registers
	signal a_reg, b_reg : signed ((DATA_WIDTH-1) downto 0);
	signal out_reg	  : signed ((2*DATA_WIDTH-1) downto 0);

begin

	process (clk, clear)
	begin
		if (clear = '1') then

			-- Reset all register data to 0
			a_reg <= (others => '0');
			b_reg <= (others => '0');
			out_reg <= (others => '0');

		elsif (rising_edge(clk)) then

			-- Store input and output values in registers
			a_reg <= a;
			b_reg <= b;
			out_reg <= a_reg * b_reg;

		end if;
	end process;

	-- Output multiplication result
	result <= out_reg;

end rtl;
end_template
begin_template Multiplier for Complex Numbers
-- Quartus II VHDL Template
-- Multiplier for complex numbers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier_for_complex_numbers is

	generic
	(
		WIDTH : natural := 18
	);

	port 
	(
		clk, ena	                    : in std_logic;

		-- dataa and datab each have a real and imaginary part
		dataa_real, dataa_img	: in signed ((WIDTH-1) downto 0);
		datab_real, datab_img	: in signed ((WIDTH-1) downto 0);

		dataout_real, dataout_img	: out signed ((2*WIDTH-1) downto 0)
	);

end entity;

architecture rtl of multiplier_for_complex_numbers is
begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (ena = '1') then

				-- Calculate both the real and imaginary parts of the product
				dataout_real <= dataa_real * datab_real - dataa_img * datab_img;
				dataout_img <= dataa_real * datab_img + datab_real * dataa_img;

			end if;
		end if;
	end process;
end rtl;
end_template
end_group
begin_group Multiply Accumulators
begin_template Unsigned Multiply-Accumulate
-- Quartus II VHDL Template
-- Unsigned Multiply-Accumulate

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unsigned_multiply_accumulate is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a		   : in unsigned ((DATA_WIDTH-1) downto 0);
		b		   : in unsigned ((DATA_WIDTH-1) downto 0);
		clk		   : in std_logic;
		sload	   : in std_logic;
		accum_out    : out unsigned ((2*DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of unsigned_multiply_accumulate is

	-- Declare registers for intermediate values
	signal mult_reg : unsigned ((2*DATA_WIDTH-1) downto 0);
	signal adder_out : unsigned ((2*DATA_WIDTH-1) downto 0);
	signal old_result : unsigned ((2*DATA_WIDTH-1) downto 0);

begin

	mult_reg <= a * b;

	process (adder_out, sload)
	begin
		if (sload = '1') then
			-- Clear the accumulated data
			old_result <= (others => '0');
		else
			old_result <= adder_out;
		end if;
	end process;

	process (clk)
	begin
		if (rising_edge(clk)) then

			-- Store accumulation result in a register
			adder_out <= old_result + mult_reg;

		end if;
	end process;

	-- Output accumulation result
	accum_out <= adder_out;

end rtl;
end_template
begin_template Signed Multiply-Accumulate
-- Quartus II VHDL Template
-- Signed Multiply-Accumulate

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity signed_multiply_accumulate is

	generic
	(
		DATA_WIDTH : natural := 8
	);

	port 
	(
		a		   : in signed((DATA_WIDTH-1) downto 0);
		b		   : in signed ((DATA_WIDTH-1) downto 0);
		clk		   : in std_logic;
		sload	   : in std_logic;
		accum_out    : out signed ((2*DATA_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of signed_multiply_accumulate is

	-- Declare registers for intermediate values
	signal mult_reg : signed ((2*DATA_WIDTH-1) downto 0);
	signal adder_out : signed ((2*DATA_WIDTH-1) downto 0);
	signal old_result : signed ((2*DATA_WIDTH-1) downto 0);

begin

	mult_reg <= a * b;

	process (adder_out, sload)
	begin
		if (sload = '1') then
			-- Clear the accumulated data
			old_result <= (others => '0');
		else
			old_result <= adder_out;
		end if;
	end process;

	process (clk)
	begin
		if (rising_edge(clk)) then

			-- Store accumulation result in a register
			adder_out <= old_result + mult_reg;

		end if;
	end process;

	-- Output accumulation result
	accum_out <= adder_out;

end rtl;
end_template
begin_template Sum-of-Four Multiply-Accumulate
-- Quartus II VHDL Template
-- Sum-of-four multiply-accumulate
-- For use with the Stratix III device family

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum_of_four_multiply_accumulate is

	generic
	(
		INPUT_WIDTH	  : natural := 18;
		OUTPUT_WIDTH   : natural := 44
	);

	port
	(
		clk, ena		       : in std_logic;
		a, b, c, d, e, f, g, h	: in signed ((INPUT_WIDTH-1) downto 0);
		dataout			: out signed ((OUTPUT_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of sum_of_four_multiply_accumulate is

	-- Each product can be up to 2*INPUT_WIDTH bits wide.
	-- The sum of four of these products can be up to 2 bits wider.
	signal mult_sum : signed ((2*INPUT_WIDTH+1) downto 0); 

	signal accum_reg : signed ((OUTPUT_WIDTH-1) downto 0);

	-- At least one product (of the four we're adding together) 
	-- must be as wide as the sum
	signal resized_a_times_b : signed ((2*INPUT_WIDTH+1) downto 0);
begin

	-- Resize the product a*b so we won't lose carry bits when adding
	resized_a_times_b <= RESIZE(a * b, 2*INPUT_WIDTH+2);

	-- Store the results of the operations on the current inputs
	mult_sum <= (resized_a_times_b + c *d) + (e * f + g * h);

	-- Store the value of the accumulation in a register
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (ena = '1') then
				accum_reg <= accum_reg + mult_sum;
			end if;
		end if;
	end process;

	dataout <= accum_reg;
end rtl;
end_template
begin_template Sum-of-Four Multiply-Accumulate with Asynchronous Reset
-- Quartus II VHDL Template
-- Sum-of-four multiply-accumulate with asynchronous reset
-- For use with the Stratix III device family

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum_of_four_multiply_accumulate_with_asynchronous_reset is

	generic
	(
		INPUT_WIDTH	  : natural := 18;
		OUTPUT_WIDTH   : natural := 44
	);

	port
	(
		clk, ena, aclr		: in std_logic;
		a, b, c, d, e, f, g, h	: in signed ((INPUT_WIDTH-1) downto 0);
		dataout			: out signed ((OUTPUT_WIDTH-1) downto 0)
	);

end entity;

architecture rtl of sum_of_four_multiply_accumulate_with_asynchronous_reset is

	-- Each product can be up to 2*INPUT_WIDTH bits wide.
	-- The sum of four of these products can be up to 2 bits wider.
	signal mult_sum : signed ((2*INPUT_WIDTH+1) downto 0); 

	signal accum_reg : signed ((OUTPUT_WIDTH-1) downto 0);

	-- At least one product (of the four we're adding together) 
	-- must be as wide as the sum
	signal resized_a_times_b : signed ((2*INPUT_WIDTH+1) downto 0);
begin

	-- Resize the product a*b so we won't lose carry bits when adding
	resized_a_times_b <= RESIZE(a * b, 2*INPUT_WIDTH+2);

	-- Store the results of the operations on the current inputs
	mult_sum <= (resized_a_times_b + c *d) + (e * f + g * h);

	-- Store the value of the accumulation in a register
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (ena = '1') then
				if (aclr = '1') then
					accum_reg <= RESIZE(mult_sum, accum_reg'length);
				else
					accum_reg <= accum_reg + mult_sum;
				end if;
			end if;
		end if;
	end process;

	dataout <= accum_reg;
end rtl;
end_template
end_group
begin_group Sums of Multipliers
begin_template Sum of Four Multipliers
-- Quartus II VHDL Template
-- Sum of four multipliers

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum_of_four_multipliers is

	generic
	(
		WIDTH : natural := 18
	);

	port
	(
		clk, ena		        : in std_logic;
		a, b, c, d, e, f, g, h	: in signed ((WIDTH-1) downto 0);
		dataout			: out signed ((2*WIDTH+1) downto 0)
	);

end entity;

architecture rtl of sum_of_four_multipliers is

	-- At least one product (of the four we're adding together) 
	-- must be as wide as the sum
	signal resized_a_times_b : signed ((2*WIDTH+1) downto 0);

begin

	-- Resize the product a*b so we won't lose carry bits when adding
	resized_a_times_b <= RESIZE(a * b, 2*WIDTH+2);

	-- dataout is the sum of four products
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (ena = '1') then
				dataout <= (resized_a_times_b + c *d) + (e * f + g * h);
			end if;
		end if;
	end process;

end rtl;
end_template
begin_template Sum of Four Multipliers in Scan Chain Mode
-- Quartus II VHDL Template
-- Sum of four multipliers in scan chain mode
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum_of_four_multipliers_scan_chain is

	generic
	(
		WIDTH : natural := 18
	);

	port
	(
		clk, ena		        : in std_logic;
		dataa			: in signed ((WIDTH-1) downto 0);
		c0, c1, c2, c3		: in signed ((WIDTH-1) downto 0);
		dataout			: out signed ((2*WIDTH+1) downto 0)
	);

end entity;

architecture rtl of sum_of_four_multipliers_scan_chain is
	-- Four scan chain registers
	signal a0, a1, a2, a3 : signed ((WIDTH-1) downto 0);

	-- At least one product (of the four we're adding together) 
	-- must be as wide as the sum
	signal resized_a3_times_c3 : signed ((2*WIDTH+1) downto 0);
begin

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (ena = '1') then

				-- The scan chain (which mimics a shift register)
				a0 <= dataa;
				a1 <= a0;
				a2 <= a1;
				a3 <= a2;
				
				-- Resize product a3*c3 so we won't lose carry bits
				resized_a3_times_c3 <= RESIZE(a3 * c3, 2*WIDTH+2);

				-- The order of the operands is important for correct inference
				dataout <= (resized_a3_times_c3 + a2 * c2) + (a1 * c1 + a0 * c0); 
			end if;
		end if;
	end process;
end rtl;
end_template
begin_template Sum of Eight Multipliers in Chainout Mode
-- Quartus II VHDL Template
-- Sum of eight multipliers in chainout mode

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum_of_eight_multipliers_chainout is

	generic
	(
		WIDTH : natural := 18
	);

	port
	(
		clk, ena			        : in std_logic;
		a0, a1, a2, a3, a4, a5, a6, a7	: in signed ((WIDTH-1) downto 0);
		b0, b1, b2, b3 ,b4, b5, b6, b7	: in signed ((WIDTH-1) downto 0);
		dataout				: out signed ((2*WIDTH+2) downto 0)
	);

end entity;

architecture rtl of sum_of_eight_multipliers_chainout is 

	-- Declare signals for intermediate values
	signal sum1, sum2 : signed ((2*WIDTH+2) downto 0);

	-- At least two products (of the eight we're adding together) 
	-- must be as wide as the sum
	signal resized_a0_times_b0 : signed ((2*WIDTH+2) downto 0);
	signal resized_a4_times_b4 : signed ((2*WIDTH+2) downto 0);

begin

	-- Resize products a0*b0 and a4*b4 so we won't lose carry bits 
	resized_a0_times_b0 <= RESIZE(a0 * b0, 2*WIDTH+3);
	resized_a4_times_b4 <= RESIZE(a4 * b4, 2*WIDTH+3);

	-- Store the results of the first two sums
	sum1 <= (resized_a0_times_b0 + a1 * b1) + (a2 * b2 + a3 * b3);
	sum2 <= (resized_a4_times_b4 + a5 * b5) + (a6 * b6 + a7 * b7);

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (ena = '1') then
				dataout <= sum1 + sum2;
			end if;
		end if;
	end process;
end rtl;
end_template
begin_template Sum of Two Multipliers with a Wide Datapath
-- Quartus II VHDL Template
-- Sum of two multipliers with a wide datapath

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sum_of_two_multipliers_wide_datapath is

	generic
	(
		WIDTH_A	: natural := 36;
		WIDTH_B	: natural := 18
	);

	port
	(
		clk, ena	        : in std_logic;
		a0, a1		: in signed ((WIDTH_A-1) downto 0);
		b0, b1		: in signed ((WIDTH_B-1) downto 0);
		dataout		: out signed ((WIDTH_A+WIDTH_B) downto 0)
	);

end entity;

architecture rtl of sum_of_two_multipliers_wide_datapath is
	-- At least one product (of the two we're adding together) 
	-- must be as wide as the sum
	signal resized_a0_times_b0 : signed ((WIDTH_A+WIDTH_B) downto 0);
begin

	-- Resize the product a0*b0 so we won't lose carry bits when adding
	resized_a0_times_b0 <= RESIZE(a0 * b0, WIDTH_A+WIDTH_B+1);

	process (clk)
	begin
		if (rising_edge(clk)) then
			if (ena = '1') then
				dataout <= resized_a0_times_b0 + a1 * b1;
			end if;
		end if;
	end process;
end rtl;
end_template
end_group
end_group
begin_group Configurations
begin_group Configuration Declarations
begin_template Configurable Gate Architecture
-- Quartus II VHDL Template
-- Configurable gate architecture

library ieee;
use ieee.std_logic_1164.all;
entity configurable_gate is
	port 
	(
		i1 : in std_logic;
		i2 : in std_logic;
		o1 : out std_logic
	);
end configurable_gate;


-- Three possible architectures
architecture and_gate of configurable_gate is
begin
	o1 <= i1 AND i2;
end and_gate;

architecture or_gate of configurable_gate is
begin
	o1 <= i1 OR i2;
end or_gate;

architecture xor_gate of configurable_gate is
begin
	o1 <= i1 XOR i2;
end xor_gate;


-- A block configuration is used to choose between the architectures.
configuration cfg of configurable_gate is  -- Configuration Declaration
	for or_gate                              	     -- Block Configuration
	end for;
end cfg;
end_template
begin_template Configurable Component Gates
-- Quartus II VHDL Template
-- Configurable component gates

entity configurable_component_gates1 is
	port
	(
		i1, i2 : in bit;
		o1, o2 : out bit
	);
end configurable_component_gates1;

architecture rtl of configurable_component_gates1 is
	component cgate is
	port 
	(
		i1, i2 : in bit;
		o      : out bit
	);
	end component;
begin
	-- Each instance can be mapped to a different 
	-- entity and/or architecture
	inst1 : cgate
	port map
	(
		i1 => i1,
		i2 => i2,
		o  => o1
	);

	inst2 : cgate
	port map
	(
		i1 => i1,
		i2 => i2,
		o  => o2
	);
end rtl;



-- An entity that corresponds to the above component
entity configurable_gate is
	port 
	(
		i1, i2 : in bit;
		o      : out bit
	);
end configurable_gate;


-- Three possible architectures
architecture and_gate of configurable_gate is
begin
	o <= i1 AND i2;
end and_gate;

architecture or_gate of configurable_gate is
begin
	o <= i1 OR i2;
end or_gate;

architecture xor_gate of configurable_gate is
begin
	o <= i1 XOR i2;
end xor_gate;



-- This component configuration matches different component instances
-- with different architectures of one entity.
configuration cfg of configurable_component_gates1 is
	for rtl
		for inst1 : cgate use entity work.configurable_gate(and_gate);
		end for;
		for inst2 : cgate use entity work.configurable_gate(xor_gate);
		end for;
	end for;
end cfg;
end_template
begin_template Configurable Component Ports
-- Quartus II VHDL Template
-- Configurable names for ports of a binary counter

library ieee;
use ieee.std_logic_1164.all;
entity configurable_counter_ports1 is
	port
	(
		i1 : in std_logic;
		i2 : in std_logic;
		i3 : in std_logic;
		o  : out integer
	);
end configurable_counter_ports1;

architecture rtl of configurable_counter_ports1 is
	component c     -- A very generic component!  
	port 
	(
		i1,i2,i3 : in std_logic;    -- These port names won't match the ports
		o        : out integer      -- of the instantiated entity.
	);
	end component;
begin

	inst1 : c
	port map 
	(
		i1 => i1,
		i2 => i2,
		i3 => i3,
		o  => o
	);

end rtl;


-- Component configurations bind component ports correctly
configuration cfg of configurable_counter_ports1 is
	for rtl
		-- Specify that the component will be a counter
		for inst1 : c use entity work.binary_counter(rtl)
		-- Specify how the counter's port names correspond
		-- to the component's port names
		port map (                  
			clk => i1,
			reset => i2,
			enable => i3,
			q => o
		);
		end for;
	end for;
end cfg;



-- The binary counter:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_counter is
	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := integer'high
	);
	port
	(
		clk		  : in std_logic;
		reset	      : in std_logic;
		enable	  : in std_logic;
		q		  : out integer range MIN_COUNT to MAX_COUNT
	);
end entity;

architecture rtl of binary_counter is
begin
	process (clk)
		variable  cnt : integer range MIN_COUNT to MAX_COUNT;
	begin
		if (rising_edge(clk)) then
			if reset = '1' then
				cnt := 0;
			elsif enable = '1' then
				cnt := cnt + 1;
			end if;
		end if;

		q <= cnt;
	end process;
end rtl;
end_template
end_group
begin_group Configuration Specifications
begin_template Configurable Component Gates
-- Quartus II VHDL Template
-- Configurable component gates

entity configurable_component_gates2 is
	port
	(
		i1, i2 : in bit;
		o1, o2 : out bit
	);
end configurable_component_gates2;

architecture rtl of configurable_component_gates2 is
	component cgate is
	port 
	(
		i1, i2 : in bit;
		o      : out bit
	);
	end component;

	-- Bind component instances to entity/architecture pairs.
	-- In this case, both instances are bound to the same entity, but
	-- different architectures.
	for inst1 : cgate use entity work.configurable_gate(and_gate);
	for inst2 : cgate use entity work.configurable_gate(xor_gate);

begin

	inst1 : cgate
	port map
	(
		i1 => i1,
		i2 => i2,
		o  => o1
	);

	inst2 : cgate
	port map
	(
		i1 => i1,
		i2 => i2,
		o  => o2
	);

end rtl;



entity configurable_gate is
	port 
	(
		i1, i2 : in bit;
		o      : out bit
	);
end configurable_gate;


-- Three possible architectures
architecture and_gate of configurable_gate is
begin
	o <= i1 and i2;
end and_gate;

architecture or_gate of configurable_gate is
begin
	o <= i1 or i2;
end or_gate;

architecture xor_gate of configurable_gate is
begin
	o <= i1 xor i2;
end xor_gate;
end_template
begin_template Configurable Component Ports
-- Quartus II VHDL Templates
-- Configurable port names for a binary counter

library ieee;
use ieee.std_logic_1164.all;
entity configurable_counter_ports2 is
	port
	(
		i1 : in std_logic;
		i2 : in std_logic;
		i3 : in std_logic;
		o  : out integer
	);
end configurable_counter_ports2;

architecture rtl of configurable_counter_ports2 is
	component c     -- A very generic component!
	port (
		i1,i2,i3 : in std_logic;    -- These port names won't match the ports
		o        : out integer      -- of the instantiated entity.
	);
	end component;

	-- Bind the generic component to a specific entity (a counter)
	for inst1 : c use entity work.binary_counter(rtl)
	port map (
		clk => i1,      -- Show how the counter's port names correspond
		reset => i2,    -- to the component's port names
		enable => i3,
		q => o
	);
begin
	inst1 : c
	port map (
		i1 => i1,
		i2 => i2,
		i3 => i3,
		o  => o
	);
end rtl;



-- The binary counter:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity binary_counter is
	generic
	(
		MIN_COUNT : natural := 0;
		MAX_COUNT : natural := integer'high
	);
	port
	(
		clk		  : in std_logic;
		reset	      : in std_logic;
		enable	  : in std_logic;
		q		  : out integer range MIN_COUNT to MAX_COUNT
	);
end entity;

architecture rtl of binary_counter is
begin
	process (clk)
		variable  cnt : integer range MIN_COUNT to MAX_COUNT;
	begin
		if (rising_edge(clk)) then
			if reset = '1' then
				cnt := 0;
			elsif enable = '1' then
				cnt := cnt + 1;
			end if;
		end if;

		q <= cnt;
	end process;
end rtl;
end_template
end_group
end_group
end_group
begin_group Constructs
begin_group Design Units
begin_template Library Clause
-- A library clause declares a name as a library.  It 
-- does not create the library; it simply forward declares 
-- it. 
library <library_name>;
end_template
begin_template Use Clause
-- Use clauses import declarations into the current scope.	
-- If more than one use clause imports the same name into the
-- the same scope, none of the names are imported.

-- Import all the declarations in a package
use <library_name>.<package_name>.all;

-- Import a specific declaration from a package
use <library_name>.<package_name>.<object_name>;

-- Import a specific entity from a library
use <library_name>.<entity_name>;

-- Import from the work library.  The work library is an alias
-- for the library containing the current design unit.
use work.<package_name>.all;


-- Commonly imported packages:

	-- STD_LOGIC and STD_LOGIC_VECTOR types, and relevant functions
	use ieee.std_logic_1164.all;

	-- SIGNED and UNSIGNED types, and relevant functions
	use ieee.numeric_std.all;

	-- Basic sequential functions and concurrent procedures
	use ieee.VITAL_Primitives.all;

	-- Library of Parameterized Modules: 
	-- customizable, device-independent logic functions
	use lpm.lpm_components.all;

	-- Altera Megafunctions
	use altera_mf.altera_mf_components.all;
end_template
begin_template Entity
entity <entity_name> is
	generic
	(
		<name>	: <type>  :=	<default_value>;
		...
		<name>	: <type>  :=	<default_value>
	);


	port
	(
		-- Input ports
		<name>	: in  <type>;
		<name>	: in  <type> := <default_value>;

		-- Inout ports
		<name>	: inout <type>;

		-- Output ports
		<name>	: out <type>;
		<name>	: out <type> := <default_value>
	);
end <entity_name>;
end_template
begin_template Architecture

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

architecture <arch_name> of <entity_name> is

	-- Declarations (optional)

begin

	-- Process Statement (optional)

	-- Concurrent Procedure Call (optional)

	-- Concurrent Signal Assignment (optional)

	-- Conditional Signal Assignment (optional)

	-- Selected Signal Assignment (optional)

	-- Component Instantiation Statement (optional)

	-- Generate Statement (optional)

end <arch_name>;
end_template
begin_template Package

-- Library Clause(s) (optional)
-- Use Clause(s) (optional)

package <package_name> is

	-- Type Declaration (optional)

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Signal Declaration (optional)

	-- Component Declaration (optional)

end <package_name>;
end_template
begin_template Package Body

package body <package_name> is

	-- Type Declaration (optional)

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Function Declaration (optional)

	-- Function Body (optional)

	-- Procedure Declaration (optional)

	-- Procedure Body (optional)

end <package_name>;
end_template
begin_template Configuration_Declaration
-- A configuration can control how the various parts of a design fit
-- together.  It can specify which architecture is used with a given
-- entity.  It can select the entity (and architecture) corresponding
-- to a component instantiation.   It can control how the ports and 
-- generics of a component map to the ports and generics of the entity 
-- it instantiates.

configuration <configuration_name> of <entity_name> is
	for <architecture_name>
	
		-- Use Clause (optional)

		-- Block Configuration or Component Configuration (optional)

	end for;
end <configuration_name>;


-- Note: A configuration declaration is used to configure one or more 
-- instances of an entity.  Quartus II must be able to determine which
-- instance(s) to configure, or it will ignore the configuration declaration.
-- Quartus II is able to determine which instances to configure in the
-- following cases:
-- 1. The configuration declaration pertains to the top-level entity.
-- 2. The configuration declaration is named in a component configuration
--    that is inside another, higher-level configuration declaration.
-- 3. The configuration declaration is named in a configuration specification.
end_template
begin_template Block Configuration
-- Block configurations go inside configuration declarations.  See the 
-- full-design configuration templates for examples using block configurations.

for <architecture_name, block_label, _or_ generate_label>

	-- Use Clause (optional)

	-- Block Configuration or Component Configuration (optional)

end for;
end_template
begin_template Component Configuration
-- Component configurations go inside configuration declarations.  See the 
-- full-design configuration templates for examples using component configurations.

for <instance_name>:<component_name>

	-- Optionally specify either an entity or configuration (not both).
	-- Only use the semicolon if there is no port/generic binding to follow.
	use entity <library_name>.<entity_name>(<optional_architecture_name>);
	use configuration <library_name>.<configuration_name>;
	
	-- Optionally specify port and generic bindings.
	-- Use these if the names of the ports/generics of the component
	-- don't match the names of the corresponding ports/generics of the
	-- entity being instantiated.
	generic map
	(
		<instantiated_entity_generic_name> => <component_generic_name>,
		...
	)
	port map 
	(
		<instantiated_entity_input_name> => <component_input_name>,
		<instantiated_entity_output_name> => <component_output_name>,
		<instantiated_entity_inout_name> => <component_inout_name>,
		...
	);

	-- Block Configuration (optional)

end for;
end_template
end_group
begin_group Declarations
begin_group Type and Subtype Declarations
begin_template Integer Type Declaration
-- Basic integer type declaration
type <name> is range <low> to <high>;

-- Examples
type index_t is range 0 to 7;
type addr_t is range 255 downto 0;
end_template
begin_template Array Type Declaration
-- Basic 1-D array type declaration
type <name> is array(<range_expr>) of <subtype_indication>;

-- Specify a multidimensional array in a single declaration
type <name> is array(<range_expr>,..) of <subtype_indication>;

-- Examples

-- Declare array types with fixed ranges.
type byte_t is array(7 downto 0) of std_logic;
type mem_t	is array(7 downto 0) of std_logic_vector(7 downto 0);

-- Declare an array type with an unconstrained range.  When
-- you declare an object of this type, you can specify the
-- range constraint in the subtype indication.
type vector_t is array(natural range <>) of std_logic;
end_template
begin_template Enum Type Declaration
type <name> is (<enum_literal>, <enum_literal>, ...);

-- Example
type state_t is (IDLE, READING, WRITING, DONE);
end_template
begin_template Record Type Declaration
type <name> is 
	record 
		<member_ids> : <subtype_indication>;
		...
	end record;

-- Example
type packet_t is 
	record
		address : integer range 0 to 256;
		data	   : std_logic_vector(7 downto 0);
	end record;
end_template
end_group
begin_template Signal Declaration
-- Signal with no default value.  Your design should assign an explicit
-- value to such a signal using an assignment statement.  You assign
-- to a signal with the "<=" operator. 

signal <name> : <type>;

-- Signal with a default value.	 If you do not assign a value to the
-- signal with an assignment, Quartus II Integrated Synthesis will 
-- initialize it with the default value.  Integrated Synthesis also
-- derives power-up conditions for memories and registers from the
-- default value.

signal <name> : <type> := <default_value>;

-- Commonly declared signals

signal <name> : std_logic;
signal <name> : std_logic_vector(<msb_index> downto <lsb_index>);
signal <name> : integer;
signal <name> : integer range <low> to <high>;
end_template
begin_template Variable Declaration
-- Variables should be declared in a process statement or subprogram.
-- They are useful for storing intermediate calculations.  You assign
-- to a variable with the ":=" operator.

-- Variable with no default value.	Your design should assign an 
-- explicit value to this variable before referring to it in a 
-- statement or an expression

variable <name> : <type>;

-- Variable with a default value.

variable <name> : <type> := <default_value>;

-- Commonly declared variables

variable <name> : std_logic;
variable <name> : std_logic_vector(<msb_index> downto <lsb_index>);
variable <name> : integer;
variable <name> : integer range <low> to <high>;
end_template
begin_template Constant Declaration
constant <constant_name> : <type> := <constant_value>;
end_template
begin_template Component Declaration
-- A component declaration declares the interface of an entity or
-- a design unit written in another language.  VHDL requires that
-- you declare a component if you do not intend to instantiate
-- an entity directly.	The component need not declare all the
-- generics and ports in the entity.  It may omit generics/ports
-- with default values.

component <component_name>

	generic
	(
		<name> : <type>;
		<name> : <type> := <default_value>
	);

	port
	(
		-- Input ports
		<name>	: in  <type>;
		<name>	: in  <type> := <default_value>;

		-- Inout ports
		<name>	: inout <type>;

		-- Output ports
		<name>	: out <type>;
		<name>	: out <type> := <default_value>
	);

end component;
end_template
begin_template Subprogram Declaration
-- Procedure Declaration
procedure <name>(<formal_parameter_decls>);

-- Function Declaration
function <name>(<formal_parameter_decls>) return <type_mark>;
end_template
begin_template Subprogram Body
<subprogram_decl> is
	-- Declaration(s)
begin
	-- Statement(s)
end;
end_template
begin_template Attribute Declaration
-- Attributes allow you to associate additional properties with another
-- object in your design.  Quartus II Integrated Synthesis supports
-- attributes as a way for you to control the synthesis of your design.
-- In general, you should import attributes from the altera_syn_attributes
-- package in the altera library with the use clause:
--	   use altera.syn_altera_attributes.all;

attribute <name> : <type>;
end_template
begin_template Configuration Specification
-- A configuration specification is a way of configuring a component instance.
-- The configuration specification can select the entity (and architecture) 
-- corresponding to a component instantiation.  It can also specify a
-- configuration declaration used to configure the component instance.

-- Specify the entity being instantiated
for <instance_name> : <component_name> use entity <library_name>.<entity_name>;

-- Specify the entity and architecture being instantiated 
for <instance_name> : <component_name> use entity <library_name>.<entity_name>(<architecture_name>);

-- Specify a configuration to configure this instance of the component
for <instance_name> : <component_name> use configuration <library_name>.<configuration_name>;


-- Examples

for inst : my_component use entity work.my_entity;

for inst : my_component use entity work.my_entity(my_arch);

for inst : my_component use configuration work.my_configuration;
end_template
end_group
begin_group Concurrent Statements
begin_template Conditional Signal Assignment
<optional_label>: <target> <= 
	<value> when <condition> else
	<value> when <condition> else 
	<value> when <condition> else
	...
	<value>;
end_template
begin_template Selected Signal Assignment
<optional_label>: with <expression> select
	<target> <= <value> when <choices>
				<value> when <choices>
				<value> when <choices>
	 		    ...
				<value> when others;
end_template
begin_template Concurrent Procedure Call
<optional_label>: <procedure_name> (<arguments>);
end_template
begin_template Combinational Process
<optional_label>:
	process(<sensitivity_list>) is
		-- Declaration(s)
	begin
		-- Sequential Statement(s)
	end process;
end_template
begin_template Sequential Process
<optional_label>:
	process(reset, clk) is 
		-- Declaration(s) 
	begin 
		if(reset = '1') then
			-- Asynchronous Sequential Statement(s) 
		elsif(rising_edge(clk)) then
			-- Synchronous Sequential Statement(s)
		end if;
	end process; 
end_template
begin_group Generates
begin_template Generate For
<generate_label>: 
	for <loop_id> in <range> generate
		-- Concurrent Statement(s)
	end generate;
end_template
begin_template Generate If
<generate_label>: 
	if <condition> generate
		-- Concurrent Statement(s)
	end generate;
end_template
end_group
begin_group Instances
begin_template Component Instantiation
<instance_name> : <component_name> 
	generic map
	(
		<name> => <value>,
		...
	)
	port map 
	(
		<formal_input> => <expression>,
		<formal_output> => <signal>,
		<formal_inout> => <signal>,
		...
	);
end_template
begin_template Direct Entity Instantiation
-- To instantiate an entity directly, the entity must be written in VHDL.
-- You must also add the file containing the entity declaration to your 
-- Quartus II project.
<instance_name>: entity <library>.<entity_name>
	generic map
	(
		<name> => <value>,
		...
	)
	port map 
	(
		<formal_input> => <expression>,
		<formal_output> => <signal>,
		<formal_inout> => <signal>,
		...
	);
end_template
begin_template Direct Entity Instantiation w/ Architecture
-- To instantiate an entity directly, the entity must be written in VHDL.
-- You must also add the file containing the entity declaration to your
-- Quartus II project.
<instance_name>: entity <library>.<entity_name>(<architecture_name>)
	generic map
	(
		<name> => <value>,
		...
	)
	port map 
	(
		<formal_input> => <expression>,
		<formal_output> => <signal>,
		<formal_inout> => <signal>,
		...
	);
end_template
end_group
end_group
begin_group Sequential Statements
begin_template Sequential Signal Assignment
<optional_label>: <signal_name> <= <expression>;	
end_template
begin_template Variable Assignment
<optional_label>: <variable_name> := <expression>;	
end_template
begin_template Procedure Call
<optional_label>: <procedure_name> (<arguments>);
end_template
begin_template If Statement
if <expression> then
	-- Sequential Statement(s)
elsif <expression> then
	-- Sequential Statement(s)
else
	-- Sequential Statement(s);
end if;
end_template
begin_template Case Statement
-- All choice expressions in a VHDL case statement must be constant
-- and unique.	Also, the case statement must be complete, or it must
-- include an others clause. 
case <expression> is
	when <constant_expression> =>
		-- Sequential Statement(s)
	when <constant_expression> =>
		-- Sequential Statement(s)
	when others =>
		-- Sequential Statement(s)
end case;
end_template
begin_template For Loop Statement
<optional_label>: 
	for <loop_id> in <range> loop
		-- Sequential Statement(s)
	end loop;
end_template
begin_template While Loop Statement
<optional_label>: 
	while <condition> loop
		-- Sequential Statement(s)
	end loop;
end_template
begin_template Next Statement
-- Unconditional next.
<optional_label>: next <optional_loop_label>;

-- Conditional next
<optional_loop_label>: next <optional_loop_label> when <condition>;	
end_template
begin_template Exit Statement
-- Unconditional exit
<optional_label>: exit <optional_loop_label>;

-- Conditional exit
<optional_label>: exit <optional_loop_label> when <condition>;
end_template
begin_template Return Statement
-- Inside a function, this statement must return a value.
<optional_label>: return <expression>;

-- Inside a procedure, this stamement must NOT return a value.
<optional_label>: return;
end_template
begin_template Null Statement
-- A null statement does nothing.
<optional_label>: null;	
end_template
end_group
begin_group Expressions
begin_template Unary Operators
-- Unary Expressions
+  -- positive
-  -- negative
NOT   -- negation
ABS   -- absolute value
end_template
begin_template Binary Operators
-- Binary Expressions
AND
OR
NAND
NOR
XOR
XNOR
=
/=
<
<=
>
>=
SLL   -- Shift Left Logical
SRL   -- Shift Right Logical
SLA   -- Shift Left Arithmetic: same as "logical" shift but uses sign extension (the leftmost bit is considered the sign bit)
SRA   -- Shift Right Arithmetic: same as "logical" shift but uses sign extension (the rightmost bit is considered the sign bit)
ROL   -- Rotate Left: Same as a shift, but bits that would "fall off" the left side during a shift will reappear on the right side in a rotation.
ROR   -- Rotate Right
+   -- Addition
-   -- Subtraction
&   -- Concatenation
*   -- Multiplication
/   -- Division
MOD   -- Modulus: If C <= A MOD B, then A = B*N + C (for some integral N), and ABS(C) < ABS(B).  Also, C must be positive if B is positive, and C must be negative if B is negative.  
REM   -- Remainder: If C <= A REM B, then A = (A/B)*B + C, and ABS(C) < ABS(B).  Also, C must be positive if A is positive, and C must be negative if A is negative.
**   -- Exponent
end_template
end_group
end_group
begin_group Logic
begin_group Registers
begin_template Basic Positive Edge Register
-- Update the register output on the clock's rising edge
process (<clock_signal>)
begin
	if (rising_edge(<clock_signal>)) then
		<register_variable> <= <data>;
	end if;
end process;
end_template
begin_template Basic Positive Edge Register with Power-Up = VCC
-- Set the initial value to 1
signal <register_variable> : std_logic := '1';

-- After initialization, update the register output on the clock's 
-- rising edge
process (<clock_signal>)
begin
	if (rising_edge(<clock_signal>)) then
		<register_variable> <= <data>;
	end if;
end process;
end_template
begin_template Basic Negative Edge Register
-- Update the register output on the clock's falling edge
process (<clock_signal>)
begin
	if (falling_edge(<clock_signal>)) then
		<register_variable> <= <data>;
	end if;
end process;
end_template
begin_template Basic Negative Edge Register with Power-Up = VCC
-- Set the initial value to 1
signal <register_variable> : STD_LOGIC := '1';

-- After initialization, update the register output on the clock's 
-- falling edge
process (<clock_signal>)
begin
	if (falling_edge(<clock_signal>)) then
		<register_variable> <= <data>;
	end if;
end process;
end_template
begin_template Basic Positive Edge Register with Asynchronous Reset
process (<clock_signal>, <reset>)
begin
	-- Reset whenever the reset signal goes low, regardless of the clock
	if (reset = '0') then
		<register_variable> <= '0';
	-- If not resetting, update the register output on the clock's rising edge
	elsif (rising_edge(<clock_signal>)) then
		<register_variable> <= <data>;
	end if;
end process;
end_template
begin_template Basic Negative Edge Register with Asynchronous Reset
process (<clock_signal>, <reset>)
begin
	-- Reset whenever the reset signal goes low, regardless of the clock
	if (reset = '0') then
		<register_variable> <= '0';
	-- If not resetting, update the register output on the clock's falling edge
	elsif (falling_edge(<clock_signal>)) then
		<register_variable> <= <data>;
	end if;
end process;
end_template
begin_template Basic Positive Edge Register with Asynchronous Reset and Clock Enable
process (<clock_signal>, <reset>)
begin
	-- Reset whenever the reset signal goes low, regardless of the clock
	-- or the clock enable
	if (reset = '0') then
		<register_variable> <= '0';
	-- If not resetting, and the clock signal is enabled on this register, 
	-- update the register output on the clock's rising edge
	elsif (rising_edge(<clock_signal>)) then
		if (<clock_enable> = '1') then
			<register_variable> <= <data>;
		end if;
	end if;
end process;
end_template
begin_template Basic Negative Edge Register with Asynchronous Reset and Clock Enable
process (<clock_signal>, <reset>)
begin
	-- Reset whenever the reset signal goes low, regardless of the clock
	-- or the clock enable
	if (reset = '0') then
		<register_variable> <= '0';
	-- If not resetting, and the clock signal is enabled on this register, 
	-- update the register output on the clock's falling edge
	elsif (falling_edge(<clock_signal>)) then
		if (<clock_enable> = '1') then
			<register_variable> <= <data>;
		end if;
	end if;
end process;
end_template
begin_template Full-Featured Positive Edge Register with All Secondary Signals
-- In Altera devices, register signals have a set priority.
-- The HDL design should reflect this priority.
process(<reset>, <aload>, <adata>, <clock_signal>)
begin
	-- The asynchronous reset signal has the highest priority
	if (<reset> = '0') then
		<register_variable> <= '0';
	-- Asynchronous load has next-highest priority
	elsif (<aload> = '1') then
		<register_variable> <= <adata>;
	else 
		-- At a clock edge, if asynchronous signals have not taken priority,
		-- respond to the appropriate synchronous signal.
		-- Check for synchronous reset, then synchronous load.
		-- If none of these takes precedence, update the register output
		-- to be the register input.
		if (rising_edge(<clock_signal>)) then
			if (<clock_enable> = '1') then
				if (<synch_reset> = '0') then
					<register_variable> <= '0';
				elsif (<synch_load> = '1') then
					<register_variable> <= <synch_data>;
				else
					<register_variable> <= <data>;
				end if;
			end if;
		end if;
	end if;
end process;
end_template
begin_template Full-Featured Negitive Edge Register with All Secondary Signals
-- In Altera devices, register signals have a set priority.
-- The HDL design should reflect this priority.
process(<reset>, <aload>, <adata>, <clock_signal>)
begin
	-- The asynchronous reset signal has the highest priority
	if (<reset> = '0') then
		<register_variable> <= '0';
	-- Asynchronous load has next-highest priority
	elsif (<aload> = '1') then
		<register_variable> <= <adata>;
	else 
		-- At a clock edge, if asynchronous signals have not taken priority,
		-- respond to the appropriate synchronous signal.
		-- Check for synchronous reset, then synchronous load.
		-- If none of these takes precedence, update the register output
		-- to be the register input.
		if (falling_edge(<clock_signal>)) then
			if (<clock_enable> = '1') then
				if (<synch_reset> = '0') then
					<register_variable> <= '0';
				elsif (<synch_load> = '1') then
					<register_variable> <= <synch_data>;
				else
					<register_variable> <= <data>;
				end if;
			end if;
		end if;
	end if;
end process;
end_template
end_group
begin_group Latches
begin_template Basic Latch
-- Update the variable only when updates are enabled
process(<enable>, <data>)
begin
	if (<enable> = '1') then
		<latch_variable> <= <data>;
	end if;
end process;
end_template
begin_template Basic Latch with Reset
process(<reset>, <enable>, <data>)
begin
	-- The reset signal overrrides the enable signal; reset the value to 0
	if (<reset> = '0') then
		<latch_variable> <= '0';
	-- Otherwise, change the variable only when updates are enabled
	elsif (<enable> = '1') then
		<latch_variable> <= <data>;
	end if;
end process;
end_template
end_group
begin_group Tri-State
begin_template Tri-State Buffer
-- Altera devices contain tri-state buffers in the I/O.  Thus, a tri-state
-- buffer must feed a top-level I/O in the final design.  Otherwise, the
-- Quartus II software will convert the tri-state buffer into logic.
<target> <= <data> when (<output_enable> = '1') else 'Z';
end_template
begin_template Tri-State Register
process (<clock_signal>, <asynch_output_enable>)
begin
	if (<asynch_output_enable> = '0') then
		<bidir_variable> <= 'Z';
	else
		if (rising_edge(<clock_signal>)) then
			if (<output_enable> = '0') then
				<bidir_variable> <= 'Z';
			else
				<bidir_variable> <= <data>;
			end if;
		end if;
	end if;
end process;
end_template
begin_template Bidirectional I/O
library ieee;
use ieee.std_logic_1164.all;
entity bidirectional_io is
generic
(
	WIDTH	: integer  :=	4
);
port
(
	<output_enable> : in std_logic;
	<data> : in std_logic_vector(WIDTH-1 downto 0);
	<bidir_variable> : inout std_logic_vector(WIDTH-1 downto 0);
	<read_buffer> : out std_logic_vector(WIDTH-1 downto 0)
);
end bidirectional_io;

architecture rtl of bidirectional_io is
begin
	-- If we are using the inout as an output, assign it an output value, 
	-- otherwise assign it high-impedence
	<bidir_variable> <= <data> when <output_enable> = '1' else (others => 'Z');

	-- Read in the current value of the bidir port, which comes either 
	-- from the input or from the previous assignment
	<read_buffer> <= <bidir_variable>;
end rtl;
end_template
begin_template Open-Drain Buffer
-- Altera devices contain tri-state buffers in the I/O.  Thus, an open-drain 
-- buffer must feed a top-level I/O in the final design.  Otherwise, the 
-- Quartus II software will convert the open-drain buffer into logic.
<target> <= '0' when (<output_enable> = '1') else 'Z';
end_template
end_group
end_group
begin_group Synthesis Attributes
begin_template Using Synthesis Attributes
-- Before using an attribute, you must first declare it or import
-- its declaration from a package.  All Altera-supported attributes are 
-- declared in the altera_syn_attributes package in the altera library.  You 
-- can import these declarations with the following use clause:
use altera.altera_syn_attributes.all;

-- For more detailed information on any attribute, refer to the
-- Quartus II Handbook or Help.
end_template
begin_template keep Attribute
-- Prevents Quartus II from minimizing or removing a particular
-- signal net during combinational logic optimization.	Apply
-- the attribute to a net or variable declaration.

attribute keep of <object> : <object_class> is true;
end_template
begin_template maxfan Attribute
-- Sets the maximum number of fanouts for a register or combinational
-- cell.  The Quartus II software will replicate the cell and split
-- the fanouts among the duplicates until the fanout of each cell
-- is below the maximum.

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute maxfan : natural;

attribute maxfan of <object> : <object_class> is <value>;
end_template
begin_template preserve Attribute
-- Prevents Quartus II from optimizing away a register.	 Apply
-- the attribute to the variable declaration for an object that infers
-- a register.

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute preserve : boolean;

attribute preserve of <object> : <object_class> is true;
end_template
begin_template noprune Attribute
-- Prevents Quartus II from removing or optimizing a fanout free register.
-- Apply the attribute to the variable declaration for an object that infers
-- a register.

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute noprune : boolean;

attribute noprune of <object> : <object_class> is true;
end_template
begin_template dont_merge Attribute
-- Prevents Quartus II from merging a register with a duplicate
-- register

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute dont_merge : boolean;

attribute dont_merge of <object> : <object_class> is true;
end_template
begin_template dont_replicate Attribute
-- Prevents Quartus II from replicating a register.

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute dont_replicate : boolean;

attribute dont_replicate of <object> : <object_class> is true;
end_template
begin_template dont_retime Attribute
-- Prevents Quartus II from retiming a register

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute dont_retime : boolean;

attribute dont_retime of <object> : <object_class> is true;
end_template
begin_template direct_enable Attribute
-- Identifies the logic cone that should be used as the clock enable
-- for a register.  Sometimes a register has a complex clock enable
-- condition, which may or may not contain the critical path in your
-- design.  With this attribute, you can force Quartus II to route
-- the critical portion directly to the clock enable port of a register
-- and implement the remaining clock enable condition using regular 
-- logic.

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute direct_enable : boolean;

attribute direct_enable of <object> : <object_class> is true;

-- Example
signal e1, e2, q, data : std_logic;

attribute direct_enable of e1 : signal is true;

process(clk)
begin
	if(rising_edge(clk) and (e1 or e2)) then
		q <= data;
	end if;
end
end_template
begin_template useioff Attribute
-- Controls the packing input, output, and output enable registers into
-- I/O cells.  Using a register in an I/O cell can improve performance
-- by minimizing setup, clock-to-output, and clock-to-output-enable times.

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute useioff : boolean;

attribute useioff of <object> : <object_class> is true;

-- Apply the attribute to a port object (a signal)

attribute useioff of my_input : signal is true;     -- enable packing
attribute useioff of my_input : signal is false;    -- disable packing
end_template
begin_template ramstyle Attribute
-- Controls the implemententation of an inferred memory.  Apply the
-- attribute to a variable declaration that infers a RAM or ROM.  

-- Legal values = "M512", "M4K", "M-RAM", "M9K", "M144K", "MLAB", "no_rw_check"

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute ramstyle : string;

attribute ramstyle of <object> : <object_class> is <string_value>;

-- The "no_rw_check" value indicates that your design does not depend
-- on the behavior of the inferred RAM when there are simultaneous reads
-- and writes to the same address.  Thus, the Quartus II software may ignore
-- the read-during-write behavior of your HDL source and choose a behavior
-- that matches the behavior of the RAM blocks in the target device.

-- You may combine "no_rw_check" with a block type by separating the values
-- with a comma:  "M512, no_rw_check" or "no_rw_check, M512"  

-- Example

-- Implement all RAMs in this architecture with M512 blocks
attribute ramstyle of rtl : architecture is "M512";

-- Implement this RAM with an M4K and ignore read-during-write behavior
signal ram : ram_t;
attribute ramstyle of ram : signal is "M4K, no_rw_check";
end_template
begin_template romstyle Attribute
-- Controls the implemententation of an inferred ROM.  Apply the
-- attribute to a variable declaration that infers ROM or to a
-- entity or architecture containing inferred ROMs.   

-- Legal values = "M512", "M4K", "M-RAM", "M9K", "M144K", "MLAB"

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute romstyle : string;

attribute romstyle of <object> : <object_class> is <string_value>;

-- Example

-- Implement all ROMs in this architecture with M512 blocks
attribute romstyle of rtl : architecture is "M512";

-- Implement this ROM with an M4K
signal rom : rom_t;
attribute romstyle of rom : signal is "M4K";
end_template
begin_template multstyle Attribute
-- Controls the implementation of multiplication operators in your HDL 
-- source.  Using this attribute, you can control whether the Quartus II 
-- software should preferentially implement a multiplication operation in 
-- general logic or dedicated hardware, if available in the target device.  

-- Legal values = "dsp" or "logic"

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute multstyle : string;

attribute multstyle of <object> : <object_class> is <string_value>;

-- Examples (in increasing order of priority)

-- Control the implementation of all multiplications in an entity
attribute multstyle of foo : entity is "dsp";

-- Control the implementation of all multiplications whose result is
-- directly assigned to a signal
signal result : integer;

attribute multstyle of result : signal is "logic";

result <= a * b; -- implement this multiply in logic
end_template
begin_template syn_encoding Attribute
-- Controls the encoding of the states in an inferred state machine.

-- Legal values = "sequential", "gray", "johnson", "compact", "onehot",
--                "auto", "default", "safe", or a space-delimited list of
--                 binary encodings, e.g. "00100 11010 10110"

-- The value "safe" instructs the Quartus II software to add extra logic 
-- to detect illegal states (unreachable states) and force the state machine 
-- into the reset state. You cannot implement a safe state machine by 
-- specifying manual recovery logic in your design; the Quartus II software 
-- eliminates this logic while optimizing your design.  You can combine
-- "safe" with any encoding style (but not a list of binary encodings), e.g.
-- "sequential, safe"

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute syn_encoding : string;

attribute syn_encoding of <object> : <object_class> is <string_value>;

-- Implement all state machines with type state_t as safe, gray-encoded
-- state machines
type state_t is (S0, S1, S2, S3, S4);
attribute syn_encoding of state_t : type is "gray, safe";
end_template
begin_template enum_encoding Attribute
-- Controls the encoding of an enumerated type.   

-- Legal values = "sequential", "gray", "johnson", "onehot", "default", 
--                "auto", or a space-delimited list of binary encodings, 
--                e.g. "00100 11010 10110"

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute syn_encoding : string;

attribute syn_encoding of <object> : <object_class> is <string_value>;

-- Implement all state machines with type state_t as safe, gray-encoded
-- state machines
type enum_t is (apple, orange, pear, cherry);
attribute enum_encoding of enum_t : type is "onehot";
end_template
begin_template chip_pin Attribute
-- Assigns pin location to ports on an entity.

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute chip_pin : string;

attribute chip_pin of <object> : <object_class> is <string_value>;

-- Example
attribute chip_pin of my_input : signal is "B3, A3, A4";
end_template
begin_template altera_attribute Attribute
-- Associates arbitrary Quartus II assignments with objects in your HDL
-- source.  Each assignment uses the QSF format, and you can associate
-- multiple assignments by separating them with ";".

-- Declare the attribute or import its declaration from 
-- altera.altera_syn_attributes
attribute altera_attribute : string;

attribute altera_attribute of <object> : <object_class> is <string_value>;

-- Preserve all registers in this hierarchy
attribute altera_attribute of foo : entity is "-name PRESERVE_REGISTER on";

-- Cut timing paths from register q1 to register q2
signal q1, q2 : std_logic;
attribute altera_attribute of q2 : signal is "-name CUT on -from q1";
end_template
end_group
begin_group Altera Primitives
begin_group Buffers
begin_template ALT_INBUF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all; 
-- Instantiating ALT_INBUF
	<instance_name> : ALT_INBUF
	generic map (
			IO_STANDARD => "LVDS",
			LOCATION => "IOBANK_1A",
			ENABLE_BUS_HOLD => "off",
			WEAK_PULL_UP_RESISTOR => "off"
			)
	port map ( 
			i => <data_in>,	  -- <data_in> must be declared as an input pin
			o => <data_out>
			);
end_template
begin_template ALT_INBUF_DIFF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all; 
-- Instantiating ALT_INBUF_DIFF
	<instance_name> : ALT_INBUF_DIFF
	generic map (
			IO_STANDARD => "LVDS",
			LOCATION => "IOBANK_1A",
			ENABLE_BUS_HOLD => "off",
			WEAK_PULL_UP_RESISTOR => "off"
			) 
	port map ( 
			i => <data_in_pos>,		 -- <data_in_pos> must be an input pin
			ibar => <data_in_neg>,	 -- <data_in_neg> must be an input pin
			o => <data_out>
			);
end_template
begin_template ALT_IOBUF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all; 
-- Instantiating ALT_IOBUF
	<instance_name> : ALT_IOBUF
	generic map (
			IO_STANDARD => "Differential 1.2-V HSTL Class I",
			CURRENT_STRENGTH_NEW => "4mA",
			ENABLE_BUS_HOLD => "none",
			WEAK_PULL_UP_RESISTOR => "off",
			LOCATION => "IOBANK_3C"
			) 
	port map (
			i => <data_in>, 
			oe => <enable_signal>, 
			o => <data_out>, 
			io => <bidir>	  -- <bidir> must be declared as an inout pin
			);
end_template
begin_template ALT_OUTBUF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating ALT_OUTBUF
	<instance_name> : ALT_OUTBUF
	generic map (
			IO_STANDARD => "LVDS",
			LOCATION => "IOBANK_2A",
			CURRENT_STRENGTH => "minimum current",
			ENABLE_BUS_HOLD => "off",
			WEAK_PULL_UP_RESISTOR => "off"
			)
	port map ( i => <data_in>, o => <data_out>);  -- <data_out> must be declared as an output pin
end_template
begin_template ALT_OUTBUF_DIFF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all; 
-- Instantiating ALT_OUTBUF_DIFF
	<instance_name> : ALT_OUTBUF_DIFF
	generic map (
			IO_STANDARD => "LVDS",
			LOCATION => "IOBANK_2A",
			CURRENT_STRENGTH => "minimum current",
			ENABLE_BUS_HOLD => "off",
			WEAK_PULL_UP_RESISTOR => "off"
			)
	-- <data_out_pos> and <data_out_neg> must be declared as output pins
	port map ( i => <data_in>, o => <data_out_pos>, obar => <data_out_neg>);
end_template
begin_template ALT_OUTBUF_TRI
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating ALT_OUTBUF_TRI
	<instance_name> : ALT_OUTBUF_TRI
	generic map (
			IO_STANDARD => "Differential 1.8-V SSTL Class I",
			LOCATION => "IOBANK_2C",
			CURRENT_STRENGTH => "8mA",
			ENABLE_BUS_HOLD => "off",
			WEAK_PULL_UP_RESISTOR => "off"
			) 
	port map ( 
			i => <data_in>, 
			oe => <enable_signal>, 
			o => <data_out>	  -- <data_out> must be declared as an output pin
			);
end_template
begin_template CASCADE
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating CASCADE
	<instance_name> : CASCADE
	-- <data_out> cannot feed an output pin, a register, or an XOR gate
	port map(a_in => <data_in>, a_out => <data_out>);
end_template
begin_template CARRY_SUM
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating CARRY_SUM
	<instance_name> : CARRY_SUM
	-- <carry_in> cannot be fed by an input pin
	-- <carry_out> cannot feed an output pin
	port map(sin => <sum_in>, cin => <carry_in>, sout => <sum_out>, cout => <carry_out>);
end_template
begin_template GLOBAL
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating GLOBAL
	<instance_name> : GLOBAL
	port map (a_in => <data_in>, a_out => <data_out>);
end_template
begin_template LCELL
-- Add the library and use clauses before the design unit declaration
library altera_mf; 
use altera_mf.altera_mf_components.all;
-- Instantiating LCELL
	<instance_name> : LCELL
	port map (a_in => <data_in>, a_out => <data_out>);
end_template
begin_template OPNDRN
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating OPNDRN
	<instance_name> : OPNDRN
	-- <data_out> may feed an inout pin
	port map (a_in => <data_in>, a_out => <data_out>);
end_template
begin_template TRI
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating TRI
	<instance_name> : TRI
	-- <data_out> may feed an inout pin
	port map (a_in => <data_in>, oe => <enable_signal>, a_out => <data_out>);
end_template
end_group
begin_group Registers and Latches
begin_template DFF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating DFF
	<instance_name> : DFF
	port map (
			d => <data_in>, 
			clk => <clock_signal>, 
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			q => <data_out>
			);
end_template
begin_template DFFE
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating DFFE
	<instance_name> : DFFE
	port map (
			d => <data_in>,
			clk => <clock_signal>,
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			ena => <clock_enable>,
			q => <data_out>
			);
end_template
begin_template DFFEA
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating DFFEA
	<instance_name> : DFFEA
	port map (
			d => <data_in>,
			clk => <clock_signal>,
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			ena => <clock_enable>,
			adata => <asynch_data_in>,
			aload => <asynch_load_signal>,
			q => <data_out>
			);
end_template
begin_template DFFEAS
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating DFFEAS
	<instance_name> : DFFEAS
	port map (
			d => <data_in>,
			clk => <clock_signal>,
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			ena => <clock_enable>,
			asdata => <asynch_data_in>,
			aload => <asynch_load_signal>,
			sclr => <synchronous_clear>,
			sload => <synchronous_load>,
			q => <data_out>
			);
end_template
begin_template JKFF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating JKFF
	<instance_name> : JKFF
	port map (
			j => <synchronous_set>,
			k => <synchronous_reset>,
			clk => <clock_signal>,
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			q => <data_out>
			);
end_template
begin_template JKFFE
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating JKFFE
	<instance_name> : JKFFE
	port map (
			j => <synchronous_set>, 
			k => <synchronous_reset>,
			clk => <clock_signal>,
			ena => <clock_enable>,
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			q => <data_out>
			);
end_template
begin_template LATCH
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating LATCH
	<instance_name> : LATCH
	port map (
			d => <data_in>,
			ena => <clock_enable>,
			q => <data_out>
			);
end_template
begin_template SRFF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating SRFF
	<instance_name> : SRFF
	port map (
			s => <synchronous_set>,
			r => <synchronous_reset>,
			clk => <clock_signal>, 
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			q => <data_out>
			);
end_template
begin_template SRFFE
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating SRFFE
	<instance_name> : SRFFE
	port map (
			s => <synchronous_set>,
			r => <synchronous_reset>,
			clk => <clock_signal>,
			ena => <clock_enable>,
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			q => <data_out>
			);
end_template
begin_template TFF
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating TFF
	<instance_name> : TFF
	port map (
			t => <toggle>,
			clk => <clock_signal>, 
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			q => <data_out>
			);
end_template
begin_template TFFE
-- Add the library and use clauses before the design unit declaration
library altera; 
use altera.altera_primitives_components.all;
-- Instantiating TFFE
	<instance_name> : TFFE
	port map (
			t => <toggle>, 
			clk => <clock_signal>,
			ena => <clock_enable>,
			clrn => <active_low_clear>,
			prn => <active_low_preset>,
			q => <data_out>
			);
end_template
end_group
end_group
end_group
