// assert.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _ASSERT_H_HEADER
#define _ASSERT_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

/*
 * The CusP synthesiser intelligently removes assert directives so there
 * is no performance loss to leaving them in the code (even if NDEBUG is
 * set).
 */
void __assert(bool condition, bool ndebug, const char * file, int line) { }

#undef assert
#ifdef NDEBUG
#define assert(EXP) __assert(EXP, true, __FILE__, __LINE__)
#else
#define assert(EXP) __assert(EXP, false, __FILE__, __LINE__)
#endif

#ifdef __cplusplus
}
#endif

#endif
