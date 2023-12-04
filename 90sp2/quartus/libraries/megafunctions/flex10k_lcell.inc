FUNCTION flex10k_lcell (
						-- INPUTS
						clk,	-- clock input
						dataa,	-- input #1
						datab,	-- input #2
						datac,	-- input #3
						datad,	-- input #4
						aclr,	-- asynchronous clear
						aload,	-- asynchronous load
						cin,	-- carry in
						cascin	-- cascade in
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,		-- normal, arithmetic, updown counter, or clearable counter
						LUT_MASK,		-- LUT function
						PACKED_MODE,		-- lonely register mode
						CLOCK_ENABLE_MODE	-- dataa used as clk_ena if "true"
						)
						RETURNS
						(
						-- OUTPUTS
						combout,	-- combinational output
						regout,		-- registered output
						cout,		-- carry out
						cascout		-- cascade out
						);
