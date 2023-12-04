#ifndef _SLS_AVALON_USB_20_HR_H__
#define _SLS_AVALON_USB_20_HR_H__

#include <stddef.h>
#include <sys/termios.h>

#include "sys/alt_dev.h"
#include "sys/alt_warning.h"
#include "system.h"
#include "os/alt_sem.h"
#include "os/alt_flag.h"
#include "alt_types.h"
#include "sls_avalon_usb20hr_regs.h"

#pragma pack(1)

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */


/* Configure all registers csr,int,buf0 and buf1 of  the Endpoint 1 as BULK IN endpoint */
#define EP1_BULK_IN_CONFIG_HS(base,csr_data)       IOWR_SLS_AVALON_USB20_EP1_CSR(base,csr_data);\
                                                IOWR_SLS_AVALON_USB20_EP1_INT(base,SLS_AVALON_USB20_EP_IMS_INT_A_ENABLE_MSK|SLS_AVALON_USB20_EP_IMS_INT_B_ENABLE_MSK);
                                                /*IOWR_SLS_AVALON_USB20_EP1_BUF0(base,0x7FFFFFFF);\
                                                IOWR_SLS_AVALON_USB20_EP1_BUF1(base,0x7FFFFFFF);*/

/* Configure all register csr,int,buf0 and buf1 of endpoint 2 as BULK OUT endpoint */
#define EP2_BULK_OUT_CONFIG_HS(base,csr_data)      IOWR_SLS_AVALON_USB20_EP2_CSR(base,csr_data);\
                                                   IOWR_SLS_AVALON_USB20_EP2_BUF0(base,SLS_AVALON_USB20_EP2_BF0_SZ_PTR_HS);

/************************************************************************************/
// For Full Speed selection.

#define EP1_BULK_IN_CONFIG_FS(base,csr_data)       IOWR_SLS_AVALON_USB20_EP1_CSR(base,csr_data);\
                                                   IOWR_SLS_AVALON_USB20_EP1_INT(base,SLS_AVALON_USB20_EP_IMS_INT_A_ENABLE_MSK|SLS_AVALON_USB20_EP_IMS_INT_B_ENABLE_MSK);


#define EP2_BULK_OUT_CONFIG_FS(base,csr_data)      IOWR_SLS_AVALON_USB20_EP2_CSR(base,csr_data);\
                                                   IOWR_SLS_AVALON_USB20_EP2_BUF0(base,SLS_AVALON_USB20_EP2_BF0_SZ_PTR_FS);

/************************************************************************************/


//IOWR_SLS_AVALON_USB20_EP2_BUF1(base,0x7FFFFFFF);
//SLS_AVALON_USB20_EP_IMS_INT_A_ENABLE_MSK|SLS_AVALON_USB20_EP_IMS_INT_B_ENABLE_MSK);
//IOWR_SLS_AVALON_USB20_EP2_INT(base,SLS_AVALON_USB20_EP_IMS_INT_A_ENABLE_MSK|SLS_AVALON_USB20_EP_IMS_INT_B_ENABLE_MSK);

#define DRIVER_NO_BUFFER                        (0x1)                   /* No driver buffer */
#define USB20_DEVICE_BUFFER_HS                  (0x800)                 /* USB2.0 core buffer size in HS*/
#define USB20_DEVICE_BUFFER_FS                  (0x40)                  /* USB2.0 core buffer size in FS*/
#define FUNCTION_ADDRESS_RESET_VALUE            (0x00000000)            /* RESTE VALUE to reset device address during,disconnect operation*/
#define CONTROL_EP_BUF0_OFST                    (0x0)                   /* offset for control endpoint in buffer0  */
#define CONTROL_EP_BUF0_LENGHT                  (0x8)                   /* Buffer0 length for controll endpoint */

#define CONTROL_EP_BUF1_SIZE_ZERO               (0x0)                   /* Buffer1*/
#define CONTROL_EP_BUF1_OFST                    (0x8)                   /* Buffer1 offset for control endpoint */
#define CONTROL_EP_BUF1_OFST_CONFIG             (0x1A)                  /* Configuratio offset in Buffer 1*/
#define CONTROL_EP_BUF1_OFST_LANG_ID            (0x3A)                  /* LNAG ID offset in Buffer1*/
#define CONTROL_EP_BUF1_OFST_MANU_STR           (0x3E)                  /* Manufacturing string desc offset  in buffer1 */
#define CONTROL_EP_BUF1_OFST_P_ID_STR           (0x46)                  /* Product string desc offset in buffer 1 */
#define CONTROL_EP_BUF1_OFST_S_NO_STR           (0x54)                  /* Serial Number desc offset in buffer1 */
#define CONTROL_EP_BUF1_OFST_CNF_STR            (0x58)
#define CONTROL_EP_BUF1_OFST_INTR_STR           (0x5C)

#define CONFIG_DESCRI_SIZE                      (0x9)                   /* Configuration Descriptor lenght */
/*Har coded configuration value of buff1 and CSR for time critical request,this value never change */
#define DEVICE_DESCRIPTIOR_CSR_CONFIG           (0x03030812)
#define DEVICE_DESCRIPTIOR_BUF1_CONFIG          (0x00240008)
#define CONTROL_EP_BUF0_CSR_CONFIG              (0x00100000)
#define CONFIG_DESC_CSR_CONFIG                  (0x03030809)
#define CONFIG_DESC_CSR_TOTAL_CONFI             (0x03030800)
#define STRING_DESC_LANG_ID_CSR                 (0x03030804)
#define SET_ADDRESS_CSR_CONFIG                  (0x03030800)
#define SET_ADDRESS_BUF1_CONFIG                 (0x00000008)
#define BUFFER1_INT_CSR_CONFIG                  (0x03030808)
#define BUFFER1_INT_BUF1_CONFIG                 (0x00240008)

#define CONTROL_EP_BUF_DATA_OFST_ZERO           (0x0)
#define CONTROL_EP_BUF_DATA_OFST_ONE            (0x4)

enum STR_DESCRIPTOR_NAME{LANG_ID=0,MANUFACTURER_STR,PRODUCT_STR,SERIAL_NO_STR,CONFIG_STR,INTERFACE_STR};
/* Structure for Circular buffer */
typedef struct CIRCULAR_BUFFER
{
  //unsigned char buffer[DRIVER_NO_BUFFER][1024]; /* Two diamention array : row - No of buffer; Collume - Buffer length */
  volatile unsigned int  buflength[DRIVER_NO_BUFFER];                    /* Store no of valid byte in buffer */
  volatile unsigned int  rx_count;                                       /* Store the current index(On Receiving side in BULK OUT ISR) in buffer */
  volatile unsigned int  tx_count;                                       /* Store current index in READ API */
  volatile unsigned int  g_buffercnt;                                    /* Global buffer count shared bewteen isr and red api,and isr increment it and read api descrement it after reading the data from buffer */
  volatile unsigned int  bufOffset;
}C_BUFFER;

/* Get bReqquest(1-byte) */
#define UBS20_BREQUEST(data)           ((data & 0x0000FF00)>>8)

/* decode wValue(2-bytes)   */
#define UBS20_WVALUE(data)             ((data & 0xFFFF0000)>>16)

/* decode wIndex(2-bytes)   */
#define USB20_WINDEX(data)             (data & 0x0000FFFF)

/* decode wLnegth(2-bytes)  */
#define USB20_WLENGTH(data)            ((data & 0xFFFF0000)>>16)

/* decode Descripto_Type(1-bytes) */
#define USB20_DESCRIPTOR_TYPE(data)    ((data & 0x0000FF00)>>8)

/* decode Descripto_Value(1-bytes) */
#define USB20_DESCRIPTOR_VALUE(data)   (data & 0x000000FF)

/* Set  the Maximum Payload size in Endpoint  CSR register(0xFFFFF800 means the 10:0 bit for Palyload size first make it zero)  */
#define SET_PAYLOAD_SIZE_EP_CSR(enp_csr_conf,payload)     ((enp_csr_conf & 0xFFFFF800)| payload)

/* Device state value */
enum state{NONE,RESET,ADDRESS,CONFIGURE,READY};
/* DataWidth */
enum DataWidth{EIGHT=8,SIXTEEN=16,THIRTY_TWO=32,DMA = 64,EIGHT_DMA=80};
enum BufferAvailable{AVAILABLE=0,NOT_AVAILABLE};
//enum {ZERO,ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE,TEN};
/*
 * The sls_avalon_usb20_dev structure is used to hold device specific data. This
 * includes the transmit and receive buffers.
 *
 * An instance of this structure is created in the auto-generated
 * alt_sys_init.c file for each USB20 listed in the systems PTF file. This is
 * done using the SLS_AVALON_USB20_INSTANCE macro given below.
 */


typedef struct dev
{
  alt_dev        dev;                                     /* Maind Device Objetct */
  volatile unsigned int   base;                           /* Device base address */
  volatile unsigned int (*ep_isr[3])(struct dev *);       /* Array of Function pointer, store the each endpoint isr function pointer */
  volatile unsigned int   ctrlep_CSR_config;              /* Store control ep configuration */
  //volatile unsigned char  ctr_cfg_buffer[256];            /* Store Device Configuration */
  //volatile unsigned int   ctr_cfg_len ;                   /* Store Device configuration length*/
  //volatile unsigned int   ctr_ep_buf0;                    /* Store Control endpoint buffer 0 address*/
 // volatile unsigned int   ctr_ep_buf1;                    /* Store Control endpoint buffer 1 address*/
  volatile unsigned int   ep1_csr;                        /* Stroe Endpoint 1 CSR register configuration */
  volatile unsigned int   ep2_csr;                        /* Store Endpoint 2 CSR register configuration*/
  //volatile unsigned int   device_address;                 /* Store device address assigned by the Host */
  volatile enum state     device_state;                   /* Store Device state */
  //Added on 5th Aud'06 by SLS//////////////////
  volatile unsigned int   rx_count_ref;
  volatile unsigned int   rx_count;
  volatile unsigned int   irq;
  // FS/HS Notification. HS = 1, FS = 0
  volatile int            speed;
  volatile unsigned char* PtrData;
    ////////////////////////////////////////
  /* variable for enumaration */
  volatile unsigned int data;
  volatile C_BUFFER m_objCBuffer;         /* Circular buffer object for buffer management in driver.*/
  volatile enum BufferAvailable m_bufferavailable; /*object maintain the state buffer available ot not in BULK IN operation */
  volatile int txBufferLen;  /* store the number of byte transfered to the usb2.0 core. Updated in bulk in isr and read in write api*/
  ALT_FLAG_GRP     (events)         /* Event flags used for
                                     * foreground/background in mult-threaded
                                     * mode */
  ALT_SEM          (read_lock)      /* Semaphore used to control access to the
                                     * read buffer in multi-threaded mode */
  ALT_SEM          (write_lock)     /* Semaphore used to control access to the
                                     * write buffer in multi-threaded mode */
}sls_avalon_usb20hr_dev;


/*
 * sls_avalon_usb20_init() is called by the auto-generated function
 * alt_sys_init() for each USB20 in the system. This is done using the
 * SLS_AVALON_USB20_INIT macro given below.
 *
 * This function is responsible for performing all the run time initilisation
 * for a device instance, i.e. registering the interrupt handler, and
 * regestering the device with the system.
 */
extern void sls_avalon_usb20hr_init(volatile void *);
extern void usb20hr_config (volatile int ,volatile int,const char *);
extern void usb20hr_connect(void);
/*
 * sls_avalon_usb20_read() is called by the read() system call for all valid
 * attempts to read from an instance of this device.
 */
extern int sls_avalon_usb20hr_read (alt_fd* fd, char* ptr, int len);

/*
 * sls_avalon_usb_write() is called by the write() system call for all valid
 * attempts to write to an instance of this device.
 */
extern int sls_avalon_usb20hr_write (alt_fd* fd, const char* ptr, int len);

/*
 * This is for DMA choice
 */

 extern void usb20hr_dma_usage(unsigned int usage,unsigned int dma_address);
/*
 * The macro SLS_AVALON_USB20_INSTANCE is used by the auto-generated file
 * alt_sys_init.c to create an instance of this device driver.
 */

#define SLS_AVALON_USB20HR_INSTANCE(name, device)   \
  static sls_avalon_usb20hr_dev device  =           \
    {                                               \
      {                                             \
        ALT_LLIST_ENTRY,                            \
        name##_NAME,                                \
        NULL, /* open  */                           \
        NULL, /* close */                           \
        sls_avalon_usb20hr_read, /* read  */        \
        sls_avalon_usb20hr_write, /* write */       \
        NULL, /* lseek */                           \
        NULL, /* fstat */                           \
        NULL, /* ioctl */                           \
      },                                            \
      name##_BASE,                                  \
      {0},\
      0,\
      0,\
      0,\
      NONE,\
      0,\
	  0,\
	  0,\
	  -1,\
      NULL,\
      0,\
      {{0},0,0,0,0},\
      AVAILABLE,\
      0,\
      }


/*
 * The macro SLS_AVALON_USB20_INIT is used by the auto-generated file
 * alt_sys_init.c to initialise an instance of the device driver.
 *
 * This macro performs a sanity check to ensure that the interrupt has been
 * connected for this device. If not, then an apropriate error message is
 * generated at build time.
 */

#define SLS_AVALON_USB20HR_INIT(name,device)                                 \
  if (name##_IRQ == ALT_IRQ_NOT_CONNECTED)                                 \
  {                                                                        \
    ALT_LINK_ERROR ("Error: Interrupt not connected for " #device ". "        \
                    );                                              \
  }                                                                        \
  else                                                                     \
  {                                                                        \
    sls_avalon_usb20hr_init (&device);          \
  }



#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* _SLS_AVALON_USB_20_H__ */

