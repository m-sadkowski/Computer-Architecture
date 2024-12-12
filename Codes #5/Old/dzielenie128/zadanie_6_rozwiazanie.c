#include <stdio.h>
#include <xmmintrin.h>

void dziel(__m128* tablica1, unsigned int n, float dzielnik);

int main()
{
	__m128 tablica[2];
	tablica[0].m128_f32[0] = 5.0;
	tablica[0].m128_f32[1] = 10.0;
	tablica[0].m128_f32[2] = 15.0;
	tablica[0].m128_f32[3] = 20.0;
	
	tablica[1].m128_f32[0] = 50.0;
	tablica[1].m128_f32[1] = 100.0;
	tablica[1].m128_f32[2] = 150.0;
	tablica[1].m128_f32[3] = 200.0;
	unsigned int n = 2;
	float dzielnik = 5.0;
	
	dziel(&tablica, n, dzielnik);

	for (int i = 0; i < n; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			printf("%f\n", tablica[i].m128_f32[j]);
		}
	}

	return 0;
}