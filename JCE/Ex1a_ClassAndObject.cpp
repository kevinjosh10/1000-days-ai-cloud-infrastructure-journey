#include<iostream>
#include<string>
using namespace std;
class Student
{
private:
    int age;
    string Name; // Changed String to string
    int Rollno;
public:
    Student(string n,int a, int r)
    {
        Name=n;
        age=a;
        Rollno=r;
    }
    void displayDetails()
    {
        cout<<"NAME:"<<Name<<endl;
        cout<<"AGE:"<<age<<endl;
        cout<<"ROLLNO:"<<Rollno<<endl;
    }
};
int main(){
    Student s("JOHN",18,20);
    s.displayDetails();
    cout<<endl;
    return 0;
}
