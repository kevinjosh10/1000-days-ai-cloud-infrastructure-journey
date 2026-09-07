# Creating a bubble sort function
def bubble_sort(list1): # Function definition accepting a list to sort
    for i in range(0, len(list1) - 1): # Outer loop for passes through the list (n-1 passes)
        for j in range(len(list1) - 1): # Inner loop to compare adjacent elements
            if (list1[j] > list1[j + 1]): # Condition to check if current element is greater than next
                temp = list1[j] # Temporarily store the current element
                list1[j] = list1[j + 1] # Move smaller adjacent element to current position
                list1[j + 1] = temp # Place stored element in adjacent position (swap complete)
                print("The intermediate list is", list1) # Print intermediate state after each swap
    return list1 # Return the fully sorted list

list1 = [] # Initialize an empty list to hold input values
n = int(input("Enter the number of elements in the array: ")) # Prompt user for total number of elements
for i in range(n): # Loop n times to take inputs
    num = int(input("Enter the number to be inserted in array: ")) # Read each element from user
    list1.append(num) # Append each element to list1

print("The unsorted list is: ", list1) # Display the original unsorted list
print("The sorted list is: ", bubble_sort(list1)) # Call bubble_sort and print the returned sorted list

'''
CODE FLOW:
1. The program defines the `bubble_sort` function that accepts a list `list1`.
2. The user is prompted to enter the number of elements `n` and each integer value sequentially.
3. The original list is printed before sorting.
4. `bubble_sort(list1)` runs nested loops:
   - The outer loop controls the number of passes over the array.
   - The inner loop iterates through adjacent pairs from index 0 to `len(list1) - 2`.
   - Whenever an element is larger than its adjacent neighbor on the right (`list1[j] > list1[j+1]`), they are swapped using a temporary variable `temp`.
   - Each time a swap happens, the intermediate state of the array is printed.
5. After all passes are complete, the sorted list is returned and printed to the console.

SUMMARY:
This program implements the Bubble Sort algorithm in Python. Bubble Sort is a comparison-based sorting algorithm where adjacent elements are repeatedly swapped if they are in the wrong order. With each complete pass, the largest unsorted element "bubbles up" to its correct position at the end of the array. The algorithm runs with an average and worst-case time complexity of O(n^2) and space complexity of O(1).
'''
