// SLSUSBClient.cpp : Defines the entry point for the console application.
//

#include <fcntl.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
	int 	Device_Handle = 0; 			// File pointer for accessing the SLSUSB Driver.
	int 	i = 0;						// Counter variable
	char 	*bWBuf;					// Buffer used for the read operation
	int 	n = 0;						// Used to keep track of the read/ write operations
	int 	iDevNo = 0;					// Number of Device to open
	int 	loop =0;					// Number of time read/write operation occurs

    	int     iNoOfByteToReadWrite;		// User input for the read write operations of the user
	int     iSelection;					// for the selection
	char	Device[25];

   	do
	{
	printf("1: WriteData to Device \n");
	printf("2: ReadData from Device \n");
	printf("3: Exit\n");

   	printf("Enter your selection index :\n");
	scanf("%d",&iSelection);
	//Device = "";
		switch(iSelection)
		{
		case 1:
			{
				printf("Enter Device No to access (Zero based Index):\n");
				scanf("%d",&iDevNo);

				// Select the device with the given number
				sprintf(Device,"/dev/SLSUSB%d",iDevNo);

				// Open the device
				Device_Handle = open(Device,O_RDWR);

				if(Device_Handle == -1)	// SLSUSB0 indicates device at zero index.
											// If you want to use device at index 1 then
											// it is SLSUSB1.
											// This list you can find in /dev Directory.
				{
					printf("Device Not Found\n");
					return 0;
				}

				printf("No of Bytes to write:\n");
				scanf("%d",&iNoOfByteToReadWrite);

				bWBuf = (char *) malloc(iNoOfByteToReadWrite);
				for(i=0;i<iNoOfByteToReadWrite;++i)
					bWBuf[i]=i;

				printf("How many times do you want to write:\n");
				scanf("%d",&loop);

				for(i=0;i<loop;++i)
				{
					n = write(Device_Handle,bWBuf,iNoOfByteToReadWrite);
					if(n==0)
						printf("Write operation failed\n");
					else
						printf("No of bytes written : %d\n",n);
				}

			free(bWBuf);
		    	close(Device_Handle);
		    	break;
			}
		case 2:
			{
				printf("Enter Device No to access (Zero based Index):\n");
				scanf("%d",&iDevNo);

				// Select the device with the given number
				sprintf(Device,"/dev/SLSUSB%d",iDevNo);

				// Open the device
				Device_Handle = open(Device,O_RDWR);
				if(Device_Handle == -1)	// SLSUSB0 indicates device at zero index.
											// If you want to use device at index 1 then
											// it is SLSUSB1.
											// This list you can find in /dev Directory.
				{
					printf("Device Not Found\n");
					return 0;
				}


				printf("No of Bytes to read:\n");
				scanf("%d",&iNoOfByteToReadWrite);

				bWBuf = (char *) malloc(iNoOfByteToReadWrite);

				printf("How many times do you want to read:\n");
				scanf("%d",&loop);

				for(i=0;i<loop;++i)
				{
					n = read(Device_Handle,bWBuf,iNoOfByteToReadWrite);
					if(n==0)
						printf("Read operation failed\n");
					else
						printf("No of bytes read : %d\n",n);

				// To varify the Read Data from the USB Devices
				/*for(i=0;i<n;i++)
				{
	 				  printf(" Position = %x   val = %x \n", i,bWBuf[i]);
	 			}*/

				}

				for(i=0;i<n;i++)
				{
	 				  printf(" Position = %x   val = %x \n", i,bWBuf[i]);
	 			}


			free(bWBuf);
		    	close(Device_Handle);
                	break;
			}
		case 5:
			printf("Thanks to use SLS USB\n");
			break;
		default:
			printf("Wrong Selection\n");
			break;
		}

	}while(iSelection!=5);

	return 0;
}
