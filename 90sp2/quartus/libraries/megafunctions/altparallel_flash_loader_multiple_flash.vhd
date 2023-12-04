library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

package TOP_CONST is
	constant TOP_PFL_IR_BITS: natural := 5;
	constant N_FLASH_BITS: natural :=4;
end package TOP_CONST;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
use WORK.TOP_CONST.all;

entity altparallel_flash_loader_multiple_flash is
	generic 
	(
		addr_width			: natural := 20;
		auto_restart		: STRING := "OFF";
		clk_divisor			: natural := 1;
		page_clk_divisor	: natural := 1;
		option_bits_start_address: natural := 0;
		conf_data_width		: natural := 1;
		flash_data_width	: natural := 16;
		lpm_type			: string := "ALTPARALLEL_FLASH_LOADER";
		features_pgm: natural := 1;
		features_cfg: natural := 1;
		safe_mode_halt			: natural := 0;
		safe_mode_retry			: natural := 1;
		safe_mode_revert		: natural := 0;
		safe_mode_revert_addr	: natural := 0;
		TRISTATE_CHECKBOX		: natural := 0;
		dclk_divisor            : natural := 1;
		normal_mode				: natural := 1;
		burst_mode				: natural := 0;
		page_mode				: natural := 0;
		burst_mode_intel		: natural := 0;
		burst_mode_spansion		: natural := 0;
		burst_mode_numonyx		: natural := 0;
		enhanced_flash_programming: natural := 0;
		fifo_size : natural :=16;
		n_flash	 : natural := 1
	);
	port
	(
		pfl_clk			: in STD_LOGIC := '0';
		pfl_nreset		: in STD_LOGIC := '0';
		pfl_flash_access_granted: in STD_LOGIC := '0';
		pfl_flash_access_request: out STD_LOGIC;
		pfl_nreconfigure		: in STD_LOGIC := '1';
		
-- 		flash output
		flash_addr		: out STD_LOGIC_VECTOR (addr_width-1 downto 0);
		flash_data		: inout STD_LOGIC_VECTOR (flash_data_width-1 downto 0);
		flash_nce		: out STD_LOGIC_VECTOR (n_flash-1 downto 0);
		flash_noe		: out STD_LOGIC;
		flash_nwe		: out STD_LOGIC;
		flash_clk		: out STD_LOGIC;
		flash_nadv		: out STD_LOGIC;
		--flash_rdy		: in STD_LOGIC;
		flash_nreset	: out STD_LOGIC;
		
--		FPGA
		fpga_pgm		: in STD_LOGIC_VECTOR (2 DOWNTO 0) := (others=>'0');
		fpga_conf_done	: in STD_LOGIC := '0';
		fpga_nstatus	: in STD_LOGIC := '0';
		fpga_dclk		: out STD_LOGIC;
		fpga_data		: out STD_LOGIC_VECTOR (conf_data_width-1 downto 0);
		fpga_nconfig	: out STD_LOGIC
	);
end entity altparallel_flash_loader_multiple_flash;

architecture rtl of altparallel_flash_loader_multiple_flash is
	COMPONENT alt_pfl_multiple_flash
	generic
	(
		PFL_IR_BITS				: natural;
		ADDR_WIDTH				: natural;
		OPTION_START_ADDR		: natural;
		CLK_DIVISOR				: natural;
		PAGE_CLK_DIVISOR		: natural;
		CONF_DATA_WIDTH	: natural;
		FLASH_DATA_WIDTH: natural;
		FEATURES_PGM: natural;
		FEATURES_CFG: natural;
		SAFE_MODE_HALT			: natural := 0;
		SAFE_MODE_RETRY			: natural := 1;
		SAFE_MODE_REVERT		: natural := 0;
		SAFE_MODE_REVERT_ADDR	: natural := 0;
		TRISTATE_CHECKBOX		: natural := 0;
		DCLK_DIVISOR            : natural := 2;
		NORMAL_MODE				: natural := 1;
		BURST_MODE				: natural := 0;
		PAGE_MODE				: natural := 0;
		BURST_MODE_INTEL		: natural := 0;
		BURST_MODE_SPANSION		: natural := 0;
		BURST_MODE_NUMONYX		: natural := 0;
		ENHANCED_FLASH_PROGRAMMING	: natural := 0;
		FIFO_SIZE				 : natural := 16;
		N_FLASH					: natural :=1;
		N_FLASH_BITS			: natural :=4
	);
	port
	(
		pfl_clk			: in STD_LOGIC;
		pfl_nreset		: in STD_LOGIC;
		pfl_flash_access_granted: in STD_LOGIC;
		pfl_flash_access_request: out STD_LOGIC;
		pfl_nreconfigure		: in STD_LOGIC;

-- 		flash output
		flash_addr		: out STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
		flash_data		: inout STD_LOGIC_VECTOR (FLASH_DATA_WIDTH-1 downto 0);
		flash_nce		: out STD_LOGIC_VECTOR (n_flash-1 downto 0);
		flash_noe		: out STD_LOGIC;
		flash_nwe		: out STD_LOGIC;
		flash_clk		: out STD_LOGIC;
		flash_nadv		: out STD_LOGIC;
		flash_rdy		: in STD_LOGIC;
		flash_nreset	: out STD_LOGIC;
		
--		FPGA
		fpga_pgm		: in STD_LOGIC_VECTOR (2 DOWNTO 0);
		fpga_conf_done	: in STD_LOGIC;
		fpga_nstatus	: in STD_LOGIC;
		dclk			: out STD_LOGIC;
		fpga_data		: out STD_LOGIC_VECTOR (CONF_DATA_WIDTH-1 downto 0);
		fpga_nconfig	: out STD_LOGIC
	);
	END COMPONENT;
	
begin
	pfl_inst: alt_pfl_multiple_flash
	generic map
	(
		ADDR_WIDTH			=> addr_width,
		OPTION_START_ADDR	=> option_bits_start_address,
		CLK_DIVISOR			=> clk_divisor,
		PAGE_CLK_DIVISOR	=> page_clk_divisor,
		PFL_IR_BITS			=> TOP_PFL_IR_BITS,
		CONF_DATA_WIDTH		=> conf_data_width,
		FLASH_DATA_WIDTH	=> flash_data_width,
		FEATURES_CFG		=> features_cfg,
		FEATURES_PGM		=> features_pgm,
		SAFE_MODE_HALT => safe_mode_halt,
		SAFE_MODE_RETRY => safe_mode_retry,
		SAFE_MODE_REVERT => safe_mode_revert,
		SAFE_MODE_REVERT_ADDR => safe_mode_revert_addr,
		TRISTATE_CHECKBOX => TRISTATE_CHECKBOX,
		DCLK_DIVISOR => DCLK_DIVISOR,
		NORMAL_MODE => normal_mode,
		BURST_MODE => burst_mode,
		PAGE_MODE => page_mode,
		BURST_MODE_INTEL => burst_mode_intel,
		BURST_MODE_SPANSION => burst_mode_spansion,
		BURST_MODE_NUMONYX => burst_mode_numonyx,
		ENHANCED_FLASH_PROGRAMMING => ENHANCED_FLASH_PROGRAMMING,
		FIFO_SIZE => FIFO_SIZE,
		N_FLASH => N_FLASH,
		N_FLASH_BITS => N_FLASH_BITS
	)
	port map
	(
		pfl_clk 		=> pfl_clk,
		pfl_nreset		=> pfl_nreset,
		pfl_flash_access_granted => pfl_flash_access_granted,
		pfl_flash_access_request => pfl_flash_access_request,
		pfl_nreconfigure => pfl_nreconfigure,

-- 		flash output
		flash_addr		=> flash_addr,
		flash_data		=> flash_data,
		flash_nce		=> flash_nce,
		flash_noe		=> flash_noe,
		flash_nwe		=> flash_nwe,
		flash_clk		=> flash_clk,
		flash_nadv		=> flash_nadv,
		flash_rdy		=> '1', --flash_rdy,
		flash_nreset	=> flash_nreset,
		
--		FPGA
		fpga_pgm		=> fpga_pgm,
		fpga_conf_done	=> fpga_conf_done,
		fpga_nstatus	=> fpga_nstatus,
		dclk			=> fpga_dclk,
		fpga_data		=> fpga_data,
		fpga_nconfig	=> fpga_nconfig
	);
end architecture;
