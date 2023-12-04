/* filename: speed_ch.v */

/*$Log:   /pvcs/quartus/install/qdesigns/logiclock_makefile/speed_ch.v__  $
// 
//    Rev 25.0   08 Jul 2007 03:31:14   max
// Quartus II 8.0 
// SJ, Sat Jul  7 08:31:15 2007
// 
//    Rev 24.0   11 Feb 2007 02:24:58   max
// Quartus II 7.2 
// SJ, Sat Feb 10 06:24:58 2007
// 
//    Rev 23.0   10 Sep 2006 00:22:04   max
// Quartus II 7.1 
// SJ, Sat Sep  9 05:22:04 2006
// 
//    Rev 22.0   05 Feb 2006 00:01:40   max
// Quartus II 6.1 
// SJ, Sat Feb  4 04:01:40 2006
// 
//    Rev 21.0   06 Aug 2005 23:58:38   max
// Quartus II 6.0 
// SJ, Sat Aug  6 04:58:38 2005
// 
//    Rev 20.0   06 Feb 2005 06:00:10   max
// Quartus II 5.1 
// SJ, Sat Feb  5 10:00:11 2005
// 
//    Rev 19.0   15 Jan 2005 13:37:16   max
// Quartus II 5.0 
// SJ, Fri Jan 14 17:37:17 2005
// 
//    Rev 1.0   30 Nov 2004 05:28:56   smalhotr
// Initial Put (Changed from directory ll_makefile to logiclock_makefile) 
// TO, Mon Nov 29 12:28:10 2004
// 
//    Rev 19.0.1.1   04 Nov 2004 10:31:58   cclark
// Putting back for TO build post branching. 
// TO, Wed Nov 03 17:31:32 2004
// 
//    Rev 19.0.1.0   04 Nov 2004 08:38:10   max
// Quartus II 4.2 
// SJ, Wed Nov  3 12:38:09 2004
// 
//    Rev 19.0   04 Nov 2004 08:38:08   max
// Quartus II 5.0 
// SJ, Wed Nov  3 12:38:08 2004
// 
//    Rev 1.0   04 Nov 2004 05:34:14   smalhotr
// Initial Put 
// TO, Wed Nov 03 12:34:07 2004
// 
//    Rev 1.0   03 Nov 2004 07:21:24   smalhotr
// Initial Put 
// TO, Tue Nov 02 14:21:24 2004
   
      Rev 17.0   04 Oct 2003 13:48:52   max
   Quartus II 4.1
   SJ, Fri Oct 03 18:48:52 2003
   
      Rev 16.0   05 Apr 2003 14:42:34   max
   Quartus II 3.1
   SJ, Fri Apr 04 18:42:34 2003
   
      Rev 15.0   07 Sep 2002 16:46:42   max
   Quartus II 3.0
   SJ, Fri Sep 06 21:46:42 2002
   
      Rev 14.0   20 Apr 2002 17:04:24   max
   Quartus II 2.2
   SJ, Fri Apr 19 22:04:24 2002
   
      Rev 13.0   03 Nov 2001 18:34:22   max
   Quartus II 2.1
   SJ, Fri Nov 02 22:34:22 2001
   
      Rev 12.0   21 Apr 2001 19:14:36   max
   Quartus II 1.2
   SJ, Sat Apr 21 00:14:34 2001
   
      Rev 11.0   25 Nov 2000 02:45:52   max
   QuartusII 1.1
   SJ, Fri Nov 24 06:45:52 2000
   
      Rev 10.0   05 Aug 2000 01:58:48   max
   2000.12
   
      Rev 9.1   01 Aug 2000 17:31:10   cauduong
    
   
      Rev 9.0   17 Feb 2000 02:10:36   max
   2000.08
   
      Rev 8.0   25 Nov 1999 02:46:28   max
   2000.06
   
      Rev 7.0   22 Jun 1999 03:03:40   max
   1999.09
   
      Rev 6.0   30 May 1999 02:28:38   max
   1999.06
   
      Rev 5.0   27 Apr 1999 02:17:42   max
   1999.05
   
      Rev 4.0   May 08 1998 22:30:10   max
   Name change from Birch to Quartus
   
      Rev 1.0   Apr 22 1998 14:34:56   shawnw
   Initial Revision.
*/

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

