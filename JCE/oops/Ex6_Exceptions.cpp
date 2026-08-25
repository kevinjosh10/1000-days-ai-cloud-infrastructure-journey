#include <iostream>
#include <stdexcept>
using namespace std;

float Division (float num, float den)
{
    if (den==0)
    {
        throw runtime_error("MATH ERROR: ATTEMPTED TO DIVIDE BY ZERO");
    }
    return (num/den);
}

int main()
{
    float numerator=12.5, denominator = 0, result; 
    try
    {
        result = Division(numerator, denominator); 
        cout << "THE QUOTIENT IS: " << result << endl;
    }
    catch (runtime_error &e)
    {
        cout << "EXCEPTION OCCURED" << endl << e.what() << endl;
    }
    
    const int Maxsize=5;
    int array[Maxsize] = {1,2,3,4,5};
    int index = 0;
    try 
    { 
        while (true) 
        { 
            if (index < Maxsize)
            {
                std::cout << "Array value at Index: " << index << " is " << array[index] << std::endl;
                index++;
            }
            else
            {
                throw std::out_of_range("Array index out of Exception!");
            } 
        }
    }
    catch (const std::out_of_range &e)
    {
        std::cerr << e.what() << std::endl;
    }
    return 0;
}
