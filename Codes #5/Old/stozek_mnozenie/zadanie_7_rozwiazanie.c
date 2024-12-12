#include <stdio.h>
#include <xmmintrin.h>
float objetosc_stozka(unsigned int big_r, unsigned int small_r, float h);
__m128 mul_at_once(__m128  one, __m128 two);
int main() {
	float res = objetosc_stozka(7, 3, 4.2);
	printf("Objetosc stozka jest rowna %f\n", res);

	__m128 one;
	__m128 two;
	one.m128_i32[0] = 12;
	one.m128_i32[1] = 7;
	one.m128_i32[2] = 3;
	one.m128_i32[3] = 4;
	two.m128_i32[0] = 5;
	two.m128_i32[1] = 6;
	two.m128_i32[2] = 7;
	two.m128_i32[3] = 8;
	__m128 resultat = mul_at_once(one, two);
	for (int i = 0; i < 4; i++) {
		printf("%d ", resultat.m128_i32[i]);
	}
	return 0;
}