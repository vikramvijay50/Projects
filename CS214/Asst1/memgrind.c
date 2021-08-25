#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h> 
#include "mymalloc.h"


//calls malloc of 1 byte and then frees it immediately 120 times.
void workloadA(){
  int i;  

  for(i = 0; i<120; i++){
    void* ptr = malloc(1);
    free(ptr);
  }
}


void workloadB(){
//calls malloc and stores the ptrs in an array.
  int i;
  void* arr[120]; 
  for(i = 0; i<120; i++){
    arr[i] = malloc(1);
  }
  //frees every ptr in arr
  for(i = 0; i<120; i++){
    free(arr[i]);
  }
}

//Randomly decides whether or not to free or malloc 1 byte if the there is something to be freed. Otherwise, just malloc 1 byte. This repeats 120 times.
void workloadC(){
  int i;  
  void* pointer_arr[120];
  int malloc_count = 0;
  int malloc_or_free;

  for(i = 0; i < 240; i++){
    if(malloc_count == 0){
      void* ptr = malloc(1);
      malloc_count++;
    }
    else{
      malloc_or_free = (rand() % 1);
      if(malloc_or_free == 1){
        pointer_arr[malloc_count] = malloc(1);
        malloc_count++;
      }
      else {
        malloc_count--;
        free(pointer_arr[malloc_count]);
      }
    }
  }
}

//Mallocs 1 byte 100 times and then randomly frees the bytes until the array of pointers is empty. Repeats 100 times. This is to test how random freeing effects runtime of malloc and free.
void workloadD(){
  int i;
  void* pointer_arr[100];
  int randOrder[100];  

  for(i = 0; i<100; i++){
    pointer_arr[i] = malloc(1);
  }

  for(i = 0; i < 100; i++){
    randOrder[i] = i;
  }

  for(i = 0; i < 100; i++){
    int temp = randOrder[i];
    int randIndex = rand() % 100;

    randOrder[i] = randOrder[randIndex];
    randOrder[randIndex] = temp;
  }
  
  for(i = 0; i < 100; i++){
    free(pointer_arr[randOrder[i]]);
  }
}

//First mallocs 1 byte 150 times. Afterwards, for 100 repetitions, we free the last 50 pointers in random order and malloc 1 byte 50 more times to test how having data already in memory effects runtime on randomly freeing and mallocing data. 
void workloadE(){
  int i;
  int j;
  void* pointer_arr[150];
  int randOrder[50];  

  for(i = 0; i < 150; i++){
    pointer_arr[i] = malloc(1);
  }
  
  for(i = 0; i < 100; i++){
    for(j = 0; j < 50; j++){
      randOrder[j] = j;
    }
    
    for(j = 0; j < 50; j++){
     int temp = randOrder[j];
     int randIndex = rand() % 50;

     randOrder[j] = randOrder[randIndex];
     randOrder[randIndex] = temp;
    }
    
    for(j = 0; j < 50; j++){
      free(pointer_arr[randOrder[j]+100]);
    }

    for(j = 0; j < 50; j++){
      pointer_arr[j+100] = malloc(1);
    }
  }

  for(i = 0; i < 150; i++){
    free(pointer_arr[i]);
  }
}

int main(void){
	
  double total_time = 0.0;

	srand((unsigned int)time(NULL));	

	int i;

	double sumA = 0.0,
		sumB = 0.0,
		sumC = 0.0,
		sumD = 0.0,
		sumE = 0.0;

//for 50 repetitions, time and run each workload.
	for(i = 0; i < 50; i++){
    clock_t begin = clock();
    workloadA();
    clock_t end = clock();
    sumA += (double)(end-begin)/CLOCKS_PER_SEC;

    begin = clock();
    workloadB();
    end = clock();
    sumB += (double)(end-begin)/CLOCKS_PER_SEC;

    begin = clock();
    workloadC();
    end = clock();
    sumC += (double)(end-begin)/CLOCKS_PER_SEC;

    begin = clock();
    workloadD();
    end = clock();
    sumD += (double)(end-begin)/CLOCKS_PER_SEC;

    begin = clock();
    workloadE();
    end = clock();
    sumE += (double)(end-begin)/CLOCKS_PER_SEC;
    
  
	}

  total_time = sumA + sumB + sumC + sumD + sumE;

  double meanA = sumA/50,
    meanB = sumB/50,
    meanC = sumC/50,
    meanD = sumD/50,
    meanE = sumE/50;
  
  printf("Workload A averaged %lf seconds.\n", (meanA));
	printf("Workload B averaged %lf seconds.\n", (meanB));
	printf("Workload C averaged %lf seconds.\n", (meanC));
	printf("Workload D averaged %lf seconds.\n", (meanD));
	printf("Workload E averaged %lf seconds.\n", (meanE));
  printf("The total time for all workloads was %lf seconds.\n", (total_time));
  return 0;
}
