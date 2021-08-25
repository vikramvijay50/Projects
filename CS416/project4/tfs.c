/*
 *  Copyright (C) 2021 CS416 Rutgers CS
 *	Tiny File System
 *	File:	tfs.c
 *
 */

#define FUSE_USE_VERSION 26

#include <fuse.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <errno.h>
#include <sys/time.h>
#include <libgen.h>
#include <limits.h>

#include "block.h"
#include "tfs.h"

char diskfile_path[PATH_MAX];
int blockAmount = 0;
int testcount;

// Declare your in-memory data structures here
struct superblock * super;
char diskfile_path[PATH_MAX];

/* 
 * Get available inode number from bitmap
 */
int get_avail_ino() {

	// Step 1: Read inode bitmap from disk
	unsigned char readInto  [BLOCK_SIZE];
	bio_read(super->i_bitmap_blk, readInto);
	
	// Step 2: Traverse inode bitmap to find an available slot
	int curr = 0;
	
	for(curr =0; curr<super->max_inum;curr++){	 
	  if(get_bitmap((bitmap_t)readInto, curr) != 1){
	    break;
	  }
	}
	if(super -> max_inum <= curr){
	  return -1;
	}
	// Step 3: Update inode bitmap and write to disk
	set_bitmap((bitmap_t)readInto, curr);
	bio_write(super->i_bitmap_blk, readInto);
	//printf("success in getting");
	return curr;
}
int isValid(int blockNum){
	if (super->d_start_blk > blockNum || (super->d_start_blk + super->max_dnum) < blockNum) {
		return -1;
 	} else{
  		return 0;
 	}
}

/* 
 * Get available data block number from bitmap
 */
int get_avail_blkno() {

	// Step 1: Read data block bitmap from disk
	unsigned char readInto [BLOCK_SIZE];
	bio_read(super->d_bitmap_blk, readInto);
	
	// Step 2: Traverse data block bitmap to find an available slot
	int curr = 0;
	for(curr =0; curr<super->max_dnum;curr++){
	  if(get_bitmap((bitmap_t)readInto, curr) != 1){
	    break;
	  }
	}
	if (super->max_dnum <= curr) {
		return -1;
	}
	
	// Step 3: Update data block bitmap and write to disk
	set_bitmap((bitmap_t)readInto, curr);
	bio_write(super->d_bitmap_blk, readInto);
	//printf("have block num");
	return curr;
}

/* 
 * inode operations
 */
int readi(uint16_t ino, struct inode *inode) {

  	if (ino > MAX_INUM){
		return -1;
  	}
	// Step 1: Get the inode's on-disk block number
  	unsigned int blockNum = ino / (BLOCK_SIZE/sizeof(struct inode));
  
  	// Step 2: Get offset of the inode in the inode on-disk block
  	unsigned int offset = ino % (BLOCK_SIZE/sizeof(struct inode)) * sizeof(struct inode);
  
  	// Step 3: Read the block from disk and then copy into inode structure
  	char readInto[BLOCK_SIZE];
 	bio_read(super->i_start_blk + blockNum, readInto);
  	struct inode * temp = malloc(sizeof(struct inode));
  	memcpy(temp, (readInto + offset), sizeof(struct inode));
  	*inode = *temp;
  	return 0;
}

int writei(uint16_t ino, struct inode *inode) {
	
	//printf("in writei");

	if (ino > MAX_INUM){
    	//not in bounds
    	return -1;
  	}
  	// Step 1: Get the block number where this inode resides on disk
  	unsigned int blockNum = ino / (BLOCK_SIZE/sizeof(struct inode));
  
  	// Step 2: Get the offset in the block where this inode resides on disk
  	unsigned int offset = ino % (BLOCK_SIZE/sizeof(struct inode)) * sizeof(struct inode);
  
  	// Step 3: Write inode to disk
  	char readInto[BLOCK_SIZE];
  	bio_read(super->i_start_blk + blockNum, readInto);
  	memcpy((readInto + offset), inode, sizeof(struct inode));
  	bio_write(super->i_start_blk + blockNum, readInto);
  	return 0;
}


/* 
 * directory operations
 */
int dir_find(uint16_t ino, const char *fname, size_t name_len, struct dirent *dirent) {

	//printf("in dir_find");

  // Step 1: Call readi() to get the inode using ino (inode number of current directory)
	struct inode * currDir = malloc(sizeof (struct inode));
  	if (readi(ino, currDir) != 0) {
    	// not found
    	return -1;
  	}  
  // Step 2: Get data block of current directory from inode
  	int x;
  	for (x = 0; x < 16; x++) {
    	if (isValid(currDir->direct_ptr[x]) == -1) {
      		continue;
    	}
    	void * readInto = malloc(BLOCK_SIZE);
    	int data = currDir->direct_ptr[x];
    	bio_read(data, readInto);
    	int y;		
    	for (y = 0; y < 16; y++) {
  // Step 3: Read directory's data block and check each directory entry.
      	struct dirent * d = malloc(sizeof(struct dirent));
      	memcpy(d, (readInto + (y * sizeof(struct dirent))), sizeof(struct dirent));
      	//If the name matches, then copy directory entry to dirent structure
      	if (strcmp(d->name, fname) == 0) {
			if(d->valid == 1){
				memcpy(dirent, d, sizeof(struct dirent));
			return 0;
		} else{
	  	//right name wrong type
	  	return -1;
		}
      	}   
    }
  }
  return -1;
}

int dir_add(struct inode dir_inode, uint16_t f_ino, const char *fname, size_t name_len) {

	//printf("in dir_add");

	int found = -1;
	// Step 1: Look inside this directory to see if the dirent we're trying to add already exists
	struct dirent * dir = malloc(sizeof(struct dirent));
	if(dir_find(dir_inode.ino, fname, name_len, dir) != -1) {
		return -1;
	}
	// Step 2: Find an empty block inside dir_inode's direct pointers to add this new dirent
	int x;  
  	for (x = 0; x < 16; x++) {
		if (found == 1) {
			break;
		}
		int dataNum = dir_inode.direct_ptr[x];
		if (isValid(dataNum) == -1) {
			int blockNum = get_avail_blkno();
			if (blockNum == -1) {	
				return -1;
			} else {				
			  void * readInto = malloc(BLOCK_SIZE);
			  dataNum = super->d_start_blk + blockNum;
			  dir_inode.direct_ptr[x] = dataNum;
			  bio_read(super->d_bitmap_blk, readInto);
			  set_bitmap((bitmap_t)readInto, dataNum);	
			}
		}
		void * readInto2 = malloc(BLOCK_SIZE);
		bio_read(dataNum, readInto2);
		int y;
		for (y = 0; y < 16; y++) {
		  // Step 3: Add directory entry in dir_inode's data block and write to disk
			struct dirent * temp = malloc(sizeof(struct dirent));
			int offset = y * sizeof(struct dirent);
			memcpy(temp, (offset + readInto2), sizeof(struct dirent));
			if (temp->valid != 1) {
			  void * readInto3 = malloc(BLOCK_SIZE);
			  struct dirent * tobeAdded = malloc(sizeof(struct dirent));
			  tobeAdded->valid = 1;			 
			  strcpy(tobeAdded->name, fname);
			  tobeAdded->ino = f_ino;			 
			  bio_read(dataNum, readInto3);
			  memcpy(readInto3 + offset, tobeAdded, sizeof(struct dirent));
			  bio_write(dataNum, readInto3); 
			  found = 1;
			  break;	
			}
		}	
	}
	// Allocate a new data block for this directory if it does not exist

	// Update directory inode

	// Write directory entry
	dir_inode.size = dir_inode.size + sizeof(struct dirent);
	dir_inode.link = dir_inode.link + 1;
	writei(dir_inode.ino, &dir_inode);
	//printf("added");
	return 0;
}

int dir_remove(struct inode dir_inode, const char *fname, size_t name_len) {

  //printf("in dir_remove");

  int x;  
  for (x = 0; x < 16; x++) {
    if (isValid(dir_inode.direct_ptr[x]) == -1) {
      continue;
    }
    // Step 1: Read dir_inode's data block and checks each directory entry of dir_inode
    void * readInto = malloc(BLOCK_SIZE);
    int dataBlockNum = dir_inode.direct_ptr[x];
    struct dirent * temp = malloc(sizeof(struct dirent));   
    bio_read(dataBlockNum, readInto);
    int y;
    for (y = 0; y < 16; y++) {
      int offset = y * sizeof(struct dirent);
      memcpy(temp, readInto + offset, sizeof(struct dirent));
     // Step 2: Check if fname exist
      if (strcmp(temp->name, fname) == 0) {
	// Step 3: If exist, then remove it from dir_inode's data block and write to disk
	if(temp->valid == 1){
	  char newName[255] = "";
	  struct dirent * newTemp = malloc(sizeof (struct dirent));
	  strcpy(newTemp->name, newName);
	  newTemp->ino = 0;
	  newTemp->valid = 0;
	  bio_write(dataBlockNum, newTemp);
	  void * readInto2 = malloc(BLOCK_SIZE);
	  bio_read(dataBlockNum,readInto2);
	  memcpy((readInto2 + offset), newTemp, sizeof(struct dirent));	  
	  if(dir_inode.size % BLOCK_SIZE == 0) {
	    void * bitmapReadInto = malloc(BLOCK_SIZE);
	    dir_inode.direct_ptr[dataBlockNum] = 0;
	    bio_read(super->d_bitmap_blk, bitmapReadInto);
	    unset_bitmap((bitmap_t)bitmapReadInto, dataBlockNum);
	    bio_write(super->d_bitmap_blk, bitmapReadInto);
	  }
	  
	  //update parent
	  dir_inode.size = dir_inode.size - sizeof(struct dirent);
	  dir_inode.link = dir_inode.link-1;
	  writei(dir_inode.ino, &dir_inode);
	  return 0;		
	}
      }
    }
  }	
  //printf("error");
  return -1;
}

/* 
 * namei operation
 */
int get_node_by_path(const char *path, uint16_t ino, struct inode *inode) {
	
  // Step 1: Resolve the path name, walk through path, and finally, find its inode.
  // Note: You could either implement it in a iterative way or recursive way
  char * recur;
  char * token = strdup(path);
  token = strtok_r(token, "/", &recur);
  if (token == NULL) {
    readi(ino, inode);
    return 0;
  }
  struct dirent * target = malloc(sizeof(struct dirent));
  if (dir_find(ino, token, strlen(token), target) != 0) {
    return -1;
  }
  else {
    return get_node_by_path(recur, target->ino, inode);
  }
}

/* 
 * Make file system
 */
int tfs_mkfs() {

	//printf("making file system");

	// Call dev_init() to initialize (Create) Diskfile
	dev_init(diskfile_path);
	
	// write superblock information
	super = malloc(sizeof(struct superblock));
	super->i_bitmap_blk = 1;
	super->d_start_blk = 68;
	super->i_start_blk = 3;
	super->d_bitmap_blk = 2;
	super->magic_num = MAGIC_NUM;
	super->max_dnum = MAX_DNUM;
	super->max_inum = MAX_INUM;
	bio_write(0, super);
	
	// initialize inode bitmap
	unsigned char inodeMap[MAX_INUM/8];
	memset(inodeMap, 0, MAX_INUM/8);
	//initialize data block bitmap
	unsigned char dataMap[MAX_DNUM/8];
	memset(dataMap, 0, MAX_DNUM/8);

	
	// update bitmap information for root directory
	set_bitmap(dataMap, 0);
	set_bitmap(inodeMap, 0);       
	bio_write(2, dataMap);
	bio_write(1, inodeMap);

	// update bitmap information for root directory
	//also did it for parent
	struct inode * rootDir = malloc(sizeof(struct inode));
	rootDir->ino = 0;
	rootDir->valid = 1;
	rootDir->size = 2 * sizeof(struct dirent);				
	rootDir->type = 1;				
	rootDir->link = 2;
	rootDir->direct_ptr[0] = 68;	
	struct dirent * rootDirDir = malloc(sizeof(struct dirent));
	strcpy(rootDirDir->name, ".");	
	rootDirDir->valid = 1;
	rootDirDir->ino = rootDir->ino;		
	struct dirent * rootDirentParent = malloc(sizeof(struct dirent));
	rootDirentParent->ino = rootDir->ino;
	rootDirentParent->valid = 1;
	strcpy(rootDirentParent->name, "..");

	// update inode for root directory
	void * readInto = malloc(BLOCK_SIZE);
	bio_read(super->i_start_blk, readInto);
	memcpy(readInto, rootDir, sizeof(struct inode));
	bio_write(super->i_start_blk, readInto);	
	memset(readInto, 0, BLOCK_SIZE);
	memcpy(readInto, rootDirDir, sizeof(struct dirent));	
	memcpy(readInto + sizeof(struct dirent), rootDirentParent, sizeof(struct dirent));
	bio_write(rootDir->direct_ptr[0], readInto);
	free(readInto);
	//printf("made system");
	return 0;
}


/* 
 * FUSE file operations
 */
static void *tfs_init(struct fuse_conn_info *conn) {

	// Step 1a: If disk file is not found, call mkfs
	int diskFileFound = dev_open(diskfile_path);
  	// Step 1b: If disk file is found, just initialize in-memory data structures
	//and read superblock from disk
	if (diskFileFound == 0) {
	  void * readInto = malloc(BLOCK_SIZE);
	  bio_read(0, readInto);
	  super = (struct superblock *) readInto;
	  if (super->magic_num != MAGIC_NUM) {	   
	    exit(EXIT_FAILURE);
	  }
	} else {
	  tfs_mkfs();
	}
	return NULL; 
}

static void tfs_destroy(void *userdata) {

	// Step 1: De-allocate in-memory data structures
	free(super);
	// Step 2: Close diskfile
	dev_close();
}

static int tfs_getattr(const char *path, struct stat *stbuf) {

	// Step 1: call get_node_by_path() to get inode from path
	struct inode * node = malloc(sizeof(struct inode));
	if (get_node_by_path(path, 0, node) == -1) {
		return -ENOENT;	
	}
	// Step 2: fill attribute of file into stbuf from inode
	if (node->type == 1) {	
	  stbuf->st_mode = S_IFDIR | 0755;			  
	}
	else if (node->type == 2) {	  	 	
	  stbuf->st_mode = S_IFREG | 0644;
	}
	stbuf->st_nlink = node->link;
	stbuf->st_size = node->size;
	stbuf->st_gid = getgid(); 
	stbuf->st_uid = getuid();       
	time(&stbuf->st_atime);
	time(&stbuf->st_mtime);
	return 0;
}

static int tfs_opendir(const char *path, struct fuse_file_info *fi) {

	// Step 1: Call get_node_by_path() to get inode from path

	// Step 2: If not find, return -1
	struct inode * node = malloc(sizeof(struct inode));	
  	return get_node_by_path(path, 0, node);
}

static int tfs_readdir(const char *path, void *buffer, fuse_fill_dir_t filler, off_t offset, struct fuse_file_info *fi) {

	// Step 1: Call get_node_by_path() to get inode from path
  struct inode * node = malloc(sizeof(struct inode));	
  if (get_node_by_path(path, 0, node) == -1 || node->type != 1) {
    return -1;
}
  
 
  // Step 2: Read directory entries from its data blocks, and copy them to filler
  int x;  
  int count = 1;
  for (x = 0; x < 16; x++) {
    void * readInto = malloc(BLOCK_SIZE);
    bio_read(node->direct_ptr[x], readInto);
    struct dirent * dir = malloc(sizeof(struct dirent));
    int y;
    for (y = 0; y < 16; y++) {
      if (count > node->link) {
	break;
      }
      count = count + 1;
      memcpy(dir, readInto + (y * sizeof(struct dirent)), sizeof(struct dirent));      
      if (dir->valid == 1 && filler(buffer, dir->name, NULL, 0) != 0)  {	
	  return 0;
      }
    }
    free(readInto); 
  }
  return 0;
}


static int tfs_mkdir(const char *path, mode_t mode) {

	//printf("making directory");

	// Step 1: Use dirname() and basename() to separate parent directory path and target directory name
	char * parentDirPath = dirname(strdup(path));
	char * targetDir = basename(strdup(path));

	// Step 2: Call get_node_by_path() to get inode of parent directory
	struct inode * parentInode = malloc(sizeof (struct inode));
	int getNodeResult = get_node_by_path(parentDirPath, 0, parentInode);
	if (getNodeResult == -1) {
		return -1;	
	}
	
	// Step 3: Call get_avail_ino() to get an available inode number
        uint16_t inodeNum = (uint16_t) get_avail_ino();	
	// Step 4: Call dir_add() to add directory entry of target directory to parent directory	        
	if (dir_add(*parentInode, inodeNum, targetDir, strlen(targetDir)) == -1) {
		return -1;
	}
	
	// Step 5: Update inode for target directory
	struct inode * newDir = malloc(sizeof(struct inode));
	newDir->ino = inodeNum;
	newDir->link = 2;
	newDir->valid = 1;		
	newDir->size = 2 * sizeof(struct dirent);	
	newDir->type = 1;
	newDir->vstat.st_mtime = time(0);
	newDir->vstat.st_atime = time(0);

	int blockNum = get_avail_blkno();
	if (blockNum == -1) {
		return -1;
	}
	void * readInto = malloc(BLOCK_SIZE);
	newDir->direct_ptr[0] = super->d_start_blk + blockNum;
	bio_read(super->d_bitmap_blk, readInto);
	set_bitmap((bitmap_t)readInto, newDir->direct_ptr[0]);
	struct dirent * parentDir = malloc(sizeof(struct dirent));
	struct dirent * currDir = malloc(sizeof(struct dirent));
	parentDir->ino = parentInode->ino;
	currDir->ino = inodeNum;
	parentDir->valid = 1;
	currDir->valid = 1;
	strcpy(parentDir->name, "..");       	
	strcpy(currDir->name, ".");		
	memset(readInto, 0, BLOCK_SIZE);
	memcpy(readInto, currDir, sizeof(struct dirent));	
	memcpy(readInto + sizeof(struct dirent), parentDir, sizeof(struct dirent));      
	bio_write(newDir->direct_ptr[0], readInto);
	
	// Step 6: Call writei() to write inode to disk
	writei(inodeNum, newDir);
	
	return 0;
}

static int tfs_rmdir(const char *path) {

	//printf("removing dir");

	// Step 1: Use dirname() and basename() to separate parent directory path and target directory name
	char * parentDirPath = dirname(strdup(path));
	char * targetDir = basename(strdup(path));
		
	// Step 2: Call get_node_by_path() to get inode of target directory
	struct inode * targetNode = malloc(sizeof(struct inode));
	//GET NODE BY PATH KEEPS RETURNING -1 FOR SOME REASON
	if (get_node_by_path(path, 0, targetNode)== -1 || targetNode->type != 1 || targetNode->link > 2) {	 
	   return -2;
	}
	
	// Step 3: Clear data block bitmap of target directory
	unsigned char readInto[BLOCK_SIZE];
	bio_read(super->d_bitmap_blk, readInto);
	int x;
	for (x = 0; x < 16; x++) {
	  if (isValid(targetNode->direct_ptr[x]) == -1) {	  
	    continue;
	  }
	  unset_bitmap((bitmap_t)readInto, targetNode->direct_ptr[x] - super->d_start_blk);
	}
	bio_write(super->d_bitmap_blk, readInto);
	
	// Step 4: Clear inode bitmap and its data block
	unsigned char bitMapReader[BLOCK_SIZE];
	bio_read(super->i_bitmap_blk, bitMapReader);
	unset_bitmap((bitmap_t)bitMapReader, targetNode->ino);
	bio_write(super->i_bitmap_blk, bitMapReader);
	void * dataBlockRead = malloc(BLOCK_SIZE);
	bio_read(targetNode->direct_ptr[0], dataBlockRead);
	memset(dataBlockRead, 0, BLOCK_SIZE);
	bio_write(targetNode->direct_ptr[0], dataBlockRead);
	struct inode * clearBlock = malloc(sizeof(struct inode));
	memset(clearBlock, 0, sizeof(struct inode));
	writei(targetNode->ino, clearBlock);
	
	// Step 5: Call get_node_by_path() to get inode of parent directory
	struct inode * parentNode = malloc(sizeof(struct inode));
	get_node_by_path(parentDirPath, 0, parentNode);
	
	// Step 6: Call dir_remove() to remove directory entry of target directory in its parent directory
	dir_remove(*parentNode, targetDir, strlen(targetDir));
	return 0;
}

static int tfs_releasedir(const char *path, struct fuse_file_info *fi) {
	// For this project, you don't need to fill this function
	// But DO NOT DELETE IT!
    return 0;
}

static int tfs_create(const char *path, mode_t mode, struct fuse_file_info *fi) {

	// Step 1: Use dirname() and basename() to separate parent directory path and target file name
	char * parentDirPath = dirname(strdup(path));
	char * targetFileName = basename(strdup(path));
	
	// Step 2: Call get_node_by_path() to get inode of parent directory
	struct inode * dir_inode = malloc(sizeof(struct inode));       
	if ( get_node_by_path(parentDirPath, 0, dir_inode)  == -1) {
		return -1;	
	}
	// Step 3: Call get_avail_ino() to get an available inode number
	uint16_t ino = (uint16_t)get_avail_ino();
	
	// Step 4: Call dir_add() to add directory entry of target file to parent directory
	if(dir_add(*dir_inode, ino, targetFileName, strlen(targetFileName)) == -1){	  
	  return -1;
	}
	
	// Step 5: Update inode for target file
	struct inode * file = malloc(sizeof(struct inode));
	file->ino = ino;
	file->link = 1;
	file->size = 0;
	file->valid = 1;				
	file->type = 2;
	file->vstat.st_mtime = time(0);
	file->vstat.st_atime = time(0);
	memset(file->direct_ptr,0,sizeof(int)*16);
	memset(file->indirect_ptr,0,sizeof(int)*8);
	// Step 6: Call writei() to write inode to disk
	writei(ino, file);
	return 0;
}

static int tfs_open(const char *path, struct fuse_file_info *fi) {

	// Step 1: Call get_node_by_path() to get inode from path

	// Step 2: If not find, return -1
	struct inode * node = malloc(sizeof(struct inode));
    return get_node_by_path(path, 0, node);
}

static int tfs_read(const char *path, char *buffer, size_t size, off_t offset, struct fuse_file_info *fi) {

	// Step 1: You could call get_node_by_path() to get inode from path
	struct inode * node = malloc(sizeof(struct inode));
	if(get_node_by_path(path, 0, node) == -1) {
		return -1;	
		}
	
	int start = offset / BLOCK_SIZE;	
	int indirect = 0;
	if(start >= 16){	  
	  start = start - 16;
	  indirect = 1;
	}
	int blockOffset = offset % BLOCK_SIZE;
	int written = 0;
	// Step 2: Based on size and offset, read its data blocks from disk
	while (written < size && indirect == 0) {
	  if (isValid(node->direct_ptr[start])) {
	    return -1;
	  }
		void * blockBuffer = malloc(BLOCK_SIZE);
		bio_read(node->direct_ptr[start], blockBuffer);
	
	
		if (written == 0) {
			if ( BLOCK_SIZE < blockOffset + size) {
			  
			  memcpy(buffer, blockBuffer + blockOffset, BLOCK_SIZE - blockOffset);			  
			  written = written + BLOCK_SIZE;
			  blockOffset = 0;		
				
			} else {			  
			  memcpy(buffer, blockBuffer + blockOffset, size);
			  written =written + size;
				
			}
		} else {
			int remaining = size - written;
			if (BLOCK_SIZE > remaining) {				
			  memcpy(buffer + written, blockBuffer, remaining);
			  written = written + remaining;
			} else {			  
			  memcpy(buffer + written, blockBuffer, BLOCK_SIZE);
			  written = written + BLOCK_SIZE;
			}	
		}
		
		start++;
		if(start >= 16){
			indirect = 1;
			start = start - 16;
		}
	}
	while (written < size) {	  
	  int indirectNum = node->indirect_ptr[(start * sizeof(int))/BLOCK_SIZE];
	  void * indirectBlock = malloc(BLOCK_SIZE);
	  if (isValid(indirectNum) == -1) {
	    return -1;
	  }
	  int blockNum = 0;
	  bio_read(indirectNum, indirectBlock);			  
	  memcpy(&blockNum, indirectBlock +((start % (BLOCK_SIZE/sizeof(int)) * sizeof(int))), sizeof(int));
	  
	  if (isValid(blockNum) == -1) {	   
	    return -1;
	  }
	  
	  void * dataReader = malloc(BLOCK_SIZE);
	  bio_read(blockNum, dataReader);
	  
	  if (written != 0) {
	    if ( BLOCK_SIZE > blockOffset + size) {	      
	      written = written + size;
	      memcpy(buffer, dataReader + blockOffset, size);	      
	    } else {
	      memcpy(buffer, dataReader + blockOffset, BLOCK_SIZE - blockOffset);
	      written = written + BLOCK_SIZE;
	      blockOffset = 0;		
	    }
	  } else {
	    int remaining = size - written;
	    if (remaining > BLOCK_SIZE) {
	      memcpy(buffer + written, dataReader, BLOCK_SIZE);
	      written = written + BLOCK_SIZE;
	    } else {
	      memcpy(buffer + written, dataReader, remaining);
	      written = written + remaining;
	    }	
	  }
	  blockOffset = 0;	
	  start = start +1 ;
	}
	free(node);
	// Note: this function should return the amount of bytes you copied to buffer
	return size;
}

static int tfs_write(const char *path, const char *buffer, size_t size, off_t offset, struct fuse_file_info *fi) {
	// Step 1: You could call get_node_by_path() to get inode from path
	struct inode * node = malloc(sizeof(struct inode));
	
	int success = get_node_by_path(path, 0, node);
	if (success == -1) {
	  return -1;	
	}
	int indirect = 0;
	int start = offset / BLOCK_SIZE;
	if((16+8*(BLOCK_SIZE/sizeof(int))) - start < (size/BLOCK_SIZE) +1){	  
	  return -1;
	}	
	
	if(start >= 16) {	  
	  start = start - 16;
	  indirect = 1;
	}
	
	int blockOffset = offset % BLOCK_SIZE;
	int written = 0;
	// Step 2: Based on size and offset, read its data blocks from disk
	while (written < size && indirect == 0) {
		int blockNum = node->direct_ptr[start];
		if (isValid(blockNum) == -1) {
		  blockNum = get_avail_blkno();
		  if(blockNum == -1){			  
		    return -1;
		  }
		  blockNum = blockNum + super->d_start_blk;
		  int remaining = size - written;
		  if (remaining < BLOCK_SIZE) {
		    node->size = node->size + remaining;
		  } else {
		    node->size = node->size + BLOCK_SIZE;
		  }		  
		  node->direct_ptr[start] = blockNum;
		} 
		void * blockReader = malloc(BLOCK_SIZE);
		bio_read(blockNum, blockReader);		
		if (written == 0) {		  
		  if ( BLOCK_SIZE > blockOffset +size) {
		    memcpy(blockReader + blockOffset, buffer, size);
		    written = written + size;
		  } else {
		    memcpy(blockReader + blockOffset, buffer, BLOCK_SIZE - blockOffset);				
		    written  = written + BLOCK_SIZE;
		    blockOffset = 0;		
		  }
		} else {
		  int remaining = size - written;
		  if (BLOCK_SIZE < remaining) {		  
		    memcpy(blockReader, buffer + written, BLOCK_SIZE);
		    written = written + BLOCK_SIZE;
		  } else {
		    memcpy(blockReader, buffer + written, remaining);
		    written = written + remaining;
		  }	
		}		
		
		bio_write(blockNum, blockReader);
		start++;
		if(start >= 16 && indirect == 0){			
			start = start - 16;
			indirect = 1;
		}
	}
	
	while (written < size) {
		int indirectNum = node->indirect_ptr[(start * sizeof(int))/BLOCK_SIZE];
		if (isValid(indirectNum) == -1 ) {
			indirectNum = get_avail_blkno();
			if(indirectNum == -1) {				
				return -1;
			}
			indirectNum = indirectNum + super->d_start_blk;
			node->indirect_ptr[(start * sizeof(int))/BLOCK_SIZE] = indirectNum;			
			void * tempReader = malloc(BLOCK_SIZE);
			bio_read(node->indirect_ptr[(start * sizeof(int))/BLOCK_SIZE], tempReader);
			memset(tempReader, 0, BLOCK_SIZE);
			bio_write(node->indirect_ptr[(start * sizeof(int))/BLOCK_SIZE], tempReader);
			free(tempReader);
		} 		
		void * indirectBlock = malloc(BLOCK_SIZE);
		bio_read(indirectNum, indirectBlock);		
		int blockNum = 0;
		memcpy(&blockNum, indirectBlock + ((start % (BLOCK_SIZE/sizeof(int))) * sizeof(int)), sizeof(int));		
		if (isValid(blockNum) == -1) {
		  blockNum = get_avail_blkno();
		  if(blockNum == -1){			
		    return -1;
		  }
		  blockNum = blockNum + super->d_start_blk;
		  int remaining = size - written;
		  if (BLOCK_SIZE < remaining) {
		    node->size = node->size + BLOCK_SIZE;
		  } else {
		    node->size = node->size + remaining;
		  }
		  memcpy(indirectBlock + ((start % (BLOCK_SIZE/sizeof(int)))*sizeof(int)), &blockNum, sizeof(int));
		}
		bio_write(indirectNum, indirectBlock);
		void * dataReader = malloc(BLOCK_SIZE);	
		bio_read(blockNum, dataReader);
		
		if (written == 0) {
			if(BLOCK_SIZE > blockOffset + size) {			  
			  written = written + size;
			  memcpy(dataReader + blockOffset, buffer, size);
			} else {
			  written = written + BLOCK_SIZE;
			  memcpy(dataReader + blockOffset, buffer, BLOCK_SIZE - blockOffset);
			  blockOffset = 0;		
			}
		} else {
			int remaining = size - written;
			if (BLOCK_SIZE < remaining) {
			  written = written + BLOCK_SIZE;
			  memcpy(dataReader, buffer + written, BLOCK_SIZE);				
			} else {
			  written = written + remaining;
			  memcpy(dataReader, buffer + written, remaining);
			}	
		}			
		blockOffset = 0;
		bio_write(blockNum, dataReader);
		start++;
	}
	
	writei(node->ino, node);	
	free(node);
	// Note: this function should return the amount of bytes you write to disk
	return size;
}

static int tfs_unlink(const char *path) {

	// Step 1: Use dirname() and basename() to separate parent directory path and target file name
	char * parentPath = dirname(strdup(path));
	char * targetName = basename(strdup(path));

	// Step 2: Call get_node_by_path() to get inode of target file
	struct inode * targetInode = malloc(sizeof(struct inode));
	if (get_node_by_path(path, 0, targetInode) != 0 || targetInode->type != 2){
		return -1;
	}

	// Step 3: Clear data block bitmap of target file
	unsigned char bitmapReader[BLOCK_SIZE];       
	bio_read(super->d_bitmap_blk, bitmapReader);
	char dataReader[BLOCK_SIZE];
	int x;
	for (x = 0; x < 16; x++) {	
		if (isValid(targetInode->direct_ptr[x]) == -1) {
			continue;
		}
		bio_read(targetInode->direct_ptr[x], dataReader);
		memset(dataReader, 0, BLOCK_SIZE);
		bio_write(targetInode->direct_ptr[x], dataReader);
		int blockNumber = targetInode->direct_ptr[x];
		targetInode->direct_ptr[x] = 0;
		unset_bitmap((bitmap_t)bitmapReader, blockNumber - super->d_start_blk);
	}	
  	for (x = 0; x < 8; x++) {
		
	  if (isValid(targetInode->indirect_ptr[x]) == -1) {
			break;
		}
		
		//DO THE SAME TO INDIRECT BLOCKS
		void * indirectReader = malloc(BLOCK_SIZE);
		bio_read(targetInode->indirect_ptr[x], indirectReader);
		int blockNumber = targetInode->indirect_ptr[x];
		targetInode->indirect_ptr[x] = 0;
		unset_bitmap((bitmap_t)bitmapReader, blockNumber - super->d_start_blk);
		int y;
		for (y = 0; y < (BLOCK_SIZE / sizeof(int)); y++) {
			int dataBlock = 0;
			memcpy(&dataBlock, indirectReader + (y * sizeof(int)), sizeof(int));
			if (isValid(dataBlock) == -1) {
				break;
			}
			void * readInto = malloc(BLOCK_SIZE);	        
			bio_read(dataBlock, readInto);
			memset(readInto, 0, BLOCK_SIZE);
			unset_bitmap((bitmap_t)bitmapReader, dataBlock - super->d_start_blk);					
			bio_write(dataBlock, readInto);
		}
		bio_write(blockNumber, indirectReader);
	}	
	bio_write(super->d_bitmap_blk, bitmapReader);
	
	// Step 4: Clear inode bitmap and its data block
	targetInode->type = 0;
	targetInode->link = 0;
	targetInode->valid = 0;		
	bio_read(super->i_bitmap_blk, bitmapReader);
	unset_bitmap((bitmap_t)bitmapReader, targetInode->ino);
	bio_write(super->i_bitmap_blk, bitmapReader);
	// Step 5: Call get_node_by_path() to get inode of parent directory
	if (get_node_by_path(parentPath, 0, targetInode) != 0 || targetInode->type != 1) {
		return -1;
	}

	// Step 6: Call dir_remove() to remove directory entry of target directory in its parent directory
	dir_remove(*targetInode, targetName, strlen(targetName));
	return 0;
}

static int tfs_truncate(const char *path, off_t size) {
	// For this project, you don't need to fill this function
	// But DO NOT DELETE IT!
    return 0;
}

static int tfs_release(const char *path, struct fuse_file_info *fi) {
	// For this project, you don't need to fill this function
	// But DO NOT DELETE IT!
	return 0;
}

static int tfs_flush(const char * path, struct fuse_file_info * fi) {
	// For this project, you don't need to fill this function
	// But DO NOT DELETE IT!
    return 0;
}

static int tfs_utimens(const char *path, const struct timespec tv[2]) {
	// For this project, you don't need to fill this function
	// But DO NOT DELETE IT!
    return 0;
}


static struct fuse_operations tfs_ope = {
	.init		= tfs_init,
	.destroy	= tfs_destroy,

	.getattr	= tfs_getattr,
	.readdir	= tfs_readdir,
	.opendir	= tfs_opendir,
	.releasedir	= tfs_releasedir,
	.mkdir		= tfs_mkdir,
	.rmdir		= tfs_rmdir,

	.create		= tfs_create,
	.open		= tfs_open,
	.read 		= tfs_read,
	.write		= tfs_write,
	.unlink		= tfs_unlink,

	.truncate   = tfs_truncate,
	.flush      = tfs_flush,
	.utimens    = tfs_utimens,
	.release	= tfs_release
};


int main(int argc, char *argv[]) {
	int fuse_stat;

	getcwd(diskfile_path, PATH_MAX);
	strcat(diskfile_path, "/DISKFILE");

	fuse_stat = fuse_main(argc, argv, &tfs_ope, NULL);

	return fuse_stat;
}

