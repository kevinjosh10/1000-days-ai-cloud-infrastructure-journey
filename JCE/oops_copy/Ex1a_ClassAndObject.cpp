#include<iostream> // Include the standard input/output stream library
#include<string> // Include the string library to use string data types
using namespace std; // Use the standard namespace so we don't have to prefix std::

class Student // Define a class named 'Student'
{
private: // Access specifier: the following members are private (accessible only within the class)
    int age; // Integer variable to store the age of the student
    string Name; // String variable to store the name of the student
    int Rollno; // Integer variable to store the roll number of the student

public: // Access specifier: the following members are public (accessible from outside the class)
    // Parameterized constructor to initialize the student details
    Student(string n, int a, int r)
    {
        Name = n; // Assign the parameter 'n' to the class member 'Name'
        age = a; // Assign the parameter 'a' to the class member 'age'
        Rollno = r; // Assign the parameter 'r' to the class member 'Rollno'
    }

    // Method to display the details of the student
    void displayDetails()
    {
        cout << "NAME:" << Name << endl; // Print the student's name followed by a newline
        cout << "AGE:" << age << endl; // Print the student's age followed by a newline
        cout << "ROLLNO:" << Rollno << endl; // Print the student's roll number followed by a newline
    }
};

int main() { // The main function where execution begins
    // Create an object 's' of the 'Student' class and pass initial values via the constructor
    Student s("JOHN", 18, 20); 
    s.displayDetails(); // Call the displayDetails method on object 's' to print its data
    cout << endl; // Print an extra newline character for formatting
    return 0; // Return 0 to indicate successful program termination
}

/*
SUMMARY:
This program demonstrates the fundamental concepts of Object-Oriented Programming (OOP) in C++: Classes and Objects.
- It defines a `Student` class that encapsulates the data (age, Name, Rollno) and the methods that operate on that data.
- It uses a parameterized constructor to initialize the member variables when an object is created.
- In the `main` function, a single `Student` object named `s` is instantiated with specific values.
- The `displayDetails` method is then called on the object to print its internal state to the console.
*/
