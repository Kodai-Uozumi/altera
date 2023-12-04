
/*****************************************************************************************
* File Name    :PortInterface.c
* Version      :v1.00.00
* NIOSII Software Suspport   : NIOSII IDE
*
* Description  : This is a simple C file that shows how to use NIOS II processor
*                to grab the commands/data provided by USB2,0 IP and take the necessary
*                action according to it.
*
* Copyright (C) 2005 by SLS
* All rights reserved
*
******************************************************************************************/
#include "stdio.h"
#include "io.h"
#include "system.h"
#include "sys/alt_irq.h"
#include <fcntl.h> 
#include "unistd.h"


extern void usb20hr_config (volatile int ,volatile int,const char *);
extern void usb20hr_dma_usage(unsigned int usage,unsigned int dma_address);
extern void usb20hr_connect();

#define WRITE 0x01
#define READ  0x02
#define BLK_WRITE 0x03
#define BLK_READ 0x04

#define DATA   9
#define OFFSET 0x0

unsigned int g_address; /* store address */
unsigned char global_data[9];
int h_USB; /* usb handle */

void BULK_IN(void);
void BULK_OUT(void);
void BLOCK_READ(void);
void BLOCK_WRITE(void);

/****************************************************************************************
 Function Name : BULK_IN()
 Function Descriptor: This function reads 4Bytes from the USB device using HAL driver.
                      Which indicate the address of memory location from there data to be
                      read.After reading the data from that location program will write
                      the value to the USB using HAL driver.
****************************************************************************************/
void BULK_IN()
{

   unsigned char  Data[4];
   g_address=0;
   //Read 32- Addresss from USB

   g_address = (g_address | global_data[4]);
   g_address = (g_address | (global_data[3]<<8));
   g_address = (g_address | (global_data[2]<<16));
   g_address = (g_address | (global_data[1]<<24));

   // Write 32- bit DATA to USB
   Data[0] = (IORD_8DIRECT(g_address,OFFSET));
   Data[1] = (IORD_8DIRECT(g_address,OFFSET+1));
   Data[2] = (IORD_8DIRECT(g_address,OFFSET+2));
   Data[3] = (IORD_8DIRECT(g_address,OFFSET+3));

//   printf(" data = %x \n",  Data[0]);
//   printf(" data = %x \n",  Data[1]);
//   printf(" data = %x \n",  Data[2]);
//   printf(" data = %x \n",  Data[3]);

   write(h_USB,Data,4);
}

/****************************************************************************************
 Function Name : BULK_OUT()
 Function Descriptor: This function reads 8 bytes from the USB device using HAL driver of
                      USB.First 4Bytes indicates the address of memory location and last
                      4Bytes are data.That will write at the location of memory address.
****************************************************************************************/

void BULK_OUT()
{

  // unsigned int Data=0;

   g_address=0;
   //printf(" BULK OUT \n" );
   g_address = (g_address | global_data[4]);
   g_address = (g_address | (global_data[3]<<8));
   g_address = (g_address | (global_data[2]<<16));
   g_address = (g_address | (global_data[1]<<24));

   /* Write 32- bit Data */
   IOWR_8DIRECT(g_address,0x0,global_data[8]);
   IOWR_8DIRECT(g_address,0x1,global_data[7]);
   IOWR_8DIRECT(g_address,0x2,global_data[6]);
   IOWR_8DIRECT(g_address,0x3,global_data[5]);
     
  // printf(" address = %x  data = %x %x %x %x \n",g_address,global_data[8],global_data[7],global_data[6],global_data[5]); 

   return;
}

/****************************************************************************************
 Function Name : BLOCK_READ()
 Function Descriptor: This function reads 4Bytes from the USB device using HAL driver.
                      Which indicate the address of memory location from there data to be
                      read.After reading the data from that location program will write
                      the value to the USB using HAL driver.
****************************************************************************************/
void BLOCK_READ()
{
   unsigned int bulk = 4096; 
   unsigned char  Data[4096];
   unsigned int NoOfBytesToRead=0,i=0,k=0;
  // unsigned int count=0;
   g_address=0;
   //Read 32- Addresss from USB

   g_address = (g_address | global_data[4]);
   g_address = (g_address | (global_data[3]<<8));
   g_address = (g_address | (global_data[2]<<16));
   g_address = (g_address | (global_data[1]<<24));

   NoOfBytesToRead=(NoOfBytesToRead | (global_data[8]));
   NoOfBytesToRead=(NoOfBytesToRead | (global_data[7]<<8));
   NoOfBytesToRead=(NoOfBytesToRead | (global_data[6]<<16));
   NoOfBytesToRead=(NoOfBytesToRead | (global_data[5]<<24));
  
   if(NoOfBytesToRead<bulk)
   {
    for(i=0;i<NoOfBytesToRead;i++)
    {
     Data[i]= (IORD_8DIRECT(g_address,OFFSET+i));
    }    
    write(h_USB,Data,NoOfBytesToRead);
   }
   else
   {         
        int loopcount = NoOfBytesToRead / bulk;
        int mod = NoOfBytesToRead % bulk;
        if (mod != 0)
            loopcount++;
            
        for (k = 0; k < loopcount; k++)
            {
               if (k == loopcount - 1 && mod != 0)
               {                 
                    bulk = mod;
               }  
               unsigned char D[bulk]; 
                                            
               for(i=0;i<bulk;i++)
               {
                 D[i]= (IORD_8DIRECT(g_address,(OFFSET+i)+(k*4096)));
               }    
               write(h_USB,D,bulk);                
            }
                
     }   
}




/****************************************************************************************
 Function Name : BLOCK_WRITE()
 Function Descriptor: This function reads 8 bytes from the USB device using HAL driver of
                      USB.First 4Bytes indicates the address of memory location and last
                      4Bytes indicates the Number of Bytes to write to the device.
                      After that it will continuously read 8 Bytes data till it finishes 
                      writing the specified number of bytes.
                      
****************************************************************************************/

void BLOCK_WRITE()
{

 //  unsigned int Data=0;
 unsigned int bulk = 4096; 
   unsigned int NoOfBytesToWrite=0;
   unsigned int count=0,i=0,k=0;
   g_address=0;
   //printf(" BULK OUT \n" );
   g_address = (g_address | global_data[4]);
   g_address = (g_address | (global_data[3]<<8));
   g_address = (g_address | (global_data[2]<<16));
   g_address = (g_address | (global_data[1]<<24));
   
   NoOfBytesToWrite=(NoOfBytesToWrite | (global_data[8]));
   NoOfBytesToWrite=(NoOfBytesToWrite | (global_data[7]<<8));
   NoOfBytesToWrite=(NoOfBytesToWrite | (global_data[6]<<16));
   NoOfBytesToWrite=(NoOfBytesToWrite | (global_data[5]<<24));
/////////////////////////////////////////////////

if(NoOfBytesToWrite<bulk)
   {
    unsigned char g_data[NoOfBytesToWrite];
    
    read(h_USB,g_data,NoOfBytesToWrite);
    
    for(i=0;i<NoOfBytesToWrite;i++)
    {      
      IOWR_8DIRECT(g_address,i,g_data[i]);
    } 
   }
   else
   {               
        int loopcount = NoOfBytesToWrite / bulk;
        int mod = NoOfBytesToWrite % bulk;
        if (mod != 0)
            loopcount++;
            
        for (k = 0; k < loopcount; k++)
            {
               if (k == loopcount - 1 && mod != 0)
               {                 
                    bulk = mod;
               }
               
               unsigned char g_data[bulk];
                   
               read(h_USB,g_data,bulk);                           
               
               for(i=0;i<bulk;i++)
               {
                IOWR_8DIRECT(g_address,(i)+(k*4096),g_data[i]);                 
           //     printf(" data = %x  \n ",g_data[i + (k*bulk)]); 
               }             
            }                
     }   


//////////////////////////////////////////////////
//    for(count=0;count<NoOfBytesToWrite;count+=8)
//    {
//       read(h_USB,global_data,8);
//       
//       /* Write 64- bit Data */
//       
//       IOWR_8DIRECT(g_address,count,global_data[0]);
//       IOWR_8DIRECT(g_address,count+1,global_data[1]);
//       IOWR_8DIRECT(g_address,count+2,global_data[2]);   
//       IOWR_8DIRECT(g_address,count+3,global_data[3]);
//       
//       IOWR_8DIRECT(g_address,count+4,global_data[4]);
//       IOWR_8DIRECT(g_address,count+5,global_data[5]);
//       IOWR_8DIRECT(g_address,count+6,global_data[6]);
//       IOWR_8DIRECT(g_address,count+7,global_data[7]);
//       //printf(" address = %x  data = %x %x %x %x %x %x %x %x \n ",g_address,global_data[7],global_data[6],global_data[5],global_data[4],global_data[3],global_data[2],global_data[1],global_data[0]); 
//    }
    
   return;
}

/****************************************************************************************
Function Name : main()
Function Descriptor: Initially this function open the handle of the USB device.If it exist
                     then it checks for the read/write operation using reading first opcode
                     According to that it will call BULK_IN/BULK_OUT function
****************************************************************************************/

int main()
{

  unsigned int usb_base = USB20HR_0_BASE;
  printf("WelCome to PortInterface Application\n");

  usb20hr_config(usb_base,USB20HR_0_IRQ,USB20HR_0_NAME);

  h_USB = open(USB20HR_0_NAME,O_RDWR);

  if(h_USB<0)
  {
    printf("Error in USB Open\n");
    return 0;
  }
  else
  {
    printf("USB open successfully \n");
  }

   usb20hr_dma_usage(0,DMA_0_BASE);

   usb20hr_connect();      //Added new function.


  /*Main loop which read the operation code and operation */
  while(1)
  {
      read(h_USB,global_data,9);

      if(global_data[0]==WRITE)
      {
        //printf("word write \n");
         BULK_OUT();
      }
      else if(global_data[0]==READ)
      {
        //printf("word read \n");
         BULK_IN();
      }
      else if(global_data[0]==BLK_WRITE)
      {
     // printf("block write \n");
        BLOCK_WRITE();
      }
      else if(global_data[0]==BLK_READ)
      {
        //printf("block read \n");
        BLOCK_READ();
      }      
      else
      {
         printf("Wrong OpCOde\n");
      }

   }

  return 0;
}
