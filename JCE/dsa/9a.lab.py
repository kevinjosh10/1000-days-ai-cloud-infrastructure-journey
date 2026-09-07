# Creating a bubble sort function
def bubble_sort(list1):
    for i in range(0, len(list1) - 1):
        for j in range(len(list1) - 1):
            if (list1[j] > list1[j + 1]):
                temp = list1[j]
                list1[j] = list1[j + 1]
                list1[j + 1] = temp
                print("The intermediate list is", list1)
    return list1

list1 = []
n = int(input("Enter the number of elements in the array: "))
for i in range(n):
    num = int(input("Enter the number to be inserted in array: "))
    list1.append(num)

print("The unsorted list is: ", list1)
print("The sorted list is: ", bubble_sort(list1))
