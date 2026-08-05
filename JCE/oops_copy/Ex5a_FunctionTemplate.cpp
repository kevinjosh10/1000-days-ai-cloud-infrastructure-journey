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
