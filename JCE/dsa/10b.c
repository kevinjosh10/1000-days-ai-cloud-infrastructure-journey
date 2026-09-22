#include <stdio.h>

void sort(int arr[], int n) {
    int temp;
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

int binarySearch(int arr[], int n, int x) {
    int low = 0;
    int high = n - 1;
    while (low <= high) {
        int mid = (low + high) / 2;
        if (arr[mid] < x) {
            low = mid + 1;
        } else if (arr[mid] > x) {
            high = mid - 1;
        } else {
            return mid;
        }
    }
    return -1;
}

int main() {
    int n, x;
    printf("Enter the number of elements in the array: ");
    scanf("%d", &n);

    int arr[n];
    for (int i = 0; i < n; i++) {
        printf("Enter number to be inserted in the array: ");
        scanf("%d", &arr[i]);
    }

    sort(arr, n);

    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");

    printf("Enter number to be searched: ");
    scanf("%d", &x);

    int found = binarySearch(arr, n, x);
    if (found == -1) {
        printf("Element not found\n");
    } else {
        printf("Element found at index: %d\n", found + 1);
    }

    return 0;
}
