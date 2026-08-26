import java.util.Scanner; // Imports the Scanner class for taking user input from the console

public class Calculator { // Declares a public class named Calculator
    public static void main(String[] args) { // Main method where the program execution begins

        Scanner sc = new Scanner(System.in); // Creates a Scanner object named 'sc' to read input from System.in (keyboard)

        System.out.print("Enter first number: "); // Prompts the user to enter the first number
        double a = sc.nextDouble(); // Reads a double (decimal) value from the user and stores it in variable 'a'

        System.out.print("Enter second number: "); // Prompts the user to enter the second number
        double b = sc.nextDouble(); // Reads a double (decimal) value from the user and stores it in variable 'b'

        System.out.print("Enter operator (+, -, *, /, %): "); // Prompts the user to enter a mathematical operator
        char op = sc.next().charAt(0); // Reads the next string input and extracts the first character to store in 'op'

        switch (op) { // Starts a switch statement to perform different actions based on the value of 'op'
            case '+': // If the operator is '+'
                System.out.println("Result: " + (a + b)); // Adds 'a' and 'b' and prints the result
                break; // Exits the switch block
            case '-': // If the operator is '-'
                System.out.println("Result: " + (a - b)); // Subtracts 'b' from 'a' and prints the result
                break; // Exits the switch block
            case '*': // If the operator is '*'
                System.out.println("Result: " + (a * b)); // Multiplies 'a' and 'b' and prints the result
                break; // Exits the switch block
            case '/': // If the operator is '/'
                System.out.println("Result: " + (a / b)); // Divides 'a' by 'b' and prints the result
                break; // Exits the switch block
            case '%': // If the operator is '%'
                System.out.println("Result: " + (a % b)); // Calculates the remainder of 'a' divided by 'b' and prints the result
                break; // Exits the switch block
            default: // If the operator does not match any of the above cases
                System.out.println("Invalid operator"); // Prints an error message
        }

        sc.close(); // Closes the Scanner object to prevent memory leaks and free up system resources
    }
}

/* 
CODE FLOW:
1. The program starts by importing the `java.util.Scanner` class, which allows it to read input from the user.
2. Inside the `main` method, a `Scanner` object `sc` is instantiated.
3. The program prompts the user to enter a first number, which is read as a `double` and stored in variable `a`.
4. It prompts for a second number, which is read and stored in variable `b`.
5. It then prompts the user for a mathematical operator. It reads this input as a string and uses `.charAt(0)` to grab just the first character.
6. A `switch` statement evaluates the operator character (`+`, `-`, `*`, `/`, `%`).
7. Based on the matched case, the program performs the corresponding mathematical operation directly inside the `println` statement and prints the result.
8. The `break` statement prevents the code from "falling through" to execute the other cases.
9. If the user enters an unrecognized operator, the `default` case handles it by printing "Invalid operator".
10. Finally, `sc.close()` is called to close the input stream cleanly.
*/

/* 
SUMMARY:
This is a simple interactive calculator program written in Java. It demonstrates basic console Input/Output operations using the `Scanner` class and control flow using a `switch` statement. 
By using `double` data types, it is capable of handling both whole integers and decimal numbers. The switch statement makes the code highly readable and efficient for routing the program's logic based on a single character input.
*/
