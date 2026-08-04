#include <stdio.h>
#include <conio.h>
#include <stdlib.h>

struct node {
    int data;
    struct node *next;
} *head, *newnode, *temp, *del, *top;

int count = 0;

void create() {
    head = (struct node *)malloc(sizeof(struct node));
    head->next = NULL;
    top = NULL;
}

void push() {
    newnode = (struct node *)malloc(sizeof(struct node));
    printf("Enter the element to be pushed : ");
    scanf("%d", &newnode->data);
    newnode->next = head->next;
    head->next = newnode;
    top = newnode;
    count++;
}

int pop() {
    if (top == NULL) {
        printf("Stack is empty!! Stack underflow error !!! \n");
        return 0;
    }
    del = head->next;
    head->next = del->next;
    top = head->next;
    count--;
    return (del->data);
}

void display() {
    temp = head;
    printf("Elements in stack : HEAD ");
    while(temp->next != NULL) {
        temp = temp->next;
        printf("-> %d ", temp->data);
    }
    printf("-> NULL ");
    printf("\nNo of elements = %d \n", count);
}

void main() {
    int option, x;
    clrscr();
    printf("\n ***-*-*-* STACK USING LINKED LIST *-*-*-*-* \n");
    create();
    do {
        printf("\n MENU : 1.Push  2.Pop  3.Exit ");
        printf("\n Enter your option : ");
        scanf("%d", &option);
        switch(option) {
            case 1: 
                push(); 
                display(); 
                break;
            case 2: 
                x = pop(); 
                if (x != 0) 
                    printf("The Popped element = %d \n", x);
                display(); 
                break;
            case 3: 
                exit(0);
            default: 
                printf("\n Wrong choice ! Try again... \n"); 
        }
    } while (option != 3);
    getch();
}
