#include <stdio.h> // Include standard input/output library for printf and scanf

// Function to perform selection sort
void selectionSort(int array[], int size) {
    int step, i, min_idx, temp; // Declare loop counters and helper variables
    for (step = 0; step < size; step++) { // Iterate through each boundary of unsorted subarray
        min_idx = step; // Assume first element of unsorted section is the minimum
        for (i = step + 1; i < size; i++) { // Search remaining unsorted elements
            // to sort in descending order, change > to < in this line
            // select the minimum element in each loop
            if (array[i] < array[min_idx]) { // Check if smaller element is found
                min_idx = i; // Update index of current minimum
            }
        }
        // put min at correct position by swapping
        temp = array[step]; // Store current step element in temp
        array[step] = array[min_idx]; // Place smallest element at current step position
        array[min_idx] = temp; // Put replaced element at old min_idx position
    }
}

int main() {
    int n, i; // Declare variables for size and counter
    printf("Enter the number of elements in the array: "); // Prompt for number of elements
    scanf("%d", &n); // Read number of elements

    int data[n]; // Declare array of size n
    for (i = 0; i < n; i++) { // Loop to read elements
        printf("Enter the number to be inserted in the array: "); // Prompt for each element
        scanf("%d", &data[i]); // Read element into data array
    }

    selectionSort(data, n); // Sort the array using Selection Sort

    printf("Sorted Array in Ascending Order:\n"); // Header for output
    for (i = 0; i < n; i++) { // Print each sorted element
        printf("%d ", data[i]);
    }
    printf("\n");

    return 0; // Return success status
}

/*
CODE FLOW:
1. `main` asks user for number of elements `n` and fills array `data` with input values.
2. `selectionSort(data, n)` is called:
   - Outer loop `step` advances from 0 to `size - 1`.
   - `min_idx` is initially set to `step`.
   - Inner loop searches all subsequent positions `step + 1` to `size - 1` to locate the minimum value.
   - If a smaller value is found at index `i`, `min_idx` becomes `i`.
   - The element at `step` and the element at `min_idx` are swapped.
3. `main` prints the resulting array in ascending sorted order.

SUMMARY:
This program implements Selection Sort in C. It continuously finds the minimum element from the unsorted portion of an array and swaps it with the first unsorted element, growing the sorted portion one element per pass. Time complexity is O(n^2) and auxiliary space complexity is O(1).
*/
