#include <stdio.h>
#define SIZE 10

int queue[SIZE];
int front = -1;
int rear = -1;

void display();
int underflow();
int overflow();
void enqueue(int);
void dequeue();

void display() {
    int i;
    if (front == -1) {
        printf("\nQueue is empty\n");
        return;
    }
    printf("\nQueue elements are:\n");
    for (i = front; i <= rear; i++) {
        printf("%d ", queue[i]);
    }
    printf("\n");
}

int underflow() {
    if (front == -1 || front > rear) {
        return 1;
    }
    return 0;
}

int overflow() {
    if (rear == SIZE - 1) {
        return 1;
    }
    return 0;
}

void enqueue(int item) {
    if (overflow() == 1) {
        printf("\nQueue is full\n");
        return;
    }
    if (front == -1) {
        front = 0;
    }
    rear = rear + 1;
    queue[rear] = item;
    printf("\nElement %d inserted into queue\n", item);
}

void dequeue() {
    if (underflow() == 1) {
        printf("\nQueue is empty\n");
        return;
    }
    printf("\nElement %d deleted from queue\n", queue[front]);
    front = front + 1;
    if (front > rear) {
        front = -1;
        rear = -1;
    }
}

int main() {
    int choice;
    int item;
    
    printf("\nQUEUE OPERATIONS USING ARRAY");
    
    while (1) {
        printf("\n1. Enqueue\n2. Dequeue\n3. Display\n4. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                printf("\nEnter the item to be inserted: ");
                scanf("%d", &item);
                enqueue(item);
                break;
            case 2:
                dequeue();
                break;
            case 3:
                display();
                break;
            case 4:
                return 0;
            default:
                printf("\nInvalid choice! Please enter a valid choice (1/2/3/4)\n");
        }
    }
    return 0;
}
