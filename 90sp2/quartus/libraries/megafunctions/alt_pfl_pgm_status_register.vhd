library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
library altera_mf;
use altera_mf.altera_mf_components.all;

entity alt_pfl_pgm_status_register is
	port
	(
		enable	: in STD_LOGIC;
		clk		: in STD_LOGIC;
		shiftin	: in STD_LOGIC;
		load	: in STD_LOGIC;
		aclr 	: in STD_LOGIC;
		set_full	: in STD_LOGIC;
		set_done	: in STD_LOGIC;
		set_error 	: in STD_LOGIC;
				
		full_bit: out STD_LOGIC;
		shiftout: out STD_LOGIC;
		pout	: out STD_LOGIC_VECTOR(2 DOWNTO 0) --for debug purpose
	);
end entity alt_pfl_pgm_status_register;

architecture rtl of alt_pfl_pgm_status_register is
	signal reg_full	: STD_LOGIC;
	signal reg_error: STD_LOGIC;
	signal reg_done	: STD_LOGIC;
	signal n_clk	: STD_LOGIC;
	signal temp	: STD_LOGIC_VECTOR(2 downto 0);
	
	COMPONENT lpm_shiftreg
		GENERIC 
		(
			LPM_WIDTH		: POSITIVE;
			LPM_AVALUE		: STRING := "UNUSED";
			LPM_PVALUE		: STRING := "UNUSED";
			LPM_DIRECTION	: STRING := "UNUSED";
			LPM_TYPE		: STRING := "LPM_SHIFTREG";
			LPM_HINT		: STRING := "UNUSED"
		);
		PORT 
		(
			data			: IN STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
			clock			: IN STD_LOGIC;
			enable, shiftin	: IN STD_LOGIC := '1';
			load, sclr, sset, aclr, aset: IN STD_LOGIC := '0';
			q				: OUT STD_LOGIC_VECTOR(LPM_WIDTH-1 DOWNTO 0);
			shiftout		: OUT STD_LOGIC
		);
	END COMPONENT lpm_shiftreg;
	
	COMPONENT reg
		port
		(
			clk	: in STD_LOGIC;
			set	: in STD_LOGIC := '0';
			clr : in STD_LOGIC := '0';
			q	: out STD_LOGIC
		);
	END COMPONENT reg;

begin
	full_reg: reg
		port map
		(
			clk	=> clk,
			set	=> set_full,
			clr => aclr,
			q	=> reg_full
		);

	done_reg: reg
		port map
		(
			clk	=> clk,
			set	=> set_done,
			clr => aclr,
			q	=> reg_done
		);
	
	error_reg: reg
		port map
		(
			clk	=> clk,
			set	=> set_error,
			clr => aclr,
			q	=> reg_error
		);
		
	status: lpm_shiftreg
		generic map
		(
			LPM_WIDTH 		=> 3,
			LPM_DIRECTION	=> "RIGHT"
		)
		port map
		(
			enable			=> enable,
			data			=> temp,
			clock			=> n_clk,
			load			=> load,
			shiftin			=> shiftin,
			shiftout		=> shiftout,
			q				=> pout
		);

	full_bit <= reg_full;
	n_clk <= not clk;
	temp <= reg_full & reg_done & reg_error;
end architecture rtl;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity reg is
	port
	(
		clk	: in STD_LOGIC;
		set	: in STD_LOGIC := '0';
		clr : in STD_LOGIC := '0';
		q	: out STD_LOGIC
	);
end entity reg;

architecture rtl of reg is
	signal temp: STD_LOGIC;

begin
	process (clk, set, clr, temp)
	begin
		if (clr = '1') then
			temp <= '0';
		elsif (clk'event and clk = '1') then
			if (set = '1') then
				temp <= '1';
			else
				temp <= temp;
			end if;
		else
			temp <= temp;
		end if;
	end process;
	q <= temp;
end architecture rtl;


	
