// stdint.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _STDINT_H_HEADER
#define _STDINT_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef signed char        int8_t;
typedef short              int16_t;
typedef int                int32_t;
typedef long long          int64_t;
typedef unsigned char      uint8_t;
typedef unsigned short     uint16_t;
typedef unsigned int       uint32_t;
typedef unsigned long long uint64_t;

typedef signed char        int_least8_t;
typedef short              int_least16_t;
typedef int                int_least32_t;
typedef long long          int_least64_t;
typedef unsigned char      uint_least8_t;
typedef unsigned short     uint_least16_t;
typedef unsigned int       uint_least32_t;
typedef unsigned long long uint_least64_t;

typedef signed char        int_fast8_t;
typedef short              int_fast16_t;
typedef int                int_fast32_t;
typedef long long          int_fast64_t;
typedef unsigned char      uint_fast8_t;
typedef unsigned short     uint_fast16_t;
typedef unsigned int       uint_fast32_t;
typedef unsigned long long uint_fast64_t;

typedef int intptr_t;
typedef unsigned int uintptr_t;

typedef long long intmax_t;
typedef unsigned long long uintmax_t;

//INTN_MIN
//INTN_MAX
//UINTN_MAX
//INT_LEASTN_MIN
//INT_LEASTN_MAX
//UINT_LEASTN_MAX
//INT_FASTN_MIN
//INT_FASTN_MAX
//UINT_FASTN_MAX
//INTPTR_MIN
//INTPTR_MAX
//UINTPTR_MAX
//INTMAX_MIN
//INTMAX_MAX
//UINTMAX_MAX
//PTRDIFF_MIN
//PTRDIFF_MAX
//SIG_ATOMIC_MIN
//SIG_ATOMIC_MAX
//SIZE_MAX
//WCHAR_MIN
//WCHAR_MAX
//WINT_MIN
//WINT_MAX
//INTN_C(value)
//UINTN_C(value)
//INTMAX_C(value)
//UINTMAX_C(value)

#ifdef __cplusplus
}
#endif

#endif
