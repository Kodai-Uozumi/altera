// stddef.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _STDDEF_H_HEADER
#define _STDDEF_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef int ptrdiff_t;
typedef unsigned int size_t;

#if !defined(__WCHAR_T_DEFINED) && !defined(_WCHAR_T)
#define __WCHAR_T_DEFINED
typedef short wchar_t;
#endif

#ifndef NULL
#ifdef __cplusplus
#define NULL __null
#else
#define NULL 0
#endif
#endif

#define offsetof(type, member) ((size_t)&(((type *)0)->member)

#ifdef __cplusplus
}
#endif

#endif
