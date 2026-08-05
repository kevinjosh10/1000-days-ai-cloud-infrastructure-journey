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
