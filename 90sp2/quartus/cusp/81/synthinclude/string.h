// string.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _STRING_H_HEADER
#define _STRING_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef unsigned int size_t;

#ifndef NULL
#ifdef __cplusplus
#define NULL __null
#else
#define NULL 0
#endif
#endif

void *memcpy(void * __restrict__ s1, const void * __restrict__ s2, size_t n);
void *memmove(void *s1, const void *s2, size_t n);
char *strcpy(char * __restrict__ s1, const char * __restrict__ s2);
char *strncpy(char * __restrict__ s1, const char * __restrict__ s2, size_t n);
char *strcat(char * __restrict__ s1, const char * __restrict__ s2);
char *strncat(char * __restrict__ s1, const char * __restrict__ s2, size_t n);
int memcmp(const void *s1, const void *s2, size_t n);
int strcmp(const char *s1, const char *s2);
int strcoll(const char *s1, const char *s2);
int strncmp(const char *s1, const char *s2, size_t n);
size_t strxfrm(char * __restrict__ s1, const char * __restrict__ s2, size_t n);
void *memchr(const void *s, int c, size_t n);
char *strchr(const char *s, int c);
size_t strcspn(const char *s1, const char *s2);
char *strpbrk(const char *s1, const char *s2);
char *strrchr(const char *s, int c);
size_t strspn(const char *s1, const char *s2);
char *strstr(const char *s1, const char *s2);
char *strtok(char * __restrict__ s1, const char * __restrict__ s2);
void *memset(void *s, int c, size_t n);
char *strerror(int errnum);
size_t strlen(const char *s);

#ifdef __cplusplus
}
#endif

#endif
