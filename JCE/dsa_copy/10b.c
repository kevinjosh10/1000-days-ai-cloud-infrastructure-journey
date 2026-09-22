#include <stdio.h> // Include standard input/output library for printf and scanf

// Helper function to sort the array before performing binary search
void sort(int arr[], int n) {
    int temp; // Temporary variable used for swapping elements
    for (int i = 0; i < n - 1; i++) { // Outer pass loop
        for (int j = 0; j < n - 1 - i; j++) { // Inner comparison loop
            if (arr[j] > arr[j + 1]) { // If current element is greater than next element, swap
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

// Function to perform binary search on a sorted array
int binarySearch(int arr[], int n, int x) {
    int low = 0; // Initialize lower bound pointer to first index
    int high = n - 1; // Initialize upper bound pointer to last index
    
    while (low <= high) { // Continue search while the search range is valid
        int mid = (low + high) / 2; // Calculate the midpoint index
        
        if (arr[mid] < x) { // If target value is greater than middle element
            low = mid + 1; // Discard left half by shifting lower bound past mid
        } else if (arr[mid] > x) { // If target value is smaller than middle element
            high = mid - 1; // Discard right half by shifting upper bound before mid
        } else { // Target value matches middle element
            return mid; // Return the index of found element
        }
    }
    return -1; // Return -1 if search element is not found
}

int main() {
    int n, x; // Declare variables for array size and search element
    printf("Enter the number of elements in the array: "); // Prompt for size of array
    scanf("%d", &n); // Read size of array

    int arr[n]; // Declare array of size n
    for (int i = 0; i < n; i++) { // Loop to read array elements
        printf("Enter number to be inserted in the array: "); // Prompt for each element
        scanf("%d", &arr[i]); // Read each integer into array
    }

    sort(arr, n); // Sort the array to satisfy Binary Search prerequisite

    for (int i = 0; i < n; i++) { // Display sorted array
        printf("%d ", arr[i]);
    }
    printf("\n");

    printf("Enter number to be searched: "); // Prompt for search element
    scanf("%d", &x); // Read target element

    int found = binarySearch(arr, n, x); // Call binary search function
    if (found == -1) { // Check if element was not found
        printf("Element not found\n");
    } else { // Element found
        printf("Element found at index: %d\n", found + 1); // Print 1-based index
    }

    return 0; // Return success status
}

/*
CODE FLOW:
1. `main` takes the number of elements `n` and array values from the user.
2. `sort(arr, n)` sorts the input array in ascending order because Binary Search requires a sorted collection.
3. The sorted array is printed to the console.
4. The user is prompted to enter the search element `x`.
5. `binarySearch(arr, n, x)` runs:
   - Sets `low = 0` and `high = n - 1`.
   - In each iteration of `while (low <= high)`, calculates `mid = (low + high) / 2`.
   - Compares `arr[mid]` with `x`:
     - If `arr[mid] == x`, returns `mid`.
     - If `arr[mid] < x`, sets `low = mid + 1` (search right half).
     - If `arr[mid] > x`, sets `high = mid - 1` (search left half).
   - If `low > high`, the loop terminates and returns `-1`.
6. `main` outputs "Element not found" or "Element found at index: " with the 1-based position.

SUMMARY:
This program implements Binary Search in C. Binary Search is a divide-and-conquer algorithm designed for sorted arrays. In each step, it compares the target key to the middle element, eliminating half of the remaining search space. Its time complexity is O(log n) in the average and worst case, with O(1) best-case time complexity and O(1) auxiliary space complexity.
*/
