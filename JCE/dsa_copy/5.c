#include <stdio.h> // Include standard I/O library
#include <stdlib.h> // Include standard library for exit()
#include <ctype.h> // Include library for character classification (isalpha, isdigit)
#include <string.h> // Include string library for strcat

#define SIZE 100 // Define max size for stack and expressions

char stack[SIZE]; // Global character array to serve as the operator stack
int top = -1; // Top index of the stack

void push(char item) { // Push a character onto the stack
    if (top >= SIZE - 1) {
        printf("\n Stack Overflow");
    } else {
        top = top + 1;
        stack[top] = item;
    }
}

char pop() { // Pop a character from the stack
    char item;
    if (top < 0) { // If stack is empty when a pop is attempted
        printf("Stack underflow: Invalid infix expression");
        getchar();
        exit(1); // Terminate program due to invalid expression
    } else {
        item = stack[top]; // Get top element
        top = top - 1; // Decrement top
        return (item); // Return the element
    }
}

int is_operator(char symbol) { // Helper function to check if a character is a mathematical operator
    if (symbol == '^' || symbol == '*' || symbol == '/' || symbol == '+' || symbol == '-') {
        return 1; // True
    } else {
        return 0; // False
    }
}

int precedence(char symbol) { // Helper function to determine Operator Precedence (BODMAS rules)
    if (symbol == '^') {
        return (3); // Highest precedence (Exponent)
    } else if (symbol == '*' || symbol == '/') {
        return (2); // Medium precedence (Multiplication/Division)
    } else if (symbol == '+' || symbol == '-') {
        return (1); // Lowest precedence (Addition/Subtraction)
    } else {
        return (0); // Not an operator or parenthesis
    }
}

void InfixToPostfix(char infix_exp[], char postfix_exp[]) { // Core conversion algorithm
    int i, j;
    char item;
    char x;

    push('('); // 1. Push a left parenthesis '(' onto the stack
    strcat(infix_exp, ")"); // 2. Add a right parenthesis ')' to the end of the input string

    i = 0; // Index for reading infix string
    j = 0; // Index for writing postfix string
    item = infix_exp[i]; // Get first character

    while (item != '\0') { // 3. Loop until the end of the string
        if (item == '(') { // Rule A: If it's a left parenthesis, push it
            push(item);
        } else if (isdigit(item) || isalpha(item)) { // Rule B: If it's an operand (letter/number), add to postfix string
            postfix_exp[j] = item;
            j++;
        } else if (is_operator(item) == 1) { // Rule C: If it's an operator
            x = pop();
            // Pop operators from the stack to postfix string as long as they have >= precedence than the current operator
            while (is_operator(x) == 1 && precedence(x) >= precedence(item)) {
                postfix_exp[j] = x;
                j++;
                x = pop();
            }
            push(x); // Push the last popped operator back (which had lower precedence)
            push(item); // Push the current operator onto the stack
        } else if (item == ')') { // Rule D: If it's a right parenthesis
            x = pop();
            while (x != '(') { // Pop everything from stack to postfix string until '(' is found
                postfix_exp[j] = x;
                j++;
                x = pop();
            }
        } else { // Handle unexpected characters
            printf("\n Invalid infix Expression.\n");
            getchar();
            exit(1);
        }
        i++; // Move to next character in infix string
        item = infix_exp[i];
    }

    if (top > 0) { // If stack still has elements (other than the initial '('), expression was unbalanced
        printf("\n Invalid infix Expression.\n");
        getchar();
        exit(1);
    }

    if (top >= 0) { // Terminate the postfix string properly
        postfix_exp[j] = '\0';
    }
}

int main() { // Main execution block
    char infix[SIZE], postfix[SIZE];
    
    printf("ASSUMPTION: The infix expression contains single letter variables and single digit constants only.\n");
    printf("\n Enter Infix expression: ");
    gets(infix); // Read infix string from user (Note: gets() is unsafe in production C, but used in older academic labs)

    InfixToPostfix(infix, postfix); // Perform conversion

    printf("Postfix Expression: ");
    puts(postfix); // Print the final postfix string

    return 0; // Terminate program
}

/*
CODE FLOW:
1. Program execution begins in `main()`. The user inputs a human-readable math expression (Infix) like `A+B*C`.
2. `InfixToPostfix` is called. It prepares by pushing a `(` to the global stack and appending a `)` to the string to ensure proper loop termination.
3. A `while` loop processes the infix string character by character.
4. If it encounters an operand (like A, B, C), it immediately writes it to the output `postfix` string.
5. If it encounters an operator (like `+`), it checks the stack. If the operator on top of the stack has higher or equal precedence (e.g., `*` is on top and we are holding `+`), it pops the stack and writes it to output first before pushing the new operator.
6. If it encounters `(`, it pushes it. If it encounters `)`, it aggressively pops and writes all operators from the stack to the output until it finds the matching `(`.
7. This algorithm elegantly reorders the expression. Finally, `main()` prints the resulting postfix expression (e.g., `ABC*+`).

SUMMARY:
This C program uses a Stack Data Structure to parse and convert mathematical expressions from Infix notation (human readable, e.g., A+B) to Postfix notation (machine readable, e.g., AB+).
Postfix notation (Reverse Polish Notation) is preferred by computers because it removes the need for parentheses and complex precedence rules during calculation. The stack acts as a temporary holding area to delay operators until their operands have been fully processed based on BODMAS rules.
*/
