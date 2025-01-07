#include <stdio.h>

int* kopia_tablicy(int tabl[], unsigned int n);

int main()
{
	int tabl[5] = { 1, 4, 5, 8, 1 };
	unsigned int n = 5;
	int* kopia;
	kopia = kopia_tablicy(tabl, n);
	for (int i = 0; i < n; i++) {
		printf("%d ", kopia[i]);
	}
}
