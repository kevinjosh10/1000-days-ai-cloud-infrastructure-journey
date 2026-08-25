#include <iostream> // Include standard I/O library
#include <string> // Include string library
using namespace std; // Use standard namespace

// Define a template function named 'myMax' that takes three arguments of generic type T
template <typename T>
T myMax(T x, T y, T z) 
{
    // Find the maximum between x and y using the ternary operator
    T max_xy = (x > y) ? x : y; 
    
    // Compare the maximum of (x, y) with z to find the overall maximum and return it
    return (max_xy > z) ? max_xy : z; 
}

int main() // Main function
{
    // Call 'myMax' explicitly defining the type as <int> and pass three integers
    cout << myMax<int>(3, 7, 2) << endl; 
    
    // Call 'myMax' explicitly defining the type as <float> and pass three floats
    cout << myMax<float>(3.0, 7.0, 4.0) << endl; 
    
    // Call 'myMax' explicitly defining the type as <char> and pass three characters
    cout << myMax<char>('R', 'V', 'A') << endl; 
    
    // Call 'myMax' explicitly defining the type as <string> and pass three strings
    cout << myMax<string>("R", "A", "V") << endl; 
    
    return 0; // Terminate program successfully
}

/*
CODE FLOW:
1. Execution begins in `main()`.
2. The `myMax<int>(3, 7, 2)` template function is explicitly called for the `int` type. 
3. Inside the function, the ternary operator `(x > y) ? x : y` finds the max between 3 and 7 (which is 7). Then `(max_xy > z) ? max_xy : z` compares 7 and 2, returning 7. The result is printed.
4. The `myMax<float>(3.0, 7.0, 4.0)` function is called for the `float` type. The same logic executes with floats, returning 7.0, which is printed.
5. The `myMax<char>('R', 'V', 'A')` function is called for the `char` type. It evaluates ASCII values, finding 'V' as the maximum, which is printed.
6. The `myMax<string>("R", "A", "V")` function is called for `std::string`. It evaluates alphabetical order, finding "V" as the maximum, which is printed.
7. The program terminates successfully.

SUMMARY:
This program continues the demonstration of Templates, specifically focusing on type flexibility.
- It defines a template function `myMax` that accepts three parameters of a generic type `T`.
- It uses the ternary operator `? :` to efficiently compute the maximum value among the three inputs.
- In the `main` function, `myMax` is invoked multiple times, explicitly defining the type parameter within angle brackets (`<int>`, `<float>`, `<char>`, `<string>`).
- This showcases how generic functions can safely and consistently compare different primitives and object types (like std::string) using the same underlying logic.
*/
