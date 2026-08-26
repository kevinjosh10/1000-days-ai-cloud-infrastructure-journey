public class Rectangle {
    // Instance variables
    private double length;
    private double width;

    // Constructor
    public Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }

    // Method to print the current instance of the class and return it
    public Rectangle getCurrentInstance() {
        System.out.println("Current instance: " + this);
        return this; // Returning the current instance
    }

    // Override the toString() method to provide a meaningful string representation of the object
    @Override
    public String toString() {
        return "Rectangle [length = " + length + ", width = " + width + "]";
    }

    // Method to display the rectangle's dimensions
    public void displayDimensions() {
        System.out.println("Length: " + this.length + ", Width: " + this.width);
    }

    // Added a main method so the program can be run and tested
    public static void main(String[] args) {
        Rectangle rect = new Rectangle(10.5, 5.5);
        System.out.println("Creating rectangle...");
        rect.displayDimensions();
        
        System.out.println("\nTesting getCurrentInstance()...");
        Rectangle returnedRect = rect.getCurrentInstance();
    }
}
