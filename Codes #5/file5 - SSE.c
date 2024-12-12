#include <stdio.h>
void dodaj_SSE(float*, float*, float*);
void pierwiastek_SSE(float*, float*);
void odwrotnosc_SSE(float*, float*);
void dodaj_SSE_16(float*, float*, float*);
void int2float(int* calkowite, float* zmienno_przec);
void pm_jeden(float* tabl);

int main() {
	float tablica[4] = { 27.5,143.57,2100.0, -3.51 };
	printf("\n%f %f %f %f\n", tablica[0], tablica[1], tablica[2], tablica[3]);
	pm_jeden(tablica);
	printf("\n%f %f %f %f\n", tablica[0], tablica[1], tablica[2], tablica[3]);

	int a[2] = { -17, 24 };
	float b[4];
	// podany rozkaz zapisuje w pamiêci od razu 128 bitów, wiêc musz¹ byæ 4 elementy w tablicy
	int2float(a, b);
	printf("\nKonwersja 2 intow na 2 floaty = %f %f\n", b[0], b[1]);

	float p[4] = { 1.0, 1.5, 2.0, 2.5 };
	float q[4] = { 0.25, -0.5, 1.0, -1.75 };
	float r[4];

	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3, -3, -3, -3, -3, -3, -3, -3, 3, 3, 3, 3, 3, 3, 3, 3 };
	dodaj_SSE_16(liczby_A, liczby_B, r);
	printf("\nObliczanie sumy 16 liczb 8-bitowych");
	printf("\nA: ");
	for (int i = 0; i < 16; i++) {
		printf("%d ", liczby_A[i]);
	}
	printf("\nB: ");
	for (int i = 0; i < 16; i++) {
		printf("%d ", liczby_B[i]);
	}
	printf("\nR: ");
	for (int i = 0; i < 16; i++) {
		printf("%d ", r[i]);
	}

	dodaj_SSE(p, q, r);
	printf("\n\nObliczanie sumy");
	printf("\np: %f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\nq: %f %f %f %f", q[0], q[1], q[2], q[3]);
	printf("\nr: %f %f %f %f", r[0], r[1], r[2], r[3]);

	printf("\n\nObliczanie pierwiastka");
	pierwiastek_SSE(p, r);
	printf("\np: %f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\nr: %f %f %f %f", r[0], r[1], r[2], r[3]);

	printf("\n\nObliczanie odwrotnosci - ze wzgledu na stosowanie 12-bitowej mantysy obliczenia sa malo dokladne");
	odwrotnosc_SSE(p, r);
	printf("\np: %f %f %f %f", p[0], p[1], p[2], p[3]);
	printf("\nr: %f %f %f %f", r[0], r[1], r[2], r[3]);
	return 0;
}
