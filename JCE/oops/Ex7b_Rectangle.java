public class Rectangle {
    private double length;
    private double width;
    
    public Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }
    
    public Rectangle getCurrentInstance() {
        System.out.println("Current instance: " + this);
        return this; 
    }
    
    @Override
    public String toString() {
        return "Rectangle [length = " + length + ", width = " + width + "]";
    }
    
    public void displayDimensions() {
        System.out.println("Length: " + this.length + ", Width: " + this.width);
    }
    
    public static void main(String[] args) {
        Rectangle r = new Rectangle(10.5, 5.5);
        r.getCurrentInstance();
        r.displayDimensions();
    }
}
