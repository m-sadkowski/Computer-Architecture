#include <stdio.h>

int __stdcall suma_liczb(int a, int b, int c);

int main()
{
	int a = 5;
	int b = 10;
	int c = 15;
	int wynik = suma_liczb(a, b, c);
	printf("Wynik: %d\n", wynik);
	return 0;
}
