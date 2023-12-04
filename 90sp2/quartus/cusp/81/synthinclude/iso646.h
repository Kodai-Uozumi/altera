// iso646.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _ISO646_H_HEADER
#define _ISO646_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

#define and    &&
#define and_eq &=
#define bitand &
#define bitor  |
#define compl  ~
#define not    !
#define not_eq !=
#define or     |
#define or_eq  |=
#define xor    ^
#define xor_eq ^=

#ifdef __cplusplus
}
#endif

#endif
