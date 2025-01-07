#include <stdio.h>

int* szukaj_elem_min(int tablica[], int n);

int main() {
	int pomiary[9] = {1, 2, 3, -49999, -4214, 5434, 7, 6, 5}, * wsk;
	wsk = szukaj_elem_min(pomiary, 9);
	printf("Element minimalny = %d", *wsk);
	return 0;
}