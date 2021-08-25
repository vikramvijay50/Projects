/* syscall.c
 *
 * Group Members Names and NetIDs:
 *   1. Vikram Vijayakumar vv236
 *   2. Wayne Huang wh309
 *
 * ILab Machine Tested on: ilab1.cs.rutgers.edu
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>                                                                                 
#include <sys/syscall.h>

double avg_time = 0;

int main(int argc, char *argv[]) {

    clock_t start, finish, total;
    int pid;
    
    start = clock();
    for(int i = 0; i < 3000; i++){
        pid = getpid();
    }
    finish = clock();

    total = (double)(finish - start);

    avg_time = (double)total/3000;

    // Remember to place your final calculated average time
    // per system call into the avg_time variable

    printf("Average time per system call is %f microseconds\n", avg_time);

    return 0;
}
