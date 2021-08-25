// File:	rpthread.c

// List all group member's name: Vikram Vijayakumar, Wayne Huang
// username of iLab: vv236, wh309
// iLab Server: ilab4.cs.rutgers.edu

#include "rpthread.h"

// INITAILIZE ALL YOUR VARIABLES HERE

#define RR 0
#define MLFQ 1

static void sched_rr();
static void sched_mlfq();
void makeScheduler();
void enqueueRun(threadNode *node);
void dequeueRun();
void signal_handler(int signum);
void initializeStructs();
void makeTimer();
void makeExitContext();
void enqueueWait(waitQueue *queue, threadNode *node);
void dequeueWait(waitQueue *queue);

int sched;

int isFirstThread = 0;
int addedMain = 0;
int threadCount = 1;
int freeNode = 0;

struct sigaction sa;
struct itimerval timer;
long int scheduleCount = 0;
//int firstTimeMake = 0;

ucontext_t *scxt;
ucontext_t *maincxt;
ucontext_t *ecxt;

int mutexCount = 0;

runQueue *run;

threadNode *currNode = NULL;
threadNode *exitList = NULL;

/* create a new thread */
int rpthread_create(rpthread_t * thread, pthread_attr_t * attr, 
                      void *(*function)(void*), void * arg) {
       // create Thread Control Block
       // create and initialize the context of this thread
       // allocate space of stack for this thread to run
       // after everything is all set, push this thread int

	if(isFirstThread == 0){
		isFirstThread = 1;

		//printf("making first thread!\n");

		scxt = (ucontext_t*)malloc(sizeof(ucontext_t));
		maincxt = (ucontext_t*)malloc(sizeof(ucontext_t));
		ecxt = (ucontext_t*)malloc(sizeof(ucontext_t));
		ucontext_t *currcxt = (ucontext_t*)malloc(sizeof(ucontext_t));

		if(getcontext(maincxt) == -1){
			//printf("getcontext: could not get context");
			exit(1);
		}

		//if(addedMain == 0){
		if(getcontext(currcxt) == -1){
			//printf("getcontext: could not get context");
			exit(1);
		}

		currcxt->uc_link = scxt;
		currcxt->uc_stack.ss_sp = malloc(STACK_SIZE);
		currcxt->uc_stack.ss_size = STACK_SIZE;
		currcxt->uc_stack.ss_flags = 0;

		makecontext(currcxt, (void*) function, 1, arg);

		tcb *myThread = (tcb*)malloc(sizeof(tcb));
		myThread->thread_id = threadCount;
		myThread->value_ptr = NULL;
		myThread->thread_status = READY;
		myThread->cxt = currcxt;

		threadNode *node = (threadNode*)malloc(sizeof(threadNode));
		node->thread = myThread;
		node->level = 0;
		node->next = NULL;

		initializeStructs();

		currNode = node;

		//printf("queued first thread!\n");

		enqueueRun(node);

		addedMain = 1;

		makeScheduler();

		makeExitContext();

		makeTimer();

		//}
		
		return 0;

	} else{
		//printf("making another thread!\n");
		ucontext_t *currcxt = (ucontext_t*)malloc(sizeof(ucontext_t));

		if(getcontext(currcxt) == -1){
			//printf("getcontext: could not get context");
			exit(1);
		}

		currcxt->uc_link = scxt;
		currcxt->uc_stack.ss_sp = malloc(STACK_SIZE);
		currcxt->uc_stack.ss_size = STACK_SIZE;
		currcxt->uc_stack.ss_flags = 0;

		threadCount++;

		makecontext(currcxt, (void*) function, 1, arg);

		tcb *myThread = (tcb*)malloc(sizeof(tcb));
		myThread->thread_id = threadCount;
		myThread->value_ptr = NULL;
		myThread->thread_status = READY;
		myThread->cxt = currcxt;

		threadNode *node = (threadNode*)malloc(sizeof(threadNode));
		node->thread = myThread;
		node->level = 0;
		node->next = NULL;

		currNode = node;

		//printf("queued another thread!\n");

		enqueueRun(node);

		makeExitContext();

		//makeTimer();

		//swapcontext(currNode->thread->cxt, scxt);
	}

    return 0;
};

/* give CPU possession to other user-level threads voluntarily */
int rpthread_yield() {
	
	// change thread state from Running to Ready
	// save context of this thread to its thread control block
	// wwitch from thread context to scheduler context

	swapcontext(currNode->thread->cxt, scxt);
	return 0;
};

/* terminate a thread */
void rpthread_exit(void *value_ptr) {
	// Deallocated any dynamic memory created when starting this thread
	//printf("in pthread_exit in Thread %d\n", currNode->thread->thread_id);
	threadNode *temp = currNode;

	run->front->thread->value_ptr = value_ptr;
	run->front->thread->thread_status = EXITED;

	if(exitList == NULL){
		exitList = currNode;
	} else{
		temp->next = exitList;
		exitList = temp;
	}

	swapcontext(currNode->thread->cxt, scxt);

};


/* Wait for thread termination */
int rpthread_join(rpthread_t thread, void **value_ptr) {
	
	// wait for a specific thread to terminate
	// de-allocate any dynamic memory created by the joining thread
  
	threadNode *temp = exitList;

	while(temp != NULL){
		if(temp->thread->thread_id == thread){
			if(value_ptr != NULL){
				*value_ptr = temp->thread->value_ptr;
			}
			return 0;
		} else{
			temp = temp->next;
		}
	}

	swapcontext(currNode->thread->cxt, scxt);
	
	if(value_ptr != NULL){
		*value_ptr = currNode->thread->value_ptr;
	}
	
	return 0;
};

/* initialize the mutex lock */
int rpthread_mutex_init(rpthread_mutex_t *mutex, 
                          const pthread_mutexattr_t *mutexattr) {
	//initialize data structures for this mutex
	if(mutex->init == 1){
			return -1;
	}

	mutex->locked = UNLOCKED;
	mutex->init = 1;
	mutex->waitQueue = (waitQueue*)malloc(sizeof(waitQueue));
	mutex->waitQueue->front = NULL;
	mutex->waitQueue->end = NULL;

	return 0;
};

/* aquire the mutex lock */
int rpthread_mutex_lock(rpthread_mutex_t *mutex) {
        // use the built-in test-and-set atomic function to test the mutex
        // if the mutex is acquired successfully, enter the critical section
        // if acquiring mutex fails, push current thread into block list and //  
        // context switch to the scheduler thread
		if(mutex->init != 1){
			return -1;
		}

        while(__sync_lock_test_and_set(&mutex->locked, 1) == LOCKED){
			if(mutex->locked == LOCKED){
				enqueueWait(mutex->waitQueue, run->front);
				dequeueRun();
				
				swapcontext(currNode->thread->cxt, scxt);
			}
		}
        return 0;
};

/* release the mutex lock */
int rpthread_mutex_unlock(rpthread_mutex_t *mutex) {
	// Release mutex and make it available again. 
	// Put threads in block list to run queue 
	// so that they could compete for mutex later.
	if(mutex->init != 1){
			return -1;
	}

	__sync_lock_release(&mutex->locked);

	if(mutex->locked == UNLOCKED){
		while(mutex->waitQueue->front != NULL){
			enqueueRun(mutex->waitQueue->front);
			dequeueWait(mutex->waitQueue);
		}
	}
	return 0;
};


/* destroy the mutex */
int rpthread_mutex_destroy(rpthread_mutex_t *mutex) {
	// Deallocate dynamic memory created in rpthread_mutex_init
	free(mutex->waitQueue);
	mutex->waitQueue = NULL;
	mutex->init = 0;
	mutex->locked = UNLOCKED;
	return 0;
};

/* scheduler */
static void schedule() {
	// Every time when timer interrup happens, your thread library 
	// should be contexted switched from thread context to this 
	// schedule function

	// Invoke different actual scheduling algorithms
	// according to policy (RR or MLFQ)

	// if (sched == RR)
	//		sched_rr();
	// else if (sched == MLFQ)
	// 		sched_mlfq();

	//printf("made it to scheduler in thread %d\n", currNode->thread->thread_id);

	if (sched == RR)
		sched_rr();
	else if (sched == MLFQ)
		sched_mlfq();

// schedule policy
#ifndef MLFQ
	// Choose RR
     sched = RR;
#else 
	// Choose MLFQ
    sched = MLFQ;
#endif

}

/* Round Robin (RR) scheduling algorithm */
static void sched_rr() {
	// Your own implementation of RR
	// (feel free to modify arguments and return types)
	//printf("in RR sched\n");

	//timer.it_value.tv_sec = 0;
	//timer.it_value.tv_usec = TIMESLICE*1000;
	//timer.it_interval.tv_sec = 0;
	//timer.it_interval.tv_usec = 0;

	//setitimer(ITIMER_PROF, &timer, NULL);

	threadNode *top = NULL;

	//printf("front's state is: %d\n", run->front->thread->thread_status);

	//printf("gonna swap in Thread %d\n", currNode->thread->thread_id);
	while(run->front != NULL){
		top = run->front;
		if(top->thread->thread_status == EXITED){
			dequeueRun();
			continue;
		} else if(top->thread->thread_status == BLOCKED){
			continue;
		} else{
			setcontext(top->thread->cxt);
		}
	}
}

/* Preemptive MLFQ scheduling algorithm */
static void sched_mlfq() {
	// Your own implementation of MLFQ
	// (feel free to modify arguments and return types)

	threadNode *top = NULL;
	while(run->front != NULL){
		top = run->front;
		if(top->thread->thread_status == EXITED){
			dequeueRun();
			continue;
		} else if(top->thread->thread_status == BLOCKED){
			continue;
		} else{
			swapcontext(scxt, top->thread->cxt);
			if(top->thread->thread_status != EXITED){
				top->level++;
				dequeueRun();
			}
		}
	}
}

// Feel free to add any other functions you need

void makeScheduler(){

	//printf("in make scheduler\n");

	if(getcontext(scxt) == -1){
			printf("getcontext: could not get context");
			exit(1);
	}

	scxt->uc_link = NULL;
	scxt->uc_stack.ss_sp = malloc(STACK_SIZE);
	scxt->uc_stack.ss_size = STACK_SIZE;
	scxt->uc_stack.ss_flags = 0;

	makecontext(scxt, (void*)schedule, 0);

	//swapcontext(currNode->thread->cxt, scxt);

}

void makeExitContext(){

	//printf("in exit maker\n");

	if(getcontext(ecxt) == -1){
			//printf("getcontext: could not get context");
			exit(1);
	}

	ecxt->uc_link = NULL;
	ecxt->uc_stack.ss_sp = malloc(STACK_SIZE);
	ecxt->uc_stack.ss_size = STACK_SIZE;
	ecxt->uc_stack.ss_flags = 0;

	makecontext(ecxt, (void*)rpthread_exit, 0);

	//swapcontext(currNode->thread->cxt, scxt);

}

void makeTimer(){
	//printf("made timer\n");
	memset(&sa, 0, sizeof(sa));
	sa.sa_handler = &signal_handler;
	sigaction(SIGPROF, &sa, NULL);

	timer.it_value.tv_sec = 0;
	timer.it_value.tv_usec = TIMESLICE*1000;
	timer.it_interval.tv_sec = 0;
	timer.it_interval.tv_usec = 0;

	setitimer(ITIMER_PROF, &timer, NULL);
}

void initializeStructs(){
	//printf("in initialize structs\n");
	run = malloc(sizeof(runQueue));
	run->size = 0;
	run->front = NULL;
	run->end = NULL;
}

void enqueueRun(threadNode *node){
	//printf("in enqueue\n");
	if(run->end == NULL){
		run->front = run->end = node;
		return;
	}

	run->size++;
	run->end->next = node;
	run->end = node;
}

void dequeueRun(){
	//printf("in dequeue\n");
	//printf("front used to be Thread %d\n", run->front->thread->thread_id);
	if(run->front == NULL){
		//printf("empty queue\n");
		return;
	}

	run->size--;

	threadNode *temp = run->front;

	run->front = run->front->next;

	//printf("front is now Thread %d\n", run->front->thread->thread_id);

	if(run->front == NULL){
		printf("queue is now empty\n");
		run->end = NULL;
	}

	free(temp);
}

void enqueueWait(waitQueue *queue, threadNode *node){
	//printf("in enqueue\n");
	if(queue->end == NULL){
		queue->front = queue->end = node;
		return;
	}

	queue->end->next = node;
	queue->end = node;
}

void dequeueWait(waitQueue *queue){
	if(queue->front == NULL){
		return;
	}

	threadNode *temp = queue->front;

	queue->front = queue->front->next;

	if(queue->front == NULL){
		//printf("queue is now empty\n");
		queue->end = NULL;
	}

	free(temp);
}

void signal_handler(int signum){
	//printf("in sig handler in Thread %d\n", currNode->thread->thread_id);
	swapcontext(currNode->thread->cxt, scxt);
}

