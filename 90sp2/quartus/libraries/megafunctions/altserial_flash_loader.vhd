---------------- SFL -----------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity altserial_flash_loader is
	generic
	(
		intended_device_family : STRING := "Cyclone";
		enable_shared_access : STRING := "OFF";
		enhanced_mode	     : natural := 0;
		lpm_type             : STRING := "ALTSERIAL_FLASH_LOADER"
	);
	port
	(
		scein               : IN STD_LOGIC := '0';
		dclkin              : IN STD_LOGIC := '0';
		sdoin               : IN STD_LOGIC := '0';
		noe                 : IN STD_LOGIC := '0';
		asmi_access_granted : IN std_logic := '1';
		data0out            : OUT STD_LOGIC;
		asmi_access_request : OUT std_logic
	);
end entity altserial_flash_loader;

architecture rtl of altserial_flash_loader is
	component alt_sfl
	port
	(
		-- ASMI IOs
		dclkin              : OUT STD_LOGIC ;
		scein               : OUT STD_LOGIC ;
		sdoin               : OUT STD_LOGIC ;
		asmi_access_request : OUT STD_LOGIC;
		data0out            : IN STD_LOGIC;
		asmi_access_granted : IN STD_LOGIC
	);
	end component;

	component alt_sfl_enhanced
	port
	(
		-- ASMI IOs
		dclkin              : OUT STD_LOGIC ;
		scein               : OUT STD_LOGIC ;
		sdoin               : OUT STD_LOGIC ;
		asmi_access_request : OUT STD_LOGIC;
		data0out            : IN STD_LOGIC;
		asmi_access_granted : IN STD_LOGIC
	);
	end component;

	COMPONENT cyclone_asmiblock 
	port
	(
		dclkin   : in STD_LOGIC;
		scein    : in STD_LOGIC;
		sdoin    : in STD_LOGIC;
		data0out : out STD_LOGIC;
		oe       : in STD_LOGIC
	);
	END COMPONENT;

	COMPONENT cycloneii_asmiblock 
	port
	(
		dclkin   : in STD_LOGIC;
		scein    : in STD_LOGIC;
		sdoin    : in STD_LOGIC;
		data0out : out STD_LOGIC;
		oe       : in STD_LOGIC
	);
	END COMPONENT;

	COMPONENT stratixii_asmiblock 
	port
	(
		dclkin   : in STD_LOGIC;
		scein    : in STD_LOGIC;
		sdoin    : in STD_LOGIC;
		data0out : out STD_LOGIC;
		oe       : in STD_LOGIC
	);
	END COMPONENT;

	COMPONENT stratixiii_asmiblock 
	port
	(
		dclkin   : in STD_LOGIC;
		scein    : in STD_LOGIC;
		sdoin    : in STD_LOGIC;
		data0out : out STD_LOGIC;
		oe       : in STD_LOGIC
	);
	END COMPONENT;

	COMPONENT stratixiv_asmiblock 
	port
	(
		dclkin   : in STD_LOGIC;
		scein    : in STD_LOGIC;
		sdoin    : in STD_LOGIC;
		data0out : out STD_LOGIC;
		oe       : in STD_LOGIC
	);
	END COMPONENT;

	constant ASMI_TYPE_0           : boolean :=
		(
			(intended_device_family = "Cyclone")
		);

	constant ASMI_TYPE_1           : boolean :=
		(
			(intended_device_family = "Cyclone II")
			OR
			(intended_device_family = "Cyclone III")
			OR
			(intended_device_family = "Cyclone III LS")
		);

	constant ASMI_TYPE_2           : boolean :=
		(
			(intended_device_family = "Stratix II")
			OR
			(intended_device_family = "Stratix II GX")
			OR
			(intended_device_family = "Arria GX")
		);

	constant ASMI_TYPE_3           : boolean :=
		(
			(intended_device_family = "Stratix III")
		);

	constant ASMI_TYPE_4           : boolean :=
		(
			(intended_device_family = "Stratix IV")
			OR
			(intended_device_family = "Arria II GX")
		);

	signal dclkin_int              : STD_LOGIC;
	signal sdoin_int               : STD_LOGIC;
	signal scein_int               : STD_LOGIC;
	signal noe_int                 : STD_LOGIC;
	signal data0out_int            : STD_LOGIC;

	signal dclkin_sfl              : STD_LOGIC;
	signal sdoin_sfl               : STD_LOGIC;
	signal scein_sfl               : STD_LOGIC;
	signal asmi_access_request_sfl : STD_LOGIC;
	signal asmi_access_granted_sfl : STD_LOGIC;

	signal sfl_has_access          : STD_LOGIC;

begin

	DEFAULT_PGM: if (enhanced_mode = 0) generate
	sfl_inst: alt_sfl
	port map
	(
		-- ASMI IOs
		dclkin => dclkin_sfl,
		scein => scein_sfl,
		sdoin => sdoin_sfl,
		asmi_access_request => asmi_access_request_sfl,
		data0out => data0out_int,
		asmi_access_granted => asmi_access_granted_sfl
	);
	end generate;

	ENHANCED_PGM: if (enhanced_mode = 1) generate
		sfl_inst_enhanced: alt_sfl_enhanced
		port map
		(
			-- ASMI IOs
			dclkin => dclkin_sfl,
			scein => scein_sfl,
			sdoin => sdoin_sfl,
			asmi_access_request => asmi_access_request_sfl,
			data0out => data0out_int,
			asmi_access_granted => asmi_access_granted_sfl
		);
	end generate;

	SHARED_ACCESS_OFF: if (enable_shared_access = "OFF") generate
		dclkin_int <= dclkin_sfl;
		scein_int <= scein_sfl;
		sdoin_int <= sdoin_sfl;
		noe_int <= '0';
		asmi_access_granted_sfl <= '1';
	end generate;

	SHARED_ACCESS_ON: if (enable_shared_access = "ON") generate
		dclkin_int <= (sfl_has_access and dclkin_sfl) or (not sfl_has_access and dclkin);
		scein_int <= (sfl_has_access and scein_sfl) or (not sfl_has_access and scein);
		sdoin_int <= (sfl_has_access and sdoin_sfl) or (not sfl_has_access and sdoin);
		noe_int <= noe;
		asmi_access_granted_sfl <= asmi_access_granted;
	end generate;

	sfl_has_access <= asmi_access_request_sfl and asmi_access_granted_sfl;

	GEN_ASMI_TYPE_0: if (ASMI_TYPE_0) generate
	asmi_inst: cyclone_asmiblock 
	port map
	(
		dclkin => dclkin_int,
		scein => scein_int,
		sdoin => sdoin_int,
		data0out => data0out_int,
		oe => noe_int and not sfl_has_access -- oe is an active low signal
	);
	end generate GEN_ASMI_TYPE_0;

	GEN_ASMI_TYPE_1: if (ASMI_TYPE_1) generate
	asmi_inst: cycloneii_asmiblock 
	port map
	(
		dclkin => dclkin_int,
		scein => scein_int,
		sdoin => sdoin_int,
		data0out => data0out_int,
		oe => noe_int and not sfl_has_access -- oe is an active low signal
	);
	end generate GEN_ASMI_TYPE_1;

	GEN_ASMI_TYPE_2: if (ASMI_TYPE_2) generate
	asmi_inst: stratixii_asmiblock 
	port map
	(
		dclkin => dclkin_int,
		scein => scein_int,
		sdoin => sdoin_int,
		data0out => data0out_int,
		oe => noe_int and not sfl_has_access -- oe is an active low signal
	);
	end generate GEN_ASMI_TYPE_2;

	GEN_ASMI_TYPE_3: if (ASMI_TYPE_3) generate
	asmi_inst: stratixiii_asmiblock 
	port map
	(
		dclkin => dclkin_int,
		scein => scein_int,
		sdoin => sdoin_int,
		data0out => data0out_int,
		oe => noe_int and not sfl_has_access -- oe is an active low signal
	);
	end generate GEN_ASMI_TYPE_3;

	GEN_ASMI_TYPE_4: if (ASMI_TYPE_4) generate
	asmi_inst: stratixiv_asmiblock 
	port map
	(
		dclkin => dclkin_int,
		scein => scein_int,
		sdoin => sdoin_int,
		data0out => data0out_int,
		oe => noe_int and not sfl_has_access -- oe is an active low signal
	);
	end generate GEN_ASMI_TYPE_4;

	data0out <= data0out_int;
	asmi_access_request <= asmi_access_request_sfl;

end architecture;
