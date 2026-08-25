#include <stdio.h> // Include standard I/O library
#include <stdlib.h> // Include standard library for malloc and free

typedef struct element { // Define a structure for linked list nodes
    int item; // Data payload
    struct element *next; // Pointer to the next node in the queue
} element;

typedef struct queue { // Define a structure to hold the queue pointers
    element *front; // Pointer to the front (head) of the queue (where we dequeue)
    element *rear;  // Pointer to the rear (tail) of the queue (where we enqueue)
} queue;

void enqueue(int item, queue *q) { // Add an element to the rear of the queue
    element *e = (element *)malloc(sizeof(element)); // Allocate dynamic memory for new node
    e->item = item; // Assign data
    e->next = NULL; // New node will be at the end, so its next is NULL
    
    if (q->front == NULL) { // If the queue is currently empty
        q->front = e; // The new node is both the front...
        q->rear = e;  // ...and the rear
        return;
    }
    
    // If not empty, attach new node to the end of the existing chain
    q->rear->next = e; // The old rear's next points to the new node
    q->rear = e; // Update the rear pointer to be the new node
}

int dequeue(queue *q) { // Remove an element from the front of the queue
    element *e; // Temporary pointer to hold the node being deleted
    int item; // Variable to store the data being returned
    
    if (q->front == NULL) { // Check for underflow
        printf("\nQueue is empty\n");
        return 0;
    }
    
    e = q->front; // Point 'e' to the front node
    item = e->item; // Extract its data
    q->front = q->front->next; // Move the front pointer to the next node in line
    
    if (q->front == NULL) { // If the queue becomes empty after this dequeue
        q->rear = NULL; // Reset rear to NULL as well
    }
    
    free(e); // Free the memory of the removed node
    return item; // Return the extracted data
}

void display(queue *q) { // Print all elements in the queue
    element *t; // Temporary traversal pointer
    if (q->front == NULL) { // Check if empty
        printf("\nQueue is Empty\n");
    } else {
        printf("in: ");
        t = q->front; // Start from the front
        while (t->next != NULL) { // Traverse until the last node
            printf("%d -> ", t->item);
            t = t->next; // Move to next node
        }
        printf("%d -> NULL\n", t->item); // Print the last node
    }
}

int main() { // Main execution block
    int choice, value;
    queue *q = (queue *)malloc(sizeof(queue)); // Dynamically allocate the queue control structure
    q->front = q->rear = NULL; // Initialize queue to be empty
    
    printf("\n:: Queue using Linked List ::\n");
    
    do { // Menu loop
        printf("\nChoose from below menu:\n");
        printf("1. Add\n2. Delete\n3. Display\n4. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                printf("Enter the value to be added: ");
                scanf("%d", &value);
                enqueue(value, q); // Call enqueue
                break;
            case 2:
                dequeue(q); // Call dequeue
                break;
            case 3:
                display(q); // Call display
                break;
            case 4:
                printf("\n\tExit POINT\n");
                break;
            default:
                printf("\n\tPlease Enter a Valid Choice (1/2/3/4)\n");
        }
    } while (choice != 4);
    
    return 0; // Terminate program
}

/*
CODE FLOW:
1. Program execution begins in `main()`. A `queue` structure `q` is allocated in memory to hold the `front` and `rear` pointers, both initialized to `NULL`.
2. A do-while menu loop begins. 
3. If Enqueue (1) is called, `malloc` creates a new node `e`. If the queue is empty, both `q->front` and `q->rear` are set to `e`. Otherwise, the new node is attached to the end using `q->rear->next = e`, and the `q->rear` pointer is updated to this new node.
4. If Dequeue (2) is called, the program checks if `q->front` is NULL. If not, it isolates the front node into a temporary pointer `e`. The queue's front is advanced using `q->front = q->front->next`. The isolated node `e` is then destroyed using `free(e)` to prevent memory leaks.
5. Display (3) traverses the linked list from `q->front` to the end, printing each node's data.

SUMMARY:
This C program implements a Queue Data Structure using a Singly Linked List.
Using a linked list removes the rigid size limitations of array-based queues. 
It maintains two distinct pointers: `front` (where Dequeue operations occur) and `rear` (where Enqueue operations occur). This design guarantees O(1) time complexity for both adding and removing elements, perfectly simulating the FIFO model.
*/
