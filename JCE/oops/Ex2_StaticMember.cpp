#include<iostream>
using namespace std;
class Student
{
private:
    static int count; // Changed Static to static
    int id;
    int stdid;
    int regno;
public:
    Student(int i,int r)
    {
        stdid=i;
        regno=r;
    }
    Student(){
        count++;
        id=count;
    }
    ~Student()
    {
        count--;
    }
    static int getCount() // Changed Static to static
    {
        return count;
    }
    void display()
    {
        std::cout<<"ENTER STUDENT DETAILS:"<<endl;
        std::cout<<"STUDENT ID:"<<stdid<<endl<<"REG NUM:"<<regno<<endl;
        std::cout<<"OBJECT ID:"<<id<<std::endl;
    }
};
int Student::count=0; // Changed student to Student

int main(){
    Student obj1;
    Student obj2;
    Student obj3;
    std::cout<<"NUMBER OF OBJECTS CREATED:"<<Student::getCount()<<std::endl;
    obj1.display();
    obj2.display();
    obj3.display();
    return 0;
}
