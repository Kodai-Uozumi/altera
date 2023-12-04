//***********************************************************
 //
 // Author       : SLS
 //
 // File         : ReadMe.txt
 //
 // Date         : 05/07/2008
 //
 // Description:  This ReadMe file contains the following information:
 //            
 //                   - Information regarding demonstration of Streaming application(write operation)
 //                     of usb20hr with utmi interface.
 //
 //
 //************************************************************

 // Follow steps as given below for performing demonstration
 //=========================================================
 
  -->Instruction for loading Streaming Application system on NiosII Development Kit, Cyclone II(2C35Revc).
 
     1> Connect USB Blaster on J24 port(JTAG) of the board and Snap on Board(USB2.0 UTMI Rev5) on SC Headers 
        J11,J12 and J13
     2> Switch on the board.
     3> Detect the USB blaster into PC.
     4> Run streaming_bo.bat file from this folder, Just double click on it.
     5> connect USB2.0 complaint cable into Snap on Board (UTMI Rev5) and detect sls usb2.0 device into 
        USBVIEW.
     
  -->Steps for running streaming application
     
     1> Run Streaming application from <USB20HR Installation Path>\software\ 
        example\windows\rwusb_csharp\rwusb\bin\release.
     2> Perform Bulk Out operation as per application console
         
     
 
   Note:- For performing BULK OUT operation write number of bytes from streaming application.