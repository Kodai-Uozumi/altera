--	(c) Altera Corporation, 1995

FUNCTION alt_asynch_counter
					(
					-- INPUTS
					data[LPM_WIDTH - 1..0],
					clock,
					clk_en,
					cnt_en,
					updown,
					aset,
					aconst,
					cin,
					aclr,
					aload,
					sclr,
					sconst,
					sset,
					sload
					)
					WITH
					(
					-- PARAMETERS
					LPM_WIDTH,
					LPM_DIRECTION,
					LPM_MODULUS,
					LPM_AVALUE,
					LPM_SVALUE
					)
					RETURNS
					(
					-- OUPUTS
					q[LPM_WIDTH-1..0],
					cout
					);
