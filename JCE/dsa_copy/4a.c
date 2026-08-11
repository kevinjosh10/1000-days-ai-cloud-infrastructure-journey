#include <stdio.h> // Include standard I/O library
#define SIZE 10 // Define macro for maximum queue size

int queue[SIZE]; // Global array to hold queue elements
int front = -1; // Index of the front element (used for dequeue)
int rear = -1; // Index of the rear element (used for enqueue)

void display(); // Function prototype for display
int underflow(); // Function prototype to check if empty
int overflow(); // Function prototype to check if full
void enqueue(int); // Function prototype to add element
void dequeue(); // Function prototype to remove element

void display() { // Function to print the queue
    int i;
    if (front == -1) { // If front is -1, queue is empty
        printf("\nQueue is empty\n");
        return;
    }
    printf("\nQueue elements are:\n");
    for (i = front; i <= rear; i++) { // Loop from front index to rear index
        printf("%d ", queue[i]); // Print each element
    }
    printf("\n");
}

int underflow() { // Check for empty queue
    // Queue is empty if front is still -1, or if front has surpassed rear after dequeues
    if (front == -1 || front > rear) { 
        return 1; // Return 1 (true) for underflow
    }
    return 0; // Return 0 (false)
}

int overflow() { // Check for full queue
    if (rear == SIZE - 1) { // If rear has reached the last index of the array
        return 1; // Return 1 (true) for overflow
    }
    return 0; // Return 0 (false)
}

void enqueue(int item) { // Add element to the back of the queue
    if (overflow() == 1) { // Check if full
        printf("\nQueue is full\n");
        return;
    }
    if (front == -1) { // If this is the very first element being inserted
        front = 0; // Initialize front to 0
    }
    rear = rear + 1; // Increment rear index
    queue[rear] = item; // Insert item at the new rear index
    printf("\nElement %d inserted into queue\n", item);
}

void dequeue() { // Remove element from the front of the queue
    if (underflow() == 1) { // Check if empty
        printf("\nQueue is empty\n");
        return;
    }
    printf("\nElement %d deleted from queue\n", queue[front]); // The element at 'front' is the one to be removed
    front = front + 1; // Increment front index to logically remove the element
    
    // Optimization/Reset: If the queue is logically empty after this dequeue, reset indices
    if (front > rear) { 
        front = -1;
        rear = -1;
    }
}

int main() { // Main execution block
    int choice;
    int item;
    
    printf("\nQUEUE OPERATIONS USING ARRAY");
    
    while (1) { // Infinite menu loop
        printf("\n1. Enqueue\n2. Dequeue\n3. Display\n4. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice); // Read user choice
        
        switch (choice) {
            case 1:
                printf("\nEnter the item to be inserted: ");
                scanf("%d", &item);
                enqueue(item); // Call enqueue
                break;
            case 2:
                dequeue(); // Call dequeue
                break;
            case 3:
                display(); // Call display
                break;
            case 4:
                return 0; // Terminate program
            default:
                printf("\nInvalid choice! Please enter a valid choice (1/2/3/4)\n");
        }
    }
    return 0;
}

/*
CODE FLOW:
1. Program starts in `main()`. Global array `queue[10]` and pointers `front` & `rear` are initialized to -1.
2. An infinite menu loop accepts user commands.
3. If Enqueue (1) is selected, `enqueue(item)` is called. It first checks `overflow()` to ensure `rear < 9`. If it's the first element, `front` is set to 0. `rear` is incremented by 1, and the `item` is placed at `queue[rear]`.
4. If Dequeue (2) is selected, `dequeue()` is called. It checks `underflow()`. It then reads and prints `queue[front]` (the oldest element). 
5. To remove it, `front` is simply incremented by 1. The data stays in the array, but it is logically ignored. If `front` exceeds `rear`, the queue is empty, and both are reset to -1.
6. Display (3) iterates a `for` loop starting from `front` up to `rear`, printing the valid active elements in the queue.

SUMMARY:
This C program implements a Linear Queue Data Structure using a static array.
A queue operates on the First-In-First-Out (FIFO) principle.
Elements are always added at the back (managed by the `rear` index) and removed from the front (managed by the `front` index). This simulates a real-world waiting line.
*/
