PortInterface(for USB) Version 2.0 for PCs (Microsoft.NET 2.0 Framework)
README.TXT
=======================================

Although we have made every effort to ensure that this version
of PortInterface software functions correctly, there may be
problems that we haven't encountered. If you have a question or
problem that is not answered by the information provided in
this readme.txt file.Please contact us.

This readme.txt file for the PortInterface software version 0.1 
for PCs includes information that was not incorporated into the 
printed documentation or online Help.

   **How To Run the Application:
   -----------------------------
   
   For Word Operation:
   -------------------
      0 Click on PortInterface.exe.
      0 If device present then exe will open in Full mode otherwise in Demo mode.
      0 To read word first enter(32-bit) address(in HEX) then click Read button.
      0 To write word enter address(32-bit) and data(32-bit) then click Write button.
      0	To verify word first select Once or Continuous mode & then enter the address(32-bit) and data(32-bit) which is to be verified.
      	In Continuous mode, there is an option of Auto-Increment mode for both Address & Data.
      
      
   For File Operation:
   -------------------
      0 To Write a file into memory click or select file Write option from the GUI.
      0 Select the specific file and give the (32-bit) addrerss (in Hex) and click on send file button.
      0 To read a file from the memory click or select read option from the GUI.
      0 Enter the 32-bit address for reading the file.And also the number of bytes you want to read from the file.
      0	To verify a file, first browse the file to be verified & and then enter the address(32-bit) from where to read that file to verify.
      

   On status bar, it gives status of USBdevice whether connected or not.

   NOTE :
   ------
   
      Base Address of the SDRAM and SRAM are given in your Quartus System, So get it from there.
        