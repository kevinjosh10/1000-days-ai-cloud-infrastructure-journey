package Mainpack;

class Rectangle {
    int width=10;
    int length=20;
    public int area(){
        return width*length;
    }
}

class Square {
    int side=5;
    public int area(){
        return side*side;
    }
}

public class Mainclass {
    public static void main(String[] args){
        Rectangle rec=new Rectangle();
        System.out.println("Rectangle Area:"+rec.area());
        Square sq=new Square();
        System.out.println("SQUARE AREA:"+sq.area());
    } 
}
