#include <iostream>
using namespace std;
class area
{
public:
    int side;
    int length;
    int breadth;
    float pi;
    int radius;
    void squareprint()
    {
        cout<<"ENTER THE SIDES OF SQUARE:"<<side<<endl;
    }
    void rectangleprint()
    {
        cout<<"ENTER THE LENGTH AND BREADTH:"<<length<<breadth<<endl;
    }
    void circleprint()
    {
        cout<<"ENTER THE RADIUS:"<<radius<<endl;
        cout<<"ENTER THE PI VALUE:"<<pi<<endl;
    }
};
int main()
{
    int choice;
    float pi=3.14,r,a; 
    a=pi*r*2; 
    
    area a_obj;
    cout<<"1.SQUARE"<<endl;
    cout<<"2.RECTANGLE"<<endl;
    cout<<"3.CIRCLE"<<endl;
    cout<<"ENTER YOUR CHOICE(1-3):"<<endl;
    cin>>choice;
    switch(choice)
    {
        case 1:
            cout<<"AREA OF SQUARE :"; 
            break;
        case 2:
            cout<<"AREA OF RECTANGLE :";
            break;
        case 3:
            cout<<"AREA OF CIRCLE:";
            break;
        default:
            cout<<"INVALID CHOICE"<<endl;
            return 0;
    }
    return 0;
}
