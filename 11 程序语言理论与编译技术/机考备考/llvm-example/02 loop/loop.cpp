#include <iostream>

int main() 
{
	int sum1 = 1;
	for (int i = 2; i < 10; i++)
	{
		sum1 += i;
	}
	
	int sum2 = 3, i = 4;
	while(i < 10)
	{
		sum2 += i;
		i++;
	}

	if(sum1 + sum2 < 100) 
		std::cout << "less" << std::endl;
	else 
		std::cout << "high" << std::endl;
	
	return sum1;
}
