#include <stdio.h>

int linearSearch(int arr[], int n, int x) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == x) {
            return i;
        }
    }
    return -1;
}

int main() {
    int n, x;
    printf("Enter number of elements in array: ");
    scanf("%d", &n);

    int arr[n];
    for (int i = 0; i < n; i++) {
        printf("Enter number to be inserted in array: ");
        scanf("%d", &arr[i]);
    }

    printf("Enter the number to be searched: ");
    scanf("%d", &x);

    int found = linearSearch(arr, n, x);
    if (found == -1) {
        printf("Element not found\n");
    } else {
        printf("Element found at position: %d\n", found + 1);
    }

    return 0;
}
