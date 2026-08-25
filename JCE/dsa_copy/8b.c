#include<stdio.h> // Includes standard I/O library for printf and scanf

// Global variables declaration
// G[10][10] is the adjacency matrix representing the graph connections
// visited[10] is an array to keep track of visited vertices to prevent infinite loops
// n is the total number of vertices in the graph
int G[10][10], visited[10], n;

// Function to perform Depth First Search recursively
void DFS(int i) {
    int j; // Local loop counter for checking adjacent vertices
    
    // Print the current vertex being visited
    printf("\n%d", i);
    
    // Mark the current vertex as visited so we don't visit it again
    visited[i] = 1;
    
    // Loop through all possible vertices to find adjacent ones
    for (j = 0; j < n; j++) {
        // If vertex 'j' has not been visited AND there is an edge from 'i' to 'j'
        if (!visited[j] && G[i][j] == 1) {
            // Recursively dive deeper into the graph starting from vertex 'j'
            DFS(j);
        }
    }
}

// Main function
int main() {
    int i, j; // Loop counters for matrix initialization
    
    // Prompt the user for the total number of vertices
    printf("Enter number of vertices: ");
    scanf("%d", &n); // Read the number of vertices
    
    // Prompt the user to enter the adjacency matrix
    printf("Enter adjacency matrix of the graph: ");
    
    // Nested loops to read the 2D adjacency matrix from the user
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            scanf("%d", &G[i][j]); // Read 1 (edge exists) or 0 (no edge)
        }
    }
    
    // Initialize the visited array to 0 (all vertices are initially unvisited)
    for (i = 0; i < n; i++) {
        visited[i] = 0;
    }
    
    // Call the DFS function starting from vertex 0
    DFS(0);
    
    return 0; // Return success status
}

/* 
CODE FLOW:
1. The program declares a global 2D array `G` for the graph's adjacency matrix and a 1D array `visited` to track traversed nodes.
2. In `main`, the user inputs the number of vertices `n`.
3. The program then asks the user to input the adjacency matrix row by row, recording the paths between nodes (1 for connected, 0 for disconnected).
4. A loop initializes the `visited` array to 0, ensuring no node is prematurely marked as visited.
5. `DFS(0)` is called to start traversing the graph from the 0th vertex.
6. Inside the `DFS` function, the current node `i` is immediately printed and marked as visited (`visited[i] = 1`).
7. A loop then checks all other nodes (`j`). If it finds an adjacent node (`G[i][j] == 1`) that has not been visited (`!visited[j]`), it recursively calls `DFS(j)`.
8. This recursive call forces the program to dive as deep as possible down a single path before backtracking to explore alternative branches, which is the defining characteristic of Depth First Search.
*/

/* 
SUMMARY:
This program implements the Depth First Search (DFS) algorithm to traverse a graph. 
DFS is an algorithm that explores a graph by starting at a root node and exploring as far as possible along each branch before backtracking. 
This code implements DFS using recursion (which inherently uses the system call stack) and an adjacency matrix to represent the graph. 
The `visited` array is a critical component that tracks which vertices have already been processed, ensuring the algorithm doesn't get stuck in an infinite cycle if the graph contains loops.
*/
