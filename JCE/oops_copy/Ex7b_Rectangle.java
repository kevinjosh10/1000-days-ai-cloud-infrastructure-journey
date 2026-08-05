public class Rectangle { // Define a public class named Rectangle
    // Private instance variables to store the dimensions of the rectangle
    private double length; 
    private double width;
    
    // Parameterized constructor to initialize the instance variables
    public Rectangle(double length, double width) {
        this.length = length; // 'this.length' refers to the instance variable, 'length' is the parameter
        this.width = width; // 'this.width' refers to the instance variable, 'width' is the parameter
    }
    
    // Method to print the current instance of the class and return it
    public Rectangle getCurrentInstance() {
        // Print the current object reference (implicitly calls toString())
        System.out.println("Current instance: " + this); 
        return this; // Return the current instance using the 'this' keyword
    }
    
    // Override the default toString() method from the Object class
    @Override
    public String toString() {
        // Return a custom, meaningful string representation of the Rectangle object
        return "Rectangle [length = " + length + ", width = " + width + "]";
    }
    
    // Method to display the rectangle's dimensions
    public void displayDimensions() {
        // Print the length and width using the 'this' keyword to explicitly refer to instance variables
        System.out.println("Length: " + this.length + ", Width: " + this.width);
    }
    
    public static void main(String[] args) { // Main method, entry point of the program
        // Create a new Rectangle object 'r' with length 10.5 and width 5.5
        Rectangle r = new Rectangle(10.5, 5.5);
        
        // Call getCurrentInstance() which prints the object and returns itself
        r.getCurrentInstance();
        
        // Call displayDimensions() to print the individual dimensions
        r.displayDimensions();
    }
}

/*
SUMMARY:
This Java program demonstrates the usage of the `this` keyword and method overriding.
- The `this` keyword is a reference to the current object. It is used in the constructor to distinguish between class instance variables and parameters with the same names (`this.length = length`).
- The `getCurrentInstance()` method returns `this`, effectively returning a reference to the object that called the method.
- It overrides the standard `toString()` method inherited from the base `Object` class. By doing so, when the object is printed, it outputs a readable string of its dimensions rather than a memory address hash.
*/
