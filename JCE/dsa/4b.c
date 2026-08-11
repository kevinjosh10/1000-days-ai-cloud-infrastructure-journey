#include <stdio.h>
#include <stdlib.h>

typedef struct element {
    int item;
    struct element *next;
} element;

typedef struct queue {
    element *front;
    element *rear;
} queue;

void enqueue(int item, queue *q) {
    element *e = (element *)malloc(sizeof(element));
    e->item = item;
    e->next = NULL;
    
    if (q->front == NULL) {
        q->front = e;
        q->rear = e;
        return;
    }
    
    q->rear->next = e;
    q->rear = e;
}

int dequeue(queue *q) {
    element *e;
    int item;
    
    if (q->front == NULL) {
        printf("\nQueue is empty\n");
        return 0;
    }
    
    e = q->front;
    item = e->item;
    q->front = q->front->next;
    
    if (q->front == NULL) {
        q->rear = NULL;
    }
    
    free(e);
    return item;
}

void display(queue *q) {
    element *t;
    if (q->front == NULL) {
        printf("\nQueue is Empty\n");
    } else {
        printf("in: ");
        t = q->front;
        while (t->next != NULL) {
            printf("%d -> ", t->item);
            t = t->next;
        }
        printf("%d -> NULL\n", t->item);
    }
}

int main() {
    int choice, value;
    queue *q = (queue *)malloc(sizeof(queue));
    q->front = q->rear = NULL;
    
    printf("\n:: Queue using Linked List ::\n");
    
    do {
        printf("\nChoose from below menu:\n");
        printf("1. Add\n2. Delete\n3. Display\n4. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                printf("Enter the value to be added: ");
                scanf("%d", &value);
                enqueue(value, q);
                break;
            case 2:
                dequeue(q);
                break;
            case 3:
                display(q);
                break;
            case 4:
                printf("\n\tExit POINT\n");
                break;
            default:
                printf("\n\tPlease Enter a Valid Choice (1/2/3/4)\n");
        }
    } while (choice != 4);
    
    return 0;
}
