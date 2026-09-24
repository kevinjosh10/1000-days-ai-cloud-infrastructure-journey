#include <stdio.h> // Include standard input/output library for printf and scanf
#include <stdlib.h> // Include standard library for exit()

#define TABLE_SIZE 10 // Define the hash table capacity

int h[TABLE_SIZE] = {0}; // Global hash table array initialized to 0 (empty slots)

// Function to insert an element using quadratic probing
void insert() {
    int key, index, i, hkey; // Declare key, probe index, loop counter, and primary hash key
    printf("\n Enter a value to insert into hash table \n"); // Prompt user for value
    scanf("%d", &key); // Read integer key
    hkey = key % TABLE_SIZE; // Compute base hash key using remainder method
    for (i = 0; i < TABLE_SIZE; i++) { // Probe up to TABLE_SIZE iterations
        index = (hkey + i * i) % TABLE_SIZE; // Quadratic probing formula: (hkey + i^2) % TABLE_SIZE
        if (h[index] == 0) { // If slot at index is unoccupied
            h[index] = key; // Place key in this slot
            break; // Exit loop after successful placement
        }
    }
    if (i == TABLE_SIZE) { // If all TABLE_SIZE probes failed (table is full or probe cycle exhausted)
        printf("\n Element cannot be inserted \n"); // Print error message
    }
}

// Function to search for an element using quadratic probing
void search() {
    int key, index, i, hkey; // Declare helper variables
    printf("\n Enter search element \n"); // Prompt for target key
    scanf("%d", &key); // Read target key
    hkey = key % TABLE_SIZE; // Compute base hash key
    for (i = 0; i < TABLE_SIZE; i++) { // Probe through quadratic sequence
        index = (hkey + i * i) % TABLE_SIZE; // Compute probe index: (hkey + i^2) % TABLE_SIZE
        if (h[index] == key) { // Check if slot holds the target key
            printf("Value is found at index %d\n", index); // Print index where found
            break; // Exit search
        }
    }
    if (i == TABLE_SIZE) { // If element was not found in probe sequence
        printf("\n Value is not found \n"); // Print not found message
    }
}

// Function to display the entire hash table
void display() {
    int i; // Loop counter
    printf("\n Elements in the hash table are \n"); // Header
    for (i = 0; i < TABLE_SIZE; i++) { // Iterate through each slot of the table
        printf("\n At index %d \t value = %d", i, h[i]); // Print index and its stored value
    }
}

int main() {
    int opt; // Variable to store user menu choice
    while (1) { // Infinite menu loop
        printf("\n Press 1. Insert \t 2. Display \t 3. Search \t 4. Exit \n"); // Print menu options
        printf("Enter choice: "); // Prompt for option
        scanf("%d", &opt); // Read option
        switch (opt) { // Branch based on choice
            case 1:
                insert(); // Call insert operation
                break;
            case 2:
                display(); // Call display operation
                break;
            case 3:
                search(); // Call search operation
                break;
            case 4:
                exit(0); // Terminate the program
        }
    }
    return 0; // Return success status
}

/*
CODE FLOW:
1. The global array `h` of size `TABLE_SIZE = 10` is initialized to 0.
2. A menu-driven `while(1)` loop prompts the user to select Insert (1), Display (2), Search (3), or Exit (4).
3. In `insert()`:
   - Base hash index is calculated as `hkey = key % TABLE_SIZE`.
   - A `for` loop checks positions `index = (hkey + i * i) % TABLE_SIZE` for `i = 0, 1, 2, ...`.
   - If an empty slot (`h[index] == 0`) is found, `key` is stored there and the loop terminates.
   - If `i == TABLE_SIZE`, "Element cannot be inserted" is displayed.
4. In `search()`:
   - Probes the quadratic sequence `(hkey + i * i) % TABLE_SIZE`.
   - If `h[index] == key`, prints the index where the value is located.
   - If not found after `TABLE_SIZE` checks, prints "Value is not found".
5. In `display()`:
   - Prints each index from 0 to 9 alongside its value.

SUMMARY:
This program implements an Open Addressing Hash Table using Quadratic Probing in C. Unlike Linear Probing which increments linearly by `i`, Quadratic Probing computes new hash locations using an offset of `i^2`: `(h(k) + i^2) % TABLE_SIZE`. This reduces primary clustering (the tendency for filled slots to form long continuous blocks), providing more uniform distribution across the table with average O(1) time complexity for lookup and insertion.
*/
