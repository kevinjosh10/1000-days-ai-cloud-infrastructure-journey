#include <stdio.h> // Include Standard I/O library
#include <conio.h> // Include console I/O for clrscr() and getch() (Turbo C environment)
#include <stdlib.h> // Include standard library for malloc() and exit()

struct node { // Define a node structure for the linked list
    int data; // Data payload
    struct node *next; // Pointer to the next node below it in the stack
} *head, *newnode, *temp, *del, *top; // Declare global pointers for list management

int count = 0; // Global variable to track the size of the stack

void create() { // Initialize the stack
    head = (struct node *)malloc(sizeof(struct node)); // Allocate a dummy head node
    head->next = NULL; // Head points to nothing initially
    top = NULL; // Top of stack is empty
}

void push() { // Function to push a new element onto the stack
    newnode = (struct node *)malloc(sizeof(struct node)); // Dynamically allocate memory for new node
    printf("Enter the element to be pushed : ");
    scanf("%d", &newnode->data); // Read data from user into the new node
    
    // Insert at the beginning of the linked list (immediately after dummy head)
    newnode->next = head->next; // New node points to what head was pointing to (the old top)
    head->next = newnode; // Head now points to the new node
    top = newnode; // Update top pointer to the new node
    count++; // Increment stack size
}

int pop() { // Function to remove the top element
    if (top == NULL) { // Check for Stack Underflow (empty stack)
        printf("Stack is empty!! Stack underflow error !!! \n");
        return 0;
    }
    
    // Remove from the beginning of the linked list
    del = head->next; // 'del' points to the first actual node (the top)
    head->next = del->next; // Head bypasses 'del' and points to the second node
    top = head->next; // Update top pointer to the new first node
    count--; // Decrement stack size
    return (del->data); // Return the data of the deleted node
    // Memory leak note: free(del) is missing in this lab code, but logically it is removed from the chain.
}

void display() { // Function to display the stack contents
    temp = head; // Start at the dummy head
    printf("Elements in stack : HEAD ");
    while(temp->next != NULL) { // Traverse until the end
        temp = temp->next; // Move to next node
        printf("-> %d ", temp->data); // Print node data
    }
    printf("-> NULL ");
    printf("\nNo of elements = %d \n", count); // Print total count
}

void main() { // Main execution block
    int option, x;
    clrscr(); // Clear the console screen
    printf("\n ***-*-*-* STACK USING LINKED LIST *-*-*-*-* \n");
    create(); // Call create to set up dummy head
    
    do { // Menu loop
        printf("\n MENU : 1.Push  2.Pop  3.Exit ");
        printf("\n Enter your option : ");
        scanf("%d", &option);
        
        switch(option) { // Handle user choice
            case 1: 
                push(); // Execute push operation
                display(); // Show updated stack
                break;
            case 2: 
                x = pop(); // Execute pop operation and capture returned data
                if (x != 0) // If pop was successful (not underflow)
                    printf("The Popped element = %d \n", x);
                display(); // Show updated stack
                break;
            case 3: 
                exit(0); // Terminate program
            default: 
                printf("\n Wrong choice ! Try again... \n"); 
        }
    } while (option != 3); // Loop until user chooses exit
    getch(); // Wait for user keystroke before closing window
}

/*
CODE FLOW:
1. Program execution begins in `main()`. Global pointers (`head`, `top`, etc.) are declared.
2. `create()` is called, which uses `malloc` to create a dummy `head` node. `top` is initialized to `NULL`.
3. The menu loop runs. If the user selects Push (1), the `push()` function executes.
4. In `push()`, a `newnode` is allocated. Its `next` pointer is linked to `head->next` (the current top), and `head->next` is redirected to the `newnode`. This ensures new elements are always added to the "front" of the list, representing the Top of the stack (LIFO).
5. If the user selects Pop (2), the `pop()` function executes. It verifies `top != NULL`.
6. In `pop()`, the node immediately following the dummy `head` (`head->next`) is isolated into the `del` pointer. The list is re-linked by setting `head->next = del->next`, effectively bypassing the top node and making the second node the new top. It returns `del->data`.
7. `display()` simply starts at `head` and prints the whole chain sequentially.

SUMMARY:
This C program implements a Stack Data Structure using a Singly Linked List.
Unlike an array-based stack which has a fixed maximum size (leading to potential overflow), a linked-list stack grows dynamically in memory using `malloc()`.
The program enforces the LIFO principle by inserting new nodes at the head of the list (Push) and deleting nodes from the head of the list (Pop), ensuring O(1) time complexity for both operations.
*/
