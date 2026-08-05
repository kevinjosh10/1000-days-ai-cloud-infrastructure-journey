#include <iostream> // Include the standard input/output stream library
#include <string> // Include the string library
using namespace std; // Use the standard namespace

// Template function to swap numbers of any generic type T
template <class T>
int swap_numbers(T &x, T &y)
{
    T t; // Create a temporary variable of type T
    t = x; // Store the value of 'x' in 't'
    x = y; // Assign the value of 'y' to 'x'
    y = t; // Assign the stored value 't' to 'y'
    return 0; // Return 0 (success)
}

// Template function specifically for swapping characters (named swap_char in this version)
template <class T>
void swap_char(T &a, T &b)
{
    T temp; // Create a temporary variable of type T
    temp = a; // Store 'a' in 'temp'
    a = b; // Assign 'b' to 'a'
    b = temp; // Assign 'temp' to 'b'
}

int main() // Main function
{
    // Test swapping integers
    int a = 10, b = 20; // Declare two integers
    swap_numbers(a, b); // Call the template function for integers
    cout << a << " " << b << endl; // Print the swapped integers
    
    // Test swapping doubles
    double c = 10.5, d = 20.5; // Declare two doubles
    swap_numbers(c, d); // Call the template function for doubles
    cout << c << " " << d << endl; // Print the swapped doubles
    
    // Test swapping strings
    string e = "APPLE", f = "BALL"; // Declare two strings
    swap_numbers(e, f); // Call the template function for strings
    cout << e << " " << f << endl; // Print the swapped strings
    
    // Test swapping characters interactively
    char ch1, ch2; // Declare two characters
    cout << "Enter first character= "; // Prompt for first character
    cin >> ch1; // Read first character
    cout << "Enter second character= "; // Prompt for second character
    cin >> ch2; // Read second character
    
    swap_char(ch1, ch2); // Call the template function for characters
    
    // Print the results after swapping
    cout << "After swapping character: ";
    cout << "\n Now first character: " << ch1;
    cout << "\n Now second character: " << ch2;
    
    return 0; // Terminate program successfully
}

/*
CODE FLOW:
1. Execution begins in `main()`. Two integers (`a=10`, `b=20`) are declared.
2. The `swap_numbers(a, b)` function is called. The compiler deduces `T` as `int` and generates an integer version of the template function, which swaps the values.
3. The swapped integer values are printed.
4. Two doubles (`c=10.5`, `d=20.5`) are declared. `swap_numbers(c, d)` is called. The compiler deduces `T` as `double` and swaps them.
5. The swapped double values are printed.
6. Two strings (`e="APPLE"`, `f="BALL"`) are declared. `swap_numbers(e, f)` is called. The compiler deduces `T` as `std::string` and swaps them.
7. The swapped string values are printed.
8. The program then asks the user to input two characters.
9. `swap_char(ch1, ch2)` is called. The compiler deduces `T` as `char` and swaps them.
10. The swapped characters are printed, and the program ends.

SUMMARY:
This program demonstrates the use of Function Templates in C++.
- Templates are the foundation of generic programming, allowing functions to operate with generic types.
- The `swap_numbers` function is defined with a template parameter `<class T>`, meaning `T` can be substituted with `int`, `double`, or `string` at compile time.
- This allows a single function definition to handle the swapping logic for multiple data types, heavily reducing code duplication.
- The program also provides a second template `swap_char` to explicitly demonstrate generic swapping using user input.
*/
