// errno.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef __ERRNO_H
#define __ERRNO_H

#ifdef __cplusplus
extern "C" {
#endif

extern int errno;
#define EDOM 1
#define ERANGE 2
#define EILSEQ 3

#ifdef __cplusplus
}
#endif

#endif
