-- **********************************************************************
-- **                    System Level Solutions, Inc.
-- **                    e-mail: support@slscorp.com
-- **                        www.slscorp.com
-- **********************************************************************
-- ** Copyright 2004-2008 System Level Solutions, All rights reserved.
-- ** 
-- ** File Name     : readme.txt
-- **
-- **********************************************************************
	             CONSOLE APPLICATION : SLSUSBClient 
*************************************************************************

The SLSUSBClient application gives user an idea about how to perform read/write operation to the SLSUSB supported devices.


HOW TO COMPILE & Execute the Application?       
************************************************************************

Go to the path "Setup_usb20hrv22\software\example\linux". You will see the SLSUSBClient inside this folder. Now type:

   	>gcc SLSUSBClient.c
   	
If you are anywhere other than this path then type the full path name along with the file name and its extension. See the example below:

	>gcc [path]\SLSUSBClient.c. where path is a variable indicating USB20HR installation path on your PC.
	
On successful compilation of the application, the executable file named a.out will be generated.  


Note: Before writing or reading to/from the SLSUSB device, make sure that the device is connected with 
      the PC.


HOW TO Run the Application?       
************************************************************************

To run the application,type

	> ./a.out 
You will be asked to choose one of the following options.

	> 1: WriteData to Device
	> 2: ReadData from Device
	> 3: Exit
	> Enter your selection index: 
		
Select the operation you wish to perform. 

Here, we will give the example of writing 64 byte data to the 1st device for 10 times.

Choose the write operation so type 1 as index.

	> 1
	
It prompts to enter the device number for the device on which you want to perform the write operation. For the 1st device, enter 0.

Note: The 1st SLS USB device is named with SLSUSB0. Likewise the other SLS USB supported devices are named with, SLSUSB1, SLSUSB2, and so on. So enter the index 0 for 1st device.

	> Enter Device No to access (Zero based Index):
	> 0 

It again asks for the number of bytes to write

	> No of Bytes to write:
	> 64

You will be prompted to enter the number for which you want to perform the write operation. 

	> How many times do you want to write:
	> 10

This will write 64 bytes of data on the device 10 times.
	
This way you can perform the read operation to read data from the SLSUSB device.


