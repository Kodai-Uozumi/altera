// limits.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _LIMITS_H_HEADER
#define _LIMITS_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

/* Number of bits in a `char'.  */
#undef  CHAR_BIT
#define CHAR_BIT 8

#undef  SCHAR_MIN
#define SCHAR_MIN (-128)
#undef  SCHAR_MAX
#define SCHAR_MAX 127
#undef  UCHAR_MAX
#define UCHAR_MAX 255
#undef  CHAR_MIN
#define CHAR_MIN -128
#undef  CHAR_MAX
#define CHAR_MAX 127

#undef  MB_LEN_MAX
#define MB_LEN_MAX 1

#undef  SHRT_MIN
#define SHRT_MIN (-32768)
#undef  SHRT_MAX
#define SHRT_MAX 32767
#undef  USHRT_MAX
#define USHRT_MAX 65535

#undef  INT_MIN
#define INT_MIN (-2147483648)
#undef  INT_MAX
#define INT_MAX  2147483647
#undef  UINT_MAX
#define UINT_MAX (INT_MAX * 2U + 1)

#undef  LONG_MIN
#define LONG_MIN  INT_MIN
#undef  LONG_MAX
#define LONG_MAX  INT_MAX
#undef  ULONG_MAX
#define ULONG_MAX UINT_MAX

#undef  LLONG_MIN
#define LLONG_MIN  (-9223372036854775807LL)
#undef  LLONG_MAX
#define LLONG_MAX  9223372036854775807LL
#undef  ULLONG_MAX
#define ULLONG_MAX (LLONG_MAX * 2ULL + 1)

#ifdef __cplusplus
}
#endif

#endif
