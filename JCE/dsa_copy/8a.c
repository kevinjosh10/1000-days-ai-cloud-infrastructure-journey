#include<stdio.h> // Includes standard I/O library for printf and scanf

// Global variables declaration
// a[20][20] is the adjacency matrix representing the graph
// q[20] is the queue used for BFS traversal
// visited[20] is an array to keep track of visited vertices (1 for visited, 0 for unvisited)
// n is the number of vertices
// i, j are loop counters
// f is the front index of the queue, initialized to 0
// r is the rear index of the queue, initialized to -1 (empty queue)
int a[20][20], q[20], visited[20], n, i, j, f = 0, r = -1;

// Function to perform Breadth First Search recursively
void bfs(int v) {
    // Loop through all possible vertices
    for (i = 1; i <= n; i++)
        // Check if there is an edge from current vertex 'v' to vertex 'i'
        // AND check if vertex 'i' has not been visited yet
        if (a[v][i] && !visited[i])
            q[++r] = i; // If true, increment rear and enqueue vertex 'i'
            
    // Check if the queue is not empty (front <= rear)
    if (f <= r) {
        visited[q[f]] = 1; // Mark the vertex at the front of the queue as visited
        bfs(q[f++]); // Recursively call bfs on the front vertex, then increment the front pointer (dequeue)
    }
}

// Main function
int main() {
    int v; // Variable to store the starting vertex
    
    // Prompt the user for the number of vertices in the graph
    printf("\n Enter the number of vertices: ");
    scanf("%d", &n); // Read the number of vertices
    
    // Initialize the queue array and visited array to 0
    for (i = 1; i <= n; i++) {
        q[i] = 0;
        visited[i] = 0;
    }
    
    // Prompt the user to enter the adjacency matrix
    printf("\n Enter graph data in matrix form: \n");
    for (i = 1; i <= n; i++)
        for (j = 1; j <= n; j++)
            scanf("%d", &a[i][j]); // Read whether there is an edge between vertex i and j (1 or 0)
    
    // Prompt the user to enter the starting vertex for traversal
    printf("\n Enter the starting vertex: ");
    scanf("%d", &v); // Read the starting vertex
    
    // Call the BFS function with the starting vertex
    bfs(v);
    
    // Print the vertices that were successfully visited
    printf("\n The nodes which are reachable are: \n");
    for (i = 1; i <= n; i++) {
        if (visited[i]) // If the vertex is marked as visited
            printf("%d\t", i); // Print the vertex
        else // If the vertex was not reached
            printf("\n BFS is not possible for vertex %d", i);
    }
    
    return 0; // Return success status
}

/* 
CODE FLOW:
1. The program declares global arrays `a` (adjacency matrix), `q` (queue), and `visited` (tracking array), along with pointers `f` (front) and `r` (rear) for the queue.
2. In `main`, the user inputs the number of vertices `n`, and the program initializes the queue and visited tracking arrays to 0.
3. The user inputs the graph's connections as an adjacency matrix (a grid of 1s and 0s where 1 denotes a path).
4. The user selects a starting vertex `v`, and the `bfs(v)` function is called.
5. Inside `bfs(v)`, a `for` loop checks all adjacent nodes of `v`. If a connected node `i` has not been visited, it is added to the rear of the queue `q`.
6. After queuing all adjacent unvisited nodes, it checks if the queue is not empty (`f <= r`). 
7. It marks the front node of the queue as visited, and recursively calls `bfs` on that node while dequeueing it (`f++`).
8. This recursive process repeats, spreading out layer by layer, until the queue is empty.
9. Finally, the program iterates through the `visited` array and prints all vertices that were marked as 1, indicating they were reachable from the start node.
*/

/* 
SUMMARY:
This program implements the Breadth First Search (BFS) algorithm to traverse a graph. 
BFS explores a graph level by layer; it starts at a selected node and explores all of its immediate neighbors before moving on to the next level of neighbors. 
This code implements BFS recursively using a queue array to keep track of nodes to visit next, and a visited array to prevent processing the same node twice (which prevents infinite loops in cyclic graphs). 
The graph is inputted and processed using an adjacency matrix representation.
*/
