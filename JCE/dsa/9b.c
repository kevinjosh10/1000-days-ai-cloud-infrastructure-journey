#include <stdio.h>

void selectionSort(int array[], int size) {
    int step, i, min_idx, temp;
    for (step = 0; step < size - 1; step++) {
        min_idx = step;
        for (i = step + 1; i < size; i++) {
            if (array[i] < array[min_idx]) {
                min_idx = i;
            }
        }
        temp = array[step];
        array[step] = array[min_idx];
        array[min_idx] = temp;
    }
}

int main() {
    int n, i;
    printf("Enter the number of elements in the array: ");
    scanf("%d", &n);

    int data[n];
    for (i = 0; i < n; i++) {
        printf("Enter the number to be inserted in the array: ");
        scanf("%d", &data[i]);
    }

    selectionSort(data, n);

    printf("Sorted Array in Ascending Order:\n");
    for (i = 0; i < n; i++) {
        printf("%d ", data[i]);
    }
    printf("\n");

    return 0;
}
