#include<stdio.h> // Includes standard I/O library for printing and scanning
#include<stdlib.h> // Includes standard library for dynamic memory allocation

// Defines the structure for an AVL tree node
typedef struct node {
    int data; // Stores the integer data
    struct node *left, *right; // Pointers to left and right child nodes
    int ht; // Stores the height of the node for balance factor calculations
} node;

// Function prototypes for all AVL tree operations
node *insert(node *, int);
node *Delete(node *, int);
void preorder(node *);
void inorder(node *);
int height(node *);
node *rotateright(node *);
node *rotateleft(node *);
node *RR(node *);
node *LL(node *);
node *LR(node *);
node *RL(node *);
int BF(node *);

// Main function
int main() {
    node *root = NULL; // Initialize an empty AVL tree
    int x, n, i, op; // Variables for data, number of elements, loop counter, and user option
    do {
        // Display the interactive menu
        printf("\n1)Create:");
        printf("\n2)Insert:");
        printf("\n3)Delete:");
        printf("\n4)Print:");
        printf("\n5)Quit:");
        printf("\n\nEnter Your Choice:");
        scanf("%d", &op); // Read user option
        
        switch (op) { // Handle user choice
            case 1:
                printf("\nEnter no. of elements:"); // Ask how many elements to insert initially
                scanf("%d", &n); // Read count
                printf("\nEnter tree data:");
                root = NULL; // Reset tree
                for (i = 0; i < n; i++) { // Loop to insert 'n' elements
                    scanf("%d", &x); // Read element
                    root = insert(root, x); // Insert element and balance tree
                }
                break;
            case 2:
                printf("\nEnter a data:"); // Ask for single element to insert
                scanf("%d", &x); // Read element
                root = insert(root, x); // Insert and balance
                break;
            case 3:
                printf("\nEnter a data:"); // Ask for element to delete
                scanf("%d", &x); // Read element
                root = Delete(root, x); // Delete and balance
                break;
            case 4:
                printf("\nPreorder sequence:\n"); // Print tree in preorder
                preorder(root); // Call preorder traversal
                break;
        }
    } while (op != 5); // Loop until user chooses to quit
    return 0; // Exit successfully
}

// Function to insert a node and balance the AVL tree
node *insert(node *T, int x) {
    if (T == NULL) { // If tree/subtree is empty, create the node
        T = (node *)malloc(sizeof(node)); // Allocate memory
        T->data = x; // Assign data
        T->left = NULL; // Initialize left child
        T->right = NULL; // Initialize right child
    } else if (x > T->data) { // If data is greater, insert in right subtree
        T->right = insert(T->right, x); // Recursive insert
        if (BF(T) == -2) // Check Balance Factor. -2 means right-heavy
            if (x > T->right->data) // If insertion was in right child of right subtree
                T = RR(T); // Perform Right-Right rotation
            else // If insertion was in left child of right subtree
                T = RL(T); // Perform Right-Left rotation
    } else if (x < T->data) { // If data is smaller, insert in left subtree
        T->left = insert(T->left, x); // Recursive insert
        if (BF(T) == 2) // Check Balance Factor. 2 means left-heavy
            if (x < T->left->data) // If insertion was in left child of left subtree
                T = LL(T); // Perform Left-Left rotation
            else // If insertion was in right child of left subtree
                T = LR(T); // Perform Left-Right rotation
    }
    T->ht = height(T); // Update the height of the current node
    return (T); // Return the balanced root
}

// Function to delete a node and balance the AVL tree
node *Delete(node *T, int x) {
    node *p;
    if (T == NULL) { // Node not found
        return NULL;
    } else if (x > T->data) { // Search in right subtree
        T->right = Delete(T->right, x);
        if (BF(T) == 2) // If tree becomes left-heavy after deletion
            if (BF(T->left) >= 0)
                T = LL(T); // Left-Left rotation
            else
                T = LR(T); // Left-Right rotation
    } else if (x < T->data) { // Search in left subtree
        T->left = Delete(T->left, x);
        if (BF(T) == -2) // If tree becomes right-heavy after deletion
            if (BF(T->right) <= 0)
                T = RR(T); // Right-Right rotation
            else
                T = RL(T); // Right-Left rotation
    } else { // Node to be deleted is found
        if (T->right != NULL) { // If right child exists
            p = T->right; 
            while (p->left != NULL) // Find the inorder successor
                p = p->left;
            T->data = p->data; // Copy successor data to current node
            T->right = Delete(T->right, p->data); // Delete the successor
            if (BF(T) == 2) // Rebalance during windup
                if (BF(T->left) >= 0)
                    T = LL(T);
                else
                    T = LR(T);
        } else // If no right child exists
            return (T->left); // Bypass node
    }
    T->ht = height(T); // Update height
    return (T); // Return balanced node
}

// Function to calculate the height of a node
int height(node *T) {
    int lh, rh;
    if (T == NULL) return (0); // Null node has height 0
    if (T->left == NULL) lh = 0; else lh = 1 + T->left->ht; // Height of left subtree
    if (T->right == NULL) rh = 0; else rh = 1 + T->right->ht; // Height of right subtree
    if (lh > rh) return (lh); // Return the larger height
    return (rh);
}

// Function to perform a right rotation
node *rotateright(node *x) {
    node *y;
    y = x->left; // y is the left child
    x->left = y->right; // Move y's right child to x's left
    y->right = x; // Make x the right child of y
    x->ht = height(x); // Update x's height
    y->ht = height(y); // Update y's height
    return (y); // y is the new root
}

// Function to perform a left rotation
node *rotateleft(node *x) {
    node *y;
    y = x->right; // y is the right child
    x->right = y->left; // Move y's left child to x's right
    y->left = x; // Make x the left child of y
    x->ht = height(x); // Update x's height
    y->ht = height(y); // Update y's height
    return (y); // y is the new root
}

// Function to handle Right-Right case
node *RR(node *T) {
    T = rotateleft(T); // Perform a single left rotation
    return (T);
}

// Function to handle Left-Left case
node *LL(node *T) {
    T = rotateright(T); // Perform a single right rotation
    return (T);
}

// Function to handle Left-Right case
node *LR(node *T) {
    T->left = rotateleft(T->left); // Perform a left rotation on the left child
    T = rotateright(T); // Perform a right rotation on the root
    return (T);
}

// Function to handle Right-Left case
node *RL(node *T) {
    T->right = rotateright(T->right); // Perform a right rotation on the right child
    T = rotateleft(T); // Perform a left rotation on the root
    return (T);
}

// Function to calculate the Balance Factor (Left Height - Right Height)
int BF(node *T) {
    int lh, rh;
    if (T == NULL) return (0);
    if (T->left == NULL) lh = 0; else lh = 1 + T->left->ht;
    if (T->right == NULL) rh = 0; else rh = 1 + T->right->ht;
    return (lh - rh); // Balance Factor = Height(Left) - Height(Right)
}

// Function to traverse the tree in Pre-order
void preorder(node *T) {
    if (T != NULL) {
        printf("%d(Bf=%d)", T->data, BF(T)); // Print data and its balance factor
        preorder(T->left); // Visit left child
        preorder(T->right); // Visit right child
    }
}

/* 
CODE FLOW:
1. The program defines an AVL tree node containing integer data, left/right pointers, and an integer `ht` to store the node's height.
2. In `main`, the user is presented with options to Create/Insert, Delete, or Print the AVL tree.
3. During Insertion (`insert`), a standard BST insertion is performed recursively. As the recursion unwinds, the height of each visited node is updated.
4. The Balance Factor (BF) is checked at each node. If BF goes out of the range [-1, 1], a rotation is triggered based on the insertion path:
   - Left-Heavy, inserted left: LL rotation (Single Right Rotation).
   - Left-Heavy, inserted right: LR rotation (Left then Right Rotation).
   - Right-Heavy, inserted right: RR rotation (Single Left Rotation).
   - Right-Heavy, inserted left: RL rotation (Right then Left Rotation).
5. During Deletion (`Delete`), a standard BST deletion is performed. Similarly, as recursion unwinds, heights are updated and balance factors are checked to trigger any necessary rotations to keep the tree balanced.
6. The `preorder` function recursively prints each node's value along with its Balance Factor to verify that the tree is successfully balancing itself.
*/

/* 
SUMMARY:
This program implements an AVL Tree, which is a self-balancing Binary Search Tree. 
Unlike a standard BST, which can degenerate into a linked list in worst-case scenarios, an AVL tree guarantees that the height difference (Balance Factor) between left and right subtrees of any node is never greater than 1.
This is achieved by performing tree rotations (Left, Right, Left-Right, Right-Left) automatically during insertions and deletions. 
By constantly updating node heights and triggering rotations when imbalances are detected during the recursive unwinding phase, the tree maintains O(log n) performance for all operations, making it highly efficient for dynamic datasets.
*/
