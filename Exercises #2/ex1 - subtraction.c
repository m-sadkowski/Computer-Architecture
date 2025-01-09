#include <stdio.h>

int roznica(int* odjemna, int** odjemnik);

int main()
{
	int a, b, *wsk, wynik;
	wsk = &b;
	a = 21; b = 25;
	wynik = roznica(&a, &wsk);
	printf("%d", wynik);
}
