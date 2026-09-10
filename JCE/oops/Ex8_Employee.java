import java.util.Scanner;

class Employee {
    String name;
    int id;
    double basic;

    void getData(Scanner sc) {
        System.out.print("Enter ID, Name, Basic Pay: ");
        id = sc.nextInt();
        name = sc.next();
        basic = sc.nextDouble();
    }

    void display() {
        System.out.println("ID: " + id + " | Name: " + name + " | Basic: " + basic);
    }
}

class Programmer extends Employee {
    void calculateSalary() {
        double da = 0.97 * basic;
        double hra = 0.10 * basic;
        double pf = 0.12 * basic;
        double gross = basic + da + hra;
        double net = gross - pf;

        display();
        System.out.println("Gross Pay: " + gross + " | Net Pay: " + net);
    }
}

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        Programmer p = new Programmer();
        p.getData(sc);
        p.calculateSalary();
    }
}
