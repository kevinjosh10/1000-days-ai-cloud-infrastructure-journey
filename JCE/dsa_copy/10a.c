#include <stdio.h> // Include standard input/output library for printf and scanf

// Function to perform linear search on an array
int linearSearch(int arr[], int n, int x) {
    for (int i = 0; i < n; i++) { // Loop sequentially through each index of the array
        if (arr[i] == x) { // Check if the current element matches the target element x
            return i; // Return the 0-based index where the element is found
        }
    }
    return -1; // Return -1 if the target element was not found in the entire array
}

int main() {
    int n, x; // Declare variables for array size and target element
    printf("Enter number of elements in array: "); // Prompt for number of elements
    scanf("%d", &n); // Read size of array

    int arr[n]; // Declare array of size n
    for (int i = 0; i < n; i++) { // Loop to read elements into the array
        printf("Enter number to be inserted in array: "); // Prompt for each element
        scanf("%d", &arr[i]); // Read each integer into array
    }

    printf("Enter the number to be searched: "); // Prompt for search key
    scanf("%d", &x); // Read target element to search for

    int found = linearSearch(arr, n, x); // Call linear search function
    if (found == -1) { // If return value is -1, element does not exist
        printf("Element not found\n");
    } else { // Otherwise, print the 1-based position where element was located
        printf("Element found at position: %d\n", found + 1);
    }

    return 0; // Return success status
}

/*
CODE FLOW:
1. `main` prompts the user for the number of elements `n` and fills the array `arr` with user inputs.
2. The user is prompted to enter the search key `x`.
3. `linearSearch(arr, n, x)` is invoked:
   - A `for` loop iterates through each element from index 0 to `n - 1`.
   - At each iteration, `arr[i]` is compared against `x`.
   - If a match is found (`arr[i] == x`), the index `i` is immediately returned.
   - If the loop finishes without finding `x`, `-1` is returned.
4. If `-1` is returned, "Element not found" is printed. Otherwise, "Element found at position: " followed by `found + 1` (1-based position) is printed.

SUMMARY:
This program implements Linear Search (Sequential Search) in C. Linear Search works on both sorted and unsorted collections by comparing the search target sequentially against each element from the beginning to the end. It has a best-case time complexity of O(1) (target at first position), an average and worst-case time complexity of O(n) (target at end or not present), and auxiliary space complexity of O(1).
*/
