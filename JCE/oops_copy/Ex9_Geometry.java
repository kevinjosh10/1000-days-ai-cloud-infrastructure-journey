package Mainpack; // Define the package name where this file belongs

// Define a default-access class named Rectangle
class Rectangle {
    int width = 10; // Default width
    int length = 20; // Default length
    
    // Method to calculate and return the area of the rectangle
    public int area(){
        return width * length; // Area formula for rectangle
    }
}

// Define a default-access class named Square
class Square {
    int side = 5; // Default side length
    
    // Method to calculate and return the area of the square
    public int area(){
        return side * side; // Area formula for square
    }
}

// Define the public main class
public class Mainclass {
    // The main method where execution begins
    public static void main(String[] args){
        // Create an instance of the Rectangle class
        Rectangle rec = new Rectangle();
        // Call the area method on the Rectangle object and print the result
        System.out.println("Rectangle Area:" + rec.area());
        
        // Create an instance of the Square class
        Square sq = new Square();
        // Call the area method on the Square object and print the result
        System.out.println("SQUARE AREA:" + sq.area());
    } 
}

/*
CODE FLOW:
1. Execution starts in the `main` method of the `Mainclass` public class.
2. A `Rectangle` object `rec` is instantiated. The default member variables (`width = 10`, `length = 20`) are allocated in memory.
3. The `rec.area()` method is called within a `System.out.println` statement.
4. Execution transfers to `Rectangle.area()`, which calculates `10 * 20 = 200` and returns it to `main`, where it is printed.
5. Next, a `Square` object `sq` is instantiated. Its default member variable (`side = 5`) is allocated in memory.
6. The `sq.area()` method is called within another `System.out.println` statement.
7. Execution transfers to `Square.area()`, which calculates `5 * 5 = 25` and returns it to `main`, where it is printed.
8. The `main` method completes and the program terminates.

SUMMARY:
This Java program demonstrates the concept of Packages and multiple classes within a single file.
- It declares a package named `Mainpack`, which is a mechanism to encapsulate a group of classes, sub-packages, and interfaces.
- It defines three distinct classes: `Rectangle`, `Square`, and `Mainclass`. 
- Only `Mainclass` is declared as `public` (as per Java rules, a file can only have one public class and the filename must match it).
- The program instantiates objects for `Rectangle` and `Square` and calls their respective methods to calculate and print the area, demonstrating simple object interaction.
*/
