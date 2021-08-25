#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mymalloc.h"

static char myblock[4096] = {0, 40, 96};
static int MAX_SIZE = 4096;
static int META_DATA_SIZE = 3;

//Splits a metadata index larger than 100 into 2 seperate numbers occupying two seperate elements of metadata
void splitNum(int index, int num){
  myblock[index+1] = num%100;
  myblock[index] = num/100;
}

//Merges two metadata numbers from two seperate elements into one number
int mergeNum(int index){
  return myblock[index]*100+myblock[index+1];
}

//Reserves space of size length in myblock and returns a pointer to the beginning of that space for usage
void *mymalloc(size_t length, char *file, int line){
  int index = 0;
  int sizeOfFreeBlock;
  while(index < MAX_SIZE){
    if(myblock[index] != 0){
      index = mergeNum(index+1);
    } else{
      if(mergeNum(index+1) < MAX_SIZE && myblock[mergeNum(index+1)] == 0){
        splitNum(index+1, mergeNum(mergeNum(index+1)+1));
      } else{
        sizeOfFreeBlock =  mergeNum(index+1)-index-META_DATA_SIZE;
        if(sizeOfFreeBlock >= (int)length){
          break;
        } else{
          index = mergeNum(index+1);
        }
      }
    }
  }
  //Handles error if length asked is larger than myblock's memory size
  if(index >= MAX_SIZE){
      printf("Memory Overflow Error: %s line: %d\n", file, line);
      return NULL;
  }

  myblock[index] = 1;
  int oldnext = mergeNum(index+1);
  splitNum(index+1, index+META_DATA_SIZE+(int)length);

  if(sizeOfFreeBlock != (int)length){
    myblock[index+META_DATA_SIZE+(int)length] = 0;
    splitNum(index+META_DATA_SIZE+1+(int)length, oldnext);
  }

  return &myblock[index+META_DATA_SIZE];
}

//Frees data in myblock for other usage
void myfree(void *ptr, char *file, int line){
  int index = (char*)ptr-myblock-META_DATA_SIZE;
  //Handles error for index bounds and unallocated pointers trying to be freed
  if(index >= 0 && index < MAX_SIZE){
    //Handles error of redundantly freeing pointers
    if(myblock[index] == 0){
      printf("Redundant free Error: %s line: %d\n", file, line);
    }
    myblock[index] = 0;
    int nextIndex = mergeNum(index+1);
    if(myblock[index] == 0){
      if(nextIndex >= MAX_SIZE){
        return;
      }
      splitNum(index+1, mergeNum(nextIndex+1));
    }
  } else{
    printf("Unallocated Pointer Error: %s line: %d\n", file, line);
  }
}
