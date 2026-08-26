public class Rectangle { // Declares a public class named Rectangle
    // Instance variables (fields) specific to each object created from this class
    private double length; // Private variable to store the length of the rectangle
    private double width; // Private variable to store the width of the rectangle

    // Constructor: a special method called when a new object is created
    public Rectangle(double length, double width) {
        // The 'this' keyword is used to distinguish the class's instance variables 
        // from the parameters being passed into the constructor which have the exact same names.
        this.length = length; // Assigns the passed parameter 'length' to the instance variable 'this.length'
        this.width = width; // Assigns the passed parameter 'width' to the instance variable 'this.width'
    }

    // Method to print the current instance of the class and return it
    public Rectangle getCurrentInstance() {
        // When 'this' is printed, Java automatically calls the object's toString() method
        System.out.println("Current instance: " + this); 
        return this; // Returns the exact memory reference of the current object that called this method
    }

    // Override the built-in toString() method inherited from the base Object class
    // This provides a meaningful string representation of the object instead of a memory hash
    @Override
    public String toString() {
        // Returns a nicely formatted string showing the object's current state
        return "Rectangle [length = " + length + ", width = " + width + "]";
    }

    // Method to display the rectangle's dimensions directly
    public void displayDimensions() {
        // 'this.' is optional here since there are no naming conflicts, but it explicitly shows we are accessing instance variables
        System.out.println("Length: " + this.length + ", Width: " + this.width);
    }

    // Main method added so the program can actually be executed and tested
    public static void main(String[] args) {
        // Creates a new Rectangle object in memory with length 10.5 and width 5.5
        Rectangle rect = new Rectangle(10.5, 5.5); 
        System.out.println("Creating rectangle...");
        
        // Calls the method to print out its dimensions
        rect.displayDimensions();
        
        System.out.println("\nTesting getCurrentInstance()...");
        
        // Calls the method that returns 'this'. The returned object reference is stored in 'returnedRect'.
        // Both 'rect' and 'returnedRect' now point to the exact same object in memory!
        Rectangle returnedRect = rect.getCurrentInstance();
    }
}

/* 
CODE FLOW:
1. The program defines a `Rectangle` class with private `length` and `width` fields.
2. A constructor is defined that takes `length` and `width` parameters. To resolve the naming collision between the parameters and the instance variables, the `this` keyword is used (`this.length = length`).
3. A method `getCurrentInstance()` is defined. It prints `this` to the console and then returns `this`.
4. The `toString()` method is overridden. Without this, printing an object (like `System.out.println(this)`) would output an ugly memory hash like `Rectangle@15db9742`. Overriding it ensures it prints a clean `Rectangle [length = 10.5, width = 5.5]` string.
5. In the `main` method, a `Rectangle` object is instantiated and assigned to the variable `rect`.
6. `rect.displayDimensions()` is called to prove the object was created properly.
7. `rect.getCurrentInstance()` is called. Internally, it prints `this` (which triggers `toString()`), and then returns its own memory reference back to the `main` method.
*/

/* 
SUMMARY:
This program is a textbook demonstration of the `this` keyword in Java. 
The `this` keyword acts as a reference to the current object—the object whose method or constructor is being called. It serves two primary purposes in this code:
First, it resolves naming ambiguity in the constructor, allowing parameters and instance variables to share the same logical names.
Second, it allows an object to return a reference to itself, which is a foundational concept used in "Method Chaining" (e.g., `rect.setLength(5).setWidth(10)`). The overridden `toString()` method is also a best practice that makes debugging and logging objects much easier.
*/
