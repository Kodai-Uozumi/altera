
/*****************************************************************************************
* File Name                  :PortInterface_C_Source.c
* Version                    :v1.00.00
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

extern void sls_avalon_usb20_init(volatile void *);
extern void usb20hr_config (volatile int ,volatile int,const char *);
extern void  usb20hr_connect(void);
int h_USB; /* usb handle */
#define DATA 512
#define LOOP 128


//****************************************************************************************

int main()
{

  int count,i,times=0;
  unsigned char ReadData[DATA],WriteData[DATA]={0x02};
  unsigned int usb_base = USB20HR_0_BASE;

  printf("WelCome to PortInterface Streaming Application\n");

  usb20hr_config(usb_base,USB20HR_0_IRQ,USB20HR_0_NAME);

  h_USB = open(USB20HR_0_NAME,O_RDWR);

  if(h_USB<0)
  {
    printf("Error in USB Open\n");
    return 0;
  }
  else
  {
    printf("USB Open Successfully\n");
  }

 usb20hr_connect();

 
 usb20hr_dma_usage(1,DMA_0_BASE);



 for(i=0;i<DATA;++i)
    {
      WriteData[i]=i;
    }
   i = 0;
  //loop that write/read 64KB of data to/from PC.
  while(1)
  {
    
    //count=write(h_USB,WriteData,DATA); //For writing to HOST. (BULK_IN)   
    count=read(h_USB,ReadData,DATA); //For reading(BULK_OUT)performance measurment, please un-comment this and comment BULK_IN routine,if you want to do bulk_out.
    
    i++;
    if(i== LOOP)  //It comes out of loop once successfully completed data
    {
        printf("Connect Successfully\n");
        break;
    }
  }

}

