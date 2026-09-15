#include <stdio.h>

void insertionSort(int list1[], int n) {
    int i, j, value;
    for (i = 1; i < n; i++) {
        value = list1[i];
        j = i - 1;
        while (j >= 0 && list1[j] > value) {
            list1[j + 1] = list1[j];
            j = j - 1;
        }
        list1[j + 1] = value;
    }
}

int main() {
    int n, i;
    printf("Enter the number of elements in the array: ");
    scanf("%d", &n);

    int list1[n];
    for (i = 0; i < n; i++) {
        printf("Enter the number to be inserted in the array: ");
        scanf("%d", &list1[i]);
    }

    insertionSort(list1, n);

    printf("Sorted Array in Ascending Order:\n");
    for (i = 0; i < n; i++) {
        printf("%d ", list1[i]);
    }
    printf("\n");

    return 0;
}
