library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
library altera_mf;
use altera_mf.altera_mf_components.all;


entity alt_pfl_pgm_flash_sm is
	generic 
	(
		ADDR_WIDTH		: natural := 20;-- from 19 for 8Mbits, up to 25 for 512Mbits
		DATA_WIDTH		: natural := 8 -- valid values are 8 and 16
	);
	port
	(
		clk				: in STD_LOGIC;
		reset			: in STD_LOGIC;
		
		--scfifo
		scfifo_data_in	: in STD_LOGIC_VECTOR (DATA_WIDTH DOWNTO 0);
		scfifo_empty	: in STD_LOGIC;
		scfifo_rdreq	: out STD_LOGIC := '0';
		
		--sync_reg
		is_sync			: in STD_LOGIC;
		
		--param_reg
		param_in		: in STD_LOGIC_VECTOR (12 DOWNTO 0);
		
		--flash
		flash_select	: out STD_LOGIC;
		flash_write		: out STD_LOGIC := '0';
		flash_read		: out STD_LOGIC := '0';
		flash_data_highz: out STD_LOGIC;
		flash_data_in	: in STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		flash_data_out	: out STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
		flash_addr_out	: out STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
		
		--addr_counter
		addr_in			: in STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
		addr_count		: out STD_LOGIC;
		
		--status_reg
		status_full		: in STD_LOGIC;
		status_done		: out STD_LOGIC;
		status_error	: out STD_LOGIC
	);
end entity alt_pfl_pgm_flash_sm;

architecture rtl of alt_pfl_pgm_flash_sm is
	type state_type is (INTEL_PRE_READ, SPANSION_PRE_READ1, SPANSION_PRE_READ2, SPANSION_POST_READ1, START_WRITE_PROCESS, IDLE, READ_REQUEST, WRITE_ADDRESS_BUS, WRITE_DATA_BUS, WRITE_TO_FLASH, INCREASE_ADDR, END_WRITE, START_CHECK_STATUS, SPANSION, INTEL, INTEL_READ_STATUS, INTEL_POST_READ, SPANSION_READ_STATUS1, SPANSION_READ_STATUS2, INTEL_CLEAR_STATUS_REG, SUCCESS, FAIL, FULL, END_CHECK_STATUS);
	
	signal present_state, next_state	: state_type; 
	signal word_nbuffer			: STD_LOGIC;
	signal intel_nspansion		: STD_LOGIC;
	signal extra_write_count	: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal write_count			: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal datareg				: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
	signal datareg_spansion_buffer_mode: STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
	shared variable var_write_count	: STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
	
	signal numonyx_dev			: STD_LOGIC;
	
	function define_fixed_addr(address: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
	variable addr : STD_LOGIC_VECTOR (31 DOWNTO 0);
	variable addr_out: STD_LOGIC_VECTOR (31 DOWNTO 0);
	begin
		addr := address;
		if DATA_WIDTH = 16 then
			addr_out := '0' & addr(31 DOWNTO 1);
			return (addr_out);
		else
			return addr;
		end if;
	end;

	constant INTEL_FL_CLEAR_STATUS		: STD_LOGIC_VECTOR (31 DOWNTO 0):= x"00000050";
	constant INTEL_FL_READ_STATUS		: STD_LOGIC_VECTOR (31 DOWNTO 0):= x"00000070";
	constant SPANSION_FL_UNLOCK_1_ADDR	: STD_LOGIC_VECTOR (31 DOWNTO 0) := define_fixed_addr(X"00000AAA"); --X"00000555";
	constant SPANSION_FL_UNLOCK_2_ADDR 	: STD_LOGIC_VECTOR (31 DOWNTO 0) := define_fixed_addr(X"00000555");--X"000002AA";
	constant SPANSION_FL_UNLOCK_BYPASS_ADDR : STD_LOGIC_VECTOR (31 DOWNTO 0) := define_fixed_addr(X"00000AAA");--X"00000555";
	constant NUMONYX_FL_WRITE_ADDR 		: STD_LOGIC_VECTOR (31 DOWNTO 0) := define_fixed_addr(X"000000AA");
	
	--flash interface
	signal sig_flash_read: STD_LOGIC;
	signal sig_flash_write: STD_LOGIC;
	signal sig_flash_select: STD_LOGIC;
	signal sig_flash_addr_out: STD_LOGIC_VECTOR(ADDR_WIDTH-1 DOWNTO 0);
	signal sig_flash_data_out: STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
	signal sig_flash_data_in: STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);

begin
	
	flash_select <= sig_flash_write or sig_flash_read;
	flash_write <= sig_flash_write;
	flash_read <= sig_flash_read;
	flash_addr_out <= sig_flash_addr_out;
	flash_data_out <= sig_flash_data_out;
	word_nbuffer <= param_in(11);
	intel_nspansion <= param_in(10);
	numonyx_dev <= param_in(12);
	extra_write_count <= "000000" & param_in(9 DOWNTO 8);
	write_count <= param_in(7 DOWNTO 0);
	
	process (clk)
	begin
		if (clk'event and clk = '1') then
			sig_flash_data_in <= flash_data_in;
		end if;
	end process;
	
	--flash_data_highz
	process (present_state, sig_flash_write)
	begin
		if (sig_flash_write = '1' or present_state = WRITE_DATA_BUS or present_state = WRITE_TO_FLASH or present_state = INCREASE_ADDR) then
			flash_data_highz <= '0';
		else
			flash_data_highz <= '1';
		end if;
	end process;
	
	--control signals: var_extra, var_write_count
	process (clk, reset, present_state, write_count, extra_write_count, is_sync, scfifo_empty)
	variable var_extra : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
	begin 
		if (reset = '1') then
			var_write_count := write_count;
			var_extra := extra_write_count;
		elsif (clk'event and clk = '0') then
			if ( present_state = START_WRITE_PROCESS) then
				var_write_count := var_write_count + var_extra;
				var_extra := var_extra;
			elsif (present_state = WRITE_DATA_BUS and (var_write_count > 0)) then 
				var_write_count := var_write_count - 1;
				var_extra := "00000000";
			elsif (present_state = END_CHECK_STATUS) then 
				if (is_sync='1' and scfifo_empty='1') then
					var_write_count := write_count;
					var_extra := extra_write_count;
				else
					var_write_count := write_count;
					var_extra := var_extra;
				end if;
			end if;
		end if;
	end process;

	--changing next state
	CHANGING_NEXT_STATE: process(present_state, intel_nspansion, status_full, scfifo_empty, is_sync, sig_flash_data_in, datareg, write_count, numonyx_dev)--, reg_write_count)
	begin
			case (present_state) is
				when START_WRITE_PROCESS =>
					if (status_full = '1') then  --status_full
						next_state <= FULL;
					elsif (scfifo_empty = '0') then
						next_state <= READ_REQUEST ;
					else
						next_state <= IDLE;
					end if;
				
				when IDLE =>
					if (is_sync = '0') then
						if (scfifo_empty = '0') then 
							if(var_write_count = write_count) then
								next_state <= START_WRITE_PROCESS;
							else
								next_state <= READ_REQUEST;
							end if;
						else
							next_state <= IDLE;
						end if;
					else 
						next_state <= END_WRITE;
					end if;
				
				when READ_REQUEST =>
					if (var_write_count > 0) then
						if (status_full = '1') then --status_full
							next_state <= FULL;
						elsif (scfifo_empty = '0') then
							next_state <= WRITE_ADDRESS_BUS;
						else 
							next_state <= IDLE;
						end if;
					else
						next_state <= END_WRITE;
					end if;
				
				when WRITE_ADDRESS_BUS =>
					next_state <= WRITE_DATA_BUS;
				
				when WRITE_DATA_BUS =>
					next_state <= WRITE_TO_FLASH;
				
				when WRITE_TO_FLASH =>
					next_state <= INCREASE_ADDR;
				
				when INCREASE_ADDR =>
					next_state <= READ_REQUEST;
					
				when END_WRITE =>
					next_state <= START_CHECK_STATUS;
					
				when START_CHECK_STATUS =>
					if (numonyx_dev = '1' or intel_nspansion = '1') then
						next_state <= INTEL;
					else
						next_state <= SPANSION;
					end if;	
				
				when INTEL =>
					if (status_full = '1') then --status_full
						next_state <= FULL;
					else
						next_state <= INTEL_PRE_READ;
					end if;
				
				when SPANSION =>
					if (status_full = '1') then --status_full
						next_state <= FULL;
					else
						next_state <= SPANSION_PRE_READ1;
					end if;
				
				when INTEL_PRE_READ =>
					next_state <= INTEL_READ_STATUS;
					
				when INTEL_READ_STATUS =>
 					if(sig_flash_data_in(7) = '1') then
						if (sig_flash_data_in(4) = '0') then
							next_state <= SUCCESS;
						else
 							next_state <= FAIL;
						end if;
					else 
						next_state <= INTEL_POST_READ;
 					end if;
				
				when INTEL_POST_READ =>
						next_state <= INTEL_PRE_READ;
				
				when SPANSION_PRE_READ1 =>
					next_state <= SPANSION_READ_STATUS1;
				
				when SPANSION_READ_STATUS1 =>
					if(sig_flash_data_in(7) = datareg(7)) then
						next_state <= SUCCESS;
					else
						if(sig_flash_data_in(5) = '1') then
							next_state <= SPANSION_POST_READ1;
						else 
							next_state <= SPANSION;
						end if;
					end if;
				
				when SPANSION_POST_READ1 =>
					next_state <= SPANSION_PRE_READ2;
					
				when SPANSION_PRE_READ2 =>
					next_state <= SPANSION_READ_STATUS2;
					
				when SPANSION_READ_STATUS2 =>
					if(sig_flash_data_in(7) = datareg(7)) then
						next_state <= SUCCESS;
					else
						next_state <= FAIL;
					end if;
						
				when SUCCESS =>
					if(numonyx_dev = '1' or intel_nspansion = '1') then
						next_state <= INTEL_CLEAR_STATUS_REG;
					else
						next_state <= END_CHECK_STATUS;
					end if;
					
				when FAIL =>
					if(numonyx_dev = '1' or intel_nspansion = '1') then
						next_state <= INTEL_CLEAR_STATUS_REG;
					else
						next_state <= END_CHECK_STATUS;
					end if;
				
				when FULL =>
					next_state <= FULL;
					
				when INTEL_CLEAR_STATUS_REG =>
					next_state <= END_CHECK_STATUS;
		
				when END_CHECK_STATUS =>
					if (is_sync = '1' and scfifo_empty = '1') then 
						next_state <= END_CHECK_STATUS;
					else
						next_state <= START_WRITE_PROCESS;
					end if;
					
				when others =>
					next_state <= START_WRITE_PROCESS;
			end case;
	end process;
	
	--changing present state
	CHANGING_PRESENT_STATE: process (reset, clk)
	begin
		if (reset = '1') then
			present_state <= START_WRITE_PROCESS;
			
		elsif (clk'event and clk = '1') then
			present_state <= next_state;
		end if;
	end process;
	
	--control signals:scfifo_rdreq
	process (present_state, scfifo_empty)
	begin
		if (present_state = READ_REQUEST and var_write_count /= 0 ) then
			scfifo_rdreq <= not scfifo_empty; -- rdreq only when there is data in scfifo
		else 
			scfifo_rdreq <= '0';
		end if;
	end process;
	
	--flash write, flash_read
	process (present_state)
	begin
			case (present_state) is
				when WRITE_TO_FLASH =>
					sig_flash_write <= '1';
					sig_flash_read <= '0';
				
				when SPANSION =>
					sig_flash_write <= '0';
					sig_flash_read <= '0';
				
				when SPANSION_PRE_READ1 =>
					sig_flash_write <= '0';
					sig_flash_read <= '1';
					
				when SPANSION_PRE_READ2 =>
					sig_flash_write <= '0';
					sig_flash_read <= '1';
				
				when SPANSION_READ_STATUS1 =>
					sig_flash_write <= '0';
					sig_flash_read <= '1';
					
				when SPANSION_READ_STATUS2 =>
					sig_flash_write <= '0';
					sig_flash_read <= '1';

				when INTEL =>
					sig_flash_write <= '1';
					sig_flash_read <= '0';
					
				when INTEL_PRE_READ =>
					sig_flash_write <= '0';
					sig_flash_read <= '1';
					
				when INTEL_READ_STATUS =>
					sig_flash_write <= '0';
					sig_flash_read <= '1';
					
				when INTEL_CLEAR_STATUS_REG =>
					sig_flash_write <= '1';
					sig_flash_read <= '0';
				
				when others =>
					sig_flash_write <= '0';
					sig_flash_read <= '0';
			end case;
	end process;
	
	--addr_count
	process (clk) 
	begin
		if (clk'event and clk = '0') then
			if (present_state = INCREASE_ADDR) then 
				addr_count <= not scfifo_data_in(0); --'0' in the last data bit means increase the address  
			else
				addr_count <= '0';
			end if;
		end if;
	end process;
	
	--datareg, datareg_spansion_buffer_mode
	process (clk, present_state, datareg, word_nbuffer, intel_nspansion, scfifo_data_in, numonyx_dev)
	begin 
		if (clk'event and clk = '0') then
			if (present_state = WRITE_TO_FLASH) then
			--in spansion buffer mode,  a 'Program Buffer to Flash' command is added after each buffer of user data is written into the write buffer, so in flashsm_sm point of view, one 'buffer' = a buffer of user data + one extra command;
			--thus datareg is here to keep the last written user data for check status in stead of the last command   
				if (word_nbuffer = '1') then
						datareg <= scfifo_data_in(DATA_WIDTH DOWNTO 1);
				else
					if (numonyx_dev ='0') then -- check for non numonyx flag bit first
						if( intel_nspansion='0' and var_write_count=1 ) then --check for spansion device
						datareg <= scfifo_data_in(DATA_WIDTH DOWNTO 1);
						else --intel
							datareg <= datareg;
						end if;
					else -- numonyx
						datareg <= datareg;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	--write address bus
	process(clk, present_state, addr_in, intel_nspansion, extra_write_count, write_count, word_nbuffer, sig_flash_addr_out, numonyx_dev)--, reg_write_count)
	begin
		if (clk'event and clk = '0') then
			if (present_state = WRITE_ADDRESS_BUS) then
				if (numonyx_dev ='1') then -- check for numonyx device first
					if (var_write_count = write_count + extra_write_count) then 
						sig_flash_addr_out <= NUMONYX_FL_WRITE_ADDR(ADDR_WIDTH-1 DOWNTO 0); --addr = 0XAA
					else
						sig_flash_addr_out <= addr_in;
					end if;
				else
				if (intel_nspansion = '1') then --intel
					sig_flash_addr_out <= addr_in;
						
				else -- spansion
					if (var_write_count = write_count + extra_write_count) then 
						sig_flash_addr_out <= SPANSION_FL_UNLOCK_1_ADDR(ADDR_WIDTH-1 DOWNTO 0);
					elsif (var_write_count = (write_count + extra_write_count - 1)) then 
						sig_flash_addr_out <= SPANSION_FL_UNLOCK_2_ADDR(ADDR_WIDTH-1 DOWNTO 0);
					elsif (var_write_count = (write_count + extra_write_count - 2)) then 
							if (word_nbuffer = '1') then -- word programming
							sig_flash_addr_out <= SPANSION_FL_UNLOCK_BYPASS_ADDR(ADDR_WIDTH-1 DOWNTO 0);
							else -- buffer programming
							sig_flash_addr_out <= addr_in;
						end if;
					else
						sig_flash_addr_out <= addr_in;
					end if;
				end if;
				end if;
			else
				sig_flash_addr_out <= sig_flash_addr_out;
			end if;
		end if;
	end process;
	
	--write data bus
	process(present_state, scfifo_data_in, intel_nspansion, numonyx_dev)
	begin
		if (numonyx_dev = '1' or intel_nspansion = '1') then --intel
			if(present_state = INTEL) then
				sig_flash_data_out <= INTEL_FL_READ_STATUS (DATA_WIDTH-1 DOWNTO 0);
			elsif (present_state = INTEL_CLEAR_STATUS_REG) then
				sig_flash_data_out <= INTEL_FL_CLEAR_STATUS (DATA_WIDTH-1 DOWNTO 0);
			else
				sig_flash_data_out <= scfifo_data_in(DATA_WIDTH DOWNTO 1);
			end if;
				
		else -- spansion
			sig_flash_data_out <= scfifo_data_in(DATA_WIDTH DOWNTO 1);
		end if;
	end process;
	
	--update status
	process (present_state, is_sync, scfifo_empty) 
	begin
		if (present_state = FAIL) then
			status_error <= '1';
			status_done <= '1';
		elsif (present_state = FULL) then
			status_error <= '0';
			status_done <= '1';			
		elsif (present_state = END_CHECK_STATUS) then
			status_done <= is_sync and scfifo_empty;
			status_error <= '0';
		else
			status_done <= '0';
			status_error <= '0';
		end if;
	end process;
	
end architecture rtl;
			
