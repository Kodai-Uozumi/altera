// signal.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _SIGNAL_H_HEADER
#define _SIGNAL_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef int sig_atomic_t;

void __sig_dfl(int);
#define SIG_DFL &__sig_dfl
void __sig_err(int);
#define SIG_ERR &__sig_err
void __sig_ign(int);
#define SIG_IGN &__sig_ign

#define SIGABRT 0
#define SIGFPE  1
#define SIGILL  2
#define SIGINT  3
#define SIGSEGV 4
#define SIGTERM 5

void (*signal(int sig, void (*func)(int)))(int);
int raise(int sig);

#ifdef __cplusplus
}
#endif

#endif
