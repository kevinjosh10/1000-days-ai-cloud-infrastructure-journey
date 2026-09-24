#include <stdio.h> // Include standard input/output library for printf and scanf
#include <stdlib.h> // Include standard library for utility functions (like exit)

#define MAX 10 // Define the maximum size of the hash table as 10

// Function to initialize the hash table with -1 (representing empty slots)
void create(int a[]) {
    int i; // Declare loop counter
    for (i = 0; i < MAX; i++) // Iterate through all slots of the array
        a[i] = -1; // Set each slot to -1 indicating it is unoccupied
    printf("Hash table created \n"); // Print confirmation message
}

// Function to compute the hash index using linear probing formula
int hashvalue(int value, int j) {
    int hash; // Variable to store computed hash address
    hash = ((value % MAX) + j) % MAX; // Linear probing formula: (h(k) + j) % MAX
    return hash; // Return the calculated slot index
}

// Function to display the contents of the hash table
void display(int a[]) {
    int i; // Declare loop counter
    for (i = 0; i < MAX; i++) // Iterate through all table indices
        printf("%d -> %d\n", i, a[i]); // Print index and the corresponding stored value
}

// Function to insert a value into the hash table using linear probing
void insert(int a[], int value) {
    int i, j, loc, flag = 0; // Declare variables and initialize availability flag
    for (i = 0; i < MAX; i++) { // Check if at least one empty slot exists
        if (a[i] == -1) { // If an empty slot is found
            flag = 1; // Mark that space is available
            break; // Exit loop
        }
    }
    if (flag == 0) { // If no empty slot is available
        printf("Hash table full. Overflow condition \n"); // Print overflow error
        return; // Terminate function
    }
    j = 0; // Initialize collision resolution step counter
    while (1) { // Loop until value is placed in an open slot
        loc = hashvalue(value, j); // Calculate probe location for step j
        if (a[loc] == -1) { // If slot at loc is empty
            a[loc] = value; // Store the key value at loc
            printf("Value inserted \n"); // Print success message
            display(a); // Display current table state
            return; // Exit insertion
        }
        else // If collision occurs
            j++; // Increment probe sequence index and retry
    }
}

// Function to search for a value in the hash table using linear probing
void search(int a[], int value) {
    int i, j, loc, flag = 0; // Declare variables
    for (i = 0; i < MAX; i++) { // Check if hash table contains any elements
        if (a[i] != -1) { // Found at least one occupied slot
            flag = 1; // Mark table as non-empty
            break;
        }
    }
    if (flag == 0) { // If table is completely empty
        printf("Hash table empty \n"); // Print empty table message
        return;
    }
    j = 0; // Initialize probe counter
    while (j < MAX) { // Probe up to MAX times
        loc = hashvalue(value, j); // Compute probe index
        if (a[loc] == value) { // Check if slot contains the target value
            printf("Value found at position %d \n", loc); // Print found location
            return; // Exit search
        }
        else // Otherwise move to next probe
            j++;
    }
    printf("Value not found \n"); // Print failure message if probed MAX times without match
}

// Function to delete a value from the hash table
void delete(int a[], int value) {
    int i, j, loc, flag = 0; // Declare variables
    for (i = 0; i < MAX; i++) { // Check if table has any elements
        if (a[i] != -1) { // Found non-empty slot
            flag = 1;
            break;
        }
    }
    if (flag == 0) { // Table is empty
        printf("Hash table empty \n");
        return;
    }
    j = 0; // Initialize probe step
    while (j < MAX) { // Probe up to table capacity
        loc = hashvalue(value, j); // Compute location
        if (a[loc] == value) { // Target key found at loc
            a[loc] = -1; // Reset slot to -1 (marked as deleted/empty)
            printf("Value deleted \n"); // Print deletion confirmation
            display(a); // Display updated hash table
            return;
        }
        else // Move to next probe
            j++;
    }
    printf("Value not found \n"); // Target key was not found
}

int main() {
    int a[MAX], choice, key; // Declare table array and menu choice variables
    create(a); // Initialize table with empty values
    while (1) { // Infinite menu loop
        printf("\n Menu: 1. Create\n 2. Insert 3. Delete 4. Search\n 5. Exit \n"); // Display options
        printf("Enter your choice: "); // Prompt for choice
        scanf("%d", &choice); // Read user option
        switch (choice) { // Route execution based on choice
            case 1:
                create(a); // Re-initialize hash table
                break;
            case 2:
                printf("Enter value to be inserted: "); // Prompt for value
                scanf("%d", &key); // Read key
                insert(a, key); // Call insert function
                break;
            case 3:
                printf("Enter value to be deleted: "); // Prompt for value
                scanf("%d", &key); // Read key
                delete(a, key); // Call delete function
                break;
            case 4:
                printf("Enter value to be searched: "); // Prompt for search key
                scanf("%d", &key); // Read key
                search(a, key); // Call search function
                break;
            case 5:
                exit(0); // Terminate program cleanly
        }
    }
    return 0; // Return success code
}

/*
CODE FLOW:
1. `create(a)` initializes all `MAX` entries of array `a` to `-1` to represent empty slots.
2. A menu-driven `while(1)` loop presents choices to Create, Insert, Delete, Search, or Exit.
3. During Insertion:
   - Checks if at least one `-1` exists (handles overflow).
   - Computes initial index `h(k) = key % MAX`.
   - If occupied, linear probing sequentially steps `loc = (h(k) + j) % MAX` for `j = 0, 1, 2...` until an empty slot (`-1`) is found and populated.
4. During Searching and Deletion:
   - Probes up to `MAX` positions using the same sequence.
   - If `a[loc] == value`, reports the position (or sets `a[loc] = -1` for deletion).
   - If not found after `MAX` probes, reports "Value not found".

SUMMARY:
This program implements an Open Addressing Hash Table using Linear Probing for collision resolution in C. In Linear Probing, when a collision occurs at hash index `h(k)`, the algorithm checks consecutive slots `(h(k) + 1) % MAX, (h(k) + 2) % MAX, ...` in a circular manner until an empty cell is found. Hash tables provide average O(1) time complexity for insert, search, and delete operations.
*/
