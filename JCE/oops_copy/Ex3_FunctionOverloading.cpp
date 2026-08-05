#include <iostream> // Include standard I/O library
using namespace std; // Use standard namespace

class Area // Define a class named 'Area'
{
public: // Public access specifier
    int side; // Variable to store side of a square
    int length; // Variable to store length of a rectangle
    int breadth; // Variable to store breadth of a rectangle
    float pi; // Variable to store the value of pi
    int radius; // Variable to store radius of a circle

    // Default constructor
    Area()
    {
        pi = 3.14; // Initialize pi to 3.14 when object is created
    }

    // Overloaded function 'print' to calculate area of a square
    int print(int side)
    {
        return side * side; // Area of square = side * side
    }

    // Overloaded function 'print' to calculate area of a rectangle
    int print(int length, int breadth)
    {
        return length * breadth; // Area of rectangle = length * breadth
    }

    // Overloaded function 'print' to calculate area of a circle
    float print(int radius, float pi)
    {
        return pi * radius * radius; // Area of circle = pi * r^2
    }
};

int main() // Main function
{
    int choice; // Variable to store user's menu choice
    Area a; // Create an object 'a' of class Area
    
    // Display a menu to the user
    cout << "1. Square" << endl;
    cout << "2. Rectangle" << endl;
    cout << "3. Circle" << endl;
    cout << "Enter Your choice (1-3): "; // Prompt for input
    cin >> choice; // Read user choice

    // Switch case to handle the user's choice
    switch (choice)
    {
        case 1: // If user chose 1 (Square)
            cout << "Enter the side of Square: "; // Prompt for side
            cin >> a.side; // Read side
            cout << "Area of Square: " << a.print(a.side) << endl; // Calculate and print area
            break; // Exit switch
            
        case 2: // If user chose 2 (Rectangle)
            cout << "Enter the length and Breadth: "; // Prompt for length and breadth
            cin >> a.length >> a.breadth; // Read length and breadth
            cout << "Area of Rectangle: " << a.print(a.length, a.breadth) << endl; // Calculate and print area
            break; // Exit switch
            
        case 3: // If user chose 3 (Circle)
            cout << "Enter the Radius: "; // Prompt for radius
            cin >> a.radius; // Read radius
            cout << "Area of Circle: " << a.print(a.radius, a.pi) << endl; // Calculate and print area
            break; // Exit switch
            
        default: // If user entered an invalid choice
            cout << "Invalid choice" << endl; // Print error message
    }
    
    return 0; // Terminate program successfully
}

/*
CODE FLOW:
1. Execution begins in `main()`. An `Area` object `a` is instantiated, and its default constructor initializes `pi` to 3.14.
2. A text menu is displayed to the user via `cout`, prompting them to choose a shape (Square, Rectangle, Circle).
3. The user inputs their `choice`, which is evaluated in a `switch` statement.
4. If choice is 1: The program asks for a side length, reads it into `a.side`, and calls `a.print(a.side)`. The compiler matches this to the `print(int)` method.
5. If choice is 2: The program asks for length and breadth, reads them, and calls `a.print(a.length, a.breadth)`. The compiler matches this to the `print(int, int)` method.
6. If choice is 3: The program asks for a radius, reads it, and calls `a.print(a.radius, a.pi)`. The compiler matches this to the `print(int, float)` method.
7. The appropriate calculated area is returned and printed, and the program terminates.

SUMMARY:
This program demonstrates Function Overloading in C++, which is a feature of compile-time polymorphism.
- Function overloading allows multiple functions to have the same name (`print`) as long as their parameter lists (number or type of parameters) are different.
- The `Area` class contains three `print` methods: one taking a single integer (for a square), one taking two integers (for a rectangle), and one taking an integer and a float (for a circle).
- The compiler automatically determines which `print` function to invoke based on the arguments passed to it.
- A switch-case menu system is used to allow the user to select which shape's area they want to calculate at runtime.
*/
