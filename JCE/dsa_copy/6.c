#include <stdio.h> // Includes standard input/output library for printf and scanf
#include <stdlib.h> // Includes standard library for dynamic memory allocation (malloc, free, exit)

// Defines the structure for a node in the Binary Search Tree
struct Node {
    int data; // Stores the integer data
    struct Node* left; // Pointer to the left child node
    struct Node* right; // Pointer to the right child node
};

// Function to create a new tree node
struct Node* createNode(int data) {
    struct Node* newNode = (struct Node*)malloc(sizeof(struct Node)); // Allocates memory for the new node
    newNode->data = data; // Assigns the data to the new node
    newNode->left = NULL; // Initializes left child to NULL
    newNode->right = NULL; // Initializes right child to NULL
    return newNode; // Returns the pointer to the newly created node
}

// Function to insert a new data value into the BST
struct Node* insert(struct Node* root, int data) {
    if (root == NULL) { // If the tree/subtree is empty
        root = createNode(data); // Create a new node and make it the root
        return root; // Return the new root
    }
    if (data < root->data) { // If data is less than current node's data
        root->left = insert(root->left, data); // Recursively insert into the left subtree
    } else if (data > root->data) { // If data is greater than current node's data
        root->right = insert(root->right, data); // Recursively insert into the right subtree
    }
    return root; // Return the unchanged root pointer
}

// Function to find the node with the minimum value in a subtree (leftmost node)
struct Node* findMin(struct Node* root) {
    while (root->left != NULL) { // Traverse down the left children
        root = root->left; // Move to the left child
    }
    return root; // Return the leftmost node
}

// Function to delete a node from the BST
struct Node* delete(struct Node* root, int data) {
    if (root == NULL) { // If tree is empty or data not found
        return root; // Return NULL
    } else if (data < root->data) { // If data is less than current node's data
        root->left = delete(root->left, data); // Recursively search and delete in left subtree
    } else if (data > root->data) { // If data is greater than current node's data
        root->right = delete(root->right, data); // Recursively search and delete in right subtree
    } else { // Node to be deleted is found
        // Case 1: No child (Leaf node)
        if (root->left == NULL && root->right == NULL) {
            free(root); // Free the memory of the node
            root = NULL; // Set the pointer to NULL
        }
        // Case 2: One child (only right child)
        else if (root->left == NULL) {
            struct Node* temp = root; // Temporarily store the node
            root = root->right; // Replace the node with its right child
            free(temp); // Free the original node
        } 
        // Case 2: One child (only left child)
        else if (root->right == NULL) {
            struct Node* temp = root; // Temporarily store the node
            root = root->left; // Replace the node with its left child
            free(temp); // Free the original node
        }
        // Case 3: Two children
        else {
            struct Node* temp = findMin(root->right); // Find the minimum node in the right subtree (inorder successor)
            root->data = temp->data; // Copy the inorder successor's data to the current node
            root->right = delete(root->right, temp->data); // Recursively delete the inorder successor
        }
    }
    return root; // Return the updated root pointer
}

// Function to search for a specific value in the BST
struct Node* search(struct Node* root, int data) {
    if (root == NULL || root->data == data) { // If node is found or subtree is empty
        return root; // Return the node (or NULL)
    }
    if (data < root->data) { // If data is less than current node
        return search(root->left, data); // Search in left subtree
    }
    return search(root->right, data); // Else search in right subtree
}

// Function for In-order traversal (Left, Root, Right)
void inorderTraversal(struct Node* root) {
    if (root != NULL) { // Base condition
        inorderTraversal(root->left); // Traverse left subtree
        printf("%d ", root->data); // Print root data (Results in sorted order)
        inorderTraversal(root->right); // Traverse right subtree
    }
}

// Function for Pre-order traversal (Root, Left, Right)
void preorderTraversal(struct Node* root) {
    if (root != NULL) { // Base condition
        printf("%d ", root->data); // Print root data
        preorderTraversal(root->left); // Traverse left subtree
        preorderTraversal(root->right); // Traverse right subtree
    }
}

// Function for Post-order traversal (Left, Right, Root)
void postorderTraversal(struct Node* root) {
    if (root != NULL) { // Base condition
        postorderTraversal(root->left); // Traverse left subtree
        postorderTraversal(root->right); // Traverse right subtree
        printf("%d ", root->data); // Print root data
    }
}

// Main function where execution starts
int main() {
    struct Node* root = NULL; // Initialize an empty BST
    int choice, data; // Variables to store user choice and input data
    while (1) { // Infinite loop for menu
        // Print the menu options
        printf("1. Insert\n");
        printf("2. Delete\n");
        printf("3. Search\n");
        printf("4. In-order Traversal\n");
        printf("5. Pre-order Traversal\n");
        printf("6. Post-order Traversal\n");
        printf("7. Exit\n");
        printf("Enter your choice: "); // Prompt for user choice
        scanf("%d", &choice); // Read the choice
        
        switch (choice) { // Handle choice using switch case
            case 1:
                printf("Enter the data to insert: "); // Prompt for data
                scanf("%d", &data); // Read data
                root = insert(root, data); // Call insert function
                break; // Break out of switch
            case 2:
                printf("Enter the data to delete: "); // Prompt for data
                scanf("%d", &data); // Read data
                root = delete(root, data); // Call delete function
                printf("Node deleted\n"); // Confirm deletion
                break; // Break out of switch
            case 3:
                printf("Enter the data to search: "); // Prompt for data
                scanf("%d", &data); // Read data
                if (search(root, data) != NULL) { // Call search function and check result
                    printf("Data found!\n"); // Node exists
                } else {
                    printf("Data not found!\n"); // Node does not exist
                }
                break; // Break out of switch
            case 4:
                printf("In-order Traversal: "); // Print label
                inorderTraversal(root); // Call in-order function
                printf("\n"); // Print newline
                break; // Break out of switch
            case 5:
                printf("Pre-order Traversal: "); // Print label
                preorderTraversal(root); // Call pre-order function
                printf("\n"); // Print newline
                break; // Break out of switch
            case 6:
                printf("Post-order Traversal: "); // Print label
                postorderTraversal(root); // Call post-order function
                printf("\n"); // Print newline
                break; // Break out of switch
            case 7:
                exit(0); // Terminate the program
            default:
                printf("Invalid choice!\n"); // Handle invalid input
        }
    }
    return 0; // Return success status
}

/* 
CODE FLOW:
1. The program starts by defining a binary tree node structure containing integer data and left/right pointers.
2. In the `main` function, an empty tree `root` is initialized to NULL, and an infinite loop displays a menu of options.
3. If the user chooses to Insert (1), the `insert` function recursively finds the correct position based on the BST property (left < root < right) and dynamically allocates a new node.
4. If the user chooses to Delete (2), the `delete` function searches for the node. If found, it handles three cases:
   - No children: It simply frees the node.
   - One child: It bypasses the node by linking the parent to the child and frees the node.
   - Two children: It finds the inorder successor (minimum value in the right subtree), copies its value, and recursively deletes the successor.
5. If the user chooses Search (3), it recursively checks left or right subtrees depending on the value, returning NULL if it hits a dead end.
6. The traversal options (4, 5, 6) recursively print the nodes in In-order (sorted), Pre-order, or Post-order sequences respectively.
7. The loop continues until the user selects Exit (7).
*/

/* 
SUMMARY:
This program implements a complete Binary Search Tree (BST) data structure in C. 
A BST is a node-based binary tree data structure where each node has at most two child nodes, and the left child's value is always less than the parent's value, while the right child's value is always greater.
The program provides a fully interactive menu-driven interface to perform all fundamental operations: insertion, deletion, searching, and tree traversals (In-order, Pre-order, Post-order). 
The recursive approach used for the operations demonstrates standard tree algorithm patterns, particularly the complex logic required for deleting a node with two children by using its inorder successor.
*/
