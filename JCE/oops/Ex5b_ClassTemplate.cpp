#include <iostream>
#include <string>
using namespace std; 
template <typename T>
T myMax (T x, T y, T z) 
{
    T max_xy = (x>y)? x:y;
    return (max_xy>z)? max_xy:z; 
}
int main()
{
    cout << myMax<int>(3, 7, 2)<<endl;
    cout << myMax<float>(3.0, 7.0, 4.0)<<endl;
    cout << myMax<char>('R', 'V', 'A')<<endl;
    cout << myMax<string>("R", "A", "V")<<endl; 
    return 0;
}
