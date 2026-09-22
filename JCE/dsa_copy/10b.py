def binary_search(arr, x): # Define binary_search function taking sorted array 'arr' and target value 'x'
    low = 0 # Initialize low pointer to the beginning of the array (index 0)
    high = len(arr) - 1 # Initialize high pointer to the last index of the array
    while low <= high: # Continue searching while the search space is valid
        mid = (high + low) // 2 # Calculate the middle index using integer division
        if arr[mid] < x: # If target is greater than the middle element
            low = mid + 1 # Discard left half by shifting low pointer past mid
        elif arr[mid] > x: # If target is smaller than the middle element
            high = mid - 1 # Discard right half by shifting high pointer before mid
        else: # If target equals the middle element (arr[mid] == x)
            return mid # Return the index of the found element
    return -1 # Return -1 if target element is not found in the array

arr = [] # Initialize empty list for input elements
n = int(input("Enter the number of elements in the array: ")) # Prompt for number of elements
for i in range(n): # Loop n times to collect array elements
    num = int(input("Enter number to be inserted in the array: ")) # Read each number
    arr.append(num) # Append each element to arr

arr.sort() # Sort the list in ascending order (required for binary search)
print(arr) # Print the sorted array
x = int(input("Enter number to be searched: ")) # Prompt for target search element
found = binary_search(arr, x) # Execute binary search
if (found == -1): # If returned index is -1
    print("Element not found") # Print element not found
else: # If element was found
    print("Element found at index: ", found + 1) # Print 1-based index position

'''
CODE FLOW:
1. `binary_search(arr, x)` is defined.
2. User enters number of elements `n` and each integer value into `arr`.
3. `arr.sort()` sorts the list in-place in ascending order (a mandatory prerequisite for binary search).
4. The sorted array is printed.
5. User enters target value `x`.
6. `binary_search(arr, x)` executes:
   - Sets `low = 0` and `high = len(arr) - 1`.
   - Iteratively computes `mid = (high + low) // 2`.
   - Halves the search space based on comparisons (`<`, `>`, `==`).
   - Returns `mid` if found, or `-1` if `low > high`.
7. Program displays either "Element not found" or "Element found at index: " with `found + 1`.

SUMMARY:
This program implements Binary Search in Python. Binary Search is an efficient O(log n) search algorithm that operates on sorted arrays by repeatedly dividing the search interval in half.
'''
