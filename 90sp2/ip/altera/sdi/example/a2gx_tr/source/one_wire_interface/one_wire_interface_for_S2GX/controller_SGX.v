module controller_SGX
	(
		clk,
		io_data,
		output_en,
		db_proto,
		rx_sel,
		tx_sel
		
	);

	input				clk;
	input				io_data;
	output	reg			output_en;
	output	reg	[4:0]	db_proto;
	output	reg	[6:0]	rx_sel;
	output	reg [6:0]	tx_sel;
//	reg		output_en;	
//	reg		[6:0]	rx_sel;	
//	reg		[6:0]	tx_sel;
	integer			state;
	reg		[11:0]	count;
//	reg		[1:0]	recount;
	parameter Start 		= 0;
	parameter State_one 	= 1;
	parameter State_two 	= 2;
	parameter State_three 	= 3;
	parameter State_four 	= 4;

//	reg [__reg_range_msb:__reg_range_lsb] state;
   always @ (negedge clk) begin
      case (state)
         Start:
		begin
            output_en = 1'b0;
			db_proto = 5'b00001;
		end
         State_one:
		begin
            output_en = 1'b1;
			db_proto = 5'b00010;
		end
         State_two:
		begin
            output_en = 1'b0;
			db_proto = 5'b00100;
		end
      	 State_three:
		begin
            output_en = 1'b1;
			db_proto = 5'b01000;
		end
		 State_four:
		begin
            output_en = 1'b0;
			db_proto = 5'b10000;
		end
         endcase
   end

	always @(posedge clk)
begin

//if (__expression)
//	begin
//		__statement;
//	end
		case (state)
			Start:
			begin
//				recount <= 2'b00;
				if ((count == 12'hfff) & (io_data == 1'b1)) begin
					state <= State_one;
					end
				else if	(io_data == 1'b0)
					begin 
					count <= 12'hfff;
					state <= State_two;
					end
				else
					begin
					state <= Start;
					count <= count + 1'b1;		
					end
				tx_sel = 0;
				rx_sel = 0;
			end		

			State_one:
//			if (recount == 2'b01)
			begin
				state <= Start;
				count <= 12'h000;
			end				
//			else
//				recount <= recount + 1;

			State_two:
			begin
				if ((rx_sel == 7'b0000000) & (io_data==1'b1))
					state <= Start;

				rx_sel <= rx_sel + 1'b1;
				if (rx_sel == 7'b0011101) 
						state <= State_three; 
//					else
//						state <= State_two;
					
//					output_en = 1;
					tx_sel <= 7'b0000000;
			end
				
			State_three:
			begin
				tx_sel <= tx_sel + 1'b1;
				if (tx_sel == 7'b1100011) 
						state <= State_four; 
					else
						state <= State_three;
					
//					output_en = 1;
					rx_sel <= 7'b0000000;
			end	
			
			State_four:
			begin
				tx_sel <= 7'b0000000;	
				rx_sel <= 7'b0000000;
//				if (io_data == 1'b0)
					state <= State_two;			
			end
					
			default:
			begin
				
				if ((count == 12'hfff) & (io_data == 1'b1)) begin
					state <= State_one;
					end
				else if	(io_data == 1'b0)
					begin 
					count <= 12'hfff;
					state <= State_two;
					end
				else
					begin
					state <= Start;
					count <= count + 1'b1;		
					end
				tx_sel = 0;
				rx_sel = 0;
			end		

		endcase

	end

endmodule

//	__statement;
//	__statement;
