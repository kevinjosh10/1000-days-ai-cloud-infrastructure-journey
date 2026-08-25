#include <iostream> // Include the standard input/output stream library
#include <string> // Include the string library
using namespace std; // Use the standard namespace

class Student { // Define a class named 'Student'
private: // Private access specifier
    int rollno; // Integer variable to store the student's roll number
    float percentage; // Float variable to store the student's percentage

public: // Public access specifier
    // Default constructor (takes no arguments)
    Student() {
        rollno = 0; // Initialize rollno to 0
        percentage = 0.0f; // Initialize percentage to 0.0
    }

    // Parameterized constructor (takes arguments to initialize member variables)
    Student(int r, float p) {
        rollno = r; // Set the class member rollno to the passed value 'r'
        percentage = p; // Set the class member percentage to the passed value 'p'
    }

    // Copy constructor (creates a new object as a copy of an existing object)
    Student(Student &c) {
        rollno = c.rollno; // Copy the rollno from the existing object 'c'
        percentage = c.percentage; // Copy the percentage from the existing object 'c'
    }

    // Method to display student details
    void display() {
        std::cout << "Roll No: " << rollno << std::endl; // Print the roll number
        std::cout << "Percentage: " << percentage << std::endl; // Print the percentage
    }

    // Destructor (called automatically when the object is destroyed)
    ~Student()
    {
        std::cout << "Destructor called for:" << rollno << std::endl; // Print a message when the object is destroyed
    }
};

int main() { // Main function where execution starts
    // Using default constructor
    Student s2; // Creates object s2 using the default constructor
    std::cout << "Student (default constructor):" << std::endl; // Print a header
    s2.display(); // Call display method for s2
    std::cout << std::endl; // Print a newline
    
    // Using parameterized constructor
    Student s3(101, 85.5); // Creates object s3 passing roll number 101 and percentage 85.5
    std::cout << "Student (parameterized constructor):" << std::endl; // Print a header
    s3.display(); // Call display method for s3
    std::cout << std::endl; // Print a newline
    
    // Using copy constructor
    Student s4 = s3; // Creates object s4 by copying s3
    std::cout << "Student 3 (copy constructor):" << std::endl; // Print a header
    s4.display(); // Call display method for s4
    std::cout << std::endl; // Print a newline
    
    return 0; // Terminate program successfully
}

/*
CODE FLOW:
1. Execution starts in the `main()` function.
2. `Student s2;` is declared. The default constructor is called automatically, setting `s2`'s `rollno` to 0 and `percentage` to 0.0.
3. `s2.display()` is called, printing 0 and 0.
4. `Student s3(101, 85.5);` is declared. The parameterized constructor is called, setting `s3`'s `rollno` to 101 and `percentage` to 85.5.
5. `s3.display()` is called, printing 101 and 85.5.
6. `Student s4 = s3;` is declared. The copy constructor is called, copying the values from `s3` into `s4`.
7. `s4.display()` is called, printing 101 and 85.5.
8. The `main()` function finishes. As the objects (`s4`, `s3`, `s2`) go out of scope, their destructors are called automatically in reverse order of creation.

SUMMARY:
This program illustrates the different types of constructors and a destructor in C++.
- A Default Constructor `Student()` initializes the object with default values (0 and 0.0f).
- A Parameterized Constructor `Student(int r, float p)` initializes the object with values provided during instantiation.
- A Copy Constructor `Student(Student &c)` creates a new object by copying the data from an existing object.
- A Destructor `~Student()` is defined to show when an object goes out of scope and is destroyed.
- In `main`, it creates three distinct objects showcasing each constructor type and calls a method to display their data.
*/
