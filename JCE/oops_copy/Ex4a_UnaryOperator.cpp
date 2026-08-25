#include<iostream> // Include the standard input/output stream library
using namespace std; // Use the standard namespace

class Overload // Define a class named 'Overload'
{
private: // Private access specifier
    int a; // Integer variable a
    int b; // Integer variable b
    int c; // Integer variable c
    int d; // Integer variable d
public: // Public access specifier
    // Parameterized constructor to initialize 'a' and 'b'
    Overload(int f, int i)
    {
        a = f; // Assign parameter 'f' to 'a'
        b = i; // Assign parameter 'i' to 'b'
    }
    
    // Method to display the values of 'a' and 'b'
    void display()
    {
        cout << "A:" << a << " B:" << b << endl; // Print values
    }
    
    // Overload the unary '+' operator
    Overload operator +()
    {
        a = +a; // Apply unary plus to 'a' (doesn't really change the value)
        b = +b; // Apply unary plus to 'b'
        c = a + b; // Calculate the sum and store in 'c'
        cout << "\nC: " << c; // Print the sum 'c'
        return Overload(a, b); // Return a new Overload object with the updated values
    }
    
    // Overload the unary '-' operator
    Overload operator -()
    {
        a = -a; // Apply unary minus to 'a' (negate it)
        b = -b; // Apply unary minus to 'b' (negate it)
        d = a - b; // Calculate the difference and store in 'd'
        cout << "\nD:" << d; // Print the difference 'd'
        return Overload(a, b); // Return a new Overload object with the updated values
    }
};

int main() // Main function
{
    // Create two Overload objects with initial values
    Overload M1(5, 4), M2(-2, -8); 
    
    -M1; // Apply overloaded unary minus operator on M1
    M1.display(); // Display the updated values of M1
    
    +M2; // Apply overloaded unary plus operator on M2
    M2.display(); // Display the updated values of M2
    
    return 0; // Terminate program successfully
}

/*
CODE FLOW:
1. Execution starts in `main()`. Two `Overload` objects, `M1` and `M2`, are created using the parameterized constructor.
2. `M1` is initialized with `a=5`, `b=4`. `M2` is initialized with `a=-2`, `b=-8`.
3. The statement `-M1;` invokes the overloaded unary minus `operator -()` method on the `M1` object.
4. Inside the `operator -()` method, the member variables `a` and `b` of `M1` are negated. A difference `d` is calculated and printed.
5. `M1.display()` is called to show the newly negated values of `M1`.
6. The statement `+M2;` invokes the overloaded unary plus `operator +()` method on the `M2` object.
7. Inside the `operator +()` method, the values of `a` and `b` of `M2` remain unchanged. A sum `c` is calculated and printed.
8. `M2.display()` is called to show the values of `M2`.

SUMMARY:
This program demonstrates Unary Operator Overloading in C++.
- Operator overloading allows developers to redefine the way operators work for user-defined data types (classes).
- The unary `+` and `-` operators (which typically operate on a single operand) are overloaded inside the `Overload` class.
- When `-M1` is called, the overloaded `operator -()` function is executed, negating the internal state of the object.
- When `+M2` is called, the overloaded `operator +()` function is executed.
- The code proves that standard operators can be customized to perform specific operations on class members seamlessly.
*/
