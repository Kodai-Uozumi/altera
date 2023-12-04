/* filename: auto_max.v */


module auto_max( dir, accel, clk, reset, speed_too_fast, at_altera, get_ticket );
   input [1:0] dir;
   input accel, clk, reset;
   output speed_too_fast, at_altera, get_ticket;
   reg speed_too_fast, at_altera, get_ticket;

   reg [2:0] street_map;
   parameter  yc=3'b000, mpld=3'b001, epld=3'b010,    gdf=3'b011,
             cnf=3'b100,  rpt=3'b101,  epm=3'b110, altera=3'b111;

   parameter NORTH=2'b00, EAST=2'b01, WEST=2'b10, SOUTH=2'b11;

   always @(posedge clk or posedge reset)
   begin
      if( reset ) street_map=yc;
      else
      case( {street_map, dir, accel} )
         {yc  , NORTH, 1'b0}:
		street_map=rpt;
         {yc  , EAST , 1'b0}:
		street_map=gdf;
         {yc  , NORTH, 1'b1}:
		street_map=mpld;
         {yc  , EAST , 1'b1}:
		street_map=cnf;
         {gdf , NORTH, 1'b0}:
		street_map=epld;
         {gdf , WEST , 1'b0}:
		street_map=yc;
         {gdf , WEST , 1'b1}:
		street_map=yc;
         {gdf , EAST , 1'b0}:
		street_map=cnf;
         {gdf , EAST , 1'b1}:
		street_map=cnf;
         {gdf , NORTH, 1'b1}:
		street_map=mpld;
         {cnf , NORTH, 1'b0}:
		street_map=epm;
         {cnf , WEST , 1'b0}:
		street_map=gdf;
         {cnf , NORTH, 1'b1}:
		street_map=altera;
         {cnf , WEST , 1'b1}:
		street_map=yc;
         {rpt , NORTH, 1'b0}:
		street_map=mpld;
         {rpt , NORTH, 1'b1}:
		street_map=mpld;
         {rpt , EAST , 1'b0}:
		street_map=epld;
         {rpt , EAST , 1'b1}:
		street_map=epm;
         {rpt , SOUTH, 1'b0}:
		street_map=yc;
         {epld, NORTH, 1'b0}:
		street_map=mpld;
         {epld, NORTH, 1'b1}:
		street_map=mpld;
         {epld, WEST , 1'b0}:
		street_map=rpt;
         {epld, WEST , 1'b1}:
		street_map=rpt;
         {epld, SOUTH, 1'b0}:
		street_map=gdf;
         {epld, SOUTH, 1'b1}:
		street_map=gdf;
         {epld, EAST , 1'b0}:
		street_map=epm;
         {epld, EAST , 1'b1}:
		street_map=epm;
         {epm , NORTH, 1'b0}:
		street_map=altera;
         {epm , NORTH, 1'b1}:
		street_map=altera;
         {epm , SOUTH, 1'b0}:
		street_map=cnf;
         {epm , SOUTH, 1'b1}:
		street_map=cnf;
         {epm , WEST , 1'b0}:
		street_map=epld;
         {epm , WEST , 1'b1}:
		street_map=rpt;
         {mpld, WEST , 1'b0}:
		street_map=rpt;
         {mpld, SOUTH, 1'b0}:
		street_map=epld;
         {mpld, WEST , 1'b1}:
		street_map=yc;
         {mpld, SOUTH, 1'b1}:
		street_map=gdf;
         {altera, NORTH, 1'b0}:
		street_map=altera;
         {altera, EAST , 1'b0}:
		street_map=altera;
         {altera, WEST , 1'b0}:
		street_map=altera;
         {altera, SOUTH, 1'b0}:
		street_map=altera;
         {altera, NORTH, 1'b1}:
		street_map=altera;
         {altera, EAST , 1'b1}:
		street_map=altera;
         {altera, WEST , 1'b1}:
		street_map=altera;
         {altera, SOUTH, 1'b1}:
		street_map=altera;
      endcase
   end

   always @(street_map or dir or accel)
   begin
      case( {street_map, dir, accel} )
         {yc  , NORTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {yc  , EAST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {yc  , NORTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {yc  , EAST , 1'b1}:
		begin
			get_ticket=1'b1;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {gdf , NORTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {gdf , WEST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {gdf , WEST , 1'b1}:
		begin
			get_ticket=1'b1;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {gdf , EAST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {gdf , EAST , 1'b1}:
		begin
			get_ticket=1'b1;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {gdf , NORTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {cnf , NORTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {cnf , WEST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {cnf , NORTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {cnf , WEST , 1'b1}:
		begin
			get_ticket=1'b1;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {rpt , NORTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {rpt , NORTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {rpt , EAST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {rpt , EAST , 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {rpt , SOUTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epld, NORTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epld, NORTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epld, WEST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epld, WEST , 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {epld, SOUTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epld, SOUTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epld, EAST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epld, EAST , 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {epm , NORTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epm , NORTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {epm , SOUTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epm , SOUTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {epm , WEST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {epm , WEST , 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {mpld, WEST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {mpld, SOUTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {mpld, WEST , 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b1;
		end
         {mpld, SOUTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
         {altera, NORTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b1;
			speed_too_fast=1'b0;
		end
         {altera, EAST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b1;
			speed_too_fast=1'b0;
		end
         {altera, WEST , 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b1;
			speed_too_fast=1'b0;
		end
         {altera, SOUTH, 1'b0}:
		begin
			get_ticket=1'b0;
			at_altera=1'b1;
			speed_too_fast=1'b0;
		end
         {altera, NORTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b1;
			speed_too_fast=1'b0;
		end
         {altera, EAST , 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b1;
			speed_too_fast=1'b0;
		end
         {altera, WEST , 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b1;
			speed_too_fast=1'b0;
		end
         {altera, SOUTH, 1'b1}:
		begin
			get_ticket=1'b0;
			at_altera=1'b1;
			speed_too_fast=1'b0;
		end

         default:
		begin
			get_ticket=1'b0;
			at_altera=1'b0;
			speed_too_fast=1'b0;
		end
      endcase
   end

endmodule

