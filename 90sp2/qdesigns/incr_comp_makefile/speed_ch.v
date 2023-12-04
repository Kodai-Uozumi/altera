/* filename: speed_ch.v */

module speed_ch( accel_in, reset, clk, get_ticket );
   input accel_in, reset, clk;
   output get_ticket;
   reg [1:0] speed;
   reg gt;
   parameter legal=0, warning=1, ticket=2;

   always @(posedge reset or posedge clk)
     begin
        if( reset ) begin
            speed = legal;
        end else begin
            case( speed )
               legal:	if( accel_in ) speed=warning;
               warning:	if( accel_in ) speed=ticket;
               ticket:	speed=legal;
            endcase
        end
     end

   always @(posedge clk)
     if( speed==warning && accel_in )
     	gt=1;
     else
     	gt=0;

   assign get_ticket = gt;
endmodule

