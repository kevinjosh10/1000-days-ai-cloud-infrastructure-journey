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
