/* Poszukiwanie najwiêkszego elementu w tablicy liczb
 ca³kowitych za pomoca funkcji (podprogramu)
 szukaj64_max, ktora zostala zakodowana w asemblerze.
 Wersja 64-bitowa
*/
#include <stdio.h>

extern __int64 szukaj64_max(__int64* tablica, __int64 n);
extern __int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64 v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);


int main()
{
	__int64 wyniki[12] = { -15, 4000000, -345679, 88046592, -1, 2297645, 7867023, -19000444, 31, 456000000000000, 444444444444444, -123456789098765 };
	__int64 wartosc_max;
	wartosc_max = szukaj64_max(wyniki, 12); 
	printf("\nNajwiekszy element tablicy wynosi: %I64d\n", wartosc_max);
	__int64 suma = suma_siedmiu_liczb(92401865498, -52, 2515, 123, 0, -999999, 2115);
	printf("\nSuma siedmiu liczb wynosi: %I64d\n", suma);
	return 0;
}

