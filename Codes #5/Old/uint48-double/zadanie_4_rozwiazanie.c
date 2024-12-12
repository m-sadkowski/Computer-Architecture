#include <stdio.h>

typedef long long int UINT48;

float uint48_float(UINT48 p);

int main()
{
	UINT48 p = 0x30000;
	float wynik = uint48_float(p);
	printf("%f", wynik);
	return 0;
};
