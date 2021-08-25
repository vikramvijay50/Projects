#include "my_vm.h"

bool init = false;

int pageTableBits;
int pageDirectoryBits;

double totalChecks = 0;
double totalMisses = 0;

char * physicalBitMap = NULL;
char * virtualBitMap = NULL;
char * physicalMemory = NULL;

pde_t * pageDirectory;

struct tlb *TLB = NULL;

pthread_mutex_t mutex;

/*
Function responsible for allocating and setting your physical memory 
*/
void set_physical_mem() {

    //Allocate physical memory using mmap or malloc; this is the total size of
    //your memory you are simulating

    
    //HINT: Also calculate the number of physical and virtual pages and allocate
    //virtual and physical bitmaps and initialize them
  if(init == false){
    int virtualOffset = log2(PGSIZE);
    pageDirectoryBits = (virtualBits - virtualOffset) / 2;
    pageTableBits = virtualBits - virtualOffset - pageDirectoryBits;

    physicalMemory = (char * ) memalign(PGSIZE, MEMSIZE);
    pageDirectory = (pde_t * ) calloc((1 << pageDirectoryBits), sizeof(pde_t));
    
    physicalBitMap = calloc(((MEMSIZE / PGSIZE) / 8), sizeof(char));
    virtualBitMap = calloc(((MAX_MEMSIZE / PGSIZE) / 8), sizeof(char));
    virtualBitMap[0] = -1;
    TLB = (struct tlb *)calloc(TLB_ENTRIES, sizeof(struct tlb));
  }
  init = true;
}


/*
 * Part 2: Add a virtual to physical page translation to the TLB.
 * Feel free to extend the function arguments or return type.
 */
void
add_TLB(unsigned long va, unsigned long pa)
{

    /*Part 2 HINT: Add a virtual to physical page translation to the TLB */

  int virtualOffset = log2(PGSIZE);
  va = va >> virtualOffset;
  int index = (va%TLB_ENTRIES);
  TLB[index].physical = pa;
  TLB[index].virtual = va;
}


/*
 * Part 2: Check TLB for a valid translation.
 * Returns the physical page address.
 * Feel free to extend this function and change the return type.
 */
pte_t *
check_TLB(unsigned long va) {

  /* Part 2: TLB lookup code here */
  int virtualOffset = log2(PGSIZE);
  totalChecks++;
  unsigned long originalVA = va;
  va = va >> virtualOffset;
  if(TLB[(va % TLB_ENTRIES)].virtual == originalVA){
    unsigned long offset = (unsigned long) va;
    offset = offset << (pageTableBits + virtualOffset);
    offset = offset >> (pageTableBits + virtualOffset);
    return (pte_t *)(TLB[va].physical + offset);
  }
  totalMisses++;
  return NULL;
}

void removeTLB(unsigned long va){
  int virtualOffset = log2(PGSIZE);
  unsigned long originalVA = va;
  va = va >> virtualOffset;
  int index = (va%TLB_ENTRIES);
  if(TLB[index].virtual == originalVA){
    TLB[index].virtual = 0;
    TLB[index].physical = 0;
  }
}


/*
 * Part 2: Print TLB miss rate.
 * Feel free to extend the function arguments or return type.
 */
void
print_TLB_missrate()
{
  double miss_rate = 0;	

  /*Part 2 Code here to calculate and print the TLB miss rate*/

  miss_rate = totalMisses / totalChecks;

  fprintf(stderr, "TLB miss rate %lf \n", miss_rate);
}



/*
The function takes a virtual address and page directories starting address and
performs translation to return the physical address
*/
pte_t *translate(pde_t *pgdir, void *va) {
    /* Part 1 HINT: Get the Page directory index (1st level) Then get the
    * 2nd-level-page table index using the virtual address.  Using the page
    * directory index and page table index get the physical address.
    *
    * Part 2 HINT: Check the TLB before performing the translation. If
    * translation exists, then you can return physical address from the TLB.
    */
  int virtualOffset = log2(PGSIZE);
  pte_t * entry = check_TLB((unsigned long)va);
  if(entry != NULL){
    return entry;
  }
  unsigned long directoryOffset = (unsigned long) va >> (pageTableBits + virtualOffset);
  pte_t * table = (pte_t * ) pgdir[directoryOffset];
  if (table == NULL) {
    return NULL;
  }
  unsigned long tableOffset = (unsigned long) va;
  tableOffset = tableOffset << pageDirectoryBits;
  tableOffset = tableOffset >> (pageTableBits + virtualOffset);
  if (table[tableOffset] == 0) {
    return NULL;
  }
}


/*
The function takes a page directory address, virtual address, physical address
as an argument, and sets a page table entry. This function will walk the page
directory to see if there is an existing mapping for a virtual address. If the
virtual address is not present, then a new entry will be added
*/
int
page_map(pde_t *pgdir, void *va, void *pa)
{

    /*HINT: Similar to translate(), find the page directory (1st level)
    and page table (2nd-level) indices. If no mapping exists, set the
    virtual to physical mapping */

  int virtualOffset = log2(PGSIZE);
  unsigned long directoryOffset = (unsigned long) va >> (pageTableBits + virtualOffset);
  
  if ((pte_t*)pgdir[directoryOffset] == NULL) {
    pgdir[directoryOffset] = (pde_t) calloc((PGSIZE / sizeof(pte_t)), sizeof(pte_t));
  }
  pte_t * table = (pte_t * ) pgdir[directoryOffset];
  unsigned long tableOffset = (unsigned long) va;
  tableOffset = tableOffset << pageDirectoryBits;
  tableOffset = tableOffset >> (pageTableBits + virtualOffset);
  if ((pte_t)table[tableOffset] == 0) {
    table[tableOffset] = (unsigned long) pa;
    return 1;
  }
  return 0;
}


/*Function that gets the next available page
*/
void *get_next_avail(int num_pages) {
 
    //Use virtual address bitmap to find the next free page
  int iteration = 0;
  char * currVirtMap;
  int startPage = -1;
  int pagesFound = 0;

  for (currVirtMap = virtualBitMap; currVirtMap < &virtualBitMap[((MAX_MEMSIZE / PGSIZE) / 8)]; currVirtMap++) {
    if(pagesFound >= num_pages){
      break;
    }
    int i;
    for (i = 7; i >= 0 && pagesFound < num_pages; i--) {
      if (( * currVirtMap & 1 << i) == 0) {
        if (pagesFound == 0) {
          startPage = (iteration * 8) + (7 - i);
        }
        pagesFound++;
      } else {
        startPage = -1;
        pagesFound = 0;
      }
    }
    iteration++;
  }
  if(pagesFound < num_pages){
    return NULL;
  }
  if (startPage != -1) {
    int k = 0;
    int currPage = startPage;
    for (k = 0; k < num_pages; k++) {
      char *phys = virtualBitMap + (currPage / 8);
      * phys = * phys | 1 << (7 - (currPage %8));
      currPage++;
    }
    return ((void * )(startPage*PGSIZE));
  }

  return NULL;
}


/* Function responsible for allocating pages
and used by the benchmark
*/
void *a_malloc(unsigned int num_bytes) {

    /* 
     * HINT: If the physical memory is not yet initialized, then allocate and initialize.
     */

   /* 
    * HINT: If the page directory is not initialized, then initialize the
    * page directory. Next, using get_next_avail(), check if there are free pages. If
    * free pages are available, set the bitmaps and map a new page. Note, you will 
    * have to mark which physical pages are used. 
    */

  if (num_bytes <= 0 || num_bytes > MEMSIZE) {
    return NULL;
  }
  pthread_mutex_lock(&mutex);
    set_physical_mem();

  int numPagesRequested = num_bytes / PGSIZE;
  if (num_bytes % PGSIZE != 0) {
    numPagesRequested++;
  }
  int pagesFound = 0;
  bool enough = false;
  char * physMap = physicalBitMap;
  while (physMap < physicalBitMap + ((MEMSIZE / PGSIZE) / 8)) {
    int curr;
    for (curr = 0; curr <= 7; curr++) {
      if ((*physMap & 1 << curr) == 0) {
        pagesFound++;
      }
    }
    if (pagesFound >= numPagesRequested) {
      enough = true;
      break;
    } else{
      enough = false;
    }
    physMap += 1;
  }
  if (enough == false) {
    pthread_mutex_unlock(&mutex);
    return NULL;
    }

  void * virtual = get_next_avail(numPagesRequested);
  if (virtual == NULL) {
    pthread_mutex_unlock(&mutex);
    return NULL;
  }
  int currPage = 0;
  char * physicalMap = physicalBitMap;
  int pageNumber = 0;
  for (currPage = 0; currPage < numPagesRequested; currPage++) {
    int shifter;
    for (shifter = 7; shifter >= 0; shifter--) {
      if ((*physicalMap & 1 << shifter) == 0) {
        pageNumber = pageNumber + 7 - shifter;
        * physicalMap |= 1 << shifter;
        break;
      }
    }
    page_map(pageDirectory, virtual, (char *) physicalMemory + (pageNumber * PGSIZE));
    virtual = virtual + PGSIZE;
    pageNumber = pageNumber - shifter - 7;
  }

  pthread_mutex_unlock(&mutex);
  return virtual = virtual - PGSIZE * numPagesRequested;
}

/* Responsible for releasing one or more memory pages using virtual address (va)
*/
void a_free(void *va, int size) {

    /* Part 1: Free the page table entries starting from this virtual address
     * (va). Also mark the pages free in the bitmap. Perform free only if the 
     * memory from "va" to va+size is valid.
     *
     * Part 2: Also, remove the translation from the TLB
     */
     
  int virtualOffset = log2(PGSIZE);
  if (size <= 0) {
    return;
  }
  pthread_mutex_lock(&mutex);
  set_physical_mem();
  int numOfPages = size / PGSIZE;
  int remainder = size % PGSIZE;
  if (remainder != 0) {
    numOfPages++;
  }

  
  if (validVirtual(va+size) == 0) {
    pthread_mutex_unlock(&mutex);
    return;
  }
  totalChecks++;
  totalMisses++;
  
  unsigned long page = ((unsigned long) va >> virtualOffset) << virtualOffset;
  unsigned long virtualPage  = page >> virtualOffset;
  unsigned long tableIndex = (page << pageDirectoryBits) >> (pageTableBits + virtualOffset);
  unsigned long directoryIndex = page >> (pageTableBits + virtualOffset);
  int pagesDone;
  for (pagesDone = 0; pagesDone < numOfPages; pagesDone++) {
    pte_t * table = (pte_t *)pageDirectory[directoryIndex];
    pte_t tableEntry = table[tableIndex];
    
    char * physBit = physicalBitMap + (unsigned long)(tableEntry >>virtualOffset)/8;
    table[tableIndex] = 0;
    *physBit = *physBit- (1 << (7 - ((unsigned long)(tableEntry >> virtualOffset) % 8)));

    char * virtBit = virtualBitMap + (virtualPage / 8);
    *virtBit = *virtBit - (1 << (7 - (virtualPage % 8)));
    virtualPage = virtualPage +1;
  }
  removeTLB((unsigned long)va);
  pthread_mutex_unlock(&mutex);
}


/* The function copies data pointed by "val" to physical
 * memory pages using virtual address (va)
*/
void put_value(void *va, void *val, int size) {

    /* HINT: Using the virtual address and translate(), find the physical page. Copy
     * the contents of "val" to a physical page. NOTE: The "size" value can be larger 
     * than one page. Therefore, you may have to find multiple pages using translate()
     * function.
     */

pthread_mutex_lock(&mutex);
set_physical_mem();
  if (va == NULL) {
    pthread_mutex_unlock(&mutex);
    return;
  }
  if (validVirtual(va) == 0) {
    pthread_mutex_unlock(&mutex);
    return;
  }
  char * addr;
  int i;
  for (i = 0; i < size; i++) {
    addr = (char *) translate(pageDirectory, va + i);
    *addr = *(char*) val;
    (char*)val++;
  }
  pthread_mutex_unlock(&mutex);


}


/*Given a virtual address, this function copies the contents of the page to val*/
void get_value(void *va, void *val, int size) {

    /* HINT: put the values pointed to by "va" inside the physical memory at given
    * "val" address. Assume you can access "val" directly by derefencing them.
    */

pthread_mutex_lock(&mutex);
set_physical_mem();
  if (va == NULL) {
    pthread_mutex_unlock(&mutex);
    return;
  }

  if (validVirtual(va) == 0) {
    pthread_mutex_unlock(&mutex);
    return;
  }
  char * addr;
  char * charValue = val;
  int i;
  for (i = 0; i < size; i++) {
    addr = (char *) translate(pageDirectory, va + i);
    *charValue = *addr;
    charValue++;
  }
  pthread_mutex_unlock(&mutex);


}



/*
This function receives two matrices mat1 and mat2 as an argument with size
argument representing the number of rows and columns. After performing matrix
multiplication, copy the result to answer.
*/
void mat_mult(void *mat1, void *mat2, int size, void *answer) {

    /* Hint: You will index as [i * size + j] where  "i, j" are the indices of the
     * matrix accessed. Similar to the code in test.c, you will use get_value() to
     * load each element and perform multiplication. Take a look at test.c! In addition to 
     * getting the values from two matrices, you will perform multiplication and 
     * store the result to the "answer array"
     */

  int row;
  int column;
  int sum = 0;
  int num1;
  int num2;
  int swapper;
  for (row = 0; row < size; row++) {
    for (column = 0; column < size; column++) {
      sum = 0;
      for (swapper = 0; swapper < size; swapper++) {
        get_value(mat1 + (row * size + swapper) * sizeof(int), &num1, sizeof(int));
        get_value(mat2 + (swapper * size + column) * sizeof(int), &num2, sizeof(int));
        sum += (num1 * num2);
      }
      put_value(answer + (row * size + column) * sizeof(int), &sum, sizeof(int));
    }
  }
}

int validVirtual(void * va) {
  unsigned long pageNum = (unsigned long) va >> ((unsigned long) log2(PGSIZE));
  if (((int) pageNum) > -1 && ((int) pageNum) <= ((unsigned long)1024*1024)) {
    return 1;
  }
  return 0;
}

