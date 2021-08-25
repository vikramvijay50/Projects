#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
/* 
 * Group Members Names and NetIDs:
 *   1. Vikram Vijayakumar vv236
 *   2. Wayne Huang wh309
 *
 * ILab Machine Tested on: ilab1.cs.rutgers.edu
 */

/* Part 1 - Step 2 to 4: Do your tricks here
 * Your goal must be to change the stack frame of caller (main function)
 * such that you get to the line after "r2 = *( (int *) 0 )"
 */
void segment_fault_handler(int signum) {

    printf("I am slain!\n");

    int* ptr = &signum;

    ptr+=51;

    *ptr += 3;

}

int main(int argc, char *argv[]) {

    int r2 = 0;

    /* Part 1 - Step 1: Registering signal handler */
    signal(SIGSEGV, segment_fault_handler);

    r2 = *( (int *) 0 ); // This will generate segmentation fault

    printf("I live again!\n");

    return 0;
}
