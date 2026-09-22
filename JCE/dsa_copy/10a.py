def linear_search(arr, x): # Define the linear_search function taking array 'arr' and target value 'x'
    for i in range(len(arr)): # Loop through each index from 0 to len(arr) - 1
        if arr[i] == x: # Compare current element with target element x
            return i # If match is found, return the index
    return -1 # If loop completes without finding x, return -1

arr = [] # Initialize an empty list to store array elements
n = int(input("Enter number of elements in array: ")) # Take input for number of elements
for i in range(n): # Loop n times to populate the list
    num = int(input("Enter number to be inserted in array: ")) # Read each number
    arr.append(num) # Append the number to list

x = int(input("Enter the number to be searched: ")) # Read the search key from user
found = linear_search(arr, x) # Call linear_search function with arr and x
if (found == -1): # Check if the element was not found
    print("Element not found") # Display not found message
else: # If found is not -1
    print("Element found at position : ", found + 1) # Display 1-based position

'''
CODE FLOW:
1. `linear_search(arr, x)` is defined.
2. The user inputs total element count `n`.
3. A `for` loop prompts `n` times, reading numbers and appending them to `arr`.
4. The user inputs target value `x`.
5. `linear_search(arr, x)` executes:
   - Evaluates each element `arr[i]` from index 0 to `len(arr) - 1`.
   - If `arr[i] == x`, returns index `i`.
   - If not found after checking all elements, returns `-1`.
6. If return value is `-1`, prints "Element not found", otherwise prints "Element found at position : " with `found + 1`.

SUMMARY:
This program implements Linear Search in Python. Linear Search sequentially checks each element of the list until a match is found or the whole list has been searched. It works on both sorted and unsorted lists with O(n) time complexity and O(1) space complexity.
'''
