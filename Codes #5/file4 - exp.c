#include <stdio.h>

float nowy_exp(float x);

int main()
{
	float x;
	printf("Podaj x: ");
	scanf_s("%f", &x);
	printf("Wynik: %f", nowy_exp(x));
	return 0;
}