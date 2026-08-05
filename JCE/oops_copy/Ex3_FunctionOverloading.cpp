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
