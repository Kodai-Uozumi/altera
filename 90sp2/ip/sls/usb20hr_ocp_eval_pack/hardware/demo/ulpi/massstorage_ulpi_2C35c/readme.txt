-- **************************************************************************
-- **                    System Level Solutions, Inc.
-- **                    e-mail: support@slscorp.com
-- **                        www.slscorp.com
-- **************************************************************************
-- ** Copyright 2006 to 2008 System Level Solutions. All rights reserved.
-- ** 
-- ** Author: SLS
-- **
-- ** File Name : Readme.txt
-- **************************************************************************
-- ** Contents:
-- **
-- ** This ReadMe file contains the following information:
-- **
-- **	- Information regarding Mass Storage Application with SLSUSB20HR IP core on 
-- **     Nios II Developement Kit 2C35(c) Board.

-- **************************************************************************

//****************************
//  MASS Storage Application
//****************************
Steps for demonstrate Mass Storage application on 2c35 board Rev C with ULPI Snap On board(Rev3).

   1>	Connect USB Blaster on J24 port(JTAG) of the board and Snap on Board(USB2.0 ULPI Rev3) on SC Headers J11,J12 and J13
   2>   Switch on the board.
   3>   Detect the USB blaster into PC.
   4>   Run Massstorage.bat file from this folder.Just double click on it.
   5>	After Successfully downloading SOF and ELF file on Hardware,Connect USB2.0 Compliant cable between Snap on board and Host PC.
   6>   Check for Mass storage device detection into USB View.
   7>   After device detection Format the drive.
   8>   Perform a read and write operation over the mass storage device.        
