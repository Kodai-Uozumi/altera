/*++

Copyright (c) 2005  System Level Solution Pvt. Ltd.

Module Name:

    SLSUSBInterface.h

Abstract:

    Native USB device driver for SLSUSB Library defination

Environment:

   user mode

Revision History:



--*/


#ifndef SLSUSBDEVINTERFACE_H
#define SLSUSBDEVINTERFACE_H

#include "windows.h"

// The following ifdef block is the standard way of creating macros
// which make exporting from a DLL simpler.  All files within this DLL
// are compiled with the SLSUSB_EXPORTS symbol defined on the command line.
// This symbol should not be defined on any project that uses this DLL.
// This way any other project whose source files include this file see
// SLSUSB_API functions as being imported from a DLL, whereas this DLL
// sees symbols defined with this macro as being exported.

#ifdef SLSUSB_EXPORTS
#define SLSUSB_API __declspec(dllexport)
#else
#define SLSUSB_API __declspec(dllimport)
#endif


typedef PVOID	SLS_HANDLE;
typedef ULONG	SLS_STATUS;

struct SLS_OVERLAPPED:public OVERLAPPED
{

   BOOL bFlagReadWrite;

};
typedef struct SLS_OVERLAPPED SLS_OVERLAPPED;
typedef struct SLS_OVERLAPPED *PSLS_OVERLAPPED;
//
// Device status
//
enum {
    SLS_OK,
    SLS_INVALID_HANDLE,
    SLS_DEVICE_NOT_FOUND,
    SLS_DEVICE_NOT_OPENED,
    SLS_IO_ERROR,
    SLS_INSUFFICIENT_RESOURCES,
    SLS_INVALID_PARAMETER,


    SLS_DEVICE_NOT_OPENED_FOR_WRITE,
    SLS_FAILED_TO_WRITE_DEVICE,
    SLS_INVALID_ARGS,
	SLS_NOT_SUPPORTED,
	SLS_OTHER_ERROR
};


#define SLS_SUCCESS(status) ((status) == SLS_OK)

//
// SLS_OpenEx Flags
//

#define SLS_OPEN_BY_SERIAL_NUMBER    1
#define SLS_OPEN_BY_DESCRIPTION      2

//
// SLS_ListDevices Flags (used in conjunction with SLS_OpenEx Flags
//

#define SLS_LIST_NUMBER_ONLY			0x80000000
#define SLS_LIST_BY_INDEX		    	0x40000000
#define SLS_LIST_ALL					0x20000000

#define SLS_LIST_MASK (SLS_LIST_NUMBER_ONLY|SLS_LIST_BY_INDEX|SLS_LIST_ALL)



#ifdef __cplusplus
extern "C" {
#endif


SLSUSB_API
SLS_STATUS WINAPI SLS_ListDevices(
	PVOID pArg1,
	PVOID pArg2,
	DWORD dwFlags
	);



SLSUSB_API
SLS_STATUS WINAPI SLS_ResetDevice(
    SLS_HANDLE SLSHandle
	);



SLSUSB_API
SLS_HANDLE WINAPI SLS_W32_CreateFile(
	LPCSTR					lpszName,
	DWORD					dwAccess,
	DWORD					dwShareMode,
	LPSECURITY_ATTRIBUTES	lpSecurityAttributes,
	DWORD					dwCreate,
	DWORD					dwAttrsAndFlags,
	HANDLE					hTemplate
	);

SLSUSB_API
BOOL WINAPI SLS_W32_CloseHandle(
    SLS_HANDLE SLSHandle
	);

SLSUSB_API
BOOL WINAPI SLS_W32_ReadFile(
    SLS_HANDLE SLSHandle,
    LPVOID lpBuffer,
    DWORD nBufferSize,
    LPDWORD lpBytesReturned,
	PSLS_OVERLAPPED lpOverlapped
    );

SLSUSB_API
BOOL WINAPI SLS_W32_WriteFile(
    SLS_HANDLE SLSHandle,
    LPVOID lpBuffer,
    DWORD nBufferSize,
    LPDWORD lpBytesWritten,
	PSLS_OVERLAPPED lpOverlapped
    );

SLSUSB_API
BOOL WINAPI SLS_W32_GetOverlappedResult(
    SLS_HANDLE SLSHandle,
	PSLS_OVERLAPPED lpOverlapped,
    LPDWORD lpdwBytesTransferred,
	BOOL bWait
    );

SLSUSB_API
BOOL WINAPI SLS_W32_CancelIo(
    SLS_HANDLE SLSHandle
    );



#ifdef __cplusplus
}
#endif


#endif  /* SLSD2XX_H */

