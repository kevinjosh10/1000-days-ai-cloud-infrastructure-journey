class BankAccount { // Defines the BankAccount resource shared across concurrent threads
    private int balance = 100; // Encapsulated initial account balance

    // Non-synchronized method: does NOT acquire a lock.
    // Multiple threads can enter and execute this method simultaneously, leading to race conditions.
    public void withdraw(int amount) {
        if (balance >= amount) { // Both threads check initial condition at nearly the same time
            try { 
                Thread.sleep(100); // Artificial delay increases the probability of interleaving / race condition
            } catch (Exception e) {} // Handles thread interruption
            
            balance -= amount; // Both threads deduct from stale balance, producing corrupt/negative balance
            System.out.println("Withdrawn: " + amount + ", Remaining balance: " + balance); // Outputs corrupt balance
        } else
            System.out.println("Insufficient balance to withdraw: " + amount);
    }
}

public class BankWithoutSynchronization { // Driver class demonstrating un-synchronized multi-threading race condition
    public static void main(String[] args) { // Main execution entry point
        BankAccount a = new BankAccount(); // Creates a single shared BankAccount instance

        // Spawns two threads concurrently without synchronization mechanisms
        new Thread(() -> a.withdraw(80)).start(); // First thread attempts to withdraw 80
        new Thread(() -> a.withdraw(50)).start(); // Second thread attempts to withdraw 50
    }
}

/*
CODE FLOW:
1. A single `BankAccount` object `a` is created with a `balance` of 100.
2. Two threads are launched at the same time:
   - Thread 1 attempts to withdraw 80.
   - Thread 2 attempts to withdraw 50.
3. Without `synchronized`, both threads enter `withdraw()` concurrently:
   - Thread 1 checks `balance >= 80` (100 >= 80 is TRUE) and goes to sleep for 100ms.
   - While Thread 1 is sleeping, Thread 2 checks `balance >= 50` (balance is STILL 100, so 100 >= 50 is TRUE) and also goes to sleep.
4. After waking up:
   - Thread 1 executes `balance -= 80` (balance becomes 20).
   - Thread 2 executes `balance -= 50` (balance becomes 20 - 50 = -30).
5. Both transactions falsely succeed, overdrawing the account and leaving a negative remaining balance (-30).

SUMMARY:
This program illustrates a classic Race Condition and Critical Section problem in multithreaded programming when synchronization is absent. Because `withdraw()` is not synchronized, context switching during the delay causes both threads to read an outdated state and perform conflicting writes. This exposes the hazard of shared mutable state without proper locking mechanisms.
*/
