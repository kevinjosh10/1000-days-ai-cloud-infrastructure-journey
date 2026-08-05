#include<iostream>
#include <string>
using namespace std;

template <class T>
int swap_numbers (T &x, T &y)
{
    T t;
    t=x;
    x=y;
    y=t;
    return 0;
}

template <class T>
void swap_char (T &a, T &b)
{
    T temp;
    temp=a;
    a=b; 
    b=temp;
}

int main()
{
    int a=10, b=20;
    swap_numbers(a,b);
    cout << a <<" "<<b<<endl;
    
    double c=10.5, d=20.5;
    swap_numbers(c,d);
    cout << c <<" "<<d<<endl;
    
    string e="APPLE", f="BALL";
    swap_numbers(e,f);
    cout << e <<" "<<f<<endl;
    
    char ch1, ch2;
    cout << "Enter first character= "; 
    cin >> ch1;
    cout <<"Enter second character= "; 
    cin >> ch2;
    swap_char(ch1,ch2);
    cout << "After swapping character: ";
    cout << "\n Now first character: "<<ch1;
    cout << "\n Now second character: "<<ch2;
    
    return 0;
}
