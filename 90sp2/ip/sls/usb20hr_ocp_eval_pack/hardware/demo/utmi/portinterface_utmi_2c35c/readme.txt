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
 //                   - Information regarding demonstration of port interface application
 //                     of usb20hr with utmi interface.
 //
 //
 //************************************************************

 // Follow steps as given below for performing demonstration
 //=========================================================
 
  --> Steps for loading Port Interface system on NiosII Development Kit, Cyclone II(2C35Revc).
 
     1> Connect USB Blaster on J24 port(JTAG) of the board and Snap on Board(USB2.0 UTMI Rev5) on SC 
        Headers J11,J12 and J13.
     2> Switch on the board.
     3> Detect the USB blaster into PC.
     4> Run portinterface.bat file from this folder, Just double click on it.
     5> connect USB2.0 compliant cable into Snap on Board (UTMI Rev5) and detect sls usb2.0 device 
        into USBVIEW.
     
     
  -->Steps for running port interface application
     
     1> Run Portinterface application from <USB20HR Installation Path>\software\   
        utilities\portinterface.
     2> Perform single word write operation at location 0x06622060( 8 bit Led pio is connected at this 
        location.lower two nibble will be displayed in LEDs).
     3> Perform single word read/write or word verify or file read/write operation between location
        (1)   0x06300000 to 0x063FFFFF
        (2)   0x02000000 to 0x02FFFFFF

 
  Note:- for getting more information about port interface application please refer ReadMe.txt file
         from the following path <USB20HR Installation Path>\software\ utilities\portinterface.