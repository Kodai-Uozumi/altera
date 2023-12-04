// stdio.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _STDIO_H_HEADER
#define _STDIO_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

#include <stdarg.h>

typedef unsigned int size_t;
typedef struct __FILE { } FILE;
typedef int fpos_t;

#ifndef NULL
#ifdef __cplusplus
#define NULL __null
#else
#define NULL 0
#endif
#endif

#define _IOFBF 1
#define _IOLBF 2
#define _IONBF 4

#define BUFSIZ 1024
#define	EOF	(-1)
#define FOPEN_MAX 256
#define FILENAME_MAX 1024
#define L_tmpnam 256
#define SEEK_CUR 0
#define SEEK_END 1
#define SEEK_SET 2
#define TMP_MAX 256

extern FILE * stdin, * stdout, * stderr;

int remove(const char *filename);
int rename(const char *old, const char *newname);
FILE *tmpfile(void);
char *tmpnam(char *s);
int fclose(FILE *stream);
int fflush(FILE *stream);
FILE *fopen(const char * __restrict__ filename, const char * __restrict__ mode);
FILE *freopen(const char * __restrict__ filename, const char * __restrict__ mode, FILE * __restrict__ stream);
void setbuf(FILE * __restrict__ stream, char * __restrict__ buf);
int setvbuf(FILE * __restrict__ stream, char * __restrict__ buf, int mode, size_t size);
int fprintf(FILE * __restrict__ stream, const char * __restrict__ format, ...);
int fscanf(FILE * __restrict__ stream, const char * __restrict__ format, ...);
int printf(const char * __restrict__ format, ...) __attribute((cusp_synth(ignore)));
int scanf(const char * __restrict__ format, ...);
int snprintf(char * __restrict__ s, size_t n, const char * __restrict__ format, ...);
int sprintf(char * __restrict__ s, const char * __restrict__ format, ...);
int sscanf(const char * __restrict__ s, const char * __restrict__ format, ...);
int vfprintf(FILE * __restrict__ stream, const char * __restrict__ format, va_list arg);
int vfscanf(FILE * __restrict__ stream, const char * __restrict__ format, va_list arg);
int vprintf(const char * __restrict__ format, va_list arg);
int vscanf(const char * __restrict__ format, va_list arg);
int vsnprintf(char * __restrict__ s, size_t n, const char * __restrict__ format, va_list arg);
int vsprintf(char * __restrict__ s, const char * __restrict__ format, va_list arg);
int vsscanf(const char * __restrict__ s, const char * __restrict__ format, va_list arg);
int fgetc(FILE *stream);
char *fgets(char * __restrict__ s, int n, FILE * __restrict__ stream);
int fputc(int c, FILE *stream);
int fputs(const char * __restrict__ s, FILE * __restrict__ stream);
int getc(FILE *stream);
int getchar(void);
char *gets(char *s);
int putc(int c, FILE *stream);
int putchar(int c);
int puts(const char *s);
int ungetc(int c, FILE *stream);
size_t fread(void * __restrict__ ptr, size_t size, size_t nmemb, FILE * __restrict__ stream);
size_t fwrite(const void * __restrict__ ptr, size_t size, size_t nmemb, FILE * __restrict__ stream);
int fgetpos(FILE * __restrict__ stream, fpos_t * __restrict__ pos);
int fseek(FILE *stream, long int offset, int whence);
int fsetpos(FILE *stream, const fpos_t *pos);
long int ftell(FILE *stream);
void rewind(FILE *stream);
void clearerr(FILE *stream);
int feof(FILE *stream);
int ferror(FILE *stream);
void perror(const char *s);

#ifdef __cplusplus
}
#endif

#endif
