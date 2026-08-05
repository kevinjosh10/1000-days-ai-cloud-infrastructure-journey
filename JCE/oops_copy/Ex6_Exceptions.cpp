#include <iostream> // Include standard I/O library
#include <stdexcept> // Include standard exception library for runtime_error and out_of_range
using namespace std; // Use standard namespace

// Function to perform division that handles division by zero
float Division(float num, float den)
{
    // Check if the denominator is zero
    if (den == 0)
    {
        // If it is, throw a runtime_error exception with a specific message
        throw runtime_error("MATH ERROR: ATTEMPTED TO DIVIDE BY ZERO");
    }
    // If not zero, return the result of the division
    return (num / den);
}

int main() // Main function
{
    // Section 1: Demonstrating Division by Zero Exception
    float numerator = 12.5, denominator = 0, result; // Declare float variables and set denominator to 0
    try
    {
        // Attempt to call the Division function which will throw an exception
        result = Division(numerator, denominator); 
        cout << "THE QUOTIENT IS: " << result << endl; // This line won't execute if exception is thrown
    }
    catch (runtime_error &e) // Catch the runtime_error thrown by the Division function
    {
        // Print an error message along with the exception detail (e.what())
        cout << "EXCEPTION OCCURED" << endl << e.what() << endl;
    }
    
    // Section 2: Demonstrating Index Out of Range Exception
    const int Maxsize = 5; // Define a constant for the maximum size of the array
    int array[Maxsize] = {1, 2, 3, 4, 5}; // Initialize an array with 5 elements
    int index = 0; // Initialize an index variable to 0
    try 
    { 
        while (true) // Infinite loop to traverse the array until it goes out of bounds
        { 
            if (index < Maxsize) // If the index is within valid bounds
            {
                // Print the value at the current index
                std::cout << "Array value at Index: " << index << " is " << array[index] << std::endl;
                index++; // Increment the index
            }
            else // If the index reaches or exceeds Maxsize
            {
                // Throw an out_of_range exception with a specific message
                throw std::out_of_range("Array index out of Exception!");
            } 
        }
    }
    catch (const std::out_of_range &e) // Catch the out_of_range exception
    {
        // Print the exception detail to the standard error stream
        std::cerr << e.what() << std::endl;
    }
    
    return 0; // Terminate program successfully
}
