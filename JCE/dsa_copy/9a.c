#include <stdio.h> // Include standard input/output library for printf and scanf

// Function to perform bubble sort on an array
void bubbleSort(int list1[], int n) {
    int i, j, temp; // Declare loop counters and temporary swap variable
    for (i = 0; i < n - 1; i++) { // Loop for passes through the array
        for (j = 0; j < n - 1; j++) { // Inner loop to compare adjacent elements
            if (list1[j] > list1[j + 1]) { // Compare adjacent elements
                temp = list1[j]; // Store current element in temp
                list1[j] = list1[j + 1]; // Move next element to current position
                list1[j + 1] = temp; // Place temp in next position (swap)
                
                printf("The intermediate list is: "); // Print intermediate message
                for (int k = 0; k < n; k++) { // Loop to print intermediate array state
                    printf("%d ", list1[k]);
                }
                printf("\n"); // Newline after each intermediate step
            }
        }
    }
}

int main() {
    int n, i; // Declare variables for size and counter
    printf("Enter the number of elements in the array: "); // Prompt for array size
    scanf("%d", &n); // Read array size

    int list1[n]; // Declare array of size n
    for (i = 0; i < n; i++) { // Loop to read array elements
        printf("Enter the number to be inserted in array: "); // Prompt for each element
        scanf("%d", &list1[i]); // Read each element
    }

    printf("The unsorted list is: "); // Display unsorted list
    for (i = 0; i < n; i++) {
        printf("%d ", list1[i]);
    }
    printf("\n");

    bubbleSort(list1, n); // Call bubble sort function

    printf("The sorted list is: "); // Display sorted list
    for (i = 0; i < n; i++) {
        printf("%d ", list1[i]);
    }
    printf("\n");

    return 0; // Return success status
}

/*
CODE FLOW:
1. `main` prompts the user for array length `n` and allocates an array `list1` of size `n`.
2. Array elements are populated via user input using `scanf`.
3. The initial unsorted array is printed to the console.
4. `bubbleSort(list1, n)` runs:
   - Outer loop iterates through `n - 1` passes.
   - Inner loop compares adjacent pairs `list1[j]` and `list1[j + 1]`.
   - If `list1[j] > list1[j + 1]`, elements are swapped and the entire intermediate array is printed.
5. Once all iterations complete, `main` prints the final sorted array.

SUMMARY:
This program implements Bubble Sort in C. It repeatedly steps through the list, compares adjacent elements, and swaps them if they are in the wrong order. Pass after pass, the largest elements settle into their final positions at the end of the array. Time complexity is O(n^2) and auxiliary space complexity is O(1).
*/
