# Creating a function for insertion
def insertion_sort(list1): # Define insertion_sort taking list1 as input
    # Outer loop to traverse through 1 to len(list1)
    for i in range(1, len(list1)): # Loop from index 1 to len(list1) - 1
        value = list1[i] # Store current element to be positioned
        # Move elements of list1[0...i-1] that are
        # greater than value to one
        # position ahead of their
        # current position
        j = i - 1 # Set pointer to the element directly to the left
        while j >= 0 and value < list1[j]: # Compare and shift elements greater than value
            list1[j + 1] = list1[j] # Shift element to the right
            j -= 1 # Move pointer left
        list1[j + 1] = value # Insert value at its correct position
        print("The intermediate list is: ", list1) # Print intermediate state after placement
    return list1 # Return sorted list

# Driver code to test above
list1 = [] # Initialize empty list for elements
n = int(input("Enter the number of elements in the array: ")) # Prompt for total elements
for i in range(n): # Loop n times to collect array elements
    num = int(input("Enter number to be inserted in array: ")) # Read each element
    list1.append(num) # Append each element to list1

print("The unsorted list is : ", list1) # Print original list
print("The sorted list is : ", insertion_sort(list1)) # Call function and print sorted result

'''
CODE FLOW:
1. `insertion_sort(list1)` is defined.
2. User inputs number of elements `n` and each integer value into `list1`.
3. The unsorted list is displayed.
4. `insertion_sort(list1)` executes:
   - Outer loop `i` iterates from 1 to `len(list1) - 1`.
   - `value` stores `list1[i]`.
   - While loop shifts elements greater than `value` one step right.
   - `value` is placed at `list1[j + 1]`.
   - The intermediate list is printed after each insertion.
5. The final sorted list is printed.

SUMMARY:
This program implements Insertion Sort in Python. It maintains a sorted sublist in the lower positions and inserts each new element into its proper place with O(n^2) worst/average-case and O(n) best-case time complexity.
'''
