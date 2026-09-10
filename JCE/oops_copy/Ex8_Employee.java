import java.util.Scanner; // Imports the Scanner class for capturing user input from the console

class Employee { // Defines the base class 'Employee' representing general employee details
    String name; // Declares a String variable to store the employee's name
    int id; // Declares an integer variable to store the employee ID
    double basic; // Declares a double variable to store the basic salary pay

    void getData(Scanner sc) { // Method to read employee information from user input
        System.out.print("Enter ID, Name, Basic Pay: "); // Prompts user to input employee attributes
        id = sc.nextInt(); // Reads and assigns the integer ID
        name = sc.next(); // Reads and assigns the single-word name token
        basic = sc.nextDouble(); // Reads and assigns the basic pay amount
    } // End of getData method

    void display() { // Method to display the employee's identity and basic pay details
        System.out.println("ID: " + id + " | Name: " + name + " | Basic: " + basic); // Prints formatted employee details
    } // End of display method
} // End of Employee class

class Programmer extends Employee { // Defines subclass 'Programmer' that inherits attributes and methods from Employee
    void calculateSalary() { // Method to calculate allowances, deductions, gross pay, and net pay
        double da = 0.97 * basic; // Calculates Dearness Allowance (DA) as 97% of basic pay
        double hra = 0.10 * basic; // Calculates House Rent Allowance (HRA) as 10% of basic pay
        double pf = 0.12 * basic; // Calculates Provident Fund (PF) deduction as 12% of basic pay
        double gross = basic + da + hra; // Computes Gross Salary by summing basic pay, DA, and HRA
        double net = gross - pf; // Computes Net Take-home Salary by subtracting PF deduction from Gross Pay

        display(); // Calls inherited display() method from base class Employee to print employee info
        System.out.println("Gross Pay: " + gross + " | Net Pay: " + net); // Prints calculated Gross and Net salary values
    } // End of calculateSalary method
} // End of Programmer class

public class Main { // Defines the main driver class
    public static void main(String[] args) { // Main execution entry point of the program
        Scanner sc = new Scanner(System.in); // Instantiates a Scanner object to read standard console input
        Programmer p = new Programmer(); // Instantiates a Programmer object
        p.getData(sc); // Invokes inherited getData() method to read ID, name, and basic pay
        p.calculateSalary(); // Invokes calculateSalary() to compute allowances, print details, and show pay slip
    } // End of main method
} // End of Main class

/* 
CODE FLOW:
1. The program starts in the `main` method of the `Main` class.
2. A `Scanner` object `sc` is created to handle user console inputs.
3. An instance `p` of class `Programmer` is created. Since `Programmer` extends `Employee`, `p` inherits `id`, `name`, `basic`, `getData()`, and `display()`.
4. `p.getData(sc)` is invoked, prompting the user to enter their ID, Name, and Basic Pay sequentially.
5. `p.calculateSalary()` is invoked:
   - DA is calculated as 97% of basic pay.
   - HRA is calculated as 10% of basic pay.
   - PF is calculated as 12% of basic pay.
   - Gross pay is calculated as (basic + da + hra).
   - Net pay is calculated as (gross - pf).
   - `display()` is called to output the employee's ID, Name, and Basic pay.
   - The Gross Pay and Net Pay are printed to the console.
6. The program terminates successfully.
*/

/* 
SUMMARY:
This program illustrates Single Inheritance in Object-Oriented Programming (OOP) using Java. 
The base class `Employee` encapsulates shared employee data (ID, name, basic salary) and utility methods (`getData` and `display`). 
The derived class `Programmer` inherits these attributes and behavior using the `extends` keyword, while extending the functionality by defining `calculateSalary()` to compute role-specific payroll components (DA, HRA, PF, Gross Pay, and Net Pay). 
This demonstrates code reusability and clean separation of concerns.
*/
