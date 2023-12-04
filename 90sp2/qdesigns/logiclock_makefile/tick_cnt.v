/* filename: tick_cnt.v */

/*$Log:   /pvcs/quartus/install/qdesigns/logiclock_makefile/tick_cnt.v__  $
// 
//    Rev 25.0   08 Jul 2007 03:31:20   max
// Quartus II 8.0 
// SJ, Sat Jul  7 08:31:20 2007
// 
//    Rev 24.0   11 Feb 2007 02:25:02   max
// Quartus II 7.2 
// SJ, Sat Feb 10 06:25:03 2007
// 
//    Rev 23.0   10 Sep 2006 00:22:10   max
// Quartus II 7.1 
// SJ, Sat Sep  9 05:22:09 2006
// 
//    Rev 22.0   05 Feb 2006 00:01:44   max
// Quartus II 6.1 
// SJ, Sat Feb  4 04:01:45 2006
// 
//    Rev 21.0   06 Aug 2005 23:58:42   max
// Quartus II 6.0 
// SJ, Sat Aug  6 04:58:43 2005
// 
//    Rev 20.0   06 Feb 2005 06:00:18   max
// Quartus II 5.1 
// SJ, Sat Feb  5 10:00:17 2005
// 
//    Rev 19.0   15 Jan 2005 13:37:24   max
// Quartus II 5.0 
// SJ, Fri Jan 14 17:37:25 2005
// 
//    Rev 1.0   30 Nov 2004 05:29:04   smalhotr
// Initial Put (Changed from directory ll_makefile to logiclock_makefile) 
// TO, Mon Nov 29 12:28:10 2004
// 
//    Rev 19.0.1.1   04 Nov 2004 10:32:02   cclark
// Putting back for TO build post branching. 
// TO, Wed Nov 03 17:31:32 2004
// 
//    Rev 19.0.1.0   04 Nov 2004 08:38:14   max
// Quartus II 4.2 
// SJ, Wed Nov  3 12:38:15 2004
// 
//    Rev 19.0   04 Nov 2004 08:38:14   max
// Quartus II 5.0 
// SJ, Wed Nov  3 12:38:14 2004
// 
//    Rev 1.0   04 Nov 2004 05:34:16   smalhotr
// Initial Put 
// TO, Wed Nov 03 12:34:07 2004
// 
//    Rev 1.0   03 Nov 2004 07:21:42   smalhotr
// Initial Put 
// TO, Tue Nov 02 14:21:42 2004
   
      Rev 17.0   04 Oct 2003 13:50:12   max
   Quartus II 4.1
   SJ, Fri Oct 03 18:50:12 2003
   
      Rev 16.0   05 Apr 2003 14:44:30   max
   Quartus II 3.1
   SJ, Fri Apr 04 18:44:30 2003
   
      Rev 15.0   07 Sep 2002 16:49:14   max
   Quartus II 3.0
   SJ, Fri Sep 06 21:49:14 2002
   
      Rev 14.0   20 Apr 2002 17:06:46   max
   Quartus II 2.2
   SJ, Fri Apr 19 22:06:44 2002
   
      Rev 13.0   03 Nov 2001 18:36:14   max
   Quartus II 2.1
   SJ, Fri Nov 02 22:36:14 2001
   
      Rev 12.0   21 Apr 2001 19:15:36   max
   Quartus II 1.2
   SJ, Sat Apr 21 00:15:36 2001
   
      Rev 11.0   25 Nov 2000 02:47:46   max
   QuartusII 1.1
   SJ, Fri Nov 24 06:47:46 2000
   
      Rev 10.0   05 Aug 2000 01:59:28   max
   2000.12
   
      Rev 9.1   01 Aug 2000 17:30:38   cauduong
    
   
      Rev 9.0   17 Feb 2000 02:10:54   max
   2000.08
   
      Rev 8.0   25 Nov 1999 02:47:04   max
   2000.06
   
      Rev 7.0   22 Jun 1999 03:04:24   max
   1999.09
   
      Rev 6.0   30 May 1999 02:29:18   max
   1999.06
   
      Rev 5.0   27 Apr 1999 02:18:28   max
   1999.05
   
      Rev 4.0   May 08 1998 22:30:04   max
   Name change from Birch to Quartus
   
      Rev 1.1   Apr 22 1998 14:34:58   shawnw
   Initial Revision.
*/

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

