-- **********************************************************************
-- **                    System Level Solutions, Inc.
-- **                    e-mail: support@slscorp.com
-- **                        www.slscorp.com
-- **********************************************************************
-- ** Copyright 2004-2008 System Level Solutions. All rights reserved.
-- ** 
-- ** File Name     : readme.txt
-- ** SLSUSB Driver : v1.00.00			
-- **
-- **********************************************************************

This readme file gives you the information on SLSUSB driver for Linux. The SLSUSB driver is designed for the Linux kernel version 2.6, upto 2.6.18. With the help of this driver, you can perform read/write operation for the Synchronous mode. There is only one file "SLSUSB.ko" which is the driver file, given with this readme. SLSUSB supported devices are SLS USB 1.1 or SLS USB 2.0 devices.

On proper installation of the driver, you can use any SLS USB supported devices.

To install the driver, follow the steps below:

	1. Copy SLSUSB.ko file into  the [../lib/modules/kernel version/] directory.
	
	2. Open the command prompt terminal and run "depmod" command. This will register your driver 
	   into the modules.dep file.
	
To confirm the driver installation follow the steps below:

	1. Open modules.dep file located at [/lib/modules/kernel version/]. You will see the path of
	   SLSUSB.ko file here.
	   
	2. Connect an SLS USB supported device with the USB port of PC and check the 
	   [/dev] directory to confirm the SLS USB device detection. Here, you will see the SLS USB device named with SLSUSB0. Likewise the other SLS USB supported devices are numberd with, SLSUSB1, SLSUSB2, and so on,
	
You are now ready to use the SLSUSB device.
	
NOTE:
SLS is not responsible for any malfunctioning of this driver. This driver is tested under Fedora 7.

Please feel free to suggest us on support@slscorp.com
