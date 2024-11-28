#include <stdio.h>

void odejmij_jeden(int** a);

int main()
{
	int k; // zmienna k
	int* wsk; // wskaznik wsk
	wsk = &k; // wskaznik wsk wskazuje na zmienna k
	printf("\nProsze napisac liczbe: ");  
	scanf_s("%d", &k, 12); // wczytanie liczby do zmiennej k, 12 to maksymalna ilosc znakow
	odejmij_jeden(&wsk); // wywolanie funkcji odejmij_jeden z argumentem wskaznikowym wsk
	printf("\nWynik = %d\n", k); // wyswietlenie wyniku
	return 0;
}
