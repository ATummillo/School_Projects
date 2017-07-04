/* 
 * Skeleton code for prodcons implementation
 * (C) Mohammad H. Mofrad, 2017  
 *
 */
#ifndef PRODCONS_H_INCLUDED
#define PRODCONS_H_INCLUDED


#include <asm/errno.h>
#include <asm/unistd.h>
#include <asm/mman.h>

#define MAP_SIZE 0x00000FFF

typedef struct Node{				//Node struct typedefined to Node
	struct task_struct *task;
	struct Node *next;
}Node;

struct cs1550_sem					//Struct for semaphore with head
{									//representing the front of a 
   int value;						//FIFO queue and tail the end of the
   struct Node* head;				//queue
   struct Node* tail;
};

int toASCII(int c);							//Method used to get appropriate ASCII
											//characters
void  cs1550_down(struct cs1550_sem *);
void  cs1550_up  (struct cs1550_sem *);

#endif
