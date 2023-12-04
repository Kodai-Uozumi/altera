module alt_cal_edge_detect (
	pd_edge,
	reset,
	testbus
);
output pd_edge;
input reset;
input testbus;

wire pd_xor;
wire pd_posedge;
wire pd_negedge;
assign pd_xor = ~(pd_posedge ^ pd_negedge);

stratixii_lcell_ff ff2 (
.clk (pd_xor),
.datain (1'b1),
.adatasdata (1'b1),
.aclr (reset),
.aload (1'b0),
.regout (pd_edge),
.sload (1'b0),
.sclr (1'b0),
.ena (1'b1)
);

stratixii_lcell_ff ff0 (
.clk (testbus),
.datain (1'b1),
.adatasdata (1'b0),
.aclr (1'b0),
.aload (reset),
.regout (pd_posedge),
.sload (1'b0),
.sclr (1'b0),
.ena (1'b1)
);

stratixii_lcell_ff ff1 (
.clk (~testbus),
.datain (1'b0),
.adatasdata (1'b1),
.aclr (1'b0),
.aload (reset),
.regout (pd_negedge),
.sload (1'b0),
.sclr (1'b0),
.ena (1'b1)
);

endmodule


module alt_cal (
	clock,
	reset,
	start,
	busy,
	dprio_addr,
	quad_addr,
	dprio_dataout,
	dprio_datain,
	dprio_wren,
	dprio_rden,
	dprio_busy,
	retain_addr,
	remap_addr,
	testbuses,
	cal_error
);
	parameter sim_model_mode = "FALSE";
	parameter lpm_type = "alt_cal";
	parameter lpm_hint = "UNUSED";

	parameter number_of_channels = 4;
	parameter channel_address_width = 2;
	parameter sample_length = 8'd100;

	input clock;				// reconfig clk
	input reset;				// reconfig reset (if applicable)
	input start;				// disconnect for now?
	output busy;				// output to alt4gxb_reconfig's busy, and to reconfig_togxb bus
	output [15:0] dprio_addr;		// mux into alt_dprio
	output [6:0] quad_addr;
	output [15:0] dprio_dataout;		// mux into alt_dprio
	input [15:0] dprio_datain;		// from alt_dprio
	output dprio_wren;			// mux into alt_dprio
	output dprio_rden;			// mux into alt_dprio
	input dprio_busy;			// from alt_dprio
	output retain_addr;			// to alt_dprio to skip the addr frame on writes
	input [9:0] remap_addr;		// from the logical channel address remapper registers
	input [(number_of_channels*4)-1:0] testbuses;		// input from reconfig_fromgxb bus, should be number_of_channels * 4
	output [(number_of_channels-1):0] cal_error;

	assign cal_error = {(number_of_channels-1){1'b0}};

parameter IDLE				=	4'd0;
parameter CH_WAIT			=	4'd1;
parameter TESTBUS_SET		=	4'd2;
parameter OFFSETS_PDEN_RD	=	4'd3;
parameter OFFSETS_PDEN_WR	=	4'd4;
parameter CAL_PD_WR			=	4'd5;
parameter CAL_RX_RD			=	4'd6;
parameter CAL_RX_WR			=	4'd7;
parameter DPRIO_WAIT		=	4'd8;
parameter SAMPLE_TB			=	4'd9;
parameter TEST_INPUT		=	4'd10;
parameter CH_ADV			=	4'd12;
parameter DPRIO_READ		=	4'd14;
parameter DPRIO_WRITE		=	4'd15;

// p0addr is from cbx_dcfifo_low_latency_stratixii.cpp
reg	p0addr/* synthesis ALTERA_ATTRIBUTE="PRESERVE_REGISTER=ON;POWER_UP_LEVEL=LOW" */;
wire powerup;
assign powerup = p0addr;

	wire [15:0] addr;
	
	reg [3:0] state;
	reg [3:0] ret_state;
	reg busy;
	reg [11:0] address;
	reg [15:0] dataout;
	reg write_reg;
	reg read;
	reg did_dprio;
	reg done;
	reg [7:0] channel;
	
	reg cal_en;
	reg [7:0] counter;
	reg [7:0] dprio_save;
	reg dprio_reuse;
	reg [4:0] cal_rx_lr, cal_rx_lr_l;
	reg [3:0] cal_pd0, cal_pd90, cal_pd180, cal_pd270;
	reg [3:0] cal_pd0_l, cal_pd90_l, cal_pd180_l, cal_pd270_l;
	reg [3:0] cal_done, cal_inc;
	reg rx_done, rx_inc;
	wire [7:0] cal_rx;
	wire [15:0] cal_pd;
	wire [3:0] ch_testbus;
	wire [3:0] int_pd0, int_pd90, int_pd180, int_pd270;
	wire [3:0] src_pd0, src_pd90, src_pd180, src_pd270;
	wire [4:0] avg_pd0, avg_pd90, avg_pd180, avg_pd270;
	wire [5:0] avg_cal_rx;
	
	assign cal_rx = (cal_rx_lr[4] == 1'b0) ? {4'd0, 4'hF - cal_rx_lr[3:0]} : {cal_rx_lr[3:0], 4'd0};
	assign src_pd0 = (rx_done == 1'b0 ? cal_rx_lr[4:1] : cal_pd0);
	assign src_pd90 = (rx_done == 1'b0 ? cal_rx_lr[4:1] : cal_pd90);
	assign src_pd180 = (rx_done == 1'b0 ? cal_rx_lr[4:1] : cal_pd180);
	assign src_pd270 = (rx_done == 1'b0 ? cal_rx_lr[4:1] : cal_pd270);
	assign int_pd0 = (src_pd0[3] == 1'b0 ? (4'hF - src_pd0) : {1'b0, src_pd0[2:0]});
	assign int_pd90 = (src_pd90[3] == 1'b0 ? (4'hF - src_pd90) : {1'b0, src_pd90[2:0]});
	assign int_pd180 = (src_pd180[3] == 1'b0 ? (4'hF - src_pd180) : {1'b0, src_pd180[2:0]});
	assign int_pd270 = (src_pd270[3] == 1'b0 ? (4'hF - src_pd270) : {1'b0, src_pd270[2:0]});
	assign cal_pd = {int_pd0, int_pd90, int_pd180, int_pd270};
	assign avg_pd0 = cal_pd0 + cal_pd0_l;
	assign avg_pd90 = cal_pd90 + cal_pd90_l;
	assign avg_pd180 = cal_pd180 + cal_pd180_l;
	assign avg_pd270 = cal_pd270 + cal_pd270_l;
	assign avg_cal_rx = cal_rx_lr + cal_rx_lr_l;



generate
if (number_of_channels == 1) begin: alt_cal_nomux_gen
	assign ch_testbus = testbuses[3:0];
end
else begin: alt_cal_mux_gen
	lpm_mux	testbus_mux (
			.sel (channel[channel_address_width-1:0]),
			.data (testbuses),
			.result (ch_testbus)
			// synopsys translate_off
			,.aclr (),.clken (),.clock ()
			// synopsys translate_on
			);
	defparam
		testbus_mux.lpm_size = number_of_channels,
		testbus_mux.lpm_type = "LPM_MUX",
		testbus_mux.lpm_width = 4,
		testbus_mux.lpm_widths = channel_address_width;
end
endgenerate
	

	assign dprio_dataout = dataout;
	assign dprio_wren = write_reg;
	assign dprio_rden = read;
	assign dprio_addr = {1'b0, channel[1:0], address[11:0]};
	assign quad_addr = {1'b0, channel[7:2]};
	assign retain_addr = 1'b0;



// {pd_0,pd_1,pd_0_p,pd_1_p} == 0110 == positive solid edge
// {pd_0,pd_1,pd_0_p,pd_1_p} == 1001 == negative solid edge
// look for (pd_0 ^ pd_0_p) & (pd_1 ^ pd_1_p) for solid edges
reg [3:0] pd_0, pd_1;
reg [3:0] pd_0_p, pd_1_p;
wire [3:0] solid_edges = (pd_0 ^ pd_0_p) & (pd_1 ^ pd_1_p);
wire [3:0] data_e;
wire samp_reset = (state == DPRIO_WRITE) ? 1'b1 : 1'b0;
reg [3:0] ignore_solid;
wire [3:0] data_solid = solid_edges & (~ignore_solid);

alt_cal_edge_detect pd0_det (
	.pd_edge (data_e[0]),
	.reset (samp_reset),
	.testbus (ch_testbus[0])
);
alt_cal_edge_detect pd90_det (
	.pd_edge (data_e[1]),
	.reset (samp_reset),
	.testbus (ch_testbus[1])
);
alt_cal_edge_detect pd180_det (
	.pd_edge (data_e[2]),
	.reset (samp_reset),
	.testbus (ch_testbus[2])
);
alt_cal_edge_detect pd270_det (
	.pd_edge (data_e[3]),
	.reset (samp_reset),
	.testbus (ch_testbus[3])
);

wire [3:0] edges = data_e | data_solid;


	always @(posedge clock) begin
		p0addr <= 1'b1;
		if (reset == 1'b1) begin
			state <= IDLE;
			ret_state <= IDLE;
			busy <= 1'b0;
			address <= 12'd0;
			dataout <= 16'd0;
			write_reg <= 1'b0;
			read <= 1'b0;
			did_dprio <= 1'b0;
			done <= 1'b0;
			channel <= 8'd0;
			
			cal_en <= 1'b0;
			cal_rx_lr <= 5'h00;
			cal_rx_lr_l <= 5'h00;
			{cal_pd0, cal_pd90, cal_pd180, cal_pd270} <= {16'h0000};
			{cal_pd0_l, cal_pd90_l, cal_pd180_l, cal_pd270_l} <= {16'h0000};
			{rx_done, rx_inc} <= {2{1'd0}};
			{cal_done, cal_inc} <= {2{4'd0}};
			counter <= 8'd0;
			dprio_save <= 8'd0;
			dprio_reuse <= 1'b0;
			ignore_solid <= 4'd0;
		end
		else begin
			case (state)
			IDLE: begin
					cal_en <= 1'b0;
					channel <= 8'd0;
					if ((powerup == 1'b1 & done == 1'b0) || start == 1'b1) begin
						state <= CH_WAIT;
						busy <= 1'b1;
					end
					else begin
						state <= IDLE;
						busy <= 1'b0;
					end
				end
			CH_WAIT: begin
					{cal_pd0, cal_pd90, cal_pd180, cal_pd270} <= {16'h0000};
					{cal_pd0_l, cal_pd90_l, cal_pd180_l, cal_pd270_l} <= {16'h0000};
					cal_rx_lr <= 5'h00;
					cal_rx_lr_l <= 5'h00;
					{rx_done, rx_inc} <= {2{1'd0}};
					{cal_done, cal_inc} <= {2{4'd0}};
					ignore_solid <= 4'hF;
					counter <= 8'd0;
					dprio_reuse <= 1'b0;
					state <= TESTBUS_SET;
				end
			TESTBUS_SET: begin
					if (remap_addr[9:0] == 10'h3FF) begin
						state <= CH_ADV;
					end
					else begin
						state <= OFFSETS_PDEN_RD;
						cal_en <= ~cal_en;
					end
				end
			OFFSETS_PDEN_RD: begin
					address <= 12'hC02;	// NPP table 38
					read <= 1'b0;
					did_dprio <= 1'b0;
					state <= DPRIO_READ;
					ret_state <= OFFSETS_PDEN_WR;
				end
			OFFSETS_PDEN_WR: begin
					dataout <= {dprio_datain[15:7], cal_en, dprio_datain[5:0]};
					write_reg <= 1'b0;
					did_dprio <= 1'b0;
					// if the channel doesn't need calibration, skip it
					cal_en <= (dprio_datain[2] == 1'b0 ? 1'b0 : cal_en);
					state <= (dprio_datain[2] == 1'b0 ? CH_ADV : DPRIO_WRITE);
					ret_state <= (cal_en == 1'b1 ? CAL_PD_WR : CH_ADV);
				end
			CAL_PD_WR: begin
					address <= 12'hC06;	// NPP table 42
					dataout <= {cal_pd};
					write_reg <= 1'b0;
					did_dprio <= 1'b0;
					state <= DPRIO_WRITE;
					ret_state <= CAL_RX_RD;
				end
			CAL_RX_RD: begin
					address <= 12'hC01;	// NPP table 37
					read <= 1'b0;
					did_dprio <= 1'b0;
					dprio_reuse <= 1'b1;
					state <= (dprio_reuse == 1'b1 ? CAL_RX_WR : DPRIO_READ);
					ret_state <= CAL_RX_WR;
				end
			CAL_RX_WR: begin
					address <= 12'hC01;	// NPP table 37
					dataout <= {dprio_save[7:3], cal_rx, dprio_save[2:0]};
					write_reg <= 1'b0;
					did_dprio <= 1'b0;
					state <= DPRIO_WRITE;
					ret_state <= DPRIO_WAIT;
					counter <= 8'd0;
				end
			DPRIO_WAIT: begin
					if (counter == 8'd6) begin
						counter <= 8'd0;
						state <= SAMPLE_TB;
						pd_0_p <= pd_0;
						pd_1_p <= pd_1;
						{pd_0, pd_1} <= 8'hFF;
					end
					else begin
						counter <= counter + 8'd1;
						state <= DPRIO_WAIT;
					end
				end
			SAMPLE_TB: begin
					pd_0 <= pd_0 & ~ch_testbus;
					pd_1 <= pd_1 & ch_testbus;
					if (counter == sample_length) begin
						counter <= 8'd0;
						state <= TEST_INPUT;
					end
					else begin
						counter <= counter + 8'd1;
						state <= SAMPLE_TB;
					end
				end
			TEST_INPUT: begin
					if ({rx_done, cal_done} == 5'b11111) begin
						state <= TESTBUS_SET;
					end
					else begin
						state <= CAL_PD_WR;
					end

					if (rx_done == 1'b0) begin
						if (edges[0] | edges[2]) begin
							ignore_solid <= 4'hF;
							if (rx_inc == 1'b0) begin
								cal_rx_lr_l <= cal_rx_lr;
								rx_inc <= 1'b1;
								cal_rx_lr <= 5'b11111;
							end
							else begin
								cal_rx_lr <= avg_cal_rx[5:1];
								rx_done <= 1'b1;	//done, state <= testbus_set
							end
						end
						else if ((cal_rx_lr == 5'b11111 && rx_inc == 1'b0) ||
					       		(cal_rx_lr == cal_rx_lr_l && rx_inc == 1'b1)) begin
							rx_done <= 1'b1;	//error
							ignore_solid <= 4'hF;
							cal_rx_lr <= rx_inc ? cal_rx_lr : 5'b11111;
						end
						else begin
							cal_rx_lr <= cal_rx_lr + (rx_inc ? 5'b11111 : 5'b00001);
							ignore_solid <= 4'h0;
						end
					end
					
					if (rx_done && cal_done[0] == 1'b0) begin
						if (edges[0]) begin
							cal_inc[0] <= 1'b1;
							ignore_solid[0] <= 1'b1;
							if (cal_inc[0] == 1'b0) begin
								cal_pd0_l <= cal_pd0;
								cal_pd0 <= 4'hF;
							end
							else begin
								cal_pd0 <= avg_pd0[4:1];
								cal_done[0] <= 1'b1;	//done
							end
						end
						else if ((cal_pd0 == 4'hF && cal_inc[0] == 1'b0) ||
					       		(cal_pd0 == cal_pd0_l && cal_inc[0] == 1'b1)) begin
							cal_done[0] <= 1'b1;		//error
							ignore_solid[0] <= 1'b1;
							cal_pd0 <= cal_inc[0] ? cal_pd0 : 4'h0;
						end
						else begin
							cal_pd0 <= cal_pd0 + (cal_inc[0] ? 4'hF : 4'h1);
							ignore_solid[0] <= 1'b0;
						end
					end

					if (rx_done && cal_done[1] == 1'b0) begin
						if (edges[1]) begin
							cal_inc[1] <= 1'b1;
							ignore_solid[1] <= 1'b1;
							if (cal_inc[1] == 1'b0) begin
								cal_pd90_l <= cal_pd90;
								cal_pd90 <= 4'hF;
							end
							else begin
								cal_pd90 <= avg_pd90[4:1];
								cal_done[1] <= 1'b1;	//done
							end
						end
						else if ((cal_pd90 == 4'hF && cal_inc[1] == 1'b0) ||
					       		(cal_pd90 == cal_pd90_l && cal_inc[1] == 1'b1)) begin
							cal_done[1] <= 1'b1;		//error
							ignore_solid[1] <= 1'b1;
							cal_pd90 <= cal_inc[1] ? cal_pd90 : 4'h0;
						end
						else begin
							cal_pd90 <= cal_pd90 + (cal_inc[1] ? 4'hF : 4'h1);
							ignore_solid[1] <= 1'b0;
						end
					end

					if (rx_done && cal_done[2] == 1'b0) begin
						if (edges[2]) begin
							cal_inc[2] <= 1'b1;
							ignore_solid[2] <= 1'b1;
							if (cal_inc[2] == 1'b0) begin
								cal_pd180_l <= cal_pd180;
								cal_pd180 <= 4'hF;
							end
							else begin
								cal_pd180 <= avg_pd180[4:1];
								cal_done[2] <= 1'b1;	//done
							end
						end
						else if ((cal_pd180 == 4'hF && cal_inc[2] == 1'b0) ||
					       		(cal_pd180 == cal_pd180_l && cal_inc[2] == 1'b1)) begin
							cal_done[2] <= 1'b1;		//error
							ignore_solid[2] <= 1'b1;
							cal_pd180 <= cal_inc[2] ? cal_pd180 : 4'h0;
						end
						else begin
							cal_pd180 <= cal_pd180 + (cal_inc[2] ? 4'hF : 4'h1);
							ignore_solid[2] <= 1'b0;
						end
					end

					if (rx_done && cal_done[3] == 1'b0) begin
						if (edges[3]) begin
							cal_inc[3] <= 1'b1;
							ignore_solid[3] <= 1'b1;
							if (cal_inc[3] == 1'b0) begin
								cal_pd270_l <= cal_pd270;
								cal_pd270 <= 4'hF;
							end
							else begin
								cal_pd270 <= avg_pd270[4:1];
								cal_done[3] <= 1'b1;	//done
							end
						end
						else if ((cal_pd270 == 4'hF && cal_inc[3] == 1'b0) ||
					       		(cal_pd270 == cal_pd270_l && cal_inc[3] == 1'b1)) begin
							cal_done[3] <= 1'b1;		//error
							ignore_solid[3] <= 1'b1;
							cal_pd270 <= cal_inc[3] ? cal_pd270 : 4'hF;
						end
						else begin
							cal_pd270 <= cal_pd270 + (cal_inc[3] ? 4'hF : 4'h1);
							ignore_solid[3] <= 1'b0;
						end
					end
				end
			CH_ADV: begin
					if (channel == (number_of_channels - 1)) begin
						done <= 1'b1;
						state <= IDLE;
					end
					else begin
						done <= 1'b0;
						state <= CH_WAIT;
						channel <= channel + 8'd1;
					end
				end
			DPRIO_READ: begin
					// always first wait for old dprio transactions to end
					// send read command, then wait for data to arrive before continuing
					if(~dprio_busy) begin
						if(did_dprio) begin
							if(read == 1'b0) begin
								state <= ret_state;
								dprio_save <= {dprio_datain[15:11], dprio_datain[2:0]};
							end
							else begin
								read <= 1'b1;
								state <= DPRIO_READ;
							end
						end
						else begin
							read <= 1'b1;
							did_dprio <= 1'b1;
							state <= DPRIO_READ;
						end
					end
					else begin
						// waiting for dprio to finish
						read <= 1'b0;
						state <= DPRIO_READ;
					end
				end
			DPRIO_WRITE: begin
					// always first wait for old dprio transactions to end
					// send write command, then wait for data to be sent before continuing
					if(~dprio_busy) begin
						if(did_dprio) begin
							if(write_reg == 1'b0) begin
								state <= ret_state;
							end
							else begin
								write_reg <= 1'b1;
								state <= DPRIO_WRITE;
							end
						end
						else begin
							write_reg <= 1'b1;
							did_dprio <= 1'b1;
							state <= DPRIO_WRITE;
						end
					end
					else begin
						// waiting for dprio to finish
						write_reg <= 1'b0;
						state <= DPRIO_WRITE;
					end
				end
			default: begin
				state <= IDLE;
				busy <= 1'b0;
				done <= 1'b0;
				end
			endcase
		end
	end

endmodule

