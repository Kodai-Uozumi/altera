-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

ENTITY ministate IS
    	PORT	(reset  : IN BOOLEAN;
		 clock  : IN BIT;
		 ps1,ps2: OUT BIT);
END ministate;

ARCHITECTURE exam of ministate IS

	TYPE STATE_TYPE IS (s0,s1,s2,s3);
	ATTRIBUTE enum_encoding				: STRING;
	ATTRIBUTE enum_encoding of STATE_TYPE		: TYPE IS "00 01 11 10";

	SIGNAL state					: STATE_TYPE;
	SIGNAL next_state				: STATE_TYPE;

	ATTRIBUTE state_vector				: STRING;
	ATTRIBUTE state_vector OF exam 			: ARCHITECTURE IS "state";

BEGIN
	PROCESS (clock)
	BEGIN
		IF (clock'EVENT and clock = '1') THEN
		      state <= next_state;
		END IF;

	END PROCESS;

	PROCESS (state,reset)
	BEGIN
		CASE state IS
                    WHEN s0 =>
			 ps1 <= '0';
			 ps2 <= '0';
			 IF (reset) THEN
			     next_state <= s0;
			 ELSE 
			     next_state <= s1;
			 END IF;

		    WHEN s1 =>
			 ps1 <= '1';
			 ps2 <= '0';
			 IF (reset) THEN
			     next_state <= s0;	
			 ELSE
			     next_state <= s2;
			 END IF;

		    WHEN s2 =>
			 ps1 <= '1';
			 ps2 <= '1';
			 IF (reset) THEN
			     next_state <= s0;
			 ELSE
			     next_state <= s3;
			 END IF;

		    WHEN s3 =>
			 ps1 <= '0';
			 ps2 <= '1';
			 next_state <= s0;
		END CASE;
	 END PROCESS;
END EXAM;
