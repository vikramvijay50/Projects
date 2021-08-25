#define malloc( x ) mymalloc( x, __FILE__, __LINE__ )
#define free( x ) myfree( x, __FILE__, __LINE__ )

void *mymalloc(size_t length, char *file, int line);
void myfree(void *ptr, char *file, int line);
