FUNCTION max_mcell (
			-- INPUTS
			clk,
			aclr,
			pexpin,
			fpin,
			pterm0[pterm0_width-1..0],
			pterm1[pterm1_width-1..0],
			pterm2[pterm2_width-1..0],
			pterm3[pterm3_width-1..0],
			pterm4[pterm4_width-1..0],
			pterm5[pterm5_width-1..0],
			pxor[pxor_width-1..0],
			pclk[pclk_width-1..0],
			pena[pena_width-1..0],
			paclr[paclr_width-1..0],
			papre[papre_width-1..0]
			)
			WITH
			(
			-- PARAMETERS
			OPERATION_MODE,
			OUTPUT_MODE,
			REGISTER_MODE,
			PEXP_MODE,
			POWER_UP,
			pterm0_width,
			pterm1_width,
			pterm2_width,
			pterm3_width,
			pterm4_width,
			pterm5_width,
			pxor_width,
			pclk_width,
			pena_width,
			paclr_width,
			papre_width
			)
			RETURNS
			(
			-- OUTPUTS
			dataout,
			pexpout
			);
