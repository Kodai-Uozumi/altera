// stdlib.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _STDLIB_H_HEADER
#define _STDLIB_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned int size_t;

#if !defined(__WCHAR_T_DEFINED) && !defined(_WCHAR_T)
#define __WCHAR_T_DEFINED
typedef short wchar_t;
#endif

struct div_t 
{
	int quot;
	int rem;
};

struct ldiv_t
{
	long int quot;
	long int rem;
};

struct lldiv_t
{
	long long int quot;
	long long int rem;
};

#ifndef NULL
#ifdef __cplusplus
#define NULL __null
#else
#define NULL 0
#endif
#endif

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0
#define RAND_MAX 2147483647
#define MB_CUR_MAX 1

double atof(const char *nptr);
int atoi(const char *nptr);
long int atol(const char *nptr);
long long int atoll(const char *nptr);
double strtod(const char * __restrict__ nptr,
char ** __restrict__ endptr);
float strtof(const char * __restrict__ nptr,
char ** __restrict__ endptr);
long double strtold(const char * __restrict__ nptr,
char ** __restrict__ endptr);
long int strtol(const char * __restrict__ nptr,
char ** __restrict__ endptr, int base);
long long int strtoll(const char * __restrict__ nptr,
char ** __restrict__ endptr, int base);
unsigned long int strtoul(
const char * __restrict__ nptr,
char ** __restrict__ endptr, int base);
unsigned long long int strtoull(const char * __restrict__ nptr, char ** __restrict__ endptr, int base);
int rand(void);
void srand(unsigned int seed);
void *calloc(size_t nmemb, size_t size);
void free(void *ptr);
void *malloc(size_t size);
void *realloc(void *ptr, size_t size);
void abort(void) __attribute__((noreturn));
int atexit(void (*func)(void));
void exit(int status) __attribute__((noreturn));
void _Exit(int status);
char *getenv(const char *name);
int system(const char *string);
void *bsearch(const void *key, const void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *));
void qsort(void *base, size_t nmemb, size_t size, int (*compar)(const void *, const void *));
int abs(int j);
long int labs(long int j);
long long int llabs(long long int j);
div_t div(int numer, int denom);
ldiv_t ldiv(long int numer, long int denom);
lldiv_t lldiv(long long int numer,
long long int denom);
int mblen(const char *s, size_t n);
int mbtowc(wchar_t * __restrict__ pwc,
const char * __restrict__ s, size_t n);
int wctomb(char *s, wchar_t wchar);
size_t mbstowcs(wchar_t * __restrict__ pwcs,
const char * __restrict__ s, size_t n);
size_t wcstombs(char * __restrict__ s,
const wchar_t * __restrict__ pwcs, size_t n);

#ifdef __cplusplus
}
#endif

#endif
