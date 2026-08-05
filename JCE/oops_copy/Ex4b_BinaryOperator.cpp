#include <iostream> // Include standard I/O library
#include <string.h> // Include string handling library for strcpy and strcat
using namespace std; // Use standard namespace

class AddString // Define a class named 'AddString'
{
public: // Public access specifier
    char s1[25], s2[25]; // Declare two character arrays of size 25
    
    // Constructor to initialize the character arrays
    AddString(char str1[25], char str2[25]) 
    {
        strcpy(this->s1, str1); // Copy the contents of str1 into class member s1
        strcpy(this->s2, str2); // Copy the contents of str2 into class member s2
    }
    
    // Overload the binary '+' operator (used here as a unary operator syntactically in the original code)
    // Note: To properly overload binary +, it should take an argument, but the provided lab code overloaded unary + to do concatenation.
    void operator +()
    {
        // Concatenate s2 to the end of s1 and print the result
        cout << "In CONCATENATION:" << strcat(s1, s2);
    }
};

int main() // Main function
{
    char str1[] = "GOOD"; // Declare and initialize a character array
    char str2[] = " MORNING"; // Declare and initialize a second character array
    
    AddString a1(str1, str2); // Create an AddString object with the arrays
    
    +a1; // Call the overloaded '+' operator function to perform concatenation
    
    return 0; // Terminate program successfully
}
