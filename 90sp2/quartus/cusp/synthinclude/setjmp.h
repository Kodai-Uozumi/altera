// setjmp.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _SETJMP_H_HEADER
#define _SETJMP_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef int[1] jmp_buf;
int setjmp(jmp_buf env);
void longjmp(jmp_buf env, int val);

#ifdef __cplusplus
}
#endif

#endif
