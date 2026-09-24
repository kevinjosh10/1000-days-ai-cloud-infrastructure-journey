class BankAccount {
    private int balance = 100;

    public void withdraw(int amount) {
        if (balance >= amount) {
            try { Thread.sleep(100); } catch (Exception e) {}
            balance -= amount;
            System.out.println("Withdrawn: " + amount + ", Remaining balance: " + balance);
        } else
            System.out.println("Insufficient balance to withdraw: " + amount);
    }
}

public class BankWithoutSynchronization {
    public static void main(String[] args) {
        BankAccount a = new BankAccount();

        new Thread(() -> a.withdraw(80)).start();
        new Thread(() -> a.withdraw(50)).start();
    }
}
