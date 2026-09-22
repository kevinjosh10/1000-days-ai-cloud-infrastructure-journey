# Creating a function for insertion
def insertion_sort(list1):
    # Outer loop to traverse through 1 to len(list1)
    for i in range(1, len(list1)):
        value = list1[i]
        # Move elements of list1[0...i-1] that are
        # greater than value to one
        # position ahead of their
        # current position
        j = i - 1
        while j >= 0 and value < list1[j]:
            list1[j + 1] = list1[j]
            j -= 1
        list1[j + 1] = value
        print("The intermediate list is: ", list1)
    return list1

# Driver code to test above
list1 = []
n = int(input("Enter the number of elements in the array: "))
for i in range(n):
    num = int(input("Enter number to be inserted in array: "))
    list1.append(num)

print("The unsorted list is : ", list1)
print("The sorted list is : ", insertion_sort(list1))
