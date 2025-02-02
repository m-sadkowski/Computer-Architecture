#include <stdio.h>

extern long long __stdcall suma(long long[], unsigned int n);

int main()
{
	long long tablica[] = {1111111111111111110, 1111111111111111110, 4, 5};
	printf("Suma = %lld", suma(tablica, 4));
	return 0;
}
