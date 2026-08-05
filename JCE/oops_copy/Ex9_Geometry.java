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
