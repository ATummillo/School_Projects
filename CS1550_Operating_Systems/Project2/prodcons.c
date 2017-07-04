/*   Anthony Tummillo
     Project 2
     CS1550 TTh 2:30-3:45PM
     Professor Misurda */

/*   Skeleton code provided by 
     Lab TA Mohammad H. Mofrad. */

/* 
 * Skeleton code for prodcons problem
 * (C) Mohammad H. Mofrad, 2017
 *   
 */

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <linux/prodcons.h>

void *BASE_PTR;

void main(int aegc, char *argv[])
{
     if(4 != aegc){                                              //Ensure proper amount of commandline arguments
          fprintf(stderr, "Incorrect number of arguments.\n" 
               "Example: ./prodcons (# of consumers) (# of producers) (size of the buffer)");
          exit(1);
     }

     int con_count = atoi(argv[1]);                    //Convert command line input to int values
     int prod_count = atoi(argv[2]);
     int buff_size = atoi(argv[3]);

     BASE_PTR = (void *) mmap(NULL, MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, 0, 0);     //Map shared memory for processes
                                                                                                         //MAP_SIZE determined by skeleton 
                                                                                                         //from TA
     if(BASE_PTR == (void *) -1)                            //Check for proper mapping
     {
          fprintf(stderr, "Error mapping memory\n");
          exit(1);
     }
     
     int *base_ptr = BASE_PTR;
     int *new_ptr;
     int *curr_ptr = BASE_PTR;
     int size = sizeof(struct cs1550_sem);
     curr_ptr = curr_ptr + size;
     if(curr_ptr > base_ptr + MAP_SIZE)                     //Check for valid ranges on shared memory
     {
          fprintf(stderr, "Address out of range\n");
          exit(1);
     }
     else
     {
          new_ptr = curr_ptr - size;
     }
     
     struct cs1550_sem *full = (struct cs1550_sem *) new_ptr;              //Initialize semaphores at
     struct cs1550_sem *empty = (struct cs1550_sem *) new_ptr+size;        //beginning of the shared 
     struct cs1550_sem *mutex = (struct cs1550_sem *) curr_ptr+size;       //memory region

     full->value = 0;                   //Initialize semaphore values
     full->head = NULL;
     full->tail = NULL;
     empty->value = buff_size;
     empty->head = NULL;
     empty->tail = NULL;
     mutex->value = 1;
     mutex->head = NULL;
     mutex->tail = NULL;

     int *in = (int *) mutex+1;    //Shared index for producing into
     *in = 0;

     int *out = in+1;              //Shared index for consuming from
     *out = 0;

     int *buff = out+1;            //Beginning of the buffer in shared memory

     int i;
     int k;

     for(i=0; i<prod_count; i++){  //Generates producers
          if(fork() == 0){    //child
               int p_item;

               while(1){
                    cs1550_down(empty);      //Decrement empty semaphore
                    cs1550_down(mutex);      //Decrement (lock) mutex semaphore
                    
                    p_item = *in;            //p_item will always be the same as the index we are
                                             //accessing since this project requires sequential
                                             //integers to be produced
                    buff[p_item] = p_item;
                    *in = (*in+1) % buff_size;

                    printf("Producer %c Produced: %d\n", toASCII(i), p_item);

                    cs1550_up(mutex);        //Increment (unlock) mutex semaphore
                    cs1550_up(full);         //Increment full semaphore
               }
          }
     }

     for(k=0; k<con_count; k++){   //Generates consumers
          if(fork() == 0){    //child
               int c_item;

               while(1){
                    cs1550_down(full);       //Decrement full semaphore
                    cs1550_down(mutex);      //Decrement (lock) mutex semaphore

                    c_item = buff[*out];
                    *out = (*out+1) % buff_size;

                    printf("Consumer %c Consumed: %d\n", toASCII(k), c_item);

                    cs1550_up(mutex);        //Increment (unlock) mutex semaphore 
                    cs1550_up(empty);        //Increment empty semaphore
               }
          }
     }
}

int toASCII(int c){           //Adds 65 to c so that
                              //the correct process can be 
                              //represented alphabetically
     return c+65;
}

void cs1550_down(struct cs1550_sem *sem) //Wrapper for down syscall
{
     syscall(__NR_sys_cs1550_down, sem);
}

void cs1550_up(struct cs1550_sem *sem)  //Wrapper for up syscall
{
     syscall(__NR_sys_cs1550_up, sem);
}
