FUNCTION stratixgx_lcell
						(
						-- INPUTS
						clk,					-- clock input
						dataa,					-- LUT input #1
						datab,					-- LUT input #2
						datac,					-- LUT input #3
						datad,					-- LUT input #4
						aclr,					-- asynchronous clear
						aload,					-- asynchronous load					
						sclr,					-- synchronous clear
						sload,					-- synchronous load
						ena,					-- clock enable
						cin,					-- carry in
						cin0,
						cin1,
						inverta,
						regcascin

						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,			-- use which LCELL mode???
						LUT_MASK,				-- LUT function
						SYNCH_MODE,				-- Use synch mode
						REGISTER_CASCADE_MODE,	-- reg cascademode
						SUM_LUTC_INPUT   		--choice of LUTC input
						)
						RETURNS
						(
						-- OUTPUTS
						combout,				-- combinational output
						regout,					-- registered output
						cout,					-- carry out
						cout0,
						cout1
						);
