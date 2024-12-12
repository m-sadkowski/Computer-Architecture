#include <stdio.h>

float* Matmul(double* A, int* B, unsigned int k, unsigned int l, unsigned int m);

int main()
{
	double A[] = {	8.0, 5.0, 6.0, 7.0,
					3.0, 1.0, 4.0, 8.0,
					9.0, 0.0, 5.0, 3.0 };

	int B[] = {		0, 5, 6, 7, 8,
					1, 9, 2, 4, 7,
					1, 8, 3, 6, 6,
					4, 6, 3, 5, 2 };

	unsigned int k = 3, l = 4, m = 5;

	float* wynik = Matmul(A, B, k, l, m);
	
	for (int i = 0; i < k * m; i++)
	{
		printf("%f\t", wynik[i]);
		if ((i+1)%m == 0) printf("\n");
	}

	return 0;
}
