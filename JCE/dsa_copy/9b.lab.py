# Selection sort
def selectionSort(array, size): # Function to perform selection sort on array with given size
    for step in range(size): # Iterate over each index of the array
        min_idx = step # Assume the current step index holds the minimum element
        for i in range(step + 1, size): # Check the remaining unsorted part of the array
            # to sort in descending order, change > to < in this line
            # select the minimum element in each loop
            if array[i] < array[min_idx]: # If a smaller element is found
                min_idx = i # Update index of the minimum element
        # put min at correct position
        (array[step], array[min_idx]) = (array[min_idx], array[step]) # Swap the minimum element with element at current step

data = [] # Initialize empty list to store user elements
n = int(input("Enter the number of elements in the array: ")) # Read array size from user
for i in range(n): # Loop n times to collect array elements
    num = int(input("Enter the number to be inserted in the array: ")) # Read integer input
    data.append(num) # Append each element to list

size = len(data) # Calculate the total number of elements in data
selectionSort(data, size) # Call selectionSort to sort list in-place
print("Sorted Array in Ascending Order:") # Print header
print(data) # Print the sorted array

'''
CODE FLOW:
1. `selectionSort(array, size)` is defined with two loops:
   - Outer loop iterates through each position `step` from 0 to `size - 1`.
   - `min_idx` is initially set to `step`.
   - Inner loop searches through the remaining unsorted elements (`step + 1` to `size - 1`) to find the absolute smallest element.
   - If a smaller element is found at index `i`, `min_idx` is updated.
   - After the inner loop, the smallest found element at `min_idx` is swapped with the element at `step`.
2. The user inputs total element count `n` and individual values, which are collected in `data`.
3. `selectionSort(data, size)` performs in-place sorting.
4. The sorted array is printed to the console.

SUMMARY:
This program implements the Selection Sort algorithm in Python. Selection Sort divides the input list into two parts: a sorted sublist built from left to right and an unsorted sublist occupying the rest. In every iteration, the algorithm finds the smallest element from the unsorted sublist and moves it to the end of the sorted sublist. It has a time complexity of O(n^2) and space complexity of O(1).
'''
