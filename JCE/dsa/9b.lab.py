# Selection sort
def selectionSort(array, size):
    for step in range(size):
        min_idx = step
        for i in range(step + 1, size):
            # to sort in descending order, change > to < in this line
            # select the minimum element in each loop
            if array[i] < array[min_idx]:
                min_idx = i
        # put min at correct position
        (array[step], array[min_idx]) = (array[min_idx], array[step])

data = []
n = int(input("Enter the number of elements in the array: "))
for i in range(n):
    num = int(input("Enter the number to be inserted in the array: "))
    data.append(num)

size = len(data)
selectionSort(data, size)
print("Sorted Array in Ascending Order:")
print(data)
