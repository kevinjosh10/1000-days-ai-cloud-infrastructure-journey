# 🚀 125-Day DSA + Golang + System Design Mastery Roadmap

> **The Elite FAANG & Cloud Infrastructure Engineering Preparation System — Version 2.0**

![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)
![Target](https://img.shields.io/badge/Target-FAANG%20%7C%20Unicorns-blue?style=for-the-badge)
![Focus](https://img.shields.io/badge/Focus-System_Design%20%7C%20DSA%20%7C%20Golang-orange?style=for-the-badge)

Designed for ambitious engineers aiming for **Google, Amazon, Meta, Netflix, Palantir, Stripe**, and Top-Tier Cloud Infrastructure Roles. This is a military-grade execution system built for mastery, pattern recognition, and problem-solving intuition.

> [!NOTE]
> *Upgraded from 100 days. All 16 planned improvements applied: 3 missing sections written, Phase 10 expanded from 3 to 6 days, Phase 11 expanded with a Go+DSA bridge, Phase 12 expanded from 5 to 11 mock days, Phase 13 (System Design, 10 days) added, Phase 14 (Behavioral Prep, 3 days) added, Mistake Log and Pattern Cheat Sheet formats defined, resources section added, and all LeetCode Premium problems flagged with free alternatives.*

---

## 📑 Table of Contents

1. [Rules of the Journey](#rules-of-the-journey)
2. [FAANG Problem Solving Framework](#faang-problem-solving-framework)
3. [Daily Study System](#daily-study-system)
4. [Weekly Revision System](#weekly-revision-system)
5. [Technical Interview Communication Checklist](#technical-interview-communication-checklist)
6. [Mistake Log Format](#mistake-log-format)
7. [Pattern Cheat Sheet Format](#pattern-cheat-sheet-format)
8. [Recommended Resources](#recommended-resources)
9. [Phase Difficulty Overview](#phase-difficulty-overview)
10. [Phase 1: Arrays & Hashing (Days 1–8)](#phase-1-arrays--hashing-days-18)
11. [Phase 2: Two Pointers & Sliding Window (Days 9–16)](#phase-2-two-pointers--sliding-window-days-916)
12. [Phase 3: Stack & Binary Search (Days 17–24)](#phase-3-stack--binary-search-days-1724)
13. [Phase 4: Linked Lists (Days 25–32)](#phase-4-linked-lists-days-2532)
14. [Phase 5: Trees & BST (Days 33–44)](#phase-5-trees--bst-days-3344)
15. [Phase 6: Heaps & Tries (Days 45–52)](#phase-6-heaps--tries-days-4552)
16. [Phase 7: Backtracking & Recursion (Days 53–60)](#phase-7-backtracking--recursion-days-5360)
17. [Phase 8: Graphs (Days 61–70)](#phase-8-graphs-days-6170)
18. [Phase 9: Dynamic Programming (Days 71–83)](#phase-9-dynamic-programming-days-7183)
19. [Phase 10: Advanced Graphs & Hard Problems (Days 84–89)](#phase-10-advanced-graphs--hard-problems-days-8489)
20. [Phase 11: Golang for Cloud Infrastructure (Days 90–101)](#phase-11-golang-for-cloud-infrastructure-days-90101)
21. [Phase 12: FAANG Interview Endgame (Days 102–112)](#phase-12-faang-interview-endgame-days-102112)
22. [Phase 13: System Design (Days 113–122)](#phase-13-system-design-days-113122)
23. [Phase 14: Behavioral Prep (Days 123–125)](#phase-14-behavioral-prep-days-123125)

---

## 📜 Rules of the Journey

> [!IMPORTANT]
> 1. **Time-box your struggle.** Spend exactly 20 minutes struggling with an approach before looking at a hint. Spend 35 minutes before looking at the solution.
> 2. **Never copy-paste.** Even if you look at a solution, type it out line by line. If you cannot explain a line, you do not understand it.
> 3. **Internalize, don't memorize.** Internalize the pattern: "Multiple sorted streams require a Min-Heap."
> 4. **Re-solve in 3 days.** If you fail a problem or need the solution, mark it. You must re-solve it from absolute scratch 3 days later. Then again on Day 7. Then again on Day 14.
> 5. **Complexity First.** Before you write a single line of code, verbally state your time and space complexity.
> 6. **Maintain the Mistake Log every single day.** A roadmap without a written record of failures is just a wish list.

---

## 🧠 FAANG Problem Solving Framework

1. **Clarify (3 mins):** Read the problem twice. What are the constraints? Are there negative numbers? Is the input sorted? State the edge cases.
2. **Brute Force (3 mins):** State the naive O(n²) or O(2ⁿ) solution out loud. This proves you understand the baseline.
3. **Pattern Matching (5 mins):** Map the problem to a core pattern (fast/slow pointer, monotonic stack, BFS).
4. **Optimization (5 mins):** Can we trade space for time using a HashMap? Can we avoid repeated work using DP?
5. **Implementation (15 mins):** Write clean, modular, bug-free code. Use descriptive variable names.
6. **Testing (4 mins):** Dry run your code with a normal case and an edge case.

---

## 📅 Daily Study System

**Target: 1 hour 45 minutes per day.** Every day, every phase, no exceptions.

| Block | Duration | Activity |
|-------|----------|----------|
| Concept Review | 20 min | Read the "Detailed Concepts to Learn" column for today's day. Look up any term you cannot fully explain. Sketch the data structure or algorithm on paper. |
| Problem 1 | 35 min | Apply the full 6-step FAANG Framework. Write on paper or Google Docs first — not an IDE. Only move to IDE after writing the logic. |
| Problem 2 | 35 min | Same framework. If Problem 2 is significantly harder (Hard vs Easy), allow up to 45 min and cut concept review to 10 min. |
| Log & Reflect | 15 min | Update your Mistake Log for any problem you needed a hint for. Add or update your Pattern Cheat Sheet for today's pattern. Write one sentence: "Today I learned that [pattern insight]." |

**Time adjustments by phase difficulty:**
- Phases 1–4 (Arrays to Linked Lists): 1h30m is often sufficient.
- Phases 5–8 (Trees to Graphs): Stick to the full 1h45m.
- Phases 9–10 (DP and Advanced Graphs): Budget 2h30m to 3h. These phases will take longer. Do not rush them. Most candidates abandon the roadmap here — knowing this ahead of time is your advantage.
- Phases 11–14 (Go, Mocks, Design, Behavioral): 2h per day.

**Non-negotiable daily habits:**
- No IDE auto-complete for the first pass. Think first, type second.
- Complexity stated out loud before every solution, even when alone.
- Mistake Log updated the same day, never the next morning.

---

## 🔄 Weekly Revision System

**The Spaced Repetition Schedule.** This is what separates engineers who retain patterns from engineers who re-learn the same problems every week.

### The Four Revision Triggers

**Trigger 1 — Day 3 Re-solve (Mid-week check):**
Any problem marked in your Mistake Log as "needed hint" or "needed full solution" must be re-solved from memory exactly 3 days later. No notes, no hints. If you fail again, mark it for Day 7.

**Trigger 2 — Day 7 Re-solve (Weekly Sunday block):**
Every Sunday, spend 2 hours on revision only — zero new problems.
- Step 1: Re-solve all Day-7 triggered problems from memory.
- Step 2: Review your Pattern Cheat Sheet for the week's phases. Read it, close it, try to recreate it from memory.
- Step 3: Re-read your Mistake Log entries from the past 7 days. Look for patterns in your mistakes (e.g., "I keep forgetting to handle null nodes" or "I keep using O(N) space when O(1) is possible").

**Trigger 3 — Day 14 Re-solve (Two-week checkpoint):**
Any problem that you failed on both Day 3 and Day 7 goes onto the Day 14 list. These are your "stubborn" problems. Re-solve them on Day 14 as a timed drill: 20 minutes maximum, cold start.

**Trigger 4 — Day 30 Recall (Monthly audit):**
On the last Sunday of each month, pick 5 random problems from your Mistake Log that are now marked "resolved." Re-solve them cold. If you blank on any, they re-enter the Day-3 cycle. This prevents long-term decay.

### Weekly Schedule Template

| Day | Primary Activity | Revision Activity |
|-----|-----------------|-------------------|
| Mon | New problems | Day-3 triggered re-solves |
| Tue | New problems | Day-3 triggered re-solves |
| Wed | New problems | Day-3 triggered re-solves |
| Thu | New problems | Day-3 triggered re-solves |
| Fri | New problems | Day-3 triggered re-solves |
| Sat | New problems | Day-3 triggered re-solves |
| Sun | NO new problems | 2-hour revision block (Day-7 re-solves + Pattern Cheat Sheet review + Mistake Log audit) |

---

## 🗣️ Technical Interview Communication Checklist

Use this checklist as a mental script during every timed mock and every real interview. The goal is never to be silent for more than 15 seconds.

### Before You Write a Line of Code

- [ ] Read the problem silently once. Then read it aloud to yourself (or the interviewer). This forces you to process it twice.
- [ ] State the input type, output type, and any constraints you notice: *"We're given an array of integers, looking for a target sum, and the array can contain negatives."*
- [ ] State at least two edge cases before being asked: *"Edge case one — empty array. Edge case two — no valid pair exists. Edge case three — duplicate elements."*
- [ ] State the brute force solution and its complexity, even if it's terrible: *"A naive O(n²) approach would be nested loops checking every pair. That's too slow, but it establishes the baseline."*
- [ ] Map to a pattern out loud: *"This looks like a Complement Search problem — classic HashMap pattern."*
- [ ] State your optimized complexity before writing a single line: *"I believe I can solve this in O(n) time and O(n) space."*

### While You Write Code

- [ ] Narrate as you type. Never code in silence: *"I'm initializing a hash map here to store values I've already seen..."*
- [ ] If you hit a mental block, narrate that too: *"Let me think about the pointer movement here for a second..."* — silence is worse than thinking out loud.
- [ ] Use meaningful variable names: `left` and `right` not `i` and `j`. `freq_map` not `m`. `complement` not `c`.
- [ ] Write helper functions for repeated logic — shows software engineering maturity.

### After Writing Code

- [ ] Dry run with a normal case. Trace through your code step by step, not in your head — write the variable values.
- [ ] Dry run with an edge case (empty input, single element, all duplicates).
- [ ] Proactively mention any trade-offs: *"I'm using O(n) space here. If we needed O(1) space, we could sort first and use two pointers, but that would cost O(n log n) time."*
- [ ] If asked "can you improve this further?" — pause, think, then answer. Do not panic-propose a wrong optimization.

### If You Are Stuck

- [ ] State what you know: *"I know I need O(n) time. I know I've seen this complement pattern before in Two Sum..."*
- [ ] Ask a targeted clarifying question: *"Is the input guaranteed to be sorted?"* — not a vague *"Can you give me a hint?"*
- [ ] Talk through what you've ruled out: *"I've eliminated the O(n²) approach. I'm trying to figure out if this is a sliding window or a two-pointer problem..."*

---

## ❌ Mistake Log Format

Create this as a spreadsheet or Markdown table. Begin it on Day 1. Update it the same day, not the next morning.

| Date | Problem Name | Difficulty | What I Tried | Root Cause of Failure | Pattern I Missed | Re-solve Date | Re-solved? |
|------|-------------|------------|-------------|----------------------|-----------------|--------------|------------|
| Day 1 | Contains Duplicate | Easy | Nested loop O(n²) | Did not think of HashSet for O(1) lookup | Frequency Counting | Day 4 | |
| Day 3 | Group Anagrams | Medium | Sorted string as key, worked. Forgot sorted() returns a list in Python, can't hash it directly | Language pitfall + HashMap grouping | Hash Map Mastery | Day 6 | |

**Fields explained:**
- **What I Tried:** Honest description of your first attempt. Not "I tried the wrong approach." Specifically what you did and why.
- **Root Cause of Failure:** One of these five causes covers 95% of all failures: (1) Did not recognize the pattern; (2) Recognized pattern but implemented it wrong; (3) Correct logic but language/syntax error; (4) Off-by-one error; (5) Forgot to handle an edge case.
- **Pattern I Missed:** The specific pattern from the Pattern Cheat Sheet this problem maps to.

---

## 📋 Pattern Cheat Sheet Format

Maintain one page per pattern. Each entry has five fields. Build this incrementally — add entries as you encounter each pattern. By Day 100, you will have 20+ fully populated entries.

### Template

```
PATTERN: [Pattern Name]
TRIGGER: When to recognize this pattern in a problem (1-2 sentences).
GO TEMPLATE:
  [minimal code skeleton in Go showing the core mechanism]
COMPLEXITY: Time — O(?). Space — O(?).
CANONICAL PROBLEMS: [Problem 1], [Problem 2], [Problem 3]
```

### Example Entry

```
PATTERN: Sliding Window (Dynamic)
TRIGGER: "Longest/shortest subarray/substring" with a validity condition. Window size varies.
GO TEMPLATE:
  left := 0
  for right := 0; right < len(s); right++ {
      // expand window: process s[right]
      for /* window is invalid */ {
          // shrink window: unprocess s[left]
          left++
      }
      // update result
  }
COMPLEXITY: Time — O(n). Space — O(k) where k is the window's state size.
CANONICAL PROBLEMS: Longest Substring Without Repeating Characters, Minimum Window Substring, Longest Repeating Character Replacement
```

---

## 📚 Recommended Resources

**Problem Practice:**
- **NeetCode.io** — Video solutions for every problem in this roadmap. Watch only after your own genuine attempt. The explanations match the "Detailed Concepts" column precisely.
- **LintCode** — Free alternatives for all LeetCode Premium problems flagged in this roadmap. Search by exact problem name.

**System Design (required for Phase 13):**
- **System Design Primer** — github.com/donnemartin/system-design-primer — Free, comprehensive, start here.
- **System Design Interview Vol. 1 & 2** by Alex Xu — The industry-standard book. Read alongside Phase 13.
- **Designing Data-Intensive Applications** by Martin Kleppmann — Deeper distributed systems theory. Read Chapter 1–3 before Phase 13.

**Golang:**
- **Go by Example** — gobyexample.com — Reference for Go syntax and patterns. Bookmark it from Day 86.
- **Effective Go** — go.dev/doc/effective_go — Official idiom guide. Read before Phase 11.
- **Go Playground** — play.golang.org — Run Go snippets instantly without a local setup.

**Mock Interviews:**
- **Pramp.com** — Free peer mock interviews. Use from Phase 12 onward for pair mock days.
- **Interviewing.io** — Paid anonymous mocks with FAANG engineers. Use for at least 2 sessions before a real interview.

**AWS Cloud (for System Design):**
- **AWS Well-Architected Framework** — Free PDF from AWS. Read the Reliability and Performance pillars before Phase 13.
- **AWS Architecture Center** — aws.amazon.com/architecture — Reference architectures for real systems. Study 3-4 diagrams before Day 118.

---

## 📊 Phase Difficulty Overview

This heatmap tells you what to expect before you arrive at each phase. The candidates who abandon this roadmap almost always do so at Phase 9. Knowing the terrain is your advantage.

| Phase | Days | Difficulty | Est. Daily Time | Note |
|-------|------|------------|----------------|------|
| 1 Arrays & Hashing | 1–8 | Easy | 1h30m | Good warm-up. Build the Mistake Log habit here. |
| 2 Two Pointers & Sliding Window | 9–16 | Easy–Medium | 1h30m | First non-trivial patterns. Sliding window trips most people on Day 15. |
| 3 Stack & Binary Search | 17–24 | Medium | 1h45m | Monotonic stack is abstract at first. Spend time on Day 19–20. |
| 4 Linked Lists | 25–32 | Medium | 1h45m | Pointer management is mechanical. Draw every step before coding. |
| 5 Trees & BST | 33–44 | Medium–Hard | 2h | Twelve days for a reason. DFS recursion patterns here are foundational for DP. |
| 6 Heaps & Tries | 45–52 | Medium–Hard | 2h | Trie + Backtracking on Day 50 is a genuine hard day. |
| 7 Backtracking | 53–60 | Hard | 2h15m | Decision tree thinking is a new mental model. Slow down here. |
| 8 Graphs | 61–70 | Hard | 2h15m | Union-Find on Day 66 must be memorized perfectly. This is a script. |
| 9 Dynamic Programming | 71–83 | Very Hard | 2h45m | The hardest phase. This is where most candidates quit. Do not quit. |
| 10 Advanced Graphs | 84–89 | Hard | 2h | Floyd-Warshall and Tarjan's are new algorithms. Budget extra time on Days 87–89. |
| 11 Golang + DSA Bridge | 90–101 | Medium | 2h | Syntax is easy. Concurrency model is the hard part. |
| 12 Mock Interviews | 102–112 | Pressure | 2h | No new learning. Pure execution under time pressure. |
| 13 System Design | 113–122 | Medium–Hard | 2h | Conceptual, not algorithmic. Slower reading pace is fine. |
| 14 Behavioral Prep | 123–125 | Light | 1h30m | Reflection-heavy. Do not skip this — FAANG rejects strong coders on behavioral. |

> [!WARNING]
> **The critical warning:** The jump from Phase 8 (Graphs) to Phase 9 (DP) is the steepest difficulty increase in the entire roadmap. If you arrive at Day 71 on schedule, you are doing well. If you arrive tired, add one rest day before Phase 9 — do not enter it exhausted.

---

> [!TIP]
> *(Note: The "Detailed Concepts to Learn" column provides a highly concentrated conceptual breakdown. You can read it directly, or copy/paste it into an AI to request a deeper 30-minute interactive lesson before tackling the day's problems. Problems marked [PREMIUM] are behind LeetCode's paywall — free alternatives are listed in the Recommended Resources section or noted inline.)*

---

## 🟢 Phase 1: Arrays & Hashing (Days 1–8)

**Estimated daily time: 1h30m. Difficulty: Easy.**
This is your warm-up phase. Build the Mistake Log habit here, not later. Every day that you skip the log is a day that future-you loses.

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 1 | Hashing Fundamentals | **Hash Maps vs Arrays:** Understand that arrays offer O(1) access by index, while Hash Maps use a hashing function to offer O(1) average access by a generic key. Learn how hash collisions occur (when two keys hash to the same bucket) and how they degrade performance to O(N). The core strategy here is trading O(N) auxiliary space to avoid O(N^2) nested loops. | Frequency Counting | Contains Duplicate (Easy) | Valid Anagram (Easy) | Explain why hash maps are O(1) average but O(N) worst case. |
| 2 | Hash Map Mastery | **Complement Search:** When looking for a pair that meets a condition (like a target sum), do not use a nested loop to check all pairs. Instead, iterate once. At each element, calculate its "complement" (`target - current_value`). Check if the complement exists in your Hash Map. If it does, you've found the pair in O(N) time. | Complement Search | Two Sum (Easy) | Group Anagrams (Med) | Recognizing that sorting strings takes O(K log K) vs O(K) with char arrays. |
| 3 | Frequency & Buckets | **Bucket Sort Strategy:** Standard sorting algorithms are bounded by O(N log N). However, if the range of possible values is limited (e.g., frequencies can only be between 1 and N), you can create an array of "buckets" where the index represents the frequency. This allows you to sort items by frequency in strict O(N) time. | Top K Elements | Top K Frequent Elements (Med) | Sort Characters By Frequency (Med) | Discussing Heap (O(N log K)) vs Bucket Sort (O(N)) trade-offs. |
| 4 | Prefix Operations | **Precomputation & Prefix Arrays:** When you need to repeatedly calculate the sum, product, or state of a subarray, do not recalculate it every time. Create a "Prefix Array" where `prefix[i]` stores the cumulative result up to index `i`. This transforms O(N) range queries into O(1) lookups. | Prefix Arrays | Product of Array Except Self (Med) | Subarray Sum Equals K (Med) | Solving without division. Managing running sums in a hash map. |
| 5 | Matrix Hashing | **Grid State Tracking:** Matrices are 2D arrays, but they are often traversed linearly. Learn how to map a 2D coordinate `(r, c)` to a 1D sub-box index (e.g., `(r/3)*3 + c/3` in Sudoku). Learn to use Hash Sets to track which rows, columns, or sub-boxes contain specific values to achieve O(1) lookups during traversal. | Grid State Tracking | Valid Sudoku (Med) | Set Matrix Zeroes (Med) | In-place modifications (using first row/col as markers) for O(1) space. |
| 6 | String Parsing | **Encoding & Delimiters:** When serializing data (converting a list of strings to a single string), you must prevent delimiter collision. The safest method is "Length-Prefixing", where you store the length of the string followed by a delimiter, followed by the string itself (e.g., `4#word`). | Encoding & Decoding | Encode and Decode Strings [PREMIUM — find free on NeetCode.io] (Med) | Isomorphic Strings (Easy) | Handling edge cases like empty strings or strings containing delimiters. |
| 7 | Sequence Tracking | **O(1) Sequence Identification:** To find the longest consecutive sequence in an unsorted array in O(N) time, convert the array to a Hash Set. Only start counting a sequence if the current number is the "start" of a sequence. You know it's a start if `num - 1` does NOT exist in the set. | Consecutive Elements | Longest Consecutive Sequence (Med) | Find All Numbers Disappeared in an Array (Easy) | Proving that the inner `while` loop only runs O(N) times globally. |
| 8 | Mixed Arrays | **Array Pattern Consolidation:** The ability to combine patterns. You must be able to instantly recognize when to use a Hash Map (O(1) lookups), a Prefix Sum (range queries), or in-place swapping (O(1) space constraints). This day focuses on mixing these patterns cleanly. | Pattern Consolidation | Longest Palindrome (Easy) | Minimum Number of Swaps to Make Strings Equal (Med) | Writing exceptionally clean code. Naming variables perfectly. |

---

## 🟢 Phase 2: Two Pointers & Sliding Window (Days 9–16)

**Estimated daily time: 1h30m. Difficulty: Easy–Medium.**
The sliding window pattern trips most people on Day 14–15. Pay close attention to the difference between "never need to shrink" (Day 14) and "must shrink" (Day 13).

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 9 | Opposite End Pointers | **Converging Pointers:** When dealing with sorted arrays or palindromes, initialize one pointer at `0` and another at `N-1`. Move them inward based on specific conditions. If the sum is too large, decrement the right pointer. If the sum is too small, increment the left pointer. This achieves O(N) time and O(1) space. | Converging Pointers | Valid Palindrome (Easy) | Two Sum II (Med) | Handling alphanumeric filtering cleanly. Explaining O(1) space. |
| 10 | Pointer Decision Making | **Greedy Optimization:** In problems like "Container With Most Water," you must make a greedy decision on which pointer to move. Always move the pointer that is the "bottleneck" (e.g., the pointer pointing to the smaller height), because keeping the smaller height guarantees the area can never increase, even if the width shrinks. | Optimal Substructure | Container With Most Water (Med) | 3Sum (Med) | Avoiding duplicates in 3Sum. Why sorting first is acceptable. |
| 11 | Advanced Two Pointers | **Min-Max Boundaries (Trapping Rain Water):** Water trapped above a bar is determined by `min(max_left_height, max_right_height) - current_height`. Instead of precomputing these max heights in O(N) space arrays, use two pointers moving inward, keeping a running tally of `left_max` and `right_max` to achieve O(1) space. | Min-Max Boundaries | Trapping Rain Water (Hard) | Sort Colors (Med) | Evolving from O(N) space (arrays) to O(1) space (pointers). |
| 12 | Fixed Sliding Window | **State Maintenance:** A Fixed Sliding Window is used when the subarray size `K` is constant. Instead of recalculating the sum/state of the window from scratch (O(K) time), simply subtract the element falling out of the left side of the window, and add the new element entering the right side. This drops the time from O(N*K) to O(N). | State Maintenance | Maximum Average Subarray I (Easy) | Number of Sub-arrays of Size K and Average >= Threshold (Med) | Never recalculating the entire window. Only update the diff. |
| 13 | Dynamic Sliding Window | **Expand & Shrink Strategy:** When the window size is variable (e.g., "Find the longest substring without repeating characters"), expand the `right` pointer aggressively to grow the window. If the window becomes invalid (e.g., a duplicate appears), use a `while` loop to advance the `left` pointer until the window becomes valid again. | Expand & Shrink | Best Time to Buy and Sell Stock (Easy) | Longest Substring Without Repeating Characters (Med) | Using a Hash Set/Map to validate the window state efficiently. |
| 14 | Sliding Window Optimization | **Frequency Window Math:** In replacement problems, the window is valid if `(Length of Window) - (Count of Most Frequent Character) <= Allowed Replacements`. You do not need to strictly shrink the window when it's invalid; you can just shift it by moving both left and right pointers, because you only care about finding a *larger* window. | Freq Window | Longest Repeating Character Replacement (Med) | Permutation in String (Med) | Why we don't strictly need to shrink the window completely. |
| 15 | Hard Sliding Window | **Multi-constraint Validation:** When a window must contain specific counts of characters (e.g., Minimum Window Substring), comparing two Hash Maps takes O(26) time. Optimize this to O(1) by maintaining an integer `have` (characters currently meeting the requirement) and `need` (total characters required). When `have == need`, the window is valid. | Multi-constraint Window | Minimum Window Substring (Hard) | Subarrays with K Different Integers (Hard) | Code modularity. Extracting the 'is window valid' logic. |
| 16 | Window Consolidation | **Monotonic Deque:** To find the maximum element in a sliding window in O(N) time, use a Double-Ended Queue (Deque) that strictly decreases. Store indices, not values. Before adding a new element, pop all smaller elements from the back (they can never be the maximum now). The front of the deque will always be the maximum. | Monotonic Queue | Sliding Window Maximum (Hard) | Minimum Size Subarray Sum (Med) | Explaining why Monotonic Queue operations are amortized O(1). |

---

## 🟡 Phase 3: Stack & Binary Search (Days 17–24)

**Estimated daily time: 1h45m. Difficulty: Medium.**
Monotonic stack is abstract on first contact. Spend extra time on Days 19–20. Draw the stack state for every element as you trace through examples.

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 17 | Stack Fundamentals | **LIFO & State History:** Stacks operate on Last-In-First-Out. They are the ultimate data structure for reversing order, matching pairs (valid parentheses), or maintaining a history of states. To design an O(1) Min Stack, push tuples of `(value, current_minimum_at_this_level)` so the minimum is always cached alongside the value. | LIFO & State Reversal | Valid Parentheses (Easy) | Min Stack (Med) | Pushing tuples `(val, current_min)` to achieve O(1) Min Stack retrieval. |
| 18 | Stack Parsing | **Expression Evaluation:** Stacks are heavily used in compiler design to parse mathematical strings. In Postfix notation (Reverse Polish Notation), you push numbers onto the stack. When you encounter an operator (`+, -, *, /`), you pop the top two numbers, apply the operator, and push the result back onto the stack. | Expression Parsing | Evaluate Reverse Polish Notation (Med) | Generate Parentheses (Med) | Using Stack vs Recursion (Implicit Stack) for generation problems. |
| 19 | Monotonic Stack I | **Next Greater Element:** A Monotonic Stack maintains elements in a strictly increasing or strictly decreasing order. To find the "Next Greater Element" for every item in an array in O(N) time, push elements to the stack. If the current element is larger than the top of the stack, pop the stack — the current element is the "Next Greater" for the popped item. | Next Greater Element | Daily Temperatures (Med) | Car Fleet (Med) | Realizing Car Fleet is finding intersection times and using a stack. |
| 20 | Monotonic Stack II | **Bounded Expansion (Histograms):** To find the largest rectangle in a histogram, you need to know how far a bar can expand left and right. A monotonic increasing stack tracks this. When you pop an element, the current index is its right boundary, and the new top of the stack is its left boundary. `Width = right - left - 1`. | Bounded Expansion | Largest Rectangle in Histogram (Hard) | Maximal Rectangle (Hard) | Handling the remaining elements in the stack after the loop finishes. |
| 21 | Binary Search Basics | **Divide & Conquer Search:** Binary Search drops O(N) linear search to O(log N) by dividing the search space in half. Always use `mid = left + (right - left) / 2` to prevent integer overflow. For a 2D sorted matrix, treat it mathematically as a 1D array: `matrix[mid / COLS][mid % COLS]`. | Divide & Conquer | Binary Search (Easy) | Search a 2D Matrix (Med) | Treating a 2D matrix as a 1D array mathematically. |
| 22 | Binary Search on Answer | **Monotonic Search Space:** Sometimes the array isn't sorted, but the *answer* is sorted. If an eating speed of `X` allows you to finish the bananas in time, then `X+1`, `X+2`, etc., will also work. This True/False boundary allows you to Binary Search the optimal answer between `1` (min speed) and `max(array)` (max speed). | Monotonic Condition | Koko Eating Bananas (Med) | Minimum Days to Make Bouquets (Med) | Identifying the min and max possible answers to form bounds. |
| 23 | Rotated Arrays | **Shifted Binary Search:** When a sorted array is rotated (e.g., `[4,5,6,1,2,3]`), one half of the array will ALWAYS be perfectly sorted. You must check `nums[left] <= nums[mid]` to determine which half is sorted. Then, check if your target falls within the bounds of that sorted half to know whether to move `left` or `right`. | Shifted Binary Search | Find Minimum in Rotated Sorted Array (Med) | Search in Rotated Sorted Array (Med) | Flawless edge case handling (array size 1, array size 2). |
| 24 | Advanced Binary Search | **Partitioning (Median of Two Arrays):** To find the median of two sorted arrays in O(log(min(N,M))), use Binary Search to partition the smaller array. The correct partition occurs when `max(Left_A) <= min(Right_B)` and `max(Left_B) <= min(Right_A)`. | Partition Search | Time Based Key-Value Store (Med) | Median of Two Sorted Arrays (Hard) | Explaining `partitionX + partitionY = (x + y + 1) / 2`. |

---

## 🟡 Phase 4: Linked Lists (Days 25–32)

**Estimated daily time: 1h45m. Difficulty: Medium.**
Pointer management is mechanical. Draw every pointer state before writing a single line of code. This habit will save you from bugs that are otherwise invisible.

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 25 | Pointers & Reversal | **In-Place Mutation:** Reversing a linked list requires manipulating pointers without losing the rest of the list. You must track three nodes: `prev`, `curr`, and `next`. A "Dummy Node" (a fake node pointing to the head) is a critical pattern to simplify edge cases where the head of the list might change or be deleted. | In-place Reversal | Reverse Linked List (Easy) | Merge Two Sorted Lists (Easy) | Iterative vs Recursive approaches and space complexity O(1) vs O(N). |
| 26 | Fast & Slow Pointers | **Tortoise & Hare Algorithm:** By advancing one pointer by 1 step (slow) and another by 2 steps (fast), you can find the middle of a linked list (when fast reaches the end, slow is at the middle). If there is a cycle, the fast pointer will eventually "lap" the slow pointer and they will collide, proving a cycle exists. | Cycle Detection | Linked List Cycle (Easy) | Reorder List (Med) | Merging two halves cleanly. Handling odd/even length lists. |
| 27 | Removal & Math | **Gap Pointers:** To find the Nth node from the end in a single pass, send the `right` pointer N steps ahead first. Then move both `left` and `right` pointers one step at a time. When `right` hits the end, `left` will be exactly at the Nth node from the end. | Gap Pointers | Remove Nth Node From End of List (Med) | Add Two Numbers (Med) | Managing the `carry` variable cleanly without duplicating code. |
| 28 | Advanced Cycle Math | **Floyd's Cycle Proof:** When the slow and fast pointers collide in a cycle, they are at an intersection point. Mathematically, the distance from the head to the start of the cycle is EXACTLY equal to the distance from the intersection point to the start of the cycle. Moving two pointers at speed 1 from both locations will find the cycle start. | Floyd's Math | Linked List Cycle II (Med) | Find the Duplicate Number (Med) | Treating an array of numbers `[1, N]` as a linked list graph. |
| 29 | Deep Copies & DLL | **Interleaving Nodes:** To deep copy a linked list with random pointers in O(1) space, interleave the cloned nodes with the original nodes (`A -> A' -> B -> B'`). Set the random pointers using `curr.next.random = curr.random.next`. Finally, detach the cloned list from the original list. | State Mapping | Copy List with Random Pointer (Med) | Design Browser History (Med) | Explaining O(1) space interleaving approach for deep copy. |
| 30 | Systems Design (Lists) | **Eviction Policies (LRU Cache):** An LRU Cache requires O(1) time for `get()` and `put()`. A Hash Map provides O(1) access to nodes, but no ordering. A Doubly Linked List provides O(1) insertions/deletions and ordering, but O(N) access. Combining them (HashMap pointing to DLL nodes) creates the ultimate O(1) cache. | Eviction Policies | LRU Cache (Med) | LFU Cache (Hard) | Writing modular helper functions `add_node()` and `remove_node()`. |
| 31 | Multiple Lists | **K-Way Merge:** Merging K sorted lists is a classic distributed systems problem. A naive merge is O(N * K). By pushing the head of each list into a Min-Heap, you can extract the smallest element and push the next element of that list in O(log K) time, bringing total time to O(N log K). | K-Way Merge | Merge k Sorted Lists (Hard) | Sort List (Med) | Comparing Heap vs Divide & Conquer implementations. |
| 32 | Advanced Reversal | **Chunk Reversal:** Reversing nodes in k-groups requires meticulous pointer management. You must first verify if there are `k` nodes left. If so, isolate the chunk, reverse it using the standard `prev`/`curr`/`next` approach, and carefully reconnect the tail of the previous chunk to the new head of the reversed chunk. | Chunk Reversal | Reverse Nodes in k-Group (Hard) | Reverse Linked List II (Med) | Meticulous pointer management. Testing with k=1 and k=length. |

---

## 🟠 Phase 5: Trees & BST (Days 33–44)

**Estimated daily time: 2h. Difficulty: Medium–Hard.**
Twelve days for a reason. The recursive DFS patterns you build here are the exact mental model you'll reuse in Dynamic Programming. Do not rush Phase 5.

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 33 | Tree Traversal Basics | **DFS Traversals:** Understand Preorder (Node, Left, Right), Inorder (Left, Node, Right), and Postorder (Left, Right, Node). Tree algorithms rely on the Call Stack. The Space Complexity of recursive tree algorithms is O(H), where H is the height of the tree. For a skewed tree, worst-case space is O(N). | DFS (Depth First) | Invert Binary Tree (Easy) | Maximum Depth of Binary Tree (Easy) | Recursion stack depth discussion. |
| 34 | Bottom-Up Recursion | **Postorder Aggregation:** In "Bottom-Up" recursion, you ask your left child for data, ask your right child for data, and then process that data at the current node to return to the parent. This is strictly Postorder. This is used to calculate heights, balances, and diameters simultaneously. | Postorder Aggregation | Diameter of Binary Tree (Easy) | Balanced Binary Tree (Easy) | Returning two values from a recursive function `(is_balanced, height)`. |
| 35 | Tree Comparison | **Simultaneous Traversal:** You can pass multiple tree nodes into a single recursive function to traverse them simultaneously (e.g., `isSameTree(p, q)`). To check if one tree is a subtree of another, you must run `isSameTree` on every node of the main tree, resulting in O(N * M) time worst-case. | Simultaneous Traversal | Same Tree (Easy) | Subtree of Another Tree (Easy) | Why Subtree is O(N * M) time worst-case and how serialization helps. |
| 36 | BST Properties | **Bounds Validation:** A BST dictates that all nodes to the left must be strictly smaller, and all nodes to the right strictly larger. A common mistake is only checking the immediate children. You must pass a `min_val` and `max_val` down the recursion tree to validate the entire sub-branches. | Bounds Passing | Lowest Common Ancestor of a BST (Med) | Validate Binary Search Tree (Med) | Passing `min_val` and `max_val` down the recursion tree. |
| 37 | Level Order (BFS) | **Queue-Based BFS:** Breadth-First Search on a tree processes level by level. Use a Queue (Deque). Crucially, capture `length = len(queue)` at the start of each level, and use a `for i in range(length)` loop. This isolates the nodes of the current level from the children being appended to the queue. | BFS (Breadth First) | Binary Tree Level Order Traversal (Med) | Binary Tree Right Side View (Med) | Grabbing the last element of the queue for Right Side View. |
| 38 | State Passing | **Preorder State Modification:** In "Top-Down" recursion, you calculate a state or value at the parent node, and pass it down as an argument to the children. Remember to backtrack your state (e.g., popping from a list) if you are passing mutable objects like lists. | Preorder State | Count Good Nodes in Binary Tree (Med) | Path Sum II (Med) | Remembering to backtrack/pop from the path list when exploring. |
| 39 | Kth Elements | **Iterative Inorder:** An Inorder traversal of a BST visits nodes in perfectly sorted, ascending order. To find the Kth smallest element, convert the recursive Inorder to an Iterative Inorder using an explicit stack, and stop exactly when you process the Kth node. | Inorder Processing | Kth Smallest Element in a BST (Med) | Construct BST from Preorder Traversal (Med) | Converting recursive Inorder to Iterative Inorder using a stack. |
| 40 | Tree Construction | **Divide & Conquer Rebuilding:** A tree can be uniquely rebuilt from its Preorder (provides the Root) and Inorder (provides the Left/Right subtrees) traversals. Use a Hash Map to store the indices of the Inorder array to achieve O(1) lookups, preventing the O(N^2) time caused by array slicing. | Divide & Conquer | Construct Binary Tree from Preorder and Inorder Traversal (Med) | Flatten Binary Tree to Linked List (Med) | Using global/class variables to track the current preorder index. |
| 41 | Hard Tree Paths | **Path Aggregation:** A tree path cannot fork in two directions and then return upward to a parent — it would form a cycle. Therefore, when returning a path sum to a parent, you can only return `node.val + max(left_path, right_path)`. However, you can update a global maximum with `left_path + node.val + right_path` at the current node. | Path Aggregation | Binary Tree Maximum Path Sum (Hard) | Sum Root to Leaf Numbers (Med) | Realizing paths cannot fork in two directions and return upward. |
| 42 | Serialization | **String Representation:** Serialization converts a complex tree into a flat string for network transfer or storage. Use Preorder traversal. Whenever you hit a Null node, append a marker like `#`. During deserialization, the `#` markers allow you to accurately rebuild the exact structure without needing an Inorder array. | Preorder Parsing | Serialize and Deserialize Binary Tree (Hard) | Serialize and Deserialize BST (Med) | Using an iterator or deque to cleanly consume the string. |
| 43 | Tree Consolidation 1 | **DP on Trees:** Dynamic Programming on trees involves making a local decision at each node. For "House Robber III", you must decide to rob the current node (and skip children) OR skip the current node (and rob children). Return a tuple of `[max_if_robbed, max_if_skipped]` from the postorder recursion. | Pattern Selection | Populating Next Right Pointers in Each Node (Med) | House Robber III (Med) | Returning `[rob_this_node, skip_this_node]` from recursion. |
| 44 | Tree Consolidation 2 | **Graph-Tree Bridging:** Trees are just directed acyclic graphs. You can treat them as graphs to perform Vertical Order Traversals. Use BFS to traverse the tree, passing `(row, col)` coordinates down to children. Group nodes by `col` using a Hash Map, and sort them top-to-bottom, left-to-right. | Graph-Tree Bridge | Vertical Order Traversal of a Binary Tree (Hard) | Step-By-Step Directions From a Binary Tree Node to Another (Med) | Using HashMaps with coordinates during traversals. |

---

## 🟠 Phase 6: Heaps & Tries (Days 45–52)

**Estimated daily time: 2h. Difficulty: Medium–Hard.**

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 45 | Min/Max Heap Basics | **Priority Queue Mechanics:** A Heap is a complete binary tree usually implemented as an array. It offers O(log N) insertions and O(log N) minimum/maximum extractions. It is perfect for processing data streams. Go's `container/heap` requires implementing an interface (Len, Less, Swap, Push, Pop). To simulate a Max-Heap, negate all values before pushing. | Priority Queues | Kth Largest Element in a Stream (Easy) | Last Stone Weight (Easy) | Maintaining a heap of size K to achieve O(N log K) time. |
| 46 | Heap Geometry / Sorting | **Quickselect vs Heaps:** To find the Kth largest element, a Max-Heap takes O(N log K) time. The Quickselect algorithm (based on QuickSort's partitioning) achieves O(N) average time but O(N^2) worst case. You must be able to explain the trade-offs of both algorithms to an interviewer. | Distance Sorting | K Closest Points to Origin (Med) | Kth Largest Element in an Array (Med) | Explaining Quickselect average O(N) vs worst-case O(N²). |
| 47 | Heaps + HashMaps | **Frequency Processing:** For task scheduling or finding top elements, first count the frequencies using a Hash Map (O(N) time). Then, push the `(frequency, element)` tuples into a Heap. If you need to enforce a "cooldown" period between tasks, use a standard Queue alongside the Heap to hold elements until their cooldown expires. | Frequency Processing | Task Scheduler (Med) | Top K Frequent Words (Med) | Using a Queue alongside the Heap to handle 'cooldown' periods. |
| 48 | Advanced Heaps | **Two-Heap Stream Balancing:** To find the Median of a continuous stream of numbers in O(1) time, use two Heaps. A Max-Heap holds the smaller half of the numbers, and a Min-Heap holds the larger half. You must strictly balance them so their sizes differ by at most 1. The median is either the top of the larger heap, or the average of both tops. | Stream Balancing | Find Median from Data Stream (Hard) | IPO (Hard) | Balancing the heaps: Max-Heap size must be `==` or `+1` of Min-Heap. |
| 49 | Trie Fundamentals | **Prefix Tree Structure:** A Trie is a tree used for O(L) string search, where L is the word length. Each node contains a Hash Map (or Array of size 26) pointing to its children, and a boolean `is_word` flag. This structure allows lightning-fast prefix matching, auto-complete, and spell-checking functionalities. | Prefix Matching | Implement Trie (Prefix Tree) (Med) | Design Add and Search Words Data Structure (Med) | DFS on a Trie to handle the `.` wildcard character in search queries. |
| 50 | Trie + Backtracking | **Boggle Board Optimization:** Searching for multiple words on a 2D grid using standard DFS takes O(Words * 4^Path) time. By building a Trie of all target words first, you can run a single DFS on the grid. If the current string is not a valid prefix in the Trie, you prune the DFS path immediately, drastically reducing time complexity. | Board Search | Word Search II (Hard) | Replace Words (Med) | Removing words from the Trie once found to speed up future DFS. |
| 51 | Bitwise Tries | **XOR Maximization:** A Trie can store the binary representation (0s and 1s) of integers. To find the maximum XOR of two numbers in an array, build a Bitwise Trie. For each number, traverse the Trie attempting to choose the "opposite" bit at every step. Because 1 XOR 0 = 1, this greedy path guarantees the maximum possible XOR value. | Bit Manipulation | Maximum XOR of Two Numbers in an Array (Med) | Design File System (Med) | Navigating the Trie by bits to greedily find the opposite bit. |
| 52 | Heaps & Tries Review | **Systems Design Mapping:** Heaps and Tries map directly to real-world systems. A Trie is the backbone of Search Autocomplete. A Heap is the backbone of Rate Limiters, Task Schedulers, and News Feed Generation. To generate a Twitter timeline from 100 people you follow, treat it as merging 100 sorted lists using a Heap. | Systems Design | Design Twitter (Med) | Find K Pairs with Smallest Sums (Med) | Formulating Twitter feeds as a Merge K Sorted Lists problem. |

---

## 🔴 Phase 7: Backtracking & Recursion (Days 53–60)

**Estimated daily time: 2h15m. Difficulty: Hard.**
Decision tree thinking is a new mental model for most people. Slow down here. Draw the recursion tree on paper before touching the keyboard on every single day of this phase.

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 53 | Subsets & Choices | **The Decision Tree:** Backtracking explores all possible paths. For subsets (Power Set), every element presents a binary choice: include it in the subset, or exclude it. This results in an O(2^N) time complexity. To handle duplicate elements, sort the array first, and if you choose to exclude an element, skip all subsequent identical elements. | Decision Trees | Subsets (Med) | Subsets II (Med) | Handling duplicates by sorting first and skipping identical peers. |
| 54 | Combinations | **Target Path Constraints:** Combinations require building a path toward a specific target (like a target sum). If elements can be reused indefinitely, you pass the same index down the recursion tree. If elements are single-use, you pass `index + 1`. If the current sum exceeds the target, you prune the branch immediately. | Target Paths | Combination Sum (Med) | Combination Sum II (Med) | Differentiating between unbounded reuse vs single use. |
| 55 | Permutations | **Sequence Ordering:** Permutations generate all possible arrangements, taking O(N!) time. Unlike subsets, order matters (`[1,2]` != `[2,1]`). You can implement this by maintaining a `visited` boolean array to track which elements are currently in the path, or by swapping elements in-place to avoid extra space usage. | Sequence Ordering | Permutations (Med) | Permutations II (Med) | Passing the `path` and `remaining` lists cleanly. |
| 56 | String Backtracking | **Substring Partitioning:** When partitioning strings (e.g., finding all Palindrome partitions), you use a `for` loop to slice the string into progressively larger prefixes (`s[start:i]`). If the prefix is valid, you add it to the path and recursively backtrack on the remainder of the string (`s[i:]`). | Substring Partitioning | Palindrome Partitioning (Med) | Letter Combinations of a Phone Number (Med) | Recognizing when to slice `s[i:j]` vs passing index pointers. |
| 57 | Matrix Backtracking | **Grid State Exploration:** DFS on a 2D matrix explores paths through adjacent cells. Crucially, you must mark the current cell as `visited` (e.g., `board[r][c] = "#"`) so you don't loop back on yourself. Once the DFS returns from that path, you MUST restore the cell to its original state so other paths can use it. | Grid Exploration | Word Search (Med) | Path with Maximum Gold (Med) | Backtracking the `visited` state (`board[r][c] = temp`) on return. |
| 58 | Hard Board States | **O(1) Conflict Tracking:** In problems like N-Queens, checking if a queen is attacked takes O(N) time if done naively. You can optimize this to O(1) time by maintaining Hash Sets for attacked `cols`, attacked positive diagonals (calculated as `row + col`), and attacked negative diagonals (calculated as `row - col`). | N-Queens Constraints | N-Queens (Hard) | Sudoku Solver (Hard) | Tracking diagonal conflicts mathematically in O(1). |
| 59 | Expression Building | **Mathematical Backtracking:** When inserting operators (`+`, `-`, `*`) between numbers, multiplication creates a precedence issue because it must be evaluated before addition. To solve this, pass the `previous_operand` down the recursion tree. If you multiply, you must subtract the previous operand from the current total, then add `previous_operand * current_val`. | Math Search | Expression Add Operators (Hard) | Split Array into Fibonacci Sequence (Med) | Passing `prev_operand` in the recursion for correct precedence. |
| 60 | Backtracking Consolidation | **The Universal Template:** Master the Backtracking Template: `1. Check Base Case (append copy of path to results). 2. Iterate through choices. 3. Apply choice (append to path, mark visited). 4. Recurse. 5. Undo choice (pop from path, unmark visited)`. This single structure solves 90% of backtracking problems. | State Trees | Generate Parentheses (Review) (Med) | Word Search II (Review) (Hard) | Drawing the recursion tree on the whiteboard before coding. |

---

## 🔴 Phase 8: Graphs (Days 61–70)

**Estimated daily time: 2h15m. Difficulty: Hard.**
Union-Find (Days 66–67) must be memorized perfectly — this is a script, not a concept you derive from scratch. Write it out from memory 5 times until you can produce it in under 3 minutes cold.

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 61 | Graph Traversals | **Adjacency & Connectivity:** A graph is typically represented as an Adjacency List (a Hash Map of lists). Because graphs contain cycles, you MUST maintain a `visited` Hash Set to prevent infinite recursion. Connected components are found by iterating through all nodes, running DFS on unvisited nodes, and counting how many times DFS was initiated. | Connected Components | Number of Islands (Med) | Clone Graph (Med) | Mapping original nodes to cloned nodes using a HashMap. |
| 62 | Grid Graphs | **Reverse Thinking (Border Traversal):** For problems like "Surrounded Regions," finding enclosed areas from the inside out is difficult. Instead, use Reverse Thinking: iterate over the borders of the grid, run DFS on valid cells, and mark them as "Safe." Afterward, any cell that is not marked safe is guaranteed to be surrounded and can be flipped. | Island Patterns | Max Area of Island (Med) | Surrounded Regions (Med) | Running DFS from the borders inward to mark safe zones. |
| 63 | Multi-Source BFS | **Simultaneous Spread:** Standard BFS starts from a single node. Multi-Source BFS starts from multiple nodes simultaneously. Initialize your Queue with ALL starting coordinates (e.g., all Rotten Oranges) at time `T=0`. As you pop from the queue, the spread happens uniformly in all directions, naturally tracking the minimum time/distance to reach all points. | Simultaneous Spread | Rotting Oranges (Med) | 01 Matrix (Med) [Free alternative to Walls and Gates — same Multi-Source BFS pattern] | Starting BFS from all sources simultaneously. |
| 64 | Topological Sort (DFS) | **3-Color Cycle Detection:** Topological Sort orders directed acyclic graphs (DAGs) linearly, often used for prerequisite scheduling. Using DFS, you detect cycles by tracking 3 states for each node: 0 (Unvisited), 1 (Visiting/Currently in Call Stack), and 2 (Fully Visited). If you ever encounter a node in state 1, a back-edge (cycle) exists. | Cycle Detection | Course Schedule (Med) | Course Schedule II (Med) | Explaining how the 'Visiting' state catches back-edges (cycles). |
| 65 | Topological Sort (BFS) | **Kahn's Algorithm:** This is the BFS approach to Topological Sort. Calculate the "In-Degree" (number of incoming edges) for every node. Add all nodes with In-Degree `0` to a Queue. As you process a node, decrement the In-Degree of all its neighbors. If a neighbor reaches `0`, add it to the Queue. If nodes remain unprocessed, a cycle exists. | Kahn's Algorithm | Minimum Height Trees (Med) | Alien Dictionary [PREMIUM — find on LintCode free tier] (Hard) | Recognizing Alien Dictionary is just Graph building + Topo Sort. |
| 66 | Union Find Basics | **Disjoint Set Union (DSU):** DSU tracks connectivity in O(alpha(N)) ~ O(1) time. The `find(x)` function traces a node to its root parent and uses "Path Compression" to flatten the tree. The `union(x, y)` function merges two sets by attaching the shorter tree under the taller tree ("Union by Rank/Size") to keep the graph shallow. | Connectivity | Redundant Connection (Med) | Find if Path Exists in Graph (Easy) [Free alternative to Number of Connected Components — same DSU pattern] | Implementing DSU from memory perfectly (mandatory FAANG script). |
| 67 | Advanced Union Find | **Dynamic Graph Validation:** In graph theory, a valid tree is a graph that is fully connected (1 connected component) and has exactly `V - 1` edges (where V is vertices). You can use Union-Find dynamically as edges are added: if `union(x, y)` returns false (they share the same root), you have detected a cycle. | Dynamic Graphs | Pacific Atlantic Water Flow (Med) [Strong free problem — BFS/DFS from borders] | Accounts Merge (Med) | Knowing a valid tree has exactly `n-1` edges and 1 component. |
| 68 | Shortest Path (Unweighted) | **State Machine BFS:** BFS guarantees the absolute shortest path in unweighted graphs because it explores all nodes at distance 1, then distance 2, etc. Graphs don't have to be nodes/edges; they can be states. "Word Ladder" treats words as nodes, and mutating one character creates an edge to another state. BFS finds the shortest mutation path. | State Machine BFS | Word Ladder (Hard) | Open the Lock (Med) | Pre-computing wildcard patterns (e.g. `*ot`) to optimize graphs. |
| 69 | Shortest Path (Weighted) | **Dijkstra's Algorithm:** For weighted graphs with positive edges, use a Min-Heap storing `(cumulative_cost, node)`. You pop the cheapest path, mark the node as visited, and push its neighbors into the heap `(cumulative_cost + neighbor_cost, neighbor)`. Dijkstra fails with negative weights because it permanently marks nodes as visited the first time they are popped. | Dijkstra's | Network Delay Time (Med) | Path with Maximum Probability (Med) | Understanding the heap mechanics and negative weight failure. |
| 70 | Minimum Spanning Tree | **Prim vs Kruskal:** An MST connects all nodes in a weighted graph with the minimum total edge weight. Prim's Algorithm grows the tree outward using a Min-Heap (similar to Dijkstra). Kruskal's Algorithm sorts all edges by weight and uses Union-Find to add them greedily while skipping cycles. Both are crucial for network routing design. | MST | Min Cost to Connect All Points (Med) | Swim in Rising Water (Hard) | Recognizing 'Swim in Rising Water' as a Dijkstra/Prim's grid variant. |

---

## 💀 Phase 9: Dynamic Programming (Days 71–83)

**Estimated daily time: 2h45m. Difficulty: Very Hard.**
This is the hardest phase. Most candidates who abandon this roadmap do so here. The correct response to struggling is not to slow down — it is to draw the decision tree and trust the process. Every DP problem is recursion + caching. Start there, always.

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 71 | 1D DP (Memoization) | **Top-Down State Caching:** DP is just recursion with caching. When a recursive decision tree calculates the exact same subproblem multiple times (Overlapping Subproblems), it wastes exponential O(2^N) time. By saving the result in a Hash Map `cache[state] = result` and returning it immediately if seen again, time drops to O(N). | State Caching | Climbing Stairs (Easy) | Min Cost Climbing Stairs (Easy) | Always start by writing the recursive DFS, then add memoization. |
| 72 | 1D DP (Tabulation) | **Bottom-Up Arrays:** Tabulation flips Memoization. Instead of starting at the target and recursing down, you start at the base cases and iteratively build up an array `dp[i]`. If the transition only relies on the previous two states (e.g., `dp[i] = dp[i-1] + dp[i-2]`), you can optimize space complexity from O(N) to strictly O(1) using two variables. | Bottom-Up Arrays | House Robber (Med) | House Robber II (Med) | House Robber II trick: Run logic twice (skip first, skip last). |
| 73 | String DP (Palindromes) | **Expand Around Center vs 2D Table:** Finding palindromes can be done in O(N^2) space using a 2D DP table where `dp[i][j]` is true if `s[i:j]` is a palindrome. However, expanding two pointers outward from every possible center in the string achieves the exact same O(N^2) time complexity while dropping the space complexity to O(1). | Substring States | Longest Palindromic Substring (Med) | Palindromic Substrings (Med) | Comparing O(N²) Expand Around Center vs O(N²) 2D DP table. |
| 74 | Array DP & Subsequences | **Max/Min State Tracking:** Kadane's Algorithm finds the maximum subarray sum in O(N) time by resetting the running sum to 0 if it goes negative. However, for Maximum *Product* Subarray, multiplying two negative numbers creates a positive. Therefore, you must track BOTH the `current_max` and `current_min` at every step to handle sign flips. | Max/Min Tracking | Maximum Product Subarray (Med) | Decode Ways (Med) | Handling the '0' edge case gracefully in Decode Ways. |
| 75 | LIS & Knapsack | **0/1 Knapsack Intuition:** In 0/1 Knapsack, you can either pick an item or leave it. This translates to `dp[weight] = max(dp[weight], dp[weight - current_weight] + value)`. Longest Increasing Subsequence (LIS) uses DP but can be optimized to O(N log N) using Binary Search on a maintained "patience sorting" array. | Subsequence Matching | Longest Increasing Subsequence (Med) | Partition Equal Subset Sum (Med) | Explaining how LIS can be optimized to O(N log N) via Binary Search. |
| 76 | Unbounded Knapsack | **Infinite Item Reuse:** Unlike 0/1 Knapsack where you iterate weights backwards to avoid reusing the same item, Unbounded Knapsack (like Coin Change) iterates weights forwards. The inner and outer loops matter: looping items then weights generates Combinations (order doesn't matter). Looping weights then items generates Permutations (order matters). | Target Generation | Coin Change (Med) | Coin Change II (Med) | The difference in loop ordering: Permutations vs Combinations. |
| 77 | 2D DP (Grids) | **Grid Path Transitions:** 2D Grid DP calculates paths or costs from `(0,0)` to `(M,N)`. The transition formula is usually `dp[r][c] = cost + min(dp[r-1][c], dp[r][c-1])`. Because calculating the current row only requires data from the immediately previous row, you can optimize the O(M*N) 2D array down to an O(N) 1D array representing the row. | Grid Paths | Unique Paths (Med) | Minimum Path Sum (Med) | Optimizing 2D grid space complexity down to O(N). |
| 78 | 2D DP (Strings) | **String Alignment Matrices:** When comparing two strings (LCS, Edit Distance), build a 2D matrix where axes represent the strings. If `char1 == char2`, the characters match, and you pull the diagonal value `dp[i-1][j-1]`. If they don't match, you evaluate Insertion (pull from left), Deletion (pull from top), or Replacement (pull from diagonal) and take the minimum/maximum. | Edit/Match States | Longest Common Subsequence (Med) | Edit Distance (Hard) | Drawing the 2D DP table and explaining operations. |
| 79 | Advanced String DP | **Complex Wildcard Matching:** In Regular Expression Matching, a `*` character means "zero or more of the PRECEDING element." This requires checking two DP transitions: First, simulating 0 occurrences by ignoring the `char*` entirely (pulling from `dp[i][j-2]`). Second, if the preceding character matches the current string character, simulate 1 or more occurrences (pulling from `dp[i-1][j]`). | Complex Matching | Interleaving String (Med) | Regular Expression Matching (Hard) | Handling the `*` character in Regex DP accurately. |
| 80 | State Machine DP | **FSM Graph Transitions:** Some DP problems impose strict rules (e.g., Stock Trading with a 1-day Cooldown). You cannot simply buy/sell; you exist in a State Machine. Define states like `Hold`, `Sold`, and `Rest`. Map the transitions mathematically: `Hold[i] = max(Hold[i-1], Rest[i-1] - price)`. Update the states iteratively. | FSM Transitions | Best Time to Buy and Sell Stock with Cooldown (Med) | Best Time to Buy and Sell Stock IV (Hard) | Drawing the State Machine graph and translating it to DP equations. |
| 81 | DFS + Memoization (Hard) | **Topological DP on Graphs:** When a matrix has complex dependencies (like moving up, down, left, right strictly increasing), building a Bottom-Up DP table is nearly impossible because the evaluation order isn't strict top-left to bottom-right. Instead, use Top-Down DFS with Memoization. The recursion naturally traverses the topological order, solving it in O(M*N) time. | Topological DP | Longest Increasing Path in a Matrix (Hard) | Burst Balloons (Hard) | Burst Balloons insight: Think about the LAST balloon to burst. |
| 82 | Target Sum DP | **Pattern Translation:** Target Sum appears to be a Backtracking problem (adding `+` or `-` to numbers), but mathematically it translates to finding a subset `P` (positives) and `N` (negatives) where `sum(P) = (target + sum(nums)) / 2`. This instantly converts the problem into a standard 0/1 Knapsack subset problem. Recognize this class of translation — it appears in other forms at FAANG. | Pattern Translation | Target Sum (Med) | Palindrome Partitioning II (Hard) | Recognizing Target Sum as a 0/1 Knapsack math translation. |
| 83 | DP Consolidation | **Full Pattern Review:** Today has one problem and one consolidation exercise. After solving the problem, spend 45 minutes reviewing your DP entries in the Pattern Cheat Sheet. Can you reconstruct the state transition for Coin Change, Edit Distance, and LIS from memory? If not, that is your Mistake Log entry for today. | Full DP Consolidation | Distinct Subsequences (Hard) | Review: re-derive state transitions for Coin Change, Edit Distance, LIS from memory | Drawing state transition tables without notes. This is the final DP exam. |

---

## 🔴 Phase 10: Advanced Graphs & Hard Problems (Days 84–89)

**Estimated daily time: 2h. Difficulty: Hard.**
Expanded from 3 to 6 days. Days 84–86 are from the original roadmap. Days 87–89 add Floyd-Warshall, Bipartite Detection, and Tarjan's SCC — three algorithms that appear at FAANG and are directly relevant to infrastructure dependency problems.

| Day | Topic | Detailed Concepts to Learn | Pattern Focus | Problem 1 | Problem 2 | Interview Focus |
|-----|-------|----------------------------|---------------|-----------|-----------|-----------------|
| 84 | Bellman-Ford & Eulerian | **K-Stop Limitations:** Dijkstra cannot find the shortest path with "At most K edges" because it aggressively pursues the cheapest path regardless of edge count. Bellman-Ford solves this by relaxing all edges exactly `K+1` times, generating the cheapest path bounded by edge count. Eulerian paths require visiting all edges exactly once using post-order DFS. | Edge Traversals | Cheapest Flights Within K Stops (Med) | Reconstruct Itinerary (Hard) | Why Bellman-Ford is perfect for 'At most K steps' (run K+1 times). |
| 85 | Advanced Intervals | **The Sweepline Algorithm:** For complex interval overlap problems, separate all start times and end times into two sorted arrays. Use two pointers. If `start[i] < end[j]`, a meeting has started (increment active count). If `start[i] >= end[j]`, a meeting has ended (decrement count). The max count at any time is the rooms needed. | Line Sweeping | Merge Intervals (Med) | Car Pooling (Med) [Free alternative to Meeting Rooms II — same Sweepline pattern] | Using a Min-Heap for interval scheduling to track active end times. |
| 86 | Greedy & Math | **Optimal Local Choice:** A Greedy algorithm builds a solution piece by piece, always choosing the next piece that offers the most obvious and immediate benefit. It only works if the "Greedy Choice Property" holds — meaning local optimums guarantee a global optimum. For Gas Station, the mathematical proof is: if `Total Gas >= Total Cost`, a circular solution MUST exist. | Optimal Local Choice | Jump Game II (Med) | Gas Station (Med) | Explaining *why* the greedy approach works (`sum(gas) < sum(cost)`). |
| 87 | Floyd-Warshall (All-Pairs Shortest Path) | **All-Pairs vs Single-Source:** Unlike Dijkstra which finds shortest paths from one source node, Floyd-Warshall computes the shortest path between EVERY pair of nodes in O(V³) time. The algorithm asks at each step: "Does routing through node K give a shorter path from I to J?" The DP formula is: `dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])`. This works even with negative edge weights, as long as there are no negative cycles. Initialize `dist[i][i] = 0` and `dist[i][j] = infinity` for all other pairs, then fill in known edges. | All-Pairs Shortest Path | Find the City With the Smallest Number of Neighbors at a Threshold Distance (Med) | Network Delay Time (Med) — re-solve using Floyd-Warshall and compare with your Day 69 Dijkstra solution | When to choose Dijkstra (single source, positive weights) vs Bellman-Ford (K steps or negative weights) vs Floyd-Warshall (all pairs). |
| 88 | Bipartite Graph Detection | **2-Color Graph Property:** A graph is bipartite if you can color every node with one of two colors such that no two adjacent nodes share the same color. Use BFS or DFS. Start by assigning color 0 to any unvisited node. For each neighbor, assign the opposite color (1 - current_color). If you encounter a neighbor that already has the same color as the current node, the graph is NOT bipartite. Applications: conflict detection (can this group be split into two non-conflicting teams?), matching problems, scheduling. | 2-Color BFS/DFS | Is Graph Bipartite? (Med) | Possible Bipartition (Med) | Connecting bipartite detection to real-world use cases: two-team scheduling, conflict resolution, social network analysis. |
| 89 | Tarjan's Algorithm (SCCs) | **Strongly Connected Components:** A Strongly Connected Component (SCC) is a maximal set of vertices such that there is a path from each vertex in the set to every other vertex. Tarjan's algorithm finds all SCCs in a single O(V+E) DFS pass. It tracks two values per node: `disc[]` (discovery time) and `low[]` (lowest discovery time reachable from this node's subtree). If `low[u] == disc[u]`, then node u is the root of an SCC. A stack collects nodes in the current DFS path. When an SCC is found, pop nodes from the stack until you reach the root. Applications: deadlock detection, package dependency resolution, finding circular dependencies in build systems. | SCC Detection | Critical Connections in a Network (Hard) — find bridges using modified Tarjan's | Redundant Connection II (Hard) | Real-world applications of SCCs: deadlock detection in OS schedulers, circular dependency detection in package managers, compiler optimization for call graphs. |

---

## 🔵 Phase 11: Golang for Cloud Infrastructure (Days 90–101)

*Golang is the language of the Cloud (Docker, Kubernetes, Terraform). In these 12 days, you will map your programming logic to Go's highly opinionated, concurrent-first architecture — and in the final 2 days (Days 100–101), bridge it directly back to DSA by re-solving canonical problems in Go.*

**Estimated daily time: 2h. Difficulty: Medium.**

| Day | Topic | Detailed Concepts to Learn | Go Implementation Task |
|-----|-------|----------------------------|-------------------------|
| 90 | Syntax, Types & `go mod` | **Go Fundamentals:** Go is strongly and statically typed. Learn short variable declarations `:=`, basic types, and the concept of zero values (variables are automatically initialized to `0`, `""`, or `nil`). Learn how Go uses capitalization for visibility (Public functions start with a Capital letter, private with lowercase). Learn module initialization with `go mod init`. | Build a CLI calculator. Accept arguments via `os.Args`. Parse strings to ints. |
| 91 | Slices, Maps & Control | **Memory-Backed Arrays:** Slices are Go's dynamic arrays, but they are just pointers to underlying fixed-size arrays. Understand `len()` (current items) vs `cap()` (capacity of underlying array). When `len == cap`, Go allocates a new array double the size. Learn Map initialization using `make()` and the `range` keyword for iterating over collections. | Implement Two Sum and Valid Anagram in Go using slices and maps. |
| 92 | Pointers & Structs | **Data Modeling without Classes:** Go is not object-oriented; it has no classes. Data is modeled using Structs. You define behaviors by attaching "Receiver Functions" to structs. Understand the critical difference between Value Receivers (copies the struct) and Pointer Receivers (mutates the original struct). Always use pointers when state modification is required. | Build a `CloudResource` struct with methods `Start()`, `Stop()`, updating state via pointer receivers. |
| 93 | Interfaces & Duck Typing | **Implicit Interface Satisfaction:** Unlike Java's `implements` keyword, Go interfaces are satisfied implicitly. If a struct has all the methods defined in an interface, it satisfies it automatically (Duck Typing). Idiomatic Go favors tiny interfaces (like `io.Reader` and `io.Writer` which have only one method) and uses composition over inheritance. | Create a `Storage` interface. Implement `S3Bucket` and `LocalFile` structs that satisfy it. |
| 94 | Error Handling | **Errors as Values:** Go does not use `try/catch` exceptions. Errors are just values returned alongside the result (`res, err := DoSomething()`). You must explicitly check `if err != nil`. Learn to wrap errors with context using `fmt.Errorf("failed to open: %w", err)` to build trace chains. Avoid `panic()` unless the program cannot safely continue. | Write a file parser that reads JSON, simulating network failures and wrapping errors with context. |
| 95 | Goroutines & WaitGroups | **Lightweight Concurrency:** A Goroutine is a function executing concurrently, spun up using the `go` keyword. They are managed by the Go runtime, not the OS, making them extremely cheap (2KB stack). To prevent the main function from exiting before goroutines finish, use `sync.WaitGroup` to `Add()`, `Done()`, and `Wait()` for completion. | Write a script that pings 5 URLs concurrently using goroutines and waits for all to finish. |
| 96 | Channels (CSP) | **Communicating Sequential Processes:** The Go proverb is "Do not communicate by sharing memory; instead, share memory by communicating." Channels are typed conduits used to safely pass data between goroutines. Learn the difference between Unbuffered channels (blocking execution until received) and Buffered channels (allowing N items before blocking). | Build a Worker Pool. Send 100 jobs (integers) to a channel, read by 3 worker goroutines. |
| 97 | Select & Context | **Cancellation Propagation:** The `select` statement lets a goroutine wait on multiple channel operations, acting like a `switch` for concurrency. The `context` package is mandatory in cloud engineering. It is passed down call stacks to enforce timeouts, deadlines, and cancel signals across thousands of concurrent API/DB requests simultaneously. | Fetch data from an API. Cancel it using `context.WithTimeout` if it takes more than 2 seconds. |
| 98 | JSON & HTTP Servers | **Network Services:** Go's standard library is incredibly powerful. The `net/http` package allows you to spin up production-ready web servers in 10 lines of code. Learn how to map JSON fields to Struct fields using struct tags `\`json:"field_name"\`` and how to use `json.Marshal` and `json.Unmarshal` for API payloads. | Build a REST API with `GET /health` and `POST /deploy` that accepts JSON and returns status codes. |
| 99 | Concurrency in the Cloud | **Shared Memory & Race Conditions:** When Goroutines MUST mutate shared state (e.g., an in-memory cache), you must lock the resource using `sync.Mutex` or `sync.RWMutex` to prevent data corruption. Always run tests with `go test -race` — Go's built-in race detector will instantly flag any unsynchronized memory access. | Build a highly concurrent in-memory Cache with read/write locks, tested with the race detector. |
| 100 | Go + DSA Bridge I: Linear Structures | **Idiomatic Go for DSA:** This day closes the gap between your Go systems knowledge and your DSA interview skills. Implement a Stack using a `[]int` slice with Push/Pop methods on a struct. Implement a Queue using two slices. Learn `sort.Slice()` with a custom comparator. Understand that Go has no built-in deque — you build one. Write DSA solutions the way Go engineers actually write them: struct-based, no global variables, pointer receivers for mutation. | Re-solve in Go from scratch: Valid Anagram, Two Sum, Reverse Linked List, Valid Parentheses, Longest Substring Without Repeating Characters. Time yourself: 15 minutes per problem. |
| 101 | Go + DSA Bridge II: Trees, Graphs & Heaps | **Go's `container/heap` Interface:** Go does not have a built-in priority queue. You must implement the `heap.Interface` by defining 5 methods on a custom type: `Len()`, `Less(i, j int) bool`, `Swap(i, j int)`, `Push(x interface{})`, `Pop() interface{}`. This is a mandatory script for any graph/scheduling interview in Go. Also implement a Binary Tree node as a struct with pointer fields. Write BFS using a `[](*TreeNode)` slice as a queue. | Re-solve in Go from scratch: Maximum Depth of Binary Tree, Level Order Traversal, Number of Islands, Network Delay Time (Dijkstra using `container/heap`). Time yourself: 20 minutes per problem. |

---

## ⏳ Phase 12: FAANG Interview Endgame (Days 102–112)

*No new learning. Pure execution. Simulating the brutal pressure of a FAANG interview. Expanded from 5 to 11 days — 4 days of solo topic mocks, 4 days of mixed and pressure mocks, 2 days of pair mocks, and 1 final reset day.*

| Day | Focus | Activity | Interview Focus |
|-----|-------|----------|-----------------|
| 102 | Solo Mock — Arrays, Strings, Hashing | 2 Hard problems. 45-minute timer each. No IDE — Google Docs or plain text editor only. No syntax highlighting, no auto-complete. | Can you write bug-free code without IDE assistance? State complexity before every function. Talk to an imaginary interviewer out loud. |
| 103 | Solo Mock — Two Pointers & Sliding Window | 2 Mediums. 40-minute timer each. Whiteboard simulation (paper only). | Edge cases: what if the array is all the same element? What if the window never becomes valid? What if K is larger than the array? |
| 104 | Solo Mock — Stack & Binary Search | 1 Hard + 1 Medium. Timed. | Write the Monotonic Stack from scratch without looking at previous solutions. Binary Search: handle size-1 arrays, all-same-value arrays. |
| 105 | Solo Mock — Linked Lists & Trees | 2 Mediums. 40-minute timer each. Paper only. | Draw the pointer diagram before writing a single line. Test with null input, single-node input, circular input. |
| 106 | Solo Mock — Graphs & BFS/DFS | 2 Mixed-difficulty graph problems. Pick from your weakest graph topics (check your Mistake Log). 45-minute timer. | What if the graph is disconnected? What if there are no edges? What if all nodes are isolated? |
| 107 | Solo Mock — Dynamic Programming | 2 Hard DP problems. 50-minute timer each. | Draw the decision tree. Identify overlapping subproblems verbally before typing. Code bottom-up after deriving the top-down recursion. |
| 108 | Pressure Mock — Full Random Mix | Pick 3 problems randomly across all topics. 40-minute timer each. No choice in topic — this simulates real interview randomness. | Speed of pattern recognition. Can you identify the correct algorithmic approach within 90 seconds of reading the problem? |
| 109 | System Design Verbal Warm-up | No coding. Verbally design two systems: Design a URL Shortener, then Design a Real-Time Notification System. Use a timer: 35 minutes each. Talk through every layer. | Clarify requirements first. Estimate scale. Name specific components (Redis, SQS, API Gateway). Identify bottlenecks. Know your AWS services by name. |
| 110 | Pair Mock — Coding Round | Conduct a 2-problem coding interview with a peer from your network. Alternate roles every 45 minutes: one is the interviewer, one is the candidate. | Communication under pressure. Handling hints gracefully. The interviewer should give exactly one hint per problem if the candidate is stuck beyond 5 minutes of silence. |
| 111 | Pair Mock — Full Loop Simulation | Full simulated interview loop with a peer: Coding problem (45 min) + System Design (40 min) + Behavioral (20 min). Back to back. No breaks between rounds. | Energy and focus management across 105 minutes. The system design round follows the coding round — you will be tired. Practice transitioning your mental state between rounds. |
| 112 | Mental Reset & Final Review | Read through your entire Mistake Log from Day 1. Review all Pattern Cheat Sheet entries. Write down your 3 strongest patterns and your 3 weakest ones — know both going into the real interview. | Sleep 8 hours tonight and every night of a real interview process. You have executed 112 days of a military-grade system. Confidence is not arrogance — it is the result of documented preparation. |

---

## 🏗️ Phase 13: System Design (Days 113–122)

*For cloud infrastructure roles, the system design round often weighs as much as — or more than — the coding round. These 10 days are structured around AWS-native architectures. Your Cloud-Morph and s3-backup-tool projects are direct real-world evidence of these patterns. Reference them in every design conversation.*

**Estimated daily time: 2h. Difficulty: Medium–Hard (conceptual, not algorithmic).**
**Required reading before this phase:** System Design Primer (GitHub), Chapter 1–3 of Designing Data-Intensive Applications, AWS Well-Architected Framework (Reliability and Performance pillars).

| Day | Topic | Detailed Concepts to Learn | Interview/Design Task |
|-----|-------|----------------------------|-----------------------|
| 113 | Scalability Fundamentals | **Vertical vs Horizontal Scaling:** Vertical scaling (adding more CPU/RAM to one machine) has a hard ceiling and a single point of failure. Horizontal scaling (adding more machines) requires stateless services — no local state per server. **CAP Theorem:** A distributed system can guarantee at most two of three properties: Consistency (every read gets the most recent write), Availability (every request receives a response), Partition Tolerance (the system works despite network partitions). **BASE vs ACID:** ACID (used by relational DBs) guarantees transaction correctness. BASE (used by NoSQL) accepts eventual consistency for higher availability. **Scale estimation:** Practice estimating QPS (queries per second), storage per year, bandwidth. | Estimate the scale of Instagram: daily active users, posts per day, storage per year, read/write ratio. Write your estimates on paper before checking any reference. |
| 114 | Load Balancers & Reverse Proxies | **Load Balancing Algorithms:** Round-robin (equal distribution), least-connections (send to least busy server), IP hashing (same client always goes to same server — sticky sessions). **Layer 4 vs Layer 7:** L4 load balancers operate at the TCP level (fast, simple). L7 load balancers operate at the HTTP level (can route based on URL paths, headers, cookies). **AWS ALB vs NLB:** Application Load Balancer (L7, HTTP/HTTPS routing). Network Load Balancer (L4, ultra-high throughput). **Health checks:** Load balancers constantly poll servers. A server that fails N consecutive health checks is removed from rotation. | Draw a highly available system diagram: 2 AWS ALBs (primary + failover) → Auto Scaling Group of EC2 instances → RDS with a read replica. Label every component and explain what happens when one EC2 instance fails. |
| 115 | Caching | **Cache Hit/Miss/Eviction:** A cache hit returns data without hitting the database. A cache miss requires a DB query, and the result is written to cache for future hits. Eviction policies: LRU (evict the least recently used item — same algorithm as your Day 30 LRU Cache problem), LFU (evict the least frequently used), TTL (evict after a fixed time). **Redis vs Memcached:** Redis is single-threaded, supports complex data types (sorted sets, lists, hashes), and can persist data to disk. Memcached is multi-threaded, simpler, higher throughput for pure key-value. **Cache Stampede:** When a popular cache entry expires, thousands of requests simultaneously hit the database. Solutions: mutex locking (only one request fetches, others wait), probabilistic early expiration (expire slightly before TTL deterministically). **CDN:** A geographically distributed cache for static assets. AWS CloudFront. | Design the caching layer for a global news feed application. Which content gets cached (post bodies, user profiles, trending feeds)? What TTL? How do you handle cache invalidation when a post is edited? Where does Redis sit in the architecture? |
| 116 | Databases | **SQL vs NoSQL Trade-offs:** SQL (PostgreSQL, MySQL, AWS RDS): ACID transactions, complex joins, strong consistency, vertical scaling. NoSQL (DynamoDB, MongoDB, Cassandra): schema-free, horizontal scaling, eventual consistency, optimized for specific access patterns. **Indexing:** B-tree indexes allow O(log N) lookups on indexed columns. Hash indexes allow O(1) lookups but only for exact-match queries, not range queries. Without an index, a query scans every row O(N). **Database Sharding:** Splitting a large table across multiple databases. Range sharding (users A–M on DB1, N–Z on DB2) — simple but creates hotspots. Hash sharding (consistent hashing) — even distribution but complex re-sharding. **Replication:** Master-slave (one writable master, N read replicas — high read throughput, eventual consistency). Multi-master (multiple writable nodes — complex conflict resolution). | Design the database schema for a ride-sharing app. What tables? What indexes? How do you shard by geography? What happens when a driver and a rider request each other simultaneously — how does the database prevent double-booking? |
| 117 | Message Queues & Event-Driven Architecture | **Producer-Consumer Pattern:** A message queue decouples producers (services that generate events) from consumers (services that process them). Producers don't wait for consumers — they fire and forget. Consumers process at their own pace. **Delivery Guarantees:** At-most-once (message may be lost, never duplicated — fine for metrics). At-least-once (message may be duplicated, never lost — requires idempotent consumers). Exactly-once (most expensive — Kafka transactions, AWS SQS FIFO). **Dead Letter Queue (DLQ):** A separate queue where messages that fail processing N times are deposited for inspection. Critical for debugging production failures. **AWS SQS vs SNS vs Kafka:** SQS (simple queue, pull-based, 14-day retention). SNS (push-based pub/sub fan-out). Kafka (distributed log, replay capability, millions of messages/sec). **CQRS:** Command Query Responsibility Segregation — separate write path from read path for independent scaling. | Design an order processing system for an e-commerce platform: User places order → Payment service → Inventory service → Shipping service → Notification service. Use SQS between each step. Handle payment failure with a DLQ and retry mechanism. Draw the full event flow. |
| 118 | AWS Cloud Architecture Deep Dive | **S3:** Object storage for any file type. Presigned URLs (time-limited access without exposing credentials — you used this in Cloud-Morph). Lifecycle policies (transition old objects to Glacier for cheap cold storage). Event notifications (S3 PUT triggers an SQS message or Lambda invocation). **Lambda:** Serverless functions. Cold start latency (first invocation after idle period). Concurrency limits (1000 per region by default). Maximum execution time: 15 minutes. **API Gateway:** REST vs WebSocket. Throttling (rate limiting per API key). Request/response transformation. Lambda proxy integration. **VPC:** Virtual Private Cloud. Public subnets (accessible from internet). Private subnets (internal only). NAT Gateway (allows private subnet resources to reach the internet for updates without being reachable from it). Security Groups (stateful firewall at the instance level). **IAM:** Roles (attached to services, not users). Policies (JSON documents defining allowed/denied actions). Principle of least privilege — every Lambda, EC2 instance, and service gets only the permissions it actually needs. | Upgrade your Cloud-Morph project architecture to production-grade: add CloudWatch alarms for Lambda errors and S3 upload rates, add IAM roles with least-privilege policies for each Lambda function, add API Gateway throttling (100 requests/sec per user), add S3 lifecycle policies (move to Glacier after 90 days). Draw the complete upgraded architecture diagram. |
| 119 | System Design Practice 1 — URL Shortener | **Design a URL shortener (like bit.ly).** Requirements: Shorten any URL, redirect users, track click analytics, support 100M URLs, handle 10B redirects/day. Components: Base-62 encoding for short codes (a–z, A–Z, 0–9 = 62 chars, 7-char code = 62^7 = 3.5 trillion unique URLs). Database: Write-heavy creation + Read-heavy redirection. Cache (Redis) for hot URLs (top 20% of URLs drive 80% of traffic). Analytics pipeline: redirect event → SQS → Lambda → DynamoDB analytics table. | Write out the complete design: API contract (POST /shorten, GET /{code}), data model (URL table schema), component diagram, cache strategy, analytics pipeline. Estimate: storage for 100M URLs, cache size for top 20% of URLs. Identify the bottleneck and explain how you'd scale it. |
| 120 | System Design Practice 2 — Rate Limiter | **Design a distributed rate limiter.** Requirements: Limit requests per user per time window, support multiple algorithms, work across multiple servers. Algorithms: Fixed window counter (simple, cheap, but allows burst at window boundary). Sliding window log (accurate, memory-intensive — store timestamp of every request). Token bucket (smooth rate limiting, allows short bursts up to bucket capacity — AWS API Gateway uses this). Leaky bucket (uniform output rate regardless of input — networking queues use this). Distributed rate limiting: Redis with atomic Lua scripts guarantees that the increment and check happen as one indivisible operation across all servers — prevents race conditions that would allow more requests than the limit. | Design the full system: choose the token bucket algorithm, describe the Redis data model (key = user_id, value = (tokens_remaining, last_refill_timestamp)), write the Lua script logic, explain how it integrates as middleware in your API Gateway, handle the edge case of Redis going down (fail open vs fail closed and the trade-off). |
| 121 | System Design Practice 3 — Cloud File Processing Pipeline | **Design a cloud file processing pipeline.** This is a direct extension of your Cloud-Morph project. Requirements: Users upload files (images, videos, PDFs). Pipeline must: generate thumbnails for images, extract text from PDFs (OCR), scan for viruses. Notify user when processing is complete. Handle failures with retries. Architecture: S3 (file storage) → SQS (job queue) → Lambda (processing workers, one per job type) → DynamoDB (job status table) → SNS (completion notification to user). For large video files that exceed Lambda's 15-minute timeout: use ECS Fargate (containerized batch processing). | Write the complete design: file upload flow, S3 event notification config, SQS message schema, Lambda function responsibilities, DynamoDB table schema (partition key = file_id, sort key = processing_step), SNS topic config, retry and DLQ configuration. Identify: what happens if the virus scan Lambda crashes mid-execution? How does the system detect and recover? |
| 122 | System Design Practice 4 — Distributed Key-Value Store | **Design the internals of a distributed key-value store (like Redis Cluster or DynamoDB).** This tests deep infrastructure knowledge. Requirements: O(1) get/put, handle node failures, scale horizontally, replicate data. Consistent Hashing: map both nodes and keys to a ring of 2^32 positions. A key is stored on the first node clockwise from its hash position. When a node is added or removed, only K/N keys are remapped (vs N keys for naive modulo hashing). Virtual nodes: each physical server maps to multiple positions on the ring — reduces variance in key distribution. Gossip Protocol: nodes periodically share their state table with random peers — O(log N) time for information to propagate across the cluster without a central coordinator. Vector Clocks: track causality for writes — each node maintains a version vector. Conflict detection: if two versions are not causally related, a conflict exists and must be resolved by the application (last-write-wins, or merge). | Draw the consistent hashing ring with 4 nodes and 3 virtual nodes each. Show what happens when Node 3 fails — which keys are remapped and to which node. Explain how a read request handles the case where the primary replica is down. Describe the write path: quorum writes (W + R > N ensures consistency), how W=2, R=2, N=3 is configured in practice. |

---

## 🤝 Phase 14: Behavioral Prep (Days 123–125)

*FAANG rejects strong coders on the behavioral round routinely. Three days is the minimum. Amazon specifically uses behavioral questions to evaluate culture fit against 14 named Leadership Principles — this is not casual conversation, it is a structured rubric. Prepare accordingly.*

**Estimated daily time: 1h30m. Difficulty: Light (reflection-heavy, not technical).**

| Day | Topic | Detailed Content & Tasks |
|-----|-------|--------------------------|
| 123 | STAR Method + Personal Story Bank | **The STAR Framework:** Situation (context, 1–2 sentences), Task (your specific responsibility), Action (what YOU did — always "I", not "we"), Result (quantified outcome where possible — "reduced latency by 40%", "shipped 3 days early", "automated a task that saved 2 hours/week"). Write your 10 personal stories using your actual experience. Story 1: Led a technically complex project under time pressure (Cloud-Morph, s3-backup-tool multipart upload fix). Story 2: Solved a problem no one else could solve (MD5/ETag multipart hash mismatch). Story 3: Showed initiative beyond what was required (1000-day public learning journey — this is your most powerful story, use it early). Story 4: Failed at something and what you learned (a project that didn't ship or broke in production). Story 5: Collaborated under disagreement (a team project where someone wanted a different technical approach). Story 6: Adapted quickly to a new technology (learning Go for systems programming, picking up Terraform). Story 7: Prioritized competing tasks with limited time (JCE coursework + multiple side projects running simultaneously). Story 8: Received hard feedback and acted on it (GitHub profile review — shallow commit history, committed pycache files). Story 9: Took full ownership of a mistake (be specific and honest — interviewers see through vague answers). Story 10: Made a decision with incomplete information (chose AWS over GCP for a project with no definitive comparison data). Practice each story out loud at 2 minutes max. Cut every word that doesn't add information. |
| 124 | Company-Specific Behavioral Frameworks | **Amazon — 14 Leadership Principles:** Every Amazon behavioral interview question maps to one or more of these principles. Map your 10 stories to the most relevant principle for each: Customer Obsession (how does your work benefit the end user?), Ownership (did you take responsibility beyond your job description?), Invent and Simplify (did you find a simpler solution?), Are Right A Lot (made a correct technical call others doubted?), Learn and Be Curious (self-directed 1000-day journey is a perfect example), Hire and Develop the Best (mentored a peer? raised the quality of a team project?), Insist on the Highest Standards (s3-backup-tool with MD5 integrity checking — refusing to ship without correctness), Think Big (public GitHub journey documenting a 1000-day career goal), Bias for Action (shipping Cloud-Morph with incomplete requirements rather than waiting for perfect specs), Frugality (building with free-tier AWS instead of paid services), Earn Trust (consistent public commits — your GitHub history is proof), Dive Deep (debugging the ETag multipart problem to its root cause), Have Backbone / Disagree and Commit (disagreed with a technical direction but committed to the team's decision), Deliver Results (shipped working projects). **Google:** Prepare for "comfort with ambiguity" questions and "Tell me about a time you had to figure something out with no guidance." Googleyness = intellectual curiosity + collaboration + not being defensive. **Meta:** "Move fast" = shipping iterations, not waiting for perfection. "Be direct" = giving honest feedback, not softening hard messages. Prepare for product-thinking questions: "How would you improve our developer infrastructure?" |
| 125 | Final Mock + Mental Preparation | **15-question mock behavioral interview.** Set a timer for 2 minutes per answer. Use your Story Bank. Do not over-explain. The 2-minute ceiling is a discipline. After the mock, write your final answers to these three questions that appear in virtually every interview: "Tell me about yourself" (2-minute version — lead with your 1000-day journey, your cloud projects, your AWS certification, your goal; do NOT read your resume chronologically). "Why this company?" (research the company's infrastructure stack, name a specific product or technical challenge they face, connect it to your work). "Why cloud infrastructure?" (anchor to the 1000-day journey, the tangible systems you've built, and where you see the field going — AI/ML infrastructure, GPU clusters, edge computing). The 1000-Day AI Cloud Infrastructure Engineering Journey is your single greatest differentiator. No other candidate in your cohort, your city, or likely your country has been doing this publicly since their first year of undergraduate study. You did not just learn cloud — you documented the entire process for the world to see. Lead with that. Own it. Sleep 8 hours. You are prepared. |

---

*Generated by the 125-Day Elite FAANG & Cloud Infrastructure Preparation System — Version 2.0.*
*Original framework: Antigravity. Upgraded with 16 improvements: missing sections written, Phase 10 expanded 3→6 days, Phase 11 expanded with Go+DSA bridge, Phase 12 expanded 5→11 days, Phase 13 (System Design) added, Phase 14 (Behavioral) added, Mistake Log and Pattern Cheat Sheet formats defined, 5 LeetCode Premium problems replaced with free alternatives, resources section and difficulty overview added.*