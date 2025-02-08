#include <stdio.h>

float srednia_harm(float* tablica, unsigned int n);

int main()
{
	int n;
	printf("Podaj ilosc elementow tablicy: ");
	scanf_s("%d", &n);
	float* tablica = malloc(n * sizeof(float));
	for (int i = 0; i < n; i++)
	{
		printf("Podaj %d element tablicy: ", i + 1);
		scanf_s("%f", &tablica[i]);
	}
	printf("Srednia harmoniczna wynosi: %f", srednia_harm(tablica, n));
	free(tablica);

	return 0;
}
