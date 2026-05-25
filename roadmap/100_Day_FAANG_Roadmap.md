# 100-Day DSA + Golang Mastery Roadmap
**The Elite FAANG & Cloud Infrastructure Engineering Preparation System**

Designed for ambitious engineers aiming for Google, Amazon, Meta, Netflix, Palantir, Stripe, and Top-Tier Cloud Roles. This is a military-grade execution system built for mastery, pattern recognition, and problem-solving intuition.

---

## Table of Contents
1. [Rules of the Journey](#rules-of-the-journey)
2. [FAANG Problem Solving Framework](#faang-problem-solving-framework)
3. [Daily Study System](#daily-study-system)
4. [Weekly Revision System](#weekly-revision-system)
5. [Technical Interview Communication Checklist](#technical-interview-communication-checklist)
6. [Phase 1: Arrays & Hashing (Days 1–8)](#phase-1-arrays--hashing-days-18)
7. [Phase 2: Two Pointers & Sliding Window (Days 9–16)](#phase-2-two-pointers--sliding-window-days-916)
8. [Phase 3: Stack & Binary Search (Days 17–24)](#phase-3-stack--binary-search-days-1724)
9. [Phase 4: Linked Lists (Days 25–32)](#phase-4-linked-lists-days-2532)
10. [Phase 5: Trees & BST (Days 33–44)](#phase-5-trees--bst-days-3344)
11. [Phase 6: Heaps & Tries (Days 45–52)](#phase-6-heaps--tries-days-4552)
12. [Phase 7: Backtracking & Recursion (Days 53–60)](#phase-7-backtracking--recursion-days-5360)
13. [Phase 8: Graphs (Days 61–70)](#phase-8-graphs-days-6170)
14. [Phase 9: Dynamic Programming (Days 71–82)](#phase-9-dynamic-programming-days-7182)
15. [Phase 10: Advanced Graphs & Hard Problems (Days 83–85)](#phase-10-advanced-graphs--hard-problems-days-8385)
16. [Phase 11: Golang for Cloud Infrastructure (Days 86–95)](#phase-11-golang-for-cloud-infrastructure-days-8695)
17. [Phase 12: FAANG Interview Endgame (Days 96–100)](#phase-12-faang-interview-endgame-days-96100)

---

## Rules of the Journey

1. **Time-box your struggle.** Spend exactly 20 minutes struggling with an approach before looking at a hint. Spend 35 minutes before looking at the solution. The struggle is where the neural connections are made.
2. **Never copy-paste.** Even if you look at a solution, type it out line by line. If you cannot explain a line, you do not understand it.
3. **Internalize, don't memorize.** Do not memorize the code for "Merge K Sorted Lists." Internalize the pattern: "Multiple sorted streams require a Min-Heap."
4. **Re-solve in 3 days.** If you fail a problem or need the solution, mark it. You must re-solve it from absolute scratch 3 days later.
5. **Complexity First.** Before you write a single line of code, verbally state your time and space complexity. 

---

## FAANG Problem Solving Framework

1. **Clarify (3 mins):** Read the problem twice. What are the constraints? Are there negative numbers? Is the input sorted? State the edge cases.
2. **Brute Force (3 mins):** State the naive O(n²) or O(2ⁿ) solution out loud. This proves you understand the baseline and gives you a fallback.
3. **Pattern Matching (5 mins):** Map the problem to a core pattern. Does it require a fast/slow pointer? A monotonic stack? A BFS traversal? 
4. **Optimization (5 mins):** Can we trade space for time using a HashMap? Can we avoid repeated work using DP or Memoization?
5. **Implementation (15 mins):** Write clean, modular, bug-free code. Use descriptive variable names (`max_so_far`, `left_ptr`, NOT `x`, `y`).
6. **Testing (4 mins):** Dry run your code with a normal case and an edge case. Find your own off-by-one errors before the interviewer points them out.

---

## Daily Study System
- **0:00–0:30 (Theory):** Deeply study the "Concepts to Learn" for the day. Use Striver, NeetCode, or text resources. Do not touch code.
- **0:30–1:15 (Problem 1):** Attempt the first problem using the FAANG framework. 
- **1:15–2:00 (Problem 2):** Attempt the second problem. 
- **2:00–2:30 (Review & Notes):** Write down why you failed, what the trick was, and how to spot this pattern again. Update your mistake log.

---

## Weekly Revision System
- **Sundays are for review.** Do not learn new concepts on Sunday.
- **The 3-Day Rule:** Re-solve any problem you struggled with 3 days prior. 
- **Pattern Extraction:** Look at the 10 problems you solved this week. What did they all have in common? Write a 1-page cheat sheet for the week's pattern.

---

## Technical Interview Communication Checklist
- [ ] Did I repeat the question back in my own words?
- [ ] Did I explicitly state the input bounds and edge cases?
- [ ] Am I thinking out loud while writing? (Never stay silent for >45 seconds).
- [ ] Did I explain *why* I am choosing a specific data structure? ("I am using a heap here because we only need the K largest elements...")
- [ ] Did I proactively state Time & Space complexity at the end?

---

## Phase 1: Arrays & Hashing (Days 1–8)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 1 | Hashing Fundamentals | Hash maps internals, constant O(1) lookup time, hash collisions, trading O(N) space for O(N) time. | Frequency Counting & Lookups | Contains Duplicate (Easy) | Valid Anagram (Easy) | Explain why hash maps are O(1) average but O(N) worst case (collisions). |
| 2 | Hash Map Mastery | Mapping values to indices, multi-pass vs single-pass hashing, difference targeting (target - current). | Complement Search | Two Sum (Easy) | Group Anagrams (Med) | Recognizing that sorting strings takes O(K log K) vs O(K) with char arrays. |
| 3 | Frequency & Buckets | Bucket sort intuition, frequency arrays. O(N) sorting when range is bounded. | Top K Elements | Top K Frequent Elements (Med) | Sort Characters By Freq (Med) | Discussing Heap (O(N log K)) vs Bucket Sort (O(N)) trade-offs. |
| 4 | Prefix Operations | Prefix products and sums. Precomputing values to answer range queries in O(1) time. | Prefix Arrays | Product of Array Except Self (Med) | Subarray Sum Equals K (Med) | Solving without division. Managing running sums in a hash map. |
| 5 | Matrix Hashing | 2D array traversal, mapping 2D coordinates to 1D blocks (`(r/3)*3 + c/3`), Set operations. | Grid State Tracking | Valid Sudoku (Med) | Set Matrix Zeroes (Med) | In-place modifications (using first row/col as markers) to achieve O(1) space. |
| 6 | String Parsing | Delimiters, length-prefixing strings to avoid delimiter collisions. | Encoding & Decoding | Encode and Decode Strings (Med) | Isomorphic Strings (Easy) | Handling edge cases like empty strings, strings containing the delimiter. |
| 7 | Sequence Tracking | Hash Sets for O(1) lookups. Identifying the start of a sequence (num - 1 not in set). | Consecutive Elements | Longest Consecutive Sequence (Med) | Find All Numbers Disappeared (Easy) | Proving that the inner `while` loop only runs O(N) times globally. |
| 8 | Mixed Arrays | Combining prefix sums, hash maps, and basic array manipulation. Reviewing Phase 1. | Pattern Consolidation | Longest Palindrome (Easy) | Minimum Number of Swaps (Med) | Writing exceptionally clean code. Naming variables perfectly. |

---

## Phase 2: Two Pointers & Sliding Window (Days 9–16)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 9 | Opposite End Pointers | Reversing, palindrome checking. Moving `left` and `right` inward based on conditions. | Converging Pointers | Valid Palindrome (Easy) | Two Sum II (Med) | Handling alphanumeric filtering cleanly. Explaining O(1) space. |
| 10 | Pointer Decision Making | Greedy pointer movement. How to decide whether `left` or `right` should move. | Optimal Substructure | Container With Most Water (Med) | 3Sum (Med) | Avoiding duplicates in 3Sum. Why sorting first (O(N log N)) is acceptable. |
| 11 | Advanced Two Pointers | Rain water trapping intuition. Tracking `left_max` and `right_max`. | Min-Max Boundaries | Trapping Rain Water (Hard) | Sort Colors (Med) | Evolving from O(N) space (arrays) to O(1) space (pointers) in Trapping Rain Water. |
| 12 | Fixed Sliding Window | Window initialization, moving the window by adding the right element and removing the left. | State Maintenance | Maximum Average Subarray I (Easy) | Number of Sub-arrays of Size K (Med) | Never recalculating the entire window. Only update the diff. |
| 13 | Dynamic Sliding Window | Expanding `right` to meet a condition, shrinking `left` when condition breaks. | Expand & Shrink | Best Time to Buy/Sell Stock (Easy) | Longest Substring w/o Repeats (Med) | Using a Hash Set/Map to validate the window state efficiently. |
| 14 | Sliding Window Optimization | Tracking maximum character frequency in the current window. Math behind replacements. | Freq Window | Longest Repeating Character Replacement (Med) | Permutation in String (Med) | Why we don't strictly need to shrink the window completely (max_freq logic). |
| 15 | Hard Sliding Window | Managing multiple constraints. Hash map comparison in O(1) using a `have` and `need` counter. | Multi-constraint Window | Minimum Window Substring (Hard) | Subarrays with K Different Integers (Hard) | Code modularity. Extracting the "is window valid" logic into a clean state. |
| 16 | Window Consolidation | Monotonic Deque intuition. Storing indices to maintain a sliding maximum in O(N). | Monotonic Queue | Sliding Window Maximum (Hard) | Minimum Size Subarray Sum (Med) | Explaining why Monotonic Queue operations are amortized O(1). |

---

## Phase 3: Stack & Binary Search (Days 17–24)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 17 | Stack Fundamentals | LIFO principles. Matching pairs, string reversal. Class design for custom stacks. | LIFO & State Reversal | Valid Parentheses (Easy) | Min Stack (Med) | Pushing tuples `(val, current_min)` to achieve O(1) Min Stack retrieval. |
| 18 | Stack Parsing | Postfix evaluation, string generation, maintaining hierarchical state. | Expression Parsing | Evaluate Reverse Polish Notation (Med) | Generate Parentheses (Med) | Using Stack vs Recursion (Implicit Stack) for generation problems. |
| 19 | Monotonic Stack I | Maintaining a strictly increasing or decreasing stack. Finding the "Next Greater Element". | Next Greater Element | Daily Temperatures (Med) | Car Fleet (Med) | Realizing that Car Fleet is just finding intersection times and using a stack. |
| 20 | Monotonic Stack II | Expanding rectangles. Calculating area using `height * (right_boundary - left_boundary)`. | Bounded Expansion | Largest Rectangle in Histogram (Hard) | Maximal Rectangle (Hard) | Handling the remaining elements in the stack after the loop finishes. |
| 21 | Binary Search Basics | `left <= right`, mid calculation to avoid overflow `left + (right-left)//2`. | Divide & Conquer | Binary Search (Easy) | Search a 2D Matrix (Med) | Treating a 2D matrix as a 1D array mathematically `matrix[mid/COLS][mid%COLS]`. |
| 22 | Binary Search on Answer | Recognizing monotonic search spaces (e.g., if speed X works, speed X+1 also works). | Monotonic Condition | Koko Eating Bananas (Med) | Minimum Days to Make Bouquets (Med) | Identifying the min and max possible answers to form the search space bounds. |
| 23 | Rotated Arrays | Finding the pivot point. Deciding which half of a rotated array is strictly sorted. | Shifted Binary Search | Find Minimum in Rotated Sorted Array (Med) | Search in Rotated Sorted Array (Med) | Flawless edge case handling (array size 1, array size 2, completely sorted). |
| 24 | Advanced Binary Search | Partitioning two arrays simultaneously. Time-based queries using binary search. | Partition Search | Time Based Key-Value Store (Med) | Median of Two Sorted Arrays (Hard) | Explaining the partition formula `partitionX + partitionY = (x + y + 1) / 2`. |

---

## Phase 4: Linked Lists (Days 25–32)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 25 | Pointers & Reversal | Node manipulation, dummy nodes to avoid edge cases at the head. | In-place Reversal | Reverse Linked List (Easy) | Merge Two Sorted Lists (Easy) | Iterative vs Recursive approaches and their space complexity differences (O(1) vs O(N)). |
| 26 | Fast & Slow Pointers | Cycle detection (Floyd’s Tortoise & Hare). Finding the middle of a linked list. | Cycle Detection | Linked List Cycle (Easy) | Reorder List (Med) | Merging two halves cleanly. Handling odd/even length lists without null pointer exceptions. |
| 27 | Removal & Math | Finding the Nth node from the end using a gap. Adding numbers digit by digit. | Gap Pointers | Remove Nth Node From End (Med) | Add Two Numbers (Med) | Managing the `carry` variable cleanly without duplicating code. |
| 28 | Advanced Cycle Math | Proving mathematically why the slow pointer and entry pointer meet at the cycle start. | Floyd's Math | Linked List Cycle II (Med) | Find the Duplicate Number (Med) | Treating an array of numbers `[1, N]` as a linked list graph for cycle detection. |
| 29 | Deep Copies & DLL | Copying structures with random pointers using HashMaps or interleaving nodes. | State Mapping | Copy List with Random Pointer (Med) | Design Browser History (Med) | Explaining O(1) space interleaving approach for deep copy. |
| 30 | Systems Design (Lists) | Combining HashMaps with Doubly Linked Lists for O(1) eviction policies. | Eviction Policies | LRU Cache (Med) | LFU Cache (Hard) | Writing modular helper functions `add_node(node)` and `remove_node(node)`. |
| 31 | Multiple Lists | Merging K lists using a Min-Heap or Divide & Conquer. | K-Way Merge | Merge k Sorted Lists (Hard) | Sort List (Med) | Comparing Heap O(N log K) vs Divide & Conquer O(N log K) in interviews. |
| 32 | Advanced Reversal | Reversing lists in chunks. Tracking `prev`, `curr`, `next`, and chunk boundaries. | Chunk Reversal | Reverse Nodes in k-Group (Hard) | Reverse Linked List II (Med) | Meticulous pointer management. Testing with k=1 and k=length. |

---

## Phase 5: Trees & BST (Days 33–44)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 33 | Tree Traversal Basics | Preorder, Inorder, Postorder. Recognizing when to process the node. | DFS (Depth First) | Invert Binary Tree (Easy) | Maximum Depth of Binary Tree (Easy) | Recursion stack depth discussion. Worst-case O(N) space for skewed trees. |
| 34 | Bottom-Up Recursion | Returning values from children to parent. Calculating height to find diameter. | Postorder Aggregation| Diameter of Binary Tree (Easy) | Balanced Binary Tree (Easy) | Returning two values from a recursive function `(is_balanced, height)`. |
| 35 | Tree Comparison | Traversing two trees simultaneously. Subtree identification. | Simultaneous Traversal| Same Tree (Easy) | Subtree of Another Tree (Easy) | Why `Subtree` is O(N * M) time worst-case and how serialization can make it O(N + M). |
| 36 | BST Properties | Inorder traversal of a BST yields sorted order. Left < Node < Right constraints. | Bounds Passing | Lowest Common Ancestor of BST (Med) | Validate Binary Search Tree (Med) | Passing `min_val` and `max_val` down the recursion tree to validate BSTs. |
| 37 | Level Order (BFS) | Using a Queue (Deque). Processing level by level using a `for i in range(len(q))` loop. | BFS (Breadth First) | Binary Tree Level Order Traversal (Med)| Binary Tree Right Side View (Med) | Grabbing the last element of the queue in the inner loop for Right Side View. |
| 38 | State Passing | Passing state from parent to child (top-down). Tracking the max value seen on a path. | Preorder State | Count Good Nodes in Binary Tree (Med)| Path Sum II (Med) | Remembering to backtrack/pop from the path list in Python when exploring paths. |
| 39 | Kth Elements | Using Inorder traversal for BST ranking. Early stopping mechanisms. | Inorder Processing | Kth Smallest Element in a BST (Med) | Construct BST from Preorder Traversal (Med)| Converting recursive Inorder to Iterative Inorder using a stack. |
| 40 | Tree Construction | Rebuilding trees from two traversals. Array slicing vs HashMap for O(1) index lookup. | Divide & Conquer | Construct Tree from Preorder and Inorder (Med)| Flatten Binary Tree to Linked List (Med) | Using global/class variables to track the current preorder index. |
| 41 | Hard Tree Paths | Finding any-to-any node paths. Updating a global max while returning a straight path. | Path Aggregation | Binary Tree Maximum Path Sum (Hard) | Sum Root to Leaf Numbers (Med) | Realizing that a valid path can only include ONE child branch when returning to a parent. |
| 42 | Serialization | Converting a tree to a string and back. Handling nulls cleanly with `#`. | Preorder Parsing | Serialize and Deserialize Binary Tree (Hard)| Serialize and Deserialize BST (Med) | Using an iterator or deque to cleanly consume the string during deserialization. |
| 43 | Tree Consolidation 1 | Mixed tree patterns. Recognizing BFS vs DFS immediately. | Pattern Selection | Populating Next Right Pointers (Med) | House Robber III (Med) | DP on Trees: returning `[rob_this_node, skip_this_node]` from recursion. |
| 44 | Tree Consolidation 2 | Advanced tree views and vertical traversals. | Graph-Tree Bridge | Vertical Order Traversal of Binary Tree (Hard)| Step-By-Step Directions From a Binary Tree Node to Another (Med) | Using HashMaps with `(row, col)` coordinates during tree traversals. |

---

## Phase 6: Heaps & Tries (Days 45–52)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 45 | Min/Max Heap Basics | Python `heapq` is Min-Heap. Multiply by `-1` for Max-Heap. Stream processing. | Priority Queues | Kth Largest Element in a Stream (Easy) | Last Stone Weight (Easy) | Maintaining a heap of size K to achieve O(N log K) time. |
| 46 | Heap Geometry / Sorting | Using tuples `(distance, x, y)` in heaps. Quickselect algorithm. | Distance Sorting | K Closest Points to Origin (Med) | Kth Largest Element in an Array (Med) | Explaining Quickselect average O(N) vs worst-case O(N²) time. |
| 47 | Heaps + HashMaps | Frequency tracking combined with Priority Queues. CPU task scheduling. | Frequency Processing| Task Scheduler (Med) | Top K Frequent Words (Med) | Using a Queue alongside the Heap to handle "cooldown" periods in Task Scheduler. |
| 48 | Advanced Heaps | Two-Heap pattern. Maintaining a Min-Heap and Max-Heap to track the median. | Stream Balancing | Find Median from Data Stream (Hard) | IPO (Hard) | Balancing the heaps: Max-Heap size must be `==` or `+1` of Min-Heap size. |
| 49 | Trie Fundamentals | Prefix trees. Node structure `children = {}`, `isWord = False`. | Prefix Matching | Implement Trie (Prefix Tree) (Med) | Design Add and Search Words Data Structure (Med)| DFS on a Trie to handle the `.` wildcard character in search queries. |
| 50 | Trie + Backtracking | Combining Tries with a 2D matrix DFS. Preventing duplicate words. | Board Search | Word Search II (Hard) | Replace Words (Med) | Optimization: Removing words from the Trie once found to speed up future DFS paths. |
| 51 | Bitwise Tries | Using Tries to store binary representations for XOR maximization. | Bit Manipulation | Maximum XOR of Two Numbers in an Array (Med)| Design File System (Med) | Navigating the Trie by bits (0 or 1) to greedily find the opposite bit for max XOR. |
| 52 | Heaps & Tries Review | Consolidating Priority Queues and Prefix Trees. | Systems Design | Design Twitter (Med) | Find K Pairs with Smallest Sums (Med) | Formulating Twitter as a "Merge K Sorted Lists" problem using heaps. |

---

## Phase 7: Backtracking & Recursion (Days 53–60)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 53 | Subsets & Choices | Decision trees: include element or exclude element. O(2ⁿ) complexity. | Decision Trees | Subsets (Med) | Subsets II (Med) | Handling duplicates by sorting first and skipping `if i > start and nums[i] == nums[i-1]`. |
| 54 | Combinations | Path building. Stopping conditions based on target sums. | Target Paths | Combination Sum (Med) | Combination Sum II (Med) | Differentiating between unbounded reuse (Comb Sum 1) vs single use (Comb Sum 2). |
| 55 | Permutations | Generating all orderings. `O(N!)` complexity. Swapping vs boolean arrays. | Sequence Ordering | Permutations (Med) | Permutations II (Med) | Passing the `path` and `remaining` lists cleanly in Python. |
| 56 | String Backtracking | Slicing strings, palindromic checks. Dictionary lookups. | Substring Partitioning| Palindrome Partitioning (Med) | Letter Combinations of a Phone Number (Med) | Recognizing when to slice `s[i:j]` and when to pass indices to save space. |
| 57 | Matrix Backtracking | DFS on a 2D grid. Tracking `visited` cells using a Set or in-place `#`. | Grid Exploration | Word Search (Med) | Path with Maximum Gold (Med) | Backtracking the `visited` state (`board[r][c] = temp`) after the DFS call returns. |
| 58 | Hard Board States | Tracking complex board state (diagonals, columns). | N-Queens Constraints | N-Queens (Hard) | Sudoku Solver (Hard) | Using HashSets for `cols`, `pos_diag (r+c)`, and `neg_diag (r-c)` in O(1) time. |
| 59 | Expression Building | Backtracking with mathematical evaluation. | Math Search | Expression Add Operators (Hard) | Split Array into Fibonacci Sequence (Med) | Handling multiplication precedence by passing `prev_operand` in the recursion. |
| 60 | Backtracking Consolidation| Reviewing all state-space search patterns. | State Trees | Generate Parentheses (Review) (Med) | Word Search II (Review) (Hard) | Drawing the recursion tree on the whiteboard before coding. |

---

## Phase 8: Graphs (Days 61–70)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 61 | Graph Traversals | DFS and BFS on Graphs. Adjacency lists. Visited sets to prevent infinite loops. | Connected Components| Number of Islands (Med) | Clone Graph (Med) | Mapping original nodes to cloned nodes using a HashMap during traversal. |
| 62 | Grid Graphs | Multi-directional DFS. Calculating areas. | Island Patterns | Max Area of Island (Med) | Surrounded Regions (Med) | The "Reverse Thinking" trick: Run DFS from the borders inward to mark safe zones. |
| 63 | Multi-Source BFS | Initializing the Queue with multiple starting points. Measuring distance/time. | Simultaneous Spread | Rotting Oranges (Med) | Walls and Gates (Med) | Starting BFS from all rotten oranges at time=0, rather than from fresh oranges. |
| 64 | Topological Sort (DFS) | Course prerequisites. Cycle detection using 3 states: Unvisited, Visiting, Visited. | Cycle Detection | Course Schedule (Med) | Course Schedule II (Med) | Explaining how the "Visiting" state catches back-edges (cycles). |
| 65 | Topological Sort (BFS) | Kahn's Algorithm. In-degree arrays. Processing nodes with 0 in-degree. | Kahn's Algorithm | Minimum Height Trees (Med) | Alien Dictionary (Hard) | Recognizing Alien Dictionary is just a Graph building + Topological Sort problem. |
| 66 | Union Find Basics | Disjoint Set Union (DSU). `find()` with path compression, `union()` by rank. | Connectivity | Redundant Connection (Med) | Number of Connected Components (Med) | Implementing DSU from memory perfectly. It is a mandatory FAANG script. |
| 67 | Advanced Union Find | Validating tree structures. Handling grid connectivity dynamically. | Dynamic Graphs | Graph Valid Tree (Med) | Accounts Merge (Med) | Knowing that a valid tree has exactly `n-1` edges and 1 connected component. |
| 68 | Shortest Path (Unweighted)| BFS for shortest path. Transforming states (words to words). | State Machine BFS | Word Ladder (Hard) | Open the Lock (Med) | Pre-computing wildcard patterns (e.g. `*ot`, `h*t`) to optimize graph building. |
| 69 | Shortest Path (Weighted) | Dijkstra's Algorithm. Min-Heap `(cost, node)`. Visited set for cheapest paths. | Dijkstra's | Network Delay Time (Med) | Path with Maximum Probability (Med) | Understanding why Dijkstra cannot handle negative edge weights. |
| 70 | Minimum Spanning Tree | Prim's Algorithm (Min-Heap) vs Kruskal's (Union-Find). | MST | Min Cost to Connect All Points (Med) | Swim in Rising Water (Hard) | Recognizing "Swim in Rising Water" as a Dijkstra/Prim's variant on a grid. |

---

## Phase 9: Dynamic Programming (Days 71–82)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 71 | 1D DP (Memoization) | Top-Down DP. Fibonacci sequences. Overlapping subproblems. | State Caching | Climbing Stairs (Easy) | Min Cost Climbing Stairs (Easy) | Always start by writing the recursive DFS. Then add a memoization dictionary. |
| 72 | 1D DP (Tabulation) | Bottom-Up DP. Array state tracking. Space optimization to O(1). | Bottom-Up Arrays | House Robber (Med) | House Robber II (Med) | House Robber II trick: Run House Robber 1 twice (skip first, skip last). |
| 73 | String DP (Palindromes) | Expanding around center. 2D tables for substring truth values. | Substring States | Longest Palindromic Substring (Med) | Palindromic Substrings (Med) | Comparing O(N²) Expand Around Center vs O(N²) 2D DP. |
| 74 | Array DP & Subsequences| Keeping track of min and max for negative multiplication (Kadane's variant). | Max/Min Tracking | Maximum Product Subarray (Med) | Decode Ways (Med) | Handling the "0" edge case gracefully in Decode Ways. |
| 75 | LIS & Knapsack | Longest Increasing Subsequence. 0/1 Knapsack intuition. | Subsequence Matching| Longest Increasing Subsequence (Med) | Partition Equal Subset Sum (Med) | Explaining how LIS can be optimized to O(N log N) using Binary Search. |
| 76 | Unbounded Knapsack | Infinite coin usage. DP array represents target amounts. | Target Generation | Coin Change (Med) | Coin Change II (Med) | The difference in loop ordering: Permutations vs Combinations in Coin Change. |
| 77 | 2D DP (Grids) | `dp[r][c] = dp[r-1][c] + dp[r][c-1]`. Navigating matrices. | Grid Paths | Unique Paths (Med) | Minimum Path Sum (Med) | Optimizing 2D DP grid space complexity from O(M*N) to O(N) using a single row. |
| 78 | 2D DP (Strings) | Comparing `word1[i]` and `word2[j]`. String alignment. | Edit/Match States | Longest Common Subsequence (Med) | Edit Distance (Hard) | Drawing the 2D DP table on the whiteboard. Explaining insertion/deletion/replace moves. |
| 79 | Advanced String DP | Interleaving, wildcard matching. | Complex Matching | Interleaving String (Med) | Regular Expression Matching (Hard) | Handling the `*` character in Regex DP (matches 0 or many of the preceding element). |
| 80 | State Machine DP | Buy/Sell Stock with Cooldown/Fees. Defining states (Hold, Sold, Rest). | FSM Transitions | Best Time to Buy/Sell Stock with Cooldown (Med)| Best Time to Buy/Sell Stock IV (Hard) | Drawing the State Machine graph and translating it into DP equations. |
| 81 | DFS + Memoization (Hard)| When standard Bottom-Up is too complex. Caching DFS on graphs/grids. | Topological DP | Longest Increasing Path in a Matrix (Hard) | Burst Balloons (Hard) | Burst Balloons insight: Think about the LAST balloon to burst, not the first. |
| 82 | DP Consolidation | Reviewing 1D, 2D, and Knapsack. | Pattern Identification| Target Sum (Med) | Distinct Subsequences (Hard) | Recognizing Target Sum as a 0/1 Knapsack problem translated to math. |

---

## Phase 10: Advanced Graphs & Hard Problems (Days 83–85)

| Day | Topic | Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|-------------------|---------------|-----------|-----------|-----------------|
| 83 | Bellman-Ford & Eulerian | Shortest path with K stops. Eulerian paths (visit every edge once). | Edge Traversals | Cheapest Flights Within K Stops (Med) | Reconstruct Itinerary (Hard) | Why Bellman-Ford is perfect for "At most K steps" (run outer loop K+1 times). |
| 84 | Advanced Intervals | Merging, sorting by start/end time. Sweepline algorithms. | Line Sweeping | Merge Intervals (Med) | Meeting Rooms II (Med) | Using a Min-Heap for Meeting Rooms to track end times of active meetings. |
| 85 | Greedy & Math | Kadane's Algorithm. Proving greedy choice property. | Optimal Local Choice| Jump Game II (Med) | Gas Station (Med) | Explaining *why* the greedy approach works. If `sum(gas) < sum(cost)`, return -1. |

---

## Phase 11: Golang for Cloud Infrastructure (Days 86–95)

*Golang is the language of the Cloud (Docker, Kubernetes, Terraform). In these 10 days, you will map your programming logic to Go's highly opinionated, concurrent-first architecture.*

| Day | Topic | Concepts to Learn | Go Implementation Task |
|-----|-------|-------------------|-------------------------|
| 86 | Syntax, Types & `go mod` | Variables, short assignment `:=`, strict typing, public/private (capitalization), `go mod init`. | Build a CLI calculator. Accept arguments via `os.Args`. Parse strings to ints. |
| 87 | Slices, Maps & Control | `make()`, capacity vs length, `range` loops. Go has no `while` loop (use `for`). | Implement "Two Sum" and "Valid Anagram" in Go using slices and maps. |
| 88 | Pointers & Structs | Pass-by-value vs Reference. Go has no classes; use structs and receiver functions. | Build a `CloudResource` struct with methods `Start()`, `Stop()`, updating its state via pointer receivers. |
| 89 | Interfaces & Duck Typing | Implicit satisfaction. Keep interfaces small (e.g., `io.Reader`). Composition over inheritance. | Create a `Storage` interface. Implement an `S3Bucket` struct and a `LocalFile` struct that both satisfy it. |
| 90 | Error Handling | Errors are just values. `if err != nil`. Custom error types. `fmt.Errorf`. No panics. | Write a file parser that reads JSON, simulating network failures and wrapping errors with context. |
| 91 | Goroutines & WaitGroups | The `go` keyword. Lightweight threads. `sync.WaitGroup` to block until completion. | Write a script that pings 5 URLs concurrently using goroutines and waits for all to finish. |
| 92 | Channels (CSP) | Unbuffered vs Buffered channels. "Share memory by communicating." Deadlock prevention. | Build a Worker Pool. Send 100 jobs (integers) to a channel, read by 3 worker goroutines. |
| 93 | Select & Context | `select` for multiplexing channels. `context.Context` for timeouts and cancellations. | Fetch data from an API. If the API takes longer than 2 seconds, cancel it using `context.WithTimeout`. |
| 94 | JSON & HTTP Servers | `encoding/json` struct tags. `net/http` handlers and multiplexers. | Build a REST API with `GET /health` and `POST /deploy` that accepts JSON and returns status codes. |
| 95 | Concurrency in the Cloud | Mutexes (`sync.Mutex`). Race conditions. `go test -race`. | Build a highly concurrent in-memory Cache (like Redis) with read/write locks, tested with the race detector. |

---

## Phase 12: FAANG Interview Endgame (Days 96–100)

*No new learning. Pure execution. Simulating the brutal pressure of a FAANG interview.*

| Day | Topic | Activity | Interview Focus |
|-----|-------|----------|-----------------|
| 96 | **MOCK: Arrays, Strings, Hashing** | Solve 2 Hards. 45-minute timer. NO IDE. Write code in Google Docs or a plain text editor. | Can you write bug-free code without syntax highlighting and auto-complete? Talk out loud to an imaginary interviewer. |
| 97 | **MOCK: Trees, Graphs, BFS/DFS** | Solve 2 Mediums. 40-minute timer. Whiteboard simulation. | Focus on edge cases. What if the tree is entirely left-skewed? What if the graph is disconnected? |
| 98 | **MOCK: DP & Backtracking** | Solve 1 Hard. 45-minute timer. | You must draw the decision tree. Identify the overlapping subproblems verbally before coding the memoization. |
| 99 | **MOCK: Mixed System/Go Design** | Implement a Thread-Safe LRU Cache in Go. | Demonstrate mastery of Structs, Pointers, Maps, Doubly Linked Lists, and Mutexes in Go. |
| 100| **Mental Reset & Review** | Read through your entire Mistake Log. Review your Pattern Cheat Sheets. | Sleep 8 hours. Confidence is your greatest weapon. You have executed a 100-day military-grade system. You are ready. |

---
*Generated by Antigravity — Elite FAANG Preparation System.*
