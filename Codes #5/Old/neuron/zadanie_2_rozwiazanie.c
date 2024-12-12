#include <stdio.h>

float* single_neuron(double* x, float* w, unsigned int n);

int main()
{
	double x[] = { 1.0, 2.0, 3.0 };
	float w[] = { 0.5, -5.0, 0.5 };
	unsigned int n = 3;

	float* wynik = single_neuron(x, w, n);

	printf("%f", *wynik);

	return 0;
}
