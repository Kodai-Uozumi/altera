/* filename: auto_max.v */

/*$Log:   /pvcs/quartus/install/qdesigns/logiclock_makefile/auto_max.v__  $
// 
//    Rev 25.0   08 Jul 2007 03:30:34   max
// Quartus II 8.0 
// SJ, Sat Jul  7 08:30:34 2007
// 
//    Rev 24.0   11 Feb 2007 02:24:18   max
// Quartus II 7.2 
// SJ, Sat Feb 10 06:24:18 2007
// 
//    Rev 23.0   10 Sep 2006 00:21:24   max
// Quartus II 7.1 
// SJ, Sat Sep  9 05:21:24 2006
// 
//    Rev 22.0   05 Feb 2006 00:01:00   max
// Quartus II 6.1 
// SJ, Sat Feb  4 04:01:00 2006
// 
//    Rev 21.0   06 Aug 2005 23:57:58   max
// Quartus II 6.0 
// SJ, Sat Aug  6 04:57:59 2005
// 
//    Rev 20.0   06 Feb 2005 05:59:10   max
// Quartus II 5.1 
// SJ, Sat Feb  5 09:59:10 2005
// 
//    Rev 19.0   15 Jan 2005 13:36:22   max
// Quartus II 5.0 
// SJ, Fri Jan 14 17:36:21 2005
// 
//    Rev 1.0   30 Nov 2004 05:28:12   smalhotr
// Initial Put (Changed from directory ll_makefile to logiclock_makefile) 
// TO, Mon Nov 29 12:28:10 2004
// 
//    Rev 19.0.1.1   04 Nov 2004 10:31:32   cclark
// Putting back for TO build post branching. 
// TO, Wed Nov 03 17:31:32 2004
// 
//    Rev 19.0.1.0   04 Nov 2004 08:37:42   max
// Quartus II 4.2 
// SJ, Wed Nov  3 12:37:43 2004
// 
//    Rev 19.0   04 Nov 2004 08:37:42   max
// Quartus II 5.0 
// SJ, Wed Nov  3 12:37:42 2004
// 
//    Rev 1.0   04 Nov 2004 05:34:08   smalhotr
// Initial Put 
// TO, Wed Nov 03 12:34:07 2004
// 
//    Rev 1.0   03 Nov 2004 07:20:48   smalhotr
// Initial Put 
// TO, Tue Nov 02 14:20:49 2004
   
      Rev 17.0   04 Oct 2003 13:40:10   max
   Quartus II 4.1
   SJ, Fri Oct 03 18:40:10 2003
   
      Rev 16.0   05 Apr 2003 14:31:30   max
   Quartus II 3.1
   SJ, Fri Apr 04 18:31:30 2003
   
      Rev 15.0   07 Sep 2002 16:32:42   max
   Quartus II 3.0
   SJ, Fri Sep 06 21:32:40 2002
   
      Rev 14.0   20 Apr 2002 16:51:48   max
   Quartus II 2.2
   SJ, Fri Apr 19 21:51:48 2002
   
      Rev 13.0   03 Nov 2001 18:25:32   max
   Quartus II 2.1
   SJ, Fri Nov 02 22:25:32 2001
   
      Rev 12.0   21 Apr 2001 19:09:04   max
   Quartus II 1.2
   SJ, Sat Apr 21 00:09:04 2001
   
      Rev 11.0   25 Nov 2000 02:38:52   max
   QuartusII 1.1
   SJ, Fri Nov 24 06:38:52 2000
   
      Rev 10.0   05 Aug 2000 01:55:38   max
   2000.12
   
      Rev 9.1   01 Aug 2000 17:31:28   cauduong
    
   
      Rev 9.0   17 Feb 2000 02:09:18   max
   2000.08
   
      Rev 8.0   25 Nov 1999 02:43:54   max
   2000.06
   
      Rev 7.0   22 Jun 1999 02:59:38   max
   1999.09
   
      Rev 6.0   30 May 1999 02:25:10   max
   1999.06
   
      Rev 5.0   27 Apr 1999 02:13:48   max
   1999.05
   
      Rev 4.0   May 08 1998 22:30:04   max
   Name change from Birch to Quartus
   
      Rev 1.0   Apr 22 1998 14:34:38   shawnw
   Initial Revision.
*/

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

