#include <stdio.h>

unsigned char czy_pierwsza(unsigned int a);

int main()
{
	unsigned int a;
	a = 1;
	printf("\n%c", czy_pierwsza(a));
	a = 8;
	printf("\n%c", czy_pierwsza(a));
	a = 256;
	printf("\n%c", czy_pierwsza(a));
	a = 47;
	printf("\n%c", czy_pierwsza(a));
	return 0;
}
