// pthread
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.
#ifndef _PTHREAD_H_HEADER
#define _PTHREAD_H_HEADER

typedef int pthread_mutex_t;
typedef int pthread_mutexattr_t;
int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr);
int pthread_mutex_destroy(pthread_mutex_t *mutex);
int pthread_mutex_lock(pthread_mutex_t *mutex);
int pthread_mutex_unlock(pthread_mutex_t *mutex);

#endif
