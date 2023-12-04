using System;
using System.Collections.Generic;
using System.Text;
using SLSUSBNET;

namespace SLSUSB_Example
{
    class Program
    {
        static void Main(string[] args)
        {
            byte[] NumDev = new byte[1];            
            byte[] buffer = new byte[16];
            byte[] cDevBuf=new byte[15] ;
            int iNoOfByteToREad=64;
            String strNoOfByteToRead = "";
            int hdevice = new int();
            String str_Input = "";
            String str_Selection = "";
            String str_DeviceNo = "";            
            int INVALID_HANDLE_VALUE = (-1),  SLS_OK = 0;	    
            Int32 iSelection, iIndex = 0,iDeviceNo;    

   	        do
	        {
                str_Input = "";
                str_Selection = "";

                Console.Out.WriteLine("0: Get Number of devices");
                Console.Out.WriteLine("1: Get Single Device SerialNumber");
                Console.Out.WriteLine("2: Get Single Device ProductDescription");
                Console.Out.WriteLine("3: Get All Device SerialNumber");
                Console.Out.WriteLine("4: Get All Device ProductDescription");
                Console.Out.WriteLine("5: WriteData to Device");
                Console.Out.WriteLine("6: ReadData from Device");
                Console.Out.WriteLine("7: Write Stream of Data to Device");
                Console.Out.WriteLine("8: Read Stream of Data from Device");
                Console.Out.WriteLine();

                Console.Out.Write("Enter your selection index : ");

                str_Selection = Console.In.ReadLine();

                try
                {
                    iSelection = int.Parse(str_Selection);
                }
                catch
                {
                 //  Invalid Input
                    iSelection = -1;
                }              

	            switch(iSelection)
	            {
		            case 0: 
			            {
                            if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_NUMBER_ONLY) == SLS_OK)  // To get List of Devices connected
				            {
					            Console.Out.WriteLine("Number of devices  are : " + Convert.ToString(NumDev[0]));
				            }
				            else 
				            {
					            Console.Out.WriteLine("Device Not Found ");
				            }
				            break;
			            }
		            case 1:
			            {
                            try
                            {
                                Console.Out.Write("Enter Device Number : ");
                                str_DeviceNo = Console.In.ReadLine();
                                try
                                {
                                    iDeviceNo = int.Parse(str_DeviceNo);
                                }
                                catch 
                                {
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }

                                try
                                {
                                    NumDev = BitConverter.GetBytes(iDeviceNo);
                                }
                                catch
                                {
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }

                                if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_BY_INDEX | SLSNETAPI.SLS_OPEN_BY_SERIAL_NUMBER) == 0) // To get Serial Number of the Device whose Index number is passed as argument
                                {
                                    Console.Out.WriteLine("Device Serial Number : " + (System.Text.Encoding.ASCII.GetString(buffer)).Substring(0, 16));
                                }
                                else
                                {
                                    Console.Out.WriteLine("Device Not Found ");
                                }                                
                            }
                            catch (Exception ex)
                            {
                                break;
                            }
                            break;
			            }
                    
                    case 2:
                        {
                         try
                            {
                                Console.Out.Write("Enter Device Number : ");
                                str_DeviceNo = Console.In.ReadLine();
                                try
                                {
                                    iDeviceNo = int.Parse(str_DeviceNo);
                                }
                                catch
                                {
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                    //iSelection = -1;
                                }

                                try
                                {
                                    NumDev = BitConverter.GetBytes(iDeviceNo);
                                }
                                catch
                                {
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }

                                if (SLSNETAPI.SLS_ListDevices(NumDev, cDevBuf, SLSNETAPI.SLS_LIST_BY_INDEX | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION) == 0) // To get Description of the Device whose Index number is passed as argument
                                {
                                    Console.Out.WriteLine("Device Product Description : " + (System.Text.Encoding.ASCII.GetString(cDevBuf)).Substring(0, 15));
                                }
                                else
                                {
                                    Console.Out.WriteLine("Device Not Found");
                                }
                            }
                            catch (Exception ex)
                            {
                                break;
                            }
                            break;                            
                        }
                    case 3:
                        {         
                            if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_NUMBER_ONLY) == 0) // Gets the Total number of Devices connected
                            {
                                iDeviceNo = Convert.ToInt32(NumDev[0]);
                            }
                            else
                            {
                                Console.Out.WriteLine("Device Not Found ");
                                break;
                            }

                            for (iIndex = 0; iIndex < iDeviceNo; iIndex++)
                            {
                                NumDev = BitConverter.GetBytes(iIndex);
                                
                                buffer = new byte[16];

                                // One by one Gets Serial Number of devices connected based on the Index passed as argument.

                                if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_BY_INDEX | SLSNETAPI.SLS_OPEN_BY_SERIAL_NUMBER) == 0)
                                {
                                    Console.Out.WriteLine("Device No: " + iIndex.ToString());
                                    Console.Out.WriteLine("Device Serial Number : " + (System.Text.Encoding.ASCII.GetString(buffer)).Substring(0, 16));
                                }
                                else
                                {
                                    Console.Out.WriteLine("Device Not Found");
                                    break;
                                }
                            }
                            break;
                        }
                    case 4:
                        {
                            if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_NUMBER_ONLY) == 0) // Gets the Total number of Devices connected
                            {
                                iDeviceNo = Convert.ToInt32(NumDev[0]);
                            }
                            else
                            {
                                Console.Out.WriteLine("Device Not Found");
                                break;
                            }

                            for (iIndex = 0; iIndex < iDeviceNo; iIndex++)
                            {
                                NumDev = BitConverter.GetBytes(iIndex);
                                cDevBuf = new byte[15];

                                // One by one Gets Description of devices connected based on the Index passed as argument.

                                if (SLSNETAPI.SLS_ListDevices(NumDev, cDevBuf, SLSNETAPI.SLS_LIST_BY_INDEX | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION) == 0)
                                {
                                    Console.Out.WriteLine("Device No: " + iIndex.ToString());
                                    Console.Out.WriteLine("Device Product Description : " + (System.Text.Encoding.ASCII.GetString(cDevBuf)).Substring(0, 15));
                                }
                                else
                                {
                                    Console.Out.WriteLine("Device Not Found");
                                    break;
                                }
                            }
                            break;
                        }
                    case 5:
                        {
                            Console.Out.Write("Enter Device No to access : ");
                            str_DeviceNo = Console.In.ReadLine();
                            try
                            {
                                iDeviceNo = int.Parse(str_DeviceNo);
                            }
                            catch
                            {
                                Console.Out.WriteLine("Invalid Input");
                                break;
                            }

                            try
                            {
                                NumDev = BitConverter.GetBytes(iDeviceNo);
                            }
                            catch
                            {
                                Console.Out.WriteLine("Invalid Input");
                                break;
                            }
                            
                            if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_BY_INDEX | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION) == SLS_OK)  // Gets Description of the Device whose Index is passed as argument ( Index of the device into which we want to write)
                            {
                                try
                                {
                                    hdevice = SLSNETAPI.SLS_W32_CreateFile(
                                                         buffer,
                                                         SLSNETAPI.GENERIC_READ | SLSNETAPI.GENERIC_WRITE,
                                                         0,
                                                         (IntPtr)0,
                                                         SLSNETAPI.OPEN_EXISTING,
                                                         SLSNETAPI.FILE_ATTRIBUTE_NORMAL | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION,
                                                         0);    // Opens the device based on the Description passed as argument (buffer) & gets Handle to that device.
                                }
                                catch (Exception e)
                                { }

                                if (hdevice == INVALID_HANDLE_VALUE)
                                {
                                    Console.Out.WriteLine("Invalid Handle Value");
                                    break;
                                }

                                Console.Out.Write("No of Bytes to write : ");
                                strNoOfByteToRead = Console.In.ReadLine();
                                try
                                {
                                    iNoOfByteToREad = int.Parse(strNoOfByteToRead);
                                }
                                catch 
                                {                    
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }
                                byte[] WriteBuf = new byte[iNoOfByteToREad];  
       


                                int ReturnByte = 0;
                                int overlapped = 0;

                                try
                                {
                                    if (!SLSNETAPI.SLS_W32_WriteFile(hdevice, WriteBuf, iNoOfByteToREad, ref ReturnByte, overlapped)) // Writes data contained in WriteBuf (having no. of bytes specified by user - iNoOfByteToRead) to the device opened with handle - hdevice.
                                    {
                                        Console.Out.WriteLine("Write operation failed");
                                    }
                                    else
                                    {
                                        Console.Out.WriteLine("No of bytes written : " + ReturnByte); // ReturnByte contains the Number of Bytes written to the device.
                                    }
                                    SLSNETAPI.SLS_W32_CloseHandle(hdevice);
                                }
                                catch
                                {
                                    Console.Out.WriteLine("Write operation failed");
                                }
                            }
                            else
                            {
                                Console.Out.WriteLine("Device Not Found ");
                            }
                            break;
                        }
                        
                    case 6:
                        {
                            Console.Out.Write("Enter Device No to access : ");
                            str_DeviceNo = Console.In.ReadLine();
                            try
                            {
                                iDeviceNo = int.Parse(str_DeviceNo);
                            }
                            catch 
                            {
                                Console.Out.WriteLine("Invalid Input");
                                break;
                            }

                            try
                            {
                                NumDev = BitConverter.GetBytes(iDeviceNo);
                            }
                            catch
                            {
                                Console.Out.WriteLine("Invalid Input");
                                break;
                            }

                            if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_BY_INDEX | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION) == SLS_OK) // Gets Description of the Device whose Index is passed as argument ( Index of the device from which we want to read data)
                            {
                                try
                                {
                                    hdevice = SLSNETAPI.SLS_W32_CreateFile(
                                                         buffer,
                                                         SLSNETAPI.GENERIC_READ | SLSNETAPI.GENERIC_WRITE,
                                                         0,
                                                         (IntPtr)0,
                                                         SLSNETAPI.OPEN_EXISTING,
                                                         SLSNETAPI.FILE_ATTRIBUTE_NORMAL | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION,
                                                         0); // Opens the device based on the Description passed as argument (buffer) & gets Handle to that device.
                                } 
                                catch (Exception e)
                                { }

                                if (hdevice == INVALID_HANDLE_VALUE)
                                {
                                    Console.Out.WriteLine("Invalid Handle Value");
                                    break;
                                }

                                Console.Out.Write("No of Bytes to Read : ");
                                strNoOfByteToRead = Console.In.ReadLine();
                                try
                                {
                                    iNoOfByteToREad = int.Parse(strNoOfByteToRead);
                                }
                                catch
                                {                    
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }
                                byte[] ReadBuf = new byte[iNoOfByteToREad];         
                                int ReturnByte = 0;
                                int overlapped = 0;

                                try
                                {
                                    if (!SLSNETAPI.SLS_W32_ReadFile(hdevice, ReadBuf, iNoOfByteToREad, ref ReturnByte, overlapped)) // Reads data into ReadBuf ( iNoOfByteToRead - specified the no. of bytes to read ) from the device opened with handle - hdevice.
                                    {
                                        Console.Out.WriteLine("Read operation failed");
                                    }
                                    else
                                    {
                                        Console.Out.WriteLine("No of bytes read : " + ReturnByte); // ReturnByte contains the Number of Bytes read from the device.
                                    }
                                    SLSNETAPI.SLS_W32_CloseHandle(hdevice);
                                }
                                catch
                                {
                                    Console.Out.WriteLine("Read operation failed");
                                    SLSNETAPI.SLS_W32_CloseHandle(hdevice);
                                }
                            }
                            else
                            {
                                Console.Out.WriteLine("Device Not Found");
                            }
                            break;           
                        }

                    case 7:
                        {
                            Console.Out.Write("Enter Device No to access : ");
                            str_DeviceNo = Console.In.ReadLine();
                            try
                            {
                                iDeviceNo = int.Parse(str_DeviceNo);
                            }
                            catch
                            {
                                Console.Out.WriteLine("Invalid Input");
                                break;
                            }

                            try
                            {
                                NumDev = BitConverter.GetBytes(iDeviceNo);
                            }
                            catch
                            {
                                Console.Out.WriteLine("Invalid Input");
                                break;
                            }

                            if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_BY_INDEX | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION) == SLS_OK)  // Gets Description of the Device whose Index is passed as argument ( Index of the device into which we want to write)
                            {
                                try
                                {
                                    hdevice = SLSNETAPI.SLS_W32_CreateFile(
                                                         buffer,
                                                         SLSNETAPI.GENERIC_READ | SLSNETAPI.GENERIC_WRITE,
                                                         0,
                                                         (IntPtr)0,
                                                         SLSNETAPI.OPEN_EXISTING,
                                                         SLSNETAPI.FILE_ATTRIBUTE_NORMAL | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION,
                                                         0);    // Opens the device based on the Description passed as argument (buffer) & gets Handle to that device.
                                }
                                catch (Exception e)
                                { }

                                if (hdevice == INVALID_HANDLE_VALUE)
                                {
                                    Console.Out.WriteLine("Invalid Handle Value");
                                    break;
                                }

                                Console.Out.Write("No of Bytes to write : ");
                                strNoOfByteToRead = Console.In.ReadLine();
                                try
                                {
                                    iNoOfByteToREad = int.Parse(strNoOfByteToRead);
                                }
                                catch 
                                {
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }

                                Int32 iNoOfTimesToWrite = 0;
                                String strNoOfTimesToWrite = "";

                                Console.Out.Write("No of Times to Write : ");
                                strNoOfTimesToWrite = Console.In.ReadLine();
                                try
                                {
                                    iNoOfTimesToWrite = int.Parse(strNoOfTimesToWrite);
                                }
                                catch 
                                {
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }


                                byte[] WriteBuf = new byte[iNoOfByteToREad];
                                int ReturnByte = 0;
                                int overlapped = 0;

                                for (int i = 0; i < iNoOfTimesToWrite; i++)
                                {
                                    try
                                    {
                                        if(!SLSNETAPI.SLS_W32_WriteFile(hdevice, WriteBuf, iNoOfByteToREad, ref ReturnByte, overlapped)) // Writes data contained in WriteBuf (having no. of bytes specified by user - iNoOfByteToRead) to the device opened with handle - hdevice.
                                        {
                                            Console.Out.WriteLine("Write operation failed");
                                        }
                                        else
                                        {
                                            Console.Out.WriteLine("No of bytes written : " + ReturnByte); // ReturnByte contains the Number of Bytes written to the device.
                                        }
                                       
                                    }
                                    catch
                                    {
                                        Console.Out.WriteLine("Write operation failed");
                                        SLSNETAPI.SLS_W32_CloseHandle(hdevice);
                                    }
                                }

                                SLSNETAPI.SLS_W32_CloseHandle(hdevice);
                            }
                            else
                            {
                                Console.Out.WriteLine("Device Not Found ");
                            }
                            break;
                        }

                    case 8:
                        {
                            Console.Out.Write("Enter Device No to access : ");
                            str_DeviceNo = Console.In.ReadLine();
                            try
                            {
                                iDeviceNo = int.Parse(str_DeviceNo);
                            }
                            catch 
                            {
                                Console.Out.WriteLine("Invalid Input");
                                break;
                            }

                            try
                            {
                                NumDev = BitConverter.GetBytes(iDeviceNo);
                            }
                            catch
                            {
                                Console.Out.WriteLine("Invalid Input");
                                break;
                            }

                            if (SLSNETAPI.SLS_ListDevices(NumDev, buffer, SLSNETAPI.SLS_LIST_BY_INDEX | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION) == SLS_OK) // Gets Description of the Device whose Index is passed as argument ( Index of the device from which we want to read data)
                            {
                                try
                                {
                                    hdevice = SLSNETAPI.SLS_W32_CreateFile(
                                                         buffer,
                                                         SLSNETAPI.GENERIC_READ | SLSNETAPI.GENERIC_WRITE,
                                                         0,
                                                         (IntPtr)0,
                                                         SLSNETAPI.OPEN_EXISTING,
                                                         SLSNETAPI.FILE_ATTRIBUTE_NORMAL | SLSNETAPI.SLS_OPEN_BY_DESCRIPTION,
                                                         0); // Opens the device based on the Description passed as argument (buffer) & gets Handle to that device.
                                }
                                catch (Exception e)
                                { }

                                if (hdevice == INVALID_HANDLE_VALUE)
                                {
                                    Console.Out.WriteLine("Invalid Handle Value");
                                    break;
                                }

                                Console.Out.Write("No of Bytes to Read : ");
                                strNoOfByteToRead = Console.In.ReadLine();
                                try
                                {
                                    iNoOfByteToREad = int.Parse(strNoOfByteToRead);
                                }
                                catch 
                                {
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }

                                Int32 iNoOfTimesToRead = 0;
                                String strNoOfTimesToRead = "";

                                Console.Out.Write("No of Times to read : ");
                                strNoOfTimesToRead = Console.In.ReadLine();
                                try
                                {
                                    iNoOfTimesToRead = int.Parse(strNoOfTimesToRead);
                                }
                                catch 
                                {
                                    Console.Out.WriteLine("Invalid Input");
                                    break;
                                }

                                byte[] ReadBuf = new byte[iNoOfByteToREad];
                                int ReturnByte = 0;
                                int overlapped = 0;

                                for (int i = 0; i < iNoOfTimesToRead; i++)
                                {
                                    try
                                    {
                                        if (!SLSNETAPI.SLS_W32_ReadFile(hdevice, ReadBuf, iNoOfByteToREad, ref ReturnByte, overlapped)) // Reads data into ReadBuf ( iNoOfByteToRead - specified the no. of bytes to read ) from the device opened with handle - hdevice.
                                        {
                                            Console.Out.WriteLine("Read operation failed");
                                        }
                                        else
                                        {
                                            Console.Out.WriteLine("No of bytes read : " + ReturnByte); // ReturnByte contains the Number of Bytes read from the device.
                                        }
                                       
                                    }
                                    catch
                                    {
                                        Console.Out.WriteLine("Read operation failed");
                                        SLSNETAPI.SLS_W32_CloseHandle(hdevice);
                                    }
                                }
                                SLSNETAPI.SLS_W32_CloseHandle(hdevice);
                            }
                            else
                            {
                                Console.Out.WriteLine("Device Not Found");
                            }
                            break;
                        }
                    default:
                            Console.Out.WriteLine("Invalid Input");
				                break;            
	                }

            Console.Out.Write("EXIT Y:N ");
            str_Input = Console.In.ReadLine();            
	        }
            while (str_Input == "N" || str_Input == "n");	
      
        }
    }
}
