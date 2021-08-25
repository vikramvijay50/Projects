#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <sys/stat.h>
#include <dirent.h>
#include <libgen.h>
#include <unistd.h> 
#include <fcntl.h>
#include <errno.h>
#include <pthread.h>
#include <math.h>

#define RED "\x1b[31m"
#define YELLOW "\x1b[33m"
#define GREEN "\x1b[32m"
#define CYAN "\x1b[36m"
#define BLUE "\x1b[34m"
#define REST "\x1b[0m"

//Linked List struct
struct Node{
  char* word;
  float prob;
  struct Node *next;
  struct Node *nextList;
};

//Global variables
struct Node *head = NULL;
struct Node *f_ptr = NULL;
int fileCount = 0;
char *str[100];
struct Node *direct_pointer;

//To test linked list for the files
void printfiles(){
  struct Node *list = head;
  while(head->nextList != NULL){
    printf("%s %lf", head->word, head->prob);
    head = head->nextList;
  }
}

//Handles file analysis and computation of Jensen-Shannon Distance
void analysis(){
  struct Node *list = head;
  while(list->nextList != NULL){
    struct Node *listA = list;
    struct Node *listB = list->nextList;
    float kldA = 0;
    float kldB = 0;

    char* nameA = malloc(sizeof(char*)*256);
    nameA = listA->word;
    //printf("%s line 55", nameA);
    char* nameB = malloc(sizeof(char*)*256);
    nameB = listB->word;
    //printf("%s line 58", nameB);
    int totalToken = listA->prob + listB->prob;
    listA = listA->next;
    listB = listB->next;
    
      while(listA != NULL){
        while(listB != NULL){
          if(strcmp(listA->word,listB->word) == 0){
            kldA += listA->prob * log10(listA->prob/((listA->prob + listB->prob)/2));
          } else{
            kldA += listA->prob * log10(listA->prob/(listA->prob/2));
          }
          listB = listB->next;
        }
        listA = listA->next;
      }
      while(listB != NULL){
        while(listA != NULL){
          if(strcmp(listA->word,listB->word) == 0){
            kldB += listB->prob * log10(listB->prob/((listB->prob + listA->prob)/2));
          } else{
            kldB += listB->prob * log10(listB->prob/(listB->prob/2));
          }
          listA = listA->next;
        }
        listB = listB->next;
      }
    
    float distance = (kldA + kldB)/2;
    
    if(distance >= 0  && distance <= 0.1){
      printf(RED);
      printf("%lf ", distance);
      printf(REST); 
      printf("\"%s\" and \"%s\"\n", nameA, nameB);
    } else if(distance > 1  && distance <= 0.15){
      printf(YELLOW);
      printf("%lf ", distance);
      printf(REST); 
      printf("\"%s\" and \"%s\"\n", nameA, nameB);
    }
    else if(distance > 0.15  && distance <= 0.2){
      printf(GREEN);
      printf("%lf ", distance);
      printf(REST); 
      printf("\"%s\" and \"%s\"\n", nameA, nameB);
    }
    else if(distance >= 0.2  && distance <= 0.25){
      printf(CYAN);
      printf("%lf ", distance);
      printf(REST); 
      printf("\"%s\" and \"%s\"\n", nameA, nameB);
    }
    else if(distance >= 0.25  && distance <= 0.3){
      printf(BLUE);
      printf("%lf ", distance);
      printf(REST); 
      printf("\"%s\" and \"%s\"\n", nameA, nameB);
    }
    else if(distance > 3){
      printf(REST);
      printf("%lf ", distance);
      printf(REST); 
      printf("\"%s\" and \"%s\"\n", nameA, nameB);
    }

    list = list->nextList;
  }
}


int isPresent(struct Node* root, char* keyword){// Tests for the presence of a keyword to help find duplicates.
  struct Node* ptr;
  ptr = root;
  while(ptr != NULL){
    if(strcmp(ptr->word, keyword) == 0){
      return 1;
    }
    ptr = ptr->next;
  }
  return 0;
}

void* freeStruct(struct Node *root){//Frees all of the nodes in the structure.
  if(root->nextList != NULL){
    freeStruct(root->nextList);
  }
  if(root->next != NULL){
    freeStruct(root->next);
  }
  free(root->word);
  free(root);
  return NULL;
}

char* makeLower(char* word){//changes strings to lowercase
  for(int i = 0; word[i]; i++){
      word[i] = tolower(word[i]);
  }
  return word;
}

char* makeAlpha(char* word){//tokenizes and filters strings to be wrods spaces or hyphens.
  int k = 0;
  char* newWord = malloc(sizeof(char)*sizeof(word));
  for(int j = 0; word[j]; j++){
    if(isalpha(word[j]) || word[j] == '-'){
      newWord[k] = word[j];
      k++;
    }
  }
  return newWord;
}

char* concat(char* s1, char* s2){ //concats two strings together.
  char* newWord = malloc(strlen(s1) + strlen(s2));
  int i = 0;
  int j = 0;
  for(i = 0; i < (strlen(s1)+strlen(s2)); i++){
    if(i >= strlen(s1)){
      newWord[i] = s2[j];
      j++;
      continue;
    }
    newWord[i] = s1[i];
  }
  newWord[i] = '\0';
  return newWord;
}

void printList(struct Node *list){//goes through a list and prints out all of it bit including 
  while(list != NULL){
    printf("(%s %f)\n", list->word, list->prob);
    list = list->next;
  }
}

void* file_handle(void* fileName){//Handles the file functions and manages the data structure.
  struct Node *currFile= (struct Node*)malloc(sizeof(struct Node));//Pointer to keep track of the current file within the structure.
  struct Node *word_ptr;
  struct Node *newNode;

  char* currWord;
  int data;
  int word_count;

  FILE *fptr = fopen((char*)fileName, "r");

  if(!fptr){
    printf("Error: %s\n", strerror(errno));
    return NULL;
  }

  fscanf(fptr, "data"); //counts the number of words within the file for the prob of file structures as well as for calculating the probability.
  currWord = malloc(sizeof(char)*500);
  word_count = 0;

  while(!feof(fptr)){
    fscanf(fptr, "%s", currWord);
    currWord = makeAlpha(makeLower(currWord));
    word_count++;
  }

  currFile->next = NULL;
  currFile->nextList = NULL;
  currFile->word = (char*)fileName;
  currFile->prob = ((float)word_count);

  if(head == NULL){//creates the file object and inserts it in the end of the list.
    head = currFile;
    f_ptr = currFile;
    fileCount++;
  }
  else{
    f_ptr->nextList = currFile;
    f_ptr = f_ptr->nextList;
    fileCount++;
  }
  int n = 0;

  word_ptr = currFile;
  fseek(fptr, 0, SEEK_SET);//resets the file to the start so that we can tokenize.

   while(!feof(fptr)){
    currWord = malloc(sizeof(char)*500);
    fscanf(fptr, "%s", currWord);
    currWord = makeAlpha(makeLower(currWord));//tokenizes the file words to be processed.

    if(isPresent(currFile, currWord) == 0){ //handles duplicates and increases the probability instead of creating a new Node. Otherwise creates a new node.
      struct Node* tempptr = currFile->next;
      struct Node* prev = currFile;     

      while (tempptr != NULL){
        if(strcmp(tempptr->word,currWord) >= 0 ){
          struct Node *newNode = (struct Node*)malloc(sizeof(struct Node));
          newNode->next = tempptr;
          newNode->word = currWord;
          newNode->prob = (1.0)/(word_count);
          prev->next = newNode;
          break;
        }
        else{
          prev = tempptr;
          tempptr = tempptr->next;          
        }
      }
      if(tempptr == NULL){
        struct Node *newNode = (struct Node*)malloc(sizeof(struct Node)); 
        newNode->next = NULL;
        newNode->word = currWord;
        newNode->prob = (1.0)/(word_count);
        word_ptr->next = newNode;
        word_ptr = newNode;
      }
    }
    else{
      
      struct Node* tempptr = currFile->next;
      while(tempptr != NULL){
        if(strcmp (tempptr->word, currWord) == 0){
          tempptr->prob = ((1.0/word_count) + tempptr->prob);
          break;
        }
        tempptr = tempptr->next;
      }
    } 
   }
  fclose(fptr); 
  return NULL;
}

void* directory_handle(void* dirName){//handles threading

  struct dirent *dp;//creates new directory pointers and files/args for the pthread.
  DIR *dir = opendir(dirName);
  char* newDir;
  char* newFile;
  memset(&newDir, 0, sizeof(newDir));
  memset(&newFile, 0, sizeof(newFile));
  pthread_t t;

  char* slash = "/";
  
  if(dir){//starts new threads and handles memory/joining.
    newDir = malloc(strlen(dirName)+2);
    newDir = concat(dirName, slash); 
    while((dp = readdir(dir))){ 
        if(dp->d_type == DT_REG){
          newFile = malloc(strlen(dirName)+strlen(dp->d_name)*2);
          newFile = concat(newDir, dp->d_name);

          pthread_create(&t, NULL, file_handle, newFile);
          pthread_join(t, NULL);

          strcpy(newFile, newDir); 
        }
        else if(dp->d_type == DT_DIR && strcmp(dp->d_name, ".") != 0 && strcmp(dp->d_name, "..") != 0){
          newFile = malloc(strlen(dirName)+strlen(dp->d_name)*2);
          newFile = concat(newDir, dp->d_name);

          pthread_create(&t, NULL, directory_handle, newFile);
          pthread_join(t, NULL);
          strcpy(newFile, newDir);
        }
    }
  } else{
    printf("Error: Not a valid directory\n");
    return NULL;
  }
  return NULL;
}

int main(int argc, char* argv[]){

  directory_handle(argv[1]);
  //printfiles();

  analysis();

  freeStruct(head);
  return 0;
  
}