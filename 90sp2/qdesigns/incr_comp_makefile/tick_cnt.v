/* filename: tick_cnt.v */


module tick_cnt( get_ticket1, get_ticket2, clk, ticket );
   input get_ticket1, get_ticket2, clk;

   output [3:0] ticket;
   reg  [3:0] ticket;

   always @(posedge clk)
        if( get_ticket1 | get_ticket2 )
        	ticket=ticket+1;
/*
   a8count mycnt( 
	  .clk(clk),
	  .gn(~(get_ticket1 | get_ticket2)),
	  .dnup(0),

	  .qd(ticket[3]), .qc(ticket[2]), .qb(ticket[1]), .qa(ticket[0]) 
   );
*/
endmodule

