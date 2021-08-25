// File:	rpthread_t.h

// List all group member's name: Vikram Vijayakumar, Wayne Huang
// username of iLab: vv236, wh309
// iLab Server: ilab4.cs.rutgers.edu

#ifndef RTHREAD_T_H
#define RTHREAD_T_H

#define _GNU_SOURCE

/* To use Linux pthread Library in Benchmark, you have to comment the USE_RTHREAD macro */
#define USE_RTHREAD 1

#ifndef TIMESLICE
/* defined timeslice to 5 ms, feel free to change this while testing your code
 * it can be done directly in the Makefile*/
#define TIMESLICE 5
#endif

#define READY 0
#define SCHEDULED 1
#define BLOCKED 2
#define EXITED 3
#define JOINED 4

#define UNLOCKED 0
#define LOCKED 1

#define LEVELS 4

/* include lib header files that you need here: */
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>
#include <ucontext.h>
#include <signal.h>
#include <string.h>

#define STACK_SIZE SIGSTKSZ

typedef uint rpthread_t;

typedef struct threadControlBlock {
	/* add important states in a thread control block */
	// thread Id
	// thread status
	// thread context
	// thread stack
	// thread priority
	// And more ...

	rpthread_t thread_id;
	int thread_status;
	ucontext_t *cxt;
	void* value_ptr;

} tcb; 

/* mutex struct definition */
typedef struct rpthread_mutex_t {
	volatile int locked;
	int init;
	struct waitQueue *waitQueue;
} rpthread_mutex_t;

/* define your data structures here: */
// Feel free to add your own auxiliary data structures (linked list or queue etc...)

typedef struct threadNode{
	int level;
	tcb *thread;
	struct threadNode *next;
} threadNode;

typedef struct runQueue{
	int size;
	int level;
	threadNode *front;
	threadNode *end;
}runQueue;

typedef struct waitQueue{
	threadNode *front;
	threadNode *end;
}waitQueue;

typedef struct runQueueLevels{
	struct runQueue *queueLevels[LEVELS];
} runQueueLevels;

/* Function Declarations: */

/* create a new thread */
int rpthread_create(rpthread_t * thread, pthread_attr_t * attr, void
    *(*function)(void*), void * arg);

/* give CPU pocession to other user level threads voluntarily */
int rpthread_yield();

/* terminate a thread */
void rpthread_exit(void *value_ptr);

/* wait for thread termination */
int rpthread_join(rpthread_t thread, void **value_ptr);

/* initial the mutex lock */
int rpthread_mutex_init(rpthread_mutex_t *mutex, const pthread_mutexattr_t
    *mutexattr);

/* aquire the mutex lock */
int rpthread_mutex_lock(rpthread_mutex_t *mutex);

/* release the mutex lock */
int rpthread_mutex_unlock(rpthread_mutex_t *mutex);

/* destroy the mutex */
int rpthread_mutex_destroy(rpthread_mutex_t *mutex);

#ifdef USE_RTHREAD
#define pthread_t rpthread_t
#define pthread_mutex_t rpthread_mutex_t
#define pthread_create rpthread_create
#define pthread_exit rpthread_exit
#define pthread_join rpthread_join
#define pthread_mutex_init rpthread_mutex_init
#define pthread_mutex_lock rpthread_mutex_lock
#define pthread_mutex_unlock rpthread_mutex_unlock
#define pthread_mutex_destroy rpthread_mutex_destroy
#endif

#endif
