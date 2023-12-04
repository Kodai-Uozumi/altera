/* filename: time_cnt.v */

/*$Log:   /pvcs/quartus/install/qdesigns/logiclock_makefile/time_cnt.v__  $
// 
//    Rev 25.0   08 Jul 2007 03:31:24   max
// Quartus II 8.0 
// SJ, Sat Jul  7 08:31:24 2007
// 
//    Rev 24.0   11 Feb 2007 02:25:08   max
// Quartus II 7.2 
// SJ, Sat Feb 10 06:25:08 2007
// 
//    Rev 23.0   10 Sep 2006 00:22:14   max
// Quartus II 7.1 
// SJ, Sat Sep  9 05:22:14 2006
// 
//    Rev 22.0   05 Feb 2006 00:01:50   max
// Quartus II 6.1 
// SJ, Sat Feb  4 04:01:50 2006
// 
//    Rev 21.0   06 Aug 2005 23:58:48   max
// Quartus II 6.0 
// SJ, Sat Aug  6 04:58:48 2005
// 
//    Rev 20.0   06 Feb 2005 06:00:22   max
// Quartus II 5.1 
// SJ, Sat Feb  5 10:00:23 2005
// 
//    Rev 19.0   15 Jan 2005 13:37:32   max
// Quartus II 5.0 
// SJ, Fri Jan 14 17:37:32 2005
// 
//    Rev 1.0   30 Nov 2004 05:29:10   smalhotr
// Initial Put (Changed from directory ll_makefile to logiclock_makefile) 
// TO, Mon Nov 29 12:28:10 2004
// 
//    Rev 19.0.1.1   04 Nov 2004 10:32:08   cclark
// Putting back for TO build post branching. 
// TO, Wed Nov 03 17:31:32 2004
// 
//    Rev 19.0.1.0   04 Nov 2004 08:38:20   max
// Quartus II 4.2 
// SJ, Wed Nov  3 12:38:20 2004
// 
//    Rev 19.0   04 Nov 2004 08:38:18   max
// Quartus II 5.0 
// SJ, Wed Nov  3 12:38:19 2004
// 
//    Rev 1.0   04 Nov 2004 05:34:20   smalhotr
// Initial Put 
// TO, Wed Nov 03 12:34:07 2004
// 
//    Rev 1.0   03 Nov 2004 07:21:58   smalhotr
// Initial Put 
// TO, Tue Nov 02 14:21:57 2004
   
      Rev 17.0   04 Oct 2003 13:51:22   max
   Quartus II 4.1
   SJ, Fri Oct 03 18:51:20 2003
   
      Rev 16.0   05 Apr 2003 14:46:06   max
   Quartus II 3.1
   SJ, Fri Apr 04 18:46:06 2003
   
      Rev 15.0   07 Sep 2002 16:51:30   max
   Quartus II 3.0
   SJ, Fri Sep 06 21:51:30 2002
   
      Rev 14.0   20 Apr 2002 17:09:10   max
   Quartus II 2.2
   SJ, Fri Apr 19 22:09:10 2002
   
      Rev 13.0   03 Nov 2001 18:38:02   max
   Quartus II 2.1
   SJ, Fri Nov 02 22:38:02 2001
   
      Rev 12.0   21 Apr 2001 19:16:46   max
   Quartus II 1.2
   SJ, Sat Apr 21 00:16:46 2001
   
      Rev 11.0   25 Nov 2000 02:49:06   max
   QuartusII 1.1
   SJ, Fri Nov 24 06:49:06 2000
   
      Rev 10.0   05 Aug 2000 02:00:06   max
   2000.12
   
      Rev 9.1   01 Aug 2000 17:30:50   cauduong
    
   
      Rev 9.0   17 Feb 2000 02:11:12   max
   2000.08
   
      Rev 8.0   25 Nov 1999 02:47:42   max
   2000.06
   
      Rev 7.0   22 Jun 1999 03:05:10   max
   1999.09
   
      Rev 6.0   30 May 1999 02:29:56   max
   1999.06
   
      Rev 5.0   27 Apr 1999 02:19:14   max
   1999.05
   
      Rev 4.0   May 08 1998 22:30:12   max
   Name change from Birch to Quartus
   
      Rev 1.1   Apr 22 1998 14:40:14   shawnw
   Initial Revision.
*/

//`include "lpm_210.v"			//   lpm_add_sub

module time_cnt( enable, clk, timeo );
   input enable, clk;
   output [7:0] timeo;
   reg [7:0] timeo;

   always @(posedge clk)
     if( enable ) timeo=timeo+1;

endmodule

