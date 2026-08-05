package calculator; // Define the package name
import java.util.Scanner; // Import the Scanner class for taking user input

public class Calculator { // Define a public class named Calculator
    public static void main(String[] args) // The main method, entry point of the program
    {
        // Create a Scanner object to read input from the standard input stream (keyboard)
        Scanner scanner = new Scanner(System.in);
        
        System.out.println("Enter the first number: "); // Prompt the user for the first number
        double num1 = scanner.nextDouble(); // Read the first double value entered by the user
        
        System.out.println("Enter the second number: "); // Prompt the user for the second number
        double num2 = scanner.nextDouble(); // Read the second double value entered by the user
        
        // Perform arithmetic operations
        double sum = num1 + num2; // Calculate the sum
        double difference = num1 - num2; // Calculate the difference
        double product = num1 * num2; // Calculate the product
        double quotient = num1 / num2; // Calculate the quotient (division)
        double remainder = num1 % num2; // Calculate the remainder (modulo)
        
        // Print the results of the operations to the console
        System.out.println("Sum: " + sum);
        System.out.println("Difference: " + difference);
        System.out.println("Product: " + product);
        System.out.println("Quotient: " + quotient);
        System.out.println("Remainder: " + remainder);
        
        // Close the scanner object to prevent resource leaks
        scanner.close();
    }
}

/*
CODE FLOW:
1. Execution starts in the `main` method of the `Calculator` class.
2. A `Scanner` object is instantiated to read input from the console (`System.in`).
3. The user is prompted to enter the first number. The program halts and waits for input via `scanner.nextDouble()`, storing it in `num1`.
4. The user is prompted to enter the second number, which is stored in `num2`.
5. The program sequentially calculates the sum, difference, product, quotient, and remainder by evaluating arithmetic expressions using `num1` and `num2`.
6. Each calculated result is immediately assigned to its respective double variable.
7. The `System.out.println` statements are executed to output the calculated results in a formatted manner to the console.
8. The `Scanner` object is closed to free up system resources, and the program terminates.

SUMMARY:
This Java program acts as a basic mathematical calculator.
- It utilizes the `java.util.Scanner` class to accept user input from the console.
- Two double-precision floating-point numbers are requested from the user.
- The program sequentially performs standard arithmetic operations: addition (+), subtraction (-), multiplication (*), division (/), and modulus/remainder (%).
- Finally, it outputs the results of all five calculations. It demonstrates basic Java I/O and arithmetic operators.
*/
