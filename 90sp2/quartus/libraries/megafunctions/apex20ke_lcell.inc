FUNCTION apex20ke_lcell
						(
						-- INPUTS
						clk,					-- clock input
						dataa,					-- LUT input #1
						datab,					-- LUT input #2
						datac,					-- LUT input #3
						datad,					-- LUT input #4
						aclr,					-- asynchronous clear
						sclr,					-- synchronous clear
						sload,					-- synchronous load
						ena,					-- clock enable
						cin,					-- carry in
						cascin					-- cascade input
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,			-- use which LCELL mode???
						LUT_MASK,				-- LUT function
						PACKED_MODE
						)
						RETURNS
						(
						-- OUTPUTS
						combout,				-- combinational output
						regout,					-- registered output
						cout,					-- carry out
						cascout					-- cascaded output
						);