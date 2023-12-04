// SLSUSBClient.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "slsusbinterface.h"
#include "iostream.h"
#include "conio.h"
#include "malloc.h"
#include "ctype.h"

int main(int argc, char* argv[])
{

	DWORD      dwNumOfDev;
	SLS_HANDLE hDevice;
	char       cBuffer[16];
//	BYTE       bRBuf[64];
	BYTE       *bWBuf;
//	BYTE       bROBuf[64];
	DWORD      junk;
	char       ch;
	char       *cDevBuf[15];
	DWORD        iIndex;
    int        iNoOfByteToREad=64;
	int        iSelection;
//    SLS_OVERLAPPED ov;



   	do
	{
	cout<<"0: Get Number of devices                             "<<endl;
	cout<<"1: Get Single Device SerialNumber                    "<<endl;
	cout<<"2: Get Single Device ProductDescription     "<<endl;
	cout<<"3: Get All Device SerialNumber              "<<endl;
	cout<<"4: Get All Device ProductDescription                              "<<endl;
	cout<<"5: WriteData to Device                               "<<endl;
	cout<<"6: ReadDat from Device                               "<<endl;

    cout<<"Enter your selection index :";
	cin>>iSelection;



	switch(iSelection)
	{
		case 0:
			{
				if(SLS_ListDevices(&dwNumOfDev,NULL,SLS_LIST_NUMBER_ONLY)==SLS_OK)
				{
					cout<<"Number of devices  are :"<<dwNumOfDev<<endl;
				}
				else
				{
					cout<<"Device Not Found "<<endl;
				}
				break;
			}
		case 1:
			{
				cout<<"Enter Device Number :";
				cin>>dwNumOfDev;
				if(SLS_ListDevices(&dwNumOfDev,cBuffer,SLS_LIST_BY_INDEX|SLS_OPEN_BY_SERIAL_NUMBER)==SLS_OK)
				{
					cout<<"Device Serial Number :"<<cBuffer<<endl;
				}
				else
				{
					cout<<"Device Not Found "<<endl;
				}
				break;
			}
		case 2:
			{
			    cout<<"Enter Device Number :";
				cin>>dwNumOfDev;
				if(SLS_ListDevices(&dwNumOfDev,cBuffer,SLS_LIST_BY_INDEX|SLS_OPEN_BY_DESCRIPTION)==SLS_OK)
				{
					cout<<"Device Product Description :"<<cBuffer<<endl;
				}
				else
				{
					cout<<"Device Not Found "<<endl;
				}
				break;
                break;
			}
		case 3:
			{

                if(SLS_ListDevices(cDevBuf,&dwNumOfDev,SLS_LIST_ALL|SLS_OPEN_BY_SERIAL_NUMBER)==SLS_OK)
				{
					for(iIndex=0;iIndex<dwNumOfDev;iIndex++)
					{
						cout<<"Device No:"<<iIndex<<endl;
						cout<<"Device Serial Number :"<<cDevBuf[iIndex]<<endl;
					}
				}
				else
				{
					cout<<"Device Not Found "<<endl;
				}
                break;
			}
		case 4:
			{
				 if(SLS_ListDevices(cDevBuf,&dwNumOfDev,SLS_LIST_ALL|SLS_OPEN_BY_DESCRIPTION)==SLS_OK)
				{
					for(iIndex=0;iIndex<dwNumOfDev;iIndex++)
					{
						cout<<"Device No:"<<iIndex<<endl;
						cout<<"Device Product Description :"<<cDevBuf[iIndex]<<endl;
					}
				}
				else
				{
					cout<<"Device Not Found "<<endl;
				}
                break;
                break;
			}
		case 6:
			{
			   int iDevNo;
			   cout<<"Enter Device No to access :";
			   cin>>iDevNo;
			   if(SLS_ListDevices(&iDevNo,cBuffer,SLS_LIST_BY_INDEX|SLS_OPEN_BY_DESCRIPTION)==SLS_OK)
				{

					hDevice = SLS_W32_CreateFile(cBuffer,
					                    GENERIC_READ|GENERIC_WRITE,
										NULL,
										NULL,
										OPEN_EXISTING,
										FILE_ATTRIBUTE_NORMAL|SLS_OPEN_BY_DESCRIPTION,
										NULL);
					if(hDevice==INVALID_HANDLE_VALUE)
					{
						cout<<"Invalid Handle Value "<<GetLastError()<<endl;
						break;
					}

					cout<<"No of Bytes to Read :";
					cin>>iNoOfByteToREad;

					bWBuf = (BYTE *) malloc(iNoOfByteToREad);

	                if(!SLS_W32_ReadFile(hDevice,bWBuf,iNoOfByteToREad,&junk,NULL))
					{
						cout<<"Read operation fail GetlastError :"<<GetLastError()<<endl;
					}
					else
					{
	 					cout<<"No of bytes Read :"<<junk<<endl;
					}
					free(bWBuf);
		    		SLS_W32_CloseHandle(hDevice);
			   }
			   else
			   {
				   cout<<"Device Not Found"<<endl;
			   }



                break;
			}
		case 5:
			{
			   int iDevNo;
			   cout<<"Enter Device No to access :";
			   cin>>iDevNo;
			   if(SLS_ListDevices(&iDevNo,cBuffer,SLS_LIST_BY_INDEX|SLS_OPEN_BY_DESCRIPTION)==SLS_OK)
				{

					hDevice = SLS_W32_CreateFile(cBuffer,
					                    GENERIC_READ|GENERIC_WRITE,
										NULL,
										NULL,
										OPEN_EXISTING,
										FILE_ATTRIBUTE_NORMAL|SLS_OPEN_BY_DESCRIPTION,
										NULL);
					if(hDevice==(PVOID)SLS_INVALID_HANDLE)
					{
						cout<<"Invalid Handle Value "<<GetLastError()<<endl;
						break;
					}

					cout<<"No of Bytes to write :";
					cin>>iNoOfByteToREad;

					bWBuf = (BYTE *) malloc(iNoOfByteToREad);
					/*for(int i=0;i<iNoOfByteToREad;++i)
						bWBuf[i] = i;*/
	                if(!SLS_W32_WriteFile(hDevice,bWBuf,iNoOfByteToREad,&junk,NULL))
					{
						cout<<"Write operation fail GetlastError :"<<GetLastError()<<endl;
					}
					else
					{
	 					cout<<"No of bytes written : "<<junk<<endl;
					}
					free(bWBuf);
		    		SLS_W32_CloseHandle(hDevice);
			   }
			   else
			   {
				   cout<<"Device Not Found"<<endl;
			   }
               break;
			}


		default:
			    cout<<"Wrong Selection"<<endl;
				break;

	}

    cout<<"EXIT Y:N";
	cin>>ch;

	}
    while(ch=='N' || ch=='n');


       /*
       ov.Offset =0;
	   ov.OffsetHigh =0;
	   ov.hEvent =CreateEvent(NULL,false,false,NULL);

	   //while(1)
	   //{
	       if(!SLS_W32_ReadFile(hDevice,bRBuf,iNoOfByteToREad,&junk,&ov))
		   {
			   int iStatus = GetLastError();

			   if(iStatus ==ERROR_IO_PENDING)
			   {
                  cout<<"ERROR_IO_PENDING"<<endl;
				  DWORD dwResult = WaitForSingleObject(ov.hEvent,INFINITE);
                  switch(dwResult)
				  {
				  case WAIT_ABANDONED:
					  cout<<"WAIT_ABANDONED"<<endl;
					  break;
				  case WAIT_OBJECT_0:
					  {

                        if(!SLS_W32_GetOverlappedResult(hDevice,&ov,&junk,TRUE))
						{
						   cout<<"Error is "<<GetLastError()<<endl;
						   cout<<"Number of read from device :"<<junk<<endl;
						   break;
						}
					    cout<<"Number of read from device :"<<junk<<endl;
					    break;
					  }

				  case WAIT_TIMEOUT:
					  cout<<"WAIT_TIMEOUT"<<endl;
					  break;
				  default:
					  cout<<"Error is "<<GetLastError()<<endl;
					  break;
				  }

			   }
			   else
                  cout<<"ReadFile operation fail GetLastError : "<<iStatus<<endl;

		   }
	       else
		   {
		      cout<<"Number of read from device :"<<junk<<endl;
		   }
		   /*
		      for(int iIndex=0;iIndex<junk;iIndex++)
			  {
			    cout<<"Data "<<bRBuf[iIndex]<<endl;
			  }*/






	return 0;
}

