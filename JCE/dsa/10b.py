def binary_search(arr, x):
    low = 0
    high = len(arr) - 1
    while low <= high:
        mid = (high + low) // 2
        if arr[mid] < x:
            low = mid + 1
        elif arr[mid] > x:
            high = mid - 1
        else:
            return mid
    return -1

arr = []
n = int(input("Enter the number of elements in the array: "))
for i in range(n):
    num = int(input("Enter number to be inserted in the array: "))
    arr.append(num)

arr.sort()
print(arr)
x = int(input("Enter number to be searched: "))
found = binary_search(arr, x)
if (found == -1):
    print("Element not found")
else:
    print("Element found at index: ", found + 1)
