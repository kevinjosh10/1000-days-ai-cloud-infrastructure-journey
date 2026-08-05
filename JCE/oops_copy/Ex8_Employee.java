import java.util.Scanner; // Import Scanner for user input

// Base class Employee containing common attributes and methods for all employees
class Employee {
    String name; // Employee's name
    int id; // Employee's ID
    int grossSalary, HRA, medical, transport, PF, tax; // Salary components and deductions

    // Constructor to initialize the Employee object with basic details
    public Employee(String name, int id, int grossSalary, int HRA, int medical, int transport, int PF, int tax) {
        this.name = name; // Initialize name
        this.id = id; // Initialize ID
        this.grossSalary = grossSalary; // Initialize gross salary
        this.HRA = HRA; // Initialize House Rent Allowance
        this.medical = medical; // Initialize medical allowance
        this.transport = transport; // Initialize transport allowance
        this.PF = PF; // Initialize Provident Fund deduction
        this.tax = tax; // Initialize income tax deduction
    }

    // Method to print all the details of the employee
    void getDetails() {
        System.out.println("Name: " + name);
        System.out.println("ID: " + id);
        System.out.println("Gross Salary: " + grossSalary);
        System.out.println("HRA: " + HRA);
        System.out.println("Medical Insurance: " + medical);
        System.out.println("Transport: " + transport);
        System.out.println("PF: " + PF);
        System.out.println("Income Tax: " + tax);
    }

    // Method to calculate and display the final basic salary after adding benefits and subtracting deductions
    String display() {
        int benefits = calculateBenefits(); // Get additional benefits (depends on specific subclass)
        // Formula: Gross + Benefits - (All deductions combined)
        int basicSalary = grossSalary + benefits - (HRA + medical + transport + PF + tax);
        System.out.println("Basic Salary: " + basicSalary); // Print the calculated salary
        return "Basic Salary: " + basicSalary; // Return the string
    }

    // Default implementation for benefits, returns 0. Designed to be overridden by subclasses.
    int calculateBenefits() {
        return 0; 
    }
}

// Subclass Programmer inherits from Employee
class Programmer extends Employee {
    int hike; // Specific attribute for Programmer
    
    // Constructor for Programmer, calls the superclass (Employee) constructor first
    public Programmer(String name, int id, int grossSalary, int HRA, int medical, int transport, int PF, int tax, int hike) {
        super(name, id, grossSalary, HRA, medical, transport, PF, tax); // Call to super()
        this.hike = hike; // Initialize programmer-specific attribute
    }
    
    // Override the calculateBenefits method to return the hike amount
    @Override
    int calculateBenefits() {
        return hike;
    }
    
    // Method to orchestrate printing the Programmer's salary details
    void call() {
        System.out.println("Programmer Salary"); // Print a header
        getDetails(); // Call inherited method to print basic details
        display(); // Call inherited method to print calculated basic salary
    }
}

// Subclass AssistantProfessor inherits from Employee
class AssistantProfessor extends Employee {
    int researchAllowance; // Specific attribute for Assistant Professor
    
    // Constructor for AssistantProfessor, calls superclass constructor
    public AssistantProfessor(String name, int id, int grossSalary, int HRA, int medical, int transport, int PF, int tax, int researchAllowance) {
        super(name, id, grossSalary, HRA, medical, transport, PF, tax);
        this.researchAllowance = researchAllowance; // Initialize specific attribute
    }
    
    // Override calculateBenefits to return research allowance
    @Override
    int calculateBenefits() {
        return researchAllowance;
    }
    
    // Method to orchestrate printing the Assistant Professor's salary details
    void call() {
        System.out.println("Assistant Professor Salary");
        getDetails();
        display();
    }
}

// Subclass Professor inherits from Employee
class Professor extends Employee {
    int publicationBonus; // Specific attribute for Professor
    
    // Constructor for Professor, calls superclass constructor
    public Professor(String name, int id, int grossSalary, int HRA, int medical, int transport, int PF, int tax, int publicationBonus) {
        super(name, id, grossSalary, HRA, medical, transport, PF, tax);
        this.publicationBonus = publicationBonus; // Initialize specific attribute
    }
    
    // Override calculateBenefits to return publication bonus
    @Override
    int calculateBenefits() {
        return publicationBonus;
    }
    
    // Method to orchestrate printing the Professor's salary details
    void call() {
        System.out.println("Professor Salary");
        getDetails();
        display();
    }
}

// Main class to run the program
public class SalaryProgram {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in); // Initialize Scanner
        
        // Take basic employee inputs
        System.out.print("Enter name: ");
        String name = sc.nextLine();
        System.out.print("Enter ID: ");
        int id = sc.nextInt();
        sc.nextLine(); // Consume the newline character left in the buffer by nextInt()
        
        // Take the profession to determine which subclass to instantiate
        System.out.print("Enter profession (Programmer/AssistantProfessor/Professor): ");
        String profession = sc.nextLine();
        
        // Take common financial inputs
        System.out.print("Enter Gross Salary: ");
        int grossSalary = sc.nextInt();
        System.out.print("Enter HRA: ");
        int HRA = sc.nextInt();
        System.out.print("Enter Medical Insurance: ");
        int medical = sc.nextInt();
        System.out.print("Enter Transport: ");
        int transport = sc.nextInt();
        System.out.print("Enter PF: ");
        int PF = sc.nextInt();
        System.out.print("Enter Tax: ");
        int tax = sc.nextInt();
        
        // Instantiate the appropriate subclass based on the profession entered
        if (profession.equalsIgnoreCase("Programmer")) {
            System.out.print("Enter Hike: ");
            int hike = sc.nextInt(); // Get specific attribute for Programmer
            // Create Programmer object and call its method
            Programmer p = new Programmer(name, id, grossSalary, HRA, medical, transport, PF, tax, hike);
            p.call();
        } else if (profession.equalsIgnoreCase("AssistantProfessor")) {
            System.out.print("Enter Research Allowance: ");
            int researchAllowance = sc.nextInt(); // Get specific attribute for Assistant Professor
            // Create AssistantProfessor object and call its method
            AssistantProfessor ap = new AssistantProfessor(name, id, grossSalary, HRA, medical, transport, PF, tax, researchAllowance);
            ap.call();
        } else if (profession.equalsIgnoreCase("Professor")) {
            System.out.print("Enter Publication Bonus: ");
            int publicationBonus = sc.nextInt(); // Get specific attribute for Professor
            // Create Professor object and call its method
            Professor pr = new Professor(name, id, grossSalary, HRA, medical, transport, PF, tax, publicationBonus);
            pr.call();
        } else {
            // Handle invalid input
            System.out.println("Invalid profession entered.");
        }
        
        sc.close(); // Close Scanner to prevent leaks
    }
}

/*
SUMMARY:
This Java program is a comprehensive demonstration of Inheritance, Polymorphism, and the `super` keyword.
- It defines a base superclass `Employee` containing shared attributes (id, name, salary components) and methods for calculating and displaying salary details.
- It defines three subclasses (`Programmer`, `AssistantProfessor`, `Professor`) that extend `Employee`.
- Each subclass inherits the common attributes but also introduces its own unique attributes (like `hike`, `researchAllowance`, `publicationBonus`).
- The `super()` keyword is utilized in the subclass constructors to invoke the parent class constructor for initializing shared fields.
- Polymorphism is demonstrated by overriding the `calculateBenefits()` method in each subclass to provide a role-specific calculation for basic salary.
*/
