#include <stdio.h>
#include <stdlib.h>

#define TABLE_SIZE 10

int h[TABLE_SIZE] = {0};

void insert() {
    int key, index, i, hkey;
    printf("\n Enter a value to insert into hash table \n");
    scanf("%d", &key);
    hkey = key % TABLE_SIZE;
    for (i = 0; i < TABLE_SIZE; i++) {
        index = (hkey + i * i) % TABLE_SIZE;
        if (h[index] == 0) {
            h[index] = key;
            break;
        }
    }
    if (i == TABLE_SIZE) {
        printf("\n Element cannot be inserted \n");
    }
}

void search() {
    int key, index, i, hkey;
    printf("\n Enter search element \n");
    scanf("%d", &key);
    hkey = key % TABLE_SIZE;
    for (i = 0; i < TABLE_SIZE; i++) {
        index = (hkey + i * i) % TABLE_SIZE;
        if (h[index] == key) {
            printf("Value is found at index %d\n", index);
            break;
        }
    }
    if (i == TABLE_SIZE) {
        printf("\n Value is not found \n");
    }
}

void display() {
    int i;
    printf("\n Elements in the hash table are \n");
    for (i = 0; i < TABLE_SIZE; i++) {
        printf("\n At index %d \t value = %d", i, h[i]);
    }
}

int main() {
    int opt;
    while (1) {
        printf("\n Press 1. Insert \t 2. Display \t 3. Search \t 4. Exit \n");
        printf("Enter choice: ");
        scanf("%d", &opt);
        switch (opt) {
            case 1:
                insert();
                break;
            case 2:
                display();
                break;
            case 3:
                search();
                break;
            case 4:
                exit(0);
        }
    }
    return 0;
}
