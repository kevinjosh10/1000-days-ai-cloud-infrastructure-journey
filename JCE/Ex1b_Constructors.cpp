#include <iostream>
#include <string>
using namespace std;
class Student {
private:
    int rollno;
    float percentage;
public:
    // Default constructor
    Student() {
        rollno = 0;
        percentage = 0.0f;
    }
    // Parameterized constructor
    Student(int r, float p) {
        rollno = r;
        percentage = p;
    }
    // Copy constructor
    Student(Student &c) {
        rollno = c.rollno;
        percentage = c.percentage;
    }
    // Method to display student details
    void display() {
        std::cout << "Roll No: " << rollno << std::endl;
        std::cout << "Percentage: " << percentage << std::endl;
    }
    ~Student()
    {
        std::cout<<"Destructor called for:"<<rollno<<std::endl;
    }
};

int main() {
    // Using default constructor
    Student s2;
    std::cout << "Student (default constructor):" << std::endl;
    s2.display();
    std::cout << std::endl;
    
    // Using parameterized constructor
    Student s3(101, 85.5);
    std::cout << "Student (parameterized constructor):" << std::endl;
    s3.display();
    std::cout << std::endl;
    
    // Using copy constructor
    Student s4= s3; // or Student s3(s2);
    std::cout << "Student 3 (copy constructor):" << std::endl;
    s4.display();
    std::cout << std::endl;
    
    return 0;
}
