#include <stdio.h> // Include standard input/output library for printf and scanf

// Function to perform insertion sort on an array
void insertionSort(int list1[], int n) {
    int i, j, value; // Declare loop counters and current key value
    for (i = 1; i < n; i++) { // Iterate through unsorted elements starting from index 1
        value = list1[i]; // Store current element to be positioned
        j = i - 1; // Start comparison with element directly to the left
        while (j >= 0 && list1[j] > value) { // Shift elements greater than value to one position ahead
            list1[j + 1] = list1[j]; // Shift element to the right
            j = j - 1; // Move pointer to the left
        }
        list1[j + 1] = value; // Insert value into its correct sorted position
    }
}

int main() {
    int n, i; // Declare variables for size and loop counter
    printf("Enter the number of elements in the array: "); // Prompt for array size
    scanf("%d", &n); // Read array size

    int list1[n]; // Declare array of size n
    for (i = 0; i < n; i++) { // Loop to read array elements
        printf("Enter the number to be inserted in the array: "); // Prompt for each element
        scanf("%d", &list1[i]); // Read element into list1 array
    }

    insertionSort(list1, n); // Sort the array using Insertion Sort

    printf("Sorted Array in Ascending Order:\n"); // Header for output
    for (i = 0; i < n; i++) { // Print each sorted element
        printf("%d ", list1[i]);
    }
    printf("\n");

    return 0; // Return success status
}

/*
CODE FLOW:
1. `main` prompts the user for the number of elements `n` and fills the array `list1` with user inputs.
2. `insertionSort(list1, n)` is called:
   - The outer loop variable `i` starts from index 1 up to `n - 1`, treating `list1[0]` as an initially sorted sub-array.
   - The current element `list1[i]` is stored in `value`.
   - The inner `while` loop checks preceding elements from `j = i - 1` down to 0.
   - Any element greater than `value` is shifted one position to the right (`list1[j + 1] = list1[j]`).
   - When an element smaller than or equal to `value` (or index -1) is reached, `value` is placed at `list1[j + 1]`.
3. After completing all iterations, `main` prints the final sorted array.

SUMMARY:
This program implements the Insertion Sort algorithm in C. Insertion Sort builds the sorted array one item at a time by repeatedly taking the next element and inserting it into its proper place among the previously sorted elements. It is an in-place, stable comparison sort with best-case time complexity of O(n) for already sorted arrays, average/worst-case time complexity of O(n^2), and auxiliary space complexity of O(1).
*/
