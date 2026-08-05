#include <iostream>
using namespace std;

class Area
{
public:
    int side;
    int length;
    int breadth;
    float pi;
    int radius;

    Area()
    {
        pi = 3.14;
    }

    int print(int side)
    {
        return side * side;
    }

    int print(int length, int breadth)
    {
        return length * breadth;
    }

    float print(int radius, float pi)
    {
        return pi * radius * radius;
    }
};

int main()
{
    int choice;
    Area a;
    cout << "1. Square" << endl;
    cout << "2. Rectangle" << endl;
    cout << "3. Circle" << endl;
    cout << "Enter Your choice (1-3): ";
    cin >> choice;

    switch (choice)
    {
        case 1:
            cout << "Enter the side of Square: ";
            cin >> a.side;
            cout << "Area of Square: " << a.print(a.side) << endl;
            break;
        case 2:
            cout << "Enter the length and Breadth: ";
            cin >> a.length >> a.breadth;
            cout << "Area of Rectangle: " << a.print(a.length, a.breadth) << endl;
            break;
        case 3:
            cout << "Enter the Radius: ";
            cin >> a.radius;
            cout << "Area of Circle: " << a.print(a.radius, a.pi) << endl;
            break;
        default:
            cout << "Invalid choice" << endl;
    }
    
    return 0;
}
