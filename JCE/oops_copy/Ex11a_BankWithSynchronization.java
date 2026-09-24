class BankAccount { // Defines the BankAccount resource shared across concurrent threads
    private int balance = 100; // Encapsulated initial account balance

    // Synchronized method: acquires intrinsic lock (monitor) of the BankAccount instance.
    // Only one thread can execute this method at any given moment.
    public synchronized void withdraw(int amount) {
        if (balance >= amount) { // Checks if sufficient funds are available
            try { 
                Thread.sleep(100); // Simulates latency in database / transaction processing
            } catch (Exception e) {} // Handles thread interruption
            
            balance -= amount; // Safely deducts the requested withdrawal amount
            System.out.println("Withdrawn: " + amount + ", Remaining balance: " + balance); // Prints transaction result
        } else // If withdrawal amount exceeds current balance
            System.out.println("Insufficient balance to withdraw: " + amount); // Rejects transaction safely
    }
}

public class BankWithSynchronization { // Driver class demonstrating thread synchronization
    public static void main(String[] args) { // Main execution entry point
        BankAccount a = new BankAccount(); // Creates a single shared BankAccount instance

        // Spawns two threads concurrently trying to withdraw money from the same account
        new Thread(() -> a.withdraw(80)).start(); // First thread attempts to withdraw 80
        new Thread(() -> a.withdraw(50)).start(); // Second thread attempts to withdraw 50
    }
}

/*
CODE FLOW:
1. A shared `BankAccount` object `a` is instantiated with an initial balance of 100.
2. Two threads are spawned concurrently using lambda expressions:
   - Thread 1 calls `a.withdraw(80)`.
   - Thread 2 calls `a.withdraw(50)`.
3. Because `withdraw()` is declared as `synchronized`, whichever thread reaches it first acquires the lock on object `a`.
4. The first thread finds `balance >= 80` (100 >= 80), sleeps for 100ms, updates `balance = 20`, prints success, and releases the lock.
5. The second thread now acquires the lock, enters `withdraw(50)`, and evaluates `balance >= 50` (20 >= 50, which is false).
6. The second thread executes the `else` branch, safely printing "Insufficient balance to withdraw: 50".
7. Account balance never becomes negative, preventing a race condition.

SUMMARY:
This program demonstrates Thread Synchronization in Java using the `synchronized` keyword. When multiple threads access shared mutable state simultaneously, race conditions can occur. Marking critical sections with `synchronized` ensures mutual exclusion, meaning only one thread can execute the synchronized method on a given object at a time. This guarantees data consistency and thread safety in concurrent banking operations.
*/
