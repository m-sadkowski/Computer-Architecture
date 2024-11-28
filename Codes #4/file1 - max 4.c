#include <stdio.h>

int szukaj4_max(int a, int b, int c, int d);

int main()
{
	int a, b, c, d, wynik;
	printf("\nProsze podac trzy liczby calkowite ze znakiem: ");
	scanf_s("%d %d %d %d", &a, &b, &c, &d, 32);
	wynik = szukaj4_max(a, b, c, d);
	printf("\nSposrod podanych liczb %d, %d, %d, %d, \
 liczba %d jest najwieksza\n", a, b, c, d, wynik);
	return 0;
}