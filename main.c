#include <stdio.h>

unsigned long long kwadrat(unsigned long long a);

int main()
{
	unsigned long long zmienna = 1, wynik;

	wynik = kwadrat(zmienna);

	printf("Wejscie: %llu\nWyjscie: %llu", zmienna, wynik);

	return 0;
}
