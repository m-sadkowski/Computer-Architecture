#include <stdio.h>

void pole_kola(float* pr);

int main() {
	float k;
	printf("\nProsze podac promien: ");
	scanf_s("%f", &k);
	pole_kola(&k);
	printf("\nPole kola wynosi %f\n", k);
	return 0;
}