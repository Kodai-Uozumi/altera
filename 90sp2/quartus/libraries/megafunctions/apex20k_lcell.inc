FUNCTION apex20k_lcell (
						-- INPUTS
						clk,		-- clock input 
						dataa, 		-- input #1
						datab, 		-- input #2
						datac, 		-- input #3 carry_in, or register feedback
						datad,		-- input #4
						aclr,		-- asynchronous clear
						sclr,		-- synchronous clear
						sload,		-- synchronous load
						ena,		-- clock enable
						cin,		-- carry in
						cascin		-- cascade in
						) 
						WITH 
						(
						-- PARAMETERS
						OPERATION_MODE,	-- normal, counter, arithmetic, or quick feedback counter
						LUT_MASK,
						PACKED_MODE
						)
						RETURNS
						(
						-- OUTPUTS
						combout,	-- combinational output
						regout,		-- registered output
						cout,		-- carry out
						cascout		-- cascade out
						);