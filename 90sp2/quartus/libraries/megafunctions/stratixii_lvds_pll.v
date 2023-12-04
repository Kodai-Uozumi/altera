module stratixii_lvds_pll(inclk, ena, areset, clk, locked, sclkout, enable);

    input   [1:0] inclk;
    input   ena;
    input   areset;
    output  [5:0] clk;
    output  locked;
    output  [5:0] sclkout;
    output  [1:0] enable;

    parameter pll_type = "fast";
    parameter vco_multiply_by = "8";
    parameter vco_divide_by = "1";
    parameter clk0_multiply_by = "8";
    parameter clk0_divide_by = "8";
    parameter clk1_multiply_by = clk0_multiply_by;
    parameter clk1_divide_by = clk0_divide_by;
 	parameter common_rx_tx = "on";
	parameter compensate_clock = "lvdsclk";
	parameter operation_mode = "normal";
	parameter inclk0_input_frequency = 0;
	parameter in_phase_shift = 0;
	parameter out_phase_shift = in_phase_shift;
	
	stratixii_pll pll (
		.inclk(inclk),
    	.ena(ena),
    	.areset(areset),
    	.clk(clk),
	    .locked(locked),
	    .sclkout(sclkout),
    	.enable0(enable[0]),
    	.enable1(enable[1])
	);

    defparam
            pll.pll_type = pll_type,
            pll.inclk0_input_frequency = inclk0_input_frequency,
            pll.vco_multiply_by = vco_multiply_by, // M
            pll.vco_divide_by  = vco_divide_by,
            pll.clk0_multiply_by = clk0_multiply_by , // M
            pll.clk0_divide_by = clk0_divide_by, // DESER
            pll.clk1_multiply_by = clk1_multiply_by , // M
            pll.clk1_divide_by = clk1_divide_by, // DESER
			pll.compensate_clock = compensate_clock,
			pll.operation_mode = operation_mode,
			pll.common_rx_tx = common_rx_tx,
			pll.clk0_phase_shift = in_phase_shift -(inclk0_input_frequency / vco_multiply_by / 2),
			pll.sclkout0_phase_shift = in_phase_shift -(inclk0_input_frequency / vco_multiply_by / 2),
			pll.clk1_phase_shift = out_phase_shift -(inclk0_input_frequency / vco_multiply_by / 2),
			pll.sclkout1_phase_shift = out_phase_shift -(inclk0_input_frequency / vco_multiply_by / 2);

endmodule // stratixii_lvds_pll



