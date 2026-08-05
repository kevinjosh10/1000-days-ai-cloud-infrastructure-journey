#include<iostream> // Include the standard input/output stream library
using namespace std; // Use the standard namespace

class Student // Define a class named 'Student'
{
private: // Private access specifier
    static int count; // Static variable to keep track of the number of objects created
    int id; // Integer variable to store the unique object ID
    int stdid; // Integer variable to store the student ID
    int regno; // Integer variable to store the registration number

public: // Public access specifier
    // Parameterized constructor
    Student(int i, int r)
    {
        stdid = i; // Assign parameter 'i' to student ID
        regno = r; // Assign parameter 'r' to registration number
    }
    
    // Default constructor
    Student() {
        count++; // Increment the static count variable whenever a new object is created
        id = count; // Assign the current count as the unique ID for this object
    }
    
    // Destructor
    ~Student()
    {
        count--; // Decrement the count when an object is destroyed
    }
    
    // Static method to get the total number of objects created
    static int getCount()
    {
        return count; // Return the static count variable
    }
    
    // Method to display student details
    void display()
    {
        std::cout << "ENTER STUDENT DETAILS:" << endl; // Print header message
        std::cout << "STUDENT ID:" << stdid << endl << "REG NUM:" << regno << endl; // Print student ID and registration number
        std::cout << "OBJECT ID:" << id << std::endl; // Print the unique object ID
    }
};

int Student::count = 0; // Initialize the static member variable 'count' to 0 outside the class

int main(){ // Main function
    Student obj1; // Create first student object (calls default constructor)
    Student obj2; // Create second student object (calls default constructor)
    Student obj3; // Create third student object (calls default constructor)
    
    // Print the total number of objects created by calling the static method getCount()
    std::cout << "NUMBER OF OBJECTS CREATED:" << Student::getCount() << std::endl;
    
    obj1.display(); // Display details for obj1
    obj2.display(); // Display details for obj2
    obj3.display(); // Display details for obj3
    
    return 0; // Terminate program successfully
}

/*
CODE FLOW:
1. Before `main()` executes, the static variable `count` is initialized to 0 in memory.
2. Execution starts in `main()`.
3. Three `Student` objects (`obj1`, `obj2`, `obj3`) are instantiated using the default constructor.
4. For each instantiation, the default constructor increments the static `count` by 1 and assigns that updated `count` to the object's unique `id`.
5. The static method `Student::getCount()` is called directly using the class name, returning the final `count` (which is 3), and it is printed to the console.
6. The `display()` method is called sequentially for `obj1`, `obj2`, and `obj3`, printing their respective IDs.
7. As the program terminates, the objects go out of scope and their destructors are called, decrementing the static `count` back down.

SUMMARY:
This program demonstrates the use of static data members and static member functions in C++.
- A static variable `count` is shared across all instances of the `Student` class. It acts as a global tracker for the class rather than being tied to a specific object.
- The `count` increments every time a new object is created (inside the constructor) and decrements when destroyed (inside the destructor).
- The static method `getCount()` allows access to the static variable without needing to instantiate an object, utilizing the scope resolution operator `Student::getCount()`.
- It dynamically assigns a unique object ID (`id`) based on the current count at the time of creation.
*/
