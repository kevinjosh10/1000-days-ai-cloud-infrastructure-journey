def linear_search(arr, x):
    for i in range(len(arr)):
        if arr[i] == x:
            return i
    return -1

arr = []
n = int(input("Enter number of elements in array: "))
for i in range(n):
    num = int(input("Enter number to be inserted in array: "))
    arr.append(num)

x = int(input("Enter the number to be searched: "))
found = linear_search(arr, x)
if (found == -1):
    print("Element not found")
else:
    print("Element found at position : ", found + 1)
