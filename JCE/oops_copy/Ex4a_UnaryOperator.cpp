#include<iostream>
using namespace std;
class Overload
{
private:
    int a;
    int b;
    int c;
    int d;
public:
    Overload(int f,int i)
    {
        a = f;
        b = i;
    }
    void display()
    {
        cout <<"A:"<<a<<" B:"<<b<<endl;
    }
    Overload operator +()
    {
        a = +a;
        b = +b;
        c = a + b;
        cout << "\nC: " <<c;
        return Overload(a,b); 
    }
    Overload operator -()
    {
        a = -a; 
        b = -b;
        d = a - b;
        cout<<"\nD:"<<d;
        return Overload(a,b);
    }
};

int main()
{
    Overload M1(5, 4) , M2(-2, -8) ; 
    -M1;
    M1.display();
    +M2;
    M2.display();
    return 0;
}
