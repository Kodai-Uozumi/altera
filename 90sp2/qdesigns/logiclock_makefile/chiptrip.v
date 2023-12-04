module chiptrip( dir, clock, accel, reset, enable, timeo, at_altera, ticket,gt1,gt2,stf );
   input [1:0] dir;
   input clock, accel, reset, enable;

   output [7:0] timeo;
   output at_altera;
   output [3:0] ticket;
   output gt1,gt2,stf;

   wire wire_speed_too_fast, wire_get_ticket1, wire_get_ticket2;

   auto_max auto_max( .clk(clock), .reset(reset), .dir(dir), .accel(accel),
   				  .speed_too_fast(wire_speed_too_fast), .at_altera(at_altera), .get_ticket(wire_get_ticket1) );
   speed_ch speed_ch( .accel_in(wire_speed_too_fast), .reset(reset), .clk(clock), .get_ticket(wire_get_ticket2) );
   time_cnt time_cnt( .enable(enable), .clk(clock), .timeo(timeo) );
   tick_cnt tick_cnt( .get_ticket1(wire_get_ticket1), .get_ticket2(wire_get_ticket2), .clk(clock), .ticket(ticket) );

	assign gt1=wire_get_ticket1;
	assign gt2=wire_get_ticket2;
	assign stf=wire_speed_too_fast;
endmodule


