#include <stdio.h>

void multiplyfloats(float a, float b, float * wynik);

int main() {
	float a = 1.0f;
	float b = 3.0f;
	float wynik = 0.0f;
	multiplyfloats(a, b, &wynik);
	printf("%f", wynik);
	return 0;
}