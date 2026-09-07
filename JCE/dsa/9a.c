#include <stdio.h>

void bubbleSort(int list1[], int n) {
    int i, j, temp;
    for (i = 0; i < n - 1; i++) {
        for (j = 0; j < n - 1; j++) {
            if (list1[j] > list1[j + 1]) {
                temp = list1[j];
                list1[j] = list1[j + 1];
                list1[j + 1] = temp;
            }
        }
    }
}

int main() {
    int n, i;
    printf("Enter the number of elements in the array: ");
    scanf("%d", &n);

    int list1[n];
    for (i = 0; i < n; i++) {
        printf("Enter the number to be inserted in array: ");
        scanf("%d", &list1[i]);
    }

    printf("The unsorted list is: ");
    for (i = 0; i < n; i++) {
        printf("%d ", list1[i]);
    }
    printf("\n");

    bubbleSort(list1, n);

    printf("The sorted list is: ");
    for (i = 0; i < n; i++) {
        printf("%d ", list1[i]);
    }
    printf("\n");

    return 0;
}
