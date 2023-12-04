FUNCTION mercury_lcell
						(
						-- INPUTS
						clk,					-- clock input
						dataa,					-- LUT input #1
						datab,					-- LUT input #2
						datac,					-- LUT input #3
						datad,					-- LUT input #4
						aclr,					-- asynchronous clear
						apre,					-- asynchronous preset
						aload,					-- asynchronous load					
						sclr,					-- synchronous clear
						sload,					-- synchronous load
						ena,					-- clock enable
						cin,					-- carry in
						multsela,				-- multiplier a input
						multselb				-- multiplier b input
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,			-- use which LCELL mode???
						LUT_MASK,				-- LUT function
						PACKED_MODE,
						MULTIPLIER_OUTPUT		-- for describing fanout in multiplier mode
						)
						RETURNS
						(
						-- OUTPUTS
						combout,				-- combinational output
						regout,					-- registered output
						cout,					-- carry out
						multout					-- multiplier output
						);
