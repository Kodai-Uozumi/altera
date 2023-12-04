// stdarg.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef __STDARG_H_HEADER
#define __STDARG_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef void * * va_list;

void * __va_arg(va_list ap);
#define va_arg(ap, type) (*((type *)__va_arg(ap)))

void va_copy(va_list dest, va_list src);

void va_end(va_list ap);

void __va_start(va_list ap, void * parmN);
#define va_start(ap, parmN) __va_start(ap, &parmN);

#ifdef __cplusplus
}
#endif

#endif
